Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55671 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1C0SdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2011 14:33:14 -0400
Received: by wya21 with SMTP id 21so2307693wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Mar 2011 11:33:12 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: xose.vazquez@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, IvDoorn@gmail.com,
	linville@tuxdriver.com, gwingerde@gmail.com
Subject: [PATCH] wireless: rt2x00: rt2800usb.c add and identify ids
Date: Sun, 27 Mar 2011 20:33:06 +0200
Message-Id: <1301250786-9157-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

taken from staging/rt2860
0x0411,0x016f de37cd49b5a54facef174cf34496919857436e8f MelCo(Buffalo) WLI-UC-G301N
0x050d,0x825b 12840c63b0679f7fab88ea1cc26b52db8b574ce7 Belkin F5D8055
0x050d,0x935a 705059a670f3af2b37695e82de0ee58e75e656ed Belkin F6D4050 v1
0x050d,0x935b 5d92fe3387d086fc2f10426fbdb6b86d6cce5a47 Belkin F6D4050 v2

identifed from ralink driverss
0x0930,0x0a07 RT35xx TOSHIBA 2010_1215_RT3572_Linux_STA_v2.5.0.0.DPO
0x1d4d,0x0011 3072 Pegatron 2011_0107_RT3070_RT3370_Linux_STA_v2.5.0.1_DPO

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 4e36865..37509d0 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -730,8 +730,12 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x050d, 0x8053), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x050d, 0x805c), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x050d, 0x815c), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x050d, 0x825b), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x050d, 0x935a), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x050d, 0x935b), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Buffalo */
 	{ USB_DEVICE(0x0411, 0x00e8), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x0411, 0x016f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Conceptronic */
 	{ USB_DEVICE(0x14b2, 0x3c06), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x14b2, 0x3c07), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -818,6 +822,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Pegatron */
 	{ USB_DEVICE(0x1d4d, 0x000c), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x000e), USB_DEVICE_DATA(&rt2800usb_ops) },
+	{ USB_DEVICE(0x1d4d, 0x0011), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Philips */
 	{ USB_DEVICE(0x0471, 0x200f), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Planex */
@@ -899,6 +904,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x148f, 0x3572), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0041), USB_DEVICE_DATA(&rt2800usb_ops) },
+	/* Toshiba */
+	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zinwell */
 	{ USB_DEVICE(0x5a57, 0x0284), USB_DEVICE_DATA(&rt2800usb_ops) },
 #endif
@@ -961,7 +968,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x05a6, 0x0101), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x0002), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x1d4d, 0x0010), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x1d4d, 0x0011), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0x5201), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x2019, 0xab24), USB_DEVICE_DATA(&rt2800usb_ops) },
@@ -975,8 +981,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Sweex */
 	{ USB_DEVICE(0x177f, 0x0153), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x177f, 0x0313), USB_DEVICE_DATA(&rt2800usb_ops) },
-	/* Toshiba */
-	{ USB_DEVICE(0x0930, 0x0a07), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Zyxel */
 	{ USB_DEVICE(0x0586, 0x341a), USB_DEVICE_DATA(&rt2800usb_ops) },
 #endif
-- 
1.7.4

