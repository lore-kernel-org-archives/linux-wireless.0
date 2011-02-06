Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40208 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab1BFSnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 13:43:43 -0500
Date: Sun, 06 Feb 2011 12:44:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sgruszka@redhat.com, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] rtlwifi: rtl8192ce: Rework rtl8192ce/phy.c
Message-ID: <4d4eec14.NZEFs/idkaNYco3C%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the phy.c codes for rtl8192ce and rtl8192cu be as alike as possible.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -37,6 +37,9 @@
 #include "dm.h"
 #include "table.h"
 
+/* Define macro to shorten lines */
+#define MCS_TXPWR	mcs_txpwrlevel_origoffset
+
 static u32 _rtl92c_phy_fw_rf_serial_read(struct ieee80211_hw *hw,
 					 enum radio_path rfpath, u32 offset);
 static void _rtl92c_phy_fw_rf_serial_write(struct ieee80211_hw *hw,
@@ -480,161 +485,129 @@ static void _rtl92c_store_pwrIndex_diffr
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 
 	if (regaddr == RTXAGC_A_RATE18_06) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][0] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][0] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][0] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][0]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][0]));
 	}
 	if (regaddr == RTXAGC_A_RATE54_24) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][1] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][1] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][1] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][1]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][1]));
 	}
 	if (regaddr == RTXAGC_A_CCK1_MCS32) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][6] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][6] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][6] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][6]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][6]));
 	}
 	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0xffffff00) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][7] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][7] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][7] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][7]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][7]));
 	}
 	if (regaddr == RTXAGC_A_MCS03_MCS00) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][2] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][2] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][2] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][2]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][2]));
 	}
 	if (regaddr == RTXAGC_A_MCS07_MCS04) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][3] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][3] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][3] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][3]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][3]));
 	}
 	if (regaddr == RTXAGC_A_MCS11_MCS08) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][4] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][4] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][4] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][4]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][4]));
 	}
 	if (regaddr == RTXAGC_A_MCS15_MCS12) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][5] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][5] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][5] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][5]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][5]));
 	}
 	if (regaddr == RTXAGC_B_RATE18_06) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][8] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][8] = data;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][8] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][8]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][8]));
 	}
 	if (regaddr == RTXAGC_B_RATE54_24) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][9] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][9] = data;
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][9] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][9]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][9]));
 	}
 
 	if (regaddr == RTXAGC_B_CCK1_55_MCS32) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][14] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][14] = data;
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][14] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][14]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][14]));
 	}
 
 	if (regaddr == RTXAGC_B_CCK11_A_CCK2_11 && bitmask == 0x000000ff) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][15] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][15] = data;
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][15] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][15]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][15]));
 	}
 
 	if (regaddr == RTXAGC_B_MCS03_MCS00) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][10] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][10] = data;
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][10] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][10]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][10]));
 	}
 
 	if (regaddr == RTXAGC_B_MCS07_MCS04) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][11] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][11] = data;
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][11] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][11]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][11]));
 	}
 
 	if (regaddr == RTXAGC_B_MCS11_MCS08) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][12] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][12] = data;
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][12] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][12]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][12]));
 	}
 
 	if (regaddr == RTXAGC_B_MCS15_MCS12) {
-		rtlphy->mcs_txpwrlevel_origoffset[rtlphy->pwrgroup_cnt][13] =
-		    data;
+		rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][13] = data;
 
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 ("MCSTxPowerLevelOriginalOffset[%d][13] = 0x%x\n",
 			  rtlphy->pwrgroup_cnt,
-			  rtlphy->mcs_txpwrlevel_origoffset[rtlphy->
-							    pwrgroup_cnt][13]));
+			  rtlphy->MCS_TXPWR[rtlphy->pwrgroup_cnt][13]));
 
 		rtlphy->pwrgroup_cnt++;
 	}

