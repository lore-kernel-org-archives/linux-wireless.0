Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63184 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab0KWSvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 13:51:02 -0500
Received: by ewy5 with SMTP id 5so2642573ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 10:51:01 -0800 (PST)
Date: Tue, 23 Nov 2010 20:45:38 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 04/30] ath5k: Use new dma_stop function on base.c
Message-ID: <20101123184538.GD4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Since we stop rx/tx dma and pcu durring reset there is no need to
 call ath5k_hw_stop_rx/tx_dma before, also there is no need to call
 them durring stop_locked since we can use ath5k_hw_dma_stop for
 both.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   99 ++++++++++++++-------------------
 1 files changed, 41 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7f783d9..eea5879 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1063,62 +1063,44 @@ err:
 	return ret;
 }
 
-static void
-ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
-{
-	struct ath5k_buf *bf, *bf0;
-
-	/*
-	 * NB: this assumes output has been stopped and
-	 *     we do not need to block ath5k_tx_tasklet
-	 */
-	spin_lock_bh(&txq->lock);
-	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
-		ath5k_debug_printtxbuf(sc, bf);
-
-		ath5k_txbuf_free_skb(sc, bf);
-
-		spin_lock_bh(&sc->txbuflock);
-		list_move_tail(&bf->list, &sc->txbuf);
-		sc->txbuf_len++;
-		txq->txq_len--;
-		spin_unlock_bh(&sc->txbuflock);
-	}
-	txq->link = NULL;
-	txq->txq_poll_mark = false;
-	spin_unlock_bh(&txq->lock);
-}
-
-/*
- * Drain the transmit queues and reclaim resources.
+/**
+ * ath5k_drain_tx_buffs - Empty tx buffers
+ *
+ * @sc The &struct ath5k_softc
+ *
+ * Empty tx buffers from all queues in preparation
+ * of a reset or during shutdown.
+ *
+ * NB:	this assumes output has been stopped and
+ *	we do not need to block ath5k_tx_tasklet
  */
 static void
-ath5k_txq_cleanup(struct ath5k_softc *sc)
+ath5k_drain_tx_buffs(struct ath5k_softc *sc)
 {
-	struct ath5k_hw *ah = sc->ah;
-	unsigned int i;
+	struct ath5k_txq *txq;
+	struct ath5k_buf *bf, *bf0;
+	int i;
 
-	/* XXX return value */
-	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
-		/* don't touch the hardware if marked invalid */
-		ath5k_hw_stop_tx_dma(ah, sc->bhalq);
-		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "beacon queue %x\n",
-			ath5k_hw_get_txdp(ah, sc->bhalq));
-		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
-			if (sc->txqs[i].setup) {
-				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
-				ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "txq [%u] %x, "
-					"link %p\n",
-					sc->txqs[i].qnum,
-					ath5k_hw_get_txdp(ah,
-							sc->txqs[i].qnum),
-					sc->txqs[i].link);
+	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++) {
+		if (sc->txqs[i].setup) {
+			txq = &sc->txqs[i];
+			spin_lock_bh(&txq->lock);
+			list_for_each_entry_safe(bf, bf0, &txq->q, list) {
+				ath5k_debug_printtxbuf(sc, bf);
+
+				ath5k_txbuf_free_skb(sc, bf);
+
+				spin_lock_bh(&sc->txbuflock);
+				list_move_tail(&bf->list, &sc->txbuf);
+				sc->txbuf_len++;
+				txq->txq_len--;
+				spin_unlock_bh(&sc->txbuflock);
 			}
+			txq->link = NULL;
+			txq->txq_poll_mark = false;
+			spin_unlock_bh(&txq->lock);
+		}
 	}
-
-	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
-		if (sc->txqs[i].setup)
-			ath5k_txq_drainq(sc, &sc->txqs[i]);
 }
 
 static void
@@ -1178,16 +1160,19 @@ err:
 }
 
 /*
- * Disable the receive h/w in preparation for a reset.
+ * Disable the receive logic on PCU (DRU)
+ * In preparation for a shutdown.
+ *
+ * Note: Doesn't stop rx DMA, ath5k_hw_dma_stop
+ * does.
  */
 static void
 ath5k_rx_stop(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
 
-	ath5k_hw_stop_rx_pcu(ah);	/* disable PCU */
 	ath5k_hw_set_rx_filter(ah, 0);	/* clear recv filter */
-	ath5k_hw_stop_rx_dma(ah);	/* disable DMA engine */
+	ath5k_hw_stop_rx_pcu(ah);	/* disable PCU */
 
 	ath5k_debug_printrxbuffs(sc, ah);
 }
@@ -2383,10 +2368,9 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 		ath5k_led_off(sc);
 		ath5k_hw_set_imr(ah, 0);
 		synchronize_irq(sc->pdev->irq);
-	}
-	ath5k_txq_cleanup(sc);
-	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
 		ath5k_rx_stop(sc);
+		ath5k_hw_dma_stop(ah);
+		ath5k_drain_tx_buffs(sc);
 		ath5k_hw_phy_disable(ah);
 	}
 
@@ -2532,8 +2516,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	stop_tasklets(sc);
 
 	if (chan) {
-		ath5k_txq_cleanup(sc);
-		ath5k_rx_stop(sc);
+		ath5k_drain_tx_buffs(sc);
 
 		sc->curchan = chan;
 		sc->curband = &sc->sbands[chan->band];
