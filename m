Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35304 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955Ab2DNUY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 16:24:58 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/3] ath9k: use consistent value for REDUCE_SCALED_POWER_BY_THREE_CHAIN
Date: Sat, 14 Apr 2012 22:01:57 +0200
Message-Id: <1334433719-1144-1-git-send-email-juhosg@openwrt.org> (sfid-20120414_222500_573552_7BE89E01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The REDUCE_SCALED_POWER_BY_THREE_CHAIN symbol is
defined in different eeprom files, and the value
varies between the different files.

In eeprom_def.c and in ar9003_eeprom.c the value
of the symbol is 9, however the comments in these
files indicates the value should be 10*log10(3)*2
which is 9.54242509439325. Replace the the value
to 10 in these files.

Also add comments to eeprom_9287.c.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 672b6c9..25a4a02 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -31,7 +31,7 @@
 #define CTL_11G_EXT (CTL_11G | EXT_ADDITIVE)
 #define CTL_11B_EXT (CTL_11B | EXT_ADDITIVE)
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9  /* 10*log10(3)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 #define PWRINCR_3_TO_1_CHAIN      9             /* 10*log(3)*2 */
 #define PWRINCR_3_TO_2_CHAIN      3             /* floor(10*log(3/2)*2) */
 #define PWRINCR_2_TO_1_CHAIN      6             /* 10*log(2)*2 */
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index f272236..604eab8 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -564,8 +564,8 @@ static void ath9k_hw_set_ar9287_power_per_rate_table(struct ath_hw *ah,
 	(((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) == \
 	 ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))
 
-#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
+#define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
 	u16 twiceMaxEdgePower;
 	int i;
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 619b95d..0068627 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -992,7 +992,7 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 						  u16 powerLimit)
 {
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
-#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9 /* 10*log10(3)*2 */
+#define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	u16 twiceMaxEdgePower;
-- 
1.7.2.1

