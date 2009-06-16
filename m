Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:37399 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZFPCPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 22:15:20 -0400
Received: by ewy6 with SMTP id 6so5575062ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2009 19:15:21 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] zd1211rw: adding 083a:e503 as a ZD1211B device
Date: Tue, 16 Jun 2009 03:15:56 +0100
Message-Id: <1245118556-1934-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans Pontar reported success on the sourceforge zd1211-devs mailing list.
The device is branded "Arcor Easy Stick A 50 WLAN" (device manufactured
by SMC for a German ISP - SMC model name: WN4501H-LF-IR). General
information and Windows driver are available under (German only):

http://www.arcor.de/hilfe/neu/index.php?sid=&aktion=anzeigen&rubrik=004018140&id=487

Device details:

USB-IDs: Vendor: 0x083A Device: 0xE503
Chip ID: zd1211b chip 083a:e503 v4810 high 00-1d-19 AL2230S_RF pa0 g--N-

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Tested-by: Hans Pontar <pontar@gmx.de>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index f0e5e94..14a19ba 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -67,6 +67,7 @@ static struct usb_device_id usb_ids[] = {
 	{ USB_DEVICE(0x079b, 0x0062), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x1582, 0x6003), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x050d, 0x705c), .driver_info = DEVICE_ZD1211B },
+	{ USB_DEVICE(0x083a, 0xe503), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0xe506), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x083a, 0x4505), .driver_info = DEVICE_ZD1211B },
 	{ USB_DEVICE(0x0471, 0x1236), .driver_info = DEVICE_ZD1211B },
-- 
1.6.0.6

