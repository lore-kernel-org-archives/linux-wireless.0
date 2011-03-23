Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44615 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932857Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 03/10] ath9k_hw: replace REG_READ+REG_WRITE with REG_RMW
Date: Wed, 23 Mar 2011 20:57:26 +0100
Message-Id: <1300910253-28189-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-2-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
 <1300910253-28189-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's easier to read and it slightly decreases code size

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c  |   66 ++++++++++++------------------
 drivers/net/wireless/ath/ath9k/mac.c |   73 ++++++++++++++--------------------
 2 files changed, 56 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9513ec7..807d410 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -675,14 +675,14 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 
 unsigned long ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 {
-		REG_WRITE(ah, PLL3, (REG_READ(ah, PLL3) & ~(PLL3_DO_MEAS_MASK)));
-		udelay(100);
-		REG_WRITE(ah, PLL3, (REG_READ(ah, PLL3) | PLL3_DO_MEAS_MASK));
+	REG_CLR_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
+	udelay(100);
+	REG_SET_BIT(ah, PLL3, PLL3_DO_MEAS_MASK);
 
-		while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0)
-			udelay(100);
+	while ((REG_READ(ah, PLL4) & PLL4_MEAS_DONE) == 0)
+		udelay(100);
 
-		return (REG_READ(ah, PLL3) & SQSUM_DVC_MASK) >> 3;
+	return (REG_READ(ah, PLL3) & SQSUM_DVC_MASK) >> 3;
 }
 EXPORT_SYMBOL(ar9003_get_pll_sqsum_dvc);
 
@@ -832,8 +832,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		ah->misc_mode);
 
 	if (ah->misc_mode != 0)
-		REG_WRITE(ah, AR_PCU_MISC,
-			  REG_READ(ah, AR_PCU_MISC) | ah->misc_mode);
+		REG_SET_BIT(ah, AR_PCU_MISC, ah->misc_mode);
 
 	if (conf->channel && conf->channel->band == IEEE80211_BAND_5GHZ)
 		sifstime = 16;
@@ -901,23 +900,19 @@ u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan)
 static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 regval;
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	/*
 	 * set AHB_MODE not to do cacheline prefetches
 	*/
-	if (!AR_SREV_9300_20_OR_LATER(ah)) {
-		regval = REG_READ(ah, AR_AHB_MODE);
-		REG_WRITE(ah, AR_AHB_MODE, regval | AR_AHB_PREFETCH_RD_EN);
-	}
+	if (!AR_SREV_9300_20_OR_LATER(ah))
+		REG_SET_BIT(ah, AR_AHB_MODE, AR_AHB_PREFETCH_RD_EN);
 
 	/*
 	 * let mac dma reads be in 128 byte chunks
 	 */
-	regval = REG_READ(ah, AR_TXCFG) & ~AR_TXCFG_DMASZ_MASK;
-	REG_WRITE(ah, AR_TXCFG, regval | AR_TXCFG_DMASZ_128B);
+	REG_RMW(ah, AR_TXCFG, AR_TXCFG_DMASZ_128B, AR_TXCFG_DMASZ_MASK);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
@@ -934,8 +929,7 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 	/*
 	 * let mac dma writes be in 128 byte chunks
 	 */
-	regval = REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_DMASZ_MASK;
-	REG_WRITE(ah, AR_RXCFG, regval | AR_RXCFG_DMASZ_128B);
+	REG_RMW(ah, AR_RXCFG, AR_RXCFG_DMASZ_128B, AR_RXCFG_DMASZ_MASK);
 
 	/*
 	 * Setup receive FIFO threshold to hold off TX activities
@@ -974,30 +968,27 @@ static inline void ath9k_hw_set_dma(struct ath_hw *ah)
 
 static void ath9k_hw_set_operating_mode(struct ath_hw *ah, int opmode)
 {
-	u32 val;
+	u32 mask = AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC;
+	u32 set = AR_STA_ID1_KSRCH_MODE;
 
-	val = REG_READ(ah, AR_STA_ID1);
-	val &= ~(AR_STA_ID1_STA_AP | AR_STA_ID1_ADHOC);
 	switch (opmode) {
-	case NL80211_IFTYPE_AP:
-		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_STA_AP
-			  | AR_STA_ID1_KSRCH_MODE);
-		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
-		break;
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
-		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_ADHOC
-			  | AR_STA_ID1_KSRCH_MODE);
+		set |= AR_STA_ID1_ADHOC;
 		REG_SET_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
+	case NL80211_IFTYPE_AP:
+		set |= AR_STA_ID1_STA_AP;
+		/* fall through */
 	case NL80211_IFTYPE_STATION:
-		REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
+		REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHOC_INDICATION);
 		break;
 	default:
-		if (ah->is_monitoring)
-			REG_WRITE(ah, AR_STA_ID1, val | AR_STA_ID1_KSRCH_MODE);
+		if (!ah->is_monitoring)
+			set = 0;
 		break;
 	}
+	REG_RMW(ah, AR_STA_ID1, set, mask);
 }
 
 void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
@@ -1023,10 +1014,8 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	u32 tmpReg;
 
 	if (AR_SREV_9100(ah)) {
-		u32 val = REG_READ(ah, AR_RTC_DERIVED_CLK);
-		val &= ~AR_RTC_DERIVED_CLK_PERIOD;
-		val |= SM(1, AR_RTC_DERIVED_CLK_PERIOD);
-		REG_WRITE(ah, AR_RTC_DERIVED_CLK, val);
+		REG_RMW_FIELD(ah, AR_RTC_DERIVED_CLK,
+			      AR_RTC_DERIVED_CLK_PERIOD, 1);
 		(void)REG_READ(ah, AR_RTC_DERIVED_CLK);
 	}
 
@@ -1451,8 +1440,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		ar9002_hw_enable_wep_aggregation(ah);
 	}
 
-	REG_WRITE(ah, AR_STA_ID1,
-		  REG_READ(ah, AR_STA_ID1) | AR_STA_ID1_PRESERVE_SEQNUM);
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PRESERVE_SEQNUM);
 
 	ath9k_hw_set_dma(ah);
 
@@ -2204,11 +2192,9 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 	REG_WRITE(ah, AR_PHY_ERR, phybits);
 
 	if (phybits)
-		REG_WRITE(ah, AR_RXCFG,
-			  REG_READ(ah, AR_RXCFG) | AR_RXCFG_ZLFDMA);
+		REG_SET_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
 	else
-		REG_WRITE(ah, AR_RXCFG,
-			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
+		REG_CLR_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 562257a..db496f2 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -465,10 +465,9 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		REG_WRITE(ah, AR_QCBRCFG(q),
 			  SM(qi->tqi_cbrPeriod, AR_Q_CBRCFG_INTERVAL) |
 			  SM(qi->tqi_cbrOverflowLimit, AR_Q_CBRCFG_OVF_THRESH));
-		REG_WRITE(ah, AR_QMISC(q),
-			  REG_READ(ah, AR_QMISC(q)) | AR_Q_MISC_FSP_CBR |
-			  (qi->tqi_cbrOverflowLimit ?
-			   AR_Q_MISC_CBR_EXP_CNTR_LIMIT_EN : 0));
+		REG_SET_BIT(ah, AR_QMISC(q), AR_Q_MISC_FSP_CBR |
+			    (qi->tqi_cbrOverflowLimit ?
+			     AR_Q_MISC_CBR_EXP_CNTR_LIMIT_EN : 0));
 	}
 	if (qi->tqi_readyTime && (qi->tqi_type != ATH9K_TX_QUEUE_CAB)) {
 		REG_WRITE(ah, AR_QRDYTIMECFG(q),
@@ -481,40 +480,31 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		  (qi->tqi_burstTime ? AR_D_CHNTIME_EN : 0));
 
 	if (qi->tqi_burstTime
-	    && (qi->tqi_qflags & TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE)) {
-		REG_WRITE(ah, AR_QMISC(q),
-			  REG_READ(ah, AR_QMISC(q)) |
-			  AR_Q_MISC_RDYTIME_EXP_POLICY);
+	    && (qi->tqi_qflags & TXQ_FLAG_RDYTIME_EXP_POLICY_ENABLE))
+		REG_SET_BIT(ah, AR_QMISC(q), AR_Q_MISC_RDYTIME_EXP_POLICY);
 
-	}
-
-	if (qi->tqi_qflags & TXQ_FLAG_BACKOFF_DISABLE) {
-		REG_WRITE(ah, AR_DMISC(q),
-			  REG_READ(ah, AR_DMISC(q)) |
-			  AR_D_MISC_POST_FR_BKOFF_DIS);
-	}
+	if (qi->tqi_qflags & TXQ_FLAG_BACKOFF_DISABLE)
+		REG_SET_BIT(ah, AR_DMISC(q), AR_D_MISC_POST_FR_BKOFF_DIS);
 
 	REGWRITE_BUFFER_FLUSH(ah);
 
-	if (qi->tqi_qflags & TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE) {
-		REG_WRITE(ah, AR_DMISC(q),
-			  REG_READ(ah, AR_DMISC(q)) |
-			  AR_D_MISC_FRAG_BKOFF_EN);
-	}
+	if (qi->tqi_qflags & TXQ_FLAG_FRAG_BURST_BACKOFF_ENABLE)
+		REG_SET_BIT(ah, AR_DMISC(q), AR_D_MISC_FRAG_BKOFF_EN);
+
 	switch (qi->tqi_type) {
 	case ATH9K_TX_QUEUE_BEACON:
 		ENABLE_REGWRITE_BUFFER(ah);
 
-		REG_WRITE(ah, AR_QMISC(q), REG_READ(ah, AR_QMISC(q))
-			  | AR_Q_MISC_FSP_DBA_GATED
-			  | AR_Q_MISC_BEACON_USE
-			  | AR_Q_MISC_CBR_INCR_DIS1);
+		REG_SET_BIT(ah, AR_QMISC(q),
+			    AR_Q_MISC_FSP_DBA_GATED
+			    | AR_Q_MISC_BEACON_USE
+			    | AR_Q_MISC_CBR_INCR_DIS1);
 
-		REG_WRITE(ah, AR_DMISC(q), REG_READ(ah, AR_DMISC(q))
-			  | (AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL <<
+		REG_SET_BIT(ah, AR_DMISC(q),
+			    (AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL <<
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S)
-			  | AR_D_MISC_BEACON_USE
-			  | AR_D_MISC_POST_FR_BKOFF_DIS);
+			    | AR_D_MISC_BEACON_USE
+			    | AR_D_MISC_POST_FR_BKOFF_DIS);
 
 		REGWRITE_BUFFER_FLUSH(ah);
 
@@ -533,41 +523,38 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 	case ATH9K_TX_QUEUE_CAB:
 		ENABLE_REGWRITE_BUFFER(ah);
 
-		REG_WRITE(ah, AR_QMISC(q), REG_READ(ah, AR_QMISC(q))
-			  | AR_Q_MISC_FSP_DBA_GATED
-			  | AR_Q_MISC_CBR_INCR_DIS1
-			  | AR_Q_MISC_CBR_INCR_DIS0);
+		REG_SET_BIT(ah, AR_QMISC(q),
+			    AR_Q_MISC_FSP_DBA_GATED
+			    | AR_Q_MISC_CBR_INCR_DIS1
+			    | AR_Q_MISC_CBR_INCR_DIS0);
 		value = (qi->tqi_readyTime -
 			 (ah->config.sw_beacon_response_time -
 			  ah->config.dma_beacon_response_time) -
 			 ah->config.additional_swba_backoff) * 1024;
 		REG_WRITE(ah, AR_QRDYTIMECFG(q),
 			  value | AR_Q_RDYTIMECFG_EN);
-		REG_WRITE(ah, AR_DMISC(q), REG_READ(ah, AR_DMISC(q))
-			  | (AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL <<
+		REG_SET_BIT(ah, AR_DMISC(q),
+			    (AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL <<
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S));
 
 		REGWRITE_BUFFER_FLUSH(ah);
 
 		break;
 	case ATH9K_TX_QUEUE_PSPOLL:
-		REG_WRITE(ah, AR_QMISC(q),
-			  REG_READ(ah, AR_QMISC(q)) | AR_Q_MISC_CBR_INCR_DIS1);
+		REG_SET_BIT(ah, AR_QMISC(q), AR_Q_MISC_CBR_INCR_DIS1);
 		break;
 	case ATH9K_TX_QUEUE_UAPSD:
-		REG_WRITE(ah, AR_DMISC(q), REG_READ(ah, AR_DMISC(q)) |
-			  AR_D_MISC_POST_FR_BKOFF_DIS);
+		REG_SET_BIT(ah, AR_DMISC(q), AR_D_MISC_POST_FR_BKOFF_DIS);
 		break;
 	default:
 		break;
 	}
 
 	if (qi->tqi_intFlags & ATH9K_TXQ_USE_LOCKOUT_BKOFF_DIS) {
-		REG_WRITE(ah, AR_DMISC(q),
-			  REG_READ(ah, AR_DMISC(q)) |
-			  SM(AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL,
-			     AR_D_MISC_ARB_LOCKOUT_CNTRL) |
-			  AR_D_MISC_POST_FR_BKOFF_DIS);
+		REG_SET_BIT(ah, AR_DMISC(q),
+			    SM(AR_D_MISC_ARB_LOCKOUT_CNTRL_GLOBAL,
+			       AR_D_MISC_ARB_LOCKOUT_CNTRL) |
+			    AR_D_MISC_POST_FR_BKOFF_DIS);
 	}
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
-- 
1.7.3.2

