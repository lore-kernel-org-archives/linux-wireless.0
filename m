Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab2CZSuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:50:22 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so8605045iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 11:50:22 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] rtlwifi: rtl8192de: Convert driver to use private dm structs
Date: Mon, 26 Mar 2012 13:49:56 -0500
Message-Id: <1332787797-26475-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120326_205028_261307_5F74370E)
In-Reply-To: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver to use the private dig_t instead of a global version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c  |   11 +++++++++--
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h  |    2 --
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index 9fda1af..befd432 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -37,8 +37,6 @@
 
 #define UNDEC_SM_PWDB	entry_min_undecoratedsmoothed_pwdb
 
-struct dig_t de_digtable;
-
 static const u32 ofdmswing_table[OFDM_TABLE_SIZE_92D] = {
 	0x7f8001fe,		/* 0, +6.0dB */
 	0x788001e2,		/* 1, +5.5dB */
@@ -159,6 +157,9 @@ static const u8 cckswing_table_ch14[CCK_TABLE_SIZE][8] = {
 
 static void rtl92d_dm_diginit(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t de_digtable = rtlpriv->dm_digtable;
+
 	de_digtable.dig_enable_flag = true;
 	de_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 	de_digtable.cur_igvalue = 0x20;
@@ -267,6 +268,7 @@ static void rtl92d_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtlpriv);
+	struct dig_t de_digtable = rtlpriv->dm_digtable;
 
 	/* Determine the minimum RSSI  */
 	if ((mac->link_state < MAC80211_LINKED) &&
@@ -305,6 +307,7 @@ static void rtl92d_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t de_digtable = rtlpriv->dm_digtable;
 	unsigned long flag = 0;
 
 	if (de_digtable.cursta_connectctate == DIG_STA_CONNECT) {
@@ -352,6 +355,7 @@ static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 void rtl92d_dm_write_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t de_digtable = rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "cur_igvalue = 0x%x, pre_igvalue = 0x%x, backoff_val = %d\n",
@@ -373,6 +377,8 @@ void rtl92d_dm_write_dig(struct ieee80211_hw *hw)
 
 static void rtl92d_early_mode_enabled(struct rtl_priv *rtlpriv)
 {
+	struct dig_t de_digtable = rtlpriv->dm_digtable;
+
 	if ((rtlpriv->mac80211.link_state >= MAC80211_LINKED) &&
 	    (rtlpriv->mac80211.vendor == PEER_CISCO)) {
 		RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "IOT_PEER = CISCO\n");
@@ -396,6 +402,7 @@ static void rtl92d_early_mode_enabled(struct rtl_priv *rtlpriv)
 static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t de_digtable = rtlpriv->dm_digtable;
 	u8 value_igi = de_digtable.cur_igvalue;
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.h b/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
index 7ede6a7..3fea0c1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.h
@@ -151,8 +151,6 @@ enum dm_dig_connect {
 	DIG_CONNECT_MAX
 };
 
-extern struct dig_t de_digtable;
-
 void rtl92d_dm_init(struct ieee80211_hw *hw);
 void rtl92d_dm_watchdog(struct ieee80211_hw *hw);
 void rtl92d_dm_init_edca_turbo(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
index d32de7a..9cd902a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3065,6 +3065,7 @@ static void rtl92d_phy_set_io(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct dig_t de_digtable = rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_CMD, DBG_TRACE,
 		 "--->Cmd(%#x), set_io_inprogress(%d)\n",
-- 
1.7.7

