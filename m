Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34502 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbbFDJLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 05:11:44 -0400
Received: by payr10 with SMTP id r10so25809700pay.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 02:11:43 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2 2/3] rtlwifi: rtl8192cu: remove INTF_PCI and INTF_USB
Date: Thu,  4 Jun 2015 18:11:33 +0900
Message-Id: <1433409093-9134-1-git-send-email-ap420073@gmail.com> (sfid-20150604_111149_481431_2E853BD6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in the rtlwifi/rtl8192cu, INTF_PCI and INTF_USB is unnecessary.
because RTL8192CU chipset is only USB interface.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
Remove rtlhal to solve warning.

 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index b878d56..844f123 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -66,7 +66,6 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
-	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	u32 tx_agc[2] = { 0, 0 }, tmpval = 0;
@@ -74,14 +73,8 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 	u8 idx1, idx2;
 	u8 *ptr;
 
-	if (rtlhal->interface == INTF_PCI) {
-		if (rtlefuse->eeprom_regulatory != 0)
-			turbo_scanoff = true;
-	} else {
-		if ((rtlefuse->eeprom_regulatory != 0) ||
-		    (rtlefuse->external_pa))
-			turbo_scanoff = true;
-	}
+	if ((rtlefuse->eeprom_regulatory != 0) || (rtlefuse->external_pa))
+		turbo_scanoff = true;
 	if (mac->act_scanning) {
 		tx_agc[RF90_PATH_A] = 0x3f3f3f3f;
 		tx_agc[RF90_PATH_B] = 0x3f3f3f3f;
@@ -90,11 +83,8 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
 			    (ppowerlevel[idx1] << 8) |
 			    (ppowerlevel[idx1] << 16) |
 			    (ppowerlevel[idx1] << 24);
-			if (rtlhal->interface == INTF_USB) {
-				if (tx_agc[idx1] > 0x20 &&
-				    rtlefuse->external_pa)
-					tx_agc[idx1] = 0x20;
-			}
+			if (tx_agc[idx1] > 0x20 && rtlefuse->external_pa)
+				tx_agc[idx1] = 0x20;
 		}
 	} else {
 		if (rtlpriv->dm.dynamic_txhighpower_lvl ==
-- 
2.1.4

