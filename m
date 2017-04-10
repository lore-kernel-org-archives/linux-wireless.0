Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33698 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752528AbdDJQXW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:22 -0400
Received: by mail-oi0-f68.google.com with SMTP id t63so7881071oih.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:21 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 07/14] rtlwifi: btcoex: 21a 1ant: add multi port action for miracast and P2P
Date: Mon, 10 Apr 2017 11:23:03 -0500
Message-Id: <20170410162310.7515-8-Larry.Finger@lwfinger.net> (sfid-20170410_182341_730421_A812D8A0)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

To support miracast and P2P, the chip may operate under concurrent mode,
In this situation, do not aggregate tx packet and properly set the rx
aggregation size.

We detect it by monitoring the number of link established.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 67 ++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 5b374c7728ba..cadc0f91af41 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -1478,6 +1478,14 @@ static void btc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
  *	Non-Software Coex Mechanism start
  *
  ***********************************************/
+static
+void btc8821a1ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
+{
+	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+}
+
 
 static void btc8821a1ant_action_hs(struct btc_coexist *btcoexist)
 {
@@ -1820,6 +1828,8 @@ static void btc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	bool bt_ctrl_agg_buf_size = false;
 	u8 agg_buf_size = 5;
 	u8 wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
 	bool wifi_under_5g = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -1862,6 +1872,18 @@ static void btc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
 
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if ((num_of_wifi_link >= 2) ||
+	    (wifi_link_status & WIFI_P2P_GO_CONNECTED)) {
+		btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		btc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					bt_ctrl_agg_buf_size, agg_buf_size);
+		btc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
+
 	if (!bt_link_info->sco_exist && !bt_link_info->hid_exist) {
 		btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
 	} else {
@@ -2337,6 +2359,10 @@ void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false, bt_hs_on = false;
+	bool bt_ctrl_agg_buf_size = false;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
+	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control ||
 	    btcoexist->stop_coex_dm ||
@@ -2350,6 +2376,17 @@ void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 
 	btc8821a1ant_query_bt_info(btcoexist);
 
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if (num_of_wifi_link >= 2) {
+		btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		btc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					bt_ctrl_agg_buf_size, agg_buf_size);
+		btc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
+
 	if (coex_sta->c2h_bt_inquiry_page) {
 		btc8821a1ant_action_bt_inquiry(btcoexist);
 		return;
@@ -2384,12 +2421,27 @@ void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool	wifi_connected = false, bt_hs_on = false;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
+	bool bt_ctrl_agg_buf_size = false;
+	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control ||
 	    btcoexist->stop_coex_dm ||
 	    btcoexist->bt_info.bt_disabled)
 		return;
 
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if (num_of_wifi_link >= 2) {
+		btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		btc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					bt_ctrl_agg_buf_size, agg_buf_size);
+		btc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
+
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
 		btc8821a1ant_action_bt_inquiry(btcoexist);
@@ -2472,6 +2524,10 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool bt_hs_on = false;
+	bool bt_ctrl_agg_buf_size = false;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
+	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control ||
 	    btcoexist->stop_coex_dm ||
@@ -2480,6 +2536,17 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 
 	coex_sta->special_pkt_period_cnt = 0;
 
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if (num_of_wifi_link >= 2) {
+		btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		btc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					bt_ctrl_agg_buf_size, agg_buf_size);
+		btc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
+
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
 		btc8821a1ant_action_bt_inquiry(btcoexist);
-- 
2.12.0
