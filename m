Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38685 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752346AbdHHQEz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 12:04:55 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org, herton@canonical.com,
        htl10@users.sourceforge.net, Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 31/35] wireless: realtek: rtl8187: constify usb_device_id
Date: Tue,  8 Aug 2017 21:34:45 +0530
Message-Id: <1502208285-12342-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170808_180521_360523_34F4757A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
index 55198ac2..121b94f 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c
@@ -43,7 +43,7 @@ MODULE_AUTHOR("Larry Finger <Larry.Finger@lwfinger.net>");
 MODULE_DESCRIPTION("RTL8187/RTL8187B USB wireless driver");
 MODULE_LICENSE("GPL");
 
-static struct usb_device_id rtl8187_table[] = {
+static const struct usb_device_id rtl8187_table[] = {
 	/* Asus */
 	{USB_DEVICE(0x0b05, 0x171d), .driver_info = DEVICE_RTL8187},
 	/* Belkin */
-- 
2.7.4
