Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay004-omc2s7.hotmail.com ([65.54.190.82]:56289 "EHLO
	BAY004-OMC2S7.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbbH2Ruh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2015 13:50:37 -0400
Message-ID: <BAY175-W16B6BC09233985008743E1A66D0@phx.gbl> (sfid-20150829_195040_932742_12C23262)
From: Michael Coates <michlinux@hotmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: rt2800usb add usb ID 1b75:3070 for Airlive WT-2000USB
Date: Sun, 30 Aug 2015 05:42:38 +1200
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please add the following device USB ID to the rt2800usb source.

Brand: Airlive (Ovislink Corp.)
Name: Turbo-G USB Adaptor
Model: WT-2000USB
USB ID: 1b75:3070

After reading specs on this device, I figured the rt2800usb driver would work for this wireless adaptor.
I first tested by using the new_id function as follows:
echo "1b75 3070"> /sys/bus/usb/drivers/rt2800usb/new_id

I then added the following line to rt2800usb.c line with the other Ovislink devices.
        { USB_DEVICE(0x1b75, 0x3070) },
I complied the modified rt2800usb driver, both methods were successful. I have been using the adapter for a week and seams to be working perfectly. I believe that all that needs to be done to support this device is to add it's USB ID. Below is my dmesg output from when I plugged the device in and also when i connected the device to a Wireless network.


[362529.196944] usb 1-1.4: new high-speed USB device number 10 using dwc_otg
[362529.364504] usb 1-1.4: New USB device found, idVendor=1b75, idProduct=3070
[362529.413100] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[362529.461461] usb 1-1.4: Product: 802.11 n WLAN
[362529.506599] usb 1-1.4: Manufacturer: Ralink
[362529.550372] usb 1-1.4: SerialNumber: 1.0
[362529.676928] usb 1-1.4: reset high-speed USB device number 10 using dwc_otg
[362529.837456] ieee80211 phy1: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 detected
[362529.893771] ieee80211 phy1: rt2x00_set_rf: Info - RF chipset 0005 detected
[362529.926673] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
[362531.322079] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[362531.364536] ieee80211 phy1: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
[362531.457883] ieee80211 phy1: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.29[362531.877956] IPv6:
[362532.039655] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
-
[363081.295356] wlan0: authenticate with XX:XX:XX:f4:31:57
[363081.438322] wlan0: send auth to XX:XX:XX:f4:31:57 (try 1/3)
[363081.478769] wlan0: authenticated
[363081.521074] wlan0: associate with XX:XX:XX:f4:31:57 (try 1/3)
[363081.564347] wlan0: RX AssocResp from XX:XX:XX:f4:31:57 (capab=0x411 status=0 aid=4)
[363081.611086] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[363081.649247] wlan0: associated



 		 	   		  