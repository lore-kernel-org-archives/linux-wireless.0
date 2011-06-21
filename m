Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41697 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1FUJY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 05:24:56 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 09/32] ath9k: add AR9330 specific PLL initialization
Date: Tue, 21 Jun 2011 11:23:29 +0200
Message-Id: <1308648232-9906-10-git-send-email-juhosg@openwrt.org> (sfid-20110621_112515_339675_F42EFB6F)
In-Reply-To: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
References: <1308648232-9906-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |   35 ++++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9840e00..99c90f7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -733,6 +733,39 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
 			      AR_CH0_BB_DPLL2_PLL_PWD, 0x0);
 		udelay(1000);
+	} else if (AR_SREV_9330(ah)) {
+		u32 ddr_dpll2, pll_control2, kd;
+
+		if (ah->is_clk_25mhz) {
+			ddr_dpll2 = 0x18e82f01;
+			pll_control2 = 0xe04a3d;
+			kd = 0x1d;
+		} else {
+			ddr_dpll2 = 0x19e82f01;
+			pll_control2 = 0x886666;
+			kd = 0x3d;
+		}
+
+		/* program DDR PLL ki and kd value */
+		REG_WRITE(ah, AR_CH0_DDR_DPLL2, ddr_dpll2);
+
+		/* program DDR PLL phase_shift */
+		REG_RMW_FIELD(ah, AR_CH0_DDR_DPLL3,
+			      AR_CH0_DPLL3_PHASE_SHIFT, 0x1);
+
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
+		udelay(1000);
+
+		/* program refdiv, nint, frac to RTC register */
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL2, pll_control2);
+
+		/* program BB PLL kd and ki value */
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2, AR_CH0_DPLL2_KD, kd);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2, AR_CH0_DPLL2_KI, 0x06);
+
+		/* program BB PLL phase_shift */
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
+			      AR_CH0_BB_DPLL3_PHASE_SHIFT, 0x1);
 	} else if (AR_SREV_9340(ah)) {
 		u32 regval, pll2_divint, pll2_divfrac, refdiv;
 
@@ -774,7 +807,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
-	if (AR_SREV_9485(ah) || AR_SREV_9340(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
 		udelay(1000);
 
 	/* Switch the core clock for ar9271 to 117Mhz */
-- 
1.7.2.1

