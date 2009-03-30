Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25185 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbZC3KC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:55 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38869.229698.501792@gargle.gargle.HOWL> (sfid-20090330_120317_386372_D8688665)
Date: Mon, 30 Mar 2009 15:28:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 12/17] ath9k: Remove the useless do..while loops
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are unnecessary constructs in a function.
This patch removes these from both RX and TX init
routines.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath9k/recv.c  |   83 +++++++++++++++++-------------------
 drivers/net/wireless/ath9k/xmit.c  |   40 +++++++----------
 3 files changed, 57 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 6aba991..f374fa4 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -344,7 +344,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
-int ath_tx_cleanup(struct ath_softc *sc);
+void ath_tx_cleanup(struct ath_softc *sc);
 struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index ea02332..94a3328 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -283,54 +283,51 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	struct ath_buf *bf;
 	int error = 0;
 
-	do {
-		spin_lock_init(&sc->rx.rxflushlock);
-		sc->sc_flags &= ~SC_OP_RXFLUSH;
-		spin_lock_init(&sc->rx.rxbuflock);
-
-		sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
-					   min(sc->cachelsz,
-					       (u16)64));
+	spin_lock_init(&sc->rx.rxflushlock);
+	sc->sc_flags &= ~SC_OP_RXFLUSH;
+	spin_lock_init(&sc->rx.rxbuflock);
 
-		DPRINTF(sc, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-			sc->cachelsz, sc->rx.bufsize);
+	sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
+				 min(sc->cachelsz, (u16)64));
 
-		/* Initialize rx descriptors */
+	DPRINTF(sc, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
+		sc->cachelsz, sc->rx.bufsize);
 
-		error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
-					  "rx", nbufs, 1);
-		if (error != 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"failed to allocate rx descriptors: %d\n", error);
-			break;
-		}
+	/* Initialize rx descriptors */
 
-		list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-			skb = ath_rxbuf_alloc(sc, sc->rx.bufsize, GFP_KERNEL);
-			if (skb == NULL) {
-				error = -ENOMEM;
-				break;
-			}
+	error = ath_descdma_setup(sc, &sc->rx.rxdma, &sc->rx.rxbuf,
+				  "rx", nbufs, 1);
+	if (error != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"failed to allocate rx descriptors: %d\n", error);
+		goto err;
+	}
 
-			bf->bf_mpdu = skb;
-			bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-							 sc->rx.bufsize,
-							 DMA_FROM_DEVICE);
-			if (unlikely(dma_mapping_error(sc->dev,
-				  bf->bf_buf_addr))) {
-				dev_kfree_skb_any(skb);
-				bf->bf_mpdu = NULL;
-				DPRINTF(sc, ATH_DBG_FATAL,
-					"dma_mapping_error() on RX init\n");
-				error = -ENOMEM;
-				break;
-			}
-			bf->bf_dmacontext = bf->bf_buf_addr;
+	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
+		skb = ath_rxbuf_alloc(sc, sc->rx.bufsize, GFP_KERNEL);
+		if (skb == NULL) {
+			error = -ENOMEM;
+			goto err;
 		}
-		sc->rx.rxlink = NULL;
 
-	} while (0);
+		bf->bf_mpdu = skb;
+		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
+						 sc->rx.bufsize,
+						 DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(sc->dev,
+					       bf->bf_buf_addr))) {
+			dev_kfree_skb_any(skb);
+			bf->bf_mpdu = NULL;
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"dma_mapping_error() on RX init\n");
+			error = -ENOMEM;
+			goto err;
+		}
+		bf->bf_dmacontext = bf->bf_buf_addr;
+	}
+	sc->rx.rxlink = NULL;
 
+err:
 	if (error)
 		ath_rx_cleanup(sc);
 
@@ -345,10 +342,8 @@ void ath_rx_cleanup(struct ath_softc *sc)
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
 		skb = bf->bf_mpdu;
 		if (skb) {
-			dma_unmap_single(sc->dev,
-					 bf->bf_buf_addr,
-					 sc->rx.bufsize,
-					 DMA_FROM_DEVICE);
+			dma_unmap_single(sc->dev, bf->bf_buf_addr,
+					 sc->rx.bufsize, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 		}
 	}
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 735256f..628b780 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2047,44 +2047,38 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 {
 	int error = 0;
 
-	do {
-		spin_lock_init(&sc->tx.txbuflock);
+	spin_lock_init(&sc->tx.txbuflock);
 
-		error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
-			"tx", nbufs, 1);
-		if (error != 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Failed to allocate tx descriptors: %d\n",
-				error);
-			break;
-		}
-
-		error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
-					  "beacon", ATH_BCBUF, 1);
-		if (error != 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Failed to allocate beacon descriptors: %d\n",
-				error);
-			break;
-		}
+	error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
+				  "tx", nbufs, 1);
+	if (error != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Failed to allocate tx descriptors: %d\n", error);
+		goto err;
+	}
 
-	} while (0);
+	error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
+				  "beacon", ATH_BCBUF, 1);
+	if (error != 0) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"Failed to allocate beacon descriptors: %d\n", error);
+		goto err;
+	}
 
+err:
 	if (error != 0)
 		ath_tx_cleanup(sc);
 
 	return error;
 }
 
-int ath_tx_cleanup(struct ath_softc *sc)
+void ath_tx_cleanup(struct ath_softc *sc)
 {
 	if (sc->beacon.bdma.dd_desc_len != 0)
 		ath_descdma_cleanup(sc, &sc->beacon.bdma, &sc->beacon.bbuf);
 
 	if (sc->tx.txdma.dd_desc_len != 0)
 		ath_descdma_cleanup(sc, &sc->tx.txdma, &sc->tx.txbuf);
-
-	return 0;
 }
 
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
-- 
1.6.2.1

