Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:34552 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYBJVsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:48:31 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4237858fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:48:30 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 01/14] rt2x00: Fix invalid DMA free
Date: Sun, 10 Feb 2008 22:46:52 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102246.52441.IvDoorn@gmail.com> (sfid-20080210_214834_945620_DC453928)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Be more strict when using the queue_entry_priv_pci_rx
and queue_entry_priv_pci_tx structures. Only use a
particular type that matches the queue type.

When freeing the DMA the priv_tx->data and priv_tx->dma
was used. This is incorrect since the start of the DMA
was in fact the priv_tx->desc pointer. Instead of
recalculating the dma_addr_t for the DMA start this
patch will swap the data and descriptor part of the
allocated memory.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00pci.c |   85 ++++++++++++++++++++++---------
 1 files changed, 60 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 275c8a1..238f1c1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -186,38 +186,44 @@ EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
 /*
  * Device initialization handlers.
  */
-#define dma_size(__queue)				\
-({							\
-	(__queue)->limit *				\
-	    ((__queue)->desc_size + (__queue)->data_size);\
+#define desc_size(__queue)			\
+({						\
+	 ((__queue)->limit * (__queue)->desc_size);\
 })
 
-#define priv_offset(__queue, __base, __i)		\
-({							\
-	(__base) + ((__i) * (__queue)->desc_size);	\
+#define data_size(__queue)			\
+({						\
+	 ((__queue)->limit * (__queue)->data_size);\
 })
 
-#define data_addr_offset(__queue, __base, __i)		\
-({							\
-	(__base) +					\
-	    ((__queue)->limit * (__queue)->desc_size) +	\
-	    ((__i) * (__queue)->data_size);		\
+#define dma_size(__queue)			\
+({						\
+	data_size(__queue) + desc_size(__queue);\
 })
 
-#define data_dma_offset(__queue, __base, __i)		\
-({							\
-	(__base) +					\
-	    ((__queue)->limit * (__queue)->desc_size) +	\
-	    ((__i) * (__queue)->data_size);		\
+#define desc_offset(__queue, __base, __i)	\
+({						\
+	(__base) + data_size(__queue) + 	\
+	    ((__i) * (__queue)->desc_size);	\
+})
+
+#define data_offset(__queue, __base, __i)	\
+({						\
+	(__base) +				\
+	    ((__i) * (__queue)->data_size);	\
 })
 
 static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 				     struct data_queue *queue)
 {
 	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
+	struct queue_entry_priv_pci_rx *priv_rx;
 	struct queue_entry_priv_pci_tx *priv_tx;
+	void *desc;
 	void *data_addr;
+	void *data;
 	dma_addr_t data_dma;
+	dma_addr_t dma;
 	unsigned int i;
 
 	/*
@@ -227,14 +233,27 @@ static int rt2x00pci_alloc_queue_dma(struct rt2x00_dev *rt2x00dev,
 	if (!data_addr)
 		return -ENOMEM;
 
+	memset(data_addr, 0, dma_size(queue));
+
 	/*
 	 * Initialize all queue entries to contain valid addresses.
 	 */
 	for (i = 0; i < queue->limit; i++) {
-		priv_tx = queue->entries[i].priv_data;
-		priv_tx->desc = priv_offset(queue, data_addr, i);
-		priv_tx->data = data_addr_offset(queue, data_addr, i);
-		priv_tx->dma = data_dma_offset(queue, data_dma, i);
+		desc = desc_offset(queue, data_addr, i);
+		data = data_offset(queue, data_addr, i);
+		dma = data_offset(queue, data_dma, i);
+
+		if (queue->qid == QID_RX) {
+			priv_rx = queue->entries[i].priv_data;
+			priv_rx->desc = desc;
+			priv_rx->data = data;
+			priv_rx->dma = dma;
+		} else {
+			priv_tx = queue->entries[i].priv_data;
+			priv_tx->desc = desc;
+			priv_tx->data = data;
+			priv_tx->dma = dma;
+		}
 	}
 
 	return 0;
@@ -244,12 +263,28 @@ static void rt2x00pci_free_queue_dma(struct rt2x00_dev *rt2x00dev,
 				     struct data_queue *queue)
 {
 	struct pci_dev *pci_dev = rt2x00dev_pci(rt2x00dev);
-	struct queue_entry_priv_pci_tx *priv_tx = queue->entries[0].priv_data;
+	struct queue_entry_priv_pci_rx *priv_rx;
+	struct queue_entry_priv_pci_tx *priv_tx;
+	void *data_addr;
+	dma_addr_t data_dma;
+
+	if (queue->qid == QID_RX) {
+		priv_rx = queue->entries[0].priv_data;
+		data_addr = priv_rx->data;
+		data_dma = priv_rx->dma;
+
+		priv_rx->data = NULL;
+	} else {
+		priv_tx = queue->entries[0].priv_data;
+		data_addr = priv_tx->data;
+		data_dma = priv_tx->dma;
+
+		priv_tx->data = NULL;
+	}
 
-	if (priv_tx->data)
+	if (data_addr)
 		pci_free_consistent(pci_dev, dma_size(queue),
-				    priv_tx->data, priv_tx->dma);
-	priv_tx->data = NULL;
+				    data_addr, data_dma);
 }
 
 int rt2x00pci_initialize(struct rt2x00_dev *rt2x00dev)
-- 
1.5.4

