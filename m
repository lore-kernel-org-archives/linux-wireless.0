Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:46006
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbbANNRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 08:17:40 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3.19] ath9k: fix race condition in irq processing during hardware reset
Date: Wed, 14 Jan 2015 14:17:36 +0100
Message-Id: <1421241456-29085-1-git-send-email-nbd@openwrt.org> (sfid-20150114_141743_490969_FC08592B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To fix invalid hardware accesses, the commit
"ath9k: do not access hardware on IRQs during reset" made the irq
handler ignore interrupts emitted after queueing a hardware reset (which
disables the IRQ). This left a small time window for the IRQ to get
re-enabled by the tasklet, which caused IRQ storms.
Instead of returning IRQ_NONE when ATH_OP_HW_RESET is set, disable the
IRQ entirely for the duration of the reset.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9a72640..62b0bf4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -285,6 +285,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 
 	__ath_cancel_work(sc);
 
+	disable_irq(sc->irq);
 	tasklet_disable(&sc->intr_tq);
 	tasklet_disable(&sc->bcon_tasklet);
 	spin_lock_bh(&sc->sc_pcu_lock);
@@ -331,6 +332,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 		r = -EIO;
 
 out:
+	enable_irq(sc->irq);
 	spin_unlock_bh(&sc->sc_pcu_lock);
 	tasklet_enable(&sc->bcon_tasklet);
 	tasklet_enable(&sc->intr_tq);
@@ -512,9 +514,6 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (!ah || test_bit(ATH_OP_INVALID, &common->op_flags))
 		return IRQ_NONE;
 
-	if (!AR_SREV_9100(ah) && test_bit(ATH_OP_HW_RESET, &common->op_flags))
-		return IRQ_NONE;
-
 	/* shared irq, not for us */
 	if (!ath9k_hw_intrpend(ah))
 		return IRQ_NONE;
@@ -529,7 +528,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 	ath9k_debug_sync_cause(sc, sync_cause);
 	status &= ah->imask;	/* discard unasked-for bits */
 
-	if (AR_SREV_9100(ah) && test_bit(ATH_OP_HW_RESET, &common->op_flags))
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
 		return IRQ_HANDLED;
 
 	/*
-- 
2.1.2

