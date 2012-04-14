Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54881 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102Ab2DNSy0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 14:54:26 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: use ath9k_hw_update_regulatory_maxpower in ath9k_hw_def_set_txpower
Date: Sat, 14 Apr 2012 20:35:19 +0200
Message-Id: <1334428519-959-1-git-send-email-juhosg@openwrt.org> (sfid-20120414_205430_165126_8CC023D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a helper function for updating the max_power_level
value. Use that and remove the duplicated code.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom_def.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 619b95d..43f554e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1263,20 +1263,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 			regulatory->max_power_level = ratesArray[i];
 	}
 
-	switch(ar5416_get_ntxchains(ah->txchainmask)) {
-	case 1:
-		break;
-	case 2:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
-		break;
-	case 3:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
-		break;
-	default:
-		ath_dbg(ath9k_hw_common(ah), EEPROM,
-			"Invalid chainmask configuration\n");
-		break;
-	}
+	ath9k_hw_update_regulatory_maxpower(ah);
 
 	if (test)
 		return;
-- 
1.7.2.1

