Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:51840 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab3BIDOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 22:14:50 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so3378599wgb.21
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 19:14:49 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next] wireless: rt2x00: rt2800usb add "unknown" devices
Date: Sat,  9 Feb 2013 04:14:35 +0100
Message-Id: <1360379675-23599-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130209_041501_020811_DA7A800D)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

0x06f8, 0xe036 Hercules  Wireless Dual Band 600 USB Key HWNUm-600
0x0b05, 0x17a7 ASUS      USB-N10H 150Mbps 11n Wireless USB dongle
0x0df6, 0x0069 Sitecom   Wireless Dualband Network Adapter 300N X5 WLA-5000
0x0df6, 0x006f Sitecom   WiFi USB adapter N600 WLA-5100
0x13d3, 0x3340 AzureWave 802.11n USB Wireless LAN Card
0x13d3, 0x3399 AzureWave 802.11n USB Wireless LAN Card
0x13d3, 0x3400 AzureWave 802.11n USB Wireless LAN Card
0x13d3, 0x3401 AzureWave 802.11n USB Wireless LAN Card
0x1740, 0x0600 EnGenius  Dual-Band Wireless Media Adapter
0x1740, 0x0602 EnGenius  802.11 a/b/g/n Wireless USB Adapter
0x177f, 0x0254 Sweex     LW054 Wireless 54G Adapter USB
0xf201, 0x5370 TP-LINK   54Mbps Wireless USB Adapter

no RF3053, and I believe no RT5572.


Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 8a57646..098613e 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1219,10 +1219,15 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1760) },
 	{ USB_DEVICE(0x0b05, 0x1761) },
 	{ USB_DEVICE(0x0b05, 0x1790) },
+	{ USB_DEVICE(0x0b05, 0x17a7) },
 	/* AzureWave */
 	{ USB_DEVICE(0x13d3, 0x3262) },
 	{ USB_DEVICE(0x13d3, 0x3284) },
 	{ USB_DEVICE(0x13d3, 0x3322) },
+	{ USB_DEVICE(0x13d3, 0x3340) },
+	{ USB_DEVICE(0x13d3, 0x3399) },
+	{ USB_DEVICE(0x13d3, 0x3400) },
+	{ USB_DEVICE(0x13d3, 0x3401) },
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x1003) },
 	/* Buffalo */
@@ -1237,10 +1242,15 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x07d1, 0x3c0b) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
+	/* EnGenius */
+	{ USB_DEVICE(0x1740, 0x0600) },
+	{ USB_DEVICE(0x1740, 0x0602) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0010) },
 	/* Gigabyte */
 	{ USB_DEVICE(0x1044, 0x800c) },
+	/* Hercules */
+	{ USB_DEVICE(0x06f8, 0xe036) },
 	/* Huawei */
 	{ USB_DEVICE(0x148f, 0xf101) },
 	/* I-O DATA */
@@ -1267,11 +1277,17 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0df6, 0x004a) },
 	{ USB_DEVICE(0x0df6, 0x004d) },
 	{ USB_DEVICE(0x0df6, 0x0053) },
+	{ USB_DEVICE(0x0df6, 0x0069) },
+	{ USB_DEVICE(0x0df6, 0x006f) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512) },
 	{ USB_DEVICE(0x083a, 0xc522) },
 	{ USB_DEVICE(0x083a, 0xd522) },
 	{ USB_DEVICE(0x083a, 0xf511) },
+	/* Sweex */
+	{ USB_DEVICE(0x177f, 0x0254) },
+	/* TP-LINK */
+	{ USB_DEVICE(0xf201, 0x5370) },
 #endif
 	{ 0, }
 };
-- 
1.7.11.7
