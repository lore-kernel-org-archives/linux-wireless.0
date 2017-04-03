Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33747 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752163AbdDCSlx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:41:53 -0400
Received: by mail-oi0-f68.google.com with SMTP id f193so21146805oib.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:41:53 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 03/12] rtlwifi: btcoex: 23b 2ant: add btc8723b2ant_limited_rx to reduce agg size
Date: Mon,  3 Apr 2017 13:41:33 -0500
Message-Id: <20170403184147.18409-3-Larry.Finger@lwfinger.net> (sfid-20170403_204217_677966_68270E60)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

For wifi and bt coexistence, if the aggregation size of wifi is too
large, the transmission time of the aggregated packet could be too long
and the bt packets might "cut off" the wifi packet. We need to reduce
the aggregation size to improve wifi performance.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - No changes.
v3 - No changes.
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 9b09b94cbb43..b182c61edf91 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -240,6 +240,29 @@ static u8 btc8723b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 	return wifi_rssi_state;
 }
 
+static
+void btc8723b2ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
+			     bool rej_ap_agg_pkt, bool bt_ctrl_agg_buf_size,
+			     u8 agg_buf_size)
+{
+	bool reject_rx_agg = rej_ap_agg_pkt;
+	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
+	u8 rx_agg_size = agg_buf_size;
+
+	/* ============================================ */
+	/*	Rx Aggregation related setting		*/
+	/* ============================================ */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_TO_REJ_AP_AGG_PKT,
+			   &reject_rx_agg);
+	/* decide BT control aggregation buf size or not */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_CTRL_AGG_SIZE,
+			   &bt_ctrl_rx_agg_size);
+	/* aggregate buf size, only work when BT control Rx aggregate size */
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_AGG_BUF_SIZE, &rx_agg_size);
+	/* real update aggregation setting */
+	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
+}
+
 static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -1266,6 +1289,8 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 		low_pwr_disable = false;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
+		btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC,
+					false, false, 0x8);
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi non-connected idle!!\n");
@@ -1288,6 +1313,8 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 			btcoexist->btc_set(btcoexist,
 					   BTC_SET_ACT_DISABLE_LOW_POWER,
 					   &low_pwr_disable);
+			btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC,
+						false, false, 0x8);
 
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Wifi connected + BT non connected-idle!!\n");
@@ -1317,6 +1344,8 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 				return false;
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Wifi connected + BT connected-idle!!\n");
+			btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC,
+						false, false, 0x8);
 
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x0);
@@ -1576,6 +1605,7 @@ static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
@@ -1623,6 +1653,7 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, true, 0x5);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
@@ -1701,6 +1732,7 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 	}
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
@@ -1746,6 +1778,7 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
@@ -1786,6 +1819,7 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
@@ -1835,6 +1869,7 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -1880,6 +1915,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
@@ -1935,6 +1971,8 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+
 	if (BTC_RSSI_HIGH(bt_rssi_state))
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
@@ -2000,6 +2038,7 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
@@ -2056,6 +2095,7 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
+	btc8723b2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-- 
2.12.0
