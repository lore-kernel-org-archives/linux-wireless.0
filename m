Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48724 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3DVSIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 14:08:23 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so362791qcs.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 11:08:22 -0700 (PDT)
From: Han Shen <shenhan@google.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	joe@perches.com, zajec5@gmail.com, shenhan@google.com
Subject: [PATCH] rtl8192c:dm: Properly initialize local array.
Date: Mon, 22 Apr 2013 11:08:02 -0700
Message-Id: <1366654089-31387-1-git-send-email-shenhan@google.com> (sfid-20130422_200828_036957_568B8263)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GCC 4.8 is spitting out uninitialized-varaible warnings against "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".
This trivial patch just adds initialization to the variable.

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

