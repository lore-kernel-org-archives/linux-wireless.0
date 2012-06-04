Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21170 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2FDOzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 10:55:16 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20428.52233.825371.168242@gargle.gargle.HOWL> (sfid-20120604_165526_210385_840486A8)
Date: Mon, 4 Jun 2012 20:24:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/7] ath9k: Handle fatal interrupts properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a fatal interrupt is received or it is detected that the baseband
has hung, the chip has to be reset immediately.  Otherwise, we end up
processing spurious interrupts. Ensure that we bail out properly in
the ISR when the reset work hasn't completed yet.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ae43de1..02fc1c1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -611,6 +611,7 @@ enum sc_op_flags {
 	SC_OP_TSF_RESET,
 	SC_OP_ANI_RUN,
 	SC_OP_PRIM_STA_VIF,
+	SC_OP_HW_RESET,
 };
 
 /* Powersave flags */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 86bfea9..6ff33c9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -218,6 +218,8 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
 			       sc->config.txpowlimit, &sc->curtxpow);
+
+	clear_bit(SC_OP_HW_RESET, &sc->sc_flags);
 	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 
@@ -362,6 +364,7 @@ void ath9k_tasklet(unsigned long data)
 
 		RESET_STAT_INC(sc, type);
 #endif
+		set_bit(SC_OP_HW_RESET, &sc->sc_flags);
 		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
 		goto out;
 	}
@@ -438,12 +441,14 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
 		return IRQ_NONE;
 
-
 	/* shared irq, not for us */
 
 	if (!ath9k_hw_intrpend(ah))
 		return IRQ_NONE;
 
+	if(test_bit(SC_OP_HW_RESET, &sc->sc_flags))
+		return IRQ_HANDLED;
+
 	/*
 	 * Figure out the reason(s) for the interrupt.  Note
 	 * that the hal returns a pseudo-ISR that may include
-- 
1.7.10.3

