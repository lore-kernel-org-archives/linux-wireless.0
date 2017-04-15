Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33424 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754878AbdDOUcN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 16:32:13 -0400
Received: by mail-oi0-f65.google.com with SMTP id t63so22231508oih.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Apr 2017 13:32:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 08/14] rtlwifi: btcoex: 21a 2ant: monitor extra wifi rssi to examine network status
Date: Sat, 15 Apr 2017 15:31:54 -0500
Message-Id: <20170415203200.22979-9-Larry.Finger@lwfinger.net> (sfid-20170415_223235_553540_A4FA7C47)
In-Reply-To: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
References: <20170415203200.22979-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Here we monitor one more wifi rssi to check the status of the network
and set the coex table instead of the legacy way.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 51 +++++++++-------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 4471bd66a2e5..b93a4f7ce17a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -2939,11 +2939,18 @@ static void btc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 
 static void btc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
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
+
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
@@ -2952,30 +2959,25 @@ static void btc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
 	else
 		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					0x5aff5aff, 0xffff, 0x3);
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 10);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
 	} else {
 		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 13);
 		btc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
 					      0x4);
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 1);
-		} else {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 5);
-		}
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 26);
+	else
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 26);
 
-		/* sw mechanism */
+	/* sw mechanism */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
@@ -2989,17 +2991,6 @@ static void btc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
 						   false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 1);
-		} else {
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     true, 5);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
-- 
2.12.0
