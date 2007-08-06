Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:4289 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbXHFBZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 21:25:19 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw: Add ID for ZyXEL M-202 XtremeMIMO
Message-Id: <20070806012519.0CF857B409F@zog.reactivated.net>
Date: Mon,  6 Aug 2007 02:25:18 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested by Nathen Meyers
FCC ID: SI5WUB221Z
zd1211b chip 0586:340a v4810 high 00-13-49 AL2230_RF pa0 ----S

Despite the product name, I'm pretty sure this isn't a MIMO device. It
appears just to be a normal ZD1211B and we have never heard of these
devices having more than 1 RF. I guess they named this product this way
to make it appear that it fits in with the rest of their XtremeMIMO
product range.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Index: linux/drivers/net/wireless/zd1211rw/zd_usb.c
===================================================================
--- linux.orig/drivers/net/wireless/zd1211rw/zd_usb.c
+++ linux/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -75,6 +75,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x129b, 0x1667), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0cde, 0x001a), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x0586, 0x340a), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
