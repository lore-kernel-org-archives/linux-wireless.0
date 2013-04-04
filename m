Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26510 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764396Ab3DDTlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 15:41:10 -0400
Date: Thu, 04 Apr 2013 14:41:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, linux-wireless@vger.kernel.org
Subject: [PATCH -next] rtlwifi: rtl8188ee: Fix allyesconfig build failures
Message-ID: <515dd752.veL9DkfmA9i3uFpk%Larry.Finger@lwfinger.net> (sfid-20130404_214114_628700_B9F84362)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An allyesconfig build of rtl8188ee yields the following duplicate entry points:

drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `.rtl92c_phy_ap_calibrate':
(.text+0x21d14): multiple definition of `.rtl92c_phy_ap_calibrate'
drivers/net/wireless/rtlwifi/rtl8192c/built-in.o:(.text+0xb1e8): first defined here
drivers/net/wireless/rtlwifi/rtl8188ee/built-in.o: In function `rtl_hal_pwrseqcmdparsing':
(.opd+0xed0): multiple definition of `rtl_hal_pwrseqcmdparsing'

One of the routines is not used and can be deleted, the other is renamed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>


Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/phy.c
@@ -2001,16 +2001,6 @@ void rtl88e_phy_lc_calibrate(struct ieee
 	rtlphy->lck_inprogress = false;
 }
 
-void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-
-	if (rtlphy->apk_done)
-		return;
-	return;
-}
-
 void rtl88e_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain)
 {
 	rfpath_switch(hw, bmain, false);
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/phy.h
@@ -225,7 +225,6 @@ extern void rtl88e_phy_set_bw_mode(struc
 extern void rtl88e_phy_sw_chnl_callback(struct ieee80211_hw *hw);
 extern u8 rtl88e_phy_sw_chnl(struct ieee80211_hw *hw);
 extern void rtl88e_phy_iq_calibrate(struct ieee80211_hw *hw, bool b_recovery);
-void rtl92c_phy_ap_calibrate(struct ieee80211_hw *hw, char delta);
 void rtl88e_phy_lc_calibrate(struct ieee80211_hw *hw);
 void rtl88e_phy_set_rfpath_switch(struct ieee80211_hw *hw, bool bmain);
 bool rtl88e_phy_config_rf_with_headerfile(struct ieee80211_hw *hw,
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/hw.c
@@ -814,11 +814,11 @@ static bool _rtl88ee_init_mac(struct iee
 
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x00);
 	/* HW Power on sequence */
-	if (!rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				      PWR_INTF_PCI_MSK,
-				      Rtl8188E_NIC_ENABLE_FLOW)) {
+	if (!rtl88_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK,
+					PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,
+					Rtl8188E_NIC_ENABLE_FLOW)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
-			 "init MAC Fail as rtl_hal_pwrseqcmdparsing\n");
+			 "init MAC Fail as rtl88_hal_pwrseqcmdparsing\n");
 		return false;
 	}
 
@@ -1344,8 +1344,9 @@ static void _rtl88ee_poweroff_adapter(st
 	}
 	rtl_write_byte(rtlpriv, REG_PCIE_CTRL_REG+1, 0xFF);
 
-	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				 PWR_INTF_PCI_MSK, Rtl8188E_NIC_LPS_ENTER_FLOW);
+	rtl88_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
+				   PWR_INTF_PCI_MSK,
+				   Rtl8188E_NIC_LPS_ENTER_FLOW);
 
 	rtl_write_byte(rtlpriv, REG_RF_CTRL, 0x00);
 
@@ -1359,8 +1360,8 @@ static void _rtl88ee_poweroff_adapter(st
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_32K_CTRL);
 	rtl_write_byte(rtlpriv, REG_32K_CTRL, (u1b_tmp & (~BIT(0))));
 
-	rtl_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
-				 PWR_INTF_PCI_MSK, Rtl8188E_NIC_DISABLE_FLOW);
+	rtl88_hal_pwrseqcmdparsing(rtlpriv, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK,
+				   PWR_INTF_PCI_MSK, Rtl8188E_NIC_DISABLE_FLOW);
 
 	u1b_tmp = rtl_read_byte(rtlpriv, REG_RSV_CTRL+1);
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL+1, (u1b_tmp & (~BIT(3))));
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.c
@@ -39,9 +39,9 @@
  *	2011.07.07, added by Roger.
  */
 
-bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
-			      u8 fab_version, u8 interface_type,
-			      struct wlan_pwr_cfg pwrcfgcmd[])
+bool rtl88_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
+				u8 fab_version, u8 interface_type,
+				struct wlan_pwr_cfg pwrcfgcmd[])
 {
 	struct wlan_pwr_cfg cmd = {0};
 	bool polling_bit = false;
@@ -54,7 +54,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl
 	do {
 		cmd = pwrcfgcmd[ary_idx];
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "rtl_hal_pwrseqcmdparsing(): offset(%#x), cut_msk(%#x), fab_msk(%#x),"
+			 "rtl88_hal_pwrseqcmdparsing(): offset(%#x), cut_msk(%#x), fab_msk(%#x),"
 			 "interface_msk(%#x), base(%#x), cmd(%#x), msk(%#x), val(%#x)\n",
 			 GET_PWR_CFG_OFFSET(cmd),
 			 GET_PWR_CFG_CUT_MASK(cmd),
@@ -71,11 +71,11 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl
 			switch (GET_PWR_CFG_CMD(cmd)) {
 			case PWR_CMD_READ:
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					 "rtl_hal_pwrseqcmdparsing(): PWR_CMD_READ\n");
+					 "rtl88_hal_pwrseqcmdparsing(): PWR_CMD_READ\n");
 				break;
 			case PWR_CMD_WRITE: {
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					 "rtl_hal_pwrseqcmdparsing(): PWR_CMD_WRITE\n");
+					 "rtl88_hal_pwrseqcmdparsing(): PWR_CMD_WRITE\n");
 				offset = GET_PWR_CFG_OFFSET(cmd);
 
 					/*Read the val from system register*/
@@ -90,7 +90,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl
 				break;
 			case PWR_CMD_POLLING:
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					 "rtl_hal_pwrseqcmdparsing(): PWR_CMD_POLLING\n");
+					 "rtl88_hal_pwrseqcmdparsing(): PWR_CMD_POLLING\n");
 				polling_bit = false;
 				offset = GET_PWR_CFG_OFFSET(cmd);
 
@@ -115,7 +115,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl
 				break;
 			case PWR_CMD_DELAY:
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					 "rtl_hal_pwrseqcmdparsing(): PWR_CMD_DELAY\n");
+					 "rtl88_hal_pwrseqcmdparsing(): PWR_CMD_DELAY\n");
 				if (GET_PWR_CFG_VALUE(cmd) == PWRSEQ_DELAY_US)
 					udelay(GET_PWR_CFG_OFFSET(cmd));
 				else
@@ -123,12 +123,12 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl
 				break;
 			case PWR_CMD_END:
 				RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-					 "rtl_hal_pwrseqcmdparsing(): PWR_CMD_END\n");
+					 "rtl88_hal_pwrseqcmdparsing(): PWR_CMD_END\n");
 				return true;
 				break;
 			default:
 				RT_ASSERT(false,
-					  "rtl_hal_pwrseqcmdparsing(): Unknown CMD!!\n");
+					  "rtl88_hal_pwrseqcmdparsing(): Unknown CMD!!\n");
 				break;
 			}
 		}
Index: wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/rtl8188ee/pwrseqcmd.h
@@ -90,8 +90,8 @@ struct wlan_pwr_cfg {
 #define	GET_PWR_CFG_MASK(__PWR)		(__PWR.msk)
 #define	GET_PWR_CFG_VALUE(__PWR)	(__PWR.value)
 
-bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
-			      u8 fab_version, u8 interface_type,
-			      struct wlan_pwr_cfg pwrcfgcmd[]);
+bool rtl88_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
+				u8 fab_version, u8 interface_type,
+				struct wlan_pwr_cfg pwrcfgcmd[]);
 
 #endif
