Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab2DSVdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:33:13 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so12437635iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 14:33:13 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 4/6 V2] rtlwifi: rtl8192c: Convert driver to use private ps_t struct
Date: Thu, 19 Apr 2012 16:32:42 -0500
Message-Id: <1334871164-9795-5-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120419_233327_696259_AD7B3B74)
In-Reply-To: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver to use the private instead of global version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   58 +++++++++++----------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 2efd03d..f7f48c7 100644
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
@@ -1235,15 +1233,20 @@ static void rtl92c_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 
 static void rtl92c_dm_init_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 {
-	dm_pstable.pre_ccastate = CCA_MAX;
-	dm_pstable.cur_ccasate = CCA_MAX;
-	dm_pstable.pre_rfstate = RF_MAX;
-	dm_pstable.cur_rfstate = RF_MAX;
-	dm_pstable.rssi_val_min = 0;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ps_t *dm_pstable = &rtlpriv->dm_pstable;
+
+	dm_pstable->pre_ccastate = CCA_MAX;
+	dm_pstable->cur_ccasate = CCA_MAX;
+	dm_pstable->pre_rfstate = RF_MAX;
+	dm_pstable->cur_rfstate = RF_MAX;
+	dm_pstable->rssi_val_min = 0;
 }
 
 void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ps_t *dm_pstable = &rtlpriv->dm_pstable;
 	static u8 initialize;
 	static u32 reg_874, reg_c70, reg_85c, reg_a74;
 
@@ -1263,27 +1266,27 @@ void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal)
 	}
 
 	if (!bforce_in_normal) {
-		if (dm_pstable.rssi_val_min != 0) {
-			if (dm_pstable.pre_rfstate == RF_NORMAL) {
-				if (dm_pstable.rssi_val_min >= 30)
-					dm_pstable.cur_rfstate = RF_SAVE;
+		if (dm_pstable->rssi_val_min != 0) {
+			if (dm_pstable->pre_rfstate == RF_NORMAL) {
+				if (dm_pstable->rssi_val_min >= 30)
+					dm_pstable->cur_rfstate = RF_SAVE;
 				else
-					dm_pstable.cur_rfstate = RF_NORMAL;
+					dm_pstable->cur_rfstate = RF_NORMAL;
 			} else {
-				if (dm_pstable.rssi_val_min <= 25)
-					dm_pstable.cur_rfstate = RF_NORMAL;
+				if (dm_pstable->rssi_val_min <= 25)
+					dm_pstable->cur_rfstate = RF_NORMAL;
 				else
-					dm_pstable.cur_rfstate = RF_SAVE;
+					dm_pstable->cur_rfstate = RF_SAVE;
 			}
 		} else {
-			dm_pstable.cur_rfstate = RF_MAX;
+			dm_pstable->cur_rfstate = RF_MAX;
 		}
 	} else {
-		dm_pstable.cur_rfstate = RF_NORMAL;
+		dm_pstable->cur_rfstate = RF_NORMAL;
 	}
 
-	if (dm_pstable.pre_rfstate != dm_pstable.cur_rfstate) {
-		if (dm_pstable.cur_rfstate == RF_SAVE) {
+	if (dm_pstable->pre_rfstate != dm_pstable->cur_rfstate) {
+		if (dm_pstable->cur_rfstate == RF_SAVE) {
 			rtl_set_bbreg(hw, RFPGA0_XCD_RFINTERFACESW,
 				      0x1C0000, 0x2);
 			rtl_set_bbreg(hw, ROFDM0_AGCPARAMETER1, BIT(3), 0);
@@ -1305,7 +1308,7 @@ void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal)
 			rtl_set_bbreg(hw, 0x818, BIT(28), 0x0);
 		}
 
-		dm_pstable.pre_rfstate = dm_pstable.cur_rfstate;
+		dm_pstable->pre_rfstate = dm_pstable->cur_rfstate;
 	}
 }
 EXPORT_SYMBOL(rtl92c_dm_rf_saving);
@@ -1313,36 +1316,37 @@ EXPORT_SYMBOL(rtl92c_dm_rf_saving);
 static void rtl92c_dm_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct ps_t *dm_pstable = &rtlpriv->dm_pstable;
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
 	if (((mac->link_state == MAC80211_NOLINK)) &&
 	    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb == 0)) {
-		dm_pstable.rssi_val_min = 0;
+		dm_pstable->rssi_val_min = 0;
 		RT_TRACE(rtlpriv, DBG_LOUD, DBG_LOUD, "Not connected to any\n");
 	}
 
 	if (mac->link_state == MAC80211_LINKED) {
 		if (mac->opmode == NL80211_IFTYPE_ADHOC) {
-			dm_pstable.rssi_val_min =
+			dm_pstable->rssi_val_min =
 			    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 			RT_TRACE(rtlpriv, DBG_LOUD, DBG_LOUD,
 				 "AP Client PWDB = 0x%lx\n",
-				 dm_pstable.rssi_val_min);
+				 dm_pstable->rssi_val_min);
 		} else {
-			dm_pstable.rssi_val_min =
+			dm_pstable->rssi_val_min =
 			    rtlpriv->dm.undecorated_smoothed_pwdb;
 			RT_TRACE(rtlpriv, DBG_LOUD, DBG_LOUD,
 				 "STA Default Port PWDB = 0x%lx\n",
-				 dm_pstable.rssi_val_min);
+				 dm_pstable->rssi_val_min);
 		}
 	} else {
-		dm_pstable.rssi_val_min =
+		dm_pstable->rssi_val_min =
 		    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 
 		RT_TRACE(rtlpriv, DBG_LOUD, DBG_LOUD,
 			 "AP Ext Port PWDB = 0x%lx\n",
-			 dm_pstable.rssi_val_min);
+			 dm_pstable->rssi_val_min);
 	}
 
 	if (IS_92C_SERIAL(rtlhal->version))
-- 
1.7.10.130.g36e6c

