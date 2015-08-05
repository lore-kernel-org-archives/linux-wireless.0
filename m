Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36615 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbbHEQSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 12:18:51 -0400
Received: by obnw1 with SMTP id w1so35261175obn.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 09:18:51 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih <pkshih@realtek.com>,
	shaofu <shaofu@realtek.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH V2 NEXT 2/7] rtlwifi: Fix programming of CAM content
Date: Wed,  5 Aug 2015 11:18:35 -0500
Message-Id: <1438791520-13216-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20150805_181855_448222_D9A14A06)
In-Reply-To: <1438791520-13216-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1438791520-13216-1-git-send-email-Larry.Finger@lwfinger.net>
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

