Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab2CZSuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:50:19 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so8605045iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 11:50:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/6] rtlwifi: rtl8192c: Convert driver to use private dm structs
Date: Mon, 26 Mar 2012 13:49:54 -0500
Message-Id: <1332787797-26475-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120326_205027_696513_DADA98F3)
In-Reply-To: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert rtl8192c to use the dm_digtable struct in the common header file
instead of the global variable.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |   14 +++++++++++++-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |    1 -
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |    1 -
 4 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index d8d73db..26d7018 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -33,7 +33,6 @@
 #include "../pci.h"
 #include "../base.h"
 
-struct dig_t dm_digtable;
 static struct ps_t dm_pstable;
 
 #define BT_RSSI_STATE_NORMAL_POWER	BIT_OFFSET_LEN_MASK_32(0, 1)
@@ -163,6 +162,9 @@ static const u8 cckswing_table_ch14[CCK_TABLE_SIZE][8] = {
 
 static void rtl92c_dm_diginit(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
+
 	dm_digtable.dig_enable_flag = true;
 	dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 	dm_digtable.cur_igvalue = 0x20;
@@ -186,6 +188,7 @@ static void rtl92c_dm_diginit(struct ieee80211_hw *hw)
 static u8 rtl92c_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 	long rssi_val_min = 0;
 
 	if ((dm_digtable.curmultista_connectstate == DIG_MULTISTA_CONNECT) &&
@@ -260,6 +263,7 @@ static void rtl92c_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 static void rtl92c_dm_ctrl_initgain_by_fa(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 	u8 value_igi = dm_digtable.cur_igvalue;
 
 	if (rtlpriv->falsealm_cnt.cnt_all < DM_DIG_FA_TH0)
@@ -284,6 +288,7 @@ static void rtl92c_dm_ctrl_initgain_by_fa(struct ieee80211_hw *hw)
 static void rtl92c_dm_ctrl_initgain_by_rssi(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 
 	if (rtlpriv->falsealm_cnt.cnt_all > dm_digtable.fa_highthresh) {
 		if ((dm_digtable.backoff_val - 2) <
@@ -322,6 +327,7 @@ static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 {
 	static u8 initialized; /* initialized to false */
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	long rssi_strength = rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 	bool multi_sta = false;
@@ -371,6 +377,7 @@ static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 static void rtl92c_dm_initial_gain_sta(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_TRACE,
 		 "presta_connectstate = %x, cursta_connectctate = %x\n",
@@ -400,6 +407,7 @@ static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 
 	if (dm_digtable.cursta_connectctate == DIG_STA_CONNECT) {
 		dm_digtable.rssi_val_min = rtl92c_dm_initial_gain_min_pwdb(hw);
@@ -470,6 +478,8 @@ static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 
 static void rtl92c_dm_ctrl_initgain_by_twoport(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	if (mac->act_scanning)
@@ -491,6 +501,7 @@ static void rtl92c_dm_ctrl_initgain_by_twoport(struct ieee80211_hw *hw)
 static void rtl92c_dm_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 
 	if (rtlpriv->dm.dm_initialgain_enable == false)
 		return;
@@ -514,6 +525,7 @@ static void rtl92c_dm_init_dynamic_txpower(struct ieee80211_hw *hw)
 void rtl92c_dm_write_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "cur_igvalue = 0x%x, pre_igvalue = 0x%x, backoff_val = %d\n",
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
index b3180ea..518e208 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
@@ -155,7 +155,6 @@ enum dm_dig_connect_e {
 	DIG_CONNECT_MAX
 };
 
-extern struct dig_t dm_digtable;
 void rtl92c_dm_init(struct ieee80211_hw *hw);
 void rtl92c_dm_watchdog(struct ieee80211_hw *hw);
 void rtl92c_dm_write_dig(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
index cc71e6a..088525c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -1881,6 +1881,7 @@ void rtl92c_phy_set_io(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct dig_t dm_digtable = rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_CMD, DBG_TRACE,
 		 "--->Cmd(%#x), set_io_inprogress(%d)\n",
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
index 56611d7..d4a3d03 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
@@ -150,7 +150,6 @@ enum dm_dig_connect_e {
 	DIG_CONNECT_MAX
 };
 
-extern struct dig_t dm_digtable;
 void rtl92c_dm_init(struct ieee80211_hw *hw);
 void rtl92c_dm_watchdog(struct ieee80211_hw *hw);
 void rtl92c_dm_write_dig(struct ieee80211_hw *hw);
-- 
1.7.7

