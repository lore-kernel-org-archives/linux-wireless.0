Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45937 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959Ab2ERSXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 14:23:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, frankyl@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] brcmfmac: use vmalloc to allocate mem for the firmware
Date: Fri, 18 May 2012 20:22:53 +0200
Message-Id: <1337365373-12418-1-git-send-email-hauke@hauke-m.de> (sfid-20120518_202357_180819_45E29612)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware is more than 300KB big and you should not use kmalloc for
such big allocations. This allocation with kmalloc failed on my mips
based device (BCM47186).

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmfmac/usb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 1d67ecf..3e35247 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -28,6 +28,7 @@
 #include <linux/uaccess.h>
 #include <linux/firmware.h>
 #include <linux/usb.h>
+#include <linux/vmalloc.h>
 #include <net/cfg80211.h>
 
 #include <defs.h>
@@ -1239,7 +1240,7 @@ static int brcmf_usb_get_fw(struct brcmf_usbdev_info *devinfo)
 		return -EINVAL;
 	}
 
-	devinfo->image = kmalloc(fw->size, GFP_ATOMIC); /* plus nvram */
+	devinfo->image = vmalloc(fw->size); /* plus nvram */
 	if (!devinfo->image)
 		return -ENOMEM;
 
@@ -1602,7 +1603,7 @@ static struct usb_driver brcmf_usbdrvr = {
 void brcmf_usb_exit(void)
 {
 	usb_deregister(&brcmf_usbdrvr);
-	kfree(g_image.data);
+	vfree(g_image.data);
 	g_image.data = NULL;
 	g_image.len = 0;
 }
-- 
1.7.9.5

