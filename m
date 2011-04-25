Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1DYRzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:55:36 -0400
Date: Mon, 25 Apr 2011 12:53:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/18] rtlwifi: rtl8192ce: Change hw routine for addition
 of rtl8192se and rtl8192de
Message-ID: <4db5b52e.4YjFDsYP3jvOz9lv%Larry.Finger@lwfinger.net> (sfid-20110425_195541_142688_440BC682)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change rtl8192ce hw routine for addition of RTL8192SE and RTL8192DE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 rtl8192ce/def.h |   28 ---
 rtl8192ce/hw.c  |  510 ++++++++++++++++++++++++++++++++++++--------------------
 rtl8192ce/hw.h  |   35 ++-
 rtl8192ce/sw.c  |    2 
 rtl8192cu/hw.c  |    1 
 rtl8192cu/hw.h  |    2 
 6 files changed, 364 insertions(+), 214 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/def.h
@@ -121,19 +121,6 @@
 #define CHIP_92C			0x01
 #define CHIP_88C			0x00
 
-/* Add vendor information into chip version definition.
- * Add UMC B-Cut and RTL8723 chip info definition.
- *
- * BIT 7	Reserved
- * BIT 6	UMC BCut
- * BIT 5	Manufacturer(TSMC/UMC)
- * BIT 4	TEST/NORMAL
- * BIT 3	8723 Version
- * BIT 2	8723?
- * BIT 1	1T2R?
- * BIT 0	88C/92C
-*/
-
 enum version_8192c {
 	VERSION_A_CHIP_92C = 0x01,
 	VERSION_A_CHIP_88C = 0x00,
@@ -280,20 +267,6 @@ struct h2c_cmd_8192c {
 	u8 *p_cmdbuffer;
 };
 
-static inline u8 _rtl92c_get_chnl_group(u8 chnl)
-{
-	u8 group = 0;
-
-	if (chnl < 3)
-		group = 0;
-	else if (chnl < 9)
-		group = 1;
-	else
-		group = 2;
-
-	return group;
-}
-
 /* NOTE: reference to rtl8192c_rates struct */
 static inline int _rtl92c_rate_mapping(struct ieee80211_hw *hw, bool isHT,
 				       u8 desc_rate, bool first_ampdu)
@@ -399,3 +372,4 @@ static inline int _rtl92c_rate_mapping(s
 }
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -30,12 +30,14 @@
 #include "../wifi.h"
 #include "../efuse.h"
 #include "../base.h"
+#include "../regd.h"
 #include "../cam.h"
 #include "../ps.h"
 #include "../pci.h"
 #include "reg.h"
 #include "def.h"
 #include "phy.h"
+#include "../rtl8192c/fw_common.h"
 #include "dm.h"
 #include "led.h"
 #include "hw.h"
@@ -137,15 +139,6 @@ void rtl92ce_get_hw_reg(struct ieee80211
 
 		break;
 		}
-	case HW_VAR_MGT_FILTER:
-		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP0);
-		break;
-	case HW_VAR_CTRL_FILTER:
-		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP1);
-		break;
-	case HW_VAR_DATA_FILTER:
-		*((u16 *) (val)) = rtl_read_word(rtlpriv, REG_RXFLTMAP2);
-		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("switch case not process\n"));
@@ -156,6 +149,7 @@ void rtl92ce_get_hw_reg(struct ieee80211
 void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -178,7 +172,7 @@ void rtl92ce_set_hw_reg(struct ieee80211
 			rate_cfg |= 0x01;
 			rtl_write_byte(rtlpriv, REG_RRSR, rate_cfg & 0xff);
 			rtl_write_byte(rtlpriv, REG_RRSR + 1,
-				       (rate_cfg >> 8)&0xff);
+				       (rate_cfg >> 8) & 0xff);
 			while (rate_cfg > 0x1) {
 				rate_cfg = (rate_cfg >> 1);
 				rate_index++;
@@ -276,13 +270,19 @@ void rtl92ce_set_hw_reg(struct ieee80211
 			break;
 		}
 	case HW_VAR_AMPDU_FACTOR:{
-			u8 regtoset_normal[4] = { 0x41, 0xa8, 0x72, 0xb9 };
+			u8 regtoset_normal[4] = {0x41, 0xa8, 0x72, 0xb9};
+			u8 regtoset_bt[4] = {0x31, 0x74, 0x42, 0x97};
 
 			u8 factor_toset;
 			u8 *p_regtoset = NULL;
 			u8 index = 0;
 
-			p_regtoset = regtoset_normal;
+			if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+			    (rtlpcipriv->bt_coexist.bt_coexist_type ==
+			    BT_CSR_BC4))
+				p_regtoset = regtoset_bt;
+			else
+				p_regtoset = regtoset_normal;
 
 			factor_toset = *((u8 *) val);
 			if (factor_toset <= 3) {
@@ -317,45 +317,7 @@ void rtl92ce_set_hw_reg(struct ieee80211
 		}
 	case HW_VAR_AC_PARAM:{
 			u8 e_aci = *((u8 *) val);
-			u32 u4b_ac_param;
-			u16 cw_min = le16_to_cpu(mac->ac[e_aci].cw_min);
-			u16 cw_max = le16_to_cpu(mac->ac[e_aci].cw_max);
-			u16 tx_op = le16_to_cpu(mac->ac[e_aci].tx_op);
-
-			u4b_ac_param = (u32) mac->ac[e_aci].aifs;
-			u4b_ac_param |= ((u32)cw_min
-					 & 0xF) << AC_PARAM_ECW_MIN_OFFSET;
-			u4b_ac_param |= ((u32)cw_max &
-					 0xF) << AC_PARAM_ECW_MAX_OFFSET;
-			u4b_ac_param |= (u32)tx_op << AC_PARAM_TXOP_OFFSET;
-
-			RT_TRACE(rtlpriv, COMP_MLME, DBG_LOUD,
-				 ("queue:%x, ac_param:%x\n", e_aci,
-				  u4b_ac_param));
-
-			switch (e_aci) {
-			case AC1_BK:
-				rtl_write_dword(rtlpriv, REG_EDCA_BK_PARAM,
-						u4b_ac_param);
-				break;
-			case AC0_BE:
-				rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM,
-						u4b_ac_param);
-				break;
-			case AC2_VI:
-				rtl_write_dword(rtlpriv, REG_EDCA_VI_PARAM,
-						u4b_ac_param);
-				break;
-			case AC3_VO:
-				rtl_write_dword(rtlpriv, REG_EDCA_VO_PARAM,
-						u4b_ac_param);
-				break;
-			default:
-				RT_ASSERT(false,
-				  ("SetHwReg8185(): invalid aci: %d !\n",
-				   e_aci));
-				break;
-			}
+			rtl92c_dm_init_edca_turbo(hw);
 
 			if (rtlpci->acm_method != eAcmWay2_SW)
 				rtlpriv->cfg->ops->set_hw_reg(hw,
@@ -526,9 +488,6 @@ void rtl92ce_set_hw_reg(struct ieee80211
 	case HW_VAR_CORRECT_TSF:{
 			u8 btype_ibss = ((u8 *) (val))[0];
 
-			/*btype_ibss = (mac->opmode == NL80211_IFTYPE_ADHOC) ?
-					1 : 0;*/
-
 			if (btype_ibss == true)
 				_rtl92ce_stop_tx_beacon(hw);
 
@@ -537,7 +496,7 @@ void rtl92ce_set_hw_reg(struct ieee80211
 			rtl_write_dword(rtlpriv, REG_TSFTR,
 					(u32) (mac->tsf & 0xffffffff));
 			rtl_write_dword(rtlpriv, REG_TSFTR + 4,
-					(u32) ((mac->tsf >> 32)&0xffffffff));
+					(u32) ((mac->tsf >> 32) & 0xffffffff));
 
 			_rtl92ce_set_bcn_ctrl_reg(hw, BIT(3), 0);
 
@@ -547,15 +506,6 @@ void rtl92ce_set_hw_reg(struct ieee80211
 			break;
 
 		}
-	case HW_VAR_MGT_FILTER:
-		rtl_write_word(rtlpriv, REG_RXFLTMAP0, *(u16 *) val);
-		break;
-	case HW_VAR_CTRL_FILTER:
-		rtl_write_word(rtlpriv, REG_RXFLTMAP1, *(u16 *) val);
-		break;
-	case HW_VAR_DATA_FILTER:
-		rtl_write_word(rtlpriv, REG_RXFLTMAP2, *(u16 *) val);
-		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("switch case "
 							"not process\n"));
@@ -679,12 +629,12 @@ static void _rtl92ce_gen_refresh_led_sta
 		rtl92ce_sw_led_on(hw, pLed0);
 	else
 		rtl92ce_sw_led_off(hw, pLed0);
-
 }
 
 static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 
@@ -693,9 +643,22 @@ static bool _rtl92ce_init_mac(struct iee
 	u16 retry;
 
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x00);
+	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+		u32 value32;
+		value32 = rtl_read_dword(rtlpriv, REG_APS_FSMCO);
+		value32 |= (SOP_ABG | SOP_AMB | XOP_BTCK);
+		rtl_write_dword(rtlpriv, REG_APS_FSMCO, value32);
+	}
 	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x2b);
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL, 0x0F);
 
+	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+		u32 u4b_tmp = rtl_read_dword(rtlpriv, REG_AFE_XTAL_CTRL);
+
+		u4b_tmp &= (~0x00024800);
+		rtl_write_dword(rtlpriv, REG_AFE_XTAL_CTRL, u4b_tmp);
+	}
+
 	bytetmp = rtl_read_byte(rtlpriv, REG_APS_FSMCO + 1) | BIT(0);
 	udelay(2);
 
@@ -726,6 +689,11 @@ static bool _rtl92ce_init_mac(struct iee
 	rtl_write_byte(rtlpriv, REG_SYS_ISO_CTRL + 1, 0x82);
 	udelay(2);
 
+	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+		bytetmp = rtl_read_byte(rtlpriv, REG_AFE_XTAL_CTRL+2) & 0xfd;
+		rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL+2, bytetmp);
+	}
+
 	rtl_write_word(rtlpriv, REG_CR, 0x2ff);
 
 	if (_rtl92ce_llt_table_init(hw) == false)
@@ -793,6 +761,7 @@ static void _rtl92ce_hw_configure(struct
 {
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	u8 reg_bw_opmode;
 	u32 reg_ratr, reg_prsr;
 
@@ -824,7 +793,11 @@ static void _rtl92ce_hw_configure(struct
 	rtl_write_dword(rtlpriv, REG_RARFRC, 0x01000000);
 	rtl_write_dword(rtlpriv, REG_RARFRC + 4, 0x07060504);
 
-	rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0xb972a841);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4))
+		rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0x97427431);
+	else
+		rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, 0xb972a841);
 
 	rtl_write_byte(rtlpriv, REG_ATIMWND, 0x2);
 
@@ -840,11 +813,20 @@ static void _rtl92ce_hw_configure(struct
 	rtl_write_byte(rtlpriv, REG_PIFS, 0x1C);
 	rtl_write_byte(rtlpriv, REG_AGGR_BREAK_TIME, 0x16);
 
-	rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
-
-	rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4)) {
+		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+		rtl_write_word(rtlpriv, REG_PROT_MODE_CTRL, 0x0402);
+	} else {
+		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+		rtl_write_word(rtlpriv, REG_NAV_PROT_LEN, 0x0020);
+	}
 
-	rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x086666);
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4))
+		rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x03086666);
+	else
+		rtl_write_dword(rtlpriv, REG_FAST_EDCA_CTRL, 0x086666);
 
 	rtl_write_byte(rtlpriv, REG_ACKTO, 0x40);
 
@@ -948,8 +930,10 @@ int rtl92ce_hw_init(struct ieee80211_hw
 	}
 
 	rtlhal->last_hmeboxnum = 0;
-	rtl92ce_phy_mac_config(hw);
-	rtl92ce_phy_bb_config(hw);
+#if 0	/* temporary */
+	rtl92c_phy_mac_config(hw);
+	rtl92c_phy_bb_config(hw);
+#endif
 	rtlphy->rf_mode = RF_OP_BY_SW_3WIRE;
 	rtl92c_phy_rf_config(hw);
 	rtlphy->rfreg_chnlval[0] = rtl_get_rfreg(hw, (enum radio_path)0,
@@ -962,15 +946,20 @@ int rtl92ce_hw_init(struct ieee80211_hw
 	_rtl92ce_hw_configure(hw);
 	rtl_cam_reset_all_entry(hw);
 	rtl92ce_enable_hw_security_config(hw);
+
 	ppsc->rfpwr_state = ERFON;
+
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_ETHER_ADDR, mac->mac_addr);
 	_rtl92ce_enable_aspm_back_door(hw);
 	rtlpriv->intf_ops->enable_aspm(hw);
+
+	rtl8192ce_bt_hw_init(hw);
+
 	if (ppsc->rfpwr_state == ERFON) {
 		rtl92c_phy_set_rfpath_switch(hw, 1);
-		if (iqk_initialized)
+		if (iqk_initialized) {
 			rtl92c_phy_iq_calibrate(hw, true);
-		else {
+		} else {
 			rtl92c_phy_iq_calibrate(hw, false);
 			iqk_initialized = true;
 		}
@@ -1128,75 +1117,62 @@ static int _rtl92ce_set_media_status(str
 	return 0;
 }
 
-static void _rtl92ce_set_check_bssid(struct ieee80211_hw *hw,
-				     enum nl80211_iftype type)
+void rtl92ce_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
-	u8 filterout_non_associated_bssid = false;
 
-	switch (type) {
-	case NL80211_IFTYPE_ADHOC:
-	case NL80211_IFTYPE_STATION:
-		filterout_non_associated_bssid = true;
-		break;
-	case NL80211_IFTYPE_UNSPECIFIED:
-	case NL80211_IFTYPE_AP:
-	default:
-		break;
-	}
+	if (rtlpriv->psc.rfpwr_state != ERFON)
+		return;
 
-	if (filterout_non_associated_bssid == true) {
+	if (check_bssid == true) {
 		reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
 					      (u8 *) (&reg_rcr));
 		_rtl92ce_set_bcn_ctrl_reg(hw, 0, BIT(4));
-	} else if (filterout_non_associated_bssid == false) {
+	} else if (check_bssid == false) {
 		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
 		_rtl92ce_set_bcn_ctrl_reg(hw, BIT(4), 0);
 		rtlpriv->cfg->ops->set_hw_reg(hw,
 					      HW_VAR_RCR, (u8 *) (&reg_rcr));
 	}
+
 }
 
 int rtl92ce_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (_rtl92ce_set_media_status(hw, type))
 		return -EOPNOTSUPP;
-	_rtl92ce_set_check_bssid(hw, type);
+
+	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
+		if (type != NL80211_IFTYPE_AP)
+			rtl92ce_set_check_bssid(hw, true);
+	} else {
+		rtl92ce_set_check_bssid(hw, false);
+	}
+
 	return 0;
 }
 
+/* don't set REG_EDCA_BE_PARAM here because mac80211 will send pkt when scan */
 void rtl92ce_set_qos(struct ieee80211_hw *hw, int aci)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u32 u4b_ac_param;
-	u16 cw_min = le16_to_cpu(mac->ac[aci].cw_min);
-	u16 cw_max = le16_to_cpu(mac->ac[aci].cw_max);
-	u16 tx_op = le16_to_cpu(mac->ac[aci].tx_op);
-
 	rtl92c_dm_init_edca_turbo(hw);
-	u4b_ac_param = (u32) mac->ac[aci].aifs;
-	u4b_ac_param |= (u32) ((cw_min & 0xF) << AC_PARAM_ECW_MIN_OFFSET);
-	u4b_ac_param |= (u32) ((cw_max & 0xF) << AC_PARAM_ECW_MAX_OFFSET);
-	u4b_ac_param |= (u32) (tx_op << AC_PARAM_TXOP_OFFSET);
-	RT_TRACE(rtlpriv, COMP_QOS, DBG_DMESG,
-		 ("queue:%x, ac_param:%x aifs:%x cwmin:%x cwmax:%x txop:%x\n",
-		  aci, u4b_ac_param, mac->ac[aci].aifs, cw_min,
-		  cw_max, tx_op));
 	switch (aci) {
 	case AC1_BK:
-		rtl_write_dword(rtlpriv, REG_EDCA_BK_PARAM, u4b_ac_param);
+		rtl_write_dword(rtlpriv, REG_EDCA_BK_PARAM, 0xa44f);
 		break;
 	case AC0_BE:
-		rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM, u4b_ac_param);
+		/* rtl_write_dword(rtlpriv, REG_EDCA_BE_PARAM, u4b_ac_param); */
 		break;
 	case AC2_VI:
-		rtl_write_dword(rtlpriv, REG_EDCA_VI_PARAM, u4b_ac_param);
+		rtl_write_dword(rtlpriv, REG_EDCA_VI_PARAM, 0x5e4322);
 		break;
 	case AC3_VO:
-		rtl_write_dword(rtlpriv, REG_EDCA_VO_PARAM, u4b_ac_param);
+		rtl_write_dword(rtlpriv, REG_EDCA_VO_PARAM, 0x2f3222);
 		break;
 	default:
 		RT_ASSERT(false, ("invalid aci: %d !\n", aci));
@@ -1227,8 +1203,10 @@ void rtl92ce_disable_interrupt(struct ie
 static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 u1b_tmp;
+	u32 u4b_tmp;
 
 	rtlpriv->intf_ops->enable_aspm(hw);
 	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0xFF);
@@ -1243,13 +1221,27 @@ static void _rtl92ce_poweroff_adapter(st
 	rtl_write_byte(rtlpriv, REG_MCUFWDL, 0x00);
 	rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00000000);
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_GPIO_PIN_CTRL);
-	rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00FF0000 |
-			(u1b_tmp << 8));
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	     ((rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) ||
+	     (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC8))) {
+		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00F30000 |
+				(u1b_tmp << 8));
+	} else {
+		rtl_write_dword(rtlpriv, REG_GPIO_PIN_CTRL, 0x00FF0000 |
+				(u1b_tmp << 8));
+	}
 	rtl_write_word(rtlpriv, REG_GPIO_IO_SEL, 0x0790);
 	rtl_write_word(rtlpriv, REG_LEDCFG0, 0x8080);
 	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL, 0x80);
 	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x23);
-	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL, 0x0e);
+	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+		u4b_tmp = rtl_read_dword(rtlpriv, REG_AFE_XTAL_CTRL);
+		u4b_tmp |= 0x03824800;
+		rtl_write_dword(rtlpriv, REG_AFE_XTAL_CTRL, u4b_tmp);
+	} else {
+		rtl_write_dword(rtlpriv, REG_AFE_XTAL_CTRL, 0x0e);
+	}
+
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x0e);
 	rtl_write_byte(rtlpriv, REG_APS_FSMCO + 1, 0x10);
 }
@@ -1327,6 +1319,7 @@ void rtl92ce_update_interrupt_mask(struc
 
 	RT_TRACE(rtlpriv, COMP_INTR, DBG_LOUD,
 		 ("add_msr:%x, rm_msr:%x\n", add_msr, rm_msr));
+
 	if (add_msr)
 		rtlpci->irq_mask[0] |= add_msr;
 	if (rm_msr)
@@ -1582,7 +1575,7 @@ static void _rtl92ce_read_adapter_info(s
 			 ("RTL819X Not boot from eeprom, check it !!"));
 	}
 
-	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_LOUD, ("MAP\n"),
+	RT_PRINT_DATA(rtlpriv, COMP_INIT, DBG_DMESG, ("MAP\n"),
 		      hwinfo, HWSET_MAX_SIZE);
 
 	eeprom_id = *((u16 *)&hwinfo[0]);
@@ -1610,6 +1603,10 @@ static void _rtl92ce_read_adapter_info(s
 					     rtlefuse->autoload_failflag,
 					     hwinfo);
 
+	rtl8192ce_read_bt_coexist_info_from_hwpg(hw,
+						 rtlefuse->autoload_failflag,
+						 hwinfo);
+
 	rtlefuse->eeprom_channelplan = *(u8 *)&hwinfo[EEPROM_CHANNELPLAN];
 	rtlefuse->eeprom_version = *(u16 *)&hwinfo[EEPROM_VERSION];
 	rtlefuse->txpwr_fromeprom = true;
@@ -1618,6 +1615,9 @@ static void _rtl92ce_read_adapter_info(s
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 		 ("EEPROM Customer ID: 0x%2x\n", rtlefuse->eeprom_oemid));
 
+	/* set channel paln to world wide 13 */
+	rtlefuse->channel_plan = COUNTRY_CODE_WORLD_WIDE_13;
+
 	if (rtlhal->oem_id == RT_CID_DEFAULT) {
 		switch (rtlefuse->eeprom_oemid) {
 		case EEPROM_CID_DEFAULT:
@@ -1701,30 +1701,36 @@ void rtl92ce_read_eeprom_info(struct iee
 	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("Autoload ERR!!\n"));
 	}
-
 	_rtl92ce_hal_customized_behavior(hw);
 }
 
-void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw)
+static void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-
-	u32 ratr_value = (u32) mac->basic_rates;
-	u8 *mcsrate = mac->mcs;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u32 ratr_value;
 	u8 ratr_index = 0;
 	u8 nmode = mac->ht_enable;
-	u8 mimo_ps = 1;
+	u8 mimo_ps = IEEE80211_SMPS_OFF;
 	u16 shortgi_rate;
 	u32 tmp_ratr_value;
 	u8 curtxbw_40mhz = mac->bw_40;
-	u8 curshortgi_40mhz = mac->sgi_40;
-	u8 curshortgi_20mhz = mac->sgi_20;
+	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+			       1 : 0;
+	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+			       1 : 0;
 	enum wireless_mode wirelessmode = mac->mode;
 
-	ratr_value |= ((*(u16 *) (mcsrate))) << 12;
-
+	if (rtlhal->current_bandtype == BAND_ON_5G)
+		ratr_value = sta->supp_rates[1] << 4;
+	else
+		ratr_value = sta->supp_rates[0];
+	ratr_value |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
+			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
 	case WIRELESS_MODE_B:
 		if (ratr_value & 0x0000000c)
@@ -1738,7 +1744,7 @@ void rtl92ce_update_hal_rate_table(struc
 	case WIRELESS_MODE_N_24G:
 	case WIRELESS_MODE_N_5G:
 		nmode = 1;
-		if (mimo_ps == 0) {
+		if (mimo_ps == IEEE80211_SMPS_STATIC) {
 			ratr_value &= 0x0007F005;
 		} else {
 			u32 ratr_mask;
@@ -1761,10 +1767,19 @@ void rtl92ce_update_hal_rate_table(struc
 		break;
 	}
 
-	ratr_value &= 0x0FFFFFFF;
+	if ((rtlpcipriv->bt_coexist.bt_coexistence) &&
+	    (rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) &&
+	    (rtlpcipriv->bt_coexist.bt_cur_state) &&
+	    (rtlpcipriv->bt_coexist.bt_ant_isolation) &&
+	    ((rtlpcipriv->bt_coexist.bt_service == BT_SCO) ||
+	    (rtlpcipriv->bt_coexist.bt_service == BT_BUSY)))
+		ratr_value &= 0x0fffcfc0;
+	else
+		ratr_value &= 0x0FFFFFFF;
 
-	if (nmode && ((curtxbw_40mhz && curshortgi_40mhz) || (!curtxbw_40mhz &&
-		       curshortgi_20mhz))) {
+	if (nmode && ((curtxbw_40mhz &&
+			 curshortgi_40mhz) || (!curtxbw_40mhz &&
+					       curshortgi_20mhz))) {
 
 		ratr_value |= 0x10000000;
 		tmp_ratr_value = (ratr_value >> 12);
@@ -1784,24 +1799,42 @@ void rtl92ce_update_hal_rate_table(struc
 		 ("%x\n", rtl_read_dword(rtlpriv, REG_ARFR0)));
 }
 
-void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level)
+static void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u8 rssi_level)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	u32 ratr_bitmap = (u32) mac->basic_rates;
-	u8 *p_mcsrate = mac->mcs;
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_sta_info *sta_entry = NULL;
+	u32 ratr_bitmap;
 	u8 ratr_index;
-	u8 curtxbw_40mhz = mac->bw_40;
-	u8 curshortgi_40mhz = mac->sgi_40;
-	u8 curshortgi_20mhz = mac->sgi_20;
-	enum wireless_mode wirelessmode = mac->mode;
+	u8 curtxbw_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
+				? 1 : 0;
+	u8 curshortgi_40mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+				1 : 0;
+	u8 curshortgi_20mhz = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
+				1 : 0;
+	enum wireless_mode wirelessmode = 0;
 	bool shortgi = false;
 	u8 rate_mask[5];
 	u8 macid = 0;
-	u8 mimops = 1;
+	u8 mimo_ps = IEEE80211_SMPS_OFF;
+
+	sta_entry = (struct rtl_sta_info *) sta->drv_priv;
+	wirelessmode = sta_entry->wireless_mode;
+	if (mac->opmode == NL80211_IFTYPE_STATION)
+		curtxbw_40mhz = mac->bw_40;
+	else if (mac->opmode == NL80211_IFTYPE_AP ||
+		mac->opmode == NL80211_IFTYPE_ADHOC)
+		macid = sta->aid + 1;
 
-	ratr_bitmap |= (p_mcsrate[1] << 20) | (p_mcsrate[0] << 12);
+	if (rtlhal->current_bandtype == BAND_ON_5G)
+		ratr_bitmap = sta->supp_rates[1] << 4;
+	else
+		ratr_bitmap = sta->supp_rates[0];
+	ratr_bitmap |= (sta->ht_cap.mcs.rx_mask[1] << 20 |
+			sta->ht_cap.mcs.rx_mask[0] << 12);
 	switch (wirelessmode) {
 	case WIRELESS_MODE_B:
 		ratr_index = RATR_INX_WIRELESS_B;
@@ -1828,7 +1861,7 @@ void rtl92ce_update_hal_rate_mask(struct
 	case WIRELESS_MODE_N_5G:
 		ratr_index = RATR_INX_WIRELESS_NGB;
 
-		if (mimops == 0) {
+		if (mimo_ps == IEEE80211_SMPS_STATIC) {
 			if (rssi_level == 1)
 				ratr_bitmap &= 0x00070000;
 			else if (rssi_level == 2)
@@ -1892,8 +1925,8 @@ void rtl92ce_update_hal_rate_mask(struct
 	}
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG,
 		 ("ratr_bitmap :%x\n", ratr_bitmap));
-	*(u32 *)&rate_mask = (ratr_bitmap & 0x0fffffff) |
-				       (ratr_index << 28);
+	*(u32 *)&rate_mask = EF4BYTE((ratr_bitmap & 0x0fffffff) |
+				     (ratr_index << 28));
 	rate_mask[4] = macid | (shortgi ? 0x20 : 0x00) | 0x80;
 	RT_TRACE(rtlpriv, COMP_RATR, DBG_DMESG, ("Rate_index:%x, "
 						 "ratr_val:%x, %x:%x:%x:%x:%x\n",
@@ -1902,6 +1935,20 @@ void rtl92ce_update_hal_rate_mask(struct
 						 rate_mask[2], rate_mask[3],
 						 rate_mask[4]));
 	rtl92c_fill_h2c_cmd(hw, H2C_RA_MASK, 5, rate_mask);
+
+	if (macid != 0)
+		sta_entry->ratr_index = ratr_index;
+}
+
+void rtl92ce_update_hal_rate_tbl(struct ieee80211_hw *hw,
+		struct ieee80211_sta *sta, u8 rssi_level)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	if (rtlpriv->dm.useramask)
+		rtl92ce_update_hal_rate_mask(hw, sta, rssi_level);
+	else
+		rtl92ce_update_hal_rate_table(hw, sta);
 }
 
 void rtl92ce_update_channel_access_setting(struct ieee80211_hw *hw)
@@ -1919,7 +1966,7 @@ void rtl92ce_update_channel_access_setti
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_SIFS, (u8 *)&sifs_timer);
 }
 
-bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid)
+bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -1929,7 +1976,7 @@ bool rtl92ce_gpio_radio_on_off_checking(
 	bool actuallyset = false;
 	unsigned long flag;
 
-	if ((rtlpci->up_first_time == 1) || (rtlpci->being_init_adapter))
+	if (rtlpci->being_init_adapter)
 		return false;
 
 	if (ppsc->swrf_processing)
@@ -1946,12 +1993,6 @@ bool rtl92ce_gpio_radio_on_off_checking(
 
 	cur_rfstate = ppsc->rfpwr_state;
 
-	if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-	    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM)) {
-		rtlpriv->intf_ops->disable_aspm(hw);
-		RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-	}
-
 	rtl_write_byte(rtlpriv, REG_MAC_PINMUX_CFG, rtl_read_byte(rtlpriv,
 		       REG_MAC_PINMUX_CFG)&~(BIT(3)));
 
@@ -1976,38 +2017,13 @@ bool rtl92ce_gpio_radio_on_off_checking(
 	}
 
 	if (actuallyset) {
-		if (e_rfpowerstate_toset == ERFON) {
-			if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
-			    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM)) {
-				rtlpriv->intf_ops->disable_aspm(hw);
-				RT_CLEAR_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-			}
-		}
-
 		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
 		ppsc->rfchange_inprogress = false;
 		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
-
-		if (e_rfpowerstate_toset == ERFOFF) {
-			if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) {
-				rtlpriv->intf_ops->enable_aspm(hw);
-				RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-			}
-		}
-
-	} else if (e_rfpowerstate_toset == ERFOFF || cur_rfstate == ERFOFF) {
+	} else {
 		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_HALT_NIC)
 			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
 
-		if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) {
-			rtlpriv->intf_ops->enable_aspm(hw);
-			RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_ASPM);
-		}
-
-		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
-		ppsc->rfchange_inprogress = false;
-		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
-	} else {
 		spin_lock_irqsave(&rtlpriv->locks.rf_ps_lock, flag);
 		ppsc->rfchange_inprogress = false;
 		spin_unlock_irqrestore(&rtlpriv->locks.rf_ps_lock, flag);
@@ -2086,15 +2102,31 @@ void rtl92ce_set_key(struct ieee80211_hw
 				macaddr = cam_const_broad;
 				entry_id = key_index;
 			} else {
+				if (mac->opmode == NL80211_IFTYPE_AP) {
+					entry_id = rtl_cam_get_free_entry(hw,
+								 p_macaddr);
+					if (entry_id >=  TOTAL_CAM_ENTRY) {
+						RT_TRACE(rtlpriv, COMP_SEC,
+						     DBG_EMERG,
+						     ("Can not find free hw"
+						     " security cam entry\n"));
+						return;
+					}
+				} else {
+					entry_id = CAM_PAIRWISE_KEY_POSITION;
+				}
+
 				key_index = PAIRWISE_KEYIDX;
-				entry_id = CAM_PAIRWISE_KEY_POSITION;
 				is_pairwise = true;
 			}
 		}
 
 		if (rtlpriv->sec.key_len[key_index] == 0) {
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
-				 ("delete one entry\n"));
+				 ("delete one entry, entry_id is %d\n",
+				 entry_id));
+			if (mac->opmode == NL80211_IFTYPE_AP)
+				rtl_cam_del_entry(hw, p_macaddr);
 			rtl_cam_delete_one_entry(hw, p_macaddr, entry_id);
 		} else {
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_LOUD,
@@ -2146,3 +2178,133 @@ void rtl92ce_set_key(struct ieee80211_hw
 		}
 	}
 }
+
+void rtl8192ce_bt_var_init(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	rtlpcipriv->bt_coexist.bt_coexistence =
+			rtlpcipriv->bt_coexist.eeprom_bt_coexist;
+	rtlpcipriv->bt_coexist.bt_ant_num =
+			rtlpcipriv->bt_coexist.eeprom_bt_ant_num;
+	rtlpcipriv->bt_coexist.bt_coexist_type =
+			rtlpcipriv->bt_coexist.eeprom_bt_type;
+
+	if (rtlpcipriv->bt_coexist.reg_bt_iso == 2)
+		rtlpcipriv->bt_coexist.bt_ant_isolation =
+			rtlpcipriv->bt_coexist.eeprom_bt_ant_isolation;
+	else
+		rtlpcipriv->bt_coexist.bt_ant_isolation =
+			rtlpcipriv->bt_coexist.reg_bt_iso;
+
+	rtlpcipriv->bt_coexist.bt_radio_shared_type =
+			rtlpcipriv->bt_coexist.eeprom_bt_radio_shared;
+
+	if (rtlpcipriv->bt_coexist.bt_coexistence) {
+
+		if (rtlpcipriv->bt_coexist.reg_bt_sco == 1)
+			rtlpcipriv->bt_coexist.bt_service = BT_OTHER_ACTION;
+		else if (rtlpcipriv->bt_coexist.reg_bt_sco == 2)
+			rtlpcipriv->bt_coexist.bt_service = BT_SCO;
+		else if (rtlpcipriv->bt_coexist.reg_bt_sco == 4)
+			rtlpcipriv->bt_coexist.bt_service = BT_BUSY;
+		else if (rtlpcipriv->bt_coexist.reg_bt_sco == 5)
+			rtlpcipriv->bt_coexist.bt_service = BT_OTHERBUSY;
+		else
+			rtlpcipriv->bt_coexist.bt_service = BT_IDLE;
+
+		rtlpcipriv->bt_coexist.bt_edca_ul = 0;
+		rtlpcipriv->bt_coexist.bt_edca_dl = 0;
+		rtlpcipriv->bt_coexist.bt_rssi_state = 0xff;
+	}
+}
+
+void rtl8192ce_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
+					      bool auto_load_fail, u8 *hwinfo)
+{
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+	u8 value;
+
+	if (!auto_load_fail) {
+		rtlpcipriv->bt_coexist.eeprom_bt_coexist =
+					((hwinfo[RF_OPTION1] & 0xe0) >> 5);
+		value = hwinfo[RF_OPTION4];
+		rtlpcipriv->bt_coexist.eeprom_bt_type = ((value & 0xe) >> 1);
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_num = (value & 0x1);
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_isolation =
+							 ((value & 0x10) >> 4);
+		rtlpcipriv->bt_coexist.eeprom_bt_radio_shared =
+							 ((value & 0x20) >> 5);
+	} else {
+		rtlpcipriv->bt_coexist.eeprom_bt_coexist = 0;
+		rtlpcipriv->bt_coexist.eeprom_bt_type = BT_2WIRE;
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_num = ANT_X2;
+		rtlpcipriv->bt_coexist.eeprom_bt_ant_isolation = 0;
+		rtlpcipriv->bt_coexist.eeprom_bt_radio_shared = BT_RADIO_SHARED;
+	}
+
+	rtl8192ce_bt_var_init(hw);
+}
+
+void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw)
+{
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	/* 0:Low, 1:High, 2:From Efuse. */
+	rtlpcipriv->bt_coexist.reg_bt_iso = 2;
+	/* 0:Idle, 1:None-SCO, 2:SCO, 3:From Counter. */
+	rtlpcipriv->bt_coexist.reg_bt_sco = 3;
+	/* 0:Disable BT control A-MPDU, 1:Enable BT control A-MPDU. */
+	rtlpcipriv->bt_coexist.reg_bt_sco = 0;
+}
+
+
+void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_pci_priv *rtlpcipriv = rtl_pcipriv(hw);
+
+	u8 u1_tmp;
+
+	if (rtlpcipriv->bt_coexist.bt_coexistence &&
+	    ((rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC4) ||
+	      rtlpcipriv->bt_coexist.bt_coexist_type == BT_CSR_BC8)) {
+
+		if (rtlpcipriv->bt_coexist.bt_ant_isolation)
+			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
+
+		u1_tmp = rtl_read_byte(rtlpriv, 0x4fd) &
+			 BIT_OFFSET_LEN_MASK_32(0, 1);
+		u1_tmp = u1_tmp |
+			 ((rtlpcipriv->bt_coexist.bt_ant_isolation == 1) ?
+			 0 : BIT_OFFSET_LEN_MASK_32(1, 1)) |
+			 ((rtlpcipriv->bt_coexist.bt_service == BT_SCO) ?
+			 0 : BIT_OFFSET_LEN_MASK_32(2, 1));
+		rtl_write_byte(rtlpriv, 0x4fd, u1_tmp);
+
+		rtl_write_dword(rtlpriv, REG_BT_COEX_TABLE+4, 0xaaaa9aaa);
+		rtl_write_dword(rtlpriv, REG_BT_COEX_TABLE+8, 0xffbd0040);
+		rtl_write_dword(rtlpriv, REG_BT_COEX_TABLE+0xc, 0x40000010);
+
+		/* Config to 1T1R. */
+		if (rtlphy->rf_type == RF_1T1R) {
+			u1_tmp = rtl_read_byte(rtlpriv, ROFDM0_TRXPATHENABLE);
+			u1_tmp &= ~(BIT_OFFSET_LEN_MASK_32(1, 1));
+			rtl_write_byte(rtlpriv, ROFDM0_TRXPATHENABLE, u1_tmp);
+
+			u1_tmp = rtl_read_byte(rtlpriv, ROFDM1_TRXPATHENABLE);
+			u1_tmp &= ~(BIT_OFFSET_LEN_MASK_32(1, 1));
+			rtl_write_byte(rtlpriv, ROFDM1_TRXPATHENABLE, u1_tmp);
+		}
+	}
+}
+
+void rtl92ce_suspend(struct ieee80211_hw *hw)
+{
+}
+
+void rtl92ce_resume(struct ieee80211_hw *hw)
+{
+}
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
@@ -30,7 +30,18 @@
 #ifndef __RTL92CE_HW_H__
 #define __RTL92CE_HW_H__
 
-#define H2C_RA_MASK	6
+static inline u8 _rtl92c_get_chnl_group(u8 chnl)
+{
+	u8 group;
+
+	if (chnl < 3)
+		group = 0;
+	else if (chnl < 9)
+		group = 1;
+	else
+		group = 2;
+	return group;
+}
 
 void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92ce_read_eeprom_info(struct ieee80211_hw *hw);
@@ -41,28 +52,28 @@ void rtl92ce_card_disable(struct ieee802
 void rtl92ce_enable_interrupt(struct ieee80211_hw *hw);
 void rtl92ce_disable_interrupt(struct ieee80211_hw *hw);
 int rtl92ce_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type);
+void rtl92ce_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
 void rtl92ce_set_qos(struct ieee80211_hw *hw, int aci);
 void rtl92ce_set_beacon_related_registers(struct ieee80211_hw *hw);
 void rtl92ce_set_beacon_interval(struct ieee80211_hw *hw);
 void rtl92ce_update_interrupt_mask(struct ieee80211_hw *hw,
 				   u32 add_msr, u32 rm_msr);
 void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
-void rtl92ce_update_hal_rate_table(struct ieee80211_hw *hw);
-void rtl92ce_update_hal_rate_mask(struct ieee80211_hw *hw, u8 rssi_level);
+void rtl92ce_update_hal_rate_tbl(struct ieee80211_hw *hw,
+				 struct ieee80211_sta *sta, u8 rssi_level);
 void rtl92ce_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92ce_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 *valid);
 void rtl92ce_enable_hw_security_config(struct ieee80211_hw *hw);
 void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 		     u8 *p_macaddr, bool is_group, u8 enc_algo,
 		     bool is_wepkey, bool clear_all);
-bool _rtl92ce_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
-void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
-void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
-void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
-int rtl92c_download_fw(struct ieee80211_hw *hw);
-void rtl92c_firmware_selfreset(struct ieee80211_hw *hw);
-void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
-			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer);
-bool rtl92ce_phy_mac_config(struct ieee80211_hw *hw);
+
+void rtl8192ce_read_bt_coexist_info_from_hwpg(struct ieee80211_hw *hw,
+			bool autoload_fail, u8 *hwinfo);
+void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw);
+void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw);
+void rtl92ce_suspend(struct ieee80211_hw *hw);
+void rtl92ce_resume(struct ieee80211_hw *hw);
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -112,10 +112,12 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.update_interrupt_mask = rtl92ce_update_interrupt_mask,
 	.get_hw_reg = rtl92ce_get_hw_reg,
 	.set_hw_reg = rtl92ce_set_hw_reg,
+#if 0	/* temporary */
 	.update_rate_table = rtl92ce_update_hal_rate_table,
 	.update_rate_mask = rtl92ce_update_hal_rate_mask,
 	.fill_tx_desc = rtl92ce_tx_fill_desc,
 	.fill_tx_cmddesc = rtl92ce_tx_fill_cmddesc,
+#endif
 	.query_rx_desc = rtl92ce_rx_query_desc,
 	.set_channel_access = rtl92ce_update_channel_access_setting,
 	.radio_onoff_checking = rtl92ce_gpio_radio_on_off_checking,
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -42,6 +42,7 @@
 #include "trx.h"
 #include "led.h"
 #include "table.h"
+#include "../rtl8192ce/hw.h"
 
 static void _rtl92cu_phy_param_tab_init(struct ieee80211_hw *hw)
 {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -104,7 +104,7 @@ void rtl92cu_update_hal_rate_mask(struct
 void rtl92cu_update_channel_access_setting(struct ieee80211_hw *hw);
 bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid);
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
-u8 _rtl92c_get_chnl_group(u8 chnl);
+static u8 _rtl92c_get_chnl_group(u8 chnl);
 int rtl92c_download_fw(struct ieee80211_hw *hw);
 void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
 void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished);
