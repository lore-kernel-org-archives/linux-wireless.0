Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56591 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0KKO5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:57:41 -0500
Date: Thu, 11 Nov 2010 15:57:36 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Message-ID: <23232015.1011289487455461.JavaMail.wlan@CHBU500181>
In-Reply-To: <17888045.991289487433290.JavaMail.wlan@CHBU500181>
Subject: [PATCH 1/9] ath5k: AHB port. Use generic DMA instead of PCI API.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

General comments for AHB bus support in ath5k:
 - most of the original patches came from Felix Fetikau. I have used them as a reference and ported to current git tree
 - tried with access point functionality with WPA2 and without encryption
 - tested on AR5312 for AHB and AR5414 and AR5212 for PCI
 - compat wireless from openwrt was used for testing these patches
 - last two patches have to be applied together because otherwise hardware will crash on reset if
  only number 9 is committed. I have kept them separated for better visibility



Generic DMA is needed for AHB support.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   65 ++++++++++++++++++---------------
 drivers/net/wireless/ath/ath5k/base.h |    4 ++-
 2 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b9f93fb..7286b5c 100644
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
@@ -659,10 +659,11 @@ struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
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
@@ -758,8 +759,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
 
 	/* XXX endianness */
-	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
-			PCI_DMA_TODEVICE);
+	bf->skbaddr = dma_map_single(sc->dev, skb->data, skb->len,
+			DMA_TO_DEVICE);
 
 	rate = ieee80211_get_tx_rate(sc->hw, info);
 	if (!rate) {
@@ -839,7 +840,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 
 	return 0;
 err_unmap:
-	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
+	dma_unmap_single(sc->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -848,7 +849,7 @@ err_unmap:
 \*******************/
 
 static int
-ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
+ath5k_desc_alloc(struct ath5k_softc *sc)
 {
 	struct ath5k_desc *ds;
 	struct ath5k_buf *bf;
@@ -859,7 +860,8 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
 	/* allocate descriptors */
 	sc->desc_len = sizeof(struct ath5k_desc) *
 			(ATH_TXBUF + ATH_RXBUF + ATH_BCBUF + 1);
-	sc->desc = pci_alloc_consistent(pdev, sc->desc_len, &sc->desc_daddr);
+
+	sc->desc = dma_alloc_coherent(sc->dev, sc->desc_len, &sc->desc_daddr, GFP_KERNEL);
 	if (sc->desc == NULL) {
 		ATH5K_ERR(sc, "can't allocate descriptors\n");
 		ret = -ENOMEM;
@@ -905,14 +907,14 @@ ath5k_desc_alloc(struct ath5k_softc *sc, struct pci_dev *pdev)
 
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
 
@@ -924,7 +926,7 @@ ath5k_desc_free(struct ath5k_softc *sc, struct pci_dev *pdev)
 		ath5k_txbuf_free_skb(sc, bf);
 
 	/* Free memory associated with all descriptors */
-	pci_free_consistent(pdev, sc->desc_len, sc->desc, sc->desc_daddr);
+	dma_free_coherent(sc->dev, sc->desc_len, sc->desc, sc->desc_daddr);
 	sc->desc = NULL;
 	sc->desc_daddr = 0;
 
@@ -1551,9 +1553,9 @@ ath5k_tasklet_rx(unsigned long data)
 			if (!next_skb)
 				goto next;
 
-			pci_unmap_single(sc->pdev, bf->skbaddr,
+			dma_unmap_single(sc->dev, bf->skbaddr,
 					 common->rx_bufsize,
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 
 			skb_put(skb, rs.rs_datalen);
 
@@ -1716,8 +1718,9 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 
 			skb = bf->skb;
 			bf->skb = NULL;
-			pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
-					PCI_DMA_TODEVICE);
+
+			dma_unmap_single(sc->dev, bf->skbaddr, skb->len,
+					DMA_TO_DEVICE);
 			ath5k_tx_frame_completed(sc, skb, &ts);
 		}
 
@@ -1771,12 +1774,13 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
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
@@ -1828,7 +1832,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 
 	return 0;
 err_unmap:
-	pci_unmap_single(sc->pdev, bf->skbaddr, skb->len, PCI_DMA_TODEVICE);
+	dma_unmap_single(sc->dev, bf->skbaddr, skb->len, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -2389,7 +2393,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
 		ath5k_led_off(sc);
 		ath5k_hw_set_imr(ah, 0);
-		synchronize_irq(sc->pdev->irq);
+		synchronize_irq(sc->irq);
 	}
 	ath5k_txq_cleanup(sc);
 	if (!test_bit(ATH_STAT_INVALID, sc->status)) {
@@ -2535,7 +2539,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
 
 	ath5k_hw_set_imr(ah, 0);
-	synchronize_irq(sc->pdev->irq);
+	synchronize_irq(sc->irq);
 	stop_tasklets(sc);
 
 	if (chan) {
@@ -2641,7 +2645,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	/*
 	 * Allocate tx+rx descriptors and populate the lists.
 	 */
-	ret = ath5k_desc_alloc(sc, pdev);
+	ret = ath5k_desc_alloc(sc);
 	if (ret) {
 		ATH5K_ERR(sc, "can't allocate descriptors\n");
 		goto err;
@@ -2705,8 +2709,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
-		ATH5K_ERR(sc, "unable to read address from EEPROM: 0x%04x\n",
-			sc->pdev->device);
+		ATH5K_ERR(sc, "unable to read address from EEPROM\n");
 		goto err_queues;
 	}
 
@@ -2741,7 +2744,7 @@ err_queues:
 err_bhal:
 	ath5k_hw_release_tx_queue(ah, sc->bhalq);
 err_desc:
-	ath5k_desc_free(sc, pdev);
+	ath5k_desc_free(sc);
 err:
 	return ret;
 }
@@ -2765,7 +2768,7 @@ ath5k_detach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	 * Other than that, it's straightforward...
 	 */
 	ieee80211_unregister_hw(hw);
-	ath5k_desc_free(sc, pdev);
+	ath5k_desc_free(sc);
 	ath5k_txq_release(sc);
 	ath5k_hw_release_tx_queue(sc->ah, sc->bhalq);
 	ath5k_unregister_leds(sc);
@@ -3558,6 +3561,8 @@ ath5k_pci_probe(struct pci_dev *pdev,
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
