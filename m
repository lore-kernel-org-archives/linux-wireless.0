Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17143 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbYG2Frk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:40 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:40 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, Sujith <Sujith.Manoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 09/16] ath9k: Use standard ISR return values, merge ath_intr and ath_isr
Date: Mon, 28 Jul 2008 22:47:18 -0700
Message-ID: <c64b03d55e96ddc532115847c5dcc1187c118f15.1217309552.git.lrodriguez@atheros.com> (sfid-20080729_074749_780499_6E0149B7)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index 5229710..b6281e5 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -964,11 +964,12 @@ int ath_suspend(struct ath_softc *sc)
 /* Interrupt handler.  Most of the actual processing is deferred.
  * It's the caller's responsibility to ensure the chip is awake. */
 
-int ath_intr(struct ath_softc *sc)
+irqreturn_t ath_isr(int irq, void *dev)
 {
+	struct ath_softc *sc = dev;
 	struct ath_hal *ah = sc->sc_ah;
 	enum hal_int status;
-	int sched = ATH_ISR_NOSCHED;
+	bool sched = false;
 
 	do {
 		if (sc->sc_invalid) {
@@ -977,10 +978,10 @@ int ath_intr(struct ath_softc *sc)
 			 * touch anything. Note this can happen early
 			 * on if the IRQ is shared.
 			 */
-			return ATH_ISR_NOTMINE;
+			return IRQ_NONE;
 		}
 		if (!ath9k_hw_intrpend(ah)) {	/* shared irq, not for us */
-			return ATH_ISR_NOTMINE;
+			return IRQ_NONE;
 		}
 
 		/*
@@ -999,16 +1000,16 @@ int ath_intr(struct ath_softc *sc)
 		 */
 
 		if (!status)
-			return ATH_ISR_NOTMINE;
+			return IRQ_NONE;
 
 		sc->sc_intrstatus = status;
 
 		if (status & HAL_INT_FATAL) {
 			/* need a chip reset */
-			sched = ATH_ISR_SCHED;
+			sched = true;
 		} else if (status & HAL_INT_RXORN) {
 			/* need a chip reset */
-			sched = ATH_ISR_SCHED;
+			sched = true;
 		} else {
 			if (status & HAL_INT_SWBA) {
 				/* schedule a tasklet for beacon handling */
@@ -1020,7 +1021,7 @@ int ath_intr(struct ath_softc *sc)
 				 *     RXE bit is written, but it doesn't work
 				 *     at least on older hardware revs.
 				 */
-				sched = ATH_ISR_SCHED;
+				sched = true;
 			}
 
 			if (status & HAL_INT_TXURN)
@@ -1028,14 +1029,14 @@ int ath_intr(struct ath_softc *sc)
 				ath9k_hw_updatetxtriglevel(ah, true);
 			/* XXX: optimize this */
 			if (status & HAL_INT_RX)
-				sched = ATH_ISR_SCHED;
+				sched = true;
 			if (status & HAL_INT_TX)
-				sched = ATH_ISR_SCHED;
+				sched = true;
 			if (status & HAL_INT_BMISS)
-				sched = ATH_ISR_SCHED;
+				sched = true;
 			/* carrier sense timeout */
 			if (status & HAL_INT_CST)
-				sched = ATH_ISR_SCHED;
+				sched = true;
 			if (status & HAL_INT_MIB) {
 				/*
 				 * Disable interrupts until we service the MIB
@@ -1059,19 +1060,19 @@ int ath_intr(struct ath_softc *sc)
 					/* Set flag indicating we're waiting
 					 * for a beacon */
 					sc->sc_waitbeacon = 1;
-
-					sched = ATH_ISR_SCHED;
+					sched = true;
 				}
 			}
 		}
 	} while (0);
 
-	if (sched == ATH_ISR_SCHED)
+	if (sched) {
 		/* turn off every interrupt except SWBA */
 		ath9k_hw_set_interrupts(ah, (sc->sc_imask & HAL_INT_SWBA));
+		tasklet_schedule(&sc->intr_tq);
+	}
 
-	return sched;
-
+	return IRQ_HANDLED;
 }
 
 /* Deferred interrupt processing  */
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 964ba58..7024c90 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -879,12 +879,6 @@ void ath_setdefantenna(void *sc, u_int antenna);
 
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 
-#define ATH_ISR_NOSCHED         0x0000	/* Do not schedule bottom half */
-/* Schedule the bottom half for execution */
-#define ATH_ISR_SCHED           0x0001
-/* This was not my interrupt, for shared IRQ's */
-#define ATH_ISR_NOTMINE         0x0002
-
 #define RSSI_LPF_THRESHOLD         -20
 #define ATH_RSSI_EP_MULTIPLIER     (1<<7)  /* pow2 to optimize out * and / */
 #define ATH_RATE_DUMMY_MARKER      0
@@ -1084,7 +1078,7 @@ int ath_init(u_int16_t devid, struct ath_softc *sc);
 void ath_deinit(struct ath_softc *sc);
 int ath_open(struct ath_softc *sc, struct hal_channel *initial_chan);
 int ath_suspend(struct ath_softc *sc);
-int ath_intr(struct ath_softc *sc);
+irqreturn_t ath_isr(int irq, void *dev);
 int ath_reset(struct ath_softc *sc);
 void ath_scan_start(struct ath_softc *sc);
 void ath_scan_end(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 24f69ef..7a8b42e 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1430,26 +1430,6 @@ bad:
 	return error;
 }
 
-static irqreturn_t ath_isr(int irq, void *dev_id)
-{
-	struct ath_softc *sc = dev_id;
-	int sched;
-
-	/* always acknowledge the interrupt */
-	sched = ath_intr(sc);
-
-	switch (sched) {
-	case ATH_ISR_NOSCHED:
-		return IRQ_HANDLED;
-	case ATH_ISR_NOTMINE:
-		return IRQ_NONE;
-	default:
-		tasklet_schedule(&sc->intr_tq);
-		return IRQ_HANDLED;
-
-	}
-}
-
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
-- 
1.5.4.3

