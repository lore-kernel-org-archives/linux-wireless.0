Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53029 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2DOAKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 20:10:01 -0400
Received: by wgbdr13 with SMTP id dr13so4094213wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 14 Apr 2012 17:10:00 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com,
	linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: [PATCH] wireless: rt2x00: rt2800usb add more devices ids
Date: Sun, 15 Apr 2012 02:09:52 +0200
Message-Id: <1334448592-16391-1-git-send-email-xose.vazquez@gmail.com> (sfid-20120415_021008_197916_BFF13188)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They were taken from ralink drivers:
2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO

0x1eda,0x2210 RT3070 Airties

0x083a,0xb511 RT3370 Panasonic
0x0471,0x20dd RT3370 Philips

0x1875,0x7733 RT3573 Air Live
0x7392,0x7733 RT3573 Edimax
0x0e66,0x0021 RT3573 Hawking
0x2019,0xed19 RT3573 Planex
0x148f,0x3573 RT3573 Ralink
0x0df6,0x0067 RT3573 Sitecom
0x1690,0x0764 RT35xx Askey
0x0df6,0x0065 RT35xx Sitecom
0x0df6,0x0066 RT35xx Sitecom
0x0df6,0x0068 RT35xx Sitecom

0x2001,0x3c1c RT5370 DLink
0x2001,0x3c1d RT5370 DLink

2001 is D-Link not Alpha

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 001735f..c4d7f6f 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -922,6 +922,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1482, 0x3c09) },
 	/* AirTies */
 	{ USB_DEVICE(0x1eda, 0x2012) },
+	{ USB_DEVICE(0x1eda, 0x2210) },
 	{ USB_DEVICE(0x1eda, 0x2310) },
 	/* Allwin */
 	{ USB_DEVICE(0x8516, 0x2070) },
@@ -1134,6 +1135,10 @@ static struct usb_device_id rt2800usb_device_table[] = {
 #ifdef CONFIG_RT2800USB_RT33XX
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x945b) },
+	/* Panasonic */
+	{ USB_DEVICE(0x083a, 0xb511) },
+	/* Philips */
+	{ USB_DEVICE(0x0471, 0x20dd) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3370) },
 	{ USB_DEVICE(0x148f, 0x8070) },
@@ -1141,38 +1146,54 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x0050) },
 #endif
 #ifdef CONFIG_RT2800USB_RT35XX
+	/* Air Live */
+	{ USB_DEVICE(0x1875, 0x7733) },
 	/* Allwin */
 	{ USB_DEVICE(0x8516, 0x3572) },
 	/* Askey */
 	{ USB_DEVICE(0x1690, 0x0744) },
+	{ USB_DEVICE(0x1690, 0x0764) },
 	/* Cisco */
 	{ USB_DEVICE(0x167b, 0x4001) },
+	/* Edimax */
+	{ USB_DEVICE(0x7392, 0x7733) },
 	/* EnGenius */
 	{ USB_DEVICE(0x1740, 0x9801) },
+	/* Hawking */
+	{ USB_DEVICE(0x0e66, 0x0021) },
 	/* I-O DATA */
 	{ USB_DEVICE(0x04bb, 0x0944) },
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x002f) },
 	{ USB_DEVICE(0x1737, 0x0079) },
+	/* Planex */
+	{ USB_DEVICE(0x2019, 0xed19) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3572) },
+	{ USB_DEVICE(0x148f, 0x3573) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0041) },
 	{ USB_DEVICE(0x0df6, 0x0062) },
+	{ USB_DEVICE(0x0df6, 0x0065) },
+	{ USB_DEVICE(0x0df6, 0x0066) },
+	{ USB_DEVICE(0x0df6, 0x0067) },
+	{ USB_DEVICE(0x0df6, 0x0068) },
 	/* Toshiba */
 	{ USB_DEVICE(0x0930, 0x0a07) },
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0284) },
 #endif
 #ifdef CONFIG_RT2800USB_RT53XX
-	/* Alpha */
-	{ USB_DEVICE(0x2001, 0x3c15) },
-	{ USB_DEVICE(0x2001, 0x3c19) },
 	/* Arcadyan */
 	{ USB_DEVICE(0x043e, 0x7a12) },
 	/* Azurewave */
 	{ USB_DEVICE(0x13d3, 0x3329) },
 	{ USB_DEVICE(0x13d3, 0x3365) },
+	/* D-Link */
+	{ USB_DEVICE(0x2001, 0x3c15) },
+	{ USB_DEVICE(0x2001, 0x3c19) },
+	{ USB_DEVICE(0x2001, 0x3c1c) },
+	{ USB_DEVICE(0x2001, 0x3c1d) },
 	/* LG innotek */
 	{ USB_DEVICE(0x043e, 0x7a22) },
 	/* Panasonic */
-- 
1.7.6.5

