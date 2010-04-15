Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:56397 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0DOL0J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 07:26:09 -0400
Received: by bwz25 with SMTP id 25so1421700bwz.28
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 04:26:07 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com, xose.vazquez@gmail.com
Subject: [PATCH] wireless: rt2x00: rt2800usb: identify Hawking devices
Date: Thu, 15 Apr 2010 13:25:49 +0200
Message-Id: <1271330749-4606-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0x0e66,0x0009 HWUN2 Hawking Technologies Hi-Gain Wireless-150N USB Adapter w/ Upgradable Antenna
0x0e66,0x000b HWDN2 Hawking Technologies Hi-Gain USB Wireless-150N Dish Adapter
0x0e66,0x0013 Hawking Technologies Hi-Gain Wireless-N USB Adapter
0x0e66,0x0017 Hawking Wireless-N Network Adapter
0x0e66,0x0018 Hawking Wireless-N Network Adapter

Hawking Technologies Technical Support guys say:

All our N adapters use the same chipset. Ralink RT 2870 chipset.

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6b809ab..df7666f 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -848,6 +848,11 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Hawking */
 	{ USB_DEVICE(0x0e66, 0x0001), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0e66, 0x0003), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0009), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x000b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0013), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0017), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0e66, 0x0018), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Linksys */
 	{ USB_DEVICE(0x1737, 0x0070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1737, 0x0071), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -1057,9 +1062,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x15a9, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Gigabyte */
 	{ USB_DEVICE(0x1044, 0x800c), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Hawking */
-	{ USB_DEVICE(0x0e66, 0x0009), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0e66, 0x000b), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* LevelOne */
 	{ USB_DEVICE(0x1740, 0x0605), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1740, 0x0615), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.6.1

