Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:56248
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbaI2Sps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 14:45:48 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3/3] ath9k_hw: fix PLL clock initialization for newer SoC
Date: Mon, 29 Sep 2014 20:45:42 +0200
Message-Id: <1412016342-21227-3-git-send-email-nbd@openwrt.org> (sfid-20140929_204554_974521_E73B27ED)
In-Reply-To: <1412016342-21227-1-git-send-email-nbd@openwrt.org>
References: <1412016342-21227-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR934x and newer SoC devices, the layout of the AR_RTC_PLL_CONTROL
register changed. This currently breaks at least 5/10 MHz operation.
AR933x uses the old layout.

It might also have been causing other stability issues because of the
different location of the PLL_BYPASS bit which needs to be set during
PLL clock initialization.

This patch also removes more instances of hardcoded register values in
favor of properly computed ones with the PLL_BYPASS bit added.

Reported-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 24 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.c         |  9 ++++++---
 drivers/net/wireless/ath/ath9k/reg.h        | 11 +++++++++++
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 542a8d5..697c4ae 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -517,6 +517,23 @@ static void ar9003_hw_spur_mitigate(struct ath_hw *ah,
 	ar9003_hw_spur_mitigate_ofdm(ah, chan);
 }
 
+static u32 ar9003_hw_compute_pll_control_soc(struct ath_hw *ah,
+					     struct ath9k_channel *chan)
+{
+	u32 pll;
+
+	pll = SM(0x5, AR_RTC_9300_SOC_PLL_REFDIV);
+
+	if (chan && IS_CHAN_HALF_RATE(chan))
+		pll |= SM(0x1, AR_RTC_9300_SOC_PLL_CLKSEL);
+	else if (chan && IS_CHAN_QUARTER_RATE(chan))
+		pll |= SM(0x2, AR_RTC_9300_SOC_PLL_CLKSEL);
+
+	pll |= SM(0x2c, AR_RTC_9300_SOC_PLL_DIV_INT);
+
+	return pll;
+}
+
 static u32 ar9003_hw_compute_pll_control(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
@@ -1781,7 +1798,12 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 
 	priv_ops->rf_set_freq = ar9003_hw_set_channel;
 	priv_ops->spur_mitigate_freq = ar9003_hw_spur_mitigate;
-	priv_ops->compute_pll_control = ar9003_hw_compute_pll_control;
+
+	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah))
+		priv_ops->compute_pll_control = ar9003_hw_compute_pll_control_soc;
+	else
+		priv_ops->compute_pll_control = ar9003_hw_compute_pll_control;
+
 	priv_ops->set_channel_regs = ar9003_hw_set_channel_regs;
 	priv_ops->init_bb = ar9003_hw_init_bb;
 	priv_ops->process_ini = ar9003_hw_process_ini;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3aed729..f03e283 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -704,6 +704,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 {
 	u32 pll;
 
+	pll = ath9k_hw_compute_pll_control(ah, chan);
+
 	if (AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
 		/* program BB PLL ki and kd value, ki=0x4, kd=0x40 */
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
@@ -754,7 +756,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		REG_RMW_FIELD(ah, AR_CH0_DDR_DPLL3,
 			      AR_CH0_DPLL3_PHASE_SHIFT, 0x1);
 
-		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL,
+			  pll | AR_RTC_9300_PLL_BYPASS);
 		udelay(1000);
 
 		/* program refdiv, nint, frac to RTC register */
@@ -770,7 +773,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 	} else if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah)) {
 		u32 regval, pll2_divint, pll2_divfrac, refdiv;
 
-		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL,
+			  pll | AR_RTC_9300_SOC_PLL_BYPASS);
 		udelay(1000);
 
 		REG_SET_BIT(ah, AR_PHY_PLL_MODE, 0x1 << 16);
@@ -843,7 +847,6 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 		udelay(1000);
 	}
 
-	pll = ath9k_hw_compute_pll_control(ah, chan);
 	if (AR_SREV_9565(ah))
 		pll |= 0x40000;
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index a149970..3747a8a 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1240,12 +1240,23 @@ enum {
 #define AR_CH0_DPLL3_PHASE_SHIFT_S   23
 #define AR_PHY_CCA_NOM_VAL_2GHZ      -118
 
+#define AR_RTC_9300_SOC_PLL_DIV_INT          0x0000003f
+#define AR_RTC_9300_SOC_PLL_DIV_INT_S        0
+#define AR_RTC_9300_SOC_PLL_DIV_FRAC         0x000fffc0
+#define AR_RTC_9300_SOC_PLL_DIV_FRAC_S       6
+#define AR_RTC_9300_SOC_PLL_REFDIV           0x01f00000
+#define AR_RTC_9300_SOC_PLL_REFDIV_S         20
+#define AR_RTC_9300_SOC_PLL_CLKSEL           0x06000000
+#define AR_RTC_9300_SOC_PLL_CLKSEL_S         25
+#define AR_RTC_9300_SOC_PLL_BYPASS           0x08000000
+
 #define AR_RTC_9300_PLL_DIV          0x000003ff
 #define AR_RTC_9300_PLL_DIV_S        0
 #define AR_RTC_9300_PLL_REFDIV       0x00003C00
 #define AR_RTC_9300_PLL_REFDIV_S     10
 #define AR_RTC_9300_PLL_CLKSEL       0x0000C000
 #define AR_RTC_9300_PLL_CLKSEL_S     14
+#define AR_RTC_9300_PLL_BYPASS       0x00010000
 
 #define AR_RTC_9160_PLL_DIV	0x000003ff
 #define AR_RTC_9160_PLL_DIV_S   0
-- 
2.0.4

