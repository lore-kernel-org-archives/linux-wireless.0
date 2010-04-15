Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:32907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355Ab0DOVjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 64/97] ath9k_hw: abstract loading noisefloor
Date: Thu, 15 Apr 2010 17:39:09 -0400
Message-Id: <1271367582-992-65-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the last call on calib.c which acceses PHY stuff,
with this change we calib.c is now generic between both
all supported hardware families.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |   67 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    6 ++
 drivers/net/wireless/ath/ath9k/calib.c        |   67 -------------------------
 drivers/net/wireless/ath/ath9k/calib.h        |    1 -
 drivers/net/wireless/ath/ath9k/hw-ops.h       |    6 ++
 drivers/net/wireless/ath/ath9k/hw.h           |    2 +
 6 files changed, 81 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index bd3792c..94eb069 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -1247,6 +1247,72 @@ static void ar5008_hw_do_getnf(struct ath_hw *ah,
 	nfarray[5] = nf;
 }
 
+static void ar5008_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	struct ath9k_nfcal_hist *h;
+	int i, j;
+	int32_t val;
+	const u32 ar5416_cca_regs[6] = {
+		AR_PHY_CCA,
+		AR_PHY_CH1_CCA,
+		AR_PHY_CH2_CCA,
+		AR_PHY_EXT_CCA,
+		AR_PHY_CH1_EXT_CCA,
+		AR_PHY_CH2_EXT_CCA
+	};
+	u8 chainmask, rx_chain_status;
+
+	rx_chain_status = REG_READ(ah, AR_PHY_RX_CHAINMASK);
+	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
+		chainmask = 0x9;
+	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah)) {
+		if ((rx_chain_status & 0x2) || (rx_chain_status & 0x4))
+			chainmask = 0x1B;
+		else
+			chainmask = 0x09;
+	} else {
+		if (rx_chain_status & 0x4)
+			chainmask = 0x3F;
+		else if (rx_chain_status & 0x2)
+			chainmask = 0x1B;
+		else
+			chainmask = 0x09;
+	}
+
+	h = ah->nfCalHist;
+
+	for (i = 0; i < NUM_NF_READINGS; i++) {
+		if (chainmask & (1 << i)) {
+			val = REG_READ(ah, ar5416_cca_regs[i]);
+			val &= 0xFFFFFE00;
+			val |= (((u32) (h[i].privNF) << 1) & 0x1ff);
+			REG_WRITE(ah, ar5416_cca_regs[i], val);
+		}
+	}
+
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_ENABLE_NF);
+	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
+		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
+	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+
+	for (j = 0; j < 5; j++) {
+		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
+		     AR_PHY_AGC_CONTROL_NF) == 0)
+			break;
+		udelay(50);
+	}
+
+	for (i = 0; i < NUM_NF_READINGS; i++) {
+		if (chainmask & (1 << i)) {
+			val = REG_READ(ah, ar5416_cca_regs[i]);
+			val &= 0xFFFFFE00;
+			val |= (((u32) (-50) << 1) & 0x1ff);
+			REG_WRITE(ah, ar5416_cca_regs[i], val);
+		}
+	}
+}
+
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1270,6 +1336,7 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->set_diversity = ar5008_set_diversity;
 	priv_ops->ani_control = ar5008_hw_ani_control;
 	priv_ops->do_getnf = ar5008_hw_do_getnf;
+	priv_ops->loadnf = ar5008_hw_loadnf;
 
 	if (AR_SREV_9100(ah))
 		priv_ops->compute_pll_control = ar9100_hw_compute_pll_control;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 00e4cb8..cd80a43 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -195,6 +195,11 @@ static bool ar9003_hw_iscal_supported(struct ath_hw *ah,
 	return false;
 }
 
+static void ar9003_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	/* TODO */
+}
+
 void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -204,6 +209,7 @@ void ar9003_hw_attach_calib_ops(struct ath_hw *ah)
 	priv_ops->init_cal = ar9003_hw_init_cal;
 	priv_ops->setup_calibration = ar9003_hw_setup_calibration;
 	priv_ops->iscal_supported = ar9003_hw_iscal_supported;
+	priv_ops->loadnf = ar9003_hw_loadnf;
 
 	ops->calibrate = ar9003_hw_calibrate;
 }
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 085e126..6982577 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -16,7 +16,6 @@
 
 #include "hw.h"
 #include "hw-ops.h"
-#include "ar9002_phy.h"
 
 /* Common calibration code */
 
@@ -174,72 +173,6 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah)
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
 }
 
-void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
-{
-	struct ath9k_nfcal_hist *h;
-	int i, j;
-	int32_t val;
-	const u32 ar5416_cca_regs[6] = {
-		AR_PHY_CCA,
-		AR_PHY_CH1_CCA,
-		AR_PHY_CH2_CCA,
-		AR_PHY_EXT_CCA,
-		AR_PHY_CH1_EXT_CCA,
-		AR_PHY_CH2_EXT_CCA
-	};
-	u8 chainmask, rx_chain_status;
-
-	rx_chain_status = REG_READ(ah, AR_PHY_RX_CHAINMASK);
-	if (AR_SREV_9285(ah) || AR_SREV_9271(ah))
-		chainmask = 0x9;
-	else if (AR_SREV_9280(ah) || AR_SREV_9287(ah)) {
-		if ((rx_chain_status & 0x2) || (rx_chain_status & 0x4))
-			chainmask = 0x1B;
-		else
-			chainmask = 0x09;
-	} else {
-		if (rx_chain_status & 0x4)
-			chainmask = 0x3F;
-		else if (rx_chain_status & 0x2)
-			chainmask = 0x1B;
-		else
-			chainmask = 0x09;
-	}
-
-	h = ah->nfCalHist;
-
-	for (i = 0; i < NUM_NF_READINGS; i++) {
-		if (chainmask & (1 << i)) {
-			val = REG_READ(ah, ar5416_cca_regs[i]);
-			val &= 0xFFFFFE00;
-			val |= (((u32) (h[i].privNF) << 1) & 0x1ff);
-			REG_WRITE(ah, ar5416_cca_regs[i], val);
-		}
-	}
-
-	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
-		    AR_PHY_AGC_CONTROL_ENABLE_NF);
-	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
-		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
-	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
-
-	for (j = 0; j < 5; j++) {
-		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
-		     AR_PHY_AGC_CONTROL_NF) == 0)
-			break;
-		udelay(50);
-	}
-
-	for (i = 0; i < NUM_NF_READINGS; i++) {
-		if (chainmask & (1 << i)) {
-			val = REG_READ(ah, ar5416_cca_regs[i]);
-			val &= 0xFFFFFE00;
-			val |= (((u32) (-50) << 1) & 0x1ff);
-			REG_WRITE(ah, ar5416_cca_regs[i], val);
-		}
-	}
-}
-
 int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 9f6c21d..25828e8 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -114,7 +114,6 @@ struct ath9k_pacal_info{
 
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah);
 void ath9k_hw_start_nfcal(struct ath_hw *ah);
-void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
 int16_t ath9k_hw_getnf(struct ath_hw *ah,
 		       struct ath9k_channel *chan);
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index b777fd1..b444ce5 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -182,6 +182,12 @@ static inline void ath9k_hw_do_getnf(struct ath_hw *ah,
 	ath9k_hw_private_ops(ah)->do_getnf(ah, nfarray);
 }
 
+static inline void ath9k_hw_loadnf(struct ath_hw *ah,
+				   struct ath9k_channel *chan)
+{
+	ath9k_hw_private_ops(ah)->loadnf(ah, chan);
+}
+
 static inline bool ath9k_hw_init_cal(struct ath_hw *ah,
 				     struct ath9k_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7a32733..d28a904 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -486,6 +486,7 @@ struct ath_gen_timer_table {
  *	AR_RTC_PLL_CONTROL for a given channel
  * @setup_calibration: set up calibration
  * @iscal_supported: used to query if a type of calibration is supported
+ * @loadnf: load noise floor read from each chain on the CCA registers
  */
 struct ath_hw_private_ops {
 	/* Calibration ops */
@@ -528,6 +529,7 @@ struct ath_hw_private_ops {
 	bool (*ani_control)(struct ath_hw *ah, enum ath9k_ani_cmd cmd,
 			    int param);
 	void (*do_getnf)(struct ath_hw *ah, int16_t nfarray[NUM_NF_READINGS]);
+	void (*loadnf)(struct ath_hw *ah, struct ath9k_channel *chan);
 };
 
 /**
-- 
1.6.3.3

