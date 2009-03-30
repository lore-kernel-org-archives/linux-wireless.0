Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25190 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbZC3KDG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:03:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:03:05 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38873.557715.553025@gargle.gargle.HOWL> (sfid-20090330_120319_537159_D06E63E6)
Date: Mon, 30 Mar 2009 15:28:49 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 15/17] ath9k: Clean Interrupt handling routine
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up the ISR, removing a unnecessary do..while
loop, and waking up the chip before getting the pending
interrupts.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |  197 ++++++++++++++++++-------------------
 1 files changed, 95 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index d8b7993..70738d5 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -456,133 +456,124 @@ static void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 
 	if (status & ATH9K_INT_FATAL) {
-		/* need a chip reset */
 		ath_reset(sc, false);
 		return;
-	} else {
+	}
 
-		if (status &
-		    (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN)) {
-			spin_lock_bh(&sc->rx.rxflushlock);
-			ath_rx_tasklet(sc, 0);
-			spin_unlock_bh(&sc->rx.rxflushlock);
-		}
-		/* XXX: optimize this */
-		if (status & ATH9K_INT_TX)
-			ath_tx_tasklet(sc);
+	if (status & (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN)) {
+		spin_lock_bh(&sc->rx.rxflushlock);
+		ath_rx_tasklet(sc, 0);
+		spin_unlock_bh(&sc->rx.rxflushlock);
 	}
 
+	if (status & ATH9K_INT_TX)
+		ath_tx_tasklet(sc);
+
 	/* re-enable hardware interrupt */
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 }
 
 irqreturn_t ath_isr(int irq, void *dev)
 {
+#define SCHED_INTR (				\
+		ATH9K_INT_FATAL |		\
+		ATH9K_INT_RXORN |		\
+		ATH9K_INT_RXEOL |		\
+		ATH9K_INT_RX |			\
+		ATH9K_INT_TX |			\
+		ATH9K_INT_BMISS |		\
+		ATH9K_INT_CST |			\
+		ATH9K_INT_TSFOOR)
+
 	struct ath_softc *sc = dev;
 	struct ath_hw *ah = sc->sc_ah;
 	enum ath9k_int status;
 	bool sched = false;
 
-	do {
-		if (sc->sc_flags & SC_OP_INVALID) {
-			/*
-			 * The hardware is not ready/present, don't
-			 * touch anything. Note this can happen early
-			 * on if the IRQ is shared.
-			 */
-			return IRQ_NONE;
-		}
-		if (!ath9k_hw_intrpend(ah)) {	/* shared irq, not for us */
-			return IRQ_NONE;
-		}
+	/*
+	 * The hardware is not ready/present, don't
+	 * touch anything. Note this can happen early
+	 * on if the IRQ is shared.
+	 */
+	if (sc->sc_flags & SC_OP_INVALID)
+		return IRQ_NONE;
 
-		/*
-		 * Figure out the reason(s) for the interrupt.  Note
-		 * that the hal returns a pseudo-ISR that may include
-		 * bits we haven't explicitly enabled so we mask the
-		 * value to insure we only process bits we requested.
-		 */
-		ath9k_hw_getisr(ah, &status);	/* NB: clears ISR too */
+	ath9k_ps_wakeup(sc);
 
-		status &= sc->imask;	/* discard unasked-for bits */
+	/* shared irq, not for us */
+
+	if (!ath9k_hw_intrpend(ah)) {
+		ath9k_ps_restore(sc);
+		return IRQ_NONE;
+	}
+
+	/*
+	 * Figure out the reason(s) for the interrupt.  Note
+	 * that the hal returns a pseudo-ISR that may include
+	 * bits we haven't explicitly enabled so we mask the
+	 * value to insure we only process bits we requested.
+	 */
+	ath9k_hw_getisr(ah, &status);	/* NB: clears ISR too */
+	status &= sc->imask;	/* discard unasked-for bits */
+
+	/*
+	 * If there are no status bits set, then this interrupt was not
+	 * for me (should have been caught above).
+	 */
+	if (!status) {
+		ath9k_ps_restore(sc);
+		return IRQ_NONE;
+	}
 
+	/* Cache the status */
+	sc->intrstatus = status;
+
+	if (status & SCHED_INTR)
+		sched = true;
+
+	/*
+	 * If a FATAL or RXORN interrupt is received, we have to reset the
+	 * chip immediately.
+	 */
+	if (status & (ATH9K_INT_FATAL | ATH9K_INT_RXORN))
+		goto chip_reset;
+
+	if (status & ATH9K_INT_SWBA)
+		tasklet_schedule(&sc->bcon_tasklet);
+
+	if (status & ATH9K_INT_TXURN)
+		ath9k_hw_updatetxtriglevel(ah, true);
+
+	if (status & ATH9K_INT_MIB) {
 		/*
-		 * If there are no status bits set, then this interrupt was not
-		 * for me (should have been caught above).
+		 * Disable interrupts until we service the MIB
+		 * interrupt; otherwise it will continue to
+		 * fire.
 		 */
-		if (!status)
-			return IRQ_NONE;
-
-		sc->intrstatus = status;
-		ath9k_ps_wakeup(sc);
+		ath9k_hw_set_interrupts(ah, 0);
+		/*
+		 * Let the hal handle the event. We assume
+		 * it will clear whatever condition caused
+		 * the interrupt.
+		 */
+		ath9k_hw_procmibevent(ah, &sc->nodestats);
+		ath9k_hw_set_interrupts(ah, sc->imask);
+	}
 
-		if (status & ATH9K_INT_FATAL) {
-			/* need a chip reset */
-			sched = true;
-		} else if (status & ATH9K_INT_RXORN) {
-			/* need a chip reset */
+	if (status & ATH9K_INT_TIM_TIMER) {
+		if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+			/* Clear RxAbort bit so that we can
+			 * receive frames */
+			ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
+			ath9k_hw_setrxabort(ah, 0);
 			sched = true;
-		} else {
-			if (status & ATH9K_INT_SWBA) {
-				/* schedule a tasklet for beacon handling */
-				tasklet_schedule(&sc->bcon_tasklet);
-			}
-			if (status & ATH9K_INT_RXEOL) {
-				/*
-				 * NB: the hardware should re-read the link when
-				 *     RXE bit is written, but it doesn't work
-				 *     at least on older hardware revs.
-				 */
-				sched = true;
-			}
-
-			if (status & ATH9K_INT_TXURN)
-				/* bump tx trigger level */
-				ath9k_hw_updatetxtriglevel(ah, true);
-			/* XXX: optimize this */
-			if (status & ATH9K_INT_RX)
-				sched = true;
-			if (status & ATH9K_INT_TX)
-				sched = true;
-			if (status & ATH9K_INT_BMISS)
-				sched = true;
-			/* carrier sense timeout */
-			if (status & ATH9K_INT_CST)
-				sched = true;
-			if (status & ATH9K_INT_MIB) {
-				/*
-				 * Disable interrupts until we service the MIB
-				 * interrupt; otherwise it will continue to
-				 * fire.
-				 */
-				ath9k_hw_set_interrupts(ah, 0);
-				/*
-				 * Let the hal handle the event. We assume
-				 * it will clear whatever condition caused
-				 * the interrupt.
-				 */
-				ath9k_hw_procmibevent(ah, &sc->nodestats);
-				ath9k_hw_set_interrupts(ah, sc->imask);
-			}
-			if (status & ATH9K_INT_TIM_TIMER) {
-				if (!(ah->caps.hw_caps &
-				      ATH9K_HW_CAP_AUTOSLEEP)) {
-					/* Clear RxAbort bit so that we can
-					 * receive frames */
-					ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
-					ath9k_hw_setrxabort(ah, 0);
-					sched = true;
-					sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
-				}
-			}
-			if (status & ATH9K_INT_TSFOOR) {
-				/* FIXME: Handle this interrupt for power save */
-				sched = true;
-			}
+			sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
 		}
-		ath9k_ps_restore(sc);
-	} while (0);
+	}
 
+chip_reset:
+
+	ath9k_ps_restore(sc);
 	ath_debug_stat_interrupt(sc, status);
 
 	if (sched) {
@@ -592,6 +583,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 	}
 
 	return IRQ_HANDLED;
+
+#undef SCHED_INTR
 }
 
 static u32 ath_get_extchanmode(struct ath_softc *sc,
-- 
1.6.2.1

