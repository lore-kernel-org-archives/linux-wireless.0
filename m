Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vostochny.stro.at ([78.47.22.85]:51446 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab0KBWK0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 18:10:26 -0400
From: maximilian attems <max@stro.at>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, maximilian attems <max@stro.at>,
	Go Taniguchi <go@turbolinux.co.jp>
Subject: [PATCH] zd1211rw: add 2 missing usb id's
Date: Tue,  2 Nov 2010 23:10:12 +0100
Message-Id: <1288735812-3422-1-git-send-email-max@stro.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"These USB ID came from Palnex <http://www.planex.co.jp/>
Worked fine." says Mandriva patch for their 2.6.32 and earlier.

Web has evidence for both id's to work, so just add them upstream:
http://www.mail-archive.com/zd1211-devs@lists.sourceforge.net/msg00507.html
http://ubuntuforums.org/showthread.php?t=473046

Signed-off-by: Go Taniguchi <go@turbolinux.co.jp>
Signed-off-by: maximilian attems <max@stro.at>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 818e148..06041cb 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -55,6 +55,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x129b, 0x1666), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x13b1, 0x001e), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x1435, 0x0711), .driver_info = DEVICE_ZD1211 },
+	{ USB_DEVICE(0x14ea, 0xab10), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x14ea, 0xab13), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300a), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x157e, 0x300b), .driver_info = DEVICE_ZD1211 },
@@ -92,6 +93,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x157e, 0x300d), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x2019, 0xed01), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
-- 
1.7.1

