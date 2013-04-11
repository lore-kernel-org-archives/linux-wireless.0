Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:60495 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab3DKSCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 14:02:54 -0400
Received: by mail-ia0-f202.google.com with SMTP id h8so444552iaa.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 11:02:53 -0700 (PDT)
From: Han Shen <shenhan@google.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	Han Shen <shenhan@google.com>
Subject: [PATCH] Fix uninitialized-variable warnings.
Date: Thu, 11 Apr 2013 11:02:27 -0700
Message-Id: <1365703360-19982-1-git-send-email-shenhan@google.com> (sfid-20130411_200300_083288_F8EF6995)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GCC 4.8 is spitting out uninitialized-varaible warnings against "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".
This trivial patch just adds initialization to the variable.

Signed-off-by: Han Shen  (shenhan@google.com)
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index b793a65..875e36f 100644
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
-- 
1.8.1.3

