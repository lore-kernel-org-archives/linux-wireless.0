Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW2.Sony.CO.JP ([137.153.0.14]:55969 "EHLO mgw2.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbXGEIrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 04:47:08 -0400
Date: Thu, 05 Jul 2007 17:11:00 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH] zd1211rw: Add ID for Plannex GW-US54GXS
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	geoffrey.levand@am.sony.com
Message-Id: <20070705165600.D014.MOKUNO@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ID for Plannex GW-US54GXS USB wireless adapter sold in 
Japan.
Since this device returns the regulatory region as 0x49,
the patch 'Allow channels 1-11 for unrecognised regulatory domains' is
required.

Tested by Masakazu Mokuno
zd1211b chip 2019:5303 v4810 high 00-90-cc AL2230_RF pa0 ---N-

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -70,6 +70,7 @@ static struct usb_device_id usb_ids[] = 
 	{ USB_DEVICE(0x0586, 0x3412), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0586, 0x3413), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0053, 0x5301), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x2019, 0x5303), .driver_info = DEVICE_ZD1211B },
 	/* "Driverless" devices that need ejecting */
 	{ USB_DEVICE(0x0ace, 0x2011), .driver_info = DEVICE_INSTALLER },
 	{ USB_DEVICE(0x0ace, 0x20ff), .driver_info = DEVICE_INSTALLER },
 
--
Masakazu MOKUNO

