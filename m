Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35421 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab2HaUjt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2012 16:39:49 -0400
Received: by ieje11 with SMTP id e11so2019210iej.19
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2012 13:39:48 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/3 V2] rtlwifi: rtl8192c: rtl8192de: Fix typo in cursta_connectctate
Date: Fri, 31 Aug 2012 15:38:59 -0500
Message-Id: <1346445541-5251-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120831_223951_833841_903BFA94)
In-Reply-To: <1346445541-5251-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1346445541-5251-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   30 ++++++++++-----------
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c       |   10 +++----
 drivers/net/wireless/rtlwifi/wifi.h               |    2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index a45afda..2fd3b49 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -167,7 +167,7 @@ static void rtl92c_dm_diginit(struct ieee80211_hw *hw)
 	dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 	dm_digtable->cur_igvalue = 0x20;
 	dm_digtable->pre_igvalue = 0x0;
-	dm_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
+	dm_digtable->cursta_connectstate = DIG_STA_DISCONNECT;
 	dm_digtable->presta_connectstate = DIG_STA_DISCONNECT;
 	dm_digtable->curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
 	dm_digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
@@ -190,7 +190,7 @@ static u8 rtl92c_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
 	long rssi_val_min = 0;
 
 	if ((dm_digtable->curmultista_connectstate == DIG_MULTISTA_CONNECT) &&
-	    (dm_digtable->cursta_connectctate == DIG_STA_CONNECT)) {
+	    (dm_digtable->cursta_connectstate == DIG_STA_CONNECT)) {
 		if (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb != 0)
 			rssi_val_min =
 			    (rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb >
@@ -199,8 +199,8 @@ static u8 rtl92c_dm_initial_gain_min_pwdb(struct ieee80211_hw *hw)
 			    rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
 		else
 			rssi_val_min = rtlpriv->dm.undecorated_smoothed_pwdb;
-	} else if (dm_digtable->cursta_connectctate == DIG_STA_CONNECT ||
-		   dm_digtable->cursta_connectctate == DIG_STA_BEFORE_CONNECT) {
+	} else if (dm_digtable->cursta_connectstate == DIG_STA_CONNECT ||
+		   dm_digtable->cursta_connectstate == DIG_STA_BEFORE_CONNECT) {
 		rssi_val_min = rtlpriv->dm.undecorated_smoothed_pwdb;
 	} else if (dm_digtable->curmultista_connectstate ==
 		   DIG_MULTISTA_CONNECT) {
@@ -334,7 +334,7 @@ static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 		multi_sta = true;
 
 	if (!multi_sta ||
-	    dm_digtable->cursta_connectctate != DIG_STA_DISCONNECT) {
+	    dm_digtable->cursta_connectstate != DIG_STA_DISCONNECT) {
 		initialized = false;
 		dm_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		return;
@@ -378,15 +378,15 @@ static void rtl92c_dm_initial_gain_sta(struct ieee80211_hw *hw)
 	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_TRACE,
-		 "presta_connectstate = %x, cursta_connectctate = %x\n",
+		 "presta_connectstate = %x, cursta_connectstate = %x\n",
 		 dm_digtable->presta_connectstate,
-		 dm_digtable->cursta_connectctate);
+		 dm_digtable->cursta_connectstate);
 
-	if (dm_digtable->presta_connectstate == dm_digtable->cursta_connectctate
-	    || dm_digtable->cursta_connectctate == DIG_STA_BEFORE_CONNECT
-	    || dm_digtable->cursta_connectctate == DIG_STA_CONNECT) {
+	if (dm_digtable->presta_connectstate == dm_digtable->cursta_connectstate
+	    || dm_digtable->cursta_connectstate == DIG_STA_BEFORE_CONNECT
+	    || dm_digtable->cursta_connectstate == DIG_STA_CONNECT) {
 
-		if (dm_digtable->cursta_connectctate != DIG_STA_DISCONNECT) {
+		if (dm_digtable->cursta_connectstate != DIG_STA_DISCONNECT) {
 			dm_digtable->rssi_val_min =
 			    rtl92c_dm_initial_gain_min_pwdb(hw);
 			rtl92c_dm_ctrl_initgain_by_rssi(hw);
@@ -407,7 +407,7 @@ static void rtl92c_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct dig_t *dm_digtable = &rtlpriv->dm_digtable;
 
-	if (dm_digtable->cursta_connectctate == DIG_STA_CONNECT) {
+	if (dm_digtable->cursta_connectstate == DIG_STA_CONNECT) {
 		dm_digtable->rssi_val_min = rtl92c_dm_initial_gain_min_pwdb(hw);
 
 		if (dm_digtable->pre_cck_pd_state == CCK_PD_STAGE_LowRssi) {
@@ -484,15 +484,15 @@ static void rtl92c_dm_ctrl_initgain_by_twoport(struct ieee80211_hw *hw)
 		return;
 
 	if (mac->link_state >= MAC80211_LINKED)
-		dm_digtable->cursta_connectctate = DIG_STA_CONNECT;
+		dm_digtable->cursta_connectstate = DIG_STA_CONNECT;
 	else
-		dm_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
+		dm_digtable->cursta_connectstate = DIG_STA_DISCONNECT;
 
 	rtl92c_dm_initial_gain_sta(hw);
 	rtl92c_dm_initial_gain_multi_sta(hw);
 	rtl92c_dm_cck_packet_detection_thresh(hw);
 
-	dm_digtable->presta_connectstate = dm_digtable->cursta_connectctate;
+	dm_digtable->presta_connectstate = dm_digtable->cursta_connectstate;
 
 }
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index c0201ed..ed868c3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -164,7 +164,7 @@ static void rtl92d_dm_diginit(struct ieee80211_hw *hw)
 	de_digtable->dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 	de_digtable->cur_igvalue = 0x20;
 	de_digtable->pre_igvalue = 0x0;
-	de_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
+	de_digtable->cursta_connectstate = DIG_STA_DISCONNECT;
 	de_digtable->presta_connectstate = DIG_STA_DISCONNECT;
 	de_digtable->curmultista_connectstate = DIG_MULTISTA_DISCONNECT;
 	de_digtable->rssi_lowthresh = DM_DIG_THRESH_LOW;
@@ -310,7 +310,7 @@ static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 	struct dig_t *de_digtable = &rtlpriv->dm_digtable;
 	unsigned long flag = 0;
 
-	if (de_digtable->cursta_connectctate == DIG_STA_CONNECT) {
+	if (de_digtable->cursta_connectstate == DIG_STA_CONNECT) {
 		if (de_digtable->pre_cck_pd_state == CCK_PD_STAGE_LOWRSSI) {
 			if (de_digtable->min_undecorated_pwdb_for_dm <= 25)
 				de_digtable->cur_cck_pd_state =
@@ -342,7 +342,7 @@ static void rtl92d_dm_cck_packet_detection_thresh(struct ieee80211_hw *hw)
 		de_digtable->pre_cck_pd_state = de_digtable->cur_cck_pd_state;
 	}
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "CurSTAConnectState=%s\n",
-		 de_digtable->cursta_connectctate == DIG_STA_CONNECT ?
+		 de_digtable->cursta_connectstate == DIG_STA_CONNECT ?
 		 "DIG_STA_CONNECT " : "DIG_STA_DISCONNECT");
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "CCKPDStage=%s\n",
 		 de_digtable->cur_cck_pd_state == CCK_PD_STAGE_LOWRSSI ?
@@ -428,9 +428,9 @@ static void rtl92d_dm_dig(struct ieee80211_hw *hw)
 	RT_TRACE(rtlpriv, COMP_DIG, DBG_LOUD, "progress\n");
 	/* Decide the current status and if modify initial gain or not */
 	if (rtlpriv->mac80211.link_state >= MAC80211_LINKED)
-		de_digtable->cursta_connectctate = DIG_STA_CONNECT;
+		de_digtable->cursta_connectstate = DIG_STA_CONNECT;
 	else
-		de_digtable->cursta_connectctate = DIG_STA_DISCONNECT;
+		de_digtable->cursta_connectstate = DIG_STA_DISCONNECT;
 
 	/* adjust initial gain according to false alarm counter */
 	if (falsealm_cnt->cnt_all < DM_DIG_FA_TH0)
diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 40153e7..a15c112 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1624,7 +1624,7 @@ struct dig_t {
 	u8 dig_twoport_algorithm;
 	u8 dig_dbgmode;
 	u8 dig_slgorithm_switch;
-	u8 cursta_connectctate;
+	u8 cursta_connectstate;
 	u8 presta_connectstate;
 	u8 curmultista_connectstate;
 	char backoff_val;
-- 
1.7.10.4

