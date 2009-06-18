Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gut75-1-81-57-27-189.fbx.proxad.net ([81.57.27.189]:39817 "EHLO
	n4.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753803AbZFRQDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 12:03:42 -0400
From: Pascal Terjan <pterjan@mandriva.com>
To: Daniel Drake <dsd@gentoo.org>, kune@deine-taler.de
Cc: linux-wireless@vger.kernel.org,
	Pascal Terjan <pterjan@mandriva.com>
Subject: [PATCH] 07b8:6001 is a ZD1211B
Date: Thu, 18 Jun 2009 17:54:03 +0200
Message-Id: <1245340443-13214-1-git-send-email-pterjan@mandriva.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a shuttle machine here we got 07b8:6001 device, handled by zd1211rw, which does not work.
Scanning is OK but association does not work, we get "direct probe to AP xxx timed out"

It appears that this simple patch makes the device work perfectly.

This id was already there in initial import of the driver so I don't know if it has ever been
working as ZD1211 (which would mean they changed it and kept the id :( ).

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index f0e5e94..d04a69d 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -38,7 +38,6 @@ static struct usb_device_id usb_ids[] = {
 	/* ZD1211 */
 	{ USB_DEVICE(0x0ace, 0x1211), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0ace, 0xa211), .driver_info = DEVICE_ZD1211 },
-	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x126f, 0xa006), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x6891, 0xa727), .driver_info = DEVICE_ZD1211 },
 	{ USB_DEVICE(0x0df6, 0x9071), .driver_info = DEVICE_ZD1211 },
@@ -86,6 +85,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x0471, 0x1237), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x07fa, 0x1196), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0df6, 0x0036), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x07b8, 0x6001), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
-- 
1.6.2.4

