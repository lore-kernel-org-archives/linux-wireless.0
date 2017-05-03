Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36200 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752205AbdECXvI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 19:51:08 -0400
Received: by mail-io0-f193.google.com with SMTP id x86so39182938ioe.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 16:51:07 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 3/4] rtlwifi: btcoex: Remove 23b 2ant configuration parameter
Date: Wed,  3 May 2017 18:50:56 -0500
Message-Id: <20170503235057.23211-4-Larry.Finger@lwfinger.net> (sfid-20170504_015118_725765_5C34E06E)
In-Reply-To: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
References: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In file halbtc8723b2ant.c, there are directives that depend on an
undocumented configuration parameter BT_AUTO_REPORT_ONLY_8723B_2ANT
that cannot be set from Kconfig. This parameter is replaced by a
boolean in the main structure used by all routines. It still cannot
be changed dynamically, but it is easier to document.

Routines halbtc8723b2ant_set_bt_auto_report, btc8723b2ant_bt_auto_report,
and btc8723b2ant_monitor_wifi_ctr are restored.
 
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 84 +++++++++++++++-------
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |  1 -
 2 files changed, 58 insertions(+), 27 deletions(-)

Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -274,6 +274,44 @@ static void btc8723b2ant_monitor_bt_ctr(
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
+static
+void btc8723b2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
+{
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
+
+	/* reset counter */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xf16, 0x1, 0x1);
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0xf16, 0x1, 0x0);
+}
+
 static void btc8723b2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
@@ -331,36 +369,22 @@ static void btc8723b2ant_update_bt_link_
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 1) /* profile from bt patch */
-	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hs_on);
+	if (btcoexist->auto_report_2ant) {
+		btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION,
+				   &bt_hs_on);
 
-	bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
-	bt_link_info->sco_exist = coex_sta->sco_exist;
-	bt_link_info->a2dp_exist = coex_sta->a2dp_exist;
-	bt_link_info->pan_exist = coex_sta->pan_exist;
-	bt_link_info->hid_exist = coex_sta->hid_exist;
-
-	/* work around for HS mode. */
-	if (bt_hs_on) {
-		bt_link_info->pan_exist = true;
-		bt_link_info->bt_link_exist = true;
-	}
-#else	/* profile from bt stack */
-	bt_link_info->bt_link_exist = stack_info->bt_link_exist;
-	bt_link_info->sco_exist = stack_info->sco_exist;
-	bt_link_info->a2dp_exist = stack_info->a2dp_exist;
-	bt_link_info->pan_exist = stack_info->pan_exist;
-	bt_link_info->hid_exist = stack_info->hid_exist;
-
-	/*for win-8 stack HID report error*/
-	if (!stack_info->hid_exist)
-		stack_info->hid_exist = coex_sta->hid_exist;
-	/*sync  BTInfo with BT firmware and stack*/
-	/* when stack HID report error, here we use the info from bt fw.*/
-	if (!stack_info->bt_link_exist)
-		stack_info->bt_link_exist = coex_sta->bt_link_exist;
-#endif
-	/* check if Sco only */
+		bt_link_info->bt_link_exist = coex_sta->bt_link_exist;
+		bt_link_info->sco_exist = coex_sta->sco_exist;
+		bt_link_info->a2dp_exist = coex_sta->a2dp_exist;
+		bt_link_info->pan_exist = coex_sta->pan_exist;
+		bt_link_info->hid_exist = coex_sta->hid_exist;
+
+		/* work around for HS mode. */
+		if (bt_hs_on) {
+			bt_link_info->pan_exist = true;
+			bt_link_info->bt_link_exist = true;
+		}
+	}
 	if (bt_link_info->sco_exist && !bt_link_info->a2dp_exist &&
 	    !bt_link_info->pan_exist && !bt_link_info->hid_exist)
 		bt_link_info->sco_only = true;
@@ -682,6 +705,36 @@ static void btc8723b2ant_dec_bt_pwr(stru
 	coex_dm->pre_dec_bt_pwr = coex_dm->cur_dec_bt_pwr;
 }
 
+static
+void halbtc8723b2ant_set_bt_auto_report(struct btc_coexist *btcoexist,
+					bool enable_auto_report)
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
+static
+void btc8723b2ant_bt_auto_report(struct btc_coexist *btcoexist,
+				 bool force_exec, bool enable_auto_report)
+{
+	coex_dm->cur_bt_auto_report = enable_auto_report;
+
+	if (!force_exec) {
+		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
+			return;
+	}
+	halbtc8723b2ant_set_bt_auto_report(btcoexist,
+					   coex_dm->cur_bt_auto_report);
+
+	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
+}
+
 static void btc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 fw_dac_swing_lvl)
 {
@@ -3118,6 +3171,7 @@ void ex_btc8723b2ant_init_hwconfig(struc
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 	btcoexist->btc_write_1byte(btcoexist, 0x778, 0x3);
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
+	btcoexist->auto_report_2ant = true;
 }
 
 void ex_btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -3350,9 +3404,8 @@ void ex_btc8723b2ant_display_coex_info(s
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
 		 "0x774(low-pri rx/tx)", coex_sta->low_priority_rx,
 		 coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 1)
-	btc8723b2ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_2ant)
+		btc8723b2ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist,
 	BTC_DBG_DISP_COEX_STATISTICS);
 }
@@ -3542,14 +3595,15 @@ void ex_btc8723b2ant_bt_info_notify(stru
 		} else {
 			/* BT already NOT ignore Wlan active, do nothing here.*/
 		}
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
-		if ((coex_sta->bt_info_ext & BIT4)) {
-			/* BT auto report already enabled, do nothing*/
-		} else {
-			btc8723b2ant_bt_auto_report(btcoexist, FORCE_EXEC,
-						    true);
+		if (!btcoexist->auto_report_2ant) {
+			if ((coex_sta->bt_info_ext & BIT4)) {
+				/* BT auto report already enabled, do nothing*/
+			} else {
+				btc8723b2ant_bt_auto_report(btcoexist,
+							    FORCE_EXEC,
+							    true);
+			}
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan*/
@@ -3643,6 +3697,7 @@ void ex_btc8723b2ant_halt_notify(struct
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	static u8 dis_ver_info_cnt;
@@ -3675,13 +3730,22 @@ void ex_btc8723b2ant_periodical(struct b
 			 "[BTCoex], ****************************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8723B_2ANT == 0)
-	btc8723b2ant_query_bt_info(btcoexist);
-	btc8723b2ant_monitor_bt_ctr(btcoexist);
-	btc8723b2ant_monitor_bt_enable_disable(btcoexist);
-#else
-	if (btc8723b2ant_is_wifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust)
-		btc8723b2ant_run_coexist_mechanism(btcoexist);
-#endif
+	if (!btcoexist->auto_report_2ant) {
+		btc8723b2ant_query_bt_info(btcoexist);
+	} else {
+		btc8723b2ant_monitor_bt_ctr(btcoexist);
+		btc8723b2ant_monitor_wifi_ctr(btcoexist);
+
+		/* for some BT speakers that High-Priority pkts appear before
+		 * playing, this will cause HID exist
+		 */
+		if ((coex_sta->high_priority_tx +
+		     coex_sta->high_priority_rx < 50) &&
+		    (bt_link_info->hid_exist))
+			bt_link_info->hid_exist = false;
+
+		if (btc8723b2ant_is_wifi_status_changed(btcoexist) ||
+		    coex_dm->auto_tdma_adjust)
+			btc8723b2ant_run_coexist_mechanism(btcoexist);
+	}
 }
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -28,7 +28,6 @@
 /************************************************************************
  * The following is for 8723B 2Ant BT Co-exist definition
  ************************************************************************/
-#define	BT_AUTO_REPORT_ONLY_8723B_2ANT			1
 
 #define	BT_INFO_8723B_2ANT_B_FTP			BIT7
 #define	BT_INFO_8723B_2ANT_B_A2DP			BIT6
@@ -148,6 +147,16 @@ struct coex_sta_8723b_2ant {
 	bool c2h_bt_inquiry_page;
 	u8 bt_retry_cnt;
 	u8 bt_info_ext;
+
+	u32 crc_ok_cck;
+	u32 crc_ok_11g;
+	u32 crc_ok_11n;
+	u32 crc_ok_11n_agg;
+
+	u32	crc_err_cck;
+	u32	crc_err_11g;
+	u32	crc_err_11n;
+	u32	crc_err_11n_agg;
 };
 
 /*********************************************************************
