Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:39824 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZBLCme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 21:42:34 -0500
Received: by ewy14 with SMTP id 14so420232ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 18:42:32 -0800 (PST)
Date: Thu, 12 Feb 2009 03:38:17 +0100
From: "Christoph .J Thompson" <cjsthompson@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: Re: Sitecom WL-608 USB WiFi
Message-Id: <20090212033817.22d0a4ae.cjsthompson@gmail.com> (sfid-20090212_034238_825652_67A355F7)
In-Reply-To: <200902112332.53480.IvDoorn@gmail.com>
References: <20090211211707.d5e71ddb.cjsthompson@gmail.com>
	<200902112332.53480.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Feb 2009 23:32:53 +0100
Ivo van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
> 
> Looks like a new USB id. Since it isn't an 11n device it can only be a rt73usb or rt2500usb device.
> Could you try below patch? My current bet is that the device contains the rt73 chipset,
> so this will enable rt73usb to use the device.

I have tried to add the id of the Sitecom WL-608 to the rt73usb, rt2500usb and zd1211rw drivers but so far no luck. I turned debugging on for the aforementioned drivers and here is what I got:

phy4 -> rt73usb_validate_eeprom: EEPROM recovery - Antenna: 0x09aa
phy4 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy4 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0x0000
phy4 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
phy4 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0001, rev: d5af900a.
phy4 -> rt73usb_init_eeprom: Error - Invalid RT chipset detected.
phy4 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
usbcore: registered new interface driver rt73usb

phy5 -> rt2500usb_validate_eeprom: EEPROM recovery - Antenna: 0x0002
phy5 -> rt2500usb_validate_eeprom: EEPROM recovery - NIC: 0xfff0
phy5 -> rt2x00_set_chip: Info - Chipset detected - rt: 1201, rf: 0000, rev: 00002080.
phy5 -> rt2500usb_init_eeprom: Error - Invalid RT chipset detected.
phy5 -> rt2x00lib_probe_dev: Error - Failed to allocate device.
usbcore: registered new interface driver rt2500usb

zd1211rw usb_init()
usb 1-1.1: print_id() 0df6:003f v0101 high
usb 1-1.1: reset high speed USB device using ehci_hcd and address 6
zd1211rw 1-1.1:1.0: zd_chip_read_mac_addr_fw() 
usb 1-1.1: read over firmware interface failed: -32
zd1211rw 1-1.1:1.0: probe() couldn't initialize mac. Error number -32
usb 1-1.1: reset high speed USB device using ehci_hcd and address 6
zd1211rw: probe of 1-1.1:1.0 failed with error -32
usbcore: registered new interface driver zd1211rw
zd1211rw initialized

-- 
Christoph .J Thompson <cjsthompson@gmail.com>
