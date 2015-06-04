Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35804 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbbFDIoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 04:44:00 -0400
Received: by pdbnf5 with SMTP id nf5so26402408pdb.2
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 01:43:59 -0700 (PDT)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: ap420073@gmail.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] rtlwifi: rtl8192cu: remove INTF_PCI and INTF_USB
Date: Thu,  4 Jun 2015 17:43:35 +0900
Message-Id: <1433407416-752-2-git-send-email-ap420073@gmail.com> (sfid-20150604_104404_301696_5441C666)
In-Reply-To: <1433407416-752-1-git-send-email-ap420073@gmail.com>
References: <1433407416-752-1-git-send-email-ap420073@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

in the rtlwifi/rtl8192cu, INTF_PCI and INTF_USB is unnecessary.
because RTL8192CU chipset is only USB interface.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
index b878d56..4440a37 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
@@ -74,14 +74,8 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
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
@@ -90,11 +84,8 @@ void rtl92cu_phy_rf6052_set_cck_txpower(struct ieee80211_hw *hw,
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

