Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:32995 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752202AbdECXvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 19:51:07 -0400
Received: by mail-io0-f195.google.com with SMTP id l196so4929724ioe.0
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 16:51:06 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 2/4] rtlwifi: btcoex: Remove 23b 1ant configuration parameter
Date: Wed,  3 May 2017 18:50:55 -0500
Message-Id: <20170503235057.23211-3-Larry.Finger@lwfinger.net> (sfid-20170504_015117_601905_FB52911A)
In-Reply-To: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
References: <20170503235057.23211-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In file halbtc8723b1ant.c, there are directives that depend on an
undocumented configuration parameter BT_AUTO_REPORT_ONLY_8723B_1ANT
that cannot be set from Kconfig. This parameter is replaced by a
boolean in the main structure used by all routines. It still cannot
be changed dynamically, but it is easier to document.

The following routines are restored:
halbtc8723b1ant_bt_auto_report
halbtc8723b1ant_set_bt_auto_report
halbtc8723b1ant_action_wifi_only
halbtc8723b1ant_set_ant_path

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Pkshih <pkshih@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 123 +++++++++++++++++----
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   2 +-
 2 files changed, 103 insertions(+), 22 deletions(-)

Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -711,6 +711,35 @@ static u8 halbtc8723b1ant_action_algorit
 	return algorithm;
 }
 
+static void halbtc8723b1ant_set_bt_auto_report(struct btc_coexist *btcoexist,
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
+static void halbtc8723b1ant_bt_auto_report(struct btc_coexist *btcoexist,
+					   bool force_exec,
+					   bool enable_auto_report)
+{
+	coex_dm->cur_bt_auto_report = enable_auto_report;
+
+	if (!force_exec) {
+		if (coex_dm->pre_bt_auto_report == coex_dm->cur_bt_auto_report)
+			return;
+	}
+	halbtc8723b1ant_set_bt_auto_report(btcoexist,
+					   coex_dm->cur_bt_auto_report);
+
+	coex_dm->pre_bt_auto_report = coex_dm->cur_bt_auto_report;
+}
+
 static void btc8723b1ant_set_sw_pen_tx_rate_adapt(struct btc_coexist *btcoexist,
 						  bool low_penalty_ra)
 {
@@ -1711,6 +1740,268 @@ static void halbtc8723b1ant_action_sco(s
 	halbtc8723b1ant_sw_mechanism(btcoexist, true);
 }
 
+static void halbtc8723b1ant_set_ant_path(struct btc_coexist *btcoexist,
+					 u8 ant_pos_type, bool force_exec,
+					 bool init_hwcfg, bool wifi_off)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u32 fw_ver = 0, u32tmp = 0, cnt_bt_cal_chk = 0;
+	bool pg_ext_switch = false;
+	bool use_ext_switch = false;
+	bool is_in_mp_mode = false;
+	u8 h2c_parameter[2] = {0}, u8tmp = 0;
+
+	coex_dm->cur_ant_pos_type = ant_pos_type;
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_EXT_SWITCH, &pg_ext_switch);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER,
+			   &fw_ver); /* [31:16]=fw ver, [15:0]=fw sub ver */
+
+	if ((fw_ver > 0 && fw_ver < 0xc0000) || pg_ext_switch)
+		use_ext_switch = true;
+
+	if (ant_pos_type == BTC_ANT_PATH_PTA) {
+		if ((board_info->btdm_ant_det_finish) &&
+		    (board_info->btdm_ant_num_by_ant_det == 2)) {
+			if (board_info->btdm_ant_pos ==
+			    BTC_ANTENNA_AT_MAIN_PORT)
+				ant_pos_type = BTC_ANT_PATH_WIFI;
+			else
+				ant_pos_type = BTC_ANT_PATH_BT;
+		}
+	}
+
+	if (init_hwcfg) {
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
+					  0x780); /* WiFi TRx Mask on */
+		/* remove due to interrupt is disabled that polling c2h will
+		 * fail and delay 100ms.
+		 */
+
+		if (fw_ver >= 0x180000) {
+			/* Use H2C to set GNT_BT to HIGH */
+			h2c_parameter[0] = 1;
+			btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1,
+						h2c_parameter);
+		} else {
+			/* set grant_bt to high */
+			btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
+		}
+		/* set wlan_act control by PTA */
+		btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
+
+		btcoexist->btc_write_1byte_bitmask(
+			btcoexist, 0x67, 0x20,
+			0x0); /* BT select s0/s1 is controlled by BT */
+
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x39, 0x8, 0x1);
+		btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x944, 0x3, 0x3);
+		btcoexist->btc_write_1byte(btcoexist, 0x930, 0x77);
+	} else if (wifi_off) {
+		if (fw_ver >= 0x180000) {
+			/* Use H2C to set GNT_BT to HIGH */
+			h2c_parameter[0] = 1;
+			btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1,
+						h2c_parameter);
+		} else {
+			/* set grant_bt to high */
+			btcoexist->btc_write_1byte(btcoexist, 0x765, 0x18);
+		}
+		/* set wlan_act to always low */
+		btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
+
+		btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_IS_IN_MP_MODE,
+				   &is_in_mp_mode);
+		if (!is_in_mp_mode)
+			btcoexist->btc_write_1byte_bitmask(
+				btcoexist, 0x67, 0x20,
+				0x0); /* BT select s0/s1 is controlled by BT */
+		else
+			btcoexist->btc_write_1byte_bitmask(
+				btcoexist, 0x67, 0x20, 0x1);
+				/* BT select s0/s1 is controlled by WiFi */
+
+		/* 0x4c[24:23]=00, Set Antenna control by BT_RFE_CTRL	BT
+		 * Vendor 0xac=0xf002
+		 */
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+		u32tmp &= ~BIT(23);
+		u32tmp &= ~BIT(24);
+		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+	} else {
+		/* Use H2C to set GNT_BT to LOW */
+		if (fw_ver >= 0x180000) {
+			if (btcoexist->btc_read_1byte(btcoexist, 0x765) != 0) {
+				h2c_parameter[0] = 0;
+				btcoexist->btc_fill_h2c(btcoexist, 0x6E, 1,
+							h2c_parameter);
+			}
+		} else {
+			/* BT calibration check */
+			while (cnt_bt_cal_chk <= 20) {
+				u8tmp = btcoexist->btc_read_1byte(btcoexist,
+								  0x49d);
+				cnt_bt_cal_chk++;
+				if (u8tmp & BIT(0)) {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], ########### BT is calibrating (wait cnt=%d) ###########\n",
+						 cnt_bt_cal_chk);
+					mdelay(50);
+				} else {
+					RT_TRACE(rtlpriv, COMP_BT_COEXIST,
+						 DBG_LOUD,
+						 "[BTCoex], ********** BT is NOT calibrating (wait cnt=%d)**********\n",
+						 cnt_bt_cal_chk);
+					break;
+				}
+			}
+
+			/* set grant_bt to PTA */
+			btcoexist->btc_write_1byte(btcoexist, 0x765, 0x0);
+		}
+
+		if (btcoexist->btc_read_1byte(btcoexist, 0x76e) != 0xc) {
+			/* set wlan_act control by PTA */
+			btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
+		}
+
+		btcoexist->btc_write_1byte_bitmask(
+			btcoexist, 0x67, 0x20,
+			0x1); /* BT select s0/s1 is controlled by WiFi */
+	}
+
+	if (use_ext_switch) {
+		if (init_hwcfg) {
+			/* 0x4c[23]=0, 0x4c[24]=1  Antenna control by WL/BT */
+			u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+			u32tmp &= ~BIT(23);
+			u32tmp |= BIT(24);
+			btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+
+			btcoexist->btc_write_4byte(
+				btcoexist, 0x948, 0x0);
+				/* fixed internal switch S1->WiFi, S0->BT */
+
+			if (board_info->btdm_ant_pos ==
+			    BTC_ANTENNA_AT_MAIN_PORT) {
+				/* tell firmware "no antenna inverse" */
+				h2c_parameter[0] = 0;
+				h2c_parameter[1] = 1; /* ext switch type */
+				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
+							h2c_parameter);
+			} else {
+				/* tell firmware "antenna inverse" */
+				h2c_parameter[0] = 1;
+				h2c_parameter[1] = 1; /* ext switch type */
+				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
+							h2c_parameter);
+			}
+		}
+
+		if (force_exec ||
+		    (coex_dm->cur_ant_pos_type != coex_dm->pre_ant_pos_type)) {
+			/* ext switch setting */
+			switch (ant_pos_type) {
+			case BTC_ANT_PATH_WIFI:
+				if (board_info->btdm_ant_pos ==
+				    BTC_ANTENNA_AT_MAIN_PORT)
+					btcoexist->btc_write_1byte_bitmask(
+						btcoexist, 0x92c, 0x3, 0x1);
+				else
+					btcoexist->btc_write_1byte_bitmask(
+						btcoexist, 0x92c, 0x3, 0x2);
+				break;
+			case BTC_ANT_PATH_BT:
+				if (board_info->btdm_ant_pos ==
+				    BTC_ANTENNA_AT_MAIN_PORT)
+					btcoexist->btc_write_1byte_bitmask(
+						btcoexist, 0x92c, 0x3, 0x2);
+				else
+					btcoexist->btc_write_1byte_bitmask(
+						btcoexist, 0x92c, 0x3, 0x1);
+				break;
+			default:
+			case BTC_ANT_PATH_PTA:
+				if (board_info->btdm_ant_pos ==
+				    BTC_ANTENNA_AT_MAIN_PORT)
+					btcoexist->btc_write_1byte_bitmask(
+						btcoexist, 0x92c, 0x3, 0x1);
+				else
+					btcoexist->btc_write_1byte_bitmask(
+						btcoexist, 0x92c, 0x3, 0x2);
+				break;
+			}
+		}
+	} else {
+		if (init_hwcfg) {
+			/* 0x4c[23]=1, 0x4c[24]=0  Antenna control by 0x64 */
+			u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+			u32tmp |= BIT(23);
+			u32tmp &= ~BIT(24);
+			btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+
+			/* Fix Ext switch Main->S1, Aux->S0 */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64, 0x1,
+							   0x0);
+
+			if (board_info->btdm_ant_pos ==
+			    BTC_ANTENNA_AT_MAIN_PORT) {
+				/* tell firmware "no antenna inverse" */
+				h2c_parameter[0] = 0;
+				h2c_parameter[1] = 0; /* internal switch type */
+				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
+							h2c_parameter);
+			} else {
+				/* tell firmware "antenna inverse" */
+				h2c_parameter[0] = 1;
+				h2c_parameter[1] = 0; /* internal switch type */
+				btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
+							h2c_parameter);
+			}
+		}
+
+		if (force_exec ||
+		    (coex_dm->cur_ant_pos_type != coex_dm->pre_ant_pos_type)) {
+			/* internal switch setting */
+			switch (ant_pos_type) {
+			case BTC_ANT_PATH_WIFI:
+				if (board_info->btdm_ant_pos ==
+				    BTC_ANTENNA_AT_MAIN_PORT)
+					btcoexist->btc_write_4byte(btcoexist,
+								   0x948, 0x0);
+				else
+					btcoexist->btc_write_4byte(
+						btcoexist, 0x948, 0x280);
+				break;
+			case BTC_ANT_PATH_BT:
+				if (board_info->btdm_ant_pos ==
+				    BTC_ANTENNA_AT_MAIN_PORT)
+					btcoexist->btc_write_4byte(
+						btcoexist, 0x948, 0x280);
+				else
+					btcoexist->btc_write_4byte(btcoexist,
+								   0x948, 0x0);
+				break;
+			default:
+			case BTC_ANT_PATH_PTA:
+				if (board_info->btdm_ant_pos ==
+				    BTC_ANTENNA_AT_MAIN_PORT)
+					btcoexist->btc_write_4byte(
+						btcoexist, 0x948, 0x200);
+				else
+					btcoexist->btc_write_4byte(btcoexist,
+								   0x948, 0x80);
+				break;
+			}
+		}
+	}
+
+	coex_dm->pre_ant_pos_type = coex_dm->cur_ant_pos_type;
+}
+
 static void halbtc8723b1ant_action_hid(struct btc_coexist *btcoexist)
 {
 	halbtc8723b1ant_sw_mechanism(btcoexist, true);
@@ -1760,6 +2051,58 @@ static void halbtc8723b1ant_action_hid_a
 	halbtc8723b1ant_sw_mechanism(btcoexist, true);
 }
 
+static void halbtc8723b1ant_action_wifi_only(struct btc_coexist *btcoexist)
+{
+	halbtc8723b1ant_coex_table_with_type(btcoexist, FORCE_EXEC, 0);
+	halbtc8723b1ant_ps_tdma(btcoexist, FORCE_EXEC, false, 8);
+	halbtc8723b1ant_set_ant_path(btcoexist, BTC_ANT_PATH_PTA,
+				     false, false, false);
+}
+
+/* check if BT is disabled */
+static void halbtc8723b1ant_monitor_bt_enable_disable(struct btc_coexist
+						      *btcoexist)
+{
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	static u32 bt_disable_cnt;
+	bool bt_active = true, bt_disabled;
+
+	if (coex_sta->high_priority_tx == 0 &&
+	    coex_sta->high_priority_rx == 0 && coex_sta->low_priority_tx == 0 &&
+	    coex_sta->low_priority_rx == 0)
+		bt_active = false;
+	if (coex_sta->high_priority_tx == 0xffff &&
+	    coex_sta->high_priority_rx == 0xffff &&
+	    coex_sta->low_priority_tx == 0xffff &&
+	    coex_sta->low_priority_rx == 0xffff)
+		bt_active = false;
+	if (bt_active) {
+		bt_disable_cnt = 0;
+		bt_disabled = false;
+	} else {
+		bt_disable_cnt++;
+		if (bt_disable_cnt >= 2)
+			bt_disabled = true;
+	}
+	if (coex_sta->bt_disabled != bt_disabled) {
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], BT is from %s to %s!!\n",
+			 (coex_sta->bt_disabled ? "disabled" : "enabled"),
+			 (bt_disabled ? "disabled" : "enabled"));
+
+		coex_sta->bt_disabled = bt_disabled;
+		btcoexist->btc_set(btcoexist, BTC_SET_BL_BT_DISABLE,
+				   &bt_disabled);
+		if (bt_disabled) {
+			halbtc8723b1ant_action_wifi_only(btcoexist);
+			btcoexist->btc_set(btcoexist, BTC_SET_ACT_LEAVE_LPS,
+					   NULL);
+			btcoexist->btc_set(btcoexist, BTC_SET_ACT_NORMAL_LPS,
+					   NULL);
+		}
+	}
+}
+
 /*****************************************************
  *
  *	Non-Software Coex Mechanism start
@@ -2391,6 +2734,7 @@ static void halbtc8723b1ant_wifi_off_hw_
 void ex_halbtc8723b1ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
 	halbtc8723b1ant_init_hw_config(btcoexist, true);
+	btcoexist->auto_report_1ant = true;
 }
 
 void ex_halbtc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist)
@@ -2679,9 +3023,8 @@ void ex_halbtc8723b1ant_display_coex_inf
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
 		 "0x774(low-pri rx/tx)", coex_sta->low_priority_rx,
 		 coex_sta->low_priority_tx);
-#if (BT_AUTO_REPORT_ONLY_8723B_1ANT == 1)
-	halbtc8723b1ant_monitor_bt_ctr(btcoexist);
-#endif
+	if (btcoexist->auto_report_1ant)
+		halbtc8723b1ant_monitor_bt_ctr(btcoexist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_COEX_STATISTICS);
 }
 
@@ -2997,14 +3340,15 @@ void ex_halbtc8723b1ant_bt_info_notify(s
 		} else {
 			/* BT already NOT ignore Wlan active, do nothing here.*/
 		}
-#if (BT_AUTO_REPORT_ONLY_8723B_1ANT == 0)
-		if (coex_sta->bt_info_ext & BIT4) {
-			/* BT auto report already enabled, do nothing */
-		} else {
-			halbtc8723b1ant_bt_auto_report(btcoexist, FORCE_EXEC,
-						       true);
+		if (!btcoexist->auto_report_1ant) {
+			if (coex_sta->bt_info_ext & BIT4) {
+				/* BT auto report already enabled, do nothing */
+			} else {
+				halbtc8723b1ant_bt_auto_report(btcoexist,
+							       FORCE_EXEC,
+							       true);
+			}
 		}
-#endif
 	}
 
 	/* check BIT2 first ==> check if bt is under inquiry or page scan */
@@ -3176,16 +3520,15 @@ void ex_halbtc8723b1ant_periodical(struc
 			 "[BTCoex], ****************************************************************\n");
 	}
 
-#if (BT_AUTO_REPORT_ONLY_8723B_1ANT == 0)
-	halbtc8723b1ant_query_bt_info(btcoexist);
-	halbtc8723b1ant_monitor_bt_ctr(btcoexist);
-	halbtc8723b1ant_monitor_bt_enable_disable(btcoexist);
-#else
-	if (btc8723b1ant_is_wifi_status_changed(btcoexist) ||
-	    coex_dm->auto_tdma_adjust) {
-		halbtc8723b1ant_run_coexist_mechanism(btcoexist);
+	if (!btcoexist->auto_report_1ant) {
+		halbtc8723b1ant_query_bt_info(btcoexist);
+		halbtc8723b1ant_monitor_bt_ctr(btcoexist);
+		halbtc8723b1ant_monitor_bt_enable_disable(btcoexist);
+	} else {
+		if (btc8723b1ant_is_wifi_status_changed(btcoexist) ||
+		    coex_dm->auto_tdma_adjust) {
+			halbtc8723b1ant_run_coexist_mechanism(btcoexist);
+		}
+		coex_sta->special_pkt_period_cnt++;
 	}
-
-	coex_sta->special_pkt_period_cnt++;
-#endif
 }
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.h
@@ -25,7 +25,6 @@
 /**********************************************************************
  * The following is for 8723B 1ANT BT Co-exist definition
  **********************************************************************/
-#define	BT_AUTO_REPORT_ONLY_8723B_1ANT			1
 
 #define	BT_INFO_8723B_1ANT_B_FTP			BIT7
 #define	BT_INFO_8723B_1ANT_B_A2DP			BIT6
@@ -84,6 +83,9 @@ enum _BT_8723B_1ANT_COEX_ALGO {
 };
 
 struct coex_dm_8723b_1ant {
+	/* hw setting */
+	u8	pre_ant_pos_type;
+	u8	cur_ant_pos_type;
 	/* fw mechanism */
 	bool cur_ignore_wlan_act;
 	bool pre_ignore_wlan_act;
@@ -138,6 +140,7 @@ struct coex_dm_8723b_1ant {
 };
 
 struct coex_sta_8723b_1ant {
+	bool bt_disabled;
 	bool bt_link_exist;
 	bool sco_exist;
 	bool a2dp_exist;
Index: wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
===================================================================
--- wireless-drivers-next.orig/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ wireless-drivers-next/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -138,8 +138,12 @@ struct btc_board_info {
 	u8 bt_chip_type;
 	u8 pg_ant_num;	/* pg ant number */
 	u8 btdm_ant_num;	/* ant number for btdm */
+	u8 btdm_ant_num_by_ant_det;	/* ant number for btdm after antenna
+					 * detection
+					 */
 	u8 btdm_ant_pos;
 	bool bt_exist;
+	bool btdm_ant_det_finish;
 };
 
 enum btc_dbg_opcode {
@@ -205,6 +209,7 @@ enum btc_get_type {
 	BTC_GET_BL_WIFI_ENABLE_ENCRYPTION,
 	BTC_GET_BL_WIFI_UNDER_B_MODE,
 	BTC_GET_BL_EXT_SWITCH,
+	BTC_GET_BL_WIFI_IS_IN_MP_MODE,
 
 	/* type s4Byte */
 	BTC_GET_S4_WIFI_RSSI,
