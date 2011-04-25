Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60893 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1DYRza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:55:30 -0400
Date: Mon, 25 Apr 2011 12:53:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/18] rtlwifi: rtl8192ce: Change sw and LED routines for
 addition of rtl8192se and rtl8192de
Message-ID: <4db5b533.X7iGcy3kmjpLiGli%Larry.Finger@lwfinger.net> (sfid-20110425_195533_722554_76AE9146)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change rtl8192ce sw and LED routines for addition of RTL8192SE and
RTL8192DE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 rtl8192c/dm_common.c |   13 ++--
 rtl8192ce/dm.c       |    3 +
 rtl8192ce/dm.h       |    2 
 rtl8192ce/led.c      |    6 +-
 rtl8192ce/led.h      |    3 -
 rtl8192ce/reg.h      |   59 ++++------------------
 rtl8192ce/sw.c       |  133 +++++++++++++++++++++++++++++++++++++++++++++------
 rtl8192ce/sw.h       |   15 +----
 rtl8192cu/hw.c       |    2 
 9 files changed, 150 insertions(+), 86 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
@@ -29,10 +29,12 @@
 
 #include "../wifi.h"
 #include "../base.h"
+#include "../pci.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
 #include "dm.h"
+#include "../rtl8192c/fw_common.h"
 
 void rtl92ce_dm_dynamic_txpower(struct ieee80211_hw *hw)
 {
@@ -111,3 +113,4 @@ void rtl92ce_dm_dynamic_txpower(struct i
 
 	rtlpriv->dm.last_dtp_lvl = rtlpriv->dm.dynamic_txhighpower_lvl;
 }
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
@@ -192,6 +192,8 @@ void rtl92c_dm_init_edca_turbo(struct ie
 void rtl92c_dm_check_txpower_tracking(struct ieee80211_hw *hw);
 void rtl92c_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw);
 void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal);
+void rtl92c_dm_bt_coexist(struct ieee80211_hw *hw);
 void rtl92ce_dm_dynamic_txpower(struct ieee80211_hw *hw);
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -320,7 +320,7 @@ static void rtl92c_dm_ctrl_initgain_by_r
 
 static void rtl92c_dm_initial_gain_multi_sta(struct ieee80211_hw *hw)
 {
-	static u8 binitialized; /* initialized to false */
+	static u8 initialized; /* initialized to false */
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	long rssi_strength = rtlpriv->dm.entry_min_undecoratedsmoothed_pwdb;
@@ -331,11 +331,11 @@ static void rtl92c_dm_initial_gain_multi
 
 	if ((multi_sta == false) || (dm_digtable.cursta_connectctate !=
 				     DIG_STA_DISCONNECT)) {
-		binitialized = false;
+		initialized = false;
 		dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_MAX;
 		return;
-	} else if (binitialized == false) {
-		binitialized = true;
+	} else if (initialized == false) {
+		initialized = true;
 		dm_digtable.dig_ext_port_stage = DIG_EXT_PORT_STAGE_0;
 		dm_digtable.cur_igvalue = 0x20;
 		rtl92c_dm_write_dig(hw);
@@ -1513,7 +1513,7 @@ void rtl92c_dm_watchdog(struct ieee80211
 }
 EXPORT_SYMBOL(rtl92c_dm_watchdog);
 
-static u8 rtl92c_bt_rssi_state_change(struct ieee80211_hw *hw)
+u8 rtl92c_bt_rssi_state_change(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
@@ -1570,6 +1570,7 @@ static u8 rtl92c_bt_rssi_state_change(st
 		return false;
 	}
 }
+EXPORT_SYMBOL(rtl92c_bt_rssi_state_change);
 
 static bool rtl92c_bt_state_change(struct ieee80211_hw *hw)
 {
@@ -1820,5 +1821,5 @@ void rtl92c_dm_bt_coexist(struct ieee802
 			rtl92c_check_bt_change(hw);
 	}
 }
-
+EXPORT_SYMBOL(rtl92c_dm_bt_coexist);
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.c
@@ -106,12 +106,11 @@ void rtl92ce_sw_led_off(struct ieee80211
 void rtl92ce_init_sw_leds(struct ieee80211_hw *hw)
 {
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-
 	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led0), LED_PIN_LED0);
 	_rtl92ce_init_led(hw, &(pcipriv->ledctl.sw_led1), LED_PIN_LED1);
 }
 
-void _rtl92ce_sw_led_control(struct ieee80211_hw *hw,
+static void _rtl92ce_sw_led_control(struct ieee80211_hw *hw,
 				    enum led_ctl_mode ledaction)
 {
 	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
@@ -146,7 +145,8 @@ void rtl92ce_led_control(struct ieee8021
 	     ledaction == LED_CTL_POWER_ON)) {
 		return;
 	}
-	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, ("ledaction %d,\n",
+	RT_TRACE(rtlpriv, COMP_LED, DBG_LOUD, ("ledaction %d.\n",
 				ledaction));
 	_rtl92ce_sw_led_control(hw, ledaction);
 }
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/led.h
@@ -34,7 +34,6 @@ void rtl92ce_init_sw_leds(struct ieee802
 void rtl92ce_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
 void rtl92ce_sw_led_off(struct ieee80211_hw *hw, struct rtl_led *pled);
 void rtl92ce_led_control(struct ieee80211_hw *hw, enum led_ctl_mode ledaction);
-void _rtl92ce_sw_led_control(struct ieee80211_hw *hw,
-				    enum led_ctl_mode ledaction);
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/reg.h
@@ -72,6 +72,7 @@
 #define REG_GPIO_IO_SEL_2			0x0062
 /* RTL8723 WIFI/BT/GPS Multi-Function control source. */
 #define REG_MULTI_FUNC_CTRL			0x0068
+
 #define REG_MCUFWDL				0x0080
 
 #define REG_HMEBOX_EXT_0			0x0088
@@ -543,6 +544,8 @@
 #define	IMR_WLANOFF				BIT(0)
 
 #define	HWSET_MAX_SIZE				128
+#define EFUSE_MAX_SECTION			16
+#define EFUSE_REAL_CONTENT_LEN			512
 
 #define	EEPROM_DEFAULT_TSSI			0x0
 #define EEPROM_DEFAULT_TXPOWERDIFF		0x0
@@ -656,6 +659,7 @@
 #define	STOPBE					BIT(1)
 #define	STOPBK					BIT(0)
 
+#define	RCR_APPFCS				BIT(31)
 #define	RCR_APP_FCS				BIT(31)
 #define	RCR_APP_MIC				BIT(30)
 #define	RCR_APP_ICV				BIT(29)
@@ -688,6 +692,7 @@
 
 #define REG_USB_INFO				0xFE17
 #define REG_USB_SPECIAL_OPTION			0xFE55
+
 #define REG_USB_DMA_AGG_TO			0xFE5B
 #define REG_USB_AGG_TO				0xFE5C
 #define REG_USB_AGG_TH				0xFE5D
@@ -775,7 +780,6 @@
 
 #define	BOOT_FROM_EEPROM			BIT(4)
 #define	EEPROM_EN				BIT(5)
-#define	EEPROMSEL				BOOT_FROM_EEPROM
 
 #define AFE_BGEN				BIT(0)
 #define AFE_MBEN				BIT(1)
@@ -901,28 +905,7 @@
 #define BD_PKG_SEL				BIT(25)
 #define BD_HCI_SEL				BIT(26)
 #define TYPE_ID					BIT(27)
-
-/* REG_GPIO_OUTSTS (For RTL8723 only) */
-#define	EFS_HCI_SEL				(BIT(0)|BIT(1))
-#define	PAD_HCI_SEL				(BIT(2)|BIT(3))
-#define	HCI_SEL					(BIT(4)|BIT(5))
-#define	PKG_SEL_HCI				BIT(6)
-#define	FEN_GPS					BIT(7)
-#define	FEN_BT					BIT(8)
-#define	FEN_WL					BIT(9)
-#define	FEN_PCI					BIT(10)
-#define	FEN_USB					BIT(11)
-#define	BTRF_HWPDN_N				BIT(12)
-#define	WLRF_HWPDN_N				BIT(13)
-#define	PDN_BT_N				BIT(14)
-#define	PDN_GPS_N				BIT(15)
-#define	BT_CTL_HWPDN				BIT(16)
-#define	GPS_CTL_HWPDN				BIT(17)
-#define	PPHY_SUSB				BIT(20)
-#define	UPHY_SUSB				BIT(21)
-#define	PCI_SUSEN				BIT(22)
-#define	USB_SUSEN				BIT(23)
-#define	RF_RL_ID			(BIT(31) | BIT(30) | BIT(29) | BIT(28))
+#define	RF_RL_ID		(BIT(31) | BIT(30) | BIT(29) | BIT(28))
 
 #define CHIP_VER_RTL_MASK			0xF000
 #define CHIP_VER_RTL_SHIFT			12
@@ -1077,6 +1060,7 @@
 #define _RARF_RC8(x)				(((x) & 0x1F) << 24)
 
 #define AC_PARAM_TXOP_OFFSET			16
+#define AC_PARAM_TXOP_LIMIT_OFFSET		16
 #define AC_PARAM_ECW_MAX_OFFSET			12
 #define AC_PARAM_ECW_MIN_OFFSET			8
 #define AC_PARAM_AIFS_OFFSET			0
@@ -1221,33 +1205,11 @@
 #define EPROM_CMD_CONFIG			0x3
 #define EPROM_CMD_LOAD				1
 
-#define	HWSET_MAX_SIZE_92S		HWSET_MAX_SIZE
-
-#define	HAL_8192C_HW_GPIO_WPS_BIT		BIT(2)
+#define	HWSET_MAX_SIZE_92S			HWSET_MAX_SIZE
 
-/* REG_MULTI_FUNC_CTRL(For RTL8723 Only) */
-/* Enable GPIO[9] as WiFi HW PDn source */
 #define	WL_HWPDN_EN				BIT(0)
-/* WiFi HW PDn polarity control */
-#define	WL_HWPDN_SL				BIT(1)
-/* WiFi function enable */
-#define	WL_FUNC_EN				BIT(2)
-/* Enable GPIO[9] as WiFi RF HW PDn source */
-#define	WL_HWROF_EN				BIT(3)
-/* Enable GPIO[11] as BT HW PDn source */
-#define	BT_HWPDN_EN				BIT(16)
-/* BT HW PDn polarity control */
-#define	BT_HWPDN_SL				BIT(17)
-/* BT function enable */
-#define	BT_FUNC_EN				BIT(18)
-/* Enable GPIO[11] as BT/GPS RF HW PDn source */
-#define	BT_HWROF_EN				BIT(19)
-/* Enable GPIO[10] as GPS HW PDn source */
-#define	GPS_HWPDN_EN				BIT(20)
-/* GPS HW PDn polarity control */
-#define	GPS_HWPDN_SL				BIT(21)
-/* GPS function enable */
-#define	GPS_FUNC_EN				BIT(22)
+
+#define	HAL_8192C_HW_GPIO_WPS_BIT		BIT(2)
 
 #define	RPMAC_RESET				0x100
 #define	RPMAC_TXSTART				0x104
@@ -2128,3 +2090,4 @@
 #define	TUPDATE_RXCOUNTER			100
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -42,10 +42,58 @@
 #include "trx.h"
 #include "led.h"
 
+void rtl92c_init_aspm_vars(struct ieee80211_hw *hw)
+{
+	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+
+	/*close ASPM for AMD defaultly */
+	rtlpci->const_amdpci_aspm = 0;
+
+	/*
+	 * ASPM PS mode.
+	 * 0 - Disable ASPM,
+	 * 1 - Enable ASPM without Clock Req,
+	 * 2 - Enable ASPM with Clock Req,
+	 * 3 - Alwyas Enable ASPM with Clock Req,
+	 * 4 - Always Enable ASPM without Clock Req.
+	 * set defult to RTL8192CE:3 RTL8192E:2
+	 * */
+	rtlpci->const_pci_aspm = 3;
+
+	/*Setting for PCI-E device */
+	rtlpci->const_devicepci_aspm_setting = 0x03;
+
+	/*Setting for PCI-E bridge */
+	rtlpci->const_hostpci_aspm_setting = 0x02;
+
+	/*
+	 * In Hw/Sw Radio Off situation.
+	 * 0 - Default,
+	 * 1 - From ASPM setting without low Mac Pwr,
+	 * 2 - From ASPM setting with low Mac Pwr,
+	 * 3 - Bus D3
+	 * set default to RTL8192CE:0 RTL8192SE:2
+	 */
+	rtlpci->const_hwsw_rfoff_d3 = 0;
+
+	/*
+	 * This setting works for those device with
+	 * backdoor ASPM setting such as EPHY setting.
+	 * 0 - Not support ASPM,
+	 * 1 - Support ASPM,
+	 * 2 - According to chipset.
+	 */
+	rtlpci->const_support_pciaspm = 1;
+}
+
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 {
+	int err;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
+	const struct firmware *firmware;
+
+	rtl8192ce_bt_reg_init(hw);
 
 	rtlpriv->dm.dm_initialgain_enable = 1;
 	rtlpriv->dm.dm_flag = 0;
@@ -53,7 +101,12 @@ int rtl92c_init_sw_vars(struct ieee80211
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpci->transmit_config = CFENDFORM | BIT(12) | BIT(13);
 
-	rtlpci->receive_config = (RCR_APP_FCS |
+	/* compatible 5G band 88ce just 2.4G band & smsp */
+	rtlpriv->rtlhal.current_bandtype = BAND_ON_2_4G;
+	rtlpriv->rtlhal.bandset = BAND_ON_2_4G;
+	rtlpriv->rtlhal.macphymode = SINGLEMAC_SINGLEPHY;
+
+	rtlpci->receive_config = (RCR_APPFCS |
 				  RCR_AMF |
 				  RCR_ADF |
 				  RCR_APP_MIC |
@@ -76,13 +129,49 @@ int rtl92c_init_sw_vars(struct ieee80211
 
 	rtlpci->irq_mask[1] = (u32) (IMR_CPWM | IMR_C2HCMD | 0);
 
-	rtlpriv->rtlhal.pfirmware = (u8 *) vmalloc(0x4000);
+	/* for LPS & IPS */
+	rtlpriv->psc.inactiveps = rtlpriv->cfg->mod_params->inactiveps;
+	rtlpriv->psc.swctrl_lps = rtlpriv->cfg->mod_params->swctrl_lps;
+	rtlpriv->psc.fwctrl_lps = rtlpriv->cfg->mod_params->fwctrl_lps;
+	rtlpriv->psc.reg_fwctrl_lps = 3;
+	rtlpriv->psc.reg_max_lps_awakeintvl = 5;
+	/* for ASPM, you can close aspm through
+	 * set const_support_pciaspm = 0 */
+	rtl92c_init_aspm_vars(hw);
+
+	if (rtlpriv->psc.reg_fwctrl_lps == 1)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_MIN_MODE;
+	else if (rtlpriv->psc.reg_fwctrl_lps == 2)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_MAX_MODE;
+	else if (rtlpriv->psc.reg_fwctrl_lps == 3)
+		rtlpriv->psc.fwctrl_psmode = FW_PS_DTIM_MODE;
+
+	/* for firmware buf */
+	rtlpriv->rtlhal.pfirmware = vzalloc(0x4000);
 	if (!rtlpriv->rtlhal.pfirmware) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("Can't alloc buffer for fw.\n"));
 		return 1;
 	}
 
+	/* request fw */
+	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
+			rtlpriv->io.dev);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Failed to request firmware!\n"));
+		return 1;
+	}
+	if (firmware->size > 0x4000) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Firmware is too big!\n"));
+		release_firmware(firmware);
+		return 1;
+	}
+	memcpy(rtlpriv->rtlhal.pfirmware, firmware->data, firmware->size);
+	rtlpriv->rtlhal.fwsize = firmware->size;
+	release_firmware(firmware);
+
 	return 0;
 }
 
@@ -96,28 +185,28 @@ void rtl92c_deinit_sw_vars(struct ieee80
 	}
 }
 
-static struct rtl_hal_ops rtl8192ce_hal_ops = {
+struct rtl_hal_ops rtl8192ce_hal_ops = {
 	.init_sw_vars = rtl92c_init_sw_vars,
 	.deinit_sw_vars = rtl92c_deinit_sw_vars,
 	.read_eeprom_info = rtl92ce_read_eeprom_info,
 	.interrupt_recognized = rtl92ce_interrupt_recognized,
 	.hw_init = rtl92ce_hw_init,
 	.hw_disable = rtl92ce_card_disable,
+	.hw_suspend = rtl92ce_suspend,
+	.hw_resume = rtl92ce_resume,
 	.enable_interrupt = rtl92ce_enable_interrupt,
 	.disable_interrupt = rtl92ce_disable_interrupt,
 	.set_network_type = rtl92ce_set_network_type,
+	.set_chk_bssid = rtl92ce_set_check_bssid,
 	.set_qos = rtl92ce_set_qos,
 	.set_bcn_reg = rtl92ce_set_beacon_related_registers,
 	.set_bcn_intv = rtl92ce_set_beacon_interval,
 	.update_interrupt_mask = rtl92ce_update_interrupt_mask,
 	.get_hw_reg = rtl92ce_get_hw_reg,
 	.set_hw_reg = rtl92ce_set_hw_reg,
-#if 0	/* temporary */
-	.update_rate_table = rtl92ce_update_hal_rate_table,
-	.update_rate_mask = rtl92ce_update_hal_rate_mask,
+	.update_rate_tbl = rtl92ce_update_hal_rate_tbl,
 	.fill_tx_desc = rtl92ce_tx_fill_desc,
 	.fill_tx_cmddesc = rtl92ce_tx_fill_cmddesc,
-#endif
 	.query_rx_desc = rtl92ce_rx_query_desc,
 	.set_channel_access = rtl92ce_update_channel_access_setting,
 	.radio_onoff_checking = rtl92ce_gpio_radio_on_off_checking,
@@ -125,7 +214,8 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.switch_channel = rtl92c_phy_sw_chnl,
 	.dm_watchdog = rtl92c_dm_watchdog,
 	.scan_operation_backup = rtl92c_phy_scan_operation_backup,
-	.set_rf_power_state = rtl92ce_phy_set_rf_power_state,
+#if 0	/* temporary */
+	.set_rf_power_state = rtl92c_phy_set_rf_power_state,
 	.led_control = rtl92ce_led_control,
 	.set_desc = rtl92ce_set_desc,
 	.get_desc = rtl92ce_get_desc,
@@ -135,24 +225,28 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.init_sw_leds = rtl92ce_init_sw_leds,
 	.get_bbreg = rtl92c_phy_query_bb_reg,
 	.set_bbreg = rtl92c_phy_set_bb_reg,
-	.get_rfreg = rtl92ce_phy_query_rf_reg,
 	.set_rfreg = rtl92ce_phy_set_rf_reg,
-	.cmd_send_packet = _rtl92c_cmd_send_packet,
+	.get_rfreg = rtl92c_phy_query_rf_reg,
 	.phy_rf6052_config = rtl92ce_phy_rf6052_config,
 	.phy_rf6052_set_cck_txpower = rtl92ce_phy_rf6052_set_cck_txpower,
 	.phy_rf6052_set_ofdm_txpower = rtl92ce_phy_rf6052_set_ofdm_txpower,
 	.config_bb_with_headerfile = _rtl92ce_phy_config_bb_with_headerfile,
 	.config_bb_with_pgheaderfile = _rtl92ce_phy_config_bb_with_pgheaderfile,
 	.phy_lc_calibrate = _rtl92ce_phy_lc_calibrate,
-	.phy_set_bw_mode_callback = rtl92ce_phy_set_bw_mode_callback,
 	.dm_dynamic_txpower = rtl92ce_dm_dynamic_txpower,
+#endif
 };
 
-static struct rtl_mod_params rtl92ce_mod_params = {
-	.sw_crypto = 0,
+struct rtl_mod_params rtl92ce_mod_params = {
+	.sw_crypto = false,
+	.inactiveps = true,
+	.swctrl_lps = false,
+	.fwctrl_lps = true,
 };
 
-static struct rtl_hal_cfg rtl92ce_hal_cfg = {
+struct rtl_hal_cfg rtl92ce_hal_cfg = {
+	.bar_id = 2,
+	.write_readback = true,
 	.name = "rtl92c_pci",
 	.fw_name = "rtlwifi/rtl8192cfw.bin",
 	.ops = &rtl8192ce_hal_ops,
@@ -176,6 +270,8 @@ static struct rtl_hal_cfg rtl92ce_hal_cf
 	.maps[EFUSE_LOADER_CLK_EN] = LOADER_CLK_EN,
 	.maps[EFUSE_ANA8M] = EFUSE_ANA8M,
 	.maps[EFUSE_HWSET_MAX_SIZE] = HWSET_MAX_SIZE,
+	.maps[EFUSE_MAX_SECTION_MAP] = EFUSE_MAX_SECTION,
+	.maps[EFUSE_REAL_CONTENT_SIZE] = EFUSE_REAL_CONTENT_LEN,
 
 	.maps[RWCAM] = REG_CAMCMD,
 	.maps[WCAMI] = REG_CAMWRITE,
@@ -240,7 +336,7 @@ static struct rtl_hal_cfg rtl92ce_hal_cf
 	.maps[RTL_RC_HT_RATEMCS15] = DESC92C_RATEMCS15,
 };
 
-static struct pci_device_id rtl92ce_pci_ids[] __devinitdata = {
+DEFINE_PCI_DEVICE_TABLE(rtl92ce_pci_ids) = {
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8191, rtl92ce_hal_cfg)},
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8178, rtl92ce_hal_cfg)},
 	{RTL_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8177, rtl92ce_hal_cfg)},
@@ -258,7 +354,13 @@ MODULE_DESCRIPTION("Realtek 8192C/8188C
 MODULE_FIRMWARE("rtlwifi/rtl8192cfw.bin");
 
 module_param_named(swenc, rtl92ce_mod_params.sw_crypto, bool, 0444);
+module_param_named(ips, rtl92ce_mod_params.inactiveps, bool, 0444);
+module_param_named(swlps, rtl92ce_mod_params.swctrl_lps, bool, 0444);
+module_param_named(fwlps, rtl92ce_mod_params.fwctrl_lps, bool, 0444);
 MODULE_PARM_DESC(swenc, "using hardware crypto (default 0 [hardware])\n");
+MODULE_PARM_DESC(ips, "using no link power save (default 1 is open)\n");
+MODULE_PARM_DESC(fwlps, "using linked fw control power save "
+		 "(default 1 is open)\n");
 
 static struct pci_driver rtl92ce_driver = {
 	.name = KBUILD_MODNAME,
@@ -291,3 +393,4 @@ static void __exit rtl92ce_module_exit(v
 
 module_init(rtl92ce_module_init);
 module_exit(rtl92ce_module_exit);
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
@@ -33,19 +33,10 @@
 int rtl92c_init_sw_vars(struct ieee80211_hw *hw);
 void rtl92c_deinit_sw_vars(struct ieee80211_hw *hw);
 void rtl92c_init_var_map(struct ieee80211_hw *hw);
-bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
-			     struct sk_buff *skb);
-void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
-					u8 *ppowerlevel);
-void rtl92ce_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
-					 u8 *ppowerlevel, u8 channel);
 bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
-						  u8 configtype);
+					    u8 configtype);
 bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
-						    u8 configtype);
-void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t);
-u32 rtl92ce_phy_query_rf_reg(struct ieee80211_hw *hw,
-			    enum radio_path rfpath, u32 regaddr, u32 bitmask);
-void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
+					      u8 configtype);
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -606,10 +606,12 @@ void rtl92cu_read_eeprom_info(struct iee
 	if (!IS_NORMAL_CHIP(rtlhal->version))
 		return;
 	tmp_u1b = rtl_read_byte(rtlpriv, REG_9346CR);
+#if 0	/* temporary */
 	rtlefuse->epromtype = (tmp_u1b & EEPROMSEL) ?
 			       EEPROM_93C46 : EEPROM_BOOT_EFUSE;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG, ("Boot from %s\n",
 		 (tmp_u1b & EEPROMSEL) ? "EERROM" : "EFUSE"));
+#endif
 	rtlefuse->autoload_failflag = (tmp_u1b & EEPROM_EN) ? false : true;
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD, ("Autoload %s\n",
 		 (tmp_u1b & EEPROM_EN) ? "OK!!" : "ERR!!"));
