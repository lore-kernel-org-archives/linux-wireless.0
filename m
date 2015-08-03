Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36475 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbbHCSyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 14:54:19 -0400
Received: by oibv126 with SMTP id v126so17642420oib.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2015 11:54:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH NEXT 2/7] rtlwifi: Fix programming of CAM content
Date: Mon,  3 Aug 2015 13:53:47 -0500
Message-Id: <1438628032-5865-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150803_205422_679515_C1649812)
In-Reply-To: <1438628032-5865-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438628032-5865-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: pkshih <pkshih@realtek.com>

There is a potential race condition when the control byte of a CAM entry
is written first.

Signed-off-by: pkshih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/cam.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/cam.c b/drivers/net/wireless/rtlwifi/cam.c
index 8fe8b4c..cc7acbf 100644
--- a/drivers/net/wireless/rtlwifi/cam.c
+++ b/drivers/net/wireless/rtlwifi/cam.c
@@ -45,12 +45,13 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 
 	u32 target_command;
 	u32 target_content = 0;
-	u8 entry_i;
+	s8 entry_i;
 
 	RT_PRINT_DATA(rtlpriv, COMP_SEC, DBG_DMESG, "Key content :",
 		      key_cont_128, 16);
 
-	for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {
+	/* 2-5 fill 128key,6-7 are reserved */
+	for (entry_i = CAM_CONTENT_COUNT - 3; entry_i >= 0; entry_i--) {
 		target_command = entry_i + CAM_CONTENT_COUNT * entry_no;
 		target_command = target_command | BIT(31) | BIT(16);
 
@@ -62,6 +63,7 @@ static void rtl_cam_program_entry(struct ieee80211_hw *hw, u32 entry_no,
 					target_content);
 			rtl_write_dword(rtlpriv, rtlpriv->cfg->maps[RWCAM],
 					target_command);
+			udelay(100);
 
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
 				 "WRITE %x: %x\n",
-- 
2.1.4

