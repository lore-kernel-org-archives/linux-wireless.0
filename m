Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35629 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932299AbdDDQuf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 12:50:35 -0400
Received: by mail-oi0-f67.google.com with SMTP id d2so18373774oig.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 09:50:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 12/13] rtlwifi: btcoex: 23b 2ant: turn off antenna when rssi is too high/low
Date: Tue,  4 Apr 2017 11:50:05 -0500
Message-Id: <20170404165006.14329-13-Larry.Finger@lwfinger.net> (sfid-20170404_185047_458926_3D274118)
In-Reply-To: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
References: <20170404165006.14329-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For 2-antenna combo card, the signal of the neighbor antenna could be
over noise level and cause be severe interference. So we monitor the
rssi and turn off one of the antennas when the other is transmitting
and the rssi level is beyond a threshold.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 332 +++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   7 +
 2 files changed, 282 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 88cd28f..4fec175 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -369,6 +369,8 @@ static bool btc8723b2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 	static bool pre_bt_hs_on;
 	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
 	bool wifi_connected = false;
+	u8 wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+	u8 tmp;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
@@ -392,6 +394,15 @@ static bool btc8723b2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 			pre_bt_hs_on = bt_hs_on;
 			return true;
 		}
+
+		tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+				 coex_dm->switch_thres_offset;
+		wifi_rssi_state =
+		     btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, tmp, 0);
+
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_LOW))
+			return true;
 	}
 
 	return false;
@@ -1186,8 +1197,16 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	u8 wifi_rssi_state, bt_rssi_state;
 	s8 wifi_duration_adjust = 0x0;
 	u8 tdma_byte4_modify = 0x0;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn %s PS TDMA, type=%d\n",
@@ -1196,6 +1215,15 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 	coex_dm->cur_ps_tdma_on = turn_on;
 	coex_dm->cur_ps_tdma = type;
 
+	if (!(BTC_RSSI_HIGH(wifi_rssi_state) &&
+	      BTC_RSSI_HIGH(bt_rssi_state)) && turn_on) {
+		 /* for WiFi RSSI low or BT RSSI low */
+		type = type + 100;
+		coex_dm->is_switch_to_1dot5_ant = true;
+	} else {
+		coex_dm->is_switch_to_1dot5_ant = false;
+	}
+
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], bPrePsTdmaOn = %d, bCurPsTdmaOn = %d!!\n",
@@ -1346,6 +1374,12 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x15,
 						    0x03, 0x70, 0x90);
 			break;
+
+		case 23:
+		case 123:
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x35,
+						    0x03, 0x71, 0x10);
+			break;
 		case 71:
 			btc8723b2ant_set_fw_ps_tdma(
 				btcoexist, 0xe3, 0x3c + wifi_duration_adjust,
@@ -1367,6 +1401,37 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 				btcoexist, 0xd3, 0x2d + wifi_duration_adjust,
 				0x03, 0x70, 0x50 | tdma_byte4_modify);
 			break;
+		case 103:
+		case 107:
+		case 111:
+		case 115:
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x1c,
+						    0x03, 0x70,
+						    0x50 | tdma_byte4_modify);
+			break;
+		case 104:
+		case 108:
+		case 112:
+		case 116:
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x10,
+						    0x03, 0x70,
+						    0x50 | tdma_byte4_modify);
+			break;
+		case 109:
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x3c,
+						    0x03, 0xf1,
+						    0x90 | tdma_byte4_modify);
+			break;
+		case 121:
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x15,
+						    0x03, 0x70,
+						    0x90 | tdma_byte4_modify);
+			break;
+		case 22:
+		case 122:
+			btc8723b2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x35,
+						    0x03, 0x71, 0x11);
+			break;
 		}
 	} else {
 		/* disable PS tdma */
@@ -2634,17 +2699,25 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 /* SCO only or SCO+PAN(HS) */
 static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state;
+	u8 wifi_rssi_state, bt_rssi_state;
 	u32 wifi_bw;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(
+		btcoexist, 2, BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+					       coex_dm->switch_thres_offset,
+		0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
 	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if (BTC_WIFI_BW_LEGACY == wifi_bw)
@@ -2683,16 +2756,22 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 {
 	u8 wifi_rssi_state, bt_rssi_state;
 	u32 wifi_bw;
+	u8 tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
-	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, true, 0x5);
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if (wifi_bw == BTC_WIFI_BW_LEGACY)
@@ -2738,12 +2817,12 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 ap_num = 0;
+	u8 tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
-	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist,
-							1, 2, 40, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2, 40, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
 
@@ -2774,7 +2853,20 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 13);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
@@ -2808,18 +2900,37 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
 	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 13);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
 
 	btc8723b2ant_tdma_duration_adjust(btcoexist, false, true, 2);
 
@@ -2848,12 +2959,17 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2865,7 +2981,15 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 10);
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 10);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 13);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
@@ -2899,20 +3023,25 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 /* PAN(HS) only */
 static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
 	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-	    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
-		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
@@ -2944,12 +3073,17 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 /* PAN(EDR) + A2DP */
 static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2961,6 +3095,12 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state))
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	else
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -3001,12 +3141,17 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
-
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -3016,27 +3161,32 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 14);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
+
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 		if (BTC_WIFI_BW_HT40 == wifi_bw) {
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      3);
-			btc8723b2ant_coex_table_with_type(btcoexist,
-							  NORMAL_EXEC, 11);
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x780);
 		} else {
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      6);
-			btc8723b2ant_coex_table_with_type(btcoexist,
-							  NORMAL_EXEC, 7);
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x0);
 		}
 		btc8723b2ant_tdma_duration_adjust(btcoexist, true, false, 2);
 	} else {
 		btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 11);
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
 					  0x0);
 		btc8723b2ant_tdma_duration_adjust(btcoexist, true, true, 2);
@@ -3067,12 +3217,17 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 /* HID + A2DP + PAN(EDR) */
 static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, tmp, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -3084,9 +3239,18 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 14);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
+
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
@@ -3124,12 +3288,18 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
+	u8 ap_num = 0;
+	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
+			coex_dm->switch_thres_offset;
 
-	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
+	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist, 1, 2,
+							tmp, 0);
+	tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
+			 coex_dm->switch_thres_offset;
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 3, tmp, 37);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -3138,13 +3308,61 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
+		if (BTC_RSSI_HIGH(bt_rssi_state))
+			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		else if (BTC_RSSI_MEDIUM(bt_rssi_state))
+			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		else
+			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+	} else {
+		/* only 802.11N mode we have to dec bt power to 4 degree */
+		if (BTC_RSSI_HIGH(bt_rssi_state)) {
+			/* need to check ap Number of Not */
+			if (ap_num < 10)
+				btc8723b2ant_dec_bt_pwr(btcoexist,
+							NORMAL_EXEC, 4);
+			else
+				btc8723b2ant_dec_bt_pwr(btcoexist,
+							NORMAL_EXEC, 2);
+		} else if (BTC_RSSI_MEDIUM(bt_rssi_state)) {
+			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		} else {
+			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		}
+	}
 
-	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
-		btc8723b2ant_tdma_duration_adjust(btcoexist, true, false, 2);
-	else
-		btc8723b2ant_tdma_duration_adjust(btcoexist, true, true, 2);
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+	} else {
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 14);
+		btc8723b2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+					      0x4);
+	}
+
+	if (BTC_RSSI_HIGH(bt_rssi_state)) {
+		if (ap_num < 10)
+			btc8723b2ant_tdma_duration_adjust(btcoexist, true,
+							  false, 1);
+		else
+			btc8723b2ant_tdma_duration_adjust(btcoexist, true,
+							  false, 3);
+	} else {
+		btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 18);
+		btcoexist->btc_write_1byte(btcoexist, 0x456, 0x38);
+		btcoexist->btc_write_2byte(btcoexist, 0x42a, 0x0808);
+		btcoexist->btc_write_4byte(btcoexist, 0x430, 0x0);
+		btcoexist->btc_write_4byte(btcoexist, 0x434, 0x01010000);
+
+		if (ap_num < 10)
+			btc8723b2ant_tdma_duration_adjust(btcoexist, true,
+							  true, 1);
+		else
+			btc8723b2ant_tdma_duration_adjust(btcoexist, true,
+							  true, 3);
+	}
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index f5e091f..2c21134 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -41,6 +41,11 @@
 
 #define BTC_RSSI_COEX_THRESH_TOL_8723B_2ANT		2
 
+/* WiFi RSSI Threshold for 2-Ant TDMA/1-Ant PS-TDMA translation */
+#define BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES	42
+/* BT RSSI Threshold for 2-Ant TDMA/1-Ant PS-TDMA translation */
+#define BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES		46
+
 enum BT_INFO_SRC_8723B_2ANT {
 	BT_INFO_SRC_8723B_2ANT_WIFI_FW			= 0x0,
 	BT_INFO_SRC_8723B_2ANT_BT_RSP			= 0x1,
@@ -127,6 +132,8 @@ struct coex_dm_8723b_2ant {
 	u8 pre_rpwm;
 	u8 cur_rpwm;
 
+	bool is_switch_to_1dot5_ant;
+	u8 switch_thres_offset;
 	bool need_recover_0x948;
 	u16 backup_0x948;
 };
-- 
2.10.2
