Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36633 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1DYRzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 13:55:35 -0400
Date: Mon, 25 Apr 2011 12:54:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/18] rtlwifi: rtl8192ce: Change phy and rc routines for
 addition of rtl8192se and rtl8192de
Message-ID: <4db5b538.QuYyvSfDdCbuxtTP%Larry.Finger@lwfinger.net> (sfid-20110425_195538_596248_1814387B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaoming_Li <chaoming_li@realsil.com.cn>

Change rtl8192ce routines phy and rc for addition of RTL8192SE and
RTL8192DE.

Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 phy.c |  192 ++++++++++++++++++++++++++++++++++++++----------------------------
 phy.h |   52 +++++++++--------
 rf.c  |   25 ++++----
 rf.h  |   18 ++----
 4 files changed, 161 insertions(+), 126 deletions(-)
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -38,7 +38,9 @@
 #include "dm.h"
 #include "table.h"
 
-u32 rtl92ce_phy_query_rf_reg(struct ieee80211_hw *hw,
+static bool _rtl92c_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
+
+u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 			    enum radio_path rfpath, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -73,9 +75,47 @@ u32 rtl92ce_phy_query_rf_reg(struct ieee
 	return readback_value;
 }
 
+bool rtl92c_phy_mac_config(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	bool is92c = IS_92C_SERIAL(rtlhal->version);
+	bool rtstatus = _rtl92c_phy_config_mac_with_headerfile(hw);
+
+	if (is92c)
+		rtl_write_byte(rtlpriv, 0x14, 0x71);
+	return rtstatus;
+}
+
+bool rtl92c_phy_bb_config(struct ieee80211_hw *hw)
+{
+	bool rtstatus = true;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u16 regval;
+	u32 regvaldw;
+	u8 reg_hwparafile = 1;
+
+	_rtl92c_phy_init_bb_rf_register_definition(hw);
+	regval = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
+	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN,
+		       regval | BIT(13) | BIT(0) | BIT(1));
+	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL, 0x83);
+	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL + 1, 0xdb);
+	rtl_write_byte(rtlpriv, REG_RF_CTRL, RF_EN | RF_RSTB | RF_SDMRSTB);
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN,
+		       FEN_PPLL | FEN_PCIEA | FEN_DIO_PCIE |
+		       FEN_BB_GLB_RSTn | FEN_BBRSTB);
+	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL + 1, 0x80);
+	regvaldw = rtl_read_dword(rtlpriv, REG_LEDCFG0);
+	rtl_write_dword(rtlpriv, REG_LEDCFG0, regvaldw | BIT(23));
+	if (reg_hwparafile == 1)
+		rtstatus = _rtl92c_phy_bb8192c_config_parafile(hw);
+	return rtstatus;
+}
+
 void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
-			   enum radio_path rfpath,
-			   u32 regaddr, u32 bitmask, u32 data)
+			    enum radio_path rfpath,
+			    u32 regaddr, u32 bitmask, u32 data)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -121,45 +161,7 @@ void rtl92ce_phy_set_rf_reg(struct ieee8
 					       bitmask, data, rfpath));
 }
 
-bool rtl92ce_phy_mac_config(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	bool is92c = IS_92C_SERIAL(rtlhal->version);
-	bool rtstatus = _rtl92ce_phy_config_mac_with_headerfile(hw);
-
-	if (is92c)
-		rtl_write_byte(rtlpriv, 0x14, 0x71);
-	return rtstatus;
-}
-
-bool rtl92ce_phy_bb_config(struct ieee80211_hw *hw)
-{
-	bool rtstatus = true;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u16 regval;
-	u32 regvaldw;
-	u8 reg_hwparafile = 1;
-
-	_rtl92c_phy_init_bb_rf_register_definition(hw);
-	regval = rtl_read_word(rtlpriv, REG_SYS_FUNC_EN);
-	rtl_write_word(rtlpriv, REG_SYS_FUNC_EN,
-		       regval | BIT(13) | BIT(0) | BIT(1));
-	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL, 0x83);
-	rtl_write_byte(rtlpriv, REG_AFE_PLL_CTRL + 1, 0xdb);
-	rtl_write_byte(rtlpriv, REG_RF_CTRL, RF_EN | RF_RSTB | RF_SDMRSTB);
-	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN,
-		       FEN_PPLL | FEN_PCIEA | FEN_DIO_PCIE |
-		       FEN_BB_GLB_RSTn | FEN_BBRSTB);
-	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL + 1, 0x80);
-	regvaldw = rtl_read_dword(rtlpriv, REG_LEDCFG0);
-	rtl_write_dword(rtlpriv, REG_LEDCFG0, regvaldw | BIT(23));
-	if (reg_hwparafile == 1)
-		rtstatus = _rtl92c_phy_bb8192c_config_parafile(hw);
-	return rtstatus;
-}
-
-bool _rtl92ce_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
+static bool _rtl92c_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 i;
@@ -177,7 +179,7 @@ bool _rtl92ce_phy_config_mac_with_header
 }
 
 bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
-						  u8 configtype)
+					    u8 configtype)
 {
 	int i;
 	u32 *phy_regarray_table;
@@ -236,7 +238,7 @@ bool _rtl92ce_phy_config_bb_with_headerf
 }
 
 bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
-						    u8 configtype)
+					      u8 configtype)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	int i;
@@ -274,7 +276,7 @@ bool _rtl92ce_phy_config_bb_with_pgheade
 	return true;
 }
 
-bool rtl92ce_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
+bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath)
 {
 
@@ -364,7 +366,7 @@ bool rtl92ce_phy_config_rf_with_headerfi
 	return true;
 }
 
-void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
+static void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -378,8 +380,10 @@ void rtl92ce_phy_set_bw_mode_callback(st
 		  rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ?
 		  "20MHz" : "40MHz"))
 
-	    if (is_hal_stop(rtlhal))
+	if (is_hal_stop(rtlhal)) {
+		rtlphy->set_bwmode_inprogress = false;
 		return;
+	}
 
 	reg_bw_opmode = rtl_read_byte(rtlpriv, REG_BWOPMODE);
 	reg_prsr_rsc = rtl_read_byte(rtlpriv, REG_RRSR + 2);
@@ -389,16 +393,13 @@ void rtl92ce_phy_set_bw_mode_callback(st
 		reg_bw_opmode |= BW_OPMODE_20MHZ;
 		rtl_write_byte(rtlpriv, REG_BWOPMODE, reg_bw_opmode);
 		break;
-
 	case HT_CHANNEL_WIDTH_20_40:
 		reg_bw_opmode &= ~BW_OPMODE_20MHZ;
 		rtl_write_byte(rtlpriv, REG_BWOPMODE, reg_bw_opmode);
-
 		reg_prsr_rsc =
 		    (reg_prsr_rsc & 0x90) | (mac->cur_40_prime_sc << 5);
 		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
 		break;
-
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
 			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
@@ -414,10 +415,12 @@ void rtl92ce_phy_set_bw_mode_callback(st
 	case HT_CHANNEL_WIDTH_20_40:
 		rtl_set_bbreg(hw, RFPGA0_RFMOD, BRFMOD, 0x1);
 		rtl_set_bbreg(hw, RFPGA1_RFMOD, BRFMOD, 0x1);
+
 		rtl_set_bbreg(hw, RCCK0_SYSTEM, BCCK_SIDEBAND,
 			      (mac->cur_40_prime_sc >> 1));
 		rtl_set_bbreg(hw, ROFDM1_LSTF, 0xC00, mac->cur_40_prime_sc);
 		rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER2, BIT(10), 0);
+
 		rtl_set_bbreg(hw, 0x818, (BIT(26) | BIT(27)),
 			      (mac->cur_40_prime_sc ==
 			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
@@ -427,11 +430,34 @@ void rtl92ce_phy_set_bw_mode_callback(st
 			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
 		break;
 	}
-	rtl92c_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
+#if 0	/* temporary */
+	rtl92ce_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
+#endif
 	rtlphy->set_bwmode_inprogress = false;
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
 }
 
+void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
+			    enum nl80211_channel_type ch_type)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u8 tmp_bw = rtlphy->current_chan_bw;
+
+	if (rtlphy->set_bwmode_inprogress)
+		return;
+	rtlphy->set_bwmode_inprogress = true;
+	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
+		rtl92c_phy_set_bw_mode_callback(hw);
+	} else {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+			 ("FALSE driver sleep or unload\n"));
+		rtlphy->set_bwmode_inprogress = false;
+		rtlphy->current_chan_bw = tmp_bw;
+	}
+}
+
 void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 {
 	u8 tmpreg;
@@ -477,6 +503,36 @@ void _rtl92ce_phy_lc_calibrate(struct ie
 	}
 }
 
+static void _rtl92ce_phy_set_rf_sleep(struct ieee80211_hw *hw)
+{
+	u32 u4b_tmp;
+	u8 delay = 5;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0xFF);
+	rtl_set_rfreg(hw, RF90_PATH_A, 0x00, RFREG_OFFSET_MASK, 0x00);
+	rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
+	u4b_tmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, RFREG_OFFSET_MASK);
+	while (u4b_tmp != 0 && delay > 0) {
+		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x0);
+		rtl_set_rfreg(hw, RF90_PATH_A, 0x00, RFREG_OFFSET_MASK, 0x00);
+		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x40);
+		u4b_tmp = rtl_get_rfreg(hw, RF90_PATH_A, 0, RFREG_OFFSET_MASK);
+		delay--;
+	}
+	if (delay == 0) {
+		rtl_write_byte(rtlpriv, REG_APSD_CTRL, 0x00);
+		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE2);
+		rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE3);
+		rtl_write_byte(rtlpriv, REG_TXPAUSE, 0x00);
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_TRACE,
+			 ("Switch RF timeout !!!.\n"));
+		return;
+	}
+	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE2);
+	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x22);
+}
+
 static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					    enum rf_pwrstate rfpwr_state)
 {
@@ -523,33 +579,6 @@ static bool _rtl92ce_phy_set_rf_power_st
 			break;
 		}
 	case ERFOFF:{
-			for (queue_id = 0, i = 0;
-			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
-				ring = &pcipriv->dev.tx_ring[queue_id];
-				if (skb_queue_len(&ring->queue) == 0 ||
-				    queue_id == BEACON_QUEUE) {
-					queue_id++;
-					continue;
-				} else {
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-						 ("eRf Off/Sleep: %d times "
-						  "TcbBusyQueue[%d] "
-						  "=%d before doze!\n", (i + 1),
-						  queue_id,
-						  skb_queue_len(&ring->queue)));
-					udelay(10);
-					i++;
-				}
-				if (i >= MAX_DOZE_WAITING_TIMES_9x) {
-					RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-						 ("\nERFOFF: %d times "
-						  "TcbBusyQueue[%d] = %d !\n",
-						  MAX_DOZE_WAITING_TIMES_9x,
-						  queue_id,
-						  skb_queue_len(&ring->queue)));
-					break;
-				}
-			}
 			if (ppsc->reg_rfps_level & RT_RF_OFF_LEVL_HALT_NIC) {
 				RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 					 ("IPS Set eRf nic disable\n"));
@@ -581,6 +610,7 @@ static bool _rtl92ce_phy_set_rf_power_st
 						  "TcbBusyQueue[%d] =%d before "
 						  "doze!\n", (i + 1), queue_id,
 						  skb_queue_len(&ring->queue)));
+
 					udelay(10);
 					i++;
 				}
@@ -599,7 +629,7 @@ static bool _rtl92ce_phy_set_rf_power_st
 				  jiffies_to_msecs(jiffies -
 						   ppsc->last_awake_jiffies)));
 			ppsc->last_sleep_jiffies = jiffies;
-			_rtl92c_phy_set_rf_sleep(hw);
+			_rtl92ce_phy_set_rf_sleep(hw);
 			break;
 		}
 	default:
@@ -614,10 +644,11 @@ static bool _rtl92ce_phy_set_rf_power_st
 	return bresult;
 }
 
-bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
+bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				   enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
 	bool bresult = false;
 
 	if (rfpwr_state == ppsc->rfpwr_state)
@@ -625,3 +656,4 @@ bool rtl92ce_phy_set_rf_power_state(stru
 	bresult = _rtl92ce_phy_set_rf_power_state(hw, rfpwr_state);
 	return bresult;
 }
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -39,6 +39,7 @@
 #define RT_CANNOT_IO(hw)		false
 #define HIGHPOWER_RADIOA_ARRAYLEN	22
 
+#define IQK_ADDA_REG_NUM		16
 #define MAX_TOLERANCE			5
 #define	IQK_DELAY_TIME			1
 
@@ -56,6 +57,8 @@
 #define IQK_ADDA_REG_NUM		16
 #define IQK_MAC_REG_NUM			4
 
+#define IQK_DELAY_TIME			1
+
 #define RF90_PATH_MAX			2
 
 #define CT_OFFSET_MAC_ADDR		0X16
@@ -76,7 +79,7 @@
 #define CT_OFFSET_CUSTOMER_ID		0x7F
 
 #define RTL92C_MAX_PATH_NUM		2
-#define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER	255
+
 enum swchnlcmd_id {
 	CMDID_END,
 	CMDID_SET_TXPOWEROWER_LEVEL,
@@ -184,43 +187,44 @@ struct tx_power_struct {
 	u32 mcs_original_offset[4][16];
 };
 
-extern u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw,
+bool rtl92c_phy_bb_config(struct ieee80211_hw *hw);
+u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw,
 				   u32 regaddr, u32 bitmask);
-extern void rtl92c_phy_set_bb_reg(struct ieee80211_hw *hw,
+void rtl92c_phy_set_bb_reg(struct ieee80211_hw *hw,
 				  u32 regaddr, u32 bitmask, u32 data);
-extern u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
+u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 				   enum radio_path rfpath, u32 regaddr,
 				   u32 bitmask);
 extern void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
-				  enum radio_path rfpath, u32 regaddr,
-				  u32 bitmask, u32 data);
-extern bool rtl92c_phy_mac_config(struct ieee80211_hw *hw);
+				   enum radio_path rfpath, u32 regaddr,
+				   u32 bitmask, u32 data);
+bool rtl92c_phy_mac_config(struct ieee80211_hw *hw);
 bool rtl92ce_phy_bb_config(struct ieee80211_hw *hw);
-extern bool rtl92c_phy_rf_config(struct ieee80211_hw *hw);
-extern bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
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
+void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t);
 void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
 bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath);
-extern bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
+bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
 					      u32 rfpath);
 bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
 bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
@@ -237,9 +241,6 @@ u32 _rtl92c_phy_calculate_bit_shift(u32
 void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 					enum radio_path rfpath, u32 offset,
 					u32 data);
-void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
-						   u32 regaddr, u32 bitmask,
-						   u32 data);
 void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
 					   enum radio_path rfpath, u32 offset,
 					   u32 data);
@@ -250,5 +251,8 @@ bool _rtl92ce_phy_config_mac_with_header
 void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
 bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw);
 void _rtl92c_phy_set_rf_sleep(struct ieee80211_hw *hw);
+bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
+				   enum rf_pwrstate rfpwr_state);
 
 #endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -34,9 +34,9 @@
 #include "rf.h"
 #include "dm.h"
 
-static bool _rtl92c_phy_rf6052_config_parafile(struct ieee80211_hw *hw);
+static bool _rtl92ce_phy_rf6052_config_parafile(struct ieee80211_hw *hw);
 
-void rtl92c_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
+void rtl92ce_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -62,7 +62,7 @@ void rtl92c_phy_rf6052_set_bandwidth(str
 }
 
 void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
-				       u8 *ppowerlevel)
+					u8 *ppowerlevel)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -128,8 +128,7 @@ void rtl92ce_phy_rf6052_set_cck_txpower(
 
 	tmpval = tx_agc[RF90_PATH_A] >> 8;
 
-	if (mac->mode == WIRELESS_MODE_B)
-		tmpval = tmpval & 0xff00ffff;
+	tmpval = tmpval & 0xff00ffff;
 
 	rtl_set_bbreg(hw, RTXAGC_B_CCK11_A_CCK2_11, 0xffffff00, tmpval);
 
@@ -440,16 +439,17 @@ bool rtl92ce_phy_rf6052_config(struct ie
 	else
 		rtlphy->num_total_rfpath = 2;
 
-	return _rtl92c_phy_rf6052_config_parafile(hw);
+	return _rtl92ce_phy_rf6052_config_parafile(hw);
+
 }
 
-static bool _rtl92c_phy_rf6052_config_parafile(struct ieee80211_hw *hw)
+static bool _rtl92ce_phy_rf6052_config_parafile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	u32 u4_regvalue = 0;
 	u8 rfpath;
-	bool rtstatus;
+	bool rtstatus = true;
 	struct bb_reg_def *pphyreg;
 
 	for (rfpath = 0; rfpath < rtlphy->num_total_rfpath; rfpath++) {
@@ -484,12 +484,12 @@ static bool _rtl92c_phy_rf6052_config_pa
 
 		switch (rfpath) {
 		case RF90_PATH_A:
-			rtstatus = rtl92ce_phy_config_rf_with_headerfile(hw,
-					(enum radio_path) rfpath);
+			rtstatus = rtl92c_phy_config_rf_with_headerfile(hw,
+						(enum radio_path)rfpath);
 			break;
 		case RF90_PATH_B:
-			rtstatus = rtl92ce_phy_config_rf_with_headerfile(hw,
-					(enum radio_path) rfpath);
+			rtstatus = rtl92c_phy_config_rf_with_headerfile(hw,
+						(enum radio_path)rfpath);
 			break;
 		case RF90_PATH_C:
 			break;
@@ -521,3 +521,4 @@ static bool _rtl92c_phy_rf6052_config_pa
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, ("<---\n"));
 	return rtstatus;
 }
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
@@ -34,14 +34,12 @@
 #define RF6052_MAX_REG			0x3F
 #define RF6052_MAX_PATH			2
 
-extern void rtl92c_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw,
-					    u8 bandwidth);
-extern void rtl92c_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
-					      u8 *ppowerlevel);
-extern void rtl92c_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
-					       u8 *ppowerlevel, u8 channel);
-bool rtl92ce_phy_rf6052_config(struct ieee80211_hw *hw);
-bool rtl92ce_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
-					  enum radio_path rfpath);
-
+extern void rtl92ce_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw,
+					     u8 bandwidth);
+extern void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+					       u8 *ppowerlevel);
+extern void rtl92ce_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+						u8 *ppowerlevel, u8 channel);
+extern bool rtl92ce_phy_rf6052_config(struct ieee80211_hw *hw);
 #endif
+
