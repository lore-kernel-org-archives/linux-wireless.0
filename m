Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34014 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754308AbdDOUcP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:15 -0400
Received: by mail-oi0-f66.google.com with SMTP id t14so12826053oif.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:15 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 10/14] rtlwifi: btcoex: 21a 2ant: dec bt power according to bt rssi and set tdma
Date: Sat, 15 Apr 2017 15:31:56 -0500
Message-Id: <20170415203200.22979-11-Larry.Finger@lwfinger.net> (sfid-20170415_223232_489025_C8BF1860)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Check the bt rssi first and decrease it if the bt rssi is too high.
Then set the tdma and coex table.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 140 +++++++--------------
 1 file changed, 48 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 9e152117730c..626b73fd97a5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3009,28 +3009,31 @@ static void btc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
 /* PAN(HS) only */
 static void btc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
-	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state1 = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+				2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
 	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-		} else {
-			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-		}
-		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+	btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
-		/* sw mechanism */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
@@ -3044,22 +3047,6 @@ static void btc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 						   false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-		} else {
-			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-		}
-
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		} else {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
@@ -3078,12 +3065,18 @@ static void btc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 /* PAN(EDR)+A2DP */
 static void btc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
 
-	bt_info_ext = coex_sta->bt_info_ext;
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
-	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state1 = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+				2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
@@ -3092,44 +3085,32 @@ static void btc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	else
 		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state))
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	else
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
-		/* for HID at 11b/g mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5afa5afa, 0xffff, 0x3);
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 12);
+
+		if (wifi_bw == BTC_WIFI_BW_HT40)
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 3);
+		else
+			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							  false, 3);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5afa5afa, 0xffff, 0x3);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 13);
+		btc8821a2ant_tdma_duration_adjust(btcoexist, false, true, 3);
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, false, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, true, 3);
-			}
-		}
-
-		/* sw mechanism */
+	/* sw mechanism	 */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
@@ -3141,33 +3122,8 @@ static void btc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 						   false, false);
 			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
 						   false, 0x18);
-		};
-	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, false, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-							false, true, 3);
-			}
 		}
-
-		/* sw mechanism */
+	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
-- 
2.12.0
