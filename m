Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48390 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3I1LHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Sep 2013 07:07:15 -0400
Received: by mail-wi0-f174.google.com with SMTP id hj3so1884616wib.13
        for <linux-wireless@vger.kernel.org>; Sat, 28 Sep 2013 04:07:14 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next] wireless: rt2x00: rt2800usb: add new devices
Date: Sat, 28 Sep 2013 13:07:10 +0200
Message-Id: <1380366430-23436-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130928_130733_119851_C2B1458E)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0411,0241  RT5572  BUFFALO WI-U2-300D Wireless LAN Adapter
0789,0170  RT3572  Logitec LAN-W300AN/U2
0846,9013  RT3573  NETGEAR Adaptador USB Inalambrico Movistar
0df6,006e  RT3573  Sitecom WiFi USB adapter N900
2001,3c1f  RT3573  D-Link DWA-162 Wireless N900 Dual Band Adapter
2001,3c20  RT5372  D-Link DWA-140 Wireless N USB Adapter(rev.D)
2001,3c21  RT5572  D-Link DWA-160 Xtreme N Dual Band USB Adapter(rev.C)
2001,3c22  RT5372  D-Link DWA-132 Wireless N USB Adapter(rev.B)
2001,3c23  RT5372  D-Link GO-USB-N300 Wireless N Easy USB Adapter
2019,ab29  ?       Planex GW-USMirco300
20f4,724a  RT5572  TRENDnet N600 Wireless Dual Band USB Adapter

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 96961b9..96677ce5 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1176,6 +1176,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x002f) },
 	{ USB_DEVICE(0x1737, 0x0079) },
+	/* Logitec */
+	{ USB_DEVICE(0x0789, 0x0170) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3572) },
 	/* Sitecom */
@@ -1199,6 +1201,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x050d, 0x1103) },
 	/* Cameo */
 	{ USB_DEVICE(0x148f, 0xf301) },
+	/* D-Link */
+	{ USB_DEVICE(0x2001, 0x3c1f) },
 	/* Edimax */
 	{ USB_DEVICE(0x7392, 0x7733) },
 	/* Hawking */
@@ -1212,6 +1216,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0789, 0x016b) },
 	/* NETGEAR */
 	{ USB_DEVICE(0x0846, 0x9012) },
+	{ USB_DEVICE(0x0846, 0x9013) },
 	{ USB_DEVICE(0x0846, 0x9019) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xed19) },
@@ -1220,6 +1225,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0067) },
 	{ USB_DEVICE(0x0df6, 0x006a) },
+	{ USB_DEVICE(0x0df6, 0x006e) },
 	/* ZyXEL */
 	{ USB_DEVICE(0x0586, 0x3421) },
 #endif
@@ -1236,6 +1242,9 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x2001, 0x3c1c) },
 	{ USB_DEVICE(0x2001, 0x3c1d) },
 	{ USB_DEVICE(0x2001, 0x3c1e) },
+	{ USB_DEVICE(0x2001, 0x3c20) },
+	{ USB_DEVICE(0x2001, 0x3c22) },
+	{ USB_DEVICE(0x2001, 0x3c23) },
 	/* LG innotek */
 	{ USB_DEVICE(0x043e, 0x7a22) },
 	{ USB_DEVICE(0x043e, 0x7a42) },
@@ -1258,12 +1267,17 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x043e, 0x7a32) },
 	/* AVM GmbH */
 	{ USB_DEVICE(0x057c, 0x8501) },
-	/* D-Link DWA-160-B2 */
+	/* Buffalo */
+	{ USB_DEVICE(0x0411, 0x0241) },
+	/* D-Link */
 	{ USB_DEVICE(0x2001, 0x3c1a) },
+	{ USB_DEVICE(0x2001, 0x3c21) },
 	/* Proware */
 	{ USB_DEVICE(0x043e, 0x7a13) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x5572) },
+	/* TRENDnet */
+	{ USB_DEVICE(0x20f4, 0x724a) },
 #endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
@@ -1333,6 +1347,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x1d4d, 0x0010) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab24) },
+	{ USB_DEVICE(0x2019, 0xab29) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6259) },
 	/* RadioShack */
-- 
1.8.3.1

