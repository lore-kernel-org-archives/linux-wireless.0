Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:59239 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab0LBLOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 06:14:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 03:13:52 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 18/27] ath9k_hw: Configure internal regulator for AR9485
Date: Thu, 2 Dec 2010 03:07:02 -0800
Message-ID: <1291288031-3409-19-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
References: <1291288031-3409-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   89 ++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |    8 ++
 2 files changed, 82 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 133e142..e7ba662 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3652,29 +3652,88 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 }
 
+static bool is_pmu_set(struct ath_hw *ah, int pmu_set, u32 pmu_reg)
+{
+	int timeout = 100;
+
+	while (pmu_set != REG_READ(ah, pmu_reg)) {
+		if (timeout-- == 0)
+			return false;
+		REG_WRITE(ah, pmu_reg, pmu_set);
+		udelay(10);
+	}
+
+	return true;
+}
+
 static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 {
 	int internal_regulator =
 		ath9k_hw_ar9300_get_eeprom(ah, EEP_INTERNAL_REGULATOR);
 
 	if (internal_regulator) {
-		/* Internal regulator is ON. Write swreg register. */
-		int swreg = ath9k_hw_ar9300_get_eeprom(ah, EEP_SWREG);
-		REG_WRITE(ah, AR_RTC_REG_CONTROL1,
-		REG_READ(ah, AR_RTC_REG_CONTROL1) &
-			 (~AR_RTC_REG_CONTROL1_SWREG_PROGRAM));
-		REG_WRITE(ah, AR_RTC_REG_CONTROL0, swreg);
-		/* Set REG_CONTROL1.SWREG_PROGRAM */
-		REG_WRITE(ah, AR_RTC_REG_CONTROL1,
-			  REG_READ(ah,
-				   AR_RTC_REG_CONTROL1) |
-				   AR_RTC_REG_CONTROL1_SWREG_PROGRAM);
+		if (AR_SREV_9485(ah)) {
+			int reg_pmu_set;
+
+			reg_pmu_set = REG_READ(ah, AR_PHY_PMU2) & ~AR_PHY_PMU2_PGM;
+			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
+			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
+				return;
+
+			reg_pmu_set = (5 << 1) | (7 << 4) | (1 << 8) |
+				      (7 << 14) | (6 << 17) | (1 << 20) |
+				      (3 << 24) | (1 << 28);
+
+			REG_WRITE(ah, AR_PHY_PMU1, reg_pmu_set);
+			if (!is_pmu_set(ah, AR_PHY_PMU1, reg_pmu_set))
+				return;
+
+			reg_pmu_set = (REG_READ(ah, AR_PHY_PMU2) & ~0xFFC00000)
+					| (4 << 26);
+			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
+			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
+				return;
+
+			reg_pmu_set = (REG_READ(ah, AR_PHY_PMU2) & ~0x00200000)
+					| (1 << 21);
+			REG_WRITE(ah, AR_PHY_PMU2, reg_pmu_set);
+			if (!is_pmu_set(ah, AR_PHY_PMU2, reg_pmu_set))
+				return;
+		} else {
+			/* Internal regulator is ON. Write swreg register. */
+			int swreg = ath9k_hw_ar9300_get_eeprom(ah, EEP_SWREG);
+			REG_WRITE(ah, AR_RTC_REG_CONTROL1,
+				  REG_READ(ah, AR_RTC_REG_CONTROL1) &
+				  (~AR_RTC_REG_CONTROL1_SWREG_PROGRAM));
+			REG_WRITE(ah, AR_RTC_REG_CONTROL0, swreg);
+			/* Set REG_CONTROL1.SWREG_PROGRAM */
+			REG_WRITE(ah, AR_RTC_REG_CONTROL1,
+				  REG_READ(ah,
+					   AR_RTC_REG_CONTROL1) |
+					   AR_RTC_REG_CONTROL1_SWREG_PROGRAM);
+		}
 	} else {
-		REG_WRITE(ah, AR_RTC_SLEEP_CLK,
-			  (REG_READ(ah,
-				    AR_RTC_SLEEP_CLK) |
-				    AR_RTC_FORCE_SWREG_PRD));
+		if (AR_SREV_9485(ah)) {
+			REG_RMW_FIELD(ah, AR_PHY_PMU2, AR_PHY_PMU2_PGM, 0);
+			while (REG_READ_FIELD(ah, AR_PHY_PMU2,
+					      AR_PHY_PMU2_PGM))
+				udelay(10);
+
+			REG_RMW_FIELD(ah, AR_PHY_PMU1, AR_PHY_PMU1_PWD, 0x1);
+			while (!REG_READ_FIELD(ah, AR_PHY_PMU1,
+					       AR_PHY_PMU1_PWD))
+				udelay(10);
+			REG_RMW_FIELD(ah, AR_PHY_PMU2, AR_PHY_PMU2_PGM, 0x1);
+			while (!REG_READ_FIELD(ah, AR_PHY_PMU2,
+					      AR_PHY_PMU2_PGM))
+				udelay(10);
+		} else
+			REG_WRITE(ah, AR_RTC_SLEEP_CLK,
+				  (REG_READ(ah,
+				   AR_RTC_SLEEP_CLK) |
+				   AR_RTC_FORCE_SWREG_PRD));
 	}
+
 }
 
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index 6e0d4ad..8de3ffd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -598,6 +598,14 @@
 #define AR_CH0_TOP2_XPABIASLVL		0xf000
 #define AR_CH0_TOP2_XPABIASLVL_S	12
 
+#define AR_PHY_PMU1		0x16c40
+#define AR_PHY_PMU1_PWD		0x1
+#define AR_PHY_PMU1_PWD_S	0
+
+#define AR_PHY_PMU2		0x16c44
+#define AR_PHY_PMU2_PGM		0x00200000
+#define AR_PHY_PMU2_PGM_S	21
+
 #define AR_PHY_RX1DB_BIQUAD_LONG_SHIFT		0x00380000
 #define AR_PHY_RX1DB_BIQUAD_LONG_SHIFT_S	19
 #define AR_PHY_RX6DB_BIQUAD_LONG_SHIFT		0x00c00000
-- 
1.7.0.4

