Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53196 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1JHSGc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 14:06:32 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 1/4] ath9k_hw: make ath9k_hw_set_interrupts use ah->imask by default
Date: Sat,  8 Oct 2011 20:06:19 +0200
Message-Id: <1318097182-78364-1-git-send-email-nbd@openwrt.org> (sfid-20111008_200639_146991_6479E933)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   10 +++++-----
 drivers/net/wireless/ath/ath9k/gpio.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/mac.c    |    6 +++---
 drivers/net/wireless/ath/ath9k/mac.h    |    2 +-
 drivers/net/wireless/ath/ath9k/main.c   |   10 +++++-----
 drivers/net/wireless/ath/ath9k/recv.c   |    2 +-
 6 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 9cdeaeb..a13cabb 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -515,7 +515,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	sc->sc_flags |= SC_OP_TSF_RESET;
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
-	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 }
 
@@ -643,7 +643,7 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	ath9k_hw_set_sta_beacon_timers(ah, &bs);
 	ah->imask |= ATH9K_INT_BMISS;
 
-	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 }
 
@@ -679,7 +679,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 
-	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 }
 
@@ -821,11 +821,11 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
 	if (status) {
 		/* Re-enable beaconing */
 		ah->imask |= ATH9K_INT_SWBA;
-		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_set_interrupts(ah);
 	} else {
 		/* Disable SWBA interrupt */
 		ah->imask &= ~ATH9K_INT_SWBA;
-		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_set_interrupts(ah);
 		tasklet_kill(&sc->bcon_tasklet);
 		ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index fd0f84e..61eee8c 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -155,7 +155,7 @@ static void ath9k_gen_timer_start(struct ath_hw *ah,
 	if ((ah->imask & ATH9K_INT_GENTIMER) == 0) {
 		ath9k_hw_disable_interrupts(ah);
 		ah->imask |= ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_set_interrupts(ah);
 		ath9k_hw_enable_interrupts(ah);
 	}
 }
@@ -170,7 +170,7 @@ static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 	if (timer_table->timer_mask.val == 0) {
 		ath9k_hw_disable_interrupts(ah);
 		ah->imask &= ~ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_set_interrupts(ah);
 		ath9k_hw_enable_interrupts(ah);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 22f23ea..835e81d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -827,9 +827,9 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_enable_interrupts);
 
-void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
+void ath9k_hw_set_interrupts(struct ath_hw *ah)
 {
-	enum ath9k_int omask = ah->imask;
+	enum ath9k_int ints = ah->imask;
 	u32 mask, mask2;
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -837,7 +837,7 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	if (!(ints & ATH9K_INT_GLOBAL))
 		ath9k_hw_disable_interrupts(ah);
 
-	ath_dbg(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
+	ath_dbg(common, ATH_DBG_INTERRUPT, "New interrupt mask 0x%x\n", ints);
 
 	mask = ints & ATH9K_INT_COMMON;
 	mask2 = 0;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 91c9654..c7cec9c 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -734,7 +734,7 @@ int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
 /* Interrupt Handling */
 bool ath9k_hw_intrpend(struct ath_hw *ah);
-void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
+void ath9k_hw_set_interrupts(struct ath_hw *ah);
 void ath9k_hw_enable_interrupts(struct ath_hw *ah);
 void ath9k_hw_disable_interrupts(struct ath_hw *ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9883186..4b2d304 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -273,7 +273,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
 			       sc->config.txpowlimit, &sc->curtxpow);
-	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_set_interrupts(ah);
 	ath9k_hw_enable_interrupts(ah);
 
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL)) && start) {
@@ -823,7 +823,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 	if (status & ATH9K_INT_RXEOL) {
 		ah->imask &= ~(ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
-		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_set_interrupts(ah);
 	}
 
 	if (status & ATH9K_INT_MIB) {
@@ -1396,7 +1396,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 		ah->imask &= ~ATH9K_INT_TSFOOR;
 	}
 
-	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_set_interrupts(ah);
 
 	/* Set up ANI */
 	if (iter_data.naps > 0) {
@@ -1571,7 +1571,7 @@ static void ath9k_enable_ps(struct ath_softc *sc)
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 		if ((ah->imask & ATH9K_INT_TIM_TIMER) == 0) {
 			ah->imask |= ATH9K_INT_TIM_TIMER;
-			ath9k_hw_set_interrupts(ah, ah->imask);
+			ath9k_hw_set_interrupts(ah);
 		}
 		ath9k_hw_setrxabort(ah, 1);
 	}
@@ -1591,7 +1591,7 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 				  PS_WAIT_FOR_TX_ACK);
 		if (ah->imask & ATH9K_INT_TIM_TIMER) {
 			ah->imask &= ~ATH9K_INT_TIM_TIMER;
-			ath9k_hw_set_interrupts(ah, ah->imask);
+			ath9k_hw_set_interrupts(ah);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f658ec6..6449b6f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1973,7 +1973,7 @@ requeue:
 
 	if (!(ah->imask & ATH9K_INT_RXEOL)) {
 		ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
-		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_set_interrupts(ah);
 	}
 
 	return 0;
-- 
1.7.3.2

