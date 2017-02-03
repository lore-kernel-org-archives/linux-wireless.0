Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35921 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdBCRfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 12:35:34 -0500
Received: by mail-oi0-f66.google.com with SMTP id u143so1898132oif.3
        for <linux-wireless@vger.kernel.org>; Fri, 03 Feb 2017 09:35:34 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 2/7] rtlwifi: btcoexist: Convert halbtc8192e2ant.c to use standard debugging
Date: Fri,  3 Feb 2017 11:35:16 -0600
Message-Id: <20170203173521.6635-3-Larry.Finger@lwfinger.net> (sfid-20170203_183552_932481_B292A316)
In-Reply-To: <20170203173521.6635-1-Larry.Finger@lwfinger.net>
References: <20170203173521.6635-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routines in btcoexist use different debugging routines than are used
in the other drivers. This patch converts halbtc8192e2ant.c to use the
standard routines.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
v2 - No change
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 237 +++++++++++----------
 1 file changed, 126 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index 6a42159..ffa1f43 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -758,13 +758,13 @@ static void halbtc8192e2ant_dec_btpwr(struct btc_coexist *btcoexist,
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s Dec BT power level = %d\n",
-		    (force_exec ? "force to" : ""), dec_btpwr_lvl);
+		 force_exec ? "force to" : "", dec_btpwr_lvl);
 	coex_dm->cur_dec_bt_pwr = dec_btpwr_lvl;
 
 	if (!force_exec) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 			 "[BTCoex], preBtDecPwrLvl=%d, curBtDecPwrLvl=%d\n",
-			    coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
+			 coex_dm->pre_dec_bt_pwr, coex_dm->cur_dec_bt_pwr);
 	}
 	halbtc8192e2ant_set_fwdec_btpwr(btcoexist, coex_dm->cur_dec_bt_pwr);
 
@@ -3174,11 +3174,12 @@ static void halbtc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 static void halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
 					  bool backup)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
 	u16 u16tmp = 0;
 	u8 u8tmp = 0;
 
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], 2Ant Init HW Config!!\n");
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], 2Ant Init HW Config!!\n");
 
 	if (backup) {
 		/* backup rf 0x1e value */
@@ -3261,8 +3262,10 @@ void ex_halbtc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist)
 
 void ex_halbtc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_INIT,
-		      "[BTCoex], Coex Mechanism Init!!\n");
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Coex Mechanism Init!!\n");
 	halbtc8192e2ant_init_coex_dm(btcoexist);
 }
 
@@ -3282,13 +3285,13 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 	u32 fw_ver = 0, bt_patch_ver = 0;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n ============[BT Coexist info]============");
+		 "\r\n ============[BT Coexist info]============");
 
 	if (btcoexist->manual_control) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ===========[Under Manual Control]===========");
+			 "\r\n ===========[Under Manual Control]===========");
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-			   "\r\n ==========================================");
+			 "\r\n ==========================================");
 	}
 
 	if (!board_info->bt_exist) {
@@ -3297,43 +3300,43 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 	}
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d/ %d ", "Ant PG number/ Ant mechanism:",
+		 "\r\n %-35s = %d/ %d ", "Ant PG number/ Ant mechanism:",
 		   board_info->pg_ant_num, board_info->btdm_ant_num);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s / %d",
-		   "BT stack/ hci ext ver",
+		 "BT stack/ hci ext ver",
 		   ((stack_info->profile_notified) ? "Yes" : "No"),
 		   stack_info->hci_version);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER, &bt_patch_ver);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %d_%d/ 0x%x/ 0x%x(%d)",
-		   "CoexVer/ FwVer/ PatchVer",
-		   glcoex_ver_date_8192e_2ant, glcoex_ver_8192e_2ant,
-		   fw_ver, bt_patch_ver, bt_patch_ver);
+		 "\r\n %-35s = %d_%d/ 0x%x/ 0x%x(%d)",
+		 "CoexVer/ FwVer/ PatchVer",
+		 glcoex_ver_date_8192e_2ant, glcoex_ver_8192e_2ant,
+		 fw_ver, bt_patch_ver, bt_patch_ver);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_HS_OPERATION, &bt_hson);
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_DOT11_CHNL,
 			   &wifi_dot11_chnl);
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_HS_CHNL, &wifi_hs_chnl);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d(%d)",
-		   "Dot11 channel / HsMode(HsChnl)",
-		   wifi_dot11_chnl, bt_hson, wifi_hs_chnl);
+		 "Dot11 channel / HsMode(HsChnl)",
+		 wifi_dot11_chnl, bt_hson, wifi_hs_chnl);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %3ph ",
-		   "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
+		 "H2C Wifi inform bt chnl Info", coex_dm->wifi_chnl_info);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_WIFI_RSSI, &wifirssi);
 	btcoexist->btc_get(btcoexist, BTC_GET_S4_HS_RSSI, &bt_hs_rssi);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "Wifi rssi/ HS rssi", wifirssi, bt_hs_rssi);
+		 "Wifi rssi/ HS rssi", wifirssi, bt_hs_rssi);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_SCAN, &scan);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_LINK, &link);
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_ROAM, &roam);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d ",
-		   "Wifi link/ roam/ scan", link, roam, scan);
+		 "Wifi link/ roam/ scan", link, roam, scan);
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_BW, &wifi_bw);
@@ -3341,7 +3344,7 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 	btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_TRAFFIC_DIRECTION,
 			   &wifi_traffic_dir);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s / %s/ %s ",
-		   "Wifi status", (wifi_under_5g ? "5G" : "2.4G"),
+		 "Wifi status", (wifi_under_5g ? "5G" : "2.4G"),
 		   ((BTC_WIFI_BW_LEGACY == wifi_bw) ? "Legacy" :
 			(((BTC_WIFI_BW_HT40 == wifi_bw) ? "HT40" : "HT20"))),
 		   ((!wifi_busy) ? "idle" :
@@ -3349,7 +3352,7 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 				"uplink" : "downlink")));
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = [%s/ %d/ %d] ",
-		   "BT [status/ rssi/ retryCnt]",
+		 "BT [status/ rssi/ retryCnt]",
 		   ((btcoexist->bt_info.bt_disabled) ? ("disabled") :
 		    ((coex_sta->c2h_bt_inquiry_page) ?
 		     ("inquiry/page scan") :
@@ -3360,127 +3363,127 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 		   coex_sta->bt_rssi, coex_sta->bt_retry_cnt);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d / %d / %d / %d",
-		   "SCO/HID/PAN/A2DP", stack_info->sco_exist,
+		 "SCO/HID/PAN/A2DP", stack_info->sco_exist,
 		   stack_info->hid_exist, stack_info->pan_exist,
 		   stack_info->a2dp_exist);
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_BT_LINK_INFO);
 
 	bt_info_ext = coex_sta->bt_info_ext;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s",
-		   "BT Info A2DP rate",
+		 "BT Info A2DP rate",
 		   (bt_info_ext&BIT0) ? "Basic rate" : "EDR rate");
 
 	for (i = 0; i < BT_INFO_SRC_8192E_2ANT_MAX; i++) {
 		if (coex_sta->bt_info_c2h_cnt[i]) {
 			RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-				   "\r\n %-35s = %7ph(%d)",
-				   GLBtInfoSrc8192e2Ant[i],
-				   coex_sta->bt_info_c2h[i],
-				   coex_sta->bt_info_c2h_cnt[i]);
+				 "\r\n %-35s = %7ph(%d)",
+				 GLBtInfoSrc8192e2Ant[i],
+				 coex_sta->bt_info_c2h[i],
+				 coex_sta->bt_info_c2h_cnt[i]);
 		}
 	}
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %s/%s",
-		   "PS state, IPS/LPS",
-		   ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
-		   ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")));
+		 "PS state, IPS/LPS",
+		 ((coex_sta->under_ips ? "IPS ON" : "IPS OFF")),
+		 ((coex_sta->under_lps ? "LPS ON" : "LPS OFF")));
 	btcoexist->btc_disp_dbg_msg(btcoexist, BTC_DBG_DISP_FW_PWR_MODE_CMD);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x ", "SS Type",
-		   coex_dm->cur_sstype);
+		 coex_dm->cur_sstype);
 
 	/* Sw mechanism	*/
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
-		   "============[Sw mechanism]============");
+		 "============[Sw mechanism]============");
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d ",
-		   "SM1[ShRf/ LpRA/ LimDig]", coex_dm->cur_rf_rx_lpf_shrink,
-		   coex_dm->cur_low_penalty_ra, coex_dm->limited_dig);
+		 "SM1[ShRf/ LpRA/ LimDig]", coex_dm->cur_rf_rx_lpf_shrink,
+		 coex_dm->cur_low_penalty_ra, coex_dm->limited_dig);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d/ %d(0x%x) ",
-		   "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
-		   coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
-		   coex_dm->cur_dac_swing_on, coex_dm->cur_dac_swing_lvl);
+		 "SM2[AgcT/ AdcB/ SwDacSwing(lvl)]",
+		 coex_dm->cur_agc_table_en, coex_dm->cur_adc_back_off,
+		 coex_dm->cur_dac_swing_on, coex_dm->cur_dac_swing_lvl);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x ", "Rate Mask",
-		   btcoexist->bt_info.ra_mask);
+		 btcoexist->bt_info.ra_mask);
 
 	/* Fw mechanism	*/
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
-		   "============[Fw mechanism]============");
+		 "============[Fw mechanism]============");
 
 	ps_tdma_case = coex_dm->cur_ps_tdma;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = %5ph case-%d (auto:%d)",
-		   "PS TDMA", coex_dm->ps_tdma_para,
-		   ps_tdma_case, coex_dm->auto_tdma_adjust);
+		 "\r\n %-35s = %5ph case-%d (auto:%d)",
+		 "PS TDMA", coex_dm->ps_tdma_para,
+		 ps_tdma_case, coex_dm->auto_tdma_adjust);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d ",
-		   "DecBtPwr/ IgnWlanAct",
-		   coex_dm->cur_dec_bt_pwr, coex_dm->cur_ignore_wlan_act);
+		 "DecBtPwr/ IgnWlanAct",
+		 coex_dm->cur_dec_bt_pwr, coex_dm->cur_ignore_wlan_act);
 
 	/* Hw setting */
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s",
-		   "============[Hw setting]============");
+		 "============[Hw setting]============");
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x",
-		   "RF-A, 0x1e initVal", coex_dm->bt_rf0x1e_backup);
+		 "RF-A, 0x1e initVal", coex_dm->bt_rf0x1e_backup);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
-		   "backup ARFR1/ARFR2/RL/AMaxTime", coex_dm->backup_arfr_cnt1,
-		   coex_dm->backup_arfr_cnt2, coex_dm->backup_retrylimit,
-		   coex_dm->backup_ampdu_maxtime);
+		 "backup ARFR1/ARFR2/RL/AMaxTime", coex_dm->backup_arfr_cnt1,
+		 coex_dm->backup_arfr_cnt2, coex_dm->backup_retrylimit,
+		 coex_dm->backup_ampdu_maxtime);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x430);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x434);
 	u16tmp[0] = btcoexist->btc_read_2byte(btcoexist, 0x42a);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x456);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/0x%x/0x%x/0x%x",
-		   "0x430/0x434/0x42a/0x456",
-		   u32tmp[0], u32tmp[1], u16tmp[0], u8tmp[0]);
+		 "0x430/0x434/0x42a/0x456",
+		 u32tmp[0], u32tmp[1], u16tmp[0], u8tmp[0]);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc04);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0xd04);
 	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x90c);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x/ 0x%x",
-		   "0xc04/ 0xd04/ 0x90c", u32tmp[0], u32tmp[1], u32tmp[2]);
+		 "0xc04/ 0xd04/ 0x90c", u32tmp[0], u32tmp[1], u32tmp[2]);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x778);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x", "0x778",
-		   u8tmp[0]);
+		 u8tmp[0]);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x92c);
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x930);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0x92c/ 0x930", (u8tmp[0]), u32tmp[0]);
+		 "0x92c/ 0x930", (u8tmp[0]), u32tmp[0]);
 
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x40);
 	u8tmp[1] = btcoexist->btc_read_1byte(btcoexist, 0x4f);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0x40/ 0x4f", u8tmp[0], u8tmp[1]);
+		 "0x40/ 0x4f", u8tmp[0], u8tmp[1]);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x550);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x522);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x/ 0x%x",
-		   "0x550(bcn ctrl)/0x522", u32tmp[0], u8tmp[0]);
+		 "0x550(bcn ctrl)/0x522", u32tmp[0], u8tmp[0]);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0xc50);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = 0x%x", "0xc50(dig)",
-		   u32tmp[0]);
+		 u32tmp[0]);
 
 	u32tmp[0] = btcoexist->btc_read_4byte(btcoexist, 0x6c0);
 	u32tmp[1] = btcoexist->btc_read_4byte(btcoexist, 0x6c4);
 	u32tmp[2] = btcoexist->btc_read_4byte(btcoexist, 0x6c8);
 	u8tmp[0] = btcoexist->btc_read_1byte(btcoexist, 0x6cc);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
-		   "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
-		   "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
-		   u32tmp[0], u32tmp[1], u32tmp[2], u8tmp[0]);
+		 "\r\n %-35s = 0x%x/ 0x%x/ 0x%x/ 0x%x",
+		 "0x6c0/0x6c4/0x6c8/0x6cc(coexTable)",
+		 u32tmp[0], u32tmp[1], u32tmp[2], u8tmp[0]);
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x770(hp rx[31:16]/tx[15:0])",
-		   coex_sta->high_priority_rx, coex_sta->high_priority_tx);
+		 "0x770(hp rx[31:16]/tx[15:0])",
+		 coex_sta->high_priority_rx, coex_sta->high_priority_tx);
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, "\r\n %-35s = %d/ %d",
-		   "0x774(lp rx[31:16]/tx[15:0])",
-		   coex_sta->low_priority_rx, coex_sta->low_priority_tx);
+		 "0x774(lp rx[31:16]/tx[15:0])",
+		 coex_sta->low_priority_rx, coex_sta->low_priority_tx);
 #if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 1)
 	halbtc8192e2ant_monitor_bt_ctr(btcoexist);
 #endif
@@ -3489,49 +3492,57 @@ void ex_halbtc8192e2ant_display_coex_info(struct btc_coexist *btcoexist)
 
 void ex_halbtc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_IPS_ENTER == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS ENTER notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS ENTER notify\n");
 		coex_sta->under_ips = true;
 		halbtc8192e2ant_coex_alloff(btcoexist);
 	} else if (BTC_IPS_LEAVE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], IPS LEAVE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], IPS LEAVE notify\n");
 		coex_sta->under_ips = false;
 	}
 }
 
 void ex_halbtc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_LPS_ENABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS ENABLE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS ENABLE notify\n");
 		coex_sta->under_lps = true;
 	} else if (BTC_LPS_DISABLE == type) {
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], LPS DISABLE notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], LPS DISABLE notify\n");
 		coex_sta->under_lps = false;
 	}
 }
 
 void ex_halbtc8192e2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_SCAN_START == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN START notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN START notify\n");
 	else if (BTC_SCAN_FINISH == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], SCAN FINISH notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], SCAN FINISH notify\n");
 }
 
 void ex_halbtc8192e2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (BTC_ASSOCIATE_START == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT START notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT START notify\n");
 	else if (BTC_ASSOCIATE_FINISH == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], CONNECT FINISH notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], CONNECT FINISH notify\n");
 }
 
 void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
@@ -3548,11 +3559,11 @@ void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 		return;
 
 	if (BTC_MEDIA_CONNECT == type)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA connect notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], MEDIA connect notify\n");
 	else
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], MEDIA disconnect notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], MEDIA disconnect notify\n");
 
 	/* only 2.4G we need to inform bt the chnl mask */
 	btcoexist->btc_get(btcoexist, BTC_GET_U1_WIFI_CENTRAL_CHNL,
@@ -3583,9 +3594,11 @@ void ex_halbtc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 void ex_halbtc8192e2ant_special_packet_notify(struct btc_coexist *btcoexist,
 					      u8 type)
 {
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
 	if (type == BTC_PACKET_DHCP)
-		btc_iface_dbg(INTF_NOTIFY,
-			      "[BTCoex], DHCP Packet notify\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "[BTCoex], DHCP Packet notify\n");
 }
 
 void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
@@ -3604,19 +3617,19 @@ void ex_halbtc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 		rsp_source = BT_INFO_SRC_8192E_2ANT_WIFI_FW;
 	coex_sta->bt_info_c2h_cnt[rsp_source]++;
 
-	btc_iface_dbg(INTF_NOTIFY,
-		      "[BTCoex], Bt info[%d], length=%d, hex data = [",
-		      rsp_source, length);
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+		 "[BTCoex], Bt info[%d], length=%d, hex data = [",
+		 rsp_source, length);
 	for (i = 0; i < length; i++) {
 		coex_sta->bt_info_c2h[rsp_source][i] = tmp_buf[i];
 		if (i == 1)
 			bt_info = tmp_buf[i];
 		if (i == length-1)
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x]\n", tmp_buf[i]);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x]\n", tmp_buf[i]);
 		else
-			btc_iface_dbg(INTF_NOTIFY,
-				      "0x%02x, ", tmp_buf[i]);
+			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+				 "0x%02x, ", tmp_buf[i]);
 	}
 
 	if (BT_INFO_SRC_8192E_2ANT_WIFI_FW != rsp_source) {
@@ -3755,7 +3768,9 @@ void ex_halbtc8192e2ant_stack_operation_notify(struct btc_coexist *btcoexist,
 
 void ex_halbtc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 {
-	btc_iface_dbg(INTF_NOTIFY, "[BTCoex], Halt notify\n");
+	struct rtl_priv *rtlpriv = btcoexist->adapter;
+
+	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Halt notify\n");
 
 	halbtc8192e2ant_IgnoreWlanAct(btcoexist, FORCE_EXEC, true);
 	ex_halbtc8192e2ant_media_status_notify(btcoexist, BTC_MEDIA_DISCONNECT);
@@ -3773,25 +3788,25 @@ void ex_halbtc8192e2ant_periodical(struct btc_coexist *btcoexist)
 		 "=======================Periodical=======================\n");
 	if (dis_ver_info_cnt <= 5) {
 		dis_ver_info_cnt += 1;
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
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "************************************************\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "Ant PG Num/ Ant Mech/ Ant Pos = %d/ %d/ %d\n",
+			 board_info->pg_ant_num, board_info->btdm_ant_num,
+			 board_info->btdm_ant_pos);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "BT stack/ hci ext ver = %s / %d\n",
+			 ((stack_info->profile_notified) ? "Yes" : "No"),
+			 stack_info->hci_version);
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_BT_PATCH_VER,
 				   &bt_patch_ver);
 		btcoexist->btc_get(btcoexist, BTC_GET_U4_WIFI_FW_VER, &fw_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "CoexVer/ FwVer/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
-			      glcoex_ver_date_8192e_2ant, glcoex_ver_8192e_2ant,
-			      fw_ver, bt_patch_ver, bt_patch_ver);
-		btc_iface_dbg(INTF_INIT,
-			      "************************************************\n");
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "CoexVer/ FwVer/ PatchVer = %d_%x/ 0x%x/ 0x%x(%d)\n",
+			 glcoex_ver_date_8192e_2ant, glcoex_ver_8192e_2ant,
+			 fw_ver, bt_patch_ver, bt_patch_ver);
+		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
+			 "************************************************\n");
 	}
 
 #if (BT_AUTO_REPORT_ONLY_8192E_2ANT == 0)
-- 
2.10.2
