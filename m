Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34678 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdECXvG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 19:51:06 -0400
Received: by mail-io0-f193.google.com with SMTP id h41so39139130ioi.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 16:51:05 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 1/4] rtlwifi: btcoex: Remove 21a 1ant configuration parameter
Date: Wed,  3 May 2017 18:50:54 -0500
Message-Id: <20170503235057.23211-2-Larry.Finger@lwfinger.net> (sfid-20170504_015116_893831_6D94363C)
In-Reply-To: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
References: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In file halbtc8821a1ant.c, there are directives that depend on an
undocumented configuration parameter BT_AUTO_REPORT_ONLY_8821A_1ANT
that cannot be set from Kconfig. This parameter is replaced by a
boolean in the main structure used by all routines. It still cannot
be changed dynamically, but it is easier to document.

Routine halbtc8821a1ant_is_wifi_status_changed is restored.

Using a suggestion from Realtek, the auto report is turned on with this
patch.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c        | 18 +++++++++---------
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h        |  2 +-
 .../wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h  |  5 +++++
 3 files changed, 15 insertions(+), 10 deletions(-)

Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -431,6 +431,38 @@ static void halbtc8821a1ant_query_bt_inf
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
+static
+bool halbtc8821a1ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
+{
+	static bool pre_wifi_busy, pre_under_4way, pre_bt_hs_on;
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
 static void halbtc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info	*bt_link_info = &btcoexist->bt_link_info;
@@ -2236,6 +2268,7 @@ static void halbtc8821a1ant_init_hw_conf
 void ex_halbtc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
 	halbtc8821a1ant_init_hw_config(btcoexist, true);
+	btcoexist->auto_report_1ant = true;
 }
 
 void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -2526,9 +2559,8 @@ void ex_halbtc8821a1ant_display_coex_inf
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 		 "\r\n %-35s = %d/ %d", "0x774(low-pri rx/tx)",
 		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 1)
-	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_1ant)
+		halbtc8821a1ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
@@ -2814,14 +2846,15 @@ void ex_halbtc8821a1ant_bt_info_notify(s
 								false);
 			}
 		}
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-		if (!(coex_sta->bt_info_ext & BIT4)) {
-			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-				 "[BTCoex], BT ext info bit4 check, set BT to enable Auto Report!!\n");
-			halbtc8821a1ant_bt_auto_report(btcoexist,
-						       FORCE_EXEC, true);
+		if (!btcoexist->auto_report_1ant) {
+			if (!(coex_sta->bt_info_ext & BIT4)) {
+				RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+					 "[BTCoex], BT ext info bit4 check, set BT to enable Auto Report!!\n");
+				halbtc8821a1ant_bt_auto_report(btcoexist,
+							       FORCE_EXEC,
+							       true);
+			}
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan*/
@@ -2981,17 +3014,16 @@ void ex_halbtc8821a1ant_periodical(struc
 			 "[BTCoex], ****************************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8821A_1ANT == 0)
-	halbtc8821a1ant_query_bt_info(btcoexist);
-	halbtc8821a1ant_monitor_bt_ctr(btcoexist);
-	btc8821a1ant_mon_bt_en_dis(btcoexist);
-#else
-	if (halbtc8821a1ant_Is_wifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust) {
-		if (coex_sta->special_pkt_period_cnt > 2)
-			halbtc8821a1ant_run_coexist_mechanism(btcoexist);
+	if (!btcoexist->auto_report_1ant) {
+		halbtc8821a1ant_query_bt_info(btcoexist);
+		halbtc8821a1ant_monitor_bt_ctr(btcoexist);
+		btc8821a1ant_mon_bt_en_dis(btcoexist);
+	} else {
+		if (halbtc8821a1ant_is_wifi_status_changed(btcoexist) ||
+		    coex_dm->auto_tdma_adjust) {
+			if (coex_sta->special_pkt_period_cnt > 2)
+				halbtc8821a1ant_run_coexist_mechanism(btcoexist);
+		}
+		coex_sta->special_pkt_period_cnt++;
 	}
-
-	coex_sta->special_pkt_period_cnt++;
-#endif
 }
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.h
@@ -27,7 +27,6 @@
  * The following is for 8821A 1ANT BT Co-exist definition
  *===========================================
  */
-#define	BT_AUTO_REPORT_ONLY_8821A_1ANT				0
 
 #define	BT_INFO_8821A_1ANT_B_FTP	BIT7
 #define	BT_INFO_8821A_1ANT_B_A2DP	BIT6
@@ -168,6 +167,7 @@ struct coex_sta_8821a_1ant {
  * The following is interface which will notify coex module.
  *===========================================
  */
+bool btc8821a1ant_is_wifi_status_changed(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_init_hwconfig(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist);
 void ex_halbtc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -478,6 +478,11 @@ struct btc_coexist {
 	enum btc_chip_interface	chip_interface;
 	struct btc_bt_link_info bt_link_info;
 
+	/* boolean variables to replace BT_AUTO_REPORT_ONLY_XXXXY_ZANT
+	 * configuration parameters
+	 */
+	bool auto_report_1ant;
+	bool auto_report_2ant;
 	bool initilized;
 	bool stop_coex_dm;
 	bool manual_control;
