Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:34340 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab0DFR05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 13:26:57 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1138594fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 10:26:55 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] wireless: rt2x00: delete duplicates ids in rt73usb rt2500usb
Date: Tue,  6 Apr 2010 19:26:31 +0200
Message-Id: <1270574791-14006-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Follow the precepts of the ralink drivers.

(0x050d, 0x7050) is only found in:

RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTVID8                  0x050D //ralink
RT25USB-SRC-V2.0.8.0/rt2570sw.h:#define RTPID8                  0x7050
RT25USB-SRC-V2.0.8.0/rt2570sw.h: {USB_DEVICE(RTVID8,RTPID8)},

and (0x050d, 0x705a) (0x1371, 0x9022) (0x148f, 0x2573) are only in:

2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x050d,0x705a)}, /* Belkin */
2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x1371,0x9022)}, /* CNet */
2009_0713_RT73_Linux_STA_Drv1.1.0.3/Module/rtmp_def.h: {USB_DEVICE(0x148f,0x2573)}, /* Ralink */

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    4 ----
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 13444b6..c7f6fa6 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1849,13 +1849,10 @@ static struct usb_device_id rt2500usb_device_table[] = {
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
@@ -1878,7 +1875,6 @@ static struct usb_device_id rt2500usb_device_table[] = {
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
-	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
 	{ USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
 	/* Sagem */
 	{ USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 290d70b..3e30ccf 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2339,7 +2339,6 @@ static struct usb_device_id rt73usb_device_table[] = {
 	{ USB_DEVICE(0x0b05, 0x1723), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0b05, 0x1724), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Belkin */
-	{ USB_DEVICE(0x050d, 0x7050), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x050d, 0x705a), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x050d, 0x905b), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x050d, 0x905c), USB_DEVICE_DATA(&rt73usb_ops) },
-- 
1.6.6.1

