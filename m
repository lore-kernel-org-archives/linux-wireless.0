Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37869 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbdHIQYu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 12:24:50 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org, petkan@nucleusys.com, chunkeey@googlemail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 04/20] carl9170: constify usb_device_id
Date: Wed,  9 Aug 2017 21:54:41 +0530
Message-Id: <1502295881-20936-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170809_182507_927548_021F081D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
changes in v2:
              Re-submitting wireless separately.

 drivers/net/wireless/ath/carl9170/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 99ab203..e7c3f3b 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -64,7 +64,7 @@ MODULE_ALIAS("arusb_lnx");
  * http://wireless.kernel.org/en/users/Drivers/ar9170/devices ),
  * whenever you add a new device.
  */
-static struct usb_device_id carl9170_usb_ids[] = {
+static const struct usb_device_id carl9170_usb_ids[] = {
 	/* Atheros 9170 */
 	{ USB_DEVICE(0x0cf3, 0x9170) },
 	/* Atheros TG121N */
-- 
2.7.4
