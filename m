Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37526 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbdHIQbd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 12:31:33 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 19/20] zd1201: constify usb_device_id
Date: Wed,  9 Aug 2017 22:01:24 +0530
Message-Id: <1502296284-21779-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170809_183222_136440_CE05F466)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
changes in v2:
              Re-submitting wireless separately.

 drivers/net/wireless/zydas/zd1201.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1201.c b/drivers/net/wireless/zydas/zd1201.c
index 7f586d7..581e857 100644
--- a/drivers/net/wireless/zydas/zd1201.c
+++ b/drivers/net/wireless/zydas/zd1201.c
@@ -25,7 +25,7 @@
 #include <linux/firmware.h>
 #include "zd1201.h"
 
-static struct usb_device_id zd1201_table[] = {
+static const struct usb_device_id zd1201_table[] = {
 	{USB_DEVICE(0x0586, 0x3400)}, /* Peabird Wireless USB Adapter */
 	{USB_DEVICE(0x0ace, 0x1201)}, /* ZyDAS ZD1201 Wireless USB Adapter */
 	{USB_DEVICE(0x050d, 0x6051)}, /* Belkin F5D6051 usb  adapter */
-- 
2.7.4
