Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35998 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753029AbcLCRcc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Dec 2016 12:32:32 -0500
Received: by mail-oi0-f67.google.com with SMTP id u15so31484735oie.3
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2016 09:32:31 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/7] rtlwifi: btcoexist: Rewrite routine halbtc8821a1ant
Date: Sat,  3 Dec 2016 11:32:04 -0600
Message-Id: <20161203173207.17774-5-Larry.Finger@lwfinger.net> (sfid-20161203_183243_152362_48E1C054)
In-Reply-To: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
References: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The btcoexist rourines for RTL8821AE have been rewritten. This is
part 1 of these changes.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 3233 ++++++++++----------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |  148 +-
 2 files changed, 1771 insertions(+), 1610 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 3ce47c7..53e744d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -22,25 +22,25 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *
  *****************************************************************************/
-
-/*============================================================
+/* ************************************************************
  * Description:
  *
- * This file is for RTL8821A Co-exist mechanism
+ * This file is for 8821A_1ANT Co-exist mechanism
  *
  * History
  * 2012/11/15 Cosa first check in.
  *
- *============================================================
-*/
-/*============================================================
+ * ************************************************************
+ * SY modify 2015/04/27
+ * ************************************************************
  * include files
- *============================================================
+ * ************************************************************
  */
 #include "halbt_precomp.h"
-/*============================================================
+
+/* ************************************************************
  * Global variables, these are static variables
- *============================================================
+ * ************************************************************
  */
 static struct coex_dm_8821a_1ant glcoex_dm_8821a_1ant;
 static struct coex_dm_8821a_1ant *coex_dm = &glcoex_dm_8821a_1ant;
@@ -48,112 +48,89 @@ static struct coex_sta_8821a_1ant glcoex_sta_8821a_1ant;
 static struct coex_sta_8821a_1ant *coex_sta = &glcoex_sta_8821a_1ant;
 
 static const char *const glbt_info_src_8821a_1ant[] = {
-	  "BT Info[wifi fw]",
-	  "BT Info[bt rsp]",
-	  "BT Info[bt auto report]",
+	"BT Info[wifi fw]", "BT Info[bt rsp]", "BT Info[bt auto report]",
 };
 
-static u32	glcoex_ver_date_8821a_1ant = 20130816;
-static u32	glcoex_ver_8821a_1ant = 0x41;
+static u32 glcoex_ver_date_8821a_1ant = 20150615;
+static u32 glcoex_ver_8821a_1ant = 0x61;
 
-/*============================================================
+/* ************************************************************
  * local function proto type if needed
- *
+ * ************************************************************
+ * ************************************************************
  * local function start with halbtc8821a1ant_
- *============================================================
+ * ************************************************************
  */
-static u8 halbtc8821a1ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
-					u8 rssi_thresh1)
+static
+u8 halbtc8821a1ant_bt_rssi_state(u8 level_num, u8 rssi_thresh, u8 rssi_thresh1)
 {
-	long	bt_rssi = 0;
-	u8	bt_rssi_state = coex_sta->pre_bt_rssi_state;
+	s32 bt_rssi = 0;
+	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	bt_rssi = coex_sta->bt_rssi;
 
 	if (level_num == 2) {
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			if (bt_rssi >= (rssi_thresh +
-					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			if (bt_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT))
 				bt_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to High\n");
-			} else {
+			else
 				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at Low\n");
-			}
 		} else {
-			if (bt_rssi < rssi_thresh) {
+			if (bt_rssi < rssi_thresh)
 				bt_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Low\n");
-			} else {
+			else
 				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at High\n");
-			}
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_BT_RSSI_STATE,
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 				    "[BTCoex], BT Rssi thresh error!!\n");
+			BTC_TRACE(trace_buf);
 			return coex_sta->pre_bt_rssi_state;
 		}
 
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			if (bt_rssi >= (rssi_thresh +
-					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			if (bt_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT))
 				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Medium\n");
-			} else {
+			else
 				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at Low\n");
-			}
 		} else if ((coex_sta->pre_bt_rssi_state ==
-			   BTC_RSSI_STATE_MEDIUM) ||
+			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_bt_rssi_state ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
 			if (bt_rssi >= (rssi_thresh1 +
-					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT))
 				bt_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to High\n");
-			} else if (bt_rssi < rssi_thresh) {
+			else if (bt_rssi < rssi_thresh)
 				bt_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Low\n");
-			} else {
+			else
 				bt_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at Medium\n");
-			}
 		} else {
-			if (bt_rssi < rssi_thresh1) {
+			if (bt_rssi < rssi_thresh1)
 				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state switch to Medium\n");
-			} else {
+			else
 				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_BT_RSSI_STATE,
-					    "[BTCoex], BT Rssi state stay at High\n");
-			}
 		}
 	}
+
 	coex_sta->pre_bt_rssi_state = bt_rssi_state;
 
 	return bt_rssi_state;
 }
 
-static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
-					u8 index, u8 level_num, u8 rssi_thresh,
-					u8 rssi_thresh1)
+static
+u8 halbtc8821a1ant_wifi_rssi_state(struct btc_coexist *btcoexist, u8 index,
+				   u8 level_num, u8 rssi_thresh,
+				   u8 rssi_thresh1)
 {
-	long	wifi_rssi = 0;
-	u8	wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
+	s32 wifi_rssi = 0;
+	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 
@@ -163,30 +140,21 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
 			if (wifi_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT))
 				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to High\n");
-			} else {
+			else
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at Low\n");
-			}
 		} else {
-			if (wifi_rssi < rssi_thresh) {
+			if (wifi_rssi < rssi_thresh)
 				wifi_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Low\n");
-			} else {
+			else
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at High\n");
-			}
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
-			btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 				    "[BTCoex], wifi RSSI thresh error!!\n");
+			BTC_TRACE(trace_buf);
 			return coex_sta->pre_wifi_rssi_state[index];
 		}
 
@@ -195,75 +163,57 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
 			if (wifi_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT))
 				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Medium\n");
-			} else {
+			else
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at Low\n");
-			}
 		} else if ((coex_sta->pre_wifi_rssi_state[index] ==
-			BTC_RSSI_STATE_MEDIUM) ||
-			(coex_sta->pre_wifi_rssi_state[index] ==
-			BTC_RSSI_STATE_STAY_MEDIUM)) {
-			if (wifi_rssi >=
-			    (rssi_thresh1 +
-			     BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			    BTC_RSSI_STATE_MEDIUM) ||
+			   (coex_sta->pre_wifi_rssi_state[index] ==
+			    BTC_RSSI_STATE_STAY_MEDIUM)) {
+			if (wifi_rssi >= (rssi_thresh1 +
+					  BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT))
 				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to High\n");
-			} else if (wifi_rssi < rssi_thresh) {
+			else if (wifi_rssi < rssi_thresh)
 				wifi_rssi_state = BTC_RSSI_STATE_LOW;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Low\n");
-			} else {
+			else
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at Medium\n");
-			}
 		} else {
-			if (wifi_rssi < rssi_thresh1) {
+			if (wifi_rssi < rssi_thresh1)
 				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state switch to Medium\n");
-			} else {
+			else
 				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
-				btc_alg_dbg(ALGO_WIFI_RSSI_STATE,
-					    "[BTCoex], wifi RSSI state stay at High\n");
-			}
 		}
 	}
+
 	coex_sta->pre_wifi_rssi_state[index] = wifi_rssi_state;
 
 	return wifi_rssi_state;
 }
 
-static void halbtc8821a1ant_update_ra_mask(struct btc_coexist *btcoexist,
-					   bool force_exec, u32 dis_rate_mask)
+static
+void halbtc8821a1ant_update_ra_mask(struct btc_coexist *btcoexist,
+				    bool force_exec, u32 dis_rate_mask)
 {
 	coex_dm->cur_ra_mask = dis_rate_mask;
 
-	if (force_exec ||
-	    (coex_dm->pre_ra_mask != coex_dm->cur_ra_mask)) {
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_ra_mask,
+	if (force_exec || (coex_dm->pre_ra_mask != coex_dm->cur_ra_mask))
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_RAMASK,
 				   &coex_dm->cur_ra_mask);
-	}
 	coex_dm->pre_ra_mask = coex_dm->cur_ra_mask;
 }
 
-static void btc8821a1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
-					    bool force_exec, u8 type)
+static
+void halbtc8821a1ant_auto_rate_fallback_retry(struct btc_coexist *btcoexist,
+					      bool force_exec, u8 type)
 {
-	bool	wifi_under_b_mode = false;
+	bool wifi_under_b_mode = false;
 
 	coex_dm->cur_arfr_type = type;
 
-	if (force_exec ||
-	    (coex_dm->pre_arfr_type != coex_dm->cur_arfr_type)) {
+	if (force_exec || (coex_dm->pre_arfr_type != coex_dm->cur_arfr_type)) {
 		switch (coex_dm->cur_arfr_type) {
-		case 0:	/* normal mode*/
+		case 0: /* normal mode */
 			btcoexist->btc_write_4byte(btcoexist, 0x430,
 						   coex_dm->backup_arfr_cnt1);
 			btcoexist->btc_write_4byte(btcoexist, 0x434,
@@ -293,41 +243,45 @@ static void btc8821a1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
 	coex_dm->pre_arfr_type = coex_dm->cur_arfr_type;
 }
 
-static void halbtc8821a1ant_retry_limit(struct btc_coexist *btcoexist,
-					bool force_exec, u8 type)
+static
+void halbtc8821a1ant_retry_limit(struct btc_coexist *btcoexist, bool force_exec,
+				 u8 type)
 {
 	coex_dm->cur_retry_limit_type = type;
 
 	if (force_exec ||
 	    (coex_dm->pre_retry_limit_type != coex_dm->cur_retry_limit_type)) {
 		switch (coex_dm->cur_retry_limit_type) {
-		case 0:	/* normal mode*/
+		case 0: /* normal mode */
 			btcoexist->btc_write_2byte(btcoexist, 0x42a,
 						   coex_dm->backup_retry_limit);
 			break;
-		case 1:	/* retry limit = 8*/
+		case 1: /* retry limit=8 */
 			btcoexist->btc_write_2byte(btcoexist, 0x42a, 0x0808);
 			break;
 		default:
 			break;
 		}
 	}
+
 	coex_dm->pre_retry_limit_type = coex_dm->cur_retry_limit_type;
 }
 
-static void halbtc8821a1ant_ampdu_max_time(struct btc_coexist *btcoexist,
-					   bool force_exec, u8 type)
+static
+void halbtc8821a1ant_ampdu_max_time(struct btc_coexist *btcoexist,
+				    bool force_exec, u8 type)
 {
 	coex_dm->cur_ampdu_time_type = type;
 
 	if (force_exec ||
 	    (coex_dm->pre_ampdu_time_type != coex_dm->cur_ampdu_time_type)) {
 		switch (coex_dm->cur_ampdu_time_type) {
-		case 0:	/* normal mode*/
-			btcoexist->btc_write_1byte(btcoexist, 0x456,
-						   coex_dm->backup_ampdu_max_time);
+		case 0: /* normal mode */
+			btcoexist->btc_write_1byte(
+				btcoexist, 0x456,
+				coex_dm->backup_ampdu_max_time);
 			break;
-		case 1:	/* AMPDU timw = 0x38 * 32us*/
+		case 1: /* AMPDU timw = 0x38 * 32us */
 			btcoexist->btc_write_1byte(btcoexist, 0x456, 0x38);
 			break;
 		default:
@@ -338,20 +292,20 @@ static void halbtc8821a1ant_ampdu_max_time(struct btc_coexist *btcoexist,
 	coex_dm->pre_ampdu_time_type = coex_dm->cur_ampdu_time_type;
 }
 
-static void halbtc8821a1ant_limited_tx(struct btc_coexist *btcoexist,
-				       bool force_exec, u8 ra_mask_type,
-				       u8 arfr_type, u8 retry_limit_type,
-				       u8 ampdu_time_type)
+static
+void halbtc8821a1ant_limited_tx(struct btc_coexist *btcoexist, bool force_exec,
+				u8 ra_mask_type, u8 arfr_type,
+				u8 retry_limit_type, u8 ampdu_time_type)
 {
 	switch (ra_mask_type) {
-	case 0:	/* normal mode*/
+	case 0: /* normal mode */
 		halbtc8821a1ant_update_ra_mask(btcoexist, force_exec, 0x0);
 		break;
-	case 1:	/* disable cck 1/2*/
+	case 1: /* disable cck 1/2 */
 		halbtc8821a1ant_update_ra_mask(btcoexist, force_exec,
 					       0x00000003);
 		break;
-	case 2:	/* disable cck 1/2/5.5, ofdm 6/9/12/18/24, mcs 0/1/2/3/4*/
+	case 2: /* disable cck 1/2/5.5, ofdm 6/9/12/18/24, mcs 0/1/2/3/4 */
 		halbtc8821a1ant_update_ra_mask(btcoexist, force_exec,
 					       0x0001f1f7);
 		break;
@@ -359,78 +313,112 @@ static void halbtc8821a1ant_limited_tx(struct btc_coexist *btcoexist,
 		break;
 	}
 
-	btc8821a1ant_auto_rate_fb_retry(btcoexist, force_exec, arfr_type);
+	halbtc8821a1ant_auto_rate_fallback_retry(btcoexist, force_exec,
+						 arfr_type);
 	halbtc8821a1ant_retry_limit(btcoexist, force_exec, retry_limit_type);
 	halbtc8821a1ant_ampdu_max_time(btcoexist, force_exec, ampdu_time_type);
 }
 
-static void halbtc8821a1ant_limited_rx(struct btc_coexist *btcoexist,
-				       bool force_exec, bool rej_ap_agg_pkt,
-				       bool bt_ctrl_agg_buf_size,
-				       u8 agg_buf_size)
+static
+void halbtc8821a1ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
+				bool rej_ap_agg_pkt, bool bt_ctrl_agg_buf_size,
+				u8 agg_buf_size)
 {
 	bool reject_rx_agg = rej_ap_agg_pkt;
 	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
 	u8 rx_agg_size = agg_buf_size;
 
-	/*============================================*/
-	/*	Rx Aggregation related setting*/
-	/*============================================*/
-	btcoexist->btc_set(btcoexist,
-		 BTC_SET_BL_TO_REJ_AP_AGG_PKT, &reject_rx_agg);
-	/* decide BT control aggregation buf size or not*/
+	/* ============================================ */
+	/*	Rx Aggregation related setting */
+	/* ============================================ */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_TO_REJ_AP_AGG_PKT,
+			   &reject_rx_agg);
+	/* decide BT control aggregation buf size or not */
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_CTRL_AGG_SIZE,
 			   &bt_ctrl_rx_agg_size);
-	/* aggregation buf size, only work when BT control Rx agg size.*/
+	/* aggregation buf size, only work when BT control Rx aggregation size.
+	 */
 	btcoexist->btc_set(btcoexist, BTC_SET_U1_AGG_BUF_SIZE, &rx_agg_size);
-	/* real update aggregation setting*/
+	/* real update aggregation setting */
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
 }
 
-static void halbtc8821a1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
-	u32	reg_hp_tx_rx, reg_lp_tx_rx, u4_tmp;
-	u32	reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
+	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
+	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 
-	reg_hp_tx_rx = 0x770;
-	reg_lp_tx_rx = 0x774;
+	reg_hp_txrx = 0x770;
+	reg_lp_txrx = 0x774;
 
-	u4_tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_tx_rx);
-	reg_hp_tx = u4_tmp & MASKLWORD;
-	reg_hp_rx = (u4_tmp & MASKHWORD)>>16;
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_txrx);
+	reg_hp_tx = u32tmp & MASKLWORD;
+	reg_hp_rx = (u32tmp & MASKHWORD) >> 16;
 
-	u4_tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_tx_rx);
-	reg_lp_tx = u4_tmp & MASKLWORD;
-	reg_lp_rx = (u4_tmp & MASKHWORD)>>16;
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_txrx);
+	reg_lp_tx = u32tmp & MASKLWORD;
+	reg_lp_rx = (u32tmp & MASKHWORD) >> 16;
 
 	coex_sta->high_priority_tx = reg_hp_tx;
 	coex_sta->high_priority_rx = reg_hp_rx;
 	coex_sta->low_priority_tx = reg_lp_tx;
 	coex_sta->low_priority_rx = reg_lp_rx;
 
-	/* reset counter*/
+	/* reset counter */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
-static void halbtc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
-	h2c_parameter[0] |= BIT0;	/* trigger*/
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
-		    h2c_parameter[0]);
+	h2c_parameter[0] |= BIT(0); /* trigger */
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
+static
+bool halbtc8821a1ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+{
+	static bool pre_wifi_busy = false, pre_under_4way = false,
+		    pre_bt_hs_on = false;
+	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
+	bool wifi_connected = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
+
+	if (wifi_connected) {
+		if (wifi_busy != pre_wifi_busy) {
+			pre_wifi_busy = wifi_busy;
+			return true;
+		}
+		if (under_4way != pre_under_4way) {
+			pre_under_4way = under_4way;
+			return true;
+		}
+		if (bt_hs_on != pre_bt_hs_on) {
+			pre_bt_hs_on = bt_hs_on;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static
+void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
-	struct btc_bt_link_info	*bt_link_info = &btcoexist->bt_link_info;
-	bool	bt_hs_on = false;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool bt_hs_on = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
@@ -440,61 +428,56 @@ static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 	bt_link_info->pan_exist = coex_sta->pan_exist;
 	bt_link_info->hid_exist = coex_sta->hid_exist;
 
-	/* work around for HS mode.*/
+	/* work around for HS mode. */
 	if (bt_hs_on) {
 		bt_link_info->pan_exist = true;
 		bt_link_info->bt_link_exist = true;
 	}
 
-	/* check if Sco only*/
-	if (bt_link_info->sco_exist &&
-	    !bt_link_info->a2dp_exist &&
-	    !bt_link_info->pan_exist &&
-	    !bt_link_info->hid_exist)
+	/* check if Sco only */
+	if (bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
 		bt_link_info->sco_only = true;
 	else
 		bt_link_info->sco_only = false;
 
-	/* check if A2dp only*/
-	if (!bt_link_info->sco_exist &&
-	    bt_link_info->a2dp_exist &&
-	    !bt_link_info->pan_exist &&
-	    !bt_link_info->hid_exist)
+	/* check if A2dp only */
+	if (!bt_link_info->sco_exist && bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
 		bt_link_info->a2dp_only = true;
 	else
 		bt_link_info->a2dp_only = false;
 
-	/* check if Pan only*/
-	if (!bt_link_info->sco_exist &&
-	    !bt_link_info->a2dp_exist &&
-	    bt_link_info->pan_exist &&
-	    !bt_link_info->hid_exist)
+	/* check if Pan only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    bt_link_info->pan_exist && !bt_link_info->hid_exist)
 		bt_link_info->pan_only = true;
 	else
 		bt_link_info->pan_only = false;
 
-	/* check if Hid only*/
-	if (!bt_link_info->sco_exist &&
-	    !bt_link_info->a2dp_exist &&
-	    !bt_link_info->pan_exist &&
-	    bt_link_info->hid_exist)
+	/* check if Hid only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && bt_link_info->hid_exist)
 		bt_link_info->hid_only = true;
 	else
 		bt_link_info->hid_only = false;
 }
 
-static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
+static
+u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool	bt_hs_on = false;
-	u8	algorithm = BT_8821A_1ANT_COEX_ALGO_UNDEFINED;
-	u8	num_of_diff_profile = 0;
+	bool bt_hs_on = false;
+	u8 algorithm = BT_8821A_1ANT_COEX_ALGO_UNDEFINED;
+	u8 num_of_diff_profile = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	if (!bt_link_info->bt_link_exist) {
-		btc_alg_dbg(ALGO_TRACE,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], No BT link exists!!!\n");
+		BTC_TRACE(trace_buf);
 		return algorithm;
 	}
 
@@ -509,78 +492,112 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 
 	if (num_of_diff_profile == 1) {
 		if (bt_link_info->sco_exist) {
-			btc_alg_dbg(ALGO_TRACE,
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 				    "[BTCoex], BT Profile = SCO only\n");
+			BTC_TRACE(trace_buf);
 			algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 		} else {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = HID only\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT Profile = HID only\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = A2DP only\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT Profile = A2DP only\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_1ANT_COEX_ALGO_A2DP;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = PAN(HS) only\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANHS;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = PAN(HS) only\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+						BT_8821A_1ANT_COEX_ALGO_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = PAN(EDR) only\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = PAN(EDR) only\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+						BT_8821A_1ANT_COEX_ALGO_PANEDR;
 				}
 			}
 		}
 	} else if (num_of_diff_profile == 2) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = SCO + HID\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT Profile = SCO + HID\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = SCO + A2DP ==> SCO\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT Profile = SCO + A2DP ==> SCO\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + PAN(HS)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = SCO + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + PAN(EDR)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = SCO + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			}
 		} else {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = HID + A2DP\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT Profile = HID + A2DP\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + PAN(HS)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = HID + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + PAN(EDR)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = HID + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = A2DP + PAN(EDR)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = A2DP + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP;
 				}
 			}
 		}
@@ -588,30 +605,43 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT Profile = SCO + HID + A2DP ==> HID\n");
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT Profile = SCO + HID + A2DP ==> HID\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->hid_exist &&
-				bt_link_info->pan_exist) {
+				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + HID + PAN(HS)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = SCO + HID + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + HID + PAN(EDR)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = SCO + HID + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
-				bt_link_info->a2dp_exist) {
+				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + A2DP + PAN(HS)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = SCO + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm = BT_8821A_1ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + A2DP + PAN(EDR) ==> HID\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = SCO + A2DP + PAN(EDR) ==> HID\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+						BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			}
 		} else {
@@ -619,13 +649,19 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = HID + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = HID + A2DP + PAN(EDR)\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = HID + A2DP + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				}
 			}
 		}
@@ -635,86 +671,49 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], Error!!! BT Profile = SCO + HID + A2DP + PAN(HS)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], Error!!! BT Profile = SCO + HID + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], BT Profile = SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
-					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT Profile = SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			}
 		}
 	}
-	return algorithm;
-}
-
-static void halbtc8821a1ant_set_bt_auto_report(struct btc_coexist *btcoexist,
-					       bool enable_auto_report)
-{
-	u8 h2c_parameter[1] = {0};
-
-	h2c_parameter[0] = 0;
-
-	if (enable_auto_report)
-		h2c_parameter[0] |= BIT0;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		    (enable_auto_report ? "Enabled!!" : "Disabled!!"),
-		    h2c_parameter[0]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
-}
-
-static void halbtc8821a1ant_bt_auto_report(struct btc_coexist *btcoexist,
-					   bool force_exec,
-					   bool enable_auto_report)
-{
-	btc_alg_dbg(ALGO_TRACE_FW, "[BTCoex], %s BT Auto report = %s\n",
-		    (force_exec ? "force to" : ""), ((enable_auto_report) ?
-						     "Enabled" : "Disabled"));
-	coex_dm->cur_bt_auto_report = enable_auto_report;
-
-	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_bt_auto_report = %d, cur_bt_auto_report = %d\n",
-			    coex_dm->pre_bt_auto_report,
-			    coex_dm->cur_bt_auto_report);
 
-		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
-			return;
-	}
-	halbtc8821a1ant_set_bt_auto_report(btcoexist, coex_dm->cur_bt_auto_report);
-
-	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
+	return algorithm;
 }
 
-static void btc8821a1ant_set_sw_pen_tx_rate(struct btc_coexist *btcoexist,
-					    bool low_penalty_ra)
+static
+void halbtc8821a1ant_set_sw_penalty_tx_rate_adaptive(
+	struct btc_coexist *btcoexist, bool low_penalty_ra)
 {
 	u8 h2c_parameter[6] = {0};
 
-	h2c_parameter[0] = 0x6;	/* opCode, 0x6= Retry_Penalty*/
+	h2c_parameter[0] = 0x6; /* op_code, 0x6= Retry_Penalty */
 
 	if (low_penalty_ra) {
-		h2c_parameter[1] |= BIT0;
-		/*normal rate except MCS7/6/5, OFDM54/48/36*/
-		h2c_parameter[2] = 0x00;
-		h2c_parameter[3] = 0xf7;  /*MCS7 or OFDM54*/
-		h2c_parameter[4] = 0xf8;  /*MCS6 or OFDM48*/
-		h2c_parameter[5] = 0xf9;	/*MCS5 or OFDM36*/
+		h2c_parameter[1] |= BIT(0);
+		h2c_parameter[2] =
+			0x00; /* normal rate except MCS7/6/5, OFDM54/48/36 */
+		h2c_parameter[3] = 0xf5; /* MCS7 or OFDM54 */
+		h2c_parameter[4] = 0xa0; /* MCS6 or OFDM48 */
+		h2c_parameter[5] = 0xa0; /* MCS5 or OFDM36	 */
 	}
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set WiFi Low-Penalty Retry: %s",
-		    (low_penalty_ra ? "ON!!" : "OFF!!"));
-
 	btcoexist->btc_fill_h2c(btcoexist, 0x69, 6, h2c_parameter);
 }
 
-static void halbtc8821a1ant_low_penalty_ra(struct btc_coexist *btcoexist,
-					   bool force_exec, bool low_penalty_ra)
+static
+void halbtc8821a1ant_low_penalty_ra(struct btc_coexist *btcoexist,
+				    bool force_exec, bool low_penalty_ra)
 {
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
@@ -722,201 +721,189 @@ static void halbtc8821a1ant_low_penalty_ra(struct btc_coexist *btcoexist,
 		if (coex_dm->pre_low_penalty_ra == coex_dm->cur_low_penalty_ra)
 			return;
 	}
-	btc8821a1ant_set_sw_pen_tx_rate(btcoexist, coex_dm->cur_low_penalty_ra);
+	halbtc8821a1ant_set_sw_penalty_tx_rate_adaptive(
+		btcoexist, coex_dm->cur_low_penalty_ra);
 
 	coex_dm->pre_low_penalty_ra = coex_dm->cur_low_penalty_ra;
 }
 
-static void halbtc8821a1ant_set_coex_table(struct btc_coexist *btcoexist,
-					   u32 val0x6c0, u32 val0x6c4,
-					   u32 val0x6c8, u8 val0x6cc)
+static
+void halbtc8821a1ant_set_coex_table(struct btc_coexist *btcoexist, u32 val0x6c0,
+				    u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
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
 
-static void halbtc8821a1ant_coex_table(struct btc_coexist *btcoexist,
-				       bool force_exec, u32 val0x6c0,
-				       u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
+static
+void halbtc8821a1ant_coex_table(struct btc_coexist *btcoexist, bool force_exec,
+				u32 val0x6c0, u32 val0x6c4, u32 val0x6c8,
+				u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, 0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
-		    (force_exec ? "force to" : ""), val0x6c0, val0x6c4,
-		    val0x6c8, val0x6cc);
-	coex_dm->cur_val_0x6c0 = val0x6c0;
-	coex_dm->cur_val_0x6c4 = val0x6c4;
-	coex_dm->cur_val_0x6c8 = val0x6c8;
-	coex_dm->cur_val_0x6cc = val0x6cc;
+	coex_dm->cur_val0x6c0 = val0x6c0;
+	coex_dm->cur_val0x6c4 = val0x6c4;
+	coex_dm->cur_val0x6c8 = val0x6c8;
+	coex_dm->cur_val0x6cc = val0x6cc;
 
 	if (!force_exec) {
-		if ((coex_dm->pre_val_0x6c0 == coex_dm->cur_val_0x6c0) &&
-		    (coex_dm->pre_val_0x6c4 == coex_dm->cur_val_0x6c4) &&
-		    (coex_dm->pre_val_0x6c8 == coex_dm->cur_val_0x6c8) &&
-		    (coex_dm->pre_val_0x6cc == coex_dm->cur_val_0x6cc))
+		if ((coex_dm->pre_val0x6c0 == coex_dm->cur_val0x6c0) &&
+		    (coex_dm->pre_val0x6c4 == coex_dm->cur_val0x6c4) &&
+		    (coex_dm->pre_val0x6c8 == coex_dm->cur_val0x6c8) &&
+		    (coex_dm->pre_val0x6cc == coex_dm->cur_val0x6cc))
 			return;
 	}
-	halbtc8821a1ant_set_coex_table(btcoexist, val0x6c0, val0x6c4,
-				       val0x6c8, val0x6cc);
+	halbtc8821a1ant_set_coex_table(btcoexist, val0x6c0, val0x6c4, val0x6c8,
+				       val0x6cc);
 
-	coex_dm->pre_val_0x6c0 = coex_dm->cur_val_0x6c0;
-	coex_dm->pre_val_0x6c4 = coex_dm->cur_val_0x6c4;
-	coex_dm->pre_val_0x6c8 = coex_dm->cur_val_0x6c8;
-	coex_dm->pre_val_0x6cc = coex_dm->cur_val_0x6cc;
+	coex_dm->pre_val0x6c0 = coex_dm->cur_val0x6c0;
+	coex_dm->pre_val0x6c4 = coex_dm->cur_val0x6c4;
+	coex_dm->pre_val0x6c8 = coex_dm->cur_val0x6c8;
+	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
 }
 
-static void halbtc8821a1ant_coex_table_with_type(struct btc_coexist *btcoexist,
-						 bool force_exec, u8 type)
+static
+void halbtc8821a1ant_coex_table_with_type(struct btc_coexist *btcoexist,
+					  bool force_exec, u8 type)
 {
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], ********** CoexTable(%d) **********\n", type);
+	BTC_TRACE(trace_buf);
+
 	switch (type) {
 	case 0:
 		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
 					   0x55555555, 0xffffff, 0x3);
 		break;
 	case 1:
-			halbtc8821a1ant_coex_table(btcoexist, force_exec,
-						   0x55555555, 0x5a5a5a5a,
-						   0xffffff, 0x3);
-			break;
+		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0x5a5a5a5a, 0xffffff, 0x3);
+		break;
 	case 2:
 		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
 					   0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 3:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
 					   0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	case 4:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0xffffffff,
-					   0xffffffff, 0xffffff, 0x3);
+		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 5:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
-					   0x5fff5fff, 0xffffff, 0x3);
+		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
+					   0xaaaa5a5a, 0xffffff, 0x3);
 		break;
 	case 6:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffffff, 0x3);
+		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0xaaaa5a5a, 0xffffff, 0x3);
 		break;
 	case 7:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5afa5afa,
-					   0x5afa5afa, 0xffffff, 0x3);
+		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0xaaaaaaaa,
+					   0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	default:
 		break;
 	}
 }
 
-static void btc8821a1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
-						bool enable)
+static
+void halbtc8821a1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
+					    bool enable)
 {
-	u8	h2c_parameter[1] = {0};
+	u8 h2c_parameter[1] = {0};
 
 	if (enable)
-		h2c_parameter[0] |= BIT0;	/* function enable*/
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
-		    h2c_parameter[0]);
+		h2c_parameter[0] |= BIT(0); /* function enable */
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
 
-static void halbtc8821a1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
-					    bool force_exec, bool enable)
+static
+void halbtc8821a1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
+				     bool force_exec, bool enable)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s turn Ignore WlanAct %s\n",
-		    (force_exec ? "force to" : ""), (enable ? "ON" : "OFF"));
 	coex_dm->cur_ignore_wlan_act = enable;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_ignore_wlan_act = %d, cur_ignore_wlan_act = %d!!\n",
-			    coex_dm->pre_ignore_wlan_act,
-			    coex_dm->cur_ignore_wlan_act);
-
 		if (coex_dm->pre_ignore_wlan_act ==
 		    coex_dm->cur_ignore_wlan_act)
 			return;
 	}
-	btc8821a1ant_set_fw_ignore_wlan_act(btcoexist, enable);
+	halbtc8821a1ant_set_fw_ignore_wlan_act(btcoexist, enable);
 
 	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
 }
 
-static void halbtc8821a1ant_set_fw_pstdma(struct btc_coexist *btcoexist,
-					  u8 byte1, u8 byte2, u8 byte3,
-					  u8 byte4, u8 byte5)
+static
+void halbtc8821a1ant_set_fw_pstdma(struct btc_coexist *btcoexist, u8 byte1,
+				   u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
 	u8 h2c_parameter[5] = {0};
+	u8 real_byte1 = byte1, real_byte5 = byte5;
+	bool ap_enable = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
+			   &ap_enable);
+
+	if (ap_enable) {
+		if (byte1 & BIT(4) && !(byte1 & BIT(5))) {
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], FW for 1Ant AP mode\n");
+			BTC_TRACE(trace_buf);
+			real_byte1 &= ~BIT(4);
+			real_byte1 |= BIT(5);
+
+			real_byte5 |= BIT(5);
+			real_byte5 &= ~BIT(6);
+		}
+	}
 
-	h2c_parameter[0] = byte1;
+	h2c_parameter[0] = real_byte1;
 	h2c_parameter[1] = byte2;
 	h2c_parameter[2] = byte3;
 	h2c_parameter[3] = byte4;
-	h2c_parameter[4] = byte5;
+	h2c_parameter[4] = real_byte5;
 
-	coex_dm->ps_tdma_para[0] = byte1;
+	coex_dm->ps_tdma_para[0] = real_byte1;
 	coex_dm->ps_tdma_para[1] = byte2;
 	coex_dm->ps_tdma_para[2] = byte3;
 	coex_dm->ps_tdma_para[3] = byte4;
-	coex_dm->ps_tdma_para[4] = byte5;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], PS-TDMA H2C cmd =0x%x%08x\n",
-		    h2c_parameter[0],
-		    h2c_parameter[1] << 24 |
-		    h2c_parameter[2] << 16 |
-		    h2c_parameter[3] << 8 |
-		    h2c_parameter[4]);
+	coex_dm->ps_tdma_para[4] = real_byte5;
+
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
-static void halbtc8821a1ant_set_lps_rpwm(struct btc_coexist *btcoexist,
-					 u8 lps_val, u8 rpwm_val)
+static
+void halbtc8821a1ant_set_lps_rpwm(struct btc_coexist *btcoexist, u8 lps_val,
+				  u8 rpwm_val)
 {
-	u8	lps = lps_val;
-	u8	rpwm = rpwm_val;
+	u8 lps = lps_val;
+	u8 rpwm = rpwm_val;
 
 	btcoexist->btc_set(btcoexist, BTC_SET_U1_LPS_VAL, &lps);
 	btcoexist->btc_set(btcoexist, BTC_SET_U1_RPWM_VAL, &rpwm);
 }
 
-static void halbtc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist,
-				     bool force_exec, u8 lps_val, u8 rpwm_val)
+static
+void halbtc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist, bool force_exec,
+			      u8 lps_val, u8 rpwm_val)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s set lps/rpwm = 0x%x/0x%x\n",
-		    (force_exec ? "force to" : ""), lps_val, rpwm_val);
 	coex_dm->cur_lps = lps_val;
 	coex_dm->cur_rpwm = rpwm_val;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], LPS-RxBeaconMode = 0x%x, LPS-RPWM = 0x%x!!\n",
-			    coex_dm->cur_lps, coex_dm->cur_rpwm);
-
 		if ((coex_dm->pre_lps == coex_dm->cur_lps) &&
-		    (coex_dm->pre_rpwm == coex_dm->cur_rpwm)) {
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], LPS-RPWM_Last = 0x%x, LPS-RPWM_Now = 0x%x!!\n",
-				    coex_dm->pre_rpwm, coex_dm->cur_rpwm);
-
+		    (coex_dm->pre_rpwm == coex_dm->cur_rpwm))
 			return;
-		}
 	}
 	halbtc8821a1ant_set_lps_rpwm(btcoexist, lps_val, rpwm_val);
 
@@ -924,69 +911,69 @@ static void halbtc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist,
 	coex_dm->pre_rpwm = coex_dm->cur_rpwm;
 }
 
-static void halbtc8821a1ant_sw_mechanism(struct btc_coexist *btcoexist,
-					 bool low_penalty_ra)
+static
+void halbtc8821a1ant_sw_mechanism(struct btc_coexist *btcoexist,
+				  bool low_penalty_ra)
 {
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex], SM[LpRA] = %d\n", low_penalty_ra);
-
 	halbtc8821a1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
 
-static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
-					 u8 ant_pos_type, bool init_hw_cfg,
-					 bool wifi_off)
+static
+void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
+				  u8 ant_pos_type, bool init_hwcfg,
+				  bool wifi_off)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
-	u32 u4_tmp = 0;
+	u32 u32tmp = 0;
 	u8 h2c_parameter[2] = {0};
 
-	if (init_hw_cfg) {
-		/* 0x4c[23] = 0, 0x4c[24] = 1  Antenna control by WL/BT*/
-		u4_tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
-		u4_tmp &= ~BIT23;
-		u4_tmp |= BIT24;
-		btcoexist->btc_write_4byte(btcoexist, 0x4c, u4_tmp);
+	if (init_hwcfg) {
+		/* 0x4c[23]=0, 0x4c[24]=1  Antenna control by WL/BT */
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+		u32tmp &= ~BIT(23);
+		u32tmp |= BIT(24);
+		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
 
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x975, 0x3, 0x3);
-		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
+		/* 0x765 = 0x18 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x3);
 
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
-			/*tell firmware "antenna inverse"  ==>
-			 * WRONG firmware antenna control code.==>need fw to fix
+			/* tell firmware "antenna inverse"  ==> WRONG firmware
+			 * antenna control code.==>need fw to fix
 			 */
 			h2c_parameter[0] = 1;
 			h2c_parameter[1] = 1;
 			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 						h2c_parameter);
-			/*Main Ant to  BT for IPS case 0x4c[23] = 1*/
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64,
-							   0x1, 0x1);
 		} else {
-			/*tell firmware "no antenna inverse" ==>
-			 * WRONG firmware antenna control code.==>need fw to fix
+			/* tell firmware "no antenna inverse" ==> WRONG firmware
+			 * antenna control code.==>need fw to fix
 			 */
 			h2c_parameter[0] = 0;
 			h2c_parameter[1] = 1;
 			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 						h2c_parameter);
-			/*Aux Ant to  BT for IPS case 0x4c[23] = 1*/
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64,
-							   0x1, 0x0);
 		}
 	} else if (wifi_off) {
-		/* 0x4c[24:23] = 00, Set Antenna control
-		 *	by BT_RFE_CTRL	BT Vendor 0xac = 0xf002
+		/* 0x4c[24:23]=00, Set Antenna control by BT_RFE_CTRL	BT
+		 * Vendor 0xac=0xf002
 		 */
-		u4_tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
-		u4_tmp &= ~BIT23;
-		u4_tmp &= ~BIT24;
-		btcoexist->btc_write_4byte(btcoexist, 0x4c, u4_tmp);
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+		u32tmp &= ~BIT(23);
+		u32tmp &= ~BIT(24);
+		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+
+		/* 0x765 = 0x18 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x3);
+	} else {
+		/* 0x765 = 0x0 */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x0);
 	}
 
-	/* ext switch setting*/
+	/* ext switch setting */
 	switch (ant_pos_type) {
 	case BTC_ANT_PATH_WIFI:
+		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb7,
 							   0x30, 0x1);
@@ -995,6 +982,7 @@ static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 							   0x30, 0x2);
 		break;
 	case BTC_ANT_PATH_BT:
+		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb7,
 							   0x30, 0x2);
@@ -1004,6 +992,7 @@ static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 		break;
 	default:
 	case BTC_ANT_PATH_PTA:
+		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x66);
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0xcb7,
 							   0x30, 0x1);
@@ -1014,24 +1003,29 @@ static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
-				    bool force_exec, bool turn_on, u8 type)
+static
+void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
+			     bool turn_on, u8 type)
 {
 	u8 rssi_adjust_val = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	coex_dm->cur_ps_tdma_on = turn_on;
 	coex_dm->cur_ps_tdma = type;
 
+	if (coex_dm->cur_ps_tdma_on) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], ********** TDMA(on, %d) **********\n",
+			    coex_dm->cur_ps_tdma);
+		BTC_TRACE(trace_buf);
+	} else {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], ********** TDMA(off, %d) **********\n",
+			    coex_dm->cur_ps_tdma);
+		BTC_TRACE(trace_buf);
+	}
+
 	if (!force_exec) {
-		if (coex_dm->cur_ps_tdma_on) {
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], ********** TDMA(on, %d) **********\n",
-				    coex_dm->cur_ps_tdma);
-		} else {
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], ********** TDMA(off, %d) **********\n",
-				    coex_dm->cur_ps_tdma);
-		}
 		if ((coex_dm->pre_ps_tdma_on == coex_dm->cur_ps_tdma_on) &&
 		    (coex_dm->pre_ps_tdma == coex_dm->cur_ps_tdma))
 			return;
@@ -1054,7 +1048,7 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 			break;
 		case 3:
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x1d,
-						      0x1d, 0x0, 0x10);
+						      0x1d, 0x0, 0x52);
 			break;
 		case 4:
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x93, 0x15,
@@ -1066,12 +1060,12 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						      0x3, 0x11, 0x10);
 			break;
 		case 6:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa,
-						      0x3, 0x0, 0x0);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x20,
+						      0x3, 0x11, 0x13);
 			break;
 		case 7:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xc,
-						      0x5, 0x0, 0x0);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xc, 0x5,
+						      0x0, 0x0);
 			break;
 		case 8:
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x93, 0x25,
@@ -1083,12 +1077,12 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 			rssi_adjust_val = 18;
 			break;
 		case 10:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa,
-						      0xa, 0x0, 0x40);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa, 0xa,
+						      0x0, 0x40);
 			break;
 		case 11:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x14,
-						      0x03, 0x10, 0x10);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x15,
+						      0x03, 0x10, 0x50);
 			rssi_adjust_val = 20;
 			break;
 		case 12:
@@ -1096,16 +1090,16 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						      0x0a, 0x0, 0x50);
 			break;
 		case 13:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x18,
-						      0x18, 0x0, 0x10);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x12,
+						      0x12, 0x0, 0x50);
 			break;
 		case 14:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x21,
-						      0x3, 0x10, 0x10);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x1e,
+						      0x3, 0x10, 0x14);
 			break;
 		case 15:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa,
-						      0x3, 0x8, 0x0);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa, 0x3,
+						      0x8, 0x0);
 			break;
 		case 16:
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x93, 0x15,
@@ -1122,8 +1116,8 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						      0x03, 0x11, 0x10);
 			break;
 		case 21:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x15,
-						      0x03, 0x11, 0x10);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x25,
+						      0x03, 0x11, 0x11);
 			break;
 		case 22:
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x25,
@@ -1140,13 +1134,13 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 			rssi_adjust_val = 22;
 			break;
 		case 25:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0x3, 0x31, 0x18);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0xa, 0x3,
+						      0x31, 0x18);
 			rssi_adjust_val = 22;
 			break;
 		case 26:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0x3, 0x31, 0x18);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0xa, 0x3,
+						      0x31, 0x18);
 			rssi_adjust_val = 22;
 			break;
 		case 27:
@@ -1163,16 +1157,16 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 						      0x1a, 0x1, 0x10);
 			break;
 		case 30:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x14,
-						      0x3, 0x10, 0x50);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x30,
+						      0x3, 0x10, 0x10);
 			break;
 		case 31:
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xd3, 0x1a,
 						      0x1a, 0, 0x58);
 			break;
 		case 32:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0xa,
-						      0x3, 0x10, 0x0);
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x35,
+						      0x3, 0x11, 0x11);
 			break;
 		case 33:
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xa3, 0x25,
@@ -1190,30 +1184,52 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xd3, 0x12,
 						      0x3, 0x14, 0x50);
 			break;
+		case 40:
+			/* SoftAP only with no sta associated,BT disable ,TDMA
+			 * mode for power saving
+			 */
+			/* here softap mode screen off will cost 70-80mA for
+			 * phone
+			 */
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x23, 0x18,
+						      0x00, 0x10, 0x24);
+			break;
+		case 41:
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x15,
+						      0x3, 0x11, 0x11);
+			break;
+		case 42:
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x20,
+						      0x3, 0x11, 0x11);
+			break;
+		case 43:
+			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x30,
+						      0x3, 0x10, 0x11);
+			break;
 		}
 	} else {
-		/* disable PS tdma*/
+		/* disable PS tdma */
 		switch (type) {
-		case 8: /*PTA Control*/
+		case 8: /* PTA Control */
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x8, 0x0, 0x0,
 						      0x0, 0x0);
-			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
-						     false, false);
+			halbtc8821a1ant_set_ant_path(
+				btcoexist, BTC_ANT_PATH_PTA, false, false);
 			break;
 		case 0:
-		default:  /*Software control, Antenna at BT side*/
+		default: /* Software control, Antenna at BT side */
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
 						      0x0, 0x0);
 			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
 						     false, false);
 			break;
-		case 9:   /*Software control, Antenna at WiFi side*/
+		case 9: /* Software control, Antenna at WiFi side */
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
 						      0x0, 0x0);
-			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_WIFI,
-						     false, false);
+			halbtc8821a1ant_set_ant_path(
+				btcoexist, BTC_ANT_PATH_WIFI, false, false);
 			break;
-		case 10:	/* under 5G*/
+		case 10: /* under 5G */
 			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
 						      0x8, 0x0);
 			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
@@ -1223,68 +1239,79 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 	}
 	rssi_adjust_val = 0;
 	btcoexist->btc_set(btcoexist,
-		 BTC_SET_U1_RSSI_ADJ_VAL_FOR_1ANT_COEX_TYPE, &rssi_adjust_val);
+			   BTC_SET_U1_RSSI_ADJ_VAL_FOR_1ANT_COEX_TYPE,
+			   &rssi_adjust_val);
 
-	/* update pre state*/
+	/* update pre state */
 	coex_dm->pre_ps_tdma_on = coex_dm->cur_ps_tdma_on;
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
+static
+bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 {
-	bool	common = false, wifi_connected = false, wifi_busy = false;
+	bool common = false, wifi_connected = false, wifi_busy = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 
 	if (!wifi_connected &&
-	    BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
-	    coex_dm->bt_status) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi non connected-idle + BT non connected-idle!!\n");
+	    coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], Wifi non connected-idle + BT non connected-idle!!\n");
+		BTC_TRACE(trace_buf);
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (wifi_connected &&
 		   (BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
 		    coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi connected + BT non connected-idle!!\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], Wifi connected + BT non connected-idle!!\n");
+		BTC_TRACE(trace_buf);
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
-	} else if (!wifi_connected &&
-		   (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
-		    coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi non connected-idle + BT connected-idle!!\n");
+	} else if (!wifi_connected && (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
+				       coex_dm->bt_status)) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], Wifi non connected-idle + BT connected-idle!!\n");
+		BTC_TRACE(trace_buf);
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
-	} else if (wifi_connected &&
-		   (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
-		   coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
+	} else if (wifi_connected && (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
+				      coex_dm->bt_status)) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], Wifi connected + BT connected-idle!!\n");
+		BTC_TRACE(trace_buf);
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
-	} else if (!wifi_connected &&
-		   (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE !=
-		    coex_dm->bt_status)) {
-		btc_alg_dbg(ALGO_TRACE,
+	} else if (!wifi_connected && (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE !=
+				       coex_dm->bt_status)) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], Wifi non connected-idle + BT Busy!!\n");
+		BTC_TRACE(trace_buf);
 		halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else {
 		if (wifi_busy) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+			BTC_TRACE(trace_buf);
 		} else {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+			BTC_TRACE(trace_buf);
 		}
 
 		common = false;
@@ -1293,249 +1320,62 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 	return common;
 }
 
-static void btc8821a1ant_tdma_dur_adj(struct btc_coexist *btcoexist,
-				      u8 wifi_status)
-{
-	static long		up, dn, m, n, wait_count;
-	/*0: no change, +1: increase WiFi duration, -1: decrease WiFi duration*/
-	long			result;
-	u8			retry_count = 0, bt_info_ext;
-
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], TdmaDurationAdjustForAcl()\n");
-
-	if ((BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
-	     wifi_status) ||
-	    (BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN ==
-	     wifi_status) ||
-	    (BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SPECIAL_PKT ==
-	     wifi_status)) {
-		if (coex_dm->cur_ps_tdma != 1 &&
-		    coex_dm->cur_ps_tdma != 2 &&
-		    coex_dm->cur_ps_tdma != 3 &&
-		    coex_dm->cur_ps_tdma != 9) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-			coex_dm->tdma_adj_type = 9;
-
-			up = 0;
-			dn = 0;
-			m = 1;
-			n = 3;
-			result = 0;
-			wait_count = 0;
-		}
-		return;
-	}
-
-	if (!coex_dm->auto_tdma_adjust) {
-		coex_dm->auto_tdma_adjust = true;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], first run TdmaDurationAdjust()!!\n");
-
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
-		coex_dm->tdma_adj_type = 2;
-		/*============*/
-		up = 0;
-		dn = 0;
-		m = 1;
-		n = 3;
-		result = 0;
-		wait_count = 0;
-	} else {
-		/*accquire the BT TRx retry count from BT_Info byte2*/
-		retry_count = coex_sta->bt_retry_cnt;
-		bt_info_ext = coex_sta->bt_info_ext;
-		result = 0;
-		wait_count++;
-
-		if (retry_count == 0) {
-			/* no retry in the last 2-second duration*/
-			up++;
-			dn--;
-
-			if (dn <= 0)
-				dn = 0;
-
-			if (up >= n) {
-				/* if (retry count == 0) for 2*n seconds ,
-				 * make WiFi duration wider
-				 */
-				wait_count = 0;
-				n = 3;
-				up = 0;
-				dn = 0;
-				result = 1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex], Increase wifi duration!!\n");
-			}
-		} else if (retry_count <= 3) {
-			/* <=3 retry in the last 2-second duration*/
-			up--;
-			dn++;
-
-			if (up <= 0)
-				up = 0;
-
-			if (dn == 2) {
-				/* if retry count< 3 for 2*2 seconds,
-				 * shrink wifi duration
-				 */
-				if (wait_count <= 2)
-					m++; /* avoid bounce in two levels */
-				else
-					m = 1;
-
-				if (m >= 20) {
-					/* m max value is 20, max time is 120 s,
-					 *	recheck if adjust WiFi duration.
-					 */
-					m = 20;
-				}
-				n = 3*m;
-				up = 0;
-				dn = 0;
-				wait_count = 0;
-				result = -1;
-				btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-					    "[BTCoex], Decrease wifi duration for retryCounter<3!!\n");
-			}
-		} else {
-			/* retry count > 3, if retry count > 3 happens once,
-			 *	shrink WiFi duration
-			 */
-			if (wait_count == 1)
-				m++; /* avoid bounce in two levels */
-			else
-				m = 1;
-		/* m max value is 20, max time is 120 second,
-		 *	recheck if adjust WiFi duration.
-		*/
-			if (m >= 20)
-				m = 20;
-
-			n = 3*m;
-			up = 0;
-			dn = 0;
-			wait_count = 0;
-			result = -1;
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], Decrease wifi duration for retryCounter>3!!\n");
-		}
-
-		if (result == -1) {
-			if ((BT_INFO_8821A_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			}
-		} else if (result == 1) {
-			if ((BT_INFO_8821A_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			}
-		} else {
-			/*no change*/
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], ********** TDMA(on, %d) **********\n",
-				    coex_dm->cur_ps_tdma);
-		}
-
-		if (coex_dm->cur_ps_tdma != 1 &&
-		    coex_dm->cur_ps_tdma != 2 &&
-		    coex_dm->cur_ps_tdma != 9 &&
-		    coex_dm->cur_ps_tdma != 11) {
-			/* recover to previous adjust type*/
-			halbtc8821a1ant_ps_tdma(btcoexist,
-						NORMAL_EXEC, true,
-						coex_dm->tdma_adj_type);
-		}
-	}
-}
-
-static void btc8821a1ant_ps_tdma_check_for_pwr_save(struct btc_coexist *btcoex,
-						    bool new_ps_state)
+static
+void halbtc8821a1ant_ps_tdma_check_for_power_save_state(
+	struct btc_coexist *btcoexist, bool new_ps_state)
 {
-	u8	lps_mode = 0x0;
+	u8 lps_mode = 0x0;
 
-	btcoex->btc_get(btcoex, BTC_GET_U1_LPS_MODE, &lps_mode);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_LPS_MODE, &lps_mode);
 
-	if (lps_mode) {
-		/* already under LPS state*/
+	if (lps_mode) { /* already under LPS state */
 		if (new_ps_state) {
-			/* keep state under LPS, do nothing.*/
+			/* keep state under LPS, do nothing. */
 		} else {
-			/* will leave LPS state, turn off psTdma first*/
-			halbtc8821a1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 0);
+			/* will leave LPS state, turn off psTdma first */
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						1);
 		}
-	} else {
-		/* NO PS state*/
+	} else { /* NO PS state */
 		if (new_ps_state) {
-			/* will enter LPS state, turn off psTdma first*/
-			halbtc8821a1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 0);
+			/* will enter LPS state, turn off psTdma first */
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						0);
 		} else {
-			/* keep state under NO PS state, do nothing.*/
+			/* keep state under NO PS state, do nothing. */
 		}
 	}
 }
 
-static void halbtc8821a1ant_power_save_state(struct btc_coexist *btcoexist,
-					     u8 ps_type, u8 lps_val,
-					     u8 rpwm_val)
+static
+void halbtc8821a1ant_power_save_state(struct btc_coexist *btcoexist, u8 ps_type,
+				      u8 lps_val, u8 rpwm_val)
 {
 	bool low_pwr_disable = false;
 
 	switch (ps_type) {
 	case BTC_PS_WIFI_NATIVE:
-		/* recover to original 32k low power setting*/
+		/* recover to original 32k low power setting */
 		low_pwr_disable = false;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS, NULL);
 		break;
 	case BTC_PS_LPS_ON:
-		btc8821a1ant_ps_tdma_check_for_pwr_save(btcoexist,
-							true);
-		halbtc8821a1ant_lps_rpwm(btcoexist,
-					 NORMAL_EXEC, lps_val, rpwm_val);
-		/* when coex force to enter LPS, do not enter 32k low power.*/
+		halbtc8821a1ant_ps_tdma_check_for_power_save_state(btcoexist,
+								   true);
+		halbtc8821a1ant_lps_rpwm(btcoexist, NORMAL_EXEC, lps_val,
+					 rpwm_val);
+		/* when coex force to enter LPS, do not enter 32k low power. */
 		low_pwr_disable = true;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
-		/* power save must executed before psTdma.*/
+		/* power save must executed before psTdma. */
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ENTER_LPS, NULL);
 		break;
 	case BTC_PS_LPS_OFF:
-		btc8821a1ant_ps_tdma_check_for_pwr_save(btcoexist, false);
+		halbtc8821a1ant_ps_tdma_check_for_power_save_state(btcoexist,
+								   false);
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS, NULL);
 		break;
 	default:
@@ -1543,10 +1383,12 @@ static void halbtc8821a1ant_power_save_state(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8821a1ant_coex_under_5g(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_coex_under_5g(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
-					 0x0, 0x0);
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+
 	halbtc8821a1ant_ignore_wlan_act(btcoexist, NORMAL_EXEC, true);
 
 	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 10);
@@ -1558,235 +1400,252 @@ static void halbtc8821a1ant_coex_under_5g(struct btc_coexist *btcoexist)
 	halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 5);
 }
 
-static void halbtc8821a1ant_action_wifi_only(struct btc_coexist *btcoexist)
-{
-	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 9);
-}
+/* *********************************************
+ *
+ *	Software Coex Mechanism start
+ *
+ * *********************************************
+ */
 
-static void btc8821a1ant_mon_bt_en_dis(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_bt_whck_test(struct btc_coexist *btcoexist)
 {
-	static bool	pre_bt_disabled;
-	static u32	bt_disable_cnt;
-	bool		bt_active = true, bt_disabled = false;
-
-	/* This function check if bt is disabled*/
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 
-	if (coex_sta->high_priority_tx == 0 &&
-	    coex_sta->high_priority_rx == 0 &&
-	    coex_sta->low_priority_tx == 0 &&
-	    coex_sta->low_priority_rx == 0) {
-		bt_active = false;
-	}
-	if (coex_sta->high_priority_tx == 0xffff &&
-	    coex_sta->high_priority_rx == 0xffff &&
-	    coex_sta->low_priority_tx == 0xffff &&
-	    coex_sta->low_priority_rx == 0xffff) {
-		bt_active = false;
-	}
-	if (bt_active) {
-		bt_disable_cnt = 0;
-		bt_disabled = false;
-		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
-				   &bt_disabled);
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], BT is enabled !!\n");
-	} else {
-		bt_disable_cnt++;
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], bt all counters = 0, %d times!!\n",
-			    bt_disable_cnt);
-		if (bt_disable_cnt >= 2) {
-			bt_disabled = true;
-			btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
-					   &bt_disabled);
-			btc_alg_dbg(ALGO_BT_MONITOR,
-				    "[BTCoex], BT is disabled !!\n");
-			halbtc8821a1ant_action_wifi_only(btcoexist);
-		}
-	}
-	if (pre_bt_disabled != bt_disabled) {
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], BT is from %s to %s!!\n",
-			    (pre_bt_disabled ? "disabled" : "enabled"),
-			    (bt_disabled ? "disabled" : "enabled"));
-		pre_bt_disabled = bt_disabled;
-		if (bt_disabled) {
-			btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS,
-					   NULL);
-			btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS,
-					   NULL);
-		}
-	}
+	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, false, false);
+	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
-/*=============================================*/
-/**/
-/*	Software Coex Mechanism start*/
-/**/
-/*=============================================*/
-
-/* SCO only or SCO+PAN(HS)*/
-static void halbtc8821a1ant_action_sco(struct btc_coexist *btcoexist)
+/* SCO only or SCO+PAN(HS) */
+static
+void halbtc8821a1ant_action_sco(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-static void halbtc8821a1ant_action_hid(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_hid(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-/*A2DP only / PAN(EDR) only/ A2DP+PAN(HS)*/
-static void halbtc8821a1ant_action_a2dp(struct btc_coexist *btcoexist)
+/* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
+static
+void halbtc8821a1ant_action_a2dp(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-static void halbtc8821a1ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-static void halbtc8821a1ant_action_pan_edr(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-/*PAN(HS) only*/
-static void halbtc8821a1ant_action_pan_hs(struct btc_coexist *btcoexist)
+/* PAN(HS) only */
+static
+void halbtc8821a1ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-/*PAN(EDR)+A2DP*/
-static void halbtc8821a1ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
+/* PAN(EDR)+A2DP */
+static
+void halbtc8821a1ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-static void halbtc8821a1ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-/* HID+A2DP+PAN(EDR)*/
-static void btc8821a1ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
+/* HID+A2DP+PAN(EDR) */
+static
+void halbtc8821a1ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-static void halbtc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-/*=============================================*/
-/**/
-/*	Non-Software Coex Mechanism start*/
-/**/
-/*=============================================*/
+/* *********************************************
+ *
+ *	Non-Software Coex Mechanism start
+ *
+ * *********************************************
+ */
+static
+void halbtc8821a1ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
+{
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+
+	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+}
 
-static void halbtc8821a1ant_action_hs(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_hs(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-	halbtc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 2);
+	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 }
 
-static void halbtc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool wifi_connected = false;
+	bool wifi_connected = false, ap_enable = false, wifi_busy = false,
+	     bt_busy = false;
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
+			   &ap_enable);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
 
-	if (!wifi_connected) {
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	} else if ((bt_link_info->sco_exist) ||
-		   (bt_link_info->hid_only)) {
-		/* SCO/HID-only busy*/
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	if ((!wifi_connected) && (!coex_sta->wifi_is_high_pri_task)) {
+		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+	}
+
+	/* sy modify	 */
+	else if ((bt_link_info->sco_exist) || (bt_link_info->hid_exist) ||
+		 (bt_link_info->a2dp_exist)) {
+		/* SCO/HID/A2DP  busy */
+		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	}
+
+	/* sy modify */
+
+	else if ((bt_link_info->a2dp_exist) && (bt_link_info->hid_exist)) {
+		/* A2DP+HID	busy */
+		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+
 		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	}
+
+	else if ((bt_link_info->pan_exist) || (wifi_busy)) {
+		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
 	} else {
-		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_LPS_ON,
-						 0x50, 0x4);
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 30);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 	}
 }
 
-static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
-						  u8 wifi_status) {
-	/* tdma and coex table*/
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
+static
+void halbtc8821a1ant_action_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
+						 u8 wifi_status)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool wifi_connected = false;
 
-	if (BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
-	    wifi_status)
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	else
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+
+	/* tdma and coex table */
+
+	if (bt_link_info->sco_exist) {
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 41);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	} else { /* HID */
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 42);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	}
 }
 
-static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
-						  u8 wifi_status)
+static
+void halbtc8821a1ant_action_wifi_connected_bt_acl_busy(
+	struct btc_coexist *btcoexist, u8 wifi_status)
 {
-	u8		bt_rssi_state;
+	u8 bt_rssi_state;
 
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	bt_rssi_state = halbtc8821a1ant_bt_rssi_state(2, 28, 0);
 
-	if (bt_link_info->hid_only) {
-		/*HID*/
-		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
-						      wifi_status);
+	if (bt_link_info->hid_only) { /* HID */
+		halbtc8821a1ant_action_bt_sco_hid_only_busy(btcoexist,
+							    wifi_status);
 		coex_dm->auto_tdma_adjust = false;
 		return;
-	} else if (bt_link_info->a2dp_only) {
-		/*A2DP*/
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a1ant_tdma_dur_adj(btcoexist, wifi_status);
-		} else {
-			/*for low BT RSSI*/
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
+	} else if (bt_link_info->a2dp_only) { /* A2DP		 */
+		if (wifi_status == BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE) {
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						32);
+			halbtc8821a1ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 1);
+			coex_dm->auto_tdma_adjust = false;
+		} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+			   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						14);
+			halbtc8821a1ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 1);
+		} else { /* for low BT RSSI */
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						14);
+			halbtc8821a1ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 1);
 			coex_dm->auto_tdma_adjust = false;
 		}
-
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if (bt_link_info->hid_exist && bt_link_info->a2dp_exist) {
-		/*HID+A2DP*/
+		/* HID+A2DP */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						14);
 			coex_dm->auto_tdma_adjust = false;
-		} else {
-			/*for low BT RSSI*/
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
+		} else { /* for low BT RSSI */
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						14);
 			coex_dm->auto_tdma_adjust = false;
 		}
 
 		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if ((bt_link_info->pan_only) ||
-		(bt_link_info->hid_exist && bt_link_info->pan_exist)) {
-		/*PAN(OPP, FTP), HID+PAN(OPP, FTP)*/
+		   (bt_link_info->hid_exist && bt_link_info->pan_exist)) {
+		/* PAN(OPP,FTP), HID+PAN(OPP,FTP) */
 		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 6);
 		coex_dm->auto_tdma_adjust = false;
 	} else if (((bt_link_info->a2dp_exist) && (bt_link_info->pan_exist)) ||
 		   (bt_link_info->hid_exist && bt_link_info->a2dp_exist &&
 		    bt_link_info->pan_exist)) {
-		/*A2DP+PAN(OPP, FTP), HID+A2DP+PAN(OPP, FTP)*/
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
+		/* A2DP+PAN(OPP,FTP), HID+A2DP+PAN(OPP,FTP) */
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 43);
 		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 		coex_dm->auto_tdma_adjust = false;
 	} else {
@@ -1796,102 +1655,184 @@ static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8821a1ant_action_wifi_not_connected(
-	struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_wifi_not_connected(struct btc_coexist *btcoexist)
 {
-	/* power save state*/
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	/* power save state */
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 
-	/* tdma and coex table*/
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	/* tdma and coex table	 */
+	halbtc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
 	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
-static void btc8821a1ant_act_wifi_not_conn_scan(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_wifi_not_connected_scan(
+	struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
-	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-}
-
-static void halbtc8821a1ant_action_wifi_connected_scan(
-	struct btc_coexist *btcoexist) {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
-	/* power save state*/
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 
-	/* tdma and coex table*/
-	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
-		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 22);
+	/* tdma and coex table */
+	if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
+		if (bt_link_info->a2dp_exist) {
+			/* sy modify */
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						14);
 			halbtc8821a1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 1);
+		} else if (bt_link_info->a2dp_exist &&
+			   bt_link_info->pan_exist) {
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						22);
+			halbtc8821a1ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 4);
 		} else {
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
-	}
-	} else if ((BT_8821A_1ANT_BT_STATUS_SCO_BUSY ==
-		    coex_dm->bt_status) ||
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						20);
+			halbtc8821a1ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 4);
+		}
+	} else if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
 		   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
 		    coex_dm->bt_status)) {
-		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
-			BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
+		halbtc8821a1ant_action_bt_sco_hid_only_busy(
+			btcoexist, BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		/* halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20); */
+		/* halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+		 * 1);
+		 */
+
+		/* Bryant Add */
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	}
 }
 
-static void btc8821a1ant_act_wifi_conn_sp_pkt(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_wifi_not_connected_asso_auth(
+	struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool	hs_connecting = false;
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_CONNECTING, &hs_connecting);
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 
-	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
-					 0x0, 0x0);
+	/* tdma and coex table */
+	if ((bt_link_info->sco_exist) || (bt_link_info->hid_exist)) {
+		/* sy modify */
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	} else if ((bt_link_info->a2dp_exist) || (bt_link_info->pan_exist)) {
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	} else {
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	}
+}
+
+static
+void halbtc8821a1ant_action_wifi_connected_scan(struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 
-	/* tdma and coex table*/
-	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
-		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 22);
+	/* tdma and coex table */
+	if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
+		if (bt_link_info->a2dp_exist) {
+			/* sy modify */
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						14);
 			halbtc8821a1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 1);
+		} else if (bt_link_info->a2dp_exist &&
+			   bt_link_info->pan_exist) {
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						22);
+			halbtc8821a1ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 4);
 		} else {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 20);
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+						20);
 			halbtc8821a1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 1);
+							     NORMAL_EXEC, 4);
 		}
+	} else if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
+		   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
+		    coex_dm->bt_status)) {
+		halbtc8821a1ant_action_bt_sco_hid_only_busy(
+			btcoexist, BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		/* halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20); */
+		/* halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+		 * 1);
+		 */
+
+		/* Bryant Add */
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	}
+}
+
+static
+void halbtc8821a1ant_action_wifi_connected_specific_packet(
+	struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+
+	/* tdma and coex table */
+	/* sy modify */
+	if ((bt_link_info->sco_exist) || (bt_link_info->hid_exist) ||
+	    (bt_link_info->a2dp_exist)) {
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	}
+
+	if ((bt_link_info->hid_exist) && (bt_link_info->a2dp_exist)) {
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
 		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	}
+
+	else if (bt_link_info->pan_exist) {
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
+	} else {
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	}
 }
 
-static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 {
-	bool	wifi_busy = false;
-	bool	scan = false, link = false, roam = false;
-	bool	under_4way = false;
+	bool wifi_busy = false;
+	bool scan = false, link = false, roam = false;
+	bool under_4way = false, ap_enable = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_alg_dbg(ALGO_TRACE,
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 		    "[BTCoex], CoexForWifiConnect()===>\n");
+	BTC_TRACE(trace_buf);
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_4_WAY_PROGRESS, &under_4way);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
 	if (under_4way) {
-		btc8821a1ant_act_wifi_conn_sp_pkt(btcoexist);
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], CoexForWifiConnect(), return for wifi is under 4way<===\n");
+		halbtc8821a1ant_action_wifi_connected_specific_packet(
+			btcoexist);
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], CoexForWifiConnect(), return for wifi is under 4way<===\n");
+		BTC_TRACE(trace_buf);
 		return;
 	}
 
@@ -1899,199 +1840,259 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 	if (scan || link || roam) {
-		halbtc8821a1ant_action_wifi_connected_scan(btcoexist);
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], CoexForWifiConnect(), return for wifi is under scan<===\n");
+		if (scan)
+			halbtc8821a1ant_action_wifi_connected_scan(btcoexist);
+		else
+			halbtc8821a1ant_action_wifi_connected_specific_packet(
+				btcoexist);
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], CoexForWifiConnect(), return for wifi is under scan<===\n");
+		BTC_TRACE(trace_buf);
 		return;
 	}
 
-	/* power save state*/
-	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY ==
-			coex_dm->bt_status && !btcoexist->bt_link_info.hid_only)
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_LPS_ON, 0x50, 0x4);
-	else
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_WIFI_NATIVE,
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_AP_MODE_ENABLE,
+			   &ap_enable);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	/* power save state */
+	if (!ap_enable &&
+	    coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY &&
+	    !btcoexist->bt_link_info.hid_only) {
+		if (!wifi_busy && btcoexist->bt_link_info.a2dp_only) /* A2DP */
+			halbtc8821a1ant_power_save_state(
+				btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+		else
+			halbtc8821a1ant_power_save_state(
+				btcoexist, BTC_PS_LPS_ON, 0x50, 0x4);
+	} else
+		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 						 0x0, 0x0);
 
-	/* tdma and coex table*/
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	/* tdma and coex table */
 	if (!wifi_busy) {
-		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
-			btc8821a1ant_act_wifi_con_bt_acl_busy(btcoexist,
+		if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
+			halbtc8821a1ant_action_wifi_connected_bt_acl_busy(
+				btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE);
 		} else if ((BT_8821A_1ANT_BT_STATUS_SCO_BUSY ==
 			    coex_dm->bt_status) ||
 			   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
 			    coex_dm->bt_status)) {
-			btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
+			halbtc8821a1ant_action_bt_sco_hid_only_busy(
+				btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE);
 		} else {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						8);
 			halbtc8821a1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 2);
 		}
 	} else {
-		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
-			btc8821a1ant_act_wifi_con_bt_acl_busy(btcoexist,
+		if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
+			halbtc8821a1ant_action_wifi_connected_bt_acl_busy(
+				btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_BUSY);
 		} else if ((BT_8821A_1ANT_BT_STATUS_SCO_BUSY ==
 			    coex_dm->bt_status) ||
 			   (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY ==
 			    coex_dm->bt_status)) {
-			btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
+			halbtc8821a1ant_action_bt_sco_hid_only_busy(
+				btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_BUSY);
 		} else {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
+			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						8);
 			halbtc8821a1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 2);
 		}
 	}
 }
 
-static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_run_sw_coexist_mechanism(struct btc_coexist *btcoexist)
 {
-	u8	algorithm = 0;
+	u8 algorithm = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	algorithm = halbtc8821a1ant_action_algorithm(btcoexist);
 	coex_dm->cur_algorithm = algorithm;
 
-	if (!halbtc8821a1ant_is_common_action(btcoexist)) {
+	if (halbtc8821a1ant_is_common_action(btcoexist)) {
+	} else {
 		switch (coex_dm->cur_algorithm) {
 		case BT_8821A_1ANT_COEX_ALGO_SCO:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = SCO\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Action algorithm = SCO.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_sco(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HID\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Action algorithm = HID.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_hid(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = A2DP\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Action algorithm = A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_a2dp(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = A2DP+PAN(HS)\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action algorithm = A2DP+PAN(HS).\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = PAN(EDR)\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Action algorithm = PAN(EDR).\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HS mode\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Action algorithm = HS mode.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = PAN+A2DP\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Action algorithm = PAN+A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = PAN(EDR)+HID\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action algorithm = PAN(EDR)+HID.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HID+A2DP+PAN\n");
-			btc8821a1ant_action_hid_a2dp_pan_edr(btcoexist);
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action algorithm = HID+A2DP+PAN.\n");
+			BTC_TRACE(trace_buf);
+			halbtc8821a1ant_action_hid_a2dp_pan_edr(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = HID+A2DP\n");
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Action algorithm = HID+A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a1ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action algorithm = coexist All Off!!\n");
-			/*halbtc8821a1ant_coex_all_off(btcoexist);*/
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action algorithm = coexist All Off!!\n");
+			BTC_TRACE(trace_buf);
+			/* halbtc8821a1ant_coex_all_off(btcoexist); */
 			break;
 		}
 		coex_dm->pre_algorithm = coex_dm->cur_algorithm;
 	}
 }
 
-static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool	wifi_connected = false, bt_hs_on = false;
-	bool	increase_scan_dev_num = false;
-	bool	bt_ctrl_agg_buf_size = false;
-	u8	agg_buf_size = 5;
-	u8	wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-	bool	wifi_under_5g = false;
-
-	btc_alg_dbg(ALGO_TRACE,
+	bool wifi_connected = false, bt_hs_on = false;
+	bool increase_scan_dev_num = false;
+	bool bt_ctrl_agg_buf_size = false;
+	u8 agg_buf_size = 5;
+	u8 wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 		    "[BTCoex], RunCoexistMechanism()===>\n");
+	BTC_TRACE(trace_buf);
 
 	if (btcoexist->manual_control) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], RunCoexistMechanism(), return for Manual CTRL <===\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for Manual CTRL <===\n");
+		BTC_TRACE(trace_buf);
 		return;
 	}
 
 	if (btcoexist->stop_coex_dm) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], RunCoexistMechanism(), return for Stop Coex DM <===\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for Stop Coex DM <===\n");
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
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 	if (wifi_under_5g) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
 		halbtc8821a1ant_coex_under_5g(btcoexist);
 		return;
 	}
+	if (coex_sta->bt_whck_test) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BT is under WHCK TEST!!!\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_action_bt_whck_test(btcoexist);
+		return;
+	}
 
-	if ((BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) ||
-	    (BT_8821A_1ANT_BT_STATUS_SCO_BUSY == coex_dm->bt_status) ||
-	    (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY == coex_dm->bt_status))
+	if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY))
 		increase_scan_dev_num = true;
 
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_INC_SCAN_DEV_NUM,
 			   &increase_scan_dev_num);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if ((num_of_wifi_link >= 2) ||
+	    (wifi_link_status & WIFI_P2P_GO_CONNECTED)) {
+		halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					   bt_ctrl_agg_buf_size, agg_buf_size);
+		halbtc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
 
 	if (!bt_link_info->sco_exist && !bt_link_info->hid_exist) {
 		halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
 	} else {
 		if (wifi_connected) {
-			wifi_rssi_state =
-				 halbtc8821a1ant_WifiRssiState(btcoexist, 1, 2,
-							       30, 0);
+			wifi_rssi_state = halbtc8821a1ant_wifi_rssi_state(
+				btcoexist, 1, 2, 30, 0);
 			if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 			    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				halbtc8821a1ant_limited_tx(btcoexist,
-							   NORMAL_EXEC, 1, 1,
-							   1, 1);
+				halbtc8821a1ant_limited_tx(
+					btcoexist, NORMAL_EXEC, 1, 1, 0, 1);
 			} else {
-				halbtc8821a1ant_limited_tx(btcoexist,
-							   NORMAL_EXEC, 1, 1,
-							   1, 1);
+				halbtc8821a1ant_limited_tx(
+					btcoexist, NORMAL_EXEC, 1, 1, 0, 1);
 			}
-		} else {
-			halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC,
-						   0, 0, 0, 0);
-		}
+		} else
+			halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0,
+						   0, 0);
 	}
 
 	if (bt_link_info->sco_exist) {
@@ -2107,7 +2108,7 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
 				   bt_ctrl_agg_buf_size, agg_buf_size);
 
-	btc8821a1ant_run_sw_coex_mech(btcoexist);
+	halbtc8821a1ant_run_sw_coexist_mechanism(btcoexist);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
@@ -2119,95 +2120,117 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	}
 
 	if (!wifi_connected) {
-		bool	scan = false, link = false, roam = false;
+		bool scan = false, link = false, roam = false;
 
-		btc_alg_dbg(ALGO_TRACE,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], wifi is non connected-idle !!!\n");
+		BTC_TRACE(trace_buf);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 
-		if (scan || link || roam)
-			btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
-		else
+		if (scan || link || roam) {
+			if (scan)
+				halbtc8821a1ant_action_wifi_not_connected_scan(
+					btcoexist);
+			else
+				halbtc8821a1ant_action_wifi_not_connected_asso_auth(
+					btcoexist);
+		} else {
 			halbtc8821a1ant_action_wifi_not_connected(btcoexist);
-	} else {
-		/* wifi LPS/Busy*/
+		}
+	} else { /* wifi LPS/Busy */
 		halbtc8821a1ant_action_wifi_connected(btcoexist);
 	}
 }
 
-static void halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
+static
+void halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	/* force to reset coex mechanism*/
-	/* sw all off*/
+	/* force to reset coex mechanism */
+	/* sw all off */
 	halbtc8821a1ant_sw_mechanism(btcoexist, false);
 
-	halbtc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+	/* halbtc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8); */
 	halbtc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 }
 
-static void halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
-					   bool back_up)
+static
+void halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist, bool back_up,
+				    bool wifi_only)
 {
-	u8	u1_tmp = 0;
-	bool	wifi_under_5g = false;
+	u8 u8tmp = 0;
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], 1Ant Init HW Config!!\n");
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], 1Ant Init HW Config!!\n");
+	BTC_TRACE(trace_buf);
+
+	if (wifi_only)
+		return;
 
 	if (back_up) {
-		coex_dm->backup_arfr_cnt1 = btcoexist->btc_read_4byte(btcoexist,
-								      0x430);
-		coex_dm->backup_arfr_cnt2 = btcoexist->btc_read_4byte(btcoexist,
-								      0x434);
+		coex_dm->backup_arfr_cnt1 =
+			btcoexist->btc_read_4byte(btcoexist, 0x430);
+		coex_dm->backup_arfr_cnt2 =
+			btcoexist->btc_read_4byte(btcoexist, 0x434);
 		coex_dm->backup_retry_limit =
-			 btcoexist->btc_read_2byte(btcoexist, 0x42a);
+			btcoexist->btc_read_2byte(btcoexist, 0x42a);
 		coex_dm->backup_ampdu_max_time =
-			 btcoexist->btc_read_1byte(btcoexist, 0x456);
+			btcoexist->btc_read_1byte(btcoexist, 0x456);
 	}
 
-	/* 0x790[5:0] = 0x5*/
-	u1_tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
-	u1_tmp &= 0xc0;
-	u1_tmp |= 0x5;
-	btcoexist->btc_write_1byte(btcoexist, 0x790, u1_tmp);
+	/* 0x790[5:0]=0x5 */
+	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
+	u8tmp &= 0xc0;
+	u8tmp |= 0x5;
+	btcoexist->btc_write_1byte(btcoexist, 0x790, u8tmp);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 
-	/*Antenna config*/
+	/* Antenna config */
 	if (wifi_under_5g)
-		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
-					     true, false);
+		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, true,
+					     false);
 	else
-		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
-					     true, false);
-	/* PTA parameter*/
+		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, true,
+					     false);
+
+	/* PTA parameter */
 	halbtc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
-	/* Enable counter statistics*/
-	/*0x76e[3] =1, WLAN_Act control by PTA*/
-	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
+	/* Enable counter statistics */
+	btcoexist->btc_write_1byte(
+		btcoexist, 0x76e,
+		0xc); /* 0x76e[3] =1, WLAN_Act control by PTA */
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
 
-/*============================================================*/
-/* work around function start with wa_halbtc8821a1ant_*/
-/*============================================================*/
-/*============================================================*/
-/* extern function start with EXhalbtc8821a1ant_*/
-/*============================================================*/
-void ex_halbtc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist)
+/* ************************************************************
+ * work around function start with wa_halbtc8821a1ant_
+ * ************************************************************
+ * ************************************************************
+ * extern function start with ex_halbtc8821a1ant_
+ * ************************************************************
+ */
+void ex_halbtc8821a1ant_power_on_setting(struct btc_coexist *btcoexist) {}
+
+void ex_halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
+				       bool wifi_only)
 {
-	halbtc8821a1ant_init_hw_config(btcoexist, true);
+	halbtc8821a1ant_init_hw_config(btcoexist, true, wifi_only);
 }
 
 void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], Coex Mechanism Init!!\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], Coex Mechanism Init!!\n");
+	BTC_TRACE(trace_buf);
 
 	btcoexist->stop_coex_dm = false;
 
@@ -2219,338 +2242,343 @@ void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 u1_tmp[4], i, bt_info_ext, ps_tdma_case = 0;
-	u16 u2_tmp[4];
-	u32 u4_tmp[4];
-	bool roam = false, scan = false, link = false, wifi_under_5g = false;
-	bool bt_hs_on = false, wifi_busy = false;
-	long wifi_rssi = 0, bt_hs_rssi = 0;
-	u32 wifi_bw, wifi_traffic_dir;
-	u8 wifi_dot11_chnl, wifi_hs_chnl;
+	u8 *cli_buf = btcoexist->cli_buf;
+	u8 u8tmp[4], i, bt_info_ext, ps_tdma_case = 0;
+	u16 u16tmp[4];
+	u32 u32tmp[4];
 	u32 fw_ver = 0, bt_patch_ver = 0;
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n ============[BT Coexist info]============");
+	CL_PRINTF(cli_buf);
 
 	if (btcoexist->manual_control) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ============[Under Manual Control]============");
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+		CL_SPRINTF(
+			cli_buf, BT_TMP_BUF_SIZE,
+			"\r\n ============[Under Manual Control]============");
+		CL_PRINTF(cli_buf);
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 			   "\r\n ==========================================");
+		CL_PRINTF(cli_buf);
 	}
 	if (btcoexist->stop_coex_dm) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 			   "\r\n ============[Coex is STOPPED]============");
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
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
-		   "\r\n %-35s = %d/ %d/ %d",
-		   "Ant PG Num/ Ant Mech/ Ant Pos:",
-		   board_info->pg_ant_num,
-		   board_info->btdm_ant_num,
-		   board_info->btdm_ant_pos);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d",
+		   "Ant PG Num/ Ant Mech/ Ant Pos:", board_info->pg_ant_num,
+		   board_info->btdm_ant_num, board_info->btdm_ant_pos);
+	CL_PRINTF(cli_buf);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s / %d", "BT stack/ hci ext ver",
-		   ((stack_info->profile_notified) ? "Yes" : "No"),
-		stack_info->hci_version);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
-			   &bt_patch_ver);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER, &bt_patch_ver);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n %-35s = %d_%x/ 0x%x/ 0x%x(%d)",
-		   "CoexVer/ FwVer/ PatchVer",
-		   glcoex_ver_date_8821a_1ant,
-		   glcoex_ver_8821a_1ant,
-		   fw_ver, bt_patch_ver,
-		   bt_patch_ver);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION,
-			   &bt_hs_on);
-	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_DOT11_CHNL,
-			   &wifi_dot11_chnl);
-	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL,
-			   &wifi_hs_chnl);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d / %d(%d)",
-		   "Dot11 channel / HsChnl(HsMode)",
-		   wifi_dot11_chnl, wifi_hs_chnl, bt_hs_on);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %3ph ",
-		   "H2C Wifi inform bt chnl Info",
-		   coex_dm->wifi_chnl_info);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d", "Wifi rssi/ HS rssi",
-		   (int)wifi_rssi, (int)bt_hs_rssi);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d/ %d ", "Wifi link/ roam/ scan",
-		   link, roam, scan);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G,
-			   &wifi_under_5g);
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW,
-			   &wifi_bw);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY,
-			   &wifi_busy);
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
-			   &wifi_traffic_dir);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s / %s/ %s ", "Wifi status",
-		   (wifi_under_5g ? "5G" : "2.4G"),
-		   ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
-		   (((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40" : "HT20"))),
-		   ((!wifi_busy) ? "idle" :
-		   ((BTC_WIFI_TRAFFIC_TX == wifi_traffic_dir) ?
-		   "uplink" : "downlink")));
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = [%s/ %d/ %d] ", "BT [status/ rssi/ retryCnt]",
-		   ((btcoexist->bt_info.bt_disabled) ? ("disabled") :
-		   ((coex_sta->c2h_bt_inquiry_page) ? ("inquiry/page scan") :
-		   ((BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
-		     coex_dm->bt_status) ?
+		   "CoexVer/ FwVer/ PatchVer", glcoex_ver_date_8821a_1ant,
+		   glcoex_ver_8821a_1ant, fw_ver, bt_patch_ver, bt_patch_ver);
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
+		  ((BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE ==
+		    coex_dm->bt_status) ?
 		   "non-connected idle" :
 		   ((BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
 		     coex_dm->bt_status) ?
-		   "connected-idle" : "busy")))),
-		   coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d / %d / %d / %d", "SCO/HID/PAN/A2DP",
-		   bt_link_info->sco_exist,
-		   bt_link_info->hid_exist,
-		   bt_link_info->pan_exist,
+		    "connected-idle" :
+		    "busy")))),
+		coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d / %d / %d / %d",
+		   "SCO/HID/PAN/A2DP", bt_link_info->sco_exist,
+		   bt_link_info->hid_exist, bt_link_info->pan_exist,
 		   bt_link_info->a2dp_exist);
+	CL_PRINTF(cli_buf);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_BT_LINK_INFO);
 
 	bt_info_ext = coex_sta->bt_info_ext;
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s",
 		   "BT Info A2DP rate",
-		   (bt_info_ext&BIT0) ?
-		   "Basic rate" : "EDR rate");
+		   (bt_info_ext & BIT(0)) ? "Basic rate" : "EDR rate");
+	CL_PRINTF(cli_buf);
 
 	for (i = 0; i < BT_INFO_SRC_8821A_1ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %7ph(%d)",
-				   glbt_info_src_8821a_1ant[i],
-				   coex_sta->bt_info_c2h[i],
-				   coex_sta->bt_info_c2h_cnt[i]);
+			CL_SPRINTF(
+				cli_buf, BT_TMP_BUF_SIZE,
+				"\r\n %-35s = %02x %02x %02x %02x %02x %02x %02x(%d)",
+				glbt_info_src_8821a_1ant[i],
+				coex_sta->bt_info_c2h[i][0],
+				coex_sta->bt_info_c2h[i][1],
+				coex_sta->bt_info_c2h[i][2],
+				coex_sta->bt_info_c2h[i][3],
+				coex_sta->bt_info_c2h[i][4],
+				coex_sta->bt_info_c2h[i][5],
+				coex_sta->bt_info_c2h[i][6],
+				coex_sta->bt_info_c2h_cnt[i]);
+			CL_PRINTF(cli_buf);
 		}
 	}
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s/%s, (0x%x/0x%x)",
-		   "PS state, IPS/LPS, (lps/rpwm)",
-		   ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
-		   ((coex_sta->under_Lps ? "LPS ON" : "LPS OFF")),
-		   btcoexist->bt_info.lps_val,
-		   btcoexist->bt_info.rpwm_val);
-	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
 
 	if (!btcoexist->manual_control) {
-		/* Sw mechanism*/
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s", "============[Sw mechanism]============");
-
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %d", "SM[LowPenaltyRA]",
-			   coex_dm->cur_low_penalty_ra);
-
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %s/ %s/ %d ",
-			   "DelBA/ BtCtrlAgg/ AggSize",
-			   (btcoexist->bt_info.reject_agg_pkt ? "Yes" : "No"),
-			   (btcoexist->bt_info.bt_ctrl_buf_size ? "Yes" : "No"),
-			   btcoexist->bt_info.agg_buf_size);
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = 0x%x ", "Rate Mask",
-			   btcoexist->bt_info.ra_mask);
-
-		/* Fw mechanism*/
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
-			   "============[Fw mechanism]============");
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d",
+			   "SM[LowPenaltyRA]", coex_dm->cur_low_penalty_ra);
+		CL_PRINTF(cli_buf);
+
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
+			   "============[mechanisms]============");
+		CL_PRINTF(cli_buf);
 
 		ps_tdma_case = coex_dm->cur_ps_tdma;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %5ph case-%d (auto:%d)",
-			   "PS TDMA",
-			   coex_dm->ps_tdma_para,
-			   ps_tdma_case,
-			   coex_dm->auto_tdma_adjust);
-
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = 0x%x ",
+		CL_SPRINTF(
+			cli_buf, BT_TMP_BUF_SIZE,
+			"\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
+			"PS TDMA", coex_dm->ps_tdma_para[0],
+			coex_dm->ps_tdma_para[1], coex_dm->ps_tdma_para[2],
+			coex_dm->ps_tdma_para[3], coex_dm->ps_tdma_para[4],
+			ps_tdma_case, coex_dm->auto_tdma_adjust);
+		CL_PRINTF(cli_buf);
+
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d ",
+			   "IgnWlanAct", coex_dm->cur_ignore_wlan_act);
+		CL_PRINTF(cli_buf);
+
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x ",
 			   "Latest error condition(should be 0)",
 			   coex_dm->error_condition);
-
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %d ", "IgnWlanAct",
-			   coex_dm->cur_ignore_wlan_act);
+		CL_PRINTF(cli_buf);
 	}
 
-	/* Hw setting*/
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s", "============[Hw setting]============");
+	/* Hw setting		 */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
+		   "============[Hw setting]============");
+	CL_PRINTF(cli_buf);
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
-		   "backup ARFR1/ARFR2/RL/AMaxTime",
-		   coex_dm->backup_arfr_cnt1,
-		   coex_dm->backup_arfr_cnt2,
-		   coex_dm->backup_retry_limit,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
+		   "backup ARFR1/ARFR2/RL/AMaxTime", coex_dm->backup_arfr_cnt1,
+		   coex_dm->backup_arfr_cnt2, coex_dm->backup_retry_limit,
 		   coex_dm->backup_ampdu_max_time);
-
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x430);
-	u4_tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x434);
-	u2_tmp[0] = btcoexist->btc_read_2byte(btcoexist, 0x42a);
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x456);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
-		   "0x430/0x434/0x42a/0x456",
-		   u4_tmp[0], u4_tmp[1], u2_tmp[0], u1_tmp[0]);
-
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc58);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x", "0x778/ 0xc58[29:25]",
-		   u1_tmp[0], (u4_tmp[0]&0x3e000000) >> 25);
-
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x8db);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x", "0x8db[6:5]",
-		   ((u1_tmp[0]&0x60)>>5));
-
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x975);
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xcb4);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x430);
+	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x434);
+	u16tmp[0] = btcoexist->btc_read_2byte(btcoexist, 0x42a);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x456);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
+		   "0x430/0x434/0x42a/0x456", u32tmp[0], u32tmp[1], u16tmp[0],
+		   u8tmp[0]);
+	CL_PRINTF(cli_buf);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc58);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
+		   "0x778/ 0xc58[29:25]", u8tmp[0],
+		   (u32tmp[0] & 0x3e000000) >> 25);
+	CL_PRINTF(cli_buf);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x8db);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x", "0x8db[6:5]",
+		   ((u8tmp[0] & 0x60) >> 5));
+	CL_PRINTF(cli_buf);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x975);
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xcb4);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
 		   "0xcb4[29:28]/0xcb4[7:0]/0x974[9:8]",
-		   (u4_tmp[0] & 0x30000000)>>28,
-		    u4_tmp[0] & 0xff,
-		    u1_tmp[0] & 0x3);
-
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x40);
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
-	u1_tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x64);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0x40/0x4c[24:23]/0x64[0]",
-		   u1_tmp[0], ((u4_tmp[0]&0x01800000)>>23), u1_tmp[1]&0x1);
-
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x", "0x550(bcn ctrl)/0x522",
-		   u4_tmp[0], u1_tmp[0]);
-
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x", "0xc50(dig)",
-		   u4_tmp[0]&0xff);
-
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xf48);
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0xa5d);
-	u1_tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xa5c);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x", "OFDM-FA/ CCK-FA",
-		   u4_tmp[0], (u1_tmp[0]<<8) + u1_tmp[1]);
-
-	u4_tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
-	u4_tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
-	u4_tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
-	u1_tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x6cc);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
-		   "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
-		   u4_tmp[0], u4_tmp[1], u4_tmp[2], u1_tmp[0]);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d", "0x770(high-pri rx/tx)",
-		   coex_sta->high_priority_rx, coex_sta->high_priority_tx);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d", "0x774(low-pri rx/tx)",
-		   coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 1)
+		   (u32tmp[0] & 0x30000000) >> 28, u32tmp[0] & 0xff,
+		   u8tmp[0] & 0x3);
+	CL_PRINTF(cli_buf);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x40);
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x64);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		   "0x40/0x4c[24:23]/0x64[0]", u8tmp[0],
+		   ((u32tmp[0] & 0x01800000) >> 23), u8tmp[1] & 0x1);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
+		   "0x550(bcn ctrl)/0x522", u32tmp[0], u8tmp[0]);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x", "0xc50(dig)",
+		   u32tmp[0] & 0xff);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xf48);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0xa5d);
+	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xa5c);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
+		   "OFDM-FA/ CCK-FA", u32tmp[0], (u8tmp[0] << 8) + u8tmp[1]);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
+	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
+	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		   "0x6c0/0x6c4/0x6c8(coexTable)", u32tmp[0], u32tmp[1],
+		   u32tmp[2]);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d",
+		   "0x770(high-pri rx/tx)", coex_sta->high_priority_rx,
+		   coex_sta->high_priority_tx);
+	CL_PRINTF(cli_buf);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d",
+		   "0x774(low-pri rx/tx)", coex_sta->low_priority_rx,
+		   coex_sta->low_priority_tx);
+	CL_PRINTF(cli_buf);
 	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
-#endif
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
 void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
-	if (BTC_IPS_ENTER == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS ENTER notify\n");
+	if (type == BTC_IPS_ENTER) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], IPS ENTER notify\n");
+		BTC_TRACE(trace_buf);
 		coex_sta->under_ips = true;
-		halbtc8821a1ant_set_ant_path(btcoexist,
-					     BTC_ANT_PATH_BT, false, true);
-		/*set PTA control*/
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
-		halbtc8821a1ant_coex_table_with_type(btcoexist,
-						     NORMAL_EXEC, 0);
-	} else if (BTC_IPS_LEAVE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS LEAVE notify\n");
+
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false,
+					     true);
+		/* halbtc8821a1ant_set_ant_path_d_cut(btcoexist, false, false,
+		 * false, BTC_ANT_PATH_BT, BTC_WIFI_STAT_NORMAL_OFF);
+		 */
+	} else if (type == BTC_IPS_LEAVE) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], IPS LEAVE notify\n");
+		BTC_TRACE(trace_buf);
 		coex_sta->under_ips = false;
 
-		halbtc8821a1ant_run_coexist_mechanism(btcoexist);
+		halbtc8821a1ant_init_hw_config(btcoexist, false, false);
+		halbtc8821a1ant_init_coex_dm(btcoexist);
+		halbtc8821a1ant_query_bt_info(btcoexist);
 	}
 }
 
 void ex_halbtc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
-		return;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	if (BTC_LPS_ENABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS ENABLE notify\n");
-		coex_sta->under_Lps = true;
-	} else if (BTC_LPS_DISABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS DISABLE notify\n");
-		coex_sta->under_Lps = false;
+	if (type == BTC_LPS_ENABLE) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], LPS ENABLE notify\n");
+		BTC_TRACE(trace_buf);
+		coex_sta->under_lps = true;
+	} else if (type == BTC_LPS_DISABLE) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], LPS DISABLE notify\n");
+		BTC_TRACE(trace_buf);
+		coex_sta->under_lps = false;
 	}
 }
 
 void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	bool wifi_connected = false, bt_hs_on = false;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
+	bool bt_ctrl_agg_buf_size = false;
+	u8 agg_buf_size = 5;
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
+		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_coex_under_5g(btcoexist);
 		return;
+	}
+
+	if (type == BTC_SCAN_START) {
+		coex_sta->wifi_is_high_pri_task = true;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], SCAN START notify\n");
+		BTC_TRACE(trace_buf);
+
+		halbtc8821a1ant_ps_tdma(
+			btcoexist, FORCE_EXEC, false,
+			8); /* Force antenna setup for no scan result issue */
+	} else {
+		coex_sta->wifi_is_high_pri_task = false;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], SCAN FINISH notify\n");
+		BTC_TRACE(trace_buf);
+	}
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_HS_OPERATION, &bt_hs_on);
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
+	if (coex_sta->bt_disabled)
+		return;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
 
 	halbtc8821a1ant_query_bt_info(btcoexist);
 
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if (num_of_wifi_link >= 2) {
+		halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					   bt_ctrl_agg_buf_size, agg_buf_size);
+		halbtc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
+
 	if (coex_sta->c2h_bt_inquiry_page) {
 		halbtc8821a1ant_action_bt_inquiry(btcoexist);
 		return;
@@ -2559,36 +2587,67 @@ void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 		return;
 	}
 
-	if (BTC_SCAN_START == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN START notify\n");
-		if (!wifi_connected) {
-			/* non-connected scan*/
-			btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
-		} else {
-			/* wifi is connected*/
+	if (type == BTC_SCAN_START) {
+		if (!wifi_connected) /* non-connected scan */
+			halbtc8821a1ant_action_wifi_not_connected_scan(
+				btcoexist);
+		else /* wifi is connected */
 			halbtc8821a1ant_action_wifi_connected_scan(btcoexist);
-		}
-	} else if (BTC_SCAN_FINISH == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN FINISH notify\n");
-		if (!wifi_connected) {
-			/* non-connected scan*/
+	} else if (type == BTC_SCAN_FINISH) {
+		if (!wifi_connected) /* non-connected scan */
 			halbtc8821a1ant_action_wifi_not_connected(btcoexist);
-		} else {
+		else
 			halbtc8821a1ant_action_wifi_connected(btcoexist);
-		}
 	}
 }
 
 void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	bool	wifi_connected = false, bt_hs_on = false;
+	bool wifi_connected = false, bt_hs_on = false;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
+	bool bt_ctrl_agg_buf_size = false;
+	u8 agg_buf_size = 5;
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
+	    coex_sta->bt_disabled)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
+
+	if (type == BTC_ASSOCIATE_START) {
+		coex_sta->wifi_is_high_pri_task = true;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], CONNECT START notify\n");
+		BTC_TRACE(trace_buf);
+		coex_dm->arp_cnt = 0;
+	} else {
+		coex_sta->wifi_is_high_pri_task = false;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], CONNECT FINISH notify\n");
+		BTC_TRACE(trace_buf);
+		coex_dm->arp_cnt = 0;
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if (num_of_wifi_link >= 2) {
+		halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					   bt_ctrl_agg_buf_size, agg_buf_size);
+		halbtc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
@@ -2599,22 +2658,15 @@ void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 		return;
 	}
 
-	if (BTC_ASSOCIATE_START == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT START notify\n");
-		btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
-	} else if (BTC_ASSOCIATE_FINISH == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT FINISH notify\n");
-
-		btcoexist->btc_get(btcoexist,
-			 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
-		if (!wifi_connected) {
-			/* non-connected scan*/
+	if (type == BTC_ASSOCIATE_START) {
+		halbtc8821a1ant_action_wifi_not_connected_asso_auth(btcoexist);
+	} else if (type == BTC_ASSOCIATE_FINISH) {
+		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+				   &wifi_connected);
+		if (!wifi_connected) /* non-connected scan */
 			halbtc8821a1ant_action_wifi_not_connected(btcoexist);
-		} else {
+		else
 			halbtc8821a1ant_action_wifi_connected(btcoexist);
-		}
 	}
 }
 
@@ -2624,31 +2676,42 @@ void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
+	    coex_sta->bt_disabled)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
-	if (BTC_MEDIA_CONNECT == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA connect notify\n");
+	if (type == BTC_MEDIA_CONNECT) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], MEDIA connect notify\n");
+		BTC_TRACE(trace_buf);
 	} else {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA disconnect notify\n");
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], MEDIA disconnect notify\n");
+		BTC_TRACE(trace_buf);
+		coex_dm->arp_cnt = 0;
 	}
 
-	/* only 2.4G we need to inform bt the chnl mask*/
-	btcoexist->btc_get(btcoexist,
-			   BTC_GET_U1_WIFI_CENTRAL_CHNL,
+	/* only 2.4G we need to inform bt the chnl mask */
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
 			   &wifi_central_chnl);
-	if ((BTC_MEDIA_CONNECT == type) &&
-	    (wifi_central_chnl <= 14)) {
-		/*h2c_parameter[0] = 0x1;*/
+	if ((type == BTC_MEDIA_CONNECT) && (wifi_central_chnl <= 14)) {
+		/* h2c_parameter[0] = 0x1; */
 		h2c_parameter[0] = 0x0;
 		h2c_parameter[1] = wifi_central_chnl;
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-		if (BTC_WIFI_BW_HT40 == wifi_bw)
+		if (wifi_bw == BTC_WIFI_BW_HT40)
 			h2c_parameter[2] = 0x30;
 		else
 			h2c_parameter[2] = 0x20;
@@ -2658,26 +2721,67 @@ void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 	coex_dm->wifi_chnl_info[1] = h2c_parameter[1];
 	coex_dm->wifi_chnl_info[2] = h2c_parameter[2];
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x66 = 0x%x\n",
-		    h2c_parameter[0] << 16 |
-		    h2c_parameter[1] << 8 |
-		    h2c_parameter[2]);
-
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
 
-void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type)
+void ex_halbtc8821a1ant_specific_packet_notify(struct btc_coexist *btcoexist,
+					       u8 type)
 {
 	bool bt_hs_on = false;
+	u32 wifi_link_status = 0;
+	u32 num_of_wifi_link = 0;
+	bool bt_ctrl_agg_buf_size = false;
+	u8 agg_buf_size = 5;
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	if (btcoexist->manual_control ||
-	    btcoexist->stop_coex_dm ||
-	    btcoexist->bt_info.bt_disabled)
+	if (btcoexist->manual_control || btcoexist->stop_coex_dm ||
+	    coex_sta->bt_disabled)
 		return;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
-	coex_sta->special_pkt_period_cnt = 0;
+	if (type == BTC_PACKET_DHCP || type == BTC_PACKET_EAPOL ||
+	    type == BTC_PACKET_ARP) {
+		coex_sta->wifi_is_high_pri_task = true;
+
+		if (type == BTC_PACKET_ARP) {
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], specific Packet ARP notify\n");
+			BTC_TRACE(trace_buf);
+		} else {
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], specific Packet DHCP or EAPOL notify\n");
+			BTC_TRACE(trace_buf);
+		}
+	} else {
+		coex_sta->wifi_is_high_pri_task = false;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], specific Packet [Type = %d] notify\n",
+			    type);
+		BTC_TRACE(trace_buf);
+	}
+
+	coex_sta->specific_pkt_period_cnt = 0;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+	if (num_of_wifi_link >= 2) {
+		halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+					   bt_ctrl_agg_buf_size, agg_buf_size);
+		halbtc8821a1ant_action_wifi_multi_port(btcoexist);
+		return;
+	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
@@ -2688,11 +2792,23 @@ void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 		return;
 	}
 
-	if (BTC_PACKET_DHCP == type ||
-	    BTC_PACKET_EAPOL == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], special Packet(%d) notify\n", type);
-		btc8821a1ant_act_wifi_conn_sp_pkt(btcoexist);
+	if (type == BTC_PACKET_DHCP || type == BTC_PACKET_EAPOL ||
+	    type == BTC_PACKET_ARP) {
+		if (type == BTC_PACKET_ARP) {
+			coex_dm->arp_cnt++;
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], ARP Packet Count = %d\n",
+				    coex_dm->arp_cnt);
+			BTC_TRACE(trace_buf);
+			if (coex_dm->arp_cnt >= 10)
+				/* if APR PKT > 10 after connect, do not go to
+				 * ActionWifiConnectedSpecificPacket(btcoexist)
+				 */
+				return;
+		}
+
+		halbtc8821a1ant_action_wifi_connected_specific_packet(
+			btcoexist);
 	}
 }
 
@@ -2704,95 +2820,118 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	bool wifi_connected = false;
 	bool bt_busy = false;
 	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	coex_sta->c2h_bt_info_req_sent = false;
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 
-	rsp_source = tmp_buf[0]&0xf;
+	rsp_source = tmp_buf[0] & 0xf;
 	if (rsp_source >= BT_INFO_SRC_8821A_1ANT_MAX)
 		rsp_source = BT_INFO_SRC_8821A_1ANT_WIFI_FW;
 	coex_sta->bt_info_c2h_cnt[rsp_source]++;
 
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Bt info[%d], length = %d, hex data = [",
-		      rsp_source, length);
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], Bt info[%d], length=%d, hex data=[", rsp_source,
+		    length);
+	BTC_TRACE(trace_buf);
 	for (i = 0; i < length; i++) {
 		coex_sta->bt_info_c2h[rsp_source][i] = tmp_buf[i];
 		if (i == 1)
 			bt_info = tmp_buf[i];
-		if (i == length-1) {
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x]\n", tmp_buf[i]);
+		if (i == length - 1) {
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "0x%02x]\n",
+				    tmp_buf[i]);
+			BTC_TRACE(trace_buf);
 		} else {
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x, ", tmp_buf[i]);
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "0x%02x, ",
+				    tmp_buf[i]);
+			BTC_TRACE(trace_buf);
 		}
 	}
+	/* if 0xff, it means BT is under WHCK test */
+	if (bt_info == 0xff)
+		coex_sta->bt_whck_test = true;
+	else
+		coex_sta->bt_whck_test = false;
 
-	if (BT_INFO_SRC_8821A_1ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0]*/
-			coex_sta->bt_info_c2h[rsp_source][2]&0xf;
+	if (rsp_source != BT_INFO_SRC_8821A_1ANT_WIFI_FW) {
+		coex_sta->bt_retry_cnt = /* [3:0] */
+			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
+
+		if (coex_sta->bt_info_c2h[rsp_source][2] & 0x20)
+			coex_sta->c2h_bt_page = true;
+		else
+			coex_sta->c2h_bt_page = false;
 
 		coex_sta->bt_rssi =
-			coex_sta->bt_info_c2h[rsp_source][3]*2+10;
+			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
 
-		coex_sta->bt_info_ext =
-			coex_sta->bt_info_c2h[rsp_source][4];
+		coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
 
-		/* Here we need to resend some wifi info to BT*/
-		/* because bt is reset and loss of the info.*/
-		if (coex_sta->bt_info_ext & BIT1) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
-			btcoexist->btc_get(btcoexist,
-					   BTC_GET_BL_WIFI_CONNECTED,
+		coex_sta->bt_tx_rx_mask =
+			(coex_sta->bt_info_c2h[rsp_source][2] & 0x40);
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TX_RX_MASK,
+				   &coex_sta->bt_tx_rx_mask);
+		if (!coex_sta->bt_tx_rx_mask) {
+			/* BT into is responded by BT FW and BT RF REG 0x3C !=
+			 * 0x15 => Need to switch BT TRx Mask
+			 */
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Switch BT TRx Mask since BT RF REG 0x3C != 0x15\n");
+			BTC_TRACE(trace_buf);
+			btcoexist->btc_set_bt_reg(btcoexist, BTC_BT_REG_RF,
+						  0x3c, 0x15);
+		}
+
+		/* Here we need to resend some wifi info to BT */
+		/* because bt is reset and loss of the info. */
+		if (coex_sta->bt_info_ext & BIT(1)) {
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
+			BTC_TRACE(trace_buf);
+			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
-			if (wifi_connected) {
-				ex_halbtc8821a1ant_media_status_notify(btcoexist,
-							       BTC_MEDIA_CONNECT);
-			} else {
-				ex_halbtc8821a1ant_media_status_notify(btcoexist,
-							       BTC_MEDIA_DISCONNECT);
-			}
+			if (wifi_connected)
+				ex_halbtc8821a1ant_media_status_notify(
+					btcoexist, BTC_MEDIA_CONNECT);
+			else
+				ex_halbtc8821a1ant_media_status_notify(
+					btcoexist, BTC_MEDIA_DISCONNECT);
 		}
 
-		if ((coex_sta->bt_info_ext & BIT3) && !wifi_under_5g) {
+		if ((coex_sta->bt_info_ext & BIT(3)) && !wifi_under_5g) {
 			if (!btcoexist->manual_control &&
 			    !btcoexist->stop_coex_dm) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
-				halbtc8821a1ant_ignore_wlan_act(btcoexist,
-								FORCE_EXEC,
-								false);
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
+				BTC_TRACE(trace_buf);
+				halbtc8821a1ant_ignore_wlan_act(
+					btcoexist, FORCE_EXEC, false);
 			}
+		} else {
+			/* BT already NOT ignore Wlan active, do nothing here.
+			 */
 		}
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-		if (!(coex_sta->bt_info_ext & BIT4)) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], BT ext info bit4 check, set BT to enable Auto Report!!\n");
-			halbtc8821a1ant_bt_auto_report(btcoexist,
-						       FORCE_EXEC, true);
-		}
-#endif
 	}
 
-	/* check BIT2 first ==> check if bt is under inquiry or page scan*/
+	/* check BIT2 first ==> check if bt is under inquiry or page scan */
 	if (bt_info & BT_INFO_8821A_1ANT_B_INQ_PAGE)
 		coex_sta->c2h_bt_inquiry_page = true;
 	else
 		coex_sta->c2h_bt_inquiry_page = false;
 
-	/* set link exist status*/
-	if (!(bt_info&BT_INFO_8821A_1ANT_B_CONNECTION)) {
+	/* set link exist status */
+	if (!(bt_info & BT_INFO_8821A_1ANT_B_CONNECTION)) {
 		coex_sta->bt_link_exist = false;
 		coex_sta->pan_exist = false;
 		coex_sta->a2dp_exist = false;
 		coex_sta->hid_exist = false;
 		coex_sta->sco_exist = false;
-	} else {
-		/* connection exists*/
+	} else { /* connection exists */
 		coex_sta->bt_link_exist = true;
 		if (bt_info & BT_INFO_8821A_1ANT_B_FTP)
 			coex_sta->pan_exist = true;
@@ -2814,134 +2953,152 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 
 	halbtc8821a1ant_update_bt_link_info(btcoexist);
 
-	if (!(bt_info&BT_INFO_8821A_1ANT_B_CONNECTION)) {
+	/* mask profile bit for connect-ilde identification
+	 * (for CSR case: A2DP idle --> 0x41)
+	 */
+	bt_info = bt_info & 0x1f;
+
+	if (!(bt_info & BT_INFO_8821A_1ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+		BTC_TRACE(trace_buf);
 	} else if (bt_info == BT_INFO_8821A_1ANT_B_CONNECTION) {
-		/* connection exists but no busy*/
+		/* connection exists but no busy */
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE;
-		btc_alg_dbg(ALGO_TRACE,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
-	} else if ((bt_info&BT_INFO_8821A_1ANT_B_SCO_ESCO) ||
-		(bt_info&BT_INFO_8821A_1ANT_B_SCO_BUSY)) {
+		BTC_TRACE(trace_buf);
+	} else if ((bt_info & BT_INFO_8821A_1ANT_B_SCO_ESCO) ||
+		   (bt_info & BT_INFO_8821A_1ANT_B_SCO_BUSY)) {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_SCO_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
-	} else if (bt_info&BT_INFO_8821A_1ANT_B_ACL_BUSY) {
-		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY != coex_dm->bt_status)
+		BTC_TRACE(trace_buf);
+	} else if (bt_info & BT_INFO_8821A_1ANT_B_ACL_BUSY) {
+		if (coex_dm->bt_status != BT_8821A_1ANT_BT_STATUS_ACL_BUSY)
 			coex_dm->auto_tdma_adjust = false;
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_ACL_BUSY;
-		btc_alg_dbg(ALGO_TRACE,
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
+		BTC_TRACE(trace_buf);
 	} else {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_MAX;
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
+		BTC_TRACE(trace_buf);
 	}
 
-	if ((BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) ||
-	    (BT_8821A_1ANT_BT_STATUS_SCO_BUSY == coex_dm->bt_status) ||
-	    (BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY == coex_dm->bt_status))
+	if ((coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_SCO_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY))
 		bt_busy = true;
 	else
 		bt_busy = false;
-	btcoexist->btc_set(btcoexist,
-			   BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
 
 	halbtc8821a1ant_run_coexist_mechanism(btcoexist);
 }
 
 void ex_halbtc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Halt notify\n");
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btcoexist->stop_coex_dm = true;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
 
-	halbtc8821a1ant_set_ant_path(btcoexist,
-				     BTC_ANT_PATH_BT, false, true);
-	halbtc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "[BTCoex], Halt notify\n");
+	BTC_TRACE(trace_buf);
 
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 	halbtc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
+	halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false, true);
+	/* halbtc8821a1ant_set_ant_path_d_cut(btcoexist, false, false, false,
+	 * BTC_ANT_PATH_BT, BTC_WIFI_STAT_NORMAL_OFF);
+	 */
+
+	halbtc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+
+	ex_halbtc8821a1ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 
-	ex_halbtc8821a1ant_media_status_notify(btcoexist,
-					       BTC_MEDIA_DISCONNECT);
+	btcoexist->stop_coex_dm = true;
 }
 
 void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Pnp notify\n");
+	bool wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	if (wifi_under_5g) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a1ant_coex_under_5g(btcoexist);
+		return;
+	}
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "[BTCoex], Pnp notify\n");
+	BTC_TRACE(trace_buf);
+
+	if (pnp_state == BTC_WIFI_PNP_SLEEP) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Pnp notify to SLEEP\n");
+		BTC_TRACE(trace_buf);
 
-	if (BTC_WIFI_PNP_SLEEP == pnp_state) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], Pnp notify to SLEEP\n");
-		btcoexist->stop_coex_dm = true;
-		halbtc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 						 0x0, 0x0);
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 9);
-	} else if (BTC_WIFI_PNP_WAKE_UP == pnp_state) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], Pnp notify to WAKE UP\n");
+		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
+		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false,
+					     true);
+		/* halbtc8821a1ant_set_ant_path_d_cut(btcoexist, false, false,
+		 * false, BTC_ANT_PATH_BT, BTC_WIFI_STAT_NORMAL_OFF);
+		 */
+
+		/* Sinda 20150819, workaround for driver skip leave IPS/LPS to
+		 * speed up sleep time.
+		 */
+		/* Driver do not leave IPS/LPS when driver is going to sleep, so
+		 * BTCoexistence think wifi is still under IPS/LPS
+		 */
+		/* BT should clear UnderIPS/UnderLPS state to avoid mismatch
+		 * state after wakeup.
+		 */
+		coex_sta->under_ips = false;
+		coex_sta->under_lps = false;
+		btcoexist->stop_coex_dm = true;
+	} else if (pnp_state == BTC_WIFI_PNP_WAKE_UP) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Pnp notify to WAKE UP\n");
+		BTC_TRACE(trace_buf);
 		btcoexist->stop_coex_dm = false;
-		halbtc8821a1ant_init_hw_config(btcoexist, false);
+		halbtc8821a1ant_init_hw_config(btcoexist, false, false);
 		halbtc8821a1ant_init_coex_dm(btcoexist);
 		halbtc8821a1ant_query_bt_info(btcoexist);
 	}
 }
 
-void
-ex_halbtc8821a1ant_periodical(
-	struct btc_coexist *btcoexist) {
-	static u8	dis_ver_info_cnt;
-	u32		fw_ver = 0, bt_patch_ver = 0;
-	struct btc_board_info *board_info = &btcoexist->board_info;
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], ==========================Periodical===========================\n");
-
-	if (dis_ver_info_cnt <= 5) {
-		dis_ver_info_cnt += 1;
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], ****************************************************************\n");
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], Ant PG Num/ Ant Mech/ Ant Pos = %d/ %d/ %d\n",
-			      board_info->pg_ant_num,
-			      board_info->btdm_ant_num,
-			      board_info->btdm_ant_pos);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], BT stack/ hci ext ver = %s / %d\n",
-			      stack_info->profile_notified ? "Yes" : "No",
-			      stack_info->hci_version);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
-				   &bt_patch_ver);
-		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], CoexVer/ FwVer/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
-			      glcoex_ver_date_8821a_1ant,
-			      glcoex_ver_8821a_1ant,
-			      fw_ver, bt_patch_ver,
-			      bt_patch_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], ****************************************************************\n");
-	}
-
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-	halbtc8821a1ant_query_bt_info(btcoexist);
-	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
-	btc8821a1ant_mon_bt_en_dis(btcoexist);
-#else
-	if (halbtc8821a1ant_Is_wifi_status_changed(btcoexist) ||
+void ex_halbtc8821a1ant_periodical(struct btc_coexist *btcoexist)
+{
+	if (halbtc8821a1ant_is_wifi_status_changed(btcoexist) ||
 	    coex_dm->auto_tdma_adjust) {
-		if (coex_sta->special_pkt_period_cnt > 2)
-			halbtc8821a1ant_run_coexist_mechanism(btcoexist);
+		/* if(coex_sta->specific_pkt_period_cnt > 2) */
+		/* { */
+		halbtc8821a1ant_run_coexist_mechanism(btcoexist);
+		/* } */
 	}
 
-	coex_sta->special_pkt_period_cnt++;
-#endif
+	coex_sta->specific_pkt_period_cnt++;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 20e9048..14e5b78 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -23,66 +23,65 @@
  *
  *****************************************************************************/
 
-/*===========================================
+/* *******************************************
  * The following is for 8821A 1ANT BT Co-exist definition
- *===========================================
+ * *******************************************
  */
-#define	BT_AUTO_REPORT_ONLY_8821A_1ANT				0
-
-#define	BT_INFO_8821A_1ANT_B_FTP	BIT7
-#define	BT_INFO_8821A_1ANT_B_A2DP	BIT6
-#define	BT_INFO_8821A_1ANT_B_HID	BIT5
-#define	BT_INFO_8821A_1ANT_B_SCO_BUSY	BIT4
-#define	BT_INFO_8821A_1ANT_B_ACL_BUSY	BIT3
-#define	BT_INFO_8821A_1ANT_B_INQ_PAGE	BIT2
-#define	BT_INFO_8821A_1ANT_B_SCO_ESCO	BIT1
-#define	BT_INFO_8821A_1ANT_B_CONNECTION	BIT0
-
-#define	BT_INFO_8821A_1ANT_A2DP_BASIC_RATE(_BT_INFO_EXT_)	\
-		(((_BT_INFO_EXT_&BIT0)) ? true : false)
-
-#define	BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT		2
-
-enum _BT_INFO_SRC_8821A_1ANT {
-	BT_INFO_SRC_8821A_1ANT_WIFI_FW			= 0x0,
-	BT_INFO_SRC_8821A_1ANT_BT_RSP			= 0x1,
-	BT_INFO_SRC_8821A_1ANT_BT_ACTIVE_SEND		= 0x2,
+
+#define BT_INFO_8821A_1ANT_B_FTP	BIT(7)
+#define BT_INFO_8821A_1ANT_B_A2DP	BIT(6)
+#define BT_INFO_8821A_1ANT_B_HID	BIT(5)
+#define BT_INFO_8821A_1ANT_B_SCO_BUSY	BIT(4)
+#define BT_INFO_8821A_1ANT_B_ACL_BUSY	BIT(3)
+#define BT_INFO_8821A_1ANT_B_INQ_PAGE	BIT(2)
+#define BT_INFO_8821A_1ANT_B_SCO_ESCO	BIT(1)
+#define BT_INFO_8821A_1ANT_B_CONNECTION	BIT(0)
+
+#define BT_INFO_8821A_1ANT_A2DP_BASIC_RATE(_BT_INFO_EXT_)                      \
+	(((_BT_INFO_EXT_ & BIT(0))) ? true : false)
+
+#define BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT	2
+
+enum bt_info_src_8821a_1ant {
+	BT_INFO_SRC_8821A_1ANT_WIFI_FW	= 0x0,
+	BT_INFO_SRC_8821A_1ANT_BT_RSP	= 0x1,
+	BT_INFO_SRC_8821A_1ANT_BT_ACTIVE_SEND	= 0x2,
 	BT_INFO_SRC_8821A_1ANT_MAX
 };
 
-enum _BT_8821A_1ANT_BT_STATUS {
-	BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE		= 0x0,
-	BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE			= 0x1,
-	BT_8821A_1ANT_BT_STATUS_INQ_PAGE			= 0x2,
-	BT_8821A_1ANT_BT_STATUS_ACL_BUSY			= 0x3,
-	BT_8821A_1ANT_BT_STATUS_SCO_BUSY			= 0x4,
-	BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY			= 0x5,
+enum bt_8821a_1ant_bt_status {
+	BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE	= 0x0,
+	BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE	= 0x1,
+	BT_8821A_1ANT_BT_STATUS_INQ_PAGE	= 0x2,
+	BT_8821A_1ANT_BT_STATUS_ACL_BUSY	= 0x3,
+	BT_8821A_1ANT_BT_STATUS_SCO_BUSY	= 0x4,
+	BT_8821A_1ANT_BT_STATUS_ACL_SCO_BUSY	= 0x5,
 	BT_8821A_1ANT_BT_STATUS_MAX
 };
 
-enum _BT_8821A_1ANT_WIFI_STATUS {
-	BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_IDLE		= 0x0,
+enum bt_8821a_1ant_wifi_status {
+	BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_IDLE	= 0x0,
 	BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN	= 0x1,
-	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN		= 0x2,
-	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SPECIAL_PKT		= 0x3,
-	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE		= 0x4,
-	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_BUSY		= 0x5,
+	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN	= 0x2,
+	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SPECIFIC_PKT	= 0x3,
+	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE	= 0x4,
+	BT_8821A_1ANT_WIFI_STATUS_CONNECTED_BUSY	= 0x5,
 	BT_8821A_1ANT_WIFI_STATUS_MAX
 };
 
-enum BT_8821A_1ANT_COEX_ALGO {
-	BT_8821A_1ANT_COEX_ALGO_UNDEFINED		= 0x0,
-	BT_8821A_1ANT_COEX_ALGO_SCO			= 0x1,
-	BT_8821A_1ANT_COEX_ALGO_HID			= 0x2,
-	BT_8821A_1ANT_COEX_ALGO_A2DP			= 0x3,
-	BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS		= 0x4,
-	BT_8821A_1ANT_COEX_ALGO_PANEDR			= 0x5,
-	BT_8821A_1ANT_COEX_ALGO_PANHS			= 0x6,
-	BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP		= 0x7,
-	BT_8821A_1ANT_COEX_ALGO_PANEDR_HID		= 0x8,
-	BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR		= 0x9,
-	BT_8821A_1ANT_COEX_ALGO_HID_A2DP		= 0xa,
-	BT_8821A_1ANT_COEX_ALGO_MAX			= 0xb,
+enum bt_8821a_1ant_coex_algo {
+	BT_8821A_1ANT_COEX_ALGO_UNDEFINED	= 0x0,
+	BT_8821A_1ANT_COEX_ALGO_SCO	= 0x1,
+	BT_8821A_1ANT_COEX_ALGO_HID	= 0x2,
+	BT_8821A_1ANT_COEX_ALGO_A2DP	= 0x3,
+	BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS	= 0x4,
+	BT_8821A_1ANT_COEX_ALGO_PANEDR	= 0x5,
+	BT_8821A_1ANT_COEX_ALGO_PANHS	= 0x6,
+	BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP	= 0x7,
+	BT_8821A_1ANT_COEX_ALGO_PANEDR_HID	= 0x8,
+	BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR	= 0x9,
+	BT_8821A_1ANT_COEX_ALGO_HID_A2DP	= 0xa,
+	BT_8821A_1ANT_COEX_ALGO_MAX	= 0xb,
 };
 
 struct coex_dm_8821a_1ant {
@@ -92,7 +91,7 @@ struct coex_dm_8821a_1ant {
 	u8	pre_ps_tdma;
 	u8	cur_ps_tdma;
 	u8	ps_tdma_para[5];
-	u8	tdma_adj_type;
+	u8	ps_tdma_du_adj_type;
 	bool	auto_tdma_adjust;
 	bool	pre_ps_tdma_on;
 	bool	cur_ps_tdma_on;
@@ -106,18 +105,17 @@ struct coex_dm_8821a_1ant {
 	/* sw mechanism */
 	bool	pre_low_penalty_ra;
 	bool	cur_low_penalty_ra;
-	u32	pre_val_0x6c0;
-	u32	cur_val_0x6c0;
-	u32	pre_val_0x6c4;
-	u32	cur_val_0x6c4;
-	u32	pre_val_0x6c8;
-	u32	cur_val_0x6c8;
-	u8	pre_val_0x6cc;
-	u8	cur_val_0x6cc;
-	/* Auto Rate Fallback Retry cnt */
-	u32	backup_arfr_cnt1;
-	/* Auto Rate Fallback Retry cnt */
-	u32	backup_arfr_cnt2;
+	u32	pre_val0x6c0;
+	u32	cur_val0x6c0;
+	u32	pre_val0x6c4;
+	u32	cur_val0x6c4;
+	u32	pre_val0x6c8;
+	u32	cur_val0x6c8;
+	u8	pre_val0x6cc;
+	u8	cur_val0x6cc;
+
+	u32	backup_arfr_cnt1; /* Auto Rate Fallback Retry cnt */
+	u32	backup_arfr_cnt2; /* Auto Rate Fallback Retry cnt */
 	u16	backup_retry_limit;
 	u8	backup_ampdu_max_time;
 
@@ -135,40 +133,48 @@ struct coex_dm_8821a_1ant {
 	u8	cur_retry_limit_type;
 	u8	pre_ampdu_time_type;
 	u8	cur_ampdu_time_type;
+	u32	arp_cnt;
 
 	u8	error_condition;
 };
 
 struct coex_sta_8821a_1ant {
+	bool	bt_disabled;
 	bool	bt_link_exist;
 	bool	sco_exist;
 	bool	a2dp_exist;
 	bool	hid_exist;
 	bool	pan_exist;
 
-	bool	under_Lps;
+	bool	under_lps;
 	bool	under_ips;
-	u32	special_pkt_period_cnt;
+	u32	specific_pkt_period_cnt;
 	u32	high_priority_tx;
 	u32	high_priority_rx;
 	u32	low_priority_tx;
 	u32	low_priority_rx;
 	u8	bt_rssi;
+	bool	bt_tx_rx_mask;
 	u8	pre_bt_rssi_state;
 	u8	pre_wifi_rssi_state[4];
 	bool	c2h_bt_info_req_sent;
 	u8	bt_info_c2h[BT_INFO_SRC_8821A_1ANT_MAX][10];
 	u32	bt_info_c2h_cnt[BT_INFO_SRC_8821A_1ANT_MAX];
 	bool	c2h_bt_inquiry_page;
+	bool	c2h_bt_page; /* Add for win8.1 page out issue */
+	bool	wifi_is_high_pri_task; /* Add for win8.1 page out issue */
 	u8	bt_retry_cnt;
 	u8	bt_info_ext;
+	bool	bt_whck_test; /* Add for WHQL TEST that enable wifi test bt */
 };
 
-/*===========================================
+/* *******************************************
  * The following is interface which will notify coex module.
- *===========================================
+ * *******************************************
  */
-void ex_halbtc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist);
+void ex_halbtc8821a1ant_power_on_setting(struct btc_coexist *btcoexist);
+void ex_halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
+				       bool wifi_only);
 void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
 void ex_halbtc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
@@ -176,13 +182,11 @@ void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
 void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
 void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 					    u8 type);
-void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type);
+void ex_halbtc8821a1ant_specific_packet_notify(struct btc_coexist *btcoexist,
+					       u8 type);
 void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpbuf, u8 length);
+				       u8 *tmp_buf, u8 length);
 void ex_halbtc8821a1ant_halt_notify(struct btc_coexist *btcoexist);
-void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnpstate);
+void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
 void ex_halbtc8821a1ant_periodical(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist);
-void ex_halbtc8821a1ant_dbg_control(struct btc_coexist *btcoexist, u8 op_code,
-				    u8 op_len, u8 *data);
-- 
2.10.2
