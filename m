Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:52402
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933526AbaKMReL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 12:34:11 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.18 3/3] ath9k: do not access hardware on IRQs during reset
Date: Thu, 13 Nov 2014 18:34:05 +0100
Message-Id: <1415900045-49093-3-git-send-email-nbd@openwrt.org> (sfid-20141113_183417_060168_DF7DA73B)
In-Reply-To: <1415900045-49093-1-git-send-email-nbd@openwrt.org>
References: <1415900045-49093-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of killing interrupts during reset when the first one happens,
kill them before issuing the reset.
This fixes an easy to reproduce crash with multiple cards sharing the
same IRQ.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ee67956..19cab65 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -512,16 +512,13 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (!ah || test_bit(ATH_OP_INVALID, &common->op_flags))
 		return IRQ_NONE;
 
-	/* shared irq, not for us */
+	if (test_bit(ATH_OP_HW_RESET, &common->op_flags))
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
@@ -613,6 +610,7 @@ int ath_reset(struct ath_softc *sc, struct ath9k_channel *hchan)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int r;
 
+	ath9k_hw_kill_interrupts(sc->sc_ah);
 	set_bit(ATH_OP_HW_RESET, &common->op_flags);
 
 	ath9k_ps_wakeup(sc);
@@ -633,6 +631,7 @@ void ath9k_queue_reset(struct ath_softc *sc, enum ath_reset_type type)
 #ifdef CONFIG_ATH9K_DEBUGFS
 	RESET_STAT_INC(sc, type);
 #endif
+	ath9k_hw_kill_interrupts(sc->sc_ah);
 	set_bit(ATH_OP_HW_RESET, &common->op_flags);
 	ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 }
-- 
2.1.2

