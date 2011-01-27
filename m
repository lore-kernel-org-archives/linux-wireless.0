Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:10256 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab1A0JPk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 04:15:40 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 01:15:21 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: [PATCH 3/5] ath9k_hw: DDR_PLL and BB_PLL need correct setting.
Date: Thu, 27 Jan 2011 14:45:09 +0530
Message-ID: <1296119711-4024-3-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1296119711-4024-2-git-send-email-vnatarajan@atheros.com>
References: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updates from the analog team for AR9485 chipsets to set
DDR_PLL2 and DDR_PLL3. Also program the BB_PLL ki
and kd value.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   26 +++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/reg.h |   11 +++++++++++
 2 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index baa2977..63edbc1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -684,13 +684,37 @@ unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);
 
+#define DPLL2_KD_VAL            0x3D
+#define DPLL2_KI_VAL            0x06
+#define DPLL3_PHASE_SHIFT_VAL   0x1
+
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
 	u32 pll;
 
-	if (AR_SREV_9485(ah))
+	if (AR_SREV_9485(ah)) {
 		REG_WRITE(ah, AR_RTC_PLL_CONTROL2, 0x886666);
+		REG_WRITE(ah, AR_CH0_DDR_DPLL2, 0x19e82f01);
+
+		REG_RMW_FIELD(ah, AR_CH0_DDR_DPLL3,
+			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
+
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x1142c);
+		udelay(100);
+
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL2, 0x886666);
+
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+			      AR_CH0_DPLL2_KD, DPLL2_KD_VAL);
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL2,
+			      AR_CH0_DPLL2_KI, DPLL2_KI_VAL);
+
+		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
+			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);
+		REG_WRITE(ah, AR_RTC_PLL_CONTROL, 0x142c);
+		udelay(110);
+	}
 
 	pll = ath9k_hw_compute_pll_control(ah, chan);
 
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 264aea7..b262e98 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1083,6 +1083,17 @@ enum {
 #define AR_ENT_OTP		  0x40d8
 #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
 #define AR_ENT_OTP_MPSD		0x00800000
+#define AR_CH0_BB_DPLL2          0x16184
+#define AR_CH0_BB_DPLL3          0x16188
+#define AR_CH0_DDR_DPLL2         0x16244
+#define AR_CH0_DDR_DPLL3         0x16248
+#define AR_CH0_DPLL2_KD              0x03F80000
+#define AR_CH0_DPLL2_KD_S            19
+#define AR_CH0_DPLL2_KI              0x3C000000
+#define AR_CH0_DPLL2_KI_S            26
+#define AR_CH0_DPLL3_PHASE_SHIFT     0x3F800000
+#define AR_CH0_DPLL3_PHASE_SHIFT_S   23
+#define AR_PHY_CCA_NOM_VAL_2GHZ      -118
 
 #define AR_RTC_9300_PLL_DIV          0x000003ff
 #define AR_RTC_9300_PLL_DIV_S        0
-- 
1.6.3.3

