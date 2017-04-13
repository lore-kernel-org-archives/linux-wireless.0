Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36738 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755320AbdDMSHZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:25 -0400
Received: by mail-oi0-f65.google.com with SMTP id b187so13576439oif.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 10/19] rtlwifi: btcoex: 21a 2ant: centralized control of coex table
Date: Thu, 13 Apr 2017 13:07:01 -0500
Message-Id: <20170413180710.19953-11-Larry.Finger@lwfinger.net> (sfid-20170413_200803_480071_34BAB263)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Gather multiple coex table settings into a function coex_table_with_type()
and control the coex table according the type value as put in
switch-case expression.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 116 +++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   2 +
 2 files changed, 99 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 77916ae3d043..4d69955fbebc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -856,6 +856,89 @@ static void btc8821a2ant_coex_table(struct btc_coexist *btcoexist,
 	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
 }
 
+static void btc8821a2ant_coex_table_with_type(struct btc_coexist *btcoexist,
+					      bool force_exec, u8 type)
+{
+	coex_sta->coex_table_type = type;
+
+	switch (type) {
+	case 0:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0x55555555, 0xffffff, 0x3);
+		break;
+	case 1:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0x5afa5afa, 0xffffff, 0x3);
+		break;
+	case 2:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x5ada5ada,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 3:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0xaaaaaaaa,
+					0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 4:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0xffffffff,
+					0xffffffff, 0xffffff, 0x3);
+		break;
+	case 5:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					0x5fff5fff, 0xffffff, 0x3);
+		break;
+	case 6:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
+					0x5a5a5a5a, 0xffffff, 0x3);
+		break;
+	case 7:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 8:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 9:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 10:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 11:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 12:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 13:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 14:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 15:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 16:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0x5fdf5fdf,
+					0x5fdb5fdb, 0xffffff, 0x3);
+		break;
+	case 17:
+		btc8821a2ant_coex_table(btcoexist, force_exec, 0xfafafafa,
+					0xfafafafa, 0xffffff, 0x3);
+		break;
+	default:
+		break;
+	}
+}
+
 static void btc8821a2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoex,
 						bool enable)
 {
@@ -1234,8 +1317,7 @@ static void btc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
 	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
 	/* hw all off */
-	btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-				0x55555555, 0x55555555, 0xffff, 0x3);
+	btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
 static void btc8821a2ant_coex_under_5g(struct btc_coexist *btcoexist)
@@ -1246,8 +1328,7 @@ static void btc8821a2ant_coex_under_5g(struct btc_coexist *btcoexist)
 static void btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	/* force to reset coex mechanism */
-	btc8821a2ant_coex_table(btcoexist, FORCE_EXEC, 0x55555555,
-				0x55555555, 0xffff, 0x3);
+	btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 
 	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 	btc8821a2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
@@ -1736,12 +1817,10 @@ static void btc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 
 	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
 		/* for HID at 11b/g mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5a5a5a5a, 0xffff, 0x3);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 	} else {
 		/* for HID quality & wifi performance balance at 11n mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5aea5aea, 0xffff, 0x3);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	}
 
 	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
@@ -1933,9 +2012,9 @@ static void btc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
 		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
 					0x5aff5aff, 0xffff, 0x3);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5aff5aff, 0xffff, 0x3);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 13);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
 	}
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
@@ -2317,13 +2396,13 @@ static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
-		/* for HID at 11b/g mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5f5b5f5b, 0xffffff, 0x3);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5f5b5f5b, 0xffffff, 0x3);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 14);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
 	}
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
@@ -2496,8 +2575,7 @@ void ex_btc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	btc8821a2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN, true, false);
 
 	/* PTA parameter */
-	btc8821a2ant_coex_table(btcoexist, FORCE_EXEC, 0x55555555, 0x55555555,
-				0xffff, 0x3);
+	btc8821a2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
 	/* Enable counter statistics */
 	/*0x76e[3] = 1, WLAN_Act control by PTA*/
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index 804b5b95cab0..6db96cf44034 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -155,6 +155,8 @@ struct coex_sta_8821a_2ant {
 	u32	crc_err_11g;
 	u32	crc_err_11n;
 	u32	crc_err_11n_agg;
+
+	u8	coex_table_type;
 	bool	force_lps_on;
 };
 
-- 
2.12.0
