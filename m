Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33546 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdBAVJZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 16:09:25 -0500
Received: by mail-ot0-f195.google.com with SMTP id f9so46849513otd.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 13:09:25 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/7] rtlwifi: btcoexist: Convert halbtc8821a1ant.c to use standard debugging
Date: Wed,  1 Feb 2017 15:08:55 -0600
Message-Id: <20170201210857.26516-6-Larry.Finger@lwfinger.net> (sfid-20170201_220934_551562_382E0EB9)
In-Reply-To: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
References: <20170201210857.26516-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routines in btcoexist use different debugging routines than are used
in the other drivers. This patch converts halbtc8821a1ant.c to use the
standard routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 898 +++++++++++----------
 1 file changed, 480 insertions(+), 418 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 3ce47c7..20562f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -62,9 +62,11 @@ static u32	glcoex_ver_8821a_1ant = 0x41;
  * local function start with halbtc8821a1ant_
  *============================================================
  */
-static u8 halbtc8821a1ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
+static u8 halbtc8821a1ant_bt_rssi_state(struct btc_coexist *btcoexist,
+					u8 level_num, u8 rssi_thresh,
 					u8 rssi_thresh1)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	long	bt_rssi = 0;
 	u8	bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
@@ -76,28 +78,28 @@ static u8 halbtc8821a1ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
 			if (bt_rssi >= (rssi_thresh +
 					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
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
 
@@ -106,12 +108,12 @@ static u8 halbtc8821a1ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
 			if (bt_rssi >= (rssi_thresh +
 					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
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
@@ -120,26 +122,26 @@ static u8 halbtc8821a1ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
 			if (bt_rssi >= (rssi_thresh1 +
 					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
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
@@ -152,6 +154,7 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 					u8 index, u8 level_num, u8 rssi_thresh,
 					u8 rssi_thresh1)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	long	wifi_rssi = 0;
 	u8	wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
@@ -165,28 +168,28 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 			if (wifi_rssi >=
 			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
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
 
@@ -197,12 +200,12 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 			if (wifi_rssi >=
 			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
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
@@ -212,26 +215,26 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 			    (rssi_thresh1 +
 			     BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
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
@@ -414,15 +417,16 @@ static void halbtc8821a1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void halbtc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
 	h2c_parameter[0] |= BIT0;	/* trigger*/
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
-		    h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
+		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
@@ -485,6 +489,7 @@ static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 
 static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool	bt_hs_on = false;
 	u8	algorithm = BT_8821A_1ANT_COEX_ALGO_UNDEFINED;
@@ -493,8 +498,8 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	if (!bt_link_info->bt_link_exist) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], No BT link exists!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], No BT link exists!!!\n");
 		return algorithm;
 	}
 
@@ -509,26 +514,28 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 
 	if (num_of_diff_profile == 1) {
 		if (bt_link_info->sco_exist) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], BT Profile = SCO only\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT Profile = SCO only\n");
 			algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 		} else {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = HID only\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = HID only\n");
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = A2DP only\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = A2DP only\n");
 				algorithm = BT_8821A_1ANT_COEX_ALGO_A2DP;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = PAN(HS) only\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = PAN(HS) only\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = PAN(EDR) only\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = PAN(EDR) only\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR;
 				}
 			}
@@ -536,50 +543,56 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 	} else if (num_of_diff_profile == 2) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = SCO + HID\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = SCO + HID\n");
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = SCO + A2DP ==> SCO\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = SCO + A2DP ==> SCO\n");
 				algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = SCO + PAN(HS)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = SCO + PAN(EDR)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			}
 		} else {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = HID + A2DP\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = HID + A2DP\n");
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = HID + PAN(HS)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = HID + PAN(EDR)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = A2DP + PAN(HS)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = A2DP + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = A2DP + PAN(EDR)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP;
 				}
 			}
@@ -588,29 +601,33 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = SCO + HID + A2DP ==> HID\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT Profile = SCO + HID + A2DP ==> HID\n");
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->hid_exist &&
 				bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + HID + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = SCO + HID + PAN(HS)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + HID + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = SCO + HID + PAN(EDR)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
 				bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = SCO + A2DP + PAN(HS)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + A2DP + PAN(EDR) ==> HID\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = SCO + A2DP + PAN(EDR) ==> HID\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			}
@@ -619,12 +636,14 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = HID + A2DP + PAN(HS)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + A2DP + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = HID + A2DP + PAN(EDR)\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				}
 			}
@@ -635,12 +654,14 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], Error!!! BT Profile = SCO + HID + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], Error!!! BT Profile = SCO + HID + A2DP + PAN(HS)\n");
 
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], BT Profile = SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			}
@@ -652,6 +673,7 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 static void halbtc8821a1ant_set_bt_auto_report(struct btc_coexist *btcoexist,
 					       bool enable_auto_report)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	h2c_parameter[0] = 0;
@@ -659,10 +681,10 @@ static void halbtc8821a1ant_set_bt_auto_report(struct btc_coexist *btcoexist,
 	if (enable_auto_report)
 		h2c_parameter[0] |= BIT0;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		    (enable_auto_report ? "Enabled!!" : "Disabled!!"),
-		    h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
+		 (enable_auto_report ? "Enabled!!" : "Disabled!!"),
+		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
 }
@@ -671,14 +693,17 @@ static void halbtc8821a1ant_bt_auto_report(struct btc_coexist *btcoexist,
 					   bool force_exec,
 					   bool enable_auto_report)
 {
-	btc_alg_dbg(ALGO_TRACE_FW, "[BTCoex], %s BT Auto report = %s\n",
-		    (force_exec ? "force to" : ""), ((enable_auto_report) ?
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s BT Auto report = %s\n",
+		 (force_exec ? "force to" : ""), ((enable_auto_report) ?
 						     "Enabled" : "Disabled"));
 	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_bt_auto_report = %d, cur_bt_auto_report = %d\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], pre_bt_auto_report = %d, cur_bt_auto_report = %d\n",
 			    coex_dm->pre_bt_auto_report,
 			    coex_dm->cur_bt_auto_report);
 
@@ -693,6 +718,7 @@ static void halbtc8821a1ant_bt_auto_report(struct btc_coexist *btcoexist,
 static void btc8821a1ant_set_sw_pen_tx_rate(struct btc_coexist *btcoexist,
 					    bool low_penalty_ra)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[6] = {0};
 
 	h2c_parameter[0] = 0x6;	/* opCode, 0x6= Retry_Penalty*/
@@ -706,9 +732,9 @@ static void btc8821a1ant_set_sw_pen_tx_rate(struct btc_coexist *btcoexist,
 		h2c_parameter[5] = 0xf9;	/*MCS5 or OFDM36*/
 	}
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set WiFi Low-Penalty Retry: %s",
-		    (low_penalty_ra ? "ON!!" : "OFF!!"));
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set WiFi Low-Penalty Retry: %s",
+		 (low_penalty_ra ? "ON!!" : "OFF!!"));
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x69, 6, h2c_parameter);
 }
@@ -731,20 +757,22 @@ static void halbtc8821a1ant_set_coex_table(struct btc_coexist *btcoexist,
 					   u32 val0x6c0, u32 val0x6c4,
 					   u32 val0x6c8, u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c0 = 0x%x\n", val0x6c0);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6c0 = 0x%x\n", val0x6c0);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c0, val0x6c0);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c4 = 0x%x\n", val0x6c4);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6c4 = 0x%x\n", val0x6c4);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c4, val0x6c4);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c8 = 0x%x\n", val0x6c8);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6c8 = 0x%x\n", val0x6c8);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c8, val0x6c8);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6cc = 0x%x\n", val0x6cc);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set coex table, set 0x6cc = 0x%x\n", val0x6cc);
 	btcoexist->btc_write_1byte(btcoexist, 0x6cc, val0x6cc);
 }
 
@@ -752,8 +780,10 @@ static void halbtc8821a1ant_coex_table(struct btc_coexist *btcoexist,
 				       bool force_exec, u32 val0x6c0,
 				       u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, 0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, 0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
 		    (force_exec ? "force to" : ""), val0x6c0, val0x6c4,
 		    val0x6c8, val0x6cc);
 	coex_dm->cur_val_0x6c0 = val0x6c0;
@@ -822,14 +852,15 @@ static void halbtc8821a1ant_coex_table_with_type(struct btc_coexist *btcoexist,
 static void btc8821a1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 						bool enable)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8	h2c_parameter[1] = {0};
 
 	if (enable)
 		h2c_parameter[0] |= BIT0;	/* function enable*/
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
-		    h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
+		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
@@ -837,16 +868,18 @@ static void btc8821a1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 static void halbtc8821a1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
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
-			    "[BTCoex], pre_ignore_wlan_act = %d, cur_ignore_wlan_act = %d!!\n",
-			    coex_dm->pre_ignore_wlan_act,
-			    coex_dm->cur_ignore_wlan_act);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], pre_ignore_wlan_act = %d, cur_ignore_wlan_act = %d!!\n",
+			 coex_dm->pre_ignore_wlan_act,
+			 coex_dm->cur_ignore_wlan_act);
 
 		if (coex_dm->pre_ignore_wlan_act ==
 		    coex_dm->cur_ignore_wlan_act)
@@ -861,6 +894,7 @@ static void halbtc8821a1ant_set_fw_pstdma(struct btc_coexist *btcoexist,
 					  u8 byte1, u8 byte2, u8 byte3,
 					  u8 byte4, u8 byte5)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[5] = {0};
 
 	h2c_parameter[0] = byte1;
@@ -875,13 +909,13 @@ static void halbtc8821a1ant_set_fw_pstdma(struct btc_coexist *btcoexist,
 	coex_dm->ps_tdma_para[3] = byte4;
 	coex_dm->ps_tdma_para[4] = byte5;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], PS-TDMA H2C cmd =0x%x%08x\n",
-		    h2c_parameter[0],
-		    h2c_parameter[1] << 24 |
-		    h2c_parameter[2] << 16 |
-		    h2c_parameter[3] << 8 |
-		    h2c_parameter[4]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], PS-TDMA H2C cmd =0x%x%08x\n",
+		 h2c_parameter[0],
+		 h2c_parameter[1] << 24 |
+		 h2c_parameter[2] << 16 |
+		 h2c_parameter[3] << 8 |
+		 h2c_parameter[4]);
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
@@ -898,22 +932,24 @@ static void halbtc8821a1ant_set_lps_rpwm(struct btc_coexist *btcoexist,
 static void halbtc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist,
 				     bool force_exec, u8 lps_val, u8 rpwm_val)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s set lps/rpwm = 0x%x/0x%x\n",
-		    (force_exec ? "force to" : ""), lps_val, rpwm_val);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s set lps/rpwm = 0x%x/0x%x\n",
+		 (force_exec ? "force to" : ""), lps_val, rpwm_val);
 	coex_dm->cur_lps = lps_val;
 	coex_dm->cur_rpwm = rpwm_val;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], LPS-RxBeaconMode = 0x%x, LPS-RPWM = 0x%x!!\n",
-			    coex_dm->cur_lps, coex_dm->cur_rpwm);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS-RxBeaconMode = 0x%x, LPS-RPWM = 0x%x!!\n",
+			 coex_dm->cur_lps, coex_dm->cur_rpwm);
 
 		if ((coex_dm->pre_lps == coex_dm->cur_lps) &&
 		    (coex_dm->pre_rpwm == coex_dm->cur_rpwm)) {
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], LPS-RPWM_Last = 0x%x, LPS-RPWM_Now = 0x%x!!\n",
-				    coex_dm->pre_rpwm, coex_dm->cur_rpwm);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], LPS-RPWM_Last = 0x%x, LPS-RPWM_Now = 0x%x!!\n",
+				 coex_dm->pre_rpwm, coex_dm->cur_rpwm);
 
 			return;
 		}
@@ -927,8 +963,10 @@ static void halbtc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist,
 static void halbtc8821a1ant_sw_mechanism(struct btc_coexist *btcoexist,
 					 bool low_penalty_ra)
 {
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex], SM[LpRA] = %d\n", low_penalty_ra);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], SM[LpRA] = %d\n", low_penalty_ra);
 
 	halbtc8821a1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
@@ -1017,6 +1055,7 @@ static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 				    bool force_exec, bool turn_on, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 rssi_adjust_val = 0;
 
 	coex_dm->cur_ps_tdma_on = turn_on;
@@ -1024,13 +1063,13 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 
 	if (!force_exec) {
 		if (coex_dm->cur_ps_tdma_on) {
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], ********** TDMA(on, %d) **********\n",
-				    coex_dm->cur_ps_tdma);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], ********** TDMA(on, %d) **********\n",
+				 coex_dm->cur_ps_tdma);
 		} else {
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], ********** TDMA(off, %d) **********\n",
-				    coex_dm->cur_ps_tdma);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], ********** TDMA(off, %d) **********\n",
+				 coex_dm->cur_ps_tdma);
 		}
 		if ((coex_dm->pre_ps_tdma_on == coex_dm->cur_ps_tdma_on) &&
 		    (coex_dm->pre_ps_tdma == coex_dm->cur_ps_tdma))
@@ -1232,6 +1271,7 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 
 static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool	common = false, wifi_connected = false, wifi_busy = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
@@ -1241,50 +1281,50 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 	if (!wifi_connected &&
 	    BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 	    coex_dm->bt_status) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi non connected-idle + BT non connected-idle!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non connected-idle + BT non connected-idle!!\n");
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (wifi_connected &&
 		   (BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 		    coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi connected + BT non connected-idle!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi connected + BT non connected-idle!!\n");
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (!wifi_connected &&
 		   (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
 		    coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi non connected-idle + BT connected-idle!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non connected-idle + BT connected-idle!!\n");
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (wifi_connected &&
 		   (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
 		   coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi connected + BT connected-idle!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi connected + BT connected-idle!!\n");
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (!wifi_connected &&
 		   (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE !=
 		    coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi non connected-idle + BT Busy!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non connected-idle + BT Busy!!\n");
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else {
 		if (wifi_busy) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
 		} else {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
 		}
 
 		common = false;
@@ -1296,13 +1336,14 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 				      u8 wifi_status)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static long		up, dn, m, n, wait_count;
 	/*0: no change, +1: increase WiFi duration, -1: decrease WiFi duration*/
 	long			result;
 	u8			retry_count = 0, bt_info_ext;
 
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], TdmaDurationAdjustForAcl()\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], TdmaDurationAdjustForAcl()\n");
 
 	if ((BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
 	     wifi_status) ||
@@ -1330,8 +1371,8 @@ static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 
 	if (!coex_dm->auto_tdma_adjust) {
 		coex_dm->auto_tdma_adjust = true;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], first run TdmaDurationAdjust()!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
 
 		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
 		coex_dm->tdma_adj_type = 2;
@@ -1366,8 +1407,8 @@ static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 				up = 0;
 				dn = 0;
 				result = 1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex], Increase wifi duration!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Increase wifi duration!!\n");
 			}
 		} else if (retry_count <= 3) {
 			/* <=3 retry in the last 2-second duration*/
@@ -1397,8 +1438,8 @@ static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 				dn = 0;
 				wait_count = 0;
 				result = -1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex], Decrease wifi duration for retryCounter<3!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], Decrease wifi duration for retryCounter<3!!\n");
 			}
 		} else {
 			/* retry count > 3, if retry count > 3 happens once,
@@ -1419,8 +1460,8 @@ static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 			dn = 0;
 			wait_count = 0;
 			result = -1;
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], Decrease wifi duration for retryCounter>3!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Decrease wifi duration for retryCounter>3!!\n");
 		}
 
 		if (result == -1) {
@@ -1465,9 +1506,9 @@ static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 			}
 		} else {
 			/*no change*/
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], ********** TDMA(on, %d) **********\n",
-				    coex_dm->cur_ps_tdma);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], ********** TDMA(on, %d) **********\n",
+				 coex_dm->cur_ps_tdma);
 		}
 
 		if (coex_dm->cur_ps_tdma != 1 &&
@@ -1566,6 +1607,7 @@ static void halbtc8821a1ant_action_wifi_only(struct btc_coexist *btcoexist)
 
 static void btc8821a1ant_mon_bt_en_dis(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static bool	pre_bt_disabled;
 	static u32	bt_disable_cnt;
 	bool		bt_active = true, bt_disabled = false;
@@ -1589,25 +1631,25 @@ static void btc8821a1ant_mon_bt_en_dis(struct btc_coexist *btcoexist)
 		bt_disabled = false;
 		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
 				   &bt_disabled);
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], BT is enabled !!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is enabled !!\n");
 	} else {
 		bt_disable_cnt++;
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], bt all counters = 0, %d times!!\n",
-			    bt_disable_cnt);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bt all counters = 0, %d times!!\n",
+			 bt_disable_cnt);
 		if (bt_disable_cnt >= 2) {
 			bt_disabled = true;
 			btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
 					   &bt_disabled);
-			btc_alg_dbg(ALGO_BT_MONITOR,
-				    "[BTCoex], BT is disabled !!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT is disabled !!\n");
 			halbtc8821a1ant_action_wifi_only(btcoexist);
 		}
 	}
 	if (pre_bt_disabled != bt_disabled) {
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], BT is from %s to %s!!\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is from %s to %s!!\n",
 			    (pre_bt_disabled ? "disabled" : "enabled"),
 			    (bt_disabled ? "disabled" : "enabled"));
 		pre_bt_disabled = bt_disabled;
@@ -1740,7 +1782,7 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
-	bt_rssi_state = halbtc8821a1ant_bt_rssi_state(2, 28, 0);
+	bt_rssi_state = halbtc8821a1ant_bt_rssi_state(btcoexist, 2, 28, 0);
 
 	if (bt_link_info->hid_only) {
 		/*HID*/
@@ -1879,19 +1921,20 @@ static void btc8821a1ant_act_wifi_conn_sp_pkt(struct btc_coexist *btcoexist)
 
 static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool	wifi_busy = false;
 	bool	scan = false, link = false, roam = false;
 	bool	under_4way = false;
 
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], CoexForWifiConnect()===>\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], CoexForWifiConnect()===>\n");
 
 	btcoexist->btc_get(btcoexist,
 		 BTC_GET_BL_WIFI_4_WAY_PROGRESS, &under_4way);
 	if (under_4way) {
 		btc8821a1ant_act_wifi_conn_sp_pkt(btcoexist);
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], CoexForWifiConnect(), return for wifi is under 4way<===\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CoexForWifiConnect(), return for wifi is under 4way<===\n");
 		return;
 	}
 
@@ -1900,8 +1943,8 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 	if (scan || link || roam) {
 		halbtc8821a1ant_action_wifi_connected_scan(btcoexist);
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], CoexForWifiConnect(), return for wifi is under scan<===\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CoexForWifiConnect(), return for wifi is under scan<===\n");
 		return;
 	}
 
@@ -1954,6 +1997,7 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 
 static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8	algorithm = 0;
 
 	algorithm = halbtc8821a1ant_action_algorithm(btcoexist);
@@ -1962,58 +2006,58 @@ static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
 	if (!halbtc8821a1ant_is_common_action(btcoexist)) {
 		switch (coex_dm->cur_algorithm) {
 		case BT_8821A_1ANT_COEX_ALGO_SCO:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = SCO\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = SCO\n");
 			halbtc8821a1ant_action_sco(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HID\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HID\n");
 			halbtc8821a1ant_action_hid(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = A2DP\n");
 			halbtc8821a1ant_action_a2dp(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = A2DP+PAN(HS)\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = A2DP+PAN(HS)\n");
 			halbtc8821a1ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = PAN(EDR)\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = PAN(EDR)\n");
 			halbtc8821a1ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HS mode\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HS mode\n");
 			halbtc8821a1ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = PAN+A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = PAN+A2DP\n");
 			halbtc8821a1ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = PAN(EDR)+HID\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = PAN(EDR)+HID\n");
 			halbtc8821a1ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HID+A2DP+PAN\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HID+A2DP+PAN\n");
 			btc8821a1ant_action_hid_a2dp_pan_edr(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HID+A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = HID+A2DP\n");
 			halbtc8821a1ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = coexist All Off!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Action algorithm = coexist All Off!!\n");
 			/*halbtc8821a1ant_coex_all_off(btcoexist);*/
 			break;
 		}
@@ -2023,6 +2067,7 @@ static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
 
 static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool	wifi_connected = false, bt_hs_on = false;
 	bool	increase_scan_dev_num = false;
@@ -2031,31 +2076,31 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	u8	wifi_rssi_state = BTC_RSSI_STATE_HIGH;
 	bool	wifi_under_5g = false;
 
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
 
 	if (btcoexist->stop_coex_dm) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], RunCoexistMechanism(), return for Stop Coex DM <===\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for Stop Coex DM <===\n");
 		return;
 	}
 
 	if (coex_sta->under_ips) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], wifi is under IPS !!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under IPS !!!\n");
 		return;
 	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 	if (wifi_under_5g) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
 		halbtc8821a1ant_coex_under_5g(btcoexist);
 		return;
 	}
@@ -2121,8 +2166,8 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	if (!wifi_connected) {
 		bool	scan = false, link = false, roam = false;
 
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], wifi is non connected-idle !!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is non connected-idle !!!\n");
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
@@ -2151,11 +2196,12 @@ static void halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 static void halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 					   bool back_up)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8	u1_tmp = 0;
 	bool	wifi_under_5g = false;
 
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], 1Ant Init HW Config!!\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], 1Ant Init HW Config!!\n");
 
 	if (back_up) {
 		coex_dm->backup_arfr_cnt1 = btcoexist->btc_read_4byte(btcoexist,
@@ -2206,8 +2252,10 @@ void ex_halbtc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist)
 
 void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], Coex Mechanism Init!!\n");
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Coex Mechanism Init!!\n");
 
 	btcoexist->stop_coex_dm = false;
 
@@ -2233,19 +2281,19 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 	u32 fw_ver = 0, bt_patch_ver = 0;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n ============[BT Coexist info]============");
+		 "\r\n ============[BT Coexist info]============");
 
 	if (btcoexist->manual_control) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ============[Under Manual Control]============");
+			 "\r\n ============[Under Manual Control]============");
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ==========================================");
+			 "\r\n ==========================================");
 	}
 	if (btcoexist->stop_coex_dm) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ============[Coex is STOPPED]============");
+			 "\r\n ============[Coex is STOPPED]============");
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ==========================================");
+			 "\r\n ==========================================");
 	}
 
 	if (!board_info->bt_exist) {
@@ -2254,27 +2302,27 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 	}
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d/ %d",
-		   "Ant PG Num/ Ant Mech/ Ant Pos:",
-		   board_info->pg_ant_num,
-		   board_info->btdm_ant_num,
-		   board_info->btdm_ant_pos);
+		 "\r\n %-35s = %d/ %d/ %d",
+		 "Ant PG Num/ Ant Mech/ Ant Pos:",
+		 board_info->pg_ant_num,
+		 board_info->btdm_ant_num,
+		 board_info->btdm_ant_pos);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s / %d", "BT stack/ hci ext ver",
-		   ((stack_info->profile_notified) ? "Yes" : "No"),
-		stack_info->hci_version);
+		 "\r\n %-35s = %s / %d", "BT stack/ hci ext ver",
+		 ((stack_info->profile_notified) ? "Yes" : "No"),
+		 stack_info->hci_version);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
 			   &bt_patch_ver);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d_%x/ 0x%x/ 0x%x(%d)",
-		   "CoexVer/ FwVer/ PatchVer",
-		   glcoex_ver_date_8821a_1ant,
-		   glcoex_ver_8821a_1ant,
-		   fw_ver, bt_patch_ver,
-		   bt_patch_ver);
+		 "\r\n %-35s = %d_%x/ 0x%x/ 0x%x(%d)",
+		 "CoexVer/ FwVer/ PatchVer",
+		 glcoex_ver_date_8821a_1ant,
+		 glcoex_ver_8821a_1ant,
+		 fw_ver, bt_patch_ver,
+		 bt_patch_ver);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION,
 			   &bt_hs_on);
@@ -2283,27 +2331,27 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL,
 			   &wifi_hs_chnl);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d / %d(%d)",
-		   "Dot11 channel / HsChnl(HsMode)",
-		   wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
+		 "\r\n %-35s = %d / %d(%d)",
+		 "Dot11 channel / HsChnl(HsMode)",
+		 wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %3ph ",
-		   "H2C Wifi inform bt chnl Info",
-		   coex_dm->wifi_chnl_info);
+		 "\r\n %-35s = %3ph ",
+		 "H2C Wifi inform bt chnl Info",
+		 coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d", "Wifi rssi/ HS rssi",
-		   (int)wifi_rssi, (int)bt_hs_rssi);
+		 "\r\n %-35s = %d/ %d", "Wifi rssi/ HS rssi",
+		 (int)wifi_rssi, (int)bt_hs_rssi);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d/ %d ", "Wifi link/ roam/ scan",
-		   link, roam, scan);
+		 "\r\n %-35s = %d/ %d/ %d ", "Wifi link/ roam/ scan",
+		 link, roam, scan);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G,
 			   &wifi_under_5g);
@@ -2314,13 +2362,13 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
 			   &wifi_traffic_dir);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s / %s/ %s ", "Wifi status",
-		   (wifi_under_5g ? "5G" : "2.4G"),
-		   ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
-		   (((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40" : "HT20"))),
-		   ((!wifi_busy) ? "idle" :
-		   ((BTC_WIFI_TRAFFIC_TX == wifi_traffic_dir) ?
-		   "uplink" : "downlink")));
+		 "\r\n %-35s = %s / %s/ %s ", "Wifi status",
+		 (wifi_under_5g ? "5G" : "2.4G"),
+		 ((wifi_bw == BTC_WIFI_BW_LEGACY) ? "Legacy" :
+		 (((wifi_bw == BTC_WIFI_BW_HT40) ? "HT40" : "HT20"))),
+		 ((!wifi_busy) ? "idle" :
+		 ((wifi_traffic_dir == BTC_WIFI_TRAFFIC_TX) ?
+		 "uplink" : "downlink")));
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		   "\r\n %-35s = [%s/ %d/ %d] ", "BT [status/ rssi/ retryCnt]",
 		   ((btcoexist->bt_info.bt_disabled) ? ("disabled") :
@@ -2334,161 +2382,162 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 		   coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d / %d / %d / %d", "SCO/HID/PAN/A2DP",
-		   bt_link_info->sco_exist,
-		   bt_link_info->hid_exist,
-		   bt_link_info->pan_exist,
-		   bt_link_info->a2dp_exist);
+		 "\r\n %-35s = %d / %d / %d / %d", "SCO/HID/PAN/A2DP",
+		 bt_link_info->sco_exist,
+		 bt_link_info->hid_exist,
+		 bt_link_info->pan_exist,
+		 bt_link_info->a2dp_exist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_BT_LINK_INFO);
 
 	bt_info_ext = coex_sta->bt_info_ext;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s",
-		   "BT Info A2DP rate",
-		   (bt_info_ext&BIT0) ?
-		   "Basic rate" : "EDR rate");
+		 "\r\n %-35s = %s",
+		 "BT Info A2DP rate",
+		 (bt_info_ext & BIT0) ?
+		 "Basic rate" : "EDR rate");
 
 	for (i = 0; i < BT_INFO_SRC_8821A_1ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %7ph(%d)",
-				   glbt_info_src_8821a_1ant[i],
-				   coex_sta->bt_info_c2h[i],
-				   coex_sta->bt_info_c2h_cnt[i]);
+				 "\r\n %-35s = %7ph(%d)",
+				 glbt_info_src_8821a_1ant[i],
+				 coex_sta->bt_info_c2h[i],
+				 coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s/%s, (0x%x/0x%x)",
-		   "PS state, IPS/LPS, (lps/rpwm)",
-		   ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
-		   ((coex_sta->under_Lps ? "LPS ON" : "LPS OFF")),
-		   btcoexist->bt_info.lps_val,
-		   btcoexist->bt_info.rpwm_val);
+		 "\r\n %-35s = %s/%s, (0x%x/0x%x)",
+		 "PS state, IPS/LPS, (lps/rpwm)",
+		 ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
+		 ((coex_sta->under_Lps ? "LPS ON" : "LPS OFF")),
+		 btcoexist->bt_info.lps_val,
+		 btcoexist->bt_info.rpwm_val);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
 
 	if (!btcoexist->manual_control) {
 		/* Sw mechanism*/
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s", "============[Sw mechanism]============");
+			 "\r\n %-35s",
+			 "============[Sw mechanism]============");
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %d", "SM[LowPenaltyRA]",
-			   coex_dm->cur_low_penalty_ra);
+			 "\r\n %-35s = %d", "SM[LowPenaltyRA]",
+			 coex_dm->cur_low_penalty_ra);
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %s/ %s/ %d ",
-			   "DelBA/ BtCtrlAgg/ AggSize",
-			   (btcoexist->bt_info.reject_agg_pkt ? "Yes" : "No"),
-			   (btcoexist->bt_info.bt_ctrl_buf_size ? "Yes" : "No"),
-			   btcoexist->bt_info.agg_buf_size);
+			 "\r\n %-35s = %s/ %s/ %d ",
+			 "DelBA/ BtCtrlAgg/ AggSize",
+			 (btcoexist->bt_info.reject_agg_pkt ? "Yes" : "No"),
+			 (btcoexist->bt_info.bt_ctrl_buf_size ? "Yes" : "No"),
+			 btcoexist->bt_info.agg_buf_size);
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = 0x%x ", "Rate Mask",
-			   btcoexist->bt_info.ra_mask);
+			 "\r\n %-35s = 0x%x ", "Rate Mask",
+			 btcoexist->bt_info.ra_mask);
 
 		/* Fw mechanism*/
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
-			   "============[Fw mechanism]============");
+			 "============[Fw mechanism]============");
 
 		ps_tdma_case = coex_dm->cur_ps_tdma;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %5ph case-%d (auto:%d)",
-			   "PS TDMA",
-			   coex_dm->ps_tdma_para,
-			   ps_tdma_case,
-			   coex_dm->auto_tdma_adjust);
+			 "\r\n %-35s = %5ph case-%d (auto:%d)",
+			 "PS TDMA",
+			 coex_dm->ps_tdma_para,
+			 ps_tdma_case,
+			 coex_dm->auto_tdma_adjust);
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = 0x%x ",
-			   "Latest error condition(should be 0)",
+			 "\r\n %-35s = 0x%x ",
+			 "Latest error condition(should be 0)",
 			   coex_dm->error_condition);
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %d ", "IgnWlanAct",
-			   coex_dm->cur_ignore_wlan_act);
+			 "\r\n %-35s = %d ", "IgnWlanAct",
+			 coex_dm->cur_ignore_wlan_act);
 	}
 
 	/* Hw setting*/
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s", "============[Hw setting]============");
+		 "\r\n %-35s", "============[Hw setting]============");
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
-		   "backup ARFR1/ARFR2/RL/AMaxTime",
-		   coex_dm->backup_arfr_cnt1,
-		   coex_dm->backup_arfr_cnt2,
-		   coex_dm->backup_retry_limit,
-		   coex_dm->backup_ampdu_max_time);
+		 "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
+		 "backup ARFR1/ARFR2/RL/AMaxTime",
+		 coex_dm->backup_arfr_cnt1,
+		 coex_dm->backup_arfr_cnt2,
+		 coex_dm->backup_retry_limit,
+		 coex_dm->backup_ampdu_max_time);
 
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x430);
 	u4_tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x434);
 	u2_tmp[0] = btcoexist->btc_read_2byte(btcoexist, 0x42a);
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x456);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
-		   "0x430/0x434/0x42a/0x456",
-		   u4_tmp[0], u4_tmp[1], u2_tmp[0], u1_tmp[0]);
+		 "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
+		 "0x430/0x434/0x42a/0x456",
+		 u4_tmp[0], u4_tmp[1], u2_tmp[0], u1_tmp[0]);
 
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc58);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x", "0x778/ 0xc58[29:25]",
-		   u1_tmp[0], (u4_tmp[0]&0x3e000000) >> 25);
+		 "\r\n %-35s = 0x%x/ 0x%x", "0x778/ 0xc58[29:25]",
+		 u1_tmp[0], (u4_tmp[0] & 0x3e000000) >> 25);
 
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x8db);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x", "0x8db[6:5]",
-		   ((u1_tmp[0]&0x60)>>5));
+		 "\r\n %-35s = 0x%x", "0x8db[6:5]",
+		 ((u1_tmp[0] & 0x60) >> 5));
 
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x975);
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xcb4);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0xcb4[29:28]/0xcb4[7:0]/0x974[9:8]",
-		   (u4_tmp[0] & 0x30000000)>>28,
-		    u4_tmp[0] & 0xff,
-		    u1_tmp[0] & 0x3);
+		 "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		 "0xcb4[29:28]/0xcb4[7:0]/0x974[9:8]",
+		 (u4_tmp[0] & 0x30000000) >> 28,
+		  u4_tmp[0] & 0xff,
+		  u1_tmp[0] & 0x3);
 
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x40);
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
 	u1_tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x64);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0x40/0x4c[24:23]/0x64[0]",
-		   u1_tmp[0], ((u4_tmp[0]&0x01800000)>>23), u1_tmp[1]&0x1);
+		 "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		 "0x40/0x4c[24:23]/0x64[0]",
+		 u1_tmp[0], ((u4_tmp[0] & 0x01800000) >> 23), u1_tmp[1] & 0x1);
 
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x", "0x550(bcn ctrl)/0x522",
-		   u4_tmp[0], u1_tmp[0]);
+		 "\r\n %-35s = 0x%x/ 0x%x", "0x550(bcn ctrl)/0x522",
+		 u4_tmp[0], u1_tmp[0]);
 
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x", "0xc50(dig)",
-		   u4_tmp[0]&0xff);
+		 "\r\n %-35s = 0x%x", "0xc50(dig)",
+		 u4_tmp[0] & 0xff);
 
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xf48);
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0xa5d);
 	u1_tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xa5c);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x", "OFDM-FA/ CCK-FA",
-		   u4_tmp[0], (u1_tmp[0]<<8) + u1_tmp[1]);
+		 "\r\n %-35s = 0x%x/ 0x%x", "OFDM-FA/ CCK-FA",
+		 u4_tmp[0], (u1_tmp[0] << 8) + u1_tmp[1]);
 
 	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
 	u4_tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
 	u4_tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
 	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x6cc);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
-		   "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
+		 "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+		 "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
 		   u4_tmp[0], u4_tmp[1], u4_tmp[2], u1_tmp[0]);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d", "0x770(high-pri rx/tx)",
-		   coex_sta->high_priority_rx, coex_sta->high_priority_tx);
+		 "\r\n %-35s = %d/ %d", "0x770(high-pri rx/tx)",
+		 coex_sta->high_priority_rx, coex_sta->high_priority_tx);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d", "0x774(low-pri rx/tx)",
-		   coex_sta->low_priority_rx, coex_sta->low_priority_tx);
+		 "\r\n %-35s = %d/ %d", "0x774(low-pri rx/tx)",
+		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
 #if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 1)
 	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
 #endif
@@ -2497,12 +2546,14 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 
 void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
 
 	if (BTC_IPS_ENTER == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS ENTER notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
 		halbtc8821a1ant_set_ant_path(btcoexist,
 					     BTC_ANT_PATH_BT, false, true);
@@ -2511,8 +2562,8 @@ void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		halbtc8821a1ant_coex_table_with_type(btcoexist,
 						     NORMAL_EXEC, 0);
 	} else if (BTC_IPS_LEAVE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS LEAVE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
 
 		halbtc8821a1ant_run_coexist_mechanism(btcoexist);
@@ -2521,22 +2572,25 @@ void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 
 void ex_halbtc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
 
 	if (BTC_LPS_ENABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS ENABLE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS ENABLE notify\n");
 		coex_sta->under_Lps = true;
 	} else if (BTC_LPS_DISABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS DISABLE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS DISABLE notify\n");
 		coex_sta->under_Lps = false;
 	}
 }
 
 void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false, bt_hs_on = false;
 
 	if (btcoexist->manual_control ||
@@ -2560,8 +2614,8 @@ void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 
 	if (BTC_SCAN_START == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN START notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN START notify\n");
 		if (!wifi_connected) {
 			/* non-connected scan*/
 			btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
@@ -2570,8 +2624,8 @@ void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 			halbtc8821a1ant_action_wifi_connected_scan(btcoexist);
 		}
 	} else if (BTC_SCAN_FINISH == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN FINISH notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN FINISH notify\n");
 		if (!wifi_connected) {
 			/* non-connected scan*/
 			halbtc8821a1ant_action_wifi_not_connected(btcoexist);
@@ -2583,6 +2637,7 @@ void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 
 void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool	wifi_connected = false, bt_hs_on = false;
 
 	if (btcoexist->manual_control ||
@@ -2600,12 +2655,12 @@ void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 
 	if (BTC_ASSOCIATE_START == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT START notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT START notify\n");
 		btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
 	} else if (BTC_ASSOCIATE_FINISH == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT FINISH notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT FINISH notify\n");
 
 		btcoexist->btc_get(btcoexist,
 			 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
@@ -2621,6 +2676,7 @@ void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 					    u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
@@ -2631,11 +2687,11 @@ void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 		return;
 
 	if (BTC_MEDIA_CONNECT == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA connect notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], MEDIA connect notify\n");
 	} else {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA disconnect notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], MEDIA disconnect notify\n");
 	}
 
 	/* only 2.4G we need to inform bt the chnl mask*/
@@ -2658,11 +2714,11 @@ void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 	coex_dm->wifi_chnl_info[1] = h2c_parameter[1];
 	coex_dm->wifi_chnl_info[2] = h2c_parameter[2];
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x66 = 0x%x\n",
-		    h2c_parameter[0] << 16 |
-		    h2c_parameter[1] << 8 |
-		    h2c_parameter[2]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], FW write 0x66 = 0x%x\n",
+		 h2c_parameter[0] << 16 |
+		 h2c_parameter[1] << 8 |
+		 h2c_parameter[2]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
@@ -2670,6 +2726,7 @@ void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 					      u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool bt_hs_on = false;
 
 	if (btcoexist->manual_control ||
@@ -2690,8 +2747,8 @@ void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 
 	if (BTC_PACKET_DHCP == type ||
 	    BTC_PACKET_EAPOL == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], special Packet(%d) notify\n", type);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], special Packet(%d) notify\n", type);
 		btc8821a1ant_act_wifi_conn_sp_pkt(btcoexist);
 	}
 }
@@ -2699,6 +2756,7 @@ void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 				       u8 *tmp_buf, u8 length)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool wifi_connected = false;
@@ -2715,19 +2773,19 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		rsp_source = BT_INFO_SRC_8821A_1ANT_WIFI_FW;
 	coex_sta->bt_info_c2h_cnt[rsp_source]++;
 
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Bt info[%d], length = %d, hex data = [",
-		      rsp_source, length);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Bt info[%d], length = %d, hex data = [",
+		 rsp_source, length);
 	for (i = 0; i < length; i++) {
 		coex_sta->bt_info_c2h[rsp_source][i] = tmp_buf[i];
 		if (i == 1)
 			bt_info = tmp_buf[i];
 		if (i == length-1) {
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x]\n", tmp_buf[i]);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x]\n", tmp_buf[i]);
 		} else {
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x, ", tmp_buf[i]);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x, ", tmp_buf[i]);
 		}
 	}
 
@@ -2744,8 +2802,8 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		/* Here we need to resend some wifi info to BT*/
 		/* because bt is reset and loss of the info.*/
 		if (coex_sta->bt_info_ext & BIT1) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
 			btcoexist->btc_get(btcoexist,
 					   BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
@@ -2761,8 +2819,8 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		if ((coex_sta->bt_info_ext & BIT3) && !wifi_under_5g) {
 			if (!btcoexist->manual_control &&
 			    !btcoexist->stop_coex_dm) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
 				halbtc8821a1ant_ignore_wlan_act(btcoexist,
 								FORCE_EXEC,
 								false);
@@ -2770,8 +2828,8 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		}
 #if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
 		if (!(coex_sta->bt_info_ext & BIT4)) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], BT ext info bit4 check, set BT to enable Auto Report!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT ext info bit4 check, set BT to enable Auto Report!!\n");
 			halbtc8821a1ant_bt_auto_report(btcoexist,
 						       FORCE_EXEC, true);
 		}
@@ -2816,28 +2874,28 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 	if (!(bt_info&BT_INFO_8821A_1ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
 	} else if (bt_info == BT_INFO_8821A_1ANT_B_CONNECTION) {
 		/* connection exists but no busy*/
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
 	} else if ((bt_info&BT_INFO_8821A_1ANT_B_SCO_ESCO) ||
 		(bt_info&BT_INFO_8821A_1ANT_B_SCO_BUSY)) {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_SCO_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
 	} else if (bt_info&BT_INFO_8821A_1ANT_B_ACL_BUSY) {
 		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY != coex_dm->bt_status)
 			coex_dm->auto_tdma_adjust = false;
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_ACL_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
 	} else {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_MAX;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
 	}
 
 	if ((BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) ||
@@ -2854,8 +2912,10 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 void ex_halbtc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Halt notify\n");
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Halt notify\n");
 
 	btcoexist->stop_coex_dm = true;
 
@@ -2873,20 +2933,22 @@ void ex_halbtc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 
 void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Pnp notify\n");
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Pnp notify\n");
 
 	if (BTC_WIFI_PNP_SLEEP == pnp_state) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], Pnp notify to SLEEP\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to SLEEP\n");
 		btcoexist->stop_coex_dm = true;
 		halbtc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 						 0x0, 0x0);
 		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 9);
 	} else if (BTC_WIFI_PNP_WAKE_UP == pnp_state) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], Pnp notify to WAKE UP\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Pnp notify to WAKE UP\n");
 		btcoexist->stop_coex_dm = false;
 		halbtc8821a1ant_init_hw_config(btcoexist, false);
 		halbtc8821a1ant_init_coex_dm(btcoexist);
@@ -2894,41 +2956,41 @@ void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 	}
 }
 
-void
-ex_halbtc8821a1ant_periodical(
-	struct btc_coexist *btcoexist) {
+void ex_halbtc8821a1ant_periodical(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static u8	dis_ver_info_cnt;
 	u32		fw_ver = 0, bt_patch_ver = 0;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 
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
-			      "[BTCoex], CoexVer/ FwVer/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CoexVer/ FwVer/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
 			      glcoex_ver_date_8821a_1ant,
 			      glcoex_ver_8821a_1ant,
 			      fw_ver, bt_patch_ver,
 			      bt_patch_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], ****************************************************************\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], ****************************************************************\n");
 	}
 
 #if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-- 
2.10.2
