Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52893 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab1DUNDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 09:03:16 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 06:02:49 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] ath9k: Fix bug in configuring hw timer
Date: Thu, 21 Apr 2011 18:33:27 +0530
Message-ID: <1303391008-4794-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hw next tigger time is configured as current_tsf + (timer_period * 10) which
is wrong, it should be current_tsf + timer_period. The wrong hw timer configuration
would cause btcoex related issues.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c |    6 +++---
 drivers/net/wireless/ath/ath9k/hw.c   |   13 ++++---------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 44a0a88..cc5fad6 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -138,10 +138,10 @@ static void ath_detect_bt_priority(struct ath_softc *sc)
 
 static void ath9k_gen_timer_start(struct ath_hw *ah,
 				  struct ath_gen_timer *timer,
-				  u32 timer_next,
+				  u32 trig_timeout,
 				  u32 timer_period)
 {
-	ath9k_hw_gen_timer_start(ah, timer, timer_next, timer_period);
+	ath9k_hw_gen_timer_start(ah, timer, trig_timeout, timer_period);
 
 	if ((ah->imask & ATH9K_INT_GENTIMER) == 0) {
 		ath9k_hw_disable_interrupts(ah);
@@ -195,7 +195,7 @@ static void ath_btcoex_period_timer(unsigned long data)
 
 		timer_period = is_btscan ? btcoex->btscan_no_stomp :
 					   btcoex->btcoex_no_stomp;
-		ath9k_gen_timer_start(ah, btcoex->no_stomp_timer, 0,
+		ath9k_gen_timer_start(ah, btcoex->no_stomp_timer, timer_period,
 				      timer_period * 10);
 		btcoex->hw_timer_enabled = true;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 9a89855..3e1b85e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2423,11 +2423,11 @@ EXPORT_SYMBOL(ath_gen_timer_alloc);
 
 void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 			      struct ath_gen_timer *timer,
-			      u32 timer_next,
+			      u32 trig_timeout,
 			      u32 timer_period)
 {
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
-	u32 tsf;
+	u32 tsf, timer_next;
 
 	BUG_ON(!timer_period);
 
@@ -2435,18 +2435,13 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 
 	tsf = ath9k_hw_gettsf32(ah);
 
+	timer_next = tsf + trig_timeout;
+
 	ath_dbg(ath9k_hw_common(ah), ATH_DBG_HWTIMER,
 		"current tsf %x period %x timer_next %x\n",
 		tsf, timer_period, timer_next);
 
 	/*
-	 * Pull timer_next forward if the current TSF already passed it
-	 * because of software latency
-	 */
-	if (timer_next < tsf)
-		timer_next = tsf + timer_period;
-
-	/*
 	 * Program generic timer registers
 	 */
 	REG_WRITE(ah, gen_tmr_configuration[timer->index].next_addr,
-- 
1.7.0.4

