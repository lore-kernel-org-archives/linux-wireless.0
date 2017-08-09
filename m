Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33234 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753318AbdHIQ1j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 12:27:39 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 09/20] libertas: constify usb_device_id
Date: Wed,  9 Aug 2017 21:57:28 +0530
Message-Id: <1502296049-21253-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170809_182804_038429_79DD7470)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
changes in v2:
              Re-submitting wireless separately.

 drivers/net/wireless/marvell/libertas/if_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index e53025e..16e54c7 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -52,7 +52,7 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8682, "libertas/usb8682.bin", NULL }
 };
 
-static struct usb_device_id if_usb_table[] = {
+static const struct usb_device_id if_usb_table[] = {
 	/* Enter the device signature inside */
 	{ USB_DEVICE(0x1286, 0x2001), .driver_info = MODEL_8388 },
 	{ USB_DEVICE(0x05a3, 0x8388), .driver_info = MODEL_8388 },
-- 
2.7.4
