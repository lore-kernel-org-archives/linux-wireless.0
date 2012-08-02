Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:38710 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab2HBOBI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 10:01:08 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] ath9k: optimize power level initialization for CTL_[25]GHT20
Date: Thu,  2 Aug 2012 16:00:51 +0200
Message-Id: <1343916052-3367-1-git-send-email-juhosg@openwrt.org> (sfid-20120802_160111_424891_3ACBC1A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first part of the power array is initialized in a loop
and the last two values are initialized separately. Extend
the loop to cover the last two items, and remove the separate
initialization.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index b5c8450..86bd756 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4963,16 +4963,10 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 			case CTL_5GHT20:
 			case CTL_2GHT20:
 				for (i = ALL_TARGET_HT20_0_8_16;
-				     i <= ALL_TARGET_HT20_21; i++)
+				     i <= ALL_TARGET_HT20_23; i++)
 					pPwrArray[i] =
 					  (u8)min((u16)pPwrArray[i],
 						  minCtlPower);
-				pPwrArray[ALL_TARGET_HT20_22] =
-				  (u8)min((u16)pPwrArray[ALL_TARGET_HT20_22],
-					  minCtlPower);
-				pPwrArray[ALL_TARGET_HT20_23] =
-				  (u8)min((u16)pPwrArray[ALL_TARGET_HT20_23],
-					   minCtlPower);
 				break;
 			case CTL_5GHT40:
 			case CTL_2GHT40:
-- 
1.7.10

