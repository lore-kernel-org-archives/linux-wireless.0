Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54310 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2DPT1V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:27:21 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 4/5] ath9k: merge power correction constants
Date: Mon, 16 Apr 2012 22:22:49 +0200
Message-Id: <1334607770-26090-4-git-send-email-juhosg@openwrt.org> (sfid-20120416_212724_667094_8317B9B9)
In-Reply-To: <1334607770-26090-1-git-send-email-juhosg@openwrt.org>
References: <1334607770-26090-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The existing constants are used for reduction/increase
tx power level on devices with 2x2 and 3x3 chainmask.

Both reduction and increase must use the same value, so
it makes no sense to use separate constants for them.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/eeprom.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/eeprom.h |    7 ++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 6a64dec..9457825 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -303,10 +303,10 @@ u16 ath9k_hw_get_scaled_power(struct ath_hw *ah, u16 power_limit,
 	case 1:
 		break;
 	case 2:
-		reduction += REDUCE_SCALED_POWER_BY_TWO_CHAIN;
+		reduction += POWER_CORRECTION_FOR_TWO_CHAIN;
 		break;
 	case 3:
-		reduction += REDUCE_SCALED_POWER_BY_THREE_CHAIN;
+		reduction += POWER_CORRECTION_FOR_THREE_CHAIN;
 		break;
 	}
 
@@ -327,10 +327,10 @@ void ath9k_hw_update_regulatory_maxpower(struct ath_hw *ah)
 	case 1:
 		break;
 	case 2:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
+		regulatory->max_power_level += POWER_CORRECTION_FOR_TWO_CHAIN;
 		break;
 	case 3:
-		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
+		regulatory->max_power_level += POWER_CORRECTION_FOR_THREE_CHAIN;
 		break;
 	default:
 		ath_dbg(common, EEPROM, "Invalid chainmask configuration\n");
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 8d779b4..689f0d0 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -79,11 +79,8 @@
 #define SUB_NUM_CTL_MODES_AT_5G_40 2
 #define SUB_NUM_CTL_MODES_AT_2G_40 3
 
-#define INCREASE_MAXPOW_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define INCREASE_MAXPOW_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
-
-#define REDUCE_SCALED_POWER_BY_TWO_CHAIN	6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN	10 /* 10*log10(3)*2 */
+#define POWER_CORRECTION_FOR_TWO_CHAIN		6  /* 10*log10(2)*2 */
+#define POWER_CORRECTION_FOR_THREE_CHAIN	10 /* 10*log10(3)*2 */
 
 /*
  * For AR9285 and later chipsets, the following bits are not being programmed
-- 
1.7.2.1

