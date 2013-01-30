Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:54748 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3A3QOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 11:14:23 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so1358755wgb.32
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 08:14:21 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next] wireless: rt2x00: rt2800usb add/identify ids
Date: Wed, 30 Jan 2013 17:14:13 +0100
Message-Id: <1359562453-31781-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130130_171426_676768_6BC0BDF0)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices were taken from Ralink Linux drivers:
- RT5370
0x043e, 0x7a32
0x043e, 0x7a42
0x0471, 0x2126
0x0471, 0x2180
0x0471, 0x2181
0x0471, 0x2182

Identify these ones:
0x04da, 0x23f6 in CONFIG_RT2800USB_RT53XX is a Panasonic device
0x07d1, 0x3c17 in RT2800USB_UNKNOWN is a RT3070
0x0586, 0x341a in RT2800USB_UNKNOWN is a RT3070

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com> 
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 4721cad..1cbf20a 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -968,6 +968,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c13) },
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
+	{ USB_DEVICE(0x07d1, 0x3c17) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
@@ -1115,6 +1116,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x3416) },
 	{ USB_DEVICE(0x0586, 0x3418) },
+	{ USB_DEVICE(0x0586, 0x341a) },
 	{ USB_DEVICE(0x0586, 0x341e) },
 	{ USB_DEVICE(0x0586, 0x343e) },
 #ifdef CONFIG_RT2800USB_RT33XX
@@ -1166,6 +1168,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 #ifdef CONFIG_RT2800USB_RT53XX
 	/* Arcadyan */
 	{ USB_DEVICE(0x043e, 0x7a12) },
+	{ USB_DEVICE(0x043e, 0x7a32) },
 	/* Azurewave */
 	{ USB_DEVICE(0x13d3, 0x3329) },
 	{ USB_DEVICE(0x13d3, 0x3365) },
@@ -1177,16 +1180,20 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x2001, 0x3c1e) },
 	/* LG innotek */
 	{ USB_DEVICE(0x043e, 0x7a22) },
+	{ USB_DEVICE(0x043e, 0x7a42) },
 	/* Panasonic */
 	{ USB_DEVICE(0x04da, 0x1801) },
 	{ USB_DEVICE(0x04da, 0x1800) },
+	{ USB_DEVICE(0x04da, 0x23f6) },
 	/* Philips */
 	{ USB_DEVICE(0x0471, 0x2104) },
+	{ USB_DEVICE(0x0471, 0x2126) },
+	{ USB_DEVICE(0x0471, 0x2180) },
+	{ USB_DEVICE(0x0471, 0x2181) },
+	{ USB_DEVICE(0x0471, 0x2182) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x5370) },
 	{ USB_DEVICE(0x148f, 0x5372) },
-	/* Unknown */
-	{ USB_DEVICE(0x04da, 0x23f6) },
 #endif
 #ifdef CONFIG_RT2800USB_UNKNOWN
 	/*
@@ -1223,7 +1230,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x18c5, 0x0008) },
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c0b) },
-	{ USB_DEVICE(0x07d1, 0x3c17) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
 	/* Gemtek */
@@ -1261,8 +1267,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x083a, 0xc522) },
 	{ USB_DEVICE(0x083a, 0xd522) },
 	{ USB_DEVICE(0x083a, 0xf511) },
-	/* Zyxel */
-	{ USB_DEVICE(0x0586, 0x341a) },
 #endif
 	{ 0, }
 };
-- 
1.7.11.7
