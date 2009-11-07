Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56133 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZKGUTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:03 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 20/29] ath: move the rx bufsize to common to share with ath5k/ath9k
Date: Sat,  7 Nov 2009 15:18:57 -0500
Message-Id: <1257625146-17971-21-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will also be used by ath9k_htc.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h         |    2 +
 drivers/net/wireless/ath/ath5k/base.c  |   22 ++++++++++++-------
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/recv.c  |   35 ++++++++++++++++++-------------
 4 files changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index b3c8ee0..4af1362 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -87,6 +87,8 @@ struct ath_common {
 	u8 tx_chainmask;
 	u8 rx_chainmask;
 
+	u32 rx_bufsize;
+
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;
 	const struct ath_bus_ops *bus_ops;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 07c1e52..31d556a 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -323,10 +323,13 @@ static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
 static inline void ath5k_rxbuf_free(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
+	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
+
 	BUG_ON(!bf);
 	if (!bf->skb)
 		return;
-	pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
+	pci_unmap_single(sc->pdev, bf->skbaddr, common->rx_bufsize,
 			PCI_DMA_FROMDEVICE);
 	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
@@ -1182,17 +1185,18 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 	 * fake physical layer header at the start.
 	 */
 	skb = ath_rxbuf_alloc(common,
-			      sc->rxbufsize + common->cachelsz - 1,
+			      common->rx_bufsize + common->cachelsz - 1,
 			      GFP_ATOMIC);
 
 	if (!skb) {
 		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
-				sc->rxbufsize + common->cachelsz - 1);
+				common->rx_bufsize + common->cachelsz - 1);
 		return NULL;
 	}
 
 	*skb_addr = pci_map_single(sc->pdev,
-		skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
+				   skb->data, common->rx_bufsize,
+				   PCI_DMA_FROMDEVICE);
 	if (unlikely(pci_dma_mapping_error(sc->pdev, *skb_addr))) {
 		ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
 		dev_kfree_skb(skb);
@@ -1632,10 +1636,10 @@ ath5k_rx_start(struct ath5k_softc *sc)
 	struct ath5k_buf *bf;
 	int ret;
 
-	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, common->cachelsz);
+	common->rx_bufsize = roundup(IEEE80211_MAX_LEN, common->cachelsz);
 
-	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
-		common->cachelsz, sc->rxbufsize);
+	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
+		  common->cachelsz, common->rx_bufsize);
 
 	spin_lock_bh(&sc->rxbuflock);
 	sc->rxlink = NULL;
@@ -1770,6 +1774,8 @@ ath5k_tasklet_rx(unsigned long data)
 	struct sk_buff *skb, *next_skb;
 	dma_addr_t next_skb_addr;
 	struct ath5k_softc *sc = (void *)data;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
 	int ret;
@@ -1847,7 +1853,7 @@ accept:
 		if (!next_skb)
 			goto next;
 
-		pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
+		pci_unmap_single(sc->pdev, bf->skbaddr, common->rx_bufsize,
 				PCI_DMA_FROMDEVICE);
 		skb_put(skb, rs.rs_datalen);
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 24f61fd..377b0ea 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -323,7 +323,6 @@ struct ath_rx {
 	u8 defant;
 	u8 rxotherant;
 	u32 *rxlink;
-	int bufsize;
 	unsigned int rxfilter;
 	spinlock_t rxflushlock;
 	spinlock_t rxbuflock;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4420a58..48ff772 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -48,6 +48,7 @@ static struct ieee80211_hw * ath_get_virt_hw(struct ath_softc *sc,
 static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_desc *ds;
 	struct sk_buff *skb;
 
@@ -62,11 +63,13 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	BUG_ON(skb == NULL);
 	ds->ds_vdata = skb->data;
 
-	/* setup rx descriptors. The rx.bufsize here tells the harware
+	/*
+	 * setup rx descriptors. The rx_bufsize here tells the hardware
 	 * how much data it can DMA to us and that we are prepared
-	 * to process */
+	 * to process
+	 */
 	ath9k_hw_setuprxdesc(ah, ds,
-			     sc->rx.bufsize,
+			     common->rx_bufsize,
 			     0);
 
 	if (sc->rx.rxlink == NULL)
@@ -344,11 +347,11 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_lock_init(&sc->rx.rxbuflock);
 
-	sc->rx.bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
-				 min(common->cachelsz, (u16)64));
+	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
+				     min(common->cachelsz, (u16)64));
 
 	ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
-		  common->cachelsz, sc->rx.bufsize);
+		  common->cachelsz, common->rx_bufsize);
 
 	/* Initialize rx descriptors */
 
@@ -361,7 +364,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	list_for_each_entry(bf, &sc->rx.rxbuf, list) {
-		skb = ath_rxbuf_alloc(common, sc->rx.bufsize, GFP_KERNEL);
+		skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_KERNEL);
 		if (skb == NULL) {
 			error = -ENOMEM;
 			goto err;
@@ -369,7 +372,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 
 		bf->bf_mpdu = skb;
 		bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-						 sc->rx.bufsize,
+						 common->rx_bufsize,
 						 DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(sc->dev,
 					       bf->bf_buf_addr))) {
@@ -393,6 +396,8 @@ err:
 
 void ath_rx_cleanup(struct ath_softc *sc)
 {
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct sk_buff *skb;
 	struct ath_buf *bf;
 
@@ -400,7 +405,7 @@ void ath_rx_cleanup(struct ath_softc *sc)
 		skb = bf->bf_mpdu;
 		if (skb) {
 			dma_unmap_single(sc->dev, bf->bf_buf_addr,
-					 sc->rx.bufsize, DMA_FROM_DEVICE);
+					 common->rx_bufsize, DMA_FROM_DEVICE);
 			dev_kfree_skb(skb);
 		}
 	}
@@ -780,7 +785,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 * 2. requeueing the same buffer to h/w
 		 */
 		dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
-				sc->rx.bufsize,
+				common->rx_bufsize,
 				DMA_FROM_DEVICE);
 
 		hdr = (struct ieee80211_hdr *) skb->data;
@@ -797,7 +802,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			goto requeue;
 
 		/* The status portion of the descriptor could get corrupted. */
-		if (sc->rx.bufsize < rx_stats->rs_datalen)
+		if (common->rx_bufsize < rx_stats->rs_datalen)
 			goto requeue;
 
 		if (!ath_rx_prepare(common, hw, skb, rx_stats,
@@ -806,7 +811,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
-		requeue_skb = ath_rxbuf_alloc(common, sc->rx.bufsize, GFP_ATOMIC);
+		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
 
 		/* If there is no memory we ignore the current RX'd frame,
 		 * tell hardware it can give us a new frame using the old
@@ -817,7 +822,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* Unmap the frame */
 		dma_unmap_single(sc->dev, bf->bf_buf_addr,
-				 sc->rx.bufsize,
+				 common->rx_bufsize,
 				 DMA_FROM_DEVICE);
 
 		skb_put(skb, rx_stats->rs_datalen);
@@ -860,8 +865,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
 		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
-					 sc->rx.bufsize,
-					 DMA_FROM_DEVICE);
+						 common->rx_bufsize,
+						 DMA_FROM_DEVICE);
 		if (unlikely(dma_mapping_error(sc->dev,
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
-- 
1.6.5.2.143.g8cc62

