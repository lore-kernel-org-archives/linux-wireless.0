Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41719 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab1FUJZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:25:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 30/32] ath9k: configure internal regulator for AR9330
Date: Tue, 21 Jun 2011 11:23:50 +0200
Message-Id: <1308648232-9906-31-git-send-email-juhosg@openwrt.org> (sfid-20110621_112536_854273_A3CFB395)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   25 +++++++++++++++++++----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 666a174..1d09f22 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3712,7 +3712,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 		ath9k_hw_ar9300_get_eeprom(ah, EEP_INTERNAL_REGULATOR);
 
 	if (internal_regulator) {
-		if (AR_SREV_9485(ah)) {
+		if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
 			int reg_pmu_set;
 
 			reg_pmu_set = REG_READ(ah, AR_PHY_PMU2) & ~AR_PHY_PMU2_PGM;
@@ -3720,9 +3720,24 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
 				return;
 
-			reg_pmu_set = (5 << 1) | (7 << 4) | (1 << 8) |
-				      (2 << 14) | (6 << 17) | (1 << 20) |
-				      (3 << 24) | (1 << 28);
+			if (AR_SREV_9330(ah)) {
+				if (ah->is_clk_25mhz) {
+					reg_pmu_set = (3 << 1) | (8 << 4) |
+						      (3 << 8) | (1 << 14) |
+						      (6 << 17) | (1 << 20) |
+						      (3 << 24);
+				} else {
+					reg_pmu_set = (4 << 1)  | (7 << 4) |
+						      (3 << 8)  | (1 << 14) |
+						      (6 << 17) | (1 << 20) |
+						      (3 << 24);
+				}
+			} else {
+				reg_pmu_set = (5 << 1) | (7 << 4) |
+					      (1 << 8) | (2 << 14) |
+					      (6 << 17) | (1 << 20) |
+					      (3 << 24) | (1 << 28);
+			}
 
 			REG_WRITE(ah, AR_PHY_PMU1, reg_pmu_set);
 			if (!is_pmu_set(ah, AR_PHY_PMU1, reg_pmu_set))
@@ -3753,7 +3768,7 @@ static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 					   AR_RTC_REG_CONTROL1_SWREG_PROGRAM);
 		}
 	} else {
-		if (AR_SREV_9485(ah)) {
+		if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
 			REG_RMW_FIELD(ah, AR_PHY_PMU2, AR_PHY_PMU2_PGM, 0);
 			while (REG_READ_FIELD(ah, AR_PHY_PMU2,
 					      AR_PHY_PMU2_PGM))
-- 
1.7.2.1

