Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62262 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1DKLJq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 07:09:46 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 04:09:21 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Implement integer mode for AR9485
Date: Mon, 11 Apr 2011 16:39:40 +0530
Message-ID: <1302520181-11949-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes random disconnect.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   15 +++++++--
 drivers/net/wireless/ath/ath9k/hw.c         |   45 +++++++++++++++++---------
 drivers/net/wireless/ath/ath9k/phy.h        |    1 -
 drivers/net/wireless/ath/ath9k/reg.h        |   31 +++++++++++++++---
 4 files changed, 67 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index eb250d6..f01c31f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -75,9 +75,18 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	freq = centers.synth_center;
 
 	if (freq < 4800) {     /* 2 GHz, fractional mode */
-		if (AR_SREV_9485(ah))
-			channelSel = CHANSEL_2G_9485(freq);
-		else
+		if (AR_SREV_9485(ah)) {
+			u32 chan_frac;
+
+			/*
+			 * freq_ref = 40 / (refdiva >> amoderefsel); where refdiva=1 and amoderefsel=0
+			 * ndiv = ((chan_mhz * 4) / 3) / freq_ref;
+			 * chansel = int(ndiv), chanfrac = (ndiv - chansel) * 0x20000
+			 */
+			channelSel = (freq * 4) / 120;
+			chan_frac = (((freq * 4) % 120) * 0x20000) / 120;
+			channelSel = (channelSel << 17) | chan_frac;
+		} else
 			channelSel = CHANSEL_2G(freq);
 		/* Set to 2G mode */
 		bMode = 1;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1b5bd13..3a8c41c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -676,42 +676,55 @@ unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);
 
-#define DPLL2_KD_VAL            0x3D
-#define DPLL2_KI_VAL            0x06
-#define DPLL3_PHASE_SHIFT_VAL   0x1
-
+#define DPLL3_PHASE_SHIFT_VAL 0x1
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
 	u32 pll;
 
 	if (AR_SREV_9485(ah)) {
-		REG_WRITE(ah, AR_RTC_PLL_CONTROL2, 0x886666);
-		REG_WRITE(ah, AR_CH0_DDR_DPLL2, 0x19e82f01);
-
-		REG_RMW_FIELD(ah, AR_CH0_DDR_DPLL3,
-			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
 
-		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
-		udelay(1000);
+		/* program BB PLL ki and kd value, ki=0x4, kd=0x40 */
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+			      AR_CH0_BB_DPLL2_PLL_PWD, 0x1);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+			      AR_CH0_DPLL2_KD, 0x40);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+			      AR_CH0_DPLL2_KI, 0x4);
 
-		REG_WRITE(ah, AR_RTC_PLL_CONTROL2, 0x886666);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL1,
+			      AR_CH0_BB_DPLL1_REFDIV, 0x5);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL1,
+			      AR_CH0_BB_DPLL1_NINI, 0x58);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL1,
+			      AR_CH0_BB_DPLL1_NFRAC, 0x0);
 
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
-			      AR_CH0_DPLL2_KD, DPLL2_KD_VAL);
+			      AR_CH0_BB_DPLL2_OUTDIV, 0x1);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+			      AR_CH0_BB_DPLL2_LOCAL_PLL, 0x1);
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
-			      AR_CH0_DPLL2_KI, DPLL2_KI_VAL);
+			      AR_CH0_BB_DPLL2_EN_NEGTRIG, 0x1);
 
+		/* program BB PLL phase_shift to 0x6 */
 		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
-			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
-		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x142c);
+			      AR_CH0_BB_DPLL3_PHASE_SHIFT, 0x6);
+
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+			      AR_CH0_BB_DPLL2_PLL_PWD, 0x0);
 		udelay(1000);
+
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
+			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
 	}
 
 	pll = ath9k_hw_compute_pll_control(ah, chan);
 
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
+	if (AR_SREV_9485(ah))
+		udelay(1000);
+
 	/* Switch the core clock for ar9271 to 117Mhz */
 	if (AR_SREV_9271(ah)) {
 		udelay(500);
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index f50e2c2..8e5fe9d 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -19,7 +19,6 @@
 
 #define CHANSEL_DIV		15
 #define CHANSEL_2G(_freq)	(((_freq) * 0x10000) / CHANSEL_DIV)
-#define CHANSEL_2G_9485(_freq)	((((_freq) * 0x10000) - 215) / CHANSEL_DIV)
 #define CHANSEL_5G(_freq)	(((_freq) * 0x8000) / CHANSEL_DIV)
 
 #define AR_PHY_BASE     0x9800
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 693d543..4b08e89 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1088,14 +1088,35 @@ enum {
 #define AR_ENT_OTP		  0x40d8
 #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
 #define AR_ENT_OTP_MPSD		0x00800000
-#define AR_CH0_BB_DPLL2          0x16184
+
+#define AR_CH0_BB_DPLL1		 0x16180
+#define AR_CH0_BB_DPLL1_REFDIV	 0xF8000000
+#define AR_CH0_BB_DPLL1_REFDIV_S 27
+#define AR_CH0_BB_DPLL1_NINI	 0x07FC0000
+#define AR_CH0_BB_DPLL1_NINI_S	 18
+#define AR_CH0_BB_DPLL1_NFRAC	 0x0003FFFF
+#define AR_CH0_BB_DPLL1_NFRAC_S	 0
+
+#define AR_CH0_BB_DPLL2		     0x16184
+#define AR_CH0_BB_DPLL2_LOCAL_PLL       0x40000000
+#define AR_CH0_BB_DPLL2_LOCAL_PLL_S     30
+#define AR_CH0_DPLL2_KI              0x3C000000
+#define AR_CH0_DPLL2_KI_S            26
+#define AR_CH0_DPLL2_KD              0x03F80000
+#define AR_CH0_DPLL2_KD_S            19
+#define AR_CH0_BB_DPLL2_EN_NEGTRIG   0x00040000
+#define AR_CH0_BB_DPLL2_EN_NEGTRIG_S 18
+#define AR_CH0_BB_DPLL2_PLL_PWD	     0x00010000
+#define AR_CH0_BB_DPLL2_PLL_PWD_S    16
+#define AR_CH0_BB_DPLL2_OUTDIV	     0x0000E000
+#define AR_CH0_BB_DPLL2_OUTDIV_S     13
+
 #define AR_CH0_BB_DPLL3          0x16188
+#define AR_CH0_BB_DPLL3_PHASE_SHIFT	0x3F800000
+#define AR_CH0_BB_DPLL3_PHASE_SHIFT_S	23
+
 #define AR_CH0_DDR_DPLL2         0x16244
 #define AR_CH0_DDR_DPLL3         0x16248
-#define AR_CH0_DPLL2_KD              0x03F80000
-#define AR_CH0_DPLL2_KD_S            19
-#define AR_CH0_DPLL2_KI              0x3C000000
-#define AR_CH0_DPLL2_KI_S            26
 #define AR_CH0_DPLL3_PHASE_SHIFT     0x3F800000
 #define AR_CH0_DPLL3_PHASE_SHIFT_S   23
 #define AR_PHY_CCA_NOM_VAL_2GHZ      -118
-- 
1.7.0.4

