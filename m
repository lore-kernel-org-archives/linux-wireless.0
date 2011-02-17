Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab1BQVSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 16:18:17 -0500
Date: Thu, 17 Feb 2011 15:18:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/14] rtlwifi: Modify some rtl8192ce routines for merging
 rtl8192cu
Message-ID: <4d5d9097.YxkwhKzWG606pSHR%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Modify some rtl8192ce routines for merging with rtl8192cu. In addition,
remove some usage of Hungarian notation.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -124,7 +124,7 @@ void rtl92ce_get_hw_reg(struct ieee80211
 			break;
 		}
 	case HW_VAR_FW_PSMODE_STATUS:
-		*((bool *) (val)) = ppsc->b_fw_current_inpsmode;
+		*((bool *) (val)) = ppsc->fw_current_inpsmode;
 		break;
 	case HW_VAR_CORRECT_TSF:{
 		u64 tsf;
@@ -173,15 +173,15 @@ void rtl92ce_set_hw_reg(struct ieee80211
 			break;
 		}
 	case HW_VAR_BASIC_RATE:{
-			u16 b_rate_cfg = ((u16 *) val)[0];
+			u16 rate_cfg = ((u16 *) val)[0];
 			u8 rate_index = 0;
-			b_rate_cfg = b_rate_cfg & 0x15f;
-			b_rate_cfg |= 0x01;
-			rtl_write_byte(rtlpriv, REG_RRSR, b_rate_cfg & 0xff);
+			rate_cfg &= 0x15f;
+			rate_cfg |= 0x01;
+			rtl_write_byte(rtlpriv, REG_RRSR, rate_cfg & 0xff);
 			rtl_write_byte(rtlpriv, REG_RRSR + 1,
-				       (b_rate_cfg >> 8)&0xff);
-			while (b_rate_cfg > 0x1) {
-				b_rate_cfg = (b_rate_cfg >> 1);
+				       (rate_cfg >> 8)&0xff);
+			while (rate_cfg > 0x1) {
+				rate_cfg = (rate_cfg >> 1);
 				rate_index++;
 			}
 			rtl_write_byte(rtlpriv, REG_INIRTS_RATE_SEL,
@@ -469,12 +469,12 @@ void rtl92ce_set_hw_reg(struct ieee80211
 			break;
 		}
 	case HW_VAR_FW_PSMODE_STATUS:
-		ppsc->b_fw_current_inpsmode = *((bool *) val);
+		ppsc->fw_current_inpsmode = *((bool *) val);
 		break;
 	case HW_VAR_H2C_FW_JOINBSSRPT:{
 			u8 mstatus = (*(u8 *) val);
 			u8 tmp_regcr, tmp_reg422;
-			bool b_recover = false;
+			bool recover = false;
 
 			if (mstatus == RT_MEDIA_CONNECT) {
 				rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_AID,
@@ -491,7 +491,7 @@ void rtl92ce_set_hw_reg(struct ieee80211
 				    rtl_read_byte(rtlpriv,
 						  REG_FWHW_TXQ_CTRL + 2);
 				if (tmp_reg422 & BIT(6))
-					b_recover = true;
+					recover = true;
 				rtl_write_byte(rtlpriv, REG_FWHW_TXQ_CTRL + 2,
 					       tmp_reg422 & (~BIT(6)));
 
@@ -500,7 +500,7 @@ void rtl92ce_set_hw_reg(struct ieee80211
 				_rtl92ce_set_bcn_ctrl_reg(hw, BIT(3), 0);
 				_rtl92ce_set_bcn_ctrl_reg(hw, 0, BIT(4));
 
-				if (b_recover) {
+				if (recover) {
 					rtl_write_byte(rtlpriv,
 						       REG_FWHW_TXQ_CTRL + 2,
 						       tmp_reg422);
@@ -868,7 +868,7 @@ static void _rtl92ce_enable_aspm_back_do
 	rtl_write_word(rtlpriv, 0x350, 0x870c);
 	rtl_write_byte(rtlpriv, 0x352, 0x1);
 
-	if (ppsc->b_support_backdoor)
+	if (ppsc->support_backdoor)
 		rtl_write_byte(rtlpriv, 0x349, 0x1b);
 	else
 		rtl_write_byte(rtlpriv, 0x349, 0x03);
@@ -940,10 +940,10 @@ int rtl92ce_hw_init(struct ieee80211_hw
 			 ("Failed to download FW. Init HW "
 			  "without FW now..\n"));
 		err = 1;
-		rtlhal->bfw_ready = false;
+		rtlhal->fw_ready = false;
 		return err;
 	} else {
-		rtlhal->bfw_ready = true;
+		rtlhal->fw_ready = true;
 	}
 
 	rtlhal->last_hmeboxnum = 0;
@@ -1237,7 +1237,7 @@ static void _rtl92ce_poweroff_adapter(st
 	rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE2);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE0);
-	if ((rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(7)) && rtlhal->bfw_ready)
+	if ((rtl_read_byte(rtlpriv, REG_MCUFWDL) & BIT(7)) && rtlhal->fw_ready)
 		rtl92c_firmware_selfreset(hw);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1, 0x51);
 	rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
@@ -1555,7 +1555,7 @@ static void _rtl92ce_read_txpower_info_f
 	rtlefuse->eeprom_thermalmeter = (tempval & 0x1f);
 
 	if (rtlefuse->eeprom_thermalmeter == 0x1f || autoload_fail)
-		rtlefuse->b_apk_thermalmeterignore = true;
+		rtlefuse->apk_thermalmeterignore = true;
 
 	rtlefuse->thermalmeter[0] = rtlefuse->eeprom_thermalmeter;
 	RTPRINT(rtlpriv, FINIT, INIT_TxPower,
@@ -1612,7 +1612,7 @@ static void _rtl92ce_read_adapter_info(s
 
 	rtlefuse->eeprom_channelplan = *(u8 *)&hwinfo[EEPROM_CHANNELPLAN];
 	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
-	rtlefuse->b_txpwr_fromeprom = true;
+	rtlefuse->txpwr_fromeprom = true;
 	rtlefuse->eeprom_oemid = *(u8 *)&hwinfo[EEPROM_CUSTOMER_ID];
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
@@ -1655,7 +1655,7 @@ static void _rtl92ce_hal_customized_beha
 
 	switch (rtlhal->oem_id) {
 	case RT_CID_819x_HP:
-		pcipriv->ledctl.bled_opendrain = true;
+		pcipriv->ledctl.led_opendrain = true;
 		break;
 	case RT_CID_819x_Lenovo:
 	case RT_CID_DEFAULT:
@@ -1680,10 +1680,10 @@ void rtl92ce_read_eeprom_info(struct iee
 
 	rtlhal->version = _rtl92ce_read_chip_version(hw);
 	if (get_rf_type(rtlphy) == RF_1T1R)
-		rtlpriv->dm.brfpath_rxenable[0] = true;
+		rtlpriv->dm.rfpath_rxenable[0] = true;
 	else
-		rtlpriv->dm.brfpath_rxenable[0] =
-		    rtlpriv->dm.brfpath_rxenable[1] = true;
+		rtlpriv->dm.rfpath_rxenable[0] =
+		    rtlpriv->dm.rfpath_rxenable[1] = true;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, ("VersionID = 0x%4x\n",
 						rtlhal->version));
 	tmp_u1b = rtl_read_byte(rtlpriv, REG_9346CR);
@@ -1714,13 +1714,13 @@ void rtl92ce_update_hal_rate_table(struc
 	u32 ratr_value = (u32) mac->basic_rates;
 	u8 *p_mcsrate = mac->mcs;
 	u8 ratr_index = 0;
-	u8 b_nmode = mac->ht_enable;
+	u8 nmode = mac->ht_enable;
 	u8 mimo_ps = 1;
 	u16 shortgi_rate;
 	u32 tmp_ratr_value;
-	u8 b_curtxbw_40mhz = mac->bw_40;
-	u8 b_curshortgi_40mhz = mac->sgi_40;
-	u8 b_curshortgi_20mhz = mac->sgi_20;
+	u8 curtxbw_40mhz = mac->bw_40;
+	u8 curshortgi_40mhz = mac->sgi_40;
+	u8 curshortgi_20mhz = mac->sgi_20;
 	enum wireless_mode wirelessmode = mac->mode;
 
 	ratr_value |= EF2BYTE((*(u16 *) (p_mcsrate))) << 12;
@@ -1737,7 +1737,7 @@ void rtl92ce_update_hal_rate_table(struc
 		break;
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
-		b_nmode = 1;
+		nmode = 1;
 		if (mimo_ps == 0) {
 			ratr_value &= 0x0007F005;
 		} else {
@@ -1763,9 +1763,8 @@ void rtl92ce_update_hal_rate_table(struc
 
 	ratr_value &= 0x0FFFFFFF;
 
-	if (b_nmode && ((b_curtxbw_40mhz &&
-			 b_curshortgi_40mhz) || (!b_curtxbw_40mhz &&
-						 b_curshortgi_20mhz))) {
+	if (nmode && ((curtxbw_40mhz && curshortgi_40mhz) || (!curtxbw_40mhz &&
+		       curshortgi_20mhz))) {
 
 		ratr_value |= 0x10000000;
 		tmp_ratr_value = (ratr_value >> 12);
@@ -1793,11 +1792,11 @@ void rtl92ce_update_hal_rate_mask(struct
 	u32 ratr_bitmap = (u32) mac->basic_rates;
 	u8 *p_mcsrate = mac->mcs;
 	u8 ratr_index;
-	u8 b_curtxbw_40mhz = mac->bw_40;
-	u8 b_curshortgi_40mhz = mac->sgi_40;
-	u8 b_curshortgi_20mhz = mac->sgi_20;
+	u8 curtxbw_40mhz = mac->bw_40;
+	u8 curshortgi_40mhz = mac->sgi_40;
+	u8 curshortgi_20mhz = mac->sgi_20;
 	enum wireless_mode wirelessmode = mac->mode;
-	bool b_shortgi = false;
+	bool shortgi = false;
 	u8 rate_mask[5];
 	u8 macid = 0;
 	u8 mimops = 1;
@@ -1839,7 +1838,7 @@ void rtl92ce_update_hal_rate_mask(struct
 		} else {
 			if (rtlphy->rf_type == RF_1T2R ||
 			    rtlphy->rf_type == RF_1T1R) {
-				if (b_curtxbw_40mhz) {
+				if (curtxbw_40mhz) {
 					if (rssi_level == 1)
 						ratr_bitmap &= 0x000f0000;
 					else if (rssi_level == 2)
@@ -1855,7 +1854,7 @@ void rtl92ce_update_hal_rate_mask(struct
 						ratr_bitmap &= 0x000ff005;
 				}
 			} else {
-				if (b_curtxbw_40mhz) {
+				if (curtxbw_40mhz) {
 					if (rssi_level == 1)
 						ratr_bitmap &= 0x0f0f0000;
 					else if (rssi_level == 2)
@@ -1873,13 +1872,13 @@ void rtl92ce_update_hal_rate_mask(struct
 			}
 		}
 
-		if ((b_curtxbw_40mhz && b_curshortgi_40mhz) ||
-		    (!b_curtxbw_40mhz && b_curshortgi_20mhz)) {
+		if ((curtxbw_40mhz && curshortgi_40mhz) ||
+		    (!curtxbw_40mhz && curshortgi_20mhz)) {
 
 			if (macid == 0)
-				b_shortgi = true;
+				shortgi = true;
 			else if (macid == 1)
-				b_shortgi = false;
+				shortgi = false;
 		}
 		break;
 	default:
@@ -1895,7 +1894,7 @@ void rtl92ce_update_hal_rate_mask(struct
 		 ("ratr_bitmap :%x\n", ratr_bitmap));
 	*(u32 *)&rate_mask = EF4BYTE((ratr_bitmap & 0x0fffffff) |
 				       (ratr_index << 28));
-	rate_mask[4] = macid | (b_shortgi ? 0x20 : 0x00) | 0x80;
+	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, ("Rate_index:%x, "
 						 "ratr_val:%x, %x:%x:%x:%x:%x\n",
 						 ratr_index, ratr_bitmap,
@@ -1927,13 +1926,13 @@ bool rtl92ce_gpio_radio_on_off_checking(
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	enum rf_pwrstate e_rfpowerstate_toset, cur_rfstate;
 	u8 u1tmp;
-	bool b_actuallyset = false;
+	bool actuallyset = false;
 	unsigned long flag;
 
 	if ((rtlpci->up_first_time == 1) || (rtlpci->being_init_adapter))
 		return false;
 
-	if (ppsc->b_swrf_processing)
+	if (ppsc->swrf_processing)
 		return false;
 
 	spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
@@ -1959,24 +1958,24 @@ bool rtl92ce_gpio_radio_on_off_checking(
 	u1tmp = rtl_read_byte(rtlpriv, REG_GPIO_IO_SEL);
 	e_rfpowerstate_toset = (u1tmp & BIT(3)) ? ERFON : ERFOFF;
 
-	if ((ppsc->b_hwradiooff == true) && (e_rfpowerstate_toset == ERFON)) {
+	if ((ppsc->hwradiooff == true) && (e_rfpowerstate_toset == ERFON)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("GPIOChangeRF  - HW Radio ON, RF ON\n"));
 
 		e_rfpowerstate_toset = ERFON;
-		ppsc->b_hwradiooff = false;
-		b_actuallyset = true;
-	} else if ((ppsc->b_hwradiooff == false)
+		ppsc->hwradiooff = false;
+		actuallyset = true;
+	} else if ((ppsc->hwradiooff == false)
 		   && (e_rfpowerstate_toset == ERFOFF)) {
 		RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 			 ("GPIOChangeRF  - HW Radio OFF, RF OFF\n"));
 
 		e_rfpowerstate_toset = ERFOFF;
-		ppsc->b_hwradiooff = true;
-		b_actuallyset = true;
+		ppsc->hwradiooff = true;
+		actuallyset = true;
 	}
 
-	if (b_actuallyset) {
+	if (actuallyset) {
 		if (e_rfpowerstate_toset == ERFON) {
 			if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
 			    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM)) {
@@ -2015,7 +2014,7 @@ bool rtl92ce_gpio_radio_on_off_checking(
 	}
 
 	*valid = 1;
-	return !ppsc->b_hwradiooff;
+	return !ppsc->hwradiooff;
 
 }
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -80,7 +80,7 @@
 #define RTL92C_MAX_PATH_NUM		2
 #define CHANNEL_MAX_NUMBER		14
 #define CHANNEL_GROUP_MAX		3
-
+#define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER	255
 enum swchnlcmd_id {
 	CMDID_END,
 	CMDID_SET_TXPOWEROWER_LEVEL,
@@ -233,5 +233,6 @@ void rtl92c_phy_config_bb_external_pa(st
 void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
 bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
 void rtl92c_phy_set_io(struct ieee80211_hw *hw);
+void rtl92c_bb_block_on(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
@@ -316,12 +316,12 @@ static void _rtl92c_fill_h2c_command(str
 
 	while (true) {
 		spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
-		if (rtlhal->b_h2c_setinprogress) {
+		if (rtlhal->h2c_setinprogress) {
 			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
 				 ("H2C set in progress! Wait to set.."
 				  "element_id(%d).\n", element_id));
 
-			while (rtlhal->b_h2c_setinprogress) {
+			while (rtlhal->h2c_setinprogress) {
 				spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock,
 						       flag);
 				h2c_waitcounter++;
@@ -337,7 +337,7 @@ static void _rtl92c_fill_h2c_command(str
 			}
 			spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
 		} else {
-			rtlhal->b_h2c_setinprogress = true;
+			rtlhal->h2c_setinprogress = true;
 			spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
 			break;
 		}
@@ -493,7 +493,7 @@ static void _rtl92c_fill_h2c_command(str
 	}
 
 	spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
-	rtlhal->b_h2c_setinprogress = false;
+	rtlhal->h2c_setinprogress = false;
 	spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
 
 	RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, ("go out\n"));
@@ -505,7 +505,7 @@ void rtl92c_fill_h2c_cmd(struct ieee8021
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u32 tmp_cmdbuf[2];
 
-	if (rtlhal->bfw_ready == false) {
+	if (rtlhal->fw_ready == false) {
 		RT_ASSERT(false, ("return H2C cmd because of Fw "
 				  "download fail!!!\n"));
 		return;
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -578,11 +578,11 @@ struct rtl_probe_rsp {
 struct rtl_led {
 	void *hw;
 	enum rtl_led_pin ledpin;
-	bool b_ledon;
+	bool ledon;
 };
 
 struct rtl_led_ctl {
-	bool bled_opendrain;
+	bool led_opendrain;
 	struct rtl_led sw_led0;
 	struct rtl_led sw_led1;
 };
@@ -727,10 +727,10 @@ struct rtl_phy {
 	u32 iqk_mac_backup[IQK_MAC_REG_NUM];
 	u32 iqk_bb_backup[10];
 
-	bool b_rfpi_enable;
+	bool rfpi_enable;
 
 	u8 pwrgroup_cnt;
-	u8 bcck_high_power;
+	u8 cck_high_power;
 	/* 3 groups of pwr diff by rates*/
 	u32 mcs_txpwrlevel_origoffset[4][16];
 	u8 default_initialgain[4];
@@ -740,7 +740,7 @@ struct rtl_phy {
 	u8 cur_ofdm24g_txpwridx;
 
 	u32 rfreg_chnlval[2];
-	bool b_apk_done;
+	bool apk_done;
 
 	/*fsync*/
 	u8 framesync;
@@ -867,9 +867,9 @@ struct rtl_hal {
 
 	/*firmware */
 	u8 *pfirmware;
-	bool b_h2c_setinprogress;
+	bool h2c_setinprogress;
 	u8 last_hmeboxnum;
-	bool bfw_ready;
+	bool fw_ready;
 	/*Reserve page start offset except beacon in TxQ. */
 	u8 fw_rsvdpage_startoffset;
 };
@@ -900,17 +900,17 @@ struct rtl_dm {
 	long entry_min_undecoratedsmoothed_pwdb;
 	long undecorated_smoothed_pwdb;	/*out dm */
 	long entry_max_undecoratedsmoothed_pwdb;
-	bool b_dm_initialgain_enable;
-	bool bdynamic_txpower_enable;
-	bool bcurrent_turbo_edca;
-	bool bis_any_nonbepkts;	/*out dm */
-	bool bis_cur_rdlstate;
-	bool btxpower_trackingInit;
-	bool b_disable_framebursting;
-	bool b_cck_inch14;
-	bool btxpower_tracking;
-	bool b_useramask;
-	bool brfpath_rxenable[4];
+	bool dm_initialgain_enable;
+	bool dynamic_txpower_enable;
+	bool current_turbo_edca;
+	bool is_any_nonbepkts;	/*out dm */
+	bool is_cur_rdlstate;
+	bool txpower_trackingInit;
+	bool disable_framebursting;
+	bool cck_inch14;
+	bool txpower_tracking;
+	bool useramask;
+	bool rfpath_rxenable[4];
 
 	u8 thermalvalue_iqk;
 	u8 thermalvalue_lck;
@@ -928,7 +928,7 @@ struct rtl_dm {
 #define	EFUSE_MAX_LOGICAL_SIZE			 128
 
 struct rtl_efuse {
-	bool bautoLoad_ok;
+	bool autoLoad_ok;
 	bool bootfromefuse;
 	u16 max_physical_size;
 	u8 contents[EFUSE_MAX_LOGICAL_SIZE];
@@ -950,7 +950,7 @@ struct rtl_efuse {
 
 	u8 dev_addr[6];
 
-	bool b_txpwr_fromeprom;
+	bool txpwr_fromeprom;
 	u8 eeprom_tssi[2];
 	u8 eeprom_pwrlimit_ht20[3];
 	u8 eeprom_pwrlimit_ht40[3];
@@ -974,15 +974,15 @@ struct rtl_efuse {
 	u8 thermalmeter[2];
 
 	u8 legacy_ht_txpowerdiff;	/*Legacy to HT rate power diff */
-	bool b_apk_thermalmeterignore;
+	bool apk_thermalmeterignore;
 };
 
 struct rtl_ps_ctl {
 	bool set_rfpowerstate_inprogress;
-	bool b_in_powersavemode;
+	bool in_powersavemode;
 	bool rfchange_inprogress;
-	bool b_swrf_processing;
-	bool b_hwradiooff;
+	bool swrf_processing;
+	bool hwradiooff;
 
 	u32 last_sleep_jiffies;
 	u32 last_awake_jiffies;
@@ -993,23 +993,23 @@ struct rtl_ps_ctl {
 	 * If it supports ASPM, Offset[560h] = 0x40,
 	 * otherwise Offset[560h] = 0x00.
 	 * */
-	bool b_support_aspm;
-	bool b_support_backdoor;
+	bool support_aspm;
+	bool support_backdoor;
 
 	/*for LPS */
 	enum rt_psmode dot11_psmode;	/*Power save mode configured. */
-	bool b_leisure_ps;
-	bool b_fwctrl_lps;
+	bool leisure_ps;
+	bool fwctrl_lps;
 	u8 fwctrl_psmode;
 	/*For Fw control LPS mode */
-	u8 b_reg_fwctrl_lps;
+	u8 reg_fwctrl_lps;
 	/*Record Fw PS mode status. */
-	bool b_fw_current_inpsmode;
+	bool fw_current_inpsmode;
 	u8 reg_max_lps_awakeintvl;
 	bool report_linked;
 
 	/*for IPS */
-	bool b_inactiveps;
+	bool inactiveps;
 
 	u32 rfoff_reason;
 
@@ -1047,10 +1047,10 @@ struct rtl_stats {
 	s32 recvsignalpower;
 	s8 rxpower;		/*in dBm Translate from PWdB */
 	u8 signalstrength;	/*in 0-100 index. */
-	u16 b_hwerror:1;
-	u16 b_crc:1;
-	u16 b_icv:1;
-	u16 b_shortpreamble:1;
+	u16 hwerror:1;
+	u16 crc:1;
+	u16 icv:1;
+	u16 shortpreamble:1;
 	u16 antenna:1;
 	u16 decrypted:1;
 	u16 wakeup:1;
@@ -1059,15 +1059,15 @@ struct rtl_stats {
 
 	u8 rx_drvinfo_size;
 	u8 rx_bufshift;
-	bool b_isampdu;
+	bool isampdu;
 	bool rx_is40Mhzpacket;
 	u32 rx_pwdb_all;
 	u8 rx_mimo_signalstrength[4];	/*in 0~100 index */
 	s8 rx_mimo_signalquality[2];
-	bool b_packet_matchbssid;
-	bool b_is_cck;
-	bool b_packet_toself;
-	bool b_packet_beacon;	/*for rssi */
+	bool packet_matchbssid;
+	bool is_cck;
+	bool packet_toself;
+	bool packet_beacon;	/*for rssi */
 	char cck_adc_pwdb[4];	/*for rx path selection */
 };
 
@@ -1078,23 +1078,23 @@ struct rt_link_detect {
 	u32 num_tx_inperiod;
 	u32 num_rx_inperiod;
 
-	bool b_busytraffic;
-	bool b_higher_busytraffic;
-	bool b_higher_busyrxtraffic;
+	bool busytraffic;
+	bool higher_busytraffic;
+	bool higher_busyrxtraffic;
 };
 
 struct rtl_tcb_desc {
-	u8 b_packet_bw:1;
-	u8 b_multicast:1;
-	u8 b_broadcast:1;
-
-	u8 b_rts_stbc:1;
-	u8 b_rts_enable:1;
-	u8 b_cts_enable:1;
-	u8 b_rts_use_shortpreamble:1;
-	u8 b_rts_use_shortgi:1;
+	u8 packet_bw:1;
+	u8 multicast:1;
+	u8 broadcast:1;
+
+	u8 rts_stbc:1;
+	u8 rts_enable:1;
+	u8 cts_enable:1;
+	u8 rts_use_shortpreamble:1;
+	u8 rts_use_shortgi:1;
 	u8 rts_sc:1;
-	u8 b_rts_bw:1;
+	u8 rts_bw:1;
 	u8 rts_rate;
 
 	u8 use_shortgi:1;
@@ -1137,23 +1137,23 @@ struct rtl_hal_ops {
 			      struct ieee80211_tx_info *info,
 			      struct sk_buff *skb, unsigned int queue_index);
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
-				 bool b_firstseg, bool b_lastseg,
+				 bool firstseg, bool lastseg,
 				 struct sk_buff *skb);
 	bool (*cmd_send_packet)(struct ieee80211_hw *hw, struct sk_buff *skb);
-	bool(*query_rx_desc) (struct ieee80211_hw *hw,
+	bool (*query_rx_desc) (struct ieee80211_hw *hw,
 			       struct rtl_stats *stats,
 			       struct ieee80211_rx_status *rx_status,
 			       u8 *pdesc, struct sk_buff *skb);
 	void (*set_channel_access) (struct ieee80211_hw *hw);
-	 bool(*radio_onoff_checking) (struct ieee80211_hw *hw, u8 *valid);
+	bool (*radio_onoff_checking) (struct ieee80211_hw *hw, u8 *valid);
 	void (*dm_watchdog) (struct ieee80211_hw *hw);
 	void (*scan_operation_backup) (struct ieee80211_hw *hw, u8 operation);
-	 bool(*set_rf_power_state) (struct ieee80211_hw *hw,
+	bool (*set_rf_power_state) (struct ieee80211_hw *hw,
 				    enum rf_pwrstate rfpwr_state);
 	void (*led_control) (struct ieee80211_hw *hw,
 			     enum led_ctl_mode ledaction);
 	void (*set_desc) (u8 *pdesc, bool istx, u8 desc_name, u8 *val);
-	 u32(*get_desc) (u8 *pdesc, bool istx, u8 desc_name);
+	u32 (*get_desc) (u8 *pdesc, bool istx, u8 desc_name);
 	void (*tx_polling) (struct ieee80211_hw *hw, unsigned int hw_queue);
 	void (*enable_hw_sec) (struct ieee80211_hw *hw);
 	void (*set_key) (struct ieee80211_hw *hw, u32 key_index,
@@ -1161,10 +1161,10 @@ struct rtl_hal_ops {
 			 bool is_wepkey, bool clear_all);
 	void (*init_sw_leds) (struct ieee80211_hw *hw);
 	void (*deinit_sw_leds) (struct ieee80211_hw *hw);
-	 u32(*get_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
+	u32 (*get_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask);
 	void (*set_bbreg) (struct ieee80211_hw *hw, u32 regaddr, u32 bitmask,
 			   u32 data);
-	 u32(*get_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
+	u32 (*get_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			  u32 regaddr, u32 bitmask);
 	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
Index: wireless-testing/drivers/net/wireless/rtlwifi/base.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/base.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/base.c
@@ -399,21 +399,21 @@ static void _rtl_query_protection_mode(s
 	u8 rate_flag = info->control.rates[0].flags;
 
 	/* Common Settings */
-	tcb_desc->b_rts_stbc = false;
-	tcb_desc->b_cts_enable = false;
+	tcb_desc->rts_stbc = false;
+	tcb_desc->cts_enable = false;
 	tcb_desc->rts_sc = 0;
-	tcb_desc->b_rts_bw = false;
-	tcb_desc->b_rts_use_shortpreamble = false;
-	tcb_desc->b_rts_use_shortgi = false;
+	tcb_desc->rts_bw = false;
+	tcb_desc->rts_use_shortpreamble = false;
+	tcb_desc->rts_use_shortgi = false;
 
 	if (rate_flag & IEEE80211_TX_RC_USE_CTS_PROTECT) {
 		/* Use CTS-to-SELF in protection mode. */
-		tcb_desc->b_rts_enable = true;
-		tcb_desc->b_cts_enable = true;
+		tcb_desc->rts_enable = true;
+		tcb_desc->cts_enable = true;
 		tcb_desc->rts_rate = rtlpriv->cfg->maps[RTL_RC_OFDM_RATE24M];
 	} else if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
 		/* Use RTS-CTS in protection mode. */
-		tcb_desc->b_rts_enable = true;
+		tcb_desc->rts_enable = true;
 		tcb_desc->rts_rate = rtlpriv->cfg->maps[RTL_RC_OFDM_RATE24M];
 	}
 
@@ -429,7 +429,7 @@ static void _rtl_txrate_selectmode(struc
 		if (mac->opmode == NL80211_IFTYPE_STATION)
 			tcb_desc->ratr_index = 0;
 		else if (mac->opmode == NL80211_IFTYPE_ADHOC) {
-			if (tcb_desc->b_multicast || tcb_desc->b_broadcast) {
+			if (tcb_desc->multicast || tcb_desc->broadcast) {
 				tcb_desc->hw_rate =
 				    rtlpriv->cfg->maps[RTL_RC_CCK_RATE2M];
 				tcb_desc->use_driver_rate = 1;
@@ -439,7 +439,7 @@ static void _rtl_txrate_selectmode(struc
 		}
 	}
 
-	if (rtlpriv->dm.b_useramask) {
+	if (rtlpriv->dm.useramask) {
 		/* TODO we will differentiate adhoc and station futrue  */
 		tcb_desc->mac_id = 0;
 
@@ -461,19 +461,19 @@ static void _rtl_query_bandwidth_mode(st
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	tcb_desc->b_packet_bw = false;
+	tcb_desc->packet_bw = false;
 
 	if (!mac->bw_40 || !mac->ht_enable)
 		return;
 
-	if (tcb_desc->b_multicast || tcb_desc->b_broadcast)
+	if (tcb_desc->multicast || tcb_desc->broadcast)
 		return;
 
 	/*use legency rate, shall use 20MHz */
 	if (tcb_desc->hw_rate <= rtlpriv->cfg->maps[RTL_RC_OFDM_RATE54M])
 		return;
 
-	tcb_desc->b_packet_bw = true;
+	tcb_desc->packet_bw = true;
 }
 
 static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw)
@@ -545,9 +545,9 @@ void rtl_get_tcb_desc(struct ieee80211_h
 		}
 
 		if (is_multicast_ether_addr(ieee80211_get_DA(hdr)))
-			tcb_desc->b_multicast = 1;
+			tcb_desc->multicast = 1;
 		else if (is_broadcast_ether_addr(ieee80211_get_DA(hdr)))
-			tcb_desc->b_broadcast = 1;
+			tcb_desc->broadcast = 1;
 
 		_rtl_txrate_selectmode(hw, tcb_desc);
 		_rtl_query_bandwidth_mode(hw, tcb_desc);
@@ -777,10 +777,10 @@ void rtl_watchdog_wq_callback(void *data
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 
-	bool b_busytraffic = false;
-	bool b_higher_busytraffic = false;
-	bool b_higher_busyrxtraffic = false;
-	bool b_higher_busytxtraffic = false;
+	bool busytraffic = false;
+	bool higher_busytraffic = false;
+	bool higher_busyrxtraffic = false;
+	bool higher_busytxtraffic = false;
 
 	u8 idx = 0;
 	u32 rx_cnt_inp4eriod = 0;
@@ -788,7 +788,7 @@ void rtl_watchdog_wq_callback(void *data
 	u32 aver_rx_cnt_inperiod = 0;
 	u32 aver_tx_cnt_inperiod = 0;
 
-	bool benter_ps = false;
+	bool enter_ps = false;
 
 	if (is_hal_stop(rtlhal))
 		return;
@@ -832,29 +832,29 @@ void rtl_watchdog_wq_callback(void *data
 
 		/* (2) check traffic busy */
 		if (aver_rx_cnt_inperiod > 100 || aver_tx_cnt_inperiod > 100)
-			b_busytraffic = true;
+			busytraffic = true;
 
 		/* Higher Tx/Rx data. */
 		if (aver_rx_cnt_inperiod > 4000 ||
 		    aver_tx_cnt_inperiod > 4000) {
-			b_higher_busytraffic = true;
+			higher_busytraffic = true;
 
 			/* Extremely high Rx data. */
 			if (aver_rx_cnt_inperiod > 5000)
-				b_higher_busyrxtraffic = true;
+				higher_busyrxtraffic = true;
 			else
-				b_higher_busytxtraffic = false;
+				higher_busytxtraffic = false;
 		}
 
 		if (((rtlpriv->link_info.num_rx_inperiod +
 		      rtlpriv->link_info.num_tx_inperiod) > 8) ||
 		    (rtlpriv->link_info.num_rx_inperiod > 2))
-			benter_ps = false;
+			enter_ps = false;
 		else
-			benter_ps = true;
+			enter_ps = true;
 
 		/* LeisurePS only work in infra mode. */
-		if (benter_ps)
+		if (enter_ps)
 			rtl_lps_enter(hw);
 		else
 			rtl_lps_leave(hw);
@@ -863,9 +863,9 @@ void rtl_watchdog_wq_callback(void *data
 	rtlpriv->link_info.num_rx_inperiod = 0;
 	rtlpriv->link_info.num_tx_inperiod = 0;
 
-	rtlpriv->link_info.b_busytraffic = b_busytraffic;
-	rtlpriv->link_info.b_higher_busytraffic = b_higher_busytraffic;
-	rtlpriv->link_info.b_higher_busyrxtraffic = b_higher_busyrxtraffic;
+	rtlpriv->link_info.busytraffic = busytraffic;
+	rtlpriv->link_info.higher_busytraffic = higher_busytraffic;
+	rtlpriv->link_info.higher_busyrxtraffic = higher_busyrxtraffic;
 
 }
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/core.c
@@ -666,7 +666,7 @@ static void rtl_op_bss_info_changed(stru
 			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_BASIC_RATE,
 					(u8 *) (&basic_rates));
 
-			if (rtlpriv->dm.b_useramask)
+			if (rtlpriv->dm.useramask)
 				rtlpriv->cfg->ops->update_rate_mask(hw, 0);
 			else
 				rtlpriv->cfg->ops->update_rate_table(hw);
@@ -681,7 +681,7 @@ static void rtl_op_bss_info_changed(stru
 	 */
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			if (ppsc->b_fwctrl_lps) {
+			if (ppsc->fwctrl_lps) {
 				u8 mstatus = RT_MEDIA_CONNECT;
 				rtlpriv->cfg->ops->set_hw_reg(hw,
 						      HW_VAR_H2C_FW_JOINBSSRPT,
@@ -689,7 +689,7 @@ static void rtl_op_bss_info_changed(stru
 				ppsc->report_linked = true;
 			}
 		} else {
-			if (ppsc->b_fwctrl_lps) {
+			if (ppsc->fwctrl_lps) {
 				u8 mstatus = RT_MEDIA_DISCONNECT;
 				rtlpriv->cfg->ops->set_hw_reg(hw,
 						      HW_VAR_H2C_FW_JOINBSSRPT,
@@ -818,7 +818,7 @@ static void rtl_op_sw_scan_complete(stru
 		/* fix fwlps issue */
 		rtlpriv->cfg->ops->set_network_type(hw, mac->opmode);
 
-		if (rtlpriv->dm.b_useramask)
+		if (rtlpriv->dm.useramask)
 			rtlpriv->cfg->ops->update_rate_mask(hw, 0);
 		else
 			rtlpriv->cfg->ops->update_rate_table(hw);
Index: wireless-testing/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/pci.c
@@ -50,7 +50,7 @@ static void _rtl_pci_update_default_sett
 	u8 pcibridge_vendor = pcipriv->ndis_adapter.pcibridge_vendor;
 
 	ppsc->reg_rfps_level = 0;
-	ppsc->b_support_aspm = 0;
+	ppsc->support_aspm = 0;
 
 	/*Update PCI ASPM setting */
 	ppsc->const_amdpci_aspm = rtlpci->const_amdpci_aspm;
@@ -115,29 +115,29 @@ static void _rtl_pci_update_default_sett
 	switch (rtlpci->const_support_pciaspm) {
 	case 0:{
 			/*Not support ASPM. */
-			bool b_support_aspm = false;
-			ppsc->b_support_aspm = b_support_aspm;
+			bool support_aspm = false;
+			ppsc->support_aspm = support_aspm;
 			break;
 		}
 	case 1:{
 			/*Support ASPM. */
-			bool b_support_aspm = true;
-			bool b_support_backdoor = true;
-			ppsc->b_support_aspm = b_support_aspm;
+			bool support_aspm = true;
+			bool support_backdoor = true;
+			ppsc->support_aspm = support_aspm;
 
 			/*if(priv->oem_id == RT_CID_TOSHIBA &&
 			   !priv->ndis_adapter.amd_l1_patch)
-			   b_support_backdoor = false; */
+			   support_backdoor = false; */
 
-			ppsc->b_support_backdoor = b_support_backdoor;
+			ppsc->support_backdoor = support_backdoor;
 
 			break;
 		}
 	case 2:
 		/*ASPM value set by chipset. */
 		if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL) {
-			bool b_support_aspm = true;
-			ppsc->b_support_aspm = b_support_aspm;
+			bool support_aspm = true;
+			ppsc->support_aspm = support_aspm;
 		}
 		break;
 	default:
@@ -585,7 +585,7 @@ static void _rtl_pci_rx_interrupt(struct
 			hdr = (struct ieee80211_hdr *)(skb->data);
 			fc = le16_to_cpu(hdr->frame_control);
 
-			if (!stats.b_crc) {
+			if (!stats.crc) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
 
@@ -890,17 +890,17 @@ static void _rtl_pci_init_struct(struct
 	rtlhal->hw = hw;
 	rtlpci->pdev = pdev;
 
-	ppsc->b_inactiveps = false;
-	ppsc->b_leisure_ps = true;
-	ppsc->b_fwctrl_lps = true;
-	ppsc->b_reg_fwctrl_lps = 3;
+	ppsc->inactiveps = false;
+	ppsc->leisure_ps = true;
+	ppsc->fwctrl_lps = true;
+	ppsc->reg_fwctrl_lps = 3;
 	ppsc->reg_max_lps_awakeintvl = 5;
 
-	if (ppsc->b_reg_fwctrl_lps == 1)
+	if (ppsc->reg_fwctrl_lps == 1)
 		ppsc->fwctrl_psmode = FW_PS_MIN_MODE;
-	else if (ppsc->b_reg_fwctrl_lps == 2)
+	else if (ppsc->reg_fwctrl_lps == 2)
 		ppsc->fwctrl_psmode = FW_PS_MAX_MODE;
-	else if (ppsc->b_reg_fwctrl_lps == 3)
+	else if (ppsc->reg_fwctrl_lps == 3)
 		ppsc->fwctrl_psmode = FW_PS_DTIM_MODE;
 
 	/*Tx/Rx related var */
Index: wireless-testing/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/ps.c
@@ -86,7 +86,7 @@ bool rtl_ps_set_rf_state(struct ieee8021
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	enum rf_pwrstate rtstate;
-	bool b_actionallowed = false;
+	bool actionallowed = false;
 	u16 rfwait_cnt = 0;
 	unsigned long flag;
 
@@ -139,13 +139,13 @@ no_protect:
 		ppsc->rfoff_reason &= (~changesource);
 
 		if ((changesource == RF_CHANGE_BY_HW) &&
-		    (ppsc->b_hwradiooff == true)) {
-			ppsc->b_hwradiooff = false;
+		    (ppsc->hwradiooff == true)) {
+			ppsc->hwradiooff = false;
 		}
 
 		if (!ppsc->rfoff_reason) {
 			ppsc->rfoff_reason = 0;
-			b_actionallowed = true;
+			actionallowed = true;
 		}
 
 		break;
@@ -153,17 +153,17 @@ no_protect:
 	case ERFOFF:
 
 		if ((changesource == RF_CHANGE_BY_HW)
-		    && (ppsc->b_hwradiooff == false)) {
-			ppsc->b_hwradiooff = true;
+		    && (ppsc->hwradiooff == false)) {
+			ppsc->hwradiooff = true;
 		}
 
 		ppsc->rfoff_reason |= changesource;
-		b_actionallowed = true;
+		actionallowed = true;
 		break;
 
 	case ERFSLEEP:
 		ppsc->rfoff_reason |= changesource;
-		b_actionallowed = true;
+		actionallowed = true;
 		break;
 
 	default:
@@ -172,7 +172,7 @@ no_protect:
 		break;
 	}
 
-	if (b_actionallowed)
+	if (actionallowed)
 		rtlpriv->cfg->ops->set_rf_power_state(hw, state_toset);
 
 	if (!protect_or_not) {
@@ -181,7 +181,7 @@ no_protect:
 		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
 	}
 
-	return b_actionallowed;
+	return actionallowed;
 }
 EXPORT_SYMBOL(rtl_ps_set_rf_state);
 
@@ -191,7 +191,7 @@ static void _rtl_ps_inactive_ps(struct i
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 
-	ppsc->b_swrf_processing = true;
+	ppsc->swrf_processing = true;
 
 	if (ppsc->inactive_pwrstate == ERFON && rtlhal->interface == INTF_PCI) {
 		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
@@ -213,7 +213,7 @@ static void _rtl_ps_inactive_ps(struct i
 		}
 	}
 
-	ppsc->b_swrf_processing = false;
+	ppsc->swrf_processing = false;
 }
 
 void rtl_ips_nic_off_wq_callback(void *data)
@@ -239,13 +239,13 @@ void rtl_ips_nic_off_wq_callback(void *d
 	if (rtlpriv->sec.being_setkey)
 		return;
 
-	if (ppsc->b_inactiveps) {
+	if (ppsc->inactiveps) {
 		rtstate = ppsc->rfpwr_state;
 
 		/*
 		 *Do not enter IPS in the following conditions:
 		 *(1) RF is already OFF or Sleep
-		 *(2) b_swrf_processing (indicates the IPS is still under going)
+		 *(2) swrf_processing (indicates the IPS is still under going)
 		 *(3) Connectted (only disconnected can trigger IPS)
 		 *(4) IBSS (send Beacon)
 		 *(5) AP mode (send Beacon)
@@ -253,14 +253,14 @@ void rtl_ips_nic_off_wq_callback(void *d
 		 */
 
 		if (rtstate == ERFON &&
-		    !ppsc->b_swrf_processing &&
+		    !ppsc->swrf_processing &&
 		    (mac->link_state == MAC80211_NOLINK) &&
 		    !mac->act_scanning) {
 			RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE,
 				 ("IPSEnter(): Turn off RF.\n"));
 
 			ppsc->inactive_pwrstate = ERFOFF;
-			ppsc->b_in_powersavemode = true;
+			ppsc->in_powersavemode = true;
 
 			/*rtl_pci_reset_trx_ring(hw); */
 			_rtl_ps_inactive_ps(hw);
@@ -290,15 +290,15 @@ void rtl_ips_nic_on(struct ieee80211_hw
 
 	spin_lock_irqsave(&rtlpriv->locks.ips_lock, flags);
 
-	if (ppsc->b_inactiveps) {
+	if (ppsc->inactiveps) {
 		rtstate = ppsc->rfpwr_state;
 
 		if (rtstate != ERFON &&
-		    !ppsc->b_swrf_processing &&
+		    !ppsc->swrf_processing &&
 		    ppsc->rfoff_reason <= RF_CHANGE_BY_IPS) {
 
 			ppsc->inactive_pwrstate = ERFON;
-			ppsc->b_in_powersavemode = false;
+			ppsc->in_powersavemode = false;
 
 			_rtl_ps_inactive_ps(hw);
 		}
@@ -370,9 +370,9 @@ static void rtl_lps_set_psmode(struct ie
 	 *   mode and set RPWM to turn RF on.
 	 */
 
-	if ((ppsc->b_fwctrl_lps) && (ppsc->b_leisure_ps) &&
+	if ((ppsc->fwctrl_lps) && (ppsc->leisure_ps) &&
 	     ppsc->report_linked) {
-		bool b_fw_current_inps;
+		bool fw_current_inps;
 		if (ppsc->dot11_psmode == EACTIVE) {
 			RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 				 ("FW LPS leave ps_mode:%x\n",
@@ -385,11 +385,11 @@ static void rtl_lps_set_psmode(struct ie
 			rtlpriv->cfg->ops->set_hw_reg(hw,
 					HW_VAR_H2C_FW_PWRMODE,
 					(u8 *) (&fw_pwrmode));
-			b_fw_current_inps = false;
+			fw_current_inps = false;
 
 			rtlpriv->cfg->ops->set_hw_reg(hw,
 					HW_VAR_FW_PSMODE_STATUS,
-					(u8 *) (&b_fw_current_inps));
+					(u8 *) (&fw_current_inps));
 
 		} else {
 			if (rtl_get_fwlps_doze(hw)) {
@@ -398,10 +398,10 @@ static void rtl_lps_set_psmode(struct ie
 						 ppsc->fwctrl_psmode));
 
 				rpwm_val = 0x02;	/* RF off */
-				b_fw_current_inps = true;
+				fw_current_inps = true;
 				rtlpriv->cfg->ops->set_hw_reg(hw,
 						HW_VAR_FW_PSMODE_STATUS,
-						(u8 *) (&b_fw_current_inps));
+						(u8 *) (&fw_current_inps));
 				rtlpriv->cfg->ops->set_hw_reg(hw,
 						HW_VAR_H2C_FW_PWRMODE,
 						(u8 *) (&ppsc->fwctrl_psmode));
@@ -425,13 +425,13 @@ void rtl_lps_enter(struct ieee80211_hw *
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned long flag;
 
-	if (!(ppsc->b_fwctrl_lps && ppsc->b_leisure_ps))
+	if (!(ppsc->fwctrl_lps && ppsc->leisure_ps))
 		return;
 
 	if (rtlpriv->sec.being_setkey)
 		return;
 
-	if (rtlpriv->link_info.b_busytraffic)
+	if (rtlpriv->link_info.busytraffic)
 		return;
 
 	/*sleep after linked 10s, to let DHCP and 4-way handshake ok enough!! */
@@ -446,7 +446,7 @@ void rtl_lps_enter(struct ieee80211_hw *
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->b_leisure_ps) {
+	if (ppsc->leisure_ps) {
 		/* Idle for a while if we connect to AP a while ago. */
 		if (mac->cnt_after_linked >= 2) {
 			if (ppsc->dot11_psmode == EACTIVE) {
@@ -470,7 +470,7 @@ void rtl_lps_leave(struct ieee80211_hw *
 
 	spin_lock_irqsave(&rtlpriv->locks.lps_lock, flag);
 
-	if (ppsc->b_fwctrl_lps && ppsc->b_leisure_ps) {
+	if (ppsc->fwctrl_lps && ppsc->leisure_ps) {
 		if (ppsc->dot11_psmode != EACTIVE) {
 
 			/*FIX ME */
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -306,13 +306,13 @@ static void rtl92c_dm_initial_gain_multi
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	long rssi_strength = rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
-	bool b_multi_sta = false;
+	bool multi_sta = false;
 
 	if (mac->opmode == NL80211_IFTYPE_ADHOC)
-		b_multi_sta = true;
+		multi_sta = true;
 
-	if ((b_multi_sta == false) || (dm_digtable.cursta_connectctate !=
-				       DIG_STA_DISCONNECT)) {
+	if ((multi_sta == false) || (dm_digtable.cursta_connectctate !=
+				     DIG_STA_DISCONNECT)) {
 		binitialized = false;
 		dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		return;
@@ -479,7 +479,7 @@ static void rtl92c_dm_dig(struct ieee802
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	if (rtlpriv->dm.b_dm_initialgain_enable == false)
+	if (rtlpriv->dm.dm_initialgain_enable == false)
 		return;
 	if (dm_digtable.dig_enable_flag == false)
 		return;
@@ -492,7 +492,7 @@ static void rtl92c_dm_init_dynamic_txpow
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	rtlpriv->dm.bdynamic_txpower_enable = false;
+	rtlpriv->dm.dynamic_txpower_enable = false;
 
 	rtlpriv->dm.last_dtp_lvl = TXHIGHPWRLEVEL_NORMAL;
 	rtlpriv->dm.dynamic_txhighpower_lvl = TXHIGHPWRLEVEL_NORMAL;
@@ -550,9 +550,9 @@ static void rtl92c_dm_pwdb_monitor(struc
 void rtl92c_dm_init_edca_turbo(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	rtlpriv->dm.bcurrent_turbo_edca = false;
-	rtlpriv->dm.bis_any_nonbepkts = false;
-	rtlpriv->dm.bis_cur_rdlstate = false;
+	rtlpriv->dm.current_turbo_edca = false;
+	rtlpriv->dm.is_any_nonbepkts = false;
+	rtlpriv->dm.is_cur_rdlstate = false;
 }
 
 static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
@@ -570,7 +570,7 @@ static void rtl92c_dm_check_edca_turbo(s
 		goto dm_checkedcaturbo_exit;
 
 	if (mac->link_state != MAC80211_LINKED) {
-		rtlpriv->dm.bcurrent_turbo_edca = false;
+		rtlpriv->dm.current_turbo_edca = false;
 		return;
 	}
 
@@ -582,40 +582,40 @@ static void rtl92c_dm_check_edca_turbo(s
 			edca_be_dl |= 0x005e0000;
 	}
 
-	if ((!rtlpriv->dm.bis_any_nonbepkts) &&
-	    (!rtlpriv->dm.b_disable_framebursting)) {
+	if ((!rtlpriv->dm.is_any_nonbepkts) &&
+	    (!rtlpriv->dm.disable_framebursting)) {
 		cur_txok_cnt = rtlpriv->stats.txbytesunicast - last_txok_cnt;
 		cur_rxok_cnt = rtlpriv->stats.rxbytesunicast - last_rxok_cnt;
 		if (cur_rxok_cnt > 4 * cur_txok_cnt) {
-			if (!rtlpriv->dm.bis_cur_rdlstate ||
-			    !rtlpriv->dm.bcurrent_turbo_edca) {
+			if (!rtlpriv->dm.is_cur_rdlstate ||
+			    !rtlpriv->dm.current_turbo_edca) {
 				rtl_write_dword(rtlpriv,
 						REG_EDCA_BE_PARAM,
 						edca_be_dl);
-				rtlpriv->dm.bis_cur_rdlstate = true;
+				rtlpriv->dm.is_cur_rdlstate = true;
 			}
 		} else {
-			if (rtlpriv->dm.bis_cur_rdlstate ||
-			    !rtlpriv->dm.bcurrent_turbo_edca) {
+			if (rtlpriv->dm.is_cur_rdlstate ||
+			    !rtlpriv->dm.current_turbo_edca) {
 				rtl_write_dword(rtlpriv,
 						REG_EDCA_BE_PARAM,
 						edca_be_ul);
-				rtlpriv->dm.bis_cur_rdlstate = false;
+				rtlpriv->dm.is_cur_rdlstate = false;
 			}
 		}
-		rtlpriv->dm.bcurrent_turbo_edca = true;
+		rtlpriv->dm.current_turbo_edca = true;
 	} else {
-		if (rtlpriv->dm.bcurrent_turbo_edca) {
+		if (rtlpriv->dm.current_turbo_edca) {
 			u8 tmp = AC0_BE;
 			rtlpriv->cfg->ops->set_hw_reg(hw,
 						      HW_VAR_AC_PARAM,
 						      (u8 *) (&tmp));
-			rtlpriv->dm.bcurrent_turbo_edca = false;
+			rtlpriv->dm.current_turbo_edca = false;
 		}
 	}
 
 dm_checkedcaturbo_exit:
-	rtlpriv->dm.bis_any_nonbepkts = false;
+	rtlpriv->dm.is_any_nonbepkts = false;
 	last_txok_cnt = rtlpriv->stats.txbytesunicast;
 	last_rxok_cnt = rtlpriv->stats.rxbytesunicast;
 }
@@ -636,7 +636,7 @@ static void rtl92c_dm_txpower_tracking_c
 	u8 txpwr_level[2] = {0, 0};
 	u8 ofdm_min_index = 6, rf;
 
-	rtlpriv->dm.btxpower_trackingInit = true;
+	rtlpriv->dm.txpower_trackingInit = true;
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 		 ("rtl92c_dm_txpower_tracking_callback_thermalmeter\n"));
 
@@ -696,7 +696,7 @@ static void rtl92c_dm_txpower_tracking_c
 		    rtl_get_bbreg(hw, RCCK0_TXFILTER2, MASKDWORD) & MASKCCK;
 
 		for (i = 0; i < CCK_TABLE_LENGTH; i++) {
-			if (rtlpriv->dm.b_cck_inch14) {
+			if (rtlpriv->dm.cck_inch14) {
 				if (memcmp((void *)&temp_cck,
 					   (void *)&cckswing_table_ch14[i][2],
 					   4) == 0) {
@@ -708,7 +708,7 @@ static void rtl92c_dm_txpower_tracking_c
 						  "cck_index=0x%x, ch 14 %d\n",
 						  RCCK0_TXFILTER2, temp_cck,
 						  cck_index_old,
-						  rtlpriv->dm.b_cck_inch14));
+						  rtlpriv->dm.cck_inch14));
 					break;
 				}
 			} else {
@@ -724,7 +724,7 @@ static void rtl92c_dm_txpower_tracking_c
 						  "cck_index=0x%x, ch14 %d\n",
 						  RCCK0_TXFILTER2, temp_cck,
 						  cck_index_old,
-						  rtlpriv->dm.b_cck_inch14));
+						  rtlpriv->dm.cck_inch14));
 					break;
 				}
 			}
@@ -937,7 +937,7 @@ static void rtl92c_dm_txpower_tracking_c
 					      BIT(31) | BIT(29), 0x00);
 			}
 
-			if (!rtlpriv->dm.b_cck_inch14) {
+			if (!rtlpriv->dm.cck_inch14) {
 				rtl_write_byte(rtlpriv, 0xa22,
 					       cckswing_table_ch1ch13[cck_index]
 					       [0]);
@@ -1057,12 +1057,12 @@ static void rtl92c_dm_initialize_txpower
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-	rtlpriv->dm.btxpower_tracking = true;
-	rtlpriv->dm.btxpower_trackingInit = false;
+	rtlpriv->dm.txpower_tracking = true;
+	rtlpriv->dm.txpower_trackingInit = false;
 
 	RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-		 ("pMgntInfo->btxpower_tracking = %d\n",
-		  rtlpriv->dm.btxpower_tracking));
+		 ("pMgntInfo->txpower_tracking = %d\n",
+		  rtlpriv->dm.txpower_tracking));
 }
 
 static void rtl92c_dm_initialize_txpower_tracking(struct ieee80211_hw *hw)
@@ -1081,7 +1081,7 @@ static void rtl92c_dm_check_txpower_trac
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	static u8 tm_trigger;
 
-	if (!rtlpriv->dm.btxpower_tracking)
+	if (!rtlpriv->dm.txpower_tracking)
 		return;
 
 	if (!tm_trigger) {
@@ -1113,9 +1113,9 @@ void rtl92c_dm_init_rate_adaptive_mask(s
 	p_ra->pre_ratr_state = DM_RATR_STA_INIT;
 
 	if (rtlpriv->dm.dm_type == DM_TYPE_BYDRIVER)
-		rtlpriv->dm.b_useramask = true;
+		rtlpriv->dm.useramask = true;
 	else
-		rtlpriv->dm.b_useramask = false;
+		rtlpriv->dm.useramask = false;
 
 }
 
@@ -1133,7 +1133,7 @@ static void rtl92c_dm_refresh_rate_adapt
 		return;
 	}
 
-	if (!rtlpriv->dm.b_useramask) {
+	if (!rtlpriv->dm.useramask) {
 		RT_TRACE(rtlpriv, COMP_RATE, DBG_LOUD,
 			("<---- driver does not control rate adaptive mask\n"));
 		return;
@@ -1365,16 +1365,16 @@ void rtl92c_dm_watchdog(struct ieee80211
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	bool b_fw_current_inpsmode = false;
-	bool b_fw_ps_awake = true;
+	bool fw_current_inpsmode = false;
+	bool fw_ps_awake = true;
 
 	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_FW_PSMODE_STATUS,
-				      (u8 *) (&b_fw_current_inpsmode));
+				      (u8 *) (&fw_current_inpsmode));
 	rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_FWLPS_RF_ON,
-				      (u8 *) (&b_fw_ps_awake));
+				      (u8 *) (&fw_ps_awake));
 
-	if ((ppsc->rfpwr_state == ERFON) && ((!b_fw_current_inpsmode) &&
-					     b_fw_ps_awake)
+	if ((ppsc->rfpwr_state == ERFON) && ((!fw_current_inpsmode) &&
+					     fw_ps_awake)
 	    && (!ppsc->rfchange_inprogress)) {
 		rtl92c_dm_pwdb_monitor(hw);
 		rtl92c_dm_dig(hw);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
@@ -44,7 +44,7 @@ void rtl92c_dm_dynamic_txpower(struct ie
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	long undecorated_smoothed_pwdb;
 
-	if (!rtlpriv->dm.bdynamic_txpower_enable)
+	if (!rtlpriv->dm.dynamic_txpower_enable)
 		return;
 
 	if (rtlpriv->dm.dm_flag & HAL_DM_HIPWR_DISABLE) {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -57,7 +57,7 @@ void rtl92ce_sw_led_on(struct ieee80211_
 			 ("switch case not process\n"));
 		break;
 	}
-	pled->b_ledon = true;
+	pled->ledon = true;
 }
 
 void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled)
@@ -76,7 +76,7 @@ void rtl92ce_sw_led_off(struct ieee80211
 		break;
 	case LED_PIN_LED0:
 		ledcfg &= 0xf0;
-		if (pcipriv->ledctl.bled_opendrain == true)
+		if (pcipriv->ledctl.led_opendrain == true)
 			rtl_write_byte(rtlpriv, REG_LEDCFG2,
 				       (ledcfg | BIT(1) | BIT(5) | BIT(6)));
 		else
@@ -92,7 +92,7 @@ void rtl92ce_sw_led_off(struct ieee80211
 			 ("switch case not process\n"));
 		break;
 	}
-	pled->b_ledon = false;
+	pled->ledon = false;
 }
 
 void rtl92ce_init_sw_leds(struct ieee80211_hw *hw)
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -330,7 +330,7 @@ bool rtl92c_phy_bb_config(struct ieee802
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u16 regval;
 	u32 regvaldw;
-	u8 b_reg_hwparafile = 1;
+	u8 reg_hwparafile = 1;
 
 	_rtl92c_phy_init_bb_rf_register_definition(hw);
 	regval = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
@@ -345,7 +345,7 @@ bool rtl92c_phy_bb_config(struct ieee802
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL + 1, 0x80);
 	regvaldw = rtl_read_dword(rtlpriv, REG_LEDCFG0);
 	rtl_write_dword(rtlpriv, REG_LEDCFG0, regvaldw | BIT(23));
-	if (b_reg_hwparafile == 1)
+	if (reg_hwparafile == 1)
 		rtstatus = _rtl92c_phy_bb8192c_config_parafile(hw);
 	return rtstatus;
 }
@@ -388,7 +388,7 @@ static bool _rtl92c_phy_bb8192c_config_p
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("AGC Table Fail\n"));
 		return false;
 	}
-	rtlphy->bcck_high_power = (bool) (rtl_get_bbreg(hw,
+	rtlphy->cck_high_power = (bool) (rtl_get_bbreg(hw,
 						RFPGA0_XA_HSSIPARAMETER2,
 						0x200));
 	return true;
@@ -954,7 +954,7 @@ void rtl92c_phy_set_txpower_level(struct
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 cckpowerlevel[2], ofdmpowerlevel[2];
 
-	if (rtlefuse->b_txpwr_fromeprom == false)
+	if (rtlefuse->txpwr_fromeprom == false)
 		return;
 	_rtl92c_get_txpower_index(hw, channel,
 				  &cckpowerlevel[0], &ofdmpowerlevel[0]);
@@ -1437,7 +1437,7 @@ static u8 _rtl92c_phy_path_b_iqk(struct
 }
 
 static void _rtl92c_phy_path_a_fill_iqk_matrix(struct ieee80211_hw *hw,
-					       bool b_iqk_ok, long result[][8],
+					       bool iqk_ok, long result[][8],
 					       u8 final_candidate, bool btxonly)
 {
 	u32 oldval_0, x, tx0_a, reg;
@@ -1445,7 +1445,7 @@ static void _rtl92c_phy_path_a_fill_iqk_
 
 	if (final_candidate == 0xFF)
 		return;
-	else if (b_iqk_ok) {
+	else if (iqk_ok) {
 		oldval_0 = (rtl_get_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 					  MASKDWORD) >> 22) & 0x3FF;
 		x = result[final_candidate][0];
@@ -1477,7 +1477,7 @@ static void _rtl92c_phy_path_a_fill_iqk_
 }
 
 static void _rtl92c_phy_path_b_fill_iqk_matrix(struct ieee80211_hw *hw,
-					       bool b_iqk_ok, long result[][8],
+					       bool iqk_ok, long result[][8],
 					       u8 final_candidate, bool btxonly)
 {
 	u32 oldval_1, x, tx1_a, reg;
@@ -1485,7 +1485,7 @@ static void _rtl92c_phy_path_b_fill_iqk_
 
 	if (final_candidate == 0xFF)
 		return;
-	else if (b_iqk_ok) {
+	else if (iqk_ok) {
 		oldval_1 = (rtl_get_bbreg(hw, ROFDM0_XBTXIQIMBALANCE,
 					  MASKDWORD) >> 22) & 0x3FF;
 		x = result[final_candidate][4];
@@ -1698,11 +1698,11 @@ static void _rtl92c_phy_iq_calibrate(str
 	}
 	_rtl92c_phy_path_adda_on(hw, adda_reg, true, is2t);
 	if (t == 0) {
-		rtlphy->b_rfpi_enable = (u8) rtl_get_bbreg(hw,
+		rtlphy->rfpi_enable = (u8) rtl_get_bbreg(hw,
 						   RFPGA0_XA_HSSIPARAMETER1,
 						   BIT(8));
 	}
-	if (!rtlphy->b_rfpi_enable)
+	if (!rtlphy->rfpi_enable)
 		_rtl92c_phy_pi_mode_switch(hw, true);
 	if (t == 0) {
 		rtlphy->reg_c04 = rtl_get_bbreg(hw, 0xc04, MASKDWORD);
@@ -1783,7 +1783,7 @@ static void _rtl92c_phy_iq_calibrate(str
 	if (is2t)
 		rtl_set_bbreg(hw, 0x844, MASKDWORD, 0x00032ed3);
 	if (t != 0) {
-		if (!rtlphy->b_rfpi_enable)
+		if (!rtlphy->rfpi_enable)
 			_rtl92c_phy_pi_mode_switch(hw, false);
 		_rtl92c_phy_reload_adda_registers(hw, adda_reg,
 						  rtlphy->adda_backup, 16);
@@ -2370,7 +2370,7 @@ void rtl92c_phy_ap_calibrate(struct ieee
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
-	if (rtlphy->b_apk_done)
+	if (rtlphy->apk_done)
 		return;
 	if (IS_92C_SERIAL(rtlhal->version))
 		_rtl92c_phy_ap_calibrate(hw, delta, true);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -46,9 +46,9 @@ int rtl92c_init_sw_vars(struct ieee80211
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
-	rtlpriv->dm.b_dm_initialgain_enable = 1;
+	rtlpriv->dm.dm_initialgain_enable = 1;
 	rtlpriv->dm.dm_flag = 0;
-	rtlpriv->dm.b_disable_framebursting = 0;;
+	rtlpriv->dm.disable_framebursting = 0;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpci->transmit_config = CFENDFORM | BIT(12) | BIT(13);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -245,9 +245,9 @@ static void _rtl92ce_query_rxphystatus(s
 				       struct rtl_stats *pstats,
 				       struct rx_desc_92c *pdesc,
 				       struct rx_fwinfo_92c *p_drvinfo,
-				       bool bpacket_match_bssid,
-				       bool bpacket_toself,
-				       bool b_packet_beacon)
+				       bool packet_match_bssid,
+				       bool packet_toself,
+				       bool packet_beacon)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct phy_sts_cck_8192s_t *cck_buf;
@@ -258,11 +258,11 @@ static void _rtl92ce_query_rxphystatus(s
 	bool is_cck_rate;
 
 	is_cck_rate = RX_HAL_IS_CCK_RATE(pdesc);
-	pstats->b_packet_matchbssid = bpacket_match_bssid;
-	pstats->b_packet_toself = bpacket_toself;
-	pstats->b_is_cck = is_cck_rate;
-	pstats->b_packet_beacon = b_packet_beacon;
-	pstats->b_is_cck = is_cck_rate;
+	pstats->packet_matchbssid = packet_match_bssid;
+	pstats->packet_toself = packet_toself;
+	pstats->is_cck = is_cck_rate;
+	pstats->packet_beacon = packet_beacon;
+	pstats->is_cck = is_cck_rate;
 	pstats->rx_mimo_signalquality[0] = -1;
 	pstats->rx_mimo_signalquality[1] = -1;
 
@@ -315,7 +315,7 @@ static void _rtl92ce_query_rxphystatus(s
 		pstats->rx_pwdb_all = pwdb_all;
 		pstats->recvsignalpower = rx_pwr_all;
 
-		if (bpacket_match_bssid) {
+		if (packet_match_bssid) {
 			u8 sq;
 			if (pstats->rx_pwdb_all > 40)
 				sq = 100;
@@ -334,10 +334,10 @@ static void _rtl92ce_query_rxphystatus(s
 			pstats->rx_mimo_signalquality[1] = -1;
 		}
 	} else {
-		rtlpriv->dm.brfpath_rxenable[0] =
-		    rtlpriv->dm.brfpath_rxenable[1] = true;
+		rtlpriv->dm.rfpath_rxenable[0] =
+		    rtlpriv->dm.rfpath_rxenable[1] = true;
 		for (i = RF90_PATH_A; i < RF90_PATH_MAX; i++) {
-			if (rtlpriv->dm.brfpath_rxenable[i])
+			if (rtlpriv->dm.rfpath_rxenable[i])
 				rf_rx_num++;
 
 			rx_pwr[i] =
@@ -347,7 +347,7 @@ static void _rtl92ce_query_rxphystatus(s
 			rtlpriv->stats.rx_snr_db[i] =
 			    (long)(p_drvinfo->rxsnr[i] / 2);
 
-			if (bpacket_match_bssid)
+			if (packet_match_bssid)
 				pstats->rx_mimo_signalstrength[i] = (u8) rssi;
 		}
 
@@ -366,7 +366,7 @@ static void _rtl92ce_query_rxphystatus(s
 		for (i = 0; i < max_spatial_stream; i++) {
 			evm = _rtl92c_evm_db_to_percentage(p_drvinfo->rxevm[i]);
 
-			if (bpacket_match_bssid) {
+			if (packet_match_bssid) {
 				if (i == 0)
 					pstats->signalquality =
 					    (u8) (evm & 0xff);
@@ -393,7 +393,7 @@ static void _rtl92ce_process_ui_rssi(str
 	u8 rfpath;
 	u32 last_rssi, tmpval;
 
-	if (pstats->b_packet_toself || pstats->b_packet_beacon) {
+	if (pstats->packet_toself || pstats->packet_beacon) {
 		rtlpriv->stats.rssi_calculate_cnt++;
 
 		if (rtlpriv->stats.ui_rssi.total_num++ >=
@@ -421,7 +421,7 @@ static void _rtl92ce_process_ui_rssi(str
 		pstats->rssi = rtlpriv->stats.signal_strength;
 	}
 
-	if (!pstats->b_is_cck && pstats->b_packet_toself) {
+	if (!pstats->is_cck && pstats->packet_toself) {
 		for (rfpath = RF90_PATH_A; rfpath < rtlphy->num_total_rfpath;
 		     rfpath++) {
 
@@ -493,7 +493,7 @@ static void _rtl92ce_process_pwdb(struct
 		    rtlpriv->dm.undecorated_smoothed_pwdb;
 	}
 
-	if (pstats->b_packet_toself || pstats->b_packet_beacon) {
+	if (pstats->packet_toself || pstats->packet_beacon) {
 		if (undecorated_smoothed_pwdb < 0)
 			undecorated_smoothed_pwdb = pstats->rx_pwdb_all;
 
@@ -525,7 +525,7 @@ static void _rtl92ce_process_ui_link_qua
 	u32 last_evm, n_spatialstream, tmpval;
 
 	if (pstats->signalquality != 0) {
-		if (pstats->b_packet_toself || pstats->b_packet_beacon) {
+		if (pstats->packet_toself || pstats->packet_beacon) {
 
 			if (rtlpriv->stats.ui_link_quality.total_num++ >=
 			    PHY_LINKQUALITY_SLID_WIN_MAX) {
@@ -595,8 +595,8 @@ static void _rtl92ce_process_phyinfo(str
 				     struct rtl_stats *pcurrent_stats)
 {
 
-	if (!pcurrent_stats->b_packet_matchbssid &&
-	    !pcurrent_stats->b_packet_beacon)
+	if (!pcurrent_stats->packet_matchbssid &&
+	    !pcurrent_stats->packet_beacon)
 		return;
 
 	_rtl92ce_process_ui_rssi(hw, pcurrent_stats);
@@ -618,7 +618,7 @@ static void _rtl92ce_translate_rx_signal
 	u8 *praddr;
 	u8 *psaddr;
 	u16 fc, type;
-	bool b_packet_matchbssid, b_packet_toself, b_packet_beacon;
+	bool packet_matchbssid, packet_toself, packet_beacon;
 
 	tmp_buf = skb->data + pstats->rx_drvinfo_size + pstats->rx_bufshift;
 
@@ -628,23 +628,23 @@ static void _rtl92ce_translate_rx_signal
 	praddr = hdr->addr1;
 	psaddr = hdr->addr2;
 
-	b_packet_matchbssid =
+	packet_matchbssid =
 	    ((IEEE80211_FTYPE_CTL != type) &&
 	     (!compare_ether_addr(mac->bssid,
 				  (fc & IEEE80211_FCTL_TODS) ?
 				  hdr->addr1 : (fc & IEEE80211_FCTL_FROMDS) ?
 				  hdr->addr2 : hdr->addr3)) &&
-	     (!pstats->b_hwerror) && (!pstats->b_crc) && (!pstats->b_icv));
+	     (!pstats->hwerror) && (!pstats->crc) && (!pstats->icv));
 
-	b_packet_toself = b_packet_matchbssid &&
+	packet_toself = packet_matchbssid &&
 	    (!compare_ether_addr(praddr, rtlefuse->dev_addr));
 
 	if (ieee80211_is_beacon(fc))
-		b_packet_beacon = true;
+		packet_beacon = true;
 
 	_rtl92ce_query_rxphystatus(hw, pstats, pdesc, p_drvinfo,
-				   b_packet_matchbssid, b_packet_toself,
-				   b_packet_beacon);
+				   packet_matchbssid, packet_toself,
+				   packet_beacon);
 
 	_rtl92ce_process_phyinfo(hw, tmp_buf, pstats);
 }
@@ -662,14 +662,14 @@ bool rtl92ce_rx_query_desc(struct ieee80
 	stats->rx_drvinfo_size = (u8) GET_RX_DESC_DRV_INFO_SIZE(pdesc) *
 	    RX_DRV_INFO_SIZE_UNIT;
 	stats->rx_bufshift = (u8) (GET_RX_DESC_SHIFT(pdesc) & 0x03);
-	stats->b_icv = (u16) GET_RX_DESC_ICV(pdesc);
-	stats->b_crc = (u16) GET_RX_DESC_CRC32(pdesc);
-	stats->b_hwerror = (stats->b_crc | stats->b_icv);
+	stats->icv = (u16) GET_RX_DESC_ICV(pdesc);
+	stats->crc = (u16) GET_RX_DESC_CRC32(pdesc);
+	stats->hwerror = (stats->crc | stats->icv);
 	stats->decrypted = !GET_RX_DESC_SWDEC(pdesc);
 	stats->rate = (u8) GET_RX_DESC_RXMCS(pdesc);
-	stats->b_shortpreamble = (u16) GET_RX_DESC_SPLCP(pdesc);
-	stats->b_isampdu = (bool) (GET_RX_DESC_PAGGR(pdesc) == 1);
-	stats->b_isampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
+	stats->shortpreamble = (u16) GET_RX_DESC_SPLCP(pdesc);
+	stats->isampdu = (bool) (GET_RX_DESC_PAGGR(pdesc) == 1);
+	stats->isampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
 				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
@@ -727,7 +727,7 @@ void rtl92ce_tx_fill_desc(struct ieee802
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-	bool b_defaultadapter = true;
+	bool defaultadapter = true;
 
 	struct ieee80211_sta *sta = ieee80211_find_sta(mac->vif, mac->bssid);
 
@@ -743,11 +743,11 @@ void rtl92ce_tx_fill_desc(struct ieee802
 	    _rtl92ce_map_hwqueue_to_fwqueue(le16_to_cpu(hdr->frame_control),
 					    queue_index);
 
-	bool b_firstseg = ((hdr->seq_ctrl &
-			    cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0);
+	bool firstseg = ((hdr->seq_ctrl &
+			  cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0);
 
-	bool b_lastseg = ((hdr->frame_control &
-			   cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) == 0);
+	bool lastseg = ((hdr->frame_control &
+			 cpu_to_le16(IEEE80211_FCTL_MOREFRAGS)) == 0);
 
 	dma_addr_t mapping = pci_map_single(rtlpci->pdev,
 					    skb->data, skb->len,
@@ -759,7 +759,7 @@ void rtl92ce_tx_fill_desc(struct ieee802
 
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, sizeof(struct tx_desc_92c));
 
-	if (b_firstseg) {
+	if (firstseg) {
 		SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 
 		SET_TX_DESC_TX_RATE(pdesc, tcb_desc.hw_rate);
@@ -774,25 +774,25 @@ void rtl92ce_tx_fill_desc(struct ieee802
 		}
 		SET_TX_DESC_SEQ(pdesc, seq_number);
 
-		SET_TX_DESC_RTS_ENABLE(pdesc, ((tcb_desc.b_rts_enable &&
+		SET_TX_DESC_RTS_ENABLE(pdesc, ((tcb_desc.rts_enable &&
 						!tcb_desc.
-						b_cts_enable) ? 1 : 0));
+						cts_enable) ? 1 : 0));
 		SET_TX_DESC_HW_RTS_ENABLE(pdesc,
-					  ((tcb_desc.b_rts_enable
-					    || tcb_desc.b_cts_enable) ? 1 : 0));
-		SET_TX_DESC_CTS2SELF(pdesc, ((tcb_desc.b_cts_enable) ? 1 : 0));
-		SET_TX_DESC_RTS_STBC(pdesc, ((tcb_desc.b_rts_stbc) ? 1 : 0));
+					  ((tcb_desc.rts_enable
+					    || tcb_desc.cts_enable) ? 1 : 0));
+		SET_TX_DESC_CTS2SELF(pdesc, ((tcb_desc.cts_enable) ? 1 : 0));
+		SET_TX_DESC_RTS_STBC(pdesc, ((tcb_desc.rts_stbc) ? 1 : 0));
 
 		SET_TX_DESC_RTS_RATE(pdesc, tcb_desc.rts_rate);
 		SET_TX_DESC_RTS_BW(pdesc, 0);
 		SET_TX_DESC_RTS_SC(pdesc, tcb_desc.rts_sc);
 		SET_TX_DESC_RTS_SHORT(pdesc,
 				      ((tcb_desc.rts_rate <= DESC92C_RATE54M) ?
-				      (tcb_desc.b_rts_use_shortpreamble ? 1 : 0)
-				      : (tcb_desc.b_rts_use_shortgi ? 1 : 0)));
+				      (tcb_desc.rts_use_shortpreamble ? 1 : 0)
+				      : (tcb_desc.rts_use_shortgi ? 1 : 0)));
 
 		if (mac->bw_40) {
-			if (tcb_desc.b_packet_bw) {
+			if (tcb_desc.packet_bw) {
 				SET_TX_DESC_DATA_BW(pdesc, 1);
 				SET_TX_DESC_TX_SUB_CARRIER(pdesc, 3);
 			} else {
@@ -854,14 +854,14 @@ void rtl92ce_tx_fill_desc(struct ieee802
 		}
 	}
 
-	SET_TX_DESC_FIRST_SEG(pdesc, (b_firstseg ? 1 : 0));
-	SET_TX_DESC_LAST_SEG(pdesc, (b_lastseg ? 1 : 0));
+	SET_TX_DESC_FIRST_SEG(pdesc, (firstseg ? 1 : 0));
+	SET_TX_DESC_LAST_SEG(pdesc, (lastseg ? 1 : 0));
 
 	SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16) skb->len);
 
 	SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
 
-	if (rtlpriv->dm.b_useramask) {
+	if (rtlpriv->dm.useramask) {
 		SET_TX_DESC_RATE_ID(pdesc, tcb_desc.ratr_index);
 		SET_TX_DESC_MACID(pdesc, tcb_desc.mac_id);
 	} else {
@@ -869,16 +869,16 @@ void rtl92ce_tx_fill_desc(struct ieee802
 		SET_TX_DESC_MACID(pdesc, tcb_desc.ratr_index);
 	}
 
-	if ((!ieee80211_is_data_qos(fc)) && ppsc->b_leisure_ps &&
-	    ppsc->b_fwctrl_lps) {
+	if ((!ieee80211_is_data_qos(fc)) && ppsc->leisure_ps &&
+	    ppsc->fwctrl_lps) {
 		SET_TX_DESC_HWSEQ_EN(pdesc, 1);
 		SET_TX_DESC_PKT_ID(pdesc, 8);
 
-		if (!b_defaultadapter)
+		if (!defaultadapter)
 			SET_TX_DESC_QOS(pdesc, 1);
 	}
 
-	SET_TX_DESC_MORE_FRAG(pdesc, (b_lastseg ? 0 : 1));
+	SET_TX_DESC_MORE_FRAG(pdesc, (lastseg ? 0 : 1));
 
 	if (is_multicast_ether_addr(ieee80211_get_DA(hdr)) ||
 	    is_broadcast_ether_addr(ieee80211_get_DA(hdr))) {
@@ -889,8 +889,8 @@ void rtl92ce_tx_fill_desc(struct ieee802
 }
 
 void rtl92ce_tx_fill_cmddesc(struct ieee80211_hw *hw,
-			     u8 *pdesc, bool b_firstseg,
-			     bool b_lastseg, struct sk_buff *skb)
+			     u8 *pdesc, bool firstseg,
+			     bool lastseg, struct sk_buff *skb)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
@@ -905,7 +905,7 @@ void rtl92ce_tx_fill_cmddesc(struct ieee
 
 	CLEAR_PCI_TX_DESC_CONTENT(pdesc, TX_DESC_SIZE);
 
-	if (b_firstseg)
+	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, USB_HWDESC_HEADER_LEN);
 
 	SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE1M);
Index: wireless-testing/drivers/net/wireless/rtlwifi/usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/usb.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/usb.c
@@ -366,10 +366,10 @@ static int _rtl_usb_init_sw(struct ieee8
 	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
 
 	rtlhal->hw = hw;
-	ppsc->b_inactiveps = false;
-	ppsc->b_leisure_ps = false;
-	ppsc->b_fwctrl_lps = false;
-	ppsc->b_reg_fwctrl_lps = 3;
+	ppsc->inactiveps = false;
+	ppsc->leisure_ps = false;
+	ppsc->fwctrl_lps = false;
+	ppsc->reg_fwctrl_lps = 3;
 	ppsc->reg_max_lps_awakeintvl = 5;
 	ppsc->fwctrl_psmode = FW_PS_DTIM_MODE;
 
@@ -450,7 +450,7 @@ static void _rtl_usb_rx_process_agg(stru
 	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
 	hdr = (struct ieee80211_hdr *)(skb->data);
 	fc = le16_to_cpu(hdr->frame_control);
-	if (!stats.b_crc) {
+	if (!stats.crc) {
 		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
 		if (is_broadcast_ether_addr(hdr->addr1)) {
@@ -493,7 +493,7 @@ static void _rtl_usb_rx_process_noagg(st
 	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
 	hdr = (struct ieee80211_hdr *)(skb->data);
 	fc = le16_to_cpu(hdr->frame_control);
-	if (!stats.b_crc) {
+	if (!stats.crc) {
 		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
 
 		if (is_broadcast_ether_addr(hdr->addr1)) {
