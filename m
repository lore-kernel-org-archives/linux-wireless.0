Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1146 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1HEN3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 09:29:30 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/3] ath9k: Use atomic reference count for interrupt ops
Date: Fri, 5 Aug 2011 18:59:41 +0530
Message-ID: <1312550982-21914-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110805_152933_766436_AD4DDCF9)
In-Reply-To: <1312550982-21914-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1312550982-21914-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let us enable/disable interrupts based on reference count.
By doing this we can ensure that interrupts are never be
enabled in the middle of tasklet processing. Instead of
addressing corner cases like "ath9k: avoid enabling interrupts
while processing rx", this approach handles it in generic manner.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/beacon.c |   21 +++++----------------
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 drivers/net/wireless/ath/ath9k/init.c   |    1 +
 drivers/net/wireless/ath/ath9k/mac.c    |   13 ++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c   |    4 ++--
 drivers/net/wireless/ath/ath9k/recv.c   |    1 -
 7 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8ac356c..d4286ba 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -566,7 +566,6 @@ struct ath_ant_comb {
 #define PS_WAIT_FOR_PSPOLL_DATA   BIT(2)
 #define PS_WAIT_FOR_TX_ACK        BIT(3)
 #define PS_BEACON_SYNC            BIT(4)
-#define PS_TSFOOR_SYNC            BIT(5)
 
 struct ath_rate_table;
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 72d3b6b..97e0837 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -648,14 +648,8 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	ath9k_hw_set_sta_beacon_timers(ah, &bs);
 	ah->imask |= ATH9K_INT_BMISS;
 
-	/*
-	 * If the beacon config is called beacause of TSFOOR,
-	 * Interrupts will be enabled back at the end of ath9k_tasklet
-	 */
-	if (!(sc->ps_flags & PS_TSFOOR_SYNC)) {
-		ath9k_hw_set_interrupts(ah, ah->imask);
-		ath9k_hw_enable_interrupts(ah);
-	}
+	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 }
 
 static void ath_beacon_config_adhoc(struct ath_softc *sc,
@@ -689,14 +683,9 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	ath9k_hw_disable_interrupts(ah);
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
-	/*
-	 * If the beacon config is called beacause of TSFOOR,
-	 * Interrupts will be enabled back at the end of ath9k_tasklet
-	 */
-	if (!(sc->ps_flags & PS_TSFOOR_SYNC)) {
-		ath9k_hw_set_interrupts(ah, ah->imask);
-		ath9k_hw_enable_interrupts(ah);
-	}
+
+	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 }
 
 static bool ath9k_allow_beacon_config(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f413937..d1ca98a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -709,6 +709,7 @@ struct ath_hw {
 	u32 txdesc_interrupt_mask;
 	u32 txeol_interrupt_mask;
 	u32 txurn_interrupt_mask;
+	atomic_t intr_ref_cnt;
 	bool chip_fullsleep;
 	u32 atim_window;
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2e96346..f01a7c8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -566,6 +566,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ah->reg_ops.read = ath9k_ioread32;
 	ah->reg_ops.write = ath9k_iowrite32;
 	ah->reg_ops.rmw = ath9k_reg_rmw;
+	atomic_set(&ah->intr_ref_cnt, -1);
 	sc->sc_ah = ah;
 
 	if (!pdata) {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c3af61e..0f90e15 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -800,6 +800,11 @@ void ath9k_hw_disable_interrupts(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	if (!(ah->imask & ATH9K_INT_GLOBAL))
+		atomic_set(&ah->intr_ref_cnt, -1);
+	else
+		atomic_dec(&ah->intr_ref_cnt);
+
 	ath_dbg(common, ATH_DBG_INTERRUPT, "disable IER\n");
 	REG_WRITE(ah, AR_IER, AR_IER_DISABLE);
 	(void) REG_READ(ah, AR_IER);
@@ -821,6 +826,13 @@ void ath9k_hw_enable_interrupts(struct ath_hw *ah)
 	if (!(ah->imask & ATH9K_INT_GLOBAL))
 		return;
 
+	if (!atomic_inc_and_test(&ah->intr_ref_cnt)) {
+		ath_dbg(common, ATH_DBG_INTERRUPT,
+			"Do not enable IER ref count %d\n",
+			atomic_read(&ah->intr_ref_cnt));
+		return;
+	}
+
 	if (AR_SREV_9340(ah))
 		sync_default &= ~AR_INTR_SYNC_HOST1_FATAL;
 
@@ -852,7 +864,6 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 
 	ath_dbg(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
-	/* TODO: global int Ref count */
 	mask = ints & ATH9K_INT_COMMON;
 	mask2 = 0;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 72b7b0d..28ccb61 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -707,8 +707,7 @@ void ath9k_tasklet(unsigned long data)
 		 */
 		ath_dbg(common, ATH_DBG_PS,
 			"TSFOOR - Sync with next Beacon\n");
-		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC |
-				PS_TSFOOR_SYNC;
+		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC;
 	}
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
@@ -887,6 +886,7 @@ static void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
+	atomic_set(&ah->intr_ref_cnt, -1);
 
 	ath9k_hw_configpcipowersave(ah, 0, 0);
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d32e82f..7e4e605 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -600,7 +600,6 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		ath_dbg(common, ATH_DBG_PS,
 			"Reconfigure Beacon timers based on timestamp from the AP\n");
 		ath_set_beacon(sc);
-		sc->ps_flags &= ~PS_TSFOOR_SYNC;
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
1.7.6

