//
//  main.swift
//  IFFReader
//
//  Created by Uli Kusterer on 04/03/16.
//  Copyright © 2016 Uli Kusterer. All rights reserved.
//

import Foundation

class IFFReader
{
	init( filePath : String ) {
		do {
			let fileData = try NSData(contentsOfFile: filePath, options: .DataReadingMappedIfSafe)
			printIFF( fileData )
		}
		catch {
			
		}
	}
	
	func printIFF( data : NSData? ) {
		var	offset = 0
		var labelData : NSData? = NSData()
		while( labelData != nil )
		{
			if data!.length <= offset {
				break
			}
			labelData = data!.subdataWithRange(NSRange(location: offset, length: 4))
			let labelStr = String(data: labelData!, encoding: NSASCIIStringEncoding)
			offset += 4
			if data!.length <= offset {
				break
			}
			var length : CInt = 0
			data!.getBytes( &length, range: NSRange(location: offset, length: 4))
			offset += 4;
			length = length.bigEndian
			
			print("label \(labelStr!)")
			
			if labelStr == "FORM" {
				let formTypeData = data!.subdataWithRange(NSRange(location: offset, length: 4))
				let formTypeStr = String(data: formTypeData, encoding: NSASCIIStringEncoding)
				print("Form Type: \(formTypeStr!)")
				offset += 4;
				let blockData = data!.subdataWithRange(NSRange(location: offset, length: Int(length) - 4))
				printIFF(blockData)
			}
			else if labelStr == "AUTH" || labelStr == "ANNO" || labelStr == "NAME" || labelStr == "(c) " {
				let blockData = data!.subdataWithRange(NSRange(location: offset, length: Int(length)))
				let metadataStr = String(data: blockData, encoding: NSASCIIStringEncoding)
				print("Content: \(metadataStr!)")
			}
			
			offset += Int(length)
		}
	}
}


var reader = IFFReader( filePath: "/System/Library/Sounds/Submarine.aiff" )