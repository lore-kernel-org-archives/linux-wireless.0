Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33172 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbdATV12 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 16:27:28 -0500
Received: by mail-ot0-f194.google.com with SMTP id f9so8855187otd.0
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 13:27:28 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 05/11] rtlwifi: btcoexist: Change logging in halbtc8192e2ant.c
Date: Fri, 20 Jan 2017 15:27:10 -0600
Message-Id: <20170120212716.29887-6-Larry.Finger@lwfinger.net> (sfid-20170120_223045_589409_4C304049)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This routine uses its own debugging macros These are changed to use the
the recently rewritten RT_TRACE macro. There are also some renamed
variables that were missed in the previous step.

The only functional change is that some debugging statements have been
dropped based on the final code supplied by Realtek.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
 .../wireless/realtek/rtlwifi/btcoexist/Makefile    |   1 +
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 825 +++++++++++----------
 2 files changed, 417 insertions(+), 409 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
index d1454d4..0ef0d31 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
@@ -1,4 +1,5 @@
 btcoexist-objs :=	halbtc8723b2ant.o	\
+			halbtc8192e2ant.o	\
 			halbtcoutsrc.o		\
 			rtl_btc.o
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index a30af6c..29f45cc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -59,9 +59,11 @@ static u32 glcoex_ver_8192e_2ant = 0x34;
 /**************************************************************
  *   local function start with halbtc8192e2ant_
  **************************************************************/
-static u8 halbtc8192e2ant_btrssi_state(u8 level_num, u8 rssi_thresh,
+static u8 halbtc8192e2ant_btrssi_state(struct btc_coexist *btcoexist,
+					u8 level_num, u8 rssi_thresh,
 				       u8 rssi_thresh1)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	int btrssi = 0;
 	u8 btrssi_state = coex_sta->pre_bt_rssi_state;
 
@@ -70,84 +72,46 @@ static u8 halbtc8192e2ant_btrssi_state(u8 level_num, u8 rssi_thresh,
 	if (level_num == 2) {
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = LOW\n");
-			if (btrssi >= (rssi_thresh +
-				       BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
+			if (btrssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
 				btrssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to High\n");
-			} else {
+			else
 				btrssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at Low\n");
-			}
 		} else {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = HIGH\n");
-			if (btrssi < rssi_thresh) {
+			if (btrssi < rssi_thresh)
 				btrssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Low\n");
-			} else {
+			else
 				btrssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at High\n");
-			}
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi thresh error!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], BT Rssi thresh error!!\n");
 			return coex_sta->pre_bt_rssi_state;
 		}
-
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = LOW\n");
-			if (btrssi >= (rssi_thresh +
-				      BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
+			if (btrssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
 				btrssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Medium\n");
-			} else {
+			else
 				btrssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at Low\n");
-			}
 		} else if ((coex_sta->pre_bt_rssi_state ==
 			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_bt_rssi_state ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "[BTCoex], BT Rssi pre state = MEDIUM\n");
 			if (btrssi >= (rssi_thresh1 +
-				       BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
+					BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
 				btrssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to High\n");
-			} else if (btrssi < rssi_thresh) {
+			else if (btrssi < rssi_thresh)
 				btrssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Low\n");
-			} else {
+			else
 				btrssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at Medium\n");
-			}
 		} else {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = HIGH\n");
-			if (btrssi < rssi_thresh1) {
+			if (btrssi < rssi_thresh1)
 				btrssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Medium\n");
-			} else {
+			else
 				btrssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at High\n");
-			}
 		}
 	}
 
@@ -160,6 +124,7 @@ static u8 halbtc8192e2ant_wifirssi_state(struct btc_coexist *btcoexist,
 					 u8 index, u8 level_num, u8 rssi_thresh,
 					 u8 rssi_thresh1)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	int wifirssi = 0;
 	u8 wifirssi_state = coex_sta->pre_wifi_rssi_state[index];
 
@@ -171,30 +136,20 @@ static u8 halbtc8192e2ant_wifirssi_state(struct btc_coexist *btcoexist,
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
 			if (wifirssi >= (rssi_thresh +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
+					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
 				wifirssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to High\n");
-			} else {
+			else
 				wifirssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at Low\n");
-			}
 		} else {
-			if (wifirssi < rssi_thresh) {
+			if (wifirssi < rssi_thresh)
 				wifirssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Low\n");
-			} else {
+			else
 				wifirssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at High\n");
-			}
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-				    "wifi RSSI thresh error!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], wifi RSSI thresh error!!\n");
 			return coex_sta->pre_wifi_rssi_state[index];
 		}
 
@@ -203,43 +158,26 @@ static u8 halbtc8192e2ant_wifirssi_state(struct btc_coexist *btcoexist,
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
 			if (wifirssi >= (rssi_thresh +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
+					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
 				wifirssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Medium\n");
-			} else {
+			else
 				wifirssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at Low\n");
-			}
 		} else if ((coex_sta->pre_wifi_rssi_state[index] ==
 			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_wifi_rssi_state[index] ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
 			if (wifirssi >= (rssi_thresh1 +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
+					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
 				wifirssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to High\n");
-			} else if (wifirssi < rssi_thresh) {
+			else if (wifirssi < rssi_thresh)
 				wifirssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Low\n");
-			} else {
+			else
 				wifirssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at Medium\n");
-			}
 		} else {
-			if (wifirssi < rssi_thresh1) {
+			if (wifirssi < rssi_thresh1)
 				wifirssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Medium\n");
-			} else {
+			else
 				wifirssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at High\n");
-			}
 		}
 	}
 
@@ -250,6 +188,7 @@ static u8 halbtc8192e2ant_wifirssi_state(struct btc_coexist *btcoexist,
 
 static void btc8192e2ant_monitor_bt_enable_dis(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static bool pre_bt_disabled;
 	static u32 bt_disable_cnt;
 	bool bt_active = true, bt_disabled = false;
@@ -273,26 +212,26 @@ static void btc8192e2ant_monitor_bt_enable_dis(struct btc_coexist *btcoexist)
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
 		}
 	}
 	if (pre_bt_disabled != bt_disabled) {
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], BT is from %s to %s!!\n",
-			    (pre_bt_disabled ? "disabled" : "enabled"),
-			    (bt_disabled ? "disabled" : "enabled"));
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is from %s to %s!!\n",
+			 (pre_bt_disabled ? "disabled" : "enabled"),
+			 (bt_disabled ? "disabled" : "enabled"));
 		pre_bt_disabled = bt_disabled;
 	}
 }
@@ -469,6 +408,7 @@ static void halbtc8192e2ant_limited_rx(struct btc_coexist *btcoexist,
 
 static void halbtc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 
@@ -488,12 +428,12 @@ static void halbtc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	coex_sta->low_priority_tx = reg_lp_tx;
 	coex_sta->low_priority_rx = reg_lp_rx;
 
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex] High Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
-		    reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex] Low Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
-		    reg_lp_txrx, reg_lp_tx, reg_lp_tx, reg_lp_rx, reg_lp_rx);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex] High Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
+		 reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex] Low Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
+		 reg_lp_txrx, reg_lp_tx, reg_lp_tx, reg_lp_rx, reg_lp_rx);
 
 	/* reset counter */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
@@ -501,15 +441,16 @@ static void halbtc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void halbtc8192e2ant_querybt_info(struct btc_coexist *btcoexist)
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
@@ -572,6 +513,7 @@ static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
 
 static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	bool bt_hson = false;
@@ -581,8 +523,8 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
 
 	if (!bt_link_info->bt_link_exist) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "No BT link exists!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "No BT link exists!!!\n");
 		return algorithm;
 	}
 
@@ -597,27 +539,29 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 
 	if (numdiffprofile == 1) {
 		if (bt_link_info->sco_exist) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "SCO only\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "SCO only\n");
 			algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 		} else {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "HID only\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "HID only\n");
 				algorithm = BT_8192E_2ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "A2DP only\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "A2DP only\n");
 				algorithm = BT_8192E_2ANT_COEX_ALGO_A2DP;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "PAN(HS) only\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "PAN(HS) only\n");
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "PAN(EDR) only\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "PAN(EDR) only\n");
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_PANEDR;
 				}
@@ -626,21 +570,23 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 	} else if (numdiffprofile == 2) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "SCO + HID\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "SCO + HID\n");
 				algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "SCO + A2DP ==> SCO\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "SCO + A2DP ==> SCO\n");
 				algorithm = BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "SCO + PAN(HS)\n");
 					algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "SCO + PAN(EDR)\n");
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_SCO_PAN;
 				}
@@ -649,38 +595,44 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (stack_info->num_of_hid >= 2) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID*2 + A2DP\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "HID*2 + A2DP\n");
 					algorithm =
 					BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + A2DP\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "HID + A2DP\n");
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_HID_A2DP;
 				}
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "HID + PAN(HS)\n");
 					algorithm = BT_8192E_2ANT_COEX_ALGO_HID;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "HID + PAN(EDR)\n");
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "A2DP + PAN(HS)\n");
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_A2DP_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "A2DP + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "A2DP + PAN(EDR)\n");
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_A2DP;
 				}
@@ -690,30 +642,34 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "SCO + HID + A2DP ==> HID\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "SCO + HID + A2DP ==> HID\n");
 				algorithm = BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + HID + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "SCO + HID + PAN(HS)\n");
 					algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + HID + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "SCO + HID + PAN(EDR)\n");
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_SCO_PAN;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "SCO + A2DP + PAN(HS)\n");
 					algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + A2DP + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "SCO + A2DP + PAN(EDR)\n");
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 				}
@@ -723,13 +679,15 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + A2DP + PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "HID + A2DP + PAN(HS)\n");
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + A2DP + PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "HID + A2DP + PAN(EDR)\n");
 					algorithm =
 					BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				}
@@ -741,12 +699,14 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "ErrorSCO+HID+A2DP+PAN(HS)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "ErrorSCO+HID+A2DP+PAN(HS)\n");
 
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO+HID+A2DP+PAN(EDR)\n");
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "SCO+HID+A2DP+PAN(EDR)\n");
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 				}
@@ -760,6 +720,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 static void halbtc8192e2ant_setfw_dac_swinglevel(struct btc_coexist *btcoexist,
 						 u8 dac_swinglvl)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	/* There are several type of dacswing
@@ -767,10 +728,10 @@ static void halbtc8192e2ant_setfw_dac_swinglevel(struct btc_coexist *btcoexist,
 	 */
 	h2c_parameter[0] = dac_swinglvl;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Set Dac Swing Level = 0x%x\n", dac_swinglvl);
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x64 = 0x%x\n", h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Set Dac Swing Level = 0x%x\n", dac_swinglvl);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], FW write 0x64 = 0x%x\n", h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x64, 1, h2c_parameter);
 }
@@ -778,13 +739,14 @@ static void halbtc8192e2ant_setfw_dac_swinglevel(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_set_fwdec_btpwr(struct btc_coexist *btcoexist,
 					    u8 dec_btpwr_lvl)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	h2c_parameter[0] = dec_btpwr_lvl;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex] decrease Bt Power level = %d, FW write 0x62 = 0x%x\n",
-		    dec_btpwr_lvl, h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex] decrease Bt Power level = %d, FW write 0x62 = 0x%x\n",
+		 dec_btpwr_lvl, h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
@@ -792,14 +754,16 @@ static void halbtc8192e2ant_set_fwdec_btpwr(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_dec_btpwr(struct btc_coexist *btcoexist,
 				      bool force_exec, u8 dec_btpwr_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s Dec BT power level = %d\n",
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s Dec BT power level = %d\n",
 		    (force_exec ? "force to" : ""), dec_btpwr_lvl);
 	coex_dm->cur_dec_bt_pwr = dec_btpwr_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], preBtDecPwrLvl=%d, curBtDecPwrLvl=%d\n",
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], preBtDecPwrLvl=%d, curBtDecPwrLvl=%d\n",
 			    coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
 	}
 	halbtc8192e2ant_set_fwdec_btpwr(btcoexist, coex_dm->cur_dec_bt_pwr);
@@ -810,6 +774,7 @@ static void halbtc8192e2ant_dec_btpwr(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_set_bt_autoreport(struct btc_coexist *btcoexist,
 					      bool enable_autoreport)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	h2c_parameter[0] = 0;
@@ -817,10 +782,10 @@ static void halbtc8192e2ant_set_bt_autoreport(struct btc_coexist *btcoexist,
 	if (enable_autoreport)
 		h2c_parameter[0] |= BIT0;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		    (enable_autoreport ? "Enabled!!" : "Disabled!!"),
-		    h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
+		 (enable_autoreport ? "Enabled!!" : "Disabled!!"),
+		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
 }
@@ -829,17 +794,19 @@ static void halbtc8192e2ant_bt_autoreport(struct btc_coexist *btcoexist,
 					  bool force_exec,
 					  bool enable_autoreport)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s BT Auto report = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((enable_autoreport) ? "Enabled" : "Disabled"));
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s BT Auto report = %s\n",
+		 (force_exec ? "force to" : ""),
+		 ((enable_autoreport) ? "Enabled" : "Disabled"));
 	coex_dm->cur_bt_auto_report = enable_autoreport;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex] bPreBtAutoReport=%d, bCurBtAutoReport=%d\n",
-			    coex_dm->pre_bt_auto_report,
-			    coex_dm->cur_bt_auto_report);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex] bPreBtAutoReport=%d, bCurBtAutoReport=%d\n",
+			 coex_dm->pre_bt_auto_report,
+			 coex_dm->cur_bt_auto_report);
 
 		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
 			return;
@@ -853,16 +820,18 @@ static void halbtc8192e2ant_bt_autoreport(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_fw_dac_swinglvl(struct btc_coexist *btcoexist,
 					    bool force_exec, u8 fw_dac_swinglvl)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s set FW Dac Swing level = %d\n",
-		    (force_exec ? "force to" : ""), fw_dac_swinglvl);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s set FW Dac Swing level = %d\n",
+		 (force_exec ? "force to" : ""), fw_dac_swinglvl);
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swinglvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex] preFwDacSwingLvl=%d, curFwDacSwingLvl=%d\n",
-			    coex_dm->pre_fw_dac_swing_lvl,
-			    coex_dm->cur_fw_dac_swing_lvl);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex] preFwDacSwingLvl=%d, curFwDacSwingLvl=%d\n",
+			 coex_dm->pre_fw_dac_swing_lvl,
+			 coex_dm->cur_fw_dac_swing_lvl);
 
 		if (coex_dm->pre_fw_dac_swing_lvl ==
 		    coex_dm->cur_fw_dac_swing_lvl)
@@ -878,10 +847,12 @@ static void halbtc8192e2ant_fw_dac_swinglvl(struct btc_coexist *btcoexist,
 static void btc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
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
@@ -889,8 +860,8 @@ static void btc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
 		 * After initialized, we can use coex_dm->btRf0x1eBackup
 		 */
 		if (btcoexist->initilized) {
-			btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-				    "[BTCoex], Resume RF Rx LPF corner!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], Resume RF Rx LPF corner!!\n");
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
 						  0xfffff,
 						  coex_dm->bt_rf0x1e_backup);
@@ -901,17 +872,19 @@ static void btc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
 				      bool force_exec, bool rx_rf_shrink_on)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn Rx RF Shrink = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((rx_rf_shrink_on) ? "ON" : "OFF"));
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s turn Rx RF Shrink = %s\n",
+		 (force_exec ? "force to" : ""),
+		 ((rx_rf_shrink_on) ? "ON" : "OFF"));
 	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex]bPreRfRxLpfShrink=%d,bCurRfRxLpfShrink=%d\n",
-			    coex_dm->pre_rf_rx_lpf_shrink,
-			    coex_dm->cur_rf_rx_lpf_shrink);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex]bPreRfRxLpfShrink=%d,bCurRfRxLpfShrink=%d\n",
+			 coex_dm->pre_rf_rx_lpf_shrink,
+			 coex_dm->cur_rf_rx_lpf_shrink);
 
 		if (coex_dm->pre_rf_rx_lpf_shrink ==
 		    coex_dm->cur_rf_rx_lpf_shrink)
@@ -926,10 +899,11 @@ static void halbtc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_set_dac_swingreg(struct btc_coexist *btcoexist,
 					     u32 level)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 val = (u8)level;
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], Write SwDacSwing = 0x%x\n", level);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Write SwDacSwing = 0x%x\n", level);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x883, 0x3e, val);
 }
 
@@ -947,22 +921,24 @@ static void halbtc8192e2ant_DacSwing(struct btc_coexist *btcoexist,
 				     bool force_exec, bool dac_swingon,
 				     u32 dac_swinglvl)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn DacSwing=%s, dac_swinglvl = 0x%x\n",
-		    (force_exec ? "force to" : ""),
-		    ((dac_swingon) ? "ON" : "OFF"), dac_swinglvl);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s turn DacSwing=%s, dac_swinglvl = 0x%x\n",
+		 (force_exec ? "force to" : ""),
+		 ((dac_swingon) ? "ON" : "OFF"), dac_swinglvl);
 	coex_dm->cur_dac_swing_on = dac_swingon;
 	coex_dm->cur_dac_swing_lvl = dac_swinglvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], bPreDacSwingOn=%d, preDacSwingLvl = 0x%x, ",
-			    coex_dm->pre_dac_swing_on,
-			    coex_dm->pre_dac_swing_lvl);
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "bCurDacSwingOn=%d, curDacSwingLvl = 0x%x\n",
-			    coex_dm->cur_dac_swing_on,
-			    coex_dm->cur_dac_swing_lvl);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreDacSwingOn=%d, preDacSwingLvl = 0x%x, ",
+			 coex_dm->pre_dac_swing_on,
+			 coex_dm->pre_dac_swing_lvl);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "bCurDacSwingOn=%d, curDacSwingLvl = 0x%x\n",
+			 coex_dm->cur_dac_swing_on,
+			 coex_dm->cur_dac_swing_lvl);
 
 		if ((coex_dm->pre_dac_swing_on == coex_dm->cur_dac_swing_on) &&
 		    (coex_dm->pre_dac_swing_lvl == coex_dm->cur_dac_swing_lvl))
@@ -978,10 +954,12 @@ static void halbtc8192e2ant_DacSwing(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
 					  bool agc_table_en)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	/* BB AGC Gain Table */
 	if (agc_table_en) {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], BB Agc Table On!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BB Agc Table On!\n");
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x0a1A0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x091B0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x081C0001);
@@ -989,8 +967,8 @@ static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x061E0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x051F0001);
 	} else {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], BB Agc Table Off!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BB Agc Table Off!\n");
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xaa1A0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa91B0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa81C0001);
@@ -1003,17 +981,19 @@ static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_AgcTable(struct btc_coexist *btcoexist,
 				     bool force_exec, bool agc_table_en)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s %s Agc Table\n",
-		    (force_exec ? "force to" : ""),
-		    ((agc_table_en) ? "Enable" : "Disable"));
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s %s Agc Table\n",
+		 (force_exec ? "force to" : ""),
+		 ((agc_table_en) ? "Enable" : "Disable"));
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
@@ -1027,20 +1007,22 @@ static void halbtc8192e2ant_set_coex_table(struct btc_coexist *btcoexist,
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
 
@@ -1049,30 +1031,32 @@ static void halbtc8192e2ant_coex_table(struct btc_coexist *btcoexist,
 				       u32 val0x6c0, u32 val0x6c4,
 				       u32 val0x6c8, u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, ",
-		    (force_exec ? "force to" : ""), val0x6c0);
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
-		    val0x6c4, val0x6c8, val0x6cc);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, ",
+		 (force_exec ? "force to" : ""), val0x6c0);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
+		 val0x6c4, val0x6c8, val0x6cc);
 	coex_dm->cur_val0x6c0 = val0x6c0;
 	coex_dm->cur_val0x6c4 = val0x6c4;
 	coex_dm->cur_val0x6c8 = val0x6c8;
 	coex_dm->cur_val0x6cc = val0x6cc;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], preVal0x6c0 = 0x%x, preVal0x6c4 = 0x%x, ",
-			    coex_dm->pre_val0x6c0, coex_dm->pre_val0x6c4);
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "preVal0x6c8 = 0x%x, preVal0x6cc = 0x%x !!\n",
-			    coex_dm->pre_val0x6c8, coex_dm->pre_val0x6cc);
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], curVal0x6c0 = 0x%x, curVal0x6c4 = 0x%x\n",
-			    coex_dm->cur_val0x6c0, coex_dm->cur_val0x6c4);
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "curVal0x6c8 = 0x%x, curVal0x6cc = 0x%x !!\n",
-			    coex_dm->cur_val0x6c8, coex_dm->cur_val0x6cc);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], preVal0x6c0 = 0x%x, preVal0x6c4 = 0x%x, ",
+			 coex_dm->pre_val0x6c0, coex_dm->pre_val0x6c4);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "preVal0x6c8 = 0x%x, preVal0x6cc = 0x%x !!\n",
+			 coex_dm->pre_val0x6c8, coex_dm->pre_val0x6cc);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], curVal0x6c0 = 0x%x, curVal0x6c4 = 0x%x\n",
+			 coex_dm->cur_val0x6c0, coex_dm->cur_val0x6c4);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "curVal0x6c8 = 0x%x, curVal0x6cc = 0x%x !!\n",
+			 coex_dm->cur_val0x6c8, coex_dm->cur_val0x6cc);
 
 		if ((coex_dm->pre_val0x6c0 == coex_dm->cur_val0x6c0) &&
 		    (coex_dm->pre_val0x6c4 == coex_dm->cur_val0x6c4) &&
@@ -1121,14 +1105,15 @@ static void btc8192e2ant_coex_tbl_w_type(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_set_fw_ignore_wlanact(struct btc_coexist *btcoexist,
 						  bool enable)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	if (enable)
 		h2c_parameter[0] |= BIT0; /* function enable */
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex]set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
-		    h2c_parameter[0]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex]set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
+		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
@@ -1136,18 +1121,20 @@ static void halbtc8192e2ant_set_fw_ignore_wlanact(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_IgnoreWlanAct(struct btc_coexist *btcoexist,
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
-			    "[BTCoex], bPreIgnoreWlanAct = %d ",
-			    coex_dm->pre_ignore_wlan_act);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "bCurIgnoreWlanAct = %d!!\n",
-			    coex_dm->cur_ignore_wlan_act);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bPreIgnoreWlanAct = %d ",
+			 coex_dm->pre_ignore_wlan_act);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "bCurIgnoreWlanAct = %d!!\n",
+			 coex_dm->cur_ignore_wlan_act);
 
 		if (coex_dm->pre_ignore_wlan_act ==
 		    coex_dm->cur_ignore_wlan_act)
@@ -1161,6 +1148,8 @@ static void halbtc8192e2ant_IgnoreWlanAct(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_SetFwPstdma(struct btc_coexist *btcoexist, u8 byte1,
 					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	u8 h2c_parameter[5] = {0};
 
 	h2c_parameter[0] = byte1;
@@ -1175,11 +1164,11 @@ static void halbtc8192e2ant_SetFwPstdma(struct btc_coexist *btcoexist, u8 byte1,
 	coex_dm->ps_tdma_para[3] = byte4;
 	coex_dm->ps_tdma_para[4] = byte5;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x60(5bytes) = 0x%x%08x\n",
-		    h2c_parameter[0],
-		    h2c_parameter[1] << 24 | h2c_parameter[2] << 16 |
-		    h2c_parameter[3] << 8 | h2c_parameter[4]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], FW write 0x60(5bytes) = 0x%x%08x\n",
+		 h2c_parameter[0],
+		 h2c_parameter[1] << 24 | h2c_parameter[2] << 16 |
+		 h2c_parameter[3] << 8 | h2c_parameter[4]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
@@ -1203,20 +1192,22 @@ static void btc8192e2ant_sw_mec2(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 				    bool force_exec, bool turn_on, u8 type)
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
@@ -1340,11 +1331,12 @@ static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_set_switch_sstype(struct btc_coexist *btcoexist,
 					      u8 sstype)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 mimops = BTC_MIMO_PS_DYNAMIC;
 	u32 disra_mask = 0x0;
 
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], REAL set SS Type = %d\n", sstype);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], REAL set SS Type = %d\n", sstype);
 
 	disra_mask = halbtc8192e2ant_decidera_mask(btcoexist, sstype,
 						   coex_dm->curra_masktype);
@@ -1376,9 +1368,11 @@ static void halbtc8192e2ant_set_switch_sstype(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_switch_sstype(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 new_sstype)
 {
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], %s Switch SS Type = %d\n",
-		    (force_exec ? "force to" : ""), new_sstype);
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], %s Switch SS Type = %d\n",
+		 (force_exec ? "force to" : ""), new_sstype);
 	coex_dm->cur_sstype = new_sstype;
 
 	if (!force_exec) {
@@ -1440,6 +1434,7 @@ static void halbtc8192e2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 
 static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool common = false, wifi_connected = false, wifi_busy = false;
 	bool bt_hson = false, low_pwr_disable = false;
@@ -1459,8 +1454,8 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
 
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi non-connected idle!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Wifi non-connected idle!!\n");
 
 		if ((BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 		     coex_dm->bt_status) ||
@@ -1496,8 +1491,8 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 					   BTC_SET_ACT_DISABLE_LOW_POWER,
 					   &low_pwr_disable);
 
-			btc_alg_dbg(ALGO_TRACE,
-				    "Wifi connected + BT non connected-idle!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Wifi connected + BT non connected-idle!!\n");
 
 			halbtc8192e2ant_switch_sstype(btcoexist,
 						      NORMAL_EXEC, 2);
@@ -1524,8 +1519,8 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 
 			if (bt_hson)
 				return false;
-			btc_alg_dbg(ALGO_TRACE,
-				    "Wifi connected + BT connected-idle!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Wifi connected + BT connected-idle!!\n");
 
 			halbtc8192e2ant_switch_sstype(btcoexist,
 						      NORMAL_EXEC, 2);
@@ -1550,12 +1545,12 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 					   &low_pwr_disable);
 
 			if (wifi_busy) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "Wifi Connected-Busy + BT Busy!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "Wifi Connected-Busy + BT Busy!!\n");
 				common = false;
 			} else {
-				btc_alg_dbg(ALGO_TRACE,
-					    "Wifi Connected-Idle + BT Busy!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "Wifi Connected-Idle + BT Busy!!\n");
 
 				halbtc8192e2ant_switch_sstype(btcoexist,
 							      NORMAL_EXEC, 1);
@@ -1581,9 +1576,11 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 static void btc8192e_int1(struct btc_coexist *btcoexist, bool tx_pause,
 			  int result)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 1\n");
 
 		if (coex_dm->cur_ps_tdma == 71) {
 			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
@@ -1678,8 +1675,8 @@ static void btc8192e_int1(struct btc_coexist *btcoexist, bool tx_pause,
 			}
 		}
 	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 0\n");
 		if (coex_dm->cur_ps_tdma == 5) {
 			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 71);
@@ -1782,9 +1779,11 @@ static void btc8192e_int1(struct btc_coexist *btcoexist, bool tx_pause,
 static void btc8192e_int2(struct btc_coexist *btcoexist, bool tx_pause,
 			  int result)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 1\n");
 		if (coex_dm->cur_ps_tdma == 1) {
 			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 6);
@@ -1873,8 +1872,8 @@ static void btc8192e_int2(struct btc_coexist *btcoexist, bool tx_pause,
 			}
 		}
 	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 0\n");
 		if (coex_dm->cur_ps_tdma == 5) {
 			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 2);
@@ -1968,9 +1967,11 @@ static void btc8192e_int2(struct btc_coexist *btcoexist, bool tx_pause,
 static void btc8192e_int3(struct btc_coexist *btcoexist, bool tx_pause,
 			  int result)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 1\n");
 		if (coex_dm->cur_ps_tdma == 1) {
 			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 7);
@@ -2059,8 +2060,8 @@ static void btc8192e_int3(struct btc_coexist *btcoexist, bool tx_pause,
 			}
 		}
 	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], TxPause = 0\n");
 		if (coex_dm->cur_ps_tdma == 5) {
 			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 3);
@@ -2155,6 +2156,7 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 						 bool sco_hid, bool tx_pause,
 						 u8 max_interval)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static int up, dn, m, n, wait_cnt;
 	/* 0: no change, +1: increase WiFi duration,
 	 * -1: decrease WiFi duration
@@ -2162,13 +2164,13 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 	int result;
 	u8 retry_cnt = 0;
 
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
@@ -2272,11 +2274,11 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 	} else {
 		/* accquire the BT TRx retry count from BT_Info byte2 */
 		retry_cnt = coex_sta->bt_retry_cnt;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], retry_cnt = %d\n", retry_cnt);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], up=%d, dn=%d, m=%d, n=%d, wait_cnt=%d\n",
-			    up, dn, m, n, wait_cnt);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], retry_cnt = %d\n", retry_cnt);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], up=%d, dn=%d, m=%d, n=%d, wait_cnt=%d\n",
+			 up, dn, m, n, wait_cnt);
 		result = 0;
 		wait_cnt++;
 		/* no retry in the last 2-second duration */
@@ -2293,8 +2295,8 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				up = 0;
 				dn = 0;
 				result = 1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex]Increase wifi duration!!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex]Increase wifi duration!!\n");
 			}
 		} else if (retry_cnt <= 3) {
 			up--;
@@ -2317,8 +2319,8 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 				dn = 0;
 				wait_cnt = 0;
 				result = -1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "Reduce wifi duration for retry<3\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "Reduce wifi duration for retry<3\n");
 			}
 		} else {
 			if (wait_cnt == 1)
@@ -2334,12 +2336,12 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 			dn = 0;
 			wait_cnt = 0;
 			result = -1;
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "Decrease wifi duration for retryCounter>3!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Decrease wifi duration for retryCounter>3!!\n");
 		}
 
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], max Interval = %d\n", max_interval);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], max Interval = %d\n", max_interval);
 		if (max_interval == 1)
 			btc8192e_int1(btcoexist, tx_pause, result);
 		else if (max_interval == 2)
@@ -2355,11 +2357,11 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 	if (coex_dm->cur_ps_tdma != coex_dm->tdma_adj_type) {
 		bool scan = false, link = false, roam = false;
 
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], PsTdma type dismatch!!!, ");
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "curPsTdma=%d, recordPsTdma=%d\n",
-			    coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], PsTdma type dismatch!!!, ");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "curPsTdma=%d, recordPsTdma=%d\n",
+			 coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
@@ -2370,8 +2372,8 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 						true,
 						coex_dm->tdma_adj_type);
 		else
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
 	}
 }
 
@@ -2390,7 +2392,7 @@ static void halbtc8192e2ant_action_sco(struct btc_coexist *btcoexist)
 
 	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 4);
 
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
 	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
@@ -2452,7 +2454,7 @@ static void halbtc8192e2ant_action_sco_pan(struct btc_coexist *btcoexist)
 
 	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 4);
 
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
 	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
@@ -2506,7 +2508,7 @@ static void halbtc8192e2ant_action_hid(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -2564,19 +2566,20 @@ static void halbtc8192e2ant_action_hid(struct btc_coexist *btcoexist)
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
 static void halbtc8192e2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 	bool long_dist = false;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	if ((btrssi_state == BTC_RSSI_STATE_LOW ||
 	     btrssi_state == BTC_RSSI_STATE_STAY_LOW) &&
 	    (wifirssi_state == BTC_RSSI_STATE_LOW ||
 	     wifirssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], A2dp, wifi/bt rssi both LOW!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], A2dp, wifi/bt rssi both LOW!!\n");
 		long_dist = true;
 	}
 	if (long_dist) {
@@ -2656,7 +2659,7 @@ static void halbtc8192e2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -2717,7 +2720,7 @@ static void halbtc8192e2ant_action_pan_edr(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -2778,7 +2781,7 @@ static void halbtc8192e2ant_action_pan_hs(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -2836,7 +2839,7 @@ static void halbtc8192e2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -2899,7 +2902,7 @@ static void halbtc8192e2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -2963,7 +2966,7 @@ static void btc8192e2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -3024,7 +3027,7 @@ static void halbtc8192e2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
 
 	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
@@ -3079,107 +3082,108 @@ static void halbtc8192e2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 algorithm = 0;
 
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], RunCoexistMechanism()===>\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], RunCoexistMechanism()===>\n");
 
 	if (btcoexist->manual_control) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], return for Manual CTRL <===\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], return for Manual CTRL <===\n");
 		return;
 	}
 
 	if (coex_sta->under_ips) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], wifi is under IPS !!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], wifi is under IPS !!!\n");
 		return;
 	}
 
 	algorithm = halbtc8192e2ant_action_algorithm(btcoexist);
 	if (coex_sta->c2h_bt_inquiry_page &&
 	    (BT_8192E_2ANT_COEX_ALGO_PANHS != algorithm)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BT is under inquiry/page scan !!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is under inquiry/page scan !!\n");
 		halbtc8192e2ant_action_bt_inquiry(btcoexist);
 		return;
 	}
 
 	coex_dm->cur_algorithm = algorithm;
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], Algorithm = %d\n", coex_dm->cur_algorithm);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Algorithm = %d\n", coex_dm->cur_algorithm);
 
 	if (halbtc8192e2ant_is_common_action(btcoexist)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Action 2-Ant common\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], Action 2-Ant common\n");
 		coex_dm->auto_tdma_adjust = false;
 	} else {
 		if (coex_dm->cur_algorithm != coex_dm->pre_algorithm) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex] preAlgorithm=%d, curAlgorithm=%d\n",
-				    coex_dm->pre_algorithm,
-				    coex_dm->cur_algorithm);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "[BTCoex] preAlgorithm=%d, curAlgorithm=%d\n",
+				 coex_dm->pre_algorithm,
+				 coex_dm->cur_algorithm);
 			coex_dm->auto_tdma_adjust = false;
 		}
 		switch (coex_dm->cur_algorithm) {
 		case BT_8192E_2ANT_COEX_ALGO_SCO:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = SCO\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = SCO\n");
 			halbtc8192e2ant_action_sco(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_SCO_PAN:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = SCO+PAN(EDR)\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = SCO+PAN(EDR)\n");
 			halbtc8192e2ant_action_sco_pan(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HID\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = HID\n");
 			halbtc8192e2ant_action_hid(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = A2DP\n");
 			halbtc8192e2ant_action_a2dp(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_A2DP_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
 			halbtc8192e2ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = PAN(EDR)\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = PAN(EDR)\n");
 			halbtc8192e2ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HS mode\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = HS mode\n");
 			halbtc8192e2ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = PAN+A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = PAN+A2DP\n");
 			halbtc8192e2ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = PAN(EDR)+HID\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = PAN(EDR)+HID\n");
 			halbtc8192e2ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HID+A2DP+PAN\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = HID+A2DP+PAN\n");
 			btc8192e2ant_action_hid_a2dp_pan_edr(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HID+A2DP\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = HID+A2DP\n");
 			halbtc8192e2ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = unknown!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "Action 2-Ant, algorithm = unknown!!\n");
 			/* halbtc8192e2ant_coex_alloff(btcoexist); */
 			break;
 		}
@@ -3553,6 +3557,7 @@ void ex_halbtc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 					    u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_center_chnl;
@@ -3587,10 +3592,10 @@ void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 	coex_dm->wifi_chnl_info[1] = h2c_parameter[1];
 	coex_dm->wifi_chnl_info[2] = h2c_parameter[2];
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x66 = 0x%x\n",
-		    h2c_parameter[0] << 16 | h2c_parameter[1] << 8 |
-		    h2c_parameter[2]);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], FW write 0x66 = 0x%x\n",
+		 h2c_parameter[0] << 16 | h2c_parameter[1] << 8 |
+		 h2c_parameter[2]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
@@ -3606,6 +3611,7 @@ void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
 void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 				       u8 *tmp_buf, u8 length)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool bt_busy = false, limited_dig = false;
@@ -3647,8 +3653,8 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		 * because bt is reset and loss of the info.
 		 */
 		if ((coex_sta->bt_info_ext & BIT1)) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "bit1, send wifi BW&Chnl to BT!!\n");
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "bit1, send wifi BW&Chnl to BT!!\n");
 			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
 			if (wifi_connected)
@@ -3664,8 +3670,8 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		if ((coex_sta->bt_info_ext & BIT3)) {
 			if (!btcoexist->manual_control &&
 			    !btcoexist->stop_coex_dm) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "bit3, BT NOT ignore Wlan active!\n");
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "bit3, BT NOT ignore Wlan active!\n");
 				halbtc8192e2ant_IgnoreWlanAct(btcoexist,
 							      FORCE_EXEC,
 							      false);
@@ -3723,25 +3729,25 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 	if (!(bt_info&BT_INFO_8192E_2ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BT Non-Connected idle!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT Non-Connected idle!!!\n");
 	} else if (bt_info == BT_INFO_8192E_2ANT_B_CONNECTION) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], bt_infoNotify(), BT Connected-idle!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bt_infoNotify(), BT Connected-idle!!!\n");
 	} else if ((bt_info&BT_INFO_8192E_2ANT_B_SCO_ESCO) ||
 		   (bt_info&BT_INFO_8192E_2ANT_B_SCO_BUSY)) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_SCO_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], bt_infoNotify(), BT SCO busy!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bt_infoNotify(), BT SCO busy!!!\n");
 	} else if (bt_info&BT_INFO_8192E_2ANT_B_ACL_BUSY) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_ACL_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], bt_infoNotify(), BT ACL busy!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], bt_infoNotify(), BT ACL busy!!!\n");
 	} else {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_MAX;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex]bt_infoNotify(), BT Non-Defined state!!!\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex]bt_infoNotify(), BT Non-Defined state!!!\n");
 	}
 
 	if ((BT_8192E_2ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) ||
@@ -3777,13 +3783,14 @@ void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 
 void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static u8 dis_ver_info_cnt;
 	u32 fw_ver = 0, bt_patch_ver = 0;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 
-	btc_alg_dbg(ALGO_TRACE,
-		    "=======================Periodical=======================\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "=======================Periodical=======================\n");
 	if (dis_ver_info_cnt <= 5) {
 		dis_ver_info_cnt += 1;
 		btc_iface_dbg(INTF_INIT,
-- 
2.10.2
