Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33098 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932465AbdDQALm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:42 -0400
Received: by mail-oi0-f66.google.com with SMTP id a189so588098oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:42 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 27/27] rtlwifi: btcoex: 23b 1ant: turn off ps and tdma mechanism when concurrent mode
Date: Sun, 16 Apr 2017 19:11:11 -0500
Message-Id: <20170417001111.29384-28-Larry.Finger@lwfinger.net> (sfid-20170417_021215_044952_E4762A48)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

When wifi is under concurrent mode, we can not distinguish if it is the
real PS or just a fake one by sending null data, so we turn it off
in case of miracast scenario.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 100 +++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  19 ++++
 2 files changed, 91 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 77481ec04e63..a34c5d4622c9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1738,6 +1738,8 @@ static void halbtc8723b1ant_action_wifi_multiport(struct btc_coexist *btcoexist)
 					 0x0, 0x0);
 
 	halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, NORMAL_EXEC,
+				     false, false);
 	halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 }
 
@@ -2147,12 +2149,15 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool wifi_connected = false, bt_hs_on = false;
+	bool wifi_connected = false, bt_hs_on = false, wifi_busy = false;
 	bool increase_scan_dev_num = false;
 	bool bt_ctrl_agg_buf_size = false;
+	bool miracast_plus_bt = false;
 	u8 agg_buf_size = 5;
+	u8 iot_peer = BTC_IOT_PEER_UNKNOWN;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
+	u32 wifi_bw;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], RunCoexistMechanism()===>\n");
@@ -2189,46 +2194,85 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_INC_SCAN_DEV_NUM,
 			   &increase_scan_dev_num);
-
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
 			   &wifi_link_status);
 	num_of_wifi_link = wifi_link_status >> 16;
-	if (num_of_wifi_link >= 2) {
-		halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+
+	if (num_of_wifi_link >= 2 ||
+	    wifi_link_status & WIFI_P2P_GO_CONNECTED) {
+		if (bt_link_info->bt_link_exist) {
+			halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC, 1, 1,
+						   0, 1);
+			miracast_plus_bt = true;
+		} else {
+			halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0,
+						   0, 0);
+			miracast_plus_bt = false;
+		}
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_MIRACAST_PLUS_BT,
+				   &miracast_plus_bt);
 		halbtc8723b1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
-					   bt_ctrl_agg_buf_size,
-					   agg_buf_size);
-		halbtc8723b1ant_action_wifi_multiport(btcoexist);
+					   bt_ctrl_agg_buf_size, agg_buf_size);
+
+		if ((bt_link_info->a2dp_exist || wifi_busy) &&
+		    (coex_sta->c2h_bt_inquiry_page))
+			halbtc8723b1ant_action_bt_inquiry(btcoexist);
+		else
+			halbtc8723b1ant_action_wifi_multiport(btcoexist);
+
 		return;
 	}
 
-	if (!bt_link_info->sco_exist && !bt_link_info->hid_exist) {
-		halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+	miracast_plus_bt = false;
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_MIRACAST_PLUS_BT,
+			   &miracast_plus_bt);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+
+	if (bt_link_info->bt_link_exist && wifi_connected) {
+		halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC, 1, 1, 0, 1);
+
+		btcoexist->btc_get(btcoexist, BTC_GET_U1_IOT_PEER, &iot_peer);
+
+		if (iot_peer != BTC_IOT_PEER_CISCO &&
+		    iot_peer != BTC_IOT_PEER_BROADCOM) {
+			if (bt_link_info->sco_exist)
+				halbtc8723b1ant_limited_rx(btcoexist,
+							   NORMAL_EXEC, false,
+							   false, 0x5);
+			else
+				halbtc8723b1ant_limited_rx(btcoexist,
+							   NORMAL_EXEC, false,
+							   false, 0x5);
+		} else {
+			if (bt_link_info->sco_exist) {
+				halbtc8723b1ant_limited_rx(btcoexist,
+							   NORMAL_EXEC, true,
+							   false, 0x5);
+			} else {
+				if (wifi_bw == BTC_WIFI_BW_HT40)
+					halbtc8723b1ant_limited_rx(
+						btcoexist, NORMAL_EXEC, false,
+						true, 0x10);
+				else
+					halbtc8723b1ant_limited_rx(
+						btcoexist, NORMAL_EXEC, false,
+						true, 0x8);
+			}
+		}
+
+		halbtc8723b1ant_sw_mechanism(btcoexist, true);
 	} else {
-		if (wifi_connected)
-			halbtc8723b1ant_limited_tx(btcoexist,
-						   NORMAL_EXEC, 1, 1, 1, 1);
-		else
-			halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC,
-						   0, 0, 0, 0);
-	}
+		halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
 
-	if (bt_link_info->sco_exist) {
-		bt_ctrl_agg_buf_size = true;
-		agg_buf_size = 0x3;
-	} else if (bt_link_info->hid_exist) {
-		bt_ctrl_agg_buf_size = true;
-		agg_buf_size = 0x5;
-	} else if (bt_link_info->a2dp_exist || bt_link_info->pan_exist) {
-		bt_ctrl_agg_buf_size = true;
-		agg_buf_size = 0x8;
-	}
-	halbtc8723b1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
-				   bt_ctrl_agg_buf_size, agg_buf_size);
+		halbtc8723b1ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
+					   0x5);
 
+		halbtc8723b1ant_sw_mechanism(btcoexist, false);
+	}
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	if (coex_sta->c2h_bt_inquiry_page) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index b6c814d1089a..4cfe00af1549 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -199,6 +199,24 @@ enum btc_wifi_pnp {
 	BTC_WIFI_PNP_MAX
 };
 
+enum btc_iot_peer {
+	BTC_IOT_PEER_UNKNOWN = 0,
+	BTC_IOT_PEER_REALTEK = 1,
+	BTC_IOT_PEER_REALTEK_92SE = 2,
+	BTC_IOT_PEER_BROADCOM = 3,
+	BTC_IOT_PEER_RALINK = 4,
+	BTC_IOT_PEER_ATHEROS = 5,
+	BTC_IOT_PEER_CISCO = 6,
+	BTC_IOT_PEER_MERU = 7,
+	BTC_IOT_PEER_MARVELL = 8,
+	BTC_IOT_PEER_REALTEK_SOFTAP = 9,
+	BTC_IOT_PEER_SELF_SOFTAP = 10, /* Self is SoftAP */
+	BTC_IOT_PEER_AIRGO = 11,
+	BTC_IOT_PEER_REALTEK_JAGUAR_BCUTAP = 12,
+	BTC_IOT_PEER_REALTEK_JAGUAR_CCUTAP = 13,
+	BTC_IOT_PEER_MAX,
+};
+
 enum btc_get_type {
 	/* type bool */
 	BTC_GET_BL_HS_OPERATION,
@@ -238,6 +256,7 @@ enum btc_get_type {
 	BTC_GET_U1_WIFI_HS_CHNL,
 	BTC_GET_U1_MAC_PHY_MODE,
 	BTC_GET_U1_AP_NUM,
+	BTC_GET_U1_IOT_PEER,
 
 	/* for 1Ant */
 	BTC_GET_U1_LPS_MODE,
-- 
2.12.0
