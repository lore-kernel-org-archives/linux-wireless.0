Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56739 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab2CZSuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:50:25 -0400
Received: by yenl12 with SMTP id l12so4097022yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 11:50:24 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] rtlwifi: rtl8192se: Convert driver to use private dm struct
Date: Mon, 26 Mar 2012 13:49:57 -0500
Message-Id: <1332787797-26475-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120326_205032_064881_A8CDA9C9)
In-Reply-To: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver to use private version of dig_t instead of global version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c  |    6 +++++-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.h  |    2 --
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
index fbabae1..6451e93 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -35,7 +35,6 @@
 #include "dm.h"
 #include "fw.h"
 
-struct dig_t digtable;
 static const u32 edca_setting_dl[PEER_MAX] = {
 	0xa44f,		/* 0 UNKNOWN */
 	0x5ea44f,	/* 1 REALTEK_90 */
@@ -422,6 +421,7 @@ static void rtl92s_backoff_enable_flag(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
+	struct dig_t digtable = rtlpriv->dm_digtable;
 
 	if (falsealm_cnt->cnt_all > digtable.fa_highthresh) {
 		if ((digtable.backoff_val - 6) <
@@ -442,6 +442,7 @@ static void rtl92s_backoff_enable_flag(struct ieee80211_hw *hw)
 static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t digtable = rtlpriv->dm_digtable;
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
 	static u8 initialized, force_write;
 	u8 initial_gain = 0;
@@ -519,6 +520,7 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 static void _rtl92s_dm_ctrl_initgain_bytwoport(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t digtable = rtlpriv->dm_digtable;
 
 	if (rtlpriv->mac80211.act_scanning)
 		return;
@@ -551,6 +553,7 @@ static void _rtl92s_dm_ctrl_initgain_byrssi(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct dig_t digtable = rtlpriv->dm_digtable;
 
 	/* 2T2R TP issue */
 	if (rtlphy->rf_type == RF_2T2R)
@@ -639,6 +642,7 @@ static void _rtl92s_dm_dynamic_txpower(struct ieee80211_hw *hw)
 static void _rtl92s_dm_init_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t digtable = rtlpriv->dm_digtable;
 
 	/* Disable DIG scheme now.*/
 	digtable.dig_enable_flag = true;
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
index 6d5bbd0..9412bfe 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -1453,6 +1453,7 @@ bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fw_cmdio)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct dig_t digtable = rtlpriv->dm_digtable;
 	u32	fw_param = FW_CMD_IO_PARA_QUERY(rtlpriv);
 	u16	fw_cmdmap = FW_CMD_IO_QUERY(rtlpriv);
 	bool bPostProcessing = false;
-- 
1.7.7

