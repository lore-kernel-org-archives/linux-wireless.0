Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48965 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab3LNRD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 04/11] ath9k_hw: clean up generic timer code
Date: Sat, 14 Dec 2013 18:03:38 +0100
Message-Id: <1387040625-38114-4-git-send-email-nbd@openwrt.org> (sfid-20131214_180424_773809_7BA89D89)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- Use generic bitops instead of custom hackery
- Move interrupt enable/disable logic from ath9k to ath9k_hw
- Decouple ISR call from btcoex
- Make the overflow callback optional (to prevent IRQ storms)

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |  6 ---
 drivers/net/wireless/ath/ath9k/gpio.c   | 36 -------------
 drivers/net/wireless/ath/ath9k/hw.c     | 92 +++++++++++++++------------------
 drivers/net/wireless/ath/ath9k/hw.h     | 12 +----
 drivers/net/wireless/ath/ath9k/main.c   |  3 ++
 5 files changed, 45 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 9963b0b..3dfc2c7 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -66,7 +66,6 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		.bt_first_slot_time = 5,
 		.bt_hold_rx_clear = true,
 	};
-	u32 i, idx;
 	bool rxclear_polarity = ath_bt_config.bt_rxclear_polarity;
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
@@ -88,11 +87,6 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		SM(ath_bt_config.bt_hold_rx_clear, AR_BT_HOLD_RX_CLEAR) |
 		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
 		AR_BT_DISABLE_BT_ANT;
-
-	for (i = 0; i < 32; i++) {
-		idx = (debruijn32 << i) >> 27;
-		ah->hw_gen_timers.gen_timer_index[idx] = i;
-	}
 }
 EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index a85e220..b1956bf 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -157,36 +157,6 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 	}
 }
 
-static void ath9k_gen_timer_start(struct ath_hw *ah,
-				  struct ath_gen_timer *timer,
-				  u32 trig_timeout,
-				  u32 timer_period)
-{
-	ath9k_hw_gen_timer_start(ah, timer, trig_timeout, timer_period);
-
-	if ((ah->imask & ATH9K_INT_GENTIMER) == 0) {
-		ath9k_hw_disable_interrupts(ah);
-		ah->imask |= ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah);
-		ath9k_hw_enable_interrupts(ah);
-	}
-}
-
-static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
-{
-	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-
-	ath9k_hw_gen_timer_stop(ah, timer);
-
-	/* if no timer is enabled, turn off interrupt mask */
-	if (timer_table->timer_mask.val == 0) {
-		ath9k_hw_disable_interrupts(ah);
-		ah->imask &= ~ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah);
-		ath9k_hw_enable_interrupts(ah);
-	}
-}
-
 static void ath_mci_ftp_adjust(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
@@ -373,12 +343,6 @@ u16 ath9k_btcoex_aggr_limit(struct ath_softc *sc, u32 max_4ms_framelen)
 
 void ath9k_btcoex_handle_interrupt(struct ath_softc *sc, u32 status)
 {
-	struct ath_hw *ah = sc->sc_ah;
-
-	if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
-		if (status & ATH9K_INT_GENTIMER)
-			ath_gen_timer_isr(sc->sc_ah);
-
 	if (status & ATH9K_INT_MCI)
 		ath_mci_intr(sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4ee24b1..150bdce 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/time.h>
+#include <linux/bitops.h>
 #include <asm/unaligned.h>
 
 #include "hw.h"
@@ -2990,20 +2991,6 @@ static const struct ath_gen_timer_configuration gen_tmr_configuration[] =
 
 /* HW generic timer primitives */
 
-/* compute and clear index of rightmost 1 */
-static u32 rightmost_index(struct ath_gen_timer_table *timer_table, u32 *mask)
-{
-	u32 b;
-
-	b = *mask;
-	b &= (0-b);
-	*mask &= ~b;
-	b *= debruijn32;
-	b >>= 27;
-
-	return timer_table->gen_timer_index[b];
-}
-
 u32 ath9k_hw_gettsf32(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_TSF_L32);
@@ -3019,6 +3006,10 @@ struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 	struct ath_gen_timer *timer;
 
+	if ((timer_index < AR_FIRST_NDP_TIMER) ||
+		(timer_index >= ATH_MAX_GEN_TIMER))
+		return NULL;
+
 	timer = kzalloc(sizeof(struct ath_gen_timer), GFP_KERNEL);
 	if (timer == NULL)
 		return NULL;
@@ -3036,23 +3027,13 @@ EXPORT_SYMBOL(ath_gen_timer_alloc);
 
 void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 			      struct ath_gen_timer *timer,
-			      u32 trig_timeout,
+			      u32 timer_next,
 			      u32 timer_period)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-	u32 tsf, timer_next;
-
-	BUG_ON(!timer_period);
-
-	set_bit(timer->index, &timer_table->timer_mask.timer_bits);
-
-	tsf = ath9k_hw_gettsf32(ah);
-
-	timer_next = tsf + trig_timeout;
+	u32 mask = 0;
 
-	ath_dbg(ath9k_hw_common(ah), BTCOEX,
-		"current tsf %x period %x timer_next %x\n",
-		tsf, timer_period, timer_next);
+	timer_table->timer_mask |= BIT(timer->index);
 
 	/*
 	 * Program generic timer registers
@@ -3078,10 +3059,19 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 				       (1 << timer->index));
 	}
 
-	/* Enable both trigger and thresh interrupt masks */
-	REG_SET_BIT(ah, AR_IMR_S5,
-		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
-		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
+	if (timer->trigger)
+		mask |= SM(AR_GENTMR_BIT(timer->index),
+			   AR_IMR_S5_GENTIMER_TRIG);
+	if (timer->overflow)
+		mask |= SM(AR_GENTMR_BIT(timer->index),
+			   AR_IMR_S5_GENTIMER_THRESH);
+
+	REG_SET_BIT(ah, AR_IMR_S5, mask);
+
+	if ((ah->imask & ATH9K_INT_GENTIMER) == 0) {
+		ah->imask |= ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah);
+	}
 }
 EXPORT_SYMBOL(ath9k_hw_gen_timer_start);
 
@@ -3089,11 +3079,6 @@ void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 
-	if ((timer->index < AR_FIRST_NDP_TIMER) ||
-		(timer->index >= ATH_MAX_GEN_TIMER)) {
-		return;
-	}
-
 	/* Clear generic timer enable bits. */
 	REG_CLR_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
 			gen_tmr_configuration[timer->index].mode_mask);
@@ -3113,7 +3098,12 @@ void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
 		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
 
-	clear_bit(timer->index, &timer_table->timer_mask.timer_bits);
+	timer_table->timer_mask &= ~BIT(timer->index);
+
+	if (timer_table->timer_mask == 0) {
+		ah->imask &= ~ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah);
+	}
 }
 EXPORT_SYMBOL(ath9k_hw_gen_timer_stop);
 
@@ -3134,32 +3124,32 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 	struct ath_gen_timer *timer;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 trigger_mask, thresh_mask, index;
+	unsigned long trigger_mask, thresh_mask;
+	unsigned int index;
 
 	/* get hardware generic timer interrupt status */
 	trigger_mask = ah->intr_gen_timer_trigger;
 	thresh_mask = ah->intr_gen_timer_thresh;
-	trigger_mask &= timer_table->timer_mask.val;
-	thresh_mask &= timer_table->timer_mask.val;
+	trigger_mask &= timer_table->timer_mask;
+	thresh_mask &= timer_table->timer_mask;
 
 	trigger_mask &= ~thresh_mask;
 
-	while (thresh_mask) {
-		index = rightmost_index(timer_table, &thresh_mask);
+	for_each_set_bit(index, &thresh_mask, ARRAY_SIZE(timer_table->timers)) {
 		timer = timer_table->timers[index];
-		BUG_ON(!timer);
-		ath_dbg(common, BTCOEX, "TSF overflow for Gen timer %d\n",
-			index);
+		if (!timer)
+		    continue;
+		if (!timer->overflow)
+		    continue;
 		timer->overflow(timer->arg);
 	}
 
-	while (trigger_mask) {
-		index = rightmost_index(timer_table, &trigger_mask);
+	for_each_set_bit(index, &trigger_mask, ARRAY_SIZE(timer_table->timers)) {
 		timer = timer_table->timers[index];
-		BUG_ON(!timer);
-		ath_dbg(common, BTCOEX,
-			"Gen timer[%d] trigger\n", index);
+		if (!timer)
+		    continue;
+		if (!timer->trigger)
+		    continue;
 		timer->trigger(timer->arg);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b1ff546..1b45920 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -499,12 +499,6 @@ struct ath9k_hw_version {
 
 #define AR_GENTMR_BIT(_index)	(1 << (_index))
 
-/*
- * Using de Bruijin sequence to look up 1's index in a 32 bit number
- * debruijn32 = 0000 0111 0111 1100 1011 0101 0011 0001
- */
-#define debruijn32 0x077CB531U
-
 struct ath_gen_timer_configuration {
 	u32 next_addr;
 	u32 period_addr;
@@ -520,12 +514,8 @@ struct ath_gen_timer {
 };
 
 struct ath_gen_timer_table {
-	u32 gen_timer_index[32];
 	struct ath_gen_timer *timers[ATH_MAX_GEN_TIMER];
-	union {
-		unsigned long timer_bits;
-		u16 val;
-	} timer_mask;
+	u16 timer_mask;
 };
 
 struct ath_hw_antcomb_conf {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b1dcf89..4798f6a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -508,6 +508,9 @@ void ath9k_tasklet(unsigned long data)
 		wake_up(&sc->tx_wait);
 	}
 
+	if (status & ATH9K_INT_GENTIMER)
+		ath_gen_timer_isr(sc->sc_ah);
+
 	ath9k_btcoex_handle_interrupt(sc, status);
 
 	/* re-enable hardware interrupt */
-- 
1.8.3.4 (Apple Git-47)

