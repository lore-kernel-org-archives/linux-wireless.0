Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35605 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab1CCStO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 13:49:14 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1356532wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 10:49:13 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/19] rt2x00: Don't treat ATIM queue as second beacon queue.
Date: Thu, 3 Mar 2011 19:46:09 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201103031938.56423.IvDoorn@gmail.com> <201103031945.17614.IvDoorn@gmail.com> <201103031945.40473.IvDoorn@gmail.com>
In-Reply-To: <201103031945.40473.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103031946.09972.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gertjan van Wingerde <gwingerde@gmail.com>

Current code for the atim queue is strange, as it is considered in the
rt2x00_dev structure as a second beacon queue.
Normalize this by letting the atim queue have its own struct data_queue
pointer in the rt2x00_dev structure.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    6 +++---
 drivers/net/wireless/rt2x00/rt2500pci.c   |    6 +++---
 drivers/net/wireless/rt2x00/rt2x00.h      |    5 ++---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   19 ++++++++-----------
 4 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 80f4988..d78d39e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -779,7 +779,7 @@ static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, TXCSR2, &reg);
 	rt2x00_set_field32(&reg, TXCSR2_TXD_SIZE, rt2x00dev->tx[0].desc_size);
 	rt2x00_set_field32(&reg, TXCSR2_NUM_TXD, rt2x00dev->tx[1].limit);
-	rt2x00_set_field32(&reg, TXCSR2_NUM_ATIM, rt2x00dev->bcn[1].limit);
+	rt2x00_set_field32(&reg, TXCSR2_NUM_ATIM, rt2x00dev->atim->limit);
 	rt2x00_set_field32(&reg, TXCSR2_NUM_PRIO, rt2x00dev->tx[0].limit);
 	rt2x00pci_register_write(rt2x00dev, TXCSR2, reg);
 
@@ -795,13 +795,13 @@ static int rt2400pci_init_queues(struct rt2x00_dev *rt2x00dev)
 			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR5, reg);
 
-	entry_priv = rt2x00dev->bcn[1].entries[0].priv_data;
+	entry_priv = rt2x00dev->atim->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR4, &reg);
 	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER,
 			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR4, reg);
 
-	entry_priv = rt2x00dev->bcn[0].entries[0].priv_data;
+	entry_priv = rt2x00dev->bcn->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR6, &reg);
 	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER,
 			   entry_priv->desc_dma);
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 635f804..3fb0915 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -865,7 +865,7 @@ static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 	rt2x00pci_register_read(rt2x00dev, TXCSR2, &reg);
 	rt2x00_set_field32(&reg, TXCSR2_TXD_SIZE, rt2x00dev->tx[0].desc_size);
 	rt2x00_set_field32(&reg, TXCSR2_NUM_TXD, rt2x00dev->tx[1].limit);
-	rt2x00_set_field32(&reg, TXCSR2_NUM_ATIM, rt2x00dev->bcn[1].limit);
+	rt2x00_set_field32(&reg, TXCSR2_NUM_ATIM, rt2x00dev->atim->limit);
 	rt2x00_set_field32(&reg, TXCSR2_NUM_PRIO, rt2x00dev->tx[0].limit);
 	rt2x00pci_register_write(rt2x00dev, TXCSR2, reg);
 
@@ -881,13 +881,13 @@ static int rt2500pci_init_queues(struct rt2x00_dev *rt2x00dev)
 			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR5, reg);
 
-	entry_priv = rt2x00dev->bcn[1].entries[0].priv_data;
+	entry_priv = rt2x00dev->atim->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR4, &reg);
 	rt2x00_set_field32(&reg, TXCSR4_ATIM_RING_REGISTER,
 			   entry_priv->desc_dma);
 	rt2x00pci_register_write(rt2x00dev, TXCSR4, reg);
 
-	entry_priv = rt2x00dev->bcn[0].entries[0].priv_data;
+	entry_priv = rt2x00dev->bcn->entries[0].priv_data;
 	rt2x00pci_register_read(rt2x00dev, TXCSR6, &reg);
 	rt2x00_set_field32(&reg, TXCSR6_BEACON_RING_REGISTER,
 			   entry_priv->desc_dma);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d5faeb1..89a0b45 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -887,14 +887,13 @@ struct rt2x00_dev {
 	struct work_struct txdone_work;
 
 	/*
-	 * Data queue arrays for RX, TX and Beacon.
-	 * The Beacon array also contains the Atim queue
-	 * if that is supported by the device.
+	 * Data queue arrays for RX, TX, Beacon and ATIM.
 	 */
 	unsigned int data_queues;
 	struct data_queue *rx;
 	struct data_queue *tx;
 	struct data_queue *bcn;
+	struct data_queue *atim;
 
 	/*
 	 * Firmware image.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f06b5c7..fcaacc6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -708,21 +708,17 @@ EXPORT_SYMBOL_GPL(rt2x00queue_for_each_entry);
 struct data_queue *rt2x00queue_get_queue(struct rt2x00_dev *rt2x00dev,
 					 const enum data_queue_qid queue)
 {
-	int atim = test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags);
-
 	if (queue == QID_RX)
 		return rt2x00dev->rx;
 
 	if (queue < rt2x00dev->ops->tx_queues && rt2x00dev->tx)
 		return &rt2x00dev->tx[queue];
 
-	if (!rt2x00dev->bcn)
-		return NULL;
-
 	if (queue == QID_BEACON)
-		return &rt2x00dev->bcn[0];
-	else if (queue == QID_ATIM && atim)
-		return &rt2x00dev->bcn[1];
+		return rt2x00dev->bcn;
+
+	if (queue == QID_ATIM)
+		return rt2x00dev->atim;
 
 	return NULL;
 }
@@ -1103,7 +1099,7 @@ int rt2x00queue_initialize(struct rt2x00_dev *rt2x00dev)
 		goto exit;
 
 	if (test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags)) {
-		status = rt2x00queue_alloc_entries(&rt2x00dev->bcn[1],
+		status = rt2x00queue_alloc_entries(rt2x00dev->atim,
 						   rt2x00dev->ops->atim);
 		if (status)
 			goto exit;
@@ -1177,6 +1173,7 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->rx = queue;
 	rt2x00dev->tx = &queue[1];
 	rt2x00dev->bcn = &queue[1 + rt2x00dev->ops->tx_queues];
+	rt2x00dev->atim = req_atim ? &queue[2 + rt2x00dev->ops->tx_queues] : NULL;
 
 	/*
 	 * Initialize queue parameters.
@@ -1193,9 +1190,9 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
 	tx_queue_for_each(rt2x00dev, queue)
 		rt2x00queue_init(rt2x00dev, queue, qid++);
 
-	rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[0], QID_BEACON);
+	rt2x00queue_init(rt2x00dev, rt2x00dev->bcn, QID_BEACON);
 	if (req_atim)
-		rt2x00queue_init(rt2x00dev, &rt2x00dev->bcn[1], QID_ATIM);
+		rt2x00queue_init(rt2x00dev, rt2x00dev->atim, QID_ATIM);
 
 	return 0;
 }
-- 
1.7.2.3

