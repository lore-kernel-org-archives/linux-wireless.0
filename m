Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53184 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1BWQZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 11:25:00 -0500
Date: Wed, 23 Feb 2011 10:24:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, otavio@ossystems.com.br, w@1wt.eu,
	george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 5/5] rtlwifi: rtl8192ce: rtl8192cu: Fix multiple def
 errors for allyesconfig build
Message-ID: <4d6534da.+vQApn44+NCpSwY4%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As noted by Stephan Rothwell, an allyesconfig build fails since rtl8192cu
was merged with failures such as:

drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_phy_sw_chnl':
(.opd+0xf30): multiple definition of `rtl92c_phy_sw_chnl'
drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.opd+0xb70): first defined here
drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_fill_h2c_cmd':
(.opd+0x288): multiple definition of `rtl92c_fill_h2c_cmd'
drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.opd+0x288): first defined here

These are caused because the code shared between rtl8192ce and rtl8192cu
is included in both drivers. This has been fixed by creating a new modue that
contains the shared code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is quite large; however, most of it is the result of moving code
from one directory to another.

Larry
---

 drivers/net/wireless/rtlwifi/rtl8192ce/fw.c                         |  769 ---------
 drivers/net/wireless/rtlwifi/rtl8192ce/fw.h                         |   98 -
 drivers/net/wireless/rtlwifi/rtl8192cu/fw.c                         |   30 
 drivers/net/wireless/rtlwifi/rtl8192cu/fw.h                         |   30 
 wireless-testing/drivers/net/wireless/rtlwifi/Kconfig               |    7 
 wireless-testing/drivers/net/wireless/rtlwifi/Makefile              |    3 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/Makefile     |   10 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  |   12 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |  205 ++
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |  775 ++++++++++
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h  |   99 +
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/main.c       |   41 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |  126 -
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h |  247 +++
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile    |    1 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c        |    7 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h        |    2 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |    5 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h        |   11 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c       |   31 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h       |   28 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c        |   10 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h        |    5 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c        |   15 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h        |   12 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile    |    1 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c        |    5 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h        |    2 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c        |    7 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h        |    9 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c       |   38 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h       |    4 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |   12 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h        |   20 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   15 
 wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h        |   18 
 wireless-testing/drivers/net/wireless/rtlwifi/wifi.h                |   12 
 37 files changed, 1645 insertions(+), 1077 deletions(-)

Index: wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Kconfig
+++ wireless-testing/drivers/net/wireless/rtlwifi/Kconfig
@@ -3,6 +3,7 @@ config RTL8192CE
 	depends on MAC80211 && PCI && EXPERIMENTAL
 	select FW_LOADER
 	select RTLWIFI
+	select RTL8192C_COMMON
 	---help---
 	This is the driver for Realtek RTL8192CE/RTL8188CE 802.11n PCIe
 	wireless network adapters.
@@ -14,6 +15,7 @@ config RTL8192CU
 	depends on MAC80211 && USB && EXPERIMENTAL
 	select FW_LOADER
 	select RTLWIFI
+	select RTL8192C_COMMON
 	---help---
 	This is the driver for Realtek RTL8192CU/RTL8188CU 802.11n USB
 	wireless network adapters.
@@ -24,3 +26,8 @@ config RTLWIFI
 	tristate
 	depends on RTL8192CE || RTL8192CU
 	default m
+
+config RTL8192C_COMMON
+	tristate
+	depends on RTL8192CE || RTL8192CU
+	default m
Index: wireless-testing/drivers/net/wireless/rtlwifi/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/Makefile
@@ -10,10 +10,13 @@ rtlwifi-objs	:=		\
 		regd.o		\
 		usb.o
 
+rtl8192c_common-objs +=		\
+
 ifeq ($(CONFIG_PCI),y)
 rtlwifi-objs	+= pci.o
 endif
 
+obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
 
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/Makefile
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/Makefile
@@ -0,0 +1,10 @@
+rtl8192c-common-objs :=		\
+		main.o		\
+		dm_common.o	\
+		fw_common.o	\
+		phy_common.o
+
+obj-$(CONFIG_RTL8192C_COMMON) += rtl8192c-common.o
+
+ccflags-y += -D__CHECK_ENDIAN__
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/Makefile
@@ -1,6 +1,5 @@
 rtl8192ce-objs :=		\
 		dm.o		\
-		fw.o		\
 		hw.o		\
 		led.o		\
 		phy.o		\
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/Makefile
@@ -1,6 +1,5 @@
 rtl8192cu-objs :=		\
 		dm.o		\
-		fw.o		\
 		hw.o		\
 		led.o		\
 		mac.o		\
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -27,44 +27,15 @@
  *
  *****************************************************************************/
 
+#include "../wifi.h"
+#include "../rtl8192ce/reg.h"
+#include "../rtl8192ce/def.h"
+#include "dm_common.h"
+#include "phy_common.h"
+
 /* Define macro to shorten lines */
 #define MCS_TXPWR	mcs_txpwrlevel_origoffset
 
-static u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
-					 enum radio_path rfpath, u32 offset);
-static void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
-					   enum radio_path rfpath, u32 offset,
-					   u32 data);
-static u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
-				      enum radio_path rfpath, u32 offset);
-static void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
-					enum radio_path rfpath, u32 offset,
-					u32 data);
-static u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask);
-static bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw);
-static bool _rtl92c_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
-static bool _rtl92c_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
-						  u8 configtype);
-static bool _rtl92c_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
-						    u8 configtype);
-static void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
-static bool _rtl92c_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
-					     u32 cmdtableidx, u32 cmdtablesz,
-					     enum swchnlcmd_id cmdid, u32 para1,
-					     u32 para2, u32 msdelay);
-static bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
-					     u8 channel, u8 *stage, u8 *step,
-					     u32 *delay);
-static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
-				       enum wireless_mode wirelessmode,
-				       long power_indbm);
-static bool _rtl92c_phy_config_rf_external_pa(struct ieee80211_hw *hw,
-					      enum radio_path rfpath);
-static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
-					 enum wireless_mode wirelessmode,
-					 u8 txpwridx);
-static void _rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t);
-
 u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -84,6 +55,7 @@ u32 rtl92c_phy_query_bb_reg(struct ieee8
 	return returnvalue;
 
 }
+EXPORT_SYMBOL(rtl92c_phy_query_bb_reg);
 
 void rtl92c_phy_set_bb_reg(struct ieee80211_hw *hw,
 			   u32 regaddr, u32 bitmask, u32 data)
@@ -106,24 +78,26 @@ void rtl92c_phy_set_bb_reg(struct ieee80
 	RT_TRACE(rtlpriv, COMP_RF, DBG_TRACE, ("regaddr(%#x), bitmask(%#x),"
 					       " data(%#x)\n", regaddr, bitmask,
 					       data));
-
 }
+EXPORT_SYMBOL(rtl92c_phy_set_bb_reg);
 
-static u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
+u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset)
 {
 	RT_ASSERT(false, ("deprecated!\n"));
 	return 0;
 }
+EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_read);
 
-static void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
+void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
 					   enum radio_path rfpath, u32 offset,
 					   u32 data)
 {
 	RT_ASSERT(false, ("deprecated!\n"));
 }
+EXPORT_SYMBOL(_rtl92c_phy_fw_rf_serial_write);
 
-static u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
+u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
 				      enum radio_path rfpath, u32 offset)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -172,8 +146,9 @@ static u32 _rtl92c_phy_rf_serial_read(st
 					       retvalue));
 	return retvalue;
 }
+EXPORT_SYMBOL(_rtl92c_phy_rf_serial_read);
 
-static void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
+void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
 					enum radio_path rfpath, u32 offset,
 					u32 data)
 {
@@ -195,8 +170,9 @@ static void _rtl92c_phy_rf_serial_write(
 					       rfpath, pphyreg->rf3wire_offset,
 					       data_and_addr));
 }
+EXPORT_SYMBOL(_rtl92c_phy_rf_serial_write);
 
-static u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask)
+u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask)
 {
 	u32 i;
 
@@ -206,6 +182,7 @@ static u32 _rtl92c_phy_calculate_bit_shi
 	}
 	return i;
 }
+EXPORT_SYMBOL(_rtl92c_phy_calculate_bit_shift);
 
 static void _rtl92c_phy_bb_config_1t(struct ieee80211_hw *hw)
 {
@@ -222,10 +199,13 @@ static void _rtl92c_phy_bb_config_1t(str
 }
 bool rtl92c_phy_rf_config(struct ieee80211_hw *hw)
 {
-	return rtl92c_phy_rf6052_config(hw);
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	return rtlpriv->cfg->ops->phy_rf6052_config(hw);
 }
+EXPORT_SYMBOL(rtl92c_phy_rf_config);
 
-static bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
+bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -233,7 +213,7 @@ static bool _rtl92c_phy_bb8192c_config_p
 	bool rtstatus;
 
 	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE, ("==>\n"));
-	rtstatus = _rtl92c_phy_config_bb_with_headerfile(hw,
+	rtstatus = rtlpriv->cfg->ops->config_bb_with_headerfile(hw,
 						 BASEBAND_CONFIG_PHY_REG);
 	if (rtstatus != true) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("Write BB Reg Fail!!"));
@@ -245,14 +225,14 @@ static bool _rtl92c_phy_bb8192c_config_p
 	}
 	if (rtlefuse->autoload_failflag == false) {
 		rtlphy->pwrgroup_cnt = 0;
-		rtstatus = _rtl92c_phy_config_bb_with_pgheaderfile(hw,
+		rtstatus = rtlpriv->cfg->ops->config_bb_with_pgheaderfile(hw,
 						   BASEBAND_CONFIG_PHY_REG);
 	}
 	if (rtstatus != true) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("BB_PG Reg Fail!!"));
 		return false;
 	}
-	rtstatus = _rtl92c_phy_config_bb_with_headerfile(hw,
+	rtstatus = rtlpriv->cfg->ops->config_bb_with_headerfile(hw,
 						 BASEBAND_CONFIG_AGC_TAB);
 	if (rtstatus != true) {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ("AGC Table Fail\n"));
@@ -263,13 +243,9 @@ static bool _rtl92c_phy_bb8192c_config_p
 						0x200));
 	return true;
 }
+EXPORT_SYMBOL(_rtl92c_phy_bb8192c_config_parafile);
 
-
-void rtl92c_phy_config_bb_external_pa(struct ieee80211_hw *hw)
-{
-}
-
-static void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
 						   u32 regaddr, u32 bitmask,
 						   u32 data)
 {
@@ -404,12 +380,7 @@ static void _rtl92c_store_pwrIndex_diffr
 		rtlphy->pwrgroup_cnt++;
 	}
 }
-
-static bool _rtl92c_phy_config_rf_external_pa(struct ieee80211_hw *hw,
-					      enum radio_path rfpath)
-{
-	return true;
-}
+EXPORT_SYMBOL(_rtl92c_store_pwrIndex_diffrate_offset);
 
 void rtl92c_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
 {
@@ -443,7 +414,7 @@ void rtl92c_phy_get_hw_reg_originalvalue
 		  ROFDM0_RXDETECTOR3, rtlphy->framesync));
 }
 
-static void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw)
+void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -547,6 +518,7 @@ static void _rtl92c_phy_init_bb_rf_regis
 	    TRANSCEIVEB_HSPI_READBACK;
 
 }
+EXPORT_SYMBOL(_rtl92c_phy_init_bb_rf_register_definition);
 
 void rtl92c_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel)
 {
@@ -615,7 +587,8 @@ static void _rtl92c_ccxpower_index_check
 
 void rtl92c_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel)
 {
-	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_efuse *rtlefuse = rtl_efuse(rtlpriv);
 	u8 cckpowerlevel[2], ofdmpowerlevel[2];
 
 	if (rtlefuse->txpwr_fromeprom == false)
@@ -625,9 +598,11 @@ void rtl92c_phy_set_txpower_level(struct
 	_rtl92c_ccxpower_index_check(hw,
 				     channel, &cckpowerlevel[0],
 				     &ofdmpowerlevel[0]);
-	rtl92c_phy_rf6052_set_cck_txpower(hw, &cckpowerlevel[0]);
-	rtl92c_phy_rf6052_set_ofdm_txpower(hw, &ofdmpowerlevel[0], channel);
+	rtlpriv->cfg->ops->phy_rf6052_set_cck_txpower(hw, &cckpowerlevel[0]);
+	rtlpriv->cfg->ops->phy_rf6052_set_ofdm_txpower(hw, &ofdmpowerlevel[0],
+						       channel);
 }
+EXPORT_SYMBOL(rtl92c_phy_set_txpower_level);
 
 bool rtl92c_phy_update_txpower_dbm(struct ieee80211_hw *hw, long power_indbm)
 {
@@ -662,10 +637,12 @@ bool rtl92c_phy_update_txpower_dbm(struc
 	rtl92c_phy_set_txpower_level(hw, rtlphy->current_channel);
 	return true;
 }
+EXPORT_SYMBOL(rtl92c_phy_update_txpower_dbm);
 
 void rtl92c_phy_set_beacon_hw_reg(struct ieee80211_hw *hw, u16 beaconinterval)
 {
 }
+EXPORT_SYMBOL(rtl92c_phy_set_beacon_hw_reg);
 
 static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
 				       enum wireless_mode wirelessmode,
@@ -697,6 +674,7 @@ static u8 _rtl92c_phy_dbm_to_txpwr_Idx(s
 
 	return txpwridx;
 }
+EXPORT_SYMBOL(_rtl92c_phy_dbm_to_txpwr_Idx);
 
 static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
 					 enum wireless_mode wirelessmode,
@@ -720,6 +698,7 @@ static long _rtl92c_phy_txpwr_idx_to_dbm
 	pwrout_dbm = txpwridx / 2 + offset;
 	return pwrout_dbm;
 }
+EXPORT_SYMBOL(_rtl92c_phy_txpwr_idx_to_dbm);
 
 void rtl92c_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation)
 {
@@ -749,6 +728,7 @@ void rtl92c_phy_scan_operation_backup(st
 		}
 	}
 }
+EXPORT_SYMBOL(rtl92c_phy_scan_operation_backup);
 
 void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
 			    enum nl80211_channel_type ch_type)
@@ -762,7 +742,7 @@ void rtl92c_phy_set_bw_mode(struct ieee8
 		return;
 	rtlphy->set_bwmode_inprogress = true;
 	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw)))
-		rtl92c_phy_set_bw_mode_callback(hw);
+		rtlpriv->cfg->ops->phy_set_bw_mode_callback(hw);
 	else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("FALSE driver sleep or unload\n"));
@@ -770,6 +750,7 @@ void rtl92c_phy_set_bw_mode(struct ieee8
 		rtlphy->current_chan_bw = tmp_bw;
 	}
 }
+EXPORT_SYMBOL(rtl92c_phy_set_bw_mode);
 
 void rtl92c_phy_sw_chnl_callback(struct ieee80211_hw *hw)
 {
@@ -798,6 +779,7 @@ void rtl92c_phy_sw_chnl_callback(struct
 	} while (true);
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
 }
+EXPORT_SYMBOL(rtl92c_phy_sw_chnl_callback);
 
 u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw)
 {
@@ -827,6 +809,7 @@ u8 rtl92c_phy_sw_chnl(struct ieee80211_h
 	}
 	return 1;
 }
+EXPORT_SYMBOL(rtl92c_phy_sw_chnl);
 
 static bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
 					     u8 channel, u8 *stage, u8 *step,
@@ -961,6 +944,7 @@ bool rtl8192_phy_check_is_legal_rfpath(s
 {
 	return true;
 }
+EXPORT_SYMBOL(rtl8192_phy_check_is_legal_rfpath);
 
 static u8 _rtl92c_phy_path_a_iqk(struct ieee80211_hw *hw, bool config_pathb)
 {
@@ -1901,19 +1885,22 @@ void rtl92c_phy_iq_calibrate(struct ieee
 	_rtl92c_phy_save_adda_registers(hw, iqk_bb_reg,
 					rtlphy->iqk_bb_backup, 10);
 }
+EXPORT_SYMBOL(rtl92c_phy_iq_calibrate);
 
 void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	bool start_conttx = false, singletone = false;
 
 	if (start_conttx || singletone)
 		return;
 	if (IS_92C_SERIAL(rtlhal->version))
-		_rtl92c_phy_lc_calibrate(hw, true);
+		rtlpriv->cfg->ops->phy_lc_calibrate(hw, true);
 	else
-		_rtl92c_phy_lc_calibrate(hw, false);
+		rtlpriv->cfg->ops->phy_lc_calibrate(hw, false);
 }
+EXPORT_SYMBOL(rtl92c_phy_lc_calibrate);
 
 void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta)
 {
@@ -1928,6 +1915,7 @@ void rtl92c_phy_ap_calibrate(struct ieee
 	else
 		_rtl92c_phy_ap_calibrate(hw, delta, false);
 }
+EXPORT_SYMBOL(rtl92c_phy_ap_calibrate);
 
 void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain)
 {
@@ -1938,6 +1926,7 @@ void rtl92c_phy_set_rfpath_switch(struct
 	else
 		_rtl92c_phy_set_rfpath_switch(hw, bmain, false);
 }
+EXPORT_SYMBOL(rtl92c_phy_set_rfpath_switch);
 
 bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype)
 {
@@ -1976,6 +1965,7 @@ bool rtl92c_phy_set_io_cmd(struct ieee80
 	RT_TRACE(rtlpriv, COMP_CMD, DBG_TRACE, ("<--IO Type(%#x)\n", iotype));
 	return true;
 }
+EXPORT_SYMBOL(rtl92c_phy_set_io_cmd);
 
 void rtl92c_phy_set_io(struct ieee80211_hw *hw)
 {
@@ -2005,6 +1995,7 @@ void rtl92c_phy_set_io(struct ieee80211_
 	RT_TRACE(rtlpriv, COMP_CMD, DBG_TRACE,
 		 ("<---(%#x)\n", rtlphy->current_io_type));
 }
+EXPORT_SYMBOL(rtl92c_phy_set_io);
 
 void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw)
 {
@@ -2017,8 +2008,9 @@ void rtl92ce_phy_set_rf_on(struct ieee80
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE3);
 	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0x00);
 }
+EXPORT_SYMBOL(rtl92ce_phy_set_rf_on);
 
-static void _rtl92ce_phy_set_rf_sleep(struct ieee80211_hw *hw)
+void _rtl92c_phy_set_rf_sleep(struct ieee80211_hw *hw)
 {
 	u32 u4b_tmp;
 	u8 delay = 5;
@@ -2047,3 +2039,5 @@ static void _rtl92ce_phy_set_rf_sleep(st
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, 0xE2);
 	rtl_write_byte(rtlpriv, REG_SPS0_CTRL, 0x22);
 }
+EXPORT_SYMBOL(_rtl92c_phy_set_rf_sleep);
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -32,14 +32,13 @@
 #include "../ps.h"
 #include "reg.h"
 #include "def.h"
+#include "hw.h"
 #include "phy.h"
 #include "rf.h"
 #include "dm.h"
 #include "table.h"
 
-#include "../rtl8192c/phy_common.c"
-
-u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
+u32 rtl92ce_phy_query_rf_reg(struct ieee80211_hw *hw,
 			    enum radio_path rfpath, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -74,7 +73,7 @@ u32 rtl92c_phy_query_rf_reg(struct ieee8
 	return readback_value;
 }
 
-void rtl92c_phy_set_rf_reg(struct ieee80211_hw *hw,
+void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 			   enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data)
 {
@@ -122,19 +121,19 @@ void rtl92c_phy_set_rf_reg(struct ieee80
 					       bitmask, data, rfpath));
 }
 
-bool rtl92c_phy_mac_config(struct ieee80211_hw *hw)
+bool rtl92ce_phy_mac_config(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	bool is92c = IS_92C_SERIAL(rtlhal->version);
-	bool rtstatus = _rtl92c_phy_config_mac_with_headerfile(hw);
+	bool rtstatus = _rtl92ce_phy_config_mac_with_headerfile(hw);
 
 	if (is92c)
 		rtl_write_byte(rtlpriv, 0x14, 0x71);
 	return rtstatus;
 }
 
-bool rtl92c_phy_bb_config(struct ieee80211_hw *hw)
+bool rtl92ce_phy_bb_config(struct ieee80211_hw *hw)
 {
 	bool rtstatus = true;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -160,7 +159,7 @@ bool rtl92c_phy_bb_config(struct ieee802
 	return rtstatus;
 }
 
-static bool _rtl92c_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
+bool _rtl92ce_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	u32 i;
@@ -177,7 +176,7 @@ static bool _rtl92c_phy_config_mac_with_
 	return true;
 }
 
-static bool _rtl92c_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 						  u8 configtype)
 {
 	int i;
@@ -221,7 +220,6 @@ static bool _rtl92c_phy_config_bb_with_h
 				  phy_regarray_table[i],
 				  phy_regarray_table[i + 1]));
 		}
-		rtl92c_phy_config_bb_external_pa(hw);
 	} else if (configtype == BASEBAND_CONFIG_AGC_TAB) {
 		for (i = 0; i < agctab_arraylen; i = i + 2) {
 			rtl_set_bbreg(hw, agctab_array_table[i], MASKDWORD,
@@ -237,7 +235,7 @@ static bool _rtl92c_phy_config_bb_with_h
 	return true;
 }
 
-static bool _rtl92c_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
+bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 						    u8 configtype)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -276,7 +274,7 @@ static bool _rtl92c_phy_config_bb_with_p
 	return true;
 }
 
-bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
+bool rtl92ce_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath)
 {
 
@@ -331,7 +329,6 @@ bool rtl92c_phy_config_rf_with_headerfil
 				udelay(1);
 			}
 		}
-		_rtl92c_phy_config_rf_external_pa(hw, rfpath);
 		break;
 	case RF90_PATH_B:
 		for (i = 0; i < radiob_arraylen; i = i + 2) {
@@ -367,7 +364,7 @@ bool rtl92c_phy_config_rf_with_headerfil
 	return true;
 }
 
-void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
+void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -435,7 +432,7 @@ void rtl92c_phy_set_bw_mode_callback(str
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
 }
 
-static void _rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
+void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 {
 	u8 tmpreg;
 	u32 rf_a_mode = 0, rf_b_mode = 0, lc_cal;
@@ -602,7 +599,7 @@ static bool _rtl92ce_phy_set_rf_power_st
 				  jiffies_to_msecs(jiffies -
 						   ppsc->last_awake_jiffies)));
 			ppsc->last_sleep_jiffies = jiffies;
-			_rtl92ce_phy_set_rf_sleep(hw);
+			_rtl92c_phy_set_rf_sleep(hw);
 			break;
 		}
 	default:
@@ -617,7 +614,7 @@ static bool _rtl92ce_phy_set_rf_power_st
 	return bresult;
 }
 
-bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
+bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				   enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -191,11 +191,11 @@ extern void rtl92c_phy_set_bb_reg(struct
 extern u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
 				   enum radio_path rfpath, u32 regaddr,
 				   u32 bitmask);
-extern void rtl92c_phy_set_rf_reg(struct ieee80211_hw *hw,
+extern void rtl92ce_phy_set_rf_reg(struct ieee80211_hw *hw,
 				  enum radio_path rfpath, u32 regaddr,
 				  u32 bitmask, u32 data);
 extern bool rtl92c_phy_mac_config(struct ieee80211_hw *hw);
-extern bool rtl92c_phy_bb_config(struct ieee80211_hw *hw);
+bool rtl92ce_phy_bb_config(struct ieee80211_hw *hw);
 extern bool rtl92c_phy_rf_config(struct ieee80211_hw *hw);
 extern bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
 						 enum radio_path rfpath);
@@ -223,12 +223,32 @@ bool rtl92c_phy_config_rf_with_headerfil
 extern bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
 					      u32 rfpath);
 bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
-extern bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
+bool rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					  enum rf_pwrstate rfpwr_state);
-void rtl92c_phy_config_bb_external_pa(struct ieee80211_hw *hw);
 void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
 bool rtl92c_phy_set_io_cmd(struct ieee80211_hw *hw, enum io_type iotype);
 void rtl92c_phy_set_io(struct ieee80211_hw *hw);
 void rtl92c_bb_block_on(struct ieee80211_hw *hw);
+u32 _rtl92c_phy_rf_serial_read(struct ieee80211_hw *hw,
+				      enum radio_path rfpath, u32 offset);
+u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
+					 enum radio_path rfpath, u32 offset);
+u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask);
+void _rtl92c_phy_rf_serial_write(struct ieee80211_hw *hw,
+					enum radio_path rfpath, u32 offset,
+					u32 data);
+void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+						   u32 regaddr, u32 bitmask,
+						   u32 data);
+void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
+					   enum radio_path rfpath, u32 offset,
+					   u32 data);
+void _rtl92c_store_pwrIndex_diffrate_offset(struct ieee80211_hw *hw,
+						   u32 regaddr, u32 bitmask,
+						   u32 data);
+bool _rtl92ce_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
+void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
+bool _rtl92c_phy_bb8192c_config_parafile(struct ieee80211_hw *hw);
+void _rtl92c_phy_set_rf_sleep(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.c
@@ -37,9 +37,7 @@
 #include "dm.h"
 #include "table.h"
 
-#include "../rtl8192c/phy_common.c"
-
-u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
+u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
 			    enum radio_path rfpath, u32 regaddr, u32 bitmask)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -65,7 +63,7 @@ u32 rtl92c_phy_query_rf_reg(struct ieee8
 	return readback_value;
 }
 
-void rtl92c_phy_set_rf_reg(struct ieee80211_hw *hw,
+void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
 			   enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data)
 {
@@ -104,20 +102,20 @@ void rtl92c_phy_set_rf_reg(struct ieee80
 					       regaddr, bitmask, data, rfpath));
 }
 
-bool rtl92c_phy_mac_config(struct ieee80211_hw *hw)
+bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw)
 {
 	bool rtstatus;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	bool is92c = IS_92C_SERIAL(rtlhal->version);
 
-	rtstatus = _rtl92c_phy_config_mac_with_headerfile(hw);
+	rtstatus = _rtl92cu_phy_config_mac_with_headerfile(hw);
 	if (is92c && IS_HARDWARE_TYPE_8192CE(rtlhal))
 		rtl_write_byte(rtlpriv, 0x14, 0x71);
 	return rtstatus;
 }
 
-bool rtl92c_phy_bb_config(struct ieee80211_hw *hw)
+bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw)
 {
 	bool rtstatus = true;
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -146,7 +144,7 @@ bool rtl92c_phy_bb_config(struct ieee802
 	return rtstatus;
 }
 
-static bool _rtl92c_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
+bool _rtl92cu_phy_config_mac_with_headerfile(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -164,7 +162,7 @@ static bool _rtl92c_phy_config_mac_with_
 	return true;
 }
 
-static bool _rtl92c_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+bool _rtl92cu_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
 						  u8 configtype)
 {
 	int i;
@@ -209,7 +207,6 @@ static bool _rtl92c_phy_config_bb_with_h
 				  phy_regarray_table[i],
 				  phy_regarray_table[i + 1]));
 		}
-		rtl92c_phy_config_bb_external_pa(hw);
 	} else if (configtype == BASEBAND_CONFIG_AGC_TAB) {
 		for (i = 0; i < agctab_arraylen; i = i + 2) {
 			rtl_set_bbreg(hw, agctab_array_table[i], MASKDWORD,
@@ -225,7 +222,7 @@ static bool _rtl92c_phy_config_bb_with_h
 	return true;
 }
 
-static bool _rtl92c_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
+bool _rtl92cu_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 						    u8 configtype)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -263,7 +260,7 @@ static bool _rtl92c_phy_config_bb_with_p
 	return true;
 }
 
-bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
+bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
 					  enum radio_path rfpath)
 {
 	int i;
@@ -316,7 +313,6 @@ bool rtl92c_phy_config_rf_with_headerfil
 				udelay(1);
 			}
 		}
-		_rtl92c_phy_config_rf_external_pa(hw, rfpath);
 		break;
 	case RF90_PATH_B:
 		for (i = 0; i < radiob_arraylen; i = i + 2) {
@@ -352,7 +348,7 @@ bool rtl92c_phy_config_rf_with_headerfil
 	return true;
 }
 
-void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
+void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
@@ -410,12 +406,12 @@ void rtl92c_phy_set_bw_mode_callback(str
 			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
 		break;
 	}
-	rtl92c_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
+	rtl92cu_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
 	rtlphy->set_bwmode_inprogress = false;
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
 }
 
-void rtl92c_bb_block_on(struct ieee80211_hw *hw)
+void rtl92cu_bb_block_on(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -425,7 +421,7 @@ void rtl92c_bb_block_on(struct ieee80211
 	mutex_unlock(&rtlpriv->io.bb_mutex);
 }
 
-static void _rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
+void _rtl92cu_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 {
 	u8 tmpreg;
 	u32 rf_a_mode = 0, rf_b_mode = 0, lc_cal;
@@ -463,7 +459,7 @@ static void _rtl92c_phy_lc_calibrate(str
 	}
 }
 
-static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
+bool _rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 					    enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -584,7 +580,7 @@ static bool _rtl92ce_phy_set_rf_power_st
 			  jiffies_to_msecs(jiffies -
 					   ppsc->last_awake_jiffies)));
 		ppsc->last_sleep_jiffies = jiffies;
-		_rtl92ce_phy_set_rf_sleep(hw);
+		_rtl92c_phy_set_rf_sleep(hw);
 		break;
 	default:
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
@@ -598,7 +594,7 @@ static bool _rtl92ce_phy_set_rf_power_st
 	return bresult;
 }
 
-bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
+bool rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
 				   enum rf_pwrstate rfpwr_state)
 {
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
@@ -606,6 +602,6 @@ bool rtl92c_phy_set_rf_power_state(struc
 
 	if (rfpwr_state == ppsc->rfpwr_state)
 		return bresult;
-	bresult = _rtl92ce_phy_set_rf_power_state(hw, rfpwr_state);
+	bresult = _rtl92cu_phy_set_rf_power_state(hw, rfpwr_state);
 	return bresult;
 }
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -0,0 +1,775 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include <linux/firmware.h>
+#include "../wifi.h"
+#include "../pci.h"
+#include "../base.h"
+#include "../rtl8192ce/reg.h"
+#include "../rtl8192ce/def.h"
+#include "fw_common.h"
+
+static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+
+	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CU) {
+		u32 value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
+		if (enable)
+			value32 |= MCUFWDL_EN;
+		else
+			value32 &= ~MCUFWDL_EN;
+		rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
+	} else if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE) {
+		u8 tmp;
+		if (enable) {
+
+			tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
+			rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1,
+				       tmp | 0x04);
+
+			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL);
+			rtl_write_byte(rtlpriv, REG_MCUFWDL, tmp | 0x01);
+
+			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL + 2);
+			rtl_write_byte(rtlpriv, REG_MCUFWDL + 2, tmp & 0xf7);
+		} else {
+
+			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL);
+			rtl_write_byte(rtlpriv, REG_MCUFWDL, tmp & 0xfe);
+
+			rtl_write_byte(rtlpriv, REG_MCUFWDL + 1, 0x00);
+		}
+	}
+}
+
+static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
+				   const u8 *buffer, u32 size)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u32 blockSize = sizeof(u32);
+	u8 *bufferPtr = (u8 *) buffer;
+	u32 *pu4BytePtr = (u32 *) buffer;
+	u32 i, offset, blockCount, remainSize;
+
+	blockCount = size / blockSize;
+	remainSize = size % blockSize;
+
+	for (i = 0; i < blockCount; i++) {
+		offset = i * blockSize;
+		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
+				*(pu4BytePtr + i));
+	}
+
+	if (remainSize) {
+		offset = blockCount * blockSize;
+		bufferPtr += offset;
+		for (i = 0; i < remainSize; i++) {
+			rtl_write_byte(rtlpriv, (FW_8192C_START_ADDRESS +
+						 offset + i), *(bufferPtr + i));
+		}
+	}
+}
+
+static void _rtl92c_fw_page_write(struct ieee80211_hw *hw,
+				  u32 page, const u8 *buffer, u32 size)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 value8;
+	u8 u8page = (u8) (page & 0x07);
+
+	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
+
+	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
+	_rtl92c_fw_block_write(hw, buffer, size);
+}
+
+static void _rtl92c_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
+{
+	u32 fwlen = *pfwlen;
+	u8 remain = (u8) (fwlen % 4);
+
+	remain = (remain == 0) ? 0 : (4 - remain);
+
+	while (remain > 0) {
+		pfwbuf[fwlen] = 0;
+		fwlen++;
+		remain--;
+	}
+
+	*pfwlen = fwlen;
+}
+
+static void _rtl92c_write_fw(struct ieee80211_hw *hw,
+			     enum version_8192c version, u8 *buffer, u32 size)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u8 *bufferPtr = (u8 *) buffer;
+
+	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, ("FW size is %d bytes,\n", size));
+
+	if (IS_CHIP_VER_B(version)) {
+		u32 pageNums, remainSize;
+		u32 page, offset;
+
+		if (IS_HARDWARE_TYPE_8192CE(rtlhal))
+			_rtl92c_fill_dummy(bufferPtr, &size);
+
+		pageNums = size / FW_8192C_PAGE_SIZE;
+		remainSize = size % FW_8192C_PAGE_SIZE;
+
+		if (pageNums > 4) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 ("Page numbers should not greater then 4\n"));
+		}
+
+		for (page = 0; page < pageNums; page++) {
+			offset = page * FW_8192C_PAGE_SIZE;
+			_rtl92c_fw_page_write(hw, page, (bufferPtr + offset),
+					      FW_8192C_PAGE_SIZE);
+		}
+
+		if (remainSize) {
+			offset = pageNums * FW_8192C_PAGE_SIZE;
+			page = pageNums;
+			_rtl92c_fw_page_write(hw, page, (bufferPtr + offset),
+					      remainSize);
+		}
+	} else {
+		_rtl92c_fw_block_write(hw, buffer, size);
+	}
+}
+
+static int _rtl92c_fw_free_to_go(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	int err = -EIO;
+	u32 counter = 0;
+	u32 value32;
+
+	do {
+		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
+	} while ((counter++ < FW_8192C_POLLING_TIMEOUT_COUNT) &&
+		 (!(value32 & FWDL_ChkSum_rpt)));
+
+	if (counter >= FW_8192C_POLLING_TIMEOUT_COUNT) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("chksum report faill ! REG_MCUFWDL:0x%08x .\n",
+			  value32));
+		goto exit;
+	}
+
+	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
+		 ("Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32));
+
+	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
+	value32 |= MCUFWDL_RDY;
+	value32 &= ~WINTINI_RDY;
+	rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
+
+	counter = 0;
+
+	do {
+		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
+		if (value32 & WINTINI_RDY) {
+			RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
+				 ("Polling FW ready success!!"
+				 " REG_MCUFWDL:0x%08x .\n",
+				 value32));
+			err = 0;
+			goto exit;
+		}
+
+		mdelay(FW_8192C_POLLING_DELAY);
+
+	} while (counter++ < FW_8192C_POLLING_TIMEOUT_COUNT);
+
+	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+		 ("Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n", value32));
+
+exit:
+	return err;
+}
+
+int rtl92c_download_fw(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl92c_firmware_header *pfwheader;
+	u8 *pfwdata;
+	u32 fwsize;
+	int err;
+	enum version_8192c version = rtlhal->version;
+	const struct firmware *firmware;
+
+	printk(KERN_INFO "rtl8192cu: Loading firmware file %s\n",
+	       rtlpriv->cfg->fw_name);
+	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
+			       rtlpriv->io.dev);
+	if (err) {
+		printk(KERN_ERR "rtl8192cu: Firmware loading failed\n");
+		return 1;
+	}
+
+	if (firmware->size > 0x4000) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Firmware is too big!\n"));
+		release_firmware(firmware);
+		return 1;
+	}
+
+	memcpy(rtlhal->pfirmware, firmware->data, firmware->size);
+	fwsize = firmware->size;
+	release_firmware(firmware);
+
+	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
+	pfwdata = (u8 *) rtlhal->pfirmware;
+
+	if (IS_FW_HEADER_EXIST(pfwheader)) {
+		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
+			 ("Firmware Version(%d), Signature(%#x),Size(%d)\n",
+			  pfwheader->version, pfwheader->signature,
+			  (uint)sizeof(struct rtl92c_firmware_header)));
+
+		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
+		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
+	}
+
+	_rtl92c_enable_fw_download(hw, true);
+	_rtl92c_write_fw(hw, version, pfwdata, fwsize);
+	_rtl92c_enable_fw_download(hw, false);
+
+	err = _rtl92c_fw_free_to_go(hw);
+	if (err) {
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("Firmware is not ready to run!\n"));
+	} else {
+		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
+			 ("Firmware is ready to run!\n"));
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(rtl92c_download_fw);
+
+static bool _rtl92c_check_fw_read_last_h2c(struct ieee80211_hw *hw, u8 boxnum)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 val_hmetfr, val_mcutst_1;
+	bool result = false;
+
+	val_hmetfr = rtl_read_byte(rtlpriv, REG_HMETFR);
+	val_mcutst_1 = rtl_read_byte(rtlpriv, (REG_MCUTST_1 + boxnum));
+
+	if (((val_hmetfr >> boxnum) & BIT(0)) == 0 && val_mcutst_1 == 0)
+		result = true;
+	return result;
+}
+
+static void _rtl92c_fill_h2c_command(struct ieee80211_hw *hw,
+			      u8 element_id, u32 cmd_len, u8 *p_cmdbuffer)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u8 boxnum;
+	u16 box_reg, box_extreg;
+	u8 u1b_tmp;
+	bool isfw_read = false;
+	u8 buf_index;
+	bool bwrite_sucess = false;
+	u8 wait_h2c_limmit = 100;
+	u8 wait_writeh2c_limmit = 100;
+	u8 boxcontent[4], boxextcontent[2];
+	u32 h2c_waitcounter = 0;
+	unsigned long flag;
+	u8 idx;
+
+	RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, ("come in\n"));
+
+	while (true) {
+		spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
+		if (rtlhal->h2c_setinprogress) {
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 ("H2C set in progress! Wait to set.."
+				  "element_id(%d).\n", element_id));
+
+			while (rtlhal->h2c_setinprogress) {
+				spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock,
+						       flag);
+				h2c_waitcounter++;
+				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+					 ("Wait 100 us (%d times)...\n",
+					  h2c_waitcounter));
+				udelay(100);
+
+				if (h2c_waitcounter > 1000)
+					return;
+				spin_lock_irqsave(&rtlpriv->locks.h2c_lock,
+						  flag);
+			}
+			spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
+		} else {
+			rtlhal->h2c_setinprogress = true;
+			spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
+			break;
+		}
+	}
+
+	while (!bwrite_sucess) {
+		wait_writeh2c_limmit--;
+		if (wait_writeh2c_limmit == 0) {
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 ("Write H2C fail because no trigger "
+				  "for FW INT!\n"));
+			break;
+		}
+
+		boxnum = rtlhal->last_hmeboxnum;
+		switch (boxnum) {
+		case 0:
+			box_reg = REG_HMEBOX_0;
+			box_extreg = REG_HMEBOX_EXT_0;
+			break;
+		case 1:
+			box_reg = REG_HMEBOX_1;
+			box_extreg = REG_HMEBOX_EXT_1;
+			break;
+		case 2:
+			box_reg = REG_HMEBOX_2;
+			box_extreg = REG_HMEBOX_EXT_2;
+			break;
+		case 3:
+			box_reg = REG_HMEBOX_3;
+			box_extreg = REG_HMEBOX_EXT_3;
+			break;
+		default:
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 ("switch case not process\n"));
+			break;
+		}
+
+		isfw_read = _rtl92c_check_fw_read_last_h2c(hw, boxnum);
+		while (!isfw_read) {
+
+			wait_h2c_limmit--;
+			if (wait_h2c_limmit == 0) {
+				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+					 ("Wating too long for FW read "
+					  "clear HMEBox(%d)!\n", boxnum));
+				break;
+			}
+
+			udelay(10);
+
+			isfw_read = _rtl92c_check_fw_read_last_h2c(hw, boxnum);
+			u1b_tmp = rtl_read_byte(rtlpriv, 0x1BF);
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 ("Wating for FW read clear HMEBox(%d)!!! "
+				  "0x1BF = %2x\n", boxnum, u1b_tmp));
+		}
+
+		if (!isfw_read) {
+			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+				 ("Write H2C register BOX[%d] fail!!!!! "
+				  "Fw do not read.\n", boxnum));
+			break;
+		}
+
+		memset(boxcontent, 0, sizeof(boxcontent));
+		memset(boxextcontent, 0, sizeof(boxextcontent));
+		boxcontent[0] = element_id;
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 ("Write element_id box_reg(%4x) = %2x\n",
+			  box_reg, element_id));
+
+		switch (cmd_len) {
+		case 1:
+			boxcontent[0] &= ~(BIT(7));
+			memcpy((u8 *) (boxcontent) + 1,
+			       p_cmdbuffer + buf_index, 1);
+
+			for (idx = 0; idx < 4; idx++) {
+				rtl_write_byte(rtlpriv, box_reg + idx,
+					       boxcontent[idx]);
+			}
+			break;
+		case 2:
+			boxcontent[0] &= ~(BIT(7));
+			memcpy((u8 *) (boxcontent) + 1,
+			       p_cmdbuffer + buf_index, 2);
+
+			for (idx = 0; idx < 4; idx++) {
+				rtl_write_byte(rtlpriv, box_reg + idx,
+					       boxcontent[idx]);
+			}
+			break;
+		case 3:
+			boxcontent[0] &= ~(BIT(7));
+			memcpy((u8 *) (boxcontent) + 1,
+			       p_cmdbuffer + buf_index, 3);
+
+			for (idx = 0; idx < 4; idx++) {
+				rtl_write_byte(rtlpriv, box_reg + idx,
+					       boxcontent[idx]);
+			}
+			break;
+		case 4:
+			boxcontent[0] |= (BIT(7));
+			memcpy((u8 *) (boxextcontent),
+			       p_cmdbuffer + buf_index, 2);
+			memcpy((u8 *) (boxcontent) + 1,
+			       p_cmdbuffer + buf_index + 2, 2);
+
+			for (idx = 0; idx < 2; idx++) {
+				rtl_write_byte(rtlpriv, box_extreg + idx,
+					       boxextcontent[idx]);
+			}
+
+			for (idx = 0; idx < 4; idx++) {
+				rtl_write_byte(rtlpriv, box_reg + idx,
+					       boxcontent[idx]);
+			}
+			break;
+		case 5:
+			boxcontent[0] |= (BIT(7));
+			memcpy((u8 *) (boxextcontent),
+			       p_cmdbuffer + buf_index, 2);
+			memcpy((u8 *) (boxcontent) + 1,
+			       p_cmdbuffer + buf_index + 2, 3);
+
+			for (idx = 0; idx < 2; idx++) {
+				rtl_write_byte(rtlpriv, box_extreg + idx,
+					       boxextcontent[idx]);
+			}
+
+			for (idx = 0; idx < 4; idx++) {
+				rtl_write_byte(rtlpriv, box_reg + idx,
+					       boxcontent[idx]);
+			}
+			break;
+		default:
+			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+				 ("switch case not process\n"));
+			break;
+		}
+
+		bwrite_sucess = true;
+
+		rtlhal->last_hmeboxnum = boxnum + 1;
+		if (rtlhal->last_hmeboxnum == 4)
+			rtlhal->last_hmeboxnum = 0;
+
+		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
+			 ("pHalData->last_hmeboxnum  = %d\n",
+			  rtlhal->last_hmeboxnum));
+	}
+
+	spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
+	rtlhal->h2c_setinprogress = false;
+	spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
+
+	RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, ("go out\n"));
+}
+
+void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
+			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer)
+{
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	u32 tmp_cmdbuf[2];
+
+	if (rtlhal->fw_ready == false) {
+		RT_ASSERT(false, ("return H2C cmd because of Fw "
+				  "download fail!!!\n"));
+		return;
+	}
+
+	memset(tmp_cmdbuf, 0, 8);
+	memcpy(tmp_cmdbuf, p_cmdbuffer, cmd_len);
+	_rtl92c_fill_h2c_command(hw, element_id, cmd_len, (u8 *)&tmp_cmdbuf);
+
+	return;
+}
+EXPORT_SYMBOL(rtl92c_fill_h2c_cmd);
+
+void rtl92c_firmware_selfreset(struct ieee80211_hw *hw)
+{
+	u8 u1b_tmp;
+	u8 delay = 100;
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
+	rtl_write_byte(rtlpriv, REG_HMETFR + 3, 0x20);
+	u1b_tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
+
+	while (u1b_tmp & BIT(2)) {
+		delay--;
+		if (delay == 0) {
+			RT_ASSERT(false, ("8051 reset fail.\n"));
+			break;
+		}
+		udelay(50);
+		u1b_tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
+	}
+}
+EXPORT_SYMBOL(rtl92c_firmware_selfreset);
+
+void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	u8 u1_h2c_set_pwrmode[3] = {0};
+	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
+
+	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, ("FW LPS mode = %d\n", mode));
+
+	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, mode);
+	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode, 1);
+	SET_H2CCMD_PWRMODE_PARM_BCN_PASS_TIME(u1_h2c_set_pwrmode,
+					      ppsc->reg_max_lps_awakeintvl);
+
+	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
+		      "rtl92c_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode\n",
+		      u1_h2c_set_pwrmode, 3);
+	rtl92c_fill_h2c_cmd(hw, H2C_SETPWRMODE, 3, u1_h2c_set_pwrmode);
+
+}
+EXPORT_SYMBOL(rtl92c_set_fw_pwrmode_cmd);
+
+#define BEACON_PG		0 /*->1*/
+#define PSPOLL_PG		2
+#define NULL_PG			3
+#define PROBERSP_PG		4 /*->5*/
+
+#define TOTAL_RESERVED_PKT_LEN	768
+
+static u8 reserved_page_packet[TOTAL_RESERVED_PKT_LEN] = {
+	/* page 0 beacon */
+	0x80, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
+	0xFF, 0xFF, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
+	0x00, 0x40, 0x10, 0x10, 0x00, 0x03, 0x50, 0x08,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x64, 0x00, 0x00, 0x04, 0x00, 0x0C, 0x6C, 0x69,
+	0x6E, 0x6B, 0x73, 0x79, 0x73, 0x5F, 0x77, 0x6C,
+	0x61, 0x6E, 0x01, 0x04, 0x82, 0x84, 0x8B, 0x96,
+	0x03, 0x01, 0x01, 0x06, 0x02, 0x00, 0x00, 0x2A,
+	0x01, 0x00, 0x32, 0x08, 0x24, 0x30, 0x48, 0x6C,
+	0x0C, 0x12, 0x18, 0x60, 0x2D, 0x1A, 0x6C, 0x18,
+	0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x3D, 0x00, 0xDD, 0x06, 0x00, 0xE0, 0x4C, 0x02,
+	0x01, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+
+	/* page 1 beacon */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x10, 0x00, 0x20, 0x8C, 0x00, 0x12, 0x10, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+
+	/* page 2  ps-poll */
+	0xA4, 0x10, 0x01, 0xC0, 0x00, 0x40, 0x10, 0x10,
+	0x00, 0x03, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x18, 0x00, 0x20, 0x8C, 0x00, 0x12, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
+	0x80, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+
+	/* page 3  null */
+	0x48, 0x01, 0x00, 0x00, 0x00, 0x40, 0x10, 0x10,
+	0x00, 0x03, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
+	0x00, 0x40, 0x10, 0x10, 0x00, 0x03, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x72, 0x00, 0x20, 0x8C, 0x00, 0x12, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
+	0x80, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+
+	/* page 4  probe_resp */
+	0x50, 0x00, 0x00, 0x00, 0x00, 0x40, 0x10, 0x10,
+	0x00, 0x03, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
+	0x00, 0x40, 0x10, 0x10, 0x00, 0x03, 0x00, 0x00,
+	0x9E, 0x46, 0x15, 0x32, 0x27, 0xF2, 0x2D, 0x00,
+	0x64, 0x00, 0x00, 0x04, 0x00, 0x0C, 0x6C, 0x69,
+	0x6E, 0x6B, 0x73, 0x79, 0x73, 0x5F, 0x77, 0x6C,
+	0x61, 0x6E, 0x01, 0x04, 0x82, 0x84, 0x8B, 0x96,
+	0x03, 0x01, 0x01, 0x06, 0x02, 0x00, 0x00, 0x2A,
+	0x01, 0x00, 0x32, 0x08, 0x24, 0x30, 0x48, 0x6C,
+	0x0C, 0x12, 0x18, 0x60, 0x2D, 0x1A, 0x6C, 0x18,
+	0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x3D, 0x00, 0xDD, 0x06, 0x00, 0xE0, 0x4C, 0x02,
+	0x01, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+
+	/* page 5  probe_resp */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	struct sk_buff *skb = NULL;
+
+	u32 totalpacketlen;
+	bool rtstatus;
+	u8 u1RsvdPageLoc[3] = {0};
+	bool b_dlok = false;
+
+	u8 *beacon;
+	u8 *p_pspoll;
+	u8 *nullfunc;
+	u8 *p_probersp;
+	/*---------------------------------------------------------
+				(1) beacon
+	---------------------------------------------------------*/
+	beacon = &reserved_page_packet[BEACON_PG * 128];
+	SET_80211_HDR_ADDRESS2(beacon, mac->mac_addr);
+	SET_80211_HDR_ADDRESS3(beacon, mac->bssid);
+
+	/*-------------------------------------------------------
+				(2) ps-poll
+	--------------------------------------------------------*/
+	p_pspoll = &reserved_page_packet[PSPOLL_PG * 128];
+	SET_80211_PS_POLL_AID(p_pspoll, (mac->assoc_id | 0xc000));
+	SET_80211_PS_POLL_BSSID(p_pspoll, mac->bssid);
+	SET_80211_PS_POLL_TA(p_pspoll, mac->mac_addr);
+
+	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1RsvdPageLoc, PSPOLL_PG);
+
+	/*--------------------------------------------------------
+				(3) null data
+	---------------------------------------------------------*/
+	nullfunc = &reserved_page_packet[NULL_PG * 128];
+	SET_80211_HDR_ADDRESS1(nullfunc, mac->bssid);
+	SET_80211_HDR_ADDRESS2(nullfunc, mac->mac_addr);
+	SET_80211_HDR_ADDRESS3(nullfunc, mac->bssid);
+
+	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1RsvdPageLoc, NULL_PG);
+
+	/*---------------------------------------------------------
+				(4) probe response
+	----------------------------------------------------------*/
+	p_probersp = &reserved_page_packet[PROBERSP_PG * 128];
+	SET_80211_HDR_ADDRESS1(p_probersp, mac->bssid);
+	SET_80211_HDR_ADDRESS2(p_probersp, mac->mac_addr);
+	SET_80211_HDR_ADDRESS3(p_probersp, mac->bssid);
+
+	SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(u1RsvdPageLoc, PROBERSP_PG);
+
+	totalpacketlen = TOTAL_RESERVED_PKT_LEN;
+
+	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD,
+		      "rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL\n",
+		      &reserved_page_packet[0], totalpacketlen);
+	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
+		      "rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL\n",
+		      u1RsvdPageLoc, 3);
+
+
+	skb = dev_alloc_skb(totalpacketlen);
+	memcpy((u8 *) skb_put(skb, totalpacketlen),
+	       &reserved_page_packet, totalpacketlen);
+
+	rtstatus = rtlpriv->cfg->ops->cmd_send_packet(hw, skb);
+
+	if (rtstatus)
+		b_dlok = true;
+
+	if (b_dlok) {
+		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
+			 ("Set RSVD page location to Fw.\n"));
+		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
+				"H2C_RSVDPAGE:\n",
+				u1RsvdPageLoc, 3);
+		rtl92c_fill_h2c_cmd(hw, H2C_RSVDPAGE,
+				    sizeof(u1RsvdPageLoc), u1RsvdPageLoc);
+	} else
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
+			 ("Set RSVD page location to Fw FAIL!!!!!!.\n"));
+}
+EXPORT_SYMBOL(rtl92c_set_fw_rsvdpagepkt);
+
+void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus)
+{
+	u8 u1_joinbssrpt_parm[1] = {0};
+
+	SET_H2CCMD_JOINBSSRPT_PARM_OPMODE(u1_joinbssrpt_parm, mstatus);
+
+	rtl92c_fill_h2c_cmd(hw, H2C_JOINBSSRPT, 1, u1_joinbssrpt_parm);
+}
+EXPORT_SYMBOL(rtl92c_set_fw_joinbss_report_cmd);
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.h
@@ -0,0 +1,99 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92C__FW__H__
+#define __RTL92C__FW__H__
+
+#define FW_8192C_SIZE				0x3000
+#define FW_8192C_START_ADDRESS			0x1000
+#define FW_8192C_END_ADDRESS			0x3FFF
+#define FW_8192C_PAGE_SIZE			4096
+#define FW_8192C_POLLING_DELAY			5
+#define FW_8192C_POLLING_TIMEOUT_COUNT		100
+
+#define IS_FW_HEADER_EXIST(_pfwhdr)	\
+	((_pfwhdr->signature&0xFFF0) == 0x92C0 ||\
+	(_pfwhdr->signature&0xFFF0) == 0x88C0)
+
+struct rtl92c_firmware_header {
+	u16 signature;
+	u8 category;
+	u8 function;
+	u16 version;
+	u8 subversion;
+	u8 rsvd1;
+	u8 month;
+	u8 date;
+	u8 hour;
+	u8 minute;
+	u16 ramcodeSize;
+	u16 rsvd2;
+	u32 svnindex;
+	u32 rsvd3;
+	u32 rsvd4;
+	u32 rsvd5;
+};
+
+enum rtl8192c_h2c_cmd {
+	H2C_AP_OFFLOAD = 0,
+	H2C_SETPWRMODE = 1,
+	H2C_JOINBSSRPT = 2,
+	H2C_RSVDPAGE = 3,
+	H2C_RSSI_REPORT = 5,
+	H2C_RA_MASK = 6,
+	MAX_H2CCMD
+};
+
+#define pagenum_128(_len)	(u32)(((_len)>>7) + ((_len)&0x7F ? 1 : 0))
+
+#define SET_H2CCMD_PWRMODE_PARM_MODE(__ph2ccmd, __val)			\
+	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
+#define SET_H2CCMD_PWRMODE_PARM_SMART_PS(__ph2ccmd, __val)		\
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+1, 0, 8, __val)
+#define SET_H2CCMD_PWRMODE_PARM_BCN_PASS_TIME(__ph2ccmd, __val)	\
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+2, 0, 8, __val)
+#define SET_H2CCMD_JOINBSSRPT_PARM_OPMODE(__ph2ccmd, __val)		\
+	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
+#define SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(__ph2ccmd, __val)		\
+	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
+#define SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(__ph2ccmd, __val)		\
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+1, 0, 8, __val)
+#define SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(__ph2ccmd, __val)		\
+	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+2, 0, 8, __val)
+
+int rtl92c_download_fw(struct ieee80211_hw *hw);
+void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw, u8 element_id,
+			 u32 cmd_len, u8 *p_cmdbuffer);
+void rtl92c_firmware_selfreset(struct ieee80211_hw *hw);
+void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
+void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
+void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
+
+#endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/fw.c
+++ /dev/null
@@ -1,769 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
-
-#include <linux/firmware.h>
-#include "../wifi.h"
-#include "../pci.h"
-#include "../base.h"
-#include "reg.h"
-#include "def.h"
-#include "fw.h"
-#include "table.h"
-
-static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-
-	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CU) {
-		u32 value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
-		if (enable)
-			value32 |= MCUFWDL_EN;
-		else
-			value32 &= ~MCUFWDL_EN;
-		rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
-	} else if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE) {
-		u8 tmp;
-		if (enable) {
-
-			tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
-			rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1,
-				       tmp | 0x04);
-
-			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL);
-			rtl_write_byte(rtlpriv, REG_MCUFWDL, tmp | 0x01);
-
-			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL + 2);
-			rtl_write_byte(rtlpriv, REG_MCUFWDL + 2, tmp & 0xf7);
-		} else {
-
-			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL);
-			rtl_write_byte(rtlpriv, REG_MCUFWDL, tmp & 0xfe);
-
-			rtl_write_byte(rtlpriv, REG_MCUFWDL + 1, 0x00);
-		}
-	}
-}
-
-static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
-				   const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u32 blockSize = sizeof(u32);
-	u8 *bufferPtr = (u8 *) buffer;
-	u32 *pu4BytePtr = (u32 *) buffer;
-	u32 i, offset, blockCount, remainSize;
-
-	blockCount = size / blockSize;
-	remainSize = size % blockSize;
-
-	for (i = 0; i < blockCount; i++) {
-		offset = i * blockSize;
-		rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-				*(pu4BytePtr + i));
-	}
-
-	if (remainSize) {
-		offset = blockCount * blockSize;
-		bufferPtr += offset;
-		for (i = 0; i < remainSize; i++) {
-			rtl_write_byte(rtlpriv, (FW_8192C_START_ADDRESS +
-						 offset + i), *(bufferPtr + i));
-		}
-	}
-}
-
-static void _rtl92c_fw_page_write(struct ieee80211_hw *hw,
-				  u32 page, const u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 value8;
-	u8 u8page = (u8) (page & 0x07);
-
-	value8 = (rtl_read_byte(rtlpriv, REG_MCUFWDL + 2) & 0xF8) | u8page;
-
-	rtl_write_byte(rtlpriv, (REG_MCUFWDL + 2), value8);
-	_rtl92c_fw_block_write(hw, buffer, size);
-}
-
-static void _rtl92c_fill_dummy(u8 *pfwbuf, u32 *pfwlen)
-{
-	u32 fwlen = *pfwlen;
-	u8 remain = (u8) (fwlen % 4);
-
-	remain = (remain == 0) ? 0 : (4 - remain);
-
-	while (remain > 0) {
-		pfwbuf[fwlen] = 0;
-		fwlen++;
-		remain--;
-	}
-
-	*pfwlen = fwlen;
-}
-
-static void _rtl92c_write_fw(struct ieee80211_hw *hw,
-			     enum version_8192c version, u8 *buffer, u32 size)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u8 *bufferPtr = (u8 *) buffer;
-
-	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE, ("FW size is %d bytes,\n", size));
-
-	if (IS_CHIP_VER_B(version)) {
-		u32 pageNums, remainSize;
-		u32 page, offset;
-
-		if (IS_HARDWARE_TYPE_8192CE(rtlhal))
-			_rtl92c_fill_dummy(bufferPtr, &size);
-
-		pageNums = size / FW_8192C_PAGE_SIZE;
-		remainSize = size % FW_8192C_PAGE_SIZE;
-
-		if (pageNums > 4) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 ("Page numbers should not greater then 4\n"));
-		}
-
-		for (page = 0; page < pageNums; page++) {
-			offset = page * FW_8192C_PAGE_SIZE;
-			_rtl92c_fw_page_write(hw, page, (bufferPtr + offset),
-					      FW_8192C_PAGE_SIZE);
-		}
-
-		if (remainSize) {
-			offset = pageNums * FW_8192C_PAGE_SIZE;
-			page = pageNums;
-			_rtl92c_fw_page_write(hw, page, (bufferPtr + offset),
-					      remainSize);
-		}
-	} else {
-		_rtl92c_fw_block_write(hw, buffer, size);
-	}
-}
-
-static int _rtl92c_fw_free_to_go(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	int err = -EIO;
-	u32 counter = 0;
-	u32 value32;
-
-	do {
-		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
-	} while ((counter++ < FW_8192C_POLLING_TIMEOUT_COUNT) &&
-		 (!(value32 & FWDL_ChkSum_rpt)));
-
-	if (counter >= FW_8192C_POLLING_TIMEOUT_COUNT) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("chksum report faill ! REG_MCUFWDL:0x%08x .\n",
-			  value32));
-		goto exit;
-	}
-
-	RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-		 ("Checksum report OK ! REG_MCUFWDL:0x%08x .\n", value32));
-
-	value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
-	value32 |= MCUFWDL_RDY;
-	value32 &= ~WINTINI_RDY;
-	rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
-
-	counter = 0;
-
-	do {
-		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
-		if (value32 & WINTINI_RDY) {
-			RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-				 ("Polling FW ready success!!"
-				 " REG_MCUFWDL:0x%08x .\n",
-				 value32));
-			err = 0;
-			goto exit;
-		}
-
-		mdelay(FW_8192C_POLLING_DELAY);
-
-	} while (counter++ < FW_8192C_POLLING_TIMEOUT_COUNT);
-
-	RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-		 ("Polling FW ready fail!! REG_MCUFWDL:0x%08x .\n", value32));
-
-exit:
-	return err;
-}
-
-int rtl92c_download_fw(struct ieee80211_hw *hw)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	struct rtl92c_firmware_header *pfwheader;
-	u8 *pfwdata;
-	u32 fwsize;
-	int err;
-	enum version_8192c version = rtlhal->version;
-	const struct firmware *firmware;
-
-	printk(KERN_INFO "rtl8192cu: Loading firmware file %s\n",
-	       rtlpriv->cfg->fw_name);
-	err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
-			       rtlpriv->io.dev);
-	if (err) {
-		printk(KERN_ERR "rtl8192cu: Firmware loading failed\n");
-		return 1;
-	}
-
-	if (firmware->size > 0x4000) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Firmware is too big!\n"));
-		release_firmware(firmware);
-		return 1;
-	}
-
-	memcpy(rtlhal->pfirmware, firmware->data, firmware->size);
-	fwsize = firmware->size;
-	release_firmware(firmware);
-
-	pfwheader = (struct rtl92c_firmware_header *)rtlhal->pfirmware;
-	pfwdata = (u8 *) rtlhal->pfirmware;
-
-	if (IS_FW_HEADER_EXIST(pfwheader)) {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_DMESG,
-			 ("Firmware Version(%d), Signature(%#x),Size(%d)\n",
-			  pfwheader->version, pfwheader->signature,
-			  (uint)sizeof(struct rtl92c_firmware_header)));
-
-		pfwdata = pfwdata + sizeof(struct rtl92c_firmware_header);
-		fwsize = fwsize - sizeof(struct rtl92c_firmware_header);
-	}
-
-	_rtl92c_enable_fw_download(hw, true);
-	_rtl92c_write_fw(hw, version, pfwdata, fwsize);
-	_rtl92c_enable_fw_download(hw, false);
-
-	err = _rtl92c_fw_free_to_go(hw);
-	if (err) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-			 ("Firmware is not ready to run!\n"));
-	} else {
-		RT_TRACE(rtlpriv, COMP_FW, DBG_TRACE,
-			 ("Firmware is ready to run!\n"));
-	}
-
-	return 0;
-}
-
-static bool _rtl92c_check_fw_read_last_h2c(struct ieee80211_hw *hw, u8 boxnum)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 val_hmetfr, val_mcutst_1;
-	bool result = false;
-
-	val_hmetfr = rtl_read_byte(rtlpriv, REG_HMETFR);
-	val_mcutst_1 = rtl_read_byte(rtlpriv, (REG_MCUTST_1 + boxnum));
-
-	if (((val_hmetfr >> boxnum) & BIT(0)) == 0 && val_mcutst_1 == 0)
-		result = true;
-	return result;
-}
-
-static void _rtl92c_fill_h2c_command(struct ieee80211_hw *hw,
-			      u8 element_id, u32 cmd_len, u8 *p_cmdbuffer)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u8 boxnum;
-	u16 box_reg, box_extreg;
-	u8 u1b_tmp;
-	bool isfw_read = false;
-	u8 buf_index;
-	bool bwrite_sucess = false;
-	u8 wait_h2c_limmit = 100;
-	u8 wait_writeh2c_limmit = 100;
-	u8 boxcontent[4], boxextcontent[2];
-	u32 h2c_waitcounter = 0;
-	unsigned long flag;
-	u8 idx;
-
-	RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, ("come in\n"));
-
-	while (true) {
-		spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
-		if (rtlhal->h2c_setinprogress) {
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 ("H2C set in progress! Wait to set.."
-				  "element_id(%d).\n", element_id));
-
-			while (rtlhal->h2c_setinprogress) {
-				spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock,
-						       flag);
-				h2c_waitcounter++;
-				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-					 ("Wait 100 us (%d times)...\n",
-					  h2c_waitcounter));
-				udelay(100);
-
-				if (h2c_waitcounter > 1000)
-					return;
-				spin_lock_irqsave(&rtlpriv->locks.h2c_lock,
-						  flag);
-			}
-			spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
-		} else {
-			rtlhal->h2c_setinprogress = true;
-			spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
-			break;
-		}
-	}
-
-	while (!bwrite_sucess) {
-		wait_writeh2c_limmit--;
-		if (wait_writeh2c_limmit == 0) {
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 ("Write H2C fail because no trigger "
-				  "for FW INT!\n"));
-			break;
-		}
-
-		boxnum = rtlhal->last_hmeboxnum;
-		switch (boxnum) {
-		case 0:
-			box_reg = REG_HMEBOX_0;
-			box_extreg = REG_HMEBOX_EXT_0;
-			break;
-		case 1:
-			box_reg = REG_HMEBOX_1;
-			box_extreg = REG_HMEBOX_EXT_1;
-			break;
-		case 2:
-			box_reg = REG_HMEBOX_2;
-			box_extreg = REG_HMEBOX_EXT_2;
-			break;
-		case 3:
-			box_reg = REG_HMEBOX_3;
-			box_extreg = REG_HMEBOX_EXT_3;
-			break;
-		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 ("switch case not process\n"));
-			break;
-		}
-
-		isfw_read = _rtl92c_check_fw_read_last_h2c(hw, boxnum);
-		while (!isfw_read) {
-
-			wait_h2c_limmit--;
-			if (wait_h2c_limmit == 0) {
-				RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-					 ("Wating too long for FW read "
-					  "clear HMEBox(%d)!\n", boxnum));
-				break;
-			}
-
-			udelay(10);
-
-			isfw_read = _rtl92c_check_fw_read_last_h2c(hw, boxnum);
-			u1b_tmp = rtl_read_byte(rtlpriv, 0x1BF);
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 ("Wating for FW read clear HMEBox(%d)!!! "
-				  "0x1BF = %2x\n", boxnum, u1b_tmp));
-		}
-
-		if (!isfw_read) {
-			RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-				 ("Write H2C register BOX[%d] fail!!!!! "
-				  "Fw do not read.\n", boxnum));
-			break;
-		}
-
-		memset(boxcontent, 0, sizeof(boxcontent));
-		memset(boxextcontent, 0, sizeof(boxextcontent));
-		boxcontent[0] = element_id;
-		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-			 ("Write element_id box_reg(%4x) = %2x\n",
-			  box_reg, element_id));
-
-		switch (cmd_len) {
-		case 1:
-			boxcontent[0] &= ~(BIT(7));
-			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index, 1);
-
-			for (idx = 0; idx < 4; idx++) {
-				rtl_write_byte(rtlpriv, box_reg + idx,
-					       boxcontent[idx]);
-			}
-			break;
-		case 2:
-			boxcontent[0] &= ~(BIT(7));
-			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index, 2);
-
-			for (idx = 0; idx < 4; idx++) {
-				rtl_write_byte(rtlpriv, box_reg + idx,
-					       boxcontent[idx]);
-			}
-			break;
-		case 3:
-			boxcontent[0] &= ~(BIT(7));
-			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index, 3);
-
-			for (idx = 0; idx < 4; idx++) {
-				rtl_write_byte(rtlpriv, box_reg + idx,
-					       boxcontent[idx]);
-			}
-			break;
-		case 4:
-			boxcontent[0] |= (BIT(7));
-			memcpy((u8 *) (boxextcontent),
-			       p_cmdbuffer + buf_index, 2);
-			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index + 2, 2);
-
-			for (idx = 0; idx < 2; idx++) {
-				rtl_write_byte(rtlpriv, box_extreg + idx,
-					       boxextcontent[idx]);
-			}
-
-			for (idx = 0; idx < 4; idx++) {
-				rtl_write_byte(rtlpriv, box_reg + idx,
-					       boxcontent[idx]);
-			}
-			break;
-		case 5:
-			boxcontent[0] |= (BIT(7));
-			memcpy((u8 *) (boxextcontent),
-			       p_cmdbuffer + buf_index, 2);
-			memcpy((u8 *) (boxcontent) + 1,
-			       p_cmdbuffer + buf_index + 2, 3);
-
-			for (idx = 0; idx < 2; idx++) {
-				rtl_write_byte(rtlpriv, box_extreg + idx,
-					       boxextcontent[idx]);
-			}
-
-			for (idx = 0; idx < 4; idx++) {
-				rtl_write_byte(rtlpriv, box_reg + idx,
-					       boxcontent[idx]);
-			}
-			break;
-		default:
-			RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
-				 ("switch case not process\n"));
-			break;
-		}
-
-		bwrite_sucess = true;
-
-		rtlhal->last_hmeboxnum = boxnum + 1;
-		if (rtlhal->last_hmeboxnum == 4)
-			rtlhal->last_hmeboxnum = 0;
-
-		RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD,
-			 ("pHalData->last_hmeboxnum  = %d\n",
-			  rtlhal->last_hmeboxnum));
-	}
-
-	spin_lock_irqsave(&rtlpriv->locks.h2c_lock, flag);
-	rtlhal->h2c_setinprogress = false;
-	spin_unlock_irqrestore(&rtlpriv->locks.h2c_lock, flag);
-
-	RT_TRACE(rtlpriv, COMP_CMD, DBG_LOUD, ("go out\n"));
-}
-
-void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
-			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer)
-{
-	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
-	u32 tmp_cmdbuf[2];
-
-	if (rtlhal->fw_ready == false) {
-		RT_ASSERT(false, ("return H2C cmd because of Fw "
-				  "download fail!!!\n"));
-		return;
-	}
-
-	memset(tmp_cmdbuf, 0, 8);
-	memcpy(tmp_cmdbuf, p_cmdbuffer, cmd_len);
-	_rtl92c_fill_h2c_command(hw, element_id, cmd_len, (u8 *)&tmp_cmdbuf);
-
-	return;
-}
-
-void rtl92c_firmware_selfreset(struct ieee80211_hw *hw)
-{
-	u8 u1b_tmp;
-	u8 delay = 100;
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	rtl_write_byte(rtlpriv, REG_HMETFR + 3, 0x20);
-	u1b_tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
-
-	while (u1b_tmp & BIT(2)) {
-		delay--;
-		if (delay == 0) {
-			RT_ASSERT(false, ("8051 reset fail.\n"));
-			break;
-		}
-		udelay(50);
-		u1b_tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
-	}
-}
-
-void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	u8 u1_h2c_set_pwrmode[3] = {0};
-	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
-
-	RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD, ("FW LPS mode = %d\n", mode));
-
-	SET_H2CCMD_PWRMODE_PARM_MODE(u1_h2c_set_pwrmode, mode);
-	SET_H2CCMD_PWRMODE_PARM_SMART_PS(u1_h2c_set_pwrmode, 1);
-	SET_H2CCMD_PWRMODE_PARM_BCN_PASS_TIME(u1_h2c_set_pwrmode,
-					      ppsc->reg_max_lps_awakeintvl);
-
-	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-		      "rtl92c_set_fw_rsvdpagepkt(): u1_h2c_set_pwrmode\n",
-		      u1_h2c_set_pwrmode, 3);
-	rtl92c_fill_h2c_cmd(hw, H2C_SETPWRMODE, 3, u1_h2c_set_pwrmode);
-
-}
-
-#define BEACON_PG		0 /*->1*/
-#define PSPOLL_PG		2
-#define NULL_PG			3
-#define PROBERSP_PG		4 /*->5*/
-
-#define TOTAL_RESERVED_PKT_LEN	768
-
-static u8 reserved_page_packet[TOTAL_RESERVED_PKT_LEN] = {
-	/* page 0 beacon */
-	0x80, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF,
-	0xFF, 0xFF, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
-	0x00, 0x40, 0x10, 0x10, 0x00, 0x03, 0x50, 0x08,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x64, 0x00, 0x00, 0x04, 0x00, 0x0C, 0x6C, 0x69,
-	0x6E, 0x6B, 0x73, 0x79, 0x73, 0x5F, 0x77, 0x6C,
-	0x61, 0x6E, 0x01, 0x04, 0x82, 0x84, 0x8B, 0x96,
-	0x03, 0x01, 0x01, 0x06, 0x02, 0x00, 0x00, 0x2A,
-	0x01, 0x00, 0x32, 0x08, 0x24, 0x30, 0x48, 0x6C,
-	0x0C, 0x12, 0x18, 0x60, 0x2D, 0x1A, 0x6C, 0x18,
-	0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x3D, 0x00, 0xDD, 0x06, 0x00, 0xE0, 0x4C, 0x02,
-	0x01, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-
-	/* page 1 beacon */
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x10, 0x00, 0x20, 0x8C, 0x00, 0x12, 0x10, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-
-	/* page 2  ps-poll */
-	0xA4, 0x10, 0x01, 0xC0, 0x00, 0x40, 0x10, 0x10,
-	0x00, 0x03, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x18, 0x00, 0x20, 0x8C, 0x00, 0x12, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
-	0x80, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-
-	/* page 3  null */
-	0x48, 0x01, 0x00, 0x00, 0x00, 0x40, 0x10, 0x10,
-	0x00, 0x03, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
-	0x00, 0x40, 0x10, 0x10, 0x00, 0x03, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x72, 0x00, 0x20, 0x8C, 0x00, 0x12, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80,
-	0x80, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-
-	/* page 4  probe_resp */
-	0x50, 0x00, 0x00, 0x00, 0x00, 0x40, 0x10, 0x10,
-	0x00, 0x03, 0x00, 0xE0, 0x4C, 0x76, 0x00, 0x42,
-	0x00, 0x40, 0x10, 0x10, 0x00, 0x03, 0x00, 0x00,
-	0x9E, 0x46, 0x15, 0x32, 0x27, 0xF2, 0x2D, 0x00,
-	0x64, 0x00, 0x00, 0x04, 0x00, 0x0C, 0x6C, 0x69,
-	0x6E, 0x6B, 0x73, 0x79, 0x73, 0x5F, 0x77, 0x6C,
-	0x61, 0x6E, 0x01, 0x04, 0x82, 0x84, 0x8B, 0x96,
-	0x03, 0x01, 0x01, 0x06, 0x02, 0x00, 0x00, 0x2A,
-	0x01, 0x00, 0x32, 0x08, 0x24, 0x30, 0x48, 0x6C,
-	0x0C, 0x12, 0x18, 0x60, 0x2D, 0x1A, 0x6C, 0x18,
-	0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x3D, 0x00, 0xDD, 0x06, 0x00, 0xE0, 0x4C, 0x02,
-	0x01, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-
-	/* page 5  probe_resp */
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-};
-
-void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
-	struct sk_buff *skb = NULL;
-
-	u32 totalpacketlen;
-	bool rtstatus;
-	u8 u1RsvdPageLoc[3] = {0};
-	bool b_dlok = false;
-
-	u8 *beacon;
-	u8 *p_pspoll;
-	u8 *nullfunc;
-	u8 *p_probersp;
-	/*---------------------------------------------------------
-				(1) beacon
-	---------------------------------------------------------*/
-	beacon = &reserved_page_packet[BEACON_PG * 128];
-	SET_80211_HDR_ADDRESS2(beacon, mac->mac_addr);
-	SET_80211_HDR_ADDRESS3(beacon, mac->bssid);
-
-	/*-------------------------------------------------------
-				(2) ps-poll
-	--------------------------------------------------------*/
-	p_pspoll = &reserved_page_packet[PSPOLL_PG * 128];
-	SET_80211_PS_POLL_AID(p_pspoll, (mac->assoc_id | 0xc000));
-	SET_80211_PS_POLL_BSSID(p_pspoll, mac->bssid);
-	SET_80211_PS_POLL_TA(p_pspoll, mac->mac_addr);
-
-	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1RsvdPageLoc, PSPOLL_PG);
-
-	/*--------------------------------------------------------
-				(3) null data
-	---------------------------------------------------------*/
-	nullfunc = &reserved_page_packet[NULL_PG * 128];
-	SET_80211_HDR_ADDRESS1(nullfunc, mac->bssid);
-	SET_80211_HDR_ADDRESS2(nullfunc, mac->mac_addr);
-	SET_80211_HDR_ADDRESS3(nullfunc, mac->bssid);
-
-	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1RsvdPageLoc, NULL_PG);
-
-	/*---------------------------------------------------------
-				(4) probe response
-	----------------------------------------------------------*/
-	p_probersp = &reserved_page_packet[PROBERSP_PG * 128];
-	SET_80211_HDR_ADDRESS1(p_probersp, mac->bssid);
-	SET_80211_HDR_ADDRESS2(p_probersp, mac->mac_addr);
-	SET_80211_HDR_ADDRESS3(p_probersp, mac->bssid);
-
-	SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(u1RsvdPageLoc, PROBERSP_PG);
-
-	totalpacketlen = TOTAL_RESERVED_PKT_LEN;
-
-	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD,
-		      "rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL\n",
-		      &reserved_page_packet[0], totalpacketlen);
-	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-		      "rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL\n",
-		      u1RsvdPageLoc, 3);
-
-
-	skb = dev_alloc_skb(totalpacketlen);
-	memcpy((u8 *) skb_put(skb, totalpacketlen),
-	       &reserved_page_packet, totalpacketlen);
-
-	rtstatus = rtlpriv->cfg->ops->cmd_send_packet(hw, skb);
-
-	if (rtstatus)
-		b_dlok = true;
-
-	if (b_dlok) {
-		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
-			 ("Set RSVD page location to Fw.\n"));
-		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-				"H2C_RSVDPAGE:\n",
-				u1RsvdPageLoc, 3);
-		rtl92c_fill_h2c_cmd(hw, H2C_RSVDPAGE,
-				    sizeof(u1RsvdPageLoc), u1RsvdPageLoc);
-	} else
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
-			 ("Set RSVD page location to Fw FAIL!!!!!!.\n"));
-}
-
-void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus)
-{
-	u8 u1_joinbssrpt_parm[1] = {0};
-
-	SET_H2CCMD_JOINBSSRPT_PARM_OPMODE(u1_joinbssrpt_parm, mstatus);
-
-	rtl92c_fill_h2c_cmd(hw, H2C_JOINBSSRPT, 1, u1_joinbssrpt_parm);
-}
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/fw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/fw.h
+++ /dev/null
@@ -1,98 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
-
-#ifndef __RTL92C__FW__H__
-#define __RTL92C__FW__H__
-
-#define FW_8192C_SIZE				0x3000
-#define FW_8192C_START_ADDRESS			0x1000
-#define FW_8192C_END_ADDRESS			0x3FFF
-#define FW_8192C_PAGE_SIZE			4096
-#define FW_8192C_POLLING_DELAY			5
-#define FW_8192C_POLLING_TIMEOUT_COUNT		100
-
-#define IS_FW_HEADER_EXIST(_pfwhdr)	\
-	((_pfwhdr->signature&0xFFF0) == 0x92C0 ||\
-	(_pfwhdr->signature&0xFFF0) == 0x88C0)
-
-struct rtl92c_firmware_header {
-	u16 signature;
-	u8 category;
-	u8 function;
-	u16 version;
-	u8 subversion;
-	u8 rsvd1;
-	u8 month;
-	u8 date;
-	u8 hour;
-	u8 minute;
-	u16 ramcodeSize;
-	u16 rsvd2;
-	u32 svnindex;
-	u32 rsvd3;
-	u32 rsvd4;
-	u32 rsvd5;
-};
-
-enum rtl8192c_h2c_cmd {
-	H2C_AP_OFFLOAD = 0,
-	H2C_SETPWRMODE = 1,
-	H2C_JOINBSSRPT = 2,
-	H2C_RSVDPAGE = 3,
-	H2C_RSSI_REPORT = 5,
-	H2C_RA_MASK = 6,
-	MAX_H2CCMD
-};
-
-#define pagenum_128(_len)	(u32)(((_len)>>7) + ((_len)&0x7F ? 1 : 0))
-
-#define SET_H2CCMD_PWRMODE_PARM_MODE(__ph2ccmd, __val)			\
-	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
-#define SET_H2CCMD_PWRMODE_PARM_SMART_PS(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+1, 0, 8, __val)
-#define SET_H2CCMD_PWRMODE_PARM_BCN_PASS_TIME(__ph2ccmd, __val)	\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+2, 0, 8, __val)
-#define SET_H2CCMD_JOINBSSRPT_PARM_OPMODE(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
-#define SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE(__ph2ccmd, 0, 8, __val)
-#define SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+1, 0, 8, __val)
-#define SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(__ph2ccmd, __val)		\
-	SET_BITS_TO_LE_1BYTE((__ph2ccmd)+2, 0, 8, __val)
-
-int rtl92c_download_fw(struct ieee80211_hw *hw);
-void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw, u8 element_id,
-			 u32 cmd_len, u8 *p_cmdbuffer);
-void rtl92c_firmware_selfreset(struct ieee80211_hw *hw);
-void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
-void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
-void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
-
-#endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/fw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/fw.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
-
-#include "../rtl8192ce/fw.c"
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/fw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/fw.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2009-2010  Realtek Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- * wlanfae <wlanfae@realtek.com>
- * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
- * Hsinchu 300, Taiwan.
- *
- * Larry Finger <Larry.Finger@lwfinger.net>
- *
- *****************************************************************************/
-
-#include "../rtl8192ce/fw.h"
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include "dm_common.h"
+
 struct dig_t dm_digtable;
 static struct ps_t dm_pstable;
 
@@ -517,6 +519,7 @@ void rtl92c_dm_write_dig(struct ieee8021
 		dm_digtable.pre_igvalue = dm_digtable.cur_igvalue;
 	}
 }
+EXPORT_SYMBOL(rtl92c_dm_write_dig);
 
 static void rtl92c_dm_pwdb_monitor(struct ieee80211_hw *hw)
 {
@@ -554,6 +557,7 @@ void rtl92c_dm_init_edca_turbo(struct ie
 	rtlpriv->dm.is_any_nonbepkts = false;
 	rtlpriv->dm.is_cur_rdlstate = false;
 }
+EXPORT_SYMBOL(rtl92c_dm_init_edca_turbo);
 
 static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 {
@@ -1103,6 +1107,7 @@ void rtl92c_dm_check_txpower_tracking(st
 {
 	rtl92c_dm_check_txpower_tracking_thermal_meter(hw);
 }
+EXPORT_SYMBOL(rtl92c_dm_check_txpower_tracking);
 
 void rtl92c_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw)
 {
@@ -1118,6 +1123,7 @@ void rtl92c_dm_init_rate_adaptive_mask(s
 		rtlpriv->dm.useramask = false;
 
 }
+EXPORT_SYMBOL(rtl92c_dm_init_rate_adaptive_mask);
 
 static void rtl92c_dm_refresh_rate_adaptive_mask(struct ieee80211_hw *hw)
 {
@@ -1307,6 +1313,7 @@ void rtl92c_dm_rf_saving(struct ieee8021
 		dm_pstable.pre_rfstate = dm_pstable.cur_rfstate;
 	}
 }
+EXPORT_SYMBOL(rtl92c_dm_rf_saving);
 
 static void rtl92c_dm_dynamic_bb_powersaving(struct ieee80211_hw *hw)
 {
@@ -1360,6 +1367,7 @@ void rtl92c_dm_init(struct ieee80211_hw
 	rtl92c_dm_initialize_txpower_tracking(hw);
 	rtl92c_dm_init_dynamic_bb_powersaving(hw);
 }
+EXPORT_SYMBOL(rtl92c_dm_init);
 
 void rtl92c_dm_watchdog(struct ieee80211_hw *hw)
 {
@@ -1380,9 +1388,11 @@ void rtl92c_dm_watchdog(struct ieee80211
 		rtl92c_dm_dig(hw);
 		rtl92c_dm_false_alarm_counter_statistics(hw);
 		rtl92c_dm_dynamic_bb_powersaving(hw);
-		rtl92c_dm_dynamic_txpower(hw);
+		rtlpriv->cfg->ops->dm_dynamic_txpower(hw);
 		rtl92c_dm_check_txpower_tracking(hw);
 		rtl92c_dm_refresh_rate_adaptive_mask(hw);
 		rtl92c_dm_check_edca_turbo(hw);
+
 	}
 }
+EXPORT_SYMBOL(rtl92c_dm_watchdog);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h
@@ -0,0 +1,205 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef	__RTL92COMMON_DM_H__
+#define __RTL92COMMON_DM_H__
+
+#include "../wifi.h"
+#include "../rtl8192ce/def.h"
+#include "../rtl8192ce/reg.h"
+#include "fw_common.h"
+
+#define HAL_DM_DIG_DISABLE			BIT(0)
+#define HAL_DM_HIPWR_DISABLE			BIT(1)
+
+#define OFDM_TABLE_LENGTH			37
+#define CCK_TABLE_LENGTH			33
+
+#define OFDM_TABLE_SIZE				37
+#define CCK_TABLE_SIZE				33
+
+#define BW_AUTO_SWITCH_HIGH_LOW			25
+#define BW_AUTO_SWITCH_LOW_HIGH			30
+
+#define DM_DIG_THRESH_HIGH			40
+#define DM_DIG_THRESH_LOW			35
+
+#define DM_FALSEALARM_THRESH_LOW		400
+#define DM_FALSEALARM_THRESH_HIGH		1000
+
+#define DM_DIG_MAX				0x3e
+#define DM_DIG_MIN				0x1e
+
+#define DM_DIG_FA_UPPER				0x32
+#define DM_DIG_FA_LOWER				0x20
+#define DM_DIG_FA_TH0				0x20
+#define DM_DIG_FA_TH1				0x100
+#define DM_DIG_FA_TH2				0x200
+
+#define DM_DIG_BACKOFF_MAX			12
+#define DM_DIG_BACKOFF_MIN			-4
+#define DM_DIG_BACKOFF_DEFAULT			10
+
+#define RXPATHSELECTION_SS_TH_lOW		30
+#define RXPATHSELECTION_DIFF_TH			18
+
+#define DM_RATR_STA_INIT			0
+#define DM_RATR_STA_HIGH			1
+#define DM_RATR_STA_MIDDLE			2
+#define DM_RATR_STA_LOW				3
+
+#define CTS2SELF_THVAL				30
+#define REGC38_TH				20
+
+#define WAIOTTHVal				25
+
+#define TXHIGHPWRLEVEL_NORMAL			0
+#define TXHIGHPWRLEVEL_LEVEL1			1
+#define TXHIGHPWRLEVEL_LEVEL2			2
+#define TXHIGHPWRLEVEL_BT1			3
+#define TXHIGHPWRLEVEL_BT2			4
+
+#define DM_TYPE_BYFW				0
+#define DM_TYPE_BYDRIVER			1
+
+#define TX_POWER_NEAR_FIELD_THRESH_LVL2		74
+#define TX_POWER_NEAR_FIELD_THRESH_LVL1		67
+
+struct ps_t {
+	u8 pre_ccastate;
+	u8 cur_ccasate;
+	u8 pre_rfstate;
+	u8 cur_rfstate;
+	long rssi_val_min;
+};
+
+struct dig_t {
+	u8 dig_enable_flag;
+	u8 dig_ext_port_stage;
+	u32 rssi_lowthresh;
+	u32 rssi_highthresh;
+	u32 fa_lowthresh;
+	u32 fa_highthresh;
+	u8 cursta_connectctate;
+	u8 presta_connectstate;
+	u8 curmultista_connectstate;
+	u8 pre_igvalue;
+	u8 cur_igvalue;
+	char backoff_val;
+	char backoff_val_range_max;
+	char backoff_val_range_min;
+	u8 rx_gain_range_max;
+	u8 rx_gain_range_min;
+	u8 rssi_val_min;
+	u8 pre_cck_pd_state;
+	u8 cur_cck_pd_state;
+	u8 pre_cck_fa_state;
+	u8 cur_cck_fa_state;
+	u8 pre_ccastate;
+	u8 cur_ccasate;
+};
+
+struct swat_t {
+	u8 failure_cnt;
+	u8 try_flag;
+	u8 stop_trying;
+	long pre_rssi;
+	long trying_threshold;
+	u8 cur_antenna;
+	u8 pre_antenna;
+};
+
+enum tag_dynamic_init_gain_operation_type_definition {
+	DIG_TYPE_THRESH_HIGH = 0,
+	DIG_TYPE_THRESH_LOW = 1,
+	DIG_TYPE_BACKOFF = 2,
+	DIG_TYPE_RX_GAIN_MIN = 3,
+	DIG_TYPE_RX_GAIN_MAX = 4,
+	DIG_TYPE_ENABLE = 5,
+	DIG_TYPE_DISABLE = 6,
+	DIG_OP_TYPE_MAX
+};
+
+enum tag_cck_packet_detection_threshold_type_definition {
+	CCK_PD_STAGE_LowRssi = 0,
+	CCK_PD_STAGE_HighRssi = 1,
+	CCK_FA_STAGE_Low = 2,
+	CCK_FA_STAGE_High = 3,
+	CCK_PD_STAGE_MAX = 4,
+};
+
+enum dm_1r_cca_e {
+	CCA_1R = 0,
+	CCA_2R = 1,
+	CCA_MAX = 2,
+};
+
+enum dm_rf_e {
+	RF_SAVE = 0,
+	RF_NORMAL = 1,
+	RF_MAX = 2,
+};
+
+enum dm_sw_ant_switch_e {
+	ANS_ANTENNA_B = 1,
+	ANS_ANTENNA_A = 2,
+	ANS_ANTENNA_MAX = 3,
+};
+
+enum dm_dig_ext_port_alg_e {
+	DIG_EXT_PORT_STAGE_0 = 0,
+	DIG_EXT_PORT_STAGE_1 = 1,
+	DIG_EXT_PORT_STAGE_2 = 2,
+	DIG_EXT_PORT_STAGE_3 = 3,
+	DIG_EXT_PORT_STAGE_MAX = 4,
+};
+
+enum dm_dig_connect_e {
+	DIG_STA_DISCONNECT = 0,
+	DIG_STA_CONNECT = 1,
+	DIG_STA_BEFORE_CONNECT = 2,
+	DIG_MULTISTA_DISCONNECT = 3,
+	DIG_MULTISTA_CONNECT = 4,
+	DIG_CONNECT_MAX
+};
+
+extern struct dig_t dm_digtable;
+void rtl92c_dm_init(struct ieee80211_hw *hw);
+void rtl92c_dm_watchdog(struct ieee80211_hw *hw);
+void rtl92c_dm_write_dig(struct ieee80211_hw *hw);
+void rtl92c_dm_init_edca_turbo(struct ieee80211_hw *hw);
+void rtl92c_dm_check_txpower_tracking(struct ieee80211_hw *hw);
+void rtl92c_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw);
+void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal);
+void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta);
+void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
+void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool recovery);
+
+#endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.h
@@ -0,0 +1,247 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#ifndef __RTL92C_PHY_H__
+#define __RTL92C_PHY_H__
+
+#define MAX_PRECMD_CNT			16
+#define MAX_RFDEPENDCMD_CNT		16
+#define MAX_POSTCMD_CNT			16
+
+#define MAX_DOZE_WAITING_TIMES_9x	64
+
+#define RT_CANNOT_IO(hw)		false
+#define HIGHPOWER_RADIOA_ARRAYLEN	22
+
+#define MAX_TOLERANCE			5
+#define	IQK_DELAY_TIME			1
+
+#define	APK_BB_REG_NUM			5
+#define	APK_AFE_REG_NUM			16
+#define	APK_CURVE_REG_NUM		4
+#define	PATH_NUM			2
+
+#define LOOP_LIMIT			5
+#define MAX_STALL_TIME			50
+#define AntennaDiversityValue		0x80
+#define MAX_TXPWR_IDX_NMODE_92S		63
+#define Reset_Cnt_Limit			3
+
+#define IQK_ADDA_REG_NUM		16
+#define IQK_MAC_REG_NUM			4
+
+#define RF90_PATH_MAX			2
+
+#define CT_OFFSET_MAC_ADDR		0X16
+
+#define CT_OFFSET_CCK_TX_PWR_IDX	0x5A
+#define CT_OFFSET_HT401S_TX_PWR_IDX	0x60
+#define CT_OFFSET_HT402S_TX_PWR_IDX_DIF	0x66
+#define CT_OFFSET_HT20_TX_PWR_IDX_DIFF	0x69
+#define CT_OFFSET_OFDM_TX_PWR_IDX_DIFF	0x6C
+
+#define CT_OFFSET_HT40_MAX_PWR_OFFSET	0x6F
+#define CT_OFFSET_HT20_MAX_PWR_OFFSET	0x72
+
+#define CT_OFFSET_CHANNEL_PLAH		0x75
+#define CT_OFFSET_THERMAL_METER		0x78
+#define CT_OFFSET_RF_OPTION		0x79
+#define CT_OFFSET_VERSION		0x7E
+#define CT_OFFSET_CUSTOMER_ID		0x7F
+
+#define RTL92C_MAX_PATH_NUM		2
+#define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER	255
+enum swchnlcmd_id {
+	CMDID_END,
+	CMDID_SET_TXPOWEROWER_LEVEL,
+	CMDID_BBREGWRITE10,
+	CMDID_WRITEPORT_ULONG,
+	CMDID_WRITEPORT_USHORT,
+	CMDID_WRITEPORT_UCHAR,
+	CMDID_RF_WRITEREG,
+};
+
+struct swchnlcmd {
+	enum swchnlcmd_id cmdid;
+	u32 para1;
+	u32 para2;
+	u32 msdelay;
+};
+
+enum hw90_block_e {
+	HW90_BLOCK_MAC = 0,
+	HW90_BLOCK_PHY0 = 1,
+	HW90_BLOCK_PHY1 = 2,
+	HW90_BLOCK_RF = 3,
+	HW90_BLOCK_MAXIMUM = 4,
+};
+
+enum baseband_config_type {
+	BASEBAND_CONFIG_PHY_REG = 0,
+	BASEBAND_CONFIG_AGC_TAB = 1,
+};
+
+enum ra_offset_area {
+	RA_OFFSET_LEGACY_OFDM1,
+	RA_OFFSET_LEGACY_OFDM2,
+	RA_OFFSET_HT_OFDM1,
+	RA_OFFSET_HT_OFDM2,
+	RA_OFFSET_HT_OFDM3,
+	RA_OFFSET_HT_OFDM4,
+	RA_OFFSET_HT_CCK,
+};
+
+enum antenna_path {
+	ANTENNA_NONE,
+	ANTENNA_D,
+	ANTENNA_C,
+	ANTENNA_CD,
+	ANTENNA_B,
+	ANTENNA_BD,
+	ANTENNA_BC,
+	ANTENNA_BCD,
+	ANTENNA_A,
+	ANTENNA_AD,
+	ANTENNA_AC,
+	ANTENNA_ACD,
+	ANTENNA_AB,
+	ANTENNA_ABD,
+	ANTENNA_ABC,
+	ANTENNA_ABCD
+};
+
+struct r_antenna_select_ofdm {
+	u32 r_tx_antenna:4;
+	u32 r_ant_l:4;
+	u32 r_ant_non_ht:4;
+	u32 r_ant_ht1:4;
+	u32 r_ant_ht2:4;
+	u32 r_ant_ht_s1:4;
+	u32 r_ant_non_ht_s1:4;
+	u32 ofdm_txsc:2;
+	u32 reserved:2;
+};
+
+struct r_antenna_select_cck {
+	u8 r_cckrx_enable_2:2;
+	u8 r_cckrx_enable:2;
+	u8 r_ccktx_enable:4;
+};
+
+struct efuse_contents {
+	u8 mac_addr[ETH_ALEN];
+	u8 cck_tx_power_idx[6];
+	u8 ht40_1s_tx_power_idx[6];
+	u8 ht40_2s_tx_power_idx_diff[3];
+	u8 ht20_tx_power_idx_diff[3];
+	u8 ofdm_tx_power_idx_diff[3];
+	u8 ht40_max_power_offset[3];
+	u8 ht20_max_power_offset[3];
+	u8 channel_plan;
+	u8 thermal_meter;
+	u8 rf_option[5];
+	u8 version;
+	u8 oem_id;
+	u8 regulatory;
+};
+
+struct tx_power_struct {
+	u8 cck[RTL92C_MAX_PATH_NUM][CHANNEL_MAX_NUMBER];
+	u8 ht40_1s[RTL92C_MAX_PATH_NUM][CHANNEL_MAX_NUMBER];
+	u8 ht40_2s[RTL92C_MAX_PATH_NUM][CHANNEL_MAX_NUMBER];
+	u8 ht20_diff[RTL92C_MAX_PATH_NUM][CHANNEL_MAX_NUMBER];
+	u8 legacy_ht_diff[RTL92C_MAX_PATH_NUM][CHANNEL_MAX_NUMBER];
+	u8 legacy_ht_txpowerdiff;
+	u8 groupht20[RTL92C_MAX_PATH_NUM][CHANNEL_MAX_NUMBER];
+	u8 groupht40[RTL92C_MAX_PATH_NUM][CHANNEL_MAX_NUMBER];
+	u8 pwrgroup_cnt;
+	u32 mcs_original_offset[4][16];
+};
+
+extern u32 rtl92c_phy_query_bb_reg(struct ieee80211_hw *hw,
+				   u32 regaddr, u32 bitmask);
+extern void rtl92c_phy_set_bb_reg(struct ieee80211_hw *hw,
+				  u32 regaddr, u32 bitmask, u32 data);
+extern u32 rtl92c_phy_query_rf_reg(struct ieee80211_hw *hw,
+				   enum radio_path rfpath, u32 regaddr,
+				   u32 bitmask);
+extern void rtl92c_phy_set_rf_reg(struct ieee80211_hw *hw,
+				  enum radio_path rfpath, u32 regaddr,
+				  u32 bitmask, u32 data);
+extern bool rtl92c_phy_mac_config(struct ieee80211_hw *hw);
+extern bool rtl92c_phy_bb_config(struct ieee80211_hw *hw);
+extern bool rtl92c_phy_rf_config(struct ieee80211_hw *hw);
+extern bool rtl92c_phy_config_rf_with_feaderfile(struct ieee80211_hw *hw,
+						 enum radio_path rfpath);
+extern void rtl92c_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
+extern void rtl92c_phy_get_txpower_level(struct ieee80211_hw *hw,
+					 long *powerlevel);
+extern void rtl92c_phy_set_txpower_level(struct ieee80211_hw *hw, u8 channel);
+extern bool rtl92c_phy_update_txpower_dbm(struct ieee80211_hw *hw,
+					  long power_indbm);
+extern void rtl92c_phy_scan_operation_backup(struct ieee80211_hw *hw,
+					     u8 operation);
+extern void rtl92c_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
+extern void rtl92c_phy_set_bw_mode(struct ieee80211_hw *hw,
+				   enum nl80211_channel_type ch_type);
+extern void rtl92c_phy_sw_chnl_callback(struct ieee80211_hw *hw);
+extern u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw);
+extern void rtl92c_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
+extern void rtl92c_phy_set_beacon_hw_reg(struct ieee80211_hw *hw,
+					 u16 beaconinterval);
+void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta);
+void rtl92c_phy_lc_calibrate(struct ieee80211_hw *hw);
+void rtl92c_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
+bool rtl92c_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
+					  enum radio_path rfpath);
+extern bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw,
+					      u32 rfpath);
+extern bool rtl92c_phy_set_rf_power_state(struct ieee80211_hw *hw,
+					  enum rf_pwrstate rfpwr_state);
+void rtl92ce_phy_set_rf_on(struct ieee80211_hw *hw);
+void rtl92c_phy_set_io(struct ieee80211_hw *hw);
+void rtl92c_bb_block_on(struct ieee80211_hw *hw);
+u32 _rtl92c_phy_calculate_bit_shift(u32 bitmask);
+static long _rtl92c_phy_txpwr_idx_to_dbm(struct ieee80211_hw *hw,
+					 enum wireless_mode wirelessmode,
+					 u8 txpwridx);
+static u8 _rtl92c_phy_dbm_to_txpwr_Idx(struct ieee80211_hw *hw,
+				       enum wireless_mode wirelessmode,
+				       long power_indbm);
+void _rtl92c_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw);
+static bool _rtl92c_phy_set_sw_chnl_cmdarray(struct swchnlcmd *cmdtable,
+					     u32 cmdtableidx, u32 cmdtablesz,
+					     enum swchnlcmd_id cmdid, u32 para1,
+					     u32 para2, u32 msdelay);
+static bool _rtl92c_phy_sw_chnl_step_by_step(struct ieee80211_hw *hw,
+					     u8 channel, u8 *stage, u8 *step,
+					     u32 *delay);
+
+#endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.c
@@ -33,11 +33,8 @@
 #include "def.h"
 #include "phy.h"
 #include "dm.h"
-#include "fw.h"
 
-#include "../rtl8192c/dm_common.c"
-
-void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw)
+void rtl92ce_dm_dynamic_txpower(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -114,5 +111,3 @@ void rtl92c_dm_dynamic_txpower(struct ie
 
 	rtlpriv->dm.last_dtp_lvl = rtlpriv->dm.dynamic_txhighpower_lvl;
 }
-
-
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/dm.h
@@ -192,6 +192,6 @@ void rtl92c_dm_init_edca_turbo(struct ie
 void rtl92c_dm_check_txpower_tracking(struct ieee80211_hw *hw);
 void rtl92c_dm_init_rate_adaptive_mask(struct ieee80211_hw *hw);
 void rtl92c_dm_rf_saving(struct ieee80211_hw *hw, u8 bforce_in_normal);
-void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
+void rtl92ce_dm_dynamic_txpower(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -37,7 +37,6 @@
 #include "def.h"
 #include "phy.h"
 #include "dm.h"
-#include "fw.h"
 #include "led.h"
 #include "hw.h"
 
@@ -949,8 +948,8 @@ int rtl92ce_hw_init(struct ieee80211_hw
 	}
 
 	rtlhal->last_hmeboxnum = 0;
-	rtl92c_phy_mac_config(hw);
-	rtl92c_phy_bb_config(hw);
+	rtl92ce_phy_mac_config(hw);
+	rtl92ce_phy_bb_config(hw);
 	rtlphy->rf_mode = RF_OP_BY_SW_3WIRE;
 	rtl92c_phy_rf_config(hw);
 	rtlphy->rfreg_chnlval[0] = rtl_get_rfreg(hw, (enum radio_path)0,
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/hw.h
@@ -30,6 +30,8 @@
 #ifndef __RTL92CE_HW_H__
 #define __RTL92CE_HW_H__
 
+#define H2C_RA_MASK	6
+
 void rtl92ce_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl92ce_read_eeprom_info(struct ieee80211_hw *hw);
 void rtl92ce_interrupt_recognized(struct ieee80211_hw *hw,
@@ -53,5 +55,14 @@ void rtl92ce_enable_hw_security_config(s
 void rtl92ce_set_key(struct ieee80211_hw *hw, u32 key_index,
 		     u8 *p_macaddr, bool is_group, u8 enc_algo,
 		     bool is_wepkey, bool clear_all);
+bool _rtl92ce_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
+void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished);
+void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
+void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
+int rtl92c_download_fw(struct ieee80211_hw *hw);
+void rtl92c_firmware_selfreset(struct ieee80211_hw *hw);
+void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
+			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer);
+bool rtl92ce_phy_mac_config(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.c
@@ -61,7 +61,7 @@ void rtl92c_phy_rf6052_set_bandwidth(str
 	}
 }
 
-void rtl92c_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 				       u8 *ppowerlevel)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -410,7 +410,7 @@ static void _rtl92c_write_ofdm_power_reg
 	}
 }
 
-void rtl92c_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+void rtl92ce_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
 					u8 *ppowerlevel, u8 channel)
 {
 	u32 writeVal[2], powerBase0[2], powerBase1[2];
@@ -430,7 +430,7 @@ void rtl92c_phy_rf6052_set_ofdm_txpower(
 	}
 }
 
-bool rtl92c_phy_rf6052_config(struct ieee80211_hw *hw)
+bool rtl92ce_phy_rf6052_config(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -484,11 +484,11 @@ static bool _rtl92c_phy_rf6052_config_pa
 
 		switch (rfpath) {
 		case RF90_PATH_A:
-			rtstatus = rtl92c_phy_config_rf_with_headerfile(hw,
+			rtstatus = rtl92ce_phy_config_rf_with_headerfile(hw,
 					(enum radio_path) rfpath);
 			break;
 		case RF90_PATH_B:
-			rtstatus = rtl92c_phy_config_rf_with_headerfile(hw,
+			rtstatus = rtl92ce_phy_config_rf_with_headerfile(hw,
 					(enum radio_path) rfpath);
 			break;
 		case RF90_PATH_C:
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/rf.h
@@ -40,5 +40,8 @@ extern void rtl92c_phy_rf6052_set_cck_tx
 					      u8 *ppowerlevel);
 extern void rtl92c_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
 					       u8 *ppowerlevel, u8 channel);
-extern bool rtl92c_phy_rf6052_config(struct ieee80211_hw *hw);
+bool rtl92ce_phy_rf6052_config(struct ieee80211_hw *hw);
+bool rtl92ce_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
+					  enum radio_path rfpath);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -37,6 +37,7 @@
 #include "phy.h"
 #include "dm.h"
 #include "hw.h"
+#include "rf.h"
 #include "sw.h"
 #include "trx.h"
 #include "led.h"
@@ -122,7 +123,7 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.switch_channel = rtl92c_phy_sw_chnl,
 	.dm_watchdog = rtl92c_dm_watchdog,
 	.scan_operation_backup = rtl92c_phy_scan_operation_backup,
-	.set_rf_power_state = rtl92c_phy_set_rf_power_state,
+	.set_rf_power_state = rtl92ce_phy_set_rf_power_state,
 	.led_control = rtl92ce_led_control,
 	.set_desc = rtl92ce_set_desc,
 	.get_desc = rtl92ce_get_desc,
@@ -133,9 +134,17 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.deinit_sw_leds = rtl92ce_deinit_sw_leds,
 	.get_bbreg = rtl92c_phy_query_bb_reg,
 	.set_bbreg = rtl92c_phy_set_bb_reg,
-	.get_rfreg = rtl92c_phy_query_rf_reg,
-	.set_rfreg = rtl92c_phy_set_rf_reg,
+	.get_rfreg = rtl92ce_phy_query_rf_reg,
+	.set_rfreg = rtl92ce_phy_set_rf_reg,
 	.cmd_send_packet = _rtl92c_cmd_send_packet,
+	.phy_rf6052_config = rtl92ce_phy_rf6052_config,
+	.phy_rf6052_set_cck_txpower = rtl92ce_phy_rf6052_set_cck_txpower,
+	.phy_rf6052_set_ofdm_txpower = rtl92ce_phy_rf6052_set_ofdm_txpower,
+	.config_bb_with_headerfile = _rtl92ce_phy_config_bb_with_headerfile,
+	.config_bb_with_pgheaderfile = _rtl92ce_phy_config_bb_with_pgheaderfile,
+	.phy_lc_calibrate = _rtl92ce_phy_lc_calibrate,
+	.phy_set_bw_mode_callback = rtl92ce_phy_set_bw_mode_callback,
+	.dm_dynamic_txpower = rtl92ce_dm_dynamic_txpower,
 };
 
 static struct rtl_mod_params rtl92ce_mod_params = {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/sw.h
@@ -35,5 +35,17 @@ void rtl92c_deinit_sw_vars(struct ieee80
 void rtl92c_init_var_map(struct ieee80211_hw *hw);
 bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
 			     struct sk_buff *skb);
+void rtl92ce_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+					u8 *ppowerlevel);
+void rtl92ce_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+					 u8 *ppowerlevel, u8 channel);
+bool _rtl92ce_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+						  u8 configtype);
+bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
+						    u8 configtype);
+void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t);
+u32 rtl92ce_phy_query_rf_reg(struct ieee80211_hw *hw,
+			    enum radio_path rfpath, u32 regaddr, u32 bitmask);
+void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.c
@@ -33,11 +33,8 @@
 #include "def.h"
 #include "phy.h"
 #include "dm.h"
-#include "fw.h"
 
-#include "../rtl8192c/dm_common.c"
-
-void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw)
+void rtl92cu_dm_dynamic_txpower(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/dm.h
@@ -29,4 +29,4 @@
 
 #include "../rtl8192ce/dm.h"
 
-void rtl92c_dm_dynamic_txpower(struct ieee80211_hw *hw);
+void rtl92cu_dm_dynamic_txpower(struct ieee80211_hw *hw);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
@@ -38,7 +38,6 @@
 #include "phy.h"
 #include "mac.h"
 #include "dm.h"
-#include "fw.h"
 #include "hw.h"
 #include "trx.h"
 #include "led.h"
@@ -1190,8 +1189,8 @@ int rtl92cu_hw_init(struct ieee80211_hw
 	}
 	rtlhal->last_hmeboxnum = 0; /* h2c */
 	_rtl92cu_phy_param_tab_init(hw);
-	rtl92c_phy_mac_config(hw);
-	rtl92c_phy_bb_config(hw);
+	rtl92cu_phy_mac_config(hw);
+	rtl92cu_phy_bb_config(hw);
 	rtlphy->rf_mode = RF_OP_BY_SW_3WIRE;
 	rtl92c_phy_rf_config(hw);
 	if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
@@ -1203,7 +1202,7 @@ int rtl92cu_hw_init(struct ieee80211_hw
 						 RF_CHNLBW, RFREG_OFFSET_MASK);
 	rtlphy->rfreg_chnlval[1] = rtl_get_rfreg(hw, (enum radio_path)1,
 						 RF_CHNLBW, RFREG_OFFSET_MASK);
-	rtl92c_bb_block_on(hw);
+	rtl92cu_bb_block_on(hw);
 	rtl_cam_reset_all_entry(hw);
 	rtl92cu_enable_hw_security_config(hw);
 	ppsc->rfpwr_state = ERFON;
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -30,6 +30,8 @@
 #ifndef __RTL92CU_HW_H__
 #define __RTL92CU_HW_H__
 
+#define H2C_RA_MASK	6
+
 #define LLT_POLLING_LLT_THRESHOLD		20
 #define LLT_POLLING_READY_TIMEOUT_COUNT		100
 #define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER		255
@@ -103,5 +105,12 @@ void rtl92cu_update_channel_access_setti
 bool rtl92cu_gpio_radio_on_off_checking(struct ieee80211_hw *hw, u8 * valid);
 void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid);
 u8 _rtl92c_get_chnl_group(u8 chnl);
+int rtl92c_download_fw(struct ieee80211_hw *hw);
+void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
+void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished);
+void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
+void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
+			 u8 element_id, u32 cmd_len, u8 *p_cmdbuffer);
+bool rtl92cu_phy_mac_config(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/phy.h
@@ -29,6 +29,8 @@
 
 #include "../rtl8192ce/phy.h"
 
-void rtl92c_bb_block_on(struct ieee80211_hw *hw);
+void rtl92cu_bb_block_on(struct ieee80211_hw *hw);
 bool rtl8192_phy_check_is_legal_rfpath(struct ieee80211_hw *hw, u32 rfpath);
 void rtl92c_phy_set_io(struct ieee80211_hw *hw);
+bool _rtl92cu_phy_config_mac_with_headerfile(struct ieee80211_hw *hw);
+bool rtl92cu_phy_bb_config(struct ieee80211_hw *hw);
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -36,7 +36,7 @@
 
 static bool _rtl92c_phy_rf6052_config_parafile(struct ieee80211_hw *hw);
 
-void rtl92c_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
+void rtl92cu_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw, u8 bandwidth)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -61,7 +61,7 @@ void rtl92c_phy_rf6052_set_bandwidth(str
 	}
 }
 
-void rtl92c_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 				       u8 *ppowerlevel)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -388,7 +388,7 @@ static void _rtl92c_write_ofdm_power_reg
 	}
 }
 
-void rtl92c_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+void rtl92cu_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
 					u8 *ppowerlevel, u8 channel)
 {
 	u32 writeVal[2], powerBase0[2], powerBase1[2];
@@ -406,7 +406,7 @@ void rtl92c_phy_rf6052_set_ofdm_txpower(
 	}
 }
 
-bool rtl92c_phy_rf6052_config(struct ieee80211_hw *hw)
+bool rtl92cu_phy_rf6052_config(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
@@ -456,11 +456,11 @@ static bool _rtl92c_phy_rf6052_config_pa
 		udelay(1);
 		switch (rfpath) {
 		case RF90_PATH_A:
-			rtstatus = rtl92c_phy_config_rf_with_headerfile(hw,
+			rtstatus = rtl92cu_phy_config_rf_with_headerfile(hw,
 					(enum radio_path) rfpath);
 			break;
 		case RF90_PATH_B:
-			rtstatus = rtl92c_phy_config_rf_with_headerfile(hw,
+			rtstatus = rtl92cu_phy_config_rf_with_headerfile(hw,
 					(enum radio_path) rfpath);
 			break;
 		case RF90_PATH_C:
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/rf.h
@@ -27,4 +27,22 @@
  *
  *****************************************************************************/
 
-#include "../rtl8192ce/rf.h"
+#ifndef __RTL92CU_RF_H__
+#define __RTL92CU_RF_H__
+
+#define RF6052_MAX_TX_PWR		0x3F
+#define RF6052_MAX_REG			0x3F
+#define RF6052_MAX_PATH			2
+
+extern void rtl92cu_phy_rf6052_set_bandwidth(struct ieee80211_hw *hw,
+					    u8 bandwidth);
+extern void rtl92c_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+					      u8 *ppowerlevel);
+extern void rtl92c_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+					       u8 *ppowerlevel, u8 channel);
+bool rtl92cu_phy_rf6052_config(struct ieee80211_hw *hw);
+bool rtl92cu_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
+					  enum radio_path rfpath);
+
+#endif
+
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
@@ -36,6 +36,7 @@
 #include "phy.h"
 #include "mac.h"
 #include "dm.h"
+#include "rf.h"
 #include "sw.h"
 #include "trx.h"
 #include "led.h"
@@ -106,7 +107,7 @@ static struct rtl_hal_ops rtl8192cu_hal_
 	.switch_channel = rtl92c_phy_sw_chnl,
 	.dm_watchdog = rtl92c_dm_watchdog,
 	.scan_operation_backup = rtl92c_phy_scan_operation_backup,
-	.set_rf_power_state = rtl92c_phy_set_rf_power_state,
+	.set_rf_power_state = rtl92cu_phy_set_rf_power_state,
 	.led_control = rtl92cu_led_control,
 	.enable_hw_sec = rtl92cu_enable_hw_security_config,
 	.set_key = rtl92c_set_key,
@@ -114,8 +115,16 @@ static struct rtl_hal_ops rtl8192cu_hal_
 	.deinit_sw_leds = rtl92cu_deinit_sw_leds,
 	.get_bbreg = rtl92c_phy_query_bb_reg,
 	.set_bbreg = rtl92c_phy_set_bb_reg,
-	.get_rfreg = rtl92c_phy_query_rf_reg,
-	.set_rfreg = rtl92c_phy_set_rf_reg,
+	.get_rfreg = rtl92cu_phy_query_rf_reg,
+	.set_rfreg = rtl92cu_phy_set_rf_reg,
+	.phy_rf6052_config = rtl92cu_phy_rf6052_config,
+	.phy_rf6052_set_cck_txpower = rtl92cu_phy_rf6052_set_cck_txpower,
+	.phy_rf6052_set_ofdm_txpower = rtl92cu_phy_rf6052_set_ofdm_txpower,
+	.config_bb_with_headerfile = _rtl92cu_phy_config_bb_with_headerfile,
+	.config_bb_with_pgheaderfile = _rtl92cu_phy_config_bb_with_pgheaderfile,
+	.phy_lc_calibrate = _rtl92cu_phy_lc_calibrate,
+	.phy_set_bw_mode_callback = rtl92cu_phy_set_bw_mode_callback,
+	.dm_dynamic_txpower = rtl92cu_dm_dynamic_txpower,
 };
 
 static struct rtl_mod_params rtl92cu_mod_params = {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/sw.h
@@ -32,4 +32,22 @@
 
 #define EFUSE_MAX_SECTION	16
 
+void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
+					u8 *powerlevel);
+void rtl92cu_phy_rf6052_set_ofdm_txpower(struct ieee80211_hw *hw,
+					u8 *ppowerlevel, u8 channel);
+bool _rtl92cu_phy_config_bb_with_headerfile(struct ieee80211_hw *hw,
+					    u8 configtype);
+bool _rtl92cu_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
+						    u8 configtype);
+void _rtl92cu_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t);
+void rtl92cu_phy_set_rf_reg(struct ieee80211_hw *hw,
+			   enum radio_path rfpath,
+			   u32 regaddr, u32 bitmask, u32 data);
+bool rtl92cu_phy_set_rf_power_state(struct ieee80211_hw *hw,
+				   enum rf_pwrstate rfpwr_state);
+u32 rtl92cu_phy_query_rf_reg(struct ieee80211_hw *hw,
+			    enum radio_path rfpath, u32 regaddr, u32 bitmask);
+void rtl92cu_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
+
 #endif
Index: wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/wifi.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/wifi.h
@@ -1383,6 +1383,18 @@ struct rtl_hal_ops {
 			  u32 regaddr, u32 bitmask);
 	void (*set_rfreg) (struct ieee80211_hw *hw, enum radio_path rfpath,
 			   u32 regaddr, u32 bitmask, u32 data);
+	bool (*phy_rf6052_config) (struct ieee80211_hw *hw);
+	void (*phy_rf6052_set_cck_txpower) (struct ieee80211_hw *hw,
+					    u8 *powerlevel);
+	void (*phy_rf6052_set_ofdm_txpower) (struct ieee80211_hw *hw,
+					     u8 *ppowerlevel, u8 channel);
+	bool (*config_bb_with_headerfile) (struct ieee80211_hw *hw,
+					   u8 configtype);
+	bool (*config_bb_with_pgheaderfile) (struct ieee80211_hw *hw,
+					     u8 configtype);
+	void (*phy_lc_calibrate) (struct ieee80211_hw *hw, bool is2t);
+	void (*phy_set_bw_mode_callback) (struct ieee80211_hw *hw);
+	void (*dm_dynamic_txpower) (struct ieee80211_hw *hw);
 };
 
 struct rtl_intf_ops {
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/main.c
===================================================================
--- /dev/null
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192c/main.c
@@ -0,0 +1,41 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2009-2010  Realtek Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * wlanfae <wlanfae@realtek.com>
+ * Realtek Corporation, No. 2, Innovation Road II, Hsinchu Science Park,
+ * Hsinchu 300, Taiwan.
+ *
+ * Larry Finger <Larry.Finger@lwfinger.net>
+ *
+ *****************************************************************************/
+
+#include "../wifi.h"
+
+
+MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
+MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
+MODULE_AUTHOR("Georgia		<georgia@realtek.com>");
+MODULE_AUTHOR("Ziv Huang	<ziv_huang@realtek.com>");
+MODULE_AUTHOR("Larry Finger	<Larry.Finger@lwfinger.net>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Realtek 8192C/8188C 802.11n PCI wireless");
+
+
