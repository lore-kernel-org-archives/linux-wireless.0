Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32967 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbdDQALS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 20:11:18 -0400
Received: by mail-oi0-f68.google.com with SMTP id a189so587134oib.0
        for <linux-wireless@vger.kernel.org>; Sun, 16 Apr 2017 17:11:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 02/27] rtlwifi: btcoex: 23b 1ant: rename and coding style modification.
Date: Sun, 16 Apr 2017 19:10:46 -0500
Message-Id: <20170417001111.29384-3-Larry.Finger@lwfinger.net> (sfid-20170417_021127_038000_5A65A458)
In-Reply-To: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
References: <20170417001111.29384-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Rename:
 * tdma_adj_type to ps_tdma_du_adj_type
 * wifiCentralChnl to wifi_central_chnl

Coding style:
 * move constant from right to left side in if-statement

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 88 +++++++++++-----------
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |  2 +-
 2 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 48b941e75e54..cece31ec33d5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -1065,7 +1065,7 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 		    coex_dm->cur_ps_tdma != 3 && coex_dm->cur_ps_tdma != 9) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 9);
-			coex_dm->tdma_adj_type = 9;
+			coex_dm->ps_tdma_du_adj_type = 9;
 
 			up = 0;
 			dn = 0;
@@ -1083,7 +1083,7 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
 
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
-		coex_dm->tdma_adj_type = 2;
+		coex_dm->ps_tdma_du_adj_type = 2;
 
 		up = 0;
 		dn = 0;
@@ -1162,19 +1162,19 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 			     (coex_dm->cur_ps_tdma == 2))) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 9);
-				coex_dm->tdma_adj_type = 9;
+				coex_dm->ps_tdma_du_adj_type = 9;
 			} else if (coex_dm->cur_ps_tdma == 1) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
+				coex_dm->ps_tdma_du_adj_type = 2;
 			} else if (coex_dm->cur_ps_tdma == 2) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 9);
-				coex_dm->tdma_adj_type = 9;
+				coex_dm->ps_tdma_du_adj_type = 9;
 			} else if (coex_dm->cur_ps_tdma == 9) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
+				coex_dm->ps_tdma_du_adj_type = 11;
 			}
 		} else if (result == 1) {
 			if ((BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
@@ -1182,19 +1182,19 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 			     (coex_dm->cur_ps_tdma == 2))) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 9);
-				coex_dm->tdma_adj_type = 9;
+				coex_dm->ps_tdma_du_adj_type = 9;
 			} else if (coex_dm->cur_ps_tdma == 11) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 9);
-				coex_dm->tdma_adj_type = 9;
+				coex_dm->ps_tdma_du_adj_type = 9;
 			} else if (coex_dm->cur_ps_tdma == 9) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
+				coex_dm->ps_tdma_du_adj_type = 2;
 			} else if (coex_dm->cur_ps_tdma == 2) {
 				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 1);
-				coex_dm->tdma_adj_type = 1;
+				coex_dm->ps_tdma_du_adj_type = 1;
 			}
 		} else {
 			/* if busy / idle change */
@@ -1207,7 +1207,7 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 		    coex_dm->cur_ps_tdma != 9 && coex_dm->cur_ps_tdma != 11) {
 			/* recover to previous adjust type */
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
-						coex_dm->tdma_adj_type);
+						coex_dm->ps_tdma_du_adj_type);
 		}
 	}
 }
@@ -1421,7 +1421,7 @@ btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 					 0x0, 0x0);
 
 	/* tdma and coex table */
-	if (BT_8723B_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
+	if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY) {
 		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 22);
@@ -1438,9 +1438,8 @@ btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 1);
 		}
-	} else if ((BT_8723B_1ANT_BT_STATUS_SCO_BUSY == coex_dm->bt_status) ||
-		   (BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY ==
-		    coex_dm->bt_status)){
+	} else if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_SCO_BUSY ||
+		   coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY){
 		btc8723b1ant_act_bt_sco_hid_only_busy(btcoexist,
 				BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
@@ -1476,7 +1475,7 @@ static void btc8723b1ant_action_wifi_conn_scan(struct btc_coexist *btcoexist)
 					 0x0, 0x0);
 
 	/* tdma and coex table */
-	if (BT_8723B_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
+	if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY) {
 		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 22);
@@ -1493,9 +1492,8 @@ static void btc8723b1ant_action_wifi_conn_scan(struct btc_coexist *btcoexist)
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 1);
 		}
-	} else if ((BT_8723B_1ANT_BT_STATUS_SCO_BUSY == coex_dm->bt_status) ||
-		   (BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY ==
-		    coex_dm->bt_status)) {
+	} else if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_SCO_BUSY ||
+		   coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY) {
 		btc8723b1ant_act_bt_sco_hid_only_busy(btcoexist,
 				BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
@@ -1566,7 +1564,7 @@ static void halbtc8723b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 	/* power save state */
 	if (!ap_enable &&
-	    BT_8723B_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status &&
+	    coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY &&
 	    !btcoexist->bt_link_info.hid_only) {
 		if (!wifi_busy && btcoexist->bt_link_info.a2dp_only)
 			halbtc8723b1ant_power_save_state(btcoexist,
@@ -1582,13 +1580,14 @@ static void halbtc8723b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	}
 	/* tdma and coex table */
 	if (!wifi_busy) {
-		if (BT_8723B_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
-			halbtc8723b1ant_action_wifi_connected_bt_acl_busy(btcoexist,
-				      BT_8723B_1ANT_WIFI_STATUS_CONNECTED_IDLE);
-		} else if ((BT_8723B_1ANT_BT_STATUS_SCO_BUSY ==
-						coex_dm->bt_status) ||
-			   (BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY ==
-						coex_dm->bt_status)) {
+		if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY) {
+			halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
+				btcoexist,
+				BT_8723B_1ANT_WIFI_STATUS_CONNECTED_IDLE);
+		} else if (coex_dm->bt_status ==
+				BT_8723B_1ANT_BT_STATUS_SCO_BUSY ||
+			   coex_dm->bt_status ==
+				BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY) {
 			btc8723b1ant_act_bt_sco_hid_only_busy(btcoexist,
 				     BT_8723B_1ANT_WIFI_STATUS_CONNECTED_IDLE);
 		} else {
@@ -1598,13 +1597,14 @@ static void halbtc8723b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 							     NORMAL_EXEC, 2);
 		}
 	} else {
-		if (BT_8723B_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
-			halbtc8723b1ant_action_wifi_connected_bt_acl_busy(btcoexist,
-				    BT_8723B_1ANT_WIFI_STATUS_CONNECTED_BUSY);
-		} else if ((BT_8723B_1ANT_BT_STATUS_SCO_BUSY ==
-			   coex_dm->bt_status) ||
-			   (BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY ==
-			    coex_dm->bt_status)) {
+		if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY) {
+			halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
+				btcoexist,
+				BT_8723B_1ANT_WIFI_STATUS_CONNECTED_BUSY);
+		} else if (coex_dm->bt_status ==
+				BT_8723B_1ANT_BT_STATUS_SCO_BUSY ||
+			   coex_dm->bt_status ==
+				BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY) {
 			btc8723b1ant_act_bt_sco_hid_only_busy(btcoexist,
 				    BT_8723B_1ANT_WIFI_STATUS_CONNECTED_BUSY);
 		} else {
@@ -1648,11 +1648,10 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		return;
 	}
 
-	if ((BT_8723B_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) ||
-	    (BT_8723B_1ANT_BT_STATUS_SCO_BUSY == coex_dm->bt_status) ||
-	    (BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY == coex_dm->bt_status)) {
+	if (coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_BUSY ||
+	    coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_SCO_BUSY ||
+	    coex_dm->bt_status == BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY)
 		increase_scan_dev_num = true;
-	}
 
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_INC_SCAN_DEV_NUM,
 			   &increase_scan_dev_num);
@@ -2269,7 +2268,7 @@ void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
-	u8 wifiCentralChnl;
+	u8 wifi_central_chnl;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
 	    btcoexist->bt_info.bt_disabled)
@@ -2284,12 +2283,11 @@ void ex_halbtc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 
 	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
-			   &wifiCentralChnl);
+			   &wifi_central_chnl);
 
-	if ((BTC_MEDIA_CONNECT == type) &&
-	    (wifiCentralChnl <= 14)) {
+	if (type == BTC_MEDIA_CONNECT && wifi_central_chnl <= 14) {
 		h2c_parameter[0] = 0x0;
-		h2c_parameter[1] = wifiCentralChnl;
+		h2c_parameter[1] = wifi_central_chnl;
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 		if (BTC_WIFI_BW_HT40 == wifi_bw)
 			h2c_parameter[2] = 0x30;
@@ -2384,8 +2382,8 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 				 "0x%02x, ", tmp_buf[i]);
 	}
 
-	if (BT_INFO_SRC_8723B_1ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0] */
+	if (rsp_source != BT_INFO_SRC_8723B_1ANT_WIFI_FW) {
+		coex_sta->bt_retry_cnt = /* [3:0] */
 			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
 		coex_sta->bt_rssi =
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
index 75f8094b7a34..786324783633 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -90,7 +90,7 @@ struct coex_dm_8723b_1ant {
 	u8 pre_ps_tdma;
 	u8 cur_ps_tdma;
 	u8 ps_tdma_para[5];
-	u8 tdma_adj_type;
+	u8 ps_tdma_du_adj_type;
 	bool auto_tdma_adjust;
 	bool pre_ps_tdma_on;
 	bool cur_ps_tdma_on;
-- 
2.12.0
