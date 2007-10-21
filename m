Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:52183 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbXJUCHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 22:07:24 -0400
Date: Sun, 21 Oct 2007 02:07:24 +0000
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
Subject: [PATCH 2/2] ath5k: Rename some functions
Message-ID: <20071021020724.GC5817@localhost.domain.invalid> (sfid-20071021_030730_753932_86BDC5FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've renamed some functions for better maintainability...

ath5k_mode_init -> ath5k_mode_setup
ath5k_rxbuf_init -> ath5k_rxbuf_setup
Because it's not just initialization + we use
"setup" on the rest of the code (eg. beacon_setup).

ath5k_tx_bf -> ath5k_txbuf_setup
Obvious

ath5k_cleanup_txbuf -> ath5k_txbuf_free
Previous name is misleading because someone might
think that it cleans all tx buffers, we use "free"
to declare that it only cleans one given buffer.

ath5k_tx_draintxq -> ath5k_txq_drainq
ath5k_draintxq -> ath5k_txq_cleanup
Same here ath5k_draintxq seems to refer to only
one queue when in fact it drains all queues, so
we use "cleanup" as above.

ath5k_tx_cleanup -> ath5k_txq_release
This one doesn't do any cleanup, it just calls 
hw_release for each queue.

ath5k_startrecv -> ath5k_rx_start
ath5k_stoprecv -> ath5k_rx_stop
As above i try to maintain a naming scheme that links
with the sorting i've done. Eg. ath5k_desc for descriptor
related funcions, ath5k_rx/tx for general rx/tx functions,
ath5k_txq for tx queues, ath5k_hw (inside hw.c and rest) for
hw related functions and so on. This helps us track down things
more easily.


Changes-licensed-under: 3-clause-BSD

Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 2098944..538513a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -346,32 +346,32 @@ static int 	ath5k_chan_set(struct ath5k_softc *sc,
 				struct ieee80211_channel *chan);
 static void	ath5k_setcurmode(struct ath5k_softc *sc,
 				unsigned int mode);
-static void	ath5k_mode_init(struct ath5k_softc *sc);
+static void	ath5k_mode_setup(struct ath5k_softc *sc);
 /* Descriptor setup */
 static int	ath5k_desc_alloc(struct ath5k_softc *sc,
 				struct pci_dev *pdev);
 static void	ath5k_desc_free(struct ath5k_softc *sc,
 				struct pci_dev *pdev);
 /* Buffers setup */
-static int 	ath5k_rxbuf_init(struct ath5k_softc *sc,
+static int 	ath5k_rxbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf);
-static int 	ath5k_tx_bf(struct ath5k_softc *sc,
+static int 	ath5k_txbuf_setup(struct ath5k_softc *sc,
 				struct ath5k_buf *bf,
 				struct ieee80211_tx_control *ctl);
-static inline void ath5k_cleanup_txbuf(struct ath5k_softc *sc,
+static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
 				struct ath5k_buf *bf);
 /* Queues setup */
 static struct 	ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
 				int qtype, int subtype);
 static int 	ath5k_beaconq_setup(struct ath5k_hw *ah);
 static int 	ath5k_beaconq_config(struct ath5k_softc *sc);
-static void 	ath5k_tx_draintxq(struct ath5k_softc *sc,
+static void 	ath5k_txq_drainq(struct ath5k_softc *sc,
 				struct ath5k_txq *txq);
-static void 	ath5k_draintxq(struct ath5k_softc *sc);
-static void 	ath5k_tx_cleanup(struct ath5k_softc *sc);
+static void 	ath5k_txq_cleanup(struct ath5k_softc *sc);
+static void 	ath5k_txq_release(struct ath5k_softc *sc);
 /* Rx handling */
-static int 	ath5k_startrecv(struct ath5k_softc *sc);
-static void 	ath5k_stoprecv(struct ath5k_softc *sc);
+static int 	ath5k_rx_start(struct ath5k_softc *sc);
+static void 	ath5k_rx_stop(struct ath5k_softc *sc);
 static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
 					struct ath5k_desc *ds,
 					struct sk_buff *skb);
@@ -797,7 +797,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	return 0;
 err_queues:
-	ath5k_tx_cleanup(sc);
+	ath5k_txq_release(sc);
 err_bhal:
 	ath5k_hw_release_tx_queue(ah, sc->bhalq);
 err_desc:
@@ -826,7 +826,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 */
 	ieee80211_unregister_hw(hw);
 	ath5k_desc_free(sc, pdev);
-	ath5k_tx_cleanup(sc);
+	ath5k_txq_release(sc);
 	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
 
 	/*
@@ -1072,8 +1072,8 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		 * the relevant bits of the h/w.
 		 */
 		ath5k_hw_set_intr(ah, 0);	/* disable interrupts */
-		ath5k_draintxq(sc);		/* clear pending tx frames */
-		ath5k_stoprecv(sc);		/* turn off frame recv */
+		ath5k_txq_cleanup(sc);		/* clear pending tx frames */
+		ath5k_rx_stop(sc);		/* turn off frame recv */
 		ret = ath5k_hw_reset(ah, sc->opmode, chan, true);
 		if (ret) {
 			printk(KERN_ERR "%s: unable to reset channel %u "
@@ -1086,7 +1086,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		/*
 		 * Re-enable rx framework.
 		 */
-		ret = ath5k_startrecv(sc);
+		ret = ath5k_rx_start(sc);
 		if (ret) {
 			printk(KERN_ERR "%s: unable to restart recv logic\n",
 					__func__);
@@ -1174,7 +1174,7 @@ ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
 }
 
 static void 
-ath5k_mode_init(struct ath5k_softc *sc)
+ath5k_mode_setup(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	u32 rfilt;
@@ -1266,11 +1266,11 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 {
 	struct ath5k_buf *bf;
 
-	ath5k_cleanup_txbuf(sc, sc->bbuf);
+	ath5k_txbuf_free(sc, sc->bbuf);
 	list_for_each_entry(bf, &sc->txbuf, list)
-		ath5k_cleanup_txbuf(sc, bf);
+		ath5k_txbuf_free(sc, bf);
 	list_for_each_entry(bf, &sc->rxbuf, list)
-		ath5k_cleanup_txbuf(sc, bf);
+		ath5k_txbuf_free(sc, bf);
 
 	/* Free memory associated with all descriptors */
 	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
@@ -1287,7 +1287,7 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 \***************/
 
 static int
-ath5k_rxbuf_init(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct sk_buff *skb = bf->skb;
@@ -1355,7 +1355,7 @@ ath5k_rxbuf_init(struct ath5k_softc *sc, struct ath5k_buf *bf)
 }
 
 static int
-ath5k_tx_bf(struct ath5k_softc *sc, struct ath5k_buf *bf,
+ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 		struct ieee80211_tx_control *ctl)
 {
 	struct ath5k_hw *ah = sc->ah;
@@ -1413,7 +1413,7 @@ err_unmap:
 }
 
 static inline void
-ath5k_cleanup_txbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
+ath5k_txbuf_free(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	BUG_ON(!bf);
 	if (!bf->skb)
@@ -1530,7 +1530,7 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
 }
 
 static void
-ath5k_tx_draintxq(struct ath5k_softc *sc, struct ath5k_txq *txq)
+ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 {
 	struct ath5k_buf *bf, *bf0;
 
@@ -1545,7 +1545,7 @@ ath5k_tx_draintxq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 			ath5k_printtxbuf(bf, !sc->ah->ah_proc_tx_desc(sc->ah,
 						bf->desc));
 #endif
-		ath5k_cleanup_txbuf(sc, bf);
+		ath5k_txbuf_free(sc, bf);
 
 		spin_lock_bh(&sc->txbuflock);
 		sc->tx_stats.data[txq->qnum].len--;
@@ -1561,7 +1561,7 @@ ath5k_tx_draintxq(struct ath5k_softc *sc, struct ath5k_txq *txq)
  * Drain the transmit queues and reclaim resources.
  */
 static void
-ath5k_draintxq(struct ath5k_softc *sc)
+ath5k_txq_cleanup(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	int i;
@@ -1587,11 +1587,11 @@ ath5k_draintxq(struct ath5k_softc *sc)
 
 	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
 		if (sc->txqs[i].setup)
-			ath5k_tx_draintxq(sc, &sc->txqs[i]);
+			ath5k_txq_drainq(sc, &sc->txqs[i]);
 }
 
 static void
-ath5k_tx_cleanup(struct ath5k_softc *sc)
+ath5k_txq_release(struct ath5k_softc *sc)
 {
 	struct ath5k_txq *txq = sc->txqs;
 	unsigned int i;
@@ -1614,7 +1614,7 @@ ath5k_tx_cleanup(struct ath5k_softc *sc)
  * Enable the receive h/w following a reset.
  */
 static int
-ath5k_startrecv(struct ath5k_softc *sc)
+ath5k_rx_start(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_buf *bf;
@@ -1629,7 +1629,7 @@ ath5k_startrecv(struct ath5k_softc *sc)
 
 	spin_lock_bh(&sc->rxbuflock);
 	list_for_each_entry(bf, &sc->rxbuf, list) {
-		ret = ath5k_rxbuf_init(sc, bf);
+		ret = ath5k_rxbuf_setup(sc, bf);
 		if (ret != 0) {
 			spin_unlock_bh(&sc->rxbuflock);
 			goto err;
@@ -1640,7 +1640,7 @@ ath5k_startrecv(struct ath5k_softc *sc)
 
 	ath5k_hw_put_rx_buf(ah, bf->daddr);
 	ath5k_hw_start_rx(ah);		/* enable recv descriptors */
-	ath5k_mode_init(sc);		/* set filters, etc. */
+	ath5k_mode_setup(sc);		/* set filters, etc. */
 	ath5k_hw_start_rx_pcu(ah);	/* re-enable PCU/DMA engine */
 
 	return 0;
@@ -1652,7 +1652,7 @@ err:
  * Disable the receive h/w in preparation for a reset.
  */
 static void
-ath5k_stoprecv(struct ath5k_softc *sc)
+ath5k_rx_stop(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 
@@ -1829,7 +1829,7 @@ accept:
 		ath5k_led_event(sc, ATH_LED_RX);
 next:
 		list_move_tail(&bf->list, &sc->rxbuf);
-	} while (ath5k_rxbuf_init(sc, bf) == 0);
+	} while (ath5k_rxbuf_setup(sc, bf) == 0);
 	spin_unlock(&sc->rxbuflock);
 }
 
@@ -2190,7 +2190,7 @@ ath5k_init(struct ath5k_softc *sc)
 	 * in the frame output path; there's nothing to do
 	 * here except setup the interrupt mask.
 	 */
-	ret = ath5k_startrecv(sc);
+	ret = ath5k_rx_start(sc);
 	if (ret)
 		goto done;
 
@@ -2244,9 +2244,9 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 		}
 		ath5k_hw_set_intr(ah, 0);
 	}
-	ath5k_draintxq(sc);
+	ath5k_txq_cleanup(sc);
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
-		ath5k_stoprecv(sc);
+		ath5k_rx_stop(sc);
 		ath5k_hw_phy_disable(ah);
 	} else
 		sc->rxlink = NULL;
@@ -2291,7 +2291,7 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 			ath5k_hw_set_power(sc->ah, AR5K_PM_FULL_SLEEP, true, 0);
 		}
 	}
-	ath5k_cleanup_txbuf(sc, sc->bbuf);
+	ath5k_txbuf_free(sc, sc->bbuf);
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
@@ -2528,7 +2528,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	bf->skb = skb;
 
-	if (ath5k_tx_bf(sc, bf, ctl)) {
+	if (ath5k_txbuf_setup(sc, bf, ctl)) {
 		bf->skb = NULL;
 		spin_lock_irqsave(&sc->txbuflock, flags);
 		list_add_tail(&bf->list, &sc->txbuf);
@@ -2556,8 +2556,8 @@ ath5k_reset(struct ieee80211_hw *hw)
 	sc->curchan = hw->conf.chan;
 
 	ath5k_hw_set_intr(ah, 0);
-	ath5k_draintxq(sc);
-	ath5k_stoprecv(sc);
+	ath5k_txq_cleanup(sc);
+	ath5k_rx_stop(sc);
 
 	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
 	if (unlikely(ret)) {
@@ -2566,7 +2566,7 @@ ath5k_reset(struct ieee80211_hw *hw)
 	}
 	ath5k_update_txpow(sc);
 
-	ret = ath5k_startrecv(sc);
+	ret = ath5k_rx_start(sc);
 	if (unlikely(ret)) {
 		printk(KERN_ERR "ath: can't start recv logic\n");
 		goto err;
@@ -2911,7 +2911,7 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 		goto end;
 	}
 
-	ath5k_cleanup_txbuf(sc, sc->bbuf);
+	ath5k_txbuf_free(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(sc, sc->bbuf, ctl);
 	if (ret)


