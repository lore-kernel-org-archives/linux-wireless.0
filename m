Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:39995 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbZAIMZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:51 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v2 01/11] ath9k: convert to struct device
Date: Fri,  9 Jan 2009 13:24:18 +0100
Message-Id: <1231503868-29226-2-git-send-email-juhosg@openwrt.org> (sfid-20090109_132608_062247_8C66791F)
In-Reply-To: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert 'struct pci_dev' to 'struct device' to make it usable on the AHB
bus as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/beacon.c |   17 ++++++++++-------
 drivers/net/wireless/ath9k/core.h   |    2 +-
 drivers/net/wireless/ath9k/main.c   |   21 +++++++++++----------
 drivers/net/wireless/ath9k/recv.c   |   15 +++++++++------
 drivers/net/wireless/ath9k/xmit.c   |    7 ++++---
 5 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 3ab0b43..f02b099 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -164,7 +164,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	bf = avp->av_bcbuf;
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	if (skb) {
-		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
+		pci_unmap_single(to_pci_dev(sc->dev), bf->bf_dmacontext,
 				 skb->len,
 				 PCI_DMA_TODEVICE);
 		dev_kfree_skb_any(skb);
@@ -188,10 +188,11 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
-		pci_map_single(sc->pdev, skb->data,
+		pci_map_single(to_pci_dev(sc->dev), skb->data,
 			       skb->len,
 			       PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_buf_addr))) {
+	if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
+					   bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
@@ -343,7 +344,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
 		skb = (struct sk_buff *)bf->bf_mpdu;
-		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
+		pci_unmap_single(to_pci_dev(sc->dev), bf->bf_dmacontext,
 				 skb->len,
 				 PCI_DMA_TODEVICE);
 		dev_kfree_skb_any(skb);
@@ -402,10 +403,11 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 
 	bf->bf_mpdu = skb;
 	bf->bf_buf_addr = bf->bf_dmacontext =
-		pci_map_single(sc->pdev, skb->data,
+		pci_map_single(to_pci_dev(sc->dev), skb->data,
 			       skb->len,
 			       PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_buf_addr))) {
+	if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
+					   bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
@@ -429,7 +431,8 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 		bf = avp->av_bcbuf;
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
-			pci_unmap_single(sc->pdev, bf->bf_dmacontext,
+			pci_unmap_single(to_pci_dev(sc->dev),
+					 bf->bf_dmacontext,
 					 skb->len,
 					 PCI_DMA_TODEVICE);
 			dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 2bb35dd..2256ba4 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -695,7 +695,7 @@ enum PROT_MODE {
 
 struct ath_softc {
 	struct ieee80211_hw *hw;
-	struct pci_dev *pdev;
+	struct device *dev;
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hal *sc_ah;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index f590fce..3313459 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -46,7 +46,8 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 {
 	u8 u8tmp;
 
-	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, (u8 *)&u8tmp);
+	pci_read_config_byte(to_pci_dev(sc->dev), PCI_CACHE_LINE_SIZE,
+			     (u8 *)&u8tmp);
 	*csz = (int)u8tmp;
 
 	/*
@@ -1267,11 +1268,11 @@ static int ath_start_rfkill_poll(struct ath_softc *sc)
 
 			/* Deinitialize the device */
 			ath_detach(sc);
-			if (sc->pdev->irq)
-				free_irq(sc->pdev->irq, sc);
-			pci_iounmap(sc->pdev, sc->mem);
-			pci_release_region(sc->pdev, 0);
-			pci_disable_device(sc->pdev);
+			if (to_pci_dev(sc->dev)->irq)
+				free_irq(to_pci_dev(sc->dev)->irq, sc);
+			pci_iounmap(to_pci_dev(sc->dev), sc->mem);
+			pci_release_region(to_pci_dev(sc->dev), 0);
+			pci_disable_device(to_pci_dev(sc->dev));
 			ieee80211_free_hw(sc->hw);
 			return -EIO;
 		} else {
@@ -1708,7 +1709,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 
 	/* allocate descriptors */
-	dd->dd_desc = pci_alloc_consistent(sc->pdev,
+	dd->dd_desc = pci_alloc_consistent(to_pci_dev(sc->dev),
 			      dd->dd_desc_len,
 			      &dd->dd_desc_paddr);
 	if (dd->dd_desc == NULL) {
@@ -1756,7 +1757,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 	return 0;
 fail2:
-	pci_free_consistent(sc->pdev,
+	pci_free_consistent(to_pci_dev(sc->dev),
 		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
 fail:
 	memset(dd, 0, sizeof(*dd));
@@ -1770,7 +1771,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 			 struct ath_descdma *dd,
 			 struct list_head *head)
 {
-	pci_free_consistent(sc->pdev,
+	pci_free_consistent(to_pci_dev(sc->dev),
 		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
 
 	INIT_LIST_HEAD(head);
@@ -2615,7 +2616,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	sc = hw->priv;
 	sc->hw = hw;
-	sc->pdev = pdev;
+	sc->dev = &pdev->dev;
 	sc->mem = mem;
 
 	if (ath_attach(id->device, sc) != 0) {
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 462e08c..d7774d1 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -291,10 +291,11 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			}
 
 			bf->bf_mpdu = skb;
-			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
+			bf->bf_buf_addr = pci_map_single(to_pci_dev(sc->dev),
+							 skb->data,
 							 sc->rx.bufsize,
 							 PCI_DMA_FROMDEVICE);
-			if (unlikely(pci_dma_mapping_error(sc->pdev,
+			if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
 				  bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
 				bf->bf_mpdu = NULL;
@@ -524,7 +525,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 * 1. accessing the frame
 		 * 2. requeueing the same buffer to h/w
 		 */
-		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
+		pci_dma_sync_single_for_cpu(to_pci_dev(sc->dev),
+				bf->bf_buf_addr,
 				sc->rx.bufsize,
 				PCI_DMA_FROMDEVICE);
 
@@ -557,7 +559,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			goto requeue;
 
 		/* Unmap the frame */
-		pci_unmap_single(sc->pdev, bf->bf_buf_addr,
+		pci_unmap_single(to_pci_dev(sc->dev), bf->bf_buf_addr,
 				 sc->rx.bufsize,
 				 PCI_DMA_FROMDEVICE);
 
@@ -599,10 +601,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
-		bf->bf_buf_addr = pci_map_single(sc->pdev, requeue_skb->data,
+		bf->bf_buf_addr = pci_map_single(to_pci_dev(sc->dev),
+					 requeue_skb->data,
 					 sc->rx.bufsize,
 					 PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(sc->pdev,
+		if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
 			bf->bf_mpdu = NULL;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 9e910f7..27cb9d5 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -340,7 +340,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 	}
 
 	/* Unmap this frame */
-	pci_unmap_single(sc->pdev,
+	pci_unmap_single(to_pci_dev(sc->dev),
 			 bf->bf_dmacontext,
 			 skb->len,
 			 PCI_DMA_TODEVICE);
@@ -1716,9 +1716,10 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	/* DMA setup */
 	bf->bf_mpdu = skb;
 
-	bf->bf_dmacontext = pci_map_single(sc->pdev, skb->data,
+	bf->bf_dmacontext = pci_map_single(to_pci_dev(sc->dev), skb->data,
 					   skb->len, PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_dmacontext))) {
+	if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
+					   bf->bf_dmacontext))) {
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
 			"pci_dma_mapping_error() on TX\n");
-- 
1.5.3.2

