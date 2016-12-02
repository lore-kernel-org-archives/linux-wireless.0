Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32939 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753274AbcLBBst (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:49 -0500
Received: by mail-oi0-f66.google.com with SMTP id f201so25534724oib.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:49 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>, shaofu <shaofu@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 02/14] rtlwifi: Fix programing CAM content sequence.
Date: Thu,  1 Dec 2016 19:48:21 -0600
Message-Id: <20161202014833.6856-3-Larry.Finger@lwfinger.net> (sfid-20161202_025211_958752_7FFB4B23)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

There is a potential race condition when the control byte of a CAM
entry is written first. Write in reverse order to correct the condition.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/cam.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c b/drivers/net/wireless/realtek/rtlwifi/cam.c
index 8fe8b4c..5d58ec0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/cam.c
+++ b/drivers/net/wireless/realtek/rtlwifi/cam.c
@@ -45,12 +45,13 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 
 	u32 target_command;
 	u32 target_content = 0;
-	u8 entry_i;
+	s8 entry_i;
 
 	RT_PRINT_DATA(rtlpriv, COMP_SEC, DBG_DMESG, "Key content :",
 		      key_cont_128, 16);
 
-	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+	/* 0-1 config + mac, 2-5 fill 128key,6-7 are reserved */
+	for (entry_i = CAM_CONTENT_COUNT - 1; entry_i >= 0; entry_i--) {
 		target_command = entry_i + CAM_CONTENT_COUNT * entry_no;
 		target_command = target_command | BIT(31) | BIT(16);
 
@@ -102,7 +103,6 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 					target_content);
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
-			udelay(100);
 
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 				 "WRITE A4: %x\n", target_content);
-- 
2.10.2
