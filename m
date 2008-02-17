Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:30440 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbYBQQfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:35:55 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1391418fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:35:54 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 03/11] rt2x00: Fix Descriptor DMA initialization
Date: Sun, 17 Feb 2008 17:33:24 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200802171733.25024.IvDoorn@gmail.com> (sfid-20080217_163611_440912_F85B16CE)
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As Adam Baker reported the DMA address for the
descriptor base was incorrectly initialized in
the PCI drivers.

Instead of the DMA base for the descriptor, the
DMA base for the data was passed resulting in a
broken TX/RX state for PCI drivers.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |   21 ++++++++++------
 drivers/net/wireless/rt2x00/rt2500pci.c |   18 +++++++++-----
 drivers/net/wireless/rt2x00/rt2x00pci.c |   38 +++++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2x00pci.h |    6 +++-
 drivers/net/wireless/rt2x00/rt61pci.c   |   21 +++++++++++-----
 5 files changed, 63 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 1e8586d..a80385d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -597,11 +597,12 @@ static void rt2400pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 	u32 word;
 
 	rt2x00_desc_read(priv_rx->desc, 2, &word);
-	rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH, entry->queue->data_size);
+	rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH,
+			   entry->queue->data_size);
 	rt2x00_desc_write(priv_rx->desc, 2, word);
 
 	rt2x00_desc_read(priv_rx->desc, 1, &word);
-	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, priv_rx->dma);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, priv_rx->data_dma);
 	rt2x00_desc_write(priv_rx->desc, 1, word);
 
 	rt2x00_desc_read(priv_rx->desc, 0, &word);
@@ -616,7 +617,7 @@ static void rt2400pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 	u32 word;
 
 	rt2x00_desc_read(priv_tx->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, priv_tx->dma);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, priv_tx->data_dma);
 	rt2x00_desc_write(priv_tx->desc, 1, word);
 
 	rt2x00_desc_read(priv_tx->desc, 2, &word);
@@ -648,22 +649,26 @@ static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_tx = rt2x00dev->tx[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR3, &reg);
-	rt2x00_set_field32(&reg, TXCSR3_TX_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR3_TX_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR3, reg);
 
 	priv_tx = rt2x00dev->tx[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR5, &reg);
-	rt2x00_set_field32(&reg, TXCSR5_PRIO_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR5_PRIO_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR5, reg);
 
 	priv_tx = rt2x00dev->bcn[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR4, &reg);
-	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR4, reg);
 
 	priv_tx = rt2x00dev->bcn[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR6, &reg);
-	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR6, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR1, &reg);
@@ -673,7 +678,7 @@ static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_rx = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RXCSR2, &reg);
-	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RXCSR2, reg);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index a44aed5..4a6a60a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -691,7 +691,7 @@ static void rt2500pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 	u32 word;
 
 	rt2x00_desc_read(priv_rx->desc, 1, &word);
-	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, priv_rx->dma);
+	rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS, priv_rx->data_dma);
 	rt2x00_desc_write(priv_rx->desc, 1, word);
 
 	rt2x00_desc_read(priv_rx->desc, 0, &word);
@@ -706,7 +706,7 @@ static void rt2500pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 	u32 word;
 
 	rt2x00_desc_read(priv_tx->desc, 1, &word);
-	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, priv_tx->dma);
+	rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, priv_tx->data_dma);
 	rt2x00_desc_write(priv_tx->desc, 1, word);
 
 	rt2x00_desc_read(priv_tx->desc, 0, &word);
@@ -733,22 +733,26 @@ static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_tx = rt2x00dev->tx[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR3, &reg);
-	rt2x00_set_field32(&reg, TXCSR3_TX_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR3_TX_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR3, reg);
 
 	priv_tx = rt2x00dev->tx[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR5, &reg);
-	rt2x00_set_field32(&reg, TXCSR5_PRIO_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR5_PRIO_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR5, reg);
 
 	priv_tx = rt2x00dev->bcn[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR4, &reg);
-	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR4, reg);
 
 	priv_tx = rt2x00dev->bcn[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR6, &reg);
-	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR6, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RXCSR1, &reg);
@@ -758,7 +762,7 @@ static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_rx = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RXCSR2, &reg);
-	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, RXCSR2_RX_RING_REGISTER, priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RXCSR2, reg);
 
 	return 0;
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 7d2f406..1960d93 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -218,40 +218,44 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
 	struct queue_entry_priv_pci_rx *priv_rx;
 	struct queue_entry_priv_pci_tx *priv_tx;
-	void *desc;
+	void *addr;
+	dma_addr_t dma;
+	void *desc_addr;
+	dma_addr_t desc_dma;
 	void *data_addr;
-	void *data;
 	dma_addr_t data_dma;
-	dma_addr_t dma;
 	unsigned int i;
 
 	/*
 	 * Allocate DMA memory for descriptor and buffer.
 	 */
-	data_addr = pci_alloc_consistent(pci_dev, dma_size(queue), &data_dma);
-	if (!data_addr)
+	addr = pci_alloc_consistent(pci_dev, dma_size(queue), &dma);
+	if (!addr)
 		return -ENOMEM;
 
-	memset(data_addr, 0, dma_size(queue));
+	memset(addr, 0, dma_size(queue));
 
 	/*
 	 * Initialize all queue entries to contain valid addresses.
 	 */
 	for (i = 0; i < queue->limit; i++) {
-		desc = desc_offset(queue, data_addr, i);
-		data = data_offset(queue, data_addr, i);
-		dma = data_offset(queue, data_dma, i);
+		desc_addr = desc_offset(queue, addr, i);
+		desc_dma = desc_offset(queue, dma, i);
+		data_addr = data_offset(queue, addr, i);
+		data_dma = data_offset(queue, dma, i);
 
 		if (queue->qid == QID_RX) {
 			priv_rx = queue->entries[i].priv_data;
-			priv_rx->desc = desc;
-			priv_rx->data = data;
-			priv_rx->dma = dma;
+			priv_rx->desc = desc_addr;
+			priv_rx->desc_dma = desc_dma;
+			priv_rx->data = data_addr;
+			priv_rx->data_dma = data_dma;
 		} else {
 			priv_tx = queue->entries[i].priv_data;
-			priv_tx->desc = desc;
-			priv_tx->data = data;
-			priv_tx->dma = dma;
+			priv_tx->desc = desc_addr;
+			priv_tx->desc_dma = desc_dma;
+			priv_tx->data = data_addr;
+			priv_tx->data_dma = data_dma;
 		}
 	}
 
@@ -270,13 +274,13 @@ static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
 	if (queue->qid == QID_RX) {
 		priv_rx = queue->entries[0].priv_data;
 		data_addr = priv_rx->data;
-		data_dma = priv_rx->dma;
+		data_dma = priv_rx->data_dma;
 
 		priv_rx->data = NULL;
 	} else {
 		priv_tx = queue->entries[0].priv_data;
 		data_addr = priv_tx->data;
-		data_dma = priv_tx->dma;
+		data_dma = priv_tx->data_dma;
 
 		priv_tx->data = NULL;
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.h b/drivers/net/wireless/rt2x00/rt2x00pci.h
index 8932b31..9d1cdb9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -103,9 +103,10 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
  */
 struct queue_entry_priv_pci_rx {
 	__le32 *desc;
+	dma_addr_t desc_dma;
 
 	void *data;
-	dma_addr_t dma;
+	dma_addr_t data_dma;
 };
 
 /**
@@ -118,9 +119,10 @@ struct queue_entry_priv_pci_rx {
  */
 struct queue_entry_priv_pci_tx {
 	__le32 *desc;
+	dma_addr_t desc_dma;
 
 	void *data;
-	dma_addr_t dma;
+	dma_addr_t data_dma;
 
 	struct ieee80211_tx_control control;
 };
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 80f0d30..a7aebb4 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -975,7 +975,8 @@ static void rt61pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 	u32 word;
 
 	rt2x00_desc_read(priv_rx->desc, 5, &word);
-	rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS, priv_rx->dma);
+	rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
+			   priv_rx->data_dma);
 	rt2x00_desc_write(priv_rx->desc, 5, word);
 
 	rt2x00_desc_read(priv_rx->desc, 0, &word);
@@ -999,7 +1000,8 @@ static void rt61pci_init_txentry(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(priv_tx->desc, 5, word);
 
 	rt2x00_desc_read(priv_tx->desc, 6, &word);
-	rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS, priv_tx->dma);
+	rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
+			   priv_tx->data_dma);
 	rt2x00_desc_write(priv_tx->desc, 6, word);
 
 	rt2x00_desc_read(priv_tx->desc, 0, &word);
@@ -1035,22 +1037,26 @@ static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_tx = rt2x00dev->tx[0].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC0_BASE_CSR, &reg);
-	rt2x00_set_field32(&reg, AC0_BASE_CSR_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, AC0_BASE_CSR_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC0_BASE_CSR, reg);
 
 	priv_tx = rt2x00dev->tx[1].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC1_BASE_CSR, &reg);
-	rt2x00_set_field32(&reg, AC1_BASE_CSR_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, AC1_BASE_CSR_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC1_BASE_CSR, reg);
 
 	priv_tx = rt2x00dev->tx[2].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC2_BASE_CSR, &reg);
-	rt2x00_set_field32(&reg, AC2_BASE_CSR_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, AC2_BASE_CSR_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC2_BASE_CSR, reg);
 
 	priv_tx = rt2x00dev->tx[3].entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, AC3_BASE_CSR, &reg);
-	rt2x00_set_field32(&reg, AC3_BASE_CSR_RING_REGISTER, priv_tx->dma);
+	rt2x00_set_field32(&reg, AC3_BASE_CSR_RING_REGISTER,
+			   priv_tx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, AC3_BASE_CSR, reg);
 
 	rt2x00pci_register_read(rt2x00dev, RX_RING_CSR, &reg);
@@ -1062,7 +1068,8 @@ static int rt61pci_init_queues(struct rt2x00_dev *rt2x00dev)
 
 	priv_rx = rt2x00dev->rx->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, RX_BASE_CSR, &reg);
-	rt2x00_set_field32(&reg, RX_BASE_CSR_RING_REGISTER, priv_rx->dma);
+	rt2x00_set_field32(&reg, RX_BASE_CSR_RING_REGISTER,
+			   priv_rx->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, RX_BASE_CSR, reg);
 
 	rt2x00pci_register_read(rt2x00dev, TX_DMA_DST_CSR, &reg);
-- 
1.5.4

