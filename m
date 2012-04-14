Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35342 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755966Ab2DNUZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 16:25:04 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/3] ath9k: simplify ath9k_hw_get_scaled_power function
Date: Sat, 14 Apr 2012 22:01:59 +0200
Message-Id: <1334433719-1144-3-git-send-email-juhosg@openwrt.org> (sfid-20120414_222508_109917_8E532E77)
In-Reply-To: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
References: <1334433719-1144-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 61bad99..6a64dec 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -293,9 +293,7 @@ u16 ath9k_hw_get_max_edge_power(u16 freq, struct cal_ctl_edges *pRdEdgesPower,
 u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
 			      u8 antenna_reduction)
 {
-	u16 scaled_power;
-
-	scaled_power = power_limit - antenna_reduction;
+	u16 reduction = antenna_reduction;
 
 	/*
 	 * Reduce scaled Power by number of chains active
@@ -305,22 +303,19 @@ u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
 	case 1:
 		break;
 	case 2:
-		if (scaled_power > REDUCE_SCALED_POWER_BY_TWO_CHAIN)
-			scaled_power -= REDUCE_SCALED_POWER_BY_TWO_CHAIN;
-		else
-			scaled_power = 0;
+		reduction += REDUCE_SCALED_POWER_BY_TWO_CHAIN;
 		break;
 	case 3:
-		if (scaled_power > REDUCE_SCALED_POWER_BY_THREE_CHAIN)
-			scaled_power -= REDUCE_SCALED_POWER_BY_THREE_CHAIN;
-		else
-			scaled_power = 0;
+		reduction += REDUCE_SCALED_POWER_BY_THREE_CHAIN;
 		break;
 	}
 
-	scaled_power = max((u16)0, scaled_power);
+	if (power_limit > reduction)
+		power_limit -= reduction;
+	else
+		power_limit = 0;
 
-	return scaled_power;
+	return power_limit;
 }
 
 void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah)
-- 
1.7.2.1

