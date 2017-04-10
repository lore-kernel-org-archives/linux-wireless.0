Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33734 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbdDJQX1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Apr 2017 12:23:27 -0400
Received: by mail-oi0-f67.google.com with SMTP id t63so7881577oih.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Apr 2017 09:23:27 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 13/14] rtlwifi: btcoex: 21a 1ant: do not switch antenna when wifi is under 5G channel
Date: Mon, 10 Apr 2017 11:23:09 -0500
Message-Id: <20170410162310.7515-14-Larry.Finger@lwfinger.net> (sfid-20170410_182338_053074_019CC9F9)
In-Reply-To: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
References: <20170410162310.7515-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is on a 5G channel, the 5G signal will not interfere bt 2.4G
signal, and they can transmit simultaneously, hence there is no need to
switch antenna between wifi and bt.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 64 +++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index eab04c2bdd3d..0509ffab9e6f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -44,6 +44,8 @@ static struct coex_dm_8821a_1ant glcoex_dm_8821a_1ant;
 static struct coex_dm_8821a_1ant *coex_dm = &glcoex_dm_8821a_1ant;
 static struct coex_sta_8821a_1ant glcoex_sta_8821a_1ant;
 static struct coex_sta_8821a_1ant *coex_sta = &glcoex_sta_8821a_1ant;
+static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
+						  u8 wifi_status);
 
 static const char *const glbt_info_src_8821a_1ant[] = {
 	  "BT Info[wifi fw]",
@@ -1588,7 +1590,8 @@ static void btc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 }
 
 static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
-						  u8 wifi_status) {
+						  u8 wifi_status)
+{
 	/* tdma and coex table */
 	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
 
@@ -2412,9 +2415,17 @@ void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 void ex_btc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_under_5g = false;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		btc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
 	if (BTC_IPS_ENTER == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2458,12 +2469,20 @@ void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false, bt_hs_on = false;
 	bool bt_ctrl_agg_buf_size = false;
+	bool wifi_under_5g = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
 	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		btc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
 	if (coex_sta->bt_disabled)
 		return;
@@ -2523,11 +2542,19 @@ void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
 	bool bt_ctrl_agg_buf_size = false;
+	bool wifi_under_5g = false;
 	u8 agg_buf_size = 5;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
 	    coex_sta->bt_disabled)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		btc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
 			   &wifi_link_status);
@@ -2575,10 +2602,18 @@ void ex_btc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
+	bool wifi_under_5g = false;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
 	    coex_sta->bt_disabled)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		btc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
 	if (BTC_MEDIA_CONNECT == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2622,6 +2657,7 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool bt_hs_on = false;
 	bool bt_ctrl_agg_buf_size = false;
+	bool wifi_under_5g = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
 	u8 agg_buf_size = 5;
@@ -2630,6 +2666,14 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	    coex_sta->bt_disabled)
 		return;
 
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		btc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
+
 	coex_sta->special_pkt_period_cnt = 0;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
@@ -2818,9 +2862,18 @@ void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 void ex_btc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_under_5g = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Halt notify\n");
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		btc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
+
 
 	btcoexist->stop_coex_dm = true;
 
@@ -2836,6 +2889,15 @@ void ex_btc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	bool wifi_under_5g = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		btc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Pnp notify\n");
-- 
2.12.0
