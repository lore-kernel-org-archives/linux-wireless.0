Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62055 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2CZSuZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:50:25 -0400
Received: by ghrr11 with SMTP id r11so4111435ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 11:50:23 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] rtlwifi: rtl8192c: Convert driver to use private ps_t struct
Date: Mon, 26 Mar 2012 13:49:55 -0500
Message-Id: <1332787797-26475-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120326_205032_609838_3EBDA6E7)
In-Reply-To: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver to use the private instead of global version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 26d7018..2054b22 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -33,8 +33,6 @@
 #include "../pci.h"
 #include "../base.h"
 
-static struct ps_t dm_pstable;
-
 #define BT_RSSI_STATE_NORMAL_POWER	BIT_OFFSET_LEN_MASK_32(0, 1)
 #define BT_RSSI_STATE_AMDPU_OFF		BIT_OFFSET_LEN_MASK_32(1, 1)
 #define BT_RSSI_STATE_SPECIAL_LOW	BIT_OFFSET_LEN_MASK_32(2, 1)
@@ -1235,6 +1233,9 @@ static void rtl92c_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 
 static void rtl92c_dm_init_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ps_t dm_pstable = rtlpriv->dm_pstable;
+
 	dm_pstable.pre_ccastate = CCA_MAX;
 	dm_pstable.cur_ccasate = CCA_MAX;
 	dm_pstable.pre_rfstate = RF_MAX;
@@ -1244,6 +1245,8 @@ static void rtl92c_dm_init_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 
 void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ps_t dm_pstable = rtlpriv->dm_pstable;
 	static u8 initialize;
 	static u32 reg_874, reg_c70, reg_85c, reg_a74;
 
@@ -1315,6 +1318,7 @@ static void rtl92c_dm_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct ps_t dm_pstable = rtlpriv->dm_pstable;
 
 	if (((mac->link_state == MAC80211_NOLINK)) &&
 	    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb == 0)) {
-- 
1.7.7

