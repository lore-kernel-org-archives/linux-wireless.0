Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37316 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2HUPBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 11:01:54 -0400
Received: by mail-gg0-f174.google.com with SMTP id k6so5887981ggd.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2012 08:01:54 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Li Chaoming <chaoming_li@realsil.com.cn>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 6/6] rtlwifi: rtl8192se: Update driver for changes in 12/30/2011 vendor version
Date: Tue, 21 Aug 2012 10:00:55 -0500
Message-Id: <1345561255-10349-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120821_170159_696417_5B257543)
In-Reply-To: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1345561255-10349-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Li Chaoming <chaoming_li@realsil.com.cn>

Yhis patch implements the changes found in the vendor driver with version
rtl_92ce_92se_92de_linux_mac80211_0005.1230.2011. The reasons for these
changes are not specified in Realtek's code.

Signed-off-by: Li Chaoming <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c  |   91 ++++---
 drivers/net/wireless/rtlwifi/rtl8192se/fw.c  |    1 -
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c  |   25 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |  353 ++++++++++++++------------
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |   11 +-
 5 files changed, 267 insertions(+), 214 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
index 465f581..e1079eb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -175,7 +175,20 @@ static void _rtl92s_dm_txpowertracking_callback_thermalmeter(
 
 	if (thermalvalue) {
 		rtlpriv->dm.thermalvalue = thermalvalue;
-		rtl92s_phy_set_fw_cmd(hw, FW_CMD_TXPWR_TRACK_THERMAL);
+
+		if (hal_get_firmwareversion(rtlpriv) >= 0x35) {
+			rtl92s_phy_set_fw_cmd(hw, FW_CMD_TXPWR_TRACK_THERMAL);
+		} else {
+			u32 fw_cmd = (FW_TXPWR_TRACK_THERMAL |
+				(rtlpriv->efuse.thermalmeter[0] << 8) |
+				(thermalvalue << 16));
+
+			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
+				 "Write to FW Thermal Val = 0x%x\n", fw_cmd);
+
+			rtl_write_dword(rtlpriv, WFM5, fw_cmd);
+			rtl92s_phy_chk_fwcmd_iodone(hw);
+		}
 	}
 
 	rtlpriv->dm.txpowercount = 0;
@@ -217,11 +230,11 @@ static void _rtl92s_dm_refresh_rateadaptive_mask(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rate_adaptive *ra = &(rtlpriv->ra);
-
+	struct ieee80211_sta *sta = NULL;
+	u8 rssi_level;
 	u32 low_rssi_thresh = 0;
 	u32 middle_rssi_thresh = 0;
 	u32 high_rssi_thresh = 0;
-	struct ieee80211_sta *sta = NULL;
 
 	if (is_hal_stop(rtlhal))
 		return;
@@ -229,16 +242,14 @@ static void _rtl92s_dm_refresh_rateadaptive_mask(struct ieee80211_hw *hw)
 	if (!rtlpriv->dm.useramask)
 		return;
 
-	if (!rtlpriv->dm.inform_fw_driverctrldm) {
+	if (hal_get_firmwareversion(rtlpriv) >= 61 &&
+		!rtlpriv->dm.inform_fw_driverctrldm) {
 		rtl92s_phy_set_fw_cmd(hw, FW_CMD_CTRL_DM_BY_DRIVER);
 		rtlpriv->dm.inform_fw_driverctrldm = true;
 	}
 
-	rcu_read_lock();
-	if (mac->opmode == NL80211_IFTYPE_STATION)
-		sta = get_sta(hw, mac->vif, mac->bssid);
 	if ((mac->link_state == MAC80211_LINKED) &&
-	    (mac->opmode == NL80211_IFTYPE_STATION)) {
+		(mac->opmode == NL80211_IFTYPE_STATION)) {
 		switch (ra->pre_ratr_state) {
 		case DM_RATR_STA_HIGH:
 			high_rssi_thresh = 40;
@@ -270,29 +281,36 @@ static void _rtl92s_dm_refresh_rateadaptive_mask(struct ieee80211_hw *hw)
 		if (rtlpriv->dm.undecorated_smoothed_pwdb >
 		    (long)high_rssi_thresh) {
 			ra->ratr_state = DM_RATR_STA_HIGH;
+			rssi_level = 1;
 		} else if (rtlpriv->dm.undecorated_smoothed_pwdb >
-			   (long)middle_rssi_thresh) {
+			(long)middle_rssi_thresh) {
 			ra->ratr_state = DM_RATR_STA_LOW;
+			rssi_level = 3;
 		} else if (rtlpriv->dm.undecorated_smoothed_pwdb >
-			   (long)low_rssi_thresh) {
+			(long)low_rssi_thresh) {
 			ra->ratr_state = DM_RATR_STA_LOW;
+			rssi_level = 5;
 		} else {
 			ra->ratr_state = DM_RATR_STA_ULTRALOW;
+			rssi_level = 6;
 		}
 
 		if (ra->pre_ratr_state != ra->ratr_state) {
 			RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
 				 "RSSI = %ld RSSI_LEVEL = %d PreState = %d, CurState = %d\n",
 				 rtlpriv->dm.undecorated_smoothed_pwdb,
-				 ra->ratr_state,
-				 ra->pre_ratr_state, ra->ratr_state);
+				 ra->ratr_state, ra->pre_ratr_state,
+				 ra->ratr_state);
 
+			rcu_read_lock();
+			sta = rtl_find_sta(hw, mac->bssid);
 			rtlpriv->cfg->ops->update_rate_tbl(hw, sta,
 							   ra->ratr_state);
+			rcu_read_unlock();
+
 			ra->pre_ratr_state = ra->ratr_state;
 		}
 	}
-	rcu_read_unlock();
 }
 
 static void _rtl92s_dm_switch_baseband_mrc(struct ieee80211_hw *hw)
@@ -417,28 +435,6 @@ static void _rtl92s_dm_false_alarm_counter_statistics(struct ieee80211_hw *hw)
 		falsealm_cnt->cnt_cck_fail;
 }
 
-static void rtl92s_backoff_enable_flag(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct dig_t *digtable = &rtlpriv->dm_digtable;
-	struct false_alarm_statistics *falsealm_cnt = &(rtlpriv->falsealm_cnt);
-
-	if (falsealm_cnt->cnt_all > digtable->fa_highthresh) {
-		if ((digtable->backoff_val - 6) <
-			digtable->backoffval_range_min)
-			digtable->backoff_val = digtable->backoffval_range_min;
-		else
-			digtable->backoff_val -= 6;
-	} else if (falsealm_cnt->cnt_all < digtable->fa_lowthresh) {
-		if ((digtable->backoff_val + 6) >
-			digtable->backoffval_range_max)
-			digtable->backoff_val =
-				 digtable->backoffval_range_max;
-		else
-			digtable->backoff_val += 6;
-	}
-}
-
 static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -453,13 +449,30 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 			if (rtlpriv->psc.rfpwr_state != ERFON)
 				return;
 
-			if (digtable->backoff_enable_flag)
-				rtl92s_backoff_enable_flag(hw);
-			else
+			if (digtable->backoff_enable_flag) {
+				if (falsealm_cnt->cnt_all >
+				    digtable->fa_highthresh) {
+					if ((digtable->backoff_val - 6) <
+					    digtable->backoffval_range_min)
+						digtable->backoff_val =
+						 digtable->backoffval_range_min;
+					else
+						digtable->backoff_val -= 6;
+				} else if (falsealm_cnt->cnt_all <
+					   digtable->fa_lowthresh) {
+					if ((digtable->backoff_val + 6) >
+					    digtable->backoffval_range_max)
+						digtable->backoff_val =
+						 digtable->backoffval_range_max;
+					else
+						digtable->backoff_val += 6;
+				}
+			} else {
 				digtable->backoff_val = DM_DIG_BACKOFF;
+			}
 
 			if ((digtable->rssi_val + 10 - digtable->backoff_val) >
-				digtable->rx_gain_range_max)
+			    digtable->rx_gain_range_max)
 				digtable->cur_igvalue =
 						digtable->rx_gain_range_max;
 			else if ((digtable->rssi_val + 10 - digtable->backoff_val)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
index 380e7d4..d52fb37 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -485,7 +485,6 @@ static u32 _rtl92s_fill_h2c_cmd(struct sk_buff *skb, u32 h2cbufferlen,
 		/* Clear content */
 		ph2c_buffer = (u8 *)skb_put(skb, (u32)len);
 		memset((ph2c_buffer + totallen + tx_desclen), 0, len);
-
 		/* CMD len */
 		SET_BITS_TO_LE_4BYTE((ph2c_buffer + totallen + tx_desclen),
 				      0, 16, pcmd_len[i]);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index 4542e69..d2b02bd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1058,7 +1058,22 @@ int rtl92se_hw_init(struct ieee80211_hw *hw)
 
 	/* We enable high power and RA related mechanism after NIC
 	 * initialized. */
-	rtl92s_phy_set_fw_cmd(hw, FW_CMD_RA_INIT);
+	if (hal_get_firmwareversion(rtlpriv) >= 0x35) {
+		/* Fw v.53 and later. */
+		rtl92s_phy_set_fw_cmd(hw, FW_CMD_RA_INIT);
+	} else if (hal_get_firmwareversion(rtlpriv) == 0x34) {
+		/* Fw v.52 and later. */
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_INIT);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+	} else {
+		/* Compatible earlier FW version. */
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_RESET);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_ACTIVE);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+		rtl_write_dword(rtlpriv, WFM5, FW_RA_REFRESH);
+		rtl92s_phy_chk_fwcmd_iodone(hw);
+	}
 
 	/* Add to prevent ASPM bug. */
 	/* Always enable hst and NIC clock request. */
@@ -1998,6 +2013,8 @@ static void rtl92se_update_hal_rate_table(struct ieee80211_hw *hw,
 		ratr_value = sta->supp_rates[1] << 4;
 	else
 		ratr_value = sta->supp_rates[0];
+	if (mac->opmode == NL80211_IFTYPE_ADHOC)
+		ratr_value = 0xfff;
 	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
@@ -2112,6 +2129,8 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 		ratr_bitmap = sta->supp_rates[1] << 4;
 	else
 		ratr_bitmap = sta->supp_rates[0];
+	if (mac->opmode == NL80211_IFTYPE_ADHOC)
+		ratr_bitmap = 0xfff;
 	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
 			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
@@ -2200,6 +2219,7 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 			ratr_bitmap &= 0x0f8ff0ff;
 		break;
 	}
+	sta_entry->ratr_index = ratr_index;
 
 	if (rtlpriv->rtlhal.version >= VERSION_8192S_BCUT)
 		ratr_bitmap &= 0x0FFFFFFF;
@@ -2226,9 +2246,6 @@ static void rtl92se_update_hal_rate_mask(struct ieee80211_hw *hw,
 		 mask, ratr_bitmap);
 	rtl_write_dword(rtlpriv, 0x2c4, ratr_bitmap);
 	rtl_write_dword(rtlpriv, WFM5, (FW_RA_UPDATE_MASK | (mask << 8)));
-
-	if (macid != 0)
-		sta_entry->ratr_index = ratr_index;
 }
 
 void rtl92se_update_hal_rate_tbl(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index b917a2a..daa81ea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -181,19 +181,20 @@ u32 rtl92s_phy_query_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 original_value, readback_value, bitshift;
+	unsigned long flags;
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 "regaddr(%#x), rfpath(%#x), bitmask(%#x)\n",
 		 regaddr, rfpath, bitmask);
 
-	spin_lock(&rtlpriv->locks.rf_lock);
+	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
 
 	original_value = _rtl92s_phy_rf_serial_read(hw, rfpath, regaddr);
 
 	bitshift = _rtl92s_phy_calculate_bit_shift(bitmask);
 	readback_value = (original_value & bitmask) >> bitshift;
 
-	spin_unlock(&rtlpriv->locks.rf_lock);
+	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 "regaddr(%#x), rfpath(%#x), bitmask(%#x), original_value(%#x)\n",
@@ -208,6 +209,7 @@ void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	u32 original_value, bitshift;
+	unsigned long flags;
 
 	if (!((rtlphy->rf_pathmap >> rfpath) & 0x1))
 		return;
@@ -216,7 +218,7 @@ void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 		 "regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
 		 regaddr, bitmask, data, rfpath);
 
-	spin_lock(&rtlpriv->locks.rf_lock);
+	spin_lock_irqsave(&rtlpriv->locks.rf_lock, flags);
 
 	if (bitmask != RFREG_OFFSET_MASK) {
 		original_value = _rtl92s_phy_rf_serial_read(hw, rfpath,
@@ -227,7 +229,7 @@ void rtl92s_phy_set_rf_reg(struct ieee80211_hw *hw, enum radio_path rfpath,
 
 	_rtl92s_phy_rf_serial_write(hw, rfpath, regaddr, data);
 
-	spin_unlock(&rtlpriv->locks.rf_lock);
+	spin_unlock_irqrestore(&rtlpriv->locks.rf_lock, flags);
 
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 		 "regaddr(%#x), bitmask(%#x), data(%#x), rfpath(%#x)\n",
@@ -1327,15 +1329,17 @@ static void _rtl92s_phy_set_fwcmd_io(struct ieee80211_hw *hw)
 
 	/* We re-map RA related CMD IO to combinational ones */
 	/* if FW version is v.52 or later. */
-	switch (rtlhal->current_fwcmd_io) {
-	case FW_CMD_RA_REFRESH_N:
-		rtlhal->current_fwcmd_io = FW_CMD_RA_REFRESH_N_COMB;
-		break;
-	case FW_CMD_RA_REFRESH_BG:
-		rtlhal->current_fwcmd_io = FW_CMD_RA_REFRESH_BG_COMB;
-		break;
-	default:
-		break;
+	if (hal_get_firmwareversion(rtlpriv) >= 0x34) {
+		switch (rtlhal->current_fwcmd_io) {
+		case FW_CMD_RA_REFRESH_N:
+			rtlhal->current_fwcmd_io = FW_CMD_RA_REFRESH_N_COMB;
+			break;
+		case FW_CMD_RA_REFRESH_BG:
+			rtlhal->current_fwcmd_io = FW_CMD_RA_REFRESH_BG_COMB;
+			break;
+		default:
+			break;
+		}
 	}
 
 	switch (rtlhal->current_fwcmd_io) {
@@ -1464,9 +1468,9 @@ bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fw_cmdio)
 		 "Set FW Cmd(%#x), set_fwcmd_inprogress(%d)\n",
 		 fw_cmdio, rtlhal->set_fwcmd_inprogress);
 
-	do {
-		/* We re-map to combined FW CMD ones if firmware version */
-		/* is v.53 or later. */
+	/* We re-map to combined FW CMD ones if firmware version */
+	/* is v.53 or later. */
+	if (hal_get_firmwareversion(rtlpriv) >= 0x35) {
 		switch (fw_cmdio) {
 		case FW_CMD_RA_REFRESH_N:
 			fw_cmdio = FW_CMD_RA_REFRESH_N_COMB;
@@ -1478,180 +1482,186 @@ bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fw_cmdio)
 			break;
 		}
 
-		/* If firmware version is v.62 or later,
-		 * use FW_CMD_IO_SET for FW_CMD_CTRL_DM_BY_DRIVER */
-		if (hal_get_firmwareversion(rtlpriv) >= 0x3E) {
-			if (fw_cmdio == FW_CMD_CTRL_DM_BY_DRIVER)
-				fw_cmdio = FW_CMD_CTRL_DM_BY_DRIVER_NEW;
+	} else {
+		if ((fw_cmdio == FW_CMD_IQK_ENABLE) ||
+		    (fw_cmdio == FW_CMD_RA_REFRESH_N) ||
+		    (fw_cmdio == FW_CMD_RA_REFRESH_BG)) {
+			bPostProcessing = true;
+			goto post_proc;
 		}
+	}
+	/* If firmware version is v.62 or later,
+	 * use FW_CMD_IO_SET for FW_CMD_CTRL_DM_BY_DRIVER */
+	if (hal_get_firmwareversion(rtlpriv) >= 0x3E) {
+		if (fw_cmdio == FW_CMD_CTRL_DM_BY_DRIVER)
+			fw_cmdio = FW_CMD_CTRL_DM_BY_DRIVER_NEW;
+	}
 
-
-		/* We shall revise all FW Cmd IO into Reg0x364
-		 * DM map table in the future. */
-		switch (fw_cmdio) {
-		case FW_CMD_RA_INIT:
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, "RA init!!\n");
-			fw_cmdmap |= FW_RA_INIT_CTL;
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			/* Clear control flag to sync with FW. */
-			FW_CMD_IO_CLR(rtlpriv, FW_RA_INIT_CTL);
-			break;
-		case FW_CMD_DIG_DISABLE:
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 "Set DIG disable!!\n");
-			fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			break;
-		case FW_CMD_DIG_ENABLE:
-		case FW_CMD_DIG_RESUME:
-			if (!(rtlpriv->dm.dm_flag & HAL_DM_DIG_DISABLE)) {
-				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-					 "Set DIG enable or resume!!\n");
-				fw_cmdmap |= (FW_DIG_ENABLE_CTL | FW_SS_CTL);
-				FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			}
-			break;
-		case FW_CMD_DIG_HALT:
+	/* We shall revise all FW Cmd IO into Reg0x364
+	 * DM map table in the future. */
+	switch (fw_cmdio) {
+	case FW_CMD_RA_INIT:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, "RA init!!\n");
+		fw_cmdmap |= FW_RA_INIT_CTL;
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		/* Clear control flag to sync with FW. */
+		FW_CMD_IO_CLR(rtlpriv, FW_RA_INIT_CTL);
+		break;
+	case FW_CMD_DIG_DISABLE:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 "Set DIG disable!!\n");
+		fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		break;
+	case FW_CMD_DIG_ENABLE:
+	case FW_CMD_DIG_RESUME:
+		if (!(rtlpriv->dm.dm_flag & HAL_DM_DIG_DISABLE)) {
 			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 "Set DIG halt!!\n");
-			fw_cmdmap &= ~(FW_DIG_ENABLE_CTL | FW_SS_CTL);
+				 "Set DIG enable or resume!!\n");
+			fw_cmdmap |= (FW_DIG_ENABLE_CTL | FW_SS_CTL);
 			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			break;
-		case FW_CMD_TXPWR_TRACK_THERMAL: {
-			u8	thermalval = 0;
-			fw_cmdmap |= FW_PWR_TRK_CTL;
-
-			/* Clear FW parameter in terms of thermal parts. */
-			fw_param &= FW_PWR_TRK_PARAM_CLR;
-
-			thermalval = rtlpriv->dm.thermalvalue;
-			fw_param |= ((thermalval << 24) |
-				     (rtlefuse->thermalmeter[0] << 16));
+		}
+		break;
+	case FW_CMD_DIG_HALT:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 "Set DIG halt!!\n");
+		fw_cmdmap &= ~(FW_DIG_ENABLE_CTL | FW_SS_CTL);
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		break;
+	case FW_CMD_TXPWR_TRACK_THERMAL: {
+		u8	thermalval = 0;
+		fw_cmdmap |= FW_PWR_TRK_CTL;
 
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 "Set TxPwr tracking!! FwCmdMap(%#x), FwParam(%#x)\n",
-				 fw_cmdmap, fw_param);
+		/* Clear FW parameter in terms of thermal parts. */
+		fw_param &= FW_PWR_TRK_PARAM_CLR;
 
-			FW_CMD_PARA_SET(rtlpriv, fw_param);
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		thermalval = rtlpriv->dm.thermalvalue;
+		fw_param |= ((thermalval << 24) |
+			     (rtlefuse->thermalmeter[0] << 16));
 
-			/* Clear control flag to sync with FW. */
-			FW_CMD_IO_CLR(rtlpriv, FW_PWR_TRK_CTL);
-			}
-			break;
-		/* The following FW CMDs are only compatible to
-		 * v.53 or later. */
-		case FW_CMD_RA_REFRESH_N_COMB:
-			fw_cmdmap |= FW_RA_N_CTL;
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 "Set TxPwr tracking!! FwCmdMap(%#x), FwParam(%#x)\n",
+			 fw_cmdmap, fw_param);
 
-			/* Clear RA BG mode control. */
-			fw_cmdmap &= ~(FW_RA_BG_CTL | FW_RA_INIT_CTL);
+		FW_CMD_PARA_SET(rtlpriv, fw_param);
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
 
-			/* Clear FW parameter in terms of RA parts. */
-			fw_param &= FW_RA_PARAM_CLR;
+		/* Clear control flag to sync with FW. */
+		FW_CMD_IO_CLR(rtlpriv, FW_PWR_TRK_CTL); }
+		break;
+	/* The following FW CMDs are only compatible to
+	 * v.53 or later. */
+	case FW_CMD_RA_REFRESH_N_COMB:
+		fw_cmdmap |= FW_RA_N_CTL;
 
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 "[FW CMD] [New Version] Set RA/IOT Comb in n mode!! FwCmdMap(%#x), FwParam(%#x)\n",
-				 fw_cmdmap, fw_param);
+		/* Clear RA BG mode control. */
+		fw_cmdmap &= ~(FW_RA_BG_CTL | FW_RA_INIT_CTL);
 
-			FW_CMD_PARA_SET(rtlpriv, fw_param);
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		/* Clear FW parameter in terms of RA parts. */
+		fw_param &= FW_RA_PARAM_CLR;
 
-			/* Clear control flag to sync with FW. */
-			FW_CMD_IO_CLR(rtlpriv, FW_RA_N_CTL);
-			break;
-		case FW_CMD_RA_REFRESH_BG_COMB:
-			fw_cmdmap |= FW_RA_BG_CTL;
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 "[FW CMD] [New Version] Set RA/IOT Comb in n mode!! FwCmdMap(%#x), FwParam(%#x)\n",
+			 fw_cmdmap, fw_param);
 
-			/* Clear RA n-mode control. */
-			fw_cmdmap &= ~(FW_RA_N_CTL | FW_RA_INIT_CTL);
-			/* Clear FW parameter in terms of RA parts. */
-			fw_param &= FW_RA_PARAM_CLR;
+		FW_CMD_PARA_SET(rtlpriv, fw_param);
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
 
-			FW_CMD_PARA_SET(rtlpriv, fw_param);
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		/* Clear control flag to sync with FW. */
+		FW_CMD_IO_CLR(rtlpriv, FW_RA_N_CTL);
+		break;
+	case FW_CMD_RA_REFRESH_BG_COMB:
+		fw_cmdmap |= FW_RA_BG_CTL;
 
-			/* Clear control flag to sync with FW. */
-			FW_CMD_IO_CLR(rtlpriv, FW_RA_BG_CTL);
-			break;
-		case FW_CMD_IQK_ENABLE:
-			fw_cmdmap |= FW_IQK_CTL;
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			/* Clear control flag to sync with FW. */
-			FW_CMD_IO_CLR(rtlpriv, FW_IQK_CTL);
-			break;
-		/* The following FW CMD is compatible to v.62 or later.  */
-		case FW_CMD_CTRL_DM_BY_DRIVER_NEW:
-			fw_cmdmap |= FW_DRIVER_CTRL_DM_CTL;
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			break;
-		/*  The followed FW Cmds needs post-processing later. */
-		case FW_CMD_RESUME_DM_BY_SCAN:
-			fw_cmdmap |= (FW_DIG_ENABLE_CTL |
-				      FW_HIGH_PWR_ENABLE_CTL |
-				      FW_SS_CTL);
+		/* Clear RA n-mode control. */
+		fw_cmdmap &= ~(FW_RA_N_CTL | FW_RA_INIT_CTL);
+		/* Clear FW parameter in terms of RA parts. */
+		fw_param &= FW_RA_PARAM_CLR;
 
-			if (rtlpriv->dm.dm_flag & HAL_DM_DIG_DISABLE ||
-				!digtable->dig_enable_flag)
-				fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
+		FW_CMD_PARA_SET(rtlpriv, fw_param);
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
 
-			if ((rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) ||
-			    rtlpriv->dm.dynamic_txpower_enable)
-				fw_cmdmap &= ~FW_HIGH_PWR_ENABLE_CTL;
+		/* Clear control flag to sync with FW. */
+		FW_CMD_IO_CLR(rtlpriv, FW_RA_BG_CTL);
+		break;
+	case FW_CMD_IQK_ENABLE:
+		fw_cmdmap |= FW_IQK_CTL;
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		/* Clear control flag to sync with FW. */
+		FW_CMD_IO_CLR(rtlpriv, FW_IQK_CTL);
+		break;
+	/* The following FW CMD is compatible to v.62 or later.  */
+	case FW_CMD_CTRL_DM_BY_DRIVER_NEW:
+		fw_cmdmap |= FW_DRIVER_CTRL_DM_CTL;
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		break;
+	/*  The followed FW Cmds needs post-processing later. */
+	case FW_CMD_RESUME_DM_BY_SCAN:
+		fw_cmdmap |= (FW_DIG_ENABLE_CTL |
+			      FW_HIGH_PWR_ENABLE_CTL |
+			      FW_SS_CTL);
 
-			if ((digtable->dig_ext_port_stage ==
-			    DIG_EXT_PORT_STAGE_0) ||
-			    (digtable->dig_ext_port_stage ==
-			    DIG_EXT_PORT_STAGE_1))
-				fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
+		if (rtlpriv->dm.dm_flag & HAL_DM_DIG_DISABLE ||
+		    !digtable->dig_enable_flag)
+			fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
 
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			bPostProcessing = true;
-			break;
-		case FW_CMD_PAUSE_DM_BY_SCAN:
-			fw_cmdmap &= ~(FW_DIG_ENABLE_CTL |
-				       FW_HIGH_PWR_ENABLE_CTL |
-				       FW_SS_CTL);
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			bPostProcessing = true;
-			break;
-		case FW_CMD_HIGH_PWR_DISABLE:
+		if ((rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) ||
+		    rtlpriv->dm.dynamic_txpower_enable)
 			fw_cmdmap &= ~FW_HIGH_PWR_ENABLE_CTL;
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			bPostProcessing = true;
-			break;
-		case FW_CMD_HIGH_PWR_ENABLE:
-			if (!(rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) &&
-			    !rtlpriv->dm.dynamic_txpower_enable) {
-				fw_cmdmap |= (FW_HIGH_PWR_ENABLE_CTL |
-					      FW_SS_CTL);
-				FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-				bPostProcessing = true;
-			}
-			break;
-		case FW_CMD_DIG_MODE_FA:
-			fw_cmdmap |= FW_FA_CTL;
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			break;
-		case FW_CMD_DIG_MODE_SS:
-			fw_cmdmap &= ~FW_FA_CTL;
-			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			break;
-		case FW_CMD_PAPE_CONTROL:
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 "[FW CMD] Set PAPE Control\n");
-			fw_cmdmap &= ~FW_PAPE_CTL_BY_SW_HW;
 
+		if ((digtable->dig_ext_port_stage ==
+		    DIG_EXT_PORT_STAGE_0) ||
+		    (digtable->dig_ext_port_stage ==
+		    DIG_EXT_PORT_STAGE_1))
+			fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
+
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		bPostProcessing = true;
+		break;
+	case FW_CMD_PAUSE_DM_BY_SCAN:
+		fw_cmdmap &= ~(FW_DIG_ENABLE_CTL |
+			       FW_HIGH_PWR_ENABLE_CTL |
+			       FW_SS_CTL);
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		bPostProcessing = true;
+		break;
+	case FW_CMD_HIGH_PWR_DISABLE:
+		fw_cmdmap &= ~FW_HIGH_PWR_ENABLE_CTL;
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		bPostProcessing = true;
+		break;
+	case FW_CMD_HIGH_PWR_ENABLE:
+		if (!(rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) &&
+		    !rtlpriv->dm.dynamic_txpower_enable) {
+			fw_cmdmap |= (FW_HIGH_PWR_ENABLE_CTL |
+				      FW_SS_CTL);
 			FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
-			break;
-		default:
-			/* Pass to original FW CMD processing callback
-			 * routine. */
 			bPostProcessing = true;
-			break;
 		}
-	} while (false);
+		break;
+	case FW_CMD_DIG_MODE_FA:
+		fw_cmdmap |= FW_FA_CTL;
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		break;
+	case FW_CMD_DIG_MODE_SS:
+		fw_cmdmap &= ~FW_FA_CTL;
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		break;
+	case FW_CMD_PAPE_CONTROL:
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 "[FW CMD] Set PAPE Control\n");
+		fw_cmdmap &= ~FW_PAPE_CTL_BY_SW_HW;
 
+		FW_CMD_IO_SET(rtlpriv, fw_cmdmap);
+		break;
+	default:
+		/* Pass to original FW CMD processing callback
+		 * routine. */
+		bPostProcessing = true;
+		break;
+	}
+
+post_proc:
 	/* We shall post processing these FW CMD if
 	 * variable bPostProcessing is set. */
 	if (bPostProcessing && !rtlhal->set_fwcmd_inprogress) {
@@ -1715,8 +1725,17 @@ void rtl92s_phy_switch_ephy_parameter(struct ieee80211_hw *hw)
 
 }
 
-void rtl92s_phy_set_beacon_hwreg(struct ieee80211_hw *hw, u16 BeaconInterval)
+void rtl92s_phy_set_beacon_hwreg(struct ieee80211_hw *hw, u16 BeaconInt)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	rtl_write_dword(rtlpriv, WFM5, 0xF1000000 | (BeaconInterval << 8));
+	u32 new_bcn_num = 0;
+
+	if (hal_get_firmwareversion(rtlpriv) >= 0x33) {
+		/* Fw v.51 and later. */
+		rtl_write_dword(rtlpriv, WFM5, 0xF1000000 | (BeaconInt << 8));
+	} else {
+		new_bcn_num = BeaconInt * 32 - 64;
+		rtl_write_dword(rtlpriv, WFM3 + 4, new_bcn_num);
+		rtl_write_dword(rtlpriv, WFM3, 0xB026007C);
+	}
 }
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index e67b338..20081b9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -43,7 +43,7 @@ static u8 _rtl92se_map_hwqueue_to_fwqueue(struct sk_buff *skb,	u8 skb_queue)
 
 	if (unlikely(ieee80211_is_beacon(fc)))
 		return QSLT_BEACON;
-	if (ieee80211_is_mgmt(fc))
+	if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc))
 		return QSLT_MGNT;
 	if (ieee80211_is_nullfunc(fc))
 		return QSLT_HIGH;
@@ -118,12 +118,12 @@ static void _rtl92se_query_rxphystatus(struct ieee80211_hw *hw,
 				       bool packet_beacon)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtlpriv);
 	struct phy_sts_cck_8192s_t *cck_buf;
 	s8 rx_pwr_all = 0, rx_pwr[4];
 	u8 rf_rx_num = 0, evm, pwdb_all;
 	u8 i, max_spatial_stream;
 	u32 rssi, total_rssi = 0;
-	bool in_powersavemode = false;
 	bool is_cck = pstats->is_cck;
 
 	pstats->packet_matchbssid = packet_match_bssid;
@@ -136,7 +136,7 @@ static void _rtl92se_query_rxphystatus(struct ieee80211_hw *hw,
 		u8 report, cck_highpwr;
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 
-		if (!in_powersavemode)
+		if (ppsc->rfpwr_state == ERFON)
 			cck_highpwr = (u8) rtl_get_bbreg(hw,
 						RFPGA0_XA_HSSIPARAMETER2,
 						0x200);
@@ -626,6 +626,11 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE_RTL8192S);
 
+	if (ieee80211_is_nullfunc(fc) || ieee80211_is_ctl(fc)) {
+		firstseg = true;
+		lastseg = true;
+	}
+
 	if (firstseg) {
 		if (rtlpriv->dm.useramask) {
 			/* set txdesc macId */
-- 
1.7.10.4

