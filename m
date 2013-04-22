Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:61083 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3DVUfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 16:35:19 -0400
Received: by mail-yh0-f74.google.com with SMTP id q10so737104yhf.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 13:35:19 -0700 (PDT)
From: Han Shen <shenhan@google.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	joe@perches.com, zajec5@gmail.com, shenhan@google.com
Subject: [PATCH v2] rtl8192c:dm: Properly initialize local array and set value.
Date: Mon, 22 Apr 2013 13:35:07 -0700
Message-Id: <1366662911-4143-1-git-send-email-shenhan@google.com> (sfid-20130422_223525_320430_17659645)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GCC 4.8 is spitting out uninitialized-variable warnings against
"drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".  This patch adds
initialization to the variable and properly sets its value.

Signed-off-by: Han Shen  (shenhan@google.com)

---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index b793a65..34150de 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -669,7 +669,7 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 	u8 thermalvalue, delta, delta_lck, delta_iqk;
 	long ele_a, ele_d, temp_cck, val_x, value32;
 	long val_y, ele_c = 0;
-	u8 ofdm_index[2], ofdm_index_old[2], cck_index_old = 0;
+	u8 ofdm_index[2], ofdm_index_old[2] = {0, 0}, cck_index_old = 0;
 	s8 cck_index = 0;
 	int i;
 	bool is2t = IS_92C_SERIAL(rtlhal->version);
@@ -717,7 +717,7 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 			for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
 				if (ele_d == (ofdmswing_table[i] &
 				    MASKOFDM_D)) {
-
+					ofdm_index_old[1] = (u8) i;
 					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
 						 DBG_LOUD,
 						 "Initial pathB ele_d reg0x%x = 0x%lx, ofdm_index=0x%x\n",
-- 
1.8.2.1

