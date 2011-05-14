Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1ENPPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 11:15:21 -0400
Date: Sat, 14 May 2011 10:15:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192c-common: rtl8192ce: Fix for HT40
 regression
Message-ID: <4dce9c85.8lZEqlxFlQS542Cf%Larry.Finger@lwfinger.net> (sfid-20110514_171525_700338_E4BDCEDC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The changes that were made to rtl8192ce when rtl8192cu was added broke
HT40. The errors included a typo in rtlwifi, a missing routine in
rtl8192ce and a missing callback of that routine in rtl8192c-common.

This patch fixes the regression reported in Bug #35082.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I know this is very late, but was just discovered. If it does not make
2.6.39, then it needs to be Cc'd to stable for .39.

Thanks,

Larry
---

 ps.c                  |    2 -
 rtl8192c/phy_common.c |    2 -
 rtl8192ce/phy.c       |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rtl8192ce/phy.h       |    1 
 rtl8192ce/sw.c        |    1 
 5 files changed, 73 insertions(+), 2 deletions(-)

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/ps.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/ps.c
@@ -190,7 +190,7 @@ static void _rtl_ps_inactive_ps(struct i
 
 	ppsc->swrf_processing = true;
 
-	if (ppsc->inactive_pwrstate == ERFOFF &&
+	if (ppsc->inactive_pwrstate == ERFON &&
 	    rtlhal->interface == INTF_PCI) {
 		if ((ppsc->reg_rfps_level & RT_RF_OFF_LEVL_ASPM) &&
 		    RT_IN_PS_LEVEL(ppsc, RT_PS_LEVEL_ASPM) &&
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -366,6 +366,75 @@ bool rtl92c_phy_config_rf_with_headerfil
 	return true;
 }
 
+void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw)
+{
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+	u8 reg_bw_opmode;
+	u8 reg_prsr_rsc;
+
+	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE,
+		 ("Switch to %s bandwidth\n",
+		  rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20 ?
+		  "20MHz" : "40MHz"))
+
+	if (is_hal_stop(rtlhal)) {
+		rtlphy->set_bwmode_inprogress = false;
+		return;
+	}
+
+	reg_bw_opmode = rtl_read_byte(rtlpriv, REG_BWOPMODE);
+	reg_prsr_rsc = rtl_read_byte(rtlpriv, REG_RRSR + 2);
+
+	switch (rtlphy->current_chan_bw) {
+	case HT_CHANNEL_WIDTH_20:
+		reg_bw_opmode |= BW_OPMODE_20MHZ;
+		rtl_write_byte(rtlpriv, REG_BWOPMODE, reg_bw_opmode);
+		break;
+	case HT_CHANNEL_WIDTH_20_40:
+		reg_bw_opmode &= ~BW_OPMODE_20MHZ;
+		rtl_write_byte(rtlpriv, REG_BWOPMODE, reg_bw_opmode);
+		reg_prsr_rsc =
+		    (reg_prsr_rsc & 0x90) | (mac->cur_40_prime_sc << 5);
+		rtl_write_byte(rtlpriv, REG_RRSR + 2, reg_prsr_rsc);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
+		break;
+	}
+
+	switch (rtlphy->current_chan_bw) {
+	case HT_CHANNEL_WIDTH_20:
+		rtl_set_bbreg(hw, RFPGA0_RFMOD, BRFMOD, 0x0);
+		rtl_set_bbreg(hw, RFPGA1_RFMOD, BRFMOD, 0x0);
+		rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER2, BIT(10), 1);
+		break;
+	case HT_CHANNEL_WIDTH_20_40:
+		rtl_set_bbreg(hw, RFPGA0_RFMOD, BRFMOD, 0x1);
+		rtl_set_bbreg(hw, RFPGA1_RFMOD, BRFMOD, 0x1);
+
+		rtl_set_bbreg(hw, RCCK0_SYSTEM, BCCK_SIDEBAND,
+			      (mac->cur_40_prime_sc >> 1));
+		rtl_set_bbreg(hw, ROFDM1_LSTF, 0xC00, mac->cur_40_prime_sc);
+		rtl_set_bbreg(hw, RFPGA0_ANALOGPARAMETER2, BIT(10), 0);
+
+		rtl_set_bbreg(hw, 0x818, (BIT(26) | BIT(27)),
+			      (mac->cur_40_prime_sc ==
+			       HAL_PRIME_CHNL_OFFSET_LOWER) ? 2 : 1);
+		break;
+	default:
+		RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG,
+			 ("unknown bandwidth: %#X\n", rtlphy->current_chan_bw));
+		break;
+	}
+	rtl92ce_phy_rf6052_set_bandwidth(hw, rtlphy->current_chan_bw);
+	rtlphy->set_bwmode_inprogress = false;
+	RT_TRACE(rtlpriv, COMP_SCAN, DBG_TRACE, ("<==\n"));
+}
+
 void _rtl92ce_phy_lc_calibrate(struct ieee80211_hw *hw, bool is2t)
 {
 	u8 tmpreg;
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/sw.c
@@ -232,6 +232,7 @@ static struct rtl_hal_ops rtl8192ce_hal_
 	.config_bb_with_headerfile = _rtl92ce_phy_config_bb_with_headerfile,
 	.config_bb_with_pgheaderfile = _rtl92ce_phy_config_bb_with_pgheaderfile,
 	.phy_lc_calibrate = _rtl92ce_phy_lc_calibrate,
+	.phy_set_bw_mode_callback = rtl92ce_phy_set_bw_mode_callback,
 	.dm_dynamic_txpower = rtl92ce_dm_dynamic_txpower,
 };
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192ce/phy.h
@@ -257,5 +257,6 @@ bool _rtl92ce_phy_config_bb_with_headerf
 					    u8 configtype);
 bool _rtl92ce_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 					      u8 configtype);
+void rtl92ce_phy_set_bw_mode_callback(struct ieee80211_hw *hw);
 
 #endif
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -728,7 +728,7 @@ void rtl92c_phy_set_bw_mode(struct ieee8
 		return;
 	rtlphy->set_bwmode_inprogress = true;
 	if ((!is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
-		rtlphy->set_bwmode_inprogress = false;
+		rtlpriv->cfg->ops->phy_set_bw_mode_callback(hw);
 	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 ("FALSE driver sleep or unload\n"));
