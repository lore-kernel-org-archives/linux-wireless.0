Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1KYSk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:40:58 -0500
Received: by mail-bw0-f46.google.com with SMTP id 11so4712560bke.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:40:58 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 03/12] ath5k: Cleanups v1
Date: Fri, 25 Nov 2011 20:40:22 +0200
Message-Id: <1322246431-10825-4-git-send-email-mickflemm@gmail.com> (sfid-20111125_194101_827018_A2DEF1B0)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes, just a few comments/documentation/cleanup

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |  112 ++++++++++++++++++++++++---------
 drivers/net/wireless/ath/ath5k/dma.c  |   17 ++++-
 2 files changed, 96 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c18d310..47194a4 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2149,69 +2149,110 @@ ath5k_intr(int irq, void *dev_id)
 	enum ath5k_int status;
 	unsigned int counter = 1000;
 
+
+	/*
+	 * If hw is not ready (or detached) and we get an
+	 * interrupt, or if we have no interrupts pending
+	 * (that means it's not for us) skip it.
+	 *
+	 * NOTE: Group 0/1 PCI interface registers are not
+	 * supported on WiSOCs, so we can't check for pending
+	 * interrupts (ISR belongs to another register group
+	 * so we are ok).
+	 */
 	if (unlikely(test_bit(ATH_STAT_INVALID, ah->status) ||
-		((ath5k_get_bus_type(ah) != ATH_AHB) &&
-				!ath5k_hw_is_intr_pending(ah))))
+			((ath5k_get_bus_type(ah) != ATH_AHB) &&
+			!ath5k_hw_is_intr_pending(ah))))
 		return IRQ_NONE;
 
+	/** Main loop **/
 	do {
-		ath5k_hw_get_isr(ah, &status);		/* NB: clears IRQ too */
+		ath5k_hw_get_isr(ah, &status);	/* NB: clears IRQ too */
+
 		ATH5K_DBG(ah, ATH5K_DEBUG_INTR, "status 0x%x/0x%x\n",
 				status, ah->imask);
+
+		/*
+		 * Fatal hw error -> Log and reset
+		 *
+		 * Fatal errors are unrecoverable so we have to
+		 * reset the card. These errors include bus and
+		 * dma errors.
+		 */
 		if (unlikely(status & AR5K_INT_FATAL)) {
-			/*
-			 * Fatal errors are unrecoverable.
-			 * Typically these are caused by DMA errors.
-			 */
+
 			ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 				  "fatal int, resetting\n");
 			ieee80211_queue_work(ah->hw, &ah->reset_work);
+
+		/*
+		 * RX Overrun -> Count and reset if needed
+		 *
+		 * Receive buffers are full. Either the bus is busy or
+		 * the CPU is not fast enough to process all received
+		 * frames.
+		 */
 		} else if (unlikely(status & AR5K_INT_RXORN)) {
+
 			/*
-			 * Receive buffers are full. Either the bus is busy or
-			 * the CPU is not fast enough to process all received
-			 * frames.
 			 * Older chipsets need a reset to come out of this
 			 * condition, but we treat it as RX for newer chips.
-			 * We don't know exactly which versions need a reset -
+			 * We don't know exactly which versions need a reset
 			 * this guess is copied from the HAL.
 			 */
 			ah->stats.rxorn_intr++;
+
 			if (ah->ah_mac_srev < AR5K_SREV_AR5212) {
 				ATH5K_DBG(ah, ATH5K_DEBUG_RESET,
 					  "rx overrun, resetting\n");
 				ieee80211_queue_work(ah->hw, &ah->reset_work);
 			} else
 				ath5k_schedule_rx(ah);
+
 		} else {
+
+			/* Software Beacon Alert -> Schedule beacon tasklet */
 			if (status & AR5K_INT_SWBA)
 				tasklet_hi_schedule(&ah->beacontq);
 
-			if (status & AR5K_INT_RXEOL) {
-				/*
-				* NB: the hardware should re-read the link when
-				*     RXE bit is written, but it doesn't work at
-				*     least on older hardware revs.
-				*/
+			/*
+			 * No more RX descriptors -> Just count
+			 *
+			 * NB: the hardware should re-read the link when
+			 *     RXE bit is written, but it doesn't work at
+			 *     least on older hardware revs.
+			 */
+			if (status & AR5K_INT_RXEOL)
 				ah->stats.rxeol_intr++;
-			}
-			if (status & AR5K_INT_TXURN) {
-				/* bump tx trigger level */
+
+
+			/* TX Underrun -> Bump tx trigger level */
+			if (status & AR5K_INT_TXURN)
 				ath5k_hw_update_tx_triglevel(ah, true);
-			}
+
+			/* RX -> Schedule rx tasklet */
 			if (status & (AR5K_INT_RXOK | AR5K_INT_RXERR))
 				ath5k_schedule_rx(ah);
-			if (status & (AR5K_INT_TXOK | AR5K_INT_TXDESC
-					| AR5K_INT_TXERR | AR5K_INT_TXEOL))
+
+			/* TX -> Schedule tx tasklet */
+			if (status & (AR5K_INT_TXOK
+					| AR5K_INT_TXDESC
+					| AR5K_INT_TXERR
+					| AR5K_INT_TXEOL))
 				ath5k_schedule_tx(ah);
-			if (status & AR5K_INT_BMISS) {
-				/* TODO */
-			}
+
+			/* Missed beacon -> TODO
+			if (status & AR5K_INT_BMISS)
+			*/
+
+			/* MIB event -> Update counters and notify ANI */
 			if (status & AR5K_INT_MIB) {
 				ah->stats.mib_intr++;
 				ath5k_hw_update_mib_counters(ah);
 				ath5k_ani_mib_intr(ah);
 			}
+
+			/* GPIO -> Notify RFKill layer */
 			if (status & AR5K_INT_GPIO)
 				tasklet_schedule(&ah->rf_kill.toggleq);
 
@@ -2222,12 +2263,19 @@ ath5k_intr(int irq, void *dev_id)
 
 	} while (ath5k_hw_is_intr_pending(ah) && --counter > 0);
 
+	/*
+	 * Until we handle rx/tx interrupts mask them on IMR
+	 *
+	 * NOTE: ah->(rx/tx)_pending are set when scheduling the tasklets
+	 * and unset after we 've handled the interrupts.
+	 */
 	if (ah->rx_pending || ah->tx_pending)
 		ath5k_set_current_imask(ah);
 
 	if (unlikely(!counter))
 		ATH5K_WARN(ah, "too many interrupts, giving up for now\n");
 
+	/* Fire up calibration poll */
 	ath5k_intr_calibration_poll(ah);
 
 	return IRQ_HANDLED;
@@ -2544,9 +2592,15 @@ int ath5k_start(struct ieee80211_hw *hw)
 	 * and then setup of the interrupt mask.
 	 */
 	ah->curchan = ah->hw->conf.channel;
-	ah->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
-		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
-		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
+	ah->imask = AR5K_INT_RXOK
+		| AR5K_INT_RXERR
+		| AR5K_INT_RXEOL
+		| AR5K_INT_RXORN
+		| AR5K_INT_TXDESC
+		| AR5K_INT_TXEOL
+		| AR5K_INT_FATAL
+		| AR5K_INT_GLOBAL
+		| AR5K_INT_MIB;
 
 	ret = ath5k_reset(ah, NULL, false);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index b5db6e7..97864d8 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -701,21 +701,25 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 		if (unlikely(pisr & (AR5K_ISR_BNR)))
 			*interrupt_mask |= AR5K_INT_BNR;
 
+		/* Doppler chirp received */
 		if (unlikely(pisr & (AR5K_ISR_RXDOPPLER)))
 			*interrupt_mask |= AR5K_INT_RX_DOPPLER;
 
+		/* A queue got CBR overrun */
 		if (unlikely(pisr & (AR5K_ISR_QCBRORN))) {
 			*interrupt_mask |= AR5K_INT_QCBRORN;
 			ah->ah_txq_isr_qcborn |= AR5K_REG_MS(sisr3,
 						AR5K_SISR3_QCBRORN);
 		}
 
+		/* A queue got CBR underrun */
 		if (unlikely(pisr & (AR5K_ISR_QCBRURN))) {
 			*interrupt_mask |= AR5K_INT_QCBRURN;
 			ah->ah_txq_isr_qcburn |= AR5K_REG_MS(sisr3,
 						AR5K_SISR3_QCBRURN);
 		}
 
+		/* A queue got triggered */
 		if (unlikely(pisr & (AR5K_ISR_QTRIG))) {
 			*interrupt_mask |= AR5K_INT_QTRIG;
 			ah->ah_txq_isr_qtrig |= AR5K_REG_MS(sisr4,
@@ -772,16 +776,14 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 		u32 simr2 = ath5k_hw_reg_read(ah, AR5K_SIMR2)
 				& AR5K_SIMR2_QCU_TXURN;
 
+		/* Fatal interrupt abstraction for 5211+ */
 		if (new_mask & AR5K_INT_FATAL) {
 			int_mask |= AR5K_IMR_HIUERR;
 			simr2 |= (AR5K_SIMR2_MCABT | AR5K_SIMR2_SSERR
 				| AR5K_SIMR2_DPERR);
 		}
 
-		/*Beacon Not Ready*/
-		if (new_mask & AR5K_INT_BNR)
-			int_mask |= AR5K_INT_BNR;
-
+		/* Misc beacon related interrupts */
 		if (new_mask & AR5K_INT_TIM)
 			int_mask |= AR5K_IMR_TIM;
 
@@ -796,6 +798,11 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 		if (new_mask & AR5K_INT_CAB_TIMEOUT)
 			simr2 |= AR5K_SISR2_CAB_TIMEOUT;
 
+		/*Beacon Not Ready*/
+		if (new_mask & AR5K_INT_BNR)
+			int_mask |= AR5K_INT_BNR;
+
+		/* RX doppler chirp */
 		if (new_mask & AR5K_INT_RX_DOPPLER)
 			int_mask |= AR5K_IMR_RXDOPPLER;
 
@@ -805,10 +812,12 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 		ath5k_hw_reg_write(ah, simr2, AR5K_SIMR2);
 
 	} else {
+		/* Fatal interrupt abstraction for 5210 */
 		if (new_mask & AR5K_INT_FATAL)
 			int_mask |= (AR5K_IMR_SSERR | AR5K_IMR_MCABT
 				| AR5K_IMR_HIUERR | AR5K_IMR_DPERR);
 
+		/* Only common interrupts left for 5210 (no SIMRs) */
 		ath5k_hw_reg_write(ah, int_mask, AR5K_IMR);
 	}
 
-- 
1.7.8.rc3

