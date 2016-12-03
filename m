Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33713 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbcLCRc0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Dec 2016 12:32:26 -0500
Received: by mail-oi0-f68.google.com with SMTP id f201so31495682oib.0
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2016 09:32:26 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/7] rtlwifi: btcoexist: Update routines for RTL8192EE
Date: Sat,  3 Dec 2016 11:32:01 -0600
Message-Id: <20161203173207.17774-2-Larry.Finger@lwfinger.net> (sfid-20161203_183233_738828_3055FBB3)
In-Reply-To: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
References: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The btcoexist routines for the RTL8192EE have been extensively rewritten.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 4598 ++++++++++----------
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  243 +-
 2 files changed, 2508 insertions(+), 2333 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index a30af6c..bcaa440 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -22,7 +22,7 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *
  *****************************************************************************/
-/**************************************************************
+/* ************************************************************
  * Description:
  *
  * This file is for RTL8192E Co-exist mechanism
@@ -30,171 +30,131 @@
  * History
  * 2012/11/15 Cosa first check in.
  *
- **************************************************************/
+ * ************************************************************
+ */
 
-/**************************************************************
- *   include files
- **************************************************************/
+/* ************************************************************
+ * include files
+ * ************************************************************
+ */
 #include "halbt_precomp.h"
-/**************************************************************
- *   Global variables, these are static variables
- **************************************************************/
+
+/* ************************************************************
+ * Global variables, these are static variables
+ * ************************************************************
+ */
 static struct coex_dm_8192e_2ant glcoex_dm_8192e_2ant;
 static struct coex_dm_8192e_2ant *coex_dm = &glcoex_dm_8192e_2ant;
 static struct coex_sta_8192e_2ant glcoex_sta_8192e_2ant;
 static struct coex_sta_8192e_2ant *coex_sta = &glcoex_sta_8192e_2ant;
 
-static const char *const GLBtInfoSrc8192e2Ant[] = {
-	"BT Info[wifi fw]",
-	"BT Info[bt rsp]",
-	"BT Info[bt auto report]",
+static const char *const glbt_info_src_8192e_2ant[] = {
+	"BT Info[wifi fw]", "BT Info[bt rsp]", "BT Info[bt auto report]",
 };
 
-static u32 glcoex_ver_date_8192e_2ant = 20130902;
-static u32 glcoex_ver_8192e_2ant = 0x34;
+static u32 glcoex_ver_date_8192e_2ant = 20130912;
+static u32 glcoex_ver_8192e_2ant = 0x35;
 
-/**************************************************************
- *   local function proto type if needed
- **************************************************************/
-/**************************************************************
- *   local function start with halbtc8192e2ant_
- **************************************************************/
-static u8 halbtc8192e2ant_btrssi_state(u8 level_num, u8 rssi_thresh,
-				       u8 rssi_thresh1)
+/* ************************************************************
+ * local function proto type if needed
+ * ************************************************************
+ * ************************************************************
+ * local function start with halbtc8192e2ant_
+ * ************************************************************
+ */
+static u8 halbtc8192e2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
+					u8 rssi_thresh1)
 {
-	int btrssi = 0;
-	u8 btrssi_state = coex_sta->pre_bt_rssi_state;
+	s32 bt_rssi = 0;
+	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btrssi = coex_sta->bt_rssi;
+	bt_rssi = coex_sta->bt_rssi;
 
 	if (level_num == 2) {
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = LOW\n");
-			if (btrssi >= (rssi_thresh +
-				       BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
-				btrssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to High\n");
-			} else {
-				btrssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at Low\n");
-			}
+			if (bt_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				bt_rssi_state = BTC_RSSI_STATE_HIGH;
+			else
+				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = HIGH\n");
-			if (btrssi < rssi_thresh) {
-				btrssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Low\n");
-			} else {
-				btrssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at High\n");
-			}
+			if (bt_rssi < rssi_thresh)
+				bt_rssi_state = BTC_RSSI_STATE_LOW;
+			else
+				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi thresh error!!\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], BT Rssi thresh error!!\n");
+			BTC_TRACE(trace_buf);
 			return coex_sta->pre_bt_rssi_state;
 		}
 
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = LOW\n");
-			if (btrssi >= (rssi_thresh +
-				      BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
-				btrssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Medium\n");
-			} else {
-				btrssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at Low\n");
-			}
+			if (bt_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
+			else
+				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else if ((coex_sta->pre_bt_rssi_state ==
 			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_bt_rssi_state ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "[BTCoex], BT Rssi pre state = MEDIUM\n");
-			if (btrssi >= (rssi_thresh1 +
-				       BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
-				btrssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to High\n");
-			} else if (btrssi < rssi_thresh) {
-				btrssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Low\n");
-			} else {
-				btrssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at Medium\n");
-			}
+			if (bt_rssi >= (rssi_thresh1 +
+					BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				bt_rssi_state = BTC_RSSI_STATE_HIGH;
+			else if (bt_rssi < rssi_thresh)
+				bt_rssi_state = BTC_RSSI_STATE_LOW;
+			else
+				bt_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
 		} else {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
-				    "BT Rssi pre state = HIGH\n");
-			if (btrssi < rssi_thresh1) {
-				btrssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state switch to Medium\n");
-			} else {
-				btrssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "BT Rssi state stay at High\n");
-			}
+			if (bt_rssi < rssi_thresh1)
+				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
+			else
+				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
 		}
 	}
 
-	coex_sta->pre_bt_rssi_state = btrssi_state;
+	coex_sta->pre_bt_rssi_state = bt_rssi_state;
 
-	return btrssi_state;
+	return bt_rssi_state;
 }
 
-static u8 halbtc8192e2ant_wifirssi_state(struct btc_coexist *btcoexist,
-					 u8 index, u8 level_num, u8 rssi_thresh,
-					 u8 rssi_thresh1)
+static u8 halbtc8192e2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
+					  u8 index, u8 level_num,
+					  u8 rssi_thresh, u8 rssi_thresh1)
 {
-	int wifirssi = 0;
-	u8 wifirssi_state = coex_sta->pre_wifi_rssi_state[index];
+	s32 wifi_rssi = 0;
+	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifirssi);
+	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 
 	if (level_num == 2) {
 		if ((coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifirssi >= (rssi_thresh +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
-				wifirssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to High\n");
-			} else {
-				wifirssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at Low\n");
-			}
+			if (wifi_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else {
-			if (wifirssi < rssi_thresh) {
-				wifirssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Low\n");
-			} else {
-				wifirssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at High\n");
-			}
+			if (wifi_rssi < rssi_thresh)
+				wifi_rssi_state = BTC_RSSI_STATE_LOW;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-				    "wifi RSSI thresh error!!\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], wifi RSSI thresh error!!\n");
+			BTC_TRACE(trace_buf);
 			return coex_sta->pre_wifi_rssi_state[index];
 		}
 
@@ -202,153 +162,139 @@ static u8 halbtc8192e2ant_wifirssi_state(struct btc_coexist *btcoexist,
 		     BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifirssi >= (rssi_thresh +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
-				wifirssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Medium\n");
-			} else {
-				wifirssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at Low\n");
-			}
+			if (wifi_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else if ((coex_sta->pre_wifi_rssi_state[index] ==
 			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_wifi_rssi_state[index] ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
-			if (wifirssi >= (rssi_thresh1 +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT)) {
-				wifirssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to High\n");
-			} else if (wifirssi < rssi_thresh) {
-				wifirssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Low\n");
-			} else {
-				wifirssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at Medium\n");
-			}
+			if (wifi_rssi >= (rssi_thresh1 +
+					  BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+			else if (wifi_rssi < rssi_thresh)
+				wifi_rssi_state = BTC_RSSI_STATE_LOW;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
 		} else {
-			if (wifirssi < rssi_thresh1) {
-				wifirssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state switch to Medium\n");
-			} else {
-				wifirssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "wifi RSSI state stay at High\n");
-			}
+			if (wifi_rssi < rssi_thresh1)
+				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
+			else
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
 		}
 	}
 
-	coex_sta->pre_wifi_rssi_state[index] = wifirssi_state;
+	coex_sta->pre_wifi_rssi_state[index] = wifi_rssi_state;
 
-	return wifirssi_state;
+	return wifi_rssi_state;
 }
 
-static void btc8192e2ant_monitor_bt_enable_dis(struct btc_coexist *btcoexist)
+static void halbtc8192e2ant_monitor_bt_enable_disable(struct btc_coexist
+						      *btcoexist)
 {
-	static bool pre_bt_disabled;
 	static u32 bt_disable_cnt;
 	bool bt_active = true, bt_disabled = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	/* This function check if bt is disabled */
 
 	if (coex_sta->high_priority_tx == 0 &&
-	    coex_sta->high_priority_rx == 0 &&
-	    coex_sta->low_priority_tx == 0 &&
+	    coex_sta->high_priority_rx == 0 && coex_sta->low_priority_tx == 0 &&
 	    coex_sta->low_priority_rx == 0)
 		bt_active = false;
-
 	if (coex_sta->high_priority_tx == 0xffff &&
 	    coex_sta->high_priority_rx == 0xffff &&
 	    coex_sta->low_priority_tx == 0xffff &&
 	    coex_sta->low_priority_rx == 0xffff)
 		bt_active = false;
-
 	if (bt_active) {
 		bt_disable_cnt = 0;
 		bt_disabled = false;
 		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
 				   &bt_disabled);
-		btc_alg_dbg(ALGO_BT_MONITOR,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BT is enabled !!\n");
+		BTC_TRACE(trace_buf);
 	} else {
 		bt_disable_cnt++;
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], bt all counters = 0, %d times!!\n",
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], bt all counters=0, %d times!!\n",
 			    bt_disable_cnt);
+		BTC_TRACE(trace_buf);
 		if (bt_disable_cnt >= 2) {
 			bt_disabled = true;
 			btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
 					   &bt_disabled);
-			btc_alg_dbg(ALGO_BT_MONITOR,
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 				    "[BTCoex], BT is disabled !!\n");
+			BTC_TRACE(trace_buf);
 		}
 	}
-	if (pre_bt_disabled != bt_disabled) {
-		btc_alg_dbg(ALGO_BT_MONITOR,
+	if (coex_sta->bt_disabled != bt_disabled) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BT is from %s to %s!!\n",
-			    (pre_bt_disabled ? "disabled" : "enabled"),
+			    (coex_sta->bt_disabled ? "disabled" : "enabled"),
 			    (bt_disabled ? "disabled" : "enabled"));
-		pre_bt_disabled = bt_disabled;
+		BTC_TRACE(trace_buf);
+		coex_sta->bt_disabled = bt_disabled;
 	}
 }
 
-static u32 halbtc8192e2ant_decidera_mask(struct btc_coexist *btcoexist,
-					 u8 sstype, u32 ra_masktype)
+static u32 halbtc8192e2ant_decide_ra_mask(struct btc_coexist *btcoexist,
+					  u8 ss_type, u32 ra_mask_type)
 {
-	u32 disra_mask = 0x0;
+	u32 dis_ra_mask = 0x0;
 
-	switch (ra_masktype) {
+	switch (ra_mask_type) {
 	case 0: /* normal mode */
-		if (sstype == 2)
-			disra_mask = 0x0;	/* enable 2ss */
+		if (ss_type == 2)
+			dis_ra_mask = 0x0; /* enable 2ss */
 		else
-			disra_mask = 0xfff00000;/* disable 2ss */
+			dis_ra_mask = 0xfff00000; /* disable 2ss */
 		break;
 	case 1: /* disable cck 1/2 */
-		if (sstype == 2)
-			disra_mask = 0x00000003;/* enable 2ss */
+		if (ss_type == 2)
+			dis_ra_mask = 0x00000003; /* enable 2ss */
 		else
-			disra_mask = 0xfff00003;/* disable 2ss */
+			dis_ra_mask = 0xfff00003; /* disable 2ss */
 		break;
 	case 2: /* disable cck 1/2/5.5, ofdm 6/9/12/18/24, mcs 0/1/2/3/4 */
-		if (sstype == 2)
-			disra_mask = 0x0001f1f7;/* enable 2ss */
+		if (ss_type == 2)
+			dis_ra_mask = 0x0001f1f7; /* enable 2ss */
 		else
-			disra_mask = 0xfff1f1f7;/* disable 2ss */
+			dis_ra_mask = 0xfff1f1f7; /* disable 2ss */
 		break;
 	default:
 		break;
 	}
 
-	return disra_mask;
+	return dis_ra_mask;
 }
 
-static void halbtc8192e2ant_Updatera_mask(struct btc_coexist *btcoexist,
-					  bool force_exec, u32 dis_ratemask)
+static void halbtc8192e2ant_update_ra_mask(struct btc_coexist *btcoexist,
+					   bool force_exec, u32 dis_rate_mask)
 {
-	coex_dm->curra_mask = dis_ratemask;
+	coex_dm->cur_ra_mask = dis_rate_mask;
 
-	if (force_exec || (coex_dm->prera_mask != coex_dm->curra_mask))
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_ra_mask,
-				   &coex_dm->curra_mask);
-	coex_dm->prera_mask = coex_dm->curra_mask;
+	if (force_exec || (coex_dm->pre_ra_mask != coex_dm->cur_ra_mask))
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_RAMASK,
+				   &coex_dm->cur_ra_mask);
+	coex_dm->pre_ra_mask = coex_dm->cur_ra_mask;
 }
 
-static void btc8192e2ant_autorate_fallback_retry(struct btc_coexist *btcoexist,
-						 bool force_exec, u8 type)
+static void halbtc8192e2ant_auto_rate_fallback_retry(struct btc_coexist
+						     *btcoexist,
+						     bool force_exec, u8 type)
 {
-	bool wifi_under_bmode = false;
+	bool wifi_under_b_mode = false;
 
-	coex_dm->cur_arfrtype = type;
+	coex_dm->cur_arfr_type = type;
 
-	if (force_exec || (coex_dm->pre_arfrtype != coex_dm->cur_arfrtype)) {
-		switch (coex_dm->cur_arfrtype) {
-		case 0:	/* normal mode */
+	if (force_exec || (coex_dm->pre_arfr_type != coex_dm->cur_arfr_type)) {
+		switch (coex_dm->cur_arfr_type) {
+		case 0: /* normal mode */
 			btcoexist->btc_write_4byte(btcoexist, 0x430,
 						   coex_dm->backup_arfr_cnt1);
 			btcoexist->btc_write_4byte(btcoexist, 0x434,
@@ -357,8 +303,8 @@ static void btc8192e2ant_autorate_fallback_retry(struct btc_coexist *btcoexist,
 		case 1:
 			btcoexist->btc_get(btcoexist,
 					   BTC_GET_BL_WIFI_UNDER_B_MODE,
-					   &wifi_under_bmode);
-			if (wifi_under_bmode) {
+					   &wifi_under_b_mode);
+			if (wifi_under_b_mode) {
 				btcoexist->btc_write_4byte(btcoexist, 0x430,
 							   0x0);
 				btcoexist->btc_write_4byte(btcoexist, 0x434,
@@ -375,46 +321,46 @@ static void btc8192e2ant_autorate_fallback_retry(struct btc_coexist *btcoexist,
 		}
 	}
 
-	coex_dm->pre_arfrtype = coex_dm->cur_arfrtype;
+	coex_dm->pre_arfr_type = coex_dm->cur_arfr_type;
 }
 
-static void halbtc8192e2ant_retrylimit(struct btc_coexist *btcoexist,
-				       bool force_exec, u8 type)
+static void halbtc8192e2ant_retry_limit(struct btc_coexist *btcoexist,
+					bool force_exec, u8 type)
 {
-	coex_dm->cur_retrylimit_type = type;
+	coex_dm->cur_retry_limit_type = type;
 
-	if (force_exec || (coex_dm->pre_retrylimit_type !=
-			   coex_dm->cur_retrylimit_type)) {
-		switch (coex_dm->cur_retrylimit_type) {
-		case 0:	/* normal mode */
-				btcoexist->btc_write_2byte(btcoexist, 0x42a,
-						    coex_dm->backup_retrylimit);
-				break;
-		case 1:	/* retry limit = 8 */
-				btcoexist->btc_write_2byte(btcoexist, 0x42a,
-							   0x0808);
-				break;
+	if (force_exec ||
+	    (coex_dm->pre_retry_limit_type != coex_dm->cur_retry_limit_type)) {
+		switch (coex_dm->cur_retry_limit_type) {
+		case 0: /* normal mode */
+			btcoexist->btc_write_2byte(btcoexist, 0x42a,
+						   coex_dm->backup_retry_limit);
+			break;
+		case 1: /* retry limit=8 */
+			btcoexist->btc_write_2byte(btcoexist, 0x42a, 0x0808);
+			break;
 		default:
-				break;
+			break;
 		}
 	}
 
-	coex_dm->pre_retrylimit_type = coex_dm->cur_retrylimit_type;
+	coex_dm->pre_retry_limit_type = coex_dm->cur_retry_limit_type;
 }
 
-static void halbtc8192e2ant_ampdu_maxtime(struct btc_coexist *btcoexist,
-					  bool force_exec, u8 type)
+static void halbtc8192e2ant_ampdu_max_time(struct btc_coexist *btcoexist,
+					   bool force_exec, u8 type)
 {
-	coex_dm->cur_ampdutime_type = type;
+	coex_dm->cur_ampdu_time_type = type;
 
-	if (force_exec || (coex_dm->pre_ampdutime_type !=
-			   coex_dm->cur_ampdutime_type)) {
-		switch (coex_dm->cur_ampdutime_type) {
-		case 0:	/* normal mode */
-			btcoexist->btc_write_1byte(btcoexist, 0x456,
-						coex_dm->backup_ampdu_maxtime);
+	if (force_exec ||
+	    (coex_dm->pre_ampdu_time_type != coex_dm->cur_ampdu_time_type)) {
+		switch (coex_dm->cur_ampdu_time_type) {
+		case 0: /* normal mode */
+			btcoexist->btc_write_1byte(
+				btcoexist, 0x456,
+				coex_dm->backup_ampdu_max_time);
 			break;
-		case 1:	/* AMPDU timw = 0x38 * 32us */
+		case 1: /* AMPDU timw = 0x38 * 32us */
 			btcoexist->btc_write_1byte(btcoexist, 0x456, 0x38);
 			break;
 		default:
@@ -422,24 +368,25 @@ static void halbtc8192e2ant_ampdu_maxtime(struct btc_coexist *btcoexist,
 		}
 	}
 
-	coex_dm->pre_ampdutime_type = coex_dm->cur_ampdutime_type;
+	coex_dm->pre_ampdu_time_type = coex_dm->cur_ampdu_time_type;
 }
 
 static void halbtc8192e2ant_limited_tx(struct btc_coexist *btcoexist,
-				       bool force_exec, u8 ra_masktype,
-				       u8 arfr_type, u8 retrylimit_type,
-				       u8 ampdutime_type)
+				       bool force_exec, u8 ra_mask_type,
+				       u8 arfr_type, u8 retry_limit_type,
+				       u8 ampdu_time_type)
 {
-	u32 disra_mask = 0x0;
+	u32 dis_ra_mask = 0x0;
+
+	coex_dm->cur_ra_mask_type = ra_mask_type;
+	dis_ra_mask = halbtc8192e2ant_decide_ra_mask(
+		btcoexist, coex_dm->cur_ss_type, ra_mask_type);
+	halbtc8192e2ant_update_ra_mask(btcoexist, force_exec, dis_ra_mask);
 
-	coex_dm->curra_masktype = ra_masktype;
-	disra_mask = halbtc8192e2ant_decidera_mask(btcoexist,
-						   coex_dm->cur_sstype,
-						   ra_masktype);
-	halbtc8192e2ant_Updatera_mask(btcoexist, force_exec, disra_mask);
-btc8192e2ant_autorate_fallback_retry(btcoexist, force_exec, arfr_type);
-	halbtc8192e2ant_retrylimit(btcoexist, force_exec, retrylimit_type);
-	halbtc8192e2ant_ampdu_maxtime(btcoexist, force_exec, ampdutime_type);
+	halbtc8192e2ant_auto_rate_fallback_retry(btcoexist, force_exec,
+						 arfr_type);
+	halbtc8192e2ant_retry_limit(btcoexist, force_exec, retry_limit_type);
+	halbtc8192e2ant_ampdu_max_time(btcoexist, force_exec, ampdu_time_type);
 }
 
 static void halbtc8192e2ant_limited_rx(struct btc_coexist *btcoexist,
@@ -451,16 +398,15 @@ static void halbtc8192e2ant_limited_rx(struct btc_coexist *btcoexist,
 	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
 	u8 rx_agg_size = agg_buf_size;
 
-	/*********************************************
-	 *	Rx Aggregation related setting
-	 *********************************************/
+	/* ============================================ */
+	/*	Rx Aggregation related setting */
+	/* ============================================ */
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_TO_REJ_AP_AGG_PKT,
 			   &reject_rx_agg);
 	/* decide BT control aggregation buf size or not */
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_CTRL_AGG_SIZE,
 			   &bt_ctrl_rx_agg_size);
-	/* aggregation buf size, only work
-	 * when BT control Rx aggregation size.
+	/* aggregation buf size, only work when BT control Rx aggregation size.
 	 */
 	btcoexist->btc_set(btcoexist, BTC_SET_U1_AGG_BUF_SIZE, &rx_agg_size);
 	/* real update aggregation setting */
@@ -471,55 +417,56 @@ static void halbtc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	reg_hp_txrx = 0x770;
 	reg_lp_txrx = 0x774;
 
 	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_txrx);
 	reg_hp_tx = u32tmp & MASKLWORD;
-	reg_hp_rx = (u32tmp & MASKHWORD)>>16;
+	reg_hp_rx = (u32tmp & MASKHWORD) >> 16;
 
 	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_txrx);
 	reg_lp_tx = u32tmp & MASKLWORD;
-	reg_lp_rx = (u32tmp & MASKHWORD)>>16;
+	reg_lp_rx = (u32tmp & MASKHWORD) >> 16;
 
 	coex_sta->high_priority_tx = reg_hp_tx;
 	coex_sta->high_priority_rx = reg_hp_rx;
 	coex_sta->low_priority_tx = reg_lp_tx;
 	coex_sta->low_priority_rx = reg_lp_rx;
 
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex] High Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
-		    reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex] Low Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
-		    reg_lp_txrx, reg_lp_tx, reg_lp_tx, reg_lp_rx, reg_lp_rx);
+	BTC_SPRINTF(
+		trace_buf, BT_TMP_BUF_SIZE,
+		"[BTCoex], High Priority Tx/Rx (reg 0x%x)=0x%x(%d)/0x%x(%d)\n",
+		reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
+	BTC_TRACE(trace_buf);
+	BTC_SPRINTF(
+		trace_buf, BT_TMP_BUF_SIZE,
+		"[BTCoex], Low Priority Tx/Rx (reg 0x%x)=0x%x(%d)/0x%x(%d)\n",
+		reg_lp_txrx, reg_lp_tx, reg_lp_tx, reg_lp_rx, reg_lp_rx);
+	BTC_TRACE(trace_buf);
 
 	/* reset counter */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
-static void halbtc8192e2ant_querybt_info(struct btc_coexist *btcoexist)
+static void halbtc8192e2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
-	h2c_parameter[0] |= BIT0;	/* trigger */
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
-		    h2c_parameter[0]);
+	h2c_parameter[0] |= BIT(0); /* trigger */
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
+static void halbtc8192e2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool bt_hson = false;
+	bool bt_hs_on = false;
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
 	bt_link_info->sco_exist = coex_sta->sco_exist;
@@ -528,43 +475,35 @@ static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
 	bt_link_info->hid_exist = coex_sta->hid_exist;
 
 	/* work around for HS mode. */
-	if (bt_hson) {
+	if (bt_hs_on) {
 		bt_link_info->pan_exist = true;
 		bt_link_info->bt_link_exist = true;
 	}
 
 	/* check if Sco only */
-	if (bt_link_info->sco_exist &&
-	    !bt_link_info->a2dp_exist &&
-	    !bt_link_info->pan_exist &&
-	    !bt_link_info->hid_exist)
+	if (bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
 		bt_link_info->sco_only = true;
 	else
 		bt_link_info->sco_only = false;
 
 	/* check if A2dp only */
-	if (!bt_link_info->sco_exist &&
-	    bt_link_info->a2dp_exist &&
-	    !bt_link_info->pan_exist &&
-	    !bt_link_info->hid_exist)
+	if (!bt_link_info->sco_exist && bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
 		bt_link_info->a2dp_only = true;
 	else
 		bt_link_info->a2dp_only = false;
 
 	/* check if Pan only */
-	if (!bt_link_info->sco_exist &&
-	    !bt_link_info->a2dp_exist &&
-	    bt_link_info->pan_exist &&
-	    !bt_link_info->hid_exist)
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    bt_link_info->pan_exist && !bt_link_info->hid_exist)
 		bt_link_info->pan_only = true;
 	else
 		bt_link_info->pan_only = false;
 
 	/* check if Hid only */
-	if (!bt_link_info->sco_exist &&
-	    !bt_link_info->a2dp_exist &&
-	    !bt_link_info->pan_exist &&
-	    bt_link_info->hid_exist)
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && bt_link_info->hid_exist)
 		bt_link_info->hid_only = true;
 	else
 		bt_link_info->hid_only = false;
@@ -574,73 +513,87 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-	bool bt_hson = false;
+	bool bt_hs_on = false;
 	u8 algorithm = BT_8192E_2ANT_COEX_ALGO_UNDEFINED;
-	u8 numdiffprofile = 0;
+	u8 num_of_diff_profile = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	if (!bt_link_info->bt_link_exist) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "No BT link exists!!!\n");
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], No BT link exists!!!\n");
+		BTC_TRACE(trace_buf);
 		return algorithm;
 	}
 
 	if (bt_link_info->sco_exist)
-		numdiffprofile++;
+		num_of_diff_profile++;
 	if (bt_link_info->hid_exist)
-		numdiffprofile++;
+		num_of_diff_profile++;
 	if (bt_link_info->pan_exist)
-		numdiffprofile++;
+		num_of_diff_profile++;
 	if (bt_link_info->a2dp_exist)
-		numdiffprofile++;
+		num_of_diff_profile++;
 
-	if (numdiffprofile == 1) {
+	if (num_of_diff_profile == 1) {
 		if (bt_link_info->sco_exist) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "SCO only\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], SCO only\n");
+			BTC_TRACE(trace_buf);
 			algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 		} else {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "HID only\n");
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+					    "[BTCoex], HID only\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8192E_2ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "A2DP only\n");
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+					    "[BTCoex], A2DP only\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8192E_2ANT_COEX_ALGO_A2DP;
 			} else if (bt_link_info->pan_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "PAN(HS) only\n");
+				if (bt_hs_on) {
+					BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+						    "[BTCoex], PAN(HS) only\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "PAN(EDR) only\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], PAN(EDR) only\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_PANEDR;
 				}
 			}
 		}
-	} else if (numdiffprofile == 2) {
+	} else if (num_of_diff_profile == 2) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "SCO + HID\n");
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+					    "[BTCoex], SCO + HID\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "SCO + A2DP ==> SCO\n");
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+					    "[BTCoex], SCO + A2DP ==> SCO\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->pan_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + PAN(HS)\n");
+				if (bt_hs_on) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + PAN(EDR)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_SCO_PAN;
 				}
@@ -649,71 +602,91 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (stack_info->num_of_hid >= 2) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID*2 + A2DP\n");
+					BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+						    "[BTCoex], HID*2 + A2DP\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
-					BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
+					    BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + A2DP\n");
+					BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+						    "[BTCoex], HID + A2DP\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_HID_A2DP;
 				}
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + PAN(HS)\n");
+				if (bt_hs_on) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm = BT_8192E_2ANT_COEX_ALGO_HID;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + PAN(EDR)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "A2DP + PAN(HS)\n");
+				if (bt_hs_on) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_A2DP_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "A2DP + PAN(EDR)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], A2DP + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_A2DP;
 				}
 			}
 		}
-	} else if (numdiffprofile == 3) {
+	} else if (num_of_diff_profile == 3) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "SCO + HID + A2DP ==> HID\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], SCO + HID + A2DP ==> HID\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + HID + PAN(HS)\n");
+				if (bt_hs_on) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + HID + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + HID + PAN(EDR)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + HID + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 						BT_8192E_2ANT_COEX_ALGO_SCO_PAN;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + A2DP + PAN(HS)\n");
+				if (bt_hs_on) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm = BT_8192E_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO + A2DP + PAN(EDR)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + A2DP + PAN(EDR) ==> HID\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 				}
@@ -722,31 +695,38 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + A2DP + PAN(HS)\n");
+				if (bt_hs_on) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "HID + A2DP + PAN(EDR)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + A2DP + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
-					BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
+					    BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				}
 			}
 		}
-	} else if (numdiffprofile >= 3) {
+	} else if (num_of_diff_profile >= 3) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
-				if (bt_hson) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "ErrorSCO+HID+A2DP+PAN(HS)\n");
-
+				if (bt_hs_on) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], Error!!! SCO + HID + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "SCO+HID+A2DP+PAN(EDR)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
+					BTC_TRACE(trace_buf);
 					algorithm =
 					    BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 				}
@@ -757,219 +737,170 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 	return algorithm;
 }
 
-static void halbtc8192e2ant_setfw_dac_swinglevel(struct btc_coexist *btcoexist,
-						 u8 dac_swinglvl)
+static void halbtc8192e2ant_set_fw_dac_swing_level(struct btc_coexist
+						   *btcoexist,
+						   u8 dac_swing_lvl)
 {
 	u8 h2c_parameter[1] = {0};
 
-	/* There are several type of dacswing
-	 * 0x18/ 0x10/ 0xc/ 0x8/ 0x4/ 0x6
-	 */
-	h2c_parameter[0] = dac_swinglvl;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Set Dac Swing Level = 0x%x\n", dac_swinglvl);
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x64 = 0x%x\n", h2c_parameter[0]);
+	/* There are several type of dacswing */
+	/* 0x18/ 0x10/ 0xc/ 0x8/ 0x4/ 0x6 */
+	h2c_parameter[0] = dac_swing_lvl;
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x64, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_set_fwdec_btpwr(struct btc_coexist *btcoexist,
-					    u8 dec_btpwr_lvl)
+static void halbtc8192e2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
+					      u8 dec_bt_pwr_lvl)
 {
 	u8 h2c_parameter[1] = {0};
 
-	h2c_parameter[0] = dec_btpwr_lvl;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex] decrease Bt Power level = %d, FW write 0x62 = 0x%x\n",
-		    dec_btpwr_lvl, h2c_parameter[0]);
+	h2c_parameter[0] = dec_bt_pwr_lvl;
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_dec_btpwr(struct btc_coexist *btcoexist,
-				      bool force_exec, u8 dec_btpwr_lvl)
+static void halbtc8192e2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
+				       bool force_exec,
+				       u8 dec_bt_pwr_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s Dec BT power level = %d\n",
-		    (force_exec ? "force to" : ""), dec_btpwr_lvl);
-	coex_dm->cur_dec_bt_pwr = dec_btpwr_lvl;
+	coex_dm->cur_bt_dec_pwr_lvl = dec_bt_pwr_lvl;
 
-	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], preBtDecPwrLvl=%d, curBtDecPwrLvl=%d\n",
-			    coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
-	}
-	halbtc8192e2ant_set_fwdec_btpwr(btcoexist, coex_dm->cur_dec_bt_pwr);
+	halbtc8192e2ant_set_fw_dec_bt_pwr(btcoexist,
+					  coex_dm->cur_bt_dec_pwr_lvl);
 
-	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
+	coex_dm->pre_bt_dec_pwr_lvl = coex_dm->cur_bt_dec_pwr_lvl;
 }
 
-static void halbtc8192e2ant_set_bt_autoreport(struct btc_coexist *btcoexist,
-					      bool enable_autoreport)
+static void halbtc8192e2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
+					       bool enable_auto_report)
 {
 	u8 h2c_parameter[1] = {0};
 
 	h2c_parameter[0] = 0;
 
-	if (enable_autoreport)
-		h2c_parameter[0] |= BIT0;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		    (enable_autoreport ? "Enabled!!" : "Disabled!!"),
-		    h2c_parameter[0]);
+	if (enable_auto_report)
+		h2c_parameter[0] |= BIT(0);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_bt_autoreport(struct btc_coexist *btcoexist,
-					  bool force_exec,
-					  bool enable_autoreport)
+static void halbtc8192e2ant_bt_auto_report(struct btc_coexist *btcoexist,
+					   bool force_exec,
+					   bool enable_auto_report)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s BT Auto report = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((enable_autoreport) ? "Enabled" : "Disabled"));
-	coex_dm->cur_bt_auto_report = enable_autoreport;
+	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex] bPreBtAutoReport=%d, bCurBtAutoReport=%d\n",
-			    coex_dm->pre_bt_auto_report,
-			    coex_dm->cur_bt_auto_report);
-
 		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
 			return;
 	}
-	halbtc8192e2ant_set_bt_autoreport(btcoexist,
-					  coex_dm->cur_bt_auto_report);
+	halbtc8192e2ant_set_bt_auto_report(btcoexist,
+					   coex_dm->cur_bt_auto_report);
 
 	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
 }
 
-static void halbtc8192e2ant_fw_dac_swinglvl(struct btc_coexist *btcoexist,
-					    bool force_exec, u8 fw_dac_swinglvl)
+static void halbtc8192e2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
+					     bool force_exec,
+					     u8 fw_dac_swing_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s set FW Dac Swing level = %d\n",
-		    (force_exec ? "force to" : ""), fw_dac_swinglvl);
-	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swinglvl;
+	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex] preFwDacSwingLvl=%d, curFwDacSwingLvl=%d\n",
-			    coex_dm->pre_fw_dac_swing_lvl,
-			    coex_dm->cur_fw_dac_swing_lvl);
-
 		if (coex_dm->pre_fw_dac_swing_lvl ==
 		    coex_dm->cur_fw_dac_swing_lvl)
 			return;
 	}
 
-	halbtc8192e2ant_setfw_dac_swinglevel(btcoexist,
-					     coex_dm->cur_fw_dac_swing_lvl);
+	halbtc8192e2ant_set_fw_dac_swing_level(btcoexist,
+					       coex_dm->cur_fw_dac_swing_lvl);
 
 	coex_dm->pre_fw_dac_swing_lvl = coex_dm->cur_fw_dac_swing_lvl;
 }
 
-static void btc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
-						 bool rx_rf_shrink_on)
+static void halbtc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist
+						    *btcoexist,
+						    bool rx_rf_shrink_on)
 {
+	char trace_buf[BT_TMP_BUF_SIZE];
+
 	if (rx_rf_shrink_on) {
 		/* Shrink RF Rx LPF corner */
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], Shrink RF Rx LPF corner!!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
-					  0xfffff, 0xffffc);
+		BTC_TRACE(trace_buf);
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e, 0xfffff,
+					  0xffffc);
 	} else {
-		/* Resume RF Rx LPF corner
-		 * After initialized, we can use coex_dm->btRf0x1eBackup
-		 */
+		/* Resume RF Rx LPF corner */
+		/* After initialized, we can use coex_dm->bt_rf_0x1e_backup */
 		if (btcoexist->initilized) {
-			btc_alg_dbg(ALGO_TRACE_SW_EXEC,
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 				    "[BTCoex], Resume RF Rx LPF corner!!\n");
+			BTC_TRACE(trace_buf);
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
 						  0xfffff,
-						  coex_dm->bt_rf0x1e_backup);
+						  coex_dm->bt_rf_0x1e_backup);
 		}
 	}
 }
 
 static void halbtc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
-				      bool force_exec, bool rx_rf_shrink_on)
+				      bool force_exec,
+				      bool rx_rf_shrink_on)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn Rx RF Shrink = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((rx_rf_shrink_on) ? "ON" : "OFF"));
 	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex]bPreRfRxLpfShrink=%d,bCurRfRxLpfShrink=%d\n",
-			    coex_dm->pre_rf_rx_lpf_shrink,
-			    coex_dm->cur_rf_rx_lpf_shrink);
-
 		if (coex_dm->pre_rf_rx_lpf_shrink ==
 		    coex_dm->cur_rf_rx_lpf_shrink)
 			return;
 	}
-	btc8192e2ant_set_sw_rf_rx_lpf_corner(btcoexist,
-					     coex_dm->cur_rf_rx_lpf_shrink);
+	halbtc8192e2ant_set_sw_rf_rx_lpf_corner(btcoexist,
+						coex_dm->cur_rf_rx_lpf_shrink);
 
 	coex_dm->pre_rf_rx_lpf_shrink = coex_dm->cur_rf_rx_lpf_shrink;
 }
 
-static void halbtc8192e2ant_set_dac_swingreg(struct btc_coexist *btcoexist,
-					     u32 level)
+static void halbtc8192e2ant_set_dac_swing_reg(struct btc_coexist *btcoexist,
+					      u32 level)
 {
 	u8 val = (u8)level;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 		    "[BTCoex], Write SwDacSwing = 0x%x\n", level);
+	BTC_TRACE(trace_buf);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x883, 0x3e, val);
 }
 
-static void btc8192e2ant_setsw_full_swing(struct btc_coexist *btcoexist,
-					  bool sw_dac_swingon,
-					  u32 sw_dac_swinglvl)
+static void halbtc8192e2ant_set_sw_full_time_dac_swing(struct btc_coexist
+						       *btcoexist,
+						       bool sw_dac_swing_on,
+						       u32 sw_dac_swing_lvl)
 {
-	if (sw_dac_swingon)
-		halbtc8192e2ant_set_dac_swingreg(btcoexist, sw_dac_swinglvl);
+	if (sw_dac_swing_on)
+		halbtc8192e2ant_set_dac_swing_reg(btcoexist, sw_dac_swing_lvl);
 	else
-		halbtc8192e2ant_set_dac_swingreg(btcoexist, 0x18);
+		halbtc8192e2ant_set_dac_swing_reg(btcoexist, 0x18);
 }
 
-static void halbtc8192e2ant_DacSwing(struct btc_coexist *btcoexist,
-				     bool force_exec, bool dac_swingon,
-				     u32 dac_swinglvl)
+static void halbtc8192e2ant_dac_swing(struct btc_coexist *btcoexist,
+				      bool force_exec, bool dac_swing_on,
+				      u32 dac_swing_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn DacSwing=%s, dac_swinglvl = 0x%x\n",
-		    (force_exec ? "force to" : ""),
-		    ((dac_swingon) ? "ON" : "OFF"), dac_swinglvl);
-	coex_dm->cur_dac_swing_on = dac_swingon;
-	coex_dm->cur_dac_swing_lvl = dac_swinglvl;
+	coex_dm->cur_dac_swing_on = dac_swing_on;
+	coex_dm->cur_dac_swing_lvl = dac_swing_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], bPreDacSwingOn=%d, preDacSwingLvl = 0x%x, ",
-			    coex_dm->pre_dac_swing_on,
-			    coex_dm->pre_dac_swing_lvl);
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "bCurDacSwingOn=%d, curDacSwingLvl = 0x%x\n",
-			    coex_dm->cur_dac_swing_on,
-			    coex_dm->cur_dac_swing_lvl);
-
 		if ((coex_dm->pre_dac_swing_on == coex_dm->cur_dac_swing_on) &&
 		    (coex_dm->pre_dac_swing_lvl == coex_dm->cur_dac_swing_lvl))
 			return;
 	}
 	mdelay(30);
-	btc8192e2ant_setsw_full_swing(btcoexist, dac_swingon, dac_swinglvl);
+	halbtc8192e2ant_set_sw_full_time_dac_swing(btcoexist, dac_swing_on,
+						   dac_swing_lvl);
 
 	coex_dm->pre_dac_swing_on = coex_dm->cur_dac_swing_on;
 	coex_dm->pre_dac_swing_lvl = coex_dm->cur_dac_swing_lvl;
@@ -978,10 +909,13 @@ static void halbtc8192e2ant_DacSwing(struct btc_coexist *btcoexist,
 static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
 					  bool agc_table_en)
 {
-	/* BB AGC Gain Table */
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	/* =================BB AGC Gain Table */
 	if (agc_table_en) {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BB Agc Table On!\n");
+		BTC_TRACE(trace_buf);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x0a1A0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x091B0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x081C0001);
@@ -989,8 +923,9 @@ static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x061E0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0x051F0001);
 	} else {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BB Agc Table Off!\n");
+		BTC_TRACE(trace_buf);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xaa1A0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa91B0001);
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa81C0001);
@@ -1000,21 +935,12 @@ static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8192e2ant_AgcTable(struct btc_coexist *btcoexist,
-				     bool force_exec, bool agc_table_en)
+static void halbtc8192e2ant_agc_table(struct btc_coexist *btcoexist,
+				      bool force_exec, bool agc_table_en)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s %s Agc Table\n",
-		    (force_exec ? "force to" : ""),
-		    ((agc_table_en) ? "Enable" : "Disable"));
 	coex_dm->cur_agc_table_en = agc_table_en;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], bPreAgcTableEn=%d, bCurAgcTableEn=%d\n",
-			    coex_dm->pre_agc_table_en,
-			    coex_dm->cur_agc_table_en);
-
 		if (coex_dm->pre_agc_table_en == coex_dm->cur_agc_table_en)
 			return;
 	}
@@ -1027,61 +953,34 @@ static void halbtc8192e2ant_set_coex_table(struct btc_coexist *btcoexist,
 					   u32 val0x6c0, u32 val0x6c4,
 					   u32 val0x6c8, u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c0 = 0x%x\n", val0x6c0);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c0, val0x6c0);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c4 = 0x%x\n", val0x6c4);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c4, val0x6c4);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6c8 = 0x%x\n", val0x6c8);
 	btcoexist->btc_write_4byte(btcoexist, 0x6c8, val0x6c8);
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-		    "[BTCoex], set coex table, set 0x6cc = 0x%x\n", val0x6cc);
 	btcoexist->btc_write_1byte(btcoexist, 0x6cc, val0x6cc);
 }
 
 static void halbtc8192e2ant_coex_table(struct btc_coexist *btcoexist,
-				       bool force_exec,
-				       u32 val0x6c0, u32 val0x6c4,
-				       u32 val0x6c8, u8 val0x6cc)
-{
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, ",
-		    (force_exec ? "force to" : ""), val0x6c0);
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
-		    val0x6c4, val0x6c8, val0x6cc);
+				       bool force_exec, u32 val0x6c0,
+				       u32 val0x6c4, u32 val0x6c8,
+				       u8 val0x6cc)
+{
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
-
 		if ((coex_dm->pre_val0x6c0 == coex_dm->cur_val0x6c0) &&
 		    (coex_dm->pre_val0x6c4 == coex_dm->cur_val0x6c4) &&
 		    (coex_dm->pre_val0x6c8 == coex_dm->cur_val0x6c8) &&
 		    (coex_dm->pre_val0x6cc == coex_dm->cur_val0x6cc))
 			return;
 	}
-	halbtc8192e2ant_set_coex_table(btcoexist, val0x6c0, val0x6c4,
-				       val0x6c8, val0x6cc);
+	halbtc8192e2ant_set_coex_table(btcoexist, val0x6c0, val0x6c4, val0x6c8,
+				       val0x6cc);
 
 	coex_dm->pre_val0x6c0 = coex_dm->cur_val0x6c0;
 	coex_dm->pre_val0x6c4 = coex_dm->cur_val0x6c4;
@@ -1089,8 +988,8 @@ static void halbtc8192e2ant_coex_table(struct btc_coexist *btcoexist,
 	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
 }
 
-static void btc8192e2ant_coex_tbl_w_type(struct btc_coexist *btcoexist,
-					 bool force_exec, u8 type)
+static void halbtc8192e2ant_coex_table_with_type(struct btc_coexist *btcoexist,
+						 bool force_exec, u8 type)
 {
 	switch (type) {
 	case 0:
@@ -1106,60 +1005,49 @@ static void btc8192e2ant_coex_tbl_w_type(struct btc_coexist *btcoexist,
 					   0x5ffb5ffb, 0xffffff, 0x3);
 		break;
 	case 3:
-		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0xdfffdfff,
+		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0x5fdf5fdf,
 					   0x5fdb5fdb, 0xffffff, 0x3);
 		break;
 	case 4:
 		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0xdfffdfff,
 					   0x5ffb5ffb, 0xffffff, 0x3);
 		break;
+
 	default:
 		break;
 	}
 }
 
-static void halbtc8192e2ant_set_fw_ignore_wlanact(struct btc_coexist *btcoexist,
-						  bool enable)
+static void halbtc8192e2ant_set_fw_ignore_wlan_act(struct btc_coexist
+						   *btcoexist,
+						   bool enable)
 {
 	u8 h2c_parameter[1] = {0};
 
 	if (enable)
-		h2c_parameter[0] |= BIT0; /* function enable */
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex]set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
-		    h2c_parameter[0]);
+		h2c_parameter[0] |= BIT(0); /* function enable */
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_IgnoreWlanAct(struct btc_coexist *btcoexist,
-					  bool force_exec, bool enable)
+static void halbtc8192e2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
+					    bool force_exec, bool enable)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s turn Ignore WlanAct %s\n",
-		    (force_exec ? "force to" : ""), (enable ? "ON" : "OFF"));
 	coex_dm->cur_ignore_wlan_act = enable;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], bPreIgnoreWlanAct = %d ",
-			    coex_dm->pre_ignore_wlan_act);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "bCurIgnoreWlanAct = %d!!\n",
-			    coex_dm->cur_ignore_wlan_act);
-
 		if (coex_dm->pre_ignore_wlan_act ==
 		    coex_dm->cur_ignore_wlan_act)
 			return;
 	}
-	halbtc8192e2ant_set_fw_ignore_wlanact(btcoexist, enable);
+	halbtc8192e2ant_set_fw_ignore_wlan_act(btcoexist, enable);
 
 	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
 }
 
-static void halbtc8192e2ant_SetFwPstdma(struct btc_coexist *btcoexist, u8 byte1,
-					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
+static void halbtc8192e2ant_set_fw_pstdma(struct btc_coexist *btcoexist,
+					  u8 byte1, u8 byte2, u8 byte3,
+					  u8 byte4, u8 byte5)
 {
 	u8 h2c_parameter[5] = {0};
 
@@ -1175,49 +1063,83 @@ static void halbtc8192e2ant_SetFwPstdma(struct btc_coexist *btcoexist, u8 byte1,
 	coex_dm->ps_tdma_para[3] = byte4;
 	coex_dm->ps_tdma_para[4] = byte5;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x60(5bytes) = 0x%x%08x\n",
-		    h2c_parameter[0],
-		    h2c_parameter[1] << 24 | h2c_parameter[2] << 16 |
-		    h2c_parameter[3] << 8 | h2c_parameter[4]);
-
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
-static void btc8192e2ant_sw_mec1(struct btc_coexist *btcoexist,
-				 bool shrink_rx_lpf, bool low_penalty_ra,
-				 bool limited_dig, bool btlan_constrain)
+static void halbtc8192e2ant_sw_mechanism1(struct btc_coexist *btcoexist,
+					  bool shrink_rx_lpf,
+					  bool low_penalty_ra,
+					  bool limited_dig,
+					  bool bt_lna_constrain)
 {
 	halbtc8192e2ant_rf_shrink(btcoexist, NORMAL_EXEC, shrink_rx_lpf);
 }
 
-static void btc8192e2ant_sw_mec2(struct btc_coexist *btcoexist,
-				 bool agc_table_shift, bool adc_backoff,
-				 bool sw_dac_swing, u32 dac_swinglvl)
+static void halbtc8192e2ant_sw_mechanism2(struct btc_coexist *btcoexist,
+					  bool agc_table_shift,
+					  bool adc_back_off,
+					  bool sw_dac_swing, u32 dac_swing_lvl)
 {
-	halbtc8192e2ant_AgcTable(btcoexist, NORMAL_EXEC, agc_table_shift);
-	halbtc8192e2ant_DacSwing(btcoexist, NORMAL_EXEC, sw_dac_swing,
-				 dac_swinglvl);
+	halbtc8192e2ant_agc_table(btcoexist, NORMAL_EXEC, agc_table_shift);
+	halbtc8192e2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
+				  dac_swing_lvl);
+}
+
+static void halbtc8192e2ant_set_ant_path(struct btc_coexist *btcoexist,
+					 u8 ant_pos_type, bool init_hwcfg,
+					 bool wifi_off)
+{
+	u32 u32tmp = 0;
+
+	if (init_hwcfg) {
+		btcoexist->btc_write_1byte(btcoexist, 0x944, 0x24);
+		btcoexist->btc_write_4byte(btcoexist, 0x930, 0x700700);
+		if (btcoexist->chip_interface == BTC_INTF_USB)
+			btcoexist->btc_write_4byte(btcoexist, 0x64, 0x30430004);
+		else
+			btcoexist->btc_write_4byte(btcoexist, 0x64, 0x30030004);
+
+		/* 0x4c[27][24]='00', Set Antenna to BB */
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+		u32tmp &= ~BIT(24);
+		u32tmp &= ~BIT(27);
+		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+	} else if (wifi_off) {
+		if (btcoexist->chip_interface == BTC_INTF_USB)
+			btcoexist->btc_write_4byte(btcoexist, 0x64, 0x30430004);
+		else
+			btcoexist->btc_write_4byte(btcoexist, 0x64, 0x30030004);
+
+		/* 0x4c[27][24]='11', Set Antenna to BT, 0x64[8:7]=0, 0x64[2]=1
+		 */
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+		u32tmp |= BIT(24);
+		u32tmp |= BIT(27);
+		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+	}
+
+	/* ext switch setting */
+	switch (ant_pos_type) {
+	case BTC_ANT_PATH_WIFI:
+		btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x4);
+		break;
+	case BTC_ANT_PATH_BT:
+		btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x20);
+		break;
+	default:
+	case BTC_ANT_PATH_PTA:
+		btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x4);
+		break;
+	}
 }
 
 static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 				    bool force_exec, bool turn_on, u8 type)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s turn %s PS TDMA, type=%d\n",
-		    (force_exec ? "force to" : ""),
-		    (turn_on ? "ON" : "OFF"), type);
 	coex_dm->cur_ps_tdma_on = turn_on;
 	coex_dm->cur_ps_tdma = type;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], bPrePsTdmaOn = %d, bCurPsTdmaOn = %d!!\n",
-			    coex_dm->pre_ps_tdma_on, coex_dm->cur_ps_tdma_on);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], prePsTdma = %d, curPsTdma = %d!!\n",
-			    coex_dm->pre_ps_tdma, coex_dm->cur_ps_tdma);
-
 		if ((coex_dm->pre_ps_tdma_on == coex_dm->cur_ps_tdma_on) &&
 		    (coex_dm->pre_ps_tdma == coex_dm->cur_ps_tdma))
 			return;
@@ -1226,108 +1148,110 @@ static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 		switch (type) {
 		case 1:
 		default:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+						      0x1a, 0xe1, 0x90);
 			break;
 		case 2:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0xe1, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+						      0x12, 0xe1, 0x90);
 			break;
 		case 3:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
-						    0x3, 0xf1, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
+						      0x3, 0xf1, 0x90);
 			break;
 		case 4:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x10,
-						    0x3, 0xf1, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x10,
+						      0x3, 0xf1, 0x90);
 			break;
 		case 5:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0x60, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+						      0x1a, 0x60, 0x90);
 			break;
 		case 6:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0x60, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+						      0x12, 0x60, 0x90);
 			break;
 		case 7:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
-						    0x3, 0x70, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
+						      0x3, 0x70, 0x90);
 			break;
 		case 8:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xa3, 0x10,
-						    0x3, 0x70, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xa3, 0x10,
+						      0x3, 0x70, 0x90);
 			break;
 		case 9:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+						      0x1a, 0xe1, 0x10);
 			break;
 		case 10:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0xe1, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+						      0x12, 0xe1, 0x10);
 			break;
 		case 11:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
-						    0x3, 0xf1, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
+						      0x3, 0xf1, 0x10);
 			break;
 		case 12:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x10,
-						    0x3, 0xf1, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x10,
+						      0x3, 0xf1, 0x10);
 			break;
 		case 13:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe0, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+						      0x1a, 0xe0, 0x10);
 			break;
 		case 14:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
-						    0x12, 0xe0, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+						      0x12, 0xe0, 0x10);
 			break;
 		case 15:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
-						    0x3, 0xf0, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
+						      0x3, 0xf0, 0x10);
 			break;
 		case 16:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
-						    0x3, 0xf0, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+						      0x3, 0xf0, 0x10);
 			break;
 		case 17:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0x61, 0x20,
-						    0x03, 0x10, 0x10);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0x61, 0x20,
+						      0x03, 0x10, 0x10);
 			break;
 		case 18:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x5,
-						    0x5, 0xe1, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5, 0x5,
+						      0xe1, 0x90);
 			break;
 		case 19:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x25,
-						    0x25, 0xe1, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x25,
+						      0x25, 0xe1, 0x90);
 			break;
 		case 20:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x25,
-						    0x25, 0x60, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x25,
+						      0x25, 0x60, 0x90);
 			break;
 		case 21:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x15,
-						    0x03, 0x70, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x15,
+						      0x03, 0x70, 0x90);
 			break;
 		case 71:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
-						    0x1a, 0xe1, 0x90);
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+						      0x1a, 0xe1, 0x90);
 			break;
 		}
 	} else {
 		/* disable PS tdma */
 		switch (type) {
 		default:
-		case 0:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0x8, 0x0, 0x0,
-						    0x0, 0x0);
-			btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x4);
+		case 0: /* ANT2PTA, 0x778=1 */
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0x8, 0x0, 0x0,
+						      0x0, 0x0);
+			halbtc8192e2ant_set_ant_path(
+				btcoexist, BTC_ANT_PATH_PTA, false, false);
 			break;
-		case 1:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0x0, 0x0, 0x0,
-						    0x8, 0x0);
+		case 1: /* ANT2BT, 0x778=3 */
+			halbtc8192e2ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
+						      0x8, 0x0);
 			mdelay(5);
-			btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x20);
+			halbtc8192e2ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
+						     false, false);
 			break;
 		}
 	}
@@ -1337,72 +1261,84 @@ static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static void halbtc8192e2ant_set_switch_sstype(struct btc_coexist *btcoexist,
-					      u8 sstype)
+static void halbtc8192e2ant_set_switch_ss_type(struct btc_coexist *btcoexist,
+					       u8 ss_type)
 {
-	u8 mimops = BTC_MIMO_PS_DYNAMIC;
-	u32 disra_mask = 0x0;
+	u8 mimo_ps = BTC_MIMO_PS_DYNAMIC;
+	u32 dis_ra_mask = 0x0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], REAL set SS Type = %d\n", sstype);
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], REAL set SS Type = %d\n", ss_type);
+	BTC_TRACE(trace_buf);
 
-	disra_mask = halbtc8192e2ant_decidera_mask(btcoexist, sstype,
-						   coex_dm->curra_masktype);
-	halbtc8192e2ant_Updatera_mask(btcoexist, FORCE_EXEC, disra_mask);
+	dis_ra_mask = halbtc8192e2ant_decide_ra_mask(btcoexist, ss_type,
+						     coex_dm->cur_ra_mask_type);
+	halbtc8192e2ant_update_ra_mask(btcoexist, FORCE_EXEC, dis_ra_mask);
 
-	if (sstype == 1) {
+	if (ss_type == 1) {
 		halbtc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
 		/* switch ofdm path */
 		btcoexist->btc_write_1byte(btcoexist, 0xc04, 0x11);
 		btcoexist->btc_write_1byte(btcoexist, 0xd04, 0x1);
 		btcoexist->btc_write_4byte(btcoexist, 0x90c, 0x81111111);
 		/* switch cck patch */
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0xe77, 0x4, 0x1);
-		btcoexist->btc_write_1byte(btcoexist, 0xa07, 0x81);
-		mimops = BTC_MIMO_PS_STATIC;
-	} else if (sstype == 2) {
+		/* btcoexist->btc_write_1byte_bitmask(btcoexist, 0xe77, 0x4,
+		 * 0x1);
+		 */
+		/* btcoexist->btc_write_1byte(btcoexist, 0xa07, 0x81); */
+		mimo_ps = BTC_MIMO_PS_STATIC;
+	} else if (ss_type == 2) {
 		halbtc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
 		btcoexist->btc_write_1byte(btcoexist, 0xc04, 0x33);
 		btcoexist->btc_write_1byte(btcoexist, 0xd04, 0x3);
 		btcoexist->btc_write_4byte(btcoexist, 0x90c, 0x81121313);
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0xe77, 0x4, 0x0);
-		btcoexist->btc_write_1byte(btcoexist, 0xa07, 0x41);
-		mimops = BTC_MIMO_PS_DYNAMIC;
+		/* remove, if 0xe77[2]=0x0 then CCK will fail, advised by Jenyu
+		 */
+		/* btcoexist->btc_write_1byte_bitmask(btcoexist, 0xe77, 0x4,
+		 * 0x0);
+		 */
+		/* btcoexist->btc_write_1byte(btcoexist, 0xa07, 0x41); */
+		mimo_ps = BTC_MIMO_PS_DYNAMIC;
 	}
-	/* set rx 1ss or 2ss */
-	btcoexist->btc_set(btcoexist, BTC_SET_ACT_SEND_MIMO_PS, &mimops);
+
+	btcoexist->btc_set(btcoexist, BTC_SET_ACT_SEND_MIMO_PS,
+			   &mimo_ps); /* set rx 1ss or 2ss */
 }
 
-static void halbtc8192e2ant_switch_sstype(struct btc_coexist *btcoexist,
-					  bool force_exec, u8 new_sstype)
+static void halbtc8192e2ant_switch_ss_type(struct btc_coexist *btcoexist,
+					   bool force_exec, u8 new_ss_type)
 {
-	btc_alg_dbg(ALGO_TRACE,
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 		    "[BTCoex], %s Switch SS Type = %d\n",
-		    (force_exec ? "force to" : ""), new_sstype);
-	coex_dm->cur_sstype = new_sstype;
+		    (force_exec ? "force to" : ""), new_ss_type);
+	BTC_TRACE(trace_buf);
+	coex_dm->cur_ss_type = new_ss_type;
 
 	if (!force_exec) {
-		if (coex_dm->pre_sstype == coex_dm->cur_sstype)
+		if (coex_dm->pre_ss_type == coex_dm->cur_ss_type)
 			return;
 	}
-	halbtc8192e2ant_set_switch_sstype(btcoexist, coex_dm->cur_sstype);
+	halbtc8192e2ant_set_switch_ss_type(btcoexist, coex_dm->cur_ss_type);
 
-	coex_dm->pre_sstype = coex_dm->cur_sstype;
+	coex_dm->pre_ss_type = coex_dm->cur_ss_type;
 }
 
-static void halbtc8192e2ant_coex_alloff(struct btc_coexist *btcoexist)
+static void halbtc8192e2ant_coex_all_off(struct btc_coexist *btcoexist)
 {
 	/* fw all off */
 	halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-	halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	/* sw all off */
-	btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-	btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+	halbtc8192e2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8192e2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
 	/* hw all off */
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 0);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
 static void halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -1410,14 +1346,14 @@ static void halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
 	/* force to reset coex mechanism */
 
 	halbtc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, FORCE_EXEC, 6);
-	halbtc8192e2ant_dec_btpwr(btcoexist, FORCE_EXEC, 0);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
+	halbtc8192e2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, 0);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, FORCE_EXEC, 0);
-	halbtc8192e2ant_switch_sstype(btcoexist, FORCE_EXEC, 2);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
+	halbtc8192e2ant_switch_ss_type(btcoexist, FORCE_EXEC, 2);
 
-	btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-	btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+	halbtc8192e2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8192e2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
 static void halbtc8192e2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
@@ -1427,24 +1363,25 @@ static void halbtc8192e2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 			   &low_pwr_disable);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-	halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-	btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+	halbtc8192e2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8192e2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
 static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool common = false, wifi_connected = false, wifi_busy = false;
-	bool bt_hson = false, low_pwr_disable = false;
+	bool bt_hs_on = false, low_pwr_disable = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
@@ -1459,33 +1396,36 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
 
-		btc_alg_dbg(ALGO_TRACE,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], Wifi non-connected idle!!\n");
+		BTC_TRACE(trace_buf);
 
 		if ((BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 		     coex_dm->bt_status) ||
 		    (BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE ==
 		     coex_dm->bt_status)) {
-			halbtc8192e2ant_switch_sstype(btcoexist,
-						      NORMAL_EXEC, 2);
-			btc8192e2ant_coex_tbl_w_type(btcoexist,
-						     NORMAL_EXEC, 1);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0);
+			halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC,
+						       2);
+			halbtc8192e2ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 1);
+			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						0);
 		} else {
-			halbtc8192e2ant_switch_sstype(btcoexist,
-						      NORMAL_EXEC, 1);
-			btc8192e2ant_coex_tbl_w_type(btcoexist,
-						     NORMAL_EXEC, 0);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
+			halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC,
+						       1);
+			halbtc8192e2ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 0);
+			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						1);
 		}
 
-		halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+		halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-		btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-		btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+		halbtc8192e2ant_sw_mechanism1(btcoexist, false, false, false,
+					      false);
+		halbtc8192e2ant_sw_mechanism2(btcoexist, false, false, false,
+					      0x18);
 
 		common = true;
 	} else {
@@ -1496,23 +1436,25 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 					   BTC_SET_ACT_DISABLE_LOW_POWER,
 					   &low_pwr_disable);
 
-			btc_alg_dbg(ALGO_TRACE,
-				    "Wifi connected + BT non connected-idle!!\n");
-
-			halbtc8192e2ant_switch_sstype(btcoexist,
-						      NORMAL_EXEC, 2);
-			btc8192e2ant_coex_tbl_w_type(btcoexist,
-						     NORMAL_EXEC, 1);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0);
-			halbtc8192e2ant_fw_dac_swinglvl(btcoexist,
-							NORMAL_EXEC, 6);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Wifi connected + BT non connected-idle!!\n");
+			BTC_TRACE(trace_buf);
+
+			halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC,
+						       2);
+			halbtc8192e2ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 1);
+			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						0);
+			halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+							 6);
+			halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 
 			common = true;
 		} else if (BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE ==
@@ -1522,25 +1464,27 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 					   BTC_SET_ACT_DISABLE_LOW_POWER,
 					   &low_pwr_disable);
 
-			if (bt_hson)
+			if (bt_hs_on)
 				return false;
-			btc_alg_dbg(ALGO_TRACE,
-				    "Wifi connected + BT connected-idle!!\n");
-
-			halbtc8192e2ant_switch_sstype(btcoexist,
-						      NORMAL_EXEC, 2);
-			btc8192e2ant_coex_tbl_w_type(btcoexist,
-						     NORMAL_EXEC, 1);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0);
-			halbtc8192e2ant_fw_dac_swinglvl(btcoexist,
-							NORMAL_EXEC, 6);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Wifi connected + BT connected-idle!!\n");
+			BTC_TRACE(trace_buf);
+
+			halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC,
+						       2);
+			halbtc8192e2ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 1);
+			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						0);
+			halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+							 6);
+			halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 
 			common = true;
 		} else {
@@ -1550,1013 +1494,1214 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 					   &low_pwr_disable);
 
 			if (wifi_busy) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "Wifi Connected-Busy + BT Busy!!\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+				BTC_TRACE(trace_buf);
 				common = false;
 			} else {
-				btc_alg_dbg(ALGO_TRACE,
-					    "Wifi Connected-Idle + BT Busy!!\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+				BTC_TRACE(trace_buf);
 
-				halbtc8192e2ant_switch_sstype(btcoexist,
-							      NORMAL_EXEC, 1);
-				btc8192e2ant_coex_tbl_w_type(btcoexist,
-							     NORMAL_EXEC, 2);
+				halbtc8192e2ant_switch_ss_type(btcoexist,
+							       NORMAL_EXEC, 1);
+				halbtc8192e2ant_coex_table_with_type(
+					btcoexist, NORMAL_EXEC, 2);
 				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 							true, 21);
-				halbtc8192e2ant_fw_dac_swinglvl(btcoexist,
-								NORMAL_EXEC, 6);
-				halbtc8192e2ant_dec_btpwr(btcoexist,
-							  NORMAL_EXEC, 0);
-				btc8192e2ant_sw_mec1(btcoexist, false,
-						     false, false, false);
-				btc8192e2ant_sw_mec2(btcoexist, false,
-						     false, false, 0x18);
+				halbtc8192e2ant_fw_dac_swing_lvl(
+					btcoexist, NORMAL_EXEC, 6);
+				halbtc8192e2ant_dec_bt_pwr(btcoexist,
+							   NORMAL_EXEC, 0);
+				halbtc8192e2ant_sw_mechanism1(
+					btcoexist, false, false, false, false);
+				halbtc8192e2ant_sw_mechanism2(
+					btcoexist, false, false, false, 0x18);
 				common = true;
 			}
 		}
 	}
+
 	return common;
 }
 
-static void btc8192e_int1(struct btc_coexist *btcoexist, bool tx_pause,
-			  int result)
-{
-	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
-
-		if (coex_dm->cur_ps_tdma == 71) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
+static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
+						 bool sco_hid, bool tx_pause,
+						 u8 max_interval)
+{
+	static s32 up, dn, m, n, wait_count;
+	s32 result; /* 0: no change, +1: increase WiFi duration, -1: decrease
+		     * WiFi duration
+		     */
+	u8 retry_count = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	if (!coex_dm->auto_tdma_adjust) {
+		coex_dm->auto_tdma_adjust = true;
+		{
+			if (sco_hid) {
+				if (tx_pause) {
+					if (max_interval == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 13);
+						coex_dm->ps_tdma_du_adj_type =
+							13;
+					} else if (max_interval == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (max_interval == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					}
+				} else {
+					if (max_interval == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 9);
+						coex_dm->ps_tdma_du_adj_type =
+							9;
+					} else if (max_interval == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (max_interval == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					}
+				}
+			} else {
+				if (tx_pause) {
+					if (max_interval == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 5);
+						coex_dm->ps_tdma_du_adj_type =
+							5;
+					} else if (max_interval == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (max_interval == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					}
+				} else {
+					if (max_interval == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 1);
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (max_interval == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (max_interval == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					}
+				}
+			}
 		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
-			coex_dm->tdma_adj_type = 13;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
+		/* ============ */
+		up = 0;
+		dn = 0;
+		m = 1;
+		n = 3;
+		result = 0;
+		wait_count = 0;
+	} else {
+		/* acquire the BT TRx retry count from BT_Info byte2 */
+		retry_count = coex_sta->bt_retry_cnt;
+		result = 0;
+		wait_count++;
+
+		if (retry_count == 0) {
+			/* no retry in the last 2-second duration */
+			up++;
+			dn--;
+
+			if (dn <= 0)
+				dn = 0;
+
+			if (up >= n) {
+				/* if retry count during continuous n*2
+				 * seconds is 0, enlarge WiFi duration
+				 */
+				wait_count = 0;
+				n = 3;
+				up = 0;
+				dn = 0;
+				result = 1;
+			}
+		} else if (retry_count <= 3) {
+			/* <=3 retry in the last 2-second duration */
+			up--;
+			dn++;
+
+			if (up <= 0)
+				up = 0;
+
+			if (dn == 2) {
+				/* if continuous 2 retry count(every 2
+				 * seconds) >0 and < 3, reduce WiFi
+				 * duration
+				 */
+				if (wait_count <= 2)
+					m++; /* to avoid loop between the two
+					      * levels
+					      */
+				else
+					m = 1;
+
+				if (m >= 20) {
+					/* maximum of m = 20 ' will recheck if
+					 * need to adjust wifi duration in
+					 * maximum time interval 120 seconds
+					 */
+					m = 20;
+				}
+
+				n = 3 * m;
+				up = 0;
+				dn = 0;
+				wait_count = 0;
+				result = -1;
+			}
+		} else {
+			/* retry count > 3, once retry count > 3, to reduce
+			 * WiFi duration
+			 */
+			if (wait_count == 1)
+				m++; /* to avoid loop between the two levels */
+			else
+				m = 1;
+
+			if (m >= 20) {
+				/* maximum of m = 20 ' will recheck if need to
+				 * adjust wifi duration in maximum time interval
+				 * 120 seconds
+				 */
+				m = 20;
+			}
+
+			n = 3 * m;
+			up = 0;
+			dn = 0;
+			wait_count = 0;
+			result = -1;
 		}
 
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+		if (max_interval == 1) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 71) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 1) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 13);
+					coex_dm->ps_tdma_du_adj_type = 13;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 5);
-				coex_dm->tdma_adj_type = 5;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							5;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 13);
-				coex_dm->tdma_adj_type = 13;
-			}
-		}
-	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 71);
-			coex_dm->tdma_adj_type = 71;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-			coex_dm->tdma_adj_type = 9;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
+						coex_dm->ps_tdma_du_adj_type =
+							13;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 71);
+					coex_dm->ps_tdma_du_adj_type = 71;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 9);
+					coex_dm->ps_tdma_du_adj_type = 9;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
 
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 71) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 71) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 71);
-				coex_dm->tdma_adj_type = 71;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							71;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 9);
-				coex_dm->tdma_adj_type = 9;
+						coex_dm->ps_tdma_du_adj_type =
+							9;
+					}
+				}
 			}
-		}
-	}
-}
-
-static void btc8192e_int2(struct btc_coexist *btcoexist, bool tx_pause,
-			  int result)
-{
-	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+		} else if (max_interval == 2) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 1) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			}
-		}
-	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					halbtc8192e2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			}
-		}
-	}
-}
-
-static void btc8192e_int3(struct btc_coexist *btcoexist, bool tx_pause,
-			  int result)
-{
-	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			}
-		}
-	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					}
+				}
 			}
-		}
-	}
-}
-
-static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
-						 bool sco_hid, bool tx_pause,
-						 u8 max_interval)
-{
-	static int up, dn, m, n, wait_cnt;
-	/* 0: no change, +1: increase WiFi duration,
-	 * -1: decrease WiFi duration
-	 */
-	int result;
-	u8 retry_cnt = 0;
-
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], TdmaDurationAdjust()\n");
-
-	if (!coex_dm->auto_tdma_adjust) {
-		coex_dm->auto_tdma_adjust = true;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], first run TdmaDurationAdjust()!!\n");
-		if (sco_hid) {
+		} else if (max_interval == 3) {
 			if (tx_pause) {
-				if (max_interval == 1) {
+				if (coex_dm->cur_ps_tdma == 1) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 13);
-					coex_dm->tdma_adj_type = 13;
-				} else if (max_interval == 2) {
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 2) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 14);
-					coex_dm->tdma_adj_type = 14;
-				} else if (max_interval == 3) {
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 3) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 15);
-					coex_dm->tdma_adj_type = 15;
-				} else {
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 15);
-					coex_dm->tdma_adj_type = 15;
+								true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
 				}
-			} else {
-				if (max_interval == 1) {
+				if (coex_dm->cur_ps_tdma == 9) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 9);
-					coex_dm->tdma_adj_type = 9;
-				} else if (max_interval == 2) {
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 10) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 10);
-					coex_dm->tdma_adj_type = 10;
-				} else if (max_interval == 3) {
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 11) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 11);
-					coex_dm->tdma_adj_type = 11;
-				} else {
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 11);
-					coex_dm->tdma_adj_type = 11;
+								true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
 				}
-			}
-		} else {
-			if (tx_pause) {
-				if (max_interval == 1) {
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 5);
-					coex_dm->tdma_adj_type = 5;
-				} else if (max_interval == 2) {
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 6) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 6);
-					coex_dm->tdma_adj_type = 6;
-				} else if (max_interval == 3) {
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 7) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 7);
-					coex_dm->tdma_adj_type = 7;
-				} else {
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 7);
-					coex_dm->tdma_adj_type = 7;
+								true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
 				}
-			} else {
-				if (max_interval == 1) {
+				if (coex_dm->cur_ps_tdma == 13) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 1);
-					coex_dm->tdma_adj_type = 1;
-				} else if (max_interval == 2) {
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 14) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 2);
-					coex_dm->tdma_adj_type = 2;
-				} else if (max_interval == 3) {
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 15) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 3);
-					coex_dm->tdma_adj_type = 3;
-				} else {
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
 					halbtc8192e2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 3);
-					coex_dm->tdma_adj_type = 3;
+								true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8192e2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					}
 				}
 			}
 		}
-
-		up = 0;
-		dn = 0;
-		m = 1;
-		n = 3;
-		result = 0;
-		wait_cnt = 0;
-	} else {
-		/* accquire the BT TRx retry count from BT_Info byte2 */
-		retry_cnt = coex_sta->bt_retry_cnt;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], retry_cnt = %d\n", retry_cnt);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], up=%d, dn=%d, m=%d, n=%d, wait_cnt=%d\n",
-			    up, dn, m, n, wait_cnt);
-		result = 0;
-		wait_cnt++;
-		/* no retry in the last 2-second duration */
-		if (retry_cnt == 0) {
-			up++;
-			dn--;
-
-			if (dn <= 0)
-				dn = 0;
-
-			if (up >= n) {
-				wait_cnt = 0;
-				n = 3;
-				up = 0;
-				dn = 0;
-				result = 1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex]Increase wifi duration!!\n");
-			}
-		} else if (retry_cnt <= 3) {
-			up--;
-			dn++;
-
-			if (up <= 0)
-				up = 0;
-
-			if (dn == 2) {
-				if (wait_cnt <= 2)
-					m++;
-				else
-					m = 1;
-
-				if (m >= 20)
-					m = 20;
-
-				n = 3 * m;
-				up = 0;
-				dn = 0;
-				wait_cnt = 0;
-				result = -1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "Reduce wifi duration for retry<3\n");
-			}
-		} else {
-			if (wait_cnt == 1)
-				m++;
-			else
-				m = 1;
-
-			if (m >= 20)
-				m = 20;
-
-			n = 3*m;
-			up = 0;
-			dn = 0;
-			wait_cnt = 0;
-			result = -1;
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "Decrease wifi duration for retryCounter>3!!\n");
-		}
-
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], max Interval = %d\n", max_interval);
-		if (max_interval == 1)
-			btc8192e_int1(btcoexist, tx_pause, result);
-		else if (max_interval == 2)
-			btc8192e_int2(btcoexist, tx_pause, result);
-		else if (max_interval == 3)
-			btc8192e_int3(btcoexist, tx_pause, result);
 	}
 
-	/* if current PsTdma not match with
-	 * the recorded one (when scan, dhcp...),
-	 * then we have to adjust it back to the previous record one.
+	/* if current PsTdma not match with the recorded one (when scan,
+	 * dhcp...),
 	 */
-	if (coex_dm->cur_ps_tdma != coex_dm->tdma_adj_type) {
+	/* then we have to adjust it back to the previous record one. */
+	if (coex_dm->cur_ps_tdma != coex_dm->ps_tdma_du_adj_type) {
 		bool scan = false, link = false, roam = false;
 
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], PsTdma type dismatch!!!, ");
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "curPsTdma=%d, recordPsTdma=%d\n",
-			    coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], PsTdma type dismatch!!!, cur_ps_tdma=%d, recordPsTdma=%d\n",
+			coex_dm->cur_ps_tdma, coex_dm->ps_tdma_du_adj_type);
+		BTC_TRACE(trace_buf);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 
 		if (!scan && !link && !roam)
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true,
-						coex_dm->tdma_adj_type);
-		else
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
+			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						coex_dm->ps_tdma_du_adj_type);
+		else {
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
+			BTC_TRACE(trace_buf);
+		}
 	}
 }
 
 /* SCO only or SCO+PAN(HS) */
 static void halbtc8192e2ant_action_sco(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_STAY_LOW;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 4);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
 
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
 	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	/* sw mechanism */
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x6);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x6);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x6);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x6);
 		}
 	}
 }
 
 static void halbtc8192e2ant_action_sco_pan(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_STAY_LOW;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 4);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
 
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
 	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	/* sw mechanism */
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x6);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x6);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x6);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x6);
 		}
 	}
 }
 
 static void halbtc8192e2ant_action_hid(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
 	}
 
 	/* sw mechanism */
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
@@ -2564,209 +2709,214 @@ static void halbtc8192e2ant_action_hid(struct btc_coexist *btcoexist)
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
 static void halbtc8192e2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 	bool long_dist = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW ||
-	     btrssi_state == BTC_RSSI_STATE_STAY_LOW) &&
-	    (wifirssi_state == BTC_RSSI_STATE_LOW ||
-	     wifirssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		btc_alg_dbg(ALGO_TRACE,
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW ||
+	     bt_rssi_state == BTC_RSSI_STATE_STAY_LOW) &&
+	    (wifi_rssi_state == BTC_RSSI_STATE_LOW ||
+	     wifi_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], A2dp, wifi/bt rssi both LOW!!\n");
+		BTC_TRACE(trace_buf);
 		long_dist = true;
 	}
 	if (long_dist) {
-		halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 2);
+		halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 2);
 		halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, true,
 					   0x4);
 	} else {
-		halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+		halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 		halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
 					   0x8);
 	}
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (long_dist)
-		btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 0);
+		halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 	else
-		btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+		halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
 	if (long_dist) {
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 17);
 		coex_dm->auto_tdma_adjust = false;
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 	} else {
-		if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-		    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
 			halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
 							     true, 1);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-			   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+			halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+			   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
 			halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
 							     false, 1);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-			   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+			   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
 			halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
 							     false, 1);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+			halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		}
 	}
 
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
 static void halbtc8192e2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, true, 2);
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
-						     false, 2);
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
-						     false, 2);
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, false,
+						     2);
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, false,
+						     2);
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 	}
 
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     true, 0x6);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      true, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     true, 0x6);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      true, 0x6);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     true, 0x6);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      true, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     true, 0x6);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      true, 0x6);
 		}
 	}
 }
 
 static void halbtc8192e2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 1);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 1);
 	}
 
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
@@ -2774,57 +2924,57 @@ static void halbtc8192e2ant_action_pan_edr(struct btc_coexist *btcoexist)
 /* PAN(HS) only */
 static void halbtc8192e2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-	}
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW))
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+	else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		 (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM))
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		 (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 	halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
@@ -2832,247 +2982,250 @@ static void halbtc8192e2ant_action_pan_hs(struct btc_coexist *btcoexist)
 /* PAN(EDR)+A2DP */
 static void halbtc8192e2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, true, 3);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
-						     false, 3);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
-						     false, 3);
-	}
-
-	/* sw mechanism	*/
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, false,
+						     3);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, false,
+						     3);
+	}
+
+	/* sw mechanism	 */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
 static void halbtc8192e2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
 	}
 
 	/* sw mechanism */
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
 /* HID+A2DP+PAN(EDR) */
-static void btc8192e2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
+static void halbtc8192e2ant_action_hid_a2dp_pan_edr(struct btc_coexist
+						    *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, true, 3);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 3);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 3);
 	}
 
 	/* sw mechanism */
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
 static void halbtc8192e2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(3, 34, 42);
+	wifi_rssi_state =
+		halbtc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8192e2ant_bt_rssi_state(3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	halbtc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, true, 2);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM))	{
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 2);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 2);
 	}
 
 	/* sw mechanism */
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			halbtc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
@@ -3080,158 +3233,182 @@ static void halbtc8192e2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	u8 algorithm = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_alg_dbg(ALGO_TRACE,
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 		    "[BTCoex], RunCoexistMechanism()===>\n");
+	BTC_TRACE(trace_buf);
 
 	if (btcoexist->manual_control) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], return for Manual CTRL <===\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for Manual CTRL <===\n");
+		BTC_TRACE(trace_buf);
 		return;
 	}
 
 	if (coex_sta->under_ips) {
-		btc_alg_dbg(ALGO_TRACE,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], wifi is under IPS !!!\n");
+		BTC_TRACE(trace_buf);
 		return;
 	}
 
 	algorithm = halbtc8192e2ant_action_algorithm(btcoexist);
 	if (coex_sta->c2h_bt_inquiry_page &&
-	    (BT_8192E_2ANT_COEX_ALGO_PANHS != algorithm)) {
-		btc_alg_dbg(ALGO_TRACE,
+	    (algorithm != BT_8192E_2ANT_COEX_ALGO_PANHS)) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BT is under inquiry/page scan !!\n");
+		BTC_TRACE(trace_buf);
 		halbtc8192e2ant_action_bt_inquiry(btcoexist);
 		return;
 	}
 
 	coex_dm->cur_algorithm = algorithm;
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], Algorithm = %d\n", coex_dm->cur_algorithm);
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "[BTCoex], Algorithm = %d\n",
+		    coex_dm->cur_algorithm);
+	BTC_TRACE(trace_buf);
 
 	if (halbtc8192e2ant_is_common_action(btcoexist)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Action 2-Ant common\n");
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Action 2-Ant common.\n");
+		BTC_TRACE(trace_buf);
 		coex_dm->auto_tdma_adjust = false;
 	} else {
 		if (coex_dm->cur_algorithm != coex_dm->pre_algorithm) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex] preAlgorithm=%d, curAlgorithm=%d\n",
-				    coex_dm->pre_algorithm,
-				    coex_dm->cur_algorithm);
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], pre_algorithm=%d, cur_algorithm=%d\n",
+				coex_dm->pre_algorithm, coex_dm->cur_algorithm);
+			BTC_TRACE(trace_buf);
 			coex_dm->auto_tdma_adjust = false;
 		}
 		switch (coex_dm->cur_algorithm) {
 		case BT_8192E_2ANT_COEX_ALGO_SCO:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = SCO\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = SCO.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_sco(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_SCO_PAN:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = SCO+PAN(EDR)\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = SCO+PAN(EDR).\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_sco_pan(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HID\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HID.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_hid(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = A2DP\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_a2dp(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_A2DP_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = A2DP+PAN(HS).\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = PAN(EDR)\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = PAN(EDR).\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HS mode\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HS mode.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = PAN+A2DP\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = PAN+A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = PAN(EDR)+HID\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = PAN(EDR)+HID.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HID+A2DP+PAN\n");
-			btc8192e2ant_action_hid_a2dp_pan_edr(btcoexist);
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HID+A2DP+PAN.\n");
+			BTC_TRACE(trace_buf);
+			halbtc8192e2ant_action_hid_a2dp_pan_edr(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = HID+A2DP\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HID+A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8192e2ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
-			btc_alg_dbg(ALGO_TRACE,
-				    "Action 2-Ant, algorithm = unknown!!\n");
-			/* halbtc8192e2ant_coex_alloff(btcoexist); */
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = unknown!!\n");
+			BTC_TRACE(trace_buf);
 			break;
 		}
 		coex_dm->pre_algorithm = coex_dm->cur_algorithm;
 	}
 }
 
-static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
-					  bool backup)
+static void halbtc8192e2ant_init_hw_config(struct btc_coexist *btcoexist,
+					   bool back_up)
 {
 	u16 u16tmp = 0;
 	u8 u8tmp = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], 2Ant Init HW Config!!\n");
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], 2Ant Init HW Config!!\n");
+	BTC_TRACE(trace_buf);
 
-	if (backup) {
+	if (back_up) {
 		/* backup rf 0x1e value */
-		coex_dm->bt_rf0x1e_backup =
-			btcoexist->btc_get_rf_reg(btcoexist, BTC_RF_A,
-						  0x1e, 0xfffff);
-
-		coex_dm->backup_arfr_cnt1 = btcoexist->btc_read_4byte(btcoexist,
-								      0x430);
-		coex_dm->backup_arfr_cnt2 = btcoexist->btc_read_4byte(btcoexist,
-								     0x434);
-		coex_dm->backup_retrylimit = btcoexist->btc_read_2byte(
-								    btcoexist,
-								    0x42a);
-		coex_dm->backup_ampdu_maxtime = btcoexist->btc_read_1byte(
-								    btcoexist,
-								    0x456);
+		coex_dm->bt_rf_0x1e_backup = btcoexist->btc_get_rf_reg(
+			btcoexist, BTC_RF_A, 0x1e, 0xfffff);
+
+		coex_dm->backup_arfr_cnt1 =
+			btcoexist->btc_read_4byte(btcoexist, 0x430);
+		coex_dm->backup_arfr_cnt2 =
+			btcoexist->btc_read_4byte(btcoexist, 0x434);
+		coex_dm->backup_retry_limit =
+			btcoexist->btc_read_2byte(btcoexist, 0x42a);
+		coex_dm->backup_ampdu_max_time =
+			btcoexist->btc_read_1byte(btcoexist, 0x456);
 	}
 
 	/* antenna sw ctrl to bt */
-	btcoexist->btc_write_1byte(btcoexist, 0x4f, 0x6);
-	btcoexist->btc_write_1byte(btcoexist, 0x944, 0x24);
-	btcoexist->btc_write_4byte(btcoexist, 0x930, 0x700700);
-	btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x20);
-	if (btcoexist->chip_interface == BTC_INTF_USB)
-		btcoexist->btc_write_4byte(btcoexist, 0x64, 0x30430004);
-	else
-		btcoexist->btc_write_4byte(btcoexist, 0x64, 0x30030004);
+	halbtc8192e2ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, true, false);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, FORCE_EXEC, 0);
+	halbtc8192e2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
 	/* antenna switch control parameter */
 	btcoexist->btc_write_4byte(btcoexist, 0x858, 0x55555555);
 
 	/* coex parameters */
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
-	/* 0x790[5:0] = 0x5 */
+	/* 0x790[5:0]=0x5 */
 	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
 	u8tmp &= 0xc0;
 	u8tmp |= 0x5;
@@ -3244,41 +3421,47 @@ static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
 	btcoexist->btc_write_1byte(btcoexist, 0x40, 0x20);
 	/* enable mailbox interface */
 	u16tmp = btcoexist->btc_read_2byte(btcoexist, 0x40);
-	u16tmp |= BIT9;
+	u16tmp |= BIT(9);
 	btcoexist->btc_write_2byte(btcoexist, 0x40, u16tmp);
 
-	/* enable PTA I2C mailbox  */
+	/* enable PTA I2C mailbox */
 	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x101);
-	u8tmp |= BIT4;
+	u8tmp |= BIT(4);
 	btcoexist->btc_write_1byte(btcoexist, 0x101, u8tmp);
 
 	/* enable bt clock when wifi is disabled. */
 	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x93);
-	u8tmp |= BIT0;
+	u8tmp |= BIT(0);
 	btcoexist->btc_write_1byte(btcoexist, 0x93, u8tmp);
 	/* enable bt clock when suspend. */
 	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x7);
-	u8tmp |= BIT0;
+	u8tmp |= BIT(0);
 	btcoexist->btc_write_1byte(btcoexist, 0x7, u8tmp);
 }
 
-/*************************************************************
- *   work around function start with wa_halbtc8192e2ant_
- *************************************************************/
-
-/************************************************************
- *   extern function start with EXhalbtc8192e2ant_
- ************************************************************/
+/* ************************************************************
+ * work around function start with wa_halbtc8192e2ant_
+ * ************************************************************
+ * ************************************************************
+ * extern function start with ex_halbtc8192e2ant_
+ * ************************************************************
+ */
+void ex_halbtc8192e2ant_power_on_setting(struct btc_coexist *btcoexist) {}
 
-void ex_halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist)
+void ex_halbtc8192e2ant_init_hw_config(struct btc_coexist *btcoexist,
+				       bool wifi_only)
 {
-	halbtc8192e2ant_init_hwconfig(btcoexist, true);
+	halbtc8192e2ant_init_hw_config(btcoexist, true);
 }
 
 void ex_halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], Coex Mechanism Init!!\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], Coex Mechanism Init!!\n");
+	BTC_TRACE(trace_buf);
+
 	halbtc8192e2ant_init_coex_dm(btcoexist);
 }
 
@@ -3286,268 +3469,284 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 *cli_buf = btcoexist->cli_buf;
 	u8 u8tmp[4], i, bt_info_ext, ps_tdma_case = 0;
 	u16 u16tmp[4];
 	u32 u32tmp[4];
-	bool roam = false, scan = false, link = false, wifi_under_5g = false;
-	bool bt_hson = false, wifi_busy = false;
-	int wifirssi = 0, bt_hs_rssi = 0;
-	u32 wifi_bw, wifi_traffic_dir;
-	u8 wifi_dot11_chnl, wifi_hs_chnl;
 	u32 fw_ver = 0, bt_patch_ver = 0;
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n ============[BT Coexist info]============");
+	CL_PRINTF(cli_buf);
 
 	if (btcoexist->manual_control) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ===========[Under Manual Control]===========");
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+		CL_SPRINTF(
+			cli_buf, BT_TMP_BUF_SIZE,
+			"\r\n ============[Under Manual Control]============");
+		CL_PRINTF(cli_buf);
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 			   "\r\n ==========================================");
+		CL_PRINTF(cli_buf);
 	}
 
-	if (!board_info->bt_exist) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n BT not exists !!!");
-		return;
-	}
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d ", "Ant PG number/ Ant mechanism:",
-		   board_info->pg_ant_num, board_info->btdm_ant_num);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s / %d",
-		   "BT stack/ hci ext ver",
-		   ((stack_info->profile_notified) ? "Yes" : "No"),
-		   stack_info->hci_version);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d ",
+		   "Ant PG number/ Ant mechanism:", board_info->pg_ant_num,
+		   board_info->btdm_ant_num);
+	CL_PRINTF(cli_buf);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER, &bt_patch_ver);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n %-35s = %d_%d/ 0x%x/ 0x%x(%d)",
-		   "CoexVer/ FwVer/ PatchVer",
-		   glcoex_ver_date_8192e_2ant, glcoex_ver_8192e_2ant,
-		   fw_ver, bt_patch_ver, bt_patch_ver);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
-	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_DOT11_CHNL,
-			   &wifi_dot11_chnl);
-	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL, &wifi_hs_chnl);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d(%d)",
-		   "Dot11 channel / HsMode(HsChnl)",
-		   wifi_dot11_chnl, bt_hson, wifi_hs_chnl);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %3ph ",
-		   "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifirssi);
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "Wifi rssi/ HS rssi", wifirssi, bt_hs_rssi);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d ",
-		   "Wifi link/ roam/ scan", link, roam, scan);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
-			   &wifi_traffic_dir);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s / %s/ %s ",
-		   "Wifi status", (wifi_under_5g ? "5G" : "2.4G"),
-		   ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
-			(((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40" : "HT20"))),
-		   ((!wifi_busy) ? "idle" :
-			((BTC_WIFI_TRAFFIC_TX == wifi_traffic_dir) ?
-				"uplink" : "downlink")));
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = [%s/ %d/ %d] ",
-		   "BT [status/ rssi/ retryCnt]",
-		   ((btcoexist->bt_info.bt_disabled) ? ("disabled") :
-		    ((coex_sta->c2h_bt_inquiry_page) ?
-		     ("inquiry/page scan") :
-		      ((BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE ==
-			coex_dm->bt_status) ? "non-connected idle" :
-			 ((BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE ==
-			   coex_dm->bt_status) ? "connected-idle" : "busy")))),
-		   coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d / %d / %d",
+		   "CoexVer/ FwVer/ PatchVer", glcoex_ver_date_8192e_2ant,
+		   glcoex_ver_8192e_2ant, fw_ver, bt_patch_ver, bt_patch_ver);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %02x %02x %02x ",
+		   "Wifi channel informed to BT", coex_dm->wifi_chnl_info[0],
+		   coex_dm->wifi_chnl_info[1], coex_dm->wifi_chnl_info[2]);
+	CL_PRINTF(cli_buf);
+
+	/* wifi status */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
+		   "============[Wifi Status]============");
+	CL_PRINTF(cli_buf);
+	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_WIFI_STATUS);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
+		   "============[BT Status]============");
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(
+		cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = [%s/ %d/ %d] ",
+		"BT [status/ rssi/ retryCnt]",
+		((coex_sta->bt_disabled) ?
+		 ("disabled") :
+		 ((coex_sta->c2h_bt_inquiry_page) ?
+		  ("inquiry/page scan") :
+		  ((BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE ==
+		    coex_dm->bt_status) ?
+		    "non-connected idle" :
+		    ((BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE ==
+		      coex_dm->bt_status) ?
+		      "connected-idle" :
+		      "busy")))),
+		coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d / %d / %d / %d",
 		   "SCO/HID/PAN/A2DP", stack_info->sco_exist,
 		   stack_info->hid_exist, stack_info->pan_exist,
 		   stack_info->a2dp_exist);
+	CL_PRINTF(cli_buf);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_BT_LINK_INFO);
 
 	bt_info_ext = coex_sta->bt_info_ext;
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s",
 		   "BT Info A2DP rate",
-		   (bt_info_ext&BIT0) ? "Basic rate" : "EDR rate");
+		   (bt_info_ext & BIT(0)) ? "Basic rate" : "EDR rate");
+	CL_PRINTF(cli_buf);
 
 	for (i = 0; i < BT_INFO_SRC_8192E_2ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %7ph(%d)",
-				   GLBtInfoSrc8192e2Ant[i],
-				   coex_sta->bt_info_c2h[i],
-				   coex_sta->bt_info_c2h_cnt[i]);
-		}
-	}
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s/%s",
-		   "PS state, IPS/LPS",
-		   ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
-		   ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")));
-	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x ", "SS Type",
-		   coex_dm->cur_sstype);
-
-	/* Sw mechanism	*/
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
+			CL_SPRINTF(
+				cli_buf, BT_TMP_BUF_SIZE,
+				"\r\n %-35s = %02x %02x %02x %02x %02x %02x %02x(%d)",
+				glbt_info_src_8192e_2ant[i],
+				coex_sta->bt_info_c2h[i][0],
+				coex_sta->bt_info_c2h[i][1],
+				coex_sta->bt_info_c2h[i][2],
+				coex_sta->bt_info_c2h[i][3],
+				coex_sta->bt_info_c2h[i][4],
+				coex_sta->bt_info_c2h[i][5],
+				coex_sta->bt_info_c2h[i][6],
+				coex_sta->bt_info_c2h_cnt[i]);
+			CL_PRINTF(cli_buf);
+		}
+	}
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x ", "SS Type",
+		   coex_dm->cur_ss_type);
+	CL_PRINTF(cli_buf);
+
+	/* Sw mechanism	 */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
 		   "============[Sw mechanism]============");
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d ",
+	CL_PRINTF(cli_buf);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d ",
 		   "SM1[ShRf/ LpRA/ LimDig]", coex_dm->cur_rf_rx_lpf_shrink,
 		   coex_dm->cur_low_penalty_ra, coex_dm->limited_dig);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d(0x%x) ",
+	CL_PRINTF(cli_buf);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d(0x%x) ",
 		   "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
 		   coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
 		   coex_dm->cur_dac_swing_on, coex_dm->cur_dac_swing_lvl);
+	CL_PRINTF(cli_buf);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x ", "Rate Mask",
-		   btcoexist->bt_info.ra_mask);
-
-	/* Fw mechanism	*/
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
+	/* Fw mechanism		 */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
 		   "============[Fw mechanism]============");
+	CL_PRINTF(cli_buf);
 
 	ps_tdma_case = coex_dm->cur_ps_tdma;
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %5ph case-%d (auto:%d)",
-		   "PS TDMA", coex_dm->ps_tdma_para,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
+		   "\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
+		   "PS TDMA", coex_dm->ps_tdma_para[0],
+		   coex_dm->ps_tdma_para[1], coex_dm->ps_tdma_para[2],
+		   coex_dm->ps_tdma_para[3], coex_dm->ps_tdma_para[4],
 		   ps_tdma_case, coex_dm->auto_tdma_adjust);
+	CL_PRINTF(cli_buf);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d ",
-		   "DecBtPwr/ IgnWlanAct",
-		   coex_dm->cur_dec_bt_pwr, coex_dm->cur_ignore_wlan_act);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d ",
+		   "DecBtPwr/ IgnWlanAct", coex_dm->cur_bt_dec_pwr_lvl,
+		   coex_dm->cur_ignore_wlan_act);
+	CL_PRINTF(cli_buf);
 
-	/* Hw setting */
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
+	/* Hw setting		 */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
 		   "============[Hw setting]============");
+	CL_PRINTF(cli_buf);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x",
-		   "RF-A, 0x1e initVal", coex_dm->bt_rf0x1e_backup);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x",
+		   "RF-A, 0x1e initVal", coex_dm->bt_rf_0x1e_backup);
+	CL_PRINTF(cli_buf);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
 		   "backup ARFR1/ARFR2/RL/AMaxTime", coex_dm->backup_arfr_cnt1,
-		   coex_dm->backup_arfr_cnt2, coex_dm->backup_retrylimit,
-		   coex_dm->backup_ampdu_maxtime);
+		   coex_dm->backup_arfr_cnt2, coex_dm->backup_retry_limit,
+		   coex_dm->backup_ampdu_max_time);
+	CL_PRINTF(cli_buf);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x430);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x434);
 	u16tmp[0] = btcoexist->btc_read_2byte(btcoexist, 0x42a);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x456);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
-		   "0x430/0x434/0x42a/0x456",
-		   u32tmp[0], u32tmp[1], u16tmp[0], u8tmp[0]);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
+		   "0x430/0x434/0x42a/0x456", u32tmp[0], u32tmp[1], u16tmp[0],
+		   u8tmp[0]);
+	CL_PRINTF(cli_buf);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc04);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0xd04);
 	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x90c);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
 		   "0xc04/ 0xd04/ 0x90c", u32tmp[0], u32tmp[1], u32tmp[2]);
+	CL_PRINTF(cli_buf);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x", "0x778",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x", "0x778",
 		   u8tmp[0]);
+	CL_PRINTF(cli_buf);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x92c);
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x930);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
 		   "0x92c/ 0x930", (u8tmp[0]), u32tmp[0]);
+	CL_PRINTF(cli_buf);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x40);
 	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x4f);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
 		   "0x40/ 0x4f", u8tmp[0], u8tmp[1]);
+	CL_PRINTF(cli_buf);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
 		   "0x550(bcn ctrl)/0x522", u32tmp[0], u8tmp[0]);
+	CL_PRINTF(cli_buf);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x", "0xc50(dig)",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x", "0xc50(dig)",
 		   u32tmp[0]);
+	CL_PRINTF(cli_buf);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
 	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x6cc);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
-		   "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
-		   u32tmp[0], u32tmp[1], u32tmp[2], u8tmp[0]);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x770(hp rx[31:16]/tx[15:0])",
-		   coex_sta->high_priority_rx, coex_sta->high_priority_tx);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x774(lp rx[31:16]/tx[15:0])",
-		   coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 1)
-	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
-#endif
+		   "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)", u32tmp[0], u32tmp[1],
+		   u32tmp[2], u8tmp[0]);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d",
+		   "0x770(hp rx[31:16]/tx[15:0])", coex_sta->high_priority_rx,
+		   coex_sta->high_priority_tx);
+	CL_PRINTF(cli_buf);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d",
+		   "0x774(lp rx[31:16]/tx[15:0])", coex_sta->low_priority_rx,
+		   coex_sta->low_priority_tx);
+	CL_PRINTF(cli_buf);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
 void ex_halbtc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	if (BTC_IPS_ENTER == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS ENTER notify\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	if (type == BTC_IPS_ENTER) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], IPS ENTER notify\n");
+		BTC_TRACE(trace_buf);
 		coex_sta->under_ips = true;
-		halbtc8192e2ant_coex_alloff(btcoexist);
-	} else if (BTC_IPS_LEAVE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS LEAVE notify\n");
+		halbtc8192e2ant_coex_all_off(btcoexist);
+		halbtc8192e2ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false,
+					     true);
+	} else if (type == BTC_IPS_LEAVE) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], IPS LEAVE notify\n");
+		BTC_TRACE(trace_buf);
 		coex_sta->under_ips = false;
 	}
 }
 
 void ex_halbtc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	if (BTC_LPS_ENABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS ENABLE notify\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	if (type == BTC_LPS_ENABLE) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], LPS ENABLE notify\n");
+		BTC_TRACE(trace_buf);
 		coex_sta->under_lps = true;
-	} else if (BTC_LPS_DISABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS DISABLE notify\n");
+	} else if (type == BTC_LPS_DISABLE) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], LPS DISABLE notify\n");
+		BTC_TRACE(trace_buf);
 		coex_sta->under_lps = false;
 	}
 }
 
 void ex_halbtc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	if (BTC_SCAN_START == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN START notify\n");
-	else if (BTC_SCAN_FINISH == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN FINISH notify\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	if (type == BTC_SCAN_START) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], SCAN START notify\n");
+		BTC_TRACE(trace_buf);
+	} else if (type == BTC_SCAN_FINISH) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], SCAN FINISH notify\n");
+		BTC_TRACE(trace_buf);
+	}
 }
 
 void ex_halbtc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	if (BTC_ASSOCIATE_START == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT START notify\n");
-	else if (BTC_ASSOCIATE_FINISH == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT FINISH notify\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	if (type == BTC_ASSOCIATE_START) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], CONNECT START notify\n");
+		BTC_TRACE(trace_buf);
+	} else if (type == BTC_ASSOCIATE_FINISH) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], CONNECT FINISH notify\n");
+		BTC_TRACE(trace_buf);
+	}
 }
 
 void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
@@ -3555,29 +3754,31 @@ void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 {
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
-	u8 wifi_center_chnl;
+	u8 wifi_central_chnl;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
+	    coex_sta->bt_disabled)
 		return;
 
-	if (BTC_MEDIA_CONNECT == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA connect notify\n");
-	else
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA disconnect notify\n");
+	if (type == BTC_MEDIA_CONNECT) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], MEDIA connect notify\n");
+		BTC_TRACE(trace_buf);
+	} else {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], MEDIA disconnect notify\n");
+		BTC_TRACE(trace_buf);
+	}
 
 	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
-			   &wifi_center_chnl);
-	if ((BTC_MEDIA_CONNECT == type) &&
-	    (wifi_center_chnl <= 14)) {
+			   &wifi_central_chnl);
+	if ((type == BTC_MEDIA_CONNECT) && (wifi_central_chnl <= 14)) {
 		h2c_parameter[0] = 0x1;
-		h2c_parameter[1] = wifi_center_chnl;
+		h2c_parameter[1] = wifi_central_chnl;
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-		if (BTC_WIFI_BW_HT40 == wifi_bw)
+		if (wifi_bw == BTC_WIFI_BW_HT40)
 			h2c_parameter[2] = 0x30;
 		else
 			h2c_parameter[2] = 0x20;
@@ -3587,20 +3788,19 @@ void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 	coex_dm->wifi_chnl_info[1] = h2c_parameter[1];
 	coex_dm->wifi_chnl_info[2] = h2c_parameter[2];
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x66 = 0x%x\n",
-		    h2c_parameter[0] << 16 | h2c_parameter[1] << 8 |
-		    h2c_parameter[2]);
-
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
 
-void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type)
+void ex_halbtc8192e2ant_specific_packet_notify(struct btc_coexist *btcoexist,
+					       u8 type)
 {
-	if (type == BTC_PACKET_DHCP)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], DHCP Packet notify\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	if (type == BTC_PACKET_DHCP) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], DHCP Packet notify\n");
+		BTC_TRACE(trace_buf);
+	}
 }
 
 void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
@@ -3610,6 +3810,7 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	u8 i, rsp_source = 0;
 	bool bt_busy = false, limited_dig = false;
 	bool wifi_connected = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	coex_sta->c2h_bt_info_req_sent = false;
 
@@ -3618,72 +3819,72 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		rsp_source = BT_INFO_SRC_8192E_2ANT_WIFI_FW;
 	coex_sta->bt_info_c2h_cnt[rsp_source]++;
 
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Bt info[%d], length=%d, hex data = [",
-		      rsp_source, length);
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], Bt info[%d], length=%d, hex data=[", rsp_source,
+		    length);
+	BTC_TRACE(trace_buf);
 	for (i = 0; i < length; i++) {
 		coex_sta->bt_info_c2h[rsp_source][i] = tmp_buf[i];
 		if (i == 1)
 			bt_info = tmp_buf[i];
-		if (i == length-1)
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x]\n", tmp_buf[i]);
-		else
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x, ", tmp_buf[i]);
+		if (i == length - 1) {
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "0x%02x]\n",
+				    tmp_buf[i]);
+			BTC_TRACE(trace_buf);
+		} else {
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "0x%02x, ",
+				    tmp_buf[i]);
+			BTC_TRACE(trace_buf);
+		}
 	}
 
-	if (BT_INFO_SRC_8192E_2ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0] */
+	if (rsp_source != BT_INFO_SRC_8192E_2ANT_WIFI_FW) {
+		coex_sta->bt_retry_cnt = /* [3:0] */
 			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
 		coex_sta->bt_rssi =
 			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
 
-		coex_sta->bt_info_ext =
-			coex_sta->bt_info_c2h[rsp_source][4];
+		coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
 
-		/* Here we need to resend some wifi info to BT
-		 * because bt is reset and loss of the info.
-		 */
-		if ((coex_sta->bt_info_ext & BIT1)) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "bit1, send wifi BW&Chnl to BT!!\n");
+		/* Here we need to resend some wifi info to BT */
+		/* because bt is reset and loss of the info. */
+		if ((coex_sta->bt_info_ext & BIT(1))) {
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
+			BTC_TRACE(trace_buf);
 			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
 			if (wifi_connected)
 				ex_halbtc8192e2ant_media_status_notify(
-							btcoexist,
-							BTC_MEDIA_CONNECT);
+					btcoexist, BTC_MEDIA_CONNECT);
 			else
 				ex_halbtc8192e2ant_media_status_notify(
-							btcoexist,
-							BTC_MEDIA_DISCONNECT);
+					btcoexist, BTC_MEDIA_DISCONNECT);
 		}
 
-		if ((coex_sta->bt_info_ext & BIT3)) {
+		if ((coex_sta->bt_info_ext & BIT(3))) {
 			if (!btcoexist->manual_control &&
 			    !btcoexist->stop_coex_dm) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "bit3, BT NOT ignore Wlan active!\n");
-				halbtc8192e2ant_IgnoreWlanAct(btcoexist,
-							      FORCE_EXEC,
-							      false);
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
+				BTC_TRACE(trace_buf);
+				halbtc8192e2ant_ignore_wlan_act(
+					btcoexist, FORCE_EXEC, false);
 			}
 		} else {
-			/* BT already NOT ignore Wlan active,
-			 * do nothing here.
+			/* BT already NOT ignore Wlan active, do nothing here.
 			 */
 		}
 
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-		if ((coex_sta->bt_info_ext & BIT4)) {
+		if ((coex_sta->bt_info_ext & BIT(4))) {
 			/* BT auto report already enabled, do nothing */
 		} else {
-			halbtc8192e2ant_bt_autoreport(btcoexist, FORCE_EXEC,
-						      true);
+			halbtc8192e2ant_bt_auto_report(btcoexist, FORCE_EXEC,
+						       true);
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan */
@@ -3693,13 +3894,13 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->c2h_bt_inquiry_page = false;
 
 	/* set link exist status */
-	if (!(bt_info&BT_INFO_8192E_2ANT_B_CONNECTION)) {
+	if (!(bt_info & BT_INFO_8192E_2ANT_B_CONNECTION)) {
 		coex_sta->bt_link_exist = false;
 		coex_sta->pan_exist = false;
 		coex_sta->a2dp_exist = false;
 		coex_sta->hid_exist = false;
 		coex_sta->sco_exist = false;
-	} else {/* connection exists */
+	} else { /* connection exists */
 		coex_sta->bt_link_exist = true;
 		if (bt_info & BT_INFO_8192E_2ANT_B_FTP)
 			coex_sta->pan_exist = true;
@@ -3719,34 +3920,42 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_sta->sco_exist = false;
 	}
 
-	halbtc8192e2ant_update_btlink_info(btcoexist);
+	halbtc8192e2ant_update_bt_link_info(btcoexist);
 
-	if (!(bt_info&BT_INFO_8192E_2ANT_B_CONNECTION)) {
+	if (!(bt_info & BT_INFO_8192E_2ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BT Non-Connected idle!!!\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+		BTC_TRACE(trace_buf);
 	} else if (bt_info == BT_INFO_8192E_2ANT_B_CONNECTION) {
+		/* connection exists but no busy */
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], bt_infoNotify(), BT Connected-idle!!!\n");
-	} else if ((bt_info&BT_INFO_8192E_2ANT_B_SCO_ESCO) ||
-		   (bt_info&BT_INFO_8192E_2ANT_B_SCO_BUSY)) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
+		BTC_TRACE(trace_buf);
+	} else if ((bt_info & BT_INFO_8192E_2ANT_B_SCO_ESCO) ||
+		   (bt_info & BT_INFO_8192E_2ANT_B_SCO_BUSY)) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_SCO_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], bt_infoNotify(), BT SCO busy!!!\n");
-	} else if (bt_info&BT_INFO_8192E_2ANT_B_ACL_BUSY) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
+		BTC_TRACE(trace_buf);
+	} else if (bt_info & BT_INFO_8192E_2ANT_B_ACL_BUSY) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_ACL_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], bt_infoNotify(), BT ACL busy!!!\n");
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
+		BTC_TRACE(trace_buf);
 	} else {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_MAX;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex]bt_infoNotify(), BT Non-Defined state!!!\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
+		BTC_TRACE(trace_buf);
 	}
 
-	if ((BT_8192E_2ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) ||
-	    (BT_8192E_2ANT_BT_STATUS_SCO_BUSY == coex_dm->bt_status) ||
-	    (BT_8192E_2ANT_BT_STATUS_ACL_SCO_BUSY == coex_dm->bt_status)) {
+	if ((coex_dm->bt_status == BT_8192E_2ANT_BT_STATUS_ACL_BUSY) ||
+	    (coex_dm->bt_status == BT_8192E_2ANT_BT_STATUS_SCO_BUSY) ||
+	    (coex_dm->bt_status == BT_8192E_2ANT_BT_STATUS_ACL_SCO_BUSY)) {
 		bt_busy = true;
 		limited_dig = true;
 	} else {
@@ -3762,58 +3971,21 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	halbtc8192e2ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8192e2ant_stack_operation_notify(struct btc_coexist *btcoexist,
-					       u8 type)
-{
-}
-
 void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_NOTIFY, "[BTCoex], Halt notify\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	halbtc8192e2ant_IgnoreWlanAct(btcoexist, FORCE_EXEC, true);
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "[BTCoex], Halt notify\n");
+	BTC_TRACE(trace_buf);
+
+	halbtc8192e2ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false, true);
+	halbtc8192e2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 	ex_halbtc8192e2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
 void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist)
 {
-	static u8 dis_ver_info_cnt;
-	u32 fw_ver = 0, bt_patch_ver = 0;
-	struct btc_board_info *board_info = &btcoexist->board_info;
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-
-	btc_alg_dbg(ALGO_TRACE,
-		    "=======================Periodical=======================\n");
-	if (dis_ver_info_cnt <= 5) {
-		dis_ver_info_cnt += 1;
-		btc_iface_dbg(INTF_INIT,
-			      "************************************************\n");
-		btc_iface_dbg(INTF_INIT,
-			      "Ant PG Num/ Ant Mech/ Ant Pos = %d/ %d/ %d\n",
-			      board_info->pg_ant_num, board_info->btdm_ant_num,
-			      board_info->btdm_ant_pos);
-		btc_iface_dbg(INTF_INIT,
-			      "BT stack/ hci ext ver = %s / %d\n",
-			      ((stack_info->profile_notified) ? "Yes" : "No"),
-			      stack_info->hci_version);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
-				   &bt_patch_ver);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "CoexVer/ FwVer/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
-			      glcoex_ver_date_8192e_2ant, glcoex_ver_8192e_2ant,
-			      fw_ver, bt_patch_ver, bt_patch_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "************************************************\n");
-	}
-
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-	halbtc8192e2ant_querybt_info(btcoexist);
+	halbtc8192e2ant_query_bt_info(btcoexist);
 	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
-	btc8192e2ant_monitor_bt_enable_dis(btcoexist);
-#else
-	if (halbtc8192e2ant_iswifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust)
-		halbtc8192e2ant_run_coexist_mechanism(btcoexist);
-#endif
+	halbtc8192e2ant_monitor_bt_enable_disable(btcoexist);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
index 75e1f7d..6581d3f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
@@ -22,151 +22,156 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *
  *****************************************************************************/
-/*****************************************************************
- *   The following is for 8192E 2Ant BT Co-exist definition
- *****************************************************************/
-#define	BT_AUTO_REPORT_ONLY_8192E_2ANT			0
 
-#define	BT_INFO_8192E_2ANT_B_FTP			BIT7
-#define	BT_INFO_8192E_2ANT_B_A2DP			BIT6
-#define	BT_INFO_8192E_2ANT_B_HID			BIT5
-#define	BT_INFO_8192E_2ANT_B_SCO_BUSY			BIT4
-#define	BT_INFO_8192E_2ANT_B_ACL_BUSY			BIT3
-#define	BT_INFO_8192E_2ANT_B_INQ_PAGE			BIT2
-#define	BT_INFO_8192E_2ANT_B_SCO_ESCO			BIT1
-#define	BT_INFO_8192E_2ANT_B_CONNECTION			BIT0
+/* *******************************************
+ * The following is for 8192E 2Ant BT Co-exist definition
+ * *******************************************
+ */
 
-#define BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT		2
+#define BT_INFO_8192E_2ANT_B_FTP	BIT(7)
+#define BT_INFO_8192E_2ANT_B_A2DP	BIT(6)
+#define BT_INFO_8192E_2ANT_B_HID	BIT(5)
+#define BT_INFO_8192E_2ANT_B_SCO_BUSY	BIT(4)
+#define BT_INFO_8192E_2ANT_B_ACL_BUSY	BIT(3)
+#define BT_INFO_8192E_2ANT_B_INQ_PAGE	BIT(2)
+#define BT_INFO_8192E_2ANT_B_SCO_ESCO	BIT(1)
+#define BT_INFO_8192E_2ANT_B_CONNECTION	BIT(0)
+
+#define BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT	2
 
 enum bt_info_src_8192e_2ant {
-	BT_INFO_SRC_8192E_2ANT_WIFI_FW			= 0x0,
-	BT_INFO_SRC_8192E_2ANT_BT_RSP			= 0x1,
-	BT_INFO_SRC_8192E_2ANT_BT_ACTIVE_SEND		= 0x2,
+	BT_INFO_SRC_8192E_2ANT_WIFI_FW	= 0x0,
+	BT_INFO_SRC_8192E_2ANT_BT_RSP	= 0x1,
+	BT_INFO_SRC_8192E_2ANT_BT_ACTIVE_SEND	= 0x2,
 	BT_INFO_SRC_8192E_2ANT_MAX
 };
 
 enum bt_8192e_2ant_bt_status {
 	BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE	= 0x0,
-	BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE		= 0x1,
-	BT_8192E_2ANT_BT_STATUS_INQ_PAGE		= 0x2,
-	BT_8192E_2ANT_BT_STATUS_ACL_BUSY		= 0x3,
-	BT_8192E_2ANT_BT_STATUS_SCO_BUSY		= 0x4,
-	BT_8192E_2ANT_BT_STATUS_ACL_SCO_BUSY		= 0x5,
+	BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE	= 0x1,
+	BT_8192E_2ANT_BT_STATUS_INQ_PAGE	= 0x2,
+	BT_8192E_2ANT_BT_STATUS_ACL_BUSY	= 0x3,
+	BT_8192E_2ANT_BT_STATUS_SCO_BUSY	= 0x4,
+	BT_8192E_2ANT_BT_STATUS_ACL_SCO_BUSY	= 0x5,
 	BT_8192E_2ANT_BT_STATUS_MAX
 };
 
 enum bt_8192e_2ant_coex_algo {
-	BT_8192E_2ANT_COEX_ALGO_UNDEFINED		= 0x0,
-	BT_8192E_2ANT_COEX_ALGO_SCO			= 0x1,
-	BT_8192E_2ANT_COEX_ALGO_SCO_PAN			= 0x2,
-	BT_8192E_2ANT_COEX_ALGO_HID			= 0x3,
-	BT_8192E_2ANT_COEX_ALGO_A2DP			= 0x4,
-	BT_8192E_2ANT_COEX_ALGO_A2DP_PANHS		= 0x5,
-	BT_8192E_2ANT_COEX_ALGO_PANEDR			= 0x6,
-	BT_8192E_2ANT_COEX_ALGO_PANHS			= 0x7,
-	BT_8192E_2ANT_COEX_ALGO_PANEDR_A2DP		= 0x8,
-	BT_8192E_2ANT_COEX_ALGO_PANEDR_HID		= 0x9,
-	BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR		= 0xa,
-	BT_8192E_2ANT_COEX_ALGO_HID_A2DP		= 0xb,
-	BT_8192E_2ANT_COEX_ALGO_MAX			= 0xc
+	BT_8192E_2ANT_COEX_ALGO_UNDEFINED	= 0x0,
+	BT_8192E_2ANT_COEX_ALGO_SCO	= 0x1,
+	BT_8192E_2ANT_COEX_ALGO_SCO_PAN	= 0x2,
+	BT_8192E_2ANT_COEX_ALGO_HID	= 0x3,
+	BT_8192E_2ANT_COEX_ALGO_A2DP	= 0x4,
+	BT_8192E_2ANT_COEX_ALGO_A2DP_PANHS	= 0x5,
+	BT_8192E_2ANT_COEX_ALGO_PANEDR	= 0x6,
+	BT_8192E_2ANT_COEX_ALGO_PANHS	= 0x7,
+	BT_8192E_2ANT_COEX_ALGO_PANEDR_A2DP	= 0x8,
+	BT_8192E_2ANT_COEX_ALGO_PANEDR_HID	= 0x9,
+	BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR	= 0xa,
+	BT_8192E_2ANT_COEX_ALGO_HID_A2DP	= 0xb,
+	BT_8192E_2ANT_COEX_ALGO_MAX = 0xc
 };
 
 struct coex_dm_8192e_2ant {
 	/* fw mechanism */
-	u8 pre_dec_bt_pwr;
-	u8 cur_dec_bt_pwr;
-	u8 pre_fw_dac_swing_lvl;
-	u8 cur_fw_dac_swing_lvl;
-	bool cur_ignore_wlan_act;
-	bool pre_ignore_wlan_act;
-	u8 pre_ps_tdma;
-	u8 cur_ps_tdma;
-	u8 ps_tdma_para[5];
-	u8 tdma_adj_type;
-	bool reset_tdma_adjust;
-	bool auto_tdma_adjust;
-	bool pre_ps_tdma_on;
-	bool cur_ps_tdma_on;
-	bool pre_bt_auto_report;
-	bool cur_bt_auto_report;
+	u8	pre_bt_dec_pwr_lvl;
+	u8	cur_bt_dec_pwr_lvl;
+	u8	pre_fw_dac_swing_lvl;
+	u8	cur_fw_dac_swing_lvl;
+	bool	cur_ignore_wlan_act;
+	bool	pre_ignore_wlan_act;
+	u8	pre_ps_tdma;
+	u8	cur_ps_tdma;
+	u8	ps_tdma_para[5];
+	u8	ps_tdma_du_adj_type;
+	bool	reset_tdma_adjust;
+	bool	auto_tdma_adjust;
+	bool	pre_ps_tdma_on;
+	bool	cur_ps_tdma_on;
+	bool	pre_bt_auto_report;
+	bool	cur_bt_auto_report;
 
 	/* sw mechanism */
-	bool pre_rf_rx_lpf_shrink;
-	bool cur_rf_rx_lpf_shrink;
-	u32 bt_rf0x1e_backup;
-	bool pre_low_penalty_ra;
-	bool cur_low_penalty_ra;
-	bool pre_dac_swing_on;
-	u32 pre_dac_swing_lvl;
-	bool cur_dac_swing_on;
-	u32 cur_dac_swing_lvl;
-	bool pre_adc_back_off;
-	bool cur_adc_back_off;
-	bool pre_agc_table_en;
-	bool cur_agc_table_en;
-	u32 pre_val0x6c0;
-	u32 cur_val0x6c0;
-	u32 pre_val0x6c4;
-	u32 cur_val0x6c4;
-	u32 pre_val0x6c8;
-	u32 cur_val0x6c8;
-	u8 pre_val0x6cc;
-	u8 cur_val0x6cc;
-	bool limited_dig;
+	bool	pre_rf_rx_lpf_shrink;
+	bool	cur_rf_rx_lpf_shrink;
+	u32	bt_rf_0x1e_backup;
+	bool	pre_low_penalty_ra;
+	bool	cur_low_penalty_ra;
+	bool	pre_dac_swing_on;
+	u32	pre_dac_swing_lvl;
+	bool	cur_dac_swing_on;
+	u32	cur_dac_swing_lvl;
+	bool	pre_adc_back_off;
+	bool	cur_adc_back_off;
+	bool	pre_agc_table_en;
+	bool	cur_agc_table_en;
+	u32	pre_val0x6c0;
+	u32	cur_val0x6c0;
+	u32	pre_val0x6c4;
+	u32	cur_val0x6c4;
+	u32	pre_val0x6c8;
+	u32	cur_val0x6c8;
+	u8	pre_val0x6cc;
+	u8	cur_val0x6cc;
+	bool	limited_dig;
 
-	u32 backup_arfr_cnt1;	/* Auto Rate Fallback Retry cnt */
-	u32 backup_arfr_cnt2;	/* Auto Rate Fallback Retry cnt */
-	u16 backup_retrylimit;
-	u8 backup_ampdu_maxtime;
+	u32	backup_arfr_cnt1; /* Auto Rate Fallback Retry cnt */
+	u32	backup_arfr_cnt2; /* Auto Rate Fallback Retry cnt */
+	u16	backup_retry_limit;
+	u8	backup_ampdu_max_time;
 
 	/* algorithm related */
-	u8 pre_algorithm;
-	u8 cur_algorithm;
-	u8 bt_status;
-	u8 wifi_chnl_info[3];
+	u8	pre_algorithm;
+	u8	cur_algorithm;
+	u8	bt_status;
+	u8	wifi_chnl_info[3];
 
-	u8 pre_sstype;
-	u8 cur_sstype;
+	u8	pre_ss_type;
+	u8	cur_ss_type;
 
-	u32 prera_mask;
-	u32 curra_mask;
-	u8 curra_masktype;
-	u8 pre_arfrtype;
-	u8 cur_arfrtype;
-	u8 pre_retrylimit_type;
-	u8 cur_retrylimit_type;
-	u8 pre_ampdutime_type;
-	u8 cur_ampdutime_type;
+	u32	pre_ra_mask;
+	u32	cur_ra_mask;
+	u8	cur_ra_mask_type;
+	u8	pre_arfr_type;
+	u8	cur_arfr_type;
+	u8	pre_retry_limit_type;
+	u8	cur_retry_limit_type;
+	u8	pre_ampdu_time_type;
+	u8	cur_ampdu_time_type;
 };
 
 struct coex_sta_8192e_2ant {
-	bool bt_link_exist;
-	bool sco_exist;
-	bool a2dp_exist;
-	bool hid_exist;
-	bool pan_exist;
+	bool	bt_disabled;
+	bool	bt_link_exist;
+	bool	sco_exist;
+	bool	a2dp_exist;
+	bool	hid_exist;
+	bool	pan_exist;
 
-	bool under_lps;
-	bool under_ips;
-	u32 high_priority_tx;
-	u32 high_priority_rx;
-	u32 low_priority_tx;
-	u32 low_priority_rx;
-	u8 bt_rssi;
-	u8 pre_bt_rssi_state;
-	u8 pre_wifi_rssi_state[4];
-	bool c2h_bt_info_req_sent;
-	u8 bt_info_c2h[BT_INFO_SRC_8192E_2ANT_MAX][10];
-	u32 bt_info_c2h_cnt[BT_INFO_SRC_8192E_2ANT_MAX];
-	bool c2h_bt_inquiry_page;
-	u8 bt_retry_cnt;
-	u8 bt_info_ext;
+	bool	under_lps;
+	bool	under_ips;
+	u32	high_priority_tx;
+	u32	high_priority_rx;
+	u32	low_priority_tx;
+	u32	low_priority_rx;
+	u8	bt_rssi;
+	u8	pre_bt_rssi_state;
+	u8	pre_wifi_rssi_state[4];
+	bool	c2h_bt_info_req_sent;
+	u8	bt_info_c2h[BT_INFO_SRC_8192E_2ANT_MAX][10];
+	u32	bt_info_c2h_cnt[BT_INFO_SRC_8192E_2ANT_MAX];
+	bool	c2h_bt_inquiry_page;
+	u8	bt_retry_cnt;
+	u8	bt_info_ext;
 };
 
-/****************************************************************
- *    The following is interface which will notify coex module.
- ****************************************************************/
-void ex_halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist);
+/* *******************************************
+ * The following is interface which will notify coex module.
+ * *******************************************
+ */
+void ex_halbtc8192e2ant_power_on_setting(struct btc_coexist *btcoexist);
+void ex_halbtc8192e2ant_init_hw_config(struct btc_coexist *btcoexist,
+				       bool wifi_only);
 void ex_halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist);
 void ex_halbtc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
 void ex_halbtc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
@@ -174,12 +179,10 @@ void ex_halbtc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
 void ex_halbtc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
 void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 					    u8 type);
-void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type);
-void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpbuf, u8 length);
-void ex_halbtc8192e2ant_stack_operation_notify(struct btc_coexist *btcoexist,
+void ex_halbtc8192e2ant_specific_packet_notify(struct btc_coexist *btcoexist,
 					       u8 type);
+void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
+				       u8 *tmp_buf, u8 length);
 void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist);
 void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist);
 void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist);
-- 
2.10.2
