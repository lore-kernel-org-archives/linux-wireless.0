Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbZEOGrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 02:47:16 -0400
Date: Fri, 15 May 2009 02:47:16 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [PATCH 4/4] ath9k: Move PS wakeup/restore calls from isr to
	tasklet
Message-ID: <20090515064715.GC24954@bombadil.infradead.org>
References: <20090514182845.684003914@atheros.com> <20090514183048.562864690@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090514183048.562864690@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 09:28:49PM +0300, Jouni Malinen wrote:
> From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> 
> We do not need to do this in ath_isr() and it looks like the modified
> version ends up being more stable as far as being able receive beacon
> frames is concerned. Furthermore, this reduces need to move between
> AWAKE and NETWORK SLEEP states when processing some unrelated
> interrupts.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

John, this one is misisng one line, please apply this one instead:

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] ath9k: Move PS wakeup/restore calls from isr to tasklet

We do not need to do this in ath_isr() and it looks like the modified
version ends up being more stable as far as being able receive beacon
frames is concerned. Furthermore, this reduces need to move between
AWAKE and NETWORK SLEEP states when processing some unrelated
interrupts.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   22 +++++++++-------------
 drivers/net/wireless/ath/ath9k/recv.c |    2 --
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bbbfdcd..df9b7c1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -455,8 +455,11 @@ static void ath9k_tasklet(unsigned long data)
 	struct ath_softc *sc = (struct ath_softc *)data;
 	u32 status = sc->intrstatus;
 
+	ath9k_ps_wakeup(sc);
+
 	if (status & ATH9K_INT_FATAL) {
 		ath_reset(sc, false);
+		ath9k_ps_restore(sc);
 		return;
 	}
 
@@ -471,6 +474,7 @@ static void ath9k_tasklet(unsigned long data)
 
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
@@ -560,20 +559,17 @@ irqreturn_t ath_isr(int irq, void *dev)
 		ath9k_hw_set_interrupts(ah, sc->imask);
 	}
 
-	if (status & ATH9K_INT_TIM_TIMER) {
-		if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
+		if (status & ATH9K_INT_TIM_TIMER) {
 			/* Clear RxAbort bit so that we can
 			 * receive frames */
 			ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
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
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 72e9283..5567517 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -508,8 +508,6 @@ static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
 static void ath_rx_ps_back_to_sleep(struct ath_softc *sc)
 {
 	sc->sc_flags &= ~(SC_OP_WAIT_FOR_BEACON | SC_OP_WAIT_FOR_CAB);
-	if (sc->hw->conf.flags & IEEE80211_CONF_PS)
-		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
 }
 
 static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
-- 
1.6.2.2.446.gfbdc0


