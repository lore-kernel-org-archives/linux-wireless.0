Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33762 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdAYQg5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 11:36:57 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/4] ath9k: fix race condition in enabling/disabling IRQs
Date: Wed, 25 Jan 2017 17:36:54 +0100
Message-Id: <20170125163654.66431-4-nbd@nbd.name> (sfid-20170125_173708_880538_D9168E94)
In-Reply-To: <20170125163654.66431-1-nbd@nbd.name>
References: <20170125163654.66431-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code currently relies on refcounting to disable IRQs from within the
IRQ handler and re-enabling them again after the tasklet has run.

However, due to race conditions sometimes the IRQ handler might be
called twice, or the tasklet may not run at all (if interrupted in the
middle of a reset).

This can cause nasty imbalances in the irq-disable refcount which will
get the driver permanently stuck until the entire radio has been stopped
and started again (ath_reset will not recover from this).

Instead of using this fragile logic, change the code to ensure that
running the irq handler during tasklet processing is safe, and leave the
refcount untouched.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  |  1 +
 drivers/net/wireless/ath/ath9k/mac.c   | 44 ++++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/mac.h   |  1 +
 drivers/net/wireless/ath/ath9k/main.c  | 15 ++++++++----
 5 files changed, 48 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a396c99ee84d..46dfca522be3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -998,6 +998,7 @@ struct ath_softc {
 	struct survey_info *cur_survey;
 	struct survey_info survey[ATH9K_NUM_CHANNELS];
 
+	spinlock_t intr_lock;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hw *sc_ah;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a2f7f48bbb92..fa4b3cc1ba22 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -669,6 +669,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 		common->bt_ant_diversity = 1;
 
 	spin_lock_init(&common->cc_lock);
+	spin_lock_init(&sc->intr_lock);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	spin_lock_init(&sc->chan_lock);
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index f79587570af6..c059dfcaca22 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -810,21 +810,12 @@ void ath9k_hw_disable_interrupts(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_disable_interrupts);
 
-void ath9k_hw_enable_interrupts(struct ath_hw *ah)
+static void __ath9k_hw_enable_interrupts(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 sync_default = AR_INTR_SYNC_DEFAULT;
 	u32 async_mask;
 
-	if (!(ah->imask & ATH9K_INT_GLOBAL))
-		return;
-
-	if (!atomic_inc_and_test(&ah->intr_ref_cnt)) {
-		ath_dbg(common, INTERRUPT, "Do not enable IER ref count %d\n",
-			atomic_read(&ah->intr_ref_cnt));
-		return;
-	}
-
 	if (AR_SREV_9340(ah) || AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
 	    AR_SREV_9561(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
@@ -846,6 +837,39 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 	ath_dbg(common, INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
 		REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
 }
+
+void ath9k_hw_resume_interrupts(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!(ah->imask & ATH9K_INT_GLOBAL))
+		return;
+
+	if (atomic_read(&ah->intr_ref_cnt) != 0) {
+		ath_dbg(common, INTERRUPT, "Do not enable IER ref count %d\n",
+			atomic_read(&ah->intr_ref_cnt));
+		return;
+	}
+
+	__ath9k_hw_enable_interrupts(ah);
+}
+EXPORT_SYMBOL(ath9k_hw_resume_interrupts);
+
+void ath9k_hw_enable_interrupts(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!(ah->imask & ATH9K_INT_GLOBAL))
+		return;
+
+	if (!atomic_inc_and_test(&ah->intr_ref_cnt)) {
+		ath_dbg(common, INTERRUPT, "Do not enable IER ref count %d\n",
+			atomic_read(&ah->intr_ref_cnt));
+		return;
+	}
+
+	__ath9k_hw_enable_interrupts(ah);
+}
 EXPORT_SYMBOL(ath9k_hw_enable_interrupts);
 
 void ath9k_hw_set_interrupts(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 3bab01435a86..770fc11b41d1 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -744,6 +744,7 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah);
 void ath9k_hw_enable_interrupts(struct ath_hw *ah);
 void ath9k_hw_disable_interrupts(struct ath_hw *ah);
 void ath9k_hw_kill_interrupts(struct ath_hw *ah);
+void ath9k_hw_resume_interrupts(struct ath_hw *ah);
 
 void ar9002_hw_attach_mac_ops(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 985b1cade4a4..d8ea087bdd07 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -375,9 +375,14 @@ void ath9k_tasklet(unsigned long data)
 	struct ath_common *common = ath9k_hw_common(ah);
 	enum ath_reset_type type;
 	unsigned long flags;
-	u32 status = sc->intrstatus;
+	u32 status;
 	u32 rxmask;
 
+	spin_lock_irqsave(&sc->intr_lock, flags);
+	status = sc->intrstatus;
+	sc->intrstatus = 0;
+	spin_unlock_irqrestore(&sc->intr_lock, flags);
+
 	ath9k_ps_wakeup(sc);
 	spin_lock(&sc->sc_pcu_lock);
 
@@ -480,7 +485,7 @@ void ath9k_tasklet(unsigned long data)
 	ath9k_btcoex_handle_interrupt(sc, status);
 
 	/* re-enable hardware interrupt */
-	ath9k_hw_enable_interrupts(ah);
+	ath9k_hw_resume_interrupts(ah);
 out:
 	spin_unlock(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
@@ -544,7 +549,9 @@ irqreturn_t ath_isr(int irq, void *dev)
 		return IRQ_NONE;
 
 	/* Cache the status */
-	sc->intrstatus = status;
+	spin_lock(&sc->intr_lock);
+	sc->intrstatus |= status;
+	spin_unlock(&sc->intr_lock);
 
 	if (status & SCHED_INTR)
 		sched = true;
@@ -590,7 +597,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 	if (sched) {
 		/* turn off every interrupt */
-		ath9k_hw_disable_interrupts(ah);
+		ath9k_hw_kill_interrupts(ah);
 		tasklet_schedule(&sc->intr_tq);
 	}
 
-- 
2.11.0
