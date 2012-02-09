Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36814 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2BIC4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 21:56:54 -0500
Date: Wed, 08 Feb 2012 20:56:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: devendra.aaru@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192c-common: rtl8192se: rtl8192de: Simplify
 if statements
Message-ID: <4f3335f4.6Baz/T/V4tG58DvC%Larry.Finger@lwfinger.net> (sfid-20120209_035657_979249_B33B0EF3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devendra Naga <devendra.aaru@gmail.com> submitted a patch for rtl8192c_common
to change the tests in _rtl92c_store_pwrIndex_diffrate_offset(). This patch
improves on those changes and applies similar modifications to drivers rtl8192se
and rtl8192de.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is -next material.

I'm submitting this as it does not appear that Devendra will be submitting a
revised version.

Larry
---
 rtl8192c/phy_common.c |  154 +++++++++++------------------------------
 rtl8192de/phy.c       |  187 +++++++++++---------------------------------------
 rtl8192se/phy.c       |   42 +++++------
 3 files changed, 105 insertions(+), 278 deletions(-)
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -253,121 +253,51 @@ void _rtl92c_store_pwrIndex_diffrate_off
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	int index;
 
-	if (regaddr == RTXAGC_A_RATE18_06) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][0] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][0] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][0]);
-	}
-	if (regaddr == RTXAGC_A_RATE54_24) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][1] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][1] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][1]);
-	}
-	if (regaddr == RTXAGC_A_CCK1_MCS32) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][6] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][6] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][6]);
-	}
-	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][7] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][7] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][7]);
-	}
-	if (regaddr == RTXAGC_A_MCS03_MCS00) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][2] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][2] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][2]);
-	}
-	if (regaddr == RTXAGC_A_MCS07_MCS04) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][3] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][3] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][3]);
-	}
-	if (regaddr == RTXAGC_A_MCS11_MCS08) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][4] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][4] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][4]);
-	}
-	if (regaddr == RTXAGC_A_MCS15_MCS12) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][5] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][5] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][5]);
-	}
-	if (regaddr == RTXAGC_B_RATE18_06) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][8] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][8] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][8]);
-	}
-	if (regaddr == RTXAGC_B_RATE54_24) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][9] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][9] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][9]);
-	}
-	if (regaddr == RTXAGC_B_CCK1_55_MCS32) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][14] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][14] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][14]);
-	}
-	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][15] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][15] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][15]);
-	}
-	if (regaddr == RTXAGC_B_MCS03_MCS00) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][10] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][10] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][10]);
-	}
-	if (regaddr == RTXAGC_B_MCS07_MCS04) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][11] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][11] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][11]);
-	}
-	if (regaddr == RTXAGC_B_MCS11_MCS08) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][12] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][12] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][12]);
-	}
-	if (regaddr == RTXAGC_B_MCS15_MCS12) {
-		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][13] = data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][13] = 0x%x\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][13]);
+	if (regaddr == RTXAGC_A_RATE18_06)
+		index = 0;
+	else if (regaddr == RTXAGC_A_RATE54_24)
+		index = 1;
+	else if (regaddr == RTXAGC_A_CCK1_MCS32)
+		index = 6;
+	else if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00)
+		index = 7;
+	else if (regaddr == RTXAGC_A_MCS03_MCS00)
+		index = 2;
+	else if (regaddr == RTXAGC_A_MCS07_MCS04)
+		index = 3;
+	else if (regaddr == RTXAGC_A_MCS11_MCS08)
+		index = 4;
+	else if (regaddr == RTXAGC_A_MCS15_MCS12)
+		index = 5;
+	else if (regaddr == RTXAGC_B_RATE18_06)
+		index = 8;
+	else if (regaddr == RTXAGC_B_RATE54_24)
+		index = 9;
+	else if (regaddr == RTXAGC_B_CCK1_55_MCS32)
+		index = 14;
+	else if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff)
+		index = 15;
+	else if (regaddr == RTXAGC_B_MCS03_MCS00)
+		index = 10;
+	else if (regaddr == RTXAGC_B_MCS07_MCS04)
+		index = 11;
+	else if (regaddr == RTXAGC_B_MCS11_MCS08)
+		index = 12;
+	else if (regaddr == RTXAGC_B_MCS15_MCS12)
+		index = 13;
+	else
+		return;
 
+	rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][index] = data;
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+		 "MCSTxPowerLevelOriginalOffset[%d][%d] = 0x%x\n",
+		 rtlphy->pwrgroup_cnt, index,
+		 rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][index]);
+
+	if (index == 13)
 		rtlphy->pwrgroup_cnt++;
-	}
 }
 EXPORT_SYMBOL(_rtl92c_store_pwrIndex_diffrate_offset);
 
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -665,152 +665,51 @@ static void _rtl92d_store_pwrindex_diffr
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	int index;
 
-	if (regaddr == RTXAGC_A_RATE18_06) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][0] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][0] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][0]);
-	}
-	if (regaddr == RTXAGC_A_RATE54_24) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][1] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][1] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][1]);
-	}
-	if (regaddr == RTXAGC_A_CCK1_MCS32) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][6] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][6] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][6]);
-	}
-	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][7] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][7] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][7]);
-	}
-	if (regaddr == RTXAGC_A_MCS03_MCS00) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][2] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][2] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][2]);
-	}
-	if (regaddr == RTXAGC_A_MCS07_MCS04) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][3] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][3] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][3]);
-	}
-	if (regaddr == RTXAGC_A_MCS11_MCS08) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][4] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][4] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][4]);
-	}
-	if (regaddr == RTXAGC_A_MCS15_MCS12) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][5] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][5] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][5]);
-	}
-	if (regaddr == RTXAGC_B_RATE18_06) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][8] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][8] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][8]);
-	}
-	if (regaddr == RTXAGC_B_RATE54_24) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][9] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][9] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][9]);
-	}
-	if (regaddr == RTXAGC_B_CCK1_55_MCS32) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][14] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][14] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][14]);
-	}
-	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][15] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][15] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][15]);
-	}
-	if (regaddr == RTXAGC_B_MCS03_MCS00) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][10] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][10] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][10]);
-	}
-	if (regaddr == RTXAGC_B_MCS07_MCS04) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][11] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][11] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][11]);
-	}
-	if (regaddr == RTXAGC_B_MCS11_MCS08) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][12] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][12] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][12]);
-	}
-	if (regaddr == RTXAGC_B_MCS15_MCS12) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][13] =
-									 data;
-		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
-			 "MCSTxPowerLevelOriginalOffset[%d][13] = 0x%ulx\n",
-			 rtlphy->pwrgroup_cnt,
-			 rtlphy->mcs_txpwrlevel_origoffset
-			 [rtlphy->pwrgroup_cnt][13]);
+	if (regaddr == RTXAGC_A_RATE18_06)
+		index = 0;
+	else if (regaddr == RTXAGC_A_RATE54_24)
+		index = 1;
+	else if (regaddr == RTXAGC_A_CCK1_MCS32)
+		index = 6;
+	else if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00)
+		index = 7;
+	else if (regaddr == RTXAGC_A_MCS03_MCS00)
+		index = 2;
+	else if (regaddr == RTXAGC_A_MCS07_MCS04)
+		index = 3;
+	else if (regaddr == RTXAGC_A_MCS11_MCS08)
+		index = 4;
+	else if (regaddr == RTXAGC_A_MCS15_MCS12)
+		index = 5;
+	else if (regaddr == RTXAGC_B_RATE18_06)
+		index = 8;
+	else if (regaddr == RTXAGC_B_RATE54_24)
+		index = 9;
+	else if (regaddr == RTXAGC_B_CCK1_55_MCS32)
+		index = 14;
+	else if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff)
+		index = 15;
+	else if (regaddr == RTXAGC_B_MCS03_MCS00)
+		index = 10;
+	else if (regaddr == RTXAGC_B_MCS07_MCS04)
+		index = 11;
+	else if (regaddr == RTXAGC_B_MCS11_MCS08)
+		index = 12;
+	else if (regaddr == RTXAGC_B_MCS15_MCS12)
+		index = 13;
+	else
+		return;
+
+	rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][index] = data;
+	RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
+		 "MCSTxPowerLevelOriginalOffset[%d][%d] = 0x%ulx\n",
+		 rtlphy->pwrgroup_cnt, index,
+		 rtlphy->mcs_txpwrlevel_origoffset
+		 [rtlphy->pwrgroup_cnt][index]);
+	if (index == 13)
 		rtlphy->pwrgroup_cnt++;
-	}
 }
 
 static bool _rtl92d_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -678,30 +678,28 @@ static void _rtl92s_store_pwrindex_diffr
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
+	int index;
 
 	if (reg_addr == RTXAGC_RATE18_06)
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][0] =
-									 data;
-	if (reg_addr == RTXAGC_RATE54_24)
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][1] =
-									 data;
-	if (reg_addr == RTXAGC_CCK_MCS32)
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][6] =
-									 data;
-	if (reg_addr == RTXAGC_MCS03_MCS00)
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][2] =
-									 data;
-	if (reg_addr == RTXAGC_MCS07_MCS04)
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][3] =
-									 data;
-	if (reg_addr == RTXAGC_MCS11_MCS08)
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][4] =
-									 data;
-	if (reg_addr == RTXAGC_MCS15_MCS12) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][5] =
-									 data;
+		index = 0;
+	else if (reg_addr == RTXAGC_RATE54_24)
+		index = 1;
+	else if (reg_addr == RTXAGC_CCK_MCS32)
+		index = 6;
+	else if (reg_addr == RTXAGC_MCS03_MCS00)
+		index = 2;
+	else if (reg_addr == RTXAGC_MCS07_MCS04)
+		index = 3;
+	else if (reg_addr == RTXAGC_MCS11_MCS08)
+		index = 4;
+	else if (reg_addr == RTXAGC_MCS15_MCS12)
+		index = 5;
+	else
+		return;
+
+	rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][index] = data;
+	if (index == 5)
 		rtlphy->pwrgroup_cnt++;
-	}
 }
 
 static void _rtl92s_phy_init_register_definition(struct ieee80211_hw *hw)
