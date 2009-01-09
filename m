Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:40011 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZAIMZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:54 -0500
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
Subject: [PATCH v2 02/11] ath9k: convert to use bus-agnostic DMA routines
Date: Fri,  9 Jan 2009 13:24:19 +0100
Message-Id: <1231503868-29226-3-git-send-email-juhosg@openwrt.org> (sfid-20090109_133904_180641_F547850D)
In-Reply-To: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert to use bus-agnostic DMA routines to make it usable on AHB bus as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/beacon.c |   31 ++++++++++++++-----------------
 drivers/net/wireless/ath9k/main.c   |   13 ++++++-------
 drivers/net/wireless/ath9k/recv.c   |   27 ++++++++++++---------------
 drivers/net/wireless/ath9k/xmit.c   |   15 ++++++---------
 4 files changed, 38 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index f02b099..be1d84a 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -164,9 +164,9 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	bf = avp->av_bcbuf;
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	if (skb) {
-		pci_unmap_single(to_pci_dev(sc->dev), bf->bf_dmacontext,
+		dma_unmap_single(sc->dev, bf->bf_dmacontext,
 				 skb->len,
-				 PCI_DMA_TODEVICE);
+				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 	}
 
@@ -188,15 +188,14 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
-		pci_map_single(to_pci_dev(sc->dev), skb->data,
+		dma_map_single(sc->dev, skb->data,
 			       skb->len,
-			       PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
-					   bf->bf_buf_addr))) {
+			       DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"pci_dma_mapping_error() on beaconing\n");
+			"dma_mapping_error() on beaconing\n");
 		return NULL;
 	}
 
@@ -344,9 +343,9 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
 		skb = (struct sk_buff *)bf->bf_mpdu;
-		pci_unmap_single(to_pci_dev(sc->dev), bf->bf_dmacontext,
+		dma_unmap_single(sc->dev, bf->bf_dmacontext,
 				 skb->len,
-				 PCI_DMA_TODEVICE);
+				 DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 	}
@@ -403,15 +402,14 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 
 	bf->bf_mpdu = skb;
 	bf->bf_buf_addr = bf->bf_dmacontext =
-		pci_map_single(to_pci_dev(sc->dev), skb->data,
+		dma_map_single(sc->dev, skb->data,
 			       skb->len,
-			       PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
-					   bf->bf_buf_addr))) {
+			       DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sc->dev, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"pci_dma_mapping_error() on beacon alloc\n");
+			"dma_mapping_error() on beacon alloc\n");
 		return -ENOMEM;
 	}
 
@@ -431,10 +429,9 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 		bf = avp->av_bcbuf;
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
-			pci_unmap_single(to_pci_dev(sc->dev),
-					 bf->bf_dmacontext,
+			dma_unmap_single(sc->dev, bf->bf_dmacontext,
 					 skb->len,
-					 PCI_DMA_TODEVICE);
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
 		}
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 3313459..9acd968 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1709,9 +1709,8 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 
 	/* allocate descriptors */
-	dd->dd_desc = pci_alloc_consistent(to_pci_dev(sc->dev),
-			      dd->dd_desc_len,
-			      &dd->dd_desc_paddr);
+	dd->dd_desc = dma_alloc_coherent(sc->dev, dd->dd_desc_len,
+					 &dd->dd_desc_paddr, GFP_ATOMIC);
 	if (dd->dd_desc == NULL) {
 		error = -ENOMEM;
 		goto fail;
@@ -1757,8 +1756,8 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 	return 0;
 fail2:
-	pci_free_consistent(to_pci_dev(sc->dev),
-		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
+	dma_free_coherent(sc->dev, dd->dd_desc_len, dd->dd_desc,
+			  dd->dd_desc_paddr);
 fail:
 	memset(dd, 0, sizeof(*dd));
 	return error;
@@ -1771,8 +1770,8 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 			 struct ath_descdma *dd,
 			 struct list_head *head)
 {
-	pci_free_consistent(to_pci_dev(sc->dev),
-		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
+	dma_free_coherent(sc->dev, dd->dd_desc_len, dd->dd_desc,
+			  dd->dd_desc_paddr);
 
 	INIT_LIST_HEAD(head);
 	kfree(dd->dd_bufptr);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index d7774d1..1fc4dd9 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -291,16 +291,15 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			}
 
 			bf->bf_mpdu = skb;
-			bf->bf_buf_addr = pci_map_single(to_pci_dev(sc->dev),
-							 skb->data,
+			bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
 							 sc->rx.bufsize,
-							 PCI_DMA_FROMDEVICE);
-			if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
+							 DMA_FROM_DEVICE);
+			if (unlikely(dma_mapping_error(sc->dev,
 				  bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
 				bf->bf_mpdu = NULL;
 				DPRINTF(sc, ATH_DBG_CONFIG,
-					"pci_dma_mapping_error() on RX init\n");
+					"dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
 				break;
 			}
@@ -525,10 +524,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 * 1. accessing the frame
 		 * 2. requeueing the same buffer to h/w
 		 */
-		pci_dma_sync_single_for_cpu(to_pci_dev(sc->dev),
-				bf->bf_buf_addr,
+		dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
 				sc->rx.bufsize,
-				PCI_DMA_FROMDEVICE);
+				DMA_FROM_DEVICE);
 
 		/*
 		 * If we're asked to flush receive queue, directly
@@ -559,9 +557,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			goto requeue;
 
 		/* Unmap the frame */
-		pci_unmap_single(to_pci_dev(sc->dev), bf->bf_buf_addr,
+		dma_unmap_single(sc->dev, bf->bf_buf_addr,
 				 sc->rx.bufsize,
-				 PCI_DMA_FROMDEVICE);
+				 DMA_FROM_DEVICE);
 
 		skb_put(skb, ds->ds_rxstat.rs_datalen);
 		skb->protocol = cpu_to_be16(ETH_P_CONTROL);
@@ -601,16 +599,15 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
-		bf->bf_buf_addr = pci_map_single(to_pci_dev(sc->dev),
-					 requeue_skb->data,
+		bf->bf_buf_addr = dma_map_single(sc->dev, requeue_skb->data,
 					 sc->rx.bufsize,
-					 PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
+					 DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(sc->dev,
 			  bf->bf_buf_addr))) {
 			dev_kfree_skb_any(requeue_skb);
 			bf->bf_mpdu = NULL;
 			DPRINTF(sc, ATH_DBG_CONFIG,
-				"pci_dma_mapping_error() on RX\n");
+				"dma_mapping_error() on RX\n");
 			break;
 		}
 		bf->bf_dmacontext = bf->bf_buf_addr;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 27cb9d5..522078d 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -340,10 +340,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 	}
 
 	/* Unmap this frame */
-	pci_unmap_single(to_pci_dev(sc->dev),
-			 bf->bf_dmacontext,
-			 skb->len,
-			 PCI_DMA_TODEVICE);
+	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
+
 	/* complete this frame */
 	ath_tx_complete(sc, skb, &tx_status);
 
@@ -1716,13 +1714,12 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	/* DMA setup */
 	bf->bf_mpdu = skb;
 
-	bf->bf_dmacontext = pci_map_single(to_pci_dev(sc->dev), skb->data,
-					   skb->len, PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(to_pci_dev(sc->dev),
-					   bf->bf_dmacontext))) {
+	bf->bf_dmacontext = dma_map_single(sc->dev, skb->data,
+					   skb->len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sc->dev, bf->bf_dmacontext))) {
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"pci_dma_mapping_error() on TX\n");
+			"dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 
-- 
1.5.3.2

