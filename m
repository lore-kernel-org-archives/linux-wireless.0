Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:35975 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031516AbcCQSlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:23 -0400
Received: by mail-ob0-f195.google.com with SMTP id cf7so6685440obc.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:23 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 9/9] rtlwifi: rtl8821ae: Fix Smatch warnings
Date: Thu, 17 Mar 2016 13:41:04 -0500
Message-Id: <1458240064-31422-10-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194135_248236_993C5BF0)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c:1960 rtl8812ae_dm_txpower_tracking_callback_thermalmeter() warn: inconsistent indenting
  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:455 phy_get_tx_swing_8812A() warn: inconsistent indenting
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:517 phy_get_tx_swing_8812A() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c  | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 7b13962..636f3d1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -1957,9 +1957,9 @@ void rtl8812ae_dm_txpower_tracking_callback_thermalmeter(
 				rtldm->swing_idx_ofdm_base[p] =
 					rtldm->swing_idx_ofdm[p];
 
-			RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
-				 "pDM_Odm->RFCalibrateInfo.ThermalValue =%d ThermalValue= %d\n",
-				 rtldm->thermalvalue, thermal_value);
+		RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
+			 "pDM_Odm->RFCalibrateInfo.ThermalValue =%d ThermalValue= %d\n",
+			 rtldm->thermalvalue, thermal_value);
 		/*Record last Power Tracking Thermal Value*/
 		rtldm->thermalvalue = thermal_value;
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 74165b3..ddf74d5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -418,9 +418,9 @@ u32 phy_get_tx_swing_8812A(struct ieee80211_hw *hw, u8	band,
 			out = 0x16A; /* -3 dB */
 		}
 	} else {
-	    u32 swing = 0, swing_a = 0, swing_b = 0;
+		u32 swing = 0, swing_a = 0, swing_b = 0;
 
-	    if (band == BAND_ON_2_4G) {
+		if (band == BAND_ON_2_4G) {
 			if (reg_swing_2g == auto_temp) {
 				efuse_shadow_read(hw, 1, 0xC6, (u32 *)&swing);
 				swing = (swing == 0xFF) ? 0x00 : swing;
@@ -514,7 +514,7 @@ u32 phy_get_tx_swing_8812A(struct ieee80211_hw *hw, u8	band,
 
 	RT_TRACE(rtlpriv, COMP_SCAN, DBG_LOUD,
 		 "<=== PHY_GetTxBBSwing_8812A, out = 0x%X\n", out);
-	 return out;
+	return out;
 }
 
 void rtl8821ae_phy_switch_wirelessband(struct ieee80211_hw *hw, u8 band)
-- 
2.1.4

