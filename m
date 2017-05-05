Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36163 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbdEEQRX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 May 2017 12:17:23 -0400
Received: by mail-io0-f195.google.com with SMTP id x86so2437421ioe.3
        for <linux-wireless@vger.kernel.org>; Fri, 05 May 2017 09:17:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 02/10] rtlwifi: btcoex: 21a 2ant: refine btc8821a2ant_action_hid_a2dp
Date: Fri,  5 May 2017 11:17:04 -0500
Message-Id: <20170505161712.8685-3-Larry.Finger@lwfinger.net> (sfid-20170505_181914_950374_AFACD205)
In-Reply-To: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
References: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For hid a2dp profiling, decrease the bt power because of the distance of
bt is usually short, and do not adjust the wifi duration to a longer
period since it may be interrupted by bt easily, set tdma instead.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - resubmit after removal of BT_AUTO_REPORT_XXXX symbols.
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 108 ++++++++-------------
 1 file changed, 42 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index a0f2eb53a011..60386c7571e8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -3295,19 +3295,46 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state, bt_info_ext;
 	u32 wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 ap_num = 0;
 
-	bt_info_ext = coex_sta->bt_info_ext;
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
-	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state1 = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+				BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+				3, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 37);
 
-	if (BTC_RSSI_HIGH(bt_rssi_state))
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, true, 0x5);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
+		if (BTC_RSSI_HIGH(bt_rssi_state))
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		else if (BTC_RSSI_MEDIUM(bt_rssi_state))
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		else
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+	} else {
+		/* only 802.11N mode we have to dec bt power to 4 degree */
+		if (BTC_RSSI_HIGH(bt_rssi_state)) {
+			btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+					   &ap_num);
+			if (ap_num < 10)
+				btc8821a2ant_dec_bt_pwr(btcoexist,
+							NORMAL_EXEC, 4);
+			else
+				btc8821a2ant_dec_bt_pwr(btcoexist,
+							NORMAL_EXEC, 2);
+		} else if (BTC_RSSI_MEDIUM(bt_rssi_state)) {
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		} else {
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		}
+	}
 
 	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
 		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
@@ -3319,36 +3346,15 @@ static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 					      0x4);
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext & BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-			}
-		} else {
-			if (bt_info_ext & BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-			}
-		}
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	} else {
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	}
 
-		/* sw mechanism */
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
@@ -3362,36 +3368,6 @@ static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 						   false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext & BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-			}
-		} else {
-			if (bt_info_ext & BIT0) {
-				/*a2dp basic rate*/
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-			} else {
-				/*a2dp edr rate*/
-				btc8821a2ant_tdma_duration_adjust(btcoexist,
-								  true, true,
-								  2);
-			}
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
-- 
2.12.2
