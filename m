Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34701 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752269AbdECXvI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 19:51:08 -0400
Received: by mail-io0-f194.google.com with SMTP id h41so39139300ioi.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 16:51:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 4/4] rtlwifi: btcoex: Remove 92e 2ant configuration parameter
Date: Wed,  3 May 2017 18:50:57 -0500
Message-Id: <20170503235057.23211-5-Larry.Finger@lwfinger.net> (sfid-20170504_015118_169046_88307E3C)
In-Reply-To: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
References: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In file halbtc8192e2ant.c, there are directives that depend on an
undocumented configuration parameter BT_AUTO_REPORT_ONLY_8192E_2ANT
that cannot be set from Kconfig. This parameter is replaced by a
boolean in the main structure used by all routines. It still cannot
be changed dynamically, but it is easier to document.

Upon the advice of Realtek, the auto report option is turned on with
this patch.

Routines btc8192e2ant_is_wifi_status_changed, btc8192e2ant_bt_auto_report,
and halbtc8192e2ant_set_bt_auto_report are restored.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 72 ++++++++++++++++------
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |  1 -
 2 files changed, 53 insertions(+), 20 deletions(-)

Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -455,6 +455,39 @@ static void halbtc8192e2ant_querybt_info
 	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
 }
 
+static
+bool btc8192e2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
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
 static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btcoexist)
 {
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
@@ -717,6 +750,35 @@ static u8 halbtc8192e2ant_action_algorit
 	return algorithm;
 }
 
+static void halbtc8192e2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
+					       bool enable_auto_report)
+{
+	u8 h2c_parameter[1] = {0};
+
+	h2c_parameter[0] = 0;
+
+	if (enable_auto_report)
+		h2c_parameter[0] |= BIT(0);
+
+	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
+}
+
+static void btc8192e2ant_bt_auto_report(struct btc_coexist *btcoexist,
+					bool force_exec,
+					bool enable_auto_report)
+{
+	coex_dm->cur_bt_auto_report = enable_auto_report;
+
+	if (!force_exec) {
+		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
+			return;
+	}
+	halbtc8192e2ant_set_bt_auto_report(btcoexist,
+					   coex_dm->cur_bt_auto_report);
+
+	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
+}
+
 static void halbtc8192e2ant_setfw_dac_swinglevel(struct btc_coexist *btcoexist,
 						 u8 dac_swinglvl)
 {
@@ -771,52 +833,6 @@ static void halbtc8192e2ant_dec_btpwr(st
 	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
 }
 
-static void halbtc8192e2ant_set_bt_autoreport(struct btc_coexist *btcoexist,
-					      bool enable_autoreport)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-	u8 h2c_parameter[1] = {0};
-
-	h2c_parameter[0] = 0;
-
-	if (enable_autoreport)
-		h2c_parameter[0] |= BIT0;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], BT FW auto report : %s, FW write 0x68 = 0x%x\n",
-		 (enable_autoreport ? "Enabled!!" : "Disabled!!"),
-		 h2c_parameter[0]);
-
-	btcoexist->btc_fill_h2c(btcoexist, 0x68, 1, h2c_parameter);
-}
-
-static void halbtc8192e2ant_bt_autoreport(struct btc_coexist *btcoexist,
-					  bool force_exec,
-					  bool enable_autoreport)
-{
-	struct rtl_priv *rtlpriv = btcoexist->adapter;
-
-	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-		 "[BTCoex], %s BT Auto report = %s\n",
-		 (force_exec ? "force to" : ""),
-		 ((enable_autoreport) ? "Enabled" : "Disabled"));
-	coex_dm->cur_bt_auto_report = enable_autoreport;
-
-	if (!force_exec) {
-		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-			 "[BTCoex] bPreBtAutoReport=%d, bCurBtAutoReport=%d\n",
-			 coex_dm->pre_bt_auto_report,
-			 coex_dm->cur_bt_auto_report);
-
-		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
-			return;
-	}
-	halbtc8192e2ant_set_bt_autoreport(btcoexist,
-					  coex_dm->cur_bt_auto_report);
-
-	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
-}
-
 static void halbtc8192e2ant_fw_dac_swinglvl(struct btc_coexist *btcoexist,
 					    bool force_exec, u8 fw_dac_swinglvl)
 {
@@ -3258,6 +3274,7 @@ static void halbtc8192e2ant_init_hwconfi
 void ex_halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
 	halbtc8192e2ant_init_hwconfig(btcoexist, true);
+	btcoexist->auto_report_2ant = true;
 }
 
 void ex_halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -3484,9 +3501,8 @@ void ex_halbtc8192e2ant_display_coex_inf
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
 		 "0x774(lp rx[31:16]/tx[15:0])",
 		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 1)
-	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_2ant)
+		halbtc8192e2ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
@@ -3675,14 +3691,15 @@ void ex_halbtc8192e2ant_bt_info_notify(s
 			 */
 		}
 
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-		if ((coex_sta->bt_info_ext & BIT4)) {
-			/* BT auto report already enabled, do nothing */
-		} else {
-			halbtc8192e2ant_bt_autoreport(btcoexist, FORCE_EXEC,
-						      true);
+		if (!btcoexist->auto_report_2ant) {
+			if ((coex_sta->bt_info_ext & BIT4)) {
+				/* BT auto report already enabled, do nothing */
+			} else {
+				btc8192e2ant_bt_auto_report(btcoexist,
+							    FORCE_EXEC,
+							    true);
+			}
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan */
@@ -3809,13 +3826,13 @@ void ex_halbtc8192e2ant_periodical(struc
 			 "************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-	halbtc8192e2ant_querybt_info(btcoexist);
-	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
-	btc8192e2ant_monitor_bt_enable_dis(btcoexist);
-#else
-	if (halbtc8192e2ant_iswifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust)
-		halbtc8192e2ant_run_coexist_mechanism(btcoexist);
-#endif
+	if (!btcoexist->auto_report_2ant) {
+		halbtc8192e2ant_querybt_info(btcoexist);
+		halbtc8192e2ant_monitor_bt_ctr(btcoexist);
+		btc8192e2ant_monitor_bt_enable_dis(btcoexist);
+	} else {
+		if (btc8192e2ant_is_wifi_status_changed(btcoexist) ||
+		    coex_dm->auto_tdma_adjust)
+			halbtc8192e2ant_run_coexist_mechanism(btcoexist);
+	}
 }
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.h
@@ -25,7 +25,6 @@
 /*****************************************************************
  *   The following is for 8192E 2Ant BT Co-exist definition
  *****************************************************************/
-#define	BT_AUTO_REPORT_ONLY_8192E_2ANT			0
 
 #define	BT_INFO_8192E_2ANT_B_FTP			BIT7
 #define	BT_INFO_8192E_2ANT_B_A2DP			BIT6
