Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:47371 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbeC1H2I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 03:28:08 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 9/9] rtlwifi: btcoex: Remove global variables of chip specific context
Date: Wed, 28 Mar 2018 15:27:41 +0800
Message-ID: <20180328072741.23349-10-pkshih@realtek.com> (sfid-20180328_092817_481185_3C15CF47)
In-Reply-To: <20180328072741.23349-1-pkshih@realtek.com>
References: <20180328072741.23349-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Remove the global varaibles, and use local varialbes that point the fields
defined in 'struct btc_coexist' instead, so it is possible to support
multiple devices.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    | 44 ++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    | 56 +++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    | 57 +++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    | 45 +++++++++-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    | 39 +++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8822b1ant.c    | 78 ++++++++++++++++--
 .../realtek/rtlwifi/btcoexist/halbtc8822b2ant.c    | 95 ++++++++++++++++++++--
 7 files changed, 376 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
index a4704b2fbeb9..b85e42628bac 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c
@@ -25,11 +25,6 @@
 
 #include "halbt_precomp.h"
 
-static struct coex_dm_8192e_2ant glcoex_dm_8192e_2ant;
-static struct coex_dm_8192e_2ant *coex_dm = &glcoex_dm_8192e_2ant;
-static struct coex_sta_8192e_2ant glcoex_sta_8192e_2ant;
-static struct coex_sta_8192e_2ant *coex_sta = &glcoex_sta_8192e_2ant;
-
 static const char *const glbt_info_src_8192e_2ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
@@ -44,6 +39,7 @@ static u8 btc8192e2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 	int bt_rssi = 0;
 	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
@@ -106,6 +102,7 @@ static u8 btc8192e2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 				       u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 	int wifi_rssi = 0;
 	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
@@ -171,6 +168,7 @@ static void btc8192e2ant_monitor_bt_enable_disable(struct btc_coexist
 						   *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 	static bool pre_bt_disabled;
 	static u32 bt_disable_cnt;
 	bool bt_active = true, bt_disabled = false;
@@ -252,6 +250,7 @@ static u32 btc8192e2ant_decide_ra_mask(struct btc_coexist *btcoexist,
 static void btc8192e2ant_update_ra_mask(struct btc_coexist *btcoexist,
 					bool force_exec, u32 dis_rate_mask)
 {
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	coex_dm->cur_ra_mask = dis_rate_mask;
 
 	if (force_exec || (coex_dm->pre_ra_mask != coex_dm->cur_ra_mask))
@@ -263,6 +262,7 @@ static void btc8192e2ant_update_ra_mask(struct btc_coexist *btcoexist,
 static void btc8192e2ant_auto_rate_fallback_retry(struct btc_coexist *btcoexist,
 						  bool force_exec, u8 type)
 {
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	bool wifi_under_b_mode = false;
 
 	coex_dm->cur_arfr_type = type;
@@ -302,6 +302,7 @@ static void btc8192e2ant_auto_rate_fallback_retry(struct btc_coexist *btcoexist,
 static void btc8192e2ant_retry_limit(struct btc_coexist *btcoexist,
 				     bool force_exec, u8 type)
 {
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	coex_dm->cur_retry_limit_type = type;
 
 	if (force_exec || (coex_dm->pre_retry_limit_type !=
@@ -325,6 +326,7 @@ static void btc8192e2ant_retry_limit(struct btc_coexist *btcoexist,
 static void btc8192e2ant_ampdu_maxtime(struct btc_coexist *btcoexist,
 				       bool force_exec, u8 type)
 {
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	coex_dm->cur_ampdu_time_type = type;
 
 	if (force_exec || (coex_dm->pre_ampdu_time_type !=
@@ -350,6 +352,7 @@ static void btc8192e2ant_limited_tx(struct btc_coexist *btcoexist,
 				    u8 arfr_type, u8 retry_limit_type,
 				    u8 ampdu_time_type)
 {
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	u32 dis_ra_mask = 0x0;
 
 	coex_dm->cur_ra_mask_type = ra_mask_type;
@@ -390,6 +393,7 @@ static void btc8192e2ant_limited_rx(struct btc_coexist *btcoexist,
 static void btc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 
@@ -423,6 +427,7 @@ static void btc8192e2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 static void btc8192e2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
@@ -471,6 +476,7 @@ bool btc8192e2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 
 static void btc8192e2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 
@@ -769,6 +775,7 @@ static void btc8192e2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 				    bool force_exec, u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s Dec BT power level = %d\n",
@@ -809,6 +816,7 @@ static void btc8192e2ant_bt_auto_report(struct btc_coexist *btcoexist,
 					bool enable_auto_report)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s BT Auto report = %s\n",
@@ -835,6 +843,7 @@ static void btc8192e2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 fw_dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s set FW Dac Swing level = %d\n",
@@ -862,6 +871,7 @@ static void btc8192e2ant_set_sw_rf_rx_lpf_corner(struct btc_coexist *btcoexist,
 						 bool rx_rf_shrink_on)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	if (rx_rf_shrink_on) {
 		/* Shrink RF Rx LPF corner */
@@ -887,6 +897,7 @@ static void btc8192e2ant_rf_shrink(struct btc_coexist *btcoexist,
 				   bool force_exec, bool rx_rf_shrink_on)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn Rx RF Shrink = %s\n",
@@ -936,6 +947,7 @@ static void btc8192e2ant_dac_swing(struct btc_coexist *btcoexist,
 				   u32 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn DacSwing=%s, dac_swing_lvl = 0x%x\n",
@@ -996,6 +1008,7 @@ static void btc8192e2ant_agc_table(struct btc_coexist *btcoexist,
 				   bool force_exec, bool agc_table_en)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s %s Agc Table\n",
@@ -1045,6 +1058,7 @@ static void btc8192e2ant_coex_table(struct btc_coexist *btcoexist,
 				    u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, ",
@@ -1135,6 +1149,7 @@ static void btc8192e2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					 bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn Ignore WlanAct %s\n",
@@ -1162,6 +1177,7 @@ static void btc8192e2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	u8 h2c_parameter[5] = {0};
 
@@ -1206,6 +1222,7 @@ static void btc8192e2ant_ps_tdma(struct btc_coexist *btcoexist,
 				 bool force_exec, bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn %s PS TDMA, type=%d\n",
@@ -1345,6 +1362,7 @@ static void btc8192e2ant_set_switch_ss_type(struct btc_coexist *btcoexist,
 					    u8 ss_type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	u8 mimops = BTC_MIMO_PS_DYNAMIC;
 	u32 dis_ra_mask = 0x0;
 
@@ -1382,6 +1400,7 @@ static void btc8192e2ant_switch_ss_type(struct btc_coexist *btcoexist,
 					bool force_exec, u8 new_ss_type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s Switch SS Type = %d\n",
@@ -1448,6 +1467,7 @@ static void btc8192e2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 static bool btc8192e2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool common = false, wifi_connected = false, wifi_busy = false;
 	bool bt_hs_on = false, low_pwr_disable = false;
@@ -1588,6 +1608,8 @@ static void btc8192e2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					      u8 max_interval)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	static int up, dn, m, n, wait_cnt;
 	/* 0: no change, +1: increase WiFi duration,
 	 * -1: decrease WiFi duration
@@ -1971,6 +1993,7 @@ static void btc8192e2ant_action_hid(struct btc_coexist *btcoexist)
 static void btc8192e2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	u8 wifi_rssi_state, bt_rssi_state = BTC_RSSI_STATE_HIGH;
 	u32 wifi_bw;
 	bool long_dist = false;
@@ -2482,6 +2505,8 @@ static void btc8192e2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 static void btc8192e2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	u8 algorithm = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2594,6 +2619,7 @@ static void btc8192e2ant_init_hwconfig(struct btc_coexist *btcoexist,
 				       bool backup)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	u16 u16tmp = 0;
 	u8 u8tmp = 0;
 
@@ -2687,6 +2713,8 @@ void ex_btc8192e2ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_btc8192e2ant_display_coex_info(struct btc_coexist *btcoexist,
 				       struct seq_file *m)
 {
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	u8 u8tmp[4], i, bt_info_ext, ps_tdma_case = 0;
@@ -2894,6 +2922,7 @@ void ex_btc8192e2ant_display_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 
 	if (BTC_IPS_ENTER == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2910,6 +2939,7 @@ void ex_btc8192e2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8192e2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
 
 	if (BTC_LPS_ENABLE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -2950,6 +2980,7 @@ void ex_btc8192e2ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_center_chnl;
@@ -3006,6 +3037,8 @@ void ex_btc8192e2ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8192e_2ant *coex_sta = &btcoexist->coex_sta_8192e_2ant;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool bt_busy = false, limited_dig = false;
@@ -3174,6 +3207,7 @@ void ex_btc8192e2ant_halt_notify(struct btc_coexist *btcoexist)
 void ex_btc8192e2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8192e_2ant *coex_dm = &btcoexist->coex_dm_8192e_2ant;
 	static u8 dis_ver_info_cnt;
 	u32 fw_ver = 0, bt_patch_ver = 0;
 	struct btc_board_info *board_info = &btcoexist->board_info;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
index 31b716fa2524..ef63b1e06d37 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b1ant.c
@@ -25,11 +25,6 @@
 
 #include "halbt_precomp.h"
 
-static struct coex_dm_8723b_1ant glcoex_dm_8723b_1ant;
-static struct coex_dm_8723b_1ant *coex_dm = &glcoex_dm_8723b_1ant;
-static struct coex_sta_8723b_1ant glcoex_sta_8723b_1ant;
-static struct coex_sta_8723b_1ant *coex_sta = &glcoex_sta_8723b_1ant;
-
 static const char *const glbt_info_src_8723b_1ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
@@ -42,6 +37,7 @@ static const u32 glcoex_ver_8723b_1ant = 0x47;
 static void halbtc8723b1ant_updatera_mask(struct btc_coexist *btcoexist,
 					  bool force_exec, u32 dis_rate_mask)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	coex_dm->curra_mask = dis_rate_mask;
 
 	if (force_exec || (coex_dm->prera_mask != coex_dm->curra_mask))
@@ -54,6 +50,7 @@ static void halbtc8723b1ant_updatera_mask(struct btc_coexist *btcoexist,
 static void btc8723b1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
 					    bool force_exec, u8 type)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	bool wifi_under_bmode = false;
 
 	coex_dm->cur_arfr_type = type;
@@ -93,6 +90,7 @@ static void btc8723b1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
 static void halbtc8723b1ant_retry_limit(struct btc_coexist *btcoexist,
 					bool force_exec, u8 type)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	coex_dm->cur_retry_limit_type = type;
 
 	if (force_exec || (coex_dm->pre_retry_limit_type !=
@@ -116,6 +114,7 @@ static void halbtc8723b1ant_retry_limit(struct btc_coexist *btcoexist,
 static void halbtc8723b1ant_ampdu_maxtime(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 type)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	coex_dm->cur_ampdu_time_type = type;
 
 	if (force_exec || (coex_dm->pre_ampdu_time_type !=
@@ -190,6 +189,7 @@ static void halbtc8723b1ant_limited_rx(struct btc_coexist *btcoexist,
 
 static void halbtc8723b1ant_query_bt_info(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
@@ -202,6 +202,7 @@ static void halbtc8723b1ant_query_bt_info(struct btc_coexist *btcoexist)
 
 static void halbtc8723b1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0;
 	u32 reg_lp_tx = 0, reg_lp_rx = 0;
@@ -253,6 +254,8 @@ static void halbtc8723b1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void halbtc8723b1ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	s32 wifi_rssi = 0;
 	bool wifi_busy = false, wifi_under_b_mode = false;
 	static u8 cck_lock_counter;
@@ -375,6 +378,7 @@ static bool btc8723b1ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 
 static void halbtc8723b1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 
@@ -439,6 +443,7 @@ static void halbtc8723b1ant_bt_auto_report(struct btc_coexist *btcoexist,
 					   bool force_exec,
 					   bool enable_auto_report)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
@@ -478,6 +483,7 @@ static void btc8723b1ant_set_sw_pen_tx_rate_adapt(struct btc_coexist *btcoexist,
 static void halbtc8723b1ant_low_penalty_ra(struct btc_coexist *btcoexist,
 					   bool force_exec, bool low_penalty_ra)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
@@ -519,6 +525,7 @@ static void halbtc8723b1ant_coex_table(struct btc_coexist *btcoexist,
 				       u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, 0x6c4 = 0x%x, 0x6cc = 0x%x\n",
@@ -548,6 +555,7 @@ static void halbtc8723b1ant_coex_table(struct btc_coexist *btcoexist,
 static void halbtc8723b1ant_coex_table_with_type(struct btc_coexist *btcoexist,
 						 bool force_exec, u8 type)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	coex_sta->coex_table_type = type;
 
 	switch (type) {
@@ -647,6 +655,7 @@ static void halbtc8723b1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					    bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn Ignore WlanAct %s\n",
@@ -673,6 +682,7 @@ static void halbtc8723b1ant_set_fw_ps_tdma(struct btc_coexist *btcoexist,
 					   u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	u8 h2c_parameter[5] = {0};
 	u8 real_byte1 = byte1, real_byte5 = byte5;
 	bool ap_enable = false;
@@ -730,6 +740,7 @@ static void halbtc8723b1ant_lps_rpwm(struct btc_coexist *btcoexist,
 				     u8 lps_val, u8 rpwm_val)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s set lps/rpwm = 0x%x/0x%x\n",
@@ -773,6 +784,7 @@ static void halbtc8723b1ant_set_ant_path(struct btc_coexist *btcoexist,
 					 bool init_hw_cfg, bool wifi_off)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	u32 fw_ver = 0, u32tmp = 0, cnt_bt_cal_chk = 0;
 	bool pg_ext_switch = false;
@@ -1028,6 +1040,8 @@ static void halbtc8723b1ant_set_ant_path(struct btc_coexist *btcoexist,
 static void halbtc8723b1ant_ps_tdma(struct btc_coexist *btcoexist,
 				    bool force_exec, bool turn_on, u8 type)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_busy = false;
 	u8 rssi_adjust_val = 0;
@@ -1419,6 +1433,8 @@ void btc8723b1ant_tdma_dur_adj_for_acl(struct btc_coexist *btcoexist,
 				       u8 wifi_status)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	static s32 up, dn, m, n, wait_count;
 	/*  0: no change, +1: increase WiFi duration,
 	 * -1: decrease WiFi duration
@@ -1630,6 +1646,7 @@ static void halbtc8723b1ant_power_save_state(struct btc_coexist *btcoexist,
 					     u8 ps_type, u8 lps_val,
 					     u8 rpwm_val)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	bool low_pwr_disable = false;
 
 	switch (ps_type) {
@@ -1676,6 +1693,7 @@ static void halbtc8723b1ant_monitor_bt_enable_disable(struct btc_coexist
 						      *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	static u32 bt_disable_cnt;
 	bool bt_active = true, bt_disabled = false;
 
@@ -1751,6 +1769,7 @@ static void halbtc8723b1ant_action_hs(struct btc_coexist *btcoexist)
 
 static void halbtc8723b1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false, ap_enable = false;
 	bool wifi_busy = false, bt_busy = false;
@@ -1830,6 +1849,8 @@ static void halbtc8723b1ant_action_wifi_connected_bt_acl_busy(
 					struct btc_coexist *btcoexist,
 					u8 wifi_status)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	if ((coex_sta->low_priority_rx >= 950) && (!coex_sta->under_ips))
@@ -1898,6 +1919,7 @@ static void btc8723b1ant_action_wifi_not_conn(struct btc_coexist *btcoexist)
 static void
 btc8723b1ant_action_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
@@ -1959,6 +1981,7 @@ btc8723b1ant_act_wifi_not_conn_asso_auth(struct btc_coexist *btcoexist)
 
 static void btc8723b1ant_action_wifi_conn_scan(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	halbtc8723b1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE,
@@ -1998,6 +2021,7 @@ static void btc8723b1ant_action_wifi_conn_scan(struct btc_coexist *btcoexist)
 static void halbtc8723b1ant_action_wifi_connected_special_packet(
 						struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_busy = false;
 
@@ -2032,6 +2056,8 @@ static void halbtc8723b1ant_action_wifi_connected_special_packet(
 static void halbtc8723b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	bool wifi_busy = false;
 	bool scan = false, link = false, roam = false;
 	bool under_4way = false, ap_enable = false;
@@ -2148,6 +2174,8 @@ static void halbtc8723b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false, bt_hs_on = false, wifi_busy = false;
 	bool increase_scan_dev_num = false;
@@ -2308,6 +2336,7 @@ static void halbtc8723b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 /* force coex mechanism to reset */
 static void halbtc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	/* sw all off */
 	halbtc8723b1ant_sw_mechanism(btcoexist, false);
 
@@ -2318,6 +2347,7 @@ static void halbtc8723b1ant_init_hw_config(struct btc_coexist *btcoexist,
 					   bool backup, bool wifi_only)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	u32 u32tmp = 0;
 	u8 u8tmpa = 0, u8tmpb = 0;
 
@@ -2456,6 +2486,8 @@ void ex_btc8723b1ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_btc8723b1ant_display_coex_info(struct btc_coexist *btcoexist,
 				       struct seq_file *m)
 {
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
@@ -2720,6 +2752,7 @@ void ex_btc8723b1ant_display_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -2749,6 +2782,7 @@ void ex_btc8723b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8723b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -2767,6 +2801,7 @@ void ex_btc8723b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 	bool wifi_connected = false, bt_hs_on = false;
 	u8 u8tmpa, u8tmpb;
 	u32 u32tmp;
@@ -2853,6 +2888,8 @@ void ex_btc8723b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8723b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	bool wifi_connected = false, bt_hs_on = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
@@ -2924,6 +2961,8 @@ void ex_btc8723b1ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
@@ -3005,6 +3044,8 @@ void ex_btc8723b1ant_special_packet_notify(struct btc_coexist *btcoexist,
 					   u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	bool bt_hs_on = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
@@ -3082,6 +3123,8 @@ void ex_btc8723b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool wifi_connected = false;
@@ -3385,6 +3428,7 @@ void ex_btc8723b1ant_halt_notify(struct btc_coexist *btcoexist)
 void ex_btc8723b1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Pnp notify\n");
 
@@ -3431,6 +3475,8 @@ void ex_btc8723b1ant_coex_dm_reset(struct btc_coexist *btcoexist)
 void ex_btc8723b1ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_1ant *coex_sta = &btcoexist->coex_sta_8723b_1ant;
+	struct coex_dm_8723b_1ant *coex_dm = &btcoexist->coex_dm_8723b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
index 8c1cec306bf1..5efa9c4a9cbd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c
@@ -25,11 +25,6 @@
 
 #include "halbt_precomp.h"
 
-static struct coex_dm_8723b_2ant glcoex_dm_8723b_2ant;
-static struct coex_dm_8723b_2ant *coex_dm = &glcoex_dm_8723b_2ant;
-static struct coex_sta_8723b_2ant glcoex_sta_8723b_2ant;
-static struct coex_sta_8723b_2ant *coex_sta = &glcoex_sta_8723b_2ant;
-
 static const char *const glbt_info_src_8723b_2ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
@@ -44,6 +39,7 @@ static u8 btc8723b2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	s32 bt_rssi = 0;
 	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
@@ -133,6 +129,7 @@ static u8 btc8723b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 				       u8 rssi_thresh, u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	s32 wifi_rssi = 0;
 	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
@@ -247,6 +244,7 @@ void btc8723b2ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
 static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0;
@@ -292,6 +290,7 @@ static void btc8723b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	if (coex_sta->under_ips) {
 		coex_sta->crc_ok_cck = 0;
 		coex_sta->crc_ok_11g = 0;
@@ -330,6 +329,7 @@ static void btc8723b2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 static void btc8723b2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
@@ -345,6 +345,7 @@ static void btc8723b2ant_query_bt_info(struct btc_coexist *btcoexist)
 
 static bool btc8723b2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	static bool pre_wifi_busy;
 	static bool pre_under_4way;
 	static bool pre_bt_hs_on;
@@ -391,6 +392,7 @@ static bool btc8723b2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 
@@ -669,6 +671,7 @@ static void btc8723b2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 				    bool force_exec, u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Dec BT power level = %u\n", dec_bt_pwr_lvl);
@@ -706,6 +709,7 @@ static
 void btc8723b2ant_bt_auto_report(struct btc_coexist *btcoexist,
 				 bool force_exec, bool enable_auto_report)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	coex_dm->cur_bt_auto_report = enable_auto_report;
 
 	if (!force_exec) {
@@ -722,6 +726,7 @@ static void btc8723b2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 fw_dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s set FW Dac Swing level = %d\n",
@@ -772,6 +777,7 @@ static void btc8723b2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 					bool force_exec, bool low_penalty_ra)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn LowPenaltyRA = %s\n",
@@ -819,6 +825,7 @@ static void btc8723b2ant_dac_swing(struct btc_coexist *btcoexist,
 				   u32 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn DacSwing=%s, dac_swing_lvl=0x%x\n",
@@ -876,6 +883,7 @@ static void btc8723b2ant_coex_table(struct btc_coexist *btcoexist,
 				    u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s write Coex Table 0x6c0=0x%x, 0x6c4=0x%x, 0x6c8=0x%x, 0x6cc=0x%x\n",
@@ -1013,6 +1021,7 @@ static void btc8723b2ant_set_lps_rpwm(struct btc_coexist *btcoexist,
 static void btc8723b2ant_lps_rpwm(struct btc_coexist *btcoexist,
 				  bool force_exec, u8 lps_val, u8 rpwm_val)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	coex_dm->cur_lps = lps_val;
 	coex_dm->cur_rpwm = rpwm_val;
 
@@ -1031,6 +1040,7 @@ static void btc8723b2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					 bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn Ignore WlanAct %s\n",
@@ -1056,6 +1066,8 @@ static void btc8723b2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 h2c_parameter[5];
 	if ((coex_sta->a2dp_exist) && (coex_sta->hid_exist))
 		byte5 = byte5 | 0x1;
@@ -1210,6 +1222,8 @@ static void btc8723b2ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 				 bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u8 wifi_rssi_state, bt_rssi_state;
 	s8 wifi_duration_adjust = 0x0;
@@ -1499,6 +1513,7 @@ static void btc8723b2ant_ps_tdma_check_for_power_save_state(
 static void btc8723b2ant_power_save_state(struct btc_coexist *btcoexist,
 					  u8 ps_type, u8 lps_val, u8 rpwm_val)
 {
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	bool low_pwr_disable = false;
 
 	switch (ps_type) {
@@ -1552,6 +1567,7 @@ static void btc8723b2ant_coex_alloff(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	/* force to reset coex mechanism*/
 	btc8723b2ant_coex_table_with_type(btcoexist, NORMAL_EXEC, 0);
 	btc8723b2ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
@@ -1568,6 +1584,7 @@ static void btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 static void btc8723b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	bool wifi_connected = false;
 	bool low_pwr_disable = true;
 	bool scan = false, link = false, roam = false;
@@ -1630,6 +1647,8 @@ static void btc8723b2ant_action_wifi_link_process(struct btc_coexist
 static bool btc8723b2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u8 ap_num = 0;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
@@ -1671,6 +1690,7 @@ static bool btc8723b2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
 static bool btc8723b2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	bool common = false, wifi_connected = false;
 	bool wifi_busy = false;
 	bool bt_hs_on = false, low_pwr_disable = false;
@@ -1783,6 +1803,8 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					  u8 max_interval)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	static s32 up, dn, m, n, wait_count;
 	/*0: no change, +1: increase WiFi duration, -1: decrease WiFi duration*/
 	s32 result;
@@ -2766,6 +2788,7 @@ static void btc8723b2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 /* SCO only or SCO+PAN(HS) */
 static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, bt_rssi_state;
 	u32 wifi_bw;
 
@@ -2821,6 +2844,7 @@ static void btc8723b2ant_action_sco(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_BT_RSSI_COEXSWITCH_THRES -
@@ -2881,6 +2905,7 @@ static void btc8723b2ant_action_hid(struct btc_coexist *btcoexist)
 /* A2DP only / PAN(EDR) only/ A2DP+PAN(HS) */
 static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 ap_num = 0;
@@ -2967,6 +2992,7 @@ static void btc8723b2ant_action_a2dp(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
@@ -3026,6 +3052,7 @@ static void btc8723b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
@@ -3090,6 +3117,7 @@ static void btc8723b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 /* PAN(HS) only */
 static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
@@ -3140,6 +3168,7 @@ static void btc8723b2ant_action_pan_hs(struct btc_coexist *btcoexist)
 /* PAN(EDR) + A2DP */
 static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
@@ -3207,6 +3236,7 @@ static void btc8723b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
@@ -3283,6 +3313,7 @@ static void btc8723b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 /* HID + A2DP + PAN(EDR) */
 static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 tmp = BT_8723B_2ANT_WIFI_RSSI_COEXSWITCH_THRES -
@@ -3354,6 +3385,7 @@ static void btc8723b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 
 static void btc8723b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u32 wifi_bw;
 	u8 ap_num = 0;
@@ -3470,6 +3502,8 @@ static void btc8723b2ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
 static void btc8723b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 algorithm = 0;
 	u32 num_of_wifi_link = 0;
 	u32 wifi_link_status = 0;
@@ -3654,6 +3688,8 @@ static void btc8723b2ant_wifioff_hwcfg(struct btc_coexist *btcoexist)
 void ex_btc8723b2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 u8tmp = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3764,6 +3800,8 @@ void ex_btc8723b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist,
 				       struct seq_file *m)
 {
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
@@ -3976,6 +4014,7 @@ void ex_btc8723b2ant_display_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 
 	if (BTC_IPS_ENTER == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3997,6 +4036,7 @@ void ex_btc8723b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 
 	if (BTC_LPS_ENABLE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -4012,6 +4052,7 @@ void ex_btc8723b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8723b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 	u32 u32tmp;
 	u8 u8tmpa, u8tmpb;
 
@@ -4049,6 +4090,7 @@ void ex_btc8723b2ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
@@ -4108,6 +4150,8 @@ void ex_btc8723b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmpbuf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool bt_busy = false, limited_dig = false;
@@ -4299,6 +4343,7 @@ void ex_btc8723b2ant_halt_notify(struct btc_coexist *btcoexist)
 void ex_btc8723b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Pnp notify\n");
 
@@ -4326,6 +4371,8 @@ void ex_btc8723b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 void ex_btc8723b2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8723b_2ant *coex_sta = &btcoexist->coex_sta_8723b_2ant;
+	struct coex_dm_8723b_2ant *coex_dm = &btcoexist->coex_dm_8723b_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
index cb34a33ae99a..d3eb717078bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c
@@ -25,10 +25,6 @@
 
 #include "halbt_precomp.h"
 
-static struct coex_dm_8821a_1ant glcoex_dm_8821a_1ant;
-static struct coex_dm_8821a_1ant *coex_dm = &glcoex_dm_8821a_1ant;
-static struct coex_sta_8821a_1ant glcoex_sta_8821a_1ant;
-static struct coex_sta_8821a_1ant *coex_sta = &glcoex_sta_8821a_1ant;
 static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
 						  u8 wifi_status);
 
@@ -46,6 +42,7 @@ static u8 btc8821a1ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	long bt_rssi = 0;
 	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
@@ -134,6 +131,7 @@ static u8 btc8821a1ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 				       u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	long	wifi_rssi = 0;
 	u8	wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
@@ -224,6 +222,7 @@ static u8 btc8821a1ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 static void btc8821a1ant_update_ra_mask(struct btc_coexist *btcoexist,
 					bool force_exec, u32 dis_rate_mask)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	coex_dm->cur_ra_mask = dis_rate_mask;
 
 	if (force_exec ||
@@ -237,6 +236,7 @@ static void btc8821a1ant_update_ra_mask(struct btc_coexist *btcoexist,
 static void btc8821a1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
 					    bool force_exec, u8 type)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	bool wifi_under_b_mode = false;
 
 	coex_dm->cur_arfr_type = type;
@@ -277,6 +277,7 @@ static void btc8821a1ant_auto_rate_fb_retry(struct btc_coexist *btcoexist,
 static void btc8821a1ant_retry_limit(struct btc_coexist *btcoexist,
 				     bool force_exec, u8 type)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	coex_dm->cur_retry_limit_type = type;
 
 	if (force_exec ||
@@ -299,6 +300,7 @@ static void btc8821a1ant_retry_limit(struct btc_coexist *btcoexist,
 static void btc8821a1ant_ampdu_max_time(struct btc_coexist *btcoexist,
 					bool force_exec, u8 type)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	coex_dm->cur_ampdu_time_type = type;
 
 	if (force_exec ||
@@ -367,6 +369,7 @@ static void btc8821a1ant_limited_rx(struct btc_coexist *btcoexist,
 
 static void btc8821a1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	u32 reg_hp_tx_rx, reg_lp_tx_rx, u4_tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 
@@ -393,6 +396,7 @@ static void btc8821a1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 static void btc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
@@ -408,6 +412,7 @@ static void btc8821a1ant_query_bt_info(struct btc_coexist *btcoexist)
 
 static void btc8821a1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	struct btc_bt_link_info	*bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 
@@ -672,6 +677,7 @@ static void btc8821a1ant_set_sw_penalty_tx_rate(struct btc_coexist *btcoexist,
 static void btc8821a1ant_low_penalty_ra(struct btc_coexist *btcoexist,
 					bool force_exec, bool low_penalty_ra)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
@@ -712,6 +718,7 @@ static void btc8821a1ant_coex_table(struct btc_coexist *btcoexist,
 				    u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, 0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
@@ -799,6 +806,7 @@ static void btc8821a1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					 bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn Ignore WlanAct %s\n",
@@ -824,6 +832,7 @@ static void btc8821a1ant_set_fw_ps_tdma(struct btc_coexist *btcoexist, u8 byte1,
 					u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	u8 h2c_parameter[5] = {0};
 	u8 real_byte1 = byte1, real_byte5 = byte5;
 	bool ap_enable = false;
@@ -879,6 +888,7 @@ static void btc8821a1ant_lps_rpwm(struct btc_coexist *btcoexist,
 				  bool force_exec, u8 lps_val, u8 rpwm_val)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s set lps/rpwm = 0x%x/0x%x\n",
@@ -1005,6 +1015,7 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 				 bool force_exec, bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	u8 rssi_adjust_val = 0;
 
 	coex_dm->cur_ps_tdma_on = turn_on;
@@ -1247,6 +1258,7 @@ static void btc8821a1ant_ps_tdma(struct btc_coexist *btcoexist,
 static bool btc8821a1ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	bool common = false, wifi_connected = false, wifi_busy = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
@@ -1452,6 +1464,7 @@ static void btc8821a1ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 static
 void btc8821a1ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
@@ -1513,6 +1526,7 @@ static void btc8821a1ant_action_hs(struct btc_coexist *btcoexist)
 
 static void btc8821a1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false;
 	bool ap_enable = false;
@@ -1574,6 +1588,7 @@ static void btc8821a1ant_act_bt_sco_hid_only_busy(struct btc_coexist *btcoexist,
 static void btc8821a1ant_act_wifi_con_bt_acl_busy(struct btc_coexist *btcoexist,
 						  u8 wifi_status)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	u8 bt_rssi_state;
 
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
@@ -1653,6 +1668,7 @@ void btc8821a1ant_action_wifi_not_connected(struct btc_coexist *btcoexist)
 
 static void btc8821a1ant_act_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	btc8821a1ant_power_save_state(btcoexist, BTC_PS_WIFI_NATIVE, 0x0, 0x0);
@@ -1687,6 +1703,7 @@ static void btc8821a1ant_act_wifi_not_conn_scan(struct btc_coexist *btcoexist)
 static
 void btc8821a1ant_action_wifi_connected_scan(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	/* power save state */
@@ -1744,6 +1761,7 @@ static void btc8821a1ant_act_wifi_conn_sp_pkt(struct btc_coexist *btcoexist)
 static void btc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	bool wifi_busy = false;
 	bool scan = false, link = false, roam = false;
 	bool under_4way = false;
@@ -1832,6 +1850,7 @@ static void btc8821a1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	u8 algorithm = 0;
 
 	algorithm = btc8821a1ant_action_algorithm(btcoexist);
@@ -1902,6 +1921,8 @@ static void btc8821a1ant_run_sw_coex_mech(struct btc_coexist *btcoexist)
 static void btc8821a1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false, bt_hs_on = false;
 	bool increase_scan_dev_num = false;
@@ -2050,6 +2071,7 @@ static void btc8821a1ant_init_hw_config(struct btc_coexist *btcoexist,
 					bool back_up, bool wifi_only)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	u8 u1_tmp = 0;
 	bool wifi_under_5g = false;
 
@@ -2122,6 +2144,8 @@ void ex_btc8821a1ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist,
 				       struct seq_file *m)
 {
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
@@ -2360,6 +2384,7 @@ void ex_btc8821a1ant_display_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	bool wifi_under_5g = false;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
@@ -2396,6 +2421,7 @@ void ex_btc8821a1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -2414,6 +2440,7 @@ void ex_btc8821a1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	bool wifi_connected = false, bt_hs_on = false;
 	bool bt_ctrl_agg_buf_size = false;
 	bool wifi_under_5g = false;
@@ -2498,6 +2525,8 @@ void ex_btc8821a1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8821a1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	bool wifi_connected = false, bt_hs_on = false;
 	u32 wifi_link_status = 0;
 	u32 num_of_wifi_link = 0;
@@ -2571,6 +2600,8 @@ void ex_btc8821a1ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
@@ -2628,6 +2659,8 @@ void ex_btc8821a1ant_special_packet_notify(struct btc_coexist *btcoexist,
 					   u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	bool bt_hs_on = false;
 	bool bt_ctrl_agg_buf_size = false;
 	bool wifi_under_5g = false;
@@ -2711,6 +2744,8 @@ void ex_btc8821a1ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
+	struct coex_dm_8821a_1ant *coex_dm = &btcoexist->coex_dm_8821a_1ant;
 	u8 i;
 	u8 bt_info = 0;
 	u8 rsp_source = 0;
@@ -2906,6 +2941,7 @@ void ex_btc8821a1ant_halt_notify(struct btc_coexist *btcoexist)
 void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	bool wifi_under_5g = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_UNDER_5G, &wifi_under_5g);
@@ -2947,6 +2983,7 @@ void ex_btc8821a1ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 void ex_btc8821a1ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_1ant *coex_sta = &btcoexist->coex_sta_8821a_1ant;
 	static u8 dis_ver_info_cnt;
 	u32 fw_ver = 0, bt_patch_ver = 0;
 	struct btc_board_info *board_info = &btcoexist->board_info;
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
index 14510d514e2f..42cb00d47a3e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
@@ -25,11 +25,6 @@
 
 #include "halbt_precomp.h"
 
-static struct coex_dm_8821a_2ant glcoex_dm_8821a_2ant;
-static struct coex_dm_8821a_2ant *coex_dm = &glcoex_dm_8821a_2ant;
-static struct coex_sta_8821a_2ant glcoex_sta_8821a_2ant;
-static struct coex_sta_8821a_2ant *coex_sta = &glcoex_sta_8821a_2ant;
-
 static const char *const glbt_info_src_8821a_2ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
@@ -44,6 +39,7 @@ static u8 btc8821a2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 				     u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	long bt_rssi = 0;
 	u8 bt_rssi_state = coex_sta->pre_bt_rssi_state;
 
@@ -135,6 +131,7 @@ static u8 btc8821a2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 				       u8 rssi_thresh, u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	long wifi_rssi = 0;
 	u8 wifi_rssi_state = coex_sta->pre_wifi_rssi_state[index];
 
@@ -247,6 +244,7 @@ void btc8821a2ant_limited_rx(struct btc_coexist *btcoexist, bool force_exec,
 static void btc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u32 reg_hp_txrx, reg_lp_txrx, u4tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
@@ -287,6 +285,7 @@ static void btc8821a2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void btc8821a2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	if (coex_sta->under_ips) {
 		coex_sta->crc_ok_cck = 0;
 		coex_sta->crc_ok_11g = 0;
@@ -325,6 +324,7 @@ static void btc8821a2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 static void btc8821a2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	u8 h2c_parameter[1] = {0};
 
 	coex_sta->c2h_bt_info_req_sent = true;
@@ -381,6 +381,7 @@ static bool btc8821a2ant_is_wifi_status_changed(struct btc_coexist *btcoexist)
 
 static void btc8821a2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 
@@ -653,6 +654,7 @@ static void btc8821a2ant_dec_bt_pwr(struct btc_coexist *btcoexist,
 				    bool force_exec, u8 dec_bt_pwr_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s Dec BT power level = %u\n",
@@ -677,6 +679,7 @@ static void btc8821a2ant_fw_dac_swing_lvl(struct btc_coexist *btcoexist,
 					  bool force_exec, u8 fw_dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s set FW Dac Swing level = %d\n",
@@ -731,6 +734,7 @@ static void btc8821a2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 					bool force_exec, bool low_penalty_ra)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn LowPenaltyRA = %s\n",
@@ -779,6 +783,7 @@ static void btc8821a2ant_dac_swing(struct btc_coexist *btcoexist,
 				   u32 dac_swing_lvl)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn DacSwing = %s, dac_swing_lvl = 0x%x\n",
@@ -837,6 +842,7 @@ static void btc8821a2ant_coex_table(struct btc_coexist *btcoexist,
 				    u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s write Coex Table 0x6c0 = 0x%x, 0x6c4 = 0x%x, 0x6c8 = 0x%x, 0x6cc = 0x%x\n",
@@ -879,6 +885,7 @@ static void btc8821a2ant_coex_table(struct btc_coexist *btcoexist,
 static void btc8821a2ant_coex_table_with_type(struct btc_coexist *btcoexist,
 					      bool force_exec, u8 type)
 {
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	coex_sta->coex_table_type = type;
 
 	switch (type) {
@@ -988,6 +995,7 @@ static void btc8821a2ant_set_lps_rpwm(struct btc_coexist *btcoexist, u8 lps_val,
 static void btc8821a2ant_lps_rpwm(struct btc_coexist *btcoexist,
 				  bool force_exec, u8 lps_val, u8 rpwm_val)
 {
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	coex_dm->cur_lps = lps_val;
 	coex_dm->cur_rpwm = rpwm_val;
 
@@ -1006,6 +1014,7 @@ static void btc8821a2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					 bool force_exec, bool enable)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], %s turn Ignore WlanAct %s\n",
@@ -1032,6 +1041,7 @@ static void btc8821a2ant_set_fw_ps_tdma(struct btc_coexist *btcoexist,
 					u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	u8 h2c_parameter[5];
 
 	h2c_parameter[0] = byte1;
@@ -1123,6 +1133,7 @@ static void btc8821a2ant_ps_tdma(struct btc_coexist *btcoexist,
 				 bool force_exec, bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	u8 wifi_rssi_state, bt_rssi_state;
 
@@ -1375,6 +1386,7 @@ btc8821a2ant_ps_tdma_check_for_power_save_state(struct btc_coexist *btcoexist,
 static void btc8821a2ant_power_save_state(struct btc_coexist *btcoexist,
 					  u8 ps_type, u8 lps_val, u8 rpwm_val)
 {
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	bool low_pwr_disable = false;
 
 	switch (ps_type) {
@@ -1517,6 +1529,7 @@ static void btc8821a2ant_action_wifi_link_process(struct btc_coexist *btcoexist)
 static bool btc8821a2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 	u8 wifi_rssi_state, wifi_rssi_state1, bt_rssi_state;
 	u8 ap_num = 0;
 
@@ -1577,6 +1590,7 @@ static bool btc8821a2ant_action_wifi_idle_process(struct btc_coexist *btcoexist)
 static bool btc8821a2ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	bool common = false, wifi_connected = false, wifi_busy = false;
 	bool low_pwr_disable = false;
 	bool bt_hs_on = false;
@@ -1700,6 +1714,8 @@ static void btc8821a2ant_tdma_duration_adjust(struct btc_coexist *btcoexist,
 					      u8 max_interval)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	static long up, dn, m, n, wait_count;
 	 /* 0 : no change
 	  * +1: increase WiFi duration
@@ -3381,6 +3397,8 @@ static void btc8821a2ant_action_wifi_multi_port(struct btc_coexist *btcoexist)
 static void btc8821a2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_under_5g = false;
 	u8 algorithm = 0;
@@ -3560,6 +3578,8 @@ static void btc8821a2ant_wifi_off_hw_cfg(struct btc_coexist *btcoexist)
 void ex_btc8821a2ant_init_hwconfig(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	u8 u1tmp = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3639,6 +3659,8 @@ void ex_btc8821a2ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_btc8821a2ant_display_coex_info(struct btc_coexist *btcoexist,
 				       struct seq_file *m)
 {
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_stack_info *stack_info = &btcoexist->stack_info;
 	u8 u1tmp[4], i, bt_info_ext, ps_tdma_case = 0;
@@ -3839,6 +3861,7 @@ void ex_btc8821a2ant_display_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 
 	if (BTC_IPS_ENTER == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3860,6 +3883,7 @@ void ex_btc8821a2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8821a2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
 
 	if (BTC_LPS_ENABLE == type) {
 		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3902,6 +3926,7 @@ void ex_btc8821a2ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	u8 h2c_parameter[3] = {0};
 	u32 wifi_bw;
 	u8 wifi_central_chnl;
@@ -3962,6 +3987,8 @@ void ex_btc8821a2ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 	u8 bt_info = 0;
 	u8 i, rsp_source = 0;
 	bool bt_busy = false, limited_dig = false;
@@ -4191,6 +4218,8 @@ void ex_btc8821a2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 void ex_btc8821a2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8821a_2ant *coex_sta = &btcoexist->coex_sta_8821a_2ant;
+	struct coex_dm_8821a_2ant *coex_dm = &btcoexist->coex_dm_8821a_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], ==========================Periodical===========================\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
index cb1826941445..aabb6c281372 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b1ant.c
@@ -15,13 +15,6 @@
 
 #include "halbt_precomp.h"
 
-static struct coex_dm_8822b_1ant	glcoex_dm_8822b_1ant;
-static struct coex_dm_8822b_1ant	*coex_dm = &glcoex_dm_8822b_1ant;
-static struct coex_sta_8822b_1ant	glcoex_sta_8822b_1ant;
-static struct coex_sta_8822b_1ant	*coex_sta = &glcoex_sta_8822b_1ant;
-static struct rfe_type_8822b_1ant	gl_rfe_type_8822b_1ant;
-static struct rfe_type_8822b_1ant	*rfe_type = &gl_rfe_type_8822b_1ant;
-
 static const char *const glbt_info_src_8822b_1ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
@@ -126,6 +119,7 @@ static void halbtc8822b1ant_limited_rx(struct btc_coexist *btcoexist,
 static void halbtc8822b1ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	u8 h2c_parameter[1] = {0};
 
 	if (coex_sta->bt_disabled) {
@@ -145,6 +139,7 @@ static void halbtc8822b1ant_query_bt_info(struct btc_coexist *btcoexist)
 static void halbtc8822b1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	u32	reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32	reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 	static u8	num_of_bt_counter_chk, cnt_slave, cnt_autoslot_hang;
@@ -237,6 +232,8 @@ static void halbtc8822b1ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void halbtc8822b1ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	s32	wifi_rssi = 0;
 	bool	wifi_busy = false, wifi_under_b_mode = false, wifi_scan = false;
 	static u8 wl_noisy_count0, wl_noisy_count1 = 3, wl_noisy_count2;
@@ -345,6 +342,7 @@ static bool
 halbtc8822b1ant_is_wifibt_status_changed(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	static bool pre_wifi_busy, pre_under_4way,
 		       pre_bt_hs_on, pre_rf4ce_enabled,
 		       pre_bt_off, pre_bt_slave,
@@ -480,6 +478,8 @@ halbtc8822b1ant_is_wifibt_status_changed(struct btc_coexist *btcoexist)
 static void halbtc8822b1ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 	bool bt_busy = false;
@@ -709,6 +709,8 @@ static void
 halbtc8822b1ant_update_wifi_ch_info(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	u8 h2c_parameter[3] = {0}, i;
 	u32 wifi_bw;
 	u8 wifi_central_chnl = 0;
@@ -956,6 +958,8 @@ static void halbtc8822b1ant_low_penalty_ra(struct btc_coexist *btcoexist,
 					   bool force_exec,
 					   bool low_penalty_ra)
 {
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
+
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
@@ -994,6 +998,7 @@ static void halbtc8822b1ant_write_score_board(struct btc_coexist *btcoexist,
 					      u16 bitpos, bool state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	static u16 originalval = 0x8002, preval;
 
 	if (state)
@@ -1029,6 +1034,8 @@ static void halbtc8822b1ant_adjust_wl_tx_power(struct btc_coexist *btcoexist,
 					       bool force_exec,
 					       u8 fw_dac_swing_lvl)
 {
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
+
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
@@ -1049,6 +1056,7 @@ static void halbtc8822b1ant_adjust_bt_tx_power(struct btc_coexist *btcoexist,
 					       bool force_exec,
 					       u8 dec_bt_pwr_lvl)
 {
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	u8 h2c_parameter[1] = {0};
 
 	coex_dm->cur_bt_dec_pwr_lvl = dec_bt_pwr_lvl;
@@ -1070,6 +1078,7 @@ static void halbtc8822b1ant_adjust_wl_rx_gain(struct btc_coexist *btcoexist,
 					      bool agc_table_en)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	u32 rx_gain_value_enable[] = {
 		0xff000003, 0xea240003, 0xe9260003, 0xe8280003, 0xe72a0003,
 		0xe62c0003, 0xaf2e0003, 0xae300003, 0xad320003, 0xac340003,
@@ -1137,6 +1146,7 @@ static void
 halbtc8822b1ant_monitor_bt_enable_disable(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	static u32 bt_disable_cnt;
 	bool bt_active = true, bt_disabled = false, wifi_under_5g = false;
 	u16 u16tmp;
@@ -1486,6 +1496,8 @@ void halbtc8822b1ant_coex_table(struct btc_coexist *btcoexist,
 				bool force_exec, u32 val0x6c0, u32 val0x6c4,
 				u32 val0x6c8, u8 val0x6cc)
 {
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
+
 	coex_dm->cur_val0x6c0 = val0x6c0;
 	coex_dm->cur_val0x6c4 = val0x6c4;
 	coex_dm->cur_val0x6c8 = val0x6c8;
@@ -1511,6 +1523,7 @@ static
 void halbtc8822b1ant_coex_table_type(struct btc_coexist *btcoexist,
 				     bool force_exec, u8 type)
 {
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	u32 break_table;
 	u8 select_table;
 
@@ -1678,6 +1691,8 @@ static
 void halbtc8822b1ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 				     bool force_exec, bool enable)
 {
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
+
 	coex_dm->cur_ignore_wlan_act = enable;
 
 	if (!force_exec) {
@@ -1709,6 +1724,8 @@ static
 void halbtc8822b1ant_lps_rpwm(struct btc_coexist *btcoexist, bool force_exec,
 			      u8 lps_val, u8 rpwm_val)
 {
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
+
 	coex_dm->cur_lps = lps_val;
 	coex_dm->cur_rpwm = rpwm_val;
 
@@ -1757,6 +1774,7 @@ static bool
 halbtc8822b1ant_power_save_state(struct btc_coexist *btcoexist,
 				 u8 ps_type, u8 lps_val, u8 rpwm_val)
 {
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	bool low_pwr_disable = false, result = true;
 
 	switch (ps_type) {
@@ -1804,6 +1822,8 @@ void halbtc8822b1ant_set_fw_pstdma(struct btc_coexist *btcoexist, u8 byte1,
 				   u8 byte2, u8 byte3, u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	u8 h2c_parameter[5] = {0};
 	u8 real_byte1 = byte1, real_byte5 = byte5;
 	bool ap_enable = false, result = false;
@@ -1889,6 +1909,8 @@ void halbtc8822b1ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 			     bool turn_on, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_busy = false;
 	static u8 tdma_byte4_modify, pre_ps_tdma_byte4_modify;
@@ -2139,6 +2161,7 @@ void halbtc8822b1ant_ps_tdma(struct btc_coexist *btcoexist, bool force_exec,
 
 static void halbtc8822b1ant_set_rfe_type(struct btc_coexist *btcoexist)
 {
+	struct rfe_type_8822b_1ant *rfe_type = &btcoexist->rfe_type_8822b_1ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 
 	/* Ext switch buffer mux */
@@ -2162,6 +2185,8 @@ void hallbtc882b1ant_set_ant_switch(struct btc_coexist *btcoexist,
 				    u8 pos_type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rfe_type_8822b_1ant *rfe_type = &btcoexist->rfe_type_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	bool switch_polatiry_inverse = false;
 	u8 regval_0xcbd = 0, regval_0x64;
 	u32 u32tmp1 = 0, u32tmp2 = 0, u32tmp3 = 0;
@@ -2319,6 +2344,8 @@ void halbtc8822b1ant_set_ant_path(struct btc_coexist *btcoexist,
 
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	u8 u8tmp = 0;
 	u32 u32tmp1 = 0;
 	u32 u32tmp2 = 0, u32tmp3 = 0;
@@ -2644,6 +2671,7 @@ void halbtc8822b1ant_set_ant_path(struct btc_coexist *btcoexist,
 static bool halbtc8822b1ant_is_common_action(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	bool common = false, wifi_connected = false, wifi_busy = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
@@ -2715,6 +2743,7 @@ static void halbtc8822b1ant_action_bt_whql_test(struct btc_coexist *btcoexist)
 
 static void halbtc8822b1ant_action_bt_relink(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	if ((!coex_sta->is_bt_multi_link && !bt_link_info->pan_exist) ||
@@ -2734,6 +2763,7 @@ static void halbtc8822b1ant_action_bt_relink(struct btc_coexist *btcoexist)
 
 static void halbtc8822b1ant_action_bt_idle(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	bool wifi_busy = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_BUSY, &wifi_busy);
@@ -2769,6 +2799,7 @@ static void halbtc8822b1ant_action_bt_idle(struct btc_coexist *btcoexist)
 static void halbtc8822b1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false, wifi_busy = false, bt_busy = false;
 	bool wifi_scan = false, link = false, roam = false;
@@ -2836,6 +2867,7 @@ static void halbtc8822b1ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 static
 void halbtc8822b1ant_action_bt_sco_hid_busy(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false, wifi_busy = false;
 	u32 wifi_bw = 1;
@@ -2907,6 +2939,7 @@ void halbtc8822b1ant_action_bt_sco_hid_busy(struct btc_coexist *btcoexist)
 static void halbtc8822b1ant_action_bt_mr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], RunCoexistMechanism(), microsoft MR!!\n");
@@ -3098,6 +3131,7 @@ static void
 halbtc8822b1ant_action_wifi_bt_acl_busy(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_busy = false, wifi_turbo = false;
 	u32 wifi_bw = 1;
@@ -3287,6 +3321,7 @@ void halbtc8822b1ant_action_wifi_not_connected(struct btc_coexist *btcoexist)
 static void halbtc8822b1ant_action_wifi_connected(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_busy = false, rf4ce_enabled = false;
 	bool wifi_under_5g = false;
@@ -3325,6 +3360,7 @@ static
 void halbtc8822b1ant_run_sw_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	u8 algorithm = 0;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
@@ -3387,6 +3423,8 @@ void halbtc8822b1ant_run_sw_coexist_mechanism(struct btc_coexist *btcoexist)
 static void halbtc8822b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool wifi_connected = false;
 	u8 mcc_dualband = BTC_MULTIPORT_SCC;
@@ -3597,6 +3635,7 @@ static void halbtc8822b1ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 
 static void halbtc8822b1ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	/* force to reset coex mechanism */
 
 	halbtc8822b1ant_low_penalty_ra(btcoexist, NORMAL_EXEC, false);
@@ -3620,6 +3659,8 @@ static void halbtc8822b1ant_init_hw_config(struct btc_coexist *btcoexist,
 					   bool back_up, bool wifi_only)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rfe_type_8822b_1ant *rfe_type = &btcoexist->rfe_type_8822b_1ant;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	u8 u8tmp = 0, i = 0;
 	u32 u32tmp1 = 0, u32tmp2 = 0, u32tmp3 = 0;
 
@@ -3734,6 +3775,7 @@ static void halbtc8822b1ant_init_hw_config(struct btc_coexist *btcoexist,
 void ex_btc8822b1ant_power_on_setting(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	u8 u8tmp = 0x0;
 	u16 u16tmp = 0x0;
@@ -3827,6 +3869,9 @@ void ex_btc8822b1ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_btc8822b1ant_display_simple_coex_info(struct btc_coexist *btcoexist,
 					      struct seq_file *m)
 {
+	struct rfe_type_8822b_1ant *rfe_type = &btcoexist->rfe_type_8822b_1ant;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u32 bt_patch_ver = 0, bt_coex_ver = 0;
@@ -3942,6 +3987,9 @@ void ex_btc8822b1ant_display_simple_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8822b1ant_display_coex_info(struct btc_coexist *btcoexist,
 				       struct seq_file *m)
 {
+	struct rfe_type_8822b_1ant *rfe_type = &btcoexist->rfe_type_8822b_1ant;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u8 u8tmp[4], i, ps_tdma_case = 0;
@@ -4384,6 +4432,7 @@ void ex_btc8822b1ant_display_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8822b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -4428,6 +4477,7 @@ void ex_btc8822b1ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8822b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	static bool pre_force_lps_on;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
@@ -4476,6 +4526,7 @@ void ex_btc8822b1ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8822b1ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	bool wifi_connected = false;
 	bool wifi_under_5g = false;
 
@@ -4564,6 +4615,7 @@ void ex_btc8822b1ant_switchband_notify(struct btc_coexist *btcoexist,
 				       u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -4606,6 +4658,8 @@ ex_btc8822b1ant_switchband_notify_without_bt(struct btc_coexist *btcoexist,
 void ex_btc8822b1ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -4664,6 +4718,8 @@ void ex_btc8822b1ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	bool wifi_under_b_mode = false;
 	bool wifi_under_5g = false;
 
@@ -4746,6 +4802,8 @@ void ex_btc8822b1ant_specific_packet_notify(struct btc_coexist *btcoexist,
 					    u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	bool under_4way = false, wifi_under_5g = false;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
@@ -4799,6 +4857,7 @@ void ex_btc8822b1ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	u8 i, rsp_source = 0;
 	bool wifi_connected = false;
 	bool wifi_scan = false, wifi_link = false, wifi_roam = false,
@@ -5022,6 +5081,7 @@ void ex_btc8822b1ant_wl_fwdbginfo_notify(struct btc_coexist *btcoexist,
 					 u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	u8 i = 0;
 	static u8 tmp_buf_pre[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
 
@@ -5047,6 +5107,8 @@ void ex_btc8822b1ant_rx_rate_change_notify(struct btc_coexist *btcoexist,
 					   u8 btc_rate_id)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
+	struct coex_dm_8822b_1ant *coex_dm = &btcoexist->coex_dm_8822b_1ant;
 	bool wifi_connected = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
@@ -5106,6 +5168,7 @@ void ex_btc8822b1ant_rx_rate_change_notify(struct btc_coexist *btcoexist,
 void ex_btc8822b1ant_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], RF Status notify\n");
@@ -5224,6 +5287,7 @@ void ex_btc8822b1ant_coex_dm_reset(struct btc_coexist *btcoexist)
 void ex_btc8822b1ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_1ant *coex_sta = &btcoexist->coex_sta_8822b_1ant;
 	bool bt_relink_finish = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b2ant.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b2ant.c
index 7c12fade5171..085a8800bcbc 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b2ant.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8822b2ant.c
@@ -15,13 +15,6 @@
 
 #include "halbt_precomp.h"
 
-static struct coex_dm_8822b_2ant	glcoex_dm_8822b_2ant;
-static struct coex_dm_8822b_2ant	*coex_dm = &glcoex_dm_8822b_2ant;
-static struct coex_sta_8822b_2ant	glcoex_sta_8822b_2ant;
-static struct coex_sta_8822b_2ant	*coex_sta = &glcoex_sta_8822b_2ant;
-static struct rfe_type_8822b_2ant	gl_rfe_type_8822b_2ant;
-static struct rfe_type_8822b_2ant	*rfe_type = &gl_rfe_type_8822b_2ant;
-
 static const char *const glbt_info_src_8822b_2ant[] = {
 	"BT Info[wifi fw]",
 	"BT Info[bt rsp]",
@@ -37,6 +30,7 @@ static u8 halbtc8822b2ant_bt_rssi_state(struct btc_coexist *btcoexist,
 					u8 rssi_thresh, u8 rssi_thresh1)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	s32 bt_rssi = 0;
 	u8 bt_rssi_state = *ppre_bt_rssi_state;
 
@@ -157,6 +151,7 @@ static u8 halbtc8822b2ant_wifi_rssi_state(struct btc_coexist *btcoexist,
 static void halbtc8822b2ant_coex_switch_threshold(struct btc_coexist *btcoexist,
 						  u8 isolation_measuared)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	s8 interference_wl_tx = 0, interference_bt_tx = 0;
 
 	interference_wl_tx =
@@ -189,6 +184,7 @@ static void halbtc8822b2ant_coex_switch_threshold(struct btc_coexist *btcoexist,
 static void halbtc8822b2ant_query_bt_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	u8 h2c_parameter[1] = {0};
 
 	if (coex_sta->bt_disabled) {
@@ -204,6 +200,7 @@ static void halbtc8822b2ant_query_bt_info(struct btc_coexist *btcoexist)
 
 static void halbtc8822b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	u32 reg_hp_txrx, reg_lp_txrx, u32tmp;
 	u32 reg_hp_tx = 0, reg_hp_rx = 0, reg_lp_tx = 0, reg_lp_rx = 0;
 	static u8 num_of_bt_counter_chk, cnt_slave, cnt_autoslot_hang;
@@ -300,6 +297,8 @@ static void halbtc8822b2ant_monitor_bt_ctr(struct btc_coexist *btcoexist)
 
 static void halbtc8822b2ant_monitor_wifi_ctr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	s32 wifi_rssi = 0;
 	bool wifi_busy = false, wifi_under_b_mode = false, wifi_scan = false;
 	static u8 wl_noisy_count0, wl_noisy_count1 = 3, wl_noisy_count2;
@@ -431,6 +430,7 @@ static bool
 halbtc8822b2ant_is_wifibt_status_changed(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	static bool pre_wifi_busy, pre_under_4way,
 		       pre_bt_hs_on, pre_bt_off,
 		       pre_bt_slave,
@@ -549,6 +549,8 @@ halbtc8822b2ant_is_wifibt_status_changed(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_update_bt_link_info(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 	bool bt_busy = false;
@@ -757,6 +759,8 @@ static void
 halbtc8822b2ant_update_wifi_ch_info(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	u8 h2c_parameter[3] = {0}, i;
 	u32 wifi_bw;
 	u8 wifi_central_chnl = 0;
@@ -814,6 +818,8 @@ static void halbtc8822b2ant_low_penalty_ra(struct btc_coexist *btcoexist,
 					   bool force_exec,
 					   bool low_penalty_ra)
 {
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
+
 	coex_dm->cur_low_penalty_ra = low_penalty_ra;
 
 	if (!force_exec) {
@@ -833,6 +839,7 @@ static void halbtc8822b2ant_write_score_board(struct btc_coexist *btcoexist,
 					      u16 bitpos, bool state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	static u16 originalval = 0x8002, preval;
 
 	if (state)
@@ -868,6 +875,8 @@ static void halbtc8822b2ant_adjust_wl_tx_power(struct btc_coexist *btcoexist,
 					       bool force_exec,
 					       u8 fw_dac_swing_lvl)
 {
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
+
 	coex_dm->cur_fw_dac_swing_lvl = fw_dac_swing_lvl;
 
 	if (!force_exec) {
@@ -888,6 +897,7 @@ static void halbtc8822b2ant_adjust_bt_tx_power(struct btc_coexist *btcoexist,
 					       bool force_exec,
 					       u8 dec_bt_pwr_lvl)
 {
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	u8 h2c_parameter[1] = {0};
 
 	coex_dm->cur_bt_dec_pwr_lvl = dec_bt_pwr_lvl;
@@ -909,6 +919,7 @@ static void halbtc8822b2ant_adjust_wl_rx_gain(struct btc_coexist *btcoexist,
 					      bool agc_table_en)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	/*20171116*/
 
 	u32 rx_gain_value_enable[] = {
@@ -1010,6 +1021,7 @@ static void
 halbtc8822b2ant_monitor_bt_enable_disable(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	static u32 bt_disable_cnt;
 	bool bt_active = true, bt_disabled = false, wifi_under_5g = false;
 	u16 u16tmp;
@@ -1362,6 +1374,8 @@ static void halbtc8822b2ant_coex_table(struct btc_coexist *btcoexist,
 				       bool force_exec, u32 val0x6c0,
 				       u32 val0x6c4, u32 val0x6c8, u8 val0x6cc)
 {
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
+
 	coex_dm->cur_val0x6c0 = val0x6c0;
 	coex_dm->cur_val0x6c4 = val0x6c4;
 	coex_dm->cur_val0x6c8 = val0x6c8;
@@ -1386,6 +1400,7 @@ static void halbtc8822b2ant_coex_table(struct btc_coexist *btcoexist,
 static void halbtc8822b2ant_coex_table_type(struct btc_coexist *btcoexist,
 					    bool force_exec, u8 type)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	u32 break_table;
 	u8 select_table;
 
@@ -1495,6 +1510,8 @@ halbtc8822b2ant_set_fw_ignore_wlan_act(struct btc_coexist *btcoexist,
 static void halbtc8822b2ant_ignore_wlan_act(struct btc_coexist *btcoexist,
 					    bool force_exec, bool enable)
 {
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
+
 	coex_dm->cur_ignore_wlan_act = enable;
 
 	if (!force_exec) {
@@ -1521,6 +1538,8 @@ static void halbtc8822b2ant_lps_rpwm(struct btc_coexist *btcoexist,
 				     bool force_exec, u8 lps_val,
 				     u8 rpwm_val)
 {
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
+
 	coex_dm->cur_lps = lps_val;
 	coex_dm->cur_rpwm = rpwm_val;
 
@@ -1572,6 +1591,7 @@ static bool halbtc8822b2ant_power_save_state(struct btc_coexist *btcoexist,
 					     u8 rpwm_val)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	bool low_pwr_disable = false, result = true;
 
 	switch (ps_type) {
@@ -1624,6 +1644,8 @@ static void halbtc8822b2ant_set_fw_pstdma(struct btc_coexist *btcoexist,
 					  u8 byte4, u8 byte5)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	u8 h2c_parameter[5] = {0};
 	u8 real_byte1 = byte1, real_byte5 = byte5;
 	bool ap_enable = false, result = false;
@@ -1709,6 +1731,8 @@ static void halbtc8822b2ant_ps_tdma(struct btc_coexist *btcoexist,
 				    u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 tdma_byte4_modify, pre_ps_tdma_byte4_modify;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
@@ -1939,6 +1963,7 @@ static void halbtc8822b2ant_ps_tdma(struct btc_coexist *btcoexist,
  */
 static void halbtc8822b2ant_set_rfe_type(struct btc_coexist *btcoexist)
 {
+	struct rfe_type_8822b_2ant *rfe_type = &btcoexist->rfe_type_8822b_2ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 
 	rfe_type->ext_band_switch_exist = false;
@@ -1977,6 +2002,8 @@ static void halbtc8822b2ant_set_ant_path(struct btc_coexist *btcoexist,
 					 u8 phase)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	u8 u8tmp = 0;
 	u32 u32tmp1 = 0;
 	u32 u32tmp2 = 0, u32tmp3 = 0;
@@ -2249,6 +2276,7 @@ static void halbtc8822b2ant_set_ant_path(struct btc_coexist *btcoexist,
 static u8 halbtc8822b2ant_action_algorithm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	bool bt_hs_on = false;
 	u8 algorithm = BT_8822B_2ANT_COEX_UNDEFINED;
@@ -2453,6 +2481,7 @@ static u8 halbtc8822b2ant_action_algorithm(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_wifi_freerun(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	bool wifi_busy = false;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 bt_rssi_state;
@@ -2527,6 +2556,7 @@ static void halbtc8822b2ant_action_bt_whql_test(struct btc_coexist *btcoexist)
 
 static void halbtc8822b2ant_action_bt_relink(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 
 	if ((!coex_sta->is_bt_multi_link && !bt_link_info->pan_exist) ||
@@ -2546,6 +2576,7 @@ static void halbtc8822b2ant_action_bt_relink(struct btc_coexist *btcoexist)
 
 static void halbtc8822b2ant_action_bt_idle(struct btc_coexist *btcoexist)
 {
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	bool wifi_busy = false;
 
 	halbtc8822b2ant_adjust_wl_tx_power(btcoexist, NORMAL_EXEC, 0xd8);
@@ -2580,6 +2611,7 @@ static void halbtc8822b2ant_action_bt_idle(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	bool wifi_connected = false;
 	bool wifi_scan = false, wifi_link = false, wifi_roam = false;
 	bool wifi_busy = false;
@@ -2645,6 +2677,8 @@ static void halbtc8822b2ant_action_bt_inquiry(struct btc_coexist *btcoexist)
 /* SCO only or SCO+PAN(HS) */
 static void halbtc8822b2ant_action_sco(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -2713,6 +2747,8 @@ static void halbtc8822b2ant_action_sco(struct btc_coexist *btcoexist)
 
 static void halbtc8822b2ant_action_hid(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -2790,6 +2826,8 @@ static void halbtc8822b2ant_action_hid(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_a2dpsink(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -2862,6 +2900,8 @@ static void halbtc8822b2ant_action_a2dpsink(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_a2dp(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -2937,6 +2977,8 @@ static void halbtc8822b2ant_action_a2dp(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -3001,6 +3043,8 @@ static void halbtc8822b2ant_action_pan_edr(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -3070,6 +3114,8 @@ static void halbtc8822b2ant_action_hid_a2dp(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -3146,6 +3192,8 @@ static void halbtc8822b2ant_action_a2dp_pan_hs(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -3208,6 +3256,8 @@ static void halbtc8822b2ant_action_pan_edr_a2dp(struct btc_coexist *btcoexist)
 
 static void halbtc8822b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -3268,6 +3318,8 @@ static void halbtc8822b2ant_action_pan_edr_hid(struct btc_coexist *btcoexist)
 static void
 halbtc8822b2ant_action_hid_a2dp_pan_edr(struct btc_coexist *btcoexist)
 {
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	static u8 prewifi_rssi_state = BTC_RSSI_STATE_LOW;
 	static u8 pre_bt_rssi_state = BTC_RSSI_STATE_LOW;
 	u8 wifi_rssi_state, bt_rssi_state;
@@ -3454,6 +3506,7 @@ halbtc8822b2ant_action_wifi_multi_port(struct btc_coexist *btcoexist,
 static void halbtc8822b2ant_action_wifi_connected(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 
 	switch (coex_dm->cur_algorithm) {
 	case BT_8822B_2ANT_COEX_SCO:
@@ -3524,6 +3577,8 @@ static void halbtc8822b2ant_action_wifi_connected(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	u8 algorithm = 0, mcc_dualband = BTC_MULTIPORT_SCC;
 	u32 num_of_wifi_link = 0;
 	u32 wifi_link_status = 0;
@@ -3702,6 +3757,7 @@ static void halbtc8822b2ant_run_coexist_mechanism(struct btc_coexist *btcoexist)
 static void halbtc8822b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], Coex Mechanism Init!!\n");
@@ -3724,6 +3780,8 @@ static void halbtc8822b2ant_init_hw_config(struct btc_coexist *btcoexist,
 					   bool wifi_only)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct rfe_type_8822b_2ant *rfe_type = &btcoexist->rfe_type_8822b_2ant;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	u32 u32tmp1 = 0, u32tmp2 = 0, u32tmp3 = 0;
 	u32 RTL97F_8822B = 0;
 	u8 i = 0;
@@ -3866,6 +3924,7 @@ static void halbtc8822b2ant_init_hw_config(struct btc_coexist *btcoexist,
 void ex_btc8822b2ant_power_on_setting(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	u8 u8tmp = 0x0;
 	u16 u16tmp = 0x0;
 
@@ -3973,6 +4032,9 @@ void ex_btc8822b2ant_init_coex_dm(struct btc_coexist *btcoexist)
 void ex_btc8822b2ant_display_simple_coex_info(struct btc_coexist *btcoexist,
 					      struct seq_file *m)
 {
+	struct rfe_type_8822b_2ant *rfe_type = &btcoexist->rfe_type_8822b_2ant;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u32 bt_patch_ver = 0, bt_coex_ver = 0;
@@ -4082,6 +4144,9 @@ void ex_btc8822b2ant_display_simple_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8822b2ant_display_coex_info(struct btc_coexist *btcoexist,
 				       struct seq_file *m)
 {
+	struct rfe_type_8822b_2ant *rfe_type = &btcoexist->rfe_type_8822b_2ant;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	struct btc_board_info *board_info = &btcoexist->board_info;
 	struct btc_bt_link_info *bt_link_info = &btcoexist->bt_link_info;
 	u8 u8tmp[4], i, ps_tdma_case = 0;
@@ -4528,6 +4593,7 @@ void ex_btc8822b2ant_display_coex_info(struct btc_coexist *btcoexist,
 void ex_btc8822b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -4565,6 +4631,7 @@ void ex_btc8822b2ant_ips_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8822b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	static bool pre_force_lps_on;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
@@ -4611,6 +4678,7 @@ void ex_btc8822b2ant_lps_notify(struct btc_coexist *btcoexist, u8 type)
 void ex_btc8822b2ant_scan_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	bool wifi_connected = false;
 	bool wifi_under_5g = false;
 
@@ -4675,6 +4743,7 @@ void ex_btc8822b2ant_switchband_notify(struct btc_coexist *btcoexist,
 				       u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -4704,6 +4773,8 @@ void ex_btc8822b2ant_switchband_notify(struct btc_coexist *btcoexist,
 void ex_btc8822b2ant_connect_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
 		return;
@@ -4762,6 +4833,7 @@ void ex_btc8822b2ant_media_status_notify(struct btc_coexist *btcoexist,
 					 u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	bool wifi_under_b_mode = false, wifi_under_5g = false;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
@@ -4837,6 +4909,8 @@ void ex_btc8822b2ant_specific_packet_notify(struct btc_coexist *btcoexist,
 					    u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	bool under_4way = false, wifi_under_5g = false;
 
 	if (btcoexist->manual_control || btcoexist->stop_coex_dm)
@@ -4889,6 +4963,7 @@ void ex_btc8822b2ant_bt_info_notify(struct btc_coexist *btcoexist,
 				    u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	u8 i, rsp_source = 0;
 	bool wifi_connected = false;
 	bool wifi_scan = false, wifi_link = false, wifi_roam = false,
@@ -5105,6 +5180,7 @@ void ex_btc8822b2ant_wl_fwdbginfo_notify(struct btc_coexist *btcoexist,
 					 u8 *tmp_buf, u8 length)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	u8 i = 0;
 	static u8 tmp_buf_pre[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
 
@@ -5130,6 +5206,8 @@ void ex_btc8822b2ant_rx_rate_change_notify(struct btc_coexist *btcoexist,
 					   u8 btc_rate_id)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
+	struct coex_dm_8822b_2ant *coex_dm = &btcoexist->coex_dm_8822b_2ant;
 	bool wifi_connected = false;
 
 	btcoexist->btc_get(btcoexist, BTC_GET_BL_WIFI_CONNECTED,
@@ -5189,6 +5267,7 @@ void ex_btc8822b2ant_rx_rate_change_notify(struct btc_coexist *btcoexist,
 void ex_btc8822b2ant_rf_status_notify(struct btc_coexist *btcoexist, u8 type)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
 		 "[BTCoex], RF Status notify\n");
@@ -5248,6 +5327,7 @@ void ex_btc8822b2ant_halt_notify(struct btc_coexist *btcoexist)
 void ex_btc8822b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	bool wifi_under_5g = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD, "[BTCoex], Pnp notify\n");
@@ -5300,6 +5380,7 @@ void ex_btc8822b2ant_pnp_notify(struct btc_coexist *btcoexist, u8 pnp_state)
 void ex_btc8822b2ant_periodical(struct btc_coexist *btcoexist)
 {
 	struct rtl_priv *rtlpriv = btcoexist->adapter;
+	struct coex_sta_8822b_2ant *coex_sta = &btcoexist->coex_sta_8822b_2ant;
 	bool bt_relink_finish = false;
 
 	RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
-- 
2.15.1
