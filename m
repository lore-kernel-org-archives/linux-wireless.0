Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26671 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab1DTE4F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 00:56:05 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 21:55:39 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH V3 04/22] ath9k_hw: Configure pll control register accordingly for AR9340
Date: Wed, 20 Apr 2011 10:26:15 +0530
Message-ID: <1303275375-28238-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
V3 - Remove AR9485 specific pll change, that should be in different patch


 drivers/net/wireless/ath/ath9k/hw.c  |   50 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h  |    2 +-
 drivers/net/wireless/ath/ath9k/phy.h |    3 ++
 drivers/net/wireless/ath/ath9k/reg.h |    4 ++-
 4 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8c0364f..5a648e7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -716,13 +716,48 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
 			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
+	} else if (AR_SREV_9340(ah)) {
+		u32 regval, pll2_divint, pll2_divfrac, refdiv;
+
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
+		udelay(1000);
+
+		REG_SET_BIT(ah, AR_PHY_PLL_MODE, 0x1 << 16);
+		udelay(100);
+
+		if (ah->is_clk_25mhz) {
+			pll2_divint = 0x54;
+			pll2_divfrac = 0x1eb85;
+			refdiv = 3;
+		} else {
+			pll2_divint = 88;
+			pll2_divfrac = 0;
+			refdiv = 5;
+		}
+
+		regval = REG_READ(ah, AR_PHY_PLL_MODE);
+		regval |= (0x1 << 16);
+		REG_WRITE(ah, AR_PHY_PLL_MODE, regval);
+		udelay(100);
+
+		REG_WRITE(ah, AR_PHY_PLL_CONTROL, (refdiv << 27) |
+			  (pll2_divint << 18) | pll2_divfrac);
+		udelay(100);
+
+		regval = REG_READ(ah, AR_PHY_PLL_MODE);
+		regval = (regval & 0x80071fff) | (0x1 << 30) | (0x1 << 13) |
+			 (0x4 << 26) | (0x18 << 19);
+		REG_WRITE(ah, AR_PHY_PLL_MODE, regval);
+		REG_WRITE(ah, AR_PHY_PLL_MODE,
+			  REG_READ(ah, AR_PHY_PLL_MODE) & 0xfffeffff);
+		udelay(1000);
 	}
 
 	pll = ath9k_hw_compute_pll_control(ah, chan);
 
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
-	if (AR_SREV_9485(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah))
 		udelay(1000);
 
 	/* Switch the core clock for ar9271 to 117Mhz */
@@ -734,6 +769,19 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 	udelay(RTC_PLL_SETTLE_DELAY);
 
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
+
+	if (AR_SREV_9340(ah)) {
+		if (ah->is_clk_25mhz) {
+			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
+			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
+			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e7ae);
+		} else {
+			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x261 << 1);
+			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f400);
+			REG_WRITE(ah,  AR_SLP32_INC, 0x0001e800);
+		}
+		udelay(100);
+	}
 }
 
 static void ath9k_hw_init_interrupt_masks(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8e3618a..b08df20 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -122,7 +122,7 @@
 #define AR_GPIO_BIT(_gpio)          (1 << (_gpio))
 
 #define BASE_ACTIVATE_DELAY         100
-#define RTC_PLL_SETTLE_DELAY        100
+#define RTC_PLL_SETTLE_DELAY        (AR_SREV_9340(ah) ? 1000 : 100)
 #define COEF_SCALE_S                24
 #define HT40_CHANNEL_CENTER_SHIFT   10
 
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index 8e5fe9d..9441bf8 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -45,4 +45,7 @@
 #define	AR_PHY_TIMING11_SPUR_FREQ_SD		0x3FF00000
 #define	AR_PHY_TIMING11_SPUR_FREQ_SD_S		20
 
+#define AR_PHY_PLL_CONTROL 0x16180
+#define AR_PHY_PLL_MODE 0x16184
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 42d9f1b..b42e36c 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1180,6 +1180,7 @@ enum {
 #define AR_RTC_PLL_REFDIV_5     0x000000c0
 #define AR_RTC_PLL_CLKSEL       0x00000300
 #define AR_RTC_PLL_CLKSEL_S     8
+#define AR_RTC_PLL_BYPASS	0x00010000
 
 #define PLL3 0x16188
 #define PLL3_DO_MEAS_MASK 0x40000000
@@ -1226,7 +1227,8 @@ enum {
 
 /* RTC_DERIVED_* - only for AR9100 */
 
-#define AR_RTC_DERIVED_CLK           (AR_RTC_BASE + 0x0038)
+#define AR_RTC_DERIVED_CLK \
+	(AR_SREV_9100(ah) ? (AR_RTC_BASE + 0x0038) : 0x7038)
 #define AR_RTC_DERIVED_CLK_PERIOD    0x0000fffe
 #define AR_RTC_DERIVED_CLK_PERIOD_S  1
 
-- 
1.7.0.4

