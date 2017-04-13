Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34374 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754811AbdDMSHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:07:17 -0400
Received: by mail-oi0-f66.google.com with SMTP id t14so4184254oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:07:16 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/19] rtlwifi: btcoex: 21a 2ant: limit rx aggregation size to avoid bt interrupt
Date: Thu, 13 Apr 2017 13:06:52 -0500
Message-Id: <20170413180710.19953-2-Larry.Finger@lwfinger.net> (sfid-20170413_200800_148591_7BAA60F9)
In-Reply-To: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
References: <20170413180710.19953-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Larger packets have higher opportunity to be interrupt by bt signal.
In order to shorten the transmission time, control the packet
aggregation size.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index f36dab9291b1..3e671d409e61 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -244,6 +244,27 @@ static u8 btc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 	return wifi_rssi_state;
 }
 
+static
+void btc8821a2ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
+			     bool rej_ap_agg_pkt, bool bt_ctrl_agg_buf_size,
+			     u8 agg_buf_size)
+{
+	bool reject_rx_agg = rej_ap_agg_pkt;
+	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
+	u8 rx_agg_size = agg_buf_size;
+
+	/* Rx Aggregation related setting */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_TO_REJ_AP_AGG_PKT,
+			   &reject_rx_agg);
+	/* decide BT control aggregation buf size or not */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_CTRL_AGG_SIZE,
+			   &bt_ctrl_rx_agg_size);
+	/* aggregation buf size, works when BT control Rx aggregation size */
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_AGG_BUF_SIZE, &rx_agg_size);
+	/* real update aggregation setting */
+	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
+}
+
 static void btc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -1141,6 +1162,8 @@ static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 		low_pwr_disable = true;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
+		btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
+					0x8);
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi IPS + BT LPS!!\n");
@@ -1447,6 +1470,7 @@ static void btc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 						       15, 0);
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
@@ -1526,6 +1550,7 @@ static void btc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
@@ -1816,6 +1841,7 @@ static void btc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
@@ -1959,6 +1985,7 @@ static void btc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
@@ -2038,6 +2065,7 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
+	btc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-- 
2.12.0
