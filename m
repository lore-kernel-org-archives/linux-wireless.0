Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48796 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1FOXXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 19:23:54 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so673021pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 16:23:54 -0700 (PDT)
Message-ID: <4DF93EE1.1090102@ring3k.org> (sfid-20110616_012358_074015_3ED777E4)
Date: Thu, 16 Jun 2011 08:23:13 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] rtlwifi: rtl8192{c,ce,cu,se}: Remove comparisons of booleans
 with true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are a potential source of confusion, as most C code treats all
non-zero values as true.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/base.c               |    2 +-
 drivers/net/wireless/rtlwifi/core.c               |    4 ++--
 drivers/net/wireless/rtlwifi/efuse.c              |    8 ++++----
 drivers/net/wireless/rtlwifi/ps.c                 |    2 +-
 drivers/net/wireless/rtlwifi/rc.c                 |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |   10 +++++-----
 drivers/net/wireless/rtlwifi/rtl8192ce/led.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/rf.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c      |    6 +++---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |    8 ++++----
 drivers/net/wireless/rtlwifi/rtl8192cu/led.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/dm.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/hw.c       |    6 +++---
 drivers/net/wireless/rtlwifi/rtl8192se/led.c      |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c      |    4 ++--
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |    6 +++---
 20 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index fb5e43b..bc13533 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -523,7 +523,7 @@ static void _rtl_query_shortgi(struct ieee80211_hw *hw,
 		mac->opmode == NL80211_IFTYPE_ADHOC)
 		bw_40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
 
-	if ((bw_40 == true) && sgi_40)
+	if (bw_40 && sgi_40)
 		tcb_desc->use_shortgi = true;
 	else if ((bw_40 == false) && sgi_20)
 		tcb_desc->use_shortgi = true;
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 3313ce6..03ce696 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -443,11 +443,11 @@ static int rtl_op_sta_add(struct ieee80211_hw *hw,
 			sta_entry->wireless_mode = WIRELESS_MODE_G;
 			if (sta->supp_rates[0] <= 0xf)
 				sta_entry->wireless_mode = WIRELESS_MODE_B;
-			if (sta->ht_cap.ht_supported == true)
+			if (sta->ht_cap.ht_supported)
 				sta_entry->wireless_mode = WIRELESS_MODE_N_24G;
 		} else if (rtlhal->current_bandtype == BAND_ON_5G) {
 			sta_entry->wireless_mode = WIRELESS_MODE_A;
-			if (sta->ht_cap.ht_supported == true)
+			if (sta->ht_cap.ht_supported)
 				sta_entry->wireless_mode = WIRELESS_MODE_N_24G;
 		}
 
diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
index 0b56232..3fc21f6 100644
--- a/drivers/net/wireless/rtlwifi/efuse.c
+++ b/drivers/net/wireless/rtlwifi/efuse.c
@@ -382,7 +382,7 @@ bool efuse_shadow_update_chk(struct ieee80211_hw *hw)
 			}
 		}
 
-		if (wordchanged == true)
+		if (wordchanged)
 			hdr_num++;
 	}
 
@@ -453,7 +453,7 @@ bool efuse_shadow_update(struct ieee80211_hw *hw)
 		base = offset * 8;
 
 		for (i = 0; i < 8; i++) {
-			if (first_pg == true) {
+			if (first_pg) {
 
 				word_en &= ~(BIT(i / 2));
 
@@ -505,7 +505,7 @@ void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 
-	if (rtlefuse->autoload_failflag == true)
+	if (rtlefuse->autoload_failflag)
 		memset(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0], 0xFF,
 			rtlpriv->cfg->maps[EFUSE_HWSET_MAX_SIZE]);
 	else
@@ -690,7 +690,7 @@ static void efuse_read_data_case1(struct ieee80211_hw *hw, u16 *efuse_addr,
 			}
 		}
 
-		if (dataempty == true) {
+		if (dataempty) {
 			*readstate = PG_STATE_DATA;
 		} else {
 			*efuse_addr = *efuse_addr + (word_cnts * 2) + 1;
diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtlwifi/ps.c
index 3eb039a..a693fef 100644
--- a/drivers/net/wireless/rtlwifi/ps.c
+++ b/drivers/net/wireless/rtlwifi/ps.c
@@ -90,7 +90,7 @@ bool rtl_ps_set_rf_state(struct ieee80211_hw *hw,
 		ppsc->rfoff_reason &= (~changesource);
 
 		if ((changesource == RF_CHANGE_BY_HW) &&
-		    (ppsc->hwradiooff == true)) {
+		    (ppsc->hwradiooff)) {
 			ppsc->hwradiooff = false;
 		}
 
diff --git a/drivers/net/wireless/rtlwifi/rc.c b/drivers/net/wireless/rtlwifi/rc.c
index 30da68a..539df66 100644
--- a/drivers/net/wireless/rtlwifi/rc.c
+++ b/drivers/net/wireless/rtlwifi/rc.c
@@ -200,7 +200,7 @@ static void rtl_tx_status(void *ppriv,
 	if (sta) {
 		/* Check if aggregation has to be enabled for this tid */
 		sta_entry = (struct rtl_sta_info *) sta->drv_priv;
-		if ((sta->ht_cap.ht_supported == true) &&
+		if ((sta->ht_cap.ht_supported) &&
 				!(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 			if (ieee80211_is_data_qos(fc)) {
 				u8 tid = rtl_get_tid(skb);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 57d52e9..a00774e 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -474,7 +474,7 @@ static void rtl92c_dm_ctrl_initgain_by_twoport(struct ieee80211_hw *hw)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	if (mac->act_scanning == true)
+	if (mac->act_scanning)
 		return;
 
 	if (mac->link_state >= MAC80211_LINKED)
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 7a7c3ae..9e2a9e3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -488,7 +488,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_CORRECT_TSF:{
 			u8 btype_ibss = ((u8 *) (val))[0];
 
-			if (btype_ibss == true)
+			if (btype_ibss)
 				_rtl92ce_stop_tx_beacon(hw);
 
 			_rtl92ce_set_bcn_ctrl_reg(hw, 0, BIT(3));
@@ -500,7 +500,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 
 			_rtl92ce_set_bcn_ctrl_reg(hw, BIT(3), 0);
 
-			if (btype_ibss == true)
+			if (btype_ibss)
 				_rtl92ce_resume_tx_beacon(hw);
 
 			break;
@@ -1121,7 +1121,7 @@ void rtl92ce_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
-	if (check_bssid == true) {
+	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
 					      (u8 *) (&reg_rcr));
@@ -1583,7 +1583,7 @@ static void _rtl92ce_read_adapter_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 	}
 
-	if (rtlefuse->autoload_failflag == true)
+	if (rtlefuse->autoload_failflag)
 		return;
 
 	for (i = 0; i < 6; i += 2) {
@@ -1992,7 +1992,7 @@ bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 	u1tmp = rtl_read_byte(rtlpriv, REG_GPIO_IO_SEL);
 	e_rfpowerstate_toset = (u1tmp & BIT(3)) ? ERFON : ERFOFF;
 
-	if ((ppsc->hwradiooff == true) && (e_rfpowerstate_toset == ERFON)) {
+	if ((ppsc->hwradiooff) && (e_rfpowerstate_toset == ERFON)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("GPIOChangeRF  - HW Radio ON, RF ON\n"));
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
index 9dd1ed7..28a1a70 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -84,7 +84,7 @@ void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain == true)
+		if (pcipriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
 		else
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
index 90d0f2c..d3b01e6 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -76,7 +76,7 @@ void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 	if (rtlefuse->eeprom_regulatory != 0)
 		turbo_scanoff = true;
 
-	if (mac->act_scanning == true) {
+	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index be37521..230bbe9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -678,7 +678,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 						    GET_RX_DESC_PAGGR(pdesc));
 
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
-	if (phystatus == true) {
+	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
 						     stats->rx_bufshift);
 
@@ -927,7 +927,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw,
 
 void rtl92ce_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
 {
-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			wmb();
@@ -968,7 +968,7 @@ u32 rtl92ce_get_desc(u8 *p_desc, bool istx, u8 desc_name)
 {
 	u32 ret = 0;
 
-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			ret = GET_TX_DESC_OWN(p_desc);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
index 52e2af5..2b34764 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -520,7 +520,7 @@ static void _rtl92cu_read_adapter_info(struct ieee80211_hw *hw)
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, ("Autoload OK\n"));
 		rtlefuse->autoload_failflag = false;
 	}
-	if (rtlefuse->autoload_failflag == true)
+	if (rtlefuse->autoload_failflag)
 		return;
 	for (i = 0; i < 6; i += 2) {
 		usvalue = *(u16 *)&hwinfo[EEPROM_MAC_ADDR + i];
@@ -1594,7 +1594,7 @@ static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
 	default:
 		break;
 	}
-	if (filterout_non_associated_bssid == true) {
+	if (filterout_non_associated_bssid) {
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
 			switch (rtlphy->current_io_type) {
 			case IO_CMD_RESUME_DM_BY_SCAN:
@@ -2155,7 +2155,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_CORRECT_TSF:{
 			u8 btype_ibss = ((u8 *) (val))[0];
 
-			if (btype_ibss == true)
+			if (btype_ibss)
 				_rtl92cu_stop_tx_beacon(hw);
 			_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(3));
 			rtl_write_dword(rtlpriv, REG_TSFTR, (u32)(mac->tsf &
@@ -2163,7 +2163,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 			rtl_write_dword(rtlpriv, REG_TSFTR + 4,
 					(u32)((mac->tsf >> 32) & 0xffffffff));
 			_rtl92cu_set_bcn_ctrl_reg(hw, BIT(3), 0);
-			if (btype_ibss == true)
+			if (btype_ibss)
 				_rtl92cu_resume_tx_beacon(hw);
 			break;
 		}
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/led.c b/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
index 332c743..2ff9d83 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/led.c
@@ -82,7 +82,7 @@ void rtl92cu_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (usbpriv->ledctl.led_opendrain == true)
+		if (usbpriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
 		else
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index c7576ec..1e851aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -82,7 +82,7 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 		    (rtlefuse->external_pa))
 			turbo_scanoff = true;
 	}
-	if (mac->act_scanning == true) {
+	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
 		if (turbo_scanoff) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 3a92ba3..906e7aa 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -342,7 +342,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 						(u8)GET_RX_DESC_RX_MCS(pdesc),
 						(bool)GET_RX_DESC_PAGGR(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
-	if (phystatus == true) {
+	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(pdesc + RTL_RX_DESC_SIZE);
 		rtl92c_translate_rx_signal_stuff(hw, skb, stats, pdesc,
 						 p_drvinfo);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
index 609c7ec..4203a85 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/dm.c
@@ -452,7 +452,7 @@ static void _rtl92s_dm_initial_gain_sta_beforeconnect(struct ieee80211_hw *hw)
 			if (rtlpriv->psc.rfpwr_state != ERFON)
 				return;
 
-			if (digtable.backoff_enable_flag == true)
+			if (digtable.backoff_enable_flag)
 				rtl92s_backoff_enable_flag(hw);
 			else
 				digtable.backoff_val = DM_DIG_BACKOFF;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
index f2d67be..d4683e9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/hw.c
@@ -1106,7 +1106,7 @@ void rtl92se_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 	if (rtlpriv->psc.rfpwr_state != ERFON)
 		return;
 
-	if (check_bssid == true) {
+	if (check_bssid) {
 		reg_rcr |= (RCR_CBSSID);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR, (u8 *)(&reg_rcr));
 	} else if (check_bssid == false) {
@@ -1648,7 +1648,7 @@ static void _rtl92se_read_adapter_info(struct ieee80211_hw *hw)
 		rtlefuse->autoload_failflag = false;
 	}
 
-	if (rtlefuse->autoload_failflag == true)
+	if (rtlefuse->autoload_failflag)
 		return;
 
 	_rtl8192se_get_IC_Inferiority(hw);
@@ -2298,7 +2298,7 @@ bool rtl92se_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 
 	rfpwr_toset = _rtl92se_rf_onoff_detect(hw);
 
-	if ((ppsc->hwradiooff == true) && (rfpwr_toset == ERFON)) {
+	if ((ppsc->hwradiooff) && (rfpwr_toset == ERFON)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("RFKILL-HW Radio ON, RF ON\n"));
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/led.c b/drivers/net/wireless/rtlwifi/rtl8192se/led.c
index 6d4f666..e3fe7c9 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/led.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/led.c
@@ -90,7 +90,7 @@ void rtl92se_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.led_opendrain == true)
+		if (pcipriv->ledctl.led_opendrain)
 			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(1)));
 		else
 			rtl_write_byte(rtlpriv, LEDCFG, (ledcfg | BIT(3)));
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
index 7ee2dac..81a5aa4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -1416,7 +1416,7 @@ static void _rtl92s_phy_set_fwcmd_io(struct ieee80211_hw *hw)
 		break;
 	case FW_CMD_HIGH_PWR_ENABLE:
 		if ((rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) ||
-			(rtlpriv->dm.dynamic_txpower_enable == true))
+			rtlpriv->dm.dynamic_txpower_enable)
 			break;
 
 		/* CCA threshold */
@@ -1608,7 +1608,7 @@ bool rtl92s_phy_set_fw_cmd(struct ieee80211_hw *hw, enum fwcmd_iotype fw_cmdio)
 				fw_cmdmap &= ~FW_DIG_ENABLE_CTL;
 
 			if ((rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) ||
-			    (rtlpriv->dm.dynamic_txpower_enable == true))
+			    rtlpriv->dm.dynamic_txpower_enable)
 				fw_cmdmap &= ~FW_HIGH_PWR_ENABLE_CTL;
 
 			if ((digtable.dig_ext_port_stage ==
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
index 1d3a483..c6e3a4c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/rf.c
@@ -410,7 +410,7 @@ void rtl92s_phy_rf6052_set_ccktxpower(struct ieee80211_hw *hw, u8 pwrlevel)
 	      (rtlefuse->eeprom_regulatory != 0)))
 		dont_inc_cck_or_turboscanoff = true;
 
-	if (mac->act_scanning == true) {
+	if (mac->act_scanning) {
 		txagc = 0x3f;
 		if (dont_inc_cck_or_turboscanoff)
 			txagc = pwrlevel;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index d509cf6..cffe308 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -661,7 +661,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 
 
 	rx_status->mactime = GET_RX_STATUS_DESC_TSFL(pdesc);
-	if (phystatus == true) {
+	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo *)(skb->data +
 						 stats->rx_bufshift);
 		_rtl92se_translate_rx_signal_stuff(hw, skb, stats, pdesc,
@@ -900,7 +900,7 @@ void rtl92se_tx_fill_cmddesc(struct ieee80211_hw *hw, u8 *pdesc,
 
 void rtl92se_set_desc(u8 *pdesc, bool istx, u8 desc_name, u8 *val)
 {
-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			wmb();
@@ -941,7 +941,7 @@ u32 rtl92se_get_desc(u8 *desc, bool istx, u8 desc_name)
 {
 	u32 ret = 0;
 
-	if (istx == true) {
+	if (istx) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
 			ret = GET_TX_DESC_OWN(desc);
-- 
1.7.4.1

