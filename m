Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:33311 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab0KZJ40 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 04:56:26 -0500
Date: Fri, 26 Nov 2010 10:56:22 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org
Message-ID: <18349102.401290765381862.JavaMail.wlan@CHBU500181>
In-Reply-To: <15310406.201290764903541.JavaMail.wlan@CHBU500181>
Subject: [PATCH v6 1/9] ath5k: Use Generic DMA for later support of AHB bus.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   66 ++++++++++++++++++---------------
 drivers/net/wireless/ath/ath5k/base.h |    4 +-
 2 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7f783d9..0d4398b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -197,8 +197,8 @@ static inline void ath5k_txbuf_free_skb(struct ath5k_softc *sc,
 	BUG_ON(!bf);
 	if (!bf->skb)
 		return;
-	pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
-			PCI_DMA_TODEVICE);
+	dma_unmap_single(sc->dev, bf->skbaddr, bf->skb->len,
+			DMA_TO_DEVICE);
 	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
 	bf->skbaddr = 0;
@@ -214,8 +214,8 @@ static inline void ath5k_rxbuf_free_skb(struct ath5k_softc *sc,
 	BUG_ON(!bf);
 	if (!bf->skb)
 		return;
-	pci_unmap_single(sc->pdev, bf->skbaddr, common->rx_bufsize,
-			PCI_DMA_FROMDEVICE);
+	dma_unmap_single(sc->dev, bf->skbaddr, common->rx_bufsize,
+			DMA_FROM_DEVICE);
 	dev_kfree_skb_any(bf->skb);
 	bf->skb = NULL;
 	bf->skbaddr = 0;
@@ -653,10 +653,11 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 		return NULL;
 	}
 
-	*skb_addr = pci_map_single(sc->pdev,
+	*skb_addr = dma_map_single(sc->dev,
 				   skb->data, common->rx_bufsize,
-				   PCI_DMA_FROMDEVICE);
-	if (unlikely(pci_dma_mapping_error(sc->pdev, *skb_addr))) {
+				   DMA_FROM_DEVICE);
+
+	if (unlikely(dma_mapping_error(sc->dev, *skb_addr))) {
 		ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
 		dev_kfree_skb(skb);
 		return NULL;
@@ -752,8 +753,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
 
 	/* XXX endianness */
-	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
-			PCI_DMA_TODEVICE);
+	bf->skbaddr = dma_map_single(sc->dev, skb->data, skb->len,
+			DMA_TO_DEVICE);
 
 	rate = ieee80211_get_tx_rate(sc->hw, info);
 	if (!rate) {
@@ -833,7 +834,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	return 0;
 err_unmap:
-	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
+	dma_unmap_single(sc->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -842,7 +843,7 @@ err_unmap:
 \*******************/
 
 static int
-ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
+ath5k_desc_alloc(struct ath5k_softc *sc)
 {
 	struct ath5k_desc *ds;
 	struct ath5k_buf *bf;
@@ -853,7 +854,9 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
 	/* allocate descriptors */
 	sc->desc_len = sizeof(struct ath5k_desc) *
 			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
-	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
+
+	sc->desc = dma_alloc_coherent(sc->dev, sc->desc_len,
+				&sc->desc_daddr, GFP_KERNEL);
 	if (sc->desc == NULL) {
 		ATH5K_ERR(sc, "can't allocate descriptors\n");
 		ret = -ENOMEM;
@@ -899,14 +902,14 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
 
 	return 0;
 err_free:
-	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+	dma_free_coherent(sc->dev, sc->desc_len, sc->desc, sc->desc_daddr);
 err:
 	sc->desc = NULL;
 	return ret;
 }
 
 static void
-ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
+ath5k_desc_free(struct ath5k_softc *sc)
 {
 	struct ath5k_buf *bf;
 
@@ -918,7 +921,7 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 		ath5k_txbuf_free_skb(sc, bf);
 
 	/* Free memory associated with all descriptors */
-	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+	dma_free_coherent(sc->dev, sc->desc_len, sc->desc, sc->desc_daddr);
 	sc->desc = NULL;
 	sc->desc_daddr = 0;
 
@@ -1544,9 +1547,9 @@ ath5k_tasklet_rx(unsigned long data)
 			if (!next_skb)
 				goto next;
 
-			pci_unmap_single(sc->pdev, bf->skbaddr,
+			dma_unmap_single(sc->dev, bf->skbaddr,
 					 common->rx_bufsize,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 
 			skb_put(skb, rs.rs_datalen);
 
@@ -1709,8 +1712,9 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 
 			skb = bf->skb;
 			bf->skb = NULL;
-			pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
-					PCI_DMA_TODEVICE);
+
+			dma_unmap_single(sc->dev, bf->skbaddr, skb->len,
+					DMA_TO_DEVICE);
 			ath5k_tx_frame_completed(sc, skb, &ts);
 		}
 
@@ -1764,12 +1768,13 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	u32 flags;
 	const int padsize = 0;
 
-	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
-			PCI_DMA_TODEVICE);
+	bf->skbaddr = dma_map_single(sc->dev, skb->data, skb->len,
+			DMA_TO_DEVICE);
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "skb %p [data %p len %u] "
 			"skbaddr %llx\n", skb, skb->data, skb->len,
 			(unsigned long long)bf->skbaddr);
-	if (pci_dma_mapping_error(sc->pdev, bf->skbaddr)) {
+
+	if (dma_mapping_error(sc->dev, bf->skbaddr)) {
 		ATH5K_ERR(sc, "beacon DMA mapping failed\n");
 		return -EIO;
 	}
@@ -1821,7 +1826,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 	return 0;
 err_unmap:
-	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
+	dma_unmap_single(sc->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -2382,7 +2387,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
 		ath5k_led_off(sc);
 		ath5k_hw_set_imr(ah, 0);
-		synchronize_irq(sc->pdev->irq);
+		synchronize_irq(sc->irq);
 	}
 	ath5k_txq_cleanup(sc);
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
@@ -2528,7 +2533,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
 	ath5k_hw_set_imr(ah, 0);
-	synchronize_irq(sc->pdev->irq);
+	synchronize_irq(sc->irq);
 	stop_tasklets(sc);
 
 	if (chan) {
@@ -2635,7 +2640,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	/*
 	 * Allocate tx+rx descriptors and populate the lists.
 	 */
-	ret = ath5k_desc_alloc(sc, pdev);
+	ret = ath5k_desc_alloc(sc);
 	if (ret) {
 		ATH5K_ERR(sc, "can't allocate descriptors\n");
 		goto err;
@@ -2699,8 +2704,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
-		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
-			sc->pdev->device);
+		ATH5K_ERR(sc, "unable to read address from EEPROM\n");
 		goto err_queues;
 	}
 
@@ -2735,7 +2739,7 @@ err_queues:
 err_bhal:
 	ath5k_hw_release_tx_queue(ah, sc->bhalq);
 err_desc:
-	ath5k_desc_free(sc, pdev);
+	ath5k_desc_free(sc);
 err:
 	return ret;
 }
@@ -2759,7 +2763,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * Other than that, it's straightforward...
 	 */
 	ieee80211_unregister_hw(hw);
-	ath5k_desc_free(sc, pdev);
+	ath5k_desc_free(sc);
 	ath5k_txq_release(sc);
 	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
 	ath5k_unregister_leds(sc);
@@ -3584,6 +3588,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->pdev = pdev;
+	sc->dev = &pdev->dev;
+	sc->irq = pdev->irq;
 
 	/*
 	 * Mark the device as detached to avoid processing
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 9a79773..0362f8e 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -169,7 +169,9 @@ struct ath5k_vif {
 /* Software Carrier, keeps track of the driver state
  * associated with an instance of a device */
 struct ath5k_softc {
-	struct pci_dev		*pdev;		/* for dma mapping */
+	struct pci_dev		*pdev;
+	struct device		*dev;		/* for dma mapping */
+	int irq;
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
 	struct ieee80211_hw	*hw;		/* IEEE 802.11 common */
-- 
1.7.1

