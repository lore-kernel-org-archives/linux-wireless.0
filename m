Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33982 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992459AbbHHQxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 12:53:50 -0400
Received: by oip136 with SMTP id 136so68063819oip.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2015 09:53:49 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V3 NEXT 2/7] rtlwifi: Fix programming of CAM content
Date: Sat,  8 Aug 2015 11:53:34 -0500
Message-Id: <1439052819-30196-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150808_185355_684740_EE4C8CBB)
In-Reply-To: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1439052819-30196-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: pkshih <pkshih@realtek.com>

There is a potential race condition when the control byte of a CAM entry
is written first.

Signed-off-by: pkshih <pkshih@realtek.com>
Signed-off-by: shaofu <shaofu@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
V2 - Removed a udelay() statement introduced because of a merge error
V3 - no changes

---
 drivers/net/wireless/rtlwifi/cam.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
 
-- 
2.1.4

