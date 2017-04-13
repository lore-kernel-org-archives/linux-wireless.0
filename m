Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34630 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755436AbdDMSHc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:32 -0400
Received: by mail-oi0-f65.google.com with SMTP id t14so4185786oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:31 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 17/19] rtlwifi: btcoex: 21a 2ant: action for wifi is idle/linking/common
Date: Thu, 13 Apr 2017 13:07:08 -0500
Message-Id: <20170413180710.19953-18-Larry.Finger@lwfinger.net> (sfid-20170413_202544_301613_55AC0574)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Depending on the state of wifi, we need to set different tdma and coex
table parameters to make wfi and bt coexist smoothly. Otherwise the
bt may have low sound quality or mouse lag, which mean bad user
experience. The same problem may occur on wifi also, if could disconnect
or lose some important packets.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 240 +++++++++++++--------
 1 file changed, 145 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index c0537d0268e6..f640f6079f9a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -1517,151 +1517,201 @@ static void btc8821a2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
-static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
+void btc8821a2ant_action_wifi_link_process(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool common = false, wifi_connected = false, wifi_busy = false;
-	bool low_pwr_disable = false;
+	u8 u8tmpa, u8tmpb;
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-			   &wifi_connected);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 15);
+	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
 
-	btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				0x5afa5afa, 0xffff, 0x3);
+	btc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
-	if (!wifi_connected &&
-	    BT_8821A_2ANT_BT_STATUS_IDLE == coex_dm->bt_status) {
-		low_pwr_disable = false;
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
+	u8tmpa = btcoexist->btc_read_1byte(btcoexist, 0x765);
+	u8tmpb = btcoexist->btc_read_1byte(btcoexist, 0x76e);
 
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi IPS + BT IPS!!\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], 0x765=0x%x, 0x76e=0x%x\n", u8tmpa, u8tmpb);
+}
 
-		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+static bool btc8821a2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 ap_num = 0;
 
-		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
-					   false);
-		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
-					   0x18);
+	wifi_rssi_state =
+		btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = btc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+			BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES - 20, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist,
+			2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
-		common = true;
-	} else if (wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_IDLE == coex_dm->bt_status)) {
-		low_pwr_disable = false;
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
 
-		if (wifi_busy) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi Busy + BT IPS!!\n");
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     false, 1);
-		} else {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi LPS + BT IPS!!\n");
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     false, 1);
-		}
+	/* define the office environment */
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && (coex_sta->hid_exist) &&
+	    (coex_sta->a2dp_exist)) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi  idle process for BT HID+A2DP exist!!\n");
 
-		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x6);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+		/* sw all off */
 		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
 					   false);
 		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
 					   0x18);
 
-		common = true;
-	} else if (!wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_CON_IDLE == coex_dm->bt_status)) {
-		low_pwr_disable = true;
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
-		btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
-					0x8);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
+		return true;
+	} else if (coex_sta->pan_exist) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi IPS + BT LPS!!\n");
+			 "[BTCoex], Wifi  idle process for BT PAN exist!!\n");
 
-		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x6);
 		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+		/* sw all off */
 		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
 					   false);
 		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
 					   0x18);
-		common = true;
-	} else if (wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_CON_IDLE == coex_dm->bt_status)) {
-		low_pwr_disable = true;
-		btcoexist->btc_set(btcoexist,
-			BTC_SET_ACT_DISABLE_LOW_POWER, &low_pwr_disable);
 
-		if (wifi_busy) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi Busy + BT LPS!!\n");
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     false, 1);
-		} else {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi LPS + BT LPS!!\n");
-			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					     false, 1);
-		}
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
-		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		return true;
+	}
+	btc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x18);
+	return false;
+}
 
-		btc8821a2ant_sw_mechanism1(btcoexist, true, true, true, true);
-		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
-					   0x18);
+static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool common = false, wifi_connected = false, wifi_busy = false;
+	bool low_pwr_disable = false;
+	bool bt_hs_on = false;
 
-		common = true;
-	} else if (!wifi_connected &&
-		   (coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_NON_IDLE)) {
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+
+	if (!wifi_connected) {
 		low_pwr_disable = false;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
+		btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
+					0x8);
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], Wifi IPS + BT Busy!!\n");
+			    "[BTCoex], Wifi non-connected idle!!\n");
 
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
+					  0x0);
+		btc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 		btc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 					      0x0, 0x0);
 		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-		btc8821a2ant_sw_mechanism1(btcoexist, false, false,
-					   false, false);
-		btc8821a2ant_sw_mechanism2(btcoexist, false, false,
-					   false, 0x18);
+		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
+					   false);
+		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					   0x18);
 
 		common = true;
 	} else {
-		low_pwr_disable = true;
-		btcoexist->btc_set(btcoexist,
-				   BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
+		if (BT_8821A_2ANT_BT_STATUS_IDLE ==
+		    coex_dm->bt_status) {
+			low_pwr_disable = false;
+			btcoexist->btc_set(btcoexist,
+					   BTC_SET_ACT_DISABLE_LOW_POWER,
+					   &low_pwr_disable);
+			btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC,
+						false, false, 0x8);
 
-		if (wifi_busy) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi Busy + BT Busy!!\n");
-			common = false;
-		} else {
+				 "[BTCoex], Wifi connected + BT non connected-idle!!\n");
+
+			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
+						  0xfffff, 0x0);
+			btc8821a2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 0);
+
+			btc8821a2ant_power_save_state(
+				btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+			btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+						      0xb);
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
+
+			common = true;
+		} else if (BT_8821A_2ANT_BT_STATUS_CON_IDLE ==
+			   coex_dm->bt_status) {
+			low_pwr_disable = true;
+			btcoexist->btc_set(btcoexist,
+					   BTC_SET_ACT_DISABLE_LOW_POWER,
+					   &low_pwr_disable);
+
+			if (bt_hs_on)
+				return false;
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Wifi LPS + BT Busy!!\n");
-			btc8821a2ant_ps_tdma(btcoexist,
-					     NORMAL_EXEC, true, 21);
+				 "[BTCoex], Wifi connected + BT connected-idle!!\n");
+			btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC,
+						false, false, 0x8);
+
+			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
+						  0xfffff, 0x0);
+			btc8821a2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 0);
+
+			btc8821a2ant_power_save_state(
+				btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+			btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+						      0xb);
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 			common = true;
+		} else {
+			low_pwr_disable = true;
+			btcoexist->btc_set(btcoexist,
+					   BTC_SET_ACT_DISABLE_LOW_POWER,
+					   &low_pwr_disable);
+
+			if (wifi_busy) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+				common = false;
+			} else {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+				common =
+				    btc8821a2ant_action_wifi_idle_process(
+					     btcoexist);
+			}
 		}
-		btc8821a2ant_sw_mechanism1(btcoexist, true, true, true, true);
 	}
 	return common;
 }
-- 
2.12.0
