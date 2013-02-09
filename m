Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:52446 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760542Ab3BICWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 21:22:48 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: separate ring initialization and ring creation routines
Date: Fri,  8 Feb 2013 18:18:07 -0800
Message-Id: <1360376289-14861-3-git-send-email-bzhao@marvell.com> (sfid-20130209_032529_422796_FF5C80AB)
In-Reply-To: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
References: <1360376289-14861-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch separates PCIe ring initialization from ring creation
routines. This modularizes ring creation(TXBD, RXBD and event
rings) functions.

Readability has been improved while moving the code around.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c |  327 +++++++++++++++++++++--------------
 1 files changed, 194 insertions(+), 133 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 29c539b..06aae55 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -372,13 +372,199 @@ static int mwifiex_pcie_enable_host_int(struct mwifiex_adapter *adapter)
 }
 
 /*
- * This function creates buffer descriptor ring for TX
+ * This function initializes TX buffer ring descriptors
+ */
+static int mwifiex_init_txq_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct mwifiex_pcie_buf_desc *desc;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		card->tx_buf_list[i] = NULL;
+		card->txbd_ring[i] = (void *)(card->txbd_ring_vbase +
+				     (sizeof(*desc) * i));
+		desc = card->txbd_ring[i];
+		memset(desc, 0, sizeof(*desc));
+	}
+
+	return 0;
+}
+
+/* This function initializes RX buffer ring descriptors. Each SKB is allocated
+ * here and after mapping PCI memory, its physical address is assigned to
+ * PCIE Rx buffer descriptor's physical address.
+ */
+static int mwifiex_init_rxq_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
+	struct mwifiex_pcie_buf_desc *desc;
+	dma_addr_t buf_pa;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		/* Allocate skb here so that firmware can DMA data from it */
+		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
+		if (!skb) {
+			dev_err(adapter->dev,
+				"Unable to allocate skb for RX ring.\n");
+			kfree(card->rxbd_ring_vbase);
+			return -ENOMEM;
+		}
+
+		if (mwifiex_map_pci_memory(adapter, skb,
+					   MWIFIEX_RX_DATA_BUF_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
+
+		dev_dbg(adapter->dev,
+			"info: RX ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
+			skb, skb->len, skb->data, (u32)buf_pa,
+			(u32)((u64)buf_pa >> 32));
+
+		card->rx_buf_list[i] = skb;
+		card->rxbd_ring[i] = (void *)(card->rxbd_ring_vbase +
+				     (sizeof(*desc) * i));
+		desc = card->rxbd_ring[i];
+		desc->paddr = buf_pa;
+		desc->len = (u16)skb->len;
+		desc->flags = 0;
+	}
+
+	return 0;
+}
+
+/* This function initializes event buffer ring descriptors. Each SKB is
+ * allocated here and after mapping PCI memory, its physical address is assigned
+ * to PCIE Rx buffer descriptor's physical address
+ */
+static int mwifiex_pcie_init_evt_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct mwifiex_pcie_buf_desc *desc;
+	struct sk_buff *skb;
+	dma_addr_t buf_pa;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
+		/* Allocate skb here so that firmware can DMA data from it */
+		skb = dev_alloc_skb(MAX_EVENT_SIZE);
+		if (!skb) {
+			dev_err(adapter->dev,
+				"Unable to allocate skb for EVENT buf.\n");
+			kfree(card->evtbd_ring_vbase);
+			return -ENOMEM;
+		}
+		skb_put(skb, MAX_EVENT_SIZE);
+
+		if (mwifiex_map_pci_memory(adapter, skb, MAX_EVENT_SIZE,
+					   PCI_DMA_FROMDEVICE))
+			return -1;
+
+		MWIFIEX_SKB_PACB(skb, &buf_pa);
+
+		dev_dbg(adapter->dev,
+			"info: EVT ring: skb=%p len=%d data=%p buf_pa=%#x:%x\n",
+			skb, skb->len, skb->data, (u32)buf_pa,
+			(u32)((u64)buf_pa >> 32));
+
+		card->evt_buf_list[i] = skb;
+		card->evtbd_ring[i] = (void *)(card->evtbd_ring_vbase +
+				      (sizeof(*desc) * i));
+
+		desc = card->evtbd_ring[i];
+		desc->paddr = buf_pa;
+		desc->len = (u16)skb->len;
+		desc->flags = 0;
+	}
+
+	return 0;
+}
+
+/* This function cleans up TX buffer rings. If any of the buffer list has valid
+ * SKB address, associated SKB is freed.
+ */
+static void mwifiex_cleanup_txq_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct sk_buff *skb;
+	struct mwifiex_pcie_buf_desc *desc;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		desc = card->txbd_ring[i];
+		if (card->tx_buf_list[i]) {
+			skb = card->tx_buf_list[i];
+			pci_unmap_single(card->dev, desc->paddr, skb->len,
+					 PCI_DMA_TODEVICE);
+			dev_kfree_skb_any(skb);
+		}
+		card->tx_buf_list[i] = NULL;
+		memset(desc, 0, sizeof(*desc));
+	}
+
+	return;
+}
+
+/* This function cleans up RX buffer rings. If any of the buffer list has valid
+ * SKB address, associated SKB is freed.
+ */
+static void mwifiex_cleanup_rxq_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct mwifiex_pcie_buf_desc *desc;
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
+		desc = card->rxbd_ring[i];
+		if (card->rx_buf_list[i]) {
+			skb = card->rx_buf_list[i];
+			pci_unmap_single(card->dev, desc->paddr,
+					 MWIFIEX_RX_DATA_BUF_SIZE,
+					 PCI_DMA_FROMDEVICE);
+			dev_kfree_skb_any(skb);
+		}
+		memset(desc, 0, sizeof(*desc));
+	}
+
+	return;
+}
+
+/* This function cleans up event buffer rings. If any of the buffer list has
+ * valid SKB address, associated SKB is freed.
+ */
+static void mwifiex_cleanup_evt_ring(struct mwifiex_adapter *adapter)
+{
+	struct pcie_service_card *card = adapter->card;
+	struct mwifiex_pcie_buf_desc *desc;
+	struct sk_buff *skb;
+	int i;
+
+	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
+		desc = card->evtbd_ring[i];
+		if (card->evt_buf_list[i]) {
+			skb = card->evt_buf_list[i];
+			pci_unmap_single(card->dev, desc->paddr, MAX_EVENT_SIZE,
+					 PCI_DMA_FROMDEVICE);
+			dev_kfree_skb_any(skb);
+		}
+		card->evt_buf_list[i] = NULL;
+		memset(desc, 0, sizeof(*desc));
+	}
+
+	return;
+}
+
+/* This function creates buffer descriptor ring for TX
  */
 static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	int i;
 
 	/*
 	 * driver maintaines the write pointer and firmware maintaines the read
@@ -408,41 +594,15 @@ static int mwifiex_pcie_create_txbd_ring(struct mwifiex_adapter *adapter)
 		card->txbd_ring_vbase, (unsigned int)card->txbd_ring_pbase,
 		(u32)((u64)card->txbd_ring_pbase >> 32), card->txbd_ring_size);
 
-	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		card->txbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
-				     (card->txbd_ring_vbase +
-				      (sizeof(struct mwifiex_pcie_buf_desc)
-				       * i));
-
-		card->tx_buf_list[i] = NULL;
-		card->txbd_ring[i]->paddr = 0;
-		card->txbd_ring[i]->len = 0;
-		card->txbd_ring[i]->flags = 0;
-	}
-
-	return 0;
+	return mwifiex_init_txq_ring(adapter);
 }
 
 static int mwifiex_pcie_delete_txbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	struct sk_buff *skb;
-	int i;
 
-	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		if (card->tx_buf_list[i]) {
-			skb = card->tx_buf_list[i];
-			pci_unmap_single(card->dev, card->txbd_ring[i]->paddr,
-					 skb->len, PCI_DMA_TODEVICE);
-			dev_kfree_skb_any(skb);
-		}
-		card->tx_buf_list[i] = NULL;
-		card->txbd_ring[i]->paddr = 0;
-		card->txbd_ring[i]->len = 0;
-		card->txbd_ring[i]->flags = 0;
-		card->txbd_ring[i] = NULL;
-	}
+	mwifiex_cleanup_txq_ring(adapter);
 
 	if (card->txbd_ring_vbase)
 		pci_free_consistent(card->dev, card->txbd_ring_size,
@@ -464,9 +624,6 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	struct sk_buff *skb;
-	int i;
-	dma_addr_t buf_pa;
 
 	/*
 	 * driver maintaines the read pointer and firmware maintaines the write
@@ -496,39 +653,7 @@ static int mwifiex_pcie_create_rxbd_ring(struct mwifiex_adapter *adapter)
 		(u32)((u64)card->rxbd_ring_pbase >> 32),
 		card->rxbd_ring_size);
 
-	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		card->rxbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
-				     (card->rxbd_ring_vbase +
-				      (sizeof(struct mwifiex_pcie_buf_desc)
-				       * i));
-
-		/* Allocate skb here so that firmware can DMA data from it */
-		skb = dev_alloc_skb(MWIFIEX_RX_DATA_BUF_SIZE);
-		if (!skb) {
-			dev_err(adapter->dev,
-				"Unable to allocate skb for RX ring.\n");
-			kfree(card->rxbd_ring_vbase);
-			return -ENOMEM;
-		}
-		if (mwifiex_map_pci_memory(adapter, skb,
-					   MWIFIEX_RX_DATA_BUF_SIZE,
-					   PCI_DMA_FROMDEVICE))
-			return -1;
-
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
-
-		dev_dbg(adapter->dev, "info: RX ring: add new skb base: %p, "
-			"buf_base: %p, buf_pbase: %#x:%x, buf_len: %#x\n",
-			skb, skb->data, (u32)buf_pa, (u32)((u64)buf_pa >> 32),
-			skb->len);
-
-		card->rx_buf_list[i] = skb;
-		card->rxbd_ring[i]->paddr = buf_pa;
-		card->rxbd_ring[i]->len = (u16)skb->len;
-		card->rxbd_ring[i]->flags = 0;
-	}
-
-	return 0;
+	return mwifiex_init_rxq_ring(adapter);
 }
 
 /*
@@ -538,23 +663,8 @@ static int mwifiex_pcie_delete_rxbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	struct sk_buff *skb;
-	int i;
 
-	for (i = 0; i < MWIFIEX_MAX_TXRX_BD; i++) {
-		if (card->rx_buf_list[i]) {
-			skb = card->rx_buf_list[i];
-			pci_unmap_single(card->dev, card->rxbd_ring[i]->paddr ,
-					 MWIFIEX_RX_DATA_BUF_SIZE,
-					 PCI_DMA_FROMDEVICE);
-			dev_kfree_skb_any(skb);
-		}
-		card->rx_buf_list[i] = NULL;
-		card->rxbd_ring[i]->paddr = 0;
-		card->rxbd_ring[i]->len = 0;
-		card->rxbd_ring[i]->flags = 0;
-		card->rxbd_ring[i] = NULL;
-	}
+	mwifiex_cleanup_rxq_ring(adapter);
 
 	if (card->rxbd_ring_vbase)
 		pci_free_consistent(card->dev, card->rxbd_ring_size,
@@ -576,9 +686,6 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	struct sk_buff *skb;
-	int i;
-	dma_addr_t buf_pa;
 
 	/*
 	 * driver maintaines the read pointer and firmware maintaines the write
@@ -608,39 +715,7 @@ static int mwifiex_pcie_create_evtbd_ring(struct mwifiex_adapter *adapter)
 		(u32)((u64)card->evtbd_ring_pbase >> 32),
 		card->evtbd_ring_size);
 
-	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
-		card->evtbd_ring[i] = (struct mwifiex_pcie_buf_desc *)
-				      (card->evtbd_ring_vbase +
-				       (sizeof(struct mwifiex_pcie_buf_desc)
-					* i));
-
-		/* Allocate skb here so that firmware can DMA data from it */
-		skb = dev_alloc_skb(MAX_EVENT_SIZE);
-		if (!skb) {
-			dev_err(adapter->dev,
-				"Unable to allocate skb for EVENT buf.\n");
-			kfree(card->evtbd_ring_vbase);
-			return -ENOMEM;
-		}
-		skb_put(skb, MAX_EVENT_SIZE);
-
-		if (mwifiex_map_pci_memory(adapter, skb, MAX_EVENT_SIZE,
-					   PCI_DMA_FROMDEVICE))
-			return -1;
-
-		MWIFIEX_SKB_PACB(skb, &buf_pa);
-		dev_dbg(adapter->dev, "info: Evt ring: add new skb. base: %p, "
-			"buf_base: %p, buf_pbase: %#x:%x, buf_len: %#x\n",
-			skb, skb->data, (u32)buf_pa, (u32)((u64)buf_pa >> 32),
-			skb->len);
-
-		card->evt_buf_list[i] = skb;
-		card->evtbd_ring[i]->paddr = buf_pa;
-		card->evtbd_ring[i]->len = (u16)skb->len;
-		card->evtbd_ring[i]->flags = 0;
-	}
-
-	return 0;
+	return mwifiex_pcie_init_evt_ring(adapter);
 }
 
 /*
@@ -650,22 +725,8 @@ static int mwifiex_pcie_delete_evtbd_ring(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *reg = card->pcie.reg;
-	struct sk_buff *skb;
-	int i;
 
-	for (i = 0; i < MWIFIEX_MAX_EVT_BD; i++) {
-		if (card->evt_buf_list[i]) {
-			skb = card->evt_buf_list[i];
-			pci_unmap_single(card->dev, card->evtbd_ring[i]->paddr,
-					 MAX_EVENT_SIZE, PCI_DMA_FROMDEVICE);
-			dev_kfree_skb_any(skb);
-		}
-		card->evt_buf_list[i] = NULL;
-		card->evtbd_ring[i]->paddr = 0;
-		card->evtbd_ring[i]->len = 0;
-		card->evtbd_ring[i]->flags = 0;
-		card->evtbd_ring[i] = NULL;
-	}
+	mwifiex_cleanup_evt_ring(adapter);
 
 	if (card->evtbd_ring_vbase)
 		pci_free_consistent(card->dev, card->evtbd_ring_size,
-- 
1.7.0.2

