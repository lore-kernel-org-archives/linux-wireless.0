Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41794 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab2DSVdR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:33:17 -0400
Received: by yhmm54 with SMTP id m54so4838056yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 14:33:17 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 6/6 V2] rtlwifi: rtl8192se: Convert driver to use private dm struct
Date: Thu, 19 Apr 2012 16:32:44 -0500
Message-Id: <1334871164-9795-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120419_233332_726808_FB192361)
In-Reply-To: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver to use private version of dig_t instead of global version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c  |  156 +++++++++++++-------------
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h  |    2 -
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    7 +-
 3 files changed, 84 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
index fbabae1..2e11580 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -35,7 +35,6 @@
 #include "dm.h"
 #include "fw.h"
 
-struct dig_t digtable;
 static const u32 edca_setting_dl[PEER_MAX] = {
 	0xa44f,		/* 0 UNKNOWN */
 	0x5ea44f,	/* 1 REALTEK_90 */
@@ -421,62 +420,64 @@ static void _rtl92s_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 static void rtl92s_backoff_enable_flag(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
 
-	if (falsealm_cnt->cnt_all > digtable.fa_highthresh) {
-		if ((digtable.backoff_val - 6) <
-			digtable.backoffval_range_min)
-			digtable.backoff_val = digtable.backoffval_range_min;
+	if (falsealm_cnt->cnt_all > digtable->fa_highthresh) {
+		if ((digtable->backoff_val - 6) <
+			digtable->backoffval_range_min)
+			digtable->backoff_val = digtable->backoffval_range_min;
 		else
-			digtable.backoff_val -= 6;
-	} else if (falsealm_cnt->cnt_all < digtable.fa_lowthresh) {
-		if ((digtable.backoff_val + 6) >
-			digtable.backoffval_range_max)
-			digtable.backoff_val =
-				 digtable.backoffval_range_max;
+			digtable->backoff_val -= 6;
+	} else if (falsealm_cnt->cnt_all < digtable->fa_lowthresh) {
+		if ((digtable->backoff_val + 6) >
+			digtable->backoffval_range_max)
+			digtable->backoff_val =
+				 digtable->backoffval_range_max;
 		else
-			digtable.backoff_val += 6;
+			digtable->backoff_val += 6;
 	}
 }
 
 static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
 	static u8 initialized, force_write;
 	u8 initial_gain = 0;
 
-	if ((digtable.pre_sta_connectstate == digtable.cur_sta_connectstate) ||
-		(digtable.cur_sta_connectstate == DIG_STA_BEFORE_CONNECT)) {
-		if (digtable.cur_sta_connectstate == DIG_STA_BEFORE_CONNECT) {
+	if ((digtable->pre_sta_connectstate == digtable->cur_sta_connectstate) ||
+		(digtable->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT)) {
+		if (digtable->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT) {
 			if (rtlpriv->psc.rfpwr_state != ERFON)
 				return;
 
-			if (digtable.backoff_enable_flag)
+			if (digtable->backoff_enable_flag)
 				rtl92s_backoff_enable_flag(hw);
 			else
-				digtable.backoff_val = DM_DIG_BACKOFF;
-
-			if ((digtable.rssi_val + 10 - digtable.backoff_val) >
-				digtable.rx_gain_range_max)
-				digtable.cur_igvalue =
-						digtable.rx_gain_range_max;
-			else if ((digtable.rssi_val + 10 - digtable.backoff_val)
-				 < digtable.rx_gain_range_min)
-				digtable.cur_igvalue =
-						digtable.rx_gain_range_min;
+				digtable->backoff_val = DM_DIG_BACKOFF;
+
+			if ((digtable->rssi_val + 10 - digtable->backoff_val) >
+				digtable->rx_gain_range_max)
+				digtable->cur_igvalue =
+						digtable->rx_gain_range_max;
+			else if ((digtable->rssi_val + 10 - digtable->backoff_val)
+				 < digtable->rx_gain_range_min)
+				digtable->cur_igvalue =
+						digtable->rx_gain_range_min;
 			else
-				digtable.cur_igvalue = digtable.rssi_val + 10 -
-						digtable.backoff_val;
+				digtable->cur_igvalue = digtable->rssi_val + 10 -
+						digtable->backoff_val;
 
 			if (falsealm_cnt->cnt_all > 10000)
-				digtable.cur_igvalue =
-					 (digtable.cur_igvalue > 0x33) ?
-					 digtable.cur_igvalue : 0x33;
+				digtable->cur_igvalue =
+					 (digtable->cur_igvalue > 0x33) ?
+					 digtable->cur_igvalue : 0x33;
 
 			if (falsealm_cnt->cnt_all > 16000)
-				digtable.cur_igvalue =
-						 digtable.rx_gain_range_max;
+				digtable->cur_igvalue =
+						 digtable->rx_gain_range_max;
 		/* connected -> connected or disconnected -> disconnected  */
 		} else {
 			/* Firmware control DIG, do nothing in driver dm */
@@ -486,31 +487,31 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 		 * disconnected or beforeconnect->(dis)connected */
 	} else {
 		/* Enable FW DIG */
-		digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+		digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_ENABLE);
 
-		digtable.backoff_val = DM_DIG_BACKOFF;
-		digtable.cur_igvalue = rtlpriv->phy.default_initialgain[0];
-		digtable.pre_igvalue = 0;
+		digtable->backoff_val = DM_DIG_BACKOFF;
+		digtable->cur_igvalue = rtlpriv->phy.default_initialgain[0];
+		digtable->pre_igvalue = 0;
 		return;
 	}
 
 	/* Forced writing to prevent from fw-dig overwriting. */
-	if (digtable.pre_igvalue != rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1,
+	if (digtable->pre_igvalue != rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1,
 						  MASKBYTE0))
 		force_write = 1;
 
-	if ((digtable.pre_igvalue != digtable.cur_igvalue) ||
+	if ((digtable->pre_igvalue != digtable->cur_igvalue) ||
 	    !initialized || force_write) {
 		/* Disable FW DIG */
 		rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_DISABLE);
 
-		initial_gain = (u8)digtable.cur_igvalue;
+		initial_gain = (u8)digtable->cur_igvalue;
 
 		/* Set initial gain. */
 		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, MASKBYTE0, initial_gain);
 		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, MASKBYTE0, initial_gain);
-		digtable.pre_igvalue = digtable.cur_igvalue;
+		digtable->pre_igvalue = digtable->cur_igvalue;
 		initialized = 1;
 		force_write = 0;
 	}
@@ -519,6 +520,7 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
 
 	if (rtlpriv->mac80211.act_scanning)
 		return;
@@ -526,17 +528,17 @@ static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
 	/* Decide the current status and if modify initial gain or not */
 	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED ||
 	    rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
-		digtable.cur_sta_connectstate = DIG_STA_CONNECT;
+		digtable->cur_sta_connectstate = DIG_STA_CONNECT;
 	else
-		digtable.cur_sta_connectstate = DIG_STA_DISCONNECT;
+		digtable->cur_sta_connectstate = DIG_STA_DISCONNECT;
 
-	digtable.rssi_val = rtlpriv->dm.undecorated_smoothed_pwdb;
+	digtable->rssi_val = rtlpriv->dm.undecorated_smoothed_pwdb;
 
 	/* Change dig mode to rssi */
-	if (digtable.cur_sta_connectstate != DIG_STA_DISCONNECT) {
-		if (digtable.dig_twoport_algorithm ==
+	if (digtable->cur_sta_connectstate != DIG_STA_DISCONNECT) {
+		if (digtable->dig_twoport_algorithm ==
 		    DIG_TWO_PORT_ALGO_FALSE_ALARM) {
-			digtable.dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
+			digtable->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
 			rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_MODE_SS);
 		}
 	}
@@ -544,13 +546,14 @@ static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
 	_rtl92s_dm_false_alarm_counter_statistics(hw);
 	_rtl92s_dm_initial_gain_sta_beforeconnect(hw);
 
-	digtable.pre_sta_connectstate = digtable.cur_sta_connectstate;
+	digtable->pre_sta_connectstate = digtable->cur_sta_connectstate;
 }
 
 static void _rtl92s_dm_ctrl_initgain_byrssi(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
 
 	/* 2T2R TP issue */
 	if (rtlphy->rf_type == RF_2T2R)
@@ -559,7 +562,7 @@ static void _rtl92s_dm_ctrl_initgain_byrssi(struct ieee80211_hw *hw)
 	if (!rtlpriv->dm.dm_initialgain_enable)
 		return;
 
-	if (digtable.dig_enable_flag == false)
+	if (digtable->dig_enable_flag == false)
 		return;
 
 	_rtl92s_dm_ctrl_initgain_bytwoport(hw);
@@ -639,51 +642,52 @@ static void _rtl92s_dm_dynamic_txpower(struct ieee80211_hw *hw)
 static void _rtl92s_dm_init_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
 
 	/* Disable DIG scheme now.*/
-	digtable.dig_enable_flag = true;
-	digtable.backoff_enable_flag = true;
+	digtable->dig_enable_flag = true;
+	digtable->backoff_enable_flag = true;
 
 	if ((rtlpriv->dm.dm_type == DM_TYPE_BYDRIVER) &&
 	    (hal_get_firmwareversion(rtlpriv) >= 0x3c))
-		digtable.dig_algorithm = DIG_ALGO_BY_TOW_PORT;
+		digtable->dig_algorithm = DIG_ALGO_BY_TOW_PORT;
 	else
-		digtable.dig_algorithm =
+		digtable->dig_algorithm =
 			 DIG_ALGO_BEFORE_CONNECT_BY_RSSI_AND_ALARM;
 
-	digtable.dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
-	digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
-	/* off=by real rssi value, on=by digtable.rssi_val for new dig */
-	digtable.dig_dbgmode = DM_DBG_OFF;
-	digtable.dig_slgorithm_switch = 0;
+	digtable->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
+	digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+	/* off=by real rssi value, on=by digtable->rssi_val for new dig */
+	digtable->dig_dbgmode = DM_DBG_OFF;
+	digtable->dig_slgorithm_switch = 0;
 
 	/* 2007/10/04 MH Define init gain threshol. */
-	digtable.dig_state = DM_STA_DIG_MAX;
-	digtable.dig_highpwrstate = DM_STA_DIG_MAX;
+	digtable->dig_state = DM_STA_DIG_MAX;
+	digtable->dig_highpwrstate = DM_STA_DIG_MAX;
 
-	digtable.cur_sta_connectstate = DIG_STA_DISCONNECT;
-	digtable.pre_sta_connectstate = DIG_STA_DISCONNECT;
-	digtable.cur_ap_connectstate = DIG_AP_DISCONNECT;
-	digtable.pre_ap_connectstate = DIG_AP_DISCONNECT;
+	digtable->cur_sta_connectstate = DIG_STA_DISCONNECT;
+	digtable->pre_sta_connectstate = DIG_STA_DISCONNECT;
+	digtable->cur_ap_connectstate = DIG_AP_DISCONNECT;
+	digtable->pre_ap_connectstate = DIG_AP_DISCONNECT;
 
-	digtable.rssi_lowthresh = DM_DIG_THRESH_LOW;
-	digtable.rssi_highthresh = DM_DIG_THRESH_HIGH;
+	digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
+	digtable->rssi_highthresh = DM_DIG_THRESH_HIGH;
 
-	digtable.fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
-	digtable.fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
+	digtable->fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
+	digtable->fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
 
-	digtable.rssi_highpower_lowthresh = DM_DIG_HIGH_PWR_THRESH_LOW;
-	digtable.rssi_highpower_highthresh = DM_DIG_HIGH_PWR_THRESH_HIGH;
+	digtable->rssi_highpower_lowthresh = DM_DIG_HIGH_PWR_THRESH_LOW;
+	digtable->rssi_highpower_highthresh = DM_DIG_HIGH_PWR_THRESH_HIGH;
 
 	/* for dig debug rssi value */
-	digtable.rssi_val = 50;
-	digtable.backoff_val = DM_DIG_BACKOFF;
-	digtable.rx_gain_range_max = DM_DIG_MAX;
+	digtable->rssi_val = 50;
+	digtable->backoff_val = DM_DIG_BACKOFF;
+	digtable->rx_gain_range_max = DM_DIG_MAX;
 
-	digtable.rx_gain_range_min = DM_DIG_MIN;
+	digtable->rx_gain_range_min = DM_DIG_MIN;
 
-	digtable.backoffval_range_max = DM_DIG_BACKOFF_MAX;
-	digtable.backoffval_range_min = DM_DIG_BACKOFF_MIN;
+	digtable->backoffval_range_max = DM_DIG_BACKOFF_MAX;
+	digtable->backoffval_range_min = DM_DIG_BACKOFF_MIN;
 }
 
 static void _rtl92s_dm_init_dynamic_txpower(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.h b/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
index f8ace73..2e9052c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.h
@@ -112,8 +112,6 @@ enum dm_ratr_sta {
 #define	DM_DIG_BACKOFF_MAX		12
 #define	DM_DIG_BACKOFF_MIN		-4
 
-extern struct dig_t digtable;
-
 void rtl92s_dm_watchdog(struct ieee80211_hw *hw);
 void rtl92s_dm_init(struct ieee80211_hw *hw);
 void rtl92s_dm_init_edca_turbo(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index 4a49992..8d7099b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -1450,6 +1450,7 @@ static void _rtl92s_phy_set_fwcmd_io(struct ieee80211_hw *hw)
 bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fw_cmdio)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *digtable = &rtlpriv->dm_digtable;
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u32	fw_param = FW_CMD_IO_PARA_QUERY(rtlpriv);
@@ -1588,16 +1589,16 @@ bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fw_cmdio)
 				      FW_SS_CTL);
 
 			if (rtlpriv->dm.dm_flag & HAL_DM_DIG_DISABLE ||
-				!digtable.dig_enable_flag)
+				!digtable->dig_enable_flag)
 				fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
 
 			if ((rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) ||
 			    rtlpriv->dm.dynamic_txpower_enable)
 				fw_cmdmap &= ~FW_HIGH_PWR_ENABLE_CTL;
 
-			if ((digtable.dig_ext_port_stage ==
+			if ((digtable->dig_ext_port_stage ==
 			    DIG_EXT_PORT_STAGE_0) ||
-			    (digtable.dig_ext_port_stage ==
+			    (digtable->dig_ext_port_stage ==
 			    DIG_EXT_PORT_STAGE_1))
 				fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
 
-- 
1.7.10.130.g36e6c

