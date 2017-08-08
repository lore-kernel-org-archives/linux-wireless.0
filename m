Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:32888 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdHHQDP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 12:03:15 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 25/35] wireless: marvell: libertas_tf: constify usb_device_id
Date: Tue,  8 Aug 2017 21:32:51 +0530
Message-Id: <1502208171-12118-2-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170808_180806_832842_A4052578)
In-Reply-To: <1502208171-12118-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502208171-12118-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index e0ade40..e9104ec 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -31,7 +31,7 @@ module_param_named(fw_name, lbtf_fw_name, charp, 0644);
 
 MODULE_FIRMWARE("lbtf_usb.bin");
 
-static struct usb_device_id if_usb_table[] = {
+static const struct usb_device_id if_usb_table[] = {
 	/* Enter the device signature inside */
 	{ USB_DEVICE(0x1286, 0x2001) },
 	{ USB_DEVICE(0x05a3, 0x8388) },
-- 
2.7.4
