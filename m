Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2DSVdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:33:11 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so12437635iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 14:33:11 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/6 V2] rtlwifi: rtl8192c: Convert driver to use private dm structs
Date: Thu, 19 Apr 2012 16:32:41 -0500
Message-Id: <1334871164-9795-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120419_233324_939422_4B613D35)
In-Reply-To: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert rtl8192c to use the dm_digtable struct in the common header file
instead of the global variable. Without this change, every instance of
rtl8192ce and rtl8192cu will be using the same global arrays.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |  232 ++++++++++----------
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |    1 -
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |    1 -
 4 files changed, 123 insertions(+), 112 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 1208b75..2efd03d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -33,7 +33,6 @@
 #include "../pci.h"
 #include "../base.h"
 
-struct dig_t dm_digtable;
 static struct ps_t dm_pstable;
 
 #define BT_RSSI_STATE_NORMAL_POWER	BIT_OFFSET_LEN_MASK_32(0, 1)
@@ -163,33 +162,37 @@ static const u8 cckswing_table_ch14[CCK_TABLE_SIZE][8] = {
 
 static void rtl92c_dm_diginit(struct ieee80211_hw *hw)
 {
-	dm_digtable.dig_enable_flag = true;
-	dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
-	dm_digtable.cur_igvalue = 0x20;
-	dm_digtable.pre_igvalue = 0x0;
-	dm_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
-	dm_digtable.presta_connectstate = DIG_STA_DISCONNECT;
-	dm_digtable.curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
-	dm_digtable.rssi_lowthresh = DM_DIG_THRESH_LOW;
-	dm_digtable.rssi_highthresh = DM_DIG_THRESH_HIGH;
-	dm_digtable.fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
-	dm_digtable.fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
-	dm_digtable.rx_gain_range_max = DM_DIG_MAX;
-	dm_digtable.rx_gain_range_min = DM_DIG_MIN;
-	dm_digtable.backoff_val = DM_DIG_BACKOFF_DEFAULT;
-	dm_digtable.backoff_val_range_max = DM_DIG_BACKOFF_MAX;
-	dm_digtable.backoff_val_range_min = DM_DIG_BACKOFF_MIN;
-	dm_digtable.pre_cck_pd_state = CCK_PD_STAGE_MAX;
-	dm_digtable.cur_cck_pd_state = CCK_PD_STAGE_MAX;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
+
+	dm_digtable->dig_enable_flag = true;
+	dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+	dm_digtable->cur_igvalue = 0x20;
+	dm_digtable->pre_igvalue = 0x0;
+	dm_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
+	dm_digtable->presta_connectstate = DIG_STA_DISCONNECT;
+	dm_digtable->curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
+	dm_digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
+	dm_digtable->rssi_highthresh = DM_DIG_THRESH_HIGH;
+	dm_digtable->fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
+	dm_digtable->fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
+	dm_digtable->rx_gain_range_max = DM_DIG_MAX;
+	dm_digtable->rx_gain_range_min = DM_DIG_MIN;
+	dm_digtable->backoff_val = DM_DIG_BACKOFF_DEFAULT;
+	dm_digtable->backoff_val_range_max = DM_DIG_BACKOFF_MAX;
+	dm_digtable->backoff_val_range_min = DM_DIG_BACKOFF_MIN;
+	dm_digtable->pre_cck_pd_state = CCK_PD_STAGE_MAX;
+	dm_digtable->cur_cck_pd_state = CCK_PD_STAGE_MAX;
 }
 
 static u8 rtl92c_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 	long rssi_val_min = 0;
 
-	if ((dm_digtable.curmultista_connectstate == DIG_MULTISTA_CONNECT) &&
-	    (dm_digtable.cursta_connectctate == DIG_STA_CONNECT)) {
+	if ((dm_digtable->curmultista_connectstate == DIG_MULTISTA_CONNECT) &&
+	    (dm_digtable->cursta_connectctate == DIG_STA_CONNECT)) {
 		if (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb != 0)
 			rssi_val_min =
 			    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb >
@@ -198,10 +201,10 @@ static u8 rtl92c_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
 			    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 		else
 			rssi_val_min = rtlpriv->dm.undecorated_smoothed_pwdb;
-	} else if (dm_digtable.cursta_connectctate == DIG_STA_CONNECT ||
-		   dm_digtable.cursta_connectctate == DIG_STA_BEFORE_CONNECT) {
+	} else if (dm_digtable->cursta_connectctate == DIG_STA_CONNECT ||
+		   dm_digtable->cursta_connectctate == DIG_STA_BEFORE_CONNECT) {
 		rssi_val_min = rtlpriv->dm.undecorated_smoothed_pwdb;
-	} else if (dm_digtable.curmultista_connectstate ==
+	} else if (dm_digtable->curmultista_connectstate ==
 		   DIG_MULTISTA_CONNECT) {
 		rssi_val_min = rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 	}
@@ -260,7 +263,8 @@ static void rtl92c_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 static void rtl92c_dm_ctrl_initgain_by_fa(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value_igi = dm_digtable.cur_igvalue;
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
+	u8 value_igi = dm_digtable->cur_igvalue;
 
 	if (rtlpriv->falsealm_cnt.cnt_all < DM_DIG_FA_TH0)
 		value_igi--;
@@ -277,43 +281,44 @@ static void rtl92c_dm_ctrl_initgain_by_fa(struct ieee80211_hw *hw)
 	if (rtlpriv->falsealm_cnt.cnt_all > 10000)
 		value_igi = 0x32;
 
-	dm_digtable.cur_igvalue = value_igi;
+	dm_digtable->cur_igvalue = value_igi;
 	rtl92c_dm_write_dig(hw);
 }
 
 static void rtl92c_dm_ctrl_initgain_by_rssi(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 
-	if (rtlpriv->falsealm_cnt.cnt_all > dm_digtable.fa_highthresh) {
-		if ((dm_digtable.backoff_val - 2) <
-		    dm_digtable.backoff_val_range_min)
-			dm_digtable.backoff_val =
-			    dm_digtable.backoff_val_range_min;
+	if (rtlpriv->falsealm_cnt.cnt_all > dm_digtable->fa_highthresh) {
+		if ((dm_digtable->backoff_val - 2) <
+		    dm_digtable->backoff_val_range_min)
+			dm_digtable->backoff_val =
+			    dm_digtable->backoff_val_range_min;
 		else
-			dm_digtable.backoff_val -= 2;
-	} else if (rtlpriv->falsealm_cnt.cnt_all < dm_digtable.fa_lowthresh) {
-		if ((dm_digtable.backoff_val + 2) >
-		    dm_digtable.backoff_val_range_max)
-			dm_digtable.backoff_val =
-			    dm_digtable.backoff_val_range_max;
+			dm_digtable->backoff_val -= 2;
+	} else if (rtlpriv->falsealm_cnt.cnt_all < dm_digtable->fa_lowthresh) {
+		if ((dm_digtable->backoff_val + 2) >
+		    dm_digtable->backoff_val_range_max)
+			dm_digtable->backoff_val =
+			    dm_digtable->backoff_val_range_max;
 		else
-			dm_digtable.backoff_val += 2;
+			dm_digtable->backoff_val += 2;
 	}
 
-	if ((dm_digtable.rssi_val_min + 10 - dm_digtable.backoff_val) >
-	    dm_digtable.rx_gain_range_max)
-		dm_digtable.cur_igvalue = dm_digtable.rx_gain_range_max;
-	else if ((dm_digtable.rssi_val_min + 10 -
-		  dm_digtable.backoff_val) < dm_digtable.rx_gain_range_min)
-		dm_digtable.cur_igvalue = dm_digtable.rx_gain_range_min;
+	if ((dm_digtable->rssi_val_min + 10 - dm_digtable->backoff_val) >
+	    dm_digtable->rx_gain_range_max)
+		dm_digtable->cur_igvalue = dm_digtable->rx_gain_range_max;
+	else if ((dm_digtable->rssi_val_min + 10 -
+		  dm_digtable->backoff_val) < dm_digtable->rx_gain_range_min)
+		dm_digtable->cur_igvalue = dm_digtable->rx_gain_range_min;
 	else
-		dm_digtable.cur_igvalue = dm_digtable.rssi_val_min + 10 -
-		    dm_digtable.backoff_val;
+		dm_digtable->cur_igvalue = dm_digtable->rssi_val_min + 10 -
+		    dm_digtable->backoff_val;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_TRACE,
 		 "rssi_val_min = %x backoff_val %x\n",
-		 dm_digtable.rssi_val_min, dm_digtable.backoff_val);
+		 dm_digtable->rssi_val_min, dm_digtable->backoff_val);
 
 	rtl92c_dm_write_dig(hw);
 }
@@ -322,6 +327,7 @@ static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 {
 	static u8 initialized; /* initialized to false */
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	long rssi_strength = rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 	bool multi_sta = false;
@@ -330,68 +336,69 @@ static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 		multi_sta = true;
 
 	if (!multi_sta ||
-	    dm_digtable.cursta_connectctate != DIG_STA_DISCONNECT) {
+	    dm_digtable->cursta_connectctate != DIG_STA_DISCONNECT) {
 		initialized = false;
-		dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		return;
 	} else if (initialized == false) {
 		initialized = true;
-		dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_0;
-		dm_digtable.cur_igvalue = 0x20;
+		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_0;
+		dm_digtable->cur_igvalue = 0x20;
 		rtl92c_dm_write_dig(hw);
 	}
 
-	if (dm_digtable.curmultista_connectstate == DIG_MULTISTA_CONNECT) {
-		if ((rssi_strength < dm_digtable.rssi_lowthresh) &&
-		    (dm_digtable.dig_ext_port_stage != DIG_EXT_PORT_STAGE_1)) {
+	if (dm_digtable->curmultista_connectstate == DIG_MULTISTA_CONNECT) {
+		if ((rssi_strength < dm_digtable->rssi_lowthresh) &&
+		    (dm_digtable->dig_ext_port_stage != DIG_EXT_PORT_STAGE_1)) {
 
-			if (dm_digtable.dig_ext_port_stage ==
+			if (dm_digtable->dig_ext_port_stage ==
 			    DIG_EXT_PORT_STAGE_2) {
-				dm_digtable.cur_igvalue = 0x20;
+				dm_digtable->cur_igvalue = 0x20;
 				rtl92c_dm_write_dig(hw);
 			}
 
-			dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_1;
-		} else if (rssi_strength > dm_digtable.rssi_highthresh) {
-			dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_2;
+			dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_1;
+		} else if (rssi_strength > dm_digtable->rssi_highthresh) {
+			dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_2;
 			rtl92c_dm_ctrl_initgain_by_fa(hw);
 		}
-	} else if (dm_digtable.dig_ext_port_stage != DIG_EXT_PORT_STAGE_0) {
-		dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_0;
-		dm_digtable.cur_igvalue = 0x20;
+	} else if (dm_digtable->dig_ext_port_stage != DIG_EXT_PORT_STAGE_0) {
+		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_0;
+		dm_digtable->cur_igvalue = 0x20;
 		rtl92c_dm_write_dig(hw);
 	}
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_TRACE,
 		 "curmultista_connectstate = %x dig_ext_port_stage %x\n",
-		 dm_digtable.curmultista_connectstate,
-		 dm_digtable.dig_ext_port_stage);
+		 dm_digtable->curmultista_connectstate,
+		 dm_digtable->dig_ext_port_stage);
 }
 
 static void rtl92c_dm_initial_gain_sta(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_TRACE,
 		 "presta_connectstate = %x, cursta_connectctate = %x\n",
-		 dm_digtable.presta_connectstate,
-		 dm_digtable.cursta_connectctate);
+		 dm_digtable->presta_connectstate,
+		 dm_digtable->cursta_connectctate);
 
-	if (dm_digtable.presta_connectstate == dm_digtable.cursta_connectctate
-	    || dm_digtable.cursta_connectctate == DIG_STA_BEFORE_CONNECT
-	    || dm_digtable.cursta_connectctate == DIG_STA_CONNECT) {
+	if (dm_digtable->presta_connectstate == dm_digtable->cursta_connectctate
+	    || dm_digtable->cursta_connectctate == DIG_STA_BEFORE_CONNECT
+	    || dm_digtable->cursta_connectctate == DIG_STA_CONNECT) {
 
-		if (dm_digtable.cursta_connectctate != DIG_STA_DISCONNECT) {
-			dm_digtable.rssi_val_min =
+		if (dm_digtable->cursta_connectctate != DIG_STA_DISCONNECT) {
+			dm_digtable->rssi_val_min =
 			    rtl92c_dm_initial_gain_min_pwdb(hw);
 			rtl92c_dm_ctrl_initgain_by_rssi(hw);
 		}
 	} else {
-		dm_digtable.rssi_val_min = 0;
-		dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
-		dm_digtable.backoff_val = DM_DIG_BACKOFF_DEFAULT;
-		dm_digtable.cur_igvalue = 0x20;
-		dm_digtable.pre_igvalue = 0;
+		dm_digtable->rssi_val_min = 0;
+		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+		dm_digtable->backoff_val = DM_DIG_BACKOFF_DEFAULT;
+		dm_digtable->cur_igvalue = 0x20;
+		dm_digtable->pre_igvalue = 0;
 		rtl92c_dm_write_dig(hw);
 	}
 }
@@ -400,40 +407,41 @@ static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 
-	if (dm_digtable.cursta_connectctate == DIG_STA_CONNECT) {
-		dm_digtable.rssi_val_min = rtl92c_dm_initial_gain_min_pwdb(hw);
+	if (dm_digtable->cursta_connectctate == DIG_STA_CONNECT) {
+		dm_digtable->rssi_val_min = rtl92c_dm_initial_gain_min_pwdb(hw);
 
-		if (dm_digtable.pre_cck_pd_state == CCK_PD_STAGE_LowRssi) {
-			if (dm_digtable.rssi_val_min <= 25)
-				dm_digtable.cur_cck_pd_state =
+		if (dm_digtable->pre_cck_pd_state == CCK_PD_STAGE_LowRssi) {
+			if (dm_digtable->rssi_val_min <= 25)
+				dm_digtable->cur_cck_pd_state =
 				    CCK_PD_STAGE_LowRssi;
 			else
-				dm_digtable.cur_cck_pd_state =
+				dm_digtable->cur_cck_pd_state =
 				    CCK_PD_STAGE_HighRssi;
 		} else {
-			if (dm_digtable.rssi_val_min <= 20)
-				dm_digtable.cur_cck_pd_state =
+			if (dm_digtable->rssi_val_min <= 20)
+				dm_digtable->cur_cck_pd_state =
 				    CCK_PD_STAGE_LowRssi;
 			else
-				dm_digtable.cur_cck_pd_state =
+				dm_digtable->cur_cck_pd_state =
 				    CCK_PD_STAGE_HighRssi;
 		}
 	} else {
-		dm_digtable.cur_cck_pd_state = CCK_PD_STAGE_MAX;
+		dm_digtable->cur_cck_pd_state = CCK_PD_STAGE_MAX;
 	}
 
-	if (dm_digtable.pre_cck_pd_state != dm_digtable.cur_cck_pd_state) {
-		if (dm_digtable.cur_cck_pd_state == CCK_PD_STAGE_LowRssi) {
+	if (dm_digtable->pre_cck_pd_state != dm_digtable->cur_cck_pd_state) {
+		if (dm_digtable->cur_cck_pd_state == CCK_PD_STAGE_LowRssi) {
 			if (rtlpriv->falsealm_cnt.cnt_cck_fail > 800)
-				dm_digtable.cur_cck_fa_state =
+				dm_digtable->cur_cck_fa_state =
 				    CCK_FA_STAGE_High;
 			else
-				dm_digtable.cur_cck_fa_state = CCK_FA_STAGE_Low;
+				dm_digtable->cur_cck_fa_state = CCK_FA_STAGE_Low;
 
-			if (dm_digtable.pre_cck_fa_state !=
-			    dm_digtable.cur_cck_fa_state) {
-				if (dm_digtable.cur_cck_fa_state ==
+			if (dm_digtable->pre_cck_fa_state !=
+			    dm_digtable->cur_cck_fa_state) {
+				if (dm_digtable->cur_cck_fa_state ==
 				    CCK_FA_STAGE_Low)
 					rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2,
 						      0x83);
@@ -441,8 +449,8 @@ static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 					rtl_set_bbreg(hw, RCCK0_CCA, MASKBYTE2,
 						      0xcd);
 
-				dm_digtable.pre_cck_fa_state =
-				    dm_digtable.cur_cck_fa_state;
+				dm_digtable->pre_cck_fa_state =
+				    dm_digtable->cur_cck_fa_state;
 			}
 
 			rtl_set_bbreg(hw, RCCK0_SYSTEM, MASKBYTE1, 0x40);
@@ -458,11 +466,11 @@ static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 				rtl_set_bbreg(hw, RCCK0_FALSEALARMREPORT,
 					      MASKBYTE2, 0xd3);
 		}
-		dm_digtable.pre_cck_pd_state = dm_digtable.cur_cck_pd_state;
+		dm_digtable->pre_cck_pd_state = dm_digtable->cur_cck_pd_state;
 	}
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_TRACE, "CCKPDStage=%x\n",
-		 dm_digtable.cur_cck_pd_state);
+		 dm_digtable->cur_cck_pd_state);
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_TRACE, "is92C=%x\n",
 		 IS_92C_SERIAL(rtlhal->version));
@@ -470,31 +478,34 @@ static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 
 static void rtl92c_dm_ctrl_initgain_by_twoport(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
 	if (mac->act_scanning)
 		return;
 
 	if (mac->link_state >= MAC80211_LINKED)
-		dm_digtable.cursta_connectctate = DIG_STA_CONNECT;
+		dm_digtable->cursta_connectctate = DIG_STA_CONNECT;
 	else
-		dm_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
+		dm_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
 
 	rtl92c_dm_initial_gain_sta(hw);
 	rtl92c_dm_initial_gain_multi_sta(hw);
 	rtl92c_dm_cck_packet_detection_thresh(hw);
 
-	dm_digtable.presta_connectstate = dm_digtable.cursta_connectctate;
+	dm_digtable->presta_connectstate = dm_digtable->cursta_connectctate;
 
 }
 
 static void rtl92c_dm_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 
 	if (rtlpriv->dm.dm_initialgain_enable == false)
 		return;
-	if (dm_digtable.dig_enable_flag == false)
+	if (dm_digtable->dig_enable_flag == false)
 		return;
 
 	rtl92c_dm_ctrl_initgain_by_twoport(hw);
@@ -514,23 +525,24 @@ static void rtl92c_dm_init_dynamic_txpower(struct ieee80211_hw *hw)
 void rtl92c_dm_write_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "cur_igvalue = 0x%x, pre_igvalue = 0x%x, backoff_val = %d\n",
-		 dm_digtable.cur_igvalue, dm_digtable.pre_igvalue,
-		 dm_digtable.backoff_val);
+		 dm_digtable->cur_igvalue, dm_digtable->pre_igvalue,
+		 dm_digtable->backoff_val);
 
-	dm_digtable.cur_igvalue += 2;
-	if (dm_digtable.cur_igvalue > 0x3f)
-		dm_digtable.cur_igvalue = 0x3f;
+	dm_digtable->cur_igvalue += 2;
+	if (dm_digtable->cur_igvalue > 0x3f)
+		dm_digtable->cur_igvalue = 0x3f;
 
-	if (dm_digtable.pre_igvalue != dm_digtable.cur_igvalue) {
+	if (dm_digtable->pre_igvalue != dm_digtable->cur_igvalue) {
 		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, 0x7f,
-			      dm_digtable.cur_igvalue);
+			      dm_digtable->cur_igvalue);
 		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, 0x7f,
-			      dm_digtable.cur_igvalue);
+			      dm_digtable->cur_igvalue);
 
-		dm_digtable.pre_igvalue = dm_digtable.cur_igvalue;
+		dm_digtable->pre_igvalue = dm_digtable->cur_igvalue;
 	}
 }
 EXPORT_SYMBOL(rtl92c_dm_write_dig);
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
index 4c01624..cdcad7d 100644
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
1.7.10.130.g36e6c

