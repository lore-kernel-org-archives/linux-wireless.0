Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:39023 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYLORti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 12:49:38 -0500
Received: by nf-out-0910.google.com with SMTP id d3so471181nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 09:49:37 -0800 (PST)
Message-ID: <494698AF.4020204@gmail.com> (sfid-20081215_184942_537482_72B4CD02)
Date: Mon, 15 Dec 2008 18:49:35 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Christian Lamparter <chunkeey@web.de>
Subject: wireless-testing, p54 and sinus 154 data no longer works
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a sinus 154 data usb adapter, which used to work w/ p54 in 2.6.27:

> Dec 13 13:21:30 kernel: usb 1-7: new high speed USB device using ehci_hcd and address 22
> Dec 13 13:21:31 kernel: usb 1-7: configuration #1 chosen from 1 choice
> Dec 13 13:21:31 kernel: firmware: requesting isl3890usb
> Dec 13 13:21:31 kernel: p54: LM86 firmware
> Dec 13 13:21:31 kernel: p54: FW rev 2.5.6.0 - Softmac protocol 3.0
> Dec 13 13:21:33 kernel: p54: unknown eeprom code : 0x1
> Dec 13 13:21:33 kernel: p54: unknown eeprom code : 0x3
> Dec 13 13:21:33 kernel: p54: unknown eeprom code : 0x1905
> Dec 13 13:21:33 kernel: p54: unknown eeprom code : 0x1007
> Dec 13 13:21:33 kernel: p54: unknown eeprom code : 0x1008
> Dec 13 13:21:33 kernel: p54: unknown eeprom code : 0x1100
> Dec 13 13:21:33 kernel: phy9: Selected rate control algorithm 'pid'
> Dec 13 13:21:33 kernel: phy9: hwaddr 00:30:f1:12:34:56, isl3886
> Dec 13 13:21:33 kernel: udev: renamed network interface wlan0 to wlan1
> Dec 13 13:21:33 kernel: usb 1-7: New USB device found, idVendor=0846, idProduct=4200
> Dec 13 13:21:33 kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0

but does not work w/ current wireless-testing.git/pending:

> Dec 15 17:43:17 kernel: usb 1-7: new high speed USB device using ehci_hcd and address 29
> Dec 15 17:43:17 kernel: usb 1-7: configuration #1 chosen from 1 choice
> Dec 15 17:43:17 kernel: usb 1-7: firmware: requesting isl3886usb
> Dec 15 17:43:17 kernel: phy16: p54 detected a LM86 firmware
> Dec 15 17:43:17 kernel: phy16: FW rev 2.5.6.0 - Softmac protocol 3.0
> Dec 15 17:43:17 kernel: phy16: you are using an obsolete firmware. visit http://wireless.kernel.org/en/users/Drivers/p54 and grab one for "kernel >= 2.6.28"!
> Dec 15 17:43:17 kernel: phy16: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:no
> Dec 15 17:43:20 kernel: phy16: device does not respond!
> Dec 15 17:43:20 kernel: p54usb: probe of 1-7:1.0 failed with error -16
> Dec 15 17:43:20 kernel: usb 1-7: New USB device found, idVendor=0846, idProduct=4200
> Dec 15 17:43:20 kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0

Using different firmwares only changes the cryptographic-accelerator line (CCMP:yes) [1],
but i still get the "device does not respond!" error.

artur

> Dec 15 17:06:29 kernel: usb 1-7: new high speed USB device using ehci_hcd and address 17
> Dec 15 17:06:29 kernel: usb 1-7: configuration #1 chosen from 1 choice
> Dec 15 17:06:29 kernel: usb 1-7: firmware: requesting isl3886usb
> Dec 15 17:06:30 kernel: phy4: p54 detected a LM86 firmware
> Dec 15 17:06:30 kernel: phy4: FW rev 2.13.1.0 - Softmac protocol 5.5
> Dec 15 17:06:30 kernel: phy4: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
> Dec 15 17:06:32 kernel: phy4: device does not respond!
> Dec 15 17:06:32 kernel: p54usb: probe of 1-7:1.0 failed with error -16
> Dec 15 17:06:32 kernel: usb 1-7: New USB device found, idVendor=0846, idProduct=4200
> Dec 15 17:06:32 kernel: usb 1-7: New USB device strings: Mfr=0, Product=0, SerialNumber=0

