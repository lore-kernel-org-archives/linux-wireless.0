Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34545 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752859AbcLCRce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Dec 2016 12:32:34 -0500
Received: by mail-oi0-f65.google.com with SMTP id m75so31541752oig.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Dec 2016 09:32:33 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/7] rtlwifi: btcoexist: Rewrite routine halbtc8821a2ant
Date: Sat,  3 Dec 2016 11:32:05 -0600
Message-Id: <20161203173207.17774-6-Larry.Finger@lwfinger.net> (sfid-20161203_183250_810363_3050E719)
In-Reply-To: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
References: <20161203173207.17774-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The btcoexist routines for RTL8821AE have been rewritten. This patch
contains part 2 of that rewrite and well as miscellaneous changes for
the rest of btcoexist.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../wireless/realtek/rtlwifi/btcoexist/Makefile    |    9 +
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |   22 +
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 6122 +++++++++++---------
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |  273 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       | 1011 +++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |  364 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   45 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |    1 +
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    2 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    1 +
 10 files changed, 4653 insertions(+), 3197 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
index 8b13789..c7df4e6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
@@ -1 +1,10 @@
+btcoexist-objs :=	halbtc8192e2ant.o	\
+			halbtc8723b1ant.o	\
+			halbtc8723b2ant.o	\
+			halbtc8821a1ant.o	\
+			halbtc8821a2ant.o	\
+			halbtcoutsrc.o		\
+			rtl_btc.o
+
+ccflags-y += -D__CHECK_ENDIAN__
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 39b9a33..e8a2990 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -37,6 +37,28 @@
 
 #include "halbtcoutsrc.h"
 
+/* Interface type */
+#define RT_PCI_INTERFACE	1
+#define RT_USB_INTERFACE	2
+#define RT_SDIO_INTERFACE	3
+#define DEV_BUS_TYPE		RT_PCI_INTERFACE
+
+/* IC type */
+#define RTL_HW_TYPE(_adapter)	(rtl_hal((struct rtl_priv *)_adapter)->hw_type)
+
+#define IS_NEW_GENERATION_IC(_adapter)		\
+			(RTL_HW_TYPE(_adapter) >= HARDWARE_TYPE_RTL8192EE)
+#define IS_HARDWARE_TYPE_8812(_adapter)		\
+			(RTL_HW_TYPE(_adapter) == HARDWARE_TYPE_RTL8812AE)
+#define IS_HARDWARE_TYPE_8821(_adapter)		\
+			(RTL_HW_TYPE(_adapter) == HARDWARE_TYPE_RTL8821AE)
+#define IS_HARDWARE_TYPE_8723A(_adapter)	\
+			(RTL_HW_TYPE(_adapter) == HARDWARE_TYPE_RTL8723AE)
+#define IS_HARDWARE_TYPE_8723B(_adapter)	\
+			(RTL_HW_TYPE(_adapter) == HARDWARE_TYPE_RTL8723BE)
+#define IS_HARDWARE_TYPE_8192E(_adapter)	\
+			(RTL_HW_TYPE(_adapter) == HARDWARE_TYPE_RTL8192EE)
+
 #include "halbtc8192e2ant.h"
 #include "halbtc8723b1ant.h"
 #include "halbtc8723b2ant.h"
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 81f843b..ec6d460 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -22,130 +22,104 @@
  * Larry Finger <Larry.Finger@lwfinger.net>
  *
  *****************************************************************************/
-
-/*============================================================
+/* ************************************************************
  * Description:
  *
  * This file is for RTL8821A Co-exist mechanism
  *
  * History
- * 2012/08/22 Cosa first check in.
- * 2012/11/14 Cosa Revise for 8821A 2Ant out sourcing.
+ * 2012/11/15 Cosa first check in.
  *
- *============================================================
+ * ************************************************************
  */
 
-/*============================================================
+/* ************************************************************
  * include files
- *============================================================
-*/
+ * ************************************************************
+ */
 #include "halbt_precomp.h"
-/*============================================================
+
+/* ************************************************************
  * Global variables, these are static variables
- *============================================================
+ * ************************************************************
  */
-static struct coex_dm_8821a_2ant	glcoex_dm_8821a_2ant;
-static struct coex_dm_8821a_2ant	*coex_dm = &glcoex_dm_8821a_2ant;
-static struct coex_sta_8821a_2ant	glcoex_sta_8821a_2ant;
-static struct coex_sta_8821a_2ant	*coex_sta = &glcoex_sta_8821a_2ant;
+static struct coex_dm_8821a_2ant glcoex_dm_8821a_2ant;
+static struct coex_dm_8821a_2ant *coex_dm = &glcoex_dm_8821a_2ant;
+static struct coex_sta_8821a_2ant glcoex_sta_8821a_2ant;
+static struct coex_sta_8821a_2ant *coex_sta = &glcoex_sta_8821a_2ant;
 
 static const char *const glbt_info_src_8821a_2ant[] = {
-	"BT Info[wifi fw]",
-	"BT Info[bt rsp]",
-	"BT Info[bt auto report]",
+	"BT Info[wifi fw]", "BT Info[bt rsp]", "BT Info[bt auto report]",
 };
 
-static u32	glcoex_ver_date_8821a_2ant = 20130618;
-static u32	glcoex_ver_8821a_2ant = 0x5050;
-
-/*============================================================
+static u32 glcoex_ver_date_8821a_2ant = 20150921;
+static u32 glcoex_ver_8821a_2ant = 0x58;
+/* modify 20140903v43 a2dpandhid tdmaonoff a2dp glitch _ tdma off
+ * 778=3(case1)->778=1(case0)
+ * and to improve tp while a2dphid case23->case25 , case123->case125 for asus
+ * spec
+ * and modify for asus bt WHQL test _ tdma off_ 778=3->1_
+ * ************************************************************
  * local function proto type if needed
- *============================================================
- *============================================================
+ * ************************************************************
+ * ************************************************************
  * local function start with halbtc8821a2ant_
- *============================================================
+ * ************************************************************
  */
-static u8 halbtc8821a2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
-					u8 rssi_thresh1)
+static
+u8 halbtc8821a2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh, u8 rssi_thresh1)
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
-			long tmp = rssi_thresh +
-				   BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT;
-			if (bt_rssi >= tmp) {
+			if (bt_rssi >=
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT))
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
 			if (bt_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT))
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
-			if (bt_rssi >=
-			    (rssi_thresh1 +
-			     BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
+			if (bt_rssi >= (rssi_thresh1 +
+					BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT))
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
 
@@ -154,12 +128,14 @@ static u8 halbtc8821a2ant_bt_rssi_state(u8 level_num, u8 rssi_thresh,
 	return bt_rssi_state;
 }
 
-static u8 halbtc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
-					  u8 index, u8 level_num,
-					  u8 rssi_thresh, u8 rssi_thresh1)
+static
+u8 halbtc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist, u8 index,
+				   u8 level_num, u8 rssi_thresh,
+				   u8 rssi_thresh1)
 {
-	long	wifi_rssi = 0;
-	u8	wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
+	s32 wifi_rssi = 0;
+	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 
@@ -169,706 +145,597 @@ static u8 halbtc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
 			if (wifi_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT))
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
 
 		if ((coex_sta->pre_wifi_rssi_state[index] ==
-		    BTC_RSSI_STATE_LOW) ||
+		     BTC_RSSI_STATE_LOW) ||
 		    (coex_sta->pre_wifi_rssi_state[index] ==
 		     BTC_RSSI_STATE_STAY_LOW)) {
 			if (wifi_rssi >=
-			    (rssi_thresh+BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
+			    (rssi_thresh + BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT))
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
-			   BTC_RSSI_STATE_MEDIUM) ||
+			    BTC_RSSI_STATE_MEDIUM) ||
 			   (coex_sta->pre_wifi_rssi_state[index] ==
 			    BTC_RSSI_STATE_STAY_MEDIUM)) {
 			if (wifi_rssi >= (rssi_thresh1 +
-			    BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT)) {
+					  BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT))
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
 
-static void btc8821a2ant_mon_bt_en_dis(struct btc_coexist *btcoexist)
-{
-	static bool	pre_bt_disabled;
-	static u32	bt_disable_cnt;
-	bool		bt_active = true, bt_disabled = false;
-
-	/* This function check if bt is disabled*/
-
-	if (coex_sta->high_priority_tx == 0 &&
-	    coex_sta->high_priority_rx == 0 &&
-	    coex_sta->low_priority_tx == 0 &&
-	    coex_sta->low_priority_rx == 0)
-		bt_active = false;
-	if (coex_sta->high_priority_tx == 0xffff &&
-	    coex_sta->high_priority_rx == 0xffff &&
-	    coex_sta->low_priority_tx == 0xffff &&
-	    coex_sta->low_priority_rx == 0xffff)
-		bt_active = false;
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
-		}
-	}
-	if (pre_bt_disabled != bt_disabled) {
-		btc_alg_dbg(ALGO_BT_MONITOR,
-			    "[BTCoex], BT is from %s to %s!!\n",
-			    (pre_bt_disabled ? "disabled" : "enabled"),
-			    (bt_disabled ? "disabled" : "enabled"));
-		pre_bt_disabled = bt_disabled;
-	}
+static
+void halbtc8821a2ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
+				bool rej_ap_agg_pkt, bool bt_ctrl_agg_buf_size,
+				u8 agg_buf_size)
+{
+	bool reject_rx_agg = rej_ap_agg_pkt;
+	bool bt_ctrl_rx_agg_size = bt_ctrl_agg_buf_size;
+	u8 rx_agg_size = agg_buf_size;
+
+	/* ============================================ */
+	/*	Rx Aggregation related setting */
+	/* ============================================ */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_TO_REJ_AP_AGG_PKT,
+			   &reject_rx_agg);
+	/* decide BT control aggregation buf size or not */
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_CTRL_AGG_SIZE,
+			   &bt_ctrl_rx_agg_size);
+	/* aggregation buf size, only work when BT control Rx aggregation size.
+	 */
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_AGG_BUF_SIZE, &rx_agg_size);
+	/* real update aggregation setting */
+	btcoexist->btc_set(btcoexist, BTC_SET_ACT_AGGREGATE_CTRL, NULL);
 }
 
-static void halbtc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
-	u32	reg_hp_txrx, reg_lp_txrx, u4tmp;
-	u32	reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
+	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
+	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	reg_hp_txrx = 0x770;
 	reg_lp_txrx = 0x774;
 
-	u4tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_txrx);
-	reg_hp_tx = u4tmp & MASKLWORD;
-	reg_hp_rx = (u4tmp & MASKHWORD)>>16;
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_hp_txrx);
+	reg_hp_tx = u32tmp & MASKLWORD;
+	reg_hp_rx = (u32tmp & MASKHWORD) >> 16;
 
-	u4tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_txrx);
-	reg_lp_tx = u4tmp & MASKLWORD;
-	reg_lp_rx = (u4tmp & MASKHWORD)>>16;
+	u32tmp = btcoexist->btc_read_4byte(btcoexist, reg_lp_txrx);
+	reg_lp_tx = u32tmp & MASKLWORD;
+	reg_lp_rx = (u32tmp & MASKHWORD) >> 16;
 
 	coex_sta->high_priority_tx = reg_hp_tx;
 	coex_sta->high_priority_rx = reg_hp_rx;
 	coex_sta->low_priority_tx = reg_lp_tx;
 	coex_sta->low_priority_rx = reg_lp_rx;
 
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex], High Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
-		    reg_hp_txrx, reg_hp_tx, reg_hp_tx, reg_hp_rx, reg_hp_rx);
-	btc_alg_dbg(ALGO_BT_MONITOR,
-		    "[BTCoex], Low Priority Tx/Rx (reg 0x%x) = 0x%x(%d)/0x%x(%d)\n",
-		    reg_lp_txrx, reg_lp_tx, reg_lp_tx, reg_lp_rx, reg_lp_rx);
+	if ((coex_sta->low_priority_rx >= 950) &&
+	    (coex_sta->low_priority_rx >= coex_sta->low_priority_tx) &&
+	    (!coex_sta->under_ips))
+		bt_link_info->slave_role = true;
+	else
+		bt_link_info->slave_role = false;
+
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
 
-static void halbtc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 {
-	u8	h2c_parameter[1] = {0};
+	if (coex_sta->under_ips) {
+		coex_sta->crc_ok_cck = 0;
+		coex_sta->crc_ok_11g = 0;
+		coex_sta->crc_ok_11n = 0;
+		coex_sta->crc_ok_11n_agg = 0;
+
+		coex_sta->crc_err_cck = 0;
+		coex_sta->crc_err_11g = 0;
+		coex_sta->crc_err_11n = 0;
+		coex_sta->crc_err_11n_agg = 0;
+	} else {
+		coex_sta->crc_ok_cck =
+			btcoexist->btc_read_4byte(btcoexist, 0xf88);
+		coex_sta->crc_ok_11g =
+			btcoexist->btc_read_2byte(btcoexist, 0xf94);
+		coex_sta->crc_ok_11n =
+			btcoexist->btc_read_2byte(btcoexist, 0xf90);
+		coex_sta->crc_ok_11n_agg =
+			btcoexist->btc_read_2byte(btcoexist, 0xfb8);
+
+		coex_sta->crc_err_cck =
+			btcoexist->btc_read_4byte(btcoexist, 0xf84);
+		coex_sta->crc_err_11g =
+			btcoexist->btc_read_2byte(btcoexist, 0xf96);
+		coex_sta->crc_err_11n =
+			btcoexist->btc_read_2byte(btcoexist, 0xf92);
+		coex_sta->crc_err_11n_agg =
+			btcoexist->btc_read_2byte(btcoexist, 0xfba);
+	}
 
-	coex_sta->c2h_bt_info_req_sent = true;
+	/* reset counter */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xf16, 0x1, 0x1);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xf16, 0x1, 0x0);
+}
+
+static
+void halbtc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
+{
+	u8 h2c_parameter[1] = {0};
 
-	h2c_parameter[0] |= BIT0;	/* trigger */
+	coex_sta->c2h_bt_info_req_sent = true;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
-		    h2c_parameter[0]);
+	h2c_parameter[0] |= BIT(0); /* trigger */
 
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
-static u8 halbtc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
+static
+bool halbtc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+{
+	static bool pre_wifi_busy = false, pre_under_4way = false,
+		    pre_bt_hs_on = false;
+	bool wifi_busy = false, under_4way = false, bt_hs_on = false;
+	bool wifi_connected = false;
+	u8 wifi_rssi_state = BTC_RSSI_STATE_HIGH;
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
+
+		wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(
+			btcoexist, 3, 2,
+			BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+
+		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
+		    (wifi_rssi_state == BTC_RSSI_STATE_LOW))
+			return true;
+	}
+
+	return false;
+}
+
+static
+void halbtc8821a2ant_update_bt_link_info(struct btc_coexist *btcoexist)
+{
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool bt_hs_on = false;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+
+	bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
+	bt_link_info->sco_exist = coex_sta->sco_exist;
+	bt_link_info->a2dp_exist = coex_sta->a2dp_exist;
+	bt_link_info->pan_exist = coex_sta->pan_exist;
+	bt_link_info->hid_exist = coex_sta->hid_exist;
+
+	/* work around for HS mode. */
+	if (bt_hs_on) {
+		bt_link_info->pan_exist = true;
+		bt_link_info->bt_link_exist = true;
+	}
+
+	/* check if Sco only */
+	if (bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->sco_only = true;
+	else
+		bt_link_info->sco_only = false;
+
+	/* check if A2dp only */
+	if (!bt_link_info->sco_exist && bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->a2dp_only = true;
+	else
+		bt_link_info->a2dp_only = false;
+
+	/* check if Pan only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    bt_link_info->pan_exist && !bt_link_info->hid_exist)
+		bt_link_info->pan_only = true;
+	else
+		bt_link_info->pan_only = false;
+
+	/* check if Hid only */
+	if (!bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
+	    !bt_link_info->pan_exist && bt_link_info->hid_exist)
+		bt_link_info->hid_only = true;
+	else
+		bt_link_info->hid_only = false;
+}
+
+static
+u8 halbtc8821a2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 	u8 algorithm = BT_8821A_2ANT_COEX_ALGO_UNDEFINED;
 	u8 num_of_diff_profile = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
 
-	/*for win-8 stack HID report error*/
-	/* sync  BTInfo with BT firmware and stack */
-	if (!stack_info->hid_exist)
-		stack_info->hid_exist = coex_sta->hid_exist;
-	/* when stack HID report error, here we use the info from bt fw. */
-	if (!stack_info->bt_link_exist)
-		stack_info->bt_link_exist = coex_sta->bt_link_exist;
-
-	if (!coex_sta->bt_link_exist) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], No profile exists!!!\n");
+	if (!bt_link_info->bt_link_exist) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], No BT link exists!!!\n");
+		BTC_TRACE(trace_buf);
 		return algorithm;
 	}
 
-	if (coex_sta->sco_exist)
+	if (bt_link_info->sco_exist)
 		num_of_diff_profile++;
-	if (coex_sta->hid_exist)
+	if (bt_link_info->hid_exist)
 		num_of_diff_profile++;
-	if (coex_sta->pan_exist)
+	if (bt_link_info->pan_exist)
 		num_of_diff_profile++;
-	if (coex_sta->a2dp_exist)
+	if (bt_link_info->a2dp_exist)
 		num_of_diff_profile++;
 
 	if (num_of_diff_profile == 1) {
-		if (coex_sta->sco_exist) {
-			btc_alg_dbg(ALGO_TRACE,
+		if (bt_link_info->sco_exist) {
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 				    "[BTCoex], SCO only\n");
+			BTC_TRACE(trace_buf);
 			algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 		} else {
-			if (coex_sta->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
+			if (bt_link_info->hid_exist) {
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 					    "[BTCoex], HID only\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_2ANT_COEX_ALGO_HID;
-			} else if (coex_sta->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
+			} else if (bt_link_info->a2dp_exist) {
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 					    "[BTCoex], A2DP only\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_2ANT_COEX_ALGO_A2DP;
-			} else if (coex_sta->pan_exist) {
+			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
+					BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 						    "[BTCoex], PAN(HS) only\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANHS;
+					BTC_TRACE(trace_buf);
+					algorithm =
+						BT_8821A_2ANT_COEX_ALGO_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], PAN(EDR) only\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], PAN(EDR) only\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+						BT_8821A_2ANT_COEX_ALGO_PANEDR;
 				}
 			}
 		}
 	} else if (num_of_diff_profile == 2) {
-		if (coex_sta->sco_exist) {
-			if (coex_sta->hid_exist) {
-				btc_alg_dbg(ALGO_TRACE,
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist) {
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 					    "[BTCoex], SCO + HID\n");
-				algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
-			} else if (coex_sta->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
+				BTC_TRACE(trace_buf);
+				algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
+			} else if (bt_link_info->a2dp_exist) {
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 					    "[BTCoex], SCO + A2DP ==> SCO\n");
-				algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
-			} else if (coex_sta->pan_exist) {
+				BTC_TRACE(trace_buf);
+				algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
+			} else if (bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + PAN(HS)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
 			}
 		} else {
-			if (coex_sta->hid_exist &&
-			    coex_sta->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->a2dp_exist) {
+				BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 					    "[BTCoex], HID + A2DP\n");
+				BTC_TRACE(trace_buf);
 				algorithm = BT_8821A_2ANT_COEX_ALGO_HID_A2DP;
-			} else if (coex_sta->hid_exist &&
-				coex_sta->pan_exist) {
+			} else if (bt_link_info->hid_exist &&
+				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + PAN(HS)\n");
-					algorithm =  BT_8821A_2ANT_COEX_ALGO_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm = BT_8821A_2ANT_COEX_ALGO_HID;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
 				}
-			} else if (coex_sta->pan_exist &&
-				coex_sta->a2dp_exist) {
+			} else if (bt_link_info->pan_exist &&
+				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], A2DP + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], A2DP + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP;
 				}
 			}
 		}
 	} else if (num_of_diff_profile == 3) {
-		if (coex_sta->sco_exist) {
-			if (coex_sta->hid_exist &&
-			    coex_sta->a2dp_exist) {
-				btc_alg_dbg(ALGO_TRACE,
-					    "[BTCoex], SCO + HID + A2DP ==> HID\n");
-				algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
-			} else if (coex_sta->hid_exist &&
-				coex_sta->pan_exist) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->a2dp_exist) {
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], SCO + HID + A2DP ==> SCO\n");
+				BTC_TRACE(trace_buf);
+				algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
+			} else if (bt_link_info->hid_exist &&
+				   bt_link_info->pan_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + HID + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + HID + PAN(HS) ==> SCO\n");
+					BTC_TRACE(trace_buf);
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + HID + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + HID + PAN(EDR) ==> SCO\n");
+					BTC_TRACE(trace_buf);
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
-			} else if (coex_sta->pan_exist &&
-				   coex_sta->a2dp_exist) {
+			} else if (bt_link_info->pan_exist &&
+				   bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + A2DP + PAN(EDR) ==> HID\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + A2DP + PAN(EDR) ==> HID\n");
+					BTC_TRACE(trace_buf);
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
 			}
 		} else {
-			if (coex_sta->hid_exist &&
-			    coex_sta->pan_exist &&
-			    coex_sta->a2dp_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->pan_exist &&
+			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + A2DP + PAN(HS)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_HID_A2DP;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_HID_A2DP;
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], HID + A2DP + PAN(EDR)\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], HID + A2DP + PAN(EDR)\n");
+					BTC_TRACE(trace_buf);
+					algorithm =
+					    BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR;
 				}
 			}
 		}
 	} else if (num_of_diff_profile >= 3) {
-		if (coex_sta->sco_exist) {
-			if (coex_sta->hid_exist &&
-			    coex_sta->pan_exist &&
-			    coex_sta->a2dp_exist) {
+		if (bt_link_info->sco_exist) {
+			if (bt_link_info->hid_exist &&
+			    bt_link_info->pan_exist &&
+			    bt_link_info->a2dp_exist) {
 				if (bt_hs_on) {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], Error!!! SCO + HID + A2DP + PAN(HS)\n");
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], Error!!! SCO + HID + A2DP + PAN(HS)\n");
+					BTC_TRACE(trace_buf);
 
 				} else {
-					btc_alg_dbg(ALGO_TRACE,
-						    "[BTCoex], SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
-					algorithm = BT_8821A_2ANT_COEX_ALGO_PANEDR_HID;
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], SCO + HID + A2DP + PAN(EDR)==>PAN(EDR)+HID\n");
+					BTC_TRACE(trace_buf);
+					algorithm = BT_8821A_2ANT_COEX_ALGO_SCO;
 				}
 			}
 		}
 	}
-	return algorithm;
-}
-
-static bool halbtc8821a2ant_need_to_dec_bt_pwr(struct btc_coexist *btcoexist)
-{
-	bool ret = false;
-	bool bt_hs_on = false, wifi_connected = false;
-	long bt_hs_rssi = 0;
-	u8 bt_rssi_state;
-
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on))
-		return false;
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-				&wifi_connected))
-		return false;
-	if (!btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi))
-		return false;
-
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
 
-	if (wifi_connected) {
-		if (bt_hs_on) {
-			if (bt_hs_rssi > 37) {
-				btc_alg_dbg(ALGO_TRACE_FW,
-					    "[BTCoex], Need to decrease bt power for HS mode!!\n");
-				ret = true;
-			}
-		} else {
-			if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-			    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-				btc_alg_dbg(ALGO_TRACE_FW,
-					    "[BTCoex], Need to decrease bt power for Wifi is connected!!\n");
-				ret = true;
-			}
-		}
-	}
-	return ret;
+	return algorithm;
 }
 
-static void btc8821a2ant_set_fw_dac_swing_lev(struct btc_coexist *btcoexist,
-					      u8 dac_swing_lvl)
+static
+void halbtc8821a2ant_set_fw_dac_swing_level(struct btc_coexist *btcoexist,
+					    u8 dac_swing_lvl)
 {
-	u8	h2c_parameter[1] = {0};
+	u8 h2c_parameter[1] = {0};
 
-	/* There are several type of dacswing
-	 * 0x18/ 0x10/ 0xc/ 0x8/ 0x4/ 0x6
-	 */
+	/* There are several type of dacswing */
+	/* 0x18/ 0x10/ 0xc/ 0x8/ 0x4/ 0x6 */
 	h2c_parameter[0] = dac_swing_lvl;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], Set Dac Swing Level = 0x%x\n", dac_swing_lvl);
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x64 = 0x%x\n", h2c_parameter[0]);
-
 	btcoexist->btc_fill_h2c(btcoexist, 0x64, 1, h2c_parameter);
 }
 
-static void halbtc8821a2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
-					      bool dec_bt_pwr)
-{
-	u8			h2c_parameter[1] = {0};
-
-	h2c_parameter[0] = 0;
-
-	if (dec_bt_pwr)
-		h2c_parameter[0] |= BIT1;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], decrease Bt Power : %s, FW write 0x62 = 0x%x\n",
-		    (dec_bt_pwr ? "Yes!!" : "No!!"), h2c_parameter[0]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
-}
-
-static void halbtc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
-				       bool force_exec, bool dec_bt_pwr)
-{
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s Dec BT power = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((dec_bt_pwr) ? "ON" : "OFF"));
-	coex_dm->cur_dec_bt_pwr = dec_bt_pwr;
-
-	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_dec_bt_pwr = %d, cur_dec_bt_pwr = %d\n",
-			    coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
-
-		if (coex_dm->pre_dec_bt_pwr == coex_dm->cur_dec_bt_pwr)
-			return;
-	}
-	halbtc8821a2ant_set_fw_dec_bt_pwr(btcoexist, coex_dm->cur_dec_bt_pwr);
-
-	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
-}
-
-static void btc8821a2ant_set_fw_bt_lna_constr(struct btc_coexist *btcoexist,
-					      bool bt_lna_cons_on)
-{
-	u8 h2c_parameter[2] = {0};
-
-	h2c_parameter[0] = 0x3;	/* opCode, 0x3 = BT_SET_LNA_CONSTRAIN */
-
-	if (bt_lna_cons_on)
-		h2c_parameter[1] |= BIT0;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set BT LNA Constrain: %s, FW write 0x69 = 0x%x\n",
-		    bt_lna_cons_on ? "ON!!" : "OFF!!",
-		    h2c_parameter[0] << 8 | h2c_parameter[1]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x69, 2, h2c_parameter);
-}
-
-static void btc8821a2_set_bt_lna_const(struct btc_coexist *btcoexist,
-				       bool force_exec, bool bt_lna_cons_on)
-{
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s BT Constrain = %s\n",
-		    (force_exec ? "force" : ""),
-		    ((bt_lna_cons_on) ? "ON" : "OFF"));
-	coex_dm->cur_bt_lna_constrain = bt_lna_cons_on;
-
-	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_bt_lna_constrain = %d,cur_bt_lna_constrain = %d\n",
-			    coex_dm->pre_bt_lna_constrain,
-			    coex_dm->cur_bt_lna_constrain);
-
-		if (coex_dm->pre_bt_lna_constrain ==
-		    coex_dm->cur_bt_lna_constrain)
-			return;
-	}
-	btc8821a2ant_set_fw_bt_lna_constr(btcoexist,
-					  coex_dm->cur_bt_lna_constrain);
-
-	coex_dm->pre_bt_lna_constrain = coex_dm->cur_bt_lna_constrain;
-}
-
-static void halbtc8821a2ant_set_fw_bt_psd_mode(struct btc_coexist *btcoexist,
-					       u8 bt_psd_mode)
-{
-	u8 h2c_parameter[2] = {0};
-
-	h2c_parameter[0] = 0x2;	/* opCode, 0x2 = BT_SET_PSD_MODE */
-
-	h2c_parameter[1] = bt_psd_mode;
-
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set BT PSD mode = 0x%x, FW write 0x69 = 0x%x\n",
-		    h2c_parameter[1],
-		    h2c_parameter[0] << 8 | h2c_parameter[1]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x69, 2, h2c_parameter);
-}
-
-static void halbtc8821a2ant_set_bt_psd_mode(struct btc_coexist *btcoexist,
-					    bool force_exec, u8 bt_psd_mode)
-{
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s BT PSD mode = 0x%x\n",
-		    (force_exec ? "force" : ""), bt_psd_mode);
-	coex_dm->cur_bt_psd_mode = bt_psd_mode;
-
-	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_bt_psd_mode = 0x%x, cur_bt_psd_mode = 0x%x\n",
-			    coex_dm->pre_bt_psd_mode, coex_dm->cur_bt_psd_mode);
-
-		if (coex_dm->pre_bt_psd_mode == coex_dm->cur_bt_psd_mode)
-			return;
-	}
-	halbtc8821a2ant_set_fw_bt_psd_mode(btcoexist,
-					   coex_dm->cur_bt_psd_mode);
-
-	coex_dm->pre_bt_psd_mode = coex_dm->cur_bt_psd_mode;
-}
-
-static void halbtc8821a2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
-					       bool enable_auto_report)
+static
+void halbtc8821a2ant_set_fw_dec_bt_pwr(struct btc_coexist *btcoexist,
+				       u8 dec_bt_pwr_lvl)
 {
 	u8 h2c_parameter[1] = {0};
 
-	h2c_parameter[0] = 0;
-
-	if (enable_auto_report)
-		h2c_parameter[0] |= BIT0;
+	h2c_parameter[0] = dec_bt_pwr_lvl;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		    (enable_auto_report ? "Enabled!!" : "Disabled!!"),
-		    h2c_parameter[0]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
+	btcoexist->btc_fill_h2c(btcoexist, 0x62, 1, h2c_parameter);
 }
 
-static void halbtc8821a2ant_bt_auto_report(struct btc_coexist *btcoexist,
-					   bool force_exec,
-					   bool enable_auto_report)
+static
+void halbtc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist, bool force_exec,
+				u8 dec_bt_pwr_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s BT Auto report = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((enable_auto_report) ? "Enabled" : "Disabled"));
-	coex_dm->cur_bt_auto_report = enable_auto_report;
+	coex_dm->cur_bt_dec_pwr_lvl = dec_bt_pwr_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_bt_auto_report = %d, cur_bt_auto_report = %d\n",
-			    coex_dm->pre_bt_auto_report,
-			    coex_dm->cur_bt_auto_report);
-
-		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
+		if (coex_dm->pre_bt_dec_pwr_lvl == coex_dm->cur_bt_dec_pwr_lvl)
 			return;
 	}
-	halbtc8821a2ant_set_bt_auto_report(btcoexist,
-					   coex_dm->cur_bt_auto_report);
+	halbtc8821a2ant_set_fw_dec_bt_pwr(btcoexist,
+					  coex_dm->cur_bt_dec_pwr_lvl);
 
-	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
+	coex_dm->pre_bt_dec_pwr_lvl = coex_dm->cur_bt_dec_pwr_lvl;
 }
 
-static void halbtc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
-					     bool force_exec,
-					     u8 fw_dac_swing_lvl)
+static
+void halbtc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
+				      bool force_exec, u8 fw_dac_swing_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s set FW Dac Swing level = %d\n",
-		    (force_exec ? "force to" : ""), fw_dac_swing_lvl);
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_fw_dac_swing_lvl = %d, cur_fw_dac_swing_lvl = %d\n",
-			    coex_dm->pre_fw_dac_swing_lvl,
-			    coex_dm->cur_fw_dac_swing_lvl);
-
 		if (coex_dm->pre_fw_dac_swing_lvl ==
 		    coex_dm->cur_fw_dac_swing_lvl)
 			return;
 	}
 
-	btc8821a2ant_set_fw_dac_swing_lev(btcoexist,
-					  coex_dm->cur_fw_dac_swing_lvl);
+	halbtc8821a2ant_set_fw_dac_swing_level(btcoexist,
+					       coex_dm->cur_fw_dac_swing_lvl);
 
 	coex_dm->pre_fw_dac_swing_lvl = coex_dm->cur_fw_dac_swing_lvl;
 }
 
-static void btc8821a2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
-						 bool rx_rf_shrink_on)
-{
-	if (rx_rf_shrink_on) {
-		/* Shrink RF Rx LPF corner */
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], Shrink RF Rx LPF corner!!\n");
-		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1e,
-					  0xfffff, 0xffffc);
-	} else {
-		/* Resume RF Rx LPF corner
-		 * After initialized, we can use coex_dm->bt_rf0x1e_backup
-		 */
-		if (btcoexist->initilized) {
-			btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-				    "[BTCoex], Resume RF Rx LPF corner!!\n");
-			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A,
-						  0x1e, 0xfffff,
-						   coex_dm->bt_rf0x1e_backup);
-		}
-	}
-}
-
-static void halbtc8821a2ant_RfShrink(struct btc_coexist *btcoexist,
-				     bool force_exec, bool rx_rf_shrink_on)
-{
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn Rx RF Shrink = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((rx_rf_shrink_on) ? "ON" : "OFF"));
-	coex_dm->cur_rf_rx_lpf_shrink = rx_rf_shrink_on;
-
-	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], pre_rf_rx_lpf_shrink = %d, cur_rf_rx_lpf_shrink = %d\n",
-			    coex_dm->pre_rf_rx_lpf_shrink,
-			    coex_dm->cur_rf_rx_lpf_shrink);
-
-		if (coex_dm->pre_rf_rx_lpf_shrink ==
-		    coex_dm->cur_rf_rx_lpf_shrink)
-			return;
-	}
-	btc8821a2ant_set_sw_rf_rx_lpf_corner(btcoexist,
-					     coex_dm->cur_rf_rx_lpf_shrink);
-
-	coex_dm->pre_rf_rx_lpf_shrink = coex_dm->cur_rf_rx_lpf_shrink;
-}
-
-static void btc8821a2ant_SetSwPenTxRateAdapt(struct btc_coexist *btcoexist,
-					     bool low_penalty_ra)
+static
+void halbtc8821a2ant_set_sw_penalty_tx_rate_adaptive(
+	struct btc_coexist *btcoexist, bool low_penalty_ra)
 {
 	u8 h2c_parameter[6] = {0};
 
-	h2c_parameter[0] = 0x6;	/* opCode, 0x6 = Retry_Penalty */
+	h2c_parameter[0] = 0x6; /* op_code, 0x6= Retry_Penalty */
 
 	if (low_penalty_ra) {
-		h2c_parameter[1] |= BIT0;
-		/*normal rate except MCS7/6/5, OFDM54/48/36 */
-		h2c_parameter[2] = 0x00;
-		/*MCS7 or OFDM54 */
-		h2c_parameter[3] = 0xf7;
-		/*MCS6 or OFDM48 */
-		h2c_parameter[4] = 0xf8;
-		/*MCS5 or OFDM36 */
-		h2c_parameter[5] = 0xf9;
+		h2c_parameter[1] |= BIT(0);
+		h2c_parameter[2] =
+			0x00; /* normal rate except MCS7/6/5, OFDM54/48/36 */
+		h2c_parameter[3] = 0xf5; /* MCS7 or OFDM54 */
+		h2c_parameter[4] = 0xa0; /* MCS6 or OFDM48 */
+		h2c_parameter[5] = 0xa0; /* MCS5 or OFDM36 */
+		/* h2c_parameter[3] = 0xf7; */ /*MCS7 or OFDM54 */
+		/* h2c_parameter[4] = 0xf8; */ /*MCS6 or OFDM48 */
+		/* h2c_parameter[5] = 0xf9;	/MCS5 or OFDM36	 */
 	}
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set WiFi Low-Penalty Retry: %s",
-		    (low_penalty_ra ? "ON!!" : "OFF!!"));
-
 	btcoexist->btc_fill_h2c(btcoexist, 0x69, 6, h2c_parameter);
 }
 
-static void halbtc8821a2ant_low_penalty_ra(struct btc_coexist *btcoexist,
-					   bool force_exec, bool low_penalty_ra)
+static
+void halbtc8821a2ant_low_penalty_ra(struct btc_coexist *btcoexist,
+				    bool force_exec, bool low_penalty_ra)
 {
-	/*return;*/
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn LowPenaltyRA = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((low_penalty_ra) ? "ON" : "OFF"));
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], pre_low_penalty_ra = %d, cur_low_penalty_ra = %d\n",
-			    coex_dm->pre_low_penalty_ra,
-			    coex_dm->cur_low_penalty_ra);
-
 		if (coex_dm->pre_low_penalty_ra == coex_dm->cur_low_penalty_ra)
 			return;
 	}
-	btc8821a2ant_SetSwPenTxRateAdapt(btcoexist,
-					 coex_dm->cur_low_penalty_ra);
+	halbtc8821a2ant_set_sw_penalty_tx_rate_adaptive(
+		btcoexist, coex_dm->cur_low_penalty_ra);
 
 	coex_dm->pre_low_penalty_ra = coex_dm->cur_low_penalty_ra;
 }
 
-static void halbtc8821a2ant_set_dac_swing_reg(struct btc_coexist *btcoexist,
-					      u32 level)
+static
+void halbtc8821a2ant_set_dac_swing_reg(struct btc_coexist *btcoexist, u32 level)
 {
 	u8 val = (u8)level;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_alg_dbg(ALGO_TRACE_SW_EXEC,
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 		    "[BTCoex], Write SwDacSwing = 0x%x\n", level);
+	BTC_TRACE(trace_buf);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xc5b, 0x3e, val);
 }
 
-static void btc8821a2ant_set_sw_full_dac_swing(struct btc_coexist *btcoexist,
-					       bool sw_dac_swing_on,
-					       u32 sw_dac_swing_lvl)
+static
+void halbtc8821a2ant_set_sw_full_time_dac_swing(struct btc_coexist *btcoexist,
+						bool sw_dac_swing_on,
+						u32 sw_dac_swing_lvl)
 {
 	if (sw_dac_swing_on)
 		halbtc8821a2ant_set_dac_swing_reg(btcoexist, sw_dac_swing_lvl);
@@ -876,124 +743,50 @@ static void btc8821a2ant_set_sw_full_dac_swing(struct btc_coexist *btcoexist,
 		halbtc8821a2ant_set_dac_swing_reg(btcoexist, 0x18);
 }
 
-static void halbtc8821a2ant_dac_swing(struct btc_coexist *btcoexist,
-				      bool force_exec, bool dac_swing_on,
-				      u32 dac_swing_lvl)
+static
+void halbtc8821a2ant_dac_swing(struct btc_coexist *btcoexist, bool force_exec,
+			       bool dac_swing_on, u32 dac_swing_lvl)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn DacSwing = %s, dac_swing_lvl = 0x%x\n",
-		    (force_exec ? "force to" : ""),
-		    ((dac_swing_on) ? "ON" : "OFF"),
-		    dac_swing_lvl);
 	coex_dm->cur_dac_swing_on = dac_swing_on;
 	coex_dm->cur_dac_swing_lvl = dac_swing_lvl;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], pre_dac_swing_on = %d, pre_dac_swing_lvl = 0x%x, cur_dac_swing_on = %d, cur_dac_swing_lvl = 0x%x\n",
-			    coex_dm->pre_dac_swing_on,
-			    coex_dm->pre_dac_swing_lvl,
-			    coex_dm->cur_dac_swing_on,
-			    coex_dm->cur_dac_swing_lvl);
-
 		if ((coex_dm->pre_dac_swing_on == coex_dm->cur_dac_swing_on) &&
-		    (coex_dm->pre_dac_swing_lvl ==
-		     coex_dm->cur_dac_swing_lvl))
+		    (coex_dm->pre_dac_swing_lvl == coex_dm->cur_dac_swing_lvl))
 			return;
 	}
 	mdelay(30);
-	btc8821a2ant_set_sw_full_dac_swing(btcoexist, dac_swing_on,
-					   dac_swing_lvl);
+	halbtc8821a2ant_set_sw_full_time_dac_swing(btcoexist, dac_swing_on,
+						   dac_swing_lvl);
 
 	coex_dm->pre_dac_swing_on = coex_dm->cur_dac_swing_on;
 	coex_dm->pre_dac_swing_lvl = coex_dm->cur_dac_swing_lvl;
 }
 
-static void halbtc8821a2ant_set_adc_back_off(struct btc_coexist *btcoexist,
-					     bool adc_back_off)
-{
-	if (adc_back_off) {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], BB BackOff Level On!\n");
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x8db, 0x60, 0x3);
-	} else {
-		btc_alg_dbg(ALGO_TRACE_SW_EXEC,
-			    "[BTCoex], BB BackOff Level Off!\n");
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x8db, 0x60, 0x1);
-	}
-}
-
-static void halbtc8821a2ant_adc_back_off(struct btc_coexist *btcoexist,
-					 bool force_exec, bool adc_back_off)
-{
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s turn AdcBackOff = %s\n",
-		    (force_exec ? "force to" : ""),
-		    ((adc_back_off) ? "ON" : "OFF"));
-	coex_dm->cur_adc_back_off = adc_back_off;
-
-	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], pre_adc_back_off = %d, cur_adc_back_off = %d\n",
-			    coex_dm->pre_adc_back_off,
-			    coex_dm->cur_adc_back_off);
-
-		if (coex_dm->pre_adc_back_off == coex_dm->cur_adc_back_off)
-			return;
-	}
-	halbtc8821a2ant_set_adc_back_off(btcoexist, coex_dm->cur_adc_back_off);
-
-	coex_dm->pre_adc_back_off = coex_dm->cur_adc_back_off;
-}
-
-static void halbtc8821a2ant_set_coex_table(struct btc_coexist *btcoexist,
-					   u32 val0x6c0, u32 val0x6c4,
-					   u32 val0x6c8, u8 val0x6cc)
+static
+void halbtc8821a2ant_set_coex_table(struct btc_coexist *btcoexist, u32 val0x6c0,
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
 
-static void halbtc8821a2ant_coex_table(struct btc_coexist *btcoexist,
-				       bool force_exec, u32 val0x6c0,
-				       u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
+static
+void halbtc8821a2ant_coex_table(struct btc_coexist *btcoexist, bool force_exec,
+				u32 val0x6c0, u32 val0x6c4, u32 val0x6c8,
+				u8 val0x6cc)
 {
-	btc_alg_dbg(ALGO_TRACE_SW,
-		    "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, 0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
-		    (force_exec ? "force to" : ""),
-		    val0x6c0, val0x6c4, val0x6c8, val0x6cc);
 	coex_dm->cur_val0x6c0 = val0x6c0;
 	coex_dm->cur_val0x6c4 = val0x6c4;
 	coex_dm->cur_val0x6c8 = val0x6c8;
 	coex_dm->cur_val0x6cc = val0x6cc;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], pre_val0x6c0 = 0x%x, pre_val0x6c4 = 0x%x, pre_val0x6c8 = 0x%x, pre_val0x6cc = 0x%x !!\n",
-			    coex_dm->pre_val0x6c0,
-			    coex_dm->pre_val0x6c4,
-			    coex_dm->pre_val0x6c8,
-			    coex_dm->pre_val0x6cc);
-		btc_alg_dbg(ALGO_TRACE_SW_DETAIL,
-			    "[BTCoex], cur_val0x6c0 = 0x%x, cur_val0x6c4 = 0x%x, cur_val0x6c8 = 0x%x, cur_val0x6cc = 0x%x !!\n",
-			    coex_dm->cur_val0x6c0,
-			    coex_dm->cur_val0x6c4,
-			    coex_dm->cur_val0x6c8,
-			    coex_dm->cur_val0x6cc);
-
 		if ((coex_dm->pre_val0x6c0 == coex_dm->cur_val0x6c0) &&
 		    (coex_dm->pre_val0x6c4 == coex_dm->cur_val0x6c4) &&
 		    (coex_dm->pre_val0x6c8 == coex_dm->cur_val0x6c8) &&
@@ -1009,35 +802,138 @@ static void halbtc8821a2ant_coex_table(struct btc_coexist *btcoexist,
 	coex_dm->pre_val0x6cc = coex_dm->cur_val0x6cc;
 }
 
-static void halbtc8821a2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoex,
-						   bool enable)
+static
+void halbtc8821a2ant_coex_table_with_type(struct btc_coexist *btcoexist,
+					  bool force_exec, u8 type)
+{
+	coex_sta->coex_table_type = type;
+
+	switch (type) {
+	case 0:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0x55555555, 0xffffff, 0x3);
+		break;
+	case 1:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55555555,
+					   0x5afa5afa, 0xffffff, 0x3);
+		break;
+	case 2:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x5ada5ada,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 3:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0xaaaaaaaa,
+					   0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 4:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0xffffffff,
+					   0xffffffff, 0xffffff, 0x3);
+		break;
+	case 5:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					   0x5fff5fff, 0xffffff, 0x3);
+		break;
+	case 6:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55ff55ff,
+					   0x5a5a5a5a, 0xffffff, 0x3);
+		break;
+	case 7:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 8:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 9:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 10:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 11:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 12:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 13:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					   0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 14:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x5fff5fff,
+					   0x5ada5ada, 0xffffff, 0x3);
+		break;
+	case 15:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x55dd55dd,
+					   0xaaaaaaaa, 0xffffff, 0x3);
+		break;
+	case 16:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0x5fdf5fdf,
+					   0x5fdb5fdb, 0xffffff, 0x3);
+		break;
+	case 17:
+		halbtc8821a2ant_coex_table(btcoexist, force_exec, 0xfafafafa,
+					   0xfafafafa, 0xffffff, 0x3);
+		break;
+	default:
+		break;
+	}
+}
+
+static
+void halbtc8821a2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
+					    bool enable)
 {
 	u8 h2c_parameter[1] = {0};
 
 	if (enable)
-		h2c_parameter[0] |= BIT0;/* function enable */
+		h2c_parameter[0] |= BIT(0); /* function enable */
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], set FW for BT Ignore Wlan_Act, FW write 0x63 = 0x%x\n",
-		    h2c_parameter[0]);
+	btcoexist->btc_fill_h2c(btcoexist, 0x63, 1, h2c_parameter);
+}
+
+static
+void halbtc8821a2ant_set_lps_rpwm(struct btc_coexist *btcoexist, u8 lps_val,
+				  u8 rpwm_val)
+{
+	u8 lps = lps_val;
+	u8 rpwm = rpwm_val;
 
-	btcoex->btc_fill_h2c(btcoex, 0x63, 1, h2c_parameter);
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_LPS_VAL, &lps);
+	btcoexist->btc_set(btcoexist, BTC_SET_U1_RPWM_VAL, &rpwm);
 }
 
-static void halbtc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
-					    bool force_exec, bool enable)
+static
+void halbtc8821a2ant_lps_rpwm(struct btc_coexist *btcoexist, bool force_exec,
+			      u8 lps_val, u8 rpwm_val)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s turn Ignore WlanAct %s\n",
-		    (force_exec ? "force to" : ""), (enable ? "ON" : "OFF"));
-	coex_dm->cur_ignore_wlan_act = enable;
+	coex_dm->cur_lps = lps_val;
+	coex_dm->cur_rpwm = rpwm_val;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_ignore_wlan_act = %d, cur_ignore_wlan_act = %d!!\n",
-			    coex_dm->pre_ignore_wlan_act,
-			    coex_dm->cur_ignore_wlan_act);
+		if ((coex_dm->pre_lps == coex_dm->cur_lps) &&
+		    (coex_dm->pre_rpwm == coex_dm->cur_rpwm))
+			return;
+	}
+	halbtc8821a2ant_set_lps_rpwm(btcoexist, lps_val, rpwm_val);
+
+	coex_dm->pre_lps = coex_dm->cur_lps;
+	coex_dm->pre_rpwm = coex_dm->cur_rpwm;
+}
 
+static
+void halbtc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
+				     bool force_exec, bool enable)
+{
+	coex_dm->cur_ignore_wlan_act = enable;
+
+	if (!force_exec) {
 		if (coex_dm->pre_ignore_wlan_act ==
 		    coex_dm->cur_ignore_wlan_act)
 			return;
@@ -1047,11 +943,11 @@ static void halbtc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 	coex_dm->pre_ignore_wlan_act = coex_dm->cur_ignore_wlan_act;
 }
 
-static void halbtc8821a2ant_set_fw_pstdma(struct btc_coexist *btcoexist,
-					  u8 byte1, u8 byte2, u8 byte3,
-					  u8 byte4, u8 byte5)
+static
+void halbtc8821a2ant_set_fw_pstdma(struct btc_coexist *btcoexist, u8 byte1,
+				   u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
-	u8 h2c_parameter[5];
+	u8 h2c_parameter[5] = {0};
 
 	h2c_parameter[0] = byte1;
 	h2c_parameter[1] = byte2;
@@ -1065,84 +961,56 @@ static void halbtc8821a2ant_set_fw_pstdma(struct btc_coexist *btcoexist,
 	coex_dm->ps_tdma_para[3] = byte4;
 	coex_dm->ps_tdma_para[4] = byte5;
 
-	btc_alg_dbg(ALGO_TRACE_FW_EXEC,
-		    "[BTCoex], FW write 0x60(5bytes) = 0x%x%08x\n",
-		    h2c_parameter[0],
-		    h2c_parameter[1] << 24 |
-		    h2c_parameter[2] << 16 |
-		    h2c_parameter[3] << 8 |
-		    h2c_parameter[4]);
-
 	btcoexist->btc_fill_h2c(btcoexist, 0x60, 5, h2c_parameter);
 }
 
-static void btc8821a2ant_sw_mech1(struct btc_coexist *btcoexist,
-				  bool shrink_rx_lpf,
-				  bool low_penalty_ra, bool limited_dig,
-				  bool bt_lna_constrain)
+static
+void halbtc8821a2ant_sw_mechanism1(struct btc_coexist *btcoexist,
+				   bool shrink_rx_lpf, bool low_penalty_ra,
+				   bool limited_dig, bool bt_lna_constrain)
 {
-	u32 wifi_bw;
-
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-
-	if (BTC_WIFI_BW_HT40 != wifi_bw) {
-		/*only shrink RF Rx LPF for HT40*/
-		if (shrink_rx_lpf)
-			shrink_rx_lpf = false;
-	}
-
-	halbtc8821a2ant_RfShrink(btcoexist, NORMAL_EXEC, shrink_rx_lpf);
-	halbtc8821a2ant_low_penalty_ra(btcoexist,
-				       NORMAL_EXEC, low_penalty_ra);
-
-	/* no limited DIG
-	 * btc8821a2_set_bt_lna_const(btcoexist,
-		NORMAL_EXEC, bBTLNAConstrain);
-	 */
+	halbtc8821a2ant_low_penalty_ra(btcoexist, NORMAL_EXEC, low_penalty_ra);
 }
 
-static void btc8821a2ant_sw_mech2(struct btc_coexist *btcoexist,
-				  bool agc_table_shift,
-				  bool adc_back_off, bool sw_dac_swing,
-				  u32 dac_swing_lvl)
+static
+void halbtc8821a2ant_sw_mechanism2(struct btc_coexist *btcoexist,
+				   bool agc_table_shift, bool adc_back_off,
+				   bool sw_dac_swing, u32 dac_swing_lvl)
 {
-	/* halbtc8821a2ant_AgcTable(btcoexist, NORMAL_EXEC, bAGCTableShift); */
-	halbtc8821a2ant_adc_back_off(btcoexist, NORMAL_EXEC, adc_back_off);
 	halbtc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, sw_dac_swing,
-				  sw_dac_swing);
+				  dac_swing_lvl);
 }
 
-static void halbtc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
-					 u8 ant_pos_type, bool init_hw_cfg,
-					 bool wifi_off)
+static
+void halbtc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
+				  u8 ant_pos_type, bool init_hwcfg,
+				  bool wifi_off)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
-	u32 u4tmp = 0;
+	u32 u32tmp = 0;
 	u8 h2c_parameter[2] = {0};
 
-	if (init_hw_cfg) {
-		/*  0x4c[23] = 0, 0x4c[24] = 1  Antenna control by WL/BT */
-		u4tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
-		u4tmp &= ~BIT23;
-		u4tmp |= BIT24;
-		btcoexist->btc_write_4byte(btcoexist, 0x4c, u4tmp);
+	if (init_hwcfg) {
+		/* 0x4c[23]=0, 0x4c[24]=1  Antenna control by WL/BT */
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+		u32tmp &= ~BIT(23);
+		u32tmp |= BIT(24);
+		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
 
 		btcoexist->btc_write_4byte(btcoexist, 0x974, 0x3ff);
-		btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77);
+		/* btcoexist->btc_write_1byte(btcoexist, 0xcb4, 0x77); */
 
 		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
-			/* tell firmware "antenna inverse"  ==>
-			 *	WRONG firmware antenna control code.
-			 *	==>need fw to fix
+			/* tell firmware "antenna inverse"  ==> WRONG firmware
+			 * antenna control code.==>need fw to fix
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
+			 * antenna control code.==>need fw to fix
 			 */
 			h2c_parameter[0] = 0;
 			h2c_parameter[1] = 1;
@@ -1162,24 +1030,27 @@ static void halbtc8821a2ant_set_ant_path(struct btc_coexist *btcoexist,
 	}
 }
 
-static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
-				    bool force_exec, bool turn_on, u8 type)
+static
+void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
+			     bool turn_on, u8 type)
 {
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], %s turn %s PS TDMA, type = %d\n",
-		    (force_exec ? "force to" : ""), (turn_on ? "ON" : "OFF"),
-		    type);
+	u8 wifi_rssi_state1, bt_rssi_state;
+
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	if (!(BTC_RSSI_HIGH(wifi_rssi_state1) &&
+	      BTC_RSSI_HIGH(bt_rssi_state)) &&
+	    turn_on) {
+		type = type + 100; /* for WiFi RSSI low or BT RSSI low */
+	}
+
 	coex_dm->cur_ps_tdma_on = turn_on;
 	coex_dm->cur_ps_tdma = type;
 
 	if (!force_exec) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_ps_tdma_on = %d, cur_ps_tdma_on = %d!!\n",
-			    coex_dm->pre_ps_tdma_on, coex_dm->cur_ps_tdma_on);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], pre_ps_tdma = %d, cur_ps_tdma = %d!!\n",
-			    coex_dm->pre_ps_tdma, coex_dm->cur_ps_tdma);
-
 		if ((coex_dm->pre_ps_tdma_on == coex_dm->cur_ps_tdma_on) &&
 		    (coex_dm->pre_ps_tdma == coex_dm->cur_ps_tdma))
 			return;
@@ -1188,12 +1059,18 @@ static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 		switch (type) {
 		case 1:
 		default:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0xe1, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+			 * 0x1a, 0xe1, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x3c,
+						      0x03, 0xf1, 0x90);
 			break;
 		case 2:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
-						      0x12, 0xe1, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+			 * 0x12, 0xe1, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x2d,
+						      0x03, 0xf1, 0x90);
 			break;
 		case 3:
 			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
@@ -1204,12 +1081,18 @@ static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 						      0x03, 0xf1, 0x90);
 			break;
 		case 5:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0x60, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+			 * 0x1a, 0x60, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x3c,
+						      0x3, 0x70, 0x90);
 			break;
 		case 6:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
-						      0x12, 0x60, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+			 * 0x12, 0x60, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x2d,
+						      0x3, 0x70, 0x90);
 			break;
 		case 7:
 			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
@@ -1220,44 +1103,68 @@ static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 						      0x3, 0x70, 0x90);
 			break;
 		case 9:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0xe1, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+			 * 0x1a, 0xe1, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x3c,
+						      0x03, 0xf1, 0x90);
 			break;
 		case 10:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
-						      0x12, 0xe1, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+			 * 0x12, 0xe1, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x2d,
+						      0x03, 0xf1, 0x90);
 			break;
 		case 11:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0xa, 0xe1, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
+			 * 0xa, 0xe1, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
+						      0x3, 0xf1, 0x90);
 			break;
 		case 12:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
-						      0x5, 0xe1, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
+			 * 0x5, 0xe1, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x10,
+						      0x3, 0xf1, 0x90);
 			break;
 		case 13:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0x60, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+			 * 0x1a, 0x60, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x3c,
+						      0x3, 0x70, 0x90);
 			break;
 		case 14:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3,
-						      0x12, 0x12, 0x60, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x12,
+			 * 0x12, 0x60, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x2d,
+						      0x3, 0x70, 0x90);
 			break;
 		case 15:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
-						      0xa, 0x60, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0xa,
+			 * 0xa, 0x60, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1c,
+						      0x3, 0x70, 0x90);
 			break;
 		case 16:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
-						      0x5, 0x60, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
+			 * 0x5, 0x60, 0x90);
+			 */
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x10,
+						      0x3, 0x70, 0x90);
 			break;
 		case 17:
 			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xa3, 0x2f,
 						      0x2f, 0x60, 0x90);
 			break;
 		case 18:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5,
-						      0x5, 0xe1, 0x90);
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x5, 0x5,
+						      0xe1, 0x90);
 			break;
 		case 19:
 			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x25,
@@ -1271,9 +1178,92 @@ static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x15,
 						      0x03, 0x70, 0x90);
 			break;
+		case 23:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1e,
+						      0x03, 0xf0, 0x14);
+			break;
+		case 24:
+		case 124:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x3c,
+						      0x03, 0x70, 0x50);
+			break;
+		/* case25/case125 : for lenovo bt pan tp degrade<30% while wifi
+		 * downlink
+		 */
+		case 25:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x14,
+						      0x03, 0xf1, 0x90);
+			break;
+		case 26:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x30,
+						      0x03, 0xf1, 0x90);
+			break;
 		case 71:
-			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
-						      0x1a, 0xe1, 0x90);
+			/* halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x1a,
+			 * 0x1a, 0xe1, 0x90);
+			 */
+
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x3c,
+						      0x03, 0xf1, 0x90);
+			break;
+		case 101:
+		case 105:
+		case 171:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x3a,
+						      0x03, 0x70, 0x50);
+			break;
+		case 102:
+		case 106:
+		case 110:
+		case 114:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x2d,
+						      0x03, 0x70, 0x50);
+			break;
+		case 103:
+		case 107:
+		case 111:
+		case 115:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x1c,
+						      0x03, 0x70, 0x50);
+			break;
+		case 104:
+		case 108:
+		case 112:
+		case 116:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x10,
+						      0x03, 0x70, 0x50);
+			break;
+		case 109:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x3c,
+						      0x03, 0xf1, 0x90);
+			break;
+		case 113:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x3c,
+						      0x03, 0x70, 0x90);
+			break;
+		case 121:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x15,
+						      0x03, 0x70, 0x90);
+			break;
+		case 22:
+		case 122:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xe3, 0x35,
+						      0x03, 0x71, 0x11);
+			break;
+		case 123:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x1c,
+						      0x03, 0x70, 0x54);
+			break;
+		/* case25/case125 : for lenovo bt pan tp degrade<30% while wifi
+		 * downlink
+		 */
+		case 125:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x14,
+						      0x03, 0x70, 0x50);
+			break;
+		case 126:
+			halbtc8821a2ant_set_fw_pstdma(btcoexist, 0xd3, 0x30,
+						      0x03, 0x70, 0x50);
 			break;
 		}
 	} else {
@@ -1299,1972 +1289,2422 @@ static void halbtc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 	coex_dm->pre_ps_tdma = coex_dm->cur_ps_tdma;
 }
 
-static void halbtc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_ps_tdma_check_for_power_save_state(
+	struct btc_coexist *btcoexist, bool new_ps_state)
+{
+	u8 lps_mode = 0x0;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_LPS_MODE, &lps_mode);
+
+	if (lps_mode) { /* already under LPS state */
+		if (new_ps_state) {
+			/* keep state under LPS, do nothing. */
+		} else {
+			/* will leave LPS state, turn off psTdma first */
+			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						1);
+		}
+	} else { /* NO PS state */
+		if (new_ps_state) {
+			/* will enter LPS state, turn off psTdma first */
+			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						1);
+		} else {
+			/* keep state under NO PS state, do nothing. */
+		}
+	}
+}
+
+static
+void halbtc8821a2ant_power_save_state(struct btc_coexist *btcoexist, u8 ps_type,
+				      u8 lps_val, u8 rpwm_val)
+{
+	bool low_pwr_disable = false;
+
+	switch (ps_type) {
+	case BTC_PS_WIFI_NATIVE:
+		/* recover to original 32k low power setting */
+		low_pwr_disable = false;
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
+				   &low_pwr_disable);
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS, NULL);
+		coex_sta->force_lps_on = false;
+		break;
+	case BTC_PS_LPS_ON:
+		halbtc8821a2ant_ps_tdma_check_for_power_save_state(btcoexist,
+								   true);
+		halbtc8821a2ant_lps_rpwm(btcoexist, NORMAL_EXEC, lps_val,
+					 rpwm_val);
+		/* when coex force to enter LPS, do not enter 32k low power. */
+		low_pwr_disable = true;
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
+				   &low_pwr_disable);
+		/* power save must executed before psTdma. */
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_ENTER_LPS, NULL);
+		coex_sta->force_lps_on = true;
+		break;
+	case BTC_PS_LPS_OFF:
+		halbtc8821a2ant_ps_tdma_check_for_power_save_state(btcoexist,
+								   false);
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS, NULL);
+		coex_sta->force_lps_on = false;
+		break;
+	default:
+		break;
+	}
+}
+
+static
+void halbtc8821a2ant_coex_all_off(struct btc_coexist *btcoexist)
 {
 	/* fw all off */
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	/* sw all off */
-	btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-	btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+	halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
 	/* hw all off */
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-				   0x55555555, 0x55555555, 0xffff, 0x3);
+	/* btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0); */
+	halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 }
 
-static void halbtc8821a2ant_coex_under_5g(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_coex_under_5g(struct btc_coexist *btcoexist)
 {
 	halbtc8821a2ant_coex_all_off(btcoexist);
+
+	halbtc8821a2ant_ignore_wlan_act(btcoexist, NORMAL_EXEC, true);
 }
 
-static void halbtc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	/* force to reset coex mechanism */
-	halbtc8821a2ant_coex_table(btcoexist, FORCE_EXEC, 0x55555555,
-				   0x55555555, 0xffff, 0x3);
+	halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 	halbtc8821a2ant_ps_tdma(btcoexist, FORCE_EXEC, false, 1);
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
-	halbtc8821a2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, false);
+	halbtc8821a2ant_dec_bt_pwr(btcoexist, FORCE_EXEC, 0);
 
-	btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-	btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+	halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
-static void halbtc8821a2ant_bt_inquiry_page(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	bool wifi_connected = false;
 	bool low_pwr_disable = true;
+	bool scan = false, link = false, roam = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
 	btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
 			   &low_pwr_disable);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5afa5afa, 0xffff, 0x3);
-	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+
+	if (scan || link || roam) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Wifi link process + BT Inq/Page!!\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     15);
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	} else if (wifi_connected) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Wifi connected + BT Inq/Page!!\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     15);
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
+	} else {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Wifi no-link + BT Inq/Page!!\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	}
+
+	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, FORCE_EXEC, 6);
+	halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 }
 
-static bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_wifi_link_process(struct btc_coexist *btcoexist)
 {
-	bool common = false, wifi_connected = false, wifi_busy = false;
-	bool low_pwr_disable = false;
+	u8 u8tmpa, u8tmpb;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
-			   &wifi_connected);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 15);
+	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 22);
 
-	halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-				   0x5afa5afa, 0xffff, 0x3);
+	halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
 
-	if (!wifi_connected &&
-	    BT_8821A_2ANT_BT_STATUS_IDLE == coex_dm->bt_status) {
-		low_pwr_disable = false;
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
+	u8tmpa = btcoexist->btc_read_1byte(btcoexist, 0x765);
+	u8tmpb = btcoexist->btc_read_1byte(btcoexist, 0x76e);
 
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi IPS + BT IPS!!\n");
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "############# [BTCoex], 0x765=0x%x, 0x76e=0x%x\n", u8tmpa,
+		    u8tmpb);
+	BTC_TRACE(trace_buf);
+}
 
+static
+bool halbtc8821a2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
+{
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u8 ap_num = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	/* wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(btcoexist, 1, 2,
+	 * BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	 */
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES - 20,
+		0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
+
+	/* define the office environment */
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && (coex_sta->hid_exist) &&
+	    (coex_sta->a2dp_exist)) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], Wifi  idle process for BT HID+A2DP exist!!\n");
+		BTC_TRACE(trace_buf);
+
+		halbtc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x6);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+		/* sw all off */
+		halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
+					      false);
+		halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					      0x18);
+
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+		return true;
+	}
 
-		common = true;
-	} else if (wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_IDLE == coex_dm->bt_status)) {
-		low_pwr_disable = false;
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
+	/* */
+	else if (coex_sta->pan_exist) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], Wifi  idle process for BT PAN exist!!\n");
+		BTC_TRACE(trace_buf);
 
-		if (wifi_busy) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi Busy + BT IPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		} else {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi LPS + BT IPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		}
+		halbtc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x6);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		/* sw all off */
+		halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
+					      false);
+		halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					      0x18);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
-
-		common = true;
-	} else if (!wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_CON_IDLE == coex_dm->bt_status)) {
-		low_pwr_disable = true;
-		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
-
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi IPS + BT LPS!!\n");
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false, false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
-		common = true;
-	} else if (wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_CON_IDLE == coex_dm->bt_status)) {
-		low_pwr_disable = true;
-		btcoexist->btc_set(btcoexist,
-			BTC_SET_ACT_DISABLE_LOW_POWER, &low_pwr_disable);
-
-		if (wifi_busy) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi Busy + BT LPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		} else {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi LPS + BT LPS!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		}
+		return true;
+	}
 
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	else {
+		halbtc8821a2ant_dac_swing(btcoexist, NORMAL_EXEC, true, 0x18);
+		return false;
+	}
+}
 
-		btc8821a2ant_sw_mech1(btcoexist, true, true, true, true);
-		btc8821a2ant_sw_mech2(btcoexist, false, false, false, 0x18);
+static
+bool halbtc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
+{
+	bool common = false, wifi_connected = false, wifi_busy = false;
+	bool bt_hs_on = false, low_pwr_disable = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-		common = true;
-	} else if (!wifi_connected &&
-		   (BT_8821A_2ANT_BT_STATUS_NON_IDLE ==
-		    coex_dm->bt_status)) {
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+
+	if (!wifi_connected) {
 		low_pwr_disable = false;
-		btcoexist->btc_set(btcoexist,
-			BTC_SET_ACT_DISABLE_LOW_POWER, &low_pwr_disable);
+		btcoexist->btc_set(btcoexist, BTC_SET_ACT_DISABLE_LOW_POWER,
+				   &low_pwr_disable);
+		halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
+					   0x8);
 
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Wifi IPS + BT Busy!!\n");
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Wifi non-connected idle!!\n");
+		BTC_TRACE(trace_buf);
 
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
+					  0x0);
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
 		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-		btc8821a2ant_sw_mech1(btcoexist, false, false,
-				      false, false);
-		btc8821a2ant_sw_mech2(btcoexist, false, false,
-				      false, 0x18);
+		halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false,
+					      false);
+		halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false,
+					      0x18);
 
 		common = true;
 	} else {
-		low_pwr_disable = true;
-		btcoexist->btc_set(btcoexist,
-				   BTC_SET_ACT_DISABLE_LOW_POWER,
-				   &low_pwr_disable);
+		if (BT_8821A_2ANT_BT_STATUS_NON_CONNECTED_IDLE ==
+		    coex_dm->bt_status) {
+			low_pwr_disable = false;
+			btcoexist->btc_set(btcoexist,
+					   BTC_SET_ACT_DISABLE_LOW_POWER,
+					   &low_pwr_disable);
+			halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC,
+						   false, false, 0x8);
+
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Wifi connected + BT non connected-idle!!\n");
+			BTC_TRACE(trace_buf);
+
+			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
+						  0xfffff, 0x0);
+			halbtc8821a2ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 0);
+
+			halbtc8821a2ant_power_save_state(
+				btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						1);
+			halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+							 0xb);
+			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 
-		if (wifi_busy) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi Busy + BT Busy!!\n");
-			common = false;
-		} else {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Wifi LPS + BT Busy!!\n");
-			halbtc8821a2ant_ps_tdma(btcoexist,
-						NORMAL_EXEC, true, 21);
-
-			if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-				halbtc8821a2ant_dec_bt_pwr(btcoexist,
-							   NORMAL_EXEC, true);
-			else
-				halbtc8821a2ant_dec_bt_pwr(btcoexist,
-							   NORMAL_EXEC, false);
+			common = true;
+		} else if (BT_8821A_2ANT_BT_STATUS_CONNECTED_IDLE ==
+			   coex_dm->bt_status) {
+			low_pwr_disable = true;
+			btcoexist->btc_set(btcoexist,
+					   BTC_SET_ACT_DISABLE_LOW_POWER,
+					   &low_pwr_disable);
+
+			if (bt_hs_on)
+				return false;
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Wifi connected + BT connected-idle!!\n");
+			BTC_TRACE(trace_buf);
+			halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC,
+						   false, false, 0x8);
+
+			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
+						  0xfffff, 0x0);
+			halbtc8821a2ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 0);
+
+			halbtc8821a2ant_power_save_state(
+				btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
+			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+						1);
+			halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+							 0xb);
+			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 
 			common = true;
+		} else {
+			low_pwr_disable = true;
+			btcoexist->btc_set(btcoexist,
+					   BTC_SET_ACT_DISABLE_LOW_POWER,
+					   &low_pwr_disable);
+
+			if (wifi_busy) {
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], Wifi Connected-Busy + BT Busy!!\n");
+				BTC_TRACE(trace_buf);
+				common = false;
+			} else {
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], Wifi Connected-Idle + BT Busy!!\n");
+				BTC_TRACE(trace_buf);
+				common =
+				    halbtc8821a2ant_action_wifi_idle_process(
+						btcoexist);
+			}
 		}
-		btc8821a2ant_sw_mech1(btcoexist, true, true, true, true);
 	}
+
 	return common;
 }
 
-static void btc8821a2_int1(struct btc_coexist *btcoexist, bool tx_pause,
-			   int result)
-{
-	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
-
-		if (coex_dm->cur_ps_tdma == 71) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-			coex_dm->tdma_adj_type = 5;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
+static
+void halbtc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
+					  bool sco_hid, bool tx_pause,
+					  u8 max_interval)
+{
+	static s32 up, dn, m, n, wait_count;
+	s32 result; /* 0: no change, +1: increase WiFi duration,
+		     * -1: decrease WiFi duration
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
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 13);
+						coex_dm->ps_tdma_du_adj_type =
+							13;
+					} else if (max_interval == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 14);
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (max_interval == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					}
+				} else {
+					if (max_interval == 1) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 9);
+						coex_dm->ps_tdma_du_adj_type =
+							9;
+					} else if (max_interval == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (max_interval == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					}
+				}
+			} else {
+				if (tx_pause) {
+					if (max_interval == 1) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 5);
+						coex_dm->ps_tdma_du_adj_type =
+							5;
+					} else if (max_interval == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 6);
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (max_interval == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					}
+				} else {
+					if (max_interval == 1) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 1);
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (max_interval == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (max_interval == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					}
+				}
+			}
 		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
-			coex_dm->tdma_adj_type = 13;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
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
+		if (retry_count ==
+		    0) { /* no retry in the last 2-second duration */
+			up++;
+			dn--;
+
+			if (dn <= 0)
+				dn = 0;
+
+			if (up >= n) {
+				wait_count = 0;
+				n = 3;
+				up = 0;
+				dn = 0;
+				result = 1;
+			}
+		} else if (retry_count <=
+			   3) { /* <=3 retry in the last 2-second duration */
+			up--;
+			dn++;
+
+			if (up <= 0)
+				up = 0;
+
+			if (dn == 2) {
+				if (wait_count <= 2)
+					m++;
+				else
+					m = 1;
+
+				if (m >= 20)
+					m = 20;
+
+				n = 3 * m;
+				up = 0;
+				dn = 0;
+				wait_count = 0;
+				result = -1;
+			}
+		} else {
+			if (wait_count == 1)
+				m++;
+			else
+				m = 1;
+
+			if (m >= 20)
+				m = 20;
+
+			n = 3 * m;
+			up = 0;
+			dn = 0;
+			wait_count = 0;
+			result = -1;
 		}
 
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+		if (max_interval == 1) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 71) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 1) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 5);
+					coex_dm->ps_tdma_du_adj_type = 5;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 13);
+					coex_dm->ps_tdma_du_adj_type = 13;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 5);
-				coex_dm->tdma_adj_type = 5;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							5;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 13);
-				coex_dm->tdma_adj_type = 13;
-			}
-		}
-	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 71);
-			coex_dm->tdma_adj_type = 71;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-			coex_dm->tdma_adj_type = 9;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
+						coex_dm->ps_tdma_du_adj_type =
+							13;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 71);
+					coex_dm->ps_tdma_du_adj_type = 71;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 9);
+					coex_dm->ps_tdma_du_adj_type = 9;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
 
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 71) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 71) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 1);
-				coex_dm->tdma_adj_type = 1;
-			} else if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							1;
+					} else if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 71);
-				coex_dm->tdma_adj_type = 71;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							71;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8821a2ant_ps_tdma(
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
-static void btc8821a2_int2(struct btc_coexist *btcoexist, bool tx_pause,
-			   int result)
-{
-	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 6);
-			coex_dm->tdma_adj_type = 6;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-			coex_dm->tdma_adj_type = 14;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+		} else if (max_interval == 2) {
+			if (tx_pause) {
+				if (coex_dm->cur_ps_tdma == 1) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 2) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 6);
+					coex_dm->ps_tdma_du_adj_type = 6;
+				} else if (coex_dm->cur_ps_tdma == 3) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
+				}
+				if (coex_dm->cur_ps_tdma == 9) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 10) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 14);
+					coex_dm->ps_tdma_du_adj_type = 14;
+				} else if (coex_dm->cur_ps_tdma == 11) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 16);
+					coex_dm->ps_tdma_du_adj_type = 16;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 5) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 6);
-				coex_dm->tdma_adj_type = 6;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							6;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 14);
-				coex_dm->tdma_adj_type = 14;
-			}
-		}
-	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 2);
-			coex_dm->tdma_adj_type = 2;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-			coex_dm->tdma_adj_type = 10;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							14;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 6) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 2);
+					coex_dm->ps_tdma_du_adj_type = 2;
+				} else if (coex_dm->cur_ps_tdma == 7) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
+				}
+				if (coex_dm->cur_ps_tdma == 13) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 14) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 10);
+					coex_dm->ps_tdma_du_adj_type = 10;
+				} else if (coex_dm->cur_ps_tdma == 15) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
+					halbtc8821a2ant_ps_tdma(btcoexist,
+								NORMAL_EXEC,
+								true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 2);
-				coex_dm->tdma_adj_type = 2;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 10);
-				coex_dm->tdma_adj_type = 10;
-			}
-		}
-	}
-}
-
-static void btc8821a2_int3(struct btc_coexist *btcoexist, bool tx_pause,
-			   int result)
-{
-	if (tx_pause) {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 1\n");
-		if (coex_dm->cur_ps_tdma == 1) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 2) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 3) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 7);
-			coex_dm->tdma_adj_type = 7;
-		} else if (coex_dm->cur_ps_tdma == 4) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 8);
-			coex_dm->tdma_adj_type = 8;
-		}
-		if (coex_dm->cur_ps_tdma == 9) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 10) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 11) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 15);
-			coex_dm->tdma_adj_type = 15;
-		} else if (coex_dm->cur_ps_tdma == 12) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 16);
-			coex_dm->tdma_adj_type = 16;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 5) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 8);
-				coex_dm->tdma_adj_type = 8;
-			} else if (coex_dm->cur_ps_tdma == 13) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 16);
-				coex_dm->tdma_adj_type = 16;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 8) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 7) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 6) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 7);
-				coex_dm->tdma_adj_type = 7;
-			} else if (coex_dm->cur_ps_tdma == 16) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 15) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			} else if (coex_dm->cur_ps_tdma == 14) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 15);
-				coex_dm->tdma_adj_type = 15;
-			}
-		}
-	} else {
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], TxPause = 0\n");
-		if (coex_dm->cur_ps_tdma == 5) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 6) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 7) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 3);
-			coex_dm->tdma_adj_type = 3;
-		} else if (coex_dm->cur_ps_tdma == 8) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 4);
-			coex_dm->tdma_adj_type = 4;
-		}
-		if (coex_dm->cur_ps_tdma == 13) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 14) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 15) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 11);
-			coex_dm->tdma_adj_type = 11;
-		} else if (coex_dm->cur_ps_tdma == 16) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 12);
-			coex_dm->tdma_adj_type = 12;
-		}
-		if (result == -1) {
-			if (coex_dm->cur_ps_tdma == 1) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 4);
-				coex_dm->tdma_adj_type = 4;
-			} else if (coex_dm->cur_ps_tdma == 9) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 12);
-				coex_dm->tdma_adj_type = 12;
-			}
-		} else if (result == 1) {
-			if (coex_dm->cur_ps_tdma == 4) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 3) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 2) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 3);
-				coex_dm->tdma_adj_type = 3;
-			} else if (coex_dm->cur_ps_tdma == 12) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 11) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
-			} else if (coex_dm->cur_ps_tdma == 10) {
-				halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 2);
+						coex_dm->ps_tdma_du_adj_type =
+							2;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
 							true, 11);
-				coex_dm->tdma_adj_type = 11;
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 10);
+						coex_dm->ps_tdma_du_adj_type =
+							10;
+					}
+				}
 			}
-		}
-	}
-}
-
-static void btc8821a2ant_tdma_dur_adj(struct btc_coexist *btcoexist,
-				      bool sco_hid, bool tx_pause,
-				      u8 max_interval)
-{
-	static long	up, dn, m, n, wait_count;
-	 /* 0: no change, +1: increase WiFi duration,
-	  * -1: decrease WiFi duration
-	  */
-	int		result;
-	u8		retry_count = 0;
-
-	btc_alg_dbg(ALGO_TRACE_FW,
-		    "[BTCoex], TdmaDurationAdjust()\n");
-
-	if (coex_dm->reset_tdma_adjust) {
-		coex_dm->reset_tdma_adjust = false;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], first run TdmaDurationAdjust()!!\n");
-		if (sco_hid) {
+		} else if (max_interval == 3) {
 			if (tx_pause) {
-				if (max_interval == 1) {
+				if (coex_dm->cur_ps_tdma == 1) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 13);
-					coex_dm->tdma_adj_type = 13;
-				} else if (max_interval == 2) {
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 2) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 14);
-					coex_dm->tdma_adj_type = 14;
-				} else if (max_interval == 3) {
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 3) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 15);
-					coex_dm->tdma_adj_type = 15;
-				} else {
+								true, 7);
+					coex_dm->ps_tdma_du_adj_type = 7;
+				} else if (coex_dm->cur_ps_tdma == 4) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 15);
-					coex_dm->tdma_adj_type = 15;
+								true, 8);
+					coex_dm->ps_tdma_du_adj_type = 8;
 				}
-			} else {
-				if (max_interval == 1) {
+				if (coex_dm->cur_ps_tdma == 9) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 9);
-					coex_dm->tdma_adj_type = 9;
-				} else if (max_interval == 2) {
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 10) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 10);
-					coex_dm->tdma_adj_type = 10;
-				} else if (max_interval == 3) {
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 11) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 11);
-					coex_dm->tdma_adj_type = 11;
-				} else {
+								true, 15);
+					coex_dm->ps_tdma_du_adj_type = 15;
+				} else if (coex_dm->cur_ps_tdma == 12) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
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
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 8);
+						coex_dm->ps_tdma_du_adj_type =
+							8;
+					} else if (coex_dm->cur_ps_tdma == 13) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 16);
+						coex_dm->ps_tdma_du_adj_type =
+							16;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 8) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 7) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 6) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 7);
+						coex_dm->ps_tdma_du_adj_type =
+							7;
+					} else if (coex_dm->cur_ps_tdma == 16) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 15) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					} else if (coex_dm->cur_ps_tdma == 14) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 15);
+						coex_dm->ps_tdma_du_adj_type =
+							15;
+					}
+				}
+			} else {
+				if (coex_dm->cur_ps_tdma == 5) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 5);
-					coex_dm->tdma_adj_type = 5;
-				} else if (max_interval == 2) {
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 6) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 6);
-					coex_dm->tdma_adj_type = 6;
-				} else if (max_interval == 3) {
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 7) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 7);
-					coex_dm->tdma_adj_type = 7;
-				} else {
+								true, 3);
+					coex_dm->ps_tdma_du_adj_type = 3;
+				} else if (coex_dm->cur_ps_tdma == 8) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 7);
-					coex_dm->tdma_adj_type = 7;
+								true, 4);
+					coex_dm->ps_tdma_du_adj_type = 4;
 				}
-			} else {
-				if (max_interval == 1) {
+				if (coex_dm->cur_ps_tdma == 13) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 1);
-					coex_dm->tdma_adj_type = 1;
-				} else if (max_interval == 2) {
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 14) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 2);
-					coex_dm->tdma_adj_type = 2;
-				} else if (max_interval == 3) {
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 15) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 3);
-					coex_dm->tdma_adj_type = 3;
-				} else {
+								true, 11);
+					coex_dm->ps_tdma_du_adj_type = 11;
+				} else if (coex_dm->cur_ps_tdma == 16) {
 					halbtc8821a2ant_ps_tdma(btcoexist,
 								NORMAL_EXEC,
-								true, 3);
-					coex_dm->tdma_adj_type = 3;
+								true, 12);
+					coex_dm->ps_tdma_du_adj_type = 12;
+				}
+				if (result == -1) {
+					if (coex_dm->cur_ps_tdma == 1) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 4);
+						coex_dm->ps_tdma_du_adj_type =
+							4;
+					} else if (coex_dm->cur_ps_tdma == 9) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 12);
+						coex_dm->ps_tdma_du_adj_type =
+							12;
+					}
+				} else if (result == 1) {
+					if (coex_dm->cur_ps_tdma == 4) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 3) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 2) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 3);
+						coex_dm->ps_tdma_du_adj_type =
+							3;
+					} else if (coex_dm->cur_ps_tdma == 12) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 11) {
+						halbtc8821a2ant_ps_tdma(
+							btcoexist, NORMAL_EXEC,
+							true, 11);
+						coex_dm->ps_tdma_du_adj_type =
+							11;
+					} else if (coex_dm->cur_ps_tdma == 10) {
+						halbtc8821a2ant_ps_tdma(
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
-		wait_count = 0;
-	} else {
-		/* accquire the BT TRx retry count from BT_Info byte2 */
-		retry_count = coex_sta->bt_retry_cnt;
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], retry_count = %d\n", retry_count);
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], up = %d, dn = %d, m = %d, n = %d, wait_count = %d\n",
-			    (int)up, (int)dn, (int)m, (int)n, (int)wait_count);
-		result = 0;
-		wait_count++;
-
-		if (retry_count == 0) {
-			/* no retry in the last 2-second duration */
-			up++;
-			dn--;
-
-			if (dn <= 0)
-				dn = 0;
-
-			if (up >= n) {
-				/* if (retry count == 0) for 2*n seconds,
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
-			/* <=3 retry in the last 2-second duration */
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
-				/* m max value is 20, max time is 120 second,
-				 * recheck if adjust WiFi duration.
-				 */
-				if (m >= 20)
-					m = 20;
-
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
-			 * shrink WiFi duration
-			 */
-			if (wait_count == 1)
-				m++; /* avoid bounce in two levels */
-			else
-				m = 1;
-			/* m max value is 20, max time is 120 second,
-			 * recheck if adjust WiFi duration.
-			 */
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
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], max Interval = %d\n", max_interval);
-		if (max_interval == 1)
-			btc8821a2_int1(btcoexist, tx_pause, result);
-		else if (max_interval == 2)
-			btc8821a2_int2(btcoexist, tx_pause, result);
-		else if (max_interval == 3)
-			btc8821a2_int3(btcoexist, tx_pause, result);
 	}
 
-	/* if current PsTdma not match with the recorded one
-	 * (when scan, dhcp...), then we have to adjust it back to
-	 * the previous recorded one.
+	/* if current PsTdma not match with the recorded one (when scan,
+	 * dhcp...),
 	 */
-	if (coex_dm->cur_ps_tdma != coex_dm->tdma_adj_type) {
-		bool	scan = false, link = false, roam = false;
+	/* then we have to adjust it back to the previous record one. */
+	if (coex_dm->cur_ps_tdma != coex_dm->ps_tdma_du_adj_type) {
+		bool scan = false, link = false, roam = false;
 
-		btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-			    "[BTCoex], PsTdma type dismatch!!!, cur_ps_tdma = %d, recordPsTdma = %d\n",
-			    coex_dm->cur_ps_tdma, coex_dm->tdma_adj_type);
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], PsTdma type dismatch!!!, cur_ps_tdma=%d, recordPsTdma=%d\n",
+			coex_dm->cur_ps_tdma, coex_dm->ps_tdma_du_adj_type);
+		BTC_TRACE(trace_buf);
 
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 
-		if (!scan && !link && !roam) {
+		if (!scan && !link && !roam)
 			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true,
-						coex_dm->tdma_adj_type);
-		} else {
-			btc_alg_dbg(ALGO_TRACE_FW_DETAIL,
-				    "[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
+						coex_dm->ps_tdma_du_adj_type);
+		else {
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], roaming/link/scan is under progress, will adjust next time!!!\n");
+			BTC_TRACE(trace_buf);
 		}
 	}
-
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 0x6);
 }
 
-/* SCO only or SCO+PAN(HS)*/
-static void halbtc8821a2ant_action_sco(struct btc_coexist *btcoexist)
+/* SCO only or SCO+PAN(HS) */
+static
+void halbtc8821a2ant_action_sco(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	u8 wifi_rssi_state, bt_rssi_state;
 	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 4);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for SCO quality at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-					   0x5a5a5a5a, 0x5a5a5a5a, 0xffff, 0x3);
-	} else {
-		/* for SCO quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC,
-					   0x5aea5aea, 0x5aea5aea, 0xffff, 0x3);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) /* for SCO quality at 11b/g mode */
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
+	else { /* for SCO quality & wifi performance balance at 11n mode */
+		if (wifi_bw == BTC_WIFI_BW_HT40)
+			halbtc8821a2ant_coex_table_with_type(btcoexist,
+							     NORMAL_EXEC, 8);
+		else {
+			if (bt_link_info->sco_only)
+				halbtc8821a2ant_coex_table_with_type(
+					btcoexist, NORMAL_EXEC, 17);
+			else
+				halbtc8821a2ant_coex_table_with_type(
+					btcoexist, NORMAL_EXEC, 12);
+		}
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism
-		 * halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		 */
-
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
-		}
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false,
+				0); /* for voice quality */
 
-		/* sw mechanism */
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      true, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      true, 0x18);
 		}
 	} else {
-		/* fw mechanism
-		 * halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 5);
-		 */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 0); /*for voice quality*/
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      true, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      true, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_hid(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_hid(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, bt_rssi_state;
+	u32 wifi_bw;
+
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist,
-							  0, 2, 15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffff, 0x3);
-	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5aea5aea, 0xffff, 0x3);
-	}
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) /* for HID at 11b/g mode */
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+	else /* for HID quality & wifi performance balance at 11n mode */
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 2);
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
-		}
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
 
-		/* sw mechanism */
+	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 24);
+
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 9);
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 13);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
-static void halbtc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
+	u8 ap_num = 0;
+
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
+
+	/* define the office environment */
+	if ((ap_num >= 10) && BTC_RSSI_HIGH(wifi_rssi_state1) &&
+	    BTC_RSSI_HIGH(bt_rssi_state)) {
+		/* dbg_print(" AP#>10(%d)\n", ap_num); */
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
+					  0x0);
+		halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false,
+					   0x8);
+		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 
-	/* fw dac swing is called in btc8821a2ant_tdma_dur_adj()
-	 * halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	 */
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+		/* halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1); */
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+
+		/* sw mechanism */
+		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+		if (wifi_bw == BTC_WIFI_BW_HT40) {
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      true, 0x6);
+		} else {
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      true, 0x6);
+		}
+		return;
+	}
+
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+	} else {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     13);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+						 0x4);
+	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, false, 1);
-		} else {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
-		}
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		/* halbtc8821a2ant_tdma_duration_adjust(btcoexist, false, false,
+		 * 1);
+		 */
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	} else {
+		/* halbtc8821a2ant_tdma_duration_adjust(btcoexist, false, true,
+		 * 1);
+		 */
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	}
 
-		/* sw mechanism */
+	/* sw mechanism */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, false, 1);
-		} else {
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
 
-	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
-	/*fw dac swing is called in btc8821a2ant_tdma_dur_adj()
-	 *halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-	 */
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
+
+	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+	} else {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     13);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+						 0x4);
+	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if (bt_info_ext&BIT0) {
-			/*a2dp basic rate*/
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 2);
-		} else {
-			/*a2dp edr rate*/
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
-		}
+	halbtc8821a2ant_tdma_duration_adjust(btcoexist, false, true, 2);
 
-		/* sw mechanism */
+	/* sw mechanism */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if (bt_info_ext&BIT0) {
-			/* a2dp basic rate */
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 2);
-		} else {
-			/* a2dp edr rate */
-			btc8821a2ant_tdma_dur_adj(btcoexist, false, true, 1);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
+
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5aff5aff, 0xffff, 0x3);
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     10);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5aff5aff, 0xffff, 0x3);
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     13);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+						 0x4);
 	}
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 1);
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-		}
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH))
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 26);
+	else
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 26);
 
-		/* sw mechanism */
+	/* sw mechanism */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 1);
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 5);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
 /* PAN(HS) only */
-static void halbtc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
-	u8		wifi_rssi_state, bt_rssi_state;
-	u32		wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
+
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist,
-							  0, 2, 15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
-						   true);
-		} else {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC,
-						   false);
-		}
-		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
 
-		/* sw mechanism */
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist,
-						   NORMAL_EXEC, true);
-		} else {
-			halbtc8821a2ant_dec_bt_pwr(btcoexist,
-						   NORMAL_EXEC, false);
-		}
-
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						false, 1);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
-/* PAN(EDR)+A2DP */
-static void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
-{
-	u8	wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32	wifi_bw;
+/* PAN(EDR)+A2DP */
+static
+void halbtc8821a2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
+{
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
+
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
-	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+	else
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+						 0x4);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5afa5afa, 0xffff, 0x3);
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     12);
+
+		if (wifi_bw == BTC_WIFI_BW_HT40)
+			halbtc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							     true, 3);
+		else
+			halbtc8821a2ant_tdma_duration_adjust(btcoexist, false,
+							     false, 3);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5afa5afa, 0xffff, 0x3);
-	}
-
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			}
-		}
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     13);
+		halbtc8821a2ant_tdma_duration_adjust(btcoexist, false, true, 3);
+	}
 
-		/* sw mechanism */
+	/* sw mechanism	 */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
-		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
-		};
-	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  false, 3);
-			}
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, false,
-							  true, 3);
-			}
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
-
-		/* sw mechanism */
+	} else {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, false,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, false,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
 
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5f5a5f, 0xffff, 0x3);
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5f5a5f, 0xffff, 0x3);
-	}
-
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 3);
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     14);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+						 0x4);
+	}
+
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		if (wifi_bw == BTC_WIFI_BW_HT40) {
+			halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+							 3);
+			/* halbtc8821a2ant_coex_table_with_type(btcoexist,
+			 * NORMAL_EXEC, 11);
+			 */
+			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
+						  0xfffff, 0x780);
 		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
+			halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC,
+							 6);
+			/* halbtc8821a2ant_coex_table_with_type(btcoexist,
+			 * NORMAL_EXEC, 7);
+			 */
+			btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1,
+						  0xfffff, 0x0);
 		}
+		halbtc8821a2ant_tdma_duration_adjust(btcoexist, true, false, 2);
+	} else {
+		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		/* halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+		 * 14);
+		 */
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
+					  0x0);
+		halbtc8821a2ant_tdma_duration_adjust(btcoexist, true, true, 2);
+	}
 
-		/* sw mechanism */
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 10);
-		} else {
-			halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						true, 14);
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
 /* HID+A2DP+PAN(EDR) */
-static void btc8821a2ant_act_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
 
-	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist,
-							  0, 2, 15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		2, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 0);
+
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
+
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, false, 0x8);
 
 	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
+	if (BTC_RSSI_HIGH(bt_rssi_state))
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+	} else {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     14);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+						 0x4);
+	}
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffff, 0x3);
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		if (wifi_bw == BTC_WIFI_BW_HT40)
+			halbtc8821a2ant_tdma_duration_adjust(btcoexist, true,
+							     true, 3);
+		else
+			halbtc8821a2ant_tdma_duration_adjust(btcoexist, true,
+							     false, 3);
 	} else {
-		/* for HID quality & wifi performance balance at 11n mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5a5a5a5a, 0xffff, 0x3);
-	}
-
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			}
-		}
+		halbtc8821a2ant_tdma_duration_adjust(btcoexist, true, true, 3);
+	}
 
-		/* sw mechanism */
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  false, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  false, 3);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist, true,
-							  true, 3);
-			}
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
-	u8	wifi_rssi_state, bt_rssi_state, bt_info_ext;
-	u32	wifi_bw;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
+	u32 wifi_bw;
+	u8 ap_num = 0;
 
-	bt_info_ext = coex_sta->bt_info_ext;
-	wifi_rssi_state = halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2,
-							  15, 0);
-	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 35, 0);
+	wifi_rssi_state =
+		halbtc8821a2ant_wifi_rssi_state(btcoexist, 0, 2, 15, 0);
+	/* bt_rssi_state = halbtc8821a2ant_bt_rssi_state(2, 29, 0); */
+	wifi_rssi_state1 = halbtc8821a2ant_wifi_rssi_state(
+		btcoexist, 1, 2, BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES, 0);
+	bt_rssi_state = halbtc8821a2ant_bt_rssi_state(
+		3, BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES, 37);
 
-	if (halbtc8821a2ant_need_to_dec_bt_pwr(btcoexist))
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, true);
-	else
-		halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	halbtc8821a2ant_limited_rx(btcoexist, NORMAL_EXEC, false, true, 0x5);
+
+	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
 
-	if (BTC_WIFI_BW_LEGACY == wifi_bw) {
-		/* for HID at 11b/g mode */
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5f5b5f5b, 0xffffff, 0x3);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	if (wifi_bw == BTC_WIFI_BW_LEGACY) {
+		if (BTC_RSSI_HIGH(bt_rssi_state))
+			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		else if (BTC_RSSI_MEDIUM(bt_rssi_state))
+			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
+		else
+			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 	} else {
-		/*for HID quality & wifi performance balance at 11n mode*/
-		halbtc8821a2ant_coex_table(btcoexist, NORMAL_EXEC, 0x55ff55ff,
-					   0x5f5b5f5b, 0xffffff, 0x3);
-	}
-
-	if (BTC_WIFI_BW_HT40 == wifi_bw) {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
+		/* only 802.11N mode we have to dec bt power to 4 degree */
+		if (BTC_RSSI_HIGH(bt_rssi_state)) {
+			btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+					   &ap_num);
+			/* need to check ap Number of Not */
+			if (ap_num < 10)
+				halbtc8821a2ant_dec_bt_pwr(btcoexist,
+							   NORMAL_EXEC, 4);
+			else
+				halbtc8821a2ant_dec_bt_pwr(btcoexist,
+							   NORMAL_EXEC, 2);
+		} else if (BTC_RSSI_MEDIUM(bt_rssi_state)) {
+			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 2);
 		} else {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
+			halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
 		}
+	}
 
-		/* sw mechanism */
+	if (BTC_RSSI_HIGH(wifi_rssi_state1) && BTC_RSSI_HIGH(bt_rssi_state)) {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 7);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
+						 0x0, 0x0);
+	} else {
+		halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC,
+						     14);
+		halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_LPS_ON, 0x50,
+						 0x4);
+	}
+
+	if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
+	    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
+		/* halbtc8821a2ant_tdma_duration_adjust(btcoexist, true, false,
+		 * 3);
+		 */
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	} else {
+		/* halbtc8821a2ant_tdma_duration_adjust(btcoexist, true, true,
+		 * 3);
+		 */
+		halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 23);
+	}
+
+	/* sw mechanism */
+	if (wifi_bw == BTC_WIFI_BW_HT40) {
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, true, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, true, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	} else {
-		/* fw mechanism */
-		if ((bt_rssi_state == BTC_RSSI_STATE_HIGH) ||
-		    (bt_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			if (bt_info_ext&BIT0) {
-				/* a2dp basic rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-
-			} else {
-				/* a2dp edr rate */
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
-		} else {
-			if (bt_info_ext&BIT0) {
-				/*a2dp basic rate*/
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			} else {
-				/*a2dp edr rate*/
-				btc8821a2ant_tdma_dur_adj(btcoexist,
-							  true, true, 2);
-			}
-		}
-
-		/* sw mechanism */
 		if ((wifi_rssi_state == BTC_RSSI_STATE_HIGH) ||
 		    (wifi_rssi_state == BTC_RSSI_STATE_STAY_HIGH)) {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, true, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, true, false,
+						      false, 0x18);
 		} else {
-			btc8821a2ant_sw_mech1(btcoexist, false, true,
-					      false, false);
-			btc8821a2ant_sw_mech2(btcoexist, false, false,
-					      false, 0x18);
+			halbtc8821a2ant_sw_mechanism1(btcoexist, false, true,
+						      false, false);
+			halbtc8821a2ant_sw_mechanism2(btcoexist, false, false,
+						      false, 0x18);
 		}
 	}
 }
 
-static void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
+static
+void halbtc8821a2ant_action_bt_whck_test(struct btc_coexist *btcoexist)
+{
+	halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	/* sw all off */
+	halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
+
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+
+	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+	halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+}
+
+static
+void halbtc8821a2ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
+{
+	halbtc8821a2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+	halbtc8821a2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, 0);
+
+	/* sw all off */
+	halbtc8821a2ant_sw_mechanism1(btcoexist, false, false, false, false);
+	halbtc8821a2ant_sw_mechanism2(btcoexist, false, false, false, 0x18);
+
+	/* hw all off */
+	/* btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0); */
+	halbtc8821a2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
+
+	halbtc8821a2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0,
+					 0x0);
+	halbtc8821a2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+}
+
+static
+void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
-	bool	wifi_under_5g = false;
-	u8	algorithm = 0;
+	bool wifi_under_5g = false;
+	u8 algorithm = 0;
+	u32 num_of_wifi_link = 0;
+	u32 wifi_link_status = 0;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	bool miracast_plus_bt = false;
+	bool scan = false, link = false, roam = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], RunCoexistMechanism()===>\n");
+	BTC_TRACE(trace_buf);
 
 	if (btcoexist->manual_control) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Manual control!!!\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), return for Manual CTRL <===\n");
+		BTC_TRACE(trace_buf);
 		return;
 	}
 
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
-
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 	if (wifi_under_5g) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], RunCoexistMechanism(), run 5G coex setting!!<===\n");
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], RunCoexistMechanism(), run 5G coex setting!!<===\n");
+		BTC_TRACE(trace_buf);
 		halbtc8821a2ant_coex_under_5g(btcoexist);
 		return;
 	}
 
+	if (coex_sta->under_ips) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], wifi is under IPS !!!\n");
+		BTC_TRACE(trace_buf);
+		return;
+	}
+
+	if (coex_sta->bt_whck_test) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BT is under WHCK TEST!!!\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a2ant_action_bt_whck_test(btcoexist);
+		return;
+	}
+
 	algorithm = halbtc8821a2ant_action_algorithm(btcoexist);
 	if (coex_sta->c2h_bt_inquiry_page &&
-	    (BT_8821A_2ANT_COEX_ALGO_PANHS != algorithm)) {
-		btc_alg_dbg(ALGO_TRACE,
+	    (algorithm != BT_8821A_2ANT_COEX_ALGO_PANHS)) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
 			    "[BTCoex], BT is under inquiry/page scan !!\n");
-		halbtc8821a2ant_bt_inquiry_page(btcoexist);
+		BTC_TRACE(trace_buf);
+		halbtc8821a2ant_action_bt_inquiry(btcoexist);
+		return;
+	}
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+
+	if (scan || link || roam) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], WiFi is under Link Process !!\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a2ant_action_wifi_link_process(btcoexist);
+		return;
+	}
+
+	/* for P2P */
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_LINK_STATUS,
+			   &wifi_link_status);
+	num_of_wifi_link = wifi_link_status >> 16;
+
+	if ((num_of_wifi_link >= 2) ||
+	    (wifi_link_status & WIFI_P2P_GO_CONNECTED)) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"############# [BTCoex],  Multi-Port num_of_wifi_link = %d, wifi_link_status = 0x%x\n",
+			num_of_wifi_link, wifi_link_status);
+		BTC_TRACE(trace_buf);
+
+		if (bt_link_info->bt_link_exist)
+			miracast_plus_bt = true;
+		else
+			miracast_plus_bt = false;
+
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_MIRACAST_PLUS_BT,
+				   &miracast_plus_bt);
+		halbtc8821a2ant_action_wifi_multi_port(btcoexist);
+
 		return;
 	}
 
+	miracast_plus_bt = false;
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_MIRACAST_PLUS_BT,
+			   &miracast_plus_bt);
+
 	coex_dm->cur_algorithm = algorithm;
-	btc_alg_dbg(ALGO_TRACE,
-		    "[BTCoex], Algorithm = %d\n", coex_dm->cur_algorithm);
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "[BTCoex], Algorithm = %d\n",
+		    coex_dm->cur_algorithm);
+	BTC_TRACE(trace_buf);
 
 	if (halbtc8821a2ant_is_common_action(btcoexist)) {
-		btc_alg_dbg(ALGO_TRACE,
-			    "[BTCoex], Action 2-Ant common\n");
-		coex_dm->reset_tdma_adjust = true;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Action 2-Ant common.\n");
+		BTC_TRACE(trace_buf);
+		coex_dm->auto_tdma_adjust = false;
 	} else {
 		if (coex_dm->cur_algorithm != coex_dm->pre_algorithm) {
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], pre_algorithm = %d, cur_algorithm = %d\n",
-				    coex_dm->pre_algorithm,
-				    coex_dm->cur_algorithm);
-			coex_dm->reset_tdma_adjust = true;
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], pre_algorithm=%d, cur_algorithm=%d\n",
+				coex_dm->pre_algorithm, coex_dm->cur_algorithm);
+			BTC_TRACE(trace_buf);
+			coex_dm->auto_tdma_adjust = false;
 		}
 		switch (coex_dm->cur_algorithm) {
 		case BT_8821A_2ANT_COEX_ALGO_SCO:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = SCO\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = SCO.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_sco(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HID\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HID.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_hid(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = A2DP\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_a2dp(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = A2DP+PAN(HS)\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = A2DP+PAN(HS).\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_a2dp_pan_hs(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = PAN(EDR).\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_pan_edr(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANHS:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HS mode\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HS mode.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_pan_hs(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = PAN+A2DP\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = PAN+A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_pan_edr_a2dp(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_PANEDR_HID:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = PAN(EDR)+HID\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = PAN(EDR)+HID.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_pan_edr_hid(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HID+A2DP+PAN\n");
-			btc8821a2ant_act_hid_a2dp_pan_edr(btcoexist);
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HID+A2DP+PAN.\n");
+			BTC_TRACE(trace_buf);
+			halbtc8821a2ant_action_hid_a2dp_pan_edr(btcoexist);
 			break;
 		case BT_8821A_2ANT_COEX_ALGO_HID_A2DP:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = HID+A2DP\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = HID+A2DP.\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_action_hid_a2dp(btcoexist);
 			break;
 		default:
-			btc_alg_dbg(ALGO_TRACE,
-				    "[BTCoex], Action 2-Ant, algorithm = coexist All Off!!\n");
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Action 2-Ant, algorithm = coexist All Off!!\n");
+			BTC_TRACE(trace_buf);
 			halbtc8821a2ant_coex_all_off(btcoexist);
 			break;
 		}
@@ -3272,590 +3712,814 @@ static void halbtc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
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
+static
+void halbtc8821a2ant_wifi_off_hw_cfg(struct btc_coexist *btcoexist)
 {
-	u8 u1tmp = 0;
+	u8 h2c_parameter[2] = {0};
+	u32 fw_ver = 0;
+
+	/* set wlan_act to low */
+	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
+
+	btcoexist->btc_set_rf_reg(
+		btcoexist, BTC_RF_A, 0x1, 0xfffff,
+		0x780); /* WiFi goto standby while GNT_BT 0-->1 */
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
+	if (fw_ver >= 0x180000) {
+		/* Use H2C to set GNT_BT to HIGH */
+		h2c_parameter[0] = 1;
+		btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1, h2c_parameter);
+	} else {
+		btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
+	}
+}
+
+static
+void halbtc8821a2ant_init_hw_config(struct btc_coexist *btcoexist, bool back_up)
+{
+	u8 u8tmp = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], 2Ant Init HW Config!!\n");
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], 2Ant Init HW Config!!\n");
+	BTC_TRACE(trace_buf);
 
 	/* backup rf 0x1e value */
-	coex_dm->bt_rf0x1e_backup =
+	coex_dm->bt_rf_0x1e_backup =
 		btcoexist->btc_get_rf_reg(btcoexist, BTC_RF_A, 0x1e, 0xfffff);
 
-	/* 0x790[5:0] = 0x5 */
-	u1tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
-	u1tmp &= 0xc0;
-	u1tmp |= 0x5;
-	btcoexist->btc_write_1byte(btcoexist, 0x790, u1tmp);
+	/* 0x790[5:0]=0x5 */
+	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
+	u8tmp &= 0xc0;
+	u8tmp |= 0x5;
+	btcoexist->btc_write_1byte(btcoexist, 0x790, u8tmp);
 
-	/*Antenna config */
-	halbtc8821a2ant_set_ant_path(btcoexist,
-				     BTC_ANT_WIFI_AT_MAIN, true, false);
+	/* Antenna config	 */
+	halbtc8821a2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN, true,
+				     false);
+	coex_sta->dis_ver_info_cnt = 0;
 
 	/* PTA parameter */
-	halbtc8821a2ant_coex_table(btcoexist,
-				   FORCE_EXEC, 0x55555555, 0x55555555,
-				   0xffff, 0x3);
+	halbtc8821a2ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
 
 	/* Enable counter statistics */
-	/*0x76e[3] = 1, WLAN_Act control by PTA*/
-	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
+	btcoexist->btc_write_1byte(
+		btcoexist, 0x76e,
+		0x4); /* 0x76e[3] =1, WLAN_Act control by PTA */
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
 
-void
-ex_halbtc8821a2ant_init_coex_dm(
-	struct btc_coexist *btcoexist
-	)
+/* ************************************************************
+ * work around function start with wa_halbtc8821a2ant_
+ * ************************************************************
+ * ************************************************************
+ * extern function start with ex_halbtc8821a2ant_
+ * ************************************************************
+ */
+void ex_halbtc8821a2ant_power_on_setting(struct btc_coexist *btcoexist) {}
+
+void ex_halbtc8821a2ant_pre_load_firmware(struct btc_coexist *btcoexist)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u8 u8tmp = 0x4; /* Set BIT2 by default since it's 2ant case */
+
+	/* */
+	/* S0 or S1 setting and Local register setting(By the setting fw can get
+	 * ant number, S0/S1, ... info)
+	 */
+	/* Local setting bit define */
+	/*	BIT0: "0" for no antenna inverse; "1" for antenna inverse  */
+	/*	BIT1: "0" for internal switch; "1" for external switch */
+	/*	BIT2: "0" for one antenna; "1" for two antenna */
+	/* NOTE: here default all internal switch and 1-antenna ==> BIT1=0 and
+	 * BIT2=0
+	 */
+	if (btcoexist->chip_interface == BTC_INTF_USB) {
+		/* fixed at S0 for USB interface */
+		u8tmp |= 0x1; /* antenna inverse */
+		btcoexist->btc_write_local_reg_1byte(btcoexist, 0xfe08, u8tmp);
+	} else {
+		/* for PCIE and SDIO interface, we check efuse 0xc3[6] */
+		if (board_info->single_ant_path == 0) {
+		} else if (board_info->single_ant_path == 1) {
+			/* set to S0 */
+			u8tmp |= 0x1; /* antenna inverse */
+		}
+
+		if (btcoexist->chip_interface == BTC_INTF_PCI)
+			btcoexist->btc_write_local_reg_1byte(btcoexist, 0x384,
+							     u8tmp);
+		else if (btcoexist->chip_interface == BTC_INTF_SDIO)
+			btcoexist->btc_write_local_reg_1byte(btcoexist, 0x60,
+							     u8tmp);
+	}
+}
+
+void ex_halbtc8821a2ant_init_hw_config(struct btc_coexist *btcoexist,
+				       bool wifi_only)
+{
+	halbtc8821a2ant_init_hw_config(btcoexist, true);
+}
+
+void ex_halbtc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], Coex Mechanism Init!!\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "[BTCoex], Coex Mechanism Init!!\n");
+	BTC_TRACE(trace_buf);
 
 	halbtc8821a2ant_init_coex_dm(btcoexist);
 }
 
-void
-ex_halbtc8821a2ant_display_coex_info(
-	struct btc_coexist *btcoexist
-	)
+void ex_halbtc8821a2ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
-	struct btc_stack_info *stack_info = &btcoexist->stack_info;
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 u1tmp[4], i, bt_info_ext, ps_tdma_case = 0;
-	u32 u4tmp[4];
-	bool roam = false, scan = false, link = false, wifi_under_5g = false;
-	bool bt_hs_on = false, wifi_busy = false;
-	long wifi_rssi = 0, bt_hs_rssi = 0;
-	u32 wifi_bw, wifi_traffic_dir;
-	u8 wifi_dot_11_chnl, wifi_hs_chnl;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
+	u8 *cli_buf = btcoexist->cli_buf;
+	u8 u8tmp[4], i, bt_info_ext, ps_tdma_case = 0;
+	u32 u32tmp[4];
+	u32 fa_of_dm, fa_cck;
 	u32 fw_ver = 0, bt_patch_ver = 0;
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n ============[BT Coexist info]============");
-
-	if (!board_info->bt_exist) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n BT not exists !!!");
-		return;
-	}
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d ", "Ant PG number/ Ant mechanism:",
-		   board_info->pg_ant_num, board_info->btdm_ant_num);
+	CL_PRINTF(cli_buf);
 
 	if (btcoexist->manual_control) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s", "[Action Manual control]!!");
+		CL_SPRINTF(
+			cli_buf, BT_TMP_BUF_SIZE,
+			"\r\n ============[Under Manual Control]============");
+		CL_PRINTF(cli_buf);
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
+			   "\r\n ==========================================");
+		CL_PRINTF(cli_buf);
 	}
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s / %d", "BT stack/ hci ext ver",
-		   ((stack_info->profile_notified) ? "Yes" : "No"),
-		   stack_info->hci_version);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d ",
+		   "Ant PG number/ Ant mechanism:", board_info->pg_ant_num,
+		   board_info->btdm_ant_num);
+	CL_PRINTF(cli_buf);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER, &bt_patch_ver);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d_%d/ 0x%x/ 0x%x(%d)",
-		   "CoexVer/ FwVer/ PatchVer",
-		   glcoex_ver_date_8821a_2ant, glcoex_ver_8821a_2ant,
-		   fw_ver, bt_patch_ver, bt_patch_ver);
-
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_BL_HS_OPERATION, &bt_hs_on);
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_U1_WIFI_DOT11_CHNL, &wifi_dot_11_chnl);
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_U1_WIFI_HS_CHNL, &wifi_hs_chnl);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d / %d(%d)",
-		   "Dot11 channel / HsMode(HsChnl)",
-		   wifi_dot_11_chnl, bt_hs_on, wifi_hs_chnl);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %3ph ",
-		   "H2C Wifi inform bt chnl Info",
-		   coex_dm->wifi_chnl_info);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
-	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %ld/ %ld", "Wifi rssi/ HS rssi",
-		   wifi_rssi, bt_hs_rssi);
-
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d/ %d ", "Wifi link/ roam/ scan",
-		   link, roam, scan);
-
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_U4_WIFI_BW, &wifi_bw);
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_BL_WIFI_BUSY, &wifi_busy);
-	btcoexist->btc_get(btcoexist,
-		BTC_GET_U4_WIFI_TRAFFIC_DIRECTION, &wifi_traffic_dir);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %s / %s/ %s ", "Wifi status",
-		   (wifi_under_5g ? "5G" : "2.4G"),
-		   ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
-		    (((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40" : "HT20"))),
-		   ((!wifi_busy) ? "idle" :
-		    ((BTC_WIFI_TRAFFIC_TX == wifi_traffic_dir) ?
-		     "uplink" : "downlink")));
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = [%s/ %d/ %d] ", "BT [status/ rssi/ retryCnt]",
-		   ((coex_sta->c2h_bt_inquiry_page) ? ("inquiry/page scan") :
-		    ((BT_8821A_2ANT_BT_STATUS_IDLE == coex_dm->bt_status)
-		     ? "idle" : ((BT_8821A_2ANT_BT_STATUS_CON_IDLE ==
-		     coex_dm->bt_status) ? "connected-idle" : "busy"))),
-		    coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
-
-	if (stack_info->profile_notified) {
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %d / %d / %d / %d", "SCO/HID/PAN/A2DP",
-			   stack_info->sco_exist, stack_info->hid_exist,
-			   stack_info->pan_exist, stack_info->a2dp_exist);
-
-		btcoexist->btc_disp_dbg_msg(btcoexist,
-					    BTC_DBG_DISP_BT_LINK_INFO);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
+		   "\r\n %-35s = %d_%x/ 0x%x/ 0x%x(%d)",
+		   "CoexVer/ FwVer/ PatchVer", glcoex_ver_date_8821a_2ant,
+		   glcoex_ver_8821a_2ant, fw_ver, bt_patch_ver, bt_patch_ver);
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
+		cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = [%s/ %ddBm/ %d] ",
+		"BT [status/ rssi/ retryCnt]",
+		((coex_sta->bt_disabled) ?
+		 ("disabled") :
+		 ((coex_sta->c2h_bt_inquiry_page) ?
+		  ("inquiry/page scan") :
+		  ((BT_8821A_2ANT_BT_STATUS_NON_CONNECTED_IDLE ==
+		    coex_dm->bt_status) ?
+		   "non-connected idle" :
+		   ((BT_8821A_2ANT_BT_STATUS_CONNECTED_IDLE ==
+		     coex_dm->bt_status) ?
+		    "connected-idle" :
+		    "busy")))),
+		coex_sta->bt_rssi - 100, coex_sta->bt_retry_cnt);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d / %d / %d / %d",
+		   "SCO/HID/PAN/A2DP", bt_link_info->sco_exist,
+		   bt_link_info->hid_exist, bt_link_info->pan_exist,
+		   bt_link_info->a2dp_exist);
+	CL_PRINTF(cli_buf);
+
+	{
+		CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s",
+			   "BT Role",
+			   (bt_link_info->slave_role) ? "Slave" : "Master");
+		CL_PRINTF(cli_buf);
 	}
 
 	bt_info_ext = coex_sta->bt_info_ext;
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s",
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s",
 		   "BT Info A2DP rate",
-		   (bt_info_ext&BIT0) ? "Basic rate" : "EDR rate");
+		   (bt_info_ext & BIT(0)) ? "Basic rate" : "EDR rate");
+	CL_PRINTF(cli_buf);
 
 	for (i = 0; i < BT_INFO_SRC_8821A_2ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
-			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %7ph(%d)",
-				   glbt_info_src_8821a_2ant[i],
-				   coex_sta->bt_info_c2h[i],
-				   coex_sta->bt_info_c2h_cnt[i]);
+			CL_SPRINTF(
+				cli_buf, BT_TMP_BUF_SIZE,
+				"\r\n %-35s = %02x %02x %02x %02x %02x %02x %02x(%d)",
+				glbt_info_src_8821a_2ant[i],
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
 
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s/%s",
-		   "PS state, IPS/LPS",
-		   ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
-		   ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")));
-	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
-
-	/* Sw mechanism*/
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
+	/* Sw mechanism	 */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
 		   "============[Sw mechanism]============");
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d/ %d/ %d ",
-		   "SM1[ShRf/ LpRA/ LimDig/ btLna]",
-		   coex_dm->cur_rf_rx_lpf_shrink, coex_dm->cur_low_penalty_ra,
-		   coex_dm->limited_dig, coex_dm->cur_bt_lna_constrain);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d/ %d(0x%x) ",
+	CL_PRINTF(cli_buf);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d ",
+		   "SM1[ShRf/ LpRA/ LimDig]", coex_dm->cur_rf_rx_lpf_shrink,
+		   coex_dm->cur_low_penalty_ra, coex_dm->limited_dig);
+	CL_PRINTF(cli_buf);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d(0x%x) ",
 		   "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
 		   coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
 		   coex_dm->cur_dac_swing_on, coex_dm->cur_dac_swing_lvl);
+	CL_PRINTF(cli_buf);
 
-	/* Fw mechanism*/
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
+	/* Fw mechanism		 */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
 		   "============[Fw mechanism]============");
-
-	if (!btcoexist->manual_control) {
-		ps_tdma_case = coex_dm->cur_ps_tdma;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %5ph case-%d",
-			   "PS TDMA",
-			   coex_dm->ps_tdma_para, ps_tdma_case);
-
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n %-35s = %d/ %d ", "DecBtPwr/ IgnWlanAct",
-			   coex_dm->cur_dec_bt_pwr,
-			   coex_dm->cur_ignore_wlan_act);
-	}
-
-	/* Hw setting*/
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s", "============[Hw setting]============");
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x", "RF-A, 0x1e initVal",
-		   coex_dm->bt_rf0x1e_backup);
-
-	u1tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
-	u1tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x6cc);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x ",
-		   "0x778 (W_Act)/ 0x6cc (CoTab Sel)",
-		   u1tmp[0], u1tmp[1]);
-
-	u1tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x8db);
-	u1tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xc5b);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0x8db(ADC)/0xc5b[29:25](DAC)",
-		   ((u1tmp[0]&0x60)>>5), ((u1tmp[1]&0x3e)>>1));
-
-	u4tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xcb4);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0xcb4[7:0](ctrl)/ 0xcb4[29:28](val)",
-		   u4tmp[0]&0xff, ((u4tmp[0]&0x30000000)>>28));
-
-	u1tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x40);
-	u4tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
-	u4tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x974);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0x40/ 0x4c[24:23]/ 0x974",
-		   u1tmp[0], ((u4tmp[0]&0x01800000)>>23), u4tmp[1]);
-
-	u4tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
-	u1tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0x550(bcn ctrl)/0x522",
-		   u4tmp[0], u1tmp[0]);
-
-	u4tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
-	u1tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0xa0a);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0xc50(DIG)/0xa0a(CCK-TH)",
-		   u4tmp[0], u1tmp[0]);
-
-	u4tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xf48);
-	u1tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0xa5b);
-	u1tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xa5c);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "OFDM-FA/ CCK-FA",
-		   u4tmp[0], (u1tmp[0]<<8) + u1tmp[1]);
-
-	u4tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
-	u4tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
-	u4tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0x6c0/0x6c4/0x6c8",
-		   u4tmp[0], u4tmp[1], u4tmp[2]);
-
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x770 (hi-pri Rx/Tx)",
-		   coex_sta->high_priority_rx, coex_sta->high_priority_tx);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x774(low-pri Rx/Tx)",
-		   coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-
-	/* Tx mgnt queue hang or not, 0x41b should = 0xf, ex: 0xd ==>hang*/
-	u1tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x41b);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x",
-		   "0x41b (mgntQ hang chk == 0xf)",
-		   u1tmp[0]);
-
+	CL_PRINTF(cli_buf);
+
+	ps_tdma_case = coex_dm->cur_ps_tdma;
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
+		   "\r\n %-35s = %02x %02x %02x %02x %02x case-%d (auto:%d)",
+		   "PS TDMA", coex_dm->ps_tdma_para[0],
+		   coex_dm->ps_tdma_para[1], coex_dm->ps_tdma_para[2],
+		   coex_dm->ps_tdma_para[3], coex_dm->ps_tdma_para[4],
+		   ps_tdma_case, coex_dm->auto_tdma_adjust);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d",
+		   "Coex Table Type", coex_sta->coex_table_type);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d ",
+		   "DecBtPwr/ IgnWlanAct", coex_dm->cur_bt_dec_pwr_lvl,
+		   coex_dm->cur_ignore_wlan_act);
+	CL_PRINTF(cli_buf);
+
+	/* Hw setting		 */
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s",
+		   "============[Hw setting]============");
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x",
+		   "RF-A, 0x1e initVal", coex_dm->bt_rf_0x1e_backup);
+	CL_PRINTF(cli_buf);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
+	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xc5b);
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x880);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		   "0x778/0x880[29:25]/0xc58[29:25]", u8tmp[0],
+		   (u32tmp[0] & 0x3e000000) >> 25, ((u8tmp[1] & 0x3e) >> 1));
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x764);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x76e);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		   "0x764/ 0x765/ 0x76e", (u32tmp[0] & 0xff),
+		   (u32tmp[0] & 0xff00) >> 8, u8tmp[0]);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xcb4);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
+		   "0xcb4[7:0](ctrl)/ 0xcb4[29:28](val)", u32tmp[0] & 0xff,
+		   ((u32tmp[0] & 0x30000000) >> 28));
+	CL_PRINTF(cli_buf);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x40);
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x974);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		   "0x40/ 0x4c[24:23]/ 0x974", u8tmp[0],
+		   ((u32tmp[0] & 0x01800000) >> 23), u32tmp[1]);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
+		   "0x550(bcn ctrl)/0x522", u32tmp[0], u8tmp[0]);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x49c);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x",
+		   "0xc50(dig)/0x49c(null-drop)", u32tmp[0] & 0xff, u8tmp[0]);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xda0);
+	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0xda4);
+	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0xda8);
+	u32tmp[3] = btcoexist->btc_read_4byte(btcoexist, 0xcf0);
+
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0xa5b);
+	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0xa5c);
+
+	fa_of_dm = ((u32tmp[0] & 0xffff0000) >> 16) +
+		   ((u32tmp[1] & 0xffff0000) >> 16) + (u32tmp[1] & 0xffff) +
+		   (u32tmp[2] & 0xffff) + ((u32tmp[3] & 0xffff0000) >> 16) +
+		   (u32tmp[3] & 0xffff);
+	fa_cck = (u8tmp[0] << 8) + u8tmp[1];
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
+		   "OFDM-CCA/OFDM-FA/CCK-FA", u32tmp[0] & 0xffff, fa_of_dm,
+		   fa_cck);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d/ %d",
+		   "CRC_OK CCK/11g/11n/11n-Agg", coex_sta->crc_ok_cck,
+		   coex_sta->crc_ok_11g, coex_sta->crc_ok_11n,
+		   coex_sta->crc_ok_11n_agg);
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d/ %d",
+		   "CRC_Err CCK/11g/11n/11n-Agg", coex_sta->crc_err_cck,
+		   coex_sta->crc_err_11g, coex_sta->crc_err_11n,
+		   coex_sta->crc_err_11n_agg);
+	CL_PRINTF(cli_buf);
+
+	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
+	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
+	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
+	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x6cc);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
+		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+		   "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)", u32tmp[0], u32tmp[1],
+		   u32tmp[2], u8tmp[0]);
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
+#if (BT_AUTO_REPORT_ONLY_8821A_2ANT == 1)
+/* halbtc8821a2ant_monitor_bt_ctr(btcoexist); */
+#endif
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
 void ex_halbtc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
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
+		halbtc8821a2ant_wifi_off_hw_cfg(btcoexist);
+		halbtc8821a2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 		halbtc8821a2ant_coex_all_off(btcoexist);
-	} else if (BTC_IPS_LEAVE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS LEAVE notify\n");
+	} else if (type == BTC_IPS_LEAVE) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], IPS LEAVE notify\n");
+		BTC_TRACE(trace_buf);
 		coex_sta->under_ips = false;
-		/*halbtc8821a2ant_init_coex_dm(btcoexist);*/
+		halbtc8821a2ant_init_hw_config(btcoexist, false);
+		halbtc8821a2ant_init_coex_dm(btcoexist);
+		halbtc8821a2ant_query_bt_info(btcoexist);
 	}
 }
 
 void ex_halbtc8821a2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
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
 
 void ex_halbtc8821a2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	if (BTC_SCAN_START == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN START notify\n");
-	} else if (BTC_SCAN_FINISH == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN FINISH notify\n");
+	u8 u8tmpa, u8tmpb;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	u8tmpa = btcoexist->btc_read_1byte(btcoexist, 0x765);
+	u8tmpb = btcoexist->btc_read_1byte(btcoexist, 0x76e);
+
+	if (type == BTC_SCAN_START) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], SCAN START notify\n");
+		BTC_TRACE(trace_buf);
+	} else if (type == BTC_SCAN_FINISH) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], SCAN FINISH notify\n");
+		BTC_TRACE(trace_buf);
 	}
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+		    "############# [BTCoex], 0x765=0x%x, 0x76e=0x%x\n", u8tmpa,
+		    u8tmpb);
+	BTC_TRACE(trace_buf);
 }
 
 void ex_halbtc8821a2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	if (BTC_ASSOCIATE_START == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT START notify\n");
-	} else if (BTC_ASSOCIATE_FINISH == type) {
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
 	}
 }
 
 void ex_halbtc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
 					    u8 type)
 {
-	u8	h2c_parameter[3] = {0};
-	u32	wifi_bw;
-	u8	wifi_central_chnl;
-
-	if (BTC_MEDIA_CONNECT == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA connect notify\n");
+	u8 h2c_parameter[3] = {0};
+	u32 wifi_bw;
+	u8 wifi_central_chnl;
+	u8 ap_num = 0;
+	char trace_buf[BT_TMP_BUF_SIZE];
+
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
 	}
 
-	/* only 2.4G we need to inform bt the chnl mask*/
+	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
 			   &wifi_central_chnl);
-	if ((BTC_MEDIA_CONNECT == type) &&
-	    (wifi_central_chnl <= 14)) {
+	if ((type == BTC_MEDIA_CONNECT) && (wifi_central_chnl <= 14)) {
 		h2c_parameter[0] = 0x1;
 		h2c_parameter[1] = wifi_central_chnl;
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
-		if (BTC_WIFI_BW_HT40 == wifi_bw)
+		if (wifi_bw == BTC_WIFI_BW_HT40) {
 			h2c_parameter[2] = 0x30;
-		else
-			h2c_parameter[2] = 0x20;
+		} else {
+			btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM,
+					   &ap_num);
+			if (ap_num < 10)
+				h2c_parameter[2] = 0x30;
+			else
+				h2c_parameter[2] = 0x20;
+		}
 	}
 
 	coex_dm->wifi_chnl_info[0] = h2c_parameter[0];
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
 
-void ex_halbtc8821a2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type) {
+void ex_halbtc8821a2ant_specific_packet_notify(struct btc_coexist *btcoexist,
+					       u8 type)
+{
+	char trace_buf[BT_TMP_BUF_SIZE];
+
 	if (type == BTC_PACKET_DHCP) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], DHCP Packet notify\n");
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], DHCP Packet notify\n");
+		BTC_TRACE(trace_buf);
 	}
 }
 
 void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 				       u8 *tmp_buf, u8 length)
 {
-	u8		bt_info = 0;
-	u8		i, rsp_source = 0;
-	static u32	set_bt_lna_cnt, set_bt_psd_mode;
-	bool		bt_busy = false, limited_dig = false;
-	bool		wifi_connected = false, bt_hs_on = false;
+	u8 bt_info = 0;
+	u8 i, rsp_source = 0;
+	bool bt_busy = false, limited_dig = false;
+	bool wifi_connected = false, wifi_under_5g = false;
+	char trace_buf[BT_TMP_BUF_SIZE];
 
 	coex_sta->c2h_bt_info_req_sent = false;
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
+			   &wifi_connected);
 
-	rsp_source = tmp_buf[0]&0xf;
+	rsp_source = tmp_buf[0] & 0xf;
 	if (rsp_source >= BT_INFO_SRC_8821A_2ANT_MAX)
 		rsp_source = BT_INFO_SRC_8821A_2ANT_WIFI_FW;
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
 
-	if (BT_INFO_SRC_8821A_2ANT_WIFI_FW != rsp_source) {
-		coex_sta->bt_retry_cnt =	/* [3:0]*/
-			coex_sta->bt_info_c2h[rsp_source][2]&0xf;
+	if (btcoexist->manual_control) {
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], BtInfoNotify(), return for Manual CTRL<===\n");
+		BTC_TRACE(trace_buf);
+		return;
+	}
+
+	/* if 0xff, it means BT is under WHCK test */
+	if (bt_info == 0xff)
+		coex_sta->bt_whck_test = true;
+	else
+		coex_sta->bt_whck_test = false;
+
+	if (rsp_source != BT_INFO_SRC_8821A_2ANT_WIFI_FW) {
+		coex_sta->bt_retry_cnt = /* [3:0] */
+			coex_sta->bt_info_c2h[rsp_source][2] & 0xf;
 
 		coex_sta->bt_rssi =
-			coex_sta->bt_info_c2h[rsp_source][3]*2+10;
-
-		coex_sta->bt_info_ext =
-			coex_sta->bt_info_c2h[rsp_source][4];
-
-		/* Here we need to resend some wifi info to BT*/
-		/* because bt is reset and loss of the info.*/
-		if ((coex_sta->bt_info_ext & BIT1)) {
-			btcoexist->btc_get(btcoexist,
-				BTC_GET_BL_WIFI_CONNECTED, &wifi_connected);
-			if (wifi_connected) {
-				ex_halbtc8821a2ant_media_status_notify(btcoexist,
-					BTC_MEDIA_CONNECT);
-			} else {
-				ex_halbtc8821a2ant_media_status_notify(btcoexist,
-					BTC_MEDIA_DISCONNECT);
-			}
+			coex_sta->bt_info_c2h[rsp_source][3] * 2 + 10;
 
-			set_bt_psd_mode = 0;
+		coex_sta->bt_info_ext = coex_sta->bt_info_c2h[rsp_source][4];
+
+		coex_sta->bt_tx_rx_mask =
+			(coex_sta->bt_info_c2h[rsp_source][2] & 0x40);
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TX_RX_MASK,
+				   &coex_sta->bt_tx_rx_mask);
+		if (coex_sta->bt_tx_rx_mask) {
+			/* BT into is responded by BT FW and BT RF REG 0x3C !=
+			 * 0x01 => Need to switch BT TRx Mask
+			 */
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], Switch BT TRx Mask since BT RF REG 0x3C != 0x01\n");
+			BTC_TRACE(trace_buf);
+			btcoexist->btc_set_bt_reg(btcoexist, BTC_BT_REG_RF,
+						  0x3c, 0x01);
 		}
-		if (set_bt_psd_mode <= 3) {
-			halbtc8821a2ant_set_bt_psd_mode(btcoexist, FORCE_EXEC,
-							0x0); /*fix CH-BW mode*/
-			set_bt_psd_mode++;
+
+		/* Here we need to resend some wifi info to BT */
+		/* because bt is reset and loss of the info. */
+		if ((coex_sta->bt_info_ext & BIT(1))) {
+			BTC_SPRINTF(
+				trace_buf, BT_TMP_BUF_SIZE,
+				"[BTCoex], BT ext info bit1 check, send wifi BW&Chnl to BT!!\n");
+			BTC_TRACE(trace_buf);
+			if (wifi_connected)
+				ex_halbtc8821a2ant_media_status_notify(
+					btcoexist, BTC_MEDIA_CONNECT);
+			else
+				ex_halbtc8821a2ant_media_status_notify(
+					btcoexist, BTC_MEDIA_DISCONNECT);
 		}
 
-		if (coex_dm->cur_bt_lna_constrain) {
-			if (!(coex_sta->bt_info_ext & BIT2)) {
-				if (set_bt_lna_cnt <= 3) {
-					btc8821a2_set_bt_lna_const(btcoexist,
-								   FORCE_EXEC,
-								   true);
-					set_bt_lna_cnt++;
+		if (!btcoexist->manual_control && !wifi_under_5g) {
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], BT ext info = 0x%x!!\n",
+				    coex_sta->bt_info_ext);
+			BTC_TRACE(trace_buf);
+			if ((coex_sta->bt_info_ext & BIT(3))) {
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT ext info bit3=1, wifi_connected=%d\n",
+					wifi_connected);
+				BTC_TRACE(trace_buf);
+				if (wifi_connected) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT ext info bit3 check, set BT NOT to ignore Wlan active!!\n");
+					BTC_TRACE(trace_buf);
+					halbtc8821a2ant_ignore_wlan_act(
+						btcoexist, FORCE_EXEC, false);
+				}
+			} else {
+				BTC_SPRINTF(
+					trace_buf, BT_TMP_BUF_SIZE,
+					"[BTCoex], BT ext info bit3=0, wifi_connected=%d\n",
+					wifi_connected);
+				BTC_TRACE(trace_buf);
+				/* BT already NOT ignore Wlan active, do nothing
+				 * here.
+				 */
+				if (!wifi_connected) {
+					BTC_SPRINTF(
+						trace_buf, BT_TMP_BUF_SIZE,
+						"[BTCoex], BT ext info bit3 check, set BT to ignore Wlan active!!\n");
+					BTC_TRACE(trace_buf);
+					halbtc8821a2ant_ignore_wlan_act(
+						btcoexist, FORCE_EXEC, true);
 				}
 			}
-		} else {
-			set_bt_lna_cnt = 0;
-		}
-
-		if ((coex_sta->bt_info_ext & BIT3)) {
-			halbtc8821a2ant_ignore_wlan_act(btcoexist,
-							FORCE_EXEC, false);
-		} else {
-			/* BT already NOT ignore Wlan active, do nothing here.*/
 		}
 
-		if ((coex_sta->bt_info_ext & BIT4)) {
-			/* BT auto report already enabled, do nothing*/
+#if (BT_AUTO_REPORT_ONLY_8821A_2ANT == 0)
+		if ((coex_sta->bt_info_ext & BIT(4))) {
+			/* BT auto report already enabled, do nothing */
 		} else {
-			halbtc8821a2ant_bt_auto_report(btcoexist,
-						       FORCE_EXEC, true);
+			halbtc8821a2ant_bt_auto_report(btcoexist, FORCE_EXEC,
+						       true);
 		}
+#endif
 	}
 
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
-	/* check BIT2 first ==> check if bt is under inquiry or page scan*/
-	if (bt_info & BT_INFO_8821A_2ANT_B_INQ_PAGE) {
+	/* check BIT2 first ==> check if bt is under inquiry or page scan */
+	if (bt_info & BT_INFO_8821A_2ANT_B_INQ_PAGE)
 		coex_sta->c2h_bt_inquiry_page = true;
-		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_NON_IDLE;
-	} else {
+	else
 		coex_sta->c2h_bt_inquiry_page = false;
-		if (bt_info == 0x1) {
-			/* connection exists but not busy*/
-			coex_sta->bt_link_exist = true;
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_CON_IDLE;
-		} else if (bt_info & BT_INFO_8821A_2ANT_B_CONNECTION) {
-			/* connection exists and some link is busy*/
-			coex_sta->bt_link_exist = true;
-			if (bt_info & BT_INFO_8821A_2ANT_B_FTP)
-				coex_sta->pan_exist = true;
-			else
-				coex_sta->pan_exist = false;
-			if (bt_info & BT_INFO_8821A_2ANT_B_A2DP)
-				coex_sta->a2dp_exist = true;
-			else
-				coex_sta->a2dp_exist = false;
-			if (bt_info & BT_INFO_8821A_2ANT_B_HID)
-				coex_sta->hid_exist = true;
-			else
-				coex_sta->hid_exist = false;
-			if (bt_info & BT_INFO_8821A_2ANT_B_SCO_ESCO)
-				coex_sta->sco_exist = true;
-			else
-				coex_sta->sco_exist = false;
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_NON_IDLE;
-		} else {
-			coex_sta->bt_link_exist = false;
+
+	/* set link exist status */
+	if (!(bt_info & BT_INFO_8821A_2ANT_B_CONNECTION)) {
+		coex_sta->bt_link_exist = false;
+		coex_sta->pan_exist = false;
+		coex_sta->a2dp_exist = false;
+		coex_sta->hid_exist = false;
+		coex_sta->sco_exist = false;
+	} else { /* connection exists */
+		coex_sta->bt_link_exist = true;
+		if (bt_info & BT_INFO_8821A_2ANT_B_FTP)
+			coex_sta->pan_exist = true;
+		else
 			coex_sta->pan_exist = false;
+		if (bt_info & BT_INFO_8821A_2ANT_B_A2DP)
+			coex_sta->a2dp_exist = true;
+		else
 			coex_sta->a2dp_exist = false;
+		if (bt_info & BT_INFO_8821A_2ANT_B_HID)
+			coex_sta->hid_exist = true;
+		else
 			coex_sta->hid_exist = false;
+		if (bt_info & BT_INFO_8821A_2ANT_B_SCO_ESCO)
+			coex_sta->sco_exist = true;
+		else
 			coex_sta->sco_exist = false;
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_IDLE;
+
+		if ((!coex_sta->hid_exist) &&
+		    (!coex_sta->c2h_bt_inquiry_page) &&
+		    (!coex_sta->sco_exist)) {
+			if (coex_sta->high_priority_tx +
+				    coex_sta->high_priority_rx >=
+			    160)
+				coex_sta->hid_exist = true;
 		}
+	}
 
-		if (bt_hs_on)
-			coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_NON_IDLE;
+	halbtc8821a2ant_update_bt_link_info(btcoexist);
+
+	if (!(bt_info & BT_INFO_8821A_2ANT_B_CONNECTION)) {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_NON_CONNECTED_IDLE;
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], BtInfoNotify(), BT Non-Connected idle!!!\n");
+		BTC_TRACE(trace_buf);
+	} else if (bt_info == BT_INFO_8821A_2ANT_B_CONNECTION) {
+		/* connection exists but no busy */
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_CONNECTED_IDLE;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BtInfoNotify(), BT Connected-idle!!!\n");
+		BTC_TRACE(trace_buf);
+	} else if ((bt_info & BT_INFO_8821A_2ANT_B_SCO_ESCO) ||
+		   (bt_info & BT_INFO_8821A_2ANT_B_SCO_BUSY)) {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_SCO_BUSY;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
+		BTC_TRACE(trace_buf);
+	} else if (bt_info & BT_INFO_8821A_2ANT_B_ACL_BUSY) {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_ACL_BUSY;
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
+		BTC_TRACE(trace_buf);
+	} else {
+		coex_dm->bt_status = BT_8821A_2ANT_BT_STATUS_MAX;
+		BTC_SPRINTF(
+			trace_buf, BT_TMP_BUF_SIZE,
+			"[BTCoex], BtInfoNotify(), BT Non-Defined state!!!\n");
+		BTC_TRACE(trace_buf);
 	}
 
-	if (BT_8821A_2ANT_BT_STATUS_NON_IDLE == coex_dm->bt_status)
+	if ((coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_ACL_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_SCO_BUSY) ||
+	    (coex_dm->bt_status == BT_8821A_2ANT_BT_STATUS_ACL_SCO_BUSY)) {
 		bt_busy = true;
-	else
+		limited_dig = true;
+	} else {
 		bt_busy = false;
+		limited_dig = false;
+	}
+
 	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_TRAFFIC_BUSY, &bt_busy);
 
-	if (BT_8821A_2ANT_BT_STATUS_IDLE != coex_dm->bt_status)
-		limited_dig = true;
-	else
-		limited_dig = false;
 	coex_dm->limited_dig = limited_dig;
-	btcoexist->btc_set(btcoexist,
-		BTC_SET_BL_BT_LIMITED_DIG, &limited_dig);
+	btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_LIMITED_DIG, &limited_dig);
 
 	halbtc8821a2ant_run_coexist_mechanism(btcoexist);
 }
 
 void ex_halbtc8821a2ant_halt_notify(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Halt notify\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "[BTCoex], Halt notify\n");
+	BTC_TRACE(trace_buf);
 
+	halbtc8821a2ant_wifi_off_hw_cfg(btcoexist);
+	/* remove due to interrupt is disabled that polling c2h will fail and
+	 * delay 100ms.
+	 */
 	halbtc8821a2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
+
 	ex_halbtc8821a2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
+void ex_halbtc8821a2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
+{
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE, "[BTCoex], Pnp notify\n");
+	BTC_TRACE(trace_buf);
+
+	if (pnp_state == BTC_WIFI_PNP_SLEEP) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Pnp notify to SLEEP\n");
+		BTC_TRACE(trace_buf);
+	} else if (pnp_state == BTC_WIFI_PNP_WAKE_UP) {
+		BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+			    "[BTCoex], Pnp notify to WAKE UP\n");
+		BTC_TRACE(trace_buf);
+		halbtc8821a2ant_init_hw_config(btcoexist, false);
+		halbtc8821a2ant_init_coex_dm(btcoexist);
+		halbtc8821a2ant_query_bt_info(btcoexist);
+	}
+}
+
 void ex_halbtc8821a2ant_periodical(struct btc_coexist *btcoexist)
 {
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
-			      glcoex_ver_date_8821a_2ant, glcoex_ver_8821a_2ant,
-			      fw_ver, bt_patch_ver, bt_patch_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "[BTCoex], ****************************************************************\n");
+	char trace_buf[BT_TMP_BUF_SIZE];
+
+	BTC_SPRINTF(
+		trace_buf, BT_TMP_BUF_SIZE,
+		"[BTCoex], ==========================Periodical===========================\n");
+	BTC_TRACE(trace_buf);
+
+	if (coex_sta->dis_ver_info_cnt <= 5) {
+		coex_sta->dis_ver_info_cnt += 1;
+		if (coex_sta->dis_ver_info_cnt == 3) {
+			/* Antenna config to set 0x765 = 0x0 (GNT_BT control by
+			 * PTA) after initial
+			 */
+			BTC_SPRINTF(trace_buf, BT_TMP_BUF_SIZE,
+				    "[BTCoex], Set GNT_BT control by PTA\n");
+			BTC_TRACE(trace_buf);
+			halbtc8821a2ant_set_ant_path(
+				btcoexist, BTC_ANT_WIFI_AT_MAIN, false, false);
+		}
 	}
 
+#if (BT_AUTO_REPORT_ONLY_8821A_2ANT == 0)
 	halbtc8821a2ant_query_bt_info(btcoexist);
+	halbtc8821a2ant_monitor_bt_enable_disable(btcoexist);
+#else
 	halbtc8821a2ant_monitor_bt_ctr(btcoexist);
-	btc8821a2ant_mon_bt_en_dis(btcoexist);
+	halbtc8821a2ant_monitor_wifi_ctr(btcoexist);
+
+	if (halbtc8821a2ant_is_wifi_status_changed(btcoexist) ||
+	    coex_dm->auto_tdma_adjust)
+		halbtc8821a2ant_run_coexist_mechanism(btcoexist);
+#endif
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
index b4cf1f5..f779b02 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.h
@@ -23,109 +23,126 @@
  *
  *****************************************************************************/
 
-/*===========================================
+/* *******************************************
  * The following is for 8821A 2Ant BT Co-exist definition
- *===========================================
-*/
-#define	BT_INFO_8821A_2ANT_B_FTP		BIT7
-#define	BT_INFO_8821A_2ANT_B_A2DP		BIT6
-#define	BT_INFO_8821A_2ANT_B_HID		BIT5
-#define	BT_INFO_8821A_2ANT_B_SCO_BUSY		BIT4
-#define	BT_INFO_8821A_2ANT_B_ACL_BUSY		BIT3
-#define	BT_INFO_8821A_2ANT_B_INQ_PAGE		BIT2
-#define	BT_INFO_8821A_2ANT_B_SCO_ESCO		BIT1
-#define	BT_INFO_8821A_2ANT_B_CONNECTION		BIT0
-
-#define	BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT	2
-
-enum _BT_INFO_SRC_8821A_2ANT {
-	BT_INFO_SRC_8821A_2ANT_WIFI_FW		= 0x0,
-	BT_INFO_SRC_8821A_2ANT_BT_RSP		= 0x1,
+ * *******************************************
+ */
+#define BT_AUTO_REPORT_ONLY_8821A_2ANT	1
+
+#define BT_INFO_8821A_2ANT_B_FTP	BIT(7)
+#define BT_INFO_8821A_2ANT_B_A2DP	BIT(6)
+#define BT_INFO_8821A_2ANT_B_HID	BIT(5)
+#define BT_INFO_8821A_2ANT_B_SCO_BUSY	BIT(4)
+#define BT_INFO_8821A_2ANT_B_ACL_BUSY	BIT(3)
+#define BT_INFO_8821A_2ANT_B_INQ_PAGE	BIT(2)
+#define BT_INFO_8821A_2ANT_B_SCO_ESCO	BIT(1)
+#define BT_INFO_8821A_2ANT_B_CONNECTION	BIT(0)
+
+#define BTC_RSSI_COEX_THRESH_TOL_8821A_2ANT	2
+
+#define BT_8821A_2ANT_WIFI_RSSI_COEXSWITCH_THRES                               \
+	42 /* WiFi RSSI Threshold for 2-Ant TDMA/1-Ant PS-TDMA translation */
+#define BT_8821A_2ANT_BT_RSSI_COEXSWITCH_THRES                                 \
+	46 /* BT RSSI Threshold for 2-Ant TDMA/1-Ant PS-TDMA translation */
+
+enum bt_info_src_8821a_2ant {
+	BT_INFO_SRC_8821A_2ANT_WIFI_FW	= 0x0,
+	BT_INFO_SRC_8821A_2ANT_BT_RSP	= 0x1,
 	BT_INFO_SRC_8821A_2ANT_BT_ACTIVE_SEND	= 0x2,
 	BT_INFO_SRC_8821A_2ANT_MAX
 };
 
-enum _BT_8821A_2ANT_BT_STATUS {
-	BT_8821A_2ANT_BT_STATUS_IDLE		= 0x0,
-	BT_8821A_2ANT_BT_STATUS_CON_IDLE	= 0x1,
-	BT_8821A_2ANT_BT_STATUS_NON_IDLE	= 0x2,
+enum bt_8821a_2ant_bt_status {
+	BT_8821A_2ANT_BT_STATUS_NON_CONNECTED_IDLE	= 0x0,
+	BT_8821A_2ANT_BT_STATUS_CONNECTED_IDLE	= 0x1,
+	BT_8821A_2ANT_BT_STATUS_INQ_PAGE	= 0x2,
+	BT_8821A_2ANT_BT_STATUS_ACL_BUSY	= 0x3,
+	BT_8821A_2ANT_BT_STATUS_SCO_BUSY	= 0x4,
+	BT_8821A_2ANT_BT_STATUS_ACL_SCO_BUSY	= 0x5,
 	BT_8821A_2ANT_BT_STATUS_MAX
 };
 
-enum _BT_8821A_2ANT_COEX_ALGO {
-	BT_8821A_2ANT_COEX_ALGO_UNDEFINED		= 0x0,
-	BT_8821A_2ANT_COEX_ALGO_SCO			= 0x1,
-	BT_8821A_2ANT_COEX_ALGO_HID			= 0x2,
-	BT_8821A_2ANT_COEX_ALGO_A2DP			= 0x3,
-	BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS		= 0x4,
-	BT_8821A_2ANT_COEX_ALGO_PANEDR			= 0x5,
-	BT_8821A_2ANT_COEX_ALGO_PANHS			= 0x6,
-	BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP		= 0x7,
-	BT_8821A_2ANT_COEX_ALGO_PANEDR_HID		= 0x8,
-	BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR		= 0x9,
-	BT_8821A_2ANT_COEX_ALGO_HID_A2DP		= 0xa,
-	BT_8821A_2ANT_COEX_ALGO_MAX			= 0xb,
+enum bt_8821a_2ant_coex_algo {
+	BT_8821A_2ANT_COEX_ALGO_UNDEFINED	= 0x0,
+	BT_8821A_2ANT_COEX_ALGO_SCO	= 0x1,
+	BT_8821A_2ANT_COEX_ALGO_HID	= 0x2,
+	BT_8821A_2ANT_COEX_ALGO_A2DP	= 0x3,
+	BT_8821A_2ANT_COEX_ALGO_A2DP_PANHS	= 0x4,
+	BT_8821A_2ANT_COEX_ALGO_PANEDR	= 0x5,
+	BT_8821A_2ANT_COEX_ALGO_PANHS	= 0x6,
+	BT_8821A_2ANT_COEX_ALGO_PANEDR_A2DP	= 0x7,
+	BT_8821A_2ANT_COEX_ALGO_PANEDR_HID	= 0x8,
+	BT_8821A_2ANT_COEX_ALGO_HID_A2DP_PANEDR	= 0x9,
+	BT_8821A_2ANT_COEX_ALGO_HID_A2DP	= 0xa,
+	BT_8821A_2ANT_COEX_ALGO_MAX	= 0xb,
 };
 
 struct coex_dm_8821a_2ant {
 	/* fw mechanism */
-	bool		pre_dec_bt_pwr;
-	bool		cur_dec_bt_pwr;
-	bool		pre_bt_lna_constrain;
-	bool		cur_bt_lna_constrain;
-	u8		pre_bt_psd_mode;
-	u8		cur_bt_psd_mode;
-	u8		pre_fw_dac_swing_lvl;
-	u8		cur_fw_dac_swing_lvl;
-	bool		cur_ignore_wlan_act;
-	bool		pre_ignore_wlan_act;
-	u8		pre_ps_tdma;
-	u8		cur_ps_tdma;
-	u8		ps_tdma_para[5];
-	u8		tdma_adj_type;
-	bool		reset_tdma_adjust;
-	bool		pre_ps_tdma_on;
-	bool		cur_ps_tdma_on;
-	bool		pre_bt_auto_report;
-	bool		cur_bt_auto_report;
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
-	bool		pre_rf_rx_lpf_shrink;
-	bool		cur_rf_rx_lpf_shrink;
-	u32		bt_rf0x1e_backup;
-	bool		pre_low_penalty_ra;
-	bool		cur_low_penalty_ra;
-	bool		pre_dac_swing_on;
-	u32		pre_dac_swing_lvl;
-	bool		cur_dac_swing_on;
-	u32		cur_dac_swing_lvl;
-	bool		pre_adc_back_off;
-	bool		cur_adc_back_off;
-	bool		pre_agc_table_en;
-	bool		cur_agc_table_en;
-	u32		pre_val0x6c0;
-	u32		cur_val0x6c0;
-	u32		pre_val0x6c4;
-	u32		cur_val0x6c4;
-	u32		pre_val0x6c8;
-	u32		cur_val0x6c8;
-	u8		pre_val0x6cc;
-	u8		cur_val0x6cc;
-	bool		limited_dig;
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
 
 	/* algorithm related */
-	u8		pre_algorithm;
-	u8		cur_algorithm;
-	u8		bt_status;
-	u8		wifi_chnl_info[3];
+	u8	pre_algorithm;
+	u8	cur_algorithm;
+	u8	bt_status;
+	u8	wifi_chnl_info[3];
+
+	bool	need_recover0x948;
+	u32	backup0x948;
+
+	u8	pre_lps;
+	u8	cur_lps;
+	u8	pre_rpwm;
+	u8	cur_rpwm;
 };
 
 struct coex_sta_8821a_2ant {
+	bool	bt_disabled;
 	bool	bt_link_exist;
 	bool	sco_exist;
 	bool	a2dp_exist;
 	bool	hid_exist;
 	bool	pan_exist;
+
 	bool	under_lps;
 	bool	under_ips;
 	u32	high_priority_tx;
@@ -133,73 +150,53 @@ struct coex_sta_8821a_2ant {
 	u32	low_priority_tx;
 	u32	low_priority_rx;
 	u8	bt_rssi;
+	bool	bt_tx_rx_mask;
 	u8	pre_bt_rssi_state;
 	u8	pre_wifi_rssi_state[4];
 	bool	c2h_bt_info_req_sent;
 	u8	bt_info_c2h[BT_INFO_SRC_8821A_2ANT_MAX][10];
 	u32	bt_info_c2h_cnt[BT_INFO_SRC_8821A_2ANT_MAX];
+	bool	bt_whck_test;
 	bool	c2h_bt_inquiry_page;
 	u8	bt_retry_cnt;
 	u8	bt_info_ext;
+
+	u32	crc_ok_cck;
+	u32	crc_ok_11g;
+	u32	crc_ok_11n;
+	u32	crc_ok_11n_agg;
+
+	u32	crc_err_cck;
+	u32	crc_err_11g;
+	u32	crc_err_11n;
+	u32	crc_err_11n_agg;
+
+	u8	coex_table_type;
+	bool	force_lps_on;
+
+	u8	dis_ver_info_cnt;
 };
 
-/*===========================================
- *	The following is interface which will notify coex module.
- *===========================================
+/* *******************************************
+ * The following is interface which will notify coex module.
+ * *******************************************
  */
-void
-ex_halbtc8821a2ant_init_hwconfig(
-	struct btc_coexist *btcoexist
-	);
-void
-ex_halbtc8821a2ant_init_coex_dm(
-	struct btc_coexist *btcoexist
-	);
-void
-ex_halbtc8821a2ant_ips_notify(
-	struct btc_coexist *btcoexist,
-	u8 type
-	);
-void
-ex_halbtc8821a2ant_lps_notify(
-	struct btc_coexist *btcoexist,
-	u8 type
-	);
-void
-ex_halbtc8821a2ant_scan_notify(
-	struct btc_coexist *btcoexist,
-	u8 type
-	);
-void
-ex_halbtc8821a2ant_connect_notify(
-	struct btc_coexist *btcoexist,
-	u8 type
-	);
-void
-ex_halbtc8821a2ant_media_status_notify(
-	struct btc_coexist *btcoexist,
-	u8 type
-	);
-void
-ex_halbtc8821a2ant_special_packet_notify(
-	struct btc_coexist *btcoexist,
-	u8 type
-	);
-void
-ex_halbtc8821a2ant_bt_info_notify(
-	struct btc_coexist *btcoexist,
-	u8 *tmp_buf,
-	u8 length
-	);
-void
-ex_halbtc8821a2ant_halt_notify(
-	struct btc_coexist *btcoexist
-	);
-void
-ex_halbtc8821a2ant_periodical(
-	struct btc_coexist *btcoexist
-	);
-void
-ex_halbtc8821a2ant_display_coex_info(
-	struct btc_coexist *btcoexist
-	);
+void ex_halbtc8821a2ant_power_on_setting(struct btc_coexist *btcoexist);
+void ex_halbtc8821a2ant_pre_load_firmware(struct btc_coexist *btcoexist);
+void ex_halbtc8821a2ant_init_hw_config(struct btc_coexist *btcoexist,
+				       bool wifi_only);
+void ex_halbtc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist);
+void ex_halbtc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_halbtc8821a2ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_halbtc8821a2ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_halbtc8821a2ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_halbtc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
+					    u8 type);
+void ex_halbtc8821a2ant_specific_packet_notify(struct btc_coexist *btcoexist,
+					       u8 type);
+void ex_halbtc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
+				       u8 *tmp_buf, u8 length);
+void ex_halbtc8821a2ant_halt_notify(struct btc_coexist *btcoexist);
+void ex_halbtc8821a2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
+void ex_halbtc8821a2ant_periodical(struct btc_coexist *btcoexist);
+void ex_halbtc8821a2ant_display_coex_info(struct btc_coexist *btcoexist);
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index 9a89ae0..6e0c0af 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -30,12 +30,25 @@
  ***********************************************/
 
 struct btc_coexist gl_bt_coexist;
-
-u32 btc_dbg_type[BTC_MSG_MAX];
+u8 gl_btc_dbg_buf[BT_TMP_BUF_SIZE];
 
 /***************************************************
  *		Debug related function
  ***************************************************/
+
+const char *const gl_btc_wifi_bw_string[] = {
+	"11bg",
+	"HT20",
+	"HT40",
+	"HT80",
+	"HT160"
+};
+
+const char *const gl_btc_wifi_freq_string[] = {
+	"2.4G",
+	"5G"
+};
+
 static bool halbtc_is_bt_coexist_available(struct btc_coexist *btcoexist)
 {
 	if (!btcoexist->binded || NULL == btcoexist->adapter)
@@ -54,28 +67,69 @@ static bool halbtc_is_wifi_busy(struct rtl_priv *rtlpriv)
 
 static void halbtc_dbg_init(void)
 {
-	u8 i;
+}
 
-	for (i = 0; i < BTC_MSG_MAX; i++)
-		btc_dbg_type[i] = 0;
+void halbtc_dbg_info_init(struct btc_coexist *btcoexist, u8 *buf, u32 size)
+{
+	struct btcoex_dbg_info *btcoex_dbg_info = &btcoexist->dbg_info;
 
-	btc_dbg_type[BTC_MSG_INTERFACE] =
-/*			INTF_INIT				| */
-/*			INTF_NOTIFY				| */
-			0;
+	memset(btcoex_dbg_info, 0, sizeof(struct btcoex_dbg_info));
 
-	btc_dbg_type[BTC_MSG_ALGORITHM] =
-/*			ALGO_BT_RSSI_STATE			| */
-/*			ALGO_WIFI_RSSI_STATE			| */
-/*			ALGO_BT_MONITOR				| */
-/*			ALGO_TRACE				| */
-/*			ALGO_TRACE_FW				| */
-/*			ALGO_TRACE_FW_DETAIL			| */
-/*			ALGO_TRACE_FW_EXEC			| */
-/*			ALGO_TRACE_SW				| */
-/*			ALGO_TRACE_SW_DETAIL			| */
-/*			ALGO_TRACE_SW_EXEC			| */
-			0;
+	if (buf && size) {
+		btcoex_dbg_info->info = buf;
+		btcoex_dbg_info->size = size;
+	}
+}
+
+void halbtc_dbg_info_print(struct btc_coexist *btcoexist, u8 *dbgmsg)
+{
+	struct btcoex_dbg_info *btcoex_dbg_info = &btcoexist->dbg_info;
+	u32 msglen;
+	u8 *pbuf;
+
+	if (!btcoex_dbg_info->info)
+		return;
+
+	msglen = strlen(dbgmsg);
+	if (btcoex_dbg_info->len + msglen > btcoex_dbg_info->size)
+		return;
+
+	pbuf = btcoex_dbg_info->info + btcoex_dbg_info->len;
+	memcpy(pbuf, dbgmsg, msglen);
+	btcoex_dbg_info->len += msglen;
+}
+
+/***************************************************
+ *		helper function
+ ***************************************************/
+static bool is_any_client_connect_to_ap(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rtl_mac *mac = rtl_mac(rtlpriv);
+	struct rtl_sta_info *drv_priv;
+	u8 cnt = 0;
+
+	if (mac->opmode == NL80211_IFTYPE_ADHOC ||
+	    mac->opmode == NL80211_IFTYPE_MESH_POINT ||
+	    mac->opmode == NL80211_IFTYPE_AP) {
+		if (in_interrupt() > 0) {
+			list_for_each_entry(drv_priv, &rtlpriv->entry_list,
+					    list) {
+				cnt++;
+			}
+		} else {
+			spin_lock_bh(&rtlpriv->locks.entry_list_lock);
+			list_for_each_entry(drv_priv, &rtlpriv->entry_list,
+					    list) {
+				cnt++;
+			}
+			spin_unlock_bh(&rtlpriv->locks.entry_list_lock);
+		}
+	}
+	if (cnt > 0)
+		return true;
+	else
+		return false;
 }
 
 static bool halbtc_is_bt40(struct rtl_priv *adapter)
@@ -141,8 +195,8 @@ static u8 halbtc_get_wifi_central_chnl(struct btc_coexist *btcoexist)
 
 	if (rtlphy->current_channel != 0)
 		chnl = rtlphy->current_channel;
-	btc_alg_dbg(ALGO_TRACE,
-		    "static halbtc_get_wifi_central_chnl:%d\n", chnl);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_TRACE,
+		 "halbtc_get_wifi_central_chnl:%d\n", chnl);
 	return chnl;
 }
 
@@ -175,6 +229,11 @@ u8 rtl_get_hwpg_package_type(struct rtl_priv *rtlpriv)
 	return rtlhal->package_type;
 }
 
+/* ************************************
+ *         Hal helper function
+ * ************************************
+ */
+
 static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv;
@@ -188,12 +247,14 @@ static void halbtc_leave_lps(struct btc_coexist *btcoexist)
 			   &ap_enable);
 
 	if (ap_enable) {
-		pr_info("halbtc_leave_lps()<--dont leave lps under AP mode\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
+			 "halbtc_leave_lps()<--dont leave lps under AP mode\n");
 		return;
 	}
 
 	btcoexist->bt_info.bt_ctrl_lps = true;
 	btcoexist->bt_info.bt_lps_on = false;
+	rtl_lps_leave(rtlpriv->mac80211.hw);
 }
 
 static void halbtc_enter_lps(struct btc_coexist *btcoexist)
@@ -209,12 +270,14 @@ static void halbtc_enter_lps(struct btc_coexist *btcoexist)
 			   &ap_enable);
 
 	if (ap_enable) {
-		pr_info("halbtc_enter_lps()<--dont enter lps under AP mode\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_DMESG,
+			 "halbtc_enter_lps()<--dont enter lps under AP mode\n");
 		return;
 	}
 
 	btcoexist->bt_info.bt_ctrl_lps = true;
 	btcoexist->bt_info.bt_lps_on = false;
+	rtl_lps_enter(rtlpriv->mac80211.hw);
 }
 
 static void halbtc_normal_lps(struct btc_coexist *btcoexist)
@@ -225,20 +288,59 @@ static void halbtc_normal_lps(struct btc_coexist *btcoexist)
 	}
 }
 
-static void halbtc_leave_low_power(void)
+static void halbtc_leave_low_power(struct btc_coexist *btcoexist)
 {
 }
 
-static void halbtc_nomal_low_power(void)
+static void halbtc_normal_low_power(struct btc_coexist *btcoexist)
 {
 }
 
-static void halbtc_disable_low_power(void)
+static void halbtc_disable_low_power(struct btc_coexist *btcoexist,
+				     bool low_pwr_disable)
 {
+	/*TODO: original/leave 32k low power*/
+	btcoexist->bt_info.bt_disable_low_pwr = low_pwr_disable;
 }
 
-static void halbtc_aggregation_check(void)
+static void halbtc_aggregation_check(struct btc_coexist *btcoexist)
 {
+	bool need_to_act = false;
+
+	/* ===================================== */
+	/* To void continuous deleteBA=>addBA=>deleteBA=>addBA */
+	/* This function is not allowed to continuous called. */
+	/* It can only be called after 8 seconds. */
+	/* ===================================== */
+
+	if (btcoexist->bt_info.reject_agg_pkt) {
+		;/*TODO: reject*/
+		btcoexist->bt_info.pre_reject_agg_pkt =
+			btcoexist->bt_info.reject_agg_pkt;
+	} else {
+		if (btcoexist->bt_info.pre_reject_agg_pkt) {
+			need_to_act = true;
+			btcoexist->bt_info.pre_reject_agg_pkt =
+				btcoexist->bt_info.reject_agg_pkt;
+		}
+
+		if (btcoexist->bt_info.pre_bt_ctrl_agg_buf_size !=
+		    btcoexist->bt_info.bt_ctrl_agg_buf_size) {
+			need_to_act = true;
+			btcoexist->bt_info.pre_bt_ctrl_agg_buf_size =
+				btcoexist->bt_info.bt_ctrl_agg_buf_size;
+		}
+
+		if (btcoexist->bt_info.bt_ctrl_agg_buf_size) {
+			if (btcoexist->bt_info.pre_agg_buf_size !=
+			    btcoexist->bt_info.agg_buf_size) {
+				need_to_act = true;
+			}
+			btcoexist->bt_info.pre_agg_buf_size =
+				btcoexist->bt_info.agg_buf_size;
+		}
+	}
+
 }
 
 static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
@@ -246,9 +348,47 @@ static u32 halbtc_get_bt_patch_version(struct btc_coexist *btcoexist)
 	return 0;
 }
 
-static s32 halbtc_get_wifi_rssi(struct rtl_priv *adapter)
+u32 halbtc_get_wifi_link_status(struct btc_coexist *btcoexist)
+{
+	/*------------------------------------
+	 * return value:
+	 * [31:16]=> connected port number
+	 * [15:0]=> port connected bit define
+	 *------------------------------------
+	 */
+
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rtl_mac *mac = rtl_mac(rtlpriv);
+	u32 ret_val = 0;
+	u32 port_connected_status = 0, num_of_connected_port = 0;
+
+	if (mac->opmode == NL80211_IFTYPE_STATION &&
+	    mac->link_state >= MAC80211_LINKED) {
+		port_connected_status |= WIFI_STA_CONNECTED;
+		num_of_connected_port++;
+	}
+	/* AP & ADHOC & MESH */
+	if (is_any_client_connect_to_ap(btcoexist)) {
+		port_connected_status |= WIFI_AP_CONNECTED;
+		num_of_connected_port++;
+	}
+	/*if(BT_HsConnectionEstablished(Adapter))
+	 * {
+	 * port_connected_status |= WIFI_HS_CONNECTED;
+	 * num_of_connected_port++;
+	 * }
+	 */
+	/* TODO:
+	 * P2P Connected Status
+	 */
+
+	ret_val = (num_of_connected_port << 16) | port_connected_status;
+
+	return ret_val;
+}
+
+static s32 halbtc_get_wifi_rssi(struct rtl_priv *rtlpriv)
 {
-	struct rtl_priv *rtlpriv = adapter;
 	s32	undec_sm_pwdb = 0;
 
 	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
@@ -282,7 +422,10 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_CONNECTED:
-		if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
+		if (rtlpriv->mac80211.opmode == NL80211_IFTYPE_STATION &&
+		    rtlpriv->mac80211.link_state >= MAC80211_LINKED)
+			tmp = true;
+		if (is_any_client_connect_to_ap(btcoexist))
 			tmp = true;
 		*bool_tmp = tmp;
 		break;
@@ -316,17 +459,6 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 		break;
 	case BTC_GET_BL_WIFI_UNDER_5G:
 		*bool_tmp = false; /*TODO*/
-
-	case BTC_GET_BL_WIFI_DHCP:	/*TODO*/
-		break;
-	case BTC_GET_BL_WIFI_SOFTAP_IDLE:
-		*bool_tmp = true;
-		break;
-	case BTC_GET_BL_WIFI_SOFTAP_LINKING:
-		*bool_tmp = false;
-		break;
-	case BTC_GET_BL_WIFI_IN_EARLY_SUSPEND:
-		*bool_tmp = false;
 		break;
 	case BTC_GET_BL_WIFI_AP_MODE_ENABLE:
 		*bool_tmp = false;
@@ -338,11 +470,20 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 			*bool_tmp = true;
 		break;
 	case BTC_GET_BL_WIFI_UNDER_B_MODE:
-		*bool_tmp = false; /*TODO*/
+		if (rtlpriv->mac80211.mode == WIRELESS_MODE_B)
+			*bool_tmp = true;
+		else
+			*bool_tmp = false;
 		break;
 	case BTC_GET_BL_EXT_SWITCH:
 		*bool_tmp = false;
 		break;
+	case BTC_GET_BL_WIFI_IS_IN_MP_MODE:
+		*bool_tmp = false;
+		break;
+	case BTC_GET_BL_IS_ASUS_8723B:
+		*bool_tmp = false;
+		break;
 	case BTC_GET_S4_WIFI_RSSI:
 		*s32_tmp = halbtc_get_wifi_rssi(rtlpriv);
 		break;
@@ -359,7 +500,10 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 			*u32_tmp = BTC_WIFI_TRAFFIC_RX;
 		break;
 	case BTC_GET_U4_WIFI_FW_VER:
-		*u32_tmp = rtlhal->fw_version;
+		*u32_tmp = (rtlhal->fw_version << 16) | rtlhal->fw_subversion;
+		break;
+	case BTC_GET_U4_WIFI_LINK_STATUS:
+		*u32_tmp = halbtc_get_wifi_link_status(btcoexist);
 		break;
 	case BTC_GET_U4_BT_PATCH_VER:
 		*u32_tmp = halbtc_get_bt_patch_version(btcoexist);
@@ -376,8 +520,17 @@ static bool halbtc_get(void *void_btcoexist, u8 get_type, void *out_buf)
 	case BTC_GET_U1_WIFI_HS_CHNL:
 		*u8_tmp = 1;/*BT_OperateChnl(rtlpriv);*/
 		break;
-	case BTC_GET_U1_MAC_PHY_MODE:
-		*u8_tmp = BTC_MP_UNKNOWN;
+	case BTC_GET_U1_AP_NUM:
+		/* driver don't know AP num,
+		 * so the return value here is not right
+		 */
+		*u8_tmp = 1;/* pDefMgntInfo->NumBssDesc4Query; */
+		break;
+	case BTC_GET_U1_ANT_TYPE:
+		*u8_tmp = (u8)BTC_ANT_TYPE_0;
+		break;
+	case BTC_GET_U1_IOT_PEER:
+		*u8_tmp = 0;
 		break;
 
 		/************* 1Ant **************/
@@ -420,11 +573,17 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 		btcoexist->bt_info.reject_agg_pkt = *bool_tmp;
 		break;
 	case BTC_SET_BL_BT_CTRL_AGG_SIZE:
-		btcoexist->bt_info.bt_ctrl_buf_size = *bool_tmp;
+		btcoexist->bt_info.bt_ctrl_agg_buf_size = *bool_tmp;
 		break;
 	case BTC_SET_BL_INC_SCAN_DEV_NUM:
 		btcoexist->bt_info.increase_scan_dev_num = *bool_tmp;
 		break;
+	case BTC_SET_BL_BT_TX_RX_MASK:
+		btcoexist->bt_info.bt_tx_rx_mask = *bool_tmp;
+		break;
+	case BTC_SET_BL_MIRACAST_PLUS_BT:
+		btcoexist->bt_info.miracast_plus_bt = *bool_tmp;
+		break;
 		/* set some u1Byte type variables. */
 	case BTC_SET_U1_RSSI_ADJ_VAL_FOR_AGC_TABLE_ON:
 		btcoexist->bt_info.rssi_adjust_for_agc_table_on = *u8_tmp;
@@ -437,7 +596,7 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 		/*BTHCI_SendGetBtRssiEvent(rtlpriv);*/
 		break;
 	case BTC_SET_ACT_AGGREGATE_CTRL:
-		halbtc_aggregation_check();
+		halbtc_aggregation_check(btcoexist);
 		break;
 
 		/* 1Ant */
@@ -447,10 +606,10 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 	case BTC_SET_UI_SCAN_SIG_COMPENSATION:
 	/*	rtlpriv->mlmepriv.scan_compensation = *u8_tmp;  */
 		break;
-	case BTC_SET_U1_1ANT_LPS:
+	case BTC_SET_U1_LPS_VAL:
 		btcoexist->bt_info.lps_val = *u8_tmp;
 		break;
-	case BTC_SET_U1_1ANT_RPWM:
+	case BTC_SET_U1_RPWM_VAL:
 		btcoexist->bt_info.rpwm_val = *u8_tmp;
 		break;
 	/* the following are some action which will be triggered  */
@@ -464,20 +623,19 @@ static bool halbtc_set(void *void_btcoexist, u8 set_type, void *in_buf)
 		halbtc_normal_lps(btcoexist);
 		break;
 	case BTC_SET_ACT_DISABLE_LOW_POWER:
-		halbtc_disable_low_power();
+		halbtc_disable_low_power(btcoexist, *bool_tmp);
 		break;
-	case BTC_SET_ACT_UPDATE_ra_mask:
+	case BTC_SET_ACT_UPDATE_RAMASK:
 		btcoexist->bt_info.ra_mask = *u32_tmp;
 		break;
 	case BTC_SET_ACT_SEND_MIMO_PS:
 		break;
-	case BTC_SET_ACT_INC_FORCE_EXEC_PWR_CMD_CNT:
-		btcoexist->bt_info.force_exec_pwr_cmd_cnt++;
-		break;
 	case BTC_SET_ACT_CTRL_BT_INFO: /*wait for 8812/8821*/
 		break;
 	case BTC_SET_ACT_CTRL_BT_COEX:
 		break;
+	case BTC_SET_ACT_CTRL_8723B_ANT:
+		break;
 	default:
 		break;
 	}
@@ -493,12 +651,100 @@ static void halbtc_display_bt_link_info(struct btc_coexist *btcoexist)
 {
 }
 
-static void halbtc_display_bt_fw_info(struct btc_coexist *btcoexist)
-{
-}
-
-static void halbtc_display_fw_pwr_mode_cmd(struct btc_coexist *btcoexist)
+void halbtc_display_wifi_status(struct btc_coexist *btcoexist)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8	*cli_buf = btcoexist->cli_buf;
+	s32	wifi_rssi = 0, bt_hs_rssi = 0;
+	bool	scan = false, link = false, roam = false, wifi_busy = false,
+		wifi_under_b_mode = false,
+		wifi_under_5g = false;
+	u32	wifi_bw = BTC_WIFI_BW_HT20,
+		wifi_traffic_dir = BTC_WIFI_TRAFFIC_TX,
+		wifi_freq = BTC_FREQ_2_4G;
+	u32	wifi_link_status = 0x0;
+	bool	bt_hs_on = false, under_ips = false, under_lps = false,
+		low_power = false, dc_mode = false;
+	u8	wifi_chnl = 0, wifi_hs_chnl = 0, fw_ps_state;
+	u8	ap_num = 0;
+
+	wifi_link_status = halbtc_get_wifi_link_status(btcoexist);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d/ %d/ %d",
+		   "STA/vWifi/HS/p2pGo/p2pGc",
+		   ((wifi_link_status & WIFI_STA_CONNECTED) ? 1 : 0),
+		   ((wifi_link_status & WIFI_AP_CONNECTED) ? 1 : 0),
+		   ((wifi_link_status & WIFI_HS_CONNECTED) ? 1 : 0),
+		   ((wifi_link_status & WIFI_P2P_GO_CONNECTED) ? 1 : 0),
+		   ((wifi_link_status & WIFI_P2P_GC_CONNECTED) ? 1 : 0));
+	CL_PRINTF(cli_buf);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_DOT11_CHNL, &wifi_chnl);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL, &wifi_hs_chnl);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d / %d(%d)",
+		   "Dot11 channel / HsChnl(High Speed)",
+		   wifi_chnl, wifi_hs_chnl, bt_hs_on);
+	CL_PRINTF(cli_buf);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
+	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d",
+		   "Wifi rssi/ HS rssi",
+		   wifi_rssi - 100, bt_hs_rssi - 100);
+	CL_PRINTF(cli_buf);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d ",
+		   "Wifi link/ roam/ scan",
+		   link, roam, scan);
+	CL_PRINTF(cli_buf);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
+			   &wifi_traffic_dir);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
+	wifi_freq = (wifi_under_5g ? BTC_FREQ_5G : BTC_FREQ_2_4G);
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_B_MODE,
+			   &wifi_under_b_mode);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s / %s/ %s/ AP=%d ",
+		   "Wifi freq/ bw/ traffic",
+		   gl_btc_wifi_freq_string[wifi_freq],
+		   ((wifi_under_b_mode) ? "11b" :
+		    gl_btc_wifi_bw_string[wifi_bw]),
+		   ((!wifi_busy) ? "idle" : ((BTC_WIFI_TRAFFIC_TX ==
+					      wifi_traffic_dir) ? "uplink" :
+					     "downlink")),
+		   ap_num);
+	CL_PRINTF(cli_buf);
+
+	/* power status	 */
+	dc_mode = true;	/*TODO*/
+	under_ips = rtlpriv->psc.inactive_pwrstate == ERFOFF ? 1 : 0;
+	under_lps = rtlpriv->psc.dot11_psmode == EACTIVE ? 0 : 1;
+	fw_ps_state = 0;
+	low_power = 0; /*TODO*/
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %s%s%s%s",
+		   "Power Status",
+		   (dc_mode ? "DC mode" : "AC mode"),
+		   (under_ips ? ", IPS ON" : ""),
+		   (under_lps ? ", LPS ON" : ""),
+		   (low_power ? ", 32k" : ""));
+	CL_PRINTF(cli_buf);
+
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
+		   "\r\n %-35s = %02x %02x %02x %02x %02x %02x (0x%x/0x%x)",
+		   "Power mode cmd(lps/rpwm)",
+		   btcoexist->pwr_mode_val[0], btcoexist->pwr_mode_val[1],
+		   btcoexist->pwr_mode_val[2], btcoexist->pwr_mode_val[3],
+		   btcoexist->pwr_mode_val[4], btcoexist->pwr_mode_val[5],
+		   btcoexist->bt_info.lps_val,
+		   btcoexist->bt_info.rpwm_val);
+	CL_PRINTF(cli_buf);
 }
 
 /************************************************************
@@ -574,6 +820,35 @@ static void halbtc_write_4byte(void *bt_context, u32 reg_addr, u32 data)
 	rtl_write_dword(rtlpriv, reg_addr, data);
 }
 
+void halbtc_write_local_reg_1byte(void *btc_context, u32 reg_addr, u8 data)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	if (btcoexist->chip_interface == BTC_INTF_SDIO)
+		;
+	else if (btcoexist->chip_interface == BTC_INTF_PCI)
+		rtl_write_byte(rtlpriv, reg_addr, data);
+	else if (btcoexist->chip_interface == BTC_INTF_USB)
+		rtl_write_byte(rtlpriv, reg_addr, data);
+}
+
+void halbtc_set_macreg(void *btc_context, u32 reg_addr, u32 bit_mask, u32 data)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	rtl_set_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask, data);
+}
+
+u32 halbtc_get_macreg(void *btc_context, u32 reg_addr, u32 bit_mask)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	return rtl_get_bbreg(rtlpriv->mac80211.hw, reg_addr, bit_mask);
+}
+
 static void halbtc_set_bbreg(void *bt_context, u32 reg_addr, u32 bit_mask,
 			     u32 data)
 {
@@ -619,9 +894,51 @@ static void halbtc_fill_h2c_cmd(void *bt_context, u8 element_id,
 					cmd_len, cmd_buf);
 }
 
+void halbtc_set_bt_reg(void *btc_context, u8 reg_type, u32 offset, u32 set_val)
+{
+	struct btc_coexist *btcoexist = (struct btc_coexist *)btc_context;
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	u8 cmd_buffer1[4] = {0};
+	u8 cmd_buffer2[4] = {0};
+	u8 *addr_to_set = (u8 *)&offset;
+	u8 *value_to_set = (u8 *)&set_val;
+	u8 oper_ver = 0;
+	u8 req_num = 0;
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		cmd_buffer1[0] |= (oper_ver & 0x0f);	/* Set OperVer */
+		cmd_buffer1[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
+		cmd_buffer1[1] = 0x0d;	/* OpCode: BT_LO_OP_WRITE_REG_VALUE */
+		cmd_buffer1[2] = value_to_set[0];	/* Set WriteRegValue */
+		rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
+						&cmd_buffer1[0]);
+
+		msleep(200);
+		req_num++;
+
+		cmd_buffer2[0] |= (oper_ver & 0x0f);	/* Set OperVer */
+		cmd_buffer2[0] |= ((req_num << 4) & 0xf0);	/* Set ReqNum */
+		cmd_buffer2[1] = 0x0c;	/* OpCode: BT_LO_OP_WRITE_REG_ADDR */
+		cmd_buffer2[3] = addr_to_set[0];	/* Set WriteRegAddr */
+		rtlpriv->cfg->ops->fill_h2c_cmd(rtlpriv->mac80211.hw, 0x67, 4,
+						&cmd_buffer2[0]);
+	}
+}
+
+bool halbtc_set_bt_ant_detection(void *btc_context, u8 tx_time, u8 bt_chnl)
+{
+	return true;
+}
+
+u32 halbtc_get_bt_reg(void *btc_context, u8 reg_type, u32 offset)
+{
+	return 0;
+}
+
 static void halbtc_display_dbg_msg(void *bt_context, u8 disp_type)
 {
 	struct btc_coexist *btcoexist =	(struct btc_coexist *)bt_context;
+
 	switch (disp_type) {
 	case BTC_DBG_DISP_COEX_STATISTICS:
 		halbtc_display_coex_statistics(btcoexist);
@@ -629,39 +946,49 @@ static void halbtc_display_dbg_msg(void *bt_context, u8 disp_type)
 	case BTC_DBG_DISP_BT_LINK_INFO:
 		halbtc_display_bt_link_info(btcoexist);
 		break;
-	case BTC_DBG_DISP_BT_FW_VER:
-		halbtc_display_bt_fw_info(btcoexist);
-		break;
-	case BTC_DBG_DISP_FW_PWR_MODE_CMD:
-		halbtc_display_fw_pwr_mode_cmd(btcoexist);
+	case BTC_DBG_DISP_WIFI_STATUS:
+		halbtc_display_wifi_status(btcoexist);
 		break;
 	default:
 		break;
 	}
 }
 
+bool halbtc_under_ips(struct btc_coexist *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
+	enum rf_pwrstate rtstate;
+
+	if (ppsc->inactiveps) {
+		rtstate = ppsc->rfpwr_state;
+
+		if (rtstate != ERFON &&
+		    ppsc->rfoff_reason == RF_CHANGE_BY_IPS) {
+			return true;
+		}
+	}
+
+	return false;
+}
 /*****************************************************************
  *         Extern functions called by other module
  *****************************************************************/
-bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
+bool exhalbtc_initlize_variables(void)
 {
 	struct btc_coexist *btcoexist = &gl_bt_coexist;
 
-	btcoexist->statistics.cnt_bind++;
-
 	halbtc_dbg_init();
 
-	if (btcoexist->binded)
-		return false;
-	else
-		btcoexist->binded = true;
-
+#if DEV_BUS_TYPE == RT_PCI_INTERFACE
+	btcoexist->chip_interface = BTC_INTF_PCI;
+#elif DEV_BUS_TYPE == RT_USB_INTERFACE
+	btcoexist->chip_interface = BTC_INTF_USB;
+#elif DEV_BUS_TYPE == RT_SDIO_INTERFACE
+	btcoexist->chip_interface = BTC_INTF_SDIO;
+#else
 	btcoexist->chip_interface = BTC_INTF_UNKNOWN;
-
-	if (NULL == btcoexist->adapter)
-		btcoexist->adapter = adapter;
-
-	btcoexist->stack_info.profile_notified = false;
+#endif
 
 	btcoexist->btc_read_1byte = halbtc_read_1byte;
 	btcoexist->btc_write_1byte = halbtc_write_1byte;
@@ -670,6 +997,7 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 	btcoexist->btc_write_2byte = halbtc_write_2byte;
 	btcoexist->btc_read_4byte = halbtc_read_4byte;
 	btcoexist->btc_write_4byte = halbtc_write_4byte;
+	btcoexist->btc_write_local_reg_1byte = halbtc_write_local_reg_1byte;
 
 	btcoexist->btc_set_bb_reg = halbtc_set_bbreg;
 	btcoexist->btc_get_bb_reg = halbtc_get_bbreg;
@@ -682,48 +1010,158 @@ bool exhalbtc_initlize_variables(struct rtl_priv *adapter)
 
 	btcoexist->btc_get = halbtc_get;
 	btcoexist->btc_set = halbtc_set;
+	btcoexist->btc_get_bt_reg = halbtc_get_bt_reg;
+	btcoexist->btc_set_bt_reg = halbtc_set_bt_reg;
+	btcoexist->btc_set_bt_ant_detection = halbtc_set_bt_ant_detection;
+
+	btcoexist->cli_buf = &gl_btc_dbg_buf[0];
+
+	return true;
+}
+
+bool exhalbtc_bind_bt_coex_withadapter(void *adapter)
+{
+	struct btc_coexist *btcoexist = &gl_bt_coexist;
+	struct rtl_priv *rtlpriv = adapter;
+	u8 ant_num = 2, chip_type, single_ant_path = 0;
 
-	btcoexist->bt_info.bt_ctrl_buf_size = false;
+	if (btcoexist->binded)
+		return false;
+
+	btcoexist->binded = true;
+
+	btcoexist->statistics.cnt_bind++;
+
+	btcoexist->adapter = adapter;
+
+	btcoexist->stack_info.profile_notified = false;
+
+	btcoexist->bt_info.bt_ctrl_agg_buf_size = false;
 	btcoexist->bt_info.agg_buf_size = 5;
 
 	btcoexist->bt_info.increase_scan_dev_num = false;
+	btcoexist->bt_info.miracast_plus_bt = false;
+
+	chip_type = rtl_get_hwpg_bt_type(rtlpriv);
+	exhalbtc_set_chip_type(chip_type);
+	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
+	exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
+	/* set default antenna position to main  port */
+	btcoexist->board_info.btdm_ant_pos = BTC_ANTENNA_AT_MAIN_PORT;
+
+	btcoexist->board_info.btdm_ant_det_finish = false;
+	btcoexist->board_info.btdm_ant_num_by_ant_det = 1;
+
+	single_ant_path = rtl_get_hwpg_single_ant_path(rtlpriv);
+	exhalbtc_set_single_ant_path(single_ant_path);
+
+	if (rtl_get_hwpg_package_type(rtlpriv) == 0)
+		btcoexist->board_info.tfbga_package = false;
+	else if (rtl_get_hwpg_package_type(rtlpriv) == 1)
+		btcoexist->board_info.tfbga_package = false;
+	else
+		btcoexist->board_info.tfbga_package = true;
+
+	if (btcoexist->board_info.tfbga_package)
+		RT_TRACE_BTC(COMP_BT_COEXIST, DBG_LOUD,
+			     "[BTCoex], Package Type = TFBGA\n");
+	else
+		RT_TRACE_BTC(COMP_BT_COEXIST, DBG_LOUD,
+			     "[BTCoex], Package Type = Non-TFBGA\n");
+
 	return true;
 }
 
-void exhalbtc_init_hw_config(struct btc_coexist *btcoexist)
+void exhalbtc_power_on_setting(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	btcoexist->statistics.cnt_power_on++;
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_power_on_setting(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_power_on_setting(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_power_on_setting(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_power_on_setting(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_power_on_setting(btcoexist);
+	}
+}
+
+void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	btcoexist->statistics.cnt_pre_load_firmware++;
 
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_pre_load_firmware(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_pre_load_firmware(btcoexist);
+	}
+}
+
+void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only)
+{
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
 	btcoexist->statistics.cnt_init_hw_config++;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_init_hwconfig(btcoexist);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_init_hw_config(btcoexist, wifi_only);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_init_hw_config(btcoexist, wifi_only);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_init_hw_config(btcoexist, wifi_only);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_init_hw_config(btcoexist, wifi_only);
+	} else if (IS_HARDWARE_TYPE_8723A(btcoexist->adapter)) {
+		/* 8723A has no this function */
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_init_hw_config(btcoexist, wifi_only);
+	}
 }
 
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
-
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
 	btcoexist->statistics.cnt_init_coex_dm++;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_init_coex_dm(btcoexist);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_init_coex_dm(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_init_coex_dm(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_init_coex_dm(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_init_coex_dm(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_init_coex_dm(btcoexist);
+	}
 
 	btcoexist->initilized = true;
 }
 
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 ips_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -737,18 +1175,28 @@ void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
 	else
 		ips_type = BTC_IPS_LEAVE;
 
-	halbtc_leave_low_power();
-
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_ips_notify(btcoexist, ips_type);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_ips_notify(btcoexist, ips_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_ips_notify(btcoexist, ips_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_ips_notify(btcoexist, ips_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_ips_notify(btcoexist, ips_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_ips_notify(btcoexist, ips_type);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 lps_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -762,14 +1210,24 @@ void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	else
 		lps_type = BTC_LPS_ENABLE;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_lps_notify(btcoexist, lps_type);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_lps_notify(btcoexist, lps_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_lps_notify(btcoexist, lps_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_lps_notify(btcoexist, lps_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_lps_notify(btcoexist, lps_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_lps_notify(btcoexist, lps_type);
+	}
 }
 
 void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 scan_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -783,18 +1241,28 @@ void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	else
 		scan_type = BTC_SCAN_FINISH;
 
-	halbtc_leave_low_power();
-
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_scan_notify(btcoexist, scan_type);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_scan_notify(btcoexist, scan_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_scan_notify(btcoexist, scan_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_scan_notify(btcoexist, scan_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_scan_notify(btcoexist, scan_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_scan_notify(btcoexist, scan_type);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 asso_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -808,10 +1276,24 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 	else
 		asso_type = BTC_ASSOCIATE_FINISH;
 
-	halbtc_leave_low_power();
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_connect_notify(btcoexist, asso_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_connect_notify(btcoexist, asso_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_connect_notify(btcoexist, asso_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_connect_notify(btcoexist, asso_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_connect_notify(btcoexist, asso_type);
+	}
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_connect_notify(btcoexist, asso_type);
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
@@ -830,15 +1312,33 @@ void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
 	else
 		status = BTC_MEDIA_DISCONNECT;
 
-	halbtc_leave_low_power();
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_media_status_notify(btcoexist,
+							       status);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_media_status_notify(btcoexist,
+							       status);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_media_status_notify(btcoexist,
+							       status);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_media_status_notify(btcoexist,
+							       status);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_media_status_notify(btcoexist,
+							       status);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 packet_type;
 
 	if (!halbtc_is_bt_coexist_available(btcoexist))
@@ -847,28 +1347,86 @@ void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type)
 	if (btcoexist->manual_control)
 		return;
 
-	packet_type = BTC_PACKET_DHCP;
-
-	halbtc_leave_low_power();
+	if (pkt_type == PACKET_DHCP) {
+		packet_type = BTC_PACKET_DHCP;
+	} else if (pkt_type == PACKET_EAPOL) {
+		packet_type = BTC_PACKET_EAPOL;
+	} else if (pkt_type == PACKET_ARP) {
+		packet_type = BTC_PACKET_ARP;
+	} else {
+		packet_type = BTC_PACKET_UNKNOWN;
+		return;
+	}
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_special_packet_notify(btcoexist,
-						      packet_type);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_specific_packet_notify(btcoexist,
+								  packet_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_specific_packet_notify(btcoexist,
+								  packet_type);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_specific_packet_notify(btcoexist,
+								  packet_type);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_specific_packet_notify(btcoexist,
+								  packet_type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_specific_packet_notify(btcoexist,
+								  packet_type);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist,
 			     u8 *tmp_buf, u8 length)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 	btcoexist->statistics.cnt_bt_info_notify++;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_bt_info_notify(btcoexist, tmp_buf, length);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_bt_info_notify(btcoexist, tmp_buf,
+							  length);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_bt_info_notify(btcoexist, tmp_buf,
+							  length);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_bt_info_notify(btcoexist, tmp_buf,
+							  length);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_bt_info_notify(btcoexist, tmp_buf,
+							  length);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_bt_info_notify(btcoexist, tmp_buf,
+							  length);
+	}
+
+	halbtc_normal_low_power(btcoexist);
+}
+
+void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+	btcoexist->statistics.cnt_rf_status_notify++;
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_rf_status_notify(btcoexist, type);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+	}
 }
 
 void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
@@ -881,44 +1439,121 @@ void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
 	if (btcoexist->manual_control)
 		return;
 
-	stack_op_type = BTC_STACK_OP_NONE;
-
-	halbtc_leave_low_power();
-
-	halbtc_nomal_low_power();
+	if ((type == HCI_BT_OP_INQUIRY_START) ||
+	    (type == HCI_BT_OP_PAGING_START) ||
+	    (type == HCI_BT_OP_PAIRING_START)) {
+		stack_op_type = BTC_STACK_OP_INQ_PAGE_PAIR_START;
+	} else if ((type == HCI_BT_OP_INQUIRY_FINISH) ||
+		   (type == HCI_BT_OP_PAGING_SUCCESS) ||
+		   (type == HCI_BT_OP_PAGING_UNSUCCESS) ||
+		   (type == HCI_BT_OP_PAIRING_FINISH)) {
+		stack_op_type = BTC_STACK_OP_INQ_PAGE_PAIR_FINISH;
+	} else {
+		stack_op_type = BTC_STACK_OP_NONE;
+	}
 }
 
 void exhalbtc_halt_notify(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_halt_notify(btcoexist);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_halt_notify(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_halt_notify(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_halt_notify(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_halt_notify(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_halt_notify(btcoexist);
+	}
+
+	btcoexist->binded = false;
 }
 
 void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
+
+	/* currently only 1ant we have to do the notification,  */
+	/* once pnp is notified to sleep state, we have to leave LPS that
+	 * we can sleep normally.
+	 */
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_pnp_notify(btcoexist, pnp_state);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_pnp_notify(btcoexist, pnp_state);
+	} else if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_pnp_notify(btcoexist, pnp_state);
+		else if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_pnp_notify(btcoexist, pnp_state);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+	}
 }
 
-void exhalbtc_periodical(struct btc_coexist *btcoexist)
+void exhalbtc_coex_dm_switch(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
+
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+	btcoexist->statistics.cnt_coex_dm_switch++;
+
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1) {
+			btcoexist->stop_coex_dm = true;
+			ex_halbtc8723b1ant_coex_dm_reset(btcoexist);
+			exhalbtc_set_ant_num(rtlpriv,
+					     BT_COEX_ANT_TYPE_DETECTED, 2);
+			ex_halbtc8723b2ant_init_hw_config(btcoexist, false);
+			ex_halbtc8723b2ant_init_coex_dm(btcoexist);
+			btcoexist->stop_coex_dm = false;
+		}
+	}
+
+	halbtc_normal_low_power(btcoexist);
+}
+
+void exhalbtc_periodical(struct btc_coexist *btcoexist)
+{
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
+
+	/* halbtc_send_cts_packet(btcoexist->adapter); */
+
 	btcoexist->statistics.cnt_periodical++;
 
-	halbtc_leave_low_power();
+	halbtc_leave_low_power(btcoexist);
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_periodical(btcoexist);
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_periodical(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1) {
+			if (!halbtc_under_ips(btcoexist))
+				ex_halbtc8821a1ant_periodical(btcoexist);
+		}
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_periodical(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_periodical(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_periodical(btcoexist);
+	}
 
-	halbtc_nomal_low_power();
+	halbtc_normal_low_power(btcoexist);
 }
 
 void exhalbtc_dbg_control(struct btc_coexist *btcoexist,
@@ -927,6 +1562,31 @@ void exhalbtc_dbg_control(struct btc_coexist *btcoexist,
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 	btcoexist->statistics.cnt_dbg_ctrl++;
+
+	halbtc_leave_low_power(btcoexist);
+
+	halbtc_normal_low_power(btcoexist);
+}
+
+void exhalbtc_antenna_detection(struct btc_coexist *btcoexist, u32 cent_freq,
+				u32 offset, u32 span, u32 seconds)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	/*TODO*/
+	/* IPSDisable(btcoexist->adapter, false, 0);
+	 * LeisurePSLeave(btcoexist->adapter, LPS_DISABLE_BT_COEX);
+	 */
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_antenna_detection(btcoexist,
+							     cent_freq, offset,
+							     span, seconds);
+	}
+
+	/* IPSReturn(btcoexist->adapter, 0xff); */
 }
 
 void exhalbtc_stack_update_profile_info(void)
@@ -962,11 +1622,8 @@ void exhalbtc_set_bt_patch_version(u16 bt_hci_version, u16 bt_patch_version)
 
 	btcoexist->bt_info.bt_real_fw_ver = bt_patch_version;
 	btcoexist->bt_info.bt_hci_ver = bt_hci_version;
-}
 
-void exhalbtc_set_bt_exist(bool bt_exist)
-{
-	gl_bt_coexist.board_info.bt_exist = bt_exist;
+	btcoexist->bt_info.get_bt_fw_ver_cnt++;
 }
 
 void exhalbtc_set_chip_type(u8 chip_type)
@@ -1002,25 +1659,8 @@ void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num)
 	if (BT_COEX_ANT_TYPE_PG == type) {
 		gl_bt_coexist.board_info.pg_ant_num = ant_num;
 		gl_bt_coexist.board_info.btdm_ant_num = ant_num;
-		/* The antenna position:
-		 * Main (default) or Aux for pgAntNum=2 && btdmAntNum =1.
-		 * The antenna position should be determined by
-		 * auto-detect mechanism.
-		 * The following is assumed to main,
-		 * and those must be modified
-		 * if y auto-detect mechanism is ready
-		 */
-		if ((gl_bt_coexist.board_info.pg_ant_num == 2) &&
-		    (gl_bt_coexist.board_info.btdm_ant_num == 1))
-			gl_bt_coexist.board_info.btdm_ant_pos =
-						       BTC_ANTENNA_AT_MAIN_PORT;
-		else
-			gl_bt_coexist.board_info.btdm_ant_pos =
-						       BTC_ANTENNA_AT_MAIN_PORT;
 	} else if (BT_COEX_ANT_TYPE_ANTDIV == type) {
 		gl_bt_coexist.board_info.btdm_ant_num = ant_num;
-		gl_bt_coexist.board_info.btdm_ant_pos =
-						       BTC_ANTENNA_AT_MAIN_PORT;
 	} else if (type == BT_COEX_ANT_TYPE_DETECTED) {
 		gl_bt_coexist.board_info.btdm_ant_num = ant_num;
 		if (rtlpriv->cfg->mod_params->ant_sel == 1)
@@ -1032,13 +1672,48 @@ void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num)
 	}
 }
 
+/* Currently used by 8723b only, S0 or S1 */
+void exhalbtc_set_single_ant_path(u8 single_ant_path)
+{
+	gl_bt_coexist.board_info.single_ant_path = single_ant_path;
+}
+
 void exhalbtc_display_bt_coex_info(struct btc_coexist *btcoexist)
 {
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	if (!halbtc_is_bt_coexist_available(btcoexist))
 		return;
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_btc8723b2ant_display_coex_info(btcoexist);
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8821(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8821a2ant_display_coex_info(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8821a1ant_display_coex_info(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8723b2ant_display_coex_info(btcoexist);
+		else if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_display_coex_info(btcoexist);
+	} else if (IS_HARDWARE_TYPE_8192E(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 2)
+			ex_halbtc8192e2ant_display_coex_info(btcoexist);
+	}
+
+	halbtc_normal_low_power(btcoexist);
+}
+
+void exhalbtc_display_ant_detection(struct btc_coexist *btcoexist)
+{
+	if (!halbtc_is_bt_coexist_available(btcoexist))
+		return;
+
+	halbtc_leave_low_power(btcoexist);
+
+	if (IS_HARDWARE_TYPE_8723B(btcoexist->adapter)) {
+		if (btcoexist->board_info.btdm_ant_num == 1)
+			ex_halbtc8723b1ant_display_ant_detection(btcoexist);
+	}
+
+	halbtc_normal_low_power(btcoexist);
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 103abd8..c895795 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -30,12 +30,12 @@
 #ifdef CONFIG_RTLWIFI_DEBUG
 
 #define BTC_SPRINTF(ptr, ...)	snprintf(ptr, ##__VA_ARGS__)
-#define BTC_TRACE(fmt)						\
-do {								\
-	struct rtl_priv *rtlpriv = gl_bt_coexist.adapter;	\
-	if (!rtlpriv)					\
-		break;						\
-	RT_TRACE_STRING(rtlpriv, COMP_COEX, DBG_LOUD, fmt);	\
+#define BTC_TRACE(fmt)							\
+do {									\
+	struct rtl_priv *rtlpriv = gl_bt_coexist.adapter;		\
+	if (!rtlpriv)						\
+		break;							\
+	RT_TRACE_STRING(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, fmt);	\
 } while (0)
 
 #else
@@ -53,6 +53,9 @@ static inline void BTC_TRACE(const char *ptr)
 #define		NORMAL_EXEC				false
 #define		FORCE_EXEC				true
 
+#define		BTC_RF_OFF					0x0
+#define		BTC_RF_ON					0x1
+
 #define		BTC_RF_A				RF90_PATH_A
 #define		BTC_RF_B				RF90_PATH_B
 #define		BTC_RF_C				RF90_PATH_C
@@ -89,6 +92,22 @@ static inline void BTC_TRACE(const char *ptr)
 #define		BTC_ANT_WIFI_AT_CPL_MAIN		0
 #define		BTC_ANT_WIFI_AT_CPL_AUX			1
 
+enum btc_powersave_type {
+	BTC_PS_WIFI_NATIVE	= 0,	/* wifi original power save behavior */
+	BTC_PS_LPS_ON		= 1,
+	BTC_PS_LPS_OFF		= 2,
+	BTC_PS_MAX
+};
+
+enum btc_bt_reg_type {
+	BTC_BT_REG_RF		= 0,
+	BTC_BT_REG_MODEM	= 1,
+	BTC_BT_REG_BLUEWIZE	= 2,
+	BTC_BT_REG_VENDOR	= 3,
+	BTC_BT_REG_LE		= 4,
+	BTC_BT_REG_MAX
+};
+
 enum btc_chip_interface {
 	BTC_INTF_UNKNOWN	= 0,
 	BTC_INTF_PCI		= 1,
@@ -108,30 +127,6 @@ enum btc_chip_type {
 	BTC_CHIP_MAX
 };
 
-enum btc_msg_type {
-	BTC_MSG_INTERFACE	= 0x0,
-	BTC_MSG_ALGORITHM	= 0x1,
-	BTC_MSG_MAX
-};
-
-extern u32 btc_dbg_type[];
-
-/* following is for BTC_MSG_INTERFACE */
-#define		INTF_INIT				BIT0
-#define		INTF_NOTIFY				BIT2
-
-/* following is for BTC_ALGORITHM */
-#define		ALGO_BT_RSSI_STATE			BIT0
-#define		ALGO_WIFI_RSSI_STATE			BIT1
-#define		ALGO_BT_MONITOR				BIT2
-#define		ALGO_TRACE				BIT3
-#define		ALGO_TRACE_FW				BIT4
-#define		ALGO_TRACE_FW_DETAIL			BIT5
-#define		ALGO_TRACE_FW_EXEC			BIT6
-#define		ALGO_TRACE_SW				BIT7
-#define		ALGO_TRACE_SW_DETAIL			BIT8
-#define		ALGO_TRACE_SW_EXEC			BIT9
-
 /* following is for wifi link status */
 #define		WIFI_STA_CONNECTED			BIT0
 #define		WIFI_AP_CONNECTED			BIT1
@@ -139,17 +134,25 @@ extern u32 btc_dbg_type[];
 #define		WIFI_P2P_GO_CONNECTED			BIT3
 #define		WIFI_P2P_GC_CONNECTED			BIT4
 
-#define	btc_alg_dbg(dbgflag, fmt, ...)					\
-do {									\
-	if (unlikely(btc_dbg_type[BTC_MSG_ALGORITHM] & dbgflag))	\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
-} while (0)
-#define	btc_iface_dbg(dbgflag, fmt, ...)				\
-do {									\
-	if (unlikely(btc_dbg_type[BTC_MSG_INTERFACE] & dbgflag))	\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);			\
-} while (0)
+/* following is for command line utility */
+#define CL_PRINTF(ptr)			halbtc_dbg_info_print(btcoexist, ptr)
+#define	CL_SPRINTF(ptr, ...)	snprintf(ptr, ##__VA_ARGS__)
 
+#define		BT_TMP_BUF_SIZE				100
+
+#define RT_TRACE_BTC(comp, level, fmt, ...)				\
+	do {								\
+		struct rtl_priv *rtlpriv = gl_bt_coexist.adapter;	\
+		if (!rtlpriv)						\
+			break;						\
+		RT_TRACE(rtlpriv, comp, level, fmt, ##__VA_ARGS__);	\
+	} while (0)
+
+struct btcoex_dbg_info {
+	u8 *info;
+	u32 size; /* buffer total size */
+	u32 len; /* now used length */
+};
 
 #define	BTC_RSSI_HIGH(_rssi_)	\
 	((_rssi_ == BTC_RSSI_STATE_HIGH ||	\
@@ -161,26 +164,31 @@ do {									\
 	((_rssi_ == BTC_RSSI_STATE_LOW ||	\
 	  _rssi_ == BTC_RSSI_STATE_STAY_LOW) ? true : false)
 
-enum btc_power_save_type {
-	BTC_PS_WIFI_NATIVE = 0,
-	BTC_PS_LPS_ON = 1,
-	BTC_PS_LPS_OFF = 2,
-	BTC_PS_LPS_MAX
-};
 
 struct btc_board_info {
 	/* The following is some board information */
 	u8 bt_chip_type;
 	u8 pg_ant_num;	/* pg ant number */
 	u8 btdm_ant_num;	/* ant number for btdm */
-	u8 btdm_ant_pos;
-	bool bt_exist;
+	u8 btdm_ant_num_by_ant_det;	/* ant number for btdm after antenna
+					 * detection
+					 */
+	u8 btdm_ant_pos;	/* Bryant Add to indicate Antenna Position for
+				 * (pg_ant_num = 2) && (btdm_ant_num =1)
+				 * (DPDT+1Ant case)
+				 */
+	u8 single_ant_path;	/* current used for 8723b only, 1=>s0,  0=>s1 */
+	bool tfbga_package;	/* for Antenna detect threshold  */
+	bool btdm_ant_det_finish;
 };
 
 enum btc_dbg_opcode {
-	BTC_DBG_SET_COEX_NORMAL = 0x0,
-	BTC_DBG_SET_COEX_WIFI_ONLY = 0x1,
-	BTC_DBG_SET_COEX_BT_ONLY = 0x2,
+	BTC_DBG_SET_COEX_NORMAL			= 0x0,
+	BTC_DBG_SET_COEX_WIFI_ONLY		= 0x1,
+	BTC_DBG_SET_COEX_BT_ONLY		= 0x2,
+	BTC_DBG_SET_COEX_DEC_BT_PWR		= 0x3,
+	BTC_DBG_SET_COEX_BT_AFH_MAP		= 0x4,
+	BTC_DBG_SET_COEX_BT_IGNORE_WLAN_ACT	= 0x5,
 	BTC_DBG_MAX
 };
 
@@ -193,7 +201,6 @@ enum btc_rssi_state {
 	BTC_RSSI_STATE_STAY_LOW = 0x5,
 	BTC_RSSI_MAX
 };
-
 enum btc_wifi_role {
 	BTC_ROLE_STATION = 0x0,
 	BTC_ROLE_AP = 0x1,
@@ -202,25 +209,72 @@ enum btc_wifi_role {
 	BTC_ROLE_MAX
 };
 
+enum btc_wireless_freq {
+	BTC_FREQ_2_4G	= 0x0,
+	BTC_FREQ_5G	= 0x1,
+	BTC_FREQ_MAX
+};
+
 enum btc_wifi_bw_mode {
-	BTC_WIFI_BW_LEGACY = 0x0,
-	BTC_WIFI_BW_HT20 = 0x1,
-	BTC_WIFI_BW_HT40 = 0x2,
+	BTC_WIFI_BW_LEGACY	= 0x0,
+	BTC_WIFI_BW_HT20	= 0x1,
+	BTC_WIFI_BW_HT40	= 0x2,
+	BTC_WIFI_BW_HT80	= 0x3,
+	BTC_WIFI_BW_HT160	= 0x4,
 	BTC_WIFI_BW_MAX
 };
 
 enum btc_wifi_traffic_dir {
-	BTC_WIFI_TRAFFIC_TX = 0x0,
-	BTC_WIFI_TRAFFIC_RX = 0x1,
+	BTC_WIFI_TRAFFIC_TX	= 0x0,
+	BTC_WIFI_TRAFFIC_RX	= 0x1,
 	BTC_WIFI_TRAFFIC_MAX
 };
 
 enum btc_wifi_pnp {
-	BTC_WIFI_PNP_WAKE_UP = 0x0,
-	BTC_WIFI_PNP_SLEEP = 0x1,
+	BTC_WIFI_PNP_WAKE_UP	= 0x0,
+	BTC_WIFI_PNP_SLEEP	= 0x1,
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
+/* for 8723b-d cut large current issue */
+enum bt_wifi_coex_state {
+	BTC_WIFI_STAT_INIT,
+	BTC_WIFI_STAT_IQK,
+	BTC_WIFI_STAT_NORMAL_OFF,
+	BTC_WIFI_STAT_MP_OFF,
+	BTC_WIFI_STAT_NORMAL,
+	BTC_WIFI_STAT_ANT_DIV,
+	BTC_WIFI_STAT_MAX
+};
+
+enum bt_ant_type {
+	BTC_ANT_TYPE_0,
+	BTC_ANT_TYPE_1,
+	BTC_ANT_TYPE_2,
+	BTC_ANT_TYPE_3,
+	BTC_ANT_TYPE_4,
+	BTC_ANT_TYPE_MAX
+};
+
+/* defined for bfp_btc_get */
 enum btc_get_type {
 	/* type bool */
 	BTC_GET_BL_HS_OPERATION,
@@ -229,10 +283,6 @@ enum btc_get_type {
 	BTC_GET_BL_WIFI_BUSY,
 	BTC_GET_BL_WIFI_SCAN,
 	BTC_GET_BL_WIFI_LINK,
-	BTC_GET_BL_WIFI_DHCP,
-	BTC_GET_BL_WIFI_SOFTAP_IDLE,
-	BTC_GET_BL_WIFI_SOFTAP_LINKING,
-	BTC_GET_BL_WIFI_IN_EARLY_SUSPEND,
 	BTC_GET_BL_WIFI_ROAM,
 	BTC_GET_BL_WIFI_4_WAY_PROGRESS,
 	BTC_GET_BL_WIFI_UNDER_5G,
@@ -240,8 +290,10 @@ enum btc_get_type {
 	BTC_GET_BL_WIFI_ENABLE_ENCRYPTION,
 	BTC_GET_BL_WIFI_UNDER_B_MODE,
 	BTC_GET_BL_EXT_SWITCH,
+	BTC_GET_BL_WIFI_IS_IN_MP_MODE,
+	BTC_GET_BL_IS_ASUS_8723B,
 
-	/* type s4Byte */
+	/* type s32 */
 	BTC_GET_S4_WIFI_RSSI,
 	BTC_GET_S4_HS_RSSI,
 
@@ -253,16 +305,16 @@ enum btc_get_type {
 	BTC_GET_U4_BT_PATCH_VER,
 	BTC_GET_U4_VENDOR,
 
-	/* type u1Byte */
+	/* type u8 */
 	BTC_GET_U1_WIFI_DOT11_CHNL,
 	BTC_GET_U1_WIFI_CENTRAL_CHNL,
 	BTC_GET_U1_WIFI_HS_CHNL,
-	BTC_GET_U1_MAC_PHY_MODE,
 	BTC_GET_U1_AP_NUM,
+	BTC_GET_U1_ANT_TYPE,
+	BTC_GET_U1_IOT_PEER,
 
 	/* for 1Ant */
 	BTC_GET_U1_LPS_MODE,
-	BTC_GET_BL_BT_SCO_BUSY,
 
 	/* for test mode */
 	BTC_GET_DRIVER_TEST_CFG,
@@ -275,6 +327,7 @@ enum btc_vendor {
 	BTC_VENDOR_OTHER
 };
 
+/* defined for bfp_btc_set */
 enum btc_set_type {
 	/* type bool */
 	BTC_SET_BL_BT_DISABLE,
@@ -284,8 +337,10 @@ enum btc_set_type {
 	BTC_SET_BL_TO_REJ_AP_AGG_PKT,
 	BTC_SET_BL_BT_CTRL_AGG_SIZE,
 	BTC_SET_BL_INC_SCAN_DEV_NUM,
+	BTC_SET_BL_BT_TX_RX_MASK,
+	BTC_SET_BL_MIRACAST_PLUS_BT,
 
-	/* type u1Byte */
+	/* type u8 */
 	BTC_SET_U1_RSSI_ADJ_VAL_FOR_AGC_TABLE_ON,
 	BTC_SET_UI_SCAN_SIG_COMPENSATION,
 	BTC_SET_U1_AGG_BUF_SIZE,
@@ -295,35 +350,32 @@ enum btc_set_type {
 	BTC_SET_ACT_AGGREGATE_CTRL,
 	BTC_SET_ACT_ANTPOSREGRISTRY_CTRL,
 
-	/********* for 1Ant **********/
+	/* ===== for 1Ant ====== */
 	/* type bool */
-	BTC_SET_BL_BT_SCO_BUSY,
-	/* type u1Byte */
+
+	/* type u8 */
 	BTC_SET_U1_RSSI_ADJ_VAL_FOR_1ANT_COEX_TYPE,
 	BTC_SET_U1_LPS_VAL,
 	BTC_SET_U1_RPWM_VAL,
-	BTC_SET_U1_1ANT_LPS,
-	BTC_SET_U1_1ANT_RPWM,
 	/* type trigger some action */
 	BTC_SET_ACT_LEAVE_LPS,
 	BTC_SET_ACT_ENTER_LPS,
 	BTC_SET_ACT_NORMAL_LPS,
-	BTC_SET_ACT_INC_FORCE_EXEC_PWR_CMD_CNT,
 	BTC_SET_ACT_DISABLE_LOW_POWER,
-	BTC_SET_ACT_UPDATE_ra_mask,
+	BTC_SET_ACT_UPDATE_RAMASK,
 	BTC_SET_ACT_SEND_MIMO_PS,
 	/* BT Coex related */
 	BTC_SET_ACT_CTRL_BT_INFO,
 	BTC_SET_ACT_CTRL_BT_COEX,
-	/***************************/
+	BTC_SET_ACT_CTRL_8723B_ANT,
+	/* ================= */
 	BTC_SET_MAX
 };
 
 enum btc_dbg_disp_type {
-	BTC_DBG_DISP_COEX_STATISTICS = 0x0,
-	BTC_DBG_DISP_BT_LINK_INFO = 0x1,
-	BTC_DBG_DISP_BT_FW_VER = 0x2,
-	BTC_DBG_DISP_FW_PWR_MODE_CMD = 0x3,
+	BTC_DBG_DISP_COEX_STATISTICS	= 0x0,
+	BTC_DBG_DISP_BT_LINK_INFO	= 0x1,
+	BTC_DBG_DISP_WIFI_STATUS	= 0x2,
 	BTC_DBG_DISP_MAX
 };
 
@@ -365,6 +417,14 @@ enum btc_notify_type_special_packet {
 	BTC_PACKET_MAX
 };
 
+enum btc_notify_type_stack_operation {
+	BTC_STACK_OP_NONE			= 0x0,
+	BTC_STACK_OP_INQ_PAGE_PAIR_START	= 0x1,
+	BTC_STACK_OP_INQ_PAGE_PAIR_FINISH	= 0x2,
+	BTC_STACK_OP_MAX
+};
+
+/* map to btc_notify_type_stack_operation */
 enum hci_ext_bt_operation {
 	HCI_BT_OP_NONE = 0x0,
 	HCI_BT_OP_INQUIRY_START = 0x1,
@@ -379,13 +439,6 @@ enum hci_ext_bt_operation {
 	HCI_BT_OP_MAX
 };
 
-enum btc_notify_type_stack_operation {
-	BTC_STACK_OP_NONE = 0x0,
-	BTC_STACK_OP_INQ_PAGE_PAIR_START = 0x1,
-	BTC_STACK_OP_INQ_PAGE_PAIR_FINISH = 0x2,
-	BTC_STACK_OP_MAX
-};
-
 typedef u8 (*bfp_btc_r1)(void *btc_context, u32 reg_addr);
 
 typedef u16 (*bfp_btc_r2)(void *btc_context, u32 reg_addr);
@@ -401,8 +454,7 @@ typedef void (*bfp_btc_w2)(void *btc_context, u32 reg_addr, u16 data);
 
 typedef void (*bfp_btc_w4)(void *btc_context, u32 reg_addr, u32 data);
 
-typedef void (*bfp_btc_wr_1byte_bit_mask)(void *btc_context, u32 reg_addr,
-					  u8 bit_mask, u8 data);
+typedef void (*bfp_btc_local_reg_w1)(void *btc_context, u32 reg_addr, u8 data);
 
 typedef void (*bfp_btc_set_bb_reg)(void *btc_context, u32 reg_addr,
 				   u32 bit_mask, u32 data);
@@ -423,33 +475,44 @@ typedef	bool (*bfp_btc_get)(void *btcoexist, u8 get_type, void *out_buf);
 
 typedef	bool (*bfp_btc_set)(void *btcoexist, u8 set_type, void *in_buf);
 
+typedef void (*bfp_btc_set_bt_reg)(void *btc_context, u8 reg_type, u32 offset,
+				   u32 value);
+
+typedef bool (*bfp_btc_set_bt_ant_detection)(void *btc_context, u8 tx_time,
+					     u8 bt_chnl);
+
+typedef u32 (*bfp_btc_get_bt_reg)(void *btc_context, u8 reg_type, u32 offset);
+
 typedef void (*bfp_btc_disp_dbg_msg)(void *btcoexist, u8 disp_type);
 
 struct btc_bt_info {
-	bool bt_disabled;
-	u8 rssi_adjust_for_agc_table_on;
-	u8 rssi_adjust_for_1ant_coex_type;
-	bool bt_busy;
-	u8 agg_buf_size;
-	bool limited_dig;
-	bool reject_agg_pkt;
-	bool bt_ctrl_buf_size;
-	bool increase_scan_dev_num;
-	u16 bt_hci_ver;
-	u16 bt_real_fw_ver;
-	u8 bt_fw_ver;
-
-	bool bt_disable_low_pwr;
-
-	/* the following is for 1Ant solution */
-	bool bt_ctrl_lps;
-	bool bt_pwr_save_mode;
-	bool bt_lps_on;
-	bool force_to_roam;
-	u8 force_exec_pwr_cmd_cnt;
-	u8 lps_val;
-	u8 rpwm_val;
-	u32 ra_mask;
+	bool	bt_disabled;
+	u8	rssi_adjust_for_agc_table_on;
+	u8	rssi_adjust_for_1ant_coex_type;
+	bool	pre_bt_ctrl_agg_buf_size;
+	bool	bt_ctrl_agg_buf_size;
+	bool	pre_reject_agg_pkt;
+	bool	reject_agg_pkt;
+	bool	increase_scan_dev_num;
+	bool	bt_tx_rx_mask;
+	u8	pre_agg_buf_size;
+	u8	agg_buf_size;
+	bool	bt_busy;
+	bool	limited_dig;
+	u16	bt_hci_ver;
+	u16	bt_real_fw_ver;
+	u8	bt_fw_ver;
+	u32	get_bt_fw_ver_cnt;
+	bool	miracast_plus_bt;
+
+	bool	bt_disable_low_pwr;
+
+	bool	bt_ctrl_lps;
+	bool	bt_lps_on;
+	bool	force_to_roam;	/* for 1Ant solution */
+	u8	lps_val;
+	u8	rpwm_val;
+	u32	ra_mask;
 };
 
 struct btc_stack_info {
@@ -468,32 +531,38 @@ struct btc_stack_info {
 };
 
 struct btc_statistics {
-	u32 cnt_bind;
-	u32 cnt_init_hw_config;
-	u32 cnt_init_coex_dm;
-	u32 cnt_ips_notify;
-	u32 cnt_lps_notify;
-	u32 cnt_scan_notify;
-	u32 cnt_connect_notify;
-	u32 cnt_media_status_notify;
-	u32 cnt_special_packet_notify;
-	u32 cnt_bt_info_notify;
-	u32 cnt_periodical;
-	u32 cnt_coex_dm_switch;
-	u32 cnt_stack_operation_notify;
-	u32 cnt_dbg_ctrl;
+	u32	cnt_bind;
+	u32	cnt_power_on;
+	u32	cnt_pre_load_firmware;
+	u32	cnt_init_hw_config;
+	u32	cnt_init_coex_dm;
+	u32	cnt_ips_notify;
+	u32	cnt_lps_notify;
+	u32	cnt_scan_notify;
+	u32	cnt_connect_notify;
+	u32	cnt_media_status_notify;
+	u32	cnt_special_packet_notify;
+	u32	cnt_bt_info_notify;
+	u32	cnt_rf_status_notify;
+	u32	cnt_periodical;
+	u32	cnt_coex_dm_switch;
+	u32	cnt_stack_operation_notify;
+	u32	cnt_dbg_ctrl;
 };
 
 struct btc_bt_link_info {
-	bool bt_link_exist;
-	bool sco_exist;
-	bool sco_only;
-	bool a2dp_exist;
-	bool a2dp_only;
-	bool hid_exist;
-	bool hid_only;
-	bool pan_exist;
-	bool pan_only;
+	bool	bt_link_exist;
+	bool	bt_hi_pri_link_exist;
+	bool	sco_exist;
+	bool	sco_only;
+	bool	a2dp_exist;
+	bool	a2dp_only;
+	bool	hid_exist;
+	bool	hid_only;
+	bool	pan_exist;
+	bool	pan_only;
+	bool	slave_role;
+	bool	acl_busy;
 };
 
 enum btc_antenna_pos {
@@ -516,6 +585,8 @@ struct btc_coexist {
 	bool initilized;
 	bool stop_coex_dm;
 	bool manual_control;
+	u8 *cli_buf;
+	struct  btcoex_dbg_info dbg_info;
 	struct btc_statistics statistics;
 	u8 pwr_mode_val[10];
 
@@ -527,6 +598,7 @@ struct btc_coexist {
 	bfp_btc_w2 btc_write_2byte;
 	bfp_btc_r4 btc_read_4byte;
 	bfp_btc_w4 btc_write_4byte;
+	bfp_btc_local_reg_w1 btc_write_local_reg_1byte;
 
 	bfp_btc_set_bb_reg btc_set_bb_reg;
 	bfp_btc_get_bb_reg btc_get_bb_reg;
@@ -540,14 +612,22 @@ struct btc_coexist {
 
 	bfp_btc_get btc_get;
 	bfp_btc_set btc_set;
+
+	bfp_btc_get_bt_reg btc_get_bt_reg;
+	bfp_btc_set_bt_reg btc_set_bt_reg;
+
+	bfp_btc_set_bt_ant_detection btc_set_bt_ant_detection;
 };
 
 bool halbtc_is_wifi_uplink(struct rtl_priv *adapter);
 
 extern struct btc_coexist gl_bt_coexist;
 
-bool exhalbtc_initlize_variables(struct rtl_priv *adapter);
-void exhalbtc_init_hw_config(struct btc_coexist *btcoexist);
+bool exhalbtc_initlize_variables(void);
+bool exhalbtc_bind_bt_coex_withadapter(void *adapter);
+void exhalbtc_power_on_setting(struct btc_coexist *btcoexist);
+void exhalbtc_pre_load_firmware(struct btc_coexist *btcoexist);
+void exhalbtc_init_hw_config(struct btc_coexist *btcoexist, bool wifi_only);
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist);
 void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type);
@@ -558,6 +638,7 @@ void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
 void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type);
 void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist, u8 *tmp_buf,
 			     u8 length);
+void exhalbtc_rf_status_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type);
 void exhalbtc_halt_notify(struct btc_coexist *btcoexist);
 void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state);
@@ -565,6 +646,8 @@ void exhalbtc_coex_dm_switch(struct btc_coexist *btcoexist);
 void exhalbtc_periodical(struct btc_coexist *btcoexist);
 void exhalbtc_dbg_control(struct btc_coexist *btcoexist, u8 code, u8 len,
 			  u8 *data);
+void exhalbtc_antenna_detection(struct btc_coexist *btcoexist, u32 cent_freq,
+				u32 offset, u32 span, u32 seconds);
 void exhalbtc_stack_update_profile_info(void);
 void exhalbtc_set_hci_version(u16 hci_version);
 void exhalbtc_set_bt_patch_version(u16 bt_hci_version, u16 bt_patch_version);
@@ -572,10 +655,15 @@ void exhalbtc_update_min_bt_rssi(s8 bt_rssi);
 void exhalbtc_set_bt_exist(bool bt_exist);
 void exhalbtc_set_chip_type(u8 chip_type);
 void exhalbtc_set_ant_num(struct rtl_priv *rtlpriv, u8 type, u8 ant_num);
+void exhalbtc_set_single_ant_path(u8 single_ant_path);
 void exhalbtc_display_bt_coex_info(struct btc_coexist *btcoexist);
+void exhalbtc_display_ant_detection(struct btc_coexist *btcoexist);
 void exhalbtc_signal_compensation(struct btc_coexist *btcoexist,
 				  u8 *rssi_wifi, u8 *rssi_bt);
 void exhalbtc_lps_leave(struct btc_coexist *btcoexist);
 void exhalbtc_low_wifi_traffic_notify(struct btc_coexist *btcoexist);
+bool halbtc_is_wifi_uplink(struct rtl_priv *adapter);
+void halbtc_dbg_info_init(struct btc_coexist *btcoexist, u8 *buf, u32 size);
+void halbtc_dbg_info_print(struct btc_coexist *btcoexist, u8 *dbgmsg);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index 46e0fa6..b1f0f2b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -32,6 +32,7 @@
 static struct rtl_btc_ops rtl_btc_operation = {
 	.btc_init_variables = rtl_btc_init_variables,
 	.btc_init_hal_vars = rtl_btc_init_hal_vars,
+	.btc_power_on_setting = rtl_btc_power_on_setting,
 	.btc_init_hw_config = rtl_btc_init_hw_config,
 	.btc_ips_notify = rtl_btc_ips_notify,
 	.btc_lps_notify = rtl_btc_lps_notify,
@@ -49,38 +50,32 @@ static struct rtl_btc_ops rtl_btc_operation = {
 
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv)
 {
-	exhalbtc_initlize_variables(rtlpriv);
+	exhalbtc_initlize_variables();
+	exhalbtc_bind_bt_coex_withadapter(rtlpriv);
+}
+
+void rtl_btc_power_on_setting(struct rtl_priv *rtlpriv)
+{
+	exhalbtc_power_on_setting(&gl_bt_coexist);
 }
 
 void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv)
 {
-	u8 ant_num;
-	u8 bt_exist;
-	u8 bt_type;
+	/* move ant_num, bt_type and single_ant_path to
+	 * exhalbtc_bind_bt_coex_withadapter()
+	 */
+}
 
-	ant_num = rtl_get_hwpg_ant_num(rtlpriv);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "%s, antNum is %d\n", __func__, ant_num);
+void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
+{
+	u8 bt_exist;
 
 	bt_exist = rtl_get_hwpg_bt_exist(rtlpriv);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		 "%s, bt_exist is %d\n", __func__, bt_exist);
-	exhalbtc_set_bt_exist(bt_exist);
-
-	bt_type = rtl_get_hwpg_bt_type(rtlpriv);
-	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "%s, bt_type is %d\n",
-		 __func__, bt_type);
-	exhalbtc_set_chip_type(bt_type);
-
-	if (rtlpriv->cfg->mod_params->ant_sel == 1)
-		exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_DETECTED, 1);
-	else
-		exhalbtc_set_ant_num(rtlpriv, BT_COEX_ANT_TYPE_PG, ant_num);
-}
+		"%s, bt_exist is %d\n", __func__, bt_exist);
+	/*exhalbtc_set_bt_exist(bt_exist);*/
 
-void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv)
-{
-	exhalbtc_init_hw_config(&gl_bt_coexist);
+	exhalbtc_init_hw_config(&gl_bt_coexist, !bt_exist);
 	exhalbtc_init_coex_dm(&gl_bt_coexist);
 }
 
@@ -118,7 +113,9 @@ void rtl_btc_periodical(struct rtl_priv *rtlpriv)
 
 void rtl_btc_halt_notify(void)
 {
-	exhalbtc_halt_notify(&gl_bt_coexist);
+	struct btc_coexist *btcoexist = &gl_bt_coexist;
+
+	exhalbtc_halt_notify(btcoexist);
 }
 
 void rtl_btc_btinfo_notify(struct rtl_priv *rtlpriv, u8 *tmp_buf, u8 length)
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
index fff5117..08e50f8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.h
@@ -30,6 +30,7 @@
 void rtl_btc_init_variables(struct rtl_priv *rtlpriv);
 void rtl_btc_init_hal_vars(struct rtl_priv *rtlpriv);
 void rtl_btc_init_hw_config(struct rtl_priv *rtlpriv);
+void rtl_btc_power_on_setting(struct rtl_priv *rtlpriv);
 void rtl_btc_ips_notify(struct rtl_priv *rtlpriv, u8 type);
 void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type);
 void rtl_btc_scan_notify(struct rtl_priv *rtlpriv, u8 scantype);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 00473a6..afff473 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -848,6 +848,8 @@ static bool _rtl8723be_init_mac(struct ieee80211_hw *hw)
 		return false;
 	}
 
+	rtlpriv->btcoexist.btc_ops->btc_power_on_setting(rtlpriv);
+
 	bytetmp = rtl_read_byte(rtlpriv, REG_MULTI_FUNC_CTRL);
 	rtl_write_byte(rtlpriv, REG_MULTI_FUNC_CTRL, bytetmp | BIT(3));
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 57a4676..13070bc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2547,6 +2547,7 @@ struct bt_coexist_info {
 struct rtl_btc_ops {
 	void (*btc_init_variables) (struct rtl_priv *rtlpriv);
 	void (*btc_init_hal_vars) (struct rtl_priv *rtlpriv);
+	void (*btc_power_on_setting)(struct rtl_priv *rtlpriv);
 	void (*btc_init_hw_config) (struct rtl_priv *rtlpriv);
 	void (*btc_ips_notify) (struct rtl_priv *rtlpriv, u8 type);
 	void (*btc_lps_notify)(struct rtl_priv *rtlpriv, u8 type);
-- 
2.10.2
