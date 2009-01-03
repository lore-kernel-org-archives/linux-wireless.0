Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48827 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667AbZACNoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:44:55 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC 01/12] ath9k: introduce bus specific DMA routines
Date: Sat,  3 Jan 2009 14:44:11 +0100
Message-Id: <1230990262-22923-2-git-send-email-juhosg@openwrt.org> (sfid-20090103_150901_191988_F57B38B5)
In-Reply-To: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the AR913x SoCs, the WMAC devices are connected to the CPU through
the internal AHB bus instead of PCI. We first patch ath9k driver to use
replaceable DMA routines, so we can use different code for the AHB bus.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/beacon.c |   29 +++++---------
 drivers/net/wireless/ath9k/core.h   |   75 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/main.c   |   71 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath9k/recv.c   |   30 ++++++--------
 drivers/net/wireless/ath9k/xmit.c   |   12 ++----
 5 files changed, 166 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 3ab0b43..05cdbc8 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -164,9 +164,7 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	bf = avp->av_bcbuf;
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	if (skb) {
-		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
-				 skb->len,
-				 PCI_DMA_TODEVICE);
+		ath_unmap_single_to_device(sc, bf->bf_dmacontext, skb->len);
 		dev_kfree_skb_any(skb);
 	}
 
@@ -188,14 +186,12 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
-		pci_map_single(sc->pdev, skb->data,
-			       skb->len,
-			       PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_buf_addr))) {
+		ath_map_single_to_device(sc, skb->data, skb->len);
+	if (unlikely(ath_dma_mapping_error(sc, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"pci_dma_mapping_error() on beaconing\n");
+			"dma_mapping_error() on beaconing\n");
 		return NULL;
 	}
 
@@ -343,9 +339,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	bf = avp->av_bcbuf;
 	if (bf->bf_mpdu != NULL) {
 		skb = (struct sk_buff *)bf->bf_mpdu;
-		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
-				 skb->len,
-				 PCI_DMA_TODEVICE);
+		ath_unmap_single_to_device(sc, bf->bf_dmacontext, skb->len);
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 	}
@@ -402,14 +396,12 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 
 	bf->bf_mpdu = skb;
 	bf->bf_buf_addr = bf->bf_dmacontext =
-		pci_map_single(sc->pdev, skb->data,
-			       skb->len,
-			       PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_buf_addr))) {
+		ath_map_single_to_device(sc, skb->data, skb->len);
+	if (unlikely(ath_dma_mapping_error(sc, bf->bf_buf_addr))) {
 		dev_kfree_skb_any(skb);
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"pci_dma_mapping_error() on beacon alloc\n");
+			"dma_mapping_error() on beacon alloc\n");
 		return -ENOMEM;
 	}
 
@@ -429,9 +421,8 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 		bf = avp->av_bcbuf;
 		if (bf->bf_mpdu != NULL) {
 			struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
-			pci_unmap_single(sc->pdev, bf->bf_dmacontext,
-					 skb->len,
-					 PCI_DMA_TODEVICE);
+			ath_unmap_single_to_device(sc, bf->bf_dmacontext,
+						   skb->len);
 			dev_kfree_skb_any(skb);
 			bf->bf_mpdu = NULL;
 		}
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4ca2aed..de50e47 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -693,6 +693,33 @@ enum PROT_MODE {
 #define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
 #define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
 
+struct ath_bus_ops {
+	dma_addr_t	(*dma_map_single_to_device)(struct ath_softc *sc,
+						void *p,
+						size_t size);
+	void		(*dma_unmap_single_to_device)(struct ath_softc *sc,
+						      dma_addr_t da,
+						      size_t size);
+	dma_addr_t	(*dma_map_single_from_device)(struct ath_softc *sc,
+						      void *p,
+						      size_t size);
+	void		(*dma_unmap_single_from_device)(struct ath_softc *sc,
+							dma_addr_t da,
+							size_t size);
+	int		(*dma_mapping_error)(struct ath_softc *sc,
+					     dma_addr_t da);
+	void		(*dma_sync_single_for_cpu)(struct ath_softc *sc,
+						   dma_addr_t da,
+						   size_t size);
+	void		*(*dma_alloc)(struct ath_softc *sc,
+				      size_t size,
+				      dma_addr_t *pda);
+	void		(*dma_free)(struct ath_softc *sc,
+				    size_t size,
+				    void *p,
+				    dma_addr_t da);
+};
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct pci_dev *pdev;
@@ -744,6 +771,7 @@ struct ath_softc {
 #ifdef CONFIG_ATH9K_DEBUG
 	struct ath9k_debug sc_debug;
 #endif
+	struct ath_bus_ops *bus_ops;
 };
 
 int ath_reset(struct ath_softc *sc, bool retry_tx);
@@ -751,4 +779,51 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 
+static inline dma_addr_t ath_map_single_to_device(struct ath_softc *sc,
+						  void *p, size_t size)
+{
+	return sc->bus_ops->dma_map_single_to_device(sc, p, size);
+}
+
+static inline void ath_unmap_single_to_device(struct ath_softc *sc,
+					      dma_addr_t da, size_t size)
+{
+	sc->bus_ops->dma_unmap_single_to_device(sc, da, size);
+}
+
+static inline dma_addr_t ath_map_single_from_device(struct ath_softc *sc,
+						    void *p, size_t size)
+{
+	return sc->bus_ops->dma_map_single_from_device(sc, p, size);
+}
+
+static inline void ath_unmap_single_from_device(struct ath_softc *sc,
+						dma_addr_t da, size_t size)
+{
+	sc->bus_ops->dma_unmap_single_from_device(sc, da, size);
+}
+
+static inline int ath_dma_mapping_error(struct ath_softc *sc, dma_addr_t da)
+{
+	return sc->bus_ops->dma_mapping_error(sc, da);
+}
+
+static inline void ath_sync_single_for_cpu(struct ath_softc *sc, dma_addr_t da,
+					   size_t size)
+{
+	sc->bus_ops->dma_sync_single_for_cpu(sc, da, size);
+}
+
+static inline void *ath_dma_alloc(struct ath_softc *sc, size_t size,
+				  dma_addr_t *pda)
+{
+	return sc->bus_ops->dma_alloc(sc, size, pda);
+}
+
+static inline void ath_dma_free(struct ath_softc *sc, size_t size,
+				void *p, dma_addr_t da)
+{
+	sc->bus_ops->dma_free(sc, size, p, da);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 70affb7..62a0a5b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1722,9 +1722,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 
 	/* allocate descriptors */
-	dd->dd_desc = pci_alloc_consistent(sc->pdev,
-			      dd->dd_desc_len,
-			      &dd->dd_desc_paddr);
+	dd->dd_desc = ath_dma_alloc(sc, dd->dd_desc_len, &dd->dd_desc_paddr);
 	if (dd->dd_desc == NULL) {
 		error = -ENOMEM;
 		goto fail;
@@ -1770,8 +1768,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 	return 0;
 fail2:
-	pci_free_consistent(sc->pdev,
-		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
+	ath_dma_free(sc, dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
 fail:
 	memset(dd, 0, sizeof(*dd));
 	return error;
@@ -1784,8 +1781,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 			 struct ath_descdma *dd,
 			 struct list_head *head)
 {
-	pci_free_consistent(sc->pdev,
-		dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
+	ath_dma_free(sc, dd->dd_desc_len, dd->dd_desc, dd->dd_desc_paddr);
 
 	INIT_LIST_HEAD(head);
 	kfree(dd->dd_bufptr);
@@ -2551,6 +2547,66 @@ ath_rf_name(u16 rf_version)
 	return "????";
 }
 
+static dma_addr_t ath_pci_map_single_to_device(struct ath_softc *sc,
+					       void *p, size_t size)
+{
+	return pci_map_single(sc->pdev, p, size, PCI_DMA_TODEVICE);
+}
+
+static void ath_pci_unmap_single_to_device(struct ath_softc *sc,
+					   dma_addr_t da, size_t size)
+{
+	pci_unmap_single(sc->pdev, da, size, PCI_DMA_TODEVICE);
+}
+
+static dma_addr_t ath_pci_map_single_from_device(struct ath_softc *sc,
+						 void *p, size_t size)
+{
+	return pci_map_single(sc->pdev, p, size, PCI_DMA_FROMDEVICE);
+}
+
+static void ath_pci_unmap_single_from_device(struct ath_softc *sc,
+					     dma_addr_t da, size_t size)
+{
+	pci_unmap_single(sc->pdev, da, size, PCI_DMA_FROMDEVICE);
+}
+
+static int ath_pci_dma_mapping_error(struct ath_softc *sc, dma_addr_t da)
+{
+	return pci_dma_mapping_error(sc->pdev, da);
+}
+
+static void ath_pci_sync_single_for_cpu(struct ath_softc *sc, dma_addr_t da,
+				       size_t size)
+{
+	pci_dma_sync_single_for_cpu(sc->pdev, da, size,
+				    PCI_DMA_FROMDEVICE);
+}
+
+static void *ath_pci_dma_alloc(struct ath_softc *sc, size_t size,
+				       dma_addr_t *pda)
+{
+	return pci_alloc_consistent(sc->pdev, size, pda);
+}
+
+static void ath_pci_dma_free(struct ath_softc *sc, size_t size,
+				    void *p, dma_addr_t da)
+{
+	pci_free_consistent(sc->pdev, size, p, da);
+}
+
+static struct ath_bus_ops ath_pci_bus_ops  = {
+	.dma_map_single_to_device = ath_pci_map_single_to_device,
+	.dma_unmap_single_to_device = ath_pci_unmap_single_to_device,
+	.dma_map_single_from_device = ath_pci_map_single_from_device,
+	.dma_unmap_single_from_device = ath_pci_unmap_single_from_device,
+	.dma_map_single_to_device = ath_pci_map_single_to_device,
+	.dma_mapping_error = ath_pci_dma_mapping_error,
+	.dma_sync_single_for_cpu = ath_pci_sync_single_for_cpu,
+	.dma_alloc = ath_pci_dma_alloc,
+	.dma_free = ath_pci_dma_free,
+};
+
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
@@ -2639,6 +2695,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->hw = hw;
 	sc->pdev = pdev;
 	sc->mem = mem;
+	sc->bus_ops = &ath_pci_bus_ops;
 
 	if (ath_attach(id->device, sc) != 0) {
 		ret = -ENODEV;
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 462e08c..e135038 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -291,15 +291,14 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			}
 
 			bf->bf_mpdu = skb;
-			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
-							 sc->rx.bufsize,
-							 PCI_DMA_FROMDEVICE);
-			if (unlikely(pci_dma_mapping_error(sc->pdev,
-				  bf->bf_buf_addr))) {
+			bf->bf_buf_addr = ath_map_single_from_device(sc,
+						skb->data, sc->rx.bufsize);
+			if (unlikely(ath_dma_mapping_error(sc,
+						bf->bf_buf_addr))) {
 				dev_kfree_skb_any(skb);
 				bf->bf_mpdu = NULL;
 				DPRINTF(sc, ATH_DBG_CONFIG,
-					"pci_dma_mapping_error() on RX init\n");
+					"dma_mapping_error() on RX init\n");
 				error = -ENOMEM;
 				break;
 			}
@@ -524,9 +523,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 * 1. accessing the frame
 		 * 2. requeueing the same buffer to h/w
 		 */
-		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
-				sc->rx.bufsize,
-				PCI_DMA_FROMDEVICE);
+		ath_sync_single_for_cpu(sc, bf->bf_buf_addr, sc->rx.bufsize);
 
 		/*
 		 * If we're asked to flush receive queue, directly
@@ -557,9 +554,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			goto requeue;
 
 		/* Unmap the frame */
-		pci_unmap_single(sc->pdev, bf->bf_buf_addr,
-				 sc->rx.bufsize,
-				 PCI_DMA_FROMDEVICE);
+		ath_unmap_single_from_device(sc, bf->bf_buf_addr,
+					     sc->rx.bufsize);
 
 		skb_put(skb, ds->ds_rxstat.rs_datalen);
 		skb->protocol = cpu_to_be16(ETH_P_CONTROL);
@@ -599,15 +595,15 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 
 		/* We will now give hardware our shiny new allocated skb */
 		bf->bf_mpdu = requeue_skb;
-		bf->bf_buf_addr = pci_map_single(sc->pdev, requeue_skb->data,
-					 sc->rx.bufsize,
-					 PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(sc->pdev,
+		bf->bf_buf_addr = ath_map_single_from_device(sc,
+						requeue_skb->data,
+						sc->rx.bufsize);
+		if (unlikely(ath_dma_mapping_error(sc,
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
index c92f0c6..d238b02 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -340,10 +340,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 	}
 
 	/* Unmap this frame */
-	pci_unmap_single(sc->pdev,
-			 bf->bf_dmacontext,
-			 skb->len,
-			 PCI_DMA_TODEVICE);
+	ath_unmap_single_to_device(sc, bf->bf_dmacontext, skb->len);
 	/* complete this frame */
 	ath_tx_complete(sc, skb, &tx_status);
 
@@ -1713,12 +1710,11 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	/* DMA setup */
 	bf->bf_mpdu = skb;
 
-	bf->bf_dmacontext = pci_map_single(sc->pdev, skb->data,
-					   skb->len, PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(sc->pdev, bf->bf_dmacontext))) {
+	bf->bf_dmacontext = ath_map_single_to_device(sc, skb->data, skb->len);
+	if (unlikely(ath_dma_mapping_error(sc, bf->bf_dmacontext))) {
 		bf->bf_mpdu = NULL;
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"pci_dma_mapping_error() on TX\n");
+			"dma_mapping_error() on TX\n");
 		return -ENOMEM;
 	}
 
-- 
1.5.3.2

