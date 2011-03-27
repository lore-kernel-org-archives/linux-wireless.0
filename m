Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58554 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab1C0AQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2011 20:16:06 -0400
Received: by wwa36 with SMTP id 36so2577471wwa.1
        for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2011 17:16:03 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com,
	linville@tuxdriver.com, gwingerde@gmail.com
Subject: [PATCH] wireless: rt2x00: rt{2500,73}usb.c fix duplicate ids
Date: Sun, 27 Mar 2011 01:15:53 +0100
Message-Id: <1301184953-18436-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

based on the Ralink drivers:

W = Windows_ralink_driver
L = Linux_ralink_driver

USB_IDs         W_73  W_2500 L_73  L_2500
=============   ====  ====== ====  ======
0x050d,0x7050   -     -      -     YES
0x050d,0x705a   -     -      YES   -
0x1371,0x9022   -     YES    YES   -
0x148f,0x2573   YES   -      YES   -

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 ----
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 979fe65..f6682f0 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1910,13 +1910,10 @@ static struct usb_device_id rt2500usb_device_table[] = {
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x7050), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x050d, 0x7051), USB_DEVICE_DATA(&rt2500usb_ops) },
-	{ USB_DEVICE(0x050d, 0x705a), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Cisco Systems */
 	{ USB_DEVICE(0x13b1, 0x000d), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x13b1, 0x0011), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x13b1, 0x001a), USB_DEVICE_DATA(&rt2500usb_ops) },
-	/* CNet */
-	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Conceptronic */
 	{ USB_DEVICE(0x14b2, 0x3c02), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* D-LINK */
@@ -1939,7 +1936,6 @@ static struct usb_device_id rt2500usb_device_table[] = {
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
-	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Sagem */
 	{ USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 02f1148..bc7a957 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2407,7 +2407,6 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1723), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1724), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Belkin */
-	{ USB_DEVICE(0x050d, 0x7050), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x050d, 0x705a), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x050d, 0x905b), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x050d, 0x905c), USB_DEVICE_DATA(&rt73usb_ops) },
-- 
1.7.4

