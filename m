Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35125 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752228AbdHHP7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 11:59:22 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org, petkan@nucleusys.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 17/35] wireless: ath: ath6kl: constify usb_device_id
Date: Tue,  8 Aug 2017 21:29:11 +0530
Message-Id: <1502207951-11692-2-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170808_180003_878348_54E04B17)
In-Reply-To: <1502207951-11692-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502207951-11692-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 9da3594..4defb7a 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1201,7 +1201,7 @@ static int ath6kl_usb_pm_resume(struct usb_interface *interface)
 #endif
 
 /* table of devices that work with this driver */
-static struct usb_device_id ath6kl_usb_ids[] = {
+static const struct usb_device_id ath6kl_usb_ids[] = {
 	{USB_DEVICE(0x0cf3, 0x9375)},
 	{USB_DEVICE(0x0cf3, 0x9374)},
 	{ /* Terminating entry */ },
-- 
2.7.4
