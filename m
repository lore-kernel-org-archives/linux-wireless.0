Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:40124 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933261Ab2GCROL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 13:14:11 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	qca-developer-program@qualcomm.com, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 17/20] ath9k: fix PLL initialization for AR9550
Date: Tue,  3 Jul 2012 19:13:31 +0200
Message-Id: <1341335614-15419-18-git-send-email-juhosg@openwrt.org> (sfid-20120703_191419_047110_89653960)
In-Reply-To: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
References: <1341335614-15419-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1ddec4b..991b2ef 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -868,7 +868,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		/* program BB PLL phase_shift */
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
 			      AR_CH0_BB_DPLL3_PHASE_SHIFT, 0x1);
-	} else if (AR_SREV_9340(ah)) {
+	} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
 		u32 regval, pll2_divint, pll2_divfrac, refdiv;
 
 		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
@@ -882,9 +882,15 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 			pll2_divfrac = 0x1eb85;
 			refdiv = 3;
 		} else {
-			pll2_divint = 88;
-			pll2_divfrac = 0;
-			refdiv = 5;
+			if (AR_SREV_9340(ah)) {
+				pll2_divint = 88;
+				pll2_divfrac = 0;
+				refdiv = 5;
+			} else {
+				pll2_divint = 0x11;
+				pll2_divfrac = 0x26666;
+				refdiv = 1;
+			}
 		}
 
 		regval = REG_READ(ah, AR_PHY_PLL_MODE);
@@ -897,8 +903,12 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		udelay(100);
 
 		regval = REG_READ(ah, AR_PHY_PLL_MODE);
-		regval = (regval & 0x80071fff) | (0x1 << 30) | (0x1 << 13) |
-			 (0x4 << 26) | (0x18 << 19);
+		if (AR_SREV_9340(ah))
+			regval = (regval & 0x80071fff) | (0x1 << 30) |
+				 (0x1 << 13) | (0x4 << 26) | (0x18 << 19);
+		else
+			regval = (regval & 0x80071fff) | (0x3 << 30) |
+				 (0x1 << 13) | (0x4 << 26) | (0x60 << 19);
 		REG_WRITE(ah, AR_PHY_PLL_MODE, regval);
 		REG_WRITE(ah, AR_PHY_PLL_MODE,
 			  REG_READ(ah, AR_PHY_PLL_MODE) & 0xfffeffff);
@@ -909,7 +919,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
-	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah))
+	if (AR_SREV_9485(ah) || AR_SREV_9340(ah) || AR_SREV_9330(ah) ||
+	    AR_SREV_9550(ah))
 		udelay(1000);
 
 	/* Switch the core clock for ar9271 to 117Mhz */
@@ -922,7 +933,7 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_RTC_SLEEP_CLK, AR_RTC_FORCE_DERIVED_CLK);
 
-	if (AR_SREV_9340(ah)) {
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah)) {
 		if (ah->is_clk_25mhz) {
 			REG_WRITE(ah, AR_RTC_DERIVED_CLK, 0x17c << 1);
 			REG_WRITE(ah, AR_SLP32_MODE, 0x0010f3d7);
-- 
1.7.2.1

