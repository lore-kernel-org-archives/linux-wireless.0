Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44373 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab0DNKQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 06:16:09 -0400
Received: by bwz25 with SMTP id 25so6684477bwz.28
        for <linux-wireless@vger.kernel.org>; Wed, 14 Apr 2010 03:16:07 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com, xose.vazquez@gmail.com
Subject: [PATCH] wireless: rt2x00: rt2800usb: identify Sitecom devices
Date: Wed, 14 Apr 2010 12:16:00 +0200
Message-Id: <1271240160-2759-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A very useful information was provided by Sitecom R&D guys:

Please find the information regarding our latest Ralink adapters below;

WL-302    -    VID: 0x0DF6,    PID: 0x002D    -    Ralink RT2771
WL-315    -    VID: 0x0DF6,    PID: 0x0039    -    Ralink RT2770
WL-319    -    VID: 0x182D,    PID: 0x0037    -    Ralink RT2860
WL-321    -    VID: 0x0DF6,    PID: 0x003B    -    Ralink RT2770
WL-324    -    VID: 0x0DF6,    PID: 0x003D    -    Ralink RT2870
WL-329    -    VID: 0x0DF6,    PID: 0x0041    -    Ralink RT3572
WL-343    -    VID: 0x0DF6,    PID: 0x003E    -    Ralink RT3070
WL-344    -    VID: 0x0DF6,    PID: 0x0040    -    Ralink RT3071
WL-345    -    VID: 0x0DF6,    PID: 0x0042    -    Ralink RT3072
WL-608    -    VID: 0x0DF6,    PID: 0x003F    -    Ralink RT2070

Note:
PID: 0x003C, 0x004A, and 0x004D:   --these products do not exist; devices were never produced/shipped--

The WL-349v4 USB dongle (0x0df6,0x0050) will be shipped soon (it isn't available yet), and uses a Ralink RT3370 chipset.

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 03a85f7..6b809ab 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -876,6 +876,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x002c), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x002d), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0039), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x003b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x003d), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x003f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0x6618), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -975,6 +977,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x003e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0040), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0042), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0047), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x0048), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -1002,6 +1005,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x8070), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0050), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0284), USB_DEVICE_DATA(&rt2800usb_ops) },
 #endif
@@ -1075,13 +1079,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x2019, 0xab24), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6259), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Sitecom */
-	{ USB_DEVICE(0x0df6, 0x003b), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x003c), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x003d), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x0040), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x004a), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x0df6, 0x004d), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x083a, 0xc522), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.6.1

