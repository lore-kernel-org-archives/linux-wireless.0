Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318Ab2DSVdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 17:33:15 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so12437635iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 14:33:15 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 5/6 V2] rtlwifi: rtl8192de: Convert driver to use private dm structs
Date: Thu, 19 Apr 2012 16:32:43 -0500
Message-Id: <1334871164-9795-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120419_233322_658582_D2E8BEC1)
In-Reply-To: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1334871164-9795-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert driver to use the private dig_t instead of a global version.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c  |  185 +++++++++++++-------------
 drivers/net/wireless/rtlwifi/rtl8192de/dm.h  |    2 -
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    7 +-
 3 files changed, 100 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index 4737018..a7d63a8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -37,8 +37,6 @@
 
 #define UNDEC_SM_PWDB	entry_min_undecoratedsmoothed_pwdb
 
-struct dig_t de_digtable;
-
 static const u32 ofdmswing_table[OFDM_TABLE_SIZE_92D] = {
 	0x7f8001fe,		/* 0, +6.0dB */
 	0x788001e2,		/* 1, +5.5dB */
@@ -159,27 +157,30 @@ static const u8 cckswing_table_ch14[CCK_TABLE_SIZE][8] = {
 
 static void rtl92d_dm_diginit(struct ieee80211_hw *hw)
 {
-	de_digtable.dig_enable_flag = true;
-	de_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
-	de_digtable.cur_igvalue = 0x20;
-	de_digtable.pre_igvalue = 0x0;
-	de_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
-	de_digtable.presta_connectstate = DIG_STA_DISCONNECT;
-	de_digtable.curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
-	de_digtable.rssi_lowthresh = DM_DIG_THRESH_LOW;
-	de_digtable.rssi_highthresh = DM_DIG_THRESH_HIGH;
-	de_digtable.fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
-	de_digtable.fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
-	de_digtable.rx_gain_range_max = DM_DIG_FA_UPPER;
-	de_digtable.rx_gain_range_min = DM_DIG_FA_LOWER;
-	de_digtable.backoff_val = DM_DIG_BACKOFF_DEFAULT;
-	de_digtable.backoff_val_range_max = DM_DIG_BACKOFF_MAX;
-	de_digtable.backoff_val_range_min = DM_DIG_BACKOFF_MIN;
-	de_digtable.pre_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
-	de_digtable.cur_cck_pd_state = CCK_PD_STAGE_MAX;
-	de_digtable.large_fa_hit = 0;
-	de_digtable.recover_cnt = 0;
-	de_digtable.forbidden_igi = DM_DIG_FA_LOWER;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
+
+	de_digtable->dig_enable_flag = true;
+	de_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
+	de_digtable->cur_igvalue = 0x20;
+	de_digtable->pre_igvalue = 0x0;
+	de_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
+	de_digtable->presta_connectstate = DIG_STA_DISCONNECT;
+	de_digtable->curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
+	de_digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
+	de_digtable->rssi_highthresh = DM_DIG_THRESH_HIGH;
+	de_digtable->fa_lowthresh = DM_FALSEALARM_THRESH_LOW;
+	de_digtable->fa_highthresh = DM_FALSEALARM_THRESH_HIGH;
+	de_digtable->rx_gain_range_max = DM_DIG_FA_UPPER;
+	de_digtable->rx_gain_range_min = DM_DIG_FA_LOWER;
+	de_digtable->backoff_val = DM_DIG_BACKOFF_DEFAULT;
+	de_digtable->backoff_val_range_max = DM_DIG_BACKOFF_MAX;
+	de_digtable->backoff_val_range_min = DM_DIG_BACKOFF_MIN;
+	de_digtable->pre_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
+	de_digtable->cur_cck_pd_state = CCK_PD_STAGE_MAX;
+	de_digtable->large_fa_hit = 0;
+	de_digtable->recover_cnt = 0;
+	de_digtable->forbidden_igi = DM_DIG_FA_LOWER;
 }
 
 static void rtl92d_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
@@ -266,68 +267,70 @@ static void rtl92d_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 static void rtl92d_dm_find_minimum_rssi(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
 	struct rtl_mac *mac = rtl_mac(rtlpriv);
 
 	/* Determine the minimum RSSI  */
 	if ((mac->link_state < MAC80211_LINKED) &&
 	    (rtlpriv->dm.UNDEC_SM_PWDB == 0)) {
-		de_digtable.min_undecorated_pwdb_for_dm = 0;
+		de_digtable->min_undecorated_pwdb_for_dm = 0;
 		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 			 "Not connected to any\n");
 	}
 	if (mac->link_state >= MAC80211_LINKED) {
 		if (mac->opmode == NL80211_IFTYPE_AP ||
 		    mac->opmode == NL80211_IFTYPE_ADHOC) {
-			de_digtable.min_undecorated_pwdb_for_dm =
+			de_digtable->min_undecorated_pwdb_for_dm =
 			    rtlpriv->dm.UNDEC_SM_PWDB;
 			RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 				 "AP Client PWDB = 0x%lx\n",
 				 rtlpriv->dm.UNDEC_SM_PWDB);
 		} else {
-			de_digtable.min_undecorated_pwdb_for_dm =
+			de_digtable->min_undecorated_pwdb_for_dm =
 			    rtlpriv->dm.undecorated_smoothed_pwdb;
 			RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 				 "STA Default Port PWDB = 0x%x\n",
-				 de_digtable.min_undecorated_pwdb_for_dm);
+				 de_digtable->min_undecorated_pwdb_for_dm);
 		}
 	} else {
-		de_digtable.min_undecorated_pwdb_for_dm =
+		de_digtable->min_undecorated_pwdb_for_dm =
 		    rtlpriv->dm.UNDEC_SM_PWDB;
 		RT_TRACE(rtlpriv, COMP_BB_POWERSAVING, DBG_LOUD,
 			 "AP Ext Port or disconnect PWDB = 0x%x\n",
-			 de_digtable.min_undecorated_pwdb_for_dm);
+			 de_digtable->min_undecorated_pwdb_for_dm);
 	}
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "MinUndecoratedPWDBForDM =%d\n",
-		 de_digtable.min_undecorated_pwdb_for_dm);
+		 de_digtable->min_undecorated_pwdb_for_dm);
 }
 
 static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
 	unsigned long flag = 0;
 
-	if (de_digtable.cursta_connectctate == DIG_STA_CONNECT) {
-		if (de_digtable.pre_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
-			if (de_digtable.min_undecorated_pwdb_for_dm <= 25)
-				de_digtable.cur_cck_pd_state =
+	if (de_digtable->cursta_connectctate == DIG_STA_CONNECT) {
+		if (de_digtable->pre_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
+			if (de_digtable->min_undecorated_pwdb_for_dm <= 25)
+				de_digtable->cur_cck_pd_state =
 							 CCK_PD_STAGE_LOWRSSI;
 			else
-				de_digtable.cur_cck_pd_state =
+				de_digtable->cur_cck_pd_state =
 							 CCK_PD_STAGE_HIGHRSSI;
 		} else {
-			if (de_digtable.min_undecorated_pwdb_for_dm <= 20)
-				de_digtable.cur_cck_pd_state =
+			if (de_digtable->min_undecorated_pwdb_for_dm <= 20)
+				de_digtable->cur_cck_pd_state =
 							 CCK_PD_STAGE_LOWRSSI;
 			else
-				de_digtable.cur_cck_pd_state =
+				de_digtable->cur_cck_pd_state =
 							 CCK_PD_STAGE_HIGHRSSI;
 		}
 	} else {
-		de_digtable.cur_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
+		de_digtable->cur_cck_pd_state = CCK_PD_STAGE_LOWRSSI;
 	}
-	if (de_digtable.pre_cck_pd_state != de_digtable.cur_cck_pd_state) {
-		if (de_digtable.cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
+	if (de_digtable->pre_cck_pd_state != de_digtable->cur_cck_pd_state) {
+		if (de_digtable->cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
 			rtl92d_acquire_cckandrw_pagea_ctl(hw, &flag);
 			rtl_set_bbreg(hw, RCCK0_CCA, BMASKBYTE2, 0x83);
 			rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
@@ -336,13 +339,13 @@ static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 			rtl_set_bbreg(hw, RCCK0_CCA, BMASKBYTE2, 0xcd);
 			rtl92d_release_cckandrw_pagea_ctl(hw, &flag);
 		}
-		de_digtable.pre_cck_pd_state = de_digtable.cur_cck_pd_state;
+		de_digtable->pre_cck_pd_state = de_digtable->cur_cck_pd_state;
 	}
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "CurSTAConnectState=%s\n",
-		 de_digtable.cursta_connectctate == DIG_STA_CONNECT ?
+		 de_digtable->cursta_connectctate == DIG_STA_CONNECT ?
 		 "DIG_STA_CONNECT " : "DIG_STA_DISCONNECT");
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "CCKPDStage=%s\n",
-		 de_digtable.cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI ?
+		 de_digtable->cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI ?
 		 "Low RSSI " : "High RSSI ");
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "is92d single phy =%x\n",
 		 IS_92D_SINGLEPHY(rtlpriv->rtlhal.version));
@@ -352,37 +355,40 @@ static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 void rtl92d_dm_write_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "cur_igvalue = 0x%x, pre_igvalue = 0x%x, backoff_val = %d\n",
-		 de_digtable.cur_igvalue, de_digtable.pre_igvalue,
-		 de_digtable.backoff_val);
-	if (de_digtable.dig_enable_flag == false) {
+		 de_digtable->cur_igvalue, de_digtable->pre_igvalue,
+		 de_digtable->backoff_val);
+	if (de_digtable->dig_enable_flag == false) {
 		RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "DIG is disabled\n");
-		de_digtable.pre_igvalue = 0x17;
+		de_digtable->pre_igvalue = 0x17;
 		return;
 	}
-	if (de_digtable.pre_igvalue != de_digtable.cur_igvalue) {
+	if (de_digtable->pre_igvalue != de_digtable->cur_igvalue) {
 		rtl_set_bbreg(hw, ROFDM0_XAAGCCORE1, 0x7f,
-			      de_digtable.cur_igvalue);
+			      de_digtable->cur_igvalue);
 		rtl_set_bbreg(hw, ROFDM0_XBAGCCORE1, 0x7f,
-			      de_digtable.cur_igvalue);
-		de_digtable.pre_igvalue = de_digtable.cur_igvalue;
+			      de_digtable->cur_igvalue);
+		de_digtable->pre_igvalue = de_digtable->cur_igvalue;
 	}
 }
 
 static void rtl92d_early_mode_enabled(struct rtl_priv *rtlpriv)
 {
+	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
+
 	if ((rtlpriv->mac80211.link_state >= MAC80211_LINKED) &&
 	    (rtlpriv->mac80211.vendor == PEER_CISCO)) {
 		RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "IOT_PEER = CISCO\n");
-		if (de_digtable.last_min_undecorated_pwdb_for_dm >= 50
-		    && de_digtable.min_undecorated_pwdb_for_dm < 50) {
+		if (de_digtable->last_min_undecorated_pwdb_for_dm >= 50
+		    && de_digtable->min_undecorated_pwdb_for_dm < 50) {
 			rtl_write_byte(rtlpriv, REG_EARLY_MODE_CONTROL, 0x00);
 			RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 				 "Early Mode Off\n");
-		} else if (de_digtable.last_min_undecorated_pwdb_for_dm <= 55 &&
-			   de_digtable.min_undecorated_pwdb_for_dm > 55) {
+		} else if (de_digtable->last_min_undecorated_pwdb_for_dm <= 55 &&
+			   de_digtable->min_undecorated_pwdb_for_dm > 55) {
 			rtl_write_byte(rtlpriv, REG_EARLY_MODE_CONTROL, 0x0f);
 			RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 				 "Early Mode On\n");
@@ -396,14 +402,15 @@ static void rtl92d_early_mode_enabled(struct rtl_priv *rtlpriv)
 static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value_igi = de_digtable.cur_igvalue;
+	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
+	u8 value_igi = de_digtable->cur_igvalue;
 	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "==>\n");
 	if (rtlpriv->rtlhal.earlymode_enable) {
 		rtl92d_early_mode_enabled(rtlpriv);
-		de_digtable.last_min_undecorated_pwdb_for_dm =
-				 de_digtable.min_undecorated_pwdb_for_dm;
+		de_digtable->last_min_undecorated_pwdb_for_dm =
+				 de_digtable->min_undecorated_pwdb_for_dm;
 	}
 	if (!rtlpriv->dm.dm_initialgain_enable)
 		return;
@@ -421,9 +428,9 @@ static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "progress\n");
 	/* Decide the current status and if modify initial gain or not */
 	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
-		de_digtable.cursta_connectctate = DIG_STA_CONNECT;
+		de_digtable->cursta_connectctate = DIG_STA_CONNECT;
 	else
-		de_digtable.cursta_connectctate = DIG_STA_DISCONNECT;
+		de_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
 
 	/* adjust initial gain according to false alarm counter */
 	if (falsealm_cnt->cnt_all < DM_DIG_FA_TH0)
@@ -436,64 +443,64 @@ static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 		value_igi += 2;
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "dm_DIG() Before: large_fa_hit=%d, forbidden_igi=%x\n",
-		 de_digtable.large_fa_hit, de_digtable.forbidden_igi);
+		 de_digtable->large_fa_hit, de_digtable->forbidden_igi);
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "dm_DIG() Before: Recover_cnt=%d, rx_gain_range_min=%x\n",
-		 de_digtable.recover_cnt, de_digtable.rx_gain_range_min);
+		 de_digtable->recover_cnt, de_digtable->rx_gain_range_min);
 
 	/* deal with abnorally large false alarm */
 	if (falsealm_cnt->cnt_all > 10000) {
 		RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 			 "dm_DIG(): Abnormally false alarm case\n");
 
-		de_digtable.large_fa_hit++;
-		if (de_digtable.forbidden_igi < de_digtable.cur_igvalue) {
-			de_digtable.forbidden_igi = de_digtable.cur_igvalue;
-			de_digtable.large_fa_hit = 1;
+		de_digtable->large_fa_hit++;
+		if (de_digtable->forbidden_igi < de_digtable->cur_igvalue) {
+			de_digtable->forbidden_igi = de_digtable->cur_igvalue;
+			de_digtable->large_fa_hit = 1;
 		}
-		if (de_digtable.large_fa_hit >= 3) {
-			if ((de_digtable.forbidden_igi + 1) > DM_DIG_MAX)
-				de_digtable.rx_gain_range_min = DM_DIG_MAX;
+		if (de_digtable->large_fa_hit >= 3) {
+			if ((de_digtable->forbidden_igi + 1) > DM_DIG_MAX)
+				de_digtable->rx_gain_range_min = DM_DIG_MAX;
 			else
-				de_digtable.rx_gain_range_min =
-				    (de_digtable.forbidden_igi + 1);
-			de_digtable.recover_cnt = 3600;	/* 3600=2hr */
+				de_digtable->rx_gain_range_min =
+				    (de_digtable->forbidden_igi + 1);
+			de_digtable->recover_cnt = 3600;	/* 3600=2hr */
 		}
 	} else {
 		/* Recovery mechanism for IGI lower bound */
-		if (de_digtable.recover_cnt != 0) {
-			de_digtable.recover_cnt--;
+		if (de_digtable->recover_cnt != 0) {
+			de_digtable->recover_cnt--;
 		} else {
-			if (de_digtable.large_fa_hit == 0) {
-				if ((de_digtable.forbidden_igi - 1) <
+			if (de_digtable->large_fa_hit == 0) {
+				if ((de_digtable->forbidden_igi - 1) <
 				    DM_DIG_FA_LOWER) {
-					de_digtable.forbidden_igi =
+					de_digtable->forbidden_igi =
 							 DM_DIG_FA_LOWER;
-					de_digtable.rx_gain_range_min =
+					de_digtable->rx_gain_range_min =
 							 DM_DIG_FA_LOWER;
 
 				} else {
-					de_digtable.forbidden_igi--;
-					de_digtable.rx_gain_range_min =
-					    (de_digtable.forbidden_igi + 1);
+					de_digtable->forbidden_igi--;
+					de_digtable->rx_gain_range_min =
+					    (de_digtable->forbidden_igi + 1);
 				}
-			} else if (de_digtable.large_fa_hit == 3) {
-				de_digtable.large_fa_hit = 0;
+			} else if (de_digtable->large_fa_hit == 3) {
+				de_digtable->large_fa_hit = 0;
 			}
 		}
 	}
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "dm_DIG() After: large_fa_hit=%d, forbidden_igi=%x\n",
-		 de_digtable.large_fa_hit, de_digtable.forbidden_igi);
+		 de_digtable->large_fa_hit, de_digtable->forbidden_igi);
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD,
 		 "dm_DIG() After: recover_cnt=%d, rx_gain_range_min=%x\n",
-		 de_digtable.recover_cnt, de_digtable.rx_gain_range_min);
+		 de_digtable->recover_cnt, de_digtable->rx_gain_range_min);
 
 	if (value_igi > DM_DIG_MAX)
 		value_igi = DM_DIG_MAX;
-	else if (value_igi < de_digtable.rx_gain_range_min)
-		value_igi = de_digtable.rx_gain_range_min;
-	de_digtable.cur_igvalue = value_igi;
+	else if (value_igi < de_digtable->rx_gain_range_min)
+		value_igi = de_digtable->rx_gain_range_min;
+	de_digtable->cur_igvalue = value_igi;
 	rtl92d_dm_write_dig(hw);
 	if (rtlpriv->rtlhal.current_bandtype != BAND_ON_5G)
 		rtl92d_dm_cck_packet_detection_thresh(hw);
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
index 28fc5fb..18380a7 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3064,6 +3064,7 @@ u8 rtl92d_phy_sw_chnl(struct ieee80211_hw *hw)
 static void rtl92d_phy_set_io(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 
 	RT_TRACE(rtlpriv, COMP_CMD, DBG_TRACE,
@@ -3071,13 +3072,13 @@ static void rtl92d_phy_set_io(struct ieee80211_hw *hw)
 		 rtlphy->current_io_type, rtlphy->set_io_inprogress);
 	switch (rtlphy->current_io_type) {
 	case IO_CMD_RESUME_DM_BY_SCAN:
-		de_digtable.cur_igvalue = rtlphy->initgain_backup.xaagccore1;
+		de_digtable->cur_igvalue = rtlphy->initgain_backup.xaagccore1;
 		rtl92d_dm_write_dig(hw);
 		rtl92d_phy_set_txpower_level(hw, rtlphy->current_channel);
 		break;
 	case IO_CMD_PAUSE_DM_BY_SCAN:
-		rtlphy->initgain_backup.xaagccore1 = de_digtable.cur_igvalue;
-		de_digtable.cur_igvalue = 0x37;
+		rtlphy->initgain_backup.xaagccore1 = de_digtable->cur_igvalue;
+		de_digtable->cur_igvalue = 0x37;
 		rtl92d_dm_write_dig(hw);
 		break;
 	default:
-- 
1.7.10.130.g36e6c

