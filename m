Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ip84.de ([212.122.42.5]:35753 "EHLO bart.ip84.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759033Ab0ECObh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 10:31:37 -0400
From: "rain_maker@root-forum.org" <rain_maker@root-forum.org>
Subject: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
Date: Mon, 3 May 2010 16:24:45 +0200
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Message-Id: <201005031624.45409.rain_maker@root-forum.org>
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The drivers rt2500usb and rt73usb both contain the usb id 148f:2573 while only 
the latter is suitable for devices with that id.

As a consequence, both drivers will be loaded and system log shows messages 
like "rt2500usb_init_eeprom: Error - Invalid RT chipset detected".

If you use the above search term, you will find more than 1500 hits with a 
well known search engine, confirming that rt2500usb is always the wrong 
driver for devices with usb id 148f:2573 and quite often as a side effect 
confusion arose about this -non fatal but misleading- error message in the 
respective bug reports or threads.

This trivial patch removes the id 148f:2573 from rt2500usb driver.

Signed-off-by:  Axel Koellhofer <rain_maker@root-forum.org>
---

diff -Naur a/drivers/net/wireless/rt2x00/rt2500usb.c 
b/drivers/net/wireless/rt2x00/rt2500usb.c
--- a/drivers/net/wireless/rt2x00/rt2500usb.c	2010-05-03 16:03:29.572101896 
+0200
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c	2010-05-03 16:03:51.902854565 
+0200
@@ -1879,7 +1879,6 @@
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
-	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Sagem */
 	{ USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
