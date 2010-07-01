Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49983 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933498Ab0GAWKD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 18:10:03 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/6] ath9k_hw: fix a few inconsistencies in initval array names
Date: Fri,  2 Jul 2010 00:09:47 +0200
Message-Id: <1278022192-83277-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c       |   12 ++++++------
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
index 0b94bd3..760be1f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9001_initvals.h
@@ -1217,7 +1217,7 @@ static const u32 ar5416Addac_9160[][2] = {
     {0x000098cc,  0x00000000 },
 };
 
-static const u32 ar5416Addac_91601_1[][2] = {
+static const u32 ar5416Addac_9160_1_1[][2] = {
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
     {0x0000989c,  0x00000000 },
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 0317ac9..75b80d1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -179,8 +179,8 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar5416Bank7_9160), 2);
 		if (AR_SREV_9160_11(ah)) {
 			INIT_INI_ARRAY(&ah->iniAddac,
-				       ar5416Addac_91601_1,
-				       ARRAY_SIZE(ar5416Addac_91601_1), 2);
+				       ar5416Addac_9160_1_1,
+				       ARRAY_SIZE(ar5416Addac_9160_1_1), 2);
 		} else {
 			INIT_INI_ARRAY(&ah->iniAddac, ar5416Addac_9160,
 				       ARRAY_SIZE(ar5416Addac_9160), 2);
@@ -239,12 +239,12 @@ void ar9002_hw_cck_chan14_spread(struct ath_hw *ah)
 {
 	if (AR_SREV_9287_11_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniCckfirNormal,
-		       ar9287Common_normal_cck_fir_coeff_92871_1,
-		       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_92871_1),
+		       ar9287Common_normal_cck_fir_coeff_9287_1_1,
+		       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_9287_1_1),
 		       2);
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
-		       ar9287Common_japan_2484_cck_fir_coeff_92871_1,
-		       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_92871_1),
+		       ar9287Common_japan_2484_cck_fir_coeff_9287_1_1,
+		       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_9287_1_1),
 		       2);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
index 8ab24ee..620fa8c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_initvals.h
@@ -4142,13 +4142,13 @@ static const u32 ar9287Common_9287_1_1[][2] = {
  * registers be programmed differently from the channel between 2412 and
  * 2472 MHz.
  */
-static const u32 ar9287Common_normal_cck_fir_coeff_92871_1[][2] = {
+static const u32 ar9287Common_normal_cck_fir_coeff_9287_1_1[][2] = {
     { 0x0000a1f4, 0x00fffeff },
     { 0x0000a1f8, 0x00f5f9ff },
     { 0x0000a1fc, 0xb79f6427 },
 };
 
-static const u32 ar9287Common_japan_2484_cck_fir_coeff_92871_1[][2] = {
+static const u32 ar9287Common_japan_2484_cck_fir_coeff_9287_1_1[][2] = {
     { 0x0000a1f4, 0x00000000 },
     { 0x0000a1f8, 0xefff0301 },
     { 0x0000a1fc, 0xca9228ee },
-- 
1.6.4.2

