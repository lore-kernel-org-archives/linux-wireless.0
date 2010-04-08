Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933268Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 061/102] ath9k_hw: Abstract the routine which returns interrupt status
Date: Thu,  8 Apr 2010 15:26:57 -0400
Message-Id: <1270754858-26266-62-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Also move interrupt related code to mac.c. Worth noting is we
now enable TX interrupt mitigation for new shiny AR9003 family.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    6 +
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    5 +
 drivers/net/wireless/ath/ath9k/hw.c         |  284 +--------------------------
 drivers/net/wireless/ath/ath9k/hw.h         |    7 +-
 drivers/net/wireless/ath/ath9k/mac.c        |  290 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h        |    5 +
 drivers/net/wireless/ath/ath9k/reg.h        |    2 +
 7 files changed, 313 insertions(+), 286 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index b229597..15f1b0f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -30,6 +30,11 @@ static void ar9003_hw_get_desc_link(void *ds, u32 **ds_link)
 	*ds_link = &((struct ar9003_txc *) ds)->link;
 }
 
+static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
+{
+	return true;
+}
+
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 {
 	struct ath_hw_ops *ops = ath9k_hw_ops(hw);
@@ -37,6 +42,7 @@ void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 	ops->rx_enable = ar9003_hw_rx_enable;
 	ops->set_desc_link = ar9003_hw_set_desc_link;
 	ops->get_desc_link = ar9003_hw_get_desc_link;
+	ops->get_isr = ar9003_hw_get_isr;
 }
 
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index bd40c0e..edb5abb 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -52,6 +52,11 @@ static inline bool ath9k_hw_calibrate(struct ath_hw *ah,
 	return ath9k_hw_ops(ah)->calibrate(ah, chan, rxchainmask, longcal);
 }
 
+static inline bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
+{
+	return ath9k_hw_ops(ah)->get_isr(ah, masked);
+}
+
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1343c7c..f8e7d40 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -385,6 +385,9 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 
 	ah->config.rx_intr_mitigation = true;
 
+	if (AR_SREV_9300_20_OR_LATER(ah))
+		ah->config.tx_intr_mitigation = true;
+
 	/*
 	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
 	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
@@ -1812,287 +1815,6 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 }
 EXPORT_SYMBOL(ath9k_hw_setpower);
 
-/**********************/
-/* Interrupt Handling */
-/**********************/
-
-bool ath9k_hw_intrpend(struct ath_hw *ah)
-{
-	u32 host_isr;
-
-	if (AR_SREV_9100(ah))
-		return true;
-
-	host_isr = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
-	if ((host_isr & AR_INTR_MAC_IRQ) && (host_isr != AR_INTR_SPURIOUS))
-		return true;
-
-	host_isr = REG_READ(ah, AR_INTR_SYNC_CAUSE);
-	if ((host_isr & AR_INTR_SYNC_DEFAULT)
-	    && (host_isr != AR_INTR_SPURIOUS))
-		return true;
-
-	return false;
-}
-EXPORT_SYMBOL(ath9k_hw_intrpend);
-
-bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
-{
-	u32 isr = 0;
-	u32 mask2 = 0;
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	u32 sync_cause = 0;
-	bool fatal_int = false;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	if (!AR_SREV_9100(ah)) {
-		if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
-			if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M)
-			    == AR_RTC_STATUS_ON) {
-				isr = REG_READ(ah, AR_ISR);
-			}
-		}
-
-		sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) &
-			AR_INTR_SYNC_DEFAULT;
-
-		*masked = 0;
-
-		if (!isr && !sync_cause)
-			return false;
-	} else {
-		*masked = 0;
-		isr = REG_READ(ah, AR_ISR);
-	}
-
-	if (isr) {
-		if (isr & AR_ISR_BCNMISC) {
-			u32 isr2;
-			isr2 = REG_READ(ah, AR_ISR_S2);
-			if (isr2 & AR_ISR_S2_TIM)
-				mask2 |= ATH9K_INT_TIM;
-			if (isr2 & AR_ISR_S2_DTIM)
-				mask2 |= ATH9K_INT_DTIM;
-			if (isr2 & AR_ISR_S2_DTIMSYNC)
-				mask2 |= ATH9K_INT_DTIMSYNC;
-			if (isr2 & (AR_ISR_S2_CABEND))
-				mask2 |= ATH9K_INT_CABEND;
-			if (isr2 & AR_ISR_S2_GTT)
-				mask2 |= ATH9K_INT_GTT;
-			if (isr2 & AR_ISR_S2_CST)
-				mask2 |= ATH9K_INT_CST;
-			if (isr2 & AR_ISR_S2_TSFOOR)
-				mask2 |= ATH9K_INT_TSFOOR;
-		}
-
-		isr = REG_READ(ah, AR_ISR_RAC);
-		if (isr == 0xffffffff) {
-			*masked = 0;
-			return false;
-		}
-
-		*masked = isr & ATH9K_INT_COMMON;
-
-		if (ah->config.rx_intr_mitigation) {
-			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
-				*masked |= ATH9K_INT_RX;
-		}
-
-		if (isr & (AR_ISR_RXOK | AR_ISR_RXERR))
-			*masked |= ATH9K_INT_RX;
-		if (isr &
-		    (AR_ISR_TXOK | AR_ISR_TXDESC | AR_ISR_TXERR |
-		     AR_ISR_TXEOL)) {
-			u32 s0_s, s1_s;
-
-			*masked |= ATH9K_INT_TX;
-
-			s0_s = REG_READ(ah, AR_ISR_S0_S);
-			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
-			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
-
-			s1_s = REG_READ(ah, AR_ISR_S1_S);
-			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
-			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
-		}
-
-		if (isr & AR_ISR_RXORN) {
-			ath_print(common, ATH_DBG_INTERRUPT,
-				  "receive FIFO overrun interrupt\n");
-		}
-
-		if (!AR_SREV_9100(ah)) {
-			if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-				u32 isr5 = REG_READ(ah, AR_ISR_S5_S);
-				if (isr5 & AR_ISR_S5_TIM_TIMER)
-					*masked |= ATH9K_INT_TIM_TIMER;
-			}
-		}
-
-		*masked |= mask2;
-	}
-
-	if (AR_SREV_9100(ah))
-		return true;
-
-	if (isr & AR_ISR_GENTMR) {
-		u32 s5_s;
-
-		s5_s = REG_READ(ah, AR_ISR_S5_S);
-		if (isr & AR_ISR_GENTMR) {
-			ah->intr_gen_timer_trigger =
-				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
-
-			ah->intr_gen_timer_thresh =
-				MS(s5_s, AR_ISR_S5_GENTIMER_THRESH);
-
-			if (ah->intr_gen_timer_trigger)
-				*masked |= ATH9K_INT_GENTIMER;
-
-		}
-	}
-
-	if (sync_cause) {
-		fatal_int =
-			(sync_cause &
-			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
-			? true : false;
-
-		if (fatal_int) {
-			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
-				ath_print(common, ATH_DBG_ANY,
-					  "received PCI FATAL interrupt\n");
-			}
-			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
-				ath_print(common, ATH_DBG_ANY,
-					  "received PCI PERR interrupt\n");
-			}
-			*masked |= ATH9K_INT_FATAL;
-		}
-		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
-			ath_print(common, ATH_DBG_INTERRUPT,
-				  "AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
-			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
-			REG_WRITE(ah, AR_RC, 0);
-			*masked |= ATH9K_INT_FATAL;
-		}
-		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
-			ath_print(common, ATH_DBG_INTERRUPT,
-				  "AR_INTR_SYNC_LOCAL_TIMEOUT\n");
-		}
-
-		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
-		(void) REG_READ(ah, AR_INTR_SYNC_CAUSE_CLR);
-	}
-
-	return true;
-}
-EXPORT_SYMBOL(ath9k_hw_getisr);
-
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
-{
-	enum ath9k_int omask = ah->imask;
-	u32 mask, mask2;
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	ath_print(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
-
-	if (omask & ATH9K_INT_GLOBAL) {
-		ath_print(common, ATH_DBG_INTERRUPT, "disable IER\n");
-		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
-		(void) REG_READ(ah, AR_IER);
-		if (!AR_SREV_9100(ah)) {
-			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, 0);
-			(void) REG_READ(ah, AR_INTR_ASYNC_ENABLE);
-
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
-			(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
-		}
-	}
-
-	mask = ints & ATH9K_INT_COMMON;
-	mask2 = 0;
-
-	if (ints & ATH9K_INT_TX) {
-		if (ah->txok_interrupt_mask)
-			mask |= AR_IMR_TXOK;
-		if (ah->txdesc_interrupt_mask)
-			mask |= AR_IMR_TXDESC;
-		if (ah->txerr_interrupt_mask)
-			mask |= AR_IMR_TXERR;
-		if (ah->txeol_interrupt_mask)
-			mask |= AR_IMR_TXEOL;
-	}
-	if (ints & ATH9K_INT_RX) {
-		mask |= AR_IMR_RXERR;
-		if (ah->config.rx_intr_mitigation)
-			mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
-		else
-			mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
-		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
-			mask |= AR_IMR_GENTMR;
-	}
-
-	if (ints & (ATH9K_INT_BMISC)) {
-		mask |= AR_IMR_BCNMISC;
-		if (ints & ATH9K_INT_TIM)
-			mask2 |= AR_IMR_S2_TIM;
-		if (ints & ATH9K_INT_DTIM)
-			mask2 |= AR_IMR_S2_DTIM;
-		if (ints & ATH9K_INT_DTIMSYNC)
-			mask2 |= AR_IMR_S2_DTIMSYNC;
-		if (ints & ATH9K_INT_CABEND)
-			mask2 |= AR_IMR_S2_CABEND;
-		if (ints & ATH9K_INT_TSFOOR)
-			mask2 |= AR_IMR_S2_TSFOOR;
-	}
-
-	if (ints & (ATH9K_INT_GTT | ATH9K_INT_CST)) {
-		mask |= AR_IMR_BCNMISC;
-		if (ints & ATH9K_INT_GTT)
-			mask2 |= AR_IMR_S2_GTT;
-		if (ints & ATH9K_INT_CST)
-			mask2 |= AR_IMR_S2_CST;
-	}
-
-	ath_print(common, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
-	REG_WRITE(ah, AR_IMR, mask);
-	ah->imrs2_reg &= ~(AR_IMR_S2_TIM | AR_IMR_S2_DTIM | AR_IMR_S2_DTIMSYNC |
-			   AR_IMR_S2_CABEND | AR_IMR_S2_CABTO |
-			   AR_IMR_S2_TSFOOR | AR_IMR_S2_GTT | AR_IMR_S2_CST);
-	ah->imrs2_reg |= mask2;
-	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
-
-	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
-		if (ints & ATH9K_INT_TIM_TIMER)
-			REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
-		else
-			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
-	}
-
-	if (ints & ATH9K_INT_GLOBAL) {
-		ath_print(common, ATH_DBG_INTERRUPT, "enable IER\n");
-		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
-		if (!AR_SREV_9100(ah)) {
-			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
-				  AR_INTR_MAC_IRQ);
-			REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
-
-
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE,
-				  AR_INTR_SYNC_DEFAULT);
-			REG_WRITE(ah, AR_INTR_SYNC_MASK,
-				  AR_INTR_SYNC_DEFAULT);
-		}
-		ath_print(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
-			  REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
-	}
-
-	return omask;
-}
-EXPORT_SYMBOL(ath9k_hw_set_interrupts);
-
 /*******************/
 /* Beacon Handling */
 /*******************/
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 8feca6b..1e95144 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -228,6 +228,7 @@ struct ath9k_ops_config {
 	u32 enable_ani;
 	int serialize_regmode;
 	bool rx_intr_mitigation;
+	bool tx_intr_mitigation;
 #define SPUR_DISABLE        	0
 #define SPUR_ENABLE_IOCTL   	1
 #define SPUR_ENABLE_EEPROM  	2
@@ -544,6 +545,7 @@ struct ath_hw_ops {
 			  struct ath9k_channel *chan,
 			  u8 rxchainmask,
 			  bool longcal);
+	bool (*get_isr)(struct ath_hw *ah, enum ath9k_int *masked);
 };
 
 struct ath_hw {
@@ -804,11 +806,6 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 
 bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
 
-/* Interrupt Handling */
-bool ath9k_hw_intrpend(struct ath_hw *ah);
-bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked);
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
-
 /* Generic hw timer primitives */
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index d620398..8e81c7a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -31,6 +31,158 @@ static void ar9002_hw_get_desc_link(void *ds, u32 **ds_link)
 	*ds_link = &((struct ath_desc *)ds)->ds_link;
 }
 
+static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
+{
+	u32 isr = 0;
+	u32 mask2 = 0;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	u32 sync_cause = 0;
+	bool fatal_int = false;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!AR_SREV_9100(ah)) {
+		if (REG_READ(ah, AR_INTR_ASYNC_CAUSE) & AR_INTR_MAC_IRQ) {
+			if ((REG_READ(ah, AR_RTC_STATUS) & AR_RTC_STATUS_M)
+			    == AR_RTC_STATUS_ON) {
+				isr = REG_READ(ah, AR_ISR);
+			}
+		}
+
+		sync_cause = REG_READ(ah, AR_INTR_SYNC_CAUSE) &
+			AR_INTR_SYNC_DEFAULT;
+
+		*masked = 0;
+
+		if (!isr && !sync_cause)
+			return false;
+	} else {
+		*masked = 0;
+		isr = REG_READ(ah, AR_ISR);
+	}
+
+	if (isr) {
+		if (isr & AR_ISR_BCNMISC) {
+			u32 isr2;
+			isr2 = REG_READ(ah, AR_ISR_S2);
+			if (isr2 & AR_ISR_S2_TIM)
+				mask2 |= ATH9K_INT_TIM;
+			if (isr2 & AR_ISR_S2_DTIM)
+				mask2 |= ATH9K_INT_DTIM;
+			if (isr2 & AR_ISR_S2_DTIMSYNC)
+				mask2 |= ATH9K_INT_DTIMSYNC;
+			if (isr2 & (AR_ISR_S2_CABEND))
+				mask2 |= ATH9K_INT_CABEND;
+			if (isr2 & AR_ISR_S2_GTT)
+				mask2 |= ATH9K_INT_GTT;
+			if (isr2 & AR_ISR_S2_CST)
+				mask2 |= ATH9K_INT_CST;
+			if (isr2 & AR_ISR_S2_TSFOOR)
+				mask2 |= ATH9K_INT_TSFOOR;
+		}
+
+		isr = REG_READ(ah, AR_ISR_RAC);
+		if (isr == 0xffffffff) {
+			*masked = 0;
+			return false;
+		}
+
+		*masked = isr & ATH9K_INT_COMMON;
+
+		if (ah->config.rx_intr_mitigation) {
+			if (isr & (AR_ISR_RXMINTR | AR_ISR_RXINTM))
+				*masked |= ATH9K_INT_RX;
+		}
+
+		if (isr & (AR_ISR_RXOK | AR_ISR_RXERR))
+			*masked |= ATH9K_INT_RX;
+		if (isr &
+		    (AR_ISR_TXOK | AR_ISR_TXDESC | AR_ISR_TXERR |
+		     AR_ISR_TXEOL)) {
+			u32 s0_s, s1_s;
+
+			*masked |= ATH9K_INT_TX;
+
+			s0_s = REG_READ(ah, AR_ISR_S0_S);
+			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXOK);
+			ah->intr_txqs |= MS(s0_s, AR_ISR_S0_QCU_TXDESC);
+
+			s1_s = REG_READ(ah, AR_ISR_S1_S);
+			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXERR);
+			ah->intr_txqs |= MS(s1_s, AR_ISR_S1_QCU_TXEOL);
+		}
+
+		if (isr & AR_ISR_RXORN) {
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "receive FIFO overrun interrupt\n");
+		}
+
+		if (!AR_SREV_9100(ah)) {
+			if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+				u32 isr5 = REG_READ(ah, AR_ISR_S5_S);
+				if (isr5 & AR_ISR_S5_TIM_TIMER)
+					*masked |= ATH9K_INT_TIM_TIMER;
+			}
+		}
+
+		*masked |= mask2;
+	}
+
+	if (AR_SREV_9100(ah))
+		return true;
+
+	if (isr & AR_ISR_GENTMR) {
+		u32 s5_s;
+
+		s5_s = REG_READ(ah, AR_ISR_S5_S);
+		if (isr & AR_ISR_GENTMR) {
+			ah->intr_gen_timer_trigger =
+				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
+
+			ah->intr_gen_timer_thresh =
+				MS(s5_s, AR_ISR_S5_GENTIMER_THRESH);
+
+			if (ah->intr_gen_timer_trigger)
+				*masked |= ATH9K_INT_GENTIMER;
+
+		}
+	}
+
+	if (sync_cause) {
+		fatal_int =
+			(sync_cause &
+			 (AR_INTR_SYNC_HOST1_FATAL | AR_INTR_SYNC_HOST1_PERR))
+			? true : false;
+
+		if (fatal_int) {
+			if (sync_cause & AR_INTR_SYNC_HOST1_FATAL) {
+				ath_print(common, ATH_DBG_ANY,
+					  "received PCI FATAL interrupt\n");
+			}
+			if (sync_cause & AR_INTR_SYNC_HOST1_PERR) {
+				ath_print(common, ATH_DBG_ANY,
+					  "received PCI PERR interrupt\n");
+			}
+			*masked |= ATH9K_INT_FATAL;
+		}
+		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
+			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
+			REG_WRITE(ah, AR_RC, 0);
+			*masked |= ATH9K_INT_FATAL;
+		}
+		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
+			ath_print(common, ATH_DBG_INTERRUPT,
+				  "AR_INTR_SYNC_LOCAL_TIMEOUT\n");
+		}
+
+		REG_WRITE(ah, AR_INTR_SYNC_CAUSE_CLR, sync_cause);
+		(void) REG_READ(ah, AR_INTR_SYNC_CAUSE_CLR);
+	}
+
+	return true;
+}
+
 void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 {
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
@@ -38,6 +190,7 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 	ops->rx_enable = ar9002_hw_rx_enable;
 	ops->set_desc_link = ar9002_hw_set_desc_link;
 	ops->get_desc_link = ar9002_hw_get_desc_link;
+	ops->get_isr = ar9002_hw_get_isr;
 }
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
@@ -1090,3 +1243,140 @@ int ath9k_hw_beaconq_setup(struct ath_hw *ah)
 	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
 }
 EXPORT_SYMBOL(ath9k_hw_beaconq_setup);
+
+bool ath9k_hw_intrpend(struct ath_hw *ah)
+{
+	u32 host_isr;
+
+	if (AR_SREV_9100(ah))
+		return true;
+
+	host_isr = REG_READ(ah, AR_INTR_ASYNC_CAUSE);
+	if ((host_isr & AR_INTR_MAC_IRQ) && (host_isr != AR_INTR_SPURIOUS))
+		return true;
+
+	host_isr = REG_READ(ah, AR_INTR_SYNC_CAUSE);
+	if ((host_isr & AR_INTR_SYNC_DEFAULT)
+	    && (host_isr != AR_INTR_SPURIOUS))
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(ath9k_hw_intrpend);
+
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah,
+					      enum ath9k_int ints)
+{
+	enum ath9k_int omask = ah->imask;
+	u32 mask, mask2;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_print(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
+
+	if (omask & ATH9K_INT_GLOBAL) {
+		ath_print(common, ATH_DBG_INTERRUPT, "disable IER\n");
+		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
+		(void) REG_READ(ah, AR_IER);
+		if (!AR_SREV_9100(ah)) {
+			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, 0);
+			(void) REG_READ(ah, AR_INTR_ASYNC_ENABLE);
+
+			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
+			(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
+		}
+	}
+
+	/* TODO: global int Ref count */
+	mask = ints & ATH9K_INT_COMMON;
+	mask2 = 0;
+
+	if (ints & ATH9K_INT_TX) {
+		if (ah->config.tx_intr_mitigation)
+			mask |= AR_IMR_TXMINTR | AR_IMR_TXINTM;
+		if (ah->txok_interrupt_mask)
+			mask |= AR_IMR_TXOK;
+		if (ah->txdesc_interrupt_mask)
+			mask |= AR_IMR_TXDESC;
+		if (ah->txerr_interrupt_mask)
+			mask |= AR_IMR_TXERR;
+		if (ah->txeol_interrupt_mask)
+			mask |= AR_IMR_TXEOL;
+	}
+	if (ints & ATH9K_INT_RX) {
+		if (AR_SREV_9300_20_OR_LATER(ah)) {
+			mask |= AR_IMR_RXERR | AR_IMR_RXOK_HP;
+			if (ah->config.rx_intr_mitigation) {
+				mask &= ~AR_IMR_RXOK_LP;
+				mask |=  AR_IMR_RXMINTR | AR_IMR_RXINTM;
+			} else {
+				mask |= AR_IMR_RXOK_LP;
+			}
+		} else {
+			if (ah->config.rx_intr_mitigation)
+				mask |= AR_IMR_RXMINTR | AR_IMR_RXINTM;
+			else
+				mask |= AR_IMR_RXOK | AR_IMR_RXDESC;
+		}
+		if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
+			mask |= AR_IMR_GENTMR;
+	}
+
+	if (ints & (ATH9K_INT_BMISC)) {
+		mask |= AR_IMR_BCNMISC;
+		if (ints & ATH9K_INT_TIM)
+			mask2 |= AR_IMR_S2_TIM;
+		if (ints & ATH9K_INT_DTIM)
+			mask2 |= AR_IMR_S2_DTIM;
+		if (ints & ATH9K_INT_DTIMSYNC)
+			mask2 |= AR_IMR_S2_DTIMSYNC;
+		if (ints & ATH9K_INT_CABEND)
+			mask2 |= AR_IMR_S2_CABEND;
+		if (ints & ATH9K_INT_TSFOOR)
+			mask2 |= AR_IMR_S2_TSFOOR;
+	}
+
+	if (ints & (ATH9K_INT_GTT | ATH9K_INT_CST)) {
+		mask |= AR_IMR_BCNMISC;
+		if (ints & ATH9K_INT_GTT)
+			mask2 |= AR_IMR_S2_GTT;
+		if (ints & ATH9K_INT_CST)
+			mask2 |= AR_IMR_S2_CST;
+	}
+
+	ath_print(common, ATH_DBG_INTERRUPT, "new IMR 0x%x\n", mask);
+	REG_WRITE(ah, AR_IMR, mask);
+	ah->imrs2_reg &= ~(AR_IMR_S2_TIM | AR_IMR_S2_DTIM | AR_IMR_S2_DTIMSYNC |
+			   AR_IMR_S2_CABEND | AR_IMR_S2_CABTO |
+			   AR_IMR_S2_TSFOOR | AR_IMR_S2_GTT | AR_IMR_S2_CST);
+	ah->imrs2_reg |= mask2;
+	REG_WRITE(ah, AR_IMR_S2, ah->imrs2_reg);
+
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+		if (ints & ATH9K_INT_TIM_TIMER)
+			REG_SET_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
+		else
+			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
+	}
+
+	if (ints & ATH9K_INT_GLOBAL) {
+		ath_print(common, ATH_DBG_INTERRUPT, "enable IER\n");
+		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
+		if (!AR_SREV_9100(ah)) {
+			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
+				  AR_INTR_MAC_IRQ);
+			REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
+
+
+			REG_WRITE(ah, AR_INTR_SYNC_ENABLE,
+				  AR_INTR_SYNC_DEFAULT);
+			REG_WRITE(ah, AR_INTR_SYNC_MASK,
+				  AR_INTR_SYNC_DEFAULT);
+		}
+		ath_print(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
+			  REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
+	}
+
+	return omask;
+}
+EXPORT_SYMBOL(ath9k_hw_set_interrupts);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 99f81eb..7c0d754 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -736,6 +736,11 @@ void ath9k_hw_stoppcurecv(struct ath_hw *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
 int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
+/* Interrupt Handling */
+bool ath9k_hw_intrpend(struct ath_hw *ah);
+enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah,
+				       enum ath9k_int ints);
+
 void ar9002_hw_attach_mac_ops(struct ath_hw *ah);
 
 #endif /* MAC_H */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 96b2cfe..7f85633 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -253,6 +253,8 @@
 #define AR_IMR               0x00a0
 #define AR_IMR_RXOK          0x00000001
 #define AR_IMR_RXDESC        0x00000002
+#define AR_IMR_RXOK_HP	     0x00000001
+#define AR_IMR_RXOK_LP	     0x00000002
 #define AR_IMR_RXERR         0x00000004
 #define AR_IMR_RXNOPKT       0x00000008
 #define AR_IMR_RXEOL         0x00000010
-- 
1.6.3.3

