Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33742 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdDCSlx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 14:41:53 -0400
Received: by mail-oi0-f67.google.com with SMTP id f193so21146765oib.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Apr 2017 11:41:52 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v3 02/12] rtlwifi: btcoex: follow linux coding style
Date: Mon,  3 Apr 2017 13:41:32 -0500
Message-Id: <20170403184147.18409-2-Larry.Finger@lwfinger.net> (sfid-20170403_204219_519014_FB6D4332)
In-Reply-To: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
References: <20170331164742.22374-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Fix a number of checkpatch.pl warnings. In addition, some variable and
function names are shortened, and/or renamed to be more consistent.

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - Fixed build error from v1.
v3 - Fix for indentation problem moved to patdch 1.
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 1878 ++++++++++----------
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   24 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  416 ++---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  339 ++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |    1 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 1141 ++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |    2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 1347 +++++++-------
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |    2 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |    2 +-
 10 files changed, 2493 insertions(+), 2659 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 113eea8e25eb..57e633dbf9a9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -44,7 +44,7 @@ static struct coex_dm_8192e_2ant *coex_dm = &glcoex_dm_8192e_2ant;
 static struct coex_sta_8192e_2ant glcoex_sta_8192e_2ant;
 static struct coex_sta_8192e_2ant *coex_sta = &glcoex_sta_8192e_2ant;
 
-static const char *const GLBtInfoSrc8192e2Ant[] = {
+static const char *const glbt_info_src_8192e_2ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
 	"BT Info[bt auto report]",
@@ -57,31 +57,31 @@ static u32 glcoex_ver_8192e_2ant = 0x34;
  *   local function proto type if needed
  **************************************************************/
 /**************************************************************
- *   local function start with halbtc8192e2ant_
+ *   local function start with btc8192e2ant_
  **************************************************************/
-static u8 halbtc8192e2ant_btrssi_state(struct btc_coexist *btcoexist,
-					u8 level_num, u8 rssi_thresh,
-				       u8 rssi_thresh1)
+static u8 btc8192e2ant_bt_rssi_state(struct btc_coexist *btcoexist,
+				     u8 level_num, u8 rssi_thresh,
+				     u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	int btrssi = 0;
-	u8 btrssi_state = coex_sta->pre_bt_rssi_state;
+	int bt_rssi = 0;
+	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
-	btrssi = coex_sta->bt_rssi;
+	bt_rssi = coex_sta->bt_rssi;
 
 	if (level_num == 2) {
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			if (btrssi >=
+			if (bt_rssi >=
 			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
-				btrssi_state = BTC_RSSI_STATE_HIGH;
+				bt_rssi_state = BTC_RSSI_STATE_HIGH;
 			else
-				btrssi_state = BTC_RSSI_STATE_STAY_LOW;
+				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else {
-			if (btrssi < rssi_thresh)
-				btrssi_state = BTC_RSSI_STATE_LOW;
+			if (bt_rssi < rssi_thresh)
+				bt_rssi_state = BTC_RSSI_STATE_LOW;
 			else
-				btrssi_state = BTC_RSSI_STATE_STAY_HIGH;
+				bt_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
@@ -89,62 +89,63 @@ static u8 halbtc8192e2ant_btrssi_state(struct btc_coexist *btcoexist,
 				 "[BTCoex], BT Rssi thresh error!!\n");
 			return coex_sta->pre_bt_rssi_state;
 		}
+
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			if (btrssi >=
+			if (bt_rssi >=
 			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
-				btrssi_state = BTC_RSSI_STATE_MEDIUM;
+				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
 			else
-				btrssi_state = BTC_RSSI_STATE_STAY_LOW;
+				bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else if ((coex_sta->pre_bt_rssi_state ==
 			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_bt_rssi_state ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
-			if (btrssi >= (rssi_thresh1 +
+			if (bt_rssi >= (rssi_thresh1 +
 					BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
-				btrssi_state = BTC_RSSI_STATE_HIGH;
-			else if (btrssi < rssi_thresh)
-				btrssi_state = BTC_RSSI_STATE_LOW;
+				bt_rssi_state = BTC_RSSI_STATE_HIGH;
+			else if (bt_rssi < rssi_thresh)
+				bt_rssi_state = BTC_RSSI_STATE_LOW;
 			else
-				btrssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
+				bt_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
 		} else {
-			if (btrssi < rssi_thresh1)
-				btrssi_state = BTC_RSSI_STATE_MEDIUM;
+			if (bt_rssi < rssi_thresh1)
+				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
 			else
-				btrssi_state = BTC_RSSI_STATE_STAY_HIGH;
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
+static u8 btc8192e2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
+				       u8 index, u8 level_num, u8 rssi_thresh,
+				       u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	int wifirssi = 0;
-	u8 wifirssi_state = coex_sta->pre_wifi_rssi_state[index];
+	int wifi_rssi = 0;
+	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifirssi);
+	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 
 	if (level_num == 2) {
 		if ((coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifirssi >= (rssi_thresh +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
-				wifirssi_state = BTC_RSSI_STATE_HIGH;
+			if (wifi_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
 			else
-				wifirssi_state = BTC_RSSI_STATE_STAY_LOW;
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else {
-			if (wifirssi < rssi_thresh)
-				wifirssi_state = BTC_RSSI_STATE_LOW;
+			if (wifi_rssi < rssi_thresh)
+				wifi_rssi_state = BTC_RSSI_STATE_LOW;
 			else
-				wifirssi_state = BTC_RSSI_STATE_STAY_HIGH;
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
 		}
 	} else if (level_num == 3) {
 		if (rssi_thresh > rssi_thresh1) {
@@ -157,36 +158,37 @@ static u8 halbtc8192e2ant_wifirssi_state(struct btc_coexist *btcoexist,
 		     BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifirssi >= (rssi_thresh +
-					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
-				wifirssi_state = BTC_RSSI_STATE_MEDIUM;
+			if (wifi_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
+				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
 			else
-				wifirssi_state = BTC_RSSI_STATE_STAY_LOW;
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 		} else if ((coex_sta->pre_wifi_rssi_state[index] ==
 			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_wifi_rssi_state[index] ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
-			if (wifirssi >= (rssi_thresh1 +
+			if (wifi_rssi >= (rssi_thresh1 +
 					 BTC_RSSI_COEX_THRESH_TOL_8192E_2ANT))
-				wifirssi_state = BTC_RSSI_STATE_HIGH;
-			else if (wifirssi < rssi_thresh)
-				wifirssi_state = BTC_RSSI_STATE_LOW;
+				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+			else if (wifi_rssi < rssi_thresh)
+				wifi_rssi_state = BTC_RSSI_STATE_LOW;
 			else
-				wifirssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_MEDIUM;
 		} else {
-			if (wifirssi < rssi_thresh1)
-				wifirssi_state = BTC_RSSI_STATE_MEDIUM;
+			if (wifi_rssi < rssi_thresh1)
+				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
 			else
-				wifirssi_state = BTC_RSSI_STATE_STAY_HIGH;
+				wifi_rssi_state = BTC_RSSI_STATE_STAY_HIGH;
 		}
 	}
 
-	coex_sta->pre_wifi_rssi_state[index] = wifirssi_state;
+	coex_sta->pre_wifi_rssi_state[index] = wifi_rssi_state;
 
-	return wifirssi_state;
+	return wifi_rssi_state;
 }
 
-static void btc8192e2ant_monitor_bt_enable_dis(struct btc_coexist *btcoexist)
+static void btc8192e2ant_monitor_bt_enable_disable(struct btc_coexist
+						   *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static bool pre_bt_disabled;
@@ -236,57 +238,57 @@ static void btc8192e2ant_monitor_bt_enable_dis(struct btc_coexist *btcoexist)
 	}
 }
 
-static u32 halbtc8192e2ant_decidera_mask(struct btc_coexist *btcoexist,
-					 u8 sstype, u32 ra_masktype)
+static u32 btc8192e2ant_decide_ra_mask(struct btc_coexist *btcoexist,
+				       u8 ss_type, u32 ra_mask_type)
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
+static void btc8192e2ant_update_ra_mask(struct btc_coexist *btcoexist,
+					bool force_exec, u32 dis_rate_mask)
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
+static void btc8192e2ant_auto_rate_fallback_retry(struct btc_coexist *btcoexist,
+						  bool force_exec, u8 type)
 {
-	bool wifi_under_bmode = false;
+	bool wifi_under_b_mode = false;
 
-	coex_dm->cur_arfrtype = type;
+	coex_dm->cur_arfr_type = type;
 
-	if (force_exec || (coex_dm->pre_arfrtype != coex_dm->cur_arfrtype)) {
-		switch (coex_dm->cur_arfrtype) {
+	if (force_exec || (coex_dm->pre_arfr_type != coex_dm->cur_arfr_type)) {
+		switch (coex_dm->cur_arfr_type) {
 		case 0:	/* normal mode */
 			btcoexist->btc_write_4byte(btcoexist, 0x430,
 						   coex_dm->backup_arfr_cnt1);
@@ -296,8 +298,8 @@ static void btc8192e2ant_autorate_fallback_retry(struct btc_coexist *btcoexist,
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
@@ -314,46 +316,45 @@ static void btc8192e2ant_autorate_fallback_retry(struct btc_coexist *btcoexist,
 		}
 	}
 
-	coex_dm->pre_arfrtype = coex_dm->cur_arfrtype;
+	coex_dm->pre_arfr_type = coex_dm->cur_arfr_type;
 }
 
-static void halbtc8192e2ant_retrylimit(struct btc_coexist *btcoexist,
-				       bool force_exec, u8 type)
+static void btc8192e2ant_retry_limit(struct btc_coexist *btcoexist,
+				     bool force_exec, u8 type)
 {
-	coex_dm->cur_retrylimit_type = type;
+	coex_dm->cur_retry_limit_type = type;
 
-	if (force_exec || (coex_dm->pre_retrylimit_type !=
-			   coex_dm->cur_retrylimit_type)) {
-		switch (coex_dm->cur_retrylimit_type) {
+	if (force_exec || (coex_dm->pre_retry_limit_type !=
+			   coex_dm->cur_retry_limit_type)) {
+		switch (coex_dm->cur_retry_limit_type) {
 		case 0:	/* normal mode */
-				btcoexist->btc_write_2byte(btcoexist, 0x42a,
-						    coex_dm->backup_retrylimit);
-				break;
+			btcoexist->btc_write_2byte(btcoexist, 0x42a,
+						   coex_dm->backup_retry_limit);
+			break;
 		case 1:	/* retry limit = 8 */
-				btcoexist->btc_write_2byte(btcoexist, 0x42a,
-							   0x0808);
-				break;
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
+static void btc8192e2ant_ampdu_maxtime(struct btc_coexist *btcoexist,
+				       bool force_exec, u8 type)
 {
-	coex_dm->cur_ampdutime_type = type;
+	coex_dm->cur_ampdu_time_type = type;
 
-	if (force_exec || (coex_dm->pre_ampdutime_type !=
-			   coex_dm->cur_ampdutime_type)) {
-		switch (coex_dm->cur_ampdutime_type) {
+	if (force_exec || (coex_dm->pre_ampdu_time_type !=
+			   coex_dm->cur_ampdu_time_type)) {
+		switch (coex_dm->cur_ampdu_time_type) {
 		case 0:	/* normal mode */
 			btcoexist->btc_write_1byte(btcoexist, 0x456,
 						coex_dm->backup_ampdu_maxtime);
 			break;
-		case 1:	/* AMPDU timw = 0x38 * 32us */
+		case 1:	/* AMPDU time = 0x38 * 32us */
 			btcoexist->btc_write_1byte(btcoexist, 0x456, 0x38);
 			break;
 		default:
@@ -361,30 +362,30 @@ static void halbtc8192e2ant_ampdu_maxtime(struct btc_coexist *btcoexist,
 		}
 	}
 
-	coex_dm->pre_ampdutime_type = coex_dm->cur_ampdutime_type;
+	coex_dm->pre_ampdu_time_type = coex_dm->cur_ampdu_time_type;
 }
 
-static void halbtc8192e2ant_limited_tx(struct btc_coexist *btcoexist,
-				       bool force_exec, u8 ra_masktype,
-				       u8 arfr_type, u8 retrylimit_type,
-				       u8 ampdutime_type)
+static void btc8192e2ant_limited_tx(struct btc_coexist *btcoexist,
+				    bool force_exec, u8 ra_mask_type,
+				    u8 arfr_type, u8 retry_limit_type,
+				    u8 ampdu_time_type)
 {
-	u32 disra_mask = 0x0;
+	u32 dis_ra_mask = 0x0;
 
-	coex_dm->curra_masktype = ra_masktype;
-	disra_mask = halbtc8192e2ant_decidera_mask(btcoexist,
-						   coex_dm->cur_sstype,
-						   ra_masktype);
-	halbtc8192e2ant_Updatera_mask(btcoexist, force_exec, disra_mask);
-	btc8192e2ant_autorate_fallback_retry(btcoexist, force_exec, arfr_type);
-	halbtc8192e2ant_retrylimit(btcoexist, force_exec, retrylimit_type);
-	halbtc8192e2ant_ampdu_maxtime(btcoexist, force_exec, ampdutime_type);
+	coex_dm->cur_ra_mask_type = ra_mask_type;
+	dis_ra_mask =
+		 btc8192e2ant_decide_ra_mask(btcoexist, coex_dm->cur_ss_type,
+					     ra_mask_type);
+	btc8192e2ant_update_ra_mask(btcoexist, force_exec, dis_ra_mask);
+	btc8192e2ant_auto_rate_fallback_retry(btcoexist, force_exec, arfr_type);
+	btc8192e2ant_retry_limit(btcoexist, force_exec, retry_limit_type);
+	btc8192e2ant_ampdu_maxtime(btcoexist, force_exec, ampdu_time_type);
 }
 
-static void halbtc8192e2ant_limited_rx(struct btc_coexist *btcoexist,
-				       bool force_exec, bool rej_ap_agg_pkt,
-				       bool bt_ctrl_agg_buf_size,
-				       u8 agg_buf_size)
+static void btc8192e2ant_limited_rx(struct btc_coexist *btcoexist,
+				    bool force_exec, bool rej_ap_agg_pkt,
+				    bool bt_ctrl_agg_buf_size,
+				    u8 agg_buf_size)
 {
 	bool reject_rx_agg = rej_ap_agg_pkt;
 	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
@@ -406,7 +407,7 @@ static void halbtc8192e2ant_limited_rx(struct btc_coexist *btcoexist,
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
 }
 
-static void halbtc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
+static void btc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
@@ -417,11 +418,11 @@ static void halbtc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
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
@@ -439,14 +440,14 @@ static void halbtc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
-static void halbtc8192e2ant_querybt_info(struct btc_coexist *btcoexist)
+static void btc8192e2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
-	h2c_parameter[0] |= BIT0;	/* trigger */
+	h2c_parameter[0] |= BIT0; /* trigger */
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
@@ -455,12 +456,12 @@ static void halbtc8192e2ant_querybt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
+static void btc8192e2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool bt_hson = false;
+	bool bt_hs_on = false;
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
 	bt_link_info->sco_exist = coex_sta->sco_exist;
@@ -469,7 +470,7 @@ static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
 	bt_link_info->hid_exist = coex_sta->hid_exist;
 
 	/* work around for HS mode. */
-	if (bt_hson) {
+	if (bt_hs_on) {
 		bt_link_info->pan_exist = true;
 		bt_link_info->bt_link_exist = true;
 	}
@@ -511,16 +512,16 @@ static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
 		bt_link_info->hid_only = false;
 }
 
-static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
+static u8 btc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-	bool bt_hson = false;
+	bool bt_hs_on = false;
 	u8 algorithm = BT_8192E_2ANT_COEX_ALGO_UNDEFINED;
-	u8 numdiffprofile = 0;
+	u8 num_of_diff_profile = 0;
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
 	if (!bt_link_info->bt_link_exist) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -529,15 +530,15 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
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
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "SCO only\n");
@@ -552,7 +553,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 					 "A2DP only\n");
 				algorithm = BT_8192E_2ANT_COEX_ALGO_A2DP;
 			} else if (bt_link_info->pan_exist) {
-				if (bt_hson) {
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "PAN(HS) only\n");
@@ -567,7 +568,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 				}
 			}
 		}
-	} else if (numdiffprofile == 2) {
+	} else if (num_of_diff_profile == 2) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -578,7 +579,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 					 "SCO + A2DP ==> SCO\n");
 				algorithm = BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->pan_exist) {
-				if (bt_hson) {
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "SCO + PAN(HS)\n");
@@ -609,7 +610,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 				}
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
-				if (bt_hson) {
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "HID + PAN(HS)\n");
@@ -623,7 +624,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
-				if (bt_hson) {
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "A2DP + PAN(HS)\n");
@@ -638,7 +639,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 				}
 			}
 		}
-	} else if (numdiffprofile == 3) {
+	} else if (num_of_diff_profile == 3) {
 		if (bt_link_info->sco_exist) {
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->a2dp_exist) {
@@ -647,7 +648,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 				algorithm = BT_8192E_2ANT_COEX_ALGO_PANEDR_HID;
 			} else if (bt_link_info->hid_exist &&
 				   bt_link_info->pan_exist) {
-				if (bt_hson) {
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "SCO + HID + PAN(HS)\n");
@@ -661,7 +662,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 				}
 			} else if (bt_link_info->pan_exist &&
 				   bt_link_info->a2dp_exist) {
-				if (bt_hson) {
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "SCO + A2DP + PAN(HS)\n");
@@ -678,7 +679,7 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 			if (bt_link_info->hid_exist &&
 			    bt_link_info->pan_exist &&
 			    bt_link_info->a2dp_exist) {
-				if (bt_hson) {
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "HID + A2DP + PAN(HS)\n");
@@ -693,12 +694,12 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
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
+				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
 						 "ErrorSCO+HID+A2DP+PAN(HS)\n");
@@ -717,8 +718,8 @@ static u8 halbtc8192e2ant_action_algorithm(struct btc_coexist *btcoexist)
 	return algorithm;
 }
 
-static void halbtc8192e2ant_setfw_dac_swinglevel(struct btc_coexist *btcoexist,
-						 u8 dac_swinglvl)
+static void btc8192e2ant_set_fw_dac_swing_level(struct btc_coexist *btcoexist,
+						u8 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
@@ -726,81 +727,81 @@ static void halbtc8192e2ant_setfw_dac_swinglevel(struct btc_coexist *btcoexist,
 	/* There are several type of dacswing
 	 * 0x18/ 0x10/ 0xc/ 0x8/ 0x4/ 0x6
 	 */
-	h2c_parameter[0] = dac_swinglvl;
+	h2c_parameter[0] = dac_swing_lvl;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], Set Dac Swing Level = 0x%x\n", dac_swinglvl);
+		 "[BTCoex], Set Dac Swing Level = 0x%x\n", dac_swing_lvl);
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], FW write 0x64 = 0x%x\n", h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x64, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_set_fwdec_btpwr(struct btc_coexist *btcoexist,
-					    u8 dec_btpwr_lvl)
+static void btc8192e2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
+					   u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
-	h2c_parameter[0] = dec_btpwr_lvl;
+	h2c_parameter[0] = dec_bt_pwr_lvl;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex] decrease Bt Power level = %d, FW write 0x62 = 0x%x\n",
-		 dec_btpwr_lvl, h2c_parameter[0]);
+		 dec_bt_pwr_lvl, h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_dec_btpwr(struct btc_coexist *btcoexist,
-				      bool force_exec, u8 dec_btpwr_lvl)
+static void btc8192e2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
+				    bool force_exec, u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s Dec BT power level = %d\n",
-		 force_exec ? "force to" : "", dec_btpwr_lvl);
-	coex_dm->cur_dec_bt_pwr = dec_btpwr_lvl;
+		 force_exec ? "force to" : "", dec_bt_pwr_lvl);
+	coex_dm->cur_dec_bt_pwr = dec_bt_pwr_lvl;
 
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], preBtDecPwrLvl=%d, curBtDecPwrLvl=%d\n",
 			 coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
 	}
-	halbtc8192e2ant_set_fwdec_btpwr(btcoexist, coex_dm->cur_dec_bt_pwr);
+	btc8192e2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr);
 
 	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
 }
 
-static void halbtc8192e2ant_set_bt_autoreport(struct btc_coexist *btcoexist,
-					      bool enable_autoreport)
+static void btc8192e2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
+					    bool enable_auto_report)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	h2c_parameter[0] = 0;
 
-	if (enable_autoreport)
+	if (enable_auto_report)
 		h2c_parameter[0] |= BIT0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		 (enable_autoreport ? "Enabled!!" : "Disabled!!"),
+		 (enable_auto_report ? "Enabled!!" : "Disabled!!"),
 		 h2c_parameter[0]);
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_bt_autoreport(struct btc_coexist *btcoexist,
-					  bool force_exec,
-					  bool enable_autoreport)
+static void btc8192e2ant_bt_auto_report(struct btc_coexist *btcoexist,
+					bool force_exec,
+					bool enable_auto_report)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s BT Auto report = %s\n",
 		 (force_exec ? "force to" : ""),
-		 ((enable_autoreport) ? "Enabled" : "Disabled"));
-	coex_dm->cur_bt_auto_report = enable_autoreport;
+		 ((enable_auto_report) ? "Enabled" : "Disabled"));
+	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -811,21 +812,21 @@ static void halbtc8192e2ant_bt_autoreport(struct btc_coexist *btcoexist,
 		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
 			return;
 	}
-	halbtc8192e2ant_set_bt_autoreport(btcoexist,
-					  coex_dm->cur_bt_auto_report);
+	btc8192e2ant_set_bt_auto_report(btcoexist,
+					coex_dm->cur_bt_auto_report);
 
 	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
 }
 
-static void halbtc8192e2ant_fw_dac_swinglvl(struct btc_coexist *btcoexist,
-					    bool force_exec, u8 fw_dac_swinglvl)
+static void btc8192e2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
+					  bool force_exec, u8 fw_dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s set FW Dac Swing level = %d\n",
-		 (force_exec ? "force to" : ""), fw_dac_swinglvl);
-	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swinglvl;
+		 (force_exec ? "force to" : ""), fw_dac_swing_lvl);
+	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -838,8 +839,8 @@ static void halbtc8192e2ant_fw_dac_swinglvl(struct btc_coexist *btcoexist,
 			return;
 	}
 
-	halbtc8192e2ant_setfw_dac_swinglevel(btcoexist,
-					     coex_dm->cur_fw_dac_swing_lvl);
+	btc8192e2ant_set_fw_dac_swing_level(btcoexist,
+					    coex_dm->cur_fw_dac_swing_lvl);
 
 	coex_dm->pre_fw_dac_swing_lvl = coex_dm->cur_fw_dac_swing_lvl;
 }
@@ -869,8 +870,8 @@ static void btc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
-				      bool force_exec, bool rx_rf_shrink_on)
+static void btc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
+				   bool force_exec, bool rx_rf_shrink_on)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -896,8 +897,8 @@ static void halbtc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
 	coex_dm->pre_rf_rx_lpf_shrink = coex_dm->cur_rf_rx_lpf_shrink;
 }
 
-static void halbtc8192e2ant_set_dac_swingreg(struct btc_coexist *btcoexist,
-					     u32 level)
+static void btc8192e2ant_set_dac_swing_reg(struct btc_coexist *btcoexist,
+					   u32 level)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 val = (u8)level;
@@ -907,28 +908,28 @@ static void halbtc8192e2ant_set_dac_swingreg(struct btc_coexist *btcoexist,
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x883, 0x3e, val);
 }
 
-static void btc8192e2ant_setsw_full_swing(struct btc_coexist *btcoexist,
-					  bool sw_dac_swingon,
-					  u32 sw_dac_swinglvl)
+static void btc8192e2ant_set_sw_full_swing(struct btc_coexist *btcoexist,
+					   bool sw_dac_swing_on,
+					   u32 sw_dac_swing_lvl)
 {
-	if (sw_dac_swingon)
-		halbtc8192e2ant_set_dac_swingreg(btcoexist, sw_dac_swinglvl);
+	if (sw_dac_swing_on)
+		btc8192e2ant_set_dac_swing_reg(btcoexist, sw_dac_swing_lvl);
 	else
-		halbtc8192e2ant_set_dac_swingreg(btcoexist, 0x18);
+		btc8192e2ant_set_dac_swing_reg(btcoexist, 0x18);
 }
 
-static void halbtc8192e2ant_DacSwing(struct btc_coexist *btcoexist,
-				     bool force_exec, bool dac_swingon,
-				     u32 dac_swinglvl)
+static void btc8192e2ant_dac_swing(struct btc_coexist *btcoexist,
+				   bool force_exec, bool dac_swing_on,
+				   u32 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s turn DacSwing=%s, dac_swinglvl = 0x%x\n",
+		 "[BTCoex], %s turn DacSwing=%s, dac_swing_lvl = 0x%x\n",
 		 (force_exec ? "force to" : ""),
-		 ((dac_swingon) ? "ON" : "OFF"), dac_swinglvl);
-	coex_dm->cur_dac_swing_on = dac_swingon;
-	coex_dm->cur_dac_swing_lvl = dac_swinglvl;
+		 ((dac_swing_on) ? "ON" : "OFF"), dac_swing_lvl);
+	coex_dm->cur_dac_swing_on = dac_swing_on;
+	coex_dm->cur_dac_swing_lvl = dac_swing_lvl;
 
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -945,14 +946,14 @@ static void halbtc8192e2ant_DacSwing(struct btc_coexist *btcoexist,
 			return;
 	}
 	mdelay(30);
-	btc8192e2ant_setsw_full_swing(btcoexist, dac_swingon, dac_swinglvl);
+	btc8192e2ant_set_sw_full_swing(btcoexist, dac_swing_on, dac_swing_lvl);
 
 	coex_dm->pre_dac_swing_on = coex_dm->cur_dac_swing_on;
 	coex_dm->pre_dac_swing_lvl = coex_dm->cur_dac_swing_lvl;
 }
 
-static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
-					  bool agc_table_en)
+static void btc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
+				       bool agc_table_en)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -978,8 +979,8 @@ static void halbtc8192e2ant_set_agc_table(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8192e2ant_AgcTable(struct btc_coexist *btcoexist,
-				     bool force_exec, bool agc_table_en)
+static void btc8192e2ant_agc_table(struct btc_coexist *btcoexist,
+				   bool force_exec, bool agc_table_en)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -998,14 +999,14 @@ static void halbtc8192e2ant_AgcTable(struct btc_coexist *btcoexist,
 		if (coex_dm->pre_agc_table_en == coex_dm->cur_agc_table_en)
 			return;
 	}
-	halbtc8192e2ant_set_agc_table(btcoexist, agc_table_en);
+	btc8192e2ant_set_agc_table(btcoexist, agc_table_en);
 
 	coex_dm->pre_agc_table_en = coex_dm->cur_agc_table_en;
 }
 
-static void halbtc8192e2ant_set_coex_table(struct btc_coexist *btcoexist,
-					   u32 val0x6c0, u32 val0x6c4,
-					   u32 val0x6c8, u8 val0x6cc)
+static void btc8192e2ant_set_coex_table(struct btc_coexist *btcoexist,
+					u32 val0x6c0, u32 val0x6c4,
+					u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -1026,10 +1027,9 @@ static void halbtc8192e2ant_set_coex_table(struct btc_coexist *btcoexist,
 	btcoexist->btc_write_1byte(btcoexist, 0x6cc, val0x6cc);
 }
 
-static void halbtc8192e2ant_coex_table(struct btc_coexist *btcoexist,
-				       bool force_exec,
-				       u32 val0x6c0, u32 val0x6c4,
-				       u32 val0x6c8, u8 val0x6cc)
+static void btc8192e2ant_coex_table(struct btc_coexist *btcoexist,
+				    bool force_exec, u32 val0x6c0, u32 val0x6c4,
+				    u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -1064,8 +1064,8 @@ static void halbtc8192e2ant_coex_table(struct btc_coexist *btcoexist,
 		    (coex_dm->pre_val0x6cc == coex_dm->cur_val0x6cc))
 			return;
 	}
-	halbtc8192e2ant_set_coex_table(btcoexist, val0x6c0, val0x6c4,
-				       val0x6c8, val0x6cc);
+	btc8192e2ant_set_coex_table(btcoexist, val0x6c0, val0x6c4, val0x6c8,
+				    val0x6cc);
 
 	coex_dm->pre_val0x6c0 = coex_dm->cur_val0x6c0;
 	coex_dm->pre_val0x6c4 = coex_dm->cur_val0x6c4;
@@ -1073,37 +1073,37 @@ static void halbtc8192e2ant_coex_table(struct btc_coexist *btcoexist,
 	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
 }
 
-static void btc8192e2ant_coex_tbl_w_type(struct btc_coexist *btcoexist,
-					 bool force_exec, u8 type)
+static void btc8192e2ant_coex_table_with_type(struct btc_coexist *btcoexist,
+					      bool force_exec, u8 type)
 {
 	switch (type) {
 	case 0:
-		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0x55555555,
-					   0x5a5a5a5a, 0xffffff, 0x3);
+		btc8192e2ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 1:
-		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
-					   0x5a5a5a5a, 0xffffff, 0x3);
+		btc8192e2ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
+					0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 2:
-		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0x55555555,
-					   0x5ffb5ffb, 0xffffff, 0x3);
+		btc8192e2ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0x5ffb5ffb, 0xffffff, 0x3);
 		break;
 	case 3:
-		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0xdfffdfff,
-					   0x5fdb5fdb, 0xffffff, 0x3);
+		btc8192e2ant_coex_table(btcoexist, force_exec, 0xdfffdfff,
+					0x5fdb5fdb, 0xffffff, 0x3);
 		break;
 	case 4:
-		halbtc8192e2ant_coex_table(btcoexist, force_exec, 0xdfffdfff,
-					   0x5ffb5ffb, 0xffffff, 0x3);
+		btc8192e2ant_coex_table(btcoexist, force_exec, 0xdfffdfff,
+					0x5ffb5ffb, 0xffffff, 0x3);
 		break;
 	default:
 		break;
 	}
 }
 
-static void halbtc8192e2ant_set_fw_ignore_wlanact(struct btc_coexist *btcoexist,
-						  bool enable)
+static void btc8192e2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
+						bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
@@ -1118,8 +1118,8 @@ static void halbtc8192e2ant_set_fw_ignore_wlanact(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
 
-static void halbtc8192e2ant_IgnoreWlanAct(struct btc_coexist *btcoexist,
-					  bool force_exec, bool enable)
+static void btc8192e2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
+					 bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -1140,12 +1140,12 @@ static void halbtc8192e2ant_IgnoreWlanAct(struct btc_coexist *btcoexist,
 		    coex_dm->cur_ignore_wlan_act)
 			return;
 	}
-	halbtc8192e2ant_set_fw_ignore_wlanact(btcoexist, enable);
+	btc8192e2ant_set_fw_ignore_wlan_act(btcoexist, enable);
 
 	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
 }
 
-static void halbtc8192e2ant_SetFwPstdma(struct btc_coexist *btcoexist, u8 byte1,
+static void btc8192e2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -1173,24 +1173,24 @@ static void halbtc8192e2ant_SetFwPstdma(struct btc_coexist *btcoexist, u8 byte1,
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
-static void btc8192e2ant_sw_mec1(struct btc_coexist *btcoexist,
-				 bool shrink_rx_lpf, bool low_penalty_ra,
-				 bool limited_dig, bool btlan_constrain)
+static void btc8192e2ant_sw_mechanism1(struct btc_coexist *btcoexist,
+				       bool shrink_rx_lpf, bool low_penalty_ra,
+				       bool limited_dig, bool btlan_constrain)
 {
-	halbtc8192e2ant_rf_shrink(btcoexist, NORMAL_EXEC, shrink_rx_lpf);
+	btc8192e2ant_rf_shrink(btcoexist, NORMAL_EXEC, shrink_rx_lpf);
 }
 
-static void btc8192e2ant_sw_mec2(struct btc_coexist *btcoexist,
-				 bool agc_table_shift, bool adc_backoff,
-				 bool sw_dac_swing, u32 dac_swinglvl)
+static void btc8192e2ant_sw_mechanism2(struct btc_coexist *btcoexist,
+				       bool agc_table_shift, bool adc_backoff,
+				       bool sw_dac_swing, u32 dac_swing_lvl)
 {
-	halbtc8192e2ant_AgcTable(btcoexist, NORMAL_EXEC, agc_table_shift);
-	halbtc8192e2ant_DacSwing(btcoexist, NORMAL_EXEC, sw_dac_swing,
-				 dac_swinglvl);
+	btc8192e2ant_agc_table(btcoexist, NORMAL_EXEC, agc_table_shift);
+	btc8192e2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
+			       dac_swing_lvl);
 }
 
-static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
-				    bool force_exec, bool turn_on, u8 type)
+static void btc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
+				 bool force_exec, bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -1217,91 +1217,91 @@ static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 		switch (type) {
 		case 1:
 		default:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
 						    0x1a, 0xe1, 0x90);
 			break;
 		case 2:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
 						    0x12, 0xe1, 0x90);
 			break;
 		case 3:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
 						    0x3, 0xf1, 0x90);
 			break;
 		case 4:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x10,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
 						    0x3, 0xf1, 0x90);
 			break;
 		case 5:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
 						    0x1a, 0x60, 0x90);
 			break;
 		case 6:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
 						    0x12, 0x60, 0x90);
 			break;
 		case 7:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
 						    0x3, 0x70, 0x90);
 			break;
 		case 8:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xa3, 0x10,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x10,
 						    0x3, 0x70, 0x90);
 			break;
 		case 9:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
 						    0x1a, 0xe1, 0x10);
 			break;
 		case 10:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
 						    0x12, 0xe1, 0x10);
 			break;
 		case 11:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
 						    0x3, 0xf1, 0x10);
 			break;
 		case 12:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x10,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
 						    0x3, 0xf1, 0x10);
 			break;
 		case 13:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
 						    0x1a, 0xe0, 0x10);
 			break;
 		case 14:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
 						    0x12, 0xe0, 0x10);
 			break;
 		case 15:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1c,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
 						    0x3, 0xf0, 0x10);
 			break;
 		case 16:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x12,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
 						    0x3, 0xf0, 0x10);
 			break;
 		case 17:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0x61, 0x20,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0x61, 0x20,
 						    0x03, 0x10, 0x10);
 			break;
 		case 18:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x5,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
 						    0x5, 0xe1, 0x90);
 			break;
 		case 19:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x25,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
 						    0x25, 0xe1, 0x90);
 			break;
 		case 20:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x25,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
 						    0x25, 0x60, 0x90);
 			break;
 		case 21:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x15,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x15,
 						    0x03, 0x70, 0x90);
 			break;
 		case 71:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0xe3, 0x1a,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
 						    0x1a, 0xe1, 0x90);
 			break;
 		}
@@ -1310,12 +1310,12 @@ static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 		switch (type) {
 		default:
 		case 0:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0x8, 0x0, 0x0,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0x8, 0x0, 0x0,
 						    0x0, 0x0);
 			btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x4);
 			break;
 		case 1:
-			halbtc8192e2ant_SetFwPstdma(btcoexist, 0x0, 0x0, 0x0,
+			btc8192e2ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0, 0x0,
 						    0x8, 0x0);
 			mdelay(5);
 			btcoexist->btc_write_1byte(btcoexist, 0x92c, 0x20);
@@ -1328,22 +1328,22 @@ static void halbtc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static void halbtc8192e2ant_set_switch_sstype(struct btc_coexist *btcoexist,
-					      u8 sstype)
+static void btc8192e2ant_set_switch_ss_type(struct btc_coexist *btcoexist,
+					    u8 ss_type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 mimops = BTC_MIMO_PS_DYNAMIC;
-	u32 disra_mask = 0x0;
+	u32 dis_ra_mask = 0x0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], REAL set SS Type = %d\n", sstype);
+		 "[BTCoex], REAL set SS Type = %d\n", ss_type);
 
-	disra_mask = halbtc8192e2ant_decidera_mask(btcoexist, sstype,
-						   coex_dm->curra_masktype);
-	halbtc8192e2ant_Updatera_mask(btcoexist, FORCE_EXEC, disra_mask);
+	dis_ra_mask = btc8192e2ant_decide_ra_mask(btcoexist, ss_type,
+						  coex_dm->cur_ra_mask_type);
+	btc8192e2ant_update_ra_mask(btcoexist, FORCE_EXEC, dis_ra_mask);
 
-	if (sstype == 1) {
-		halbtc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
+	if (ss_type == 1) {
+		btc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
 		/* switch ofdm path */
 		btcoexist->btc_write_1byte(btcoexist, 0xc04, 0x11);
 		btcoexist->btc_write_1byte(btcoexist, 0xd04, 0x1);
@@ -1352,8 +1352,8 @@ static void halbtc8192e2ant_set_switch_sstype(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_1byte_bitmask(btcoexist, 0xe77, 0x4, 0x1);
 		btcoexist->btc_write_1byte(btcoexist, 0xa07, 0x81);
 		mimops = BTC_MIMO_PS_STATIC;
-	} else if (sstype == 2) {
-		halbtc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
+	} else if (ss_type == 2) {
+		btc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
 		btcoexist->btc_write_1byte(btcoexist, 0xc04, 0x33);
 		btcoexist->btc_write_1byte(btcoexist, 0xd04, 0x3);
 		btcoexist->btc_write_4byte(btcoexist, 0x90c, 0x81121313);
@@ -1365,89 +1365,89 @@ static void halbtc8192e2ant_set_switch_sstype(struct btc_coexist *btcoexist,
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_SEND_MIMO_PS, &mimops);
 }
 
-static void halbtc8192e2ant_switch_sstype(struct btc_coexist *btcoexist,
-					  bool force_exec, u8 new_sstype)
+static void btc8192e2ant_switch_ss_type(struct btc_coexist *btcoexist,
+					bool force_exec, u8 new_ss_type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s Switch SS Type = %d\n",
-		 (force_exec ? "force to" : ""), new_sstype);
-	coex_dm->cur_sstype = new_sstype;
+		 (force_exec ? "force to" : ""), new_ss_type);
+	coex_dm->cur_ss_type = new_ss_type;
 
 	if (!force_exec) {
-		if (coex_dm->pre_sstype == coex_dm->cur_sstype)
+		if (coex_dm->pre_ss_type == coex_dm->cur_ss_type)
 			return;
 	}
-	halbtc8192e2ant_set_switch_sstype(btcoexist, coex_dm->cur_sstype);
+	btc8192e2ant_set_switch_ss_type(btcoexist, coex_dm->cur_ss_type);
 
-	coex_dm->pre_sstype = coex_dm->cur_sstype;
+	coex_dm->pre_ss_type = coex_dm->cur_ss_type;
 }
 
-static void halbtc8192e2ant_coex_alloff(struct btc_coexist *btcoexist)
+static void btc8192e2ant_coex_all_off(struct btc_coexist *btcoexist)
 {
 	/* fw all off */
-	halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-	halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	/* sw all off */
-	btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-	btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+	btc8192e2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8192e2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
 	/* hw all off */
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 0);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
-static void halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
+static void btc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	/* force to reset coex mechanism */
 
-	halbtc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, FORCE_EXEC, 6);
-	halbtc8192e2ant_dec_btpwr(btcoexist, FORCE_EXEC, 0);
+	btc8192e2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
+	btc8192e2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, 0);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, FORCE_EXEC, 0);
-	halbtc8192e2ant_switch_sstype(btcoexist, FORCE_EXEC, 2);
+	btc8192e2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
+	btc8192e2ant_switch_ss_type(btcoexist, FORCE_EXEC, 2);
 
-	btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-	btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+	btc8192e2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8192e2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
-static void halbtc8192e2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	bool low_pwr_disable = true;
 
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 			   &low_pwr_disable);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
-	halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-	halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-	btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+	btc8192e2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8192e2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
-static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
+static bool btc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool common = false, wifi_connected = false, wifi_busy = false;
-	bool bt_hson = false, low_pwr_disable = false;
+	bool bt_hs_on = false, low_pwr_disable = false;
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 
 	if (bt_link_info->sco_exist || bt_link_info->hid_exist)
-		halbtc8192e2ant_limited_tx(btcoexist, NORMAL_EXEC, 1, 0, 0, 0);
+		btc8192e2ant_limited_tx(btcoexist, NORMAL_EXEC, 1, 0, 0, 0);
 	else
-		halbtc8192e2ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		btc8192e2ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
 
 	if (!wifi_connected) {
 		low_pwr_disable = false;
@@ -1461,26 +1461,24 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 		     coex_dm->bt_status) ||
 		    (BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE ==
 		     coex_dm->bt_status)) {
-			halbtc8192e2ant_switch_sstype(btcoexist,
-						      NORMAL_EXEC, 2);
-			btc8192e2ant_coex_tbl_w_type(btcoexist,
-						     NORMAL_EXEC, 1);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0);
+			btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 2);
+			btc8192e2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
+			btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 		} else {
-			halbtc8192e2ant_switch_sstype(btcoexist,
-						      NORMAL_EXEC, 1);
-			btc8192e2ant_coex_tbl_w_type(btcoexist,
-						     NORMAL_EXEC, 0);
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
+			btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+			btc8192e2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 0);
+			btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 		}
 
-		halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-		btc8192e2ant_sw_mec1(btcoexist, false, false, false, false);
-		btc8192e2ant_sw_mec2(btcoexist, false, false, false, 0x18);
+		btc8192e2ant_sw_mechanism1(btcoexist, false, false, false,
+					   false);
+		btc8192e2ant_sw_mechanism2(btcoexist, false, false, false,
+					   0x18);
 
 		common = true;
 	} else {
@@ -1494,20 +1492,18 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Wifi connected + BT non connected-idle!!\n");
 
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
+			btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 2);
+			btc8192e2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
+			btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
+			btc8192e2ant_fw_dac_swing_lvl(btcoexist,
+						      NORMAL_EXEC, 6);
+			btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 
 			common = true;
 		} else if (BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE ==
@@ -1517,25 +1513,25 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 					   BTC_SET_ACT_DISABLE_LOW_POWER,
 					   &low_pwr_disable);
 
-			if (bt_hson)
+			if (bt_hs_on)
 				return false;
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Wifi connected + BT connected-idle!!\n");
 
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
+			btc8192e2ant_switch_ss_type(btcoexist,
+						    NORMAL_EXEC, 2);
+			btc8192e2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
+			btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     false, 0);
+			btc8192e2ant_fw_dac_swing_lvl(btcoexist,
+						      NORMAL_EXEC, 6);
+			btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 
 			common = true;
 		} else {
@@ -1552,20 +1548,21 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "Wifi Connected-Idle + BT Busy!!\n");
 
-				halbtc8192e2ant_switch_sstype(btcoexist,
-							      NORMAL_EXEC, 1);
-				btc8192e2ant_coex_tbl_w_type(btcoexist,
-							     NORMAL_EXEC, 2);
-				halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 21);
-				halbtc8192e2ant_fw_dac_swinglvl(btcoexist,
-								NORMAL_EXEC, 6);
-				halbtc8192e2ant_dec_btpwr(btcoexist,
-							  NORMAL_EXEC, 0);
-				btc8192e2ant_sw_mec1(btcoexist, false,
-						     false, false, false);
-				btc8192e2ant_sw_mec2(btcoexist, false,
-						     false, false, 0x18);
+				btc8192e2ant_switch_ss_type(btcoexist,
+							    NORMAL_EXEC, 1);
+				btc8192e2ant_coex_table_with_type(btcoexist,
+								  NORMAL_EXEC,
+								  2);
+				btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						     true, 21);
+				btc8192e2ant_fw_dac_swing_lvl(btcoexist,
+							      NORMAL_EXEC, 6);
+				btc8192e2ant_dec_bt_pwr(btcoexist,
+							NORMAL_EXEC, 0);
+				btc8192e2ant_sw_mechanism1(btcoexist, false,
+							   false, false, false);
+				btc8192e2ant_sw_mechanism2(btcoexist, false,
+							   false, false, 0x18);
 				common = true;
 			}
 		}
@@ -1573,9 +1570,9 @@ static bool halbtc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 	return common;
 }
 
-static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
-						 bool sco_hid, bool tx_pause,
-						 u8 max_interval)
+static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
+					      bool sco_hid, bool tx_pause,
+					      u8 max_interval)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static int up, dn, m, n, wait_cnt;
@@ -1595,72 +1592,72 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 		if (sco_hid) {
 			if (tx_pause) {
 				if (max_interval == 1) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 13);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 13);
 					coex_dm->tdma_adj_type = 13;
 				} else if (max_interval == 2) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 14);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 14);
 					coex_dm->tdma_adj_type = 14;
 				} else {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 15);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
 					coex_dm->tdma_adj_type = 15;
 				}
 			} else {
 				if (max_interval == 1) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 9);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 9);
 					coex_dm->tdma_adj_type = 9;
 				} else if (max_interval == 2) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 10);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 10);
 					coex_dm->tdma_adj_type = 10;
 				} else {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 11);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 11);
 					coex_dm->tdma_adj_type = 11;
 				}
 			}
 		} else {
 			if (tx_pause) {
 				if (max_interval == 1) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 5);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 5);
 					coex_dm->tdma_adj_type = 5;
 				} else if (max_interval == 2) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 6);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 6);
 					coex_dm->tdma_adj_type = 6;
 				} else {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 7);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
 					coex_dm->tdma_adj_type = 7;
 				}
 			} else {
 				if (max_interval == 1) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 1);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 1);
 					coex_dm->tdma_adj_type = 1;
 				} else if (max_interval == 2) {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 2);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 2);
 					coex_dm->tdma_adj_type = 2;
 				} else {
-					halbtc8192e2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 3);
+					btc8192e2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
 					coex_dm->tdma_adj_type = 3;
 				}
 			}
@@ -1763,9 +1760,8 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 
 		if (!scan && !link && !roam)
-			halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true,
-						coex_dm->tdma_adj_type);
+			btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, coex_dm->tdma_adj_type);
 		else
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
@@ -1773,583 +1769,578 @@ static void halbtc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 }
 
 /* SCO only or SCO+PAN(HS) */
-static void halbtc8192e2ant_action_sco(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_sco(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_STAY_LOW;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 4);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
 
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
 	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x6);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x6);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x6);
 		}
 	}
 }
 
-static void halbtc8192e2ant_action_sco_pan(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_sco_pan(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_STAY_LOW;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_STAY_LOW;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 4);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 4);
 
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
 	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x6);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x6);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x6);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x6);
 		}
 	}
 }
 
-static void halbtc8192e2ant_action_hid(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_hid(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
 	}
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
-static void halbtc8192e2ant_action_a2dp(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 	bool long_dist = false;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW ||
-	     btrssi_state == BTC_RSSI_STATE_STAY_LOW) &&
-	    (wifirssi_state == BTC_RSSI_STATE_LOW ||
-	     wifirssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW ||
+	     bt_rssi_state == BTC_RSSI_STATE_STAY_LOW) &&
+	    (wifi_rssi_state == BTC_RSSI_STATE_LOW ||
+	     wifi_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], A2dp, wifi/bt rssi both LOW!!\n");
 		long_dist = true;
 	}
 	if (long_dist) {
-		halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, true,
-					   0x4);
+		btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, true,
+					0x4);
 	} else {
-		halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-		halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
-					   0x8);
+		btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+		btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
+					0x8);
 	}
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (long_dist)
-		btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 	else
-		btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
 	if (long_dist) {
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 17);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 17);
 		coex_dm->auto_tdma_adjust = false;
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 	} else {
-		if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-		    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
-							     true, 1);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-			   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-			halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
-							     false, 1);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-			   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8192e2ant_tdma_duration_adjust(btcoexist, false,
-							     false, 1);
-			halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+		if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+			btc8192e2ant_tdma_duration_adjust(btcoexist, false,
+							  true, 1);
+			btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+			   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+			btc8192e2ant_tdma_duration_adjust(btcoexist, false,
+							  false, 1);
+			btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+			   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_tdma_duration_adjust(btcoexist, false,
+							  false, 1);
+			btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 		}
 	}
 
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8192e2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, true, 2);
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
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_tdma_duration_adjust(btcoexist, false, true, 2);
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_tdma_duration_adjust(btcoexist, false, false, 2);
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_tdma_duration_adjust(btcoexist, false, false, 2);
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 	}
 
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     true, 0x6);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   true, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     true, 0x6);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   true, 0x6);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   true, 0x6);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     true, 0x6);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   true, 0x6);
 		}
 	}
 }
 
-static void halbtc8192e2ant_action_pan_edr(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 1);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 1);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 1);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 1);
 	}
 
 	/* sw mechanism */
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
 /* PAN(HS) only */
-static void halbtc8192e2ant_action_pan_hs(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
 	}
-	halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
 /* PAN(EDR)+A2DP */
-static void halbtc8192e2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 2);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, false, true, 3);
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
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, false, true, 3);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, false, false, 3);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, false, false, 3);
 	}
 
 	/* sw mechanism	*/
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, false,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8192e2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
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
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+				     true, 10);
 	}
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
@@ -2357,125 +2348,125 @@ static void halbtc8192e2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 /* HID+A2DP+PAN(EDR) */
 static void btc8192e2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	halbtc8192e2ant_fw_dac_swinglvl(btcoexist, NORMAL_EXEC, 6);
+	btc8192e2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, true, 3);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 3);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 3);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, true, true, 3);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 3);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 3);
 	}
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8192e2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
+static void btc8192e2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifirssi_state, btrssi_state = BTC_RSSI_STATE_HIGH;
+	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 
-	wifirssi_state = halbtc8192e2ant_wifirssi_state(btcoexist, 0, 2, 15, 0);
-	btrssi_state = halbtc8192e2ant_btrssi_state(btcoexist, 3, 34, 42);
+	wifi_rssi_state = btc8192e2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8192e2ant_bt_rssi_state(btcoexist, 3, 34, 42);
 
-	halbtc8192e2ant_switch_sstype(btcoexist, NORMAL_EXEC, 1);
-	halbtc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+	btc8192e2ant_switch_ss_type(btcoexist, NORMAL_EXEC, 1);
+	btc8192e2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, NORMAL_EXEC, 3);
+	btc8192e2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 3);
 
-	if ((btrssi_state == BTC_RSSI_STATE_LOW) ||
-	    (btrssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 0);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, true, 2);
-	} else if ((btrssi_state == BTC_RSSI_STATE_MEDIUM) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_MEDIUM))	{
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 2);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 2);
-	} else if ((btrssi_state == BTC_RSSI_STATE_HIGH) ||
-		   (btrssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		halbtc8192e2ant_dec_btpwr(btcoexist, NORMAL_EXEC, 4);
-		halbtc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 2);
+	if ((bt_rssi_state == BTC_RSSI_STATE_LOW) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, true, true, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_MEDIUM) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_MEDIUM))	{
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 2);
+	} else if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		   (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		btc8192e2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 4);
+		btc8192e2ant_tdma_duration_adjust(btcoexist, true, false, 2);
 	}
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		if ((wifirssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifirssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, true, false,
-					     false, 0x18);
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, true, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
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
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8192e2ant_sw_mec1(btcoexist, false, true,
-					     false, false);
-			btc8192e2ant_sw_mec2(btcoexist, false, false,
-					     false, 0x18);
+			btc8192e2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8192e2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
+static void btc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 algorithm = 0;
@@ -2495,12 +2486,12 @@ static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		return;
 	}
 
-	algorithm = halbtc8192e2ant_action_algorithm(btcoexist);
+	algorithm = btc8192e2ant_action_algorithm(btcoexist);
 	if (coex_sta->c2h_bt_inquiry_page &&
 	    (BT_8192E_2ANT_COEX_ALGO_PANHS != algorithm)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BT is under inquiry/page scan !!\n");
-		halbtc8192e2ant_action_bt_inquiry(btcoexist);
+		btc8192e2ant_action_bt_inquiry(btcoexist);
 		return;
 	}
 
@@ -2508,7 +2499,7 @@ static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Algorithm = %d\n", coex_dm->cur_algorithm);
 
-	if (halbtc8192e2ant_is_common_action(btcoexist)) {
+	if (btc8192e2ant_is_common_action(btcoexist)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Action 2-Ant common\n");
 		coex_dm->auto_tdma_adjust = false;
@@ -2524,47 +2515,47 @@ static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		case BT_8192E_2ANT_COEX_ALGO_SCO:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = SCO\n");
-			halbtc8192e2ant_action_sco(btcoexist);
+			btc8192e2ant_action_sco(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_SCO_PAN:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = SCO+PAN(EDR)\n");
-			halbtc8192e2ant_action_sco_pan(btcoexist);
+			btc8192e2ant_action_sco_pan(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = HID\n");
-			halbtc8192e2ant_action_hid(btcoexist);
+			btc8192e2ant_action_hid(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = A2DP\n");
-			halbtc8192e2ant_action_a2dp(btcoexist);
+			btc8192e2ant_action_a2dp(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_A2DP_PANHS:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
-			halbtc8192e2ant_action_a2dp_pan_hs(btcoexist);
+			btc8192e2ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = PAN(EDR)\n");
-			halbtc8192e2ant_action_pan_edr(btcoexist);
+			btc8192e2ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANHS:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = HS mode\n");
-			halbtc8192e2ant_action_pan_hs(btcoexist);
+			btc8192e2ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = PAN+A2DP\n");
-			halbtc8192e2ant_action_pan_edr_a2dp(btcoexist);
+			btc8192e2ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_PANEDR_HID:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = PAN(EDR)+HID\n");
-			halbtc8192e2ant_action_pan_edr_hid(btcoexist);
+			btc8192e2ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8192E_2ANT_COEX_ALGO_HID_A2DP_PANEDR:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2574,20 +2565,20 @@ static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		case BT_8192E_2ANT_COEX_ALGO_HID_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = HID+A2DP\n");
-			halbtc8192e2ant_action_hid_a2dp(btcoexist);
+			btc8192e2ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "Action 2-Ant, algorithm = unknown!!\n");
-			/* halbtc8192e2ant_coex_alloff(btcoexist); */
+			/* btc8192e2ant_coex_all_off(btcoexist); */
 			break;
 		}
 		coex_dm->pre_algorithm = coex_dm->cur_algorithm;
 	}
 }
 
-static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
-					  bool backup)
+static void btc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
+				       bool backup)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u16 u16tmp = 0;
@@ -2606,7 +2597,7 @@ static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
 								      0x430);
 		coex_dm->backup_arfr_cnt2 = btcoexist->btc_read_4byte(btcoexist,
 								     0x434);
-		coex_dm->backup_retrylimit = btcoexist->btc_read_2byte(
+		coex_dm->backup_retry_limit = btcoexist->btc_read_2byte(
 								    btcoexist,
 								    0x42a);
 		coex_dm->backup_ampdu_maxtime = btcoexist->btc_read_1byte(
@@ -2624,7 +2615,7 @@ static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
 	else
 		btcoexist->btc_write_4byte(btcoexist, 0x64, 0x30030004);
 
-	btc8192e2ant_coex_tbl_w_type(btcoexist, FORCE_EXEC, 0);
+	btc8192e2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
 	/* antenna switch control parameter */
 	btcoexist->btc_write_4byte(btcoexist, 0x858, 0x55555555);
@@ -2647,7 +2638,7 @@ static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
 	u16tmp |= BIT9;
 	btcoexist->btc_write_2byte(btcoexist, 0x40, u16tmp);
 
-	/* enable PTA I2C mailbox  */
+	/* enable PTA I2C mailbox */
 	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x101);
 	u8tmp |= BIT4;
 	btcoexist->btc_write_1byte(btcoexist, 0x101, u8tmp);
@@ -2662,29 +2653,25 @@ static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
 	btcoexist->btc_write_1byte(btcoexist, 0x7, u8tmp);
 }
 
-/*************************************************************
- *   work around function start with wa_halbtc8192e2ant_
- *************************************************************/
-
 /************************************************************
- *   extern function start with EXhalbtc8192e2ant_
+ *   extern function start with ex_btc8192e2ant_
  ************************************************************/
 
-void ex_halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist)
+void ex_btc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
-	halbtc8192e2ant_init_hwconfig(btcoexist, true);
+	btc8192e2ant_init_hwconfig(btcoexist, true);
 }
 
-void ex_halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
+void ex_btc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Coex Mechanism Init!!\n");
-	halbtc8192e2ant_init_coex_dm(btcoexist);
+	btc8192e2ant_init_coex_dm(btcoexist);
 }
 
-void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
+void ex_btc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
@@ -2693,8 +2680,8 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 	u16 u16tmp[4];
 	u32 u32tmp[4];
 	bool roam = false, scan = false, link = false, wifi_under_5g = false;
-	bool bt_hson = false, wifi_busy = false;
-	int wifirssi = 0, bt_hs_rssi = 0;
+	bool bt_hs_on = false, wifi_busy = false;
+	int wifi_rssi = 0, bt_hs_rssi = 0;
 	u32 wifi_bw, wifi_traffic_dir;
 	u8 wifi_dot11_chnl, wifi_hs_chnl;
 	u32 fw_ver = 0, bt_patch_ver = 0;
@@ -2731,21 +2718,21 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 		 glcoex_ver_date_8192e_2ant, glcoex_ver_8192e_2ant,
 		 fw_ver, bt_patch_ver, bt_patch_ver);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_DOT11_CHNL,
 			   &wifi_dot11_chnl);
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL, &wifi_hs_chnl);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d(%d)",
 		 "Dot11 channel / HsMode(HsChnl)",
-		 wifi_dot11_chnl, bt_hson, wifi_hs_chnl);
+		 wifi_dot11_chnl, bt_hs_on, wifi_hs_chnl);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %3ph ",
 		 "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifirssi);
+	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		 "Wifi rssi/ HS rssi", wifirssi, bt_hs_rssi);
+		 "Wifi rssi/ HS rssi", wifi_rssi, bt_hs_rssi);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
@@ -2792,7 +2779,7 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 "\r\n %-35s = %7ph(%d)",
-				 GLBtInfoSrc8192e2Ant[i],
+				 glbt_info_src_8192e_2ant[i],
 				 coex_sta->bt_info_c2h[i],
 				 coex_sta->bt_info_c2h_cnt[i]);
 		}
@@ -2805,7 +2792,7 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x ", "SS Type",
-		 coex_dm->cur_sstype);
+		 coex_dm->cur_ss_type);
 
 	/* Sw mechanism	*/
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
@@ -2844,7 +2831,7 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
 		 "backup ARFR1/ARFR2/RL/AMaxTime", coex_dm->backup_arfr_cnt1,
-		 coex_dm->backup_arfr_cnt2, coex_dm->backup_retrylimit,
+		 coex_dm->backup_arfr_cnt2, coex_dm->backup_retry_limit,
 		 coex_dm->backup_ampdu_maxtime);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x430);
@@ -2900,12 +2887,12 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 		 "0x774(lp rx[31:16]/tx[15:0])",
 		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
 #if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 1)
-	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
+	btc8192e2ant_monitor_bt_ctr(btcoexist);
 #endif
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
-void ex_halbtc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2913,7 +2900,7 @@ void ex_halbtc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
-		halbtc8192e2ant_coex_alloff(btcoexist);
+		btc8192e2ant_coex_all_off(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS LEAVE notify\n");
@@ -2921,7 +2908,7 @@ void ex_halbtc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2936,7 +2923,7 @@ void ex_halbtc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2948,7 +2935,7 @@ void ex_halbtc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], SCAN FINISH notify\n");
 }
 
-void ex_halbtc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2960,8 +2947,8 @@ void ex_halbtc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], CONNECT FINISH notify\n");
 }
 
-void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
-					    u8 type)
+void ex_btc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[3] = {0};
@@ -3006,8 +2993,8 @@ void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
 
-void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type)
+void ex_btc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -3016,8 +3003,8 @@ void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
 			 "[BTCoex], DHCP Packet notify\n");
 }
 
-void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmp_buf, u8 length)
+void ex_btc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 bt_info = 0;
@@ -3048,7 +3035,8 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	}
 
 	if (BT_INFO_SRC_8192E_2ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0] */
+		/* [3:0] */
+		coex_sta->bt_retry_cnt =
 			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
 		coex_sta->bt_rssi =
@@ -3066,11 +3054,11 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
 			if (wifi_connected)
-				ex_halbtc8192e2ant_media_status_notify(
+				ex_btc8192e2ant_media_status_notify(
 							btcoexist,
 							BTC_MEDIA_CONNECT);
 			else
-				ex_halbtc8192e2ant_media_status_notify(
+				ex_btc8192e2ant_media_status_notify(
 							btcoexist,
 							BTC_MEDIA_DISCONNECT);
 		}
@@ -3080,9 +3068,9 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			    !btcoexist->stop_coex_dm) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "bit3, BT NOT ignore Wlan active!\n");
-				halbtc8192e2ant_IgnoreWlanAct(btcoexist,
-							      FORCE_EXEC,
-							      false);
+				btc8192e2ant_ignore_wlan_act(btcoexist,
+							     FORCE_EXEC,
+							     false);
 			}
 		} else {
 			/* BT already NOT ignore Wlan active,
@@ -3094,8 +3082,8 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		if ((coex_sta->bt_info_ext & BIT4)) {
 			/* BT auto report already enabled, do nothing */
 		} else {
-			halbtc8192e2ant_bt_autoreport(btcoexist, FORCE_EXEC,
-						      true);
+			btc8192e2ant_bt_auto_report(btcoexist, FORCE_EXEC,
+						    true);
 		}
 #endif
 	}
@@ -3133,9 +3121,9 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_sta->sco_exist = false;
 	}
 
-	halbtc8192e2ant_update_btlink_info(btcoexist);
+	btc8192e2ant_update_bt_link_info(btcoexist);
 
-	if (!(bt_info&BT_INFO_8192E_2ANT_B_CONNECTION)) {
+	if (!(bt_info & BT_INFO_8192E_2ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_NON_CONNECTED_IDLE;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BT Non-Connected idle!!!\n");
@@ -3143,12 +3131,12 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_CONNECTED_IDLE;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], bt_infoNotify(), BT Connected-idle!!!\n");
-	} else if ((bt_info&BT_INFO_8192E_2ANT_B_SCO_ESCO) ||
-		   (bt_info&BT_INFO_8192E_2ANT_B_SCO_BUSY)) {
+	} else if ((bt_info & BT_INFO_8192E_2ANT_B_SCO_ESCO) ||
+		   (bt_info & BT_INFO_8192E_2ANT_B_SCO_BUSY)) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_SCO_BUSY;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], bt_infoNotify(), BT SCO busy!!!\n");
-	} else if (bt_info&BT_INFO_8192E_2ANT_B_ACL_BUSY) {
+	} else if (bt_info & BT_INFO_8192E_2ANT_B_ACL_BUSY) {
 		coex_dm->bt_status = BT_8192E_2ANT_BT_STATUS_ACL_BUSY;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], bt_infoNotify(), BT ACL busy!!!\n");
@@ -3173,7 +3161,7 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	coex_dm->limited_dig = limited_dig;
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_LIMITED_DIG, &limited_dig);
 
-	halbtc8192e2ant_run_coexist_mechanism(btcoexist);
+	btc8192e2ant_run_coexist_mechanism(btcoexist);
 }
 
 void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
@@ -3182,11 +3170,11 @@ void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Halt notify\n");
 
-	halbtc8192e2ant_IgnoreWlanAct(btcoexist, FORCE_EXEC, true);
-	ex_halbtc8192e2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
+	btc8192e2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+	ex_btc8192e2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
-void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist)
+void ex_btc8192e2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	static u8 dis_ver_info_cnt;
@@ -3220,12 +3208,12 @@ void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist)
 	}
 
 #if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-	halbtc8192e2ant_querybt_info(btcoexist);
-	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
-	btc8192e2ant_monitor_bt_enable_dis(btcoexist);
+	btc8192e2ant_query_bt_info(btcoexist);
+	btc8192e2ant_monitor_bt_ctr(btcoexist);
+	btc8192e2ant_monitor_bt_enable_disable(btcoexist);
 #else
-	if (halbtc8192e2ant_iswifi_status_changed(btcoexist) ||
+	if (btc8192e2ant_is_wifi_status_changed(btcoexist) ||
 	    coex_dm->auto_tdma_adjust)
-		halbtc8192e2ant_run_coexist_mechanism(btcoexist);
+		btc8192e2ant_run_coexist_mechanism(btcoexist);
 #endif
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
index 75e1f7d0db06..fc0fa87ec404 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
@@ -116,7 +116,7 @@ struct coex_dm_8192e_2ant {
 
 	u32 backup_arfr_cnt1;	/* Auto Rate Fallback Retry cnt */
 	u32 backup_arfr_cnt2;	/* Auto Rate Fallback Retry cnt */
-	u16 backup_retrylimit;
+	u16 backup_retry_limit;
 	u8 backup_ampdu_maxtime;
 
 	/* algorithm related */
@@ -125,18 +125,18 @@ struct coex_dm_8192e_2ant {
 	u8 bt_status;
 	u8 wifi_chnl_info[3];
 
-	u8 pre_sstype;
-	u8 cur_sstype;
+	u8 pre_ss_type;
+	u8 cur_ss_type;
 
-	u32 prera_mask;
-	u32 curra_mask;
-	u8 curra_masktype;
-	u8 pre_arfrtype;
-	u8 cur_arfrtype;
-	u8 pre_retrylimit_type;
-	u8 cur_retrylimit_type;
-	u8 pre_ampdutime_type;
-	u8 cur_ampdutime_type;
+	u32 pre_ra_mask;
+	u32 cur_ra_mask;
+	u8 cur_ra_mask_type;
+	u8 pre_arfr_type;
+	u8 cur_arfr_type;
+	u8 pre_retry_limit_type;
+	u8 cur_retry_limit_type;
+	u8 pre_ampdu_time_type;
+	u8 cur_ampdu_time_type;
 };
 
 struct coex_sta_8192e_2ant {
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index b58aeff7eb16..2003c8c51dcc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -45,7 +45,7 @@ static struct coex_dm_8723b_1ant *coex_dm = &glcoex_dm_8723b_1ant;
 static struct coex_sta_8723b_1ant glcoex_sta_8723b_1ant;
 static struct coex_sta_8723b_1ant *coex_sta = &glcoex_sta_8723b_1ant;
 
-static const char *const GLBtInfoSrc8723b1Ant[] = {
+static const char *const glbt_info_src_8723b_1ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
 	"BT Info[bt auto report]",
@@ -67,7 +67,7 @@ static void halbtc8723b1ant_updatera_mask(struct btc_coexist *btcoexist,
 	coex_dm->curra_mask = dis_rate_mask;
 
 	if (force_exec || (coex_dm->prera_mask != coex_dm->curra_mask))
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_ra_mask,
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_RAMASK,
 				   &coex_dm->curra_mask);
 
 	coex_dm->prera_mask = coex_dm->curra_mask;
@@ -144,15 +144,14 @@ static void halbtc8723b1ant_ampdu_maxtime(struct btc_coexist *btcoexist,
 		coex_dm->cur_ampdu_time_type)) {
 		switch (coex_dm->cur_ampdu_time_type) {
 		case 0:	/* normal mode */
-				btcoexist->btc_write_1byte(btcoexist, 0x456,
-						coex_dm->backup_ampdu_max_time);
-				break;
+			btcoexist->btc_write_1byte(btcoexist, 0x456,
+					coex_dm->backup_ampdu_max_time);
+			break;
 		case 1:	/* AMPDU timw = 0x38 * 32us */
-				btcoexist->btc_write_1byte(btcoexist,
-							   0x456, 0x38);
-				break;
+			btcoexist->btc_write_1byte(btcoexist, 0x456, 0x38);
+			break;
 		default:
-				break;
+			break;
 		}
 	}
 
@@ -172,7 +171,7 @@ static void halbtc8723b1ant_limited_tx(struct btc_coexist *btcoexist,
 		halbtc8723b1ant_updatera_mask(btcoexist, force_exec,
 					      0x00000003);
 		break;
-	/* disable cck 1/2/5.5, ofdm 6/9/12/18/24, mcs 0/1/2/3/4*/
+	/* disable cck 1/2/5.5, ofdm 6/9/12/18/24, mcs 0/1/2/3/4 */
 	case 2:
 		halbtc8723b1ant_updatera_mask(btcoexist, force_exec,
 					      0x0001f1f7);
@@ -244,7 +243,8 @@ static void halbtc8723b1ant_query_bt_info(struct btc_coexist *btcoexist)
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
-	h2c_parameter[0] |= BIT0;	/* trigger*/
+	/* trigger */
+	h2c_parameter[0] |= BIT0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
@@ -343,11 +343,11 @@ static void btc8723b1ant_set_sw_pen_tx_rate_adapt(struct btc_coexist *btcoexist,
 
 	if (low_penalty_ra) {
 		h2c_parameter[1] |= BIT0;
-		/*normal rate except MCS7/6/5, OFDM54/48/36 */
+		/* normal rate except MCS7/6/5, OFDM54/48/36 */
 		h2c_parameter[2] = 0x00;
-		h2c_parameter[3] = 0xf7;  /*MCS7 or OFDM54 */
-		h2c_parameter[4] = 0xf8;  /*MCS6 or OFDM48 */
-		h2c_parameter[5] = 0xf9;  /*MCS5 or OFDM36 */
+		h2c_parameter[3] = 0xf7;  /* MCS7 or OFDM54 */
+		h2c_parameter[4] = 0xf8;  /* MCS6 or OFDM48 */
+		h2c_parameter[5] = 0xf9;  /* MCS5 or OFDM36 */
 	}
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -468,8 +468,9 @@ static void halbtc8723b1ant_coex_table_with_type(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8723b1ant_SetFwIgnoreWlanAct(struct btc_coexist *btcoexist,
-					       bool enable)
+static void
+halbtc8723b1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
+				       bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
@@ -504,7 +505,7 @@ static void halbtc8723b1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 		    coex_dm->cur_ignore_wlan_act)
 			return;
 	}
-	halbtc8723b1ant_SetFwIgnoreWlanAct(btcoexist, enable);
+	halbtc8723b1ant_set_fw_ignore_wlan_act(btcoexist, enable);
 
 	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
 }
@@ -566,9 +567,9 @@ static void halbtc8723b1ant_set_lps_rpwm(struct btc_coexist *btcoexist,
 	btcoexist->btc_set(btcoexist, BTC_SET_U1_RPWM_VAL, &rpwm);
 }
 
-static void halbtc8723b1ant_LpsRpwm(struct btc_coexist *btcoexist,
-				    bool force_exec,
-				    u8 lps_val, u8 rpwm_val)
+static void halbtc8723b1ant_lps_rpwm(struct btc_coexist *btcoexist,
+				     bool force_exec,
+				     u8 lps_val, u8 rpwm_val)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -609,9 +610,9 @@ static void halbtc8723b1ant_sw_mechanism(struct btc_coexist *btcoexist,
 	halbtc8723b1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
 
-static void halbtc8723b1ant_SetAntPath(struct btc_coexist *btcoexist,
-				       u8 ant_pos_type, bool init_hw_cfg,
-				bool wifi_off)
+static void halbtc8723b1ant_set_ant_path(struct btc_coexist *btcoexist,
+					 u8 ant_pos_type, bool init_hw_cfg,
+					 bool wifi_off)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	u32 fw_ver = 0, u32tmp = 0;
@@ -650,7 +651,7 @@ static void halbtc8723b1ant_SetAntPath(struct btc_coexist *btcoexist,
 	if (use_ext_switch) {
 		if (init_hw_cfg) {
 			/* 0x4c[23] = 0, 0x4c[24] = 1
-			 *	Antenna control by WL/BT
+			 * Antenna control by WL/BT
 			 */
 			u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
 			u32tmp &= ~BIT23;
@@ -659,35 +660,36 @@ static void halbtc8723b1ant_SetAntPath(struct btc_coexist *btcoexist,
 
 			if (board_info->btdm_ant_pos ==
 			    BTC_ANTENNA_AT_MAIN_PORT) {
-				/* Main Ant to  BT for IPS case 0x4c[23] = 1 */
+				/* Main Ant to BT for IPS case 0x4c[23] = 1 */
 				btcoexist->btc_write_1byte_bitmask(btcoexist,
 								   0x64, 0x1,
 								   0x1);
 
-				/*tell firmware "no antenna inverse"*/
+				/* tell firmware "no antenna inverse" */
 				h2c_parameter[0] = 0;
 				h2c_parameter[1] = 1;  /*ext switch type*/
 				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 							h2c_parameter);
 			} else {
-				/*Aux Ant to  BT for IPS case 0x4c[23] = 1 */
+				/* Aux Ant to  BT for IPS case 0x4c[23] = 1 */
 				btcoexist->btc_write_1byte_bitmask(btcoexist,
 								   0x64, 0x1,
 								   0x0);
 
-				/*tell firmware "antenna inverse"*/
+				/* tell firmware "antenna inverse" */
 				h2c_parameter[0] = 1;
-				h2c_parameter[1] = 1;  /*ext switch type*/
+				h2c_parameter[1] = 1; /* ext switch type */
 				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 							h2c_parameter);
 			}
 		}
 
-		/* fixed internal switch first*/
-		/* fixed internal switch S1->WiFi, S0->BT*/
+		/* fixed internal switch first
+		 * fixed internal switch S1->WiFi, S0->BT
+		 */
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
-		else/* fixed internal switch S0->WiFi, S1->BT*/
+		else	/* fixed internal switch S0->WiFi, S1->BT */
 			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x280);
 
 		/* ext switch setting */
@@ -730,7 +732,7 @@ static void halbtc8723b1ant_SetAntPath(struct btc_coexist *btcoexist,
 
 	} else {
 		if (init_hw_cfg) {
-			/* 0x4c[23] = 1, 0x4c[24] = 0  Antenna control by 0x64*/
+			/* 0x4c[23] = 1, 0x4c[24] = 0 Antenna control by 0x64 */
 			u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
 			u32tmp |= BIT23;
 			u32tmp &= ~BIT24;
@@ -738,41 +740,42 @@ static void halbtc8723b1ant_SetAntPath(struct btc_coexist *btcoexist,
 
 			if (board_info->btdm_ant_pos ==
 			    BTC_ANTENNA_AT_MAIN_PORT) {
-				/*Main Ant to  WiFi for IPS case 0x4c[23] = 1*/
+				/* Main Ant to WiFi for IPS case 0x4c[23] = 1 */
 				btcoexist->btc_write_1byte_bitmask(btcoexist,
 								   0x64, 0x1,
 								   0x0);
 
-				/*tell firmware "no antenna inverse"*/
+				/* tell firmware "no antenna inverse" */
 				h2c_parameter[0] = 0;
-				h2c_parameter[1] = 0;  /*internal switch type*/
+				h2c_parameter[1] = 0; /* internal switch type */
 				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 							h2c_parameter);
 			} else {
-				/*Aux Ant to  BT for IPS case 0x4c[23] = 1*/
+				/* Aux Ant to BT for IPS case 0x4c[23] = 1 */
 				btcoexist->btc_write_1byte_bitmask(btcoexist,
 								   0x64, 0x1,
 								   0x1);
 
-				/*tell firmware "antenna inverse"*/
+				/* tell firmware "antenna inverse" */
 				h2c_parameter[0] = 1;
-				h2c_parameter[1] = 0;  /*internal switch type*/
+				h2c_parameter[1] = 0; /* internal switch type */
 				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 							h2c_parameter);
 			}
 		}
 
-		/* fixed external switch first*/
-		/*Main->WiFi, Aux->BT*/
+		/* fixed external switch first
+		 * Main->WiFi, Aux->BT
+		 */
 		if (board_info->btdm_ant_pos ==
 			BTC_ANTENNA_AT_MAIN_PORT)
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c,
 							   0x3, 0x1);
-		else/*Main->BT, Aux->WiFi */
+		else	/* Main->BT, Aux->WiFi */
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c,
 							   0x3, 0x2);
 
-		/* internal switch setting*/
+		/* internal switch setting */
 		switch (ant_pos_type) {
 		case BTC_ANT_PATH_WIFI:
 			if (board_info->btdm_ant_pos ==
@@ -987,7 +990,7 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 			halbtc8723b1ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x12,
 						       0x3, 0x14, 0x50);
 			break;
-		/* SoftAP only with no sta associated,BT disable ,
+		/* SoftAP only with no sta associated, BT disable,
 		 * TDMA mode for power saving
 		 * here softap mode screen off will cost 70-80mA for phone
 		 */
@@ -998,24 +1001,29 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 		}
 	} else {
 		switch (type) {
-		case 8: /*PTA Control */
+		case 8: /* PTA Control */
 			halbtc8723b1ant_set_fw_ps_tdma(btcoexist, 0x8, 0x0,
 						       0x0, 0x0, 0x0);
-			halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_PTA,
-						   false, false);
+			halbtc8723b1ant_set_ant_path(btcoexist,
+						     BTC_ANT_PATH_PTA,
+						     false, false);
 			break;
 		case 0:
-		default:  /*Software control, Antenna at BT side */
+		default:
+			/* Software control, Antenna at BT side */
 			halbtc8723b1ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0,
 						       0x0, 0x0, 0x0);
-			halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_BT,
-						   false, false);
+			halbtc8723b1ant_set_ant_path(btcoexist,
+						     BTC_ANT_PATH_BT,
+						     false, false);
 			break;
-		case 9:   /*Software control, Antenna at WiFi side */
+		case 9:
+			/* Software control, Antenna at WiFi side */
 			halbtc8723b1ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0,
 						       0x0, 0x0, 0x0);
-			halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_WIFI,
-						   false, false);
+			halbtc8723b1ant_set_ant_path(btcoexist,
+						     BTC_ANT_PATH_WIFI,
+						     false, false);
 			break;
 		}
 	}
@@ -1029,189 +1037,15 @@ static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
-					      u8 wifi_status)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static s32 up, dn, m, n, wait_count;
-	/* 0: no change, +1: increase WiFi duration,
-	 * -1: decrease WiFi duration
-	 */
-	s32 result;
-	u8 retry_count = 0, bt_info_ext;
-	bool wifi_busy = false;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], TdmaDurationAdjustForAcl()\n");
-
-	if (BT_8723B_1ANT_WIFI_STATUS_CONNECTED_BUSY == wifi_status)
-		wifi_busy = true;
-	else
-		wifi_busy = false;
-
-	if ((BT_8723B_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
-							 wifi_status) ||
-	    (BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SCAN == wifi_status) ||
-	    (BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SPECIAL_PKT == wifi_status)) {
-		if (coex_dm->cur_ps_tdma != 1 && coex_dm->cur_ps_tdma != 2 &&
-		    coex_dm->cur_ps_tdma != 3 && coex_dm->cur_ps_tdma != 9) {
-			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
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
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
-
-		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 2);
-		coex_dm->tdma_adj_type = 2;
-
-		up = 0;
-		dn = 0;
-		m = 1;
-		n = 3;
-		result = 0;
-		wait_count = 0;
-	} else {
-		/*accquire the BT TRx retry count from BT_Info byte2 */
-		retry_count = coex_sta->bt_retry_cnt;
-		bt_info_ext = coex_sta->bt_info_ext;
-		result = 0;
-		wait_count++;
-		/* no retry in the last 2-second duration */
-		if (retry_count == 0) {
-			up++;
-			dn--;
-
-			if (dn <= 0)
-				dn = 0;
-
-			if (up >= n) {
-				wait_count = 0;
-				n = 3;
-				up = 0;
-				dn = 0;
-				result = 1;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Increase wifi duration!!\n");
-			}
-		} else if (retry_count <= 3) {
-			up--;
-			dn++;
-
-			if (up <= 0)
-				up = 0;
-
-			if (dn == 2) {
-				if (wait_count <= 2)
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
-				wait_count = 0;
-				result = -1;
-				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-					 "[BTCoex], Decrease wifi duration for retryCounter<3!!\n");
-			}
-		} else {
-			if (wait_count == 1)
-				m++;
-			else
-				m = 1;
-
-			if (m >= 20)
-				m = 20;
-
-			n = 3 * m;
-			up = 0;
-			dn = 0;
-			wait_count = 0;
-			result = -1;
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], Decrease wifi duration for retryCounter>3!!\n");
-		}
-
-		if (result == -1) {
-			if ((BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			}
-		} else if (result == 1) {
-			if ((BT_INFO_8723B_1ANT_A2DP_BASIC_RATE(bt_info_ext)) &&
-			    ((coex_dm->cur_ps_tdma == 1) ||
-			     (coex_dm->cur_ps_tdma == 2))) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 9);
-				coex_dm->tdma_adj_type = 9;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			}
-		} else {	  /*no change */
-			/*if busy / idle change */
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex],********* TDMA(on, %d) ********\n",
-				 coex_dm->cur_ps_tdma);
-		}
-
-		if (coex_dm->cur_ps_tdma != 1 && coex_dm->cur_ps_tdma != 2 &&
-		    coex_dm->cur_ps_tdma != 9 && coex_dm->cur_ps_tdma != 11) {
-			/* recover to previous adjust type */
-			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
-						coex_dm->tdma_adj_type);
-		}
-	}
-}
-
-static void btc8723b1ant_pstdmachkpwrsave(struct btc_coexist *btcoexist,
-					  bool new_ps_state)
+static void halbtc8723b1ant_ps_tdma_chk_pwr_save(struct btc_coexist *btcoexist,
+						 bool new_ps_state)
 {
 	u8 lps_mode = 0x0;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_LPS_MODE, &lps_mode);
 
-	if (lps_mode) {	/* already under LPS state */
+	if (lps_mode) {
+		/* already under LPS state */
 		if (new_ps_state) {
 			/* keep state under LPS, do nothing. */
 		} else {
@@ -1219,7 +1053,8 @@ static void btc8723b1ant_pstdmachkpwrsave(struct btc_coexist *btcoexist,
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						false, 0);
 		}
-	} else {	/* NO PS state */
+	} else {
+		/* NO PS state */
 		if (new_ps_state) {
 			/* will enter LPS state, turn off psTdma first */
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
@@ -1245,18 +1080,18 @@ static void halbtc8723b1ant_power_save_state(struct btc_coexist *btcoexist,
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS, NULL);
 		break;
 	case BTC_PS_LPS_ON:
-		btc8723b1ant_pstdmachkpwrsave(btcoexist, true);
-		halbtc8723b1ant_LpsRpwm(btcoexist, NORMAL_EXEC, lps_val,
-					rpwm_val);
-		/* when coex force to enter LPS, do not enter 32k low power. */
+		halbtc8723b1ant_ps_tdma_chk_pwr_save(btcoexist, true);
+		halbtc8723b1ant_lps_rpwm(btcoexist, NORMAL_EXEC, lps_val,
+					 rpwm_val);
+		/* when coex force to enter LPS, do not enter 32k low power */
 		low_pwr_disable = true;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
-		/* power save must executed before psTdma.	 */
+		/* power save must executed before psTdma */
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ENTER_LPS, NULL);
 		break;
 	case BTC_PS_LPS_OFF:
-		btc8723b1ant_pstdmachkpwrsave(btcoexist, false);
+		halbtc8723b1ant_ps_tdma_chk_pwr_save(btcoexist, false);
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS, NULL);
 		break;
 	default:
@@ -1330,11 +1165,11 @@ static void btc8723b1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
 			   &wifi_connected);
 
 	/* tdma and coex table */
-
 	if (bt_link_info->sco_exist) {
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
 		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
-	} else { /* HID */
+	} else {
+		/* HID */
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 6);
 		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 5);
 	}
@@ -1347,18 +1182,18 @@ static void halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 
-	if (bt_link_info->hid_only) {  /*HID */
+	if (bt_link_info->hid_only) { /* HID */
 		btc8723b1ant_act_bt_sco_hid_only_busy(btcoexist, wifi_status);
 		coex_dm->auto_tdma_adjust = false;
 		return;
-	} else if (bt_link_info->a2dp_only) { /*A2DP */
-		if (BT_8723B_1ANT_WIFI_STATUS_CONNECTED_IDLE == wifi_status) {
+	} else if (bt_link_info->a2dp_only) { /* A2DP */
+		if (wifi_status == BT_8723B_1ANT_WIFI_STATUS_CONNECTED_IDLE) {
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						false, 8);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 2);
 			coex_dm->auto_tdma_adjust = false;
-		} else { /*for low BT RSSI */
+		} else { /* for low BT RSSI */
 			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 11);
 			halbtc8723b1ant_coex_table_with_type(btcoexist,
@@ -1366,18 +1201,18 @@ static void halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
 			coex_dm->auto_tdma_adjust = false;
 		}
 	} else if (bt_link_info->hid_exist &&
-			bt_link_info->a2dp_exist) { /*HID+A2DP */
-		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
+		bt_link_info->a2dp_exist) { /* HID + A2DP */
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,	true, 14);
 		coex_dm->auto_tdma_adjust = false;
 
 		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 6);
-	 /*PAN(OPP,FTP), HID+PAN(OPP,FTP) */
+	 /* PAN(OPP,FTP), HID + PAN(OPP,FTP) */
 	} else if (bt_link_info->pan_only ||
 		   (bt_link_info->hid_exist && bt_link_info->pan_exist)) {
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 6);
 		coex_dm->auto_tdma_adjust = false;
-	 /*A2DP+PAN(OPP,FTP), HID+A2DP+PAN(OPP,FTP)*/
+	 /* A2DP + PAN(OPP,FTP), HID + A2DP + PAN(OPP,FTP) */
 	} else if ((bt_link_info->a2dp_exist && bt_link_info->pan_exist) ||
 		   (bt_link_info->hid_exist && bt_link_info->a2dp_exist &&
 		    bt_link_info->pan_exist)) {
@@ -1402,57 +1237,59 @@ static void btc8723b1ant_action_wifi_not_conn(struct btc_coexist *btcoexist)
 	halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
-static void btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoex)
+static void
+btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 {
-	struct btc_bt_link_info *bt_link_info = &btcoex->bt_link_info;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
-	halbtc8723b1ant_power_save_state(btcoex, BTC_PS_WIFI_NATIVE,
+	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 					 0x0, 0x0);
 
 	/* tdma and coex table */
 	if (BT_8723B_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
 		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
-			halbtc8723b1ant_ps_tdma(btcoex, NORMAL_EXEC,
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 22);
-			halbtc8723b1ant_coex_table_with_type(btcoex,
+			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 1);
 		} else if (bt_link_info->pan_only) {
-			halbtc8723b1ant_ps_tdma(btcoex, NORMAL_EXEC,
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 20);
-			halbtc8723b1ant_coex_table_with_type(btcoex,
+			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 2);
 		} else {
-			halbtc8723b1ant_ps_tdma(btcoex, NORMAL_EXEC,
+			halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						true, 20);
-			halbtc8723b1ant_coex_table_with_type(btcoex,
+			halbtc8723b1ant_coex_table_with_type(btcoexist,
 							     NORMAL_EXEC, 1);
 		}
 	} else if ((BT_8723B_1ANT_BT_STATUS_SCO_BUSY == coex_dm->bt_status) ||
 		   (BT_8723B_1ANT_BT_STATUS_ACL_SCO_BUSY ==
 		    coex_dm->bt_status)){
-		btc8723b1ant_act_bt_sco_hid_only_busy(btcoex,
+		btc8723b1ant_act_bt_sco_hid_only_busy(btcoexist,
 				BT_8723B_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
-		halbtc8723b1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 8);
-		halbtc8723b1ant_coex_table_with_type(btcoex, NORMAL_EXEC, 2);
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 	}
 }
 
-static void btc8723b1ant_act_wifi_not_conn_asso_auth(struct btc_coexist *btcoex)
+static void
+btc8723b1ant_act_wifi_not_conn_asso_auth(struct btc_coexist *btcoexist)
 {
-	struct btc_bt_link_info *bt_link_info = &btcoex->bt_link_info;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
-	halbtc8723b1ant_power_save_state(btcoex, BTC_PS_WIFI_NATIVE,
+	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 					 0x0, 0x0);
 
 	if ((BT_8723B_1ANT_BT_STATUS_CONNECTED_IDLE == coex_dm->bt_status) ||
 	    (bt_link_info->sco_exist) || (bt_link_info->hid_only) ||
 	    (bt_link_info->a2dp_only) || (bt_link_info->pan_only)) {
-		halbtc8723b1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 8);
-		halbtc8723b1ant_coex_table_with_type(btcoex, NORMAL_EXEC, 7);
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 	} else {
-		halbtc8723b1ant_ps_tdma(btcoex, NORMAL_EXEC, true, 20);
-		halbtc8723b1ant_coex_table_with_type(btcoex, NORMAL_EXEC, 1);
+		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		halbtc8723b1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	}
 }
 
@@ -1663,13 +1500,12 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	if (!bt_link_info->sco_exist && !bt_link_info->hid_exist) {
 		halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
 	} else {
-		if (wifi_connected) {
+		if (wifi_connected)
 			halbtc8723b1ant_limited_tx(btcoexist,
 						   NORMAL_EXEC, 1, 1, 1, 1);
-		} else {
+		else
 			halbtc8723b1ant_limited_tx(btcoexist, NORMAL_EXEC,
 						   0, 0, 0, 0);
-		}
 	}
 
 	if (bt_link_info->sco_exist) {
@@ -1784,22 +1620,19 @@ static void halbtc8723b1ant_init_hw_config(struct btc_coexist *btcoexist,
 	btcoexist->btc_write_1byte(btcoexist, 0x790, u8tmp);
 
 	/* Enable counter statistics */
-	/*0x76e[3] =1, WLAN_Act control by PTA */
+	/*0x76e[3] = 1, WLAN_Act control by PTA */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x1);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 
-	/*Antenna config */
-	halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_PTA, true, false);
+	/* Antenna config */
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA, true, false);
 	/* PTA parameter */
 	halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 }
 
 /**************************************************************
- * work around function start with wa_halbtc8723b1ant_
- **************************************************************/
-/**************************************************************
- * extern function start with EXhalbtc8723b1ant_
+ * extern function start with ex_halbtc8723b1ant_
  **************************************************************/
 
 void ex_halbtc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist)
@@ -1953,7 +1786,7 @@ void ex_halbtc8723b1ant_display_coex_info(struct btc_coexist *btcoexist)
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 				 "\r\n %-35s = %7ph(%d)",
-				 GLBtInfoSrc8723b1Ant[i],
+				 glbt_info_src_8723b_1ant[i],
 				 coex_sta->bt_info_c2h[i],
 				 coex_sta->bt_info_c2h_cnt[i]);
 		}
@@ -2111,8 +1944,8 @@ void ex_halbtc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
 
-		halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_BT,
-					   false, true);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
+					     false, true);
 		/* set PTA control */
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 		halbtc8723b1ant_coex_table_with_type(btcoexist,
@@ -2187,14 +2020,17 @@ void ex_halbtc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	if (BTC_SCAN_START == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], SCAN START notify\n");
-		if (!wifi_connected)	/* non-connected scan */
+		if (!wifi_connected)
+			/* non-connected scan */
 			btc8723b1ant_action_wifi_not_conn_scan(btcoexist);
-		else	/* wifi is connected */
+		else
+			/* wifi is connected */
 			btc8723b1ant_action_wifi_conn_scan(btcoexist);
 	} else if (BTC_SCAN_FINISH == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], SCAN FINISH notify\n");
-		if (!wifi_connected)	/* non-connected scan */
+		if (!wifi_connected)
+			/* non-connected scan */
 			btc8723b1ant_action_wifi_not_conn(btcoexist);
 		else
 			halbtc8723b1ant_action_wifi_connected(btcoexist);
@@ -2244,7 +2080,8 @@ void ex_halbtc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 				   &wifi_connected);
-		if (!wifi_connected) /* non-connected scan */
+		if (!wifi_connected)
+			/* non-connected scan */
 			btc8723b1ant_action_wifi_not_conn(btcoexist);
 		else
 			halbtc8723b1ant_action_wifi_connected(btcoexist);
@@ -2433,7 +2270,8 @@ void ex_halbtc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->a2dp_exist = false;
 		coex_sta->hid_exist = false;
 		coex_sta->sco_exist = false;
-	} else { /* connection exists */
+	} else {
+		/* connection exists */
 		coex_sta->bt_link_exist = true;
 		if (bt_info & BT_INFO_8723B_1ANT_B_FTP)
 			coex_sta->pan_exist = true;
@@ -2502,7 +2340,7 @@ void ex_halbtc8723b1ant_halt_notify(struct btc_coexist *btcoexist)
 
 	btcoexist->stop_coex_dm = true;
 
-	halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_BT, false, true);
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false, true);
 
 	halbtc8723b1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 
@@ -2523,8 +2361,8 @@ void ex_halbtc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Pnp notify to SLEEP\n");
 		btcoexist->stop_coex_dm = true;
-		halbtc8723b1ant_SetAntPath(btcoexist, BTC_ANT_PATH_BT, false,
-					   true);
+		halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false,
+					     true);
 		halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
 						 0x0, 0x0);
 		halbtc8723b1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 4e5dfaa02da9..9b09b94cbb43 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -676,15 +676,15 @@ static void btc8723b_set_penalty_txrate(struct btc_coexist *btcoexist,
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[6] = {0};
 
-	h2c_parameter[0] = 0x6;	/* opCode, 0x6= Retry_Penalty*/
+	h2c_parameter[0] = 0x6;	/* op_code, 0x6 = Retry_Penalty */
 
 	if (low_penalty_ra) {
 		h2c_parameter[1] |= BIT0;
-		/*normal rate except MCS7/6/5, OFDM54/48/36*/
+		/* normal rate except MCS7/6/5, OFDM54/48/36 */
 		h2c_parameter[2] = 0x00;
-		h2c_parameter[3] = 0xf7;  /*MCS7 or OFDM54*/
-		h2c_parameter[4] = 0xf8;  /*MCS6 or OFDM48*/
-		h2c_parameter[5] = 0xf9;  /*MCS5 or OFDM36*/
+		h2c_parameter[3] = 0xf7; /* MCS7 or OFDM54 */
+		h2c_parameter[4] = 0xf8; /* MCS6 or OFDM48 */
+		h2c_parameter[5] = 0xf9; /* MCS5 or OFDM36 */
 	}
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -699,7 +699,6 @@ static void btc8723b2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
-	/*return; */
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn LowPenaltyRA = %s\n",
 		 (force_exec ? "force to" : ""), (low_penalty_ra ?
@@ -741,9 +740,9 @@ static void btc8723b2ant_set_sw_fulltime_dac_swing(struct btc_coexist *btcoex,
 		btc8723b2ant_set_dac_swing_reg(btcoex, 0x18);
 }
 
-static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
-				   bool force_exec, bool dac_swing_on,
-				   u32 dac_swing_lvl)
+void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
+			    bool force_exec, bool dac_swing_on,
+			    u32 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -838,8 +837,8 @@ static void btc8723b2ant_coex_table(struct btc_coexist *btcoexist,
 	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
 }
 
-static void btc8723b_coex_tbl_type(struct btc_coexist *btcoexist,
-				   bool force_exec, u8 type)
+static void btc8723b2ant_coex_table_with_type(struct btc_coexist *btcoexist,
+					      bool force_exec, u8 type)
 {
 	switch (type) {
 	case 0:
@@ -906,7 +905,7 @@ static void btc8723b2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 	u8 h2c_parameter[1] = {0};
 
 	if (enable)
-		h2c_parameter[0] |= BIT0;/* function enable*/
+		h2c_parameter[0] |= BIT0; /* function enable */
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63=0x%x\n",
@@ -967,9 +966,9 @@ static void btc8723b2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
-static void btc8723b2ant_sw_mechanism1(struct btc_coexist *btcoexist,
-				       bool shrink_rx_lpf, bool low_penalty_ra,
-				       bool limited_dig, bool bt_lna_constrain)
+static void btc8723b2ant_sw_mechanism(struct btc_coexist *btcoexist,
+				      bool shrink_rx_lpf, bool low_penalty_ra,
+				      bool limited_dig, bool bt_lna_constrain)
 {
 	btc8723b2ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
@@ -1208,11 +1207,11 @@ static void btc8723b2ant_coex_alloff(struct btc_coexist *btcoexist)
 	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	/* sw all off */
-	btc8723b2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
 
 	/* hw all off */
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
-	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 0);
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
 static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -1223,7 +1222,9 @@ static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
 	btc8723b2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, false);
 
-	btc8723b2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
+
+	coex_sta->pop_event_cnt = 0;
 }
 
 static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
@@ -1237,22 +1238,16 @@ static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 			   &wifi_connected);
 
 	if (wifi_connected) {
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 	} else {
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 0);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 	}
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
 	btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-	btc8723b2ant_sw_mechanism1(btcoexist, false, false, false, false);
-
-	coex_dm->need_recover_0x948 = true;
-	coex_dm->backup_0x948 = btcoexist->btc_read_2byte(btcoexist, 0x948);
-
-	btc8723b2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_AUX,
-				  false, false);
+	btc8723b2ant_sw_mechanism(btcoexist, false, false, false, false);
 }
 
 static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
@@ -1277,13 +1272,13 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
 					  0x0);
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 0);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 		btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8723b2ant_sw_mechanism1(btcoexist, false, false, false,
-					   false);
+		btc8723b2ant_sw_mechanism(btcoexist, false, false, false,
+					  false);
 
 		common = true;
 	} else {
@@ -1299,15 +1294,16 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x0);
-			btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 0);
+			btc8723b2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 0);
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      0xb);
 			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
 						false);
 
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 
 			common = true;
 		} else if (BT_8723B_2ANT_BT_STATUS_CONNECTED_IDLE ==
@@ -1324,15 +1320,16 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x0);
-			btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 0);
+			btc8723b2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 0);
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      0xb);
 			btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
 						false);
 
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 
 			common = true;
 		} else {
@@ -1354,16 +1351,17 @@ static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 
 				btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A,
 							  0x1, 0xfffff, 0x0);
-				btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC,
-						       7);
+				btc8723b2ant_coex_table_with_type(btcoexist,
+								  NORMAL_EXEC,
+								  7);
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 21);
 				btc8723b2ant_fw_dac_swing_lvl(btcoexist,
 							      NORMAL_EXEC,
 							      0xb);
-				btc8723b2ant_sw_mechanism1(btcoexist, false,
-							   false, false,
-							   false);
+				btc8723b2ant_sw_mechanism(btcoexist, false,
+							  false, false,
+							  false);
 				common = true;
 			}
 		}
@@ -1542,8 +1540,11 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 			 "[BTCoex], max Interval = %d\n", max_interval);
 	}
 
-	/*if current PsTdma not match with the recorded one (when scan, dhcp..),
-	 *then we have to adjust it back to the previous recorded one.
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], max Interval = %d\n", max_interval);
+
+	/* if current PsTdma not match with the recorded one (scan, dhcp, ...),
+	 * then we have to adjust it back to the previous recorded one.
 	 */
 	if (coex_dm->cur_ps_tdma != coex_dm->tdma_adj_type) {
 		bool scan = false, link = false, roam = false;
@@ -1579,33 +1580,34 @@ static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	/*for SCO quality at 11b/g mode*/
 	if (BTC_WIFI_BW_LEGACY == wifi_bw)
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 2);
-	else  /*for SCO quality & wifi performance balance at 11n mode*/
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 8);
+		/* for SCO quality at 11b/g mode */
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	else
+		/* for SCO quality & wifi performance balance at 11n mode */
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 8);
 
-	/*for voice quality */
+	/* for voice quality */
 	btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 
 	/* sw mechanism */
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		}
 	}
 }
@@ -1625,10 +1627,13 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) /*/for HID at 11b/g mode*/
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
-	else  /*for HID quality & wifi performance balance at 11n mode*/
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 9);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY)
+		/* for HID at 11b/g mode */
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+	else
+		/* for HID quality & wifi performance balance at 11n mode */
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 9);
+
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
@@ -1640,25 +1645,25 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		}
 	}
 }
 
-/*A2DP only / PAN(EDR) only/ A2DP+PAN(HS)*/
+/* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
 static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
@@ -1680,17 +1685,17 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 					  0x0);
 		btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 0);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
 		/* sw mechanism */
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 		if (BTC_WIFI_BW_HT40 == wifi_bw) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		}
 		return;
 	}
@@ -1699,7 +1704,7 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
@@ -1713,20 +1718,20 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		}
 	}
 }
@@ -1743,30 +1748,29 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 
 	btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 
 	btc8723b2ant_tdma_duration_adjust(btcoexist, false, true, 2);
 
 	/* sw mechanism */
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_U4_WIFI_BW, &wifi_bw);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		}
 	}
 }
@@ -1789,7 +1793,7 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 10);
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 10);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
@@ -1802,25 +1806,25 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		}
 	}
 }
 
-/*PAN(HS) only*/
+/* PAN(HS) only */
 static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
 	u8 wifi_rssi_state;
@@ -1839,33 +1843,32 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 	else
 		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
-
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 	btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		}
 	}
 }
 
-/*PAN(EDR)+A2DP*/
+/* PAN(EDR) + A2DP */
 static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -1888,7 +1891,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 12);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 12);
 		if (BTC_WIFI_BW_HT40 == wifi_bw)
 			btc8723b2ant_tdma_duration_adjust(btcoexist, false,
 							  true, 3);
@@ -1896,7 +1899,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 			btc8723b2ant_tdma_duration_adjust(btcoexist, false,
 							  false, 3);
 	} else {
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 		btc8723b2ant_tdma_duration_adjust(btcoexist, false, true, 3);
 	}
 
@@ -1904,20 +1907,20 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, false,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, false,
+						  false, false);
 		}
 	}
 }
@@ -1942,20 +1945,22 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 		if (BTC_WIFI_BW_HT40 == wifi_bw) {
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      3);
-			btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 11);
+			btc8723b2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 11);
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x780);
 		} else {
 			btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
 						      6);
-			btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
+			btc8723b2ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 7);
 			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
 						  0xfffff, 0x0);
 		}
 		btc8723b2ant_tdma_duration_adjust(btcoexist, true, false, 2);
 	} else {
 		btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 11);
+		btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 11);
 		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
 					  0x0);
 		btc8723b2ant_tdma_duration_adjust(btcoexist, true, true, 2);
@@ -1965,25 +1970,25 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		}
 	}
 }
 
-/* HID+A2DP+PAN(EDR) */
+/* HID + A2DP + PAN(EDR) */
 static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -2004,7 +2009,7 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
@@ -2022,20 +2027,20 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		}
 	}
 }
@@ -2055,7 +2060,7 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 7);
+	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 
 	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
@@ -2067,20 +2072,20 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, true, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, true, true,
+						  false, false);
 		}
 	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		} else {
-			btc8723b2ant_sw_mechanism1(btcoexist, false, true,
-						   false, false);
+			btc8723b2ant_sw_mechanism(btcoexist, false, true,
+						  false, false);
 		}
 	}
 }
@@ -2209,10 +2214,7 @@ static void btc8723b2ant_wifioff_hwcfg(struct btc_coexist *btcoexist)
 }
 
 /*********************************************************************
- *  work around function start with wa_btc8723b2ant_
- *********************************************************************/
-/*********************************************************************
- *  extern function start with EXbtc8723b2ant_
+ *  extern function start with ex_btc8723b2ant_
  *********************************************************************/
 void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
@@ -2230,14 +2232,14 @@ void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	u8tmp |= 0x5;
 	btcoexist->btc_write_1byte(btcoexist, 0x790, u8tmp);
 
-	/*Antenna config */
+	/* Antenna config */
 	btc8723b2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN,
 				  true, false);
 	/* PTA parameter */
-	btc8723b_coex_tbl_type(btcoexist, FORCE_EXEC, 0);
+	btc8723b2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
 	/* Enable counter statistics */
-	/*0x76e[3] =1, WLAN_Act control by PTA*/
+	/* 0x76e[3] = 1, WLAN_ACT controlled by PTA */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
@@ -2615,7 +2617,7 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_info_c2h[rsp_source][i] = tmpbuf[i];
 		if (i == 1)
 			bt_info = tmpbuf[i];
-		if (i == length-1)
+		if (i == length - 1)
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "0x%02x]\n", tmpbuf[i]);
 		else
@@ -2630,7 +2632,7 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	}
 
 	if (BT_INFO_SRC_8723B_2ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0]*/
+		coex_sta->bt_retry_cnt =
 			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
 		coex_sta->bt_rssi =
@@ -2640,7 +2642,7 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_sta->bt_info_c2h[rsp_source][4];
 
 		/* Here we need to resend some wifi info to BT
-		     because bt is reset and loss of the info.
+		 * because BT is reset and loss of the info.
 		 */
 		if ((coex_sta->bt_info_ext & BIT1)) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2675,20 +2677,21 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 #endif
 	}
 
-	/* check BIT2 first ==> check if bt is under inquiry or page scan*/
+	/* check BIT2 first ==> check if bt is under inquiry or page scan */
 	if (bt_info & BT_INFO_8723B_2ANT_B_INQ_PAGE)
 		coex_sta->c2h_bt_inquiry_page = true;
 	else
 		coex_sta->c2h_bt_inquiry_page = false;
 
-	/* set link exist status*/
 	if (!(bt_info & BT_INFO_8723B_2ANT_B_CONNECTION)) {
+		/* set link exist status */
 		coex_sta->bt_link_exist = false;
 		coex_sta->pan_exist = false;
 		coex_sta->a2dp_exist = false;
 		coex_sta->hid_exist = false;
 		coex_sta->sco_exist = false;
-	} else { /* connection exists */
+	} else {
+		/* connection exists */
 		coex_sta->bt_link_exist = true;
 		if (bt_info & BT_INFO_8723B_2ANT_B_FTP)
 			coex_sta->pan_exist = true;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
index 567f354caf95..d787ae3bced2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -148,6 +148,7 @@ struct coex_sta_8723b_2ant {
 	bool c2h_bt_inquiry_page;
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
+	u32 pop_event_cnt;
 };
 
 /*********************************************************************
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index 4a8d8cfb34d3..6f6ab0738fbb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -23,7 +23,7 @@
  *
  *****************************************************************************/
 
-/*============================================================
+/**************************************************************
  * Description:
  *
  * This file is for RTL8821A Co-exist mechanism
@@ -31,17 +31,15 @@
  * History
  * 2012/11/15 Cosa first check in.
  *
- *============================================================
-*/
-/*============================================================
+ **************************************************************/
+
+/**************************************************************
  * include files
- *============================================================
- */
+ **************************************************************/
 #include "halbt_precomp.h"
-/*============================================================
+/**************************************************************
  * Global variables, these are static variables
- *============================================================
- */
+ **************************************************************/
 static struct coex_dm_8821a_1ant glcoex_dm_8821a_1ant;
 static struct coex_dm_8821a_1ant *coex_dm = &glcoex_dm_8821a_1ant;
 static struct coex_sta_8821a_1ant glcoex_sta_8821a_1ant;
@@ -53,22 +51,21 @@ static const char *const glbt_info_src_8821a_1ant[] = {
 	  "BT Info[bt auto report]",
 };
 
-static u32	glcoex_ver_date_8821a_1ant = 20130816;
-static u32	glcoex_ver_8821a_1ant = 0x41;
+static u32 glcoex_ver_date_8821a_1ant = 20130816;
+static u32 glcoex_ver_8821a_1ant = 0x41;
 
-/*============================================================
+/**************************************************************
  * local function proto type if needed
  *
- * local function start with halbtc8821a1ant_
- *============================================================
- */
-static u8 halbtc8821a1ant_bt_rssi_state(struct btc_coexist *btcoexist,
-					u8 level_num, u8 rssi_thresh,
-					u8 rssi_thresh1)
+ * local function start with btc8821a1ant_
+ **************************************************************/
+static u8 btc8821a1ant_bt_rssi_state(struct btc_coexist *btcoexist,
+				     u8 level_num, u8 rssi_thresh,
+				     u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	long	bt_rssi = 0;
-	u8	bt_rssi_state = coex_sta->pre_bt_rssi_state;
+	long bt_rssi = 0;
+	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
 	bt_rssi = coex_sta->bt_rssi;
 
@@ -150,9 +147,9 @@ static u8 halbtc8821a1ant_bt_rssi_state(struct btc_coexist *btcoexist,
 	return bt_rssi_state;
 }
 
-static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
-					u8 index, u8 level_num, u8 rssi_thresh,
-					u8 rssi_thresh1)
+static u8 btc8821a1ant_wifi_rssi_state(struct btc_coexist *btcoexist,
+				       u8 index, u8 level_num, u8 rssi_thresh,
+				       u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	long	wifi_rssi = 0;
@@ -165,8 +162,8 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 		     BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifi_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			if (wifi_rssi >= (rssi_thresh +
+					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
 				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], wifi RSSI state switch to High\n");
@@ -197,8 +194,8 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 		     BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
-			if (wifi_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			if (wifi_rssi >= (rssi_thresh +
+					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
 				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], wifi RSSI state switch to Medium\n");
@@ -211,9 +208,8 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 			BTC_RSSI_STATE_MEDIUM) ||
 			(coex_sta->pre_wifi_rssi_state[index] ==
 			BTC_RSSI_STATE_STAY_MEDIUM)) {
-			if (wifi_rssi >=
-			    (rssi_thresh1 +
-			     BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
+			if (wifi_rssi >= (rssi_thresh1 +
+					BTC_RSSI_COEX_THRESH_TOL_8821A_1ANT)) {
 				wifi_rssi_state = BTC_RSSI_STATE_HIGH;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], wifi RSSI state switch to High\n");
@@ -243,14 +239,14 @@ static u8 halbtc8821a1ant_WifiRssiState(struct btc_coexist *btcoexist,
 	return wifi_rssi_state;
 }
 
-static void halbtc8821a1ant_update_ra_mask(struct btc_coexist *btcoexist,
-					   bool force_exec, u32 dis_rate_mask)
+static void btc8821a1ant_update_ra_mask(struct btc_coexist *btcoexist,
+					bool force_exec, u32 dis_rate_mask)
 {
 	coex_dm->cur_ra_mask = dis_rate_mask;
 
 	if (force_exec ||
 	    (coex_dm->pre_ra_mask != coex_dm->cur_ra_mask)) {
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_ra_mask,
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_UPDATE_RAMASK,
 				   &coex_dm->cur_ra_mask);
 	}
 	coex_dm->pre_ra_mask = coex_dm->cur_ra_mask;
@@ -259,14 +255,14 @@ static void halbtc8821a1ant_update_ra_mask(struct btc_coexist *btcoexist,
 static void btc8821a1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
 					    bool force_exec, u8 type)
 {
-	bool	wifi_under_b_mode = false;
+	bool wifi_under_b_mode = false;
 
 	coex_dm->cur_arfr_type = type;
 
 	if (force_exec ||
 	    (coex_dm->pre_arfr_type != coex_dm->cur_arfr_type)) {
 		switch (coex_dm->cur_arfr_type) {
-		case 0:	/* normal mode*/
+		case 0:	/* normal mode */
 			btcoexist->btc_write_4byte(btcoexist, 0x430,
 						   coex_dm->backup_arfr_cnt1);
 			btcoexist->btc_write_4byte(btcoexist, 0x434,
@@ -296,19 +292,19 @@ static void btc8821a1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
 	coex_dm->pre_arfr_type = coex_dm->cur_arfr_type;
 }
 
-static void halbtc8821a1ant_retry_limit(struct btc_coexist *btcoexist,
-					bool force_exec, u8 type)
+static void btc8821a1ant_retry_limit(struct btc_coexist *btcoexist,
+				     bool force_exec, u8 type)
 {
 	coex_dm->cur_retry_limit_type = type;
 
 	if (force_exec ||
 	    (coex_dm->pre_retry_limit_type != coex_dm->cur_retry_limit_type)) {
 		switch (coex_dm->cur_retry_limit_type) {
-		case 0:	/* normal mode*/
+		case 0:	/* normal mode */
 			btcoexist->btc_write_2byte(btcoexist, 0x42a,
 						   coex_dm->backup_retry_limit);
 			break;
-		case 1:	/* retry limit = 8*/
+		case 1:	/* retry limit = 8 */
 			btcoexist->btc_write_2byte(btcoexist, 0x42a, 0x0808);
 			break;
 		default:
@@ -318,19 +314,19 @@ static void halbtc8821a1ant_retry_limit(struct btc_coexist *btcoexist,
 	coex_dm->pre_retry_limit_type = coex_dm->cur_retry_limit_type;
 }
 
-static void halbtc8821a1ant_ampdu_max_time(struct btc_coexist *btcoexist,
-					   bool force_exec, u8 type)
+static void btc8821a1ant_ampdu_max_time(struct btc_coexist *btcoexist,
+					bool force_exec, u8 type)
 {
 	coex_dm->cur_ampdu_time_type = type;
 
 	if (force_exec ||
 	    (coex_dm->pre_ampdu_time_type != coex_dm->cur_ampdu_time_type)) {
 		switch (coex_dm->cur_ampdu_time_type) {
-		case 0:	/* normal mode*/
+		case 0:	/* normal mode */
 			btcoexist->btc_write_1byte(btcoexist, 0x456,
 						   coex_dm->backup_ampdu_max_time);
 			break;
-		case 1:	/* AMPDU timw = 0x38 * 32us*/
+		case 1:	/* AMPDU time = 0x38 * 32us */
 			btcoexist->btc_write_1byte(btcoexist, 0x456, 0x38);
 			break;
 		default:
@@ -341,88 +337,85 @@ static void halbtc8821a1ant_ampdu_max_time(struct btc_coexist *btcoexist,
 	coex_dm->pre_ampdu_time_type = coex_dm->cur_ampdu_time_type;
 }
 
-static void halbtc8821a1ant_limited_tx(struct btc_coexist *btcoexist,
-				       bool force_exec, u8 ra_mask_type,
-				       u8 arfr_type, u8 retry_limit_type,
-				       u8 ampdu_time_type)
+static void btc8821a1ant_limited_tx(struct btc_coexist *btcoexist,
+				    bool force_exec, u8 ra_mask_type,
+				    u8 arfr_type, u8 retry_limit_type,
+				    u8 ampdu_time_type)
 {
 	switch (ra_mask_type) {
-	case 0:	/* normal mode*/
-		halbtc8821a1ant_update_ra_mask(btcoexist, force_exec, 0x0);
+	case 0:	/* normal mode */
+		btc8821a1ant_update_ra_mask(btcoexist, force_exec, 0x0);
 		break;
-	case 1:	/* disable cck 1/2*/
-		halbtc8821a1ant_update_ra_mask(btcoexist, force_exec,
-					       0x00000003);
+	case 1:	/* disable cck 1/2 */
+		btc8821a1ant_update_ra_mask(btcoexist, force_exec,
+					    0x00000003);
 		break;
-	case 2:	/* disable cck 1/2/5.5, ofdm 6/9/12/18/24, mcs 0/1/2/3/4*/
-		halbtc8821a1ant_update_ra_mask(btcoexist, force_exec,
-					       0x0001f1f7);
+	case 2:	/* disable cck 1/2/5.5, ofdm 6/9/12/18/24, mcs 0/1/2/3/4 */
+		btc8821a1ant_update_ra_mask(btcoexist, force_exec,
+					    0x0001f1f7);
 		break;
 	default:
 		break;
 	}
 
 	btc8821a1ant_auto_rate_fb_retry(btcoexist, force_exec, arfr_type);
-	halbtc8821a1ant_retry_limit(btcoexist, force_exec, retry_limit_type);
-	halbtc8821a1ant_ampdu_max_time(btcoexist, force_exec, ampdu_time_type);
+	btc8821a1ant_retry_limit(btcoexist, force_exec, retry_limit_type);
+	btc8821a1ant_ampdu_max_time(btcoexist, force_exec, ampdu_time_type);
 }
 
-static void halbtc8821a1ant_limited_rx(struct btc_coexist *btcoexist,
-				       bool force_exec, bool rej_ap_agg_pkt,
-				       bool bt_ctrl_agg_buf_size,
-				       u8 agg_buf_size)
+static void btc8821a1ant_limited_rx(struct btc_coexist *btcoexist,
+				    bool force_exec, bool rej_ap_agg_pkt,
+				    bool bt_ctrl_agg_buf_size, u8 agg_buf_size)
 {
 	bool reject_rx_agg = rej_ap_agg_pkt;
 	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
 	u8 rx_agg_size = agg_buf_size;
 
-	/*============================================*/
-	/*	Rx Aggregation related setting*/
-	/*============================================*/
+	/* Rx Aggregation related setting */
 	btcoexist->btc_set(btcoexist,
 		 BTC_SET_BL_TO_REJ_AP_AGG_PKT, &reject_rx_agg);
-	/* decide BT control aggregation buf size or not*/
+	/* decide BT control aggregation buf size or not */
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_CTRL_AGG_SIZE,
 			   &bt_ctrl_rx_agg_size);
-	/* aggregation buf size, only work when BT control Rx agg size.*/
+	/* aggregation buf size, only work when BT control Rx agg size */
 	btcoexist->btc_set(btcoexist, BTC_SET_U1_AGG_BUF_SIZE, &rx_agg_size);
-	/* real update aggregation setting*/
+	/* real update aggregation setting */
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
 }
 
-static void halbtc8821a1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
+static void btc8821a1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
-	u32	reg_hp_tx_rx, reg_lp_tx_rx, u4_tmp;
-	u32	reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
+	u32 reg_hp_tx_rx, reg_lp_tx_rx, u4_tmp;
+	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 
 	reg_hp_tx_rx = 0x770;
 	reg_lp_tx_rx = 0x774;
 
 	u4_tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_tx_rx);
 	reg_hp_tx = u4_tmp & MASKLWORD;
-	reg_hp_rx = (u4_tmp & MASKHWORD)>>16;
+	reg_hp_rx = (u4_tmp & MASKHWORD) >> 16;
 
 	u4_tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_tx_rx);
 	reg_lp_tx = u4_tmp & MASKLWORD;
-	reg_lp_rx = (u4_tmp & MASKHWORD)>>16;
+	reg_lp_rx = (u4_tmp & MASKHWORD) >> 16;
 
 	coex_sta->high_priority_tx = reg_hp_tx;
 	coex_sta->high_priority_rx = reg_hp_rx;
 	coex_sta->low_priority_tx = reg_lp_tx;
 	coex_sta->low_priority_rx = reg_lp_rx;
 
-	/* reset counter*/
+	/* reset counter */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
-static void halbtc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
+static void btc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
-	h2c_parameter[0] |= BIT0;	/* trigger*/
+	h2c_parameter[0] |= BIT0; /* trigger */
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
@@ -431,10 +424,10 @@ static void halbtc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
+static void btc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info	*bt_link_info = &btcoexist->bt_link_info;
-	bool	bt_hs_on = false;
+	bool bt_hs_on = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
@@ -444,13 +437,13 @@ static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 	bt_link_info->pan_exist = coex_sta->pan_exist;
 	bt_link_info->hid_exist = coex_sta->hid_exist;
 
-	/* work around for HS mode.*/
+	/* work around for HS mode */
 	if (bt_hs_on) {
 		bt_link_info->pan_exist = true;
 		bt_link_info->bt_link_exist = true;
 	}
 
-	/* check if Sco only*/
+	/* check if Sco only */
 	if (bt_link_info->sco_exist &&
 	    !bt_link_info->a2dp_exist &&
 	    !bt_link_info->pan_exist &&
@@ -459,7 +452,7 @@ static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 	else
 		bt_link_info->sco_only = false;
 
-	/* check if A2dp only*/
+	/* check if A2dp only */
 	if (!bt_link_info->sco_exist &&
 	    bt_link_info->a2dp_exist &&
 	    !bt_link_info->pan_exist &&
@@ -468,7 +461,7 @@ static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 	else
 		bt_link_info->a2dp_only = false;
 
-	/* check if Pan only*/
+	/* check if Pan only */
 	if (!bt_link_info->sco_exist &&
 	    !bt_link_info->a2dp_exist &&
 	    bt_link_info->pan_exist &&
@@ -477,7 +470,7 @@ static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 	else
 		bt_link_info->pan_only = false;
 
-	/* check if Hid only*/
+	/* check if Hid only */
 	if (!bt_link_info->sco_exist &&
 	    !bt_link_info->a2dp_exist &&
 	    !bt_link_info->pan_exist &&
@@ -487,13 +480,13 @@ static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 		bt_link_info->hid_only = false;
 }
 
-static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
+static u8 btc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool	bt_hs_on = false;
-	u8	algorithm = BT_8821A_1ANT_COEX_ALGO_UNDEFINED;
-	u8	num_of_diff_profile = 0;
+	bool bt_hs_on = false;
+	u8 algorithm = BT_8821A_1ANT_COEX_ALGO_UNDEFINED;
+	u8 num_of_diff_profile = 0;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
@@ -605,7 +598,7 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 					 "[BTCoex], BT Profile = SCO + HID + A2DP ==> HID\n");
 				algorithm = BT_8821A_1ANT_COEX_ALGO_HID;
 			} else if (bt_link_info->hid_exist &&
-				bt_link_info->pan_exist) {
+				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
@@ -618,7 +611,7 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 					algorithm = BT_8821A_1ANT_COEX_ALGO_PANEDR_HID;
 				}
 			} else if (bt_link_info->pan_exist &&
-				bt_link_info->a2dp_exist) {
+				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
 					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
 						 DBG_LOUD,
@@ -670,8 +663,8 @@ static u8 halbtc8821a1ant_action_algorithm(struct btc_coexist *btcoexist)
 	return algorithm;
 }
 
-static void btc8821a1ant_set_sw_pen_tx_rate(struct btc_coexist *btcoexist,
-					    bool low_penalty_ra)
+static void btc8821a1ant_set_sw_penalty_tx_rate(struct btc_coexist *btcoexist,
+						bool low_penalty_ra)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[6] = {0};
@@ -680,11 +673,11 @@ static void btc8821a1ant_set_sw_pen_tx_rate(struct btc_coexist *btcoexist,
 
 	if (low_penalty_ra) {
 		h2c_parameter[1] |= BIT0;
-		/*normal rate except MCS7/6/5, OFDM54/48/36*/
+		/* normal rate except MCS7/6/5, OFDM54/48/36 */
 		h2c_parameter[2] = 0x00;
-		h2c_parameter[3] = 0xf7;  /*MCS7 or OFDM54*/
-		h2c_parameter[4] = 0xf8;  /*MCS6 or OFDM48*/
-		h2c_parameter[5] = 0xf9;	/*MCS5 or OFDM36*/
+		h2c_parameter[3] = 0xf7; /* MCS7 or OFDM54 */
+		h2c_parameter[4] = 0xf8; /* MCS6 or OFDM48 */
+		h2c_parameter[5] = 0xf9; /* MCS5 or OFDM36 */
 	}
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -694,8 +687,8 @@ static void btc8821a1ant_set_sw_pen_tx_rate(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x69, 6, h2c_parameter);
 }
 
-static void halbtc8821a1ant_low_penalty_ra(struct btc_coexist *btcoexist,
-					   bool force_exec, bool low_penalty_ra)
+static void btc8821a1ant_low_penalty_ra(struct btc_coexist *btcoexist,
+					bool force_exec, bool low_penalty_ra)
 {
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
@@ -703,14 +696,15 @@ static void halbtc8821a1ant_low_penalty_ra(struct btc_coexist *btcoexist,
 		if (coex_dm->pre_low_penalty_ra == coex_dm->cur_low_penalty_ra)
 			return;
 	}
-	btc8821a1ant_set_sw_pen_tx_rate(btcoexist, coex_dm->cur_low_penalty_ra);
+	btc8821a1ant_set_sw_penalty_tx_rate(btcoexist,
+					    coex_dm->cur_low_penalty_ra);
 
 	coex_dm->pre_low_penalty_ra = coex_dm->cur_low_penalty_ra;
 }
 
-static void halbtc8821a1ant_set_coex_table(struct btc_coexist *btcoexist,
-					   u32 val0x6c0, u32 val0x6c4,
-					   u32 val0x6c8, u8 val0x6cc)
+static void btc8821a1ant_set_coex_table(struct btc_coexist *btcoexist,
+					u32 val0x6c0, u32 val0x6c4,
+					u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -731,9 +725,9 @@ static void halbtc8821a1ant_set_coex_table(struct btc_coexist *btcoexist,
 	btcoexist->btc_write_1byte(btcoexist, 0x6cc, val0x6cc);
 }
 
-static void halbtc8821a1ant_coex_table(struct btc_coexist *btcoexist,
-				       bool force_exec, u32 val0x6c0,
-				       u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
+static void btc8821a1ant_coex_table(struct btc_coexist *btcoexist,
+				    bool force_exec, u32 val0x6c0, u32 val0x6c4,
+				    u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -753,8 +747,8 @@ static void halbtc8821a1ant_coex_table(struct btc_coexist *btcoexist,
 		    (coex_dm->pre_val_0x6cc == coex_dm->cur_val_0x6cc))
 			return;
 	}
-	halbtc8821a1ant_set_coex_table(btcoexist, val0x6c0, val0x6c4,
-				       val0x6c8, val0x6cc);
+	btc8821a1ant_set_coex_table(btcoexist, val0x6c0, val0x6c4,
+				    val0x6c8, val0x6cc);
 
 	coex_dm->pre_val_0x6c0 = coex_dm->cur_val_0x6c0;
 	coex_dm->pre_val_0x6c4 = coex_dm->cur_val_0x6c4;
@@ -762,42 +756,41 @@ static void halbtc8821a1ant_coex_table(struct btc_coexist *btcoexist,
 	coex_dm->pre_val_0x6cc = coex_dm->cur_val_0x6cc;
 }
 
-static void halbtc8821a1ant_coex_table_with_type(struct btc_coexist *btcoexist,
-						 bool force_exec, u8 type)
+static void btc8821a1ant_coex_table_with_type(struct btc_coexist *btcoexist,
+					      bool force_exec, u8 type)
 {
 	switch (type) {
 	case 0:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
-					   0x55555555, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0x55555555, 0xffffff, 0x3);
 		break;
 	case 1:
-			halbtc8821a1ant_coex_table(btcoexist, force_exec,
-						   0x55555555, 0x5a5a5a5a,
-						   0xffffff, 0x3);
-			break;
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0x5a5a5a5a, 0xffffff, 0x3);
+		break;
 	case 2:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
-					   0x5a5a5a5a, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x5a5a5a5a,
+					0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 3:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
-					   0xaaaaaaaa, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55555555,
+					0xaaaaaaaa, 0xffffff, 0x3);
 		break;
 	case 4:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0xffffffff,
-					   0xffffffff, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0xffffffff,
+					0xffffffff, 0xffffff, 0x3);
 		break;
 	case 5:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
-					   0x5fff5fff, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					0x5fff5fff, 0xffffff, 0x3);
 		break;
 	case 6:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
+					0x5a5a5a5a, 0xffffff, 0x3);
 		break;
 	case 7:
-		halbtc8821a1ant_coex_table(btcoexist, force_exec, 0x5afa5afa,
-					   0x5afa5afa, 0xffffff, 0x3);
+		btc8821a1ant_coex_table(btcoexist, force_exec, 0x5afa5afa,
+					0x5afa5afa, 0xffffff, 0x3);
 		break;
 	default:
 		break;
@@ -808,10 +801,10 @@ static void btc8821a1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 						bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8	h2c_parameter[1] = {0};
+	u8 h2c_parameter[1] = {0};
 
 	if (enable)
-		h2c_parameter[0] |= BIT0;	/* function enable*/
+		h2c_parameter[0] |= BIT0; /* function enable */
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
@@ -820,8 +813,8 @@ static void btc8821a1ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
 }
 
-static void halbtc8821a1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
-					    bool force_exec, bool enable)
+static void btc8821a1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
+					 bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -845,9 +838,8 @@ static void halbtc8821a1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
 }
 
-static void halbtc8821a1ant_set_fw_pstdma(struct btc_coexist *btcoexist,
-					  u8 byte1, u8 byte2, u8 byte3,
-					  u8 byte4, u8 byte5)
+static void btc8821a1ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
+					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[5] = {0};
@@ -874,18 +866,18 @@ static void halbtc8821a1ant_set_fw_pstdma(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
-static void halbtc8821a1ant_set_lps_rpwm(struct btc_coexist *btcoexist,
-					 u8 lps_val, u8 rpwm_val)
+static void btc8821a1ant_set_lps_rpwm(struct btc_coexist *btcoexist,
+				      u8 lps_val, u8 rpwm_val)
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
+static void btc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist,
+				  bool force_exec, u8 lps_val, u8 rpwm_val)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -909,33 +901,33 @@ static void halbtc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist,
 			return;
 		}
 	}
-	halbtc8821a1ant_set_lps_rpwm(btcoexist, lps_val, rpwm_val);
+	btc8821a1ant_set_lps_rpwm(btcoexist, lps_val, rpwm_val);
 
 	coex_dm->pre_lps = coex_dm->cur_lps;
 	coex_dm->pre_rpwm = coex_dm->cur_rpwm;
 }
 
-static void halbtc8821a1ant_sw_mechanism(struct btc_coexist *btcoexist,
-					 bool low_penalty_ra)
+static void btc8821a1ant_sw_mechanism(struct btc_coexist *btcoexist,
+				      bool low_penalty_ra)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], SM[LpRA] = %d\n", low_penalty_ra);
 
-	halbtc8821a1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
+	btc8821a1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
 
-static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
-					 u8 ant_pos_type, bool init_hw_cfg,
-					 bool wifi_off)
+static void btc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
+				      u8 ant_pos_type, bool init_hw_cfg,
+				      bool wifi_off)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	u32 u4_tmp = 0;
 	u8 h2c_parameter[2] = {0};
 
 	if (init_hw_cfg) {
-		/* 0x4c[23] = 0, 0x4c[24] = 1  Antenna control by WL/BT*/
+		/* 0x4c[23] = 0, 0x4c[24] = 1  Antenna control by WL/BT */
 		u4_tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
 		u4_tmp &= ~BIT23;
 		u4_tmp |= BIT24;
@@ -945,31 +937,31 @@ static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
 
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
-			/*tell firmware "antenna inverse"  ==>
-			 * WRONG firmware antenna control code.==>need fw to fix
+			/* tell firmware "antenna inverse"
+			 * WRONG firmware antenna control code, need fw to fix
 			 */
 			h2c_parameter[0] = 1;
 			h2c_parameter[1] = 1;
 			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 						h2c_parameter);
-			/*Main Ant to  BT for IPS case 0x4c[23] = 1*/
+			/* Main Ant to  BT for IPS case 0x4c[23] = 1 */
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64,
 							   0x1, 0x1);
 		} else {
-			/*tell firmware "no antenna inverse" ==>
-			 * WRONG firmware antenna control code.==>need fw to fix
+			/* tell firmware "no antenna inverse"
+			 * WRONG firmware antenna control code, need fw to fix
 			 */
 			h2c_parameter[0] = 0;
 			h2c_parameter[1] = 1;
 			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 						h2c_parameter);
-			/*Aux Ant to  BT for IPS case 0x4c[23] = 1*/
+			/* Aux Ant to BT for IPS case 0x4c[23] = 1 */
 			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64,
 							   0x1, 0x0);
 		}
 	} else if (wifi_off) {
 		/* 0x4c[24:23] = 00, Set Antenna control
-		 *	by BT_RFE_CTRL	BT Vendor 0xac = 0xf002
+		 * by BT_RFE_CTRL BT Vendor 0xac = 0xf002
 		 */
 		u4_tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
 		u4_tmp &= ~BIT23;
@@ -977,7 +969,7 @@ static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_4byte(btcoexist, 0x4c, u4_tmp);
 	}
 
-	/* ext switch setting*/
+	/* ext switch setting */
 	switch (ant_pos_type) {
 	case BTC_ANT_PATH_WIFI:
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT)
@@ -1007,8 +999,8 @@ static void halbtc8821a1ant_set_ant_path(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
-				    bool force_exec, bool turn_on, u8 type)
+static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
+				 bool force_exec, bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 rssi_adjust_val = 0;
@@ -1033,185 +1025,189 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 	if (turn_on) {
 		switch (type) {
 		default:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x1a,
-						      0x1a, 0x0, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x1a,
+						    0x1a, 0x0, 0x50);
 			break;
 		case 1:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x3a,
-						      0x03, 0x10, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x3a,
+						    0x03, 0x10, 0x50);
 			rssi_adjust_val = 11;
 			break;
 		case 2:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x2b,
-						      0x03, 0x10, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x2b,
+						    0x03, 0x10, 0x50);
 			rssi_adjust_val = 14;
 			break;
 		case 3:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x1d,
-						      0x1d, 0x0, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x1d,
+						    0x1d, 0x0, 0x10);
 			break;
 		case 4:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x93, 0x15,
-						      0x3, 0x14, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x93, 0x15,
+						    0x3, 0x14, 0x0);
 			rssi_adjust_val = 17;
 			break;
 		case 5:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x15,
-						      0x3, 0x11, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x15,
+						    0x3, 0x11, 0x10);
 			break;
 		case 6:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa,
-						      0x3, 0x0, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x13, 0xa,
+						    0x3, 0x0, 0x0);
 			break;
 		case 7:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xc,
-						      0x5, 0x0, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x13, 0xc,
+						    0x5, 0x0, 0x0);
 			break;
 		case 8:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x93, 0x25,
-						      0x3, 0x10, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x93, 0x25,
+						    0x3, 0x10, 0x0);
 			break;
 		case 9:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x21,
-						      0x3, 0x10, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x21,
+						    0x3, 0x10, 0x50);
 			rssi_adjust_val = 18;
 			break;
 		case 10:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa,
-						      0xa, 0x0, 0x40);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x13, 0xa,
+						    0xa, 0x0, 0x40);
 			break;
 		case 11:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x14,
-						      0x03, 0x10, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x14,
+						    0x03, 0x10, 0x10);
 			rssi_adjust_val = 20;
 			break;
 		case 12:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x0a,
-						      0x0a, 0x0, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x0a,
+						    0x0a, 0x0, 0x50);
 			break;
 		case 13:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x18,
-						      0x18, 0x0, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x18,
+						    0x18, 0x0, 0x10);
 			break;
 		case 14:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x21,
-						      0x3, 0x10, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x21,
+						    0x3, 0x10, 0x10);
 			break;
 		case 15:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x13, 0xa,
-						      0x3, 0x8, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x13, 0xa,
+						    0x3, 0x8, 0x0);
 			break;
 		case 16:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x93, 0x15,
-						      0x3, 0x10, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x93, 0x15,
+						    0x3, 0x10, 0x0);
 			rssi_adjust_val = 18;
 			break;
 		case 18:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x93, 0x25,
-						      0x3, 0x10, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x93, 0x25,
+						    0x3, 0x10, 0x0);
 			rssi_adjust_val = 14;
 			break;
 		case 20:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x35,
-						      0x03, 0x11, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x35,
+						    0x03, 0x11, 0x10);
 			break;
 		case 21:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x15,
-						      0x03, 0x11, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x15,
+						    0x03, 0x11, 0x10);
 			break;
 		case 22:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0x25,
-						      0x03, 0x11, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0x25,
+						    0x03, 0x11, 0x10);
 			break;
 		case 23:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0x25,
-						      0x3, 0x31, 0x18);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
+						    0x3, 0x31, 0x18);
 			rssi_adjust_val = 22;
 			break;
 		case 24:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0x15,
-						      0x3, 0x31, 0x18);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x15,
+						    0x3, 0x31, 0x18);
 			rssi_adjust_val = 22;
 			break;
 		case 25:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0x3, 0x31, 0x18);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
+						    0x3, 0x31, 0x18);
 			rssi_adjust_val = 22;
 			break;
 		case 26:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0x3, 0x31, 0x18);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
+						    0x3, 0x31, 0x18);
 			rssi_adjust_val = 22;
 			break;
 		case 27:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xe3, 0x25,
-						      0x3, 0x31, 0x98);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
+						    0x3, 0x31, 0x98);
 			rssi_adjust_val = 22;
 			break;
 		case 28:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x69, 0x25,
-						      0x3, 0x31, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x69, 0x25,
+						    0x3, 0x31, 0x0);
 			break;
 		case 29:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xab, 0x1a,
-						      0x1a, 0x1, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xab, 0x1a,
+						    0x1a, 0x1, 0x10);
 			break;
 		case 30:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x51, 0x14,
-						      0x3, 0x10, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x51, 0x14,
+						    0x3, 0x10, 0x50);
 			break;
 		case 31:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xd3, 0x1a,
-						      0x1a, 0, 0x58);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x1a,
+						    0x1a, 0, 0x58);
 			break;
 		case 32:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x61, 0xa,
-						      0x3, 0x10, 0x0);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x61, 0xa,
+						    0x3, 0x10, 0x0);
 			break;
 		case 33:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xa3, 0x25,
-						      0x3, 0x30, 0x90);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x25,
+						    0x3, 0x30, 0x90);
 			break;
 		case 34:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x53, 0x1a,
-						      0x1a, 0x0, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x53, 0x1a,
+						    0x1a, 0x0, 0x10);
 			break;
 		case 35:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x63, 0x1a,
-						      0x1a, 0x0, 0x10);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x63, 0x1a,
+						    0x1a, 0x0, 0x10);
 			break;
 		case 36:
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0xd3, 0x12,
-						      0x3, 0x14, 0x50);
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0xd3, 0x12,
+						    0x3, 0x14, 0x50);
 			break;
 		}
 	} else {
-		/* disable PS tdma*/
+		/* disable PS tdma */
 		switch (type) {
-		case 8: /*PTA Control*/
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x8, 0x0, 0x0,
-						      0x0, 0x0);
-			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
-						     false, false);
+		case 8:
+			/* PTA Control */
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x8, 0x0, 0x0,
+						    0x0, 0x0);
+			btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+						  false, false);
 			break;
 		case 0:
-		default:  /*Software control, Antenna at BT side*/
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
-						      0x0, 0x0);
-			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
-						     false, false);
+		default:
+			/* Software control, Antenna at BT side */
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0, 0x0,
+						    0x0, 0x0);
+			btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
+						  false, false);
 			break;
-		case 9:   /*Software control, Antenna at WiFi side*/
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
-						      0x0, 0x0);
-			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_WIFI,
-						     false, false);
+		case 9:
+			/* Software control, Antenna at WiFi side */
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0, 0x0,
+						    0x0, 0x0);
+			btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_WIFI,
+						  false, false);
 			break;
-		case 10:	/* under 5G*/
-			halbtc8821a1ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
-						      0x8, 0x0);
-			halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
-						     false, false);
+		case 10:
+			/* under 5G */
+			btc8821a1ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0, 0x0,
+						    0x8, 0x0);
+			btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
+						  false, false);
 			break;
 		}
 	}
@@ -1219,15 +1215,15 @@ static void halbtc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 	btcoexist->btc_set(btcoexist,
 		 BTC_SET_U1_RSSI_ADJ_VAL_FOR_1ANT_COEX_TYPE, &rssi_adjust_val);
 
-	/* update pre state*/
+	/* update pre state */
 	coex_dm->pre_ps_tdma_on = coex_dm->cur_ps_tdma_on;
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
+static bool btc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool	common = false, wifi_connected = false, wifi_busy = false;
+	bool common = false, wifi_connected = false, wifi_busy = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 			   &wifi_connected);
@@ -1238,7 +1234,7 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 	    coex_dm->bt_status) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi non connected-idle + BT non connected-idle!!\n");
-		halbtc8821a1ant_sw_mechanism(btcoexist, false);
+		btc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (wifi_connected &&
@@ -1246,7 +1242,7 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 		    coex_dm->bt_status)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi connected + BT non connected-idle!!\n");
-		halbtc8821a1ant_sw_mechanism(btcoexist, false);
+		btc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (!wifi_connected &&
@@ -1254,15 +1250,15 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 		    coex_dm->bt_status)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi non connected-idle + BT connected-idle!!\n");
-		halbtc8821a1ant_sw_mechanism(btcoexist, false);
+		btc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (wifi_connected &&
 		   (BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE ==
-		   coex_dm->bt_status)) {
+		    coex_dm->bt_status)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi connected + BT connected-idle!!\n");
-		halbtc8821a1ant_sw_mechanism(btcoexist, false);
+		btc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else if (!wifi_connected &&
@@ -1270,7 +1266,7 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 		    coex_dm->bt_status)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi non connected-idle + BT Busy!!\n");
-		halbtc8821a1ant_sw_mechanism(btcoexist, false);
+		btc8821a1ant_sw_mechanism(btcoexist, false);
 
 		common = true;
 	} else {
@@ -1291,38 +1287,37 @@ static bool halbtc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 static void btc8821a1ant_ps_tdma_check_for_pwr_save(struct btc_coexist *btcoex,
 						    bool new_ps_state)
 {
-	u8	lps_mode = 0x0;
+	u8 lps_mode = 0x0;
 
 	btcoex->btc_get(btcoex, BTC_GET_U1_LPS_MODE, &lps_mode);
 
 	if (lps_mode) {
-		/* already under LPS state*/
+		/* already under LPS state */
 		if (new_ps_state) {
-			/* keep state under LPS, do nothing.*/
+			/* keep state under LPS, do nothing */
 		} else {
-			/* will leave LPS state, turn off psTdma first*/
-			halbtc8821a1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 0);
+			/* will leave LPS state, turn off psTdma first */
+			btc8821a1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 0);
 		}
 	} else {
 		/* NO PS state*/
 		if (new_ps_state) {
-			/* will enter LPS state, turn off psTdma first*/
-			halbtc8821a1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 0);
+			/* will enter LPS state, turn off psTdma first */
+			btc8821a1ant_ps_tdma(btcoex, NORMAL_EXEC, false, 0);
 		} else {
-			/* keep state under NO PS state, do nothing.*/
+			/* keep state under NO PS state, do nothing */
 		}
 	}
 }
 
-static void halbtc8821a1ant_power_save_state(struct btc_coexist *btcoexist,
-					     u8 ps_type, u8 lps_val,
-					     u8 rpwm_val)
+static void btc8821a1ant_power_save_state(struct btc_coexist *btcoexist,
+					  u8 ps_type, u8 lps_val, u8 rpwm_val)
 {
 	bool low_pwr_disable = false;
 
 	switch (ps_type) {
 	case BTC_PS_WIFI_NATIVE:
-		/* recover to original 32k low power setting*/
+		/* recover to original 32k low power setting */
 		low_pwr_disable = false;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
@@ -1331,13 +1326,13 @@ static void halbtc8821a1ant_power_save_state(struct btc_coexist *btcoexist,
 	case BTC_PS_LPS_ON:
 		btc8821a1ant_ps_tdma_check_for_pwr_save(btcoexist,
 							true);
-		halbtc8821a1ant_lps_rpwm(btcoexist,
-					 NORMAL_EXEC, lps_val, rpwm_val);
-		/* when coex force to enter LPS, do not enter 32k low power.*/
+		btc8821a1ant_lps_rpwm(btcoexist, NORMAL_EXEC, lps_val,
+				      rpwm_val);
+		/* when coex force to enter LPS, do not enter 32k low power */
 		low_pwr_disable = true;
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 				   &low_pwr_disable);
-		/* power save must executed before psTdma.*/
+		/* power save must executed before psTdma */
 		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ENTER_LPS, NULL);
 		break;
 	case BTC_PS_LPS_OFF:
@@ -1349,19 +1344,19 @@ static void halbtc8821a1ant_power_save_state(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8821a1ant_coex_under_5g(struct btc_coexist *btcoexist)
+static void btc8821a1ant_coex_under_5g(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
-					 0x0, 0x0);
-	halbtc8821a1ant_ignore_wlan_act(btcoexist, NORMAL_EXEC, true);
+	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+				      0x0, 0x0);
+	btc8821a1ant_ignore_wlan_act(btcoexist, NORMAL_EXEC, true);
 
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 10);
+	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 10);
 
-	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 
-	halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+	btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
 
-	halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 5);
+	btc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 5);
 }
 
 /***********************************************
@@ -1370,74 +1365,74 @@ static void halbtc8821a1ant_coex_under_5g(struct btc_coexist *btcoexist)
  *
  ***********************************************/
 
-/* SCO only or SCO+PAN(HS)*/
-static void halbtc8821a1ant_action_sco(struct btc_coexist *btcoexist)
+/* SCO only or SCO+PAN(HS) */
+static void btc8821a1ant_action_sco(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, true);
+	btc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-static void halbtc8821a1ant_action_hid(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_hid(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, true);
+	btc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-/*A2DP only / PAN(EDR) only/ A2DP+PAN(HS)*/
-static void halbtc8821a1ant_action_a2dp(struct btc_coexist *btcoexist)
+/* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
+static void btc8821a1ant_action_a2dp(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, false);
+	btc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-static void halbtc8821a1ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, false);
+	btc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-static void halbtc8821a1ant_action_pan_edr(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, false);
+	btc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-/*PAN(HS) only*/
-static void halbtc8821a1ant_action_pan_hs(struct btc_coexist *btcoexist)
+/* PAN(HS) only */
+static void btc8821a1ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, false);
+	btc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-/*PAN(EDR)+A2DP*/
-static void halbtc8821a1ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
+/* PAN(EDR)+A2DP */
+static void btc8821a1ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, false);
+	btc8821a1ant_sw_mechanism(btcoexist, false);
 }
 
-static void halbtc8821a1ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, true);
+	btc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-/* HID+A2DP+PAN(EDR)*/
+/* HID+A2DP+PAN(EDR) */
 static void btc8821a1ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, true);
+	btc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-static void halbtc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_sw_mechanism(btcoexist, true);
+	btc8821a1ant_sw_mechanism(btcoexist, true);
 }
 
-/*=============================================*/
-/**/
-/*	Non-Software Coex Mechanism start*/
-/**/
-/*=============================================*/
+/***********************************************
+ *
+ *	Non-Software Coex Mechanism start
+ *
+ ***********************************************/
 
-static void halbtc8821a1ant_action_hs(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_hs(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-	halbtc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 2);
+	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
+	btc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 2);
 }
 
-static void halbtc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false;
@@ -1446,133 +1441,136 @@ static void halbtc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 		 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
 
 	if (!wifi_connected) {
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_power_save_state(btcoexist,
+					      BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if ((bt_link_info->sco_exist) ||
 		   (bt_link_info->hid_only)) {
-		/* SCO/HID-only busy*/
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		/* SCO/HID-only busy */
+		btc8821a1ant_power_save_state(btcoexist,
+					      BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 32);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else {
-		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_LPS_ON,
-						 0x50, 0x4);
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 30);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_power_save_state(btcoexist, BTC_PS_LPS_ON,
+					      0x50, 0x4);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 30);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	}
 }
 
 static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
 						  u8 wifi_status) {
-	/* tdma and coex table*/
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
+	/* tdma and coex table */
+	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
 
-	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	if (BT_8821A_1ANT_WIFI_STATUS_NON_CONNECTED_ASSO_AUTH_SCAN ==
+	    wifi_status)
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	else
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 }
 
 static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 						  u8 wifi_status)
 {
-	u8		bt_rssi_state;
+	u8 bt_rssi_state;
 
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
-	bt_rssi_state = halbtc8821a1ant_bt_rssi_state(btcoexist, 2, 28, 0);
+	bt_rssi_state = btc8821a1ant_bt_rssi_state(btcoexist, 2, 28, 0);
 
 	if (bt_link_info->hid_only) {
-		/*HID*/
+		/* HID */
 		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
 						      wifi_status);
 		coex_dm->auto_tdma_adjust = false;
 		return;
 	} else if (bt_link_info->a2dp_only) {
-		/*A2DP*/
+		/* A2DP */
 		if ((bt_rssi_state != BTC_RSSI_STATE_HIGH) &&
 		    (bt_rssi_state != BTC_RSSI_STATE_STAY_HIGH)) {
-			/*for low BT RSSI*/
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
+			/* for low BT RSSI */
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 11);
 			coex_dm->auto_tdma_adjust = false;
 		}
 
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if (bt_link_info->hid_exist && bt_link_info->a2dp_exist) {
-		/*HID+A2DP*/
+		/* HID+A2DP */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 14);
 			coex_dm->auto_tdma_adjust = false;
 		} else {
 			/*for low BT RSSI*/
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 11);
 			coex_dm->auto_tdma_adjust = false;
 		}
 
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	} else if ((bt_link_info->pan_only) ||
 		(bt_link_info->hid_exist && bt_link_info->pan_exist)) {
-		/*PAN(OPP, FTP), HID+PAN(OPP, FTP)*/
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		/* PAN(OPP, FTP), HID+PAN(OPP, FTP) */
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 		coex_dm->auto_tdma_adjust = false;
 	} else if (((bt_link_info->a2dp_exist) && (bt_link_info->pan_exist)) ||
 		   (bt_link_info->hid_exist && bt_link_info->a2dp_exist &&
 		    bt_link_info->pan_exist)) {
-		/*A2DP+PAN(OPP, FTP), HID+A2DP+PAN(OPP, FTP)*/
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		/* A2DP+PAN(OPP, FTP), HID+A2DP+PAN(OPP, FTP) */
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 13);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 		coex_dm->auto_tdma_adjust = false;
 	} else {
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 		coex_dm->auto_tdma_adjust = false;
 	}
 }
 
-static void halbtc8821a1ant_action_wifi_not_connected(
-	struct btc_coexist *btcoexist)
+static
+void btc8821a1ant_action_wifi_not_connected(struct btc_coexist *btcoexist)
 {
-	/* power save state*/
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	/* power save state */
+	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 
-	/* tdma and coex table*/
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
-	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+	/* tdma and coex table */
+	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
 static void btc8821a1ant_act_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	btc8821a1ant_power_save_state(btcoexist,
+				      BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 
-	halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
-	halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+	btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 }
 
-static void halbtc8821a1ant_action_wifi_connected_scan(
-	struct btc_coexist *btcoexist) {
+static
+void btc8821a1ant_action_wifi_connected_scan(struct btc_coexist *btcoexist)
+{
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
-	/* power save state*/
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	/* power save state */
+	btc8821a1ant_power_save_state(btcoexist,
+				      BTC_PS_WIFI_NATIVE, 0x0, 0x0);
 
-	/* tdma and coex table*/
+	/* tdma and coex table */
 	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
 		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 22);
-			halbtc8821a1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 1);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
 		} else {
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	}
 	} else if ((BT_8821A_1ANT_BT_STATUS_SCO_BUSY ==
 		    coex_dm->bt_status) ||
@@ -1581,52 +1579,52 @@ static void halbtc8821a1ant_action_wifi_connected_scan(
 		btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
 			BT_8821A_1ANT_WIFI_STATUS_CONNECTED_SCAN);
 	} else {
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	}
 }
 
 static void btc8821a1ant_act_wifi_conn_sp_pkt(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool	hs_connecting = false;
+	bool hs_connecting = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_CONNECTING, &hs_connecting);
 
-	halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
-					 0x0, 0x0);
+	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+				      0x0, 0x0);
 
-	/* tdma and coex table*/
-	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
+	/* tdma and coex table */
+	if (coex_dm->bt_status == BT_8821A_1ANT_BT_STATUS_ACL_BUSY) {
 		if (bt_link_info->a2dp_exist && bt_link_info->pan_exist) {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 22);
-			halbtc8821a1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 1);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 22);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
 		} else {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 20);
-			halbtc8821a1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 1);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 20);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 1);
 		}
 	} else {
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
-		halbtc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 20);
+		btc8821a1ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 1);
 	}
 }
 
-static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
+static void btc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool	wifi_busy = false;
-	bool	scan = false, link = false, roam = false;
-	bool	under_4way = false;
+	bool wifi_busy = false;
+	bool scan = false, link = false, roam = false;
+	bool under_4way = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], CoexForWifiConnect()===>\n");
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_4_WAY_PROGRESS, &under_4way);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_4_WAY_PROGRESS,
+			   &under_4way);
 	if (under_4way) {
 		btc8821a1ant_act_wifi_conn_sp_pkt(btcoexist);
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -1638,7 +1636,7 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 	if (scan || link || roam) {
-		halbtc8821a1ant_action_wifi_connected_scan(btcoexist);
+		btc8821a1ant_action_wifi_connected_scan(btcoexist);
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], CoexForWifiConnect(), return for wifi is under scan<===\n");
 		return;
@@ -1647,14 +1645,14 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 	/* power save state*/
 	if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY ==
 			coex_dm->bt_status && !btcoexist->bt_link_info.hid_only)
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_LPS_ON, 0x50, 0x4);
+		btc8821a1ant_power_save_state(btcoexist,
+					      BTC_PS_LPS_ON, 0x50, 0x4);
 	else
-		halbtc8821a1ant_power_save_state(btcoexist,
-						 BTC_PS_WIFI_NATIVE,
-						 0x0, 0x0);
+		btc8821a1ant_power_save_state(btcoexist,
+					      BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
 
-	/* tdma and coex table*/
+	/* tdma and coex table */
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 	if (!wifi_busy) {
 		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
@@ -1667,10 +1665,10 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 			btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_IDLE);
 		} else {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			halbtc8821a1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 2);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 5);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 2);
 		}
 	} else {
 		if (BT_8821A_1ANT_BT_STATUS_ACL_BUSY == coex_dm->bt_status) {
@@ -1683,10 +1681,9 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 			btc8821a1ant_act_bt_sco_hid_only_busy(btcoexist,
 				BT_8821A_1ANT_WIFI_STATUS_CONNECTED_BUSY);
 		} else {
-			halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			halbtc8821a1ant_coex_table_with_type(btcoexist,
-							     NORMAL_EXEC, 2);
+			btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
+			btc8821a1ant_coex_table_with_type(btcoexist,
+							  NORMAL_EXEC, 2);
 		}
 	}
 }
@@ -1694,52 +1691,52 @@ static void halbtc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8	algorithm = 0;
+	u8 algorithm = 0;
 
-	algorithm = halbtc8821a1ant_action_algorithm(btcoexist);
+	algorithm = btc8821a1ant_action_algorithm(btcoexist);
 	coex_dm->cur_algorithm = algorithm;
 
-	if (!halbtc8821a1ant_is_common_action(btcoexist)) {
+	if (!btc8821a1ant_is_common_action(btcoexist)) {
 		switch (coex_dm->cur_algorithm) {
 		case BT_8821A_1ANT_COEX_ALGO_SCO:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = SCO\n");
-			halbtc8821a1ant_action_sco(btcoexist);
+			btc8821a1ant_action_sco(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = HID\n");
-			halbtc8821a1ant_action_hid(btcoexist);
+			btc8821a1ant_action_hid(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = A2DP\n");
-			halbtc8821a1ant_action_a2dp(btcoexist);
+			btc8821a1ant_action_a2dp(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_A2DP_PANHS:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = A2DP+PAN(HS)\n");
-			halbtc8821a1ant_action_a2dp_pan_hs(btcoexist);
+			btc8821a1ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = PAN(EDR)\n");
-			halbtc8821a1ant_action_pan_edr(btcoexist);
+			btc8821a1ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANHS:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = HS mode\n");
-			halbtc8821a1ant_action_pan_hs(btcoexist);
+			btc8821a1ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = PAN+A2DP\n");
-			halbtc8821a1ant_action_pan_edr_a2dp(btcoexist);
+			btc8821a1ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_PANEDR_HID:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = PAN(EDR)+HID\n");
-			halbtc8821a1ant_action_pan_edr_hid(btcoexist);
+			btc8821a1ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8821A_1ANT_COEX_ALGO_HID_A2DP_PANEDR:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -1749,28 +1746,28 @@ static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
 		case BT_8821A_1ANT_COEX_ALGO_HID_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = HID+A2DP\n");
-			halbtc8821a1ant_action_hid_a2dp(btcoexist);
+			btc8821a1ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action algorithm = coexist All Off!!\n");
-			/*halbtc8821a1ant_coex_all_off(btcoexist);*/
+			/*btc8821a1ant_coex_all_off(btcoexist);*/
 			break;
 		}
 		coex_dm->pre_algorithm = coex_dm->cur_algorithm;
 	}
 }
 
-static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
+static void btc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
-	bool	wifi_connected = false, bt_hs_on = false;
-	bool	increase_scan_dev_num = false;
-	bool	bt_ctrl_agg_buf_size = false;
-	u8	agg_buf_size = 5;
-	u8	wifi_rssi_state = BTC_RSSI_STATE_HIGH;
-	bool	wifi_under_5g = false;
+	bool wifi_connected = false, bt_hs_on = false;
+	bool increase_scan_dev_num = false;
+	bool bt_ctrl_agg_buf_size = false;
+	u8 agg_buf_size = 5;
+	u8 wifi_rssi_state = BTC_RSSI_STATE_HIGH;
+	bool wifi_under_5g = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], RunCoexistMechanism()===>\n");
@@ -1797,7 +1794,7 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	if (wifi_under_5g) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], RunCoexistMechanism(), return for 5G <===\n");
-		halbtc8821a1ant_coex_under_5g(btcoexist);
+		btc8821a1ant_coex_under_5g(btcoexist);
 		return;
 	}
 
@@ -1809,21 +1806,29 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_INC_SCAN_DEV_NUM,
 			   &increase_scan_dev_num);
 
-	btcoexist->btc_get(btcoexist,
-		 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
 
 	if (!bt_link_info->sco_exist && !bt_link_info->hid_exist) {
-		halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
+		btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC, 0, 0, 0, 0);
 	} else {
 		if (wifi_connected) {
 			wifi_rssi_state =
-				 halbtc8821a1ant_WifiRssiState(btcoexist, 1, 2,
-							       30, 0);
-			halbtc8821a1ant_limited_tx(btcoexist,
-						   NORMAL_EXEC, 1, 1, 1, 1);
+				btc8821a1ant_wifi_rssi_state(btcoexist, 1, 2,
+							     30, 0);
+			if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+			    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+				btc8821a1ant_limited_tx(btcoexist,
+							NORMAL_EXEC, 1, 1,
+							1, 1);
+			} else {
+				btc8821a1ant_limited_tx(btcoexist,
+							NORMAL_EXEC, 1, 1,
+							1, 1);
+			}
 		} else {
-			halbtc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC,
-						   0, 0, 0, 0);
+			btc8821a1ant_limited_tx(btcoexist, NORMAL_EXEC,
+						0, 0, 0, 0);
 		}
 	}
 
@@ -1837,22 +1842,22 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		bt_ctrl_agg_buf_size = true;
 		agg_buf_size = 0x8;
 	}
-	halbtc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
-				   bt_ctrl_agg_buf_size, agg_buf_size);
+	btc8821a1ant_limited_rx(btcoexist, NORMAL_EXEC, false,
+				bt_ctrl_agg_buf_size, agg_buf_size);
 
 	btc8821a1ant_run_sw_coex_mech(btcoexist);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
-		halbtc8821a1ant_action_bt_inquiry(btcoexist);
+		btc8821a1ant_action_bt_inquiry(btcoexist);
 		return;
 	} else if (bt_hs_on) {
-		halbtc8821a1ant_action_hs(btcoexist);
+		btc8821a1ant_action_hs(btcoexist);
 		return;
 	}
 
 	if (!wifi_connected) {
-		bool	scan = false, link = false, roam = false;
+		bool scan = false, link = false, roam = false;
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], wifi is non connected-idle !!!\n");
@@ -1864,29 +1869,30 @@ static void halbtc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		if (scan || link || roam)
 			btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
 		else
-			halbtc8821a1ant_action_wifi_not_connected(btcoexist);
+			btc8821a1ant_action_wifi_not_connected(btcoexist);
 	} else {
-		/* wifi LPS/Busy*/
-		halbtc8821a1ant_action_wifi_connected(btcoexist);
+		/* wifi LPS/Busy */
+		btc8821a1ant_action_wifi_connected(btcoexist);
 	}
 }
 
-static void halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
+static void btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	/* force to reset coex mechanism*/
-	/* sw all off*/
-	halbtc8821a1ant_sw_mechanism(btcoexist, false);
+	/* force to reset coex mechanism
+	 * sw all off
+	 */
+	btc8821a1ant_sw_mechanism(btcoexist, false);
 
-	halbtc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
-	halbtc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
+	btc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+	btc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 }
 
-static void halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
-					   bool back_up)
+static void btc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
+					bool back_up)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8	u1_tmp = 0;
-	bool	wifi_under_5g = false;
+	u8 u1_tmp = 0;
+	bool wifi_under_5g = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], 1Ant Init HW Config!!\n");
@@ -1897,12 +1903,12 @@ static void halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 		coex_dm->backup_arfr_cnt2 = btcoexist->btc_read_4byte(btcoexist,
 								      0x434);
 		coex_dm->backup_retry_limit =
-			 btcoexist->btc_read_2byte(btcoexist, 0x42a);
+			btcoexist->btc_read_2byte(btcoexist, 0x42a);
 		coex_dm->backup_ampdu_max_time =
-			 btcoexist->btc_read_1byte(btcoexist, 0x456);
+			btcoexist->btc_read_1byte(btcoexist, 0x456);
 	}
 
-	/* 0x790[5:0] = 0x5*/
+	/* 0x790[5:0] = 0x5 */
 	u1_tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
 	u1_tmp &= 0xc0;
 	u1_tmp |= 0x5;
@@ -1910,35 +1916,33 @@ static void halbtc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 
-	/*Antenna config*/
+	/* Antenna config */
 	if (wifi_under_5g)
-		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
-					     true, false);
+		btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT,
+					  true, false);
 	else
-		halbtc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
-					     true, false);
-	/* PTA parameter*/
-	halbtc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
-
-	/* Enable counter statistics*/
-	/*0x76e[3] =1, WLAN_Act control by PTA*/
+		btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+					  true, false);
+	/* PTA parameter */
+	btc8821a1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
+
+	/* Enable counter statistics
+	 * 0x76e[3] =1, WLAN_Act control by PTA
+	 */
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
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
+/**************************************************************
+ * extern function start with ex_btc8821a1ant_
+ **************************************************************/
+void ex_btc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
-	halbtc8821a1ant_init_hw_config(btcoexist, true);
+	btc8821a1ant_init_hw_config(btcoexist, true);
 }
 
-void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
+void ex_btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -1947,12 +1951,12 @@ void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 
 	btcoexist->stop_coex_dm = false;
 
-	halbtc8821a1ant_init_coex_dm(btcoexist);
+	btc8821a1ant_init_coex_dm(btcoexist);
 
-	halbtc8821a1ant_query_bt_info(btcoexist);
+	btc8821a1ant_query_bt_info(btcoexist);
 }
 
-void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
+void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
@@ -2097,7 +2101,7 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 		 "\r\n %-35s = %s/%s, (0x%x/0x%x)",
 		 "PS state, IPS/LPS, (lps/rpwm)",
 		 ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
-		 ((coex_sta->under_Lps ? "LPS ON" : "LPS OFF")),
+		 ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")),
 		 btcoexist->bt_info.lps_val,
 		 btcoexist->bt_info.rpwm_val);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
@@ -2122,7 +2126,7 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 			 "\r\n %-35s = 0x%x ", "Rate Mask",
 			 btcoexist->bt_info.ra_mask);
 
-		/* Fw mechanism*/
+		/* Fw mechanism */
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
 			 "============[Fw mechanism]============");
 
@@ -2144,7 +2148,7 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 			 coex_dm->cur_ignore_wlan_act);
 	}
 
-	/* Hw setting*/
+	/* Hw setting */
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 "\r\n %-35s", "============[Hw setting]============");
 
@@ -2227,12 +2231,12 @@ void ex_halbtc8821a1ant_display_coex_info(struct btc_coexist *btcoexist)
 		 "\r\n %-35s = %d/ %d", "0x774(low-pri rx/tx)",
 		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
 #if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 1)
-	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
+	btc8821a1ant_monitor_bt_ctr(btcoexist);
 #endif
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
-void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2243,22 +2247,22 @@ void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
-		halbtc8821a1ant_set_ant_path(btcoexist,
-					     BTC_ANT_PATH_BT, false, true);
-		/*set PTA control*/
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
-		halbtc8821a1ant_coex_table_with_type(btcoexist,
-						     NORMAL_EXEC, 0);
+		btc8821a1ant_set_ant_path(btcoexist,
+					  BTC_ANT_PATH_BT, false, true);
+		/* set PTA control */
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 8);
+		btc8821a1ant_coex_table_with_type(btcoexist,
+						  NORMAL_EXEC, 0);
 	} else if (BTC_IPS_LEAVE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
 
-		halbtc8821a1ant_run_coexist_mechanism(btcoexist);
+		btc8821a1ant_run_coexist_mechanism(btcoexist);
 	}
 }
 
-void ex_halbtc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2268,15 +2272,15 @@ void ex_halbtc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	if (BTC_LPS_ENABLE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], LPS ENABLE notify\n");
-		coex_sta->under_Lps = true;
+		coex_sta->under_lps = true;
 	} else if (BTC_LPS_DISABLE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], LPS DISABLE notify\n");
-		coex_sta->under_Lps = false;
+		coex_sta->under_lps = false;
 	}
 }
 
-void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool wifi_connected = false, bt_hs_on = false;
@@ -2291,13 +2295,13 @@ void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	btcoexist->btc_get(btcoexist,
 		 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
 
-	halbtc8821a1ant_query_bt_info(btcoexist);
+	btc8821a1ant_query_bt_info(btcoexist);
 
 	if (coex_sta->c2h_bt_inquiry_page) {
-		halbtc8821a1ant_action_bt_inquiry(btcoexist);
+		btc8821a1ant_action_bt_inquiry(btcoexist);
 		return;
 	} else if (bt_hs_on) {
-		halbtc8821a1ant_action_hs(btcoexist);
+		btc8821a1ant_action_hs(btcoexist);
 		return;
 	}
 
@@ -2305,25 +2309,25 @@ void ex_halbtc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], SCAN START notify\n");
 		if (!wifi_connected) {
-			/* non-connected scan*/
+			/* non-connected scan */
 			btc8821a1ant_act_wifi_not_conn_scan(btcoexist);
 		} else {
-			/* wifi is connected*/
-			halbtc8821a1ant_action_wifi_connected_scan(btcoexist);
+			/* wifi is connected */
+			btc8821a1ant_action_wifi_connected_scan(btcoexist);
 		}
 	} else if (BTC_SCAN_FINISH == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], SCAN FINISH notify\n");
 		if (!wifi_connected) {
-			/* non-connected scan*/
-			halbtc8821a1ant_action_wifi_not_connected(btcoexist);
+			/* non-connected scan */
+			btc8821a1ant_action_wifi_not_connected(btcoexist);
 		} else {
-			halbtc8821a1ant_action_wifi_connected(btcoexist);
+			btc8821a1ant_action_wifi_connected(btcoexist);
 		}
 	}
 }
 
-void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool	wifi_connected = false, bt_hs_on = false;
@@ -2335,10 +2339,10 @@ void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
-		halbtc8821a1ant_action_bt_inquiry(btcoexist);
+		btc8821a1ant_action_bt_inquiry(btcoexist);
 		return;
 	} else if (bt_hs_on) {
-		halbtc8821a1ant_action_hs(btcoexist);
+		btc8821a1ant_action_hs(btcoexist);
 		return;
 	}
 
@@ -2353,16 +2357,16 @@ void ex_halbtc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 		btcoexist->btc_get(btcoexist,
 			 BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
 		if (!wifi_connected) {
-			/* non-connected scan*/
-			halbtc8821a1ant_action_wifi_not_connected(btcoexist);
+			/* non-connected scan */
+			btc8821a1ant_action_wifi_not_connected(btcoexist);
 		} else {
-			halbtc8821a1ant_action_wifi_connected(btcoexist);
+			btc8821a1ant_action_wifi_connected(btcoexist);
 		}
 	}
 }
 
-void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
-					    u8 type)
+void ex_btc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[3] = {0};
@@ -2382,17 +2386,16 @@ void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 			 "[BTCoex], MEDIA disconnect notify\n");
 	}
 
-	/* only 2.4G we need to inform bt the chnl mask*/
+	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist,
 			   BTC_GET_U1_WIFI_CENTRAL_CHNL,
 			   &wifi_central_chnl);
-	if ((BTC_MEDIA_CONNECT == type) &&
+	if ((type == BTC_MEDIA_CONNECT) &&
 	    (wifi_central_chnl <= 14)) {
-		/*h2c_parameter[0] = 0x1;*/
 		h2c_parameter[0] = 0x0;
 		h2c_parameter[1] = wifi_central_chnl;
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-		if (BTC_WIFI_BW_HT40 == wifi_bw)
+		if (wifi_bw == BTC_WIFI_BW_HT40)
 			h2c_parameter[2] = 0x30;
 		else
 			h2c_parameter[2] = 0x20;
@@ -2411,8 +2414,8 @@ void ex_halbtc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
 
-void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type)
+void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool bt_hs_on = false;
@@ -2426,10 +2429,10 @@ void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 	if (coex_sta->c2h_bt_inquiry_page) {
-		halbtc8821a1ant_action_bt_inquiry(btcoexist);
+		btc8821a1ant_action_bt_inquiry(btcoexist);
 		return;
 	} else if (bt_hs_on) {
-		halbtc8821a1ant_action_hs(btcoexist);
+		btc8821a1ant_action_hs(btcoexist);
 		return;
 	}
 
@@ -2441,12 +2444,13 @@ void ex_halbtc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 	}
 }
 
-void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmp_buf, u8 length)
+void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 i;
 	u8 bt_info = 0;
-	u8 i, rsp_source = 0;
+	u8 rsp_source = 0;
 	bool wifi_connected = false;
 	bool bt_busy = false;
 	bool wifi_under_5g = false;
@@ -2456,7 +2460,7 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_get(btcoexist,
 		 BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 
-	rsp_source = tmp_buf[0]&0xf;
+	rsp_source = tmp_buf[0] & 0xf;
 	if (rsp_source >= BT_INFO_SRC_8821A_1ANT_MAX)
 		rsp_source = BT_INFO_SRC_8821A_1ANT_WIFI_FW;
 	coex_sta->bt_info_c2h_cnt[rsp_source]++;
@@ -2468,7 +2472,7 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_info_c2h[rsp_source][i] = tmp_buf[i];
 		if (i == 1)
 			bt_info = tmp_buf[i];
-		if (i == length-1) {
+		if (i == length - 1) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "0x%02x]\n", tmp_buf[i]);
 		} else {
@@ -2487,19 +2491,19 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_info_ext =
 			coex_sta->bt_info_c2h[rsp_source][4];
 
-		/* Here we need to resend some wifi info to BT*/
-		/* because bt is reset and loss of the info.*/
+		/* Here we need to resend some wifi info to BT
+		 * because bt is reset and lost the info
+		 */
 		if (coex_sta->bt_info_ext & BIT1) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
-			btcoexist->btc_get(btcoexist,
-					   BTC_GET_BL_WIFI_CONNECTED,
+			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
 			if (wifi_connected) {
-				ex_halbtc8821a1ant_media_status_notify(btcoexist,
+				ex_btc8821a1ant_media_status_notify(btcoexist,
 							       BTC_MEDIA_CONNECT);
 			} else {
-				ex_halbtc8821a1ant_media_status_notify(btcoexist,
+				ex_btc8821a1ant_media_status_notify(btcoexist,
 							       BTC_MEDIA_DISCONNECT);
 			}
 		}
@@ -2509,28 +2513,28 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 			    !btcoexist->stop_coex_dm) {
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
-				halbtc8821a1ant_ignore_wlan_act(btcoexist,
-								FORCE_EXEC,
-								false);
+				btc8821a1ant_ignore_wlan_act(btcoexist,
+							     FORCE_EXEC,
+							     false);
 			}
 		}
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
 	} else {
-		/* connection exists*/
+		/* connection exists */
 		coex_sta->bt_link_exist = true;
 		if (bt_info & BT_INFO_8821A_1ANT_B_FTP)
 			coex_sta->pan_exist = true;
@@ -2550,14 +2554,14 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_sta->sco_exist = false;
 	}
 
-	halbtc8821a1ant_update_bt_link_info(btcoexist);
+	btc8821a1ant_update_bt_link_info(btcoexist);
 
 	if (!(bt_info&BT_INFO_8821A_1ANT_B_CONNECTION)) {
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_NON_CONNECTED_IDLE;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
 	} else if (bt_info == BT_INFO_8821A_1ANT_B_CONNECTION) {
-		/* connection exists but no busy*/
+		/* connection exists but no busy */
 		coex_dm->bt_status = BT_8821A_1ANT_BT_STATUS_CONNECTED_IDLE;
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
@@ -2587,10 +2591,10 @@ void ex_halbtc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_set(btcoexist,
 			   BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
 
-	halbtc8821a1ant_run_coexist_mechanism(btcoexist);
+	btc8821a1ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
+void ex_btc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2599,19 +2603,16 @@ void ex_halbtc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 
 	btcoexist->stop_coex_dm = true;
 
-	halbtc8821a1ant_set_ant_path(btcoexist,
-				     BTC_ANT_PATH_BT, false, true);
-	halbtc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+	btc8821a1ant_set_ant_path(btcoexist, BTC_ANT_PATH_BT, false, true);
+	btc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 
-	halbtc8821a1ant_power_save_state(btcoexist,
-					 BTC_PS_WIFI_NATIVE, 0x0, 0x0);
-	halbtc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
+	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+	btc8821a1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 0);
 
-	ex_halbtc8821a1ant_media_status_notify(btcoexist,
-					       BTC_MEDIA_DISCONNECT);
+	ex_btc8821a1ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
-void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
+void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2622,25 +2623,25 @@ void ex_halbtc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Pnp notify to SLEEP\n");
 		btcoexist->stop_coex_dm = true;
-		halbtc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
-		halbtc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
-						 0x0, 0x0);
-		halbtc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 9);
+		btc8821a1ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+		btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+					      0x0, 0x0);
+		btc8821a1ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 9);
 	} else if (BTC_WIFI_PNP_WAKE_UP == pnp_state) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Pnp notify to WAKE UP\n");
 		btcoexist->stop_coex_dm = false;
-		halbtc8821a1ant_init_hw_config(btcoexist, false);
-		halbtc8821a1ant_init_coex_dm(btcoexist);
-		halbtc8821a1ant_query_bt_info(btcoexist);
+		btc8821a1ant_init_hw_config(btcoexist, false);
+		btc8821a1ant_init_coex_dm(btcoexist);
+		btc8821a1ant_query_bt_info(btcoexist);
 	}
 }
 
-void ex_halbtc8821a1ant_periodical(struct btc_coexist *btcoexist)
+void ex_btc8821a1ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static u8	dis_ver_info_cnt;
-	u32		fw_ver = 0, bt_patch_ver = 0;
+	static u8 dis_ver_info_cnt;
+	u32 fw_ver = 0, bt_patch_ver = 0;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 
@@ -2674,8 +2675,8 @@ void ex_halbtc8821a1ant_periodical(struct btc_coexist *btcoexist)
 	}
 
 #if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-	halbtc8821a1ant_query_bt_info(btcoexist);
-	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
+	btc8821a1ant_query_bt_info(btcoexist);
+	btc8821a1ant_monitor_bt_ctr(btcoexist);
 #else
 	coex_sta->special_pkt_period_cnt++;
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
index 20e904890fc2..9f50a1427388 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -146,7 +146,7 @@ struct coex_sta_8821a_1ant {
 	bool	hid_exist;
 	bool	pan_exist;
 
-	bool	under_Lps;
+	bool	under_lps;
 	bool	under_ips;
 	u32	special_pkt_period_cnt;
 	u32	high_priority_tx;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 7b7772b7d061..f36dab9291b1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -23,7 +23,7 @@
  *
  *****************************************************************************/
 
-/*============================================================
+/************************************************************
  * Description:
  *
  * This file is for RTL8821A Co-exist mechanism
@@ -32,22 +32,19 @@
  * 2012/08/22 Cosa first check in.
  * 2012/11/14 Cosa Revise for 8821A 2Ant out sourcing.
  *
- *============================================================
- */
+ ************************************************************/
 
-/*============================================================
+/************************************************************
  * include files
- *============================================================
-*/
+ ************************************************************/
 #include "halbt_precomp.h"
-/*============================================================
+/************************************************************
  * Global variables, these are static variables
- *============================================================
- */
-static struct coex_dm_8821a_2ant	glcoex_dm_8821a_2ant;
-static struct coex_dm_8821a_2ant	*coex_dm = &glcoex_dm_8821a_2ant;
-static struct coex_sta_8821a_2ant	glcoex_sta_8821a_2ant;
-static struct coex_sta_8821a_2ant	*coex_sta = &glcoex_sta_8821a_2ant;
+ ************************************************************/
+static struct coex_dm_8821a_2ant glcoex_dm_8821a_2ant;
+static struct coex_dm_8821a_2ant *coex_dm = &glcoex_dm_8821a_2ant;
+static struct coex_sta_8821a_2ant glcoex_sta_8821a_2ant;
+static struct coex_sta_8821a_2ant *coex_sta = &glcoex_sta_8821a_2ant;
 
 static const char *const glbt_info_src_8821a_2ant[] = {
 	"BT Info[wifi fw]",
@@ -55,32 +52,29 @@ static const char *const glbt_info_src_8821a_2ant[] = {
 	"BT Info[bt auto report]",
 };
 
-static u32	glcoex_ver_date_8821a_2ant = 20130618;
-static u32	glcoex_ver_8821a_2ant = 0x5050;
+static u32 glcoex_ver_date_8821a_2ant = 20130618;
+static u32 glcoex_ver_8821a_2ant = 0x5050;
 
-/*============================================================
+/************************************************************
  * local function proto type if needed
- *============================================================
- *============================================================
- * local function start with halbtc8821a2ant_
- *============================================================
- */
-static u8 halbtc8821a2ant_bt_rssi_state(struct btc_coexist *btcoexist,
-					u8 level_num, u8 rssi_thresh,
-					u8 rssi_thresh1)
+ *
+ * local function start with btc8821a2ant_
+ ************************************************************/
+static u8 btc8821a2ant_bt_rssi_state(struct btc_coexist *btcoexist,
+				     u8 level_num, u8 rssi_thresh,
+				     u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	long	bt_rssi = 0;
-	u8	bt_rssi_state = coex_sta->pre_bt_rssi_state;
+	long bt_rssi = 0;
+	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
 	bt_rssi = coex_sta->bt_rssi;
 
 	if (level_num == 2) {
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
-			long tmp = rssi_thresh +
-				   BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT;
-			if (bt_rssi >= tmp) {
+			if (bt_rssi >=
+			    rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT) {
 				bt_rssi_state = BTC_RSSI_STATE_HIGH;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], BT Rssi state switch to High\n");
@@ -110,7 +104,8 @@ static u8 halbtc8821a2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 		if ((coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_bt_rssi_state == BTC_RSSI_STATE_STAY_LOW)) {
 			if (bt_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
+			    (rssi_thresh +
+			     BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
 				bt_rssi_state = BTC_RSSI_STATE_MEDIUM;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], BT Rssi state switch to Medium\n");
@@ -156,13 +151,13 @@ static u8 halbtc8821a2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 	return bt_rssi_state;
 }
 
-static u8 halbtc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
-					  u8 index, u8 level_num,
-					  u8 rssi_thresh, u8 rssi_thresh1)
+static u8 btc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
+				       u8 index, u8 level_num,
+				       u8 rssi_thresh, u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	long	wifi_rssi = 0;
-	u8	wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
+	long wifi_rssi = 0;
+	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 
@@ -204,7 +199,8 @@ static u8 halbtc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
 			if (wifi_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
+			    (rssi_thresh +
+			     BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
 				wifi_rssi_state = BTC_RSSI_STATE_MEDIUM;
 				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 					 "[BTCoex], wifi RSSI state switch to Medium\n");
@@ -248,22 +244,22 @@ static u8 halbtc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 	return wifi_rssi_state;
 }
 
-static void halbtc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
+static void btc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u32	reg_hp_txrx, reg_lp_txrx, u4tmp;
-	u32	reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
+	u32 reg_hp_txrx, reg_lp_txrx, u4tmp;
+	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 
 	reg_hp_txrx = 0x770;
 	reg_lp_txrx = 0x774;
 
 	u4tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_txrx);
 	reg_hp_tx = u4tmp & MASKLWORD;
-	reg_hp_rx = (u4tmp & MASKHWORD)>>16;
+	reg_hp_rx = (u4tmp & MASKHWORD) >> 16;
 
 	u4tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_txrx);
 	reg_lp_tx = u4tmp & MASKLWORD;
-	reg_lp_rx = (u4tmp & MASKHWORD)>>16;
+	reg_lp_rx = (u4tmp & MASKHWORD) >> 16;
 
 	coex_sta->high_priority_tx = reg_hp_tx;
 	coex_sta->high_priority_rx = reg_hp_rx;
@@ -281,14 +277,14 @@ static void halbtc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
-static void halbtc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
+static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
 
-	h2c_parameter[0] |= BIT0;	/* trigger */
+	h2c_parameter[0] |= BIT0; /* trigger */
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
@@ -297,7 +293,7 @@ static void halbtc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-static u8 halbtc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
+static u8 btc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
@@ -307,7 +303,6 @@ static u8 halbtc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
-	/*for win-8 stack HID report error*/
 	/* sync  BTInfo with BT firmware and stack */
 	if (!stack_info->hid_exist)
 		stack_info->hid_exist = coex_sta->hid_exist;
@@ -488,7 +483,7 @@ static u8 halbtc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 	return algorithm;
 }
 
-static void btc8821a2ant_set_fw_dac_swing_lev(struct btc_coexist *btcoexist,
+static void btc8821a2ant_set_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					      u8 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -507,8 +502,8 @@ static void btc8821a2ant_set_fw_dac_swing_lev(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x64, 1, h2c_parameter);
 }
 
-static void halbtc8821a2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
-					      bool dec_bt_pwr)
+static void btc8821a2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
+					   bool dec_bt_pwr)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[1] = {0};
@@ -525,8 +520,8 @@ static void halbtc8821a2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
 
-static void halbtc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
-				       bool force_exec, bool dec_bt_pwr)
+static void btc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
+				    bool force_exec, bool dec_bt_pwr)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -544,14 +539,13 @@ static void halbtc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 		if (coex_dm->pre_dec_bt_pwr == coex_dm->cur_dec_bt_pwr)
 			return;
 	}
-	halbtc8821a2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr);
+	btc8821a2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr);
 
 	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
 }
 
-static void halbtc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
-					     bool force_exec,
-					     u8 fw_dac_swing_lvl)
+static void btc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
+					  bool force_exec, u8 fw_dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -571,14 +565,14 @@ static void halbtc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 			return;
 	}
 
-	btc8821a2ant_set_fw_dac_swing_lev(btcoexist,
+	btc8821a2ant_set_fw_dac_swing_lvl(btcoexist,
 					  coex_dm->cur_fw_dac_swing_lvl);
 
 	coex_dm->pre_fw_dac_swing_lvl = coex_dm->cur_fw_dac_swing_lvl;
 }
 
-static void btc8821a2ant_SetSwPenTxRateAdapt(struct btc_coexist *btcoexist,
-					     bool low_penalty_ra)
+static void btc8821a2ant_set_sw_penalty_tx_rate_adaptive(
+		struct btc_coexist *btcoexist, bool low_penalty_ra)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[6] = {0};
@@ -587,13 +581,13 @@ static void btc8821a2ant_SetSwPenTxRateAdapt(struct btc_coexist *btcoexist,
 
 	if (low_penalty_ra) {
 		h2c_parameter[1] |= BIT0;
-		/*normal rate except MCS7/6/5, OFDM54/48/36 */
+		/* normal rate except MCS7/6/5, OFDM54/48/36 */
 		h2c_parameter[2] = 0x00;
-		/*MCS7 or OFDM54 */
+		/* MCS7 or OFDM54 */
 		h2c_parameter[3] = 0xf7;
-		/*MCS6 or OFDM48 */
+		/* MCS6 or OFDM48 */
 		h2c_parameter[4] = 0xf8;
-		/*MCS5 or OFDM36 */
+		/* MCS5 or OFDM36 */
 		h2c_parameter[5] = 0xf9;
 	}
 
@@ -604,12 +598,11 @@ static void btc8821a2ant_SetSwPenTxRateAdapt(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x69, 6, h2c_parameter);
 }
 
-static void halbtc8821a2ant_low_penalty_ra(struct btc_coexist *btcoexist,
-					   bool force_exec, bool low_penalty_ra)
+static void btc8821a2ant_low_penalty_ra(struct btc_coexist *btcoexist,
+					bool force_exec, bool low_penalty_ra)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
-	/*return;*/
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn LowPenaltyRA = %s\n",
 		 (force_exec ? "force to" : ""),
@@ -620,19 +613,19 @@ static void halbtc8821a2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], pre_low_penalty_ra = %d, cur_low_penalty_ra = %d\n",
 			 coex_dm->pre_low_penalty_ra,
-			    coex_dm->cur_low_penalty_ra);
+			 coex_dm->cur_low_penalty_ra);
 
 		if (coex_dm->pre_low_penalty_ra == coex_dm->cur_low_penalty_ra)
 			return;
 	}
-	btc8821a2ant_SetSwPenTxRateAdapt(btcoexist,
+	btc8821a2ant_set_sw_penalty_tx_rate_adaptive(btcoexist,
 					 coex_dm->cur_low_penalty_ra);
 
 	coex_dm->pre_low_penalty_ra = coex_dm->cur_low_penalty_ra;
 }
 
-static void halbtc8821a2ant_set_dac_swing_reg(struct btc_coexist *btcoexist,
-					      u32 level)
+static void btc8821a2ant_set_dac_swing_reg(struct btc_coexist *btcoexist,
+					   u32 level)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 val = (u8)level;
@@ -647,14 +640,14 @@ static void btc8821a2ant_set_sw_full_dac_swing(struct btc_coexist *btcoexist,
 					       u32 sw_dac_swing_lvl)
 {
 	if (sw_dac_swing_on)
-		halbtc8821a2ant_set_dac_swing_reg(btcoexist, sw_dac_swing_lvl);
+		btc8821a2ant_set_dac_swing_reg(btcoexist, sw_dac_swing_lvl);
 	else
-		halbtc8821a2ant_set_dac_swing_reg(btcoexist, 0x18);
+		btc8821a2ant_set_dac_swing_reg(btcoexist, 0x18);
 }
 
-static void halbtc8821a2ant_dac_swing(struct btc_coexist *btcoexist,
-				      bool force_exec, bool dac_swing_on,
-				      u32 dac_swing_lvl)
+static void btc8821a2ant_dac_swing(struct btc_coexist *btcoexist,
+				   bool force_exec, bool dac_swing_on,
+				   u32 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -687,9 +680,9 @@ static void halbtc8821a2ant_dac_swing(struct btc_coexist *btcoexist,
 	coex_dm->pre_dac_swing_lvl = coex_dm->cur_dac_swing_lvl;
 }
 
-static void halbtc8821a2ant_set_coex_table(struct btc_coexist *btcoexist,
-					   u32 val0x6c0, u32 val0x6c4,
-					   u32 val0x6c8, u8 val0x6cc)
+static void btc8821a2ant_set_coex_table(struct btc_coexist *btcoexist,
+					u32 val0x6c0, u32 val0x6c4,
+					u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -710,9 +703,9 @@ static void halbtc8821a2ant_set_coex_table(struct btc_coexist *btcoexist,
 	btcoexist->btc_write_1byte(btcoexist, 0x6cc, val0x6cc);
 }
 
-static void halbtc8821a2ant_coex_table(struct btc_coexist *btcoexist,
-				       bool force_exec, u32 val0x6c0,
-				       u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
+static void btc8821a2ant_coex_table(struct btc_coexist *btcoexist,
+				    bool force_exec, u32 val0x6c0,
+				    u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -745,8 +738,8 @@ static void halbtc8821a2ant_coex_table(struct btc_coexist *btcoexist,
 		    (coex_dm->pre_val0x6cc == coex_dm->cur_val0x6cc))
 			return;
 	}
-	halbtc8821a2ant_set_coex_table(btcoexist, val0x6c0, val0x6c4, val0x6c8,
-				       val0x6cc);
+	btc8821a2ant_set_coex_table(btcoexist, val0x6c0, val0x6c4, val0x6c8,
+				    val0x6cc);
 
 	coex_dm->pre_val0x6c0 = coex_dm->cur_val0x6c0;
 	coex_dm->pre_val0x6c4 = coex_dm->cur_val0x6c4;
@@ -754,14 +747,14 @@ static void halbtc8821a2ant_coex_table(struct btc_coexist *btcoexist,
 	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
 }
 
-static void halbtc8821a2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoex,
-						   bool enable)
+static void btc8821a2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoex,
+						bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoex->adapter;
 	u8 h2c_parameter[1] = {0};
 
 	if (enable)
-		h2c_parameter[0] |= BIT0;/* function enable */
+		h2c_parameter[0] |= BIT0; /* function enable */
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
@@ -770,8 +763,8 @@ static void halbtc8821a2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoex,
 	btcoex->btc_fill_h2c(btcoex, 0x63, 1, h2c_parameter);
 }
 
-static void halbtc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
-					    bool force_exec, bool enable)
+static void btc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
+					 bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -790,14 +783,14 @@ static void halbtc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 		    coex_dm->cur_ignore_wlan_act)
 			return;
 	}
-	halbtc8821a2ant_set_fw_ignore_wlan_act(btcoexist, enable);
+	btc8821a2ant_set_fw_ignore_wlan_act(btcoexist, enable);
 
 	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
 }
 
-static void halbtc8821a2ant_set_fw_pstdma(struct btc_coexist *btcoexist,
-					  u8 byte1, u8 byte2, u8 byte3,
-					  u8 byte4, u8 byte5)
+static void btc8821a2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist,
+					u8 byte1, u8 byte2, u8 byte3,
+					u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 h2c_parameter[5];
@@ -825,10 +818,9 @@ static void halbtc8821a2ant_set_fw_pstdma(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
-static void btc8821a2ant_sw_mech1(struct btc_coexist *btcoexist,
-				  bool shrink_rx_lpf,
-				  bool low_penalty_ra, bool limited_dig,
-				  bool bt_lna_constrain)
+static void btc8821a2ant_sw_mechanism1(struct btc_coexist *btcoexist,
+				       bool shrink_rx_lpf, bool low_penalty_ra,
+				       bool limited_dig, bool bt_lna_constrain)
 {
 	u32 wifi_bw;
 
@@ -840,22 +832,20 @@ static void btc8821a2ant_sw_mech1(struct btc_coexist *btcoexist,
 			shrink_rx_lpf = false;
 	}
 
-	halbtc8821a2ant_low_penalty_ra(btcoexist,
-				       NORMAL_EXEC, low_penalty_ra);
+	btc8821a2ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
 
-static void btc8821a2ant_sw_mech2(struct btc_coexist *btcoexist,
-				  bool agc_table_shift,
-				  bool adc_back_off, bool sw_dac_swing,
-				  u32 dac_swing_lvl)
+static void btc8821a2ant_sw_mechanism2(struct btc_coexist *btcoexist,
+				       bool agc_table_shift, bool adc_back_off,
+				       bool sw_dac_swing, u32 dac_swing_lvl)
 {
-	halbtc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
+	btc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
 			       sw_dac_swing);
 }
 
-static void halbtc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
-					 u8 ant_pos_type, bool init_hw_cfg,
-					 bool wifi_off)
+static void btc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
+				      u8 ant_pos_type, bool init_hw_cfg,
+				      bool wifi_off)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	u32 u4tmp = 0;
@@ -872,18 +862,16 @@ static void halbtc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
 
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
-			/* tell firmware "antenna inverse"  ==>
-			 *	WRONG firmware antenna control code.
-			 *	==>need fw to fix
+			/* tell firmware "antenna inverse"  ==> WRONG firmware
+			 * antenna control code ==>need fw to fix
 			 */
 			h2c_parameter[0] = 1;
 			h2c_parameter[1] = 1;
 			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
 						h2c_parameter);
 		} else {
-			/* tell firmware "no antenna inverse"
-			 *	==> WRONG firmware antenna control code.
-			 *	==>need fw to fix
+			/* tell firmware "no antenna inverse" ==> WRONG firmware
+			 * antenna control code ==>need fw to fix
 			 */
 			h2c_parameter[0] = 0;
 			h2c_parameter[1] = 1;
@@ -903,8 +891,8 @@ static void halbtc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
-				    bool force_exec, bool turn_on, u8 type)
+static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
+				 bool force_exec, bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -931,108 +919,108 @@ static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 		switch (type) {
 		case 1:
 		default:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
+						    0x1a, 0xe1, 0x90);
 			break;
 		case 2:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
-						      0x12, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
+						    0x12, 0xe1, 0x90);
 			break;
 		case 3:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
-						      0x3, 0xf1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
+						    0x3, 0xf1, 0x90);
 			break;
 		case 4:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x10,
-						      0x03, 0xf1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x10,
+						    0x03, 0xf1, 0x90);
 			break;
 		case 5:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
+						    0x1a, 0x60, 0x90);
 			break;
 		case 6:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
-						      0x12, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
+						    0x12, 0x60, 0x90);
 			break;
 		case 7:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
-						      0x3, 0x70, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1c,
+						    0x3, 0x70, 0x90);
 			break;
 		case 8:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xa3, 0x10,
-						      0x3, 0x70, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x10,
+						    0x3, 0x70, 0x90);
 			break;
 		case 9:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
+						    0x1a, 0xe1, 0x90);
 			break;
 		case 10:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
-						      0x12, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x12,
+						    0x12, 0xe1, 0x90);
 			break;
 		case 11:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0xa, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
+						    0xa, 0xe1, 0x90);
 			break;
 		case 12:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
-						      0x5, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
+						    0x5, 0xe1, 0x90);
 			break;
 		case 13:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
+						    0x1a, 0x60, 0x90);
 			break;
 		case 14:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3,
-						      0x12, 0x12, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3,
+						    0x12, 0x12, 0x60, 0x90);
 			break;
 		case 15:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0xa, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0xa,
+						    0xa, 0x60, 0x90);
 			break;
 		case 16:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
-						      0x5, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
+						    0x5, 0x60, 0x90);
 			break;
 		case 17:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xa3, 0x2f,
-						      0x2f, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xa3, 0x2f,
+						    0x2f, 0x60, 0x90);
 			break;
 		case 18:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
-						      0x5, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x5,
+						    0x5, 0xe1, 0x90);
 			break;
 		case 19:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x25,
-						      0x25, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
+						    0x25, 0xe1, 0x90);
 			break;
 		case 20:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x25,
-						      0x25, 0x60, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x25,
+						    0x25, 0x60, 0x90);
 			break;
 		case 21:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x15,
-						      0x03, 0x70, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x15,
+						    0x03, 0x70, 0x90);
 			break;
 		case 71:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0xe1, 0x90);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0xe3, 0x1a,
+						    0x1a, 0xe1, 0x90);
 			break;
 		}
 	} else {
 		/* disable PS tdma */
 		switch (type) {
 		case 0:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
-						      0x40, 0x0);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0, 0x0,
+						    0x40, 0x0);
 			break;
 		case 1:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
-						      0x48, 0x0);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0, 0x0,
+						    0x48, 0x0);
 			break;
 		default:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0x0, 0x0, 0x0,
-						      0x40, 0x0);
+			btc8821a2ant_set_fw_ps_tdma(btcoexist, 0x0, 0x0, 0x0,
+						    0x40, 0x0);
 			break;
 		}
 	}
@@ -1042,54 +1030,54 @@ static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static void halbtc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
+static void btc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
 {
 	/* fw all off */
-	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	/* sw all off */
-	btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-	btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+	btc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
 	/* hw all off */
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-				   0x55555555, 0x55555555, 0xffff, 0x3);
+	btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
+				0x55555555, 0x55555555, 0xffff, 0x3);
 }
 
-static void halbtc8821a2ant_coex_under_5g(struct btc_coexist *btcoexist)
+static void btc8821a2ant_coex_under_5g(struct btc_coexist *btcoexist)
 {
-	halbtc8821a2ant_coex_all_off(btcoexist);
+	btc8821a2ant_coex_all_off(btcoexist);
 }
 
-static void halbtc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
+static void btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	/* force to reset coex mechanism */
-	halbtc8821a2ant_coex_table(btcoexist, FORCE_EXEC, 0x55555555,
-				   0x55555555, 0xffff, 0x3);
+	btc8821a2ant_coex_table(btcoexist, FORCE_EXEC, 0x55555555,
+				0x55555555, 0xffff, 0x3);
 
-	halbtc8821a2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
-	halbtc8821a2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, false);
+	btc8821a2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
+	btc8821a2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, false);
 
-	btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-	btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+	btc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	btc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
-static void halbtc8821a2ant_bt_inquiry_page(struct btc_coexist *btcoexist)
+static void btc8821a2ant_bt_inquiry_page(struct btc_coexist *btcoexist)
 {
 	bool low_pwr_disable = true;
 
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 			   &low_pwr_disable);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5afa5afa, 0xffff, 0x3);
-	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
+	btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+				0x5afa5afa, 0xffff, 0x3);
+	btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 }
 
-static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
+static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	bool common = false, wifi_connected = false, wifi_busy = false;
@@ -1099,8 +1087,8 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 			   &wifi_connected);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5afa5afa, 0xffff, 0x3);
+	btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+				0x5afa5afa, 0xffff, 0x3);
 
 	if (!wifi_connected &&
 	    BT_8821A_2ANT_BT_STATUS_IDLE == coex_dm->bt_status) {
@@ -1111,12 +1099,14 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi IPS + BT IPS!!\n");
 
-		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
+					   false);
+		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					   0x18);
 
 		common = true;
 	} else if (wifi_connected &&
@@ -1128,20 +1118,22 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 		if (wifi_busy) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Wifi Busy + BT IPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     false, 1);
 		} else {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Wifi LPS + BT IPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     false, 1);
 		}
 
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
+					   false);
+		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					   0x18);
 
 		common = true;
 	} else if (!wifi_connected &&
@@ -1153,12 +1145,14 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi IPS + BT LPS!!\n");
 
-		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+		btc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
+					   false);
+		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					   0x18);
 		common = true;
 	} else if (wifi_connected &&
 		   (BT_8821A_2ANT_BT_STATUS_CON_IDLE == coex_dm->bt_status)) {
@@ -1169,40 +1163,40 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 		if (wifi_busy) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Wifi Busy + BT LPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     false, 1);
 		} else {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Wifi LPS + BT LPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     false, 1);
 		}
 
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8821a2ant_sw_mech1(btcoexist, true, true, true, true);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+		btc8821a2ant_sw_mechanism1(btcoexist, true, true, true, true);
+		btc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					   0x18);
 
 		common = true;
 	} else if (!wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_NON_IDLE ==
-		    coex_dm->bt_status)) {
+		   (coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_NON_IDLE)) {
 		low_pwr_disable = false;
-		btcoexist->btc_set(btcoexist,
-			BTC_SET_ACT_DISABLE_LOW_POWER, &low_pwr_disable);
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
+				   &low_pwr_disable);
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Wifi IPS + BT Busy!!\n");
 
-		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false,
-				      false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false,
-				      false, 0x18);
+		btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+					   false, false);
+		btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+					   false, 0x18);
 
 		common = true;
 	} else {
@@ -1218,13 +1212,12 @@ static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 		} else {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Wifi LPS + BT Busy!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist,
-						NORMAL_EXEC, true, 21);
-
+			btc8821a2ant_ps_tdma(btcoexist,
+					     NORMAL_EXEC, true, 21);
 
 			common = true;
 		}
-		btc8821a2ant_sw_mech1(btcoexist, true, true, true, true);
+		btc8821a2ant_sw_mechanism1(btcoexist, true, true, true, true);
 	}
 	return common;
 }
@@ -1234,12 +1227,13 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 				      u8 max_interval)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static long	up, dn, m, n, wait_count;
-	 /* 0: no change, +1: increase WiFi duration,
+	static long up, dn, m, n, wait_count;
+	 /* 0 : no change
+	  * +1: increase WiFi duration
 	  * -1: decrease WiFi duration
 	  */
-	int		result;
-	u8		retry_count = 0;
+	int result;
+	u8 retry_count = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], TdmaDurationAdjust()\n");
@@ -1251,72 +1245,72 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 		if (sco_hid) {
 			if (tx_pause) {
 				if (max_interval == 1) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 13);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 13);
 					coex_dm->tdma_adj_type = 13;
 				} else if (max_interval == 2) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 14);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 14);
 					coex_dm->tdma_adj_type = 14;
 				} else {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 15);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 15);
 					coex_dm->tdma_adj_type = 15;
 				}
 			} else {
 				if (max_interval == 1) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 9);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 9);
 					coex_dm->tdma_adj_type = 9;
 				} else if (max_interval == 2) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 10);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 10);
 					coex_dm->tdma_adj_type = 10;
 				} else {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 11);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 11);
 					coex_dm->tdma_adj_type = 11;
 				}
 			}
 		} else {
 			if (tx_pause) {
 				if (max_interval == 1) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 5);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 5);
 					coex_dm->tdma_adj_type = 5;
 				} else if (max_interval == 2) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 6);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 6);
 					coex_dm->tdma_adj_type = 6;
 				} else {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 7);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 7);
 					coex_dm->tdma_adj_type = 7;
 				}
 			} else {
 				if (max_interval == 1) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 1);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 1);
 					coex_dm->tdma_adj_type = 1;
 				} else if (max_interval == 2) {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 2);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 2);
 					coex_dm->tdma_adj_type = 2;
 				} else {
-					halbtc8821a2ant_ps_tdma(btcoexist,
-								NORMAL_EXEC,
-								true, 3);
+					btc8821a2ant_ps_tdma(btcoexist,
+							     NORMAL_EXEC,
+							     true, 3);
 					coex_dm->tdma_adj_type = 3;
 				}
 			}
@@ -1368,7 +1362,7 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 				up = 0;
 
 			if (dn == 2) {
-				/* if retry count< 3 for 2*2 seconds,
+				/* if retry count < 3 for 2*2 seconds,
 				 * shrink wifi duration
 				 */
 				if (wait_count <= 2)
@@ -1381,7 +1375,7 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 				if (m >= 20)
 					m = 20;
 
-				n = 3*m;
+				n = 3 * m;
 				up = 0;
 				dn = 0;
 				wait_count = 0;
@@ -1403,7 +1397,7 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 			if (m >= 20)
 				m = 20;
 
-			n = 3*m;
+			n = 3 * m;
 			up = 0;
 			dn = 0;
 			wait_count = 0;
@@ -1425,200 +1419,201 @@ static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
 
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], PsTdma type dismatch!!!, cur_ps_tdma = %d, recordPsTdma = %d\n",
-			    coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
+			 coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 
 		if (!scan && !link && !roam) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
-						coex_dm->tdma_adj_type);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
+					     coex_dm->tdma_adj_type);
 		} else {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
 		}
 	}
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 0x6);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 0x6);
 }
 
 /* SCO only or SCO+PAN(HS)*/
-static void halbtc8821a2ant_action_sco(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, bt_rssi_state;
 	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
+						       15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
 		/* for SCO quality at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-					   0x5a5a5a5a, 0x5a5a5a5a, 0xffff, 0x3);
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
+					0x5a5a5a5a, 0x5a5a5a5a, 0xffff, 0x3);
 	} else {
 		/* for SCO quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-					   0x5aea5aea, 0x5aea5aea, 0xffff, 0x3);
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
+					0x5aea5aea, 0x5aea5aea, 0xffff, 0x3);
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism
-		 * halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		 */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 
-		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-					false, 0); /*for voice quality*/
+		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			/* for voice quality */
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     false, 0);
+		} else {
+			/* for voice quality */
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     false, 0);
+		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
-		/* fw mechanism
-		 * halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		 */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
+			/* for voice quality */
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
+			/* for voice quality */
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 0);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_hid(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state;
+	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist,
-							  0, 2, 15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
 		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffff, 0x3);
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5a5a5a5a, 0xffff, 0x3);
 	} else {
 		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5aea5aea, 0xffff, 0x3);
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5aea5aea, 0xffff, 0x3);
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 9);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 13);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 9);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 13);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
-static void halbtc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state;
+	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
+						       15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
 	/* fw dac swing is called in btc8821a2ant_tdma_dur_adj()
-	 * halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	 * btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 	 */
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -1634,15 +1629,15 @@ static void halbtc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
 		/* fw mechanism */
@@ -1656,62 +1651,57 @@ static void halbtc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state, bt_info_ext;
+	u32 wifi_bw;
 
 	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
-
-	/*fw dac swing is called in btc8821a2ant_tdma_dur_adj()
-	 *halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	 */
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		/* fw mechanism */
 		if (bt_info_ext&BIT0) {
-			/*a2dp basic rate*/
+			/* a2dp basic rate */
 			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 2);
 		} else {
-			/*a2dp edr rate*/
+			/* a2dp edr rate */
 			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
 		/* fw mechanism */
@@ -1726,109 +1716,107 @@ static void halbtc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state;
+	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
 		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5aff5aff, 0xffff, 0x3);
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5aff5aff, 0xffff, 0x3);
 	} else {
 		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5aff5aff, 0xffff, 0x3);
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5aff5aff, 0xffff, 0x3);
 	}
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 1);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 1);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 5);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 1);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 1);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 5);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
 /* PAN(HS) only */
-static void halbtc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state;
+	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist,
-							  0, 2, 15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
@@ -1836,78 +1824,85 @@ static void halbtc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 		/* fw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
-						   true);
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 		} else {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
-						   false);
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 		}
-		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
 		/* fw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist,
-						   NORMAL_EXEC, true);
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 		} else {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist,
-						   NORMAL_EXEC, false);
+			btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 		}
 
-		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		} else {
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
 /* PAN(EDR)+A2DP */
-static void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
 	u8	wifi_rssi_state, bt_rssi_state, bt_info_ext;
 	u32	wifi_bw;
 
 	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5afa5afa, 0xffff, 0x3);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
+		/* for HID at 11b/g mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5afa5afa, 0xffff, 0x3);
+	} else {
+		/* for HID quality & wifi performance balance at 11n mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5afa5afa, 0xffff, 0x3);
+	}
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
@@ -1922,16 +1917,16 @@ static void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
-		}
+			btc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
+		};
 	} else {
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
@@ -1943,89 +1938,92 @@ static void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state;
+	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5a5f5a5f, 0xffff, 0x3);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
+		/* for HID at 11b/g mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5a5f5a5f, 0xffff, 0x3);
+	} else {
+		/* for HID quality & wifi performance balance at 11n mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5a5f5a5f, 0xffff, 0x3);
+	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 3);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 3);
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+					     true, 10);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 		/* fw mechanism */
 		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
+			btc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
 		}
 
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
@@ -2033,25 +2031,31 @@ static void halbtc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 /* HID+A2DP+PAN(EDR) */
 static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state, bt_info_ext;
+	u32 wifi_bw;
 
 	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist,
-							  0, 2, 15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	btc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5a5a5a5a, 0xffff, 0x3);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
+		/* for HID at 11b/g mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5a5a5a5a, 0xffff, 0x3);
+	} else {
+		/* for HID quality & wifi performance balance at 11n mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5a5a5a5a, 0xffff, 0x3);
+	}
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
@@ -2060,15 +2064,15 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
 		/* fw mechanism */
@@ -2098,38 +2102,44 @@ static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
+static void btc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state, bt_info_ext;
+	u32 wifi_bw;
 
 	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
+	wifi_rssi_state = btc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = btc8821a2ant_bt_rssi_state(btcoexist, 2, 35, 0);
 
 	if (BTC_RSSI_HIGH(bt_rssi_state))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5f5b5f5b, 0xffffff, 0x3);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
+		/* for HID at 11b/g mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5f5b5f5b, 0xffffff, 0x3);
+	} else {
+		/* for HID quality & wifi performance balance at 11n mode */
+		btc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
+					0x5f5b5f5b, 0xffffff, 0x3);
+	}
 
 	if (BTC_WIFI_BW_HT40 == wifi_bw) {
 		/* fw mechanism */
@@ -2138,15 +2148,15 @@ static void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	} else {
 		/* fw mechanism */
@@ -2155,24 +2165,24 @@ static void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						   false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			btc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						   false, false);
+			btc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						   false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
+static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	bool	wifi_under_5g = false;
-	u8	algorithm = 0;
+	bool wifi_under_5g = false;
+	u8 algorithm = 0;
 
 	if (btcoexist->manual_control) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2186,16 +2196,16 @@ static void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	if (wifi_under_5g) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], RunCoexistMechanism(), run 5G coex setting!!<===\n");
-		halbtc8821a2ant_coex_under_5g(btcoexist);
+		btc8821a2ant_coex_under_5g(btcoexist);
 		return;
 	}
 
-	algorithm = halbtc8821a2ant_action_algorithm(btcoexist);
+	algorithm = btc8821a2ant_action_algorithm(btcoexist);
 	if (coex_sta->c2h_bt_inquiry_page &&
 	    (BT_8821A_2ANT_COEX_ALGO_PANHS != algorithm)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], BT is under inquiry/page scan !!\n");
-		halbtc8821a2ant_bt_inquiry_page(btcoexist);
+		btc8821a2ant_bt_inquiry_page(btcoexist);
 		return;
 	}
 
@@ -2203,7 +2213,7 @@ static void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Algorithm = %d\n", coex_dm->cur_algorithm);
 
-	if (halbtc8821a2ant_is_common_action(btcoexist)) {
+	if (btc8821a2ant_is_common_action(btcoexist)) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], Action 2-Ant common\n");
 		coex_dm->reset_tdma_adjust = true;
@@ -2219,42 +2229,42 @@ static void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		case BT_8821A_2ANT_COEX_ALGO_SCO:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = SCO\n");
-			halbtc8821a2ant_action_sco(btcoexist);
+			btc8821a2ant_action_sco(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_HID:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = HID\n");
-			halbtc8821a2ant_action_hid(btcoexist);
+			btc8821a2ant_action_hid(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = A2DP\n");
-			halbtc8821a2ant_action_a2dp(btcoexist);
+			btc8821a2ant_action_a2dp(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
-			halbtc8821a2ant_action_a2dp_pan_hs(btcoexist);
+			btc8821a2ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANEDR:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)\n");
-			halbtc8821a2ant_action_pan_edr(btcoexist);
+			btc8821a2ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANHS:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = HS mode\n");
-			halbtc8821a2ant_action_pan_hs(btcoexist);
+			btc8821a2ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = PAN+A2DP\n");
-			halbtc8821a2ant_action_pan_edr_a2dp(btcoexist);
+			btc8821a2ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANEDR_HID:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)+HID\n");
-			halbtc8821a2ant_action_pan_edr_hid(btcoexist);
+			btc8821a2ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2264,26 +2274,22 @@ static void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 		case BT_8821A_2ANT_COEX_ALGO_HID_A2DP:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = HID+A2DP\n");
-			halbtc8821a2ant_action_hid_a2dp(btcoexist);
+			btc8821a2ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "[BTCoex], Action 2-Ant, algorithm = coexist All Off!!\n");
-			halbtc8821a2ant_coex_all_off(btcoexist);
+			btc8821a2ant_coex_all_off(btcoexist);
 			break;
 		}
 		coex_dm->pre_algorithm = coex_dm->cur_algorithm;
 	}
 }
 
-/*============================================================
- *work around function start with wa_halbtc8821a2ant_
- *============================================================
- *============================================================
- * extern function start with EXhalbtc8821a2ant_
- *============================================================
- */
-void ex_halbtc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
+/**************************************************************
+ * extern function start with ex_btc8821a2ant_
+ **************************************************************/
+void ex_btc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u8 u1tmp = 0;
@@ -2302,13 +2308,11 @@ void ex_halbtc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte(btcoexist, 0x790, u1tmp);
 
 	/*Antenna config */
-	halbtc8821a2ant_set_ant_path(btcoexist,
-				     BTC_ANT_WIFI_AT_MAIN, true, false);
+	btc8821a2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN, true, false);
 
 	/* PTA parameter */
-	halbtc8821a2ant_coex_table(btcoexist,
-				   FORCE_EXEC, 0x55555555, 0x55555555,
-				   0xffff, 0x3);
+	btc8821a2ant_coex_table(btcoexist, FORCE_EXEC, 0x55555555, 0x55555555,
+				0xffff, 0x3);
 
 	/* Enable counter statistics */
 	/*0x76e[3] = 1, WLAN_Act control by PTA*/
@@ -2317,20 +2321,17 @@ void ex_halbtc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
 
-void ex_halbtc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
+void ex_btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Coex Mechanism Init!!\n");
 
-	halbtc8821a2ant_init_coex_dm(btcoexist);
+	btc8821a2ant_init_coex_dm(btcoexist);
 }
 
-void
-ex_halbtc8821a2ant_display_coex_info(
-	struct btc_coexist *btcoexist
-	)
+void ex_btc8821a2ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
@@ -2564,7 +2565,7 @@ ex_halbtc8821a2ant_display_coex_info(
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
-void ex_halbtc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2572,16 +2573,15 @@ void ex_halbtc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
-		halbtc8821a2ant_coex_all_off(btcoexist);
+		btc8821a2ant_coex_all_off(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
-		/*halbtc8821a2ant_init_coex_dm(btcoexist);*/
 	}
 }
 
-void ex_halbtc8821a2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2596,7 +2596,7 @@ void ex_halbtc8821a2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8821a2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2609,7 +2609,7 @@ void ex_halbtc8821a2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8821a2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8821a2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
@@ -2622,13 +2622,13 @@ void ex_halbtc8821a2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
-					    u8 type)
+void ex_btc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8	h2c_parameter[3] = {0};
-	u32	wifi_bw;
-	u8	wifi_central_chnl;
+	u8 h2c_parameter[3] = {0};
+	u32 wifi_bw;
+	u8 wifi_central_chnl;
 
 	if (BTC_MEDIA_CONNECT == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2638,7 +2638,7 @@ void ex_halbtc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
 			 "[BTCoex], MEDIA disconnect notify\n");
 	}
 
-	/* only 2.4G we need to inform bt the chnl mask*/
+	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
 			   &wifi_central_chnl);
 	if ((BTC_MEDIA_CONNECT == type) &&
@@ -2665,8 +2665,9 @@ void ex_halbtc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
 
-void ex_halbtc8821a2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type) {
+void ex_btc8821a2ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type)
+{
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	if (type == BTC_PACKET_DHCP) {
@@ -2675,18 +2676,18 @@ void ex_halbtc8821a2ant_special_packet_notify(struct btc_coexist *btcoexist,
 	}
 }
 
-void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmp_buf, u8 length)
+void ex_btc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8		bt_info = 0;
-	u8		i, rsp_source = 0;
-	bool		bt_busy = false, limited_dig = false;
-	bool		wifi_connected = false, bt_hs_on = false;
+	u8 bt_info = 0;
+	u8 i, rsp_source = 0;
+	bool bt_busy = false, limited_dig = false;
+	bool wifi_connected = false, bt_hs_on = false;
 
 	coex_sta->c2h_bt_info_req_sent = false;
 
-	rsp_source = tmp_buf[0]&0xf;
+	rsp_source = tmp_buf[0] & 0xf;
 	if (rsp_source >= BT_INFO_SRC_8821A_2ANT_MAX)
 		rsp_source = BT_INFO_SRC_8821A_2ANT_WIFI_FW;
 	coex_sta->bt_info_c2h_cnt[rsp_source]++;
@@ -2698,7 +2699,7 @@ void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_info_c2h[rsp_source][i] = tmp_buf[i];
 		if (i == 1)
 			bt_info = tmp_buf[i];
-		if (i == length-1) {
+		if (i == length - 1) {
 			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 				 "0x%02x]\n", tmp_buf[i]);
 		} else {
@@ -2708,7 +2709,8 @@ void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	}
 
 	if (BT_INFO_SRC_8821A_2ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0]*/
+		/* [3:0] */
+		coex_sta->bt_retry_cnt =
 			coex_sta->bt_info_c2h[rsp_source][2]&0xf;
 
 		coex_sta->bt_rssi =
@@ -2717,24 +2719,25 @@ void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->bt_info_ext =
 			coex_sta->bt_info_c2h[rsp_source][4];
 
-		/* Here we need to resend some wifi info to BT*/
-		/* because bt is reset and loss of the info.*/
+		/* Here we need to resend some wifi info to BT
+		 * because bt is reset and loss of the info
+		 */
 		if ((coex_sta->bt_info_ext & BIT1)) {
 			btcoexist->btc_get(btcoexist,
 				BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
 			if (wifi_connected) {
-				ex_halbtc8821a2ant_media_status_notify(btcoexist,
+				ex_btc8821a2ant_media_status_notify(btcoexist,
 					BTC_MEDIA_CONNECT);
 			} else {
-				ex_halbtc8821a2ant_media_status_notify(btcoexist,
+				ex_btc8821a2ant_media_status_notify(btcoexist,
 					BTC_MEDIA_DISCONNECT);
 			}
 
 		}
 
 		if ((coex_sta->bt_info_ext & BIT3)) {
-			halbtc8821a2ant_ignore_wlan_act(btcoexist,
-							FORCE_EXEC, false);
+			btc8821a2ant_ignore_wlan_act(btcoexist,
+						     FORCE_EXEC, false);
 		} else {
 			/* BT already NOT ignore Wlan active, do nothing here.*/
 		}
@@ -2798,27 +2801,27 @@ void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_set(btcoexist,
 		BTC_SET_BL_BT_LIMITED_DIG, &limited_dig);
 
-	halbtc8821a2ant_run_coexist_mechanism(btcoexist);
+	btc8821a2ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8821a2ant_halt_notify(struct btc_coexist *btcoexist)
+void ex_btc8821a2ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Halt notify\n");
 
-	halbtc8821a2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
-	ex_halbtc8821a2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
+	btc8821a2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+	ex_btc8821a2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
-void ex_halbtc8821a2ant_periodical(struct btc_coexist *btcoexist)
+void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	static u8	dis_ver_info_cnt;
-	u32		fw_ver = 0, bt_patch_ver = 0;
+	static u8 dis_ver_info_cnt;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
+	u32 fw_ver = 0, bt_patch_ver = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], ==========================Periodical===========================\n");
@@ -2847,6 +2850,6 @@ void ex_halbtc8821a2ant_periodical(struct btc_coexist *btcoexist)
 			 "[BTCoex], ****************************************************************\n");
 	}
 
-	halbtc8821a2ant_query_bt_info(btcoexist);
-	halbtc8821a2ant_monitor_bt_ctr(btcoexist);
+	btc8821a2ant_query_bt_info(btcoexist);
+	btc8821a2ant_monitor_bt_ctr(btcoexist);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 150aeb8e79d1..f13000612913 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -466,7 +466,7 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	case BTC_SET_ACT_DISABLE_LOW_POWER:
 		halbtc_disable_low_power();
 		break;
-	case BTC_SET_ACT_UPDATE_ra_mask:
+	case BTC_SET_ACT_UPDATE_RAMASK:
 		btcoexist->bt_info.ra_mask = *u32_tmp;
 		break;
 	case BTC_SET_ACT_SEND_MIMO_PS:
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 601bbe1d22b3..f74864f54edb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -275,7 +275,7 @@ enum btc_set_type {
 	BTC_SET_ACT_NORMAL_LPS,
 	BTC_SET_ACT_INC_FORCE_EXEC_PWR_CMD_CNT,
 	BTC_SET_ACT_DISABLE_LOW_POWER,
-	BTC_SET_ACT_UPDATE_ra_mask,
+	BTC_SET_ACT_UPDATE_RAMASK,
 	BTC_SET_ACT_SEND_MIMO_PS,
 	/* BT Coex related */
 	BTC_SET_ACT_CTRL_BT_INFO,
-- 
2.12.0
