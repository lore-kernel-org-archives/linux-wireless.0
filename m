Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64203 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab0JZIkw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 04:40:52 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 01:40:41 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <greearb@candelatech.com>, <kyungwan.nam@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT 2/3] ath9k: move the PCU lock to the sc structure
Date: Tue, 26 Oct 2010 01:40:40 -0700
Message-ID: <1288082441-4882-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com>
References: <1288082441-4882-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCU lock should be used to contend TX DMA as well,
this will be done next.

Cc: Ben Greear <greearb@candelatech.com>
Cc: Kyungwan Nam <kyungwan.nam@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |   42 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |    4 +-
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1b64a30..622f42e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -310,7 +310,6 @@ struct ath_rx {
 	u8 rxotherant;
 	u32 *rxlink;
 	unsigned int rxfilter;
-	spinlock_t pcu_lock;
 	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
@@ -602,6 +601,7 @@ struct ath_softc {
 	int irq;
 	spinlock_t sc_serial_rw;
 	spinlock_t sc_pm_lock;
+	spinlock_t sc_pcu_lock;
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct work_struct hw_check_work;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5e036af..4196336 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -242,7 +242,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, false);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 
 	stopped = ath_stoprecv(sc);
 
@@ -268,7 +268,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 			  "Unable to reset channel (%u MHz), "
 			  "reset status %d\n",
 			  channel->center_freq, r);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto ps_restore;
 	}
 
@@ -276,11 +276,11 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
 		r = -EIO;
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto ps_restore;
 	}
 
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, ah->imask);
@@ -616,7 +616,7 @@ void ath9k_tasklet(unsigned long data)
 		rxmask = (ATH9K_INT_RX | ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
 
 	if (status & rxmask) {
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 
 		/* Check for high priority Rx first */
 		if ((ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
@@ -624,7 +624,7 @@ void ath9k_tasklet(unsigned long data)
 			ath_rx_tasklet(sc, 0, true);
 
 		ath_rx_tasklet(sc, 0, false);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	if (status & ATH9K_INT_TX) {
@@ -879,7 +879,7 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (!ah->curchan)
 		ah->curchan = ath_get_curchannel(sc, sc->hw);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 	r = ath9k_hw_reset(ah, ah->curchan, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
@@ -892,10 +892,10 @@ void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		return;
 	}
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	if (sc->sc_flags & SC_OP_BEACONS)
 		ath_beacon_config(sc, NULL);	/* restart beacons */
@@ -935,7 +935,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	ath_drain_all_txq(sc, false);	/* clear pending tx frames */
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ath_stoprecv(sc);		/* turn off frame recv */
 	ath_flushrecv(sc);		/* flush recv queue */
@@ -953,7 +953,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	ath9k_hw_phy_disable(ah);
 
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	ath9k_hw_configpcipowersave(ah, 1, 1);
 	ath9k_ps_restore(sc);
@@ -975,7 +975,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	ath9k_hw_set_interrupts(ah, 0);
 	ath_drain_all_txq(sc, retry_tx);
 
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ath_stoprecv(sc);
 	ath_flushrecv(sc);
@@ -989,7 +989,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	/*
 	 * We may be doing a reset in response to a request
@@ -1153,14 +1153,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	spin_lock_bh(&sc->rx.pcu_lock);
+	spin_lock_bh(&sc->sc_pcu_lock);
 	r = ath9k_hw_reset(ah, init_channel, ah->caldata, false);
 	if (r) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to reset hardware; reset status %d "
 			  "(freq %u MHz)\n", r,
 			  curchan->center_freq);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto mutex_unlock;
 	}
 
@@ -1181,10 +1181,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to start recv logic\n");
 		r = -EIO;
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 		goto mutex_unlock;
 	}
-	spin_unlock_bh(&sc->rx.pcu_lock);
+	spin_unlock_bh(&sc->sc_pcu_lock);
 
 	/* Setup our intr mask. */
 	ah->imask = ATH9K_INT_TX | ATH9K_INT_RXEOL |
@@ -1385,14 +1385,14 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	if (!(sc->sc_flags & SC_OP_INVALID)) {
 		ath_drain_all_txq(sc, false);
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 		ath_stoprecv(sc);
 		ath9k_hw_phy_disable(ah);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	} else {
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 		sc->rx.rxlink = NULL;
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	/* disable HAL and put h/w to sleep */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 26ac6d8..0821664 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -317,7 +317,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	struct ath_buf *bf;
 	int error = 0;
 
-	spin_lock_init(&sc->rx.pcu_lock);
+	spin_lock_init(&sc->sc_pcu_lock);
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_lock_init(&sc->rx.rxbuflock);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6c0de85..81f63e52 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1148,13 +1148,13 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		ath_print(common, ATH_DBG_FATAL,
 			  "Failed to stop TX DMA. Resetting hardware!\n");
 
-		spin_lock_bh(&sc->rx.pcu_lock);
+		spin_lock_bh(&sc->sc_pcu_lock);
 		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, ah->caldata, false);
 		if (r)
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to reset hardware; reset status %d\n",
 				  r);
-		spin_unlock_bh(&sc->rx.pcu_lock);
+		spin_unlock_bh(&sc->sc_pcu_lock);
 	}
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-- 
1.7.3.2.90.gd4c43

