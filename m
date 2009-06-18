Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:39840 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZFRCx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 22:53:29 -0400
Received: by ewy6 with SMTP id 6so1108771ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 19:53:30 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH 1/2] zd1211rw: sort vid/pid pairs by numerical value
Date: Thu, 18 Jun 2009 03:53:26 +0100
Message-Id: <1245293606-2101-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the past ids were inserted in no particular order and it has
become hard to see what ids are already included or not. This
patch sorts the ids by numerical value and has no functional effect.

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   72 ++++++++++++++++----------------
 1 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 14a19ba..2c24dd9 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -36,57 +36,57 @@
 
 static struct usb_device_id usb_ids[] = {
 	/* ZD1211 */
+	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0586, 0x3402), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0586, 0x3409), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x079b, 0x004a), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0ace, 0x1211), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0ace, 0xa211), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0b05, 0x170c), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0b3b, 0x1630), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x0b3b, 0x5630), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0df6, 0x9071), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0df6, 0x9075), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x079b, 0x004a), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0586, 0x3402), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0b3b, 0x5630), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0b05, 0x170c), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x1435, 0x0711), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0586, 0x3409), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0b3b, 0x1630), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0586, 0x3401), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x14ea, 0xab13), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0586, 0x3407), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x0105, 0x145f), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x157e, 0x3204), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x1740, 0x2000), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
 	/* ZD1211B */
-	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0ace, 0xb215), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x083a, 0xe503), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x083a, 0xe506), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0053, 0x5301), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0411, 0x00da), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x340f), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0b05, 0x171b), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x3410), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0baf, 0x0121), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x3412), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x3413), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0053, 0x5301), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0411, 0x00da), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
-	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x083a, 0xe503), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x083a, 0xe506), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0ace, 0x1215), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0ace, 0xb215), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0b05, 0x171b), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0baf, 0x0121), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0df6, 0x0036), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x13b1, 0x0024), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
-- 
1.6.2.2

