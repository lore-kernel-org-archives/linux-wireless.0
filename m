Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50639 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3GWM40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 08:56:26 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so2160504wgh.14
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jul 2013 05:56:25 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless: rt2x00: rt2800usb: add RT3573 devices
Date: Tue, 23 Jul 2013 14:55:15 +0200
Message-Id: <1374584115-18361-1-git-send-email-xose.vazquez@gmail.com> (sfid-20130723_145630_163947_602F89EC)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

taken from Ralink linux and windows drivers:

0x1b75, 0x7733 AirLive 450Mbps Wireless-N Dual Band USB Adapter
0x0b05, 0x17bc ASUS USB-N66 450Mbps Dual Band USB Adapter
0x0b05, 0x17ad ASUS USB-N66 Dual Band N Network Adapter
0x050d, 0x1103 Belkin Wireless Adapter
0x148f, 0xf301 Cameo Ralink3573 3x3 single band USB dongle
0x7392, 0x7733 Edimax
0x0e66, 0x0020 Hawking HD45U Dual Band USB Wireless-N Adapter
0x0e66, 0x0021 Hawking HD45U Dual Band Wls-450N Adapter
0x04bb, 0x094e I-O DATA WN-AG450U Wireless LAN Adapter
0x0789, 0x016b Logitec LAN-W450AN/U2
0x0846, 0x9012 NETGEAR WNDA4100 N900 Wireless Dual Band USB Adapter
0x0846, 0x9019 NETGEAR WNDA4200D Wireless Dual Band USB Adapter
0x2019, 0xed19 Planex GW-USDual450
0x148f, 0x3573 Ralink 802.11n USB Wireless LAN Card
0x0df6, 0x0067 Sitecom Wireless Dualband Network Adapter N750 X6
0x0df6, 0x006a Sitecom Wireless Dualband Network Adapter N900 X7
0x0586, 0x3421 ZyXEL Dual-Band Wireless N450 USB Adapter

Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ab609ae..fc9efdf 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1198,8 +1198,38 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x5a57, 0x0284) },
 #endif
 #ifdef CONFIG_RT2800USB_RT3573
+	/* AirLive */
+	{ USB_DEVICE(0x1b75, 0x7733) },
+	/* ASUS */
+	{ USB_DEVICE(0x0b05, 0x17bc) },
+	{ USB_DEVICE(0x0b05, 0x17ad) },
+	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x1103) },
+	/* Cameo */
+	{ USB_DEVICE(0x148f, 0xf301) },
+	/* Edimax */
+	{ USB_DEVICE(0x7392, 0x7733) },
+	/* Hawking */
+	{ USB_DEVICE(0x0e66, 0x0020) },
+	{ USB_DEVICE(0x0e66, 0x0021) },
+	/* I-O DATA */
+	{ USB_DEVICE(0x04bb, 0x094e) },
 	/* Linksys */
 	{ USB_DEVICE(0x13b1, 0x003b) },
+	/* Logitec */
+	{ USB_DEVICE(0x0789, 0x016b) },
+	/* NETGEAR */
+	{ USB_DEVICE(0x0846, 0x9012) },
+	{ USB_DEVICE(0x0846, 0x9019) },
+	/* Planex */
+	{ USB_DEVICE(0x2019, 0xed19) },
+	/* Ralink */
+	{ USB_DEVICE(0x148f, 0x3573) },
+	/* Sitecom */
+	{ USB_DEVICE(0x0df6, 0x0067) },
+	{ USB_DEVICE(0x0df6, 0x006a) },
+	/* ZyXEL */
+	{ USB_DEVICE(0x0586, 0x3421) },
 #endif
 #ifdef CONFIG_RT2800USB_RT53XX
 	/* Arcadyan */
-- 
1.8.3.1

