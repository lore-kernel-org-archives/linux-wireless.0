Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50770 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757156Ab0DPKQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 06:16:59 -0400
Received: by wyb39 with SMTP id 39so1033745wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Apr 2010 03:16:57 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, linville@tuxdriver.com,
	IvDoorn@gmail.com, gwingerde@gmail.com, xose.vazquez@gmail.com
Subject: [PATCH] wireless: rt2x00: rt2800usb: delete Allwin devices
Date: Fri, 16 Apr 2010 12:16:45 +0200
Message-Id: <1271413005-2509-1-git-send-email-xose.vazquez@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Common sense says:
(0x8516, 0x2070) is RT2070
(0x8516, 0x2770) is RT2770
(0x8516, 0x2870) is RT2870
[...]

but Allwin doesn't sell USB dongles nor PCI boards, only voip-routers
http://www.allwin.com.tw/eng/modules/tinyd0/content/index.php?id=1

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index df7666f..41de405 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1019,14 +1019,6 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	 * Unclear what kind of devices these are (they aren't supported by the
 	 * vendor driver).
 	 */
-	/* Allwin */
-	{ USB_DEVICE(0x8516, 0x2070), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x2770), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x2870), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x3070), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x3071), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x3072), USB_DEVICE_DATA(&rt2800usb_ops) },
-	{ USB_DEVICE(0x8516, 0x3572), USB_DEVICE_DATA(&rt2800usb_ops) },
 	/* Amigo */
 	{ USB_DEVICE(0x0e0b, 0x9031), USB_DEVICE_DATA(&rt2800usb_ops) },
 	{ USB_DEVICE(0x0e0b, 0x9041), USB_DEVICE_DATA(&rt2800usb_ops) },
-- 
1.6.6.1

