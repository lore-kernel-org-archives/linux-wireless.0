Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:10356 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754700Ab0IQCgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 22:36:46 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0686641005
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 11:36:45 +0900 (JST)
Subject: [PATCH 09/11] ath5k: Keep last descriptor in queue
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Fri, 17 Sep 2010 11:37:07 +0900
Message-ID: <20100917023707.24997.98021.stgit@tt-desk>
In-Reply-To: <20100917023543.24997.48466.stgit@tt-desk>
References: <20100917023543.24997.48466.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we return a TX descriptor to the pool of available descriptors, while a
queues TXDP still points to it we could potentially run into all sorts of
troube.

It has been suggested that there is hardware which can set the descriptors
done bit before it reads ds_link and moves on to the next descriptor. While the
documentation says this is not true for newer chipsets (the descriptor contents
are copied to some internal memory), we don't know about older hardware.

To be safe, we always keep the last descriptor in the queue, and avoid dangling
TXDP pointers. Unfortunately this does not fully resolve the problem - queues
still get stuck!

This is similar to what ath9k does.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   64 +++++++++++++++++----------------
 1 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c4f0786..9b67cee 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1590,44 +1590,44 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 
 	spin_lock(&txq->lock);
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
-		ds = bf->desc;
+
+		txq->txq_poll_mark = false;
+
+		/* skb might already have been processed last time. */
+		if (bf->skb != NULL) {
+			ds = bf->desc;
+
+			ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
+			if (unlikely(ret == -EINPROGRESS))
+				break;
+			else if (unlikely(ret)) {
+				ATH5K_ERR(sc,
+					"error %d while processing "
+					"queue %u\n", ret, txq->qnum);
+				break;
+			}
+
+			skb = bf->skb;
+			bf->skb = NULL;
+			pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
+					PCI_DMA_TODEVICE);
+			ath5k_tx_frame_completed(sc, skb, &ts);
+		}
 
 		/*
 		 * It's possible that the hardware can say the buffer is
 		 * completed when it hasn't yet loaded the ds_link from
-		 * host memory and moved on.  If there are more TX
-		 * descriptors in the queue, wait for TXDP to change
-		 * before processing this one.
+		 * host memory and moved on.
+		 * Always keep the last descriptor to avoid HW races...
 		 */
-		if (ath5k_hw_get_txdp(sc->ah, txq->qnum) == bf->daddr &&
-		    !list_is_last(&bf->list, &txq->q))
-			break;
-		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
-		if (unlikely(ret == -EINPROGRESS))
-			break;
-		else if (unlikely(ret)) {
-			ATH5K_ERR(sc, "error %d while processing queue %u\n",
-				ret, txq->qnum);
-			break;
+		if (ath5k_hw_get_txdp(sc->ah, txq->qnum) != bf->daddr) {
+			spin_lock(&sc->txbuflock);
+			list_move_tail(&bf->list, &sc->txbuf);
+			sc->txbuf_len++;
+			txq->txq_len--;
+			spin_unlock(&sc->txbuflock);
 		}
-
-		skb = bf->skb;
-		bf->skb = NULL;
-		pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
-				PCI_DMA_TODEVICE);
-
-		ath5k_tx_frame_completed(sc, skb, &ts);
-
-		spin_lock(&sc->txbuflock);
-		list_move_tail(&bf->list, &sc->txbuf);
-		sc->txbuf_len++;
-		txq->txq_len--;
-		spin_unlock(&sc->txbuflock);
-
-		txq->txq_poll_mark = false;
 	}
-	if (likely(list_empty(&txq->q)))
-		txq->link = NULL;
 	spin_unlock(&txq->lock);
 	if (txq->txq_len < ATH5K_TXQ_LEN_LOW)
 		ieee80211_wake_queue(sc->hw, txq->qnum);
@@ -2192,7 +2192,7 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 		if (sc->txqs[i].setup) {
 			txq = &sc->txqs[i];
 			spin_lock_bh(&txq->lock);
-			if (txq->txq_len > 0) {
+			if (txq->txq_len > 1) {
 				if (txq->txq_poll_mark) {
 					ATH5K_DBG(sc, ATH5K_DEBUG_XMIT,
 						  "TX queue stuck %d\n",

