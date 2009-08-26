Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45805 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbZHZPrR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 11:47:17 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 08:47:20 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 7/8] ath9k: Add infrastructure for generic hw timers
Date: Wed, 26 Aug 2009 21:08:49 +0530
Message-ID: <1251301130-10912-8-git-send-email-vasanth@atheros.com>
In-Reply-To: <1251301130-10912-7-git-send-email-vasanth@atheros.com>
References: <1251301130-10912-1-git-send-email-vasanth@atheros.com>
 <1251301130-10912-2-git-send-email-vasanth@atheros.com>
 <1251301130-10912-3-git-send-email-vasanth@atheros.com>
 <1251301130-10912-4-git-send-email-vasanth@atheros.com>
 <1251301130-10912-5-git-send-email-vasanth@atheros.com>
 <1251301130-10912-6-git-send-email-vasanth@atheros.com>
 <1251301130-10912-7-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c    |  212 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h    |   52 ++++++++
 drivers/net/wireless/ath/ath9k/reg.h   |   15 ++-
 4 files changed, 278 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 5e56b79..ea0dd1e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -30,6 +30,7 @@ enum ATH_DEBUG {
 	ATH_DBG_CONFIG		= 0x00000200,
 	ATH_DBG_FATAL		= 0x00000400,
 	ATH_DBG_PS		= 0x00000800,
+	ATH_DBG_HWTIMER		= 0x00001000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c80be8c..3afd7a9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3215,6 +3215,23 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 	if (AR_SREV_9100(ah))
 		return true;
 
+	if (isr & AR_ISR_GENTMR) {
+		u32 s5_s;
+
+		s5_s = REG_READ(ah, AR_ISR_S5_S);
+		if (isr & AR_ISR_GENTMR) {
+			ah->intr_gen_timer_trigger =
+				MS(s5_s, AR_ISR_S5_GENTIMER_TRIG);
+
+			ah->intr_gen_timer_thresh =
+				MS(s5_s, AR_ISR_S5_GENTIMER_THRESH);
+
+			if (ah->intr_gen_timer_trigger)
+				*masked |= ATH9K_INT_GENTIMER;
+
+		}
+	}
+
 	if (sync_cause) {
 		fatal_int =
 			(sync_cause &
@@ -4078,3 +4095,198 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah, enum ath9k_ht_macmode mode)
 
 	REG_WRITE(ah, AR_2040_MODE, macmode);
 }
+
+/* HW Generic timers configuration */
+
+static const struct ath_gen_timer_configuration gen_tmr_configuration[] =
+{
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP_TIMER, AR_NDP_PERIOD, AR_TIMER_MODE, 0x0080},
+	{AR_NEXT_NDP2_TIMER, AR_NDP2_PERIOD, AR_NDP2_TIMER_MODE, 0x0001},
+	{AR_NEXT_NDP2_TIMER + 1*4, AR_NDP2_PERIOD + 1*4,
+				AR_NDP2_TIMER_MODE, 0x0002},
+	{AR_NEXT_NDP2_TIMER + 2*4, AR_NDP2_PERIOD + 2*4,
+				AR_NDP2_TIMER_MODE, 0x0004},
+	{AR_NEXT_NDP2_TIMER + 3*4, AR_NDP2_PERIOD + 3*4,
+				AR_NDP2_TIMER_MODE, 0x0008},
+	{AR_NEXT_NDP2_TIMER + 4*4, AR_NDP2_PERIOD + 4*4,
+				AR_NDP2_TIMER_MODE, 0x0010},
+	{AR_NEXT_NDP2_TIMER + 5*4, AR_NDP2_PERIOD + 5*4,
+				AR_NDP2_TIMER_MODE, 0x0020},
+	{AR_NEXT_NDP2_TIMER + 6*4, AR_NDP2_PERIOD + 6*4,
+				AR_NDP2_TIMER_MODE, 0x0040},
+	{AR_NEXT_NDP2_TIMER + 7*4, AR_NDP2_PERIOD + 7*4,
+				AR_NDP2_TIMER_MODE, 0x0080}
+};
+
+/* HW generic timer primitives */
+
+/* compute and clear index of rightmost 1 */
+static u32 rightmost_index(struct ath_gen_timer_table *timer_table, u32 *mask)
+{
+	u32 b;
+
+	b = *mask;
+	b &= (0-b);
+	*mask &= ~b;
+	b *= debruijn32;
+	b >>= 27;
+
+	return timer_table->gen_timer_index[b];
+}
+
+static u32 ath9k_hw_gettsf32(struct ath_hw *ah)
+{
+	return REG_READ(ah, AR_TSF_L32);
+}
+
+struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
+					  void (*trigger)(void *),
+					  void (*overflow)(void *),
+					  void *arg,
+					  u8 timer_index)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+	struct ath_gen_timer *timer;
+
+	timer = kzalloc(sizeof(struct ath_gen_timer), GFP_KERNEL);
+
+	if (timer == NULL) {
+		printk(KERN_DEBUG "Failed to allocate memory"
+		       "for hw timer[%d]\n", timer_index);
+		return NULL;
+	}
+
+	/* allocate a hardware generic timer slot */
+	timer_table->timers[timer_index] = timer;
+	timer->index = timer_index;
+	timer->trigger = trigger;
+	timer->overflow = overflow;
+	timer->arg = arg;
+
+	return timer;
+}
+
+void ath_gen_timer_start(struct ath_hw *ah,
+			 struct ath_gen_timer *timer,
+			 u32 timer_next, u32 timer_period)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+	u32 tsf;
+
+	BUG_ON(!timer_period);
+
+	set_bit(timer->index, &timer_table->timer_mask.timer_bits);
+
+	tsf = ath9k_hw_gettsf32(ah);
+
+	DPRINTF(ah->ah_sc, ATH_DBG_HWTIMER, "curent tsf %x period %x"
+		"timer_next %x\n", tsf, timer_period, timer_next);
+
+	/*
+	 * Pull timer_next forward if the current TSF already passed it
+	 * because of software latency
+	 */
+	if (timer_next < tsf)
+		timer_next = tsf + timer_period;
+
+	/*
+	 * Program generic timer registers
+	 */
+	REG_WRITE(ah, gen_tmr_configuration[timer->index].next_addr,
+		 timer_next);
+	REG_WRITE(ah, gen_tmr_configuration[timer->index].period_addr,
+		  timer_period);
+	REG_SET_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
+		    gen_tmr_configuration[timer->index].mode_mask);
+
+	/* Enable both trigger and thresh interrupt masks */
+	REG_SET_BIT(ah, AR_IMR_S5,
+		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
+		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
+
+	if ((ah->ah_sc->imask & ATH9K_INT_GENTIMER) == 0) {
+		ath9k_hw_set_interrupts(ah, 0);
+		ah->ah_sc->imask |= ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
+	}
+}
+
+void ath_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+
+	if ((timer->index < AR_FIRST_NDP_TIMER) ||
+		(timer->index >= ATH_MAX_GEN_TIMER)) {
+		return;
+	}
+
+	/* Clear generic timer enable bits. */
+	REG_CLR_BIT(ah, gen_tmr_configuration[timer->index].mode_addr,
+			gen_tmr_configuration[timer->index].mode_mask);
+
+	/* Disable both trigger and thresh interrupt masks */
+	REG_CLR_BIT(ah, AR_IMR_S5,
+		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
+		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
+
+	clear_bit(timer->index, &timer_table->timer_mask.timer_bits);
+
+	/* if no timer is enabled, turn off interrupt mask */
+	if (timer_table->timer_mask.val == 0) {
+		ath9k_hw_set_interrupts(ah, 0);
+		ah->ah_sc->imask &= ~ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
+	}
+}
+
+void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+
+	/* free the hardware generic timer slot */
+	timer_table->timers[timer->index] = NULL;
+	kfree(timer);
+}
+
+/*
+ * Generic Timer Interrupts handling
+ */
+void ath_gen_timer_isr(struct ath_hw *ah)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+	struct ath_gen_timer *timer;
+	u32 trigger_mask, thresh_mask, index;
+
+	/* get hardware generic timer interrupt status */
+	trigger_mask = ah->intr_gen_timer_trigger;
+	thresh_mask = ah->intr_gen_timer_thresh;
+	trigger_mask &= timer_table->timer_mask.val;
+	thresh_mask &= timer_table->timer_mask.val;
+
+	trigger_mask &= ~thresh_mask;
+
+	while (thresh_mask) {
+		index = rightmost_index(timer_table, &thresh_mask);
+		timer = timer_table->timers[index];
+		BUG_ON(!timer);
+		DPRINTF(ah->ah_sc, ATH_DBG_HWTIMER,
+			"TSF overflow for Gen timer %d\n", index);
+		timer->overflow(timer->arg);
+	}
+
+	while (trigger_mask) {
+		index = rightmost_index(timer_table, &trigger_mask);
+		timer = timer_table->timers[index];
+		BUG_ON(!timer);
+		DPRINTF(ah->ah_sc, ATH_DBG_HWTIMER,
+			"Gen timer[%d] trigger\n", index);
+		timer->trigger(timer->arg);
+	}
+}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index de10de8..052a9c4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -237,6 +237,7 @@ enum ath9k_int {
 	ATH9K_INT_GPIO = 0x01000000,
 	ATH9K_INT_CABEND = 0x02000000,
 	ATH9K_INT_TSFOOR = 0x04000000,
+	ATH9K_INT_GENTIMER = 0x08000000,
 	ATH9K_INT_CST = 0x10000000,
 	ATH9K_INT_GTT = 0x20000000,
 	ATH9K_INT_FATAL = 0x40000000,
@@ -390,6 +391,41 @@ struct ath9k_hw_version {
 	u16 analog2GhzRev;
 };
 
+/* Generic TSF timer definitions */
+
+#define ATH_MAX_GEN_TIMER	16
+
+#define AR_GENTMR_BIT(_index)	(1 << (_index))
+
+/*
+ * Using de Bruijin sequence to to look up 1's index in a 32 bit number
+ * debruijn32 = 0000 0111 0111 1100 1011 0101 0011 0001
+ */
+#define debruijn32 0x077CB531UL
+
+struct ath_gen_timer_configuration {
+	u32 next_addr;
+	u32 period_addr;
+	u32 mode_addr;
+	u32 mode_mask;
+};
+
+struct ath_gen_timer {
+	void (*trigger)(void *arg);
+	void (*overflow)(void *arg);
+	void *arg;
+	u8 index;
+};
+
+struct ath_gen_timer_table {
+	u32 gen_timer_index[32];
+	struct ath_gen_timer *timers[ATH_MAX_GEN_TIMER];
+	union {
+		unsigned long timer_bits;
+		u16 val;
+	} timer_mask;
+};
+
 struct ath_hw {
 	struct ath_softc *ah_sc;
 	struct ath9k_hw_version hw_version;
@@ -536,6 +572,10 @@ struct ath_hw {
 	struct ar5416IniArray iniModesAdditional;
 	struct ar5416IniArray iniModesRxGain;
 	struct ar5416IniArray iniModesTxGain;
+
+	u32 intr_gen_timer_trigger;
+	u32 intr_gen_timer_thresh;
+	struct ath_gen_timer_table hw_gen_timers;
 };
 
 /* Initialization, Detach, Reset */
@@ -611,4 +651,16 @@ bool ath9k_hw_intrpend(struct ath_hw *ah);
 bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked);
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
 
+/* Generic hw timer primitives */
+struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
+					  void (*trigger)(void *),
+					  void (*overflow)(void *),
+					  void *arg,
+					  u8 timer_index);
+void ath_gen_timer_start(struct ath_hw *ah, struct ath_gen_timer *timer,
+			 u32 timer_next, u32 timer_period);
+void ath_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer);
+void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
+void ath_gen_timer_isr(struct ath_hw *hw);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index c9e1ac9..1d8e0a8 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -234,7 +234,15 @@
 #define AR_IMR_S5                   0x00b8
 #define AR_IMR_S5_TIM_TIMER         0x00000010
 #define AR_IMR_S5_DTIM_TIMER        0x00000020
-
+#define AR_ISR_S5_GENTIMER_TRIG     0x0000FF80
+#define AR_ISR_S5_GENTIMER_TRIG_S   0
+#define AR_ISR_S5_GENTIMER_THRESH   0xFF800000
+#define AR_ISR_S5_GENTIMER_THRESH_S 16
+#define AR_ISR_S5_S                 0x00d8
+#define AR_IMR_S5_GENTIMER_TRIG     0x0000FF80
+#define AR_IMR_S5_GENTIMER_TRIG_S   0
+#define AR_IMR_S5_GENTIMER_THRESH   0xFF800000
+#define AR_IMR_S5_GENTIMER_THRESH_S 16
 
 #define AR_IMR               0x00a0
 #define AR_IMR_RXOK          0x00000001
@@ -1516,7 +1524,10 @@ enum {
 #define AR_TXOP_8_11   0x81f8
 #define AR_TXOP_12_15  0x81fc
 
-
+#define AR_NEXT_NDP2_TIMER                  0x8180
+#define AR_FIRST_NDP_TIMER                  7
+#define AR_NDP2_PERIOD                      0x81a0
+#define AR_NDP2_TIMER_MODE                  0x81c0
 #define AR_NEXT_TBTT_TIMER                  0x8200
 #define AR_NEXT_DMA_BEACON_ALERT            0x8204
 #define AR_NEXT_SWBA                        0x8208
-- 
1.5.5.1

