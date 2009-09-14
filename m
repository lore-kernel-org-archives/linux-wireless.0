Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52496 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbZINIhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:37:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 02/11] ath9k: separate core driver and hw timer code
Date: Mon, 14 Sep 2009 04:37:19 -0400
Message-Id: <1252917448-10744-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
References: <1252917448-10744-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   |   22 +++------------
 drivers/net/wireless/ath/ath9k/hw.h   |    9 ++++--
 drivers/net/wireless/ath/ath9k/main.c |   44 +++++++++++++++++++++++++++------
 3 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1f4e747..0fe8644 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -4096,9 +4096,10 @@ struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 	return timer;
 }
 
-void ath_gen_timer_start(struct ath_hw *ah,
-			 struct ath_gen_timer *timer,
-			 u32 timer_next, u32 timer_period)
+void ath9k_hw_gen_timer_start(struct ath_hw *ah,
+			      struct ath_gen_timer *timer,
+			      u32 timer_next,
+			      u32 timer_period)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 	u32 tsf;
@@ -4133,15 +4134,9 @@ void ath_gen_timer_start(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_IMR_S5,
 		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
 		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
-
-	if ((ah->ah_sc->imask & ATH9K_INT_GENTIMER) == 0) {
-		ath9k_hw_set_interrupts(ah, 0);
-		ah->ah_sc->imask |= ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
-	}
 }
 
-void ath_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
+void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 
@@ -4160,13 +4155,6 @@ void ath_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
 
 	clear_bit(timer->index, &timer_table->timer_mask.timer_bits);
-
-	/* if no timer is enabled, turn off interrupt mask */
-	if (timer_table->timer_mask.val == 0) {
-		ath9k_hw_set_interrupts(ah, 0);
-		ah->ah_sc->imask &= ~ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
-	}
 }
 
 void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index eeb55e9..3120c21 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -682,9 +682,12 @@ struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*overflow)(void *),
 					  void *arg,
 					  u8 timer_index);
-void ath_gen_timer_start(struct ath_hw *ah, struct ath_gen_timer *timer,
-			 u32 timer_next, u32 timer_period);
-void ath_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer);
+void ath9k_hw_gen_timer_start(struct ath_hw *ah,
+			      struct ath_gen_timer *timer,
+			      u32 timer_next,
+			      u32 timer_period);
+void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer);
+
 void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_isr(struct ath_hw *hw);
 u32 ath9k_hw_gettsf32(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0884c3e..5cd4b78 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1412,6 +1412,34 @@ static void ath9k_btcoex_bt_stomp(struct ath_softc *sc,
 	ath9k_hw_btcoex_enable(ah);
 }
 
+static void ath9k_gen_timer_start(struct ath_hw *ah,
+				  struct ath_gen_timer *timer,
+				  u32 timer_next,
+				  u32 timer_period)
+{
+	ath9k_hw_gen_timer_start(ah, timer, timer_next, timer_period);
+
+	if ((ah->ah_sc->imask & ATH9K_INT_GENTIMER) == 0) {
+		ath9k_hw_set_interrupts(ah, 0);
+		ah->ah_sc->imask |= ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
+	}
+}
+
+static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
+{
+	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
+
+	ath9k_hw_gen_timer_stop(ah, timer);
+
+	/* if no timer is enabled, turn off interrupt mask */
+	if (timer_table->timer_mask.val == 0) {
+		ath9k_hw_set_interrupts(ah, 0);
+		ah->ah_sc->imask &= ~ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
+	}
+}
+
 /*
  * This is the master bt coex timer which runs for every
  * 45ms, bt traffic will be given priority during 55% of this
@@ -1433,13 +1461,13 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 	if (btcoex->btcoex_period != btcoex->btcoex_no_stomp) {
 		if (btcoex->hw_timer_enabled)
-			ath_gen_timer_stop(ah, btcoex->no_stomp_timer);
+			ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
 
-		ath_gen_timer_start(ah,
-			btcoex->no_stomp_timer,
-			(ath9k_hw_gettsf32(ah) +
-				btcoex->btcoex_no_stomp),
-				btcoex->btcoex_no_stomp * 10);
+		ath9k_gen_timer_start(ah,
+				      btcoex->no_stomp_timer,
+				      (ath9k_hw_gettsf32(ah) +
+				       btcoex->btcoex_no_stomp),
+				       btcoex->btcoex_no_stomp * 10);
 		btcoex->hw_timer_enabled = true;
 	}
 
@@ -2169,7 +2197,7 @@ static void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 
 	/* make sure duty cycle timer is also stopped when resuming */
 	if (btcoex->hw_timer_enabled)
-		ath_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
+		ath9k_gen_timer_stop(sc->sc_ah, btcoex->no_stomp_timer);
 
 	btcoex->bt_priority_cnt = 0;
 	btcoex->bt_priority_time = jiffies;
@@ -2411,7 +2439,7 @@ static void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 	del_timer_sync(&btcoex->period_timer);
 
 	if (btcoex->hw_timer_enabled)
-		ath_gen_timer_stop(ah, btcoex->no_stomp_timer);
+		ath9k_gen_timer_stop(ah, btcoex->no_stomp_timer);
 
 	btcoex->hw_timer_enabled = false;
 }
-- 
1.6.3.3

