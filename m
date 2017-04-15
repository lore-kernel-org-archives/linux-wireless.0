Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34981 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754522AbdDOUcK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:10 -0400
Received: by mail-oi0-f68.google.com with SMTP id a21so5610663oic.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>
Subject: [PATCH 04/14] rtlwifi: btcoex: 21a 2ant: more combinations of wifi/bt rssi state
Date: Sat, 15 Apr 2017 15:31:50 -0500
Message-Id: <20170415203200.22979-5-Larry.Finger@lwfinger.net> (sfid-20170415_223222_926196_2664F853)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For bt a2dp, we need to check more rssi state combinations to have
better voice quality.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 97 +++++++++++++++-------
 1 file changed, 65 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 8437f1b6c108..62c3556e83b5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -2771,36 +2771,80 @@ static void btc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
 static void btc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 ap_num = 0;
 	u32 wifi_bw;
 
-	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-						       15, 0);
-	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
-	/* fw dac swing is called in btc8821a2ant_tdma_duration_adjust()
-	 * btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	 */
+	if ((ap_num >= 10) && BTC_RSSI_HIGH(wifi_rssi_state1) &&
+	    BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
 
-	if (BTC_RSSI_HIGH(bt_rssi_state))
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
+					  0x0);
+		btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
+					0x8);
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
-							  false, 1);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+
+		/* sw mechanism */
+		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+		if (wifi_bw == BTC_WIFI_BW_HT40) {
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   true, 0x6);
 		} else {
-			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
-							  true, 1);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   true, 0x6);
 		}
+		return;
+	}
 
-		/* sw mechanism */
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 13);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
+
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	} else {
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	}
+
+	/* sw mechanism */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
@@ -2814,17 +2858,6 @@ static void btc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 						   false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
-							  false, 1);
-		} else {
-			btc8821a2ant_tdma_duration_adjust(btcoexist, false,
-							  true, 1);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
-- 
2.12.0
