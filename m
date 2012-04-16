Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54274 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab2DPT1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:27:17 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 1/5] ath9k: use consistent value for REDUCE_SCALED_POWER_BY_THREE_CHAIN
Date: Mon, 16 Apr 2012 22:22:46 +0200
Message-Id: <1334607770-26090-1-git-send-email-juhosg@openwrt.org> (sfid-20120416_212721_259041_44F4109F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The REDUCE_SCALED_POWER_BY_THREE_CHAIN symbol is
defined in different eeprom files, but the value
varies between the different files.

In eeprom_def.c and in ar9003_eeprom.c the value
of the symbol is 9, however the comments in these
files indicates the value should be 10*log10(3)*2
which is 9.54242509439325.

The same inconsistency was present in the Atheros
reference code as well, but that has been fixed
lately. Replace the value with 10 in these files
in order to follow the reference code.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
v2: update commit message
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 43f554e..6a85796 100644
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

