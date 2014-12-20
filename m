Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41414 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaLTW4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2014 17:56:31 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so4032727wgh.23
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2014 14:56:30 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: rtlwifi: rtl8723be: phy.c:  Remove unused function
Date: Sat, 20 Dec 2014 23:59:18 +0100
Message-Id: <1419116358-13223-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20141220_235635_799260_3227555E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the function rtl8723be_phy_get_txpower_level() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/net/wireless/rtlwifi/rtl8723be/phy.c |   25 -------------------------
 drivers/net/wireless/rtlwifi/rtl8723be/phy.h |    2 --
 2 files changed, 27 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
index 20dcc25..b7b73cb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/phy.c
@@ -874,31 +874,6 @@ void rtl8723be_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw)
 		  ROFDM0_RXDETECTOR3, rtlphy->framesync);
 }
 
-void rtl8723be_phy_get_txpower_level(struct ieee80211_hw *hw, long *powerlevel)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &rtlpriv->phy;
-	u8 txpwr_level;
-	long txpwr_dbm;
-
-	txpwr_level = rtlphy->cur_cck_txpwridx;
-	txpwr_dbm = rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_B,
-						 txpwr_level);
-	txpwr_level = rtlphy->cur_ofdm24g_txpwridx;
-	if (rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_G, txpwr_level) >
-	    txpwr_dbm)
-		txpwr_dbm =
-		    rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_G,
-						 txpwr_level);
-	txpwr_level = rtlphy->cur_ofdm24g_txpwridx;
-	if (rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_N_24G,
-					 txpwr_level) > txpwr_dbm)
-		txpwr_dbm =
-		    rtl8723_phy_txpwr_idx_to_dbm(hw, WIRELESS_MODE_N_24G,
-						 txpwr_level);
-	*powerlevel = txpwr_dbm;
-}
-
 static u8 _rtl8723be_phy_get_ratesection_intxpower_byrate(enum radio_path path,
 							  u8 rate)
 {
diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/phy.h b/drivers/net/wireless/rtlwifi/rtl8723be/phy.h
index 6339738..9021d47 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/phy.h
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/phy.h
@@ -114,8 +114,6 @@ bool rtl8723be_phy_mac_config(struct ieee80211_hw *hw);
 bool rtl8723be_phy_bb_config(struct ieee80211_hw *hw);
 bool rtl8723be_phy_rf_config(struct ieee80211_hw *hw);
 void rtl8723be_phy_get_hw_reg_originalvalue(struct ieee80211_hw *hw);
-void rtl8723be_phy_get_txpower_level(struct ieee80211_hw *hw,
-				     long *powerlevel);
 void rtl8723be_phy_set_txpower_level(struct ieee80211_hw *hw,
 				     u8 channel);
 void rtl8723be_phy_scan_operation_backup(struct ieee80211_hw *hw,
-- 
1.7.10.4

