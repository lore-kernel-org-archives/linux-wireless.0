Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756Ab1DYRxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:53:46 -0400
Date: Mon, 25 Apr 2011 12:53:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/18] rtlwifi: rtl8192c-common: Change common PHY
 routines for addition of rtl8192se and rtl8192de
Message-ID: <4db5b529.TWKGHjdAjKESYiWB%Larry.Finger@lwfinger.net> (sfid-20110425_195352_939687_3027CD87)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change common PHY routines for addition of RTL8192SE and RTL8192DE code.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 phy_common.c |  121 +++++++++++++++++++++++++++--------------------------------
 phy_common.h |   62 ++++++++++++++----------------
 2 files changed, 87 insertions(+), 96 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -78,18 +78,20 @@ void rtl92c_phy_set_bb_reg(struct ieee80
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), bitmask(%#x),"
 					       " data(%#x)\n", regaddr, bitmask,
 					       data));
+
 }
 EXPORT_SYMBOL(rtl92c_phy_set_bb_reg);
 
-u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
+static u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset)
 {
 	RT_ASSERT(false, ("deprecated!\n"));
 	return 0;
+
 }
 EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_read);
 
-void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
+static void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
 					   enum radio_path rfpath, u32 offset,
 					   u32 data)
 {
@@ -97,7 +99,7 @@ void _rtl92c_phy_fw_rf_serial_write(stru
 }
 EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_write);
 
-u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
+static u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
 				      enum radio_path rfpath, u32 offset)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -148,7 +150,7 @@ u32 _rtl92c_phy_rf_serial_read(struct ie
 }
 EXPORT_SYMBOL(_rtl92c_phy_rf_serial_read);
 
-void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
+static void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 					enum radio_path rfpath, u32 offset,
 					u32 data)
 {
@@ -197,6 +199,7 @@ static void _rtl92c_phy_bb_config_1t(str
 	rtl_set_bbreg(hw, 0xe80, 0x0c000000, 0x2);
 	rtl_set_bbreg(hw, 0xe88, 0x0c000000, 0x2);
 }
+
 bool rtl92c_phy_rf_config(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -205,7 +208,7 @@ bool rtl92c_phy_rf_config(struct ieee802
 }
 EXPORT_SYMBOL(rtl92c_phy_rf_config);
 
-bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
+static bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -241,6 +244,7 @@ bool _rtl92c_phy_bb8192c_config_parafile
 	rtlphy->cck_high_power = (bool) (rtl_get_bbreg(hw,
 						RFPGA0_XA_HSSIPARAMETER2,
 						0x200));
+
 	return true;
 }
 EXPORT_SYMBOL(_rtl92c_phy_bb8192c_config_parafile);
@@ -317,61 +321,48 @@ void _rtl92c_store_pwrIndex_diffrate_off
 	}
 	if (regaddr == RTXAGC_B_RATE54_24) {
 		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][9] = data;
-
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][9] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
 			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][9]));
 	}
-
 	if (regaddr == RTXAGC_B_CCK1_55_MCS32) {
 		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][14] = data;
-
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][14] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
 			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][14]));
 	}
-
 	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff) {
 		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][15] = data;
-
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][15] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
 			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][15]));
 	}
-
 	if (regaddr == RTXAGC_B_MCS03_MCS00) {
 		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][10] = data;
-
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][10] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
 			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][10]));
 	}
-
 	if (regaddr == RTXAGC_B_MCS07_MCS04) {
 		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][11] = data;
-
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][11] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
 			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][11]));
 	}
-
 	if (regaddr == RTXAGC_B_MCS11_MCS08) {
 		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][12] = data;
-
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][12] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
 			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][12]));
 	}
-
 	if (regaddr == RTXAGC_B_MCS15_MCS12) {
 		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][13] = data;
-
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][13] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
@@ -583,6 +574,7 @@ static void _rtl92c_ccxpower_index_check
 
 	rtlphy->cur_cck_txpwridx = cckpowerlevel[0];
 	rtlphy->cur_ofdm24g_txpwridx = ofdmpowerlevel[0];
+
 }
 
 void rtl92c_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel)
@@ -611,7 +603,6 @@ bool rtl92c_phy_update_txpower_dbm(struc
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u8 idx;
 	u8 rf_path;
-
 	u8 ccktxpwridx = _rtl92c_phy_dbm_to_txpwr_Idx(hw,
 						      WIRELESS_MODE_B,
 						      power_indbm);
@@ -639,11 +630,6 @@ bool rtl92c_phy_update_txpower_dbm(struc
 }
 EXPORT_SYMBOL(rtl92c_phy_update_txpower_dbm);
 
-void rtl92c_phy_set_beacon_hw_reg(struct ieee80211_hw *hw, u16 beaconinterval)
-{
-}
-EXPORT_SYMBOL(rtl92c_phy_set_beacon_hw_reg);
-
 u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
 				enum wireless_mode wirelessmode,
 				long power_indbm)
@@ -741,9 +727,9 @@ void rtl92c_phy_set_bw_mode(struct ieee8
 	if (rtlphy->set_bwmode_inprogress)
 		return;
 	rtlphy->set_bwmode_inprogress = true;
-	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw)))
-		rtlpriv->cfg->ops->phy_set_bw_mode_callback(hw);
-	else {
+	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
+		rtlphy->set_bwmode_inprogress = false;
+	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("FALSE driver sleep or unload\n"));
 		rtlphy->set_bwmode_inprogress = false;
@@ -773,8 +759,9 @@ void rtl92c_phy_sw_chnl_callback(struct
 				mdelay(delay);
 			else
 				continue;
-		} else
+		} else {
 			rtlphy->sw_chnl_inprogress = false;
+		}
 		break;
 	} while (true);
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
@@ -811,9 +798,32 @@ u8 rtl92c_phy_sw_chnl(struct ieee80211_h
 }
 EXPORT_SYMBOL(rtl92c_phy_sw_chnl);
 
-static bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
-					     u8 channel, u8 *stage, u8 *step,
-					     u32 *delay)
+static bool _rtl92c_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
+					     u32 cmdtableidx, u32 cmdtablesz,
+					     enum swchnlcmd_id cmdid,
+					     u32 para1, u32 para2, u32 msdelay)
+{
+	struct swchnlcmd *pcmd;
+
+	if (cmdtable == NULL) {
+		RT_ASSERT(false, ("cmdtable cannot be NULL.\n"));
+		return false;
+	}
+
+	if (cmdtableidx >= cmdtablesz)
+		return false;
+
+	pcmd = cmdtable + cmdtableidx;
+	pcmd->cmdid = cmdid;
+	pcmd->para1 = para1;
+	pcmd->para2 = para2;
+	pcmd->msdelay = msdelay;
+	return true;
+}
+
+bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
+				      u8 channel, u8 *stage, u8 *step,
+				      u32 *delay)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -917,29 +927,6 @@ static bool _rtl92c_phy_sw_chnl_step_by_
 	return false;
 }
 
-static bool _rtl92c_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
-					     u32 cmdtableidx, u32 cmdtablesz,
-					     enum swchnlcmd_id cmdid,
-					     u32 para1, u32 para2, u32 msdelay)
-{
-	struct swchnlcmd *pcmd;
-
-	if (cmdtable == NULL) {
-		RT_ASSERT(false, ("cmdtable cannot be NULL.\n"));
-		return false;
-	}
-
-	if (cmdtableidx >= cmdtablesz)
-		return false;
-
-	pcmd = cmdtable + cmdtableidx;
-	pcmd->cmdid = cmdid;
-	pcmd->para1 = para1;
-	pcmd->para2 = para2;
-	pcmd->msdelay = msdelay;
-	return true;
-}
-
 bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw, u32 rfpath)
 {
 	return true;
@@ -1002,13 +989,13 @@ static u8 _rtl92c_phy_path_b_iqk(struct
 	reg_ebc = rtl_get_bbreg(hw, 0xebc, MASKDWORD);
 	reg_ec4 = rtl_get_bbreg(hw, 0xec4, MASKDWORD);
 	reg_ecc = rtl_get_bbreg(hw, 0xecc, MASKDWORD);
+
 	if (!(reg_eac & BIT(31)) &&
 	    (((reg_eb4 & 0x03FF0000) >> 16) != 0x142) &&
 	    (((reg_ebc & 0x03FF0000) >> 16) != 0x42))
 		result |= 0x01;
 	else
 		return result;
-
 	if (!(reg_eac & BIT(30)) &&
 	    (((reg_ec4 & 0x03FF0000) >> 16) != 0x132) &&
 	    (((reg_ecc & 0x03FF0000) >> 16) != 0x36))
@@ -1023,9 +1010,9 @@ static void _rtl92c_phy_path_a_fill_iqk_
 	u32 oldval_0, x, tx0_a, reg;
 	long y, tx0_c;
 
-	if (final_candidate == 0xFF)
+	if (final_candidate == 0xFF) {
 		return;
-	else if (iqk_ok) {
+	} else if (iqk_ok) {
 		oldval_0 = (rtl_get_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 					  MASKDWORD) >> 22) & 0x3FF;
 		x = result[final_candidate][0];
@@ -1063,9 +1050,9 @@ static void _rtl92c_phy_path_b_fill_iqk_
 	u32 oldval_1, x, tx1_a, reg;
 	long y, tx1_c;
 
-	if (final_candidate == 0xFF)
+	if (final_candidate == 0xFF) {
 		return;
-	else if (iqk_ok) {
+	} else if (iqk_ok) {
 		oldval_1 = (rtl_get_bbreg(hw, ROFDM0_XBTXIQIMBALANCE,
 					  MASKDWORD) >> 22) & 0x3FF;
 		x = result[final_candidate][4];
@@ -1282,6 +1269,7 @@ static void _rtl92c_phy_iq_calibrate(str
 						   RFPGA0_XA_HSSIPARAMETER1,
 						   BIT(8));
 	}
+
 	if (!rtlphy->rfpi_enable)
 		_rtl92c_phy_pi_mode_switch(hw, true);
 	if (t == 0) {
@@ -1317,9 +1305,10 @@ static void _rtl92c_phy_iq_calibrate(str
 					0x3FF0000) >> 16;
 			break;
 		} else if (i == (retrycount - 1) && patha_ok == 0x01)
+
 			result[t][0] = (rtl_get_bbreg(hw, 0xe94,
 						      MASKDWORD) & 0x3FF0000) >>
-						      16;
+			    16;
 		result[t][1] =
 		    (rtl_get_bbreg(hw, 0xe9c, MASKDWORD) & 0x3FF0000) >> 16;
 
@@ -1434,7 +1423,7 @@ static void _rtl92c_phy_ap_calibrate(str
 		0x04db25a4, 0x0b1b25a4
 	};
 
-	u32 apk_offset[PATH_NUM] = { 0xb68, 0xb6c };
+	const u32 apk_offset[PATH_NUM] = { 0xb68, 0xb6c };
 
 	u32 apk_normal_offset[PATH_NUM] = { 0xb28, 0xb98 };
 
@@ -1463,13 +1452,15 @@ static void _rtl92c_phy_ap_calibrate(str
 		0x00050006
 	};
 
-	const u32 apk_result[PATH_NUM][APK_BB_REG_NUM];
+	u32 apk_result[PATH_NUM][APK_BB_REG_NUM];
 
 	long bb_offset, delta_v, delta_offset;
 
 	if (!is2t)
 		pathbound = 1;
 
+	return;
+
 	for (index = 0; index < PATH_NUM; index++) {
 		apk_offset[index] = apk_normal_offset[index];
 		apk_value[index] = apk_normal_value[index];
@@ -1730,8 +1721,7 @@ static void _rtl92c_phy_ap_calibrate(str
 			       0x08));
 
 	}
-
-	rtlphy->apk_done = true;
+	rtlphy->b_apk_done = true;
 #endif
 }
 
@@ -1758,6 +1748,7 @@ static void _rtl92c_phy_set_rfpath_switc
 			rtl_set_bbreg(hw, RFPGA0_XA_RFINTERFACEOE, 0x300, 0x1);
 
 	}
+
 }
 
 #undef IQK_ADDA_REG_NUM
@@ -2040,3 +2031,5 @@ void _rtl92c_phy_set_rf_sleep(struct iee
 	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x22);
 }
 EXPORT_SYMBOL(_rtl92c_phy_set_rf_sleep);
+
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
@@ -27,8 +27,8 @@
  *
  *****************************************************************************/
 
-#ifndef __RTL92C_PHY_H__
-#define __RTL92C_PHY_H__
+#ifndef __RTL92C_PHY_COMMON_H__
+#define __RTL92C_PHY_COMMON_H__
 
 #define MAX_PRECMD_CNT			16
 #define MAX_RFDEPENDCMD_CNT		16
@@ -39,6 +39,7 @@
 #define RT_CANNOT_IO(hw)		false
 #define HIGHPOWER_RADIOA_ARRAYLEN	22
 
+#define IQK_ADDA_REG_NUM		16
 #define MAX_TOLERANCE			5
 #define	IQK_DELAY_TIME			1
 
@@ -56,6 +57,7 @@
 #define IQK_ADDA_REG_NUM		16
 #define IQK_MAC_REG_NUM			4
 
+#define IQK_DELAY_TIME			1
 #define RF90_PATH_MAX			2
 
 #define CT_OFFSET_MAC_ADDR		0X16
@@ -77,6 +79,7 @@
 
 #define RTL92C_MAX_PATH_NUM		2
 #define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER	255
+
 enum swchnlcmd_id {
 	CMDID_END,
 	CMDID_SET_TXPOWEROWER_LEVEL,
@@ -184,45 +187,41 @@ struct tx_power_struct {
 	u32 mcs_original_offset[4][16];
 };
 
-extern u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw,
+u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw,
 				   u32 regaddr, u32 bitmask);
-extern void rtl92c_phy_set_bb_reg(struct ieee80211_hw *hw,
+void rtl92c_phy_set_bb_reg(struct ieee80211_hw *hw,
 				  u32 regaddr, u32 bitmask, u32 data);
-extern u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
+u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 				   enum radio_path rfpath, u32 regaddr,
 				   u32 bitmask);
-extern void rtl92c_phy_set_rf_reg(struct ieee80211_hw *hw,
-				  enum radio_path rfpath, u32 regaddr,
-				  u32 bitmask, u32 data);
-extern bool rtl92c_phy_mac_config(struct ieee80211_hw *hw);
-extern bool rtl92c_phy_bb_config(struct ieee80211_hw *hw);
-extern bool rtl92c_phy_rf_config(struct ieee80211_hw *hw);
-extern bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
+bool rtl92c_phy_mac_config(struct ieee80211_hw *hw);
+bool rtl92c_phy_bb_config(struct ieee80211_hw *hw);
+bool rtl92c_phy_rf_config(struct ieee80211_hw *hw);
+bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
 						 enum radio_path rfpath);
-extern void rtl92c_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
-extern void rtl92c_phy_get_txpower_level(struct ieee80211_hw *hw,
+void rtl92c_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
+void rtl92c_phy_get_txpower_level(struct ieee80211_hw *hw,
 					 long *powerlevel);
-extern void rtl92c_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
-extern bool rtl92c_phy_update_txpower_dbm(struct ieee80211_hw *hw,
+void rtl92c_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
+bool rtl92c_phy_update_txpower_dbm(struct ieee80211_hw *hw,
 					  long power_indbm);
-extern void rtl92c_phy_scan_operation_backup(struct ieee80211_hw *hw,
+void rtl92c_phy_scan_operation_backup(struct ieee80211_hw *hw,
 					     u8 operation);
-extern void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
-extern void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
+void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
 				   enum nl80211_channel_type ch_type);
-extern void rtl92c_phy_sw_chnl_callback(struct ieee80211_hw *hw);
-extern u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw);
-extern void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
-extern void rtl92c_phy_set_beacon_hw_reg(struct ieee80211_hw *hw,
+void rtl92c_phy_sw_chnl_callback(struct ieee80211_hw *hw);
+u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw);
+void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
+void rtl92c_phy_set_beacon_hw_reg(struct ieee80211_hw *hw,
 					 u16 beaconinterval);
 void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta);
 void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
 void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
 bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath);
-extern bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
+bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
 					      u32 rfpath);
-extern bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
+bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  enum rf_pwrstate rfpwr_state);
 void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
 void rtl92c_phy_set_io(struct ieee80211_hw *hw);
@@ -235,12 +234,11 @@ u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct i
 				enum wireless_mode wirelessmode,
 				long power_indbm);
 void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
-static bool _rtl92c_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
-					     u32 cmdtableidx, u32 cmdtablesz,
-					     enum swchnlcmd_id cmdid, u32 para1,
-					     u32 para2, u32 msdelay);
-static bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
-					     u8 channel, u8 *stage, u8 *step,
-					     u32 *delay);
+void _rtl92c_phy_set_rf_sleep(struct ieee80211_hw *hw);
+bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
+				      u8 channel, u8 *stage, u8 *step,
+				      u32 *delay);
 
 #endif
+
+
