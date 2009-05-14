Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55425 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752484AbZENSaw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:30:52 -0400
Message-Id: <20090514183048.562864690@atheros.com>
References: <20090514182845.684003914@atheros.com>
Date: Thu, 14 May 2009 21:28:49 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 4/4] ath9k: Move PS wakeup/restore calls from isr to tasklet
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

We do not need to do this in ath_isr() and it looks like the modified
version ends up being more stable as far as being able receive beacon
frames is concerned. Furthermore, this reduces need to move between
AWAKE and NETWORK SLEEP states when processing some unrelated
interrupts.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/main.c |   23 +++++++++--------------
 drivers/net/wireless/ath/ath9k/recv.c |    2 --
 2 files changed, 9 insertions(+), 16 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-14 21:04:10.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-14 21:13:14.000000000 +0300
@@ -455,8 +455,11 @@ static void ath9k_tasklet(unsigned long 
 	struct ath_softc *sc = (struct ath_softc *)data;
 	u32 status = sc->intrstatus;
 
+	ath9k_ps_wakeup(sc);
+
 	if (status & ATH9K_INT_FATAL) {
 		ath_reset(sc, false);
+		ath9k_ps_restore(sc);
 		return;
 	}
 
@@ -471,6 +474,7 @@ static void ath9k_tasklet(unsigned long 
 
 	/* re-enable hardware interrupt */
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+	ath9k_ps_restore(sc);
 }
 
 irqreturn_t ath_isr(int irq, void *dev)
@@ -498,14 +502,11 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (sc->sc_flags & SC_OP_INVALID)
 		return IRQ_NONE;
 
-	ath9k_ps_wakeup(sc);
 
 	/* shared irq, not for us */
 
-	if (!ath9k_hw_intrpend(ah)) {
-		ath9k_ps_restore(sc);
+	if (!ath9k_hw_intrpend(ah))
 		return IRQ_NONE;
-	}
 
 	/*
 	 * Figure out the reason(s) for the interrupt.  Note
@@ -520,10 +521,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 	 * If there are no status bits set, then this interrupt was not
 	 * for me (should have been caught above).
 	 */
-	if (!status) {
-		ath9k_ps_restore(sc);
+	if (!status)
 		return IRQ_NONE;
-	}
 
 	/* Cache the status */
 	sc->intrstatus = status;
@@ -560,20 +559,16 @@ irqreturn_t ath_isr(int irq, void *dev)
 		ath9k_hw_set_interrupts(ah, sc->imask);
 	}
 
-	if (status & ATH9K_INT_TIM_TIMER) {
-		if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
+		if (status & ATH9K_INT_TIM_TIMER) {
 			/* Clear RxAbort bit so that we can
 			 * receive frames */
-			ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
-			ath9k_hw_setrxabort(ah, 0);
-			sched = true;
+			ath9k_hw_setrxabort(sc->sc_ah, 0);
 			sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
 		}
-	}
 
 chip_reset:
 
-	ath9k_ps_restore(sc);
 	ath_debug_stat_interrupt(sc, status);
 
 	if (sched) {
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-05-14 21:12:24.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-05-14 21:13:14.000000000 +0300
@@ -508,8 +508,6 @@ static bool ath_beacon_dtim_pending_cab(
 static void ath_rx_ps_back_to_sleep(struct ath_softc *sc)
 {
 	sc->sc_flags &= ~(SC_OP_WAIT_FOR_BEACON | SC_OP_WAIT_FOR_CAB);
-	if (sc->hw->conf.flags & IEEE80211_CONF_PS)
-		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
 }
 
 static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
