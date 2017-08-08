Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:38274 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752668AbdHHQGQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 12:06:16 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 33/35] wireless: realtek: rtl8192cu: constify usb_device_id
Date: Tue,  8 Aug 2017 21:35:53 +0530
Message-Id: <1502208353-12447-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170808_180753_841661_90507D44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_device_id are not supposed to change at runtime. All functions
working with usb_device_id provided by <linux/usb.h> work with
const usb_device_id. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 96c923b..e673bc2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -275,7 +275,7 @@ static struct rtl_hal_cfg rtl92cu_hal_cfg = {
 #define USB_VENDER_ID_REALTEK		0x0bda
 
 /* 2010-10-19 DID_USB_V3.4 */
-static struct usb_device_id rtl8192c_usb_ids[] = {
+static const struct usb_device_id rtl8192c_usb_ids[] = {
 
 	/*=== Realtek demoboard ===*/
 	/* Default ID */
-- 
2.7.4
