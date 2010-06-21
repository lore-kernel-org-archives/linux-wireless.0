Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0FUWix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 18:38:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Aeolus Yang <aeolus.yang@atheros.com>,
	Madhan Jaganathan <madhan.jaganathan@atheros.com>
Subject: [PATCH 1/5] ath9k_hw: fix ASPM setting for AR9003
Date: Mon, 21 Jun 2010 18:38:47 -0400
Message-Id: <1277159931-7797-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
References: <1277159931-7797-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR_WA register should not be read when in sleep state so
add a variable we can stash its value into for when we need
to set it. Additionally the AR_WA_D3_TO_L1_DISABLE_REAL
(bit 16) needs to be removed.

Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: Madhan Jaganathan <madhan.jaganathan@atheros.com>
signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    2 +
 drivers/net/wireless/ath/ath9k/hw.c        |   45 ++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/hw.h        |    6 ++++
 drivers/net/wireless/ath/ath9k/reg.h       |    5 +++
 4 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 82c3ab7..b4a9441 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -295,6 +295,8 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 		/* Several PCIe massages to ensure proper behaviour */
 		if (ah->config.pcie_waen)
 			REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
+		else
+			REG_WRITE(ah, AR_WA, ah->WARegVal);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 62597f4..fb09042 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -575,14 +575,8 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	 * This enables PCIe low power mode.
 	 */
 	if (AR_SREV_9300_20_OR_LATER(ah)) {
-		u32 regval;
 		unsigned int i;
 
-		/* Set Bits 16 and 17 in the AR_WA register. */
-		regval = REG_READ(ah, AR_WA);
-		regval |= 0x00030000;
-		REG_WRITE(ah, AR_WA, regval);
-
 		for (i = 0; i < ah->iniPcieSerdesLowPower.ia_rows; i++) {
 			REG_WRITE(ah,
 				  INI_RA(&ah->iniPcieSerdesLowPower, i, 0),
@@ -590,6 +584,15 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		}
 	}
 
+	/*
+	 * Read back AR_WA into a permanent copy and set bits 14 and 17.
+	 * We need to do this to avoid RMW of this register. We cannot
+	 * read the reg when chip is asleep.
+	 */
+	ah->WARegVal = REG_READ(ah, AR_WA);
+	ah->WARegVal |= (AR_WA_D3_L1_DISABLE |
+			 AR_WA_ASPM_TIMER_BASED_DISABLE);
+
 	if (ah->is_pciexpress)
 		ath9k_hw_configpcipowersave(ah, 0, 0);
 	else
@@ -1009,6 +1012,11 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_WA, ah->WARegVal);
+		udelay(10);
+	}
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
@@ -1063,6 +1071,11 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 {
 	ENABLE_REGWRITE_BUFFER(ah);
 
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_WA, ah->WARegVal);
+		udelay(10);
+	}
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_EN |
 		  AR_RTC_FORCE_WAKE_ON_INT);
 
@@ -1099,6 +1112,11 @@ static bool ath9k_hw_set_reset_power_on(struct ath_hw *ah)
 
 static bool ath9k_hw_set_reset_reg(struct ath_hw *ah, u32 type)
 {
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_WA, ah->WARegVal);
+		udelay(10);
+	}
+
 	REG_WRITE(ah, AR_RTC_FORCE_WAKE,
 		  AR_RTC_FORCE_WAKE_EN | AR_RTC_FORCE_WAKE_ON_INT);
 
@@ -1768,6 +1786,11 @@ static void ath9k_set_power_sleep(struct ath_hw *ah, int setChip)
 			REG_CLR_BIT(ah, (AR_RTC_RESET),
 				    AR_RTC_RESET_EN);
 	}
+
+	/* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		REG_WRITE(ah, AR_WA,
+			  ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
 }
 
 /*
@@ -1794,6 +1817,10 @@ static void ath9k_set_power_network_sleep(struct ath_hw *ah, int setChip)
 				    AR_RTC_FORCE_WAKE_EN);
 		}
 	}
+
+	/* Clear Bit 14 of AR_WA after putting chip into Net Sleep mode. */
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
 }
 
 static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
@@ -1801,6 +1828,12 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah, int setChip)
 	u32 val;
 	int i;
 
+	/* Set Bits 14 and 17 of AR_WA before powering on the chip. */
+	if (AR_SREV_9300_20_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_WA, ah->WARegVal);
+		udelay(10);
+	}
+
 	if (setChip) {
 		if ((REG_READ(ah, AR_RTC_STATUS) &
 		     AR_RTC_STATUS_M) == AR_RTC_STATUS_SHUTDOWN) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5ecbfcf..6c6d47b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -819,6 +819,12 @@ struct ath_hw {
 
 	u32 paprd_gain_table_entries[PAPRD_GAIN_TABLE_ENTRIES];
 	u8 paprd_gain_table_index[PAPRD_GAIN_TABLE_ENTRIES];
+	/*
+	 * Store the permanent value of Reg 0x4004in WARegVal
+	 * so we dont have to R/M/W. We should not be reading
+	 * this register when in sleep states.
+	 */
+	u32 WARegVal;
 };
 
 static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 3e3ccef..47be667 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -704,6 +704,11 @@
 #define AR_WA_BIT7			(1 << 7)
 #define AR_WA_BIT23			(1 << 23)
 #define AR_WA_D3_L1_DISABLE		(1 << 14)
+#define AR_WA_D3_TO_L1_DISABLE_REAL     (1 << 16)
+#define AR_WA_ASPM_TIMER_BASED_DISABLE  (1 << 17)
+#define AR_WA_RESET_EN                  (1 << 18) /* Sw Control to enable PCI-Reset to POR (bit 15) */
+#define AR_WA_ANALOG_SHIFT              (1 << 20)
+#define AR_WA_POR_SHORT                 (1 << 21) /* PCI-E Phy reset control */
 #define AR9285_WA_DEFAULT		0x004a050b
 #define AR9280_WA_DEFAULT           	0x0040073b
 #define AR_WA_DEFAULT               	0x0000073f
-- 
1.6.3.3

