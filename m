Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53097 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab2K1UB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 15:01:27 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so5927851bkw.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 12:01:26 -0800 (PST)
From: Daniel Stamer <daniel@stamer.info>
To: linville@tuxdriver.com
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
	Daniel Stamer <daniel@stamer.info>
Subject: [PATCH] rtlwifi: rtl8192se: Fixed coding style issues
Date: Wed, 28 Nov 2012 21:01:19 +0100
Message-Id: <1354132879-5154-1-git-send-email-daniel@stamer.info> (sfid-20121128_210131_719548_3F777BFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes coding style issues in the whole rtl8192se driver. All rules
are used, except for the one which demands empty last lines on block comments.
Some fields have been altered to create readable lines in 80 columns.

Signed-off-by: Daniel Stamer <daniel@stamer.info>
---
 drivers/net/wireless/rtlwifi/rtl8192se/def.h |  3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c  | 79 +++++++++++++---------------
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |  3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.h  |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/sw.c  |  9 ++--
 5 files changed, 44 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
index 20afec6..2d255e0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
@@ -522,8 +522,7 @@ enum fwcmd_iotype {
 	FW_CMD_IQK_ENABLE = 30,
 };
 
-/*
- * Driver info contain PHY status
+/* Driver info contain PHY status
  * and other variabel size info
  * PHY Status content as below
  */
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
index 465f581..618efe7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -442,42 +442,39 @@ static void rtl92s_backoff_enable_flag(struct ieee80211_hw *hw)
 static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct dig_t *digtable = &rtlpriv->dm_digtable;
+	struct dig_t *dig = &rtlpriv->dm_digtable;
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
-	static u8 initialized, force_write;
+	static u8 init, force_write;
 	u8 initial_gain = 0;
 
-	if ((digtable->pre_sta_connectstate == digtable->cur_sta_connectstate) ||
-		(digtable->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT)) {
-		if (digtable->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT) {
+	if ((dig->pre_sta_connectstate == dig->cur_sta_connectstate) ||
+		(dig->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT)) {
+		if (dig->cur_sta_connectstate == DIG_STA_BEFORE_CONNECT) {
 			if (rtlpriv->psc.rfpwr_state != ERFON)
 				return;
 
-			if (digtable->backoff_enable_flag)
+			if (dig->backoff_enable_flag)
 				rtl92s_backoff_enable_flag(hw);
 			else
-				digtable->backoff_val = DM_DIG_BACKOFF;
-
-			if ((digtable->rssi_val + 10 - digtable->backoff_val) >
-				digtable->rx_gain_range_max)
-				digtable->cur_igvalue =
-						digtable->rx_gain_range_max;
-			else if ((digtable->rssi_val + 10 - digtable->backoff_val)
-				 < digtable->rx_gain_range_min)
-				digtable->cur_igvalue =
-						digtable->rx_gain_range_min;
+				dig->backoff_val = DM_DIG_BACKOFF;
+
+			if ((dig->rssi_val + 10 - dig->backoff_val) >
+				dig->rx_gain_range_max)
+				dig->cur_igvalue = dig->rx_gain_range_max;
+			else if ((dig->rssi_val + 10 - dig->backoff_val)
+				 < dig->rx_gain_range_min)
+				dig->cur_igvalue = dig->rx_gain_range_min;
 			else
-				digtable->cur_igvalue = digtable->rssi_val + 10 -
-						digtable->backoff_val;
+				dig->cur_igvalue = dig->rssi_val + 10
+					- dig->backoff_val;
 
 			if (falsealm_cnt->cnt_all > 10000)
-				digtable->cur_igvalue =
-					 (digtable->cur_igvalue > 0x33) ?
-					 digtable->cur_igvalue : 0x33;
+				dig->cur_igvalue = (dig->cur_igvalue > 0x33) ?
+					 dig->cur_igvalue : 0x33;
 
 			if (falsealm_cnt->cnt_all > 16000)
-				digtable->cur_igvalue =
-						 digtable->rx_gain_range_max;
+				dig->cur_igvalue = dig->rx_gain_range_max;
+
 		/* connected -> connected or disconnected -> disconnected  */
 		} else {
 			/* Firmware control DIG, do nothing in driver dm */
@@ -487,32 +484,30 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 		 * disconnected or beforeconnect->(dis)connected */
 	} else {
 		/* Enable FW DIG */
-		digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+		dig->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_ENABLE);
 
-		digtable->backoff_val = DM_DIG_BACKOFF;
-		digtable->cur_igvalue = rtlpriv->phy.default_initialgain[0];
-		digtable->pre_igvalue = 0;
+		dig->backoff_val = DM_DIG_BACKOFF;
+		dig->cur_igvalue = rtlpriv->phy.default_initialgain[0];
+		dig->pre_igvalue = 0;
 		return;
 	}
 
 	/* Forced writing to prevent from fw-dig overwriting. */
-	if (digtable->pre_igvalue != rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1,
-						  MASKBYTE0))
+	if (dig->pre_igvalue != rtl_get_bbreg(hw, ROFDM0_XAAGCCORE1, MASKBYTE0))
 		force_write = 1;
 
-	if ((digtable->pre_igvalue != digtable->cur_igvalue) ||
-	    !initialized || force_write) {
+	if ((dig->pre_igvalue != dig->cur_igvalue) || !init || force_write) {
 		/* Disable FW DIG */
 		rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_DISABLE);
 
-		initial_gain = (u8)digtable->cur_igvalue;
+		initial_gain = (u8)dig->cur_igvalue;
 
 		/* Set initial gain. */
 		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, MASKBYTE0, initial_gain);
 		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, MASKBYTE0, initial_gain);
-		digtable->pre_igvalue = digtable->cur_igvalue;
-		initialized = 1;
+		dig->pre_igvalue = dig->cur_igvalue;
+		init = 1;
 		force_write = 0;
 	}
 }
@@ -520,7 +515,7 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct dig_t *digtable = &rtlpriv->dm_digtable;
+	struct dig_t *dig = &rtlpriv->dm_digtable;
 
 	if (rtlpriv->mac80211.act_scanning)
 		return;
@@ -528,17 +523,17 @@ static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
 	/* Decide the current status and if modify initial gain or not */
 	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED ||
 	    rtlpriv->mac80211.opmode == NL80211_IFTYPE_ADHOC)
-		digtable->cur_sta_connectstate = DIG_STA_CONNECT;
+		dig->cur_sta_connectstate = DIG_STA_CONNECT;
 	else
-		digtable->cur_sta_connectstate = DIG_STA_DISCONNECT;
+		dig->cur_sta_connectstate = DIG_STA_DISCONNECT;
 
-	digtable->rssi_val = rtlpriv->dm.undecorated_smoothed_pwdb;
+	dig->rssi_val = rtlpriv->dm.undecorated_smoothed_pwdb;
 
 	/* Change dig mode to rssi */
-	if (digtable->cur_sta_connectstate != DIG_STA_DISCONNECT) {
-		if (digtable->dig_twoport_algorithm ==
+	if (dig->cur_sta_connectstate != DIG_STA_DISCONNECT) {
+		if (dig->dig_twoport_algorithm ==
 		    DIG_TWO_PORT_ALGO_FALSE_ALARM) {
-			digtable->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
+			dig->dig_twoport_algorithm = DIG_TWO_PORT_ALGO_RSSI;
 			rtl92s_phy_set_fw_cmd(hw, FW_CMD_DIG_MODE_SS);
 		}
 	}
@@ -546,7 +541,7 @@ static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
 	_rtl92s_dm_false_alarm_counter_statistics(hw);
 	_rtl92s_dm_initial_gain_sta_beforeconnect(hw);
 
-	digtable->pre_sta_connectstate = digtable->cur_sta_connectstate;
+	dig->pre_sta_connectstate = dig->cur_sta_connectstate;
 }
 
 static void _rtl92s_dm_ctrl_initgain_byrssi(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 4542e69..976c6a4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1089,8 +1089,9 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 	return err;
 }
 
-void rtl92se_set_mac_addr(struct rtl_io *io, const u8 * addr)
+void rtl92se_set_mac_addr(struct rtl_io *io, const u8 *addr)
 {
+	/* This is obviously a stub. */
 }
 
 void rtl92se_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
index 1886c26..a8e068c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.h
@@ -54,7 +54,7 @@ void rtl92se_disable_interrupt(struct ieee80211_hw *hw);
 int rtl92se_set_network_type(struct ieee80211_hw *hw,
 			     enum nl80211_iftype type);
 void rtl92se_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
-void rtl92se_set_mac_addr(struct rtl_io *io, const u8 * addr);
+void rtl92se_set_mac_addr(struct rtl_io *io, const u8 *addr);
 void rtl92se_set_qos(struct ieee80211_hw *hw, int aci);
 void rtl92se_set_beacon_related_registers(struct ieee80211_hw *hw);
 void rtl92se_set_beacon_interval(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
index ad4b480..c725133 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
@@ -50,8 +50,7 @@ static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
 	/*close ASPM for AMD defaultly */
 	rtlpci->const_amdpci_aspm = 0;
 
-	/*
-	 * ASPM PS mode.
+	/* ASPM PS mode.
 	 * 0 - Disable ASPM,
 	 * 1 - Enable ASPM without Clock Req,
 	 * 2 - Enable ASPM with Clock Req,
@@ -67,8 +66,7 @@ static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
 	/*Setting for PCI-E bridge */
 	rtlpci->const_hostpci_aspm_setting = 0x02;
 
-	/*
-	 * In Hw/Sw Radio Off situation.
+	/* In Hw/Sw Radio Off situation.
 	 * 0 - Default,
 	 * 1 - From ASPM setting without low Mac Pwr,
 	 * 2 - From ASPM setting with low Mac Pwr,
@@ -77,8 +75,7 @@ static void rtl92s_init_aspm_vars(struct ieee80211_hw *hw)
 	 */
 	rtlpci->const_hwsw_rfoff_d3 = 2;
 
-	/*
-	 * This setting works for those device with
+	/* This setting works for those device with
 	 * backdoor ASPM setting such as EPHY setting.
 	 * 0 - Not support ASPM,
 	 * 1 - Support ASPM,
-- 
1.8.0.1

