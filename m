Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:41848
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047AbaK3U6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 15:58:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 3/3] ath9k: do not access hardware on IRQs during reset
Date: Sun, 30 Nov 2014 21:58:32 +0100
Message-Id: <1417381112-33402-3-git-send-email-nbd@openwrt.org> (sfid-20141130_215838_606203_89BFCBD9)
In-Reply-To: <1417381112-33402-1-git-send-email-nbd@openwrt.org>
References: <1417381112-33402-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of killing interrupts during reset when the first one happens,
kill them before issuing the reset.
This fixes an easy to reproduce crash with multiple cards sharing the
same IRQ.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9437365..9a72640 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -512,16 +512,13 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (!ah || test_bit(ATH_OP_INVALID, &common->op_flags))
 		return IRQ_NONE;
 
-	/* shared irq, not for us */
+	if (!AR_SREV_9100(ah) && test_bit(ATH_OP_HW_RESET, &common->op_flags))
+		return IRQ_NONE;
 
+	/* shared irq, not for us */
 	if (!ath9k_hw_intrpend(ah))
 		return IRQ_NONE;
 
-	if (test_bit(ATH_OP_HW_RESET, &common->op_flags)) {
-		ath9k_hw_kill_interrupts(ah);
-		return IRQ_HANDLED;
-	}
-
 	/*
 	 * Figure out the reason(s) for the interrupt.  Note
 	 * that the hal returns a pseudo-ISR that may include
@@ -532,6 +529,9 @@ irqreturn_t ath_isr(int irq, void *dev)
 	ath9k_debug_sync_cause(sc, sync_cause);
 	status &= ah->imask;	/* discard unasked-for bits */
 
+	if (AR_SREV_9100(ah) && test_bit(ATH_OP_HW_RESET, &common->op_flags))
+		return IRQ_HANDLED;
+
 	/*
 	 * If there are no status bits set, then this interrupt was not
 	 * for me (should have been caught above).
@@ -613,6 +613,7 @@ int ath_reset(struct ath_softc *sc, struct ath9k_channel *hchan)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int r;
 
+	ath9k_hw_kill_interrupts(sc->sc_ah);
 	set_bit(ATH_OP_HW_RESET, &common->op_flags);
 
 	ath9k_ps_wakeup(sc);
@@ -633,6 +634,7 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
 #ifdef CONFIG_ATH9K_DEBUGFS
 	RESET_STAT_INC(sc, type);
 #endif
+	ath9k_hw_kill_interrupts(sc->sc_ah);
 	set_bit(ATH_OP_HW_RESET, &common->op_flags);
 	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 }
-- 
2.1.2

