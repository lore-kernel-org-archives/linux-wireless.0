Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33000 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab0KHTy5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 14:54:57 -0500
Message-ID: <4CD85587.70508@openwrt.org>
Date: Mon, 08 Nov 2010 20:54:47 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 1/6] ath9k_hw: optimize interrupt mask changes
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OProfile showed that ath9k was spending way too much time in
ath9k_hw_set_interrupts. Since most of the interrupt mask changes only
need to globally enable/disable interrupts, it makes sense to split
this part into separate functions, replacing all calls to
ath9k_hw_set_interrupts(ah, 0) with ath9k_hw_disable_interrupts(ah).

ath9k_hw_set_interrupts(ah, ah->imask) only gets changed to
ath9k_hw_enable_interrupts(ah), whenever ah->imask was not changed
since the point where interrupts were disabled.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 v2: leave a few ath9k_hw_set_interrupts(ah, ah->imask) calls, because
     the interrupt mask is changed earlier in the code.

 drivers/net/wireless/ath/ath9k/beacon.c |    6 +-
 drivers/net/wireless/ath/ath9k/gpio.c   |    4 +-
 drivers/net/wireless/ath/ath9k/mac.c    |   86 ++++++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/mac.h    |    6 ++-
 drivers/net/wireless/ath/ath9k/main.c   |   18 +++---
 5 files changed, 68 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 19891e7..333da7b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -503,7 +503,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 
 	/* Set the computed AP beacon timers */
 
-	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_disable_interrupts(ah);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(ah, ah->imask);
@@ -638,7 +638,7 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 
 	/* Set the computed STA beacon timers */
 
-	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_disable_interrupts(ah);
 	ath9k_hw_set_sta_beacon_timers(ah, &bs);
 	ah->imask |= ATH9K_INT_BMISS;
 	ath9k_hw_set_interrupts(ah, ah->imask);
@@ -686,7 +686,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 
 	/* Set the computed ADHOC beacon timers */
 
-	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_disable_interrupts(ah);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(ah, ah->imask);
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 4a9a68b..db9c6fe 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -259,7 +259,7 @@ static void ath9k_gen_timer_start(struct ath_hw *ah,
 	ath9k_hw_gen_timer_start(ah, timer, timer_next, timer_period);
 
 	if ((ah->imask & ATH9K_INT_GENTIMER) == 0) {
-		ath9k_hw_set_interrupts(ah, 0);
+		ath9k_hw_disable_interrupts(ah);
 		ah->imask |= ATH9K_INT_GENTIMER;
 		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
@@ -273,7 +273,7 @@ static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 
 	/* if no timer is enabled, turn off interrupt mask */
 	if (timer_table->timer_mask.val == 0) {
-		ath9k_hw_set_interrupts(ah, 0);
+		ath9k_hw_disable_interrupts(ah);
 		ah->imask &= ~ATH9K_INT_GENTIMER;
 		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 8c13479..65b1ee2 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -117,12 +117,11 @@ EXPORT_SYMBOL(ath9k_hw_numtxpending);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 {
 	u32 txcfg, curLevel, newLevel;
-	enum ath9k_int omask;
 
 	if (ah->tx_trig_level >= ah->config.max_txtrig_level)
 		return false;
 
-	omask = ath9k_hw_set_interrupts(ah, ah->imask & ~ATH9K_INT_GLOBAL);
+	ath9k_hw_disable_interrupts(ah);
 
 	txcfg = REG_READ(ah, AR_TXCFG);
 	curLevel = MS(txcfg, AR_FTRIG);
@@ -136,7 +135,7 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 		REG_WRITE(ah, AR_TXCFG,
 			  (txcfg & ~AR_FTRIG) | SM(newLevel, AR_FTRIG));
 
-	ath9k_hw_set_interrupts(ah, omask);
+	ath9k_hw_enable_interrupts(ah);
 
 	ah->tx_trig_level = newLevel;
 
@@ -849,28 +848,59 @@ bool ath9k_hw_intrpend(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_intrpend);
 
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah,
-					      enum ath9k_int ints)
+void ath9k_hw_disable_interrupts(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_print(common, ATH_DBG_INTERRUPT, "disable IER\n");
+	REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
+	(void) REG_READ(ah, AR_IER);
+	if (!AR_SREV_9100(ah)) {
+		REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, 0);
+		(void) REG_READ(ah, AR_INTR_ASYNC_ENABLE);
+
+		REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
+		(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_disable_interrupts);
+
+void ath9k_hw_enable_interrupts(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (!(ah->imask & ATH9K_INT_GLOBAL))
+		return;
+
+	ath_print(common, ATH_DBG_INTERRUPT, "enable IER\n");
+	REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
+	if (!AR_SREV_9100(ah)) {
+		REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
+			  AR_INTR_MAC_IRQ);
+		REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
+
+
+		REG_WRITE(ah, AR_INTR_SYNC_ENABLE,
+			  AR_INTR_SYNC_DEFAULT);
+		REG_WRITE(ah, AR_INTR_SYNC_MASK,
+			  AR_INTR_SYNC_DEFAULT);
+	}
+	ath_print(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
+		  REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
+}
+EXPORT_SYMBOL(ath9k_hw_enable_interrupts);
+
+void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 {
 	enum ath9k_int omask = ah->imask;
 	u32 mask, mask2;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	ath_print(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
-
-	if (omask & ATH9K_INT_GLOBAL) {
-		ath_print(common, ATH_DBG_INTERRUPT, "disable IER\n");
-		REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
-		(void) REG_READ(ah, AR_IER);
-		if (!AR_SREV_9100(ah)) {
-			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE, 0);
-			(void) REG_READ(ah, AR_INTR_ASYNC_ENABLE);
+	if (!(ints & ATH9K_INT_GLOBAL))
+		ath9k_hw_enable_interrupts(ah);
 
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE, 0);
-			(void) REG_READ(ah, AR_INTR_SYNC_ENABLE);
-		}
-	}
+	ath_print(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
 	/* TODO: global int Ref count */
 	mask = ints & ATH9K_INT_COMMON;
@@ -946,24 +976,8 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah,
 			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 	}
 
-	if (ints & ATH9K_INT_GLOBAL) {
-		ath_print(common, ATH_DBG_INTERRUPT, "enable IER\n");
-		REG_WRITE(ah, AR_IER, AR_IER_ENABLE);
-		if (!AR_SREV_9100(ah)) {
-			REG_WRITE(ah, AR_INTR_ASYNC_ENABLE,
-				  AR_INTR_MAC_IRQ);
-			REG_WRITE(ah, AR_INTR_ASYNC_MASK, AR_INTR_MAC_IRQ);
-
-
-			REG_WRITE(ah, AR_INTR_SYNC_ENABLE,
-				  AR_INTR_SYNC_DEFAULT);
-			REG_WRITE(ah, AR_INTR_SYNC_MASK,
-				  AR_INTR_SYNC_DEFAULT);
-		}
-		ath_print(common, ATH_DBG_INTERRUPT, "AR_IMR 0x%x IER 0x%x\n",
-			  REG_READ(ah, AR_IMR), REG_READ(ah, AR_IER));
-	}
+	ath9k_hw_enable_interrupts(ah);
 
-	return omask;
+	return;
 }
 EXPORT_SYMBOL(ath9k_hw_set_interrupts);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 7c1a34d..538c676 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -669,6 +669,7 @@ enum ath9k_key_type {
 
 struct ath_hw;
 struct ath9k_channel;
+enum ath9k_int;
 
 u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q);
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp);
@@ -700,8 +701,9 @@ int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
 /* Interrupt Handling */
 bool ath9k_hw_intrpend(struct ath_hw *ah);
-enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah,
-				       enum ath9k_int ints);
+void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
+void ath9k_hw_enable_interrupts(struct ath_hw *ah);
+void ath9k_hw_disable_interrupts(struct ath_hw *ah);
 
 void ar9002_hw_attach_mac_ops(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b52f1cf..ade9d7c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -239,7 +239,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	 * hardware at the new frequency, and then re-enable
 	 * the relevant bits of the h/w.
 	 */
-	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_disable_interrupts(ah);
 	ath_drain_all_txq(sc, false);
 
 	spin_lock_bh(&sc->rx.pcu_lock);
@@ -653,7 +653,7 @@ void ath9k_tasklet(unsigned long data)
 			ath_gen_timer_isr(sc->sc_ah);
 
 	/* re-enable hardware interrupt */
-	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 	ath9k_ps_restore(sc);
 }
 
@@ -752,7 +752,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		 * interrupt; otherwise it will continue to
 		 * fire.
 		 */
-		ath9k_hw_set_interrupts(ah, 0);
+		ath9k_hw_disable_interrupts(ah);
 		/*
 		 * Let the hal handle the event. We assume
 		 * it will clear whatever condition caused
@@ -761,7 +761,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		spin_lock(&common->cc_lock);
 		ath9k_hw_proc_mib_event(ah);
 		spin_unlock(&common->cc_lock);
-		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_enable_interrupts(ah);
 	}
 
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
@@ -778,8 +778,8 @@ chip_reset:
 	ath_debug_stat_interrupt(sc, status);
 
 	if (sched) {
-		/* turn off every interrupt except SWBA */
-		ath9k_hw_set_interrupts(ah, (ah->imask & ATH9K_INT_SWBA));
+		/* turn off every interrupt */
+		ath9k_hw_disable_interrupts(ah);
 		tasklet_schedule(&sc->intr_tq);
 	}
 
@@ -937,7 +937,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	}
 
 	/* Disable interrupts */
-	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_disable_interrupts(ah);
 
 	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
 
@@ -980,7 +980,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	ieee80211_stop_queues(hw);
 
-	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_disable_interrupts(ah);
 	ath_drain_all_txq(sc, retry_tx);
 
 	spin_lock_bh(&sc->rx.pcu_lock);
@@ -1394,7 +1394,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	/* make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
-	ath9k_hw_set_interrupts(ah, 0);
+	ath9k_hw_disable_interrupts(ah);
 
 	spin_lock_bh(&sc->rx.pcu_lock);
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
