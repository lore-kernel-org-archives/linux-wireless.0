Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61487 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbaIDVEK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 17:04:10 -0400
Received: by mail-oa0-f46.google.com with SMTP id m19so7757695oag.33
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 14:04:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	troy_tan@realsil.com.cn
Subject: [PATCH 1/7 V3.18] rtlwifi: btcoexist: Modify btcoexist for changes in the V062814 Realtek version
Date: Thu,  4 Sep 2014 16:03:40 -0500
Message-Id: <1409864626-16373-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140904_230418_210390_8300B9E1)
In-Reply-To: <1409864626-16373-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1409864626-16373-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is the first of a set to bring this driver up to the latest Realtek code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: troy_tan@realsil.com.cn
---
 .../wireless/rtlwifi/btcoexist/halbtc8723b2ant.c   | 447 ++++++++++++---------
 .../wireless/rtlwifi/btcoexist/halbtc8723b2ant.h   |  31 +-
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c  |  31 +-
 .../net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h  |  22 +
 4 files changed, 298 insertions(+), 233 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c
index d916ab9..bd37d65 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -49,8 +49,8 @@ static const char *const glbt_info_src_8723b_2ant[] = {
 	"BT Info[bt auto report]",
 };
 
-static u32 glcoex_ver_date_8723b_2ant = 20130731;
-static u32 glcoex_ver_8723b_2ant = 0x3b;
+static u32 glcoex_ver_date_8723b_2ant = 20131113;
+static u32 glcoex_ver_8723b_2ant = 0x3f;
 
 /**************************************************************
  * local function proto type if needed
@@ -303,6 +303,21 @@ static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0xc);
 }
 
+static void btc8723b2ant_query_bt_info(struct btc_coexist *btcoexist)
+{
+	u8 h2c_parameter[1] = {0};
+
+	coex_sta->c2h_bt_info_req_sent = true;
+
+	h2c_parameter[0] |= BIT0;	/* trigger */
+
+	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW_EXEC,
+		  "[BTCoex], Query Bt Info, FW write 0x61 = 0x%x\n",
+		  h2c_parameter[0]);
+
+	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
+}
+
 static bool btc8723b2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 {
 	static bool pre_wifi_busy;
@@ -604,7 +619,7 @@ static bool btc8723b_need_dec_pwr(struct btc_coexist *btcoexist)
 	if (!btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi))
 		return false;
 
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
 
 	if (wifi_connected) {
 		if (bt_hs_on) {
@@ -824,7 +839,6 @@ static void btc8723b2ant_set_sw_fulltime_dac_swing(struct btc_coexist *btcoex,
 		btc8723b2ant_set_dac_swing_reg(btcoex, 0x18);
 }
 
-
 static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
 				   bool force_exec, bool dac_swing_on,
 				   u32 dac_swing_lvl)
@@ -884,7 +898,6 @@ static void btc8723b2ant_set_agc_table(struct btc_coexist *btcoexist,
 		btcoexist->btc_write_4byte(btcoexist, 0xc78, 0xa4200001);
 	}
 
-
 	/* RF Gain */
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0xef, 0xfffff, 0x02000);
 	if (agc_table_en) {
@@ -1160,8 +1173,87 @@ static void btc8723b2ant_sw_mechanism2(struct btc_coexist *btcoexist,
 			       dac_swing_lvl);
 }
 
+static void btc8723b2ant_set_ant_path(struct btc_coexist *btcoexist,
+				      u8 antpos_type, bool init_hwcfg,
+				      bool wifi_off)
+{
+	struct btc_board_info *board_info = &btcoexist->board_info;
+	u32 fw_ver = 0, u32tmp = 0;
+	bool pg_ext_switch = false;
+	bool use_ext_switch = false;
+	u8 h2c_parameter[2] = {0};
+
+	btcoexist->btc_get(btcoexist, BTC_GET_BL_EXT_SWITCH, &pg_ext_switch);
+	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
+
+	if ((fw_ver < 0xc0000) || pg_ext_switch)
+		use_ext_switch = true;
+
+	if (init_hwcfg) {
+		/* 0x4c[23] = 0, 0x4c[24] = 1  Antenna control by WL/BT */
+		u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
+		u32tmp &= ~BIT23;
+		u32tmp |= BIT24;
+		btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
+
+		btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x944, 0x3, 0x3);
+		btcoexist->btc_write_1byte(btcoexist, 0x930, 0x77);
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, 0x20, 0x1);
+
+		/* Force GNT_BT to low */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x0);
+		btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
+
+		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
+			/* tell firmware "no antenna inverse" */
+			h2c_parameter[0] = 0;
+			h2c_parameter[1] = 1;  /* ext switch type */
+			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
+						h2c_parameter);
+		} else {
+			/* tell firmware "antenna inverse" */
+			h2c_parameter[0] = 1;
+			h2c_parameter[1] = 1;  /* ext switch type */
+			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
+						h2c_parameter);
+		}
+	}
+
+	/* ext switch setting */
+	if (use_ext_switch) {
+		/* fixed internal switch S1->WiFi, S0->BT */
+		btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
+		switch (antpos_type) {
+		case BTC_ANT_WIFI_AT_MAIN:
+			/* ext switch main at wifi */
+			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c,
+							   0x3, 0x1);
+			break;
+		case BTC_ANT_WIFI_AT_AUX:
+			/* ext switch aux at wifi */
+			btcoexist->btc_write_1byte_bitmask(btcoexist,
+							   0x92c, 0x3, 0x2);
+			break;
+		}
+	} else {	/* internal switch */
+		/* fixed ext switch */
+		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c, 0x3, 0x1);
+		switch (antpos_type) {
+		case BTC_ANT_WIFI_AT_MAIN:
+			/* fixed internal switch S1->WiFi, S0->BT */
+			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
+			break;
+		case BTC_ANT_WIFI_AT_AUX:
+			/* fixed internal switch S0->WiFi, S1->BT */
+			btcoexist->btc_write_2byte(btcoexist, 0x948, 0x280);
+			break;
+		}
+	}
+}
+
 static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
-			     bool turn_on, u8 type)
+				 bool turn_on, u8 type)
 {
 	BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE_FW,
 		  "[BTCoex], %s turn %s PS TDMA, type=%d\n",
@@ -1351,7 +1443,8 @@ static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 	coex_dm->need_recover_0x948 = true;
 	coex_dm->backup_0x948 = btcoexist->btc_read_2byte(btcoexist, 0x948);
 
-	btcoexist->btc_write_2byte(btcoexist, 0x948, 0x280);
+	btc8723b2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_AUX,
+				  false, false);
 }
 
 static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
@@ -1520,7 +1613,9 @@ static void set_tdma_int1(struct btc_coexist *btcoexist, bool tx_pause,
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 					     true, 8);
 			coex_dm->tdma_adj_type = 8;
-		} else if (coex_dm->cur_ps_tdma == 9) {
+		}
+
+		if (coex_dm->cur_ps_tdma == 9) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 					     true, 13);
 			coex_dm->tdma_adj_type = 13;
@@ -1607,7 +1702,9 @@ static void set_tdma_int1(struct btc_coexist *btcoexist, bool tx_pause,
 		} else if (coex_dm->cur_ps_tdma == 8) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 4);
 			coex_dm->tdma_adj_type = 4;
-		} else if (coex_dm->cur_ps_tdma == 13) {
+		}
+
+		if (coex_dm->cur_ps_tdma == 13) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 9);
 			coex_dm->tdma_adj_type = 9;
 		} else if (coex_dm->cur_ps_tdma == 14) {
@@ -1652,23 +1749,34 @@ static void set_tdma_int1(struct btc_coexist *btcoexist, bool tx_pause,
 				coex_dm->tdma_adj_type = 12;
 			}
 		}  else if (result == 1) {
-			int tmp = coex_dm->cur_ps_tdma;
-			switch (tmp) {
-			case 4:
-			case 3:
-			case 2:
-			case 12:
-			case 11:
-			case 10:
-				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
-						     true, tmp - 1);
-				coex_dm->tdma_adj_type = tmp - 1;
-				break;
-			case 1:
+			if (coex_dm->cur_ps_tdma == 4) {
+				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						     true, 3);
+				coex_dm->tdma_adj_type = 3;
+			} else if (coex_dm->cur_ps_tdma == 3) {
+				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						     true, 2);
+				coex_dm->tdma_adj_type = 2;
+			} else if (coex_dm->cur_ps_tdma == 2) {
+				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						     true, 1);
+				coex_dm->tdma_adj_type = 1;
+			} else if (coex_dm->cur_ps_tdma == 1) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 71);
 				coex_dm->tdma_adj_type = 71;
-				break;
+			} else if (coex_dm->cur_ps_tdma == 12) {
+				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						     true, 11);
+				coex_dm->tdma_adj_type = 11;
+			} else if (coex_dm->cur_ps_tdma == 11) {
+				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						     true, 10);
+				coex_dm->tdma_adj_type = 10;
+			} else if (coex_dm->cur_ps_tdma == 10) {
+				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
+						     true, 9);
+				coex_dm->tdma_adj_type = 9;
 			}
 		}
 	}
@@ -1694,7 +1802,8 @@ static void set_tdma_int2(struct btc_coexist *btcoexist, bool tx_pause,
 		} else if (coex_dm->cur_ps_tdma == 4) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 8);
 			coex_dm->tdma_adj_type = 8;
-		} else if (coex_dm->cur_ps_tdma == 9) {
+		}
+		if (coex_dm->cur_ps_tdma == 9) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 14);
 			coex_dm->tdma_adj_type = 14;
 		} else if (coex_dm->cur_ps_tdma == 10) {
@@ -1776,7 +1885,8 @@ static void set_tdma_int2(struct btc_coexist *btcoexist, bool tx_pause,
 		} else if (coex_dm->cur_ps_tdma == 8) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 4);
 			coex_dm->tdma_adj_type = 4;
-		} else if (coex_dm->cur_ps_tdma == 13) {
+		}
+		if (coex_dm->cur_ps_tdma == 13) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 10);
 			coex_dm->tdma_adj_type = 10;
 		} else if (coex_dm->cur_ps_tdma == 14) {
@@ -1865,7 +1975,8 @@ static void set_tdma_int3(struct btc_coexist *btcoexist, bool tx_pause,
 		} else if (coex_dm->cur_ps_tdma == 4) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 8);
 			coex_dm->tdma_adj_type = 8;
-		} else if (coex_dm->cur_ps_tdma == 9) {
+		}
+		if (coex_dm->cur_ps_tdma == 9) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 15);
 			coex_dm->tdma_adj_type = 15;
 		} else if (coex_dm->cur_ps_tdma == 10) {
@@ -1935,101 +2046,80 @@ static void set_tdma_int3(struct btc_coexist *btcoexist, bool tx_pause,
 		BTC_PRINT(BTC_MSG_ALGORITHM,
 			  ALGO_TRACE_FW_DETAIL,
 			  "[BTCoex], TxPause = 0\n");
-		switch (coex_dm->cur_ps_tdma) {
-		case 5:
+		if (coex_dm->cur_ps_tdma == 5) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 			coex_dm->tdma_adj_type = 3;
-			break;
-		case 6:
+		} else if (coex_dm->cur_ps_tdma == 6) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 			coex_dm->tdma_adj_type = 3;
-			break;
-		case 7:
+		} else if (coex_dm->cur_ps_tdma == 7) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 3);
 			coex_dm->tdma_adj_type = 3;
-			break;
-		case 8:
+		} else if (coex_dm->cur_ps_tdma == 8) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 4);
 			coex_dm->tdma_adj_type = 4;
-			break;
-		case 13:
+		}
+		if (coex_dm->cur_ps_tdma == 13) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
 			coex_dm->tdma_adj_type = 11;
-			break;
-		case 14:
+		} else if (coex_dm->cur_ps_tdma == 14) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
 			coex_dm->tdma_adj_type = 11;
-			break;
-		case 15:
+		} else if (coex_dm->cur_ps_tdma == 15) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 11);
 			coex_dm->tdma_adj_type = 11;
-			break;
-		case 16:
+		} else if (coex_dm->cur_ps_tdma == 16) {
 			btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, true, 12);
 			coex_dm->tdma_adj_type = 12;
-			break;
 		}
 		if (result == -1) {
-			switch (coex_dm->cur_ps_tdma) {
-			case 1:
+			if (coex_dm->cur_ps_tdma == 1) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 3);
 				coex_dm->tdma_adj_type = 3;
-				break;
-			case 2:
+			} else if (coex_dm->cur_ps_tdma == 2) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 3);
 				coex_dm->tdma_adj_type = 3;
-				break;
-			case 3:
+			} else if (coex_dm->cur_ps_tdma == 3) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 4);
 				coex_dm->tdma_adj_type = 4;
-				break;
-			case 9:
+			} else if (coex_dm->cur_ps_tdma == 9) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 11);
 				coex_dm->tdma_adj_type = 11;
-				break;
-			case 10:
+			} else if (coex_dm->cur_ps_tdma == 10) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 11);
 				coex_dm->tdma_adj_type = 11;
-				break;
-			case 11:
+			} else if (coex_dm->cur_ps_tdma == 11) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 12);
 				coex_dm->tdma_adj_type = 12;
-				break;
 			}
 		} else if (result == 1) {
-			switch (coex_dm->cur_ps_tdma) {
-			case 4:
+			if (coex_dm->cur_ps_tdma == 4) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 3);
 				coex_dm->tdma_adj_type = 3;
-				break;
-			case 3:
+			} else if (coex_dm->cur_ps_tdma == 3) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 3);
 				coex_dm->tdma_adj_type = 3;
-				break;
-			case 2:
+			} else if (coex_dm->cur_ps_tdma == 2) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 3);
 				coex_dm->tdma_adj_type = 3;
-				break;
-			case 12:
+			} else if (coex_dm->cur_ps_tdma == 12) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 11);
 				coex_dm->tdma_adj_type = 11;
-				break;
-			case 11:
+			} else if (coex_dm->cur_ps_tdma == 11) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 11);
 				coex_dm->tdma_adj_type = 11;
-				break;
-			case 10:
+			} else if (coex_dm->cur_ps_tdma == 10) {
 				btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC,
 						     true, 11);
 				coex_dm->tdma_adj_type = 11;
@@ -2328,7 +2418,7 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2385,12 +2475,43 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 /*A2DP only / PAN(EDR) only/ A2DP+PAN(HS)*/
 static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
-	u8 wifi_rssi_state, bt_rssi_state;
+	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
+	u8 ap_num = 0;
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+	wifi_rssi_state1 = btc8723b2ant_wifi_rssi_state(btcoexist,
+							1, 2, 40, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
+
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
+
+	/* define the office environment */
+	/* driver don't know AP num in Linux, so we will never enter this if */
+	if (ap_num >= 10 && BTC_RSSI_HIGH(wifi_rssi_state1)) {
+		btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff,
+					  0x0);
+		btc8723b2ant_fw_dac_swing_lvl(btcoexist, NORMAL_EXEC, 6);
+		btc8723b2ant_dec_bt_pwr(btcoexist, NORMAL_EXEC, false);
+		btc8723b_coex_tbl_type(btcoexist, NORMAL_EXEC, 0);
+		btc8723b2ant_ps_tdma(btcoexist, NORMAL_EXEC, false, 1);
+
+		/* sw mechanism */
+		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
+		if (BTC_WIFI_BW_HT40 == wifi_bw) {
+			btc8723b2ant_sw_mechanism1(btcoexist, true, false,
+						   false, false);
+			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
+						   true, 0x18);
+		} else {
+			btc8723b2ant_sw_mechanism1(btcoexist, false, false,
+						   false, false);
+			btc8723b2ant_sw_mechanism2(btcoexist, true, false,
+						   true, 0x18);
+		}
+		return;
+	}
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2501,7 +2622,7 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2612,7 +2733,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2676,7 +2797,7 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
 
 	if (btc8723b_need_dec_pwr(btcoexist))
@@ -2746,7 +2867,7 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
 						       0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2809,8 +2930,8 @@ static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 	u32 wifi_bw;
 
 	wifi_rssi_state = btc8723b2ant_wifi_rssi_state(btcoexist,
-							  0, 2, 15, 0);
-	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 35, 0);
+						       0, 2, 15, 0);
+	bt_rssi_state = btc8723b2ant_bt_rssi_state(2, 29, 0);
 
 	btcoexist->btc_set_rf_reg(btcoexist, BTC_RF_A, 0x1, 0xfffff, 0x0);
 
@@ -2982,7 +3103,15 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 	}
 }
 
-
+static void btc8723b2ant_wifioff_hwcfg(struct btc_coexist *btcoexist)
+{
+	/* set wlan_act to low */
+	btcoexist->btc_write_1byte(btcoexist, 0x76e, 0x4);
+	/* Force GNT_BT to High */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x3);
+	/* BT select s0/s1 is controlled by BT */
+	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, 0x20, 0x0);
+}
 
 /*********************************************************************
  *  work around function start with wa_btc8723b2ant_
@@ -2990,98 +3119,24 @@ static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 /*********************************************************************
  *  extern function start with EXbtc8723b2ant_
  *********************************************************************/
-void ex_halbtc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
+void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
-	struct btc_board_info *board_info = &btcoexist->board_info;
-	u32 u32tmp = 0, fw_ver;
 	u8 u8tmp = 0;
-	u8 h2c_parameter[2] = {0};
-
 
 	BTC_PRINT(BTC_MSG_INTERFACE, INTF_INIT,
 		  "[BTCoex], 2Ant Init HW Config!!\n");
+	coex_dm->bt_rf0x1e_backup =
+		btcoexist->btc_get_rf_reg(btcoexist, BTC_RF_A, 0x1e, 0xfffff);
 
-	/* backup rf 0x1e value */
-	coex_dm->bt_rf0x1e_backup = btcoexist->btc_get_rf_reg(btcoexist,
-							      BTC_RF_A, 0x1e,
-							      0xfffff);
-
-	/* 0x4c[23]=0, 0x4c[24]=1  Antenna control by WL/BT */
-	u32tmp = btcoexist->btc_read_4byte(btcoexist, 0x4c);
-	u32tmp &= ~BIT23;
-	u32tmp |= BIT24;
-	btcoexist->btc_write_4byte(btcoexist, 0x4c, u32tmp);
-
-	btcoexist->btc_write_1byte(btcoexist, 0x974, 0xff);
-	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x944, 0x3, 0x3);
-	btcoexist->btc_write_1byte(btcoexist, 0x930, 0x77);
-	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x67, 0x20, 0x1);
-
-	/* Antenna switch control parameter */
-	/* btcoexist->btc_write_4byte(btcoexist, 0x858, 0x55555555);*/
-
-	/*Force GNT_BT to low*/
-	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x765, 0x18, 0x0);
-	btcoexist->btc_write_2byte(btcoexist, 0x948, 0x0);
-
-	/* 0x790[5:0]=0x5 */
+	/* 0x790[5:0] = 0x5 */
 	u8tmp = btcoexist->btc_read_1byte(btcoexist, 0x790);
 	u8tmp &= 0xc0;
 	u8tmp |= 0x5;
 	btcoexist->btc_write_1byte(btcoexist, 0x790, u8tmp);
 
-
-	/*Antenna config	*/
-	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-
- /*ext switch for fw ver < 0xc */
-	if (fw_ver < 0xc00) {
-		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c,
-							   0x3, 0x1);
-			/*Main Ant to  BT for IPS case 0x4c[23]=1*/
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64, 0x1,
-							   0x1);
-
-			/*tell firmware "no antenna inverse"*/
-			h2c_parameter[0] = 0;
-			h2c_parameter[1] = 1;  /* ext switch type */
-			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
-						h2c_parameter);
-		} else {
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c,
-							   0x3, 0x2);
-			/*Aux Ant to  BT for IPS case 0x4c[23]=1*/
-			btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64, 0x1,
-							   0x0);
-
-			/*tell firmware "antenna inverse"*/
-			h2c_parameter[0] = 1;
-			h2c_parameter[1] = 1;  /*ext switch type*/
-			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
-						h2c_parameter);
-		}
-	} else {
-		/*ext switch always at s1 (if exist) */
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x92c, 0x3, 0x1);
-		/*Main Ant to  BT for IPS case 0x4c[23]=1*/
-		btcoexist->btc_write_1byte_bitmask(btcoexist, 0x64, 0x1, 0x1);
-
-		if (board_info->btdm_ant_pos == BTC_ANTENNA_AT_MAIN_PORT) {
-			/*tell firmware "no antenna inverse"*/
-			h2c_parameter[0] = 0;
-			h2c_parameter[1] = 0;  /*ext switch type*/
-			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
-						h2c_parameter);
-		} else {
-			/*tell firmware "antenna inverse"*/
-			h2c_parameter[0] = 1;
-			h2c_parameter[1] = 0;  /*ext switch type*/
-			btcoexist->btc_fill_h2c(btcoexist, 0x65, 2,
-						h2c_parameter);
-		}
-	}
-
+	/*Antenna config */
+	btc8723b2ant_set_ant_path(btcoexist, BTC_ANT_WIFI_AT_MAIN,
+				  true, false);
 	/* PTA parameter */
 	btc8723b_coex_tbl_type(btcoexist, FORCE_EXEC, 0);
 
@@ -3092,14 +3147,14 @@ void ex_halbtc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 	btcoexist->btc_write_1byte_bitmask(btcoexist, 0x40, 0x20, 0x1);
 }
 
-void ex_halbtc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
+void ex_btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	BTC_PRINT(BTC_MSG_INTERFACE, INTF_INIT,
 		  "[BTCoex], Coex Mechanism Init!!\n");
 	btc8723b2ant_init_coex_dm(btcoexist);
 }
 
-void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
+void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
@@ -3114,6 +3169,7 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	u32 wifi_bw, wifi_traffic_dir, fa_ofdm, fa_cck;
 	u8 wifi_dot11_chnl, wifi_hs_chnl;
 	u32 fw_ver = 0, bt_patch_ver = 0;
+	u8 ap_num = 0;
 
 	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE,
 		   "\r\n ============[BT Coexist info]============");
@@ -3171,8 +3227,9 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifi_rssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
-	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d",
-		   "Wifi rssi/ HS rssi", wifi_rssi, bt_hs_rssi);
+	btcoexist->btc_get(btcoexist, BTC_GET_U1_AP_NUM, &ap_num);
+	CL_SPRINTF(cli_buf, BT_TMP_BUF_SIZE, "\r\n %-35s = %d/ %d/ %d",
+		   "Wifi rssi/ HS rssi/ AP#", wifi_rssi, bt_hs_rssi, ap_num);
 	CL_PRINTF(cli_buf);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
@@ -3301,7 +3358,6 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 		   u32tmp[0]&0x3, u32tmp[1]&0xff, u32tmp[2]&0x3);
 	CL_PRINTF(cli_buf);
 
-
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x39);
 	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x40);
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x4c);
@@ -3371,22 +3427,26 @@ void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist)
 	BTC_DBG_DISP_COEX_STATISTICS);
 }
 
-
-void ex_halbtc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	if (BTC_IPS_ENTER == type) {
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
 			  "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
+		btc8723b2ant_wifioff_hwcfg(btcoexist);
+		btc8723b2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
 		btc8723b2ant_coex_alloff(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
 			  "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
+		ex_btc8723b2ant_init_hwconfig(btcoexist);
+		btc8723b2ant_init_coex_dm(btcoexist);
+		btc8723b2ant_query_bt_info(btcoexist);
 	}
 }
 
-void ex_halbtc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	if (BTC_LPS_ENABLE == type) {
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
@@ -3399,7 +3459,7 @@ void ex_halbtc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 	}
 }
 
-void ex_halbtc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	if (BTC_SCAN_START == type)
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
@@ -3409,7 +3469,7 @@ void ex_halbtc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 			  "[BTCoex], SCAN FINISH notify\n");
 }
 
-void ex_halbtc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
+void ex_btc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	if (BTC_ASSOCIATE_START == type)
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
@@ -3419,8 +3479,8 @@ void ex_halbtc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 			  "[BTCoex], CONNECT FINISH notify\n");
 }
 
-void btc8723b_med_stat_notify(struct btc_coexist *btcoexist,
-					    u8 type)
+void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type)
 {
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
@@ -3460,16 +3520,16 @@ void btc8723b_med_stat_notify(struct btc_coexist *btcoexist,
 	btcoexist->btc_fill_h2c(btcoexist, 0x66, 3, h2c_parameter);
 }
 
-void ex_halbtc8723b2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type)
+void ex_btc8723b2ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type)
 {
 	if (type == BTC_PACKET_DHCP)
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
 			  "[BTCoex], DHCP Packet notify\n");
 }
 
-void ex_halbtc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpbuf, u8 length)
+void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmpbuf, u8 length)
 {
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
@@ -3516,7 +3576,7 @@ void ex_halbtc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			coex_sta->bt_info_c2h[rsp_source][4];
 
 		/* Here we need to resend some wifi info to BT
-		 * because bt is reset and loss of the info.
+		     because bt is reset and loss of the info.
 		 */
 		if ((coex_sta->bt_info_ext & BIT1)) {
 			BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE,
@@ -3525,11 +3585,13 @@ void ex_halbtc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 			btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
 					   &wifi_connected);
 			if (wifi_connected)
-				btc8723b_med_stat_notify(btcoexist,
-							 BTC_MEDIA_CONNECT);
+				ex_btc8723b2ant_media_status_notify(
+							btcoexist,
+							BTC_MEDIA_CONNECT);
 			else
-				btc8723b_med_stat_notify(btcoexist,
-							 BTC_MEDIA_DISCONNECT);
+				ex_btc8723b2ant_media_status_notify(
+							btcoexist,
+							BTC_MEDIA_DISCONNECT);
 		}
 
 		if ((coex_sta->bt_info_ext & BIT3)) {
@@ -3564,7 +3626,7 @@ void ex_halbtc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_sta->a2dp_exist = false;
 		coex_sta->hid_exist = false;
 		coex_sta->sco_exist = false;
-	} else { /*  connection exists */
+	} else { /* connection exists */
 		coex_sta->bt_link_exist = true;
 		if (bt_info & BT_INFO_8723B_2ANT_B_FTP)
 			coex_sta->pan_exist = true;
@@ -3601,7 +3663,7 @@ void ex_halbtc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		coex_dm->bt_status = BT_8723B_2ANT_BT_STATUS_SCO_BUSY;
 		BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE,
 			  "[BTCoex], BtInfoNotify(), BT SCO busy!!!\n");
-	} else if (bt_info & BT_INFO_8723B_2ANT_B_ACL_BUSY) {
+	} else if (bt_info&BT_INFO_8723B_2ANT_B_ACL_BUSY) {
 		coex_dm->bt_status = BT_8723B_2ANT_BT_STATUS_ACL_BUSY;
 		BTC_PRINT(BTC_MSG_ALGORITHM, ALGO_TRACE,
 			  "[BTCoex], BtInfoNotify(), BT ACL busy!!!\n");
@@ -3630,26 +3692,16 @@ void ex_halbtc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 	btc8723b2ant_run_coexist_mechanism(btcoexist);
 }
 
-void ex_halbtc8723b2ant_stack_operation_notify(struct btc_coexist *btcoexist,
-					       u8 type)
-{
-	if (BTC_STACK_OP_INQ_PAGE_PAIR_START == type)
-		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
-			  "[BTCoex],StackOP Inquiry/page/pair start notify\n");
-	else if (BTC_STACK_OP_INQ_PAGE_PAIR_FINISH == type)
-		BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY,
-			  "[BTCoex],StackOP Inquiry/page/pair finish notify\n");
-}
-
-void ex_halbtc8723b2ant_halt_notify(struct btc_coexist *btcoexist)
+void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist)
 {
 	BTC_PRINT(BTC_MSG_INTERFACE, INTF_NOTIFY, "[BTCoex], Halt notify\n");
 
+	btc8723b2ant_wifioff_hwcfg(btcoexist);
 	btc8723b2ant_ignore_wlan_act(btcoexist, FORCE_EXEC, true);
-	btc8723b_med_stat_notify(btcoexist, BTC_MEDIA_DISCONNECT);
+	ex_btc8723b2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
 }
 
-void ex_halbtc8723b2ant_periodical(struct btc_coexist *btcoexist)
+void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
@@ -3677,8 +3729,7 @@ void ex_halbtc8723b2ant_periodical(struct btc_coexist *btcoexist)
 				   &bt_patch_ver);
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_INIT,
-			  "[BTCoex], CoexVer/ FwVer/ PatchVer = "
-			  "%d_%x/ 0x%x/ 0x%x(%d)\n",
+			  "[BTCoex], CoexVer/ fw_ver/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
 			  glcoex_ver_date_8723b_2ant, glcoex_ver_8723b_2ant,
 			  fw_ver, bt_patch_ver, bt_patch_ver);
 		BTC_PRINT(BTC_MSG_INTERFACE, INTF_INIT,
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h
index e0ad8e5..567f354 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtc8723b2ant.h
@@ -153,21 +153,20 @@ struct coex_sta_8723b_2ant {
 /*********************************************************************
  * The following is interface which will notify coex module.
  *********************************************************************/
-void ex_halbtc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist);
-void ex_halbtc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist);
-void ex_halbtc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
-void btc8723b_med_stat_notify(struct btc_coexist *btcoexist, u8 type);
-void ex_halbtc8723b2ant_special_packet_notify(struct btc_coexist *btcoexist,
-					      u8 type);
-void ex_halbtc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
-				       u8 *tmpbuf, u8 length);
-void ex_halbtc8723b2ant_stack_operation_notify(struct btc_coexist *btcoexist,
-					       u8 type);
-void ex_halbtc8723b2ant_halt_notify(struct btc_coexist *btcoexist);
-void ex_halbtc8723b2ant_periodical(struct btc_coexist *btcoexist);
-void ex_halbtc8723b2ant_display_coex_info(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type);
+void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
+					 u8 type);
+void ex_btc8723b2ant_special_packet_notify(struct btc_coexist *btcoexist,
+					   u8 type);
+void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
+				    u8 *tmpbuf, u8 length);
+void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist);
+void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist);
 
 #endif
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
index d4bd550..9b9d09a 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -672,7 +672,7 @@ void exhalbtc_init_hw_config(struct btc_coexist *btcoexist)
 	btcoexist->statistics.cnt_init_hw_config++;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_init_hwconfig(btcoexist);
+		ex_btc8723b2ant_init_hwconfig(btcoexist);
 }
 
 void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
@@ -686,7 +686,7 @@ void exhalbtc_init_coex_dm(struct btc_coexist *btcoexist)
 	btcoexist->statistics.cnt_init_coex_dm++;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_init_coex_dm(btcoexist);
+		ex_btc8723b2ant_init_coex_dm(btcoexist);
 
 	btcoexist->initilized = true;
 }
@@ -711,7 +711,7 @@ void exhalbtc_ips_notify(struct btc_coexist *btcoexist, u8 type)
 	halbtc_leave_low_power();
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_ips_notify(btcoexist, ips_type);
+		ex_btc8723b2ant_ips_notify(btcoexist, ips_type);
 
 	halbtc_nomal_low_power();
 }
@@ -734,7 +734,7 @@ void exhalbtc_lps_notify(struct btc_coexist *btcoexist, u8 type)
 		lps_type = BTC_LPS_ENABLE;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_lps_notify(btcoexist, lps_type);
+		ex_btc8723b2ant_lps_notify(btcoexist, lps_type);
 }
 
 void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
@@ -757,7 +757,7 @@ void exhalbtc_scan_notify(struct btc_coexist *btcoexist, u8 type)
 	halbtc_leave_low_power();
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_scan_notify(btcoexist, scan_type);
+		ex_btc8723b2ant_scan_notify(btcoexist, scan_type);
 
 	halbtc_nomal_low_power();
 }
@@ -782,7 +782,7 @@ void exhalbtc_connect_notify(struct btc_coexist *btcoexist, u8 action)
 	halbtc_leave_low_power();
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_connect_notify(btcoexist, asso_type);
+		ex_btc8723b2ant_connect_notify(btcoexist, asso_type);
 }
 
 void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
@@ -805,9 +805,6 @@ void exhalbtc_mediastatus_notify(struct btc_coexist *btcoexist,
 
 	halbtc_leave_low_power();
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		btc8723b_med_stat_notify(btcoexist, status);
-
 	halbtc_nomal_low_power();
 }
 
@@ -828,8 +825,8 @@ void exhalbtc_special_packet_notify(struct btc_coexist *btcoexist, u8 pkt_type)
 	halbtc_leave_low_power();
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_special_packet_notify(btcoexist,
-							 packet_type);
+		ex_btc8723b2ant_special_packet_notify(btcoexist,
+						      packet_type);
 
 	halbtc_nomal_low_power();
 }
@@ -844,7 +841,7 @@ void exhalbtc_bt_info_notify(struct btc_coexist *btcoexist,
 	btcoexist->statistics.cnt_bt_info_notify++;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_bt_info_notify(btcoexist, tmp_buf, length);
+		ex_btc8723b2ant_bt_info_notify(btcoexist, tmp_buf, length);
 }
 
 void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
@@ -863,10 +860,6 @@ void exhalbtc_stack_operation_notify(struct btc_coexist *btcoexist, u8 type)
 
 	halbtc_leave_low_power();
 
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_stack_operation_notify(btcoexist,
-							  stack_op_type);
-
 	halbtc_nomal_low_power();
 }
 
@@ -878,7 +871,7 @@ void exhalbtc_halt_notify(struct btc_coexist *btcoexist)
 		return;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_halt_notify(btcoexist);
+		ex_btc8723b2ant_halt_notify(btcoexist);
 }
 
 void exhalbtc_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
@@ -898,7 +891,7 @@ void exhalbtc_periodical(struct btc_coexist *btcoexist)
 	halbtc_leave_low_power();
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_periodical(btcoexist);
+		ex_btc8723b2ant_periodical(btcoexist);
 
 	halbtc_nomal_low_power();
 }
@@ -997,5 +990,5 @@ void exhalbtc_display_bt_coex_info(struct btc_coexist *btcoexist)
 		return;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8723BE)
-		ex_halbtc8723b2ant_display_coex_info(btcoexist);
+		ex_btc8723b2ant_display_coex_info(btcoexist);
 }
diff --git a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
index 049f4c8..e90af4b 100644
--- a/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -55,6 +55,17 @@
 #define		BTC_RATE_DISABLE			0
 #define		BTC_RATE_ENABLE				1
 
+/* single Antenna definition */
+#define		BTC_ANT_PATH_WIFI			0
+#define		BTC_ANT_PATH_BT				1
+#define		BTC_ANT_PATH_PTA			2
+/* dual Antenna definition */
+#define		BTC_ANT_WIFI_AT_MAIN			0
+#define		BTC_ANT_WIFI_AT_AUX			1
+/* coupler Antenna definition */
+#define		BTC_ANT_WIFI_AT_CPL_MAIN		0
+#define		BTC_ANT_WIFI_AT_CPL_AUX			1
+
 #define		BTC_ANT_PATH_WIFI			0
 #define		BTC_ANT_PATH_BT				1
 #define		BTC_ANT_PATH_PTA			2
@@ -164,6 +175,16 @@ extern u32 btc_dbg_type[];
 #define BTC_ANT_PATH_BT		1
 #define BTC_ANT_PATH_PTA	2
 
+#define	BTC_RSSI_HIGH(_rssi_)	\
+	((_rssi_ == BTC_RSSI_STATE_HIGH ||	\
+	  _rssi_ == BTC_RSSI_STATE_STAY_HIGH) ? true : false)
+#define	BTC_RSSI_MEDIUM(_rssi_)	\
+	((_rssi_ == BTC_RSSI_STATE_MEDIUM ||	\
+	  _rssi_ == BTC_RSSI_STATE_STAY_MEDIUM) ? true : false)
+#define	BTC_RSSI_LOW(_rssi_)	\
+	((_rssi_ == BTC_RSSI_STATE_LOW ||	\
+	  _rssi_ == BTC_RSSI_STATE_STAY_LOW) ? true : false)
+
 enum btc_power_save_type {
 	BTC_PS_WIFI_NATIVE = 0,
 	BTC_PS_LPS_ON = 1,
@@ -260,6 +281,7 @@ enum btc_get_type {
 	BTC_GET_U1_WIFI_CENTRAL_CHNL,
 	BTC_GET_U1_WIFI_HS_CHNL,
 	BTC_GET_U1_MAC_PHY_MODE,
+	BTC_GET_U1_AP_NUM,
 
 	/* for 1Ant */
 	BTC_GET_U1_LPS_MODE,
-- 
1.8.4.5

