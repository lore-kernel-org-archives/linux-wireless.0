Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36473 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdBAVJY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 16:09:24 -0500
Received: by mail-oi0-f65.google.com with SMTP id u143so31667372oif.3
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 13:09:24 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/7] rtlwifi: btcoexist: Convert halbtc8723b2ant.c to use standard debugging
Date: Wed,  1 Feb 2017 15:08:54 -0600
Message-Id: <20170201210857.26516-5-Larry.Finger@lwfinger.net> (sfid-20170201_220944_286515_13F9D08C)
In-Reply-To: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
References: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routines in btcoexist use different debugging routines than are used
in the other drivers. This patch converts halbtc8723b2ant.c to use the
standard routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 973 +++++++++++----------
 1 file changed, 527 insertions(+), 446 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 5f488ec..c62957d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -58,9 +58,11 @@ static u32 glcoex_ver_8723b_2ant = 0x3f;
 /**************************************************************
  * local function start with btc8723b2ant_
  **************************************************************/
-static u8 btc8723b2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
+static u8 btc8723b2ant_bt_rssi_state(struct btc_coexist *btcoexist,
+				     u8 level_num, u8 rssi_thresh,
 				     u8 rssi_thresh1)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	s32 bt_rssi = 0;
 	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
@@ -72,28 +74,28 @@ static u8 btc8723b2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
 			if (bt_rssi >= rssi_thresh +
 				       BTC_RSSI_COEX_THRESH_TOL_8723B_2ANT) {
 				bt_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state switch to High\n");
 			} else {
 				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state stay at Low\n");
 			}
 		} else {
 			if (bt_rssi < rssi_thresh) {
 				bt_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state switch to Low\n");
 			} else {
 				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state stay at High\n");
 			}
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "[BTCoex], BT Rssi thresh error!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT Rssi thresh error!!\n");
 			return coex_sta->pre_bt_rssi_state;
 		}
 
@@ -102,12 +104,12 @@ static u8 btc8723b2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
 			if (bt_rssi >= rssi_thresh +
 				       BTC_RSSI_COEX_THRESH_TOL_8723B_2ANT) {
 				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Medium\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state switch to Medium\n");
 			} else {
 				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state stay at Low\n");
 			}
 		} else if ((coex_sta->pre_bt_rssi_state ==
 						BTC_RSSI_STATE_MEDIUM) ||
@@ -116,26 +118,26 @@ static u8 btc8723b2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
 			if (bt_rssi >= rssi_thresh1 +
 				       BTC_RSSI_COEX_THRESH_TOL_8723B_2ANT) {
 				bt_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state switch to High\n");
 			} else if (bt_rssi < rssi_thresh) {
 				bt_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state switch to Low\n");
 			} else {
 				bt_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at Medium\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state stay at Medium\n");
 			}
 		} else {
 			if (bt_rssi < rssi_thresh1) {
 				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Medium\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state switch to Medium\n");
 			} else {
 				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Rssi state stay at High\n");
 			}
 		}
 	}
@@ -149,6 +151,7 @@ static u8 btc8723b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 				       u8 index, u8 level_num,
 				       u8 rssi_thresh, u8 rssi_thresh1)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	s32 wifi_rssi = 0;
 	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
@@ -162,28 +165,28 @@ static u8 btc8723b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 			if (wifi_rssi >= rssi_thresh +
 					 BTC_RSSI_COEX_THRESH_TOL_8723B_2ANT) {
 				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state switch to High\n");
 			} else {
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state stay at Low\n");
 			}
 		} else {
 			if (wifi_rssi < rssi_thresh) {
 				wifi_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state switch to Low\n");
 			} else {
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state stay at High\n");
 			}
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-				    "[BTCoex], wifi RSSI thresh error!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], wifi RSSI thresh error!!\n");
 			return coex_sta->pre_wifi_rssi_state[index];
 		}
 
@@ -194,12 +197,12 @@ static u8 btc8723b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 			if (wifi_rssi >= rssi_thresh +
 					BTC_RSSI_COEX_THRESH_TOL_8723B_2ANT) {
 				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Medium\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state switch to Medium\n");
 			} else {
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state stay at Low\n");
 			}
 		} else if ((coex_sta->pre_wifi_rssi_state[index] ==
 						BTC_RSSI_STATE_MEDIUM) ||
@@ -208,26 +211,26 @@ static u8 btc8723b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 			if (wifi_rssi >= rssi_thresh1 +
 					 BTC_RSSI_COEX_THRESH_TOL_8723B_2ANT) {
 				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state switch to High\n");
 			} else if (wifi_rssi < rssi_thresh) {
 				wifi_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Low\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state switch to Low\n");
 			} else {
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at Medium\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state stay at Medium\n");
 			}
 		} else {
 			if (wifi_rssi < rssi_thresh1) {
 				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Medium\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state switch to Medium\n");
 			} else {
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at High\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], wifi RSSI state stay at High\n");
 			}
 		}
 	}
@@ -239,6 +242,7 @@ static u8 btc8723b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 
 static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0;
 	u32 reg_lp_tx = 0, reg_lp_rx = 0;
@@ -259,12 +263,12 @@ static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	coex_sta->low_priority_tx = reg_lp_tx;
 	coex_sta->low_priority_rx = reg_lp_rx;
 
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex], High Priority Tx/Rx(reg 0x%x)=0x%x(%d)/0x%x(%d)\n",
-		    reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex], Low Priority Tx/Rx(reg 0x%x)=0x%x(%d)/0x%x(%d)\n",
-		    reg_lp_txrx, reg_lp_tx, reg_lp_tx, reg_lp_rx, reg_lp_rx);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], High Priority Tx/Rx(reg 0x%x)=0x%x(%d)/0x%x(%d)\n",
+		 reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Low Priority Tx/Rx(reg 0x%x)=0x%x(%d)/0x%x(%d)\n",
+		 reg_lp_txrx, reg_lp_tx, reg_lp_tx, reg_lp_rx, reg_lp_rx);
 
 	/* reset counter */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
@@ -272,15 +276,16 @@ static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
 	h2c_parameter[0] |= BIT0;	/* trigger */
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
-		    h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
+		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
@@ -386,6 +391,7 @@ static void btc8723b2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 
 static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 	u8 algorithm = BT_8723B_2ANT_COEX_ALGO_UNDEFINED;
@@ -394,8 +400,8 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	if (!bt_link_info->bt_link_exist) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], No BT link exists!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], No BT link exists!!!\n");
 		return algorithm;
 	}
 
@@ -410,27 +416,29 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 
 	if (num_of_diff_profile == 1) {
 		if (bt_link_info->sco_exist) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], SCO only\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], SCO only\n");
 			algorithm = BT_8723B_2ANT_COEX_ALGO_SCO;
 		} else {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], HID only\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], HID only\n");
 				algorithm = BT_8723B_2ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], A2DP only\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], A2DP only\n");
 				algorithm = BT_8723B_2ANT_COEX_ALGO_A2DP;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], PAN(HS) only\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], PAN(HS) only\n");
 					algorithm =
 						BT_8723B_2ANT_COEX_ALGO_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], PAN(EDR) only\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], PAN(EDR) only\n");
 					algorithm =
 						BT_8723B_2ANT_COEX_ALGO_PANEDR;
 				}
@@ -439,21 +447,23 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 	} else if (num_of_diff_profile == 2) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], SCO + HID\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], SCO + HID\n");
 				algorithm = BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], SCO + A2DP ==> SCO\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], SCO + A2DP ==> SCO\n");
 				algorithm = BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], SCO + PAN(HS)\n");
 					algorithm = BT_8723B_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], SCO + PAN(EDR)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 				}
@@ -461,31 +471,35 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 		} else {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], HID + A2DP\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], HID + A2DP\n");
 				algorithm = BT_8723B_2ANT_COEX_ALGO_HID_A2DP;
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], HID + PAN(HS)\n");
 					algorithm = BT_8723B_2ANT_COEX_ALGO_HID;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], HID + PAN(EDR)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], A2DP + PAN(HS)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_A2DP_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex],A2DP + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex],A2DP + PAN(EDR)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_A2DP;
 				}
@@ -495,32 +509,36 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], SCO + HID + A2DP ==> HID\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], SCO + HID + A2DP ==> HID\n");
 				algorithm = BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + HID + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], SCO + HID + PAN(HS)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + HID + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], SCO + HID + PAN(EDR)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], SCO + A2DP + PAN(HS)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + A2DP + PAN(EDR) ==> HID\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], SCO + A2DP + PAN(EDR) ==> HID\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 				}
@@ -530,13 +548,15 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], HID + A2DP + PAN(HS)\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + A2DP + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], HID + A2DP + PAN(EDR)\n");
 					algorithm =
 					BT_8723B_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				}
@@ -548,11 +568,13 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], Error!!! SCO + HID + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], Error!!! SCO + HID + A2DP + PAN(HS)\n");
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
 					algorithm =
 					    BT_8723B_2ANT_COEX_ALGO_PANEDR_HID;
 				}
@@ -564,6 +586,7 @@ static u8 btc8723b2ant_action_algorithm(struct btc_coexist *btcoexist)
 
 static bool btc8723b_need_dec_pwr(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool ret = false;
 	bool bt_hs_on = false, wifi_connected = false;
 	s32 bt_hs_rssi = 0;
@@ -577,20 +600,20 @@ static bool btc8723b_need_dec_pwr(struct btc_coexist *btcoexist)
 	if (!btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi))
 		return false;
 
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 
 	if (wifi_connected) {
 		if (bt_hs_on) {
 			if (bt_hs_rssi > 37) {
-				btc_alg_dbg(ALGO_TRACE_FW,
-					    "[BTCoex], Need to decrease bt power for HS mode!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Need to decrease bt power for HS mode!!\n");
 				ret = true;
 			}
 		} else {
 			if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 			    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				btc_alg_dbg(ALGO_TRACE_FW,
-					    "[BTCoex], Need to decrease bt power for Wifi is connected!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Need to decrease bt power for Wifi is connected!!\n");
 				ret = true;
 			}
 		}
@@ -602,6 +625,7 @@ static bool btc8723b_need_dec_pwr(struct btc_coexist *btcoexist)
 static void btc8723b2ant_set_fw_dac_swing_level(struct btc_coexist *btcoexist,
 						u8 dac_swing_lvl)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	/* There are several type of dacswing
@@ -609,10 +633,10 @@ static void btc8723b2ant_set_fw_dac_swing_level(struct btc_coexist *btcoexist,
 	 */
 	h2c_parameter[0] = dac_swing_lvl;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Set Dac Swing Level=0x%x\n", dac_swing_lvl);
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x64=0x%x\n", h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Set Dac Swing Level=0x%x\n", dac_swing_lvl);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], FW write 0x64=0x%x\n", h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x64, 1, h2c_parameter);
 }
@@ -620,6 +644,7 @@ static void btc8723b2ant_set_fw_dac_swing_level(struct btc_coexist *btcoexist,
 static void btc8723b2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
 					   bool dec_bt_pwr)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	h2c_parameter[0] = 0;
@@ -627,8 +652,8 @@ static void btc8723b2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
 	if (dec_bt_pwr)
 		h2c_parameter[0] |= BIT1;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], decrease Bt Power : %s, FW write 0x62=0x%x\n",
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], decrease Bt Power : %s, FW write 0x62=0x%x\n",
 		    (dec_bt_pwr ? "Yes!!" : "No!!"), h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
@@ -637,14 +662,16 @@ static void btc8723b2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
 static void btc8723b2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 				    bool force_exec, bool dec_bt_pwr)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s Dec BT power = %s\n",
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s Dec BT power = %s\n",
 		    force_exec ? "force to" : "", dec_bt_pwr ? "ON" : "OFF");
 	coex_dm->cur_dec_bt_pwr = dec_bt_pwr;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], bPreDecBtPwr=%d, bCurDecBtPwr=%d\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreDecBtPwr=%d, bCurDecBtPwr=%d\n",
 			    coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
 
 		if (coex_dm->pre_dec_bt_pwr == coex_dm->cur_dec_bt_pwr)
@@ -658,14 +685,16 @@ static void btc8723b2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 static void btc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 fw_dac_swing_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s set FW Dac Swing level = %d\n",
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s set FW Dac Swing level = %d\n",
 		    (force_exec ? "force to" : ""), fw_dac_swing_lvl);
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], preFwDacSwingLvl=%d, curFwDacSwingLvl=%d\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], preFwDacSwingLvl=%d, curFwDacSwingLvl=%d\n",
 			    coex_dm->pre_fw_dac_swing_lvl,
 			    coex_dm->cur_fw_dac_swing_lvl);
 
@@ -682,18 +711,20 @@ static void btc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 static void btc8723b2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
 						 bool rx_rf_shrink_on)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (rx_rf_shrink_on) {
 		/* Shrink RF Rx LPF corner */
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], Shrink RF Rx LPF corner!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Shrink RF Rx LPF corner!!\n");
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
 					  0xfffff, 0xffffc);
 	} else {
 		/* Resume RF Rx LPF corner */
 		/* After initialized, we can use coex_dm->btRf0x1eBackup */
 		if (btcoexist->initilized) {
-			btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-				    "[BTCoex], Resume RF Rx LPF corner!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Resume RF Rx LPF corner!!\n");
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
 						  0xfffff,
 						  coex_dm->bt_rf0x1e_backup);
@@ -704,15 +735,17 @@ static void btc8723b2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
 static void btc8723b2ant_rf_shrink(struct btc_coexist *btcoexist,
 				   bool force_exec, bool rx_rf_shrink_on)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn Rx RF Shrink = %s\n",
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s turn Rx RF Shrink = %s\n",
 		    (force_exec ? "force to" : ""), (rx_rf_shrink_on ?
 						     "ON" : "OFF"));
 	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], bPreRfRxLpfShrink=%d, bCurRfRxLpfShrink=%d\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreRfRxLpfShrink=%d, bCurRfRxLpfShrink=%d\n",
 			    coex_dm->pre_rf_rx_lpf_shrink,
 			    coex_dm->cur_rf_rx_lpf_shrink);
 
@@ -729,6 +762,7 @@ static void btc8723b2ant_rf_shrink(struct btc_coexist *btcoexist,
 static void btc8723b_set_penalty_txrate(struct btc_coexist *btcoexist,
 					bool low_penalty_ra)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[6] = {0};
 
 	h2c_parameter[0] = 0x6;	/* opCode, 0x6= Retry_Penalty*/
@@ -742,9 +776,9 @@ static void btc8723b_set_penalty_txrate(struct btc_coexist *btcoexist,
 		h2c_parameter[5] = 0xf9;  /*MCS5 or OFDM36*/
 	}
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set WiFi Low-Penalty Retry: %s",
-		    (low_penalty_ra ? "ON!!" : "OFF!!"));
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set WiFi Low-Penalty Retry: %s",
+		 (low_penalty_ra ? "ON!!" : "OFF!!"));
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x69, 6, h2c_parameter);
 }
@@ -752,18 +786,20 @@ static void btc8723b_set_penalty_txrate(struct btc_coexist *btcoexist,
 static void btc8723b2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 					bool force_exec, bool low_penalty_ra)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	/*return; */
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn LowPenaltyRA = %s\n",
-		    (force_exec ? "force to" : ""), (low_penalty_ra ?
-						     "ON" : "OFF"));
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s turn LowPenaltyRA = %s\n",
+		 (force_exec ? "force to" : ""), (low_penalty_ra ?
+						  "ON" : "OFF"));
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], bPreLowPenaltyRa=%d, bCurLowPenaltyRa=%d\n",
-			    coex_dm->pre_low_penalty_ra,
-			    coex_dm->cur_low_penalty_ra);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreLowPenaltyRa=%d, bCurLowPenaltyRa=%d\n",
+			 coex_dm->pre_low_penalty_ra,
+			 coex_dm->cur_low_penalty_ra);
 
 		if (coex_dm->pre_low_penalty_ra == coex_dm->cur_low_penalty_ra)
 			return;
@@ -776,9 +812,11 @@ static void btc8723b2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 static void btc8723b2ant_set_dac_swing_reg(struct btc_coexist *btcoexist,
 					   u32 level)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 val = (u8) level;
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], Write SwDacSwing = 0x%x\n", level);
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Write SwDacSwing = 0x%x\n", level);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x883, 0x3e, val);
 }
 
@@ -796,20 +834,22 @@ static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
 				   bool force_exec, bool dac_swing_on,
 				   u32 dac_swing_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn DacSwing=%s, dac_swing_lvl=0x%x\n",
-		    (force_exec ? "force to" : ""),
-		    (dac_swing_on ? "ON" : "OFF"), dac_swing_lvl);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s turn DacSwing=%s, dac_swing_lvl=0x%x\n",
+		 (force_exec ? "force to" : ""),
+		 (dac_swing_on ? "ON" : "OFF"), dac_swing_lvl);
 	coex_dm->cur_dac_swing_on = dac_swing_on;
 	coex_dm->cur_dac_swing_lvl = dac_swing_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], bPreDacSwingOn=%d, preDacSwingLvl=0x%x, bCurDacSwingOn=%d, curDacSwingLvl=0x%x\n",
-			    coex_dm->pre_dac_swing_on,
-			    coex_dm->pre_dac_swing_lvl,
-			    coex_dm->cur_dac_swing_on,
-			    coex_dm->cur_dac_swing_lvl);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreDacSwingOn=%d, preDacSwingLvl=0x%x, bCurDacSwingOn=%d, curDacSwingLvl=0x%x\n",
+			 coex_dm->pre_dac_swing_on,
+			 coex_dm->pre_dac_swing_lvl,
+			 coex_dm->cur_dac_swing_on,
+			 coex_dm->cur_dac_swing_lvl);
 
 		if ((coex_dm->pre_dac_swing_on == coex_dm->cur_dac_swing_on) &&
 		    (coex_dm->pre_dac_swing_lvl == coex_dm->cur_dac_swing_lvl))
@@ -826,12 +866,13 @@ static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
 static void btc8723b2ant_set_agc_table(struct btc_coexist *btcoexist,
 				       bool agc_table_en)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 rssi_adjust_val = 0;
 
 	/*  BB AGC Gain Table */
 	if (agc_table_en) {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], BB Agc Table On!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BB Agc Table On!\n");
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6e1A0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6d1B0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x6c1C0001);
@@ -840,8 +881,8 @@ static void btc8723b2ant_set_agc_table(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x691F0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x68200001);
 	} else {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], BB Agc Table Off!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BB Agc Table Off!\n");
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xaa1A0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa91B0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa81C0001);
@@ -854,15 +895,15 @@ static void btc8723b2ant_set_agc_table(struct btc_coexist *btcoexist,
 	/* RF Gain */
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0xef, 0xfffff, 0x02000);
 	if (agc_table_en) {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], Agc Table On!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Agc Table On!\n");
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
 					  0xfffff, 0x38fff);
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
 					  0xfffff, 0x38ffe);
 	} else {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], Agc Table Off!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Agc Table Off!\n");
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
 					  0xfffff, 0x380c3);
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x3b,
@@ -873,15 +914,15 @@ static void btc8723b2ant_set_agc_table(struct btc_coexist *btcoexist,
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0xed, 0xfffff, 0x1);
 
 	if (agc_table_en) {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], Agc Table On!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Agc Table On!\n");
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
 					  0xfffff, 0x38fff);
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
 					  0xfffff, 0x38ffe);
 	} else {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], Agc Table Off!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Agc Table Off!\n");
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
 					  0xfffff, 0x380c3);
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x40,
@@ -899,17 +940,19 @@ static void btc8723b2ant_set_agc_table(struct btc_coexist *btcoexist,
 static void btc8723b2ant_agc_table(struct btc_coexist *btcoexist,
 				   bool force_exec, bool agc_table_en)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s %s Agc Table\n",
-		    (force_exec ? "force to" : ""),
-		    (agc_table_en ? "Enable" : "Disable"));
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s %s Agc Table\n",
+		 (force_exec ? "force to" : ""),
+		 (agc_table_en ? "Enable" : "Disable"));
 	coex_dm->cur_agc_table_en = agc_table_en;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], bPreAgcTableEn=%d, bCurAgcTableEn=%d\n",
-			    coex_dm->pre_agc_table_en,
-			    coex_dm->cur_agc_table_en);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreAgcTableEn=%d, bCurAgcTableEn=%d\n",
+			 coex_dm->pre_agc_table_en,
+			 coex_dm->cur_agc_table_en);
 
 		if (coex_dm->pre_agc_table_en == coex_dm->cur_agc_table_en)
 			return;
@@ -923,20 +966,22 @@ static void btc8723b2ant_set_coex_table(struct btc_coexist *btcoexist,
 					u32 val0x6c0, u32 val0x6c4,
 					u32 val0x6c8, u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c0=0x%x\n", val0x6c0);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6c0=0x%x\n", val0x6c0);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c0, val0x6c0);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c4=0x%x\n", val0x6c4);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6c4=0x%x\n", val0x6c4);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c4, val0x6c4);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c8=0x%x\n", val0x6c8);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6c8=0x%x\n", val0x6c8);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c8, val0x6c8);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6cc=0x%x\n", val0x6cc);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6cc=0x%x\n", val0x6cc);
 	btcoexist->btc_write_1byte(btcoexist, 0x6cc, val0x6cc);
 }
 
@@ -945,24 +990,26 @@ static void btc8723b2ant_coex_table(struct btc_coexist *btcoexist,
 				    u32 val0x6c4, u32 val0x6c8,
 				    u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s write Coex Table 0x6c0=0x%x, 0x6c4=0x%x, 0x6c8=0x%x, 0x6cc=0x%x\n",
-		    force_exec ? "force to" : "",
-		    val0x6c0, val0x6c4, val0x6c8, val0x6cc);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s write Coex Table 0x6c0=0x%x, 0x6c4=0x%x, 0x6c8=0x%x, 0x6cc=0x%x\n",
+		 force_exec ? "force to" : "",
+		 val0x6c0, val0x6c4, val0x6c8, val0x6cc);
 	coex_dm->cur_val0x6c0 = val0x6c0;
 	coex_dm->cur_val0x6c4 = val0x6c4;
 	coex_dm->cur_val0x6c8 = val0x6c8;
 	coex_dm->cur_val0x6cc = val0x6cc;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], preVal0x6c0=0x%x, preVal0x6c4=0x%x, preVal0x6c8=0x%x, preVal0x6cc=0x%x !!\n",
-			    coex_dm->pre_val0x6c0, coex_dm->pre_val0x6c4,
-			    coex_dm->pre_val0x6c8, coex_dm->pre_val0x6cc);
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], curVal0x6c0=0x%x, curVal0x6c4=0x%x, curVal0x6c8=0x%x, curVal0x6cc=0x%x !!\n",
-			    coex_dm->cur_val0x6c0, coex_dm->cur_val0x6c4,
-			    coex_dm->cur_val0x6c8, coex_dm->cur_val0x6cc);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], preVal0x6c0=0x%x, preVal0x6c4=0x%x, preVal0x6c8=0x%x, preVal0x6cc=0x%x !!\n",
+			 coex_dm->pre_val0x6c0, coex_dm->pre_val0x6c4,
+			 coex_dm->pre_val0x6c8, coex_dm->pre_val0x6cc);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], curVal0x6c0=0x%x, curVal0x6c4=0x%x, curVal0x6c8=0x%x, curVal0x6cc=0x%x !!\n",
+			 coex_dm->cur_val0x6c0, coex_dm->cur_val0x6c4,
+			 coex_dm->cur_val0x6c8, coex_dm->cur_val0x6cc);
 
 		if ((coex_dm->pre_val0x6c0 == coex_dm->cur_val0x6c0) &&
 		    (coex_dm->pre_val0x6c4 == coex_dm->cur_val0x6c4) &&
@@ -1043,14 +1090,15 @@ static void btc8723b_coex_tbl_type(struct btc_coexist *btcoexist,
 static void btc8723b2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 						bool enable)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	if (enable)
 		h2c_parameter[0] |= BIT0;/* function enable*/
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63=0x%x\n",
-		    h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63=0x%x\n",
+		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
@@ -1058,16 +1106,18 @@ static void btc8723b2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 static void btc8723b2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					 bool force_exec, bool enable)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s turn Ignore WlanAct %s\n",
-		    (force_exec ? "force to" : ""), (enable ? "ON" : "OFF"));
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s turn Ignore WlanAct %s\n",
+		 (force_exec ? "force to" : ""), (enable ? "ON" : "OFF"));
 	coex_dm->cur_ignore_wlan_act = enable;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], bPreIgnoreWlanAct = %d, bCurIgnoreWlanAct = %d!!\n",
-			    coex_dm->pre_ignore_wlan_act,
-			    coex_dm->cur_ignore_wlan_act);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreIgnoreWlanAct = %d, bCurIgnoreWlanAct = %d!!\n",
+			 coex_dm->pre_ignore_wlan_act,
+			 coex_dm->cur_ignore_wlan_act);
 
 		if (coex_dm->pre_ignore_wlan_act ==
 		    coex_dm->cur_ignore_wlan_act)
@@ -1081,6 +1131,7 @@ static void btc8723b2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 static void btc8723b2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[5];
 
 	h2c_parameter[0] = byte1;
@@ -1095,11 +1146,11 @@ static void btc8723b2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 	coex_dm->ps_tdma_para[3] = byte4;
 	coex_dm->ps_tdma_para[4] = byte5;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x60(5bytes)=0x%x%08x\n",
-		    h2c_parameter[0],
-		    h2c_parameter[1] << 24 | h2c_parameter[2] << 16 |
-		    h2c_parameter[3] << 8 | h2c_parameter[4]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], FW write 0x60(5bytes)=0x%x%08x\n",
+		 h2c_parameter[0],
+		 h2c_parameter[1] << 24 | h2c_parameter[2] << 16 |
+		 h2c_parameter[3] << 8 | h2c_parameter[4]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
@@ -1208,20 +1259,22 @@ static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
 static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 				 bool turn_on, u8 type)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s turn %s PS TDMA, type=%d\n",
-		    (force_exec ? "force to" : ""),
-		    (turn_on ? "ON" : "OFF"), type);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s turn %s PS TDMA, type=%d\n",
+		 (force_exec ? "force to" : ""),
+		 (turn_on ? "ON" : "OFF"), type);
 	coex_dm->cur_ps_tdma_on = turn_on;
 	coex_dm->cur_ps_tdma = type;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], bPrePsTdmaOn = %d, bCurPsTdmaOn = %d!!\n",
-			    coex_dm->pre_ps_tdma_on, coex_dm->cur_ps_tdma_on);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], prePsTdma = %d, curPsTdma = %d!!\n",
-			    coex_dm->pre_ps_tdma, coex_dm->cur_ps_tdma);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPrePsTdmaOn = %d, bCurPsTdmaOn = %d!!\n",
+			 coex_dm->pre_ps_tdma_on, coex_dm->cur_ps_tdma_on);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], prePsTdma = %d, curPsTdma = %d!!\n",
+			 coex_dm->pre_ps_tdma, coex_dm->cur_ps_tdma);
 
 		if ((coex_dm->pre_ps_tdma_on == coex_dm->cur_ps_tdma_on) &&
 		    (coex_dm->pre_ps_tdma == coex_dm->cur_ps_tdma))
@@ -1405,6 +1458,7 @@ static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 
 static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool common = false, wifi_connected = false;
 	bool wifi_busy = false;
 	bool bt_hs_on = false, low_pwr_disable = false;
@@ -1419,8 +1473,8 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
 
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi non-connected idle!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non-connected idle!!\n");
 
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
 					  0x0);
@@ -1443,8 +1497,8 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 					   BTC_SET_ACT_DISABLE_LOW_POWER,
 					   &low_pwr_disable);
 
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi connected + BT non connected-idle!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Wifi connected + BT non connected-idle!!\n");
 
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x0);
@@ -1470,8 +1524,8 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 			if (bt_hs_on)
 				return false;
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi connected + BT connected-idle!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Wifi connected + BT connected-idle!!\n");
 
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x0);
@@ -1495,15 +1549,15 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 					   &low_pwr_disable);
 
 			if (wifi_busy) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
 				common = false;
 			} else {
 				if (bt_hs_on)
 					return false;
 
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
 
 				btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A,
 							  0x1, 0xfffff, 0x0);
@@ -1539,10 +1593,12 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 static void set_tdma_int1(struct btc_coexist *btcoexist, bool tx_pause,
 			  s32 result)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	/* Set PS TDMA for max interval == 1 */
 	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 1\n");
 
 		if (coex_dm->cur_ps_tdma == 71) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
@@ -1638,8 +1694,8 @@ static void set_tdma_int1(struct btc_coexist *btcoexist, bool tx_pause,
 			}
 		}
 	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 0\n");
 		if (coex_dm->cur_ps_tdma == 5) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 71);
 			coex_dm->tdma_adj_type = 71;
@@ -1735,10 +1791,12 @@ static void set_tdma_int1(struct btc_coexist *btcoexist, bool tx_pause,
 static void set_tdma_int2(struct btc_coexist *btcoexist, bool tx_pause,
 			  s32 result)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	/* Set PS TDMA for max interval == 2 */
 	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 1\n");
 		if (coex_dm->cur_ps_tdma == 1) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 6);
 			coex_dm->tdma_adj_type = 6;
@@ -1819,8 +1877,8 @@ static void set_tdma_int2(struct btc_coexist *btcoexist, bool tx_pause,
 			}
 		}
 	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 0\n");
 		if (coex_dm->cur_ps_tdma == 5) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
 			coex_dm->tdma_adj_type = 2;
@@ -1906,10 +1964,12 @@ static void set_tdma_int2(struct btc_coexist *btcoexist, bool tx_pause,
 static void set_tdma_int3(struct btc_coexist *btcoexist, bool tx_pause,
 			  s32 result)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	/* Set PS TDMA for max interval == 3 */
 	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 1\n");
 		if (coex_dm->cur_ps_tdma == 1) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 7);
 			coex_dm->tdma_adj_type = 7;
@@ -1990,8 +2050,8 @@ static void set_tdma_int3(struct btc_coexist *btcoexist, bool tx_pause,
 			}
 		}
 	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 0\n");
 		if (coex_dm->cur_ps_tdma == 5) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 			coex_dm->tdma_adj_type = 3;
@@ -2078,18 +2138,19 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					  bool sco_hid, bool tx_pause,
 					  u8 max_interval)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static s32 up, dn, m, n, wait_count;
 	/*0: no change, +1: increase WiFi duration, -1: decrease WiFi duration*/
 	s32 result;
 	u8 retry_count = 0;
 
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], TdmaDurationAdjust()\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], TdmaDurationAdjust()\n");
 
 	if (!coex_dm->auto_tdma_adjust) {
 		coex_dm->auto_tdma_adjust = true;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], first run TdmaDurationAdjust()!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
 		if (sco_hid) {
 			if (tx_pause) {
 				if (max_interval == 1) {
@@ -2193,11 +2254,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 	} else {
 		/*accquire the BT TRx retry count from BT_Info byte2*/
 		retry_count = coex_sta->bt_retry_cnt;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], retry_count = %d\n", retry_count);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], up=%d, dn=%d, m=%d, n=%d, wait_count=%d\n",
-			    up, dn, m, n, wait_count);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], retry_count = %d\n", retry_count);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], up=%d, dn=%d, m=%d, n=%d, wait_count=%d\n",
+			 up, dn, m, n, wait_count);
 		result = 0;
 		wait_count++;
 		 /* no retry in the last 2-second duration*/
@@ -2214,8 +2275,8 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				up = 0;
 				dn = 0;
 				result = 1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex], Increase wifi duration!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Increase wifi duration!!\n");
 			} /* <=3 retry in the last 2-second duration*/
 		} else if (retry_count <= 3) {
 			up--;
@@ -2238,8 +2299,8 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				dn = 0;
 				wait_count = 0;
 				result = -1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex], Decrease wifi duration for retry_counter<3!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Decrease wifi duration for retry_counter<3!!\n");
 			}
 		} else {
 			if (wait_count == 1)
@@ -2255,12 +2316,12 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 			dn = 0;
 			wait_count = 0;
 			result = -1;
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], Decrease wifi duration for retry_counter>3!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Decrease wifi duration for retry_counter>3!!\n");
 		}
 
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], max Interval = %d\n", max_interval);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], max Interval = %d\n", max_interval);
 		if (max_interval == 1)
 			set_tdma_int1(btcoexist, tx_pause, result);
 		else if (max_interval == 2)
@@ -2274,9 +2335,9 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 	 */
 	if (coex_dm->cur_ps_tdma != coex_dm->tdma_adj_type) {
 		bool scan = false, link = false, roam = false;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], PsTdma type dismatch!!!, curPsTdma=%d, recordPsTdma=%d\n",
-			    coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], PsTdma type dismatch!!!, curPsTdma=%d, recordPsTdma=%d\n",
+			 coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
@@ -2286,8 +2347,8 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
 					     coex_dm->tdma_adj_type);
 		else
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
 	}
 }
 
@@ -2357,7 +2418,7 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2422,7 +2483,7 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 						       0, 2, 15, 0);
 	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist,
 							1, 2, 40, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
 
@@ -2561,7 +2622,7 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2672,7 +2733,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2736,7 +2797,7 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if (btc8723b_need_dec_pwr(btcoexist))
@@ -2806,7 +2867,7 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2870,7 +2931,7 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(btcoexist, 2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2923,28 +2984,29 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 algorithm = 0;
 
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], RunCoexistMechanism()===>\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], RunCoexistMechanism()===>\n");
 
 	if (btcoexist->manual_control) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], RunCoexistMechanism(), return for Manual CTRL <===\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for Manual CTRL <===\n");
 		return;
 	}
 
 	if (coex_sta->under_ips) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], wifi is under IPS !!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under IPS !!!\n");
 		return;
 	}
 
 	algorithm = btc8723b2ant_action_algorithm(btcoexist);
 	if (coex_sta->c2h_bt_inquiry_page &&
 	    (BT_8723B_2ANT_COEX_ALGO_PANHS != algorithm)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BT is under inquiry/page scan !!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is under inquiry/page scan !!\n");
 		btc8723b2ant_action_bt_inquiry(btcoexist);
 		return;
 	} else {
@@ -2956,75 +3018,76 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	}
 
 	coex_dm->cur_algorithm = algorithm;
-	btc_alg_dbg(ALGO_TRACE, "[BTCoex], Algorithm = %d\n",
-		    coex_dm->cur_algorithm);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Algorithm = %d\n",
+		 coex_dm->cur_algorithm);
 
 	if (btc8723b2ant_is_common_action(btcoexist)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Action 2-Ant common\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Action 2-Ant common\n");
 		coex_dm->auto_tdma_adjust = false;
 	} else {
 		if (coex_dm->cur_algorithm != coex_dm->pre_algorithm) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], preAlgorithm=%d, curAlgorithm=%d\n",
-				    coex_dm->pre_algorithm,
-				    coex_dm->cur_algorithm);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], preAlgorithm=%d, curAlgorithm=%d\n",
+				 coex_dm->pre_algorithm,
+				 coex_dm->cur_algorithm);
 			coex_dm->auto_tdma_adjust = false;
 		}
 		switch (coex_dm->cur_algorithm) {
 		case BT_8723B_2ANT_COEX_ALGO_SCO:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = SCO\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = SCO\n");
 			btc8723b2ant_action_sco(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HID\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = HID\n");
 			btc8723b2ant_action_hid(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = A2DP\n");
 			btc8723b2ant_action_a2dp(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_A2DP_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
 			btc8723b2ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)\n");
 			btc8723b2ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HS mode\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = HS mode\n");
 			btc8723b2ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_PANEDR_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = PAN+A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = PAN+A2DP\n");
 			btc8723b2ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_PANEDR_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)+HID\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)+HID\n");
 			btc8723b2ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_HID_A2DP_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HID+A2DP+PAN\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = HID+A2DP+PAN\n");
 			btc8723b2ant_action_hid_a2dp_pan_edr(btcoexist);
 			break;
 		case BT_8723B_2ANT_COEX_ALGO_HID_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HID+A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = HID+A2DP\n");
 			btc8723b2ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = coexist All Off!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action 2-Ant, algorithm = coexist All Off!!\n");
 			btc8723b2ant_coex_alloff(btcoexist);
 			break;
 		}
@@ -3050,10 +3113,11 @@ static void btc8723b2ant_wifioff_hwcfg(struct btc_coexist *btcoexist)
  *********************************************************************/
 void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 u8tmp = 0;
 
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], 2Ant Init HW Config!!\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], 2Ant Init HW Config!!\n");
 	coex_dm->bt_rf0x1e_backup =
 		btcoexist->btc_get_rf_reg(btcoexist, BTC_RF_A, 0x1e, 0xfffff);
 
@@ -3078,8 +3142,10 @@ void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 
 void ex_btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], Coex Mechanism Init!!\n");
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Coex Mechanism Init!!\n");
 	btc8723b2ant_init_coex_dm(btcoexist);
 }
 
@@ -3101,13 +3167,13 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	u8 ap_num = 0;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n ============[BT Coexist info]============");
+		 "\r\n ============[BT Coexist info]============");
 
 	if (btcoexist->manual_control) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ==========[Under Manual Control]============");
+			 "\r\n ==========[Under Manual Control]============");
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ==========================================");
+			 "\r\n ==========================================");
 	}
 
 	if (!board_info->bt_exist) {
@@ -3116,21 +3182,21 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	}
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d ",
-		   "Ant PG number/ Ant mechanism:",
-		   board_info->pg_ant_num, board_info->btdm_ant_num);
+		 "Ant PG number/ Ant mechanism:",
+		 board_info->pg_ant_num, board_info->btdm_ant_num);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s / %d",
-		   "BT stack/ hci ext ver",
-		   ((stack_info->profile_notified) ? "Yes" : "No"),
-		   stack_info->hci_version);
+		 "BT stack/ hci ext ver",
+		 ((stack_info->profile_notified) ? "Yes" : "No"),
+		 stack_info->hci_version);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER, &bt_patch_ver);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d_%x/ 0x%x/ 0x%x(%d)",
-		   "CoexVer/ FwVer/ PatchVer",
-		   glcoex_ver_date_8723b_2ant, glcoex_ver_8723b_2ant,
-		   fw_ver, bt_patch_ver, bt_patch_ver);
+		 "\r\n %-35s = %d_%x/ 0x%x/ 0x%x(%d)",
+		 "CoexVer/ FwVer/ PatchVer",
+		 glcoex_ver_date_8723b_2ant, glcoex_ver_8723b_2ant,
+		 fw_ver, bt_patch_ver, bt_patch_ver);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_DOT11_CHNL,
@@ -3138,23 +3204,23 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL, &wifi_hs_chnl);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d(%d)",
-		   "Dot11 channel / HsChnl(HsMode)",
-		   wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
+		 "Dot11 channel / HsChnl(HsMode)",
+		 wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %3ph ",
-		   "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
+		 "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d",
-		   "Wifi rssi/ HS rssi/ AP#", wifi_rssi, bt_hs_rssi, ap_num);
+		 "Wifi rssi/ HS rssi/ AP#", wifi_rssi, bt_hs_rssi, ap_num);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d ",
-		   "Wifi link/ roam/ scan", link, roam, scan);
+		 "Wifi link/ roam/ scan", link, roam, scan);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
@@ -3162,112 +3228,112 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
 			   &wifi_traffic_dir);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s / %s/ %s ",
-		   "Wifi status", (wifi_under_5g ? "5G" : "2.4G"),
-		   ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
-		   (((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40" : "HT20"))),
-		   ((!wifi_busy) ? "idle" :
-		   ((BTC_WIFI_TRAFFIC_TX == wifi_traffic_dir) ?
-		   "uplink" : "downlink")));
+		 "Wifi status", (wifi_under_5g ? "5G" : "2.4G"),
+		 ((wifi_bw == BTC_WIFI_BW_LEGACY) ? "Legacy" :
+		 (((wifi_bw == BTC_WIFI_BW_HT40) ? "HT40" : "HT20"))),
+		 ((!wifi_busy) ? "idle" :
+		 ((wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX) ?
+		  "uplink" : "downlink")));
 
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d / %d / %d",
-		   "SCO/HID/PAN/A2DP",
-		   bt_link_info->sco_exist, bt_link_info->hid_exist,
-		   bt_link_info->pan_exist, bt_link_info->a2dp_exist);
+		 "SCO/HID/PAN/A2DP",
+		 bt_link_info->sco_exist, bt_link_info->hid_exist,
+		 bt_link_info->pan_exist, bt_link_info->a2dp_exist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_BT_LINK_INFO);
 
 	bt_info_ext = coex_sta->bt_info_ext;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s",
-		   "BT Info A2DP rate",
-		   (bt_info_ext&BIT0) ? "Basic rate" : "EDR rate");
+		 "BT Info A2DP rate",
+		 (bt_info_ext & BIT0) ? "Basic rate" : "EDR rate");
 
 	for (i = 0; i < BT_INFO_SRC_8723B_2ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %7ph(%d)",
-				   glbt_info_src_8723b_2ant[i],
-				   coex_sta->bt_info_c2h[i],
-				   coex_sta->bt_info_c2h_cnt[i]);
+				 "\r\n %-35s = %7ph(%d)",
+				 glbt_info_src_8723b_2ant[i],
+				 coex_sta->bt_info_c2h[i],
+				 coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s/%s",
-		   "PS state, IPS/LPS",
-		   ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
-		   ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")));
+		 "PS state, IPS/LPS",
+		 ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
+		 ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")));
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
 
 	/* Sw mechanism	*/
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s", "============[Sw mechanism]============");
+		 "\r\n %-35s", "============[Sw mechanism]============");
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d ",
-		   "SM1[ShRf/ LpRA/ LimDig]", coex_dm->cur_rf_rx_lpf_shrink,
-		   coex_dm->cur_low_penalty_ra, coex_dm->limited_dig);
+		 "SM1[ShRf/ LpRA/ LimDig]", coex_dm->cur_rf_rx_lpf_shrink,
+		 coex_dm->cur_low_penalty_ra, coex_dm->limited_dig);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d(0x%x) ",
-		   "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
-		   coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
-		   coex_dm->cur_dac_swing_on, coex_dm->cur_dac_swing_lvl);
+		 "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
+		 coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
+		 coex_dm->cur_dac_swing_on, coex_dm->cur_dac_swing_lvl);
 
 	/* Fw mechanism	*/
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
-		   "============[Fw mechanism]============");
+		 "============[Fw mechanism]============");
 
 	ps_tdma_case = coex_dm->cur_ps_tdma;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %5ph case-%d (auto:%d)",
-		   "PS TDMA", coex_dm->ps_tdma_para,
-		   ps_tdma_case, coex_dm->auto_tdma_adjust);
+		 "\r\n %-35s = %5ph case-%d (auto:%d)",
+		 "PS TDMA", coex_dm->ps_tdma_para,
+		 ps_tdma_case, coex_dm->auto_tdma_adjust);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d ",
-		   "DecBtPwr/ IgnWlanAct", coex_dm->cur_dec_bt_pwr,
-		   coex_dm->cur_ignore_wlan_act);
+		 "DecBtPwr/ IgnWlanAct", coex_dm->cur_dec_bt_pwr,
+		 coex_dm->cur_ignore_wlan_act);
 
 	/* Hw setting */
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
-		   "============[Hw setting]============");
+		 "============[Hw setting]============");
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x",
-		   "RF-A, 0x1e initVal", coex_dm->bt_rf0x1e_backup);
+		 "RF-A, 0x1e initVal", coex_dm->bt_rf0x1e_backup);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x880);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0x778/0x880[29:25]", u8tmp[0],
-		   (u32tmp[0]&0x3e000000) >> 25);
+		 "0x778/0x880[29:25]", u8tmp[0],
+		 (u32tmp[0] & 0x3e000000) >> 25);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x948);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x67);
 	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x765);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0x948/ 0x67[5] / 0x765",
-		   u32tmp[0], ((u8tmp[0]&0x20) >> 5), u8tmp[1]);
+		 "0x948/ 0x67[5] / 0x765",
+		 u32tmp[0], ((u8tmp[0] & 0x20) >> 5), u8tmp[1]);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x92c);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x930);
 	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x944);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0x92c[1:0]/ 0x930[7:0]/0x944[1:0]",
-		   u32tmp[0]&0x3, u32tmp[1]&0xff, u32tmp[2]&0x3);
+		 "0x92c[1:0]/ 0x930[7:0]/0x944[1:0]",
+		 u32tmp[0] & 0x3, u32tmp[1] & 0xff, u32tmp[2] & 0x3);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x39);
 	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x40);
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
 	u8tmp[2] = btcoexist->btc_read_1byte(btcoexist, 0x64);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
-		   "0x38[11]/0x40/0x4c[24:23]/0x64[0]",
-		   ((u8tmp[0] & 0x8)>>3), u8tmp[1],
-		   ((u32tmp[0]&0x01800000)>>23), u8tmp[2]&0x1);
+		 "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+		 "0x38[11]/0x40/0x4c[24:23]/0x64[0]",
+		 ((u8tmp[0] & 0x8) >> 3), u8tmp[1],
+		 ((u32tmp[0] & 0x01800000) >> 23), u8tmp[2] & 0x1);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0x550(bcn ctrl)/0x522", u32tmp[0], u8tmp[0]);
+		 "0x550(bcn ctrl)/0x522", u32tmp[0], u8tmp[0]);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x49c);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0xc50(dig)/0x49c(null-drop)", u32tmp[0]&0xff, u8tmp[0]);
+		 "0xc50(dig)/0x49c(null-drop)", u32tmp[0] & 0xff, u8tmp[0]);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xda0);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0xda4);
@@ -3286,24 +3352,24 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	fa_cck = (u8tmp[0] << 8) + u8tmp[1];
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "OFDM-CCA/OFDM-FA/CCK-FA",
-		   u32tmp[0]&0xffff, fa_ofdm, fa_cck);
+		 "OFDM-CCA/OFDM-FA/CCK-FA",
+		 u32tmp[0] & 0xffff, fa_ofdm, fa_cck);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
 	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x6cc);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
-		   "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
-		   u32tmp[0], u32tmp[1], u32tmp[2], u8tmp[0]);
+		 "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+		 "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
+		 u32tmp[0], u32tmp[1], u32tmp[2], u8tmp[0]);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x770(high-pri rx/tx)",
-		   coex_sta->high_priority_rx, coex_sta->high_priority_tx);
+		 "0x770(high-pri rx/tx)",
+		 coex_sta->high_priority_rx, coex_sta->high_priority_tx);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x774(low-pri rx/tx)", coex_sta->low_priority_rx,
-		   coex_sta->low_priority_tx);
+		 "0x774(low-pri rx/tx)", coex_sta->low_priority_rx,
+		 coex_sta->low_priority_tx);
 #if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 1)
 	btc8723b2ant_monitor_bt_ctr(btcoexist);
 #endif
@@ -3313,16 +3379,18 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 void ex_btc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_IPS_ENTER == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS ENTER notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
 		btc8723b2ant_wifioff_hwcfg(btcoexist);
 		btc8723b2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 		btc8723b2ant_coex_alloff(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS LEAVE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
 		ex_btc8723b2ant_init_hwconfig(btcoexist);
 		btc8723b2ant_init_coex_dm(btcoexist);
@@ -3332,50 +3400,57 @@ void ex_btc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 
 void ex_btc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_LPS_ENABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS ENABLE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS ENABLE notify\n");
 		coex_sta->under_lps = true;
 	} else if (BTC_LPS_DISABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS DISABLE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS DISABLE notify\n");
 		coex_sta->under_lps = false;
 	}
 }
 
 void ex_btc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_SCAN_START == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN START notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN START notify\n");
 	else if (BTC_SCAN_FINISH == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN FINISH notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN FINISH notify\n");
 }
 
 void ex_btc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_ASSOCIATE_START == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT START notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT START notify\n");
 	else if (BTC_ASSOCIATE_FINISH == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT FINISH notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT FINISH notify\n");
 }
 
 void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
 
 	if (BTC_MEDIA_CONNECT == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA connect notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], MEDIA connect notify\n");
 	else
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA disconnect notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], MEDIA disconnect notify\n");
 
 	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist,
@@ -3396,10 +3471,10 @@ void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
 	coex_dm->wifi_chnl_info[1] = h2c_parameter[1];
 	coex_dm->wifi_chnl_info[2] = h2c_parameter[2];
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x66=0x%x\n",
-		    h2c_parameter[0] << 16 | h2c_parameter[1] << 8 |
-		    h2c_parameter[2]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], FW write 0x66=0x%x\n",
+		 h2c_parameter[0] << 16 | h2c_parameter[1] << 8 |
+		 h2c_parameter[2]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
@@ -3407,14 +3482,17 @@ void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
 void ex_btc8723b2ant_special_packet_notify(struct btc_coexist *btcoexist,
 					   u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (type == BTC_PACKET_DHCP)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], DHCP Packet notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], DHCP Packet notify\n");
 }
 
 void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmpbuf, u8 length)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool bt_busy = false, limited_dig = false;
@@ -3427,24 +3505,24 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		rsp_source = BT_INFO_SRC_8723B_2ANT_WIFI_FW;
 	coex_sta->bt_info_c2h_cnt[rsp_source]++;
 
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Bt info[%d], length=%d, hex data=[",
-		      rsp_source, length);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Bt info[%d], length=%d, hex data=[",
+		 rsp_source, length);
 	for (i = 0; i < length; i++) {
 		coex_sta->bt_info_c2h[rsp_source][i] = tmpbuf[i];
 		if (i == 1)
 			bt_info = tmpbuf[i];
 		if (i == length-1)
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x]\n", tmpbuf[i]);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x]\n", tmpbuf[i]);
 		else
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x, ", tmpbuf[i]);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x, ", tmpbuf[i]);
 	}
 
 	if (btcoexist->manual_control) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), return for Manual CTRL<===\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), return for Manual CTRL<===\n");
 		return;
 	}
 
@@ -3462,8 +3540,8 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		     because bt is reset and loss of the info.
 		 */
 		if ((coex_sta->bt_info_ext & BIT1)) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
 			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
 			if (wifi_connected)
@@ -3477,8 +3555,8 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		}
 
 		if ((coex_sta->bt_info_ext & BIT3)) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
 			btc8723b2ant_ignore_wlan_act(btcoexist, FORCE_EXEC,
 						     false);
 		} else {
@@ -3531,26 +3609,26 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 	if (!(bt_info & BT_INFO_8723B_2ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8723B_2ANT_BT_STATUS_NON_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
 	/* connection exists but no busy */
 	} else if (bt_info == BT_INFO_8723B_2ANT_B_CONNECTION) {
 		coex_dm->bt_status = BT_8723B_2ANT_BT_STATUS_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
 	} else if ((bt_info & BT_INFO_8723B_2ANT_B_SCO_ESCO) ||
 		   (bt_info & BT_INFO_8723B_2ANT_B_SCO_BUSY)) {
 		coex_dm->bt_status = BT_8723B_2ANT_BT_STATUS_SCO_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
 	} else if (bt_info&BT_INFO_8723B_2ANT_B_ACL_BUSY) {
 		coex_dm->bt_status = BT_8723B_2ANT_BT_STATUS_ACL_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
 	} else {
 		coex_dm->bt_status = BT_8723B_2ANT_BT_STATUS_MAX;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
 	}
 
 	if ((BT_8723B_2ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) ||
@@ -3573,7 +3651,9 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_NOTIFY, "[BTCoex], Halt notify\n");
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Halt notify\n");
 
 	btc8723b2ant_wifioff_hwcfg(btcoexist);
 	btc8723b2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
@@ -3582,36 +3662,37 @@ void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist)
 
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	static u8 dis_ver_info_cnt;
 	u32 fw_ver = 0, bt_patch_ver = 0;
 
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], ==========================Periodical===========================\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], ==========================Periodical===========================\n");
 
 	if (dis_ver_info_cnt <= 5) {
 		dis_ver_info_cnt += 1;
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], ****************************************************************\n");
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], Ant PG Num/ Ant Mech/ Ant Pos = %d/ %d/ %d\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ****************************************************************\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Ant PG Num/ Ant Mech/ Ant Pos = %d/ %d/ %d\n",
 			      board_info->pg_ant_num,
 			      board_info->btdm_ant_num,
 			      board_info->btdm_ant_pos);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], BT stack/ hci ext ver = %s / %d\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT stack/ hci ext ver = %s / %d\n",
 			      stack_info->profile_notified ? "Yes" : "No",
 			      stack_info->hci_version);
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
 				   &bt_patch_ver);
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], CoexVer/ fw_ver/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CoexVer/ fw_ver/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
 			      glcoex_ver_date_8723b_2ant, glcoex_ver_8723b_2ant,
 			      fw_ver, bt_patch_ver, bt_patch_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], ****************************************************************\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ****************************************************************\n");
 	}
 
 #if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
-- 
2.10.2
