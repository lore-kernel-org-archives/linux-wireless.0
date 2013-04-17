Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:11630 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966146Ab3DQM3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:29:54 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 1/2] rt2x00: provide separate information about TXWI & RXWI sizes
Date: Wed, 17 Apr 2013 14:30:47 +0200
Message-Id: <1366201848-18009-2-git-send-email-stf_xl@wp.pl> (sfid-20130417_142958_024943_DCAB6413)
In-Reply-To: <1366201848-18009-1-git-send-email-stf_xl@wp.pl>
References: <1366201848-18009-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

On new 2800 hardware sizes of TXWI & RXIW can be different than TXD
& RXD sizes, so we need to difference between them. Let's define
winfo_size as size of in buffer descriptor (TXWI & RXWI), and desc_size
of as size of additional descriptor - in separate DMA coherent buffer
for PCI hardware (TXD & RXD) and yet another in buffer descriptor for
USB hardware (TXINFO & RXINFO).

Change is rt2x00 wild, but should affect only 2800 driver.

Patch also fix beaconing for 5592usb AP mode.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c   |   12 +++++++++---
 drivers/net/wireless/rt2x00/rt2800pci.c   |   10 ++++------
 drivers/net/wireless/rt2x00/rt2800usb.c   |   25 +++++++++++++------------
 drivers/net/wireless/rt2x00/rt2x00queue.c |    6 ++++--
 drivers/net/wireless/rt2x00/rt2x00queue.h |    6 ++++--
 5 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 211c9bc..5c20e98 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -676,6 +676,10 @@ void rt2800_process_rxwi(struct queue_entry *entry,
 	 * Convert descriptor AGC value to RSSI value.
 	 */
 	rxdesc->rssi = rt2800_agc_to_rssi(entry->queue->rt2x00dev, word);
+	/*
+	 * Remove RXWI descriptor from start of the buffer.
+	 */
+	skb_pull(entry->skb, entry->queue->winfo_size);
 }
 EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
 
@@ -766,6 +770,7 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	unsigned int beacon_base;
 	unsigned int padding_len;
 	u32 orig_reg, reg;
+	const int txwi_desc_size = entry->queue->winfo_size;
 
 	/*
 	 * Disable beaconing while we are reloading the beacon data,
@@ -779,14 +784,14 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	/*
 	 * Add space for the TXWI in front of the skb.
 	 */
-	memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
+	memset(skb_push(entry->skb, txwi_desc_size), 0, txwi_desc_size);
 
 	/*
 	 * Register descriptor details in skb frame descriptor.
 	 */
 	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
 	skbdesc->desc = entry->skb->data;
-	skbdesc->desc_len = TXWI_DESC_SIZE;
+	skbdesc->desc_len = txwi_desc_size;
 
 	/*
 	 * Add the TXWI for the beacon to the skb.
@@ -832,13 +837,14 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 						unsigned int beacon_base)
 {
 	int i;
+	const int txwi_desc_size = rt2x00dev->ops->bcn->winfo_size;
 
 	/*
 	 * For the Beacon base registers we only need to clear
 	 * the whole TXWI which (when set to 0) will invalidate
 	 * the entire beacon.
 	 */
-	for (i = 0; i < TXWI_DESC_SIZE; i += sizeof(__le32))
+	for (i = 0; i < txwi_desc_size; i += sizeof(__le32))
 		rt2800_register_write(rt2x00dev, beacon_base + i, 0);
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index def357e..d540ce9 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -735,11 +735,6 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	 * Process the RXWI structure that is at the start of the buffer.
 	 */
 	rt2800_process_rxwi(entry, rxdesc);
-
-	/*
-	 * Remove RXWI descriptor from start of buffer.
-	 */
-	skb_pull(entry->skb, RXWI_DESC_SIZE);
 }
 
 /*
@@ -1197,6 +1192,7 @@ static const struct data_queue_desc rt2800pci_queue_rx = {
 	.entry_num		= 128,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
+	.winfo_size		= RXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
@@ -1204,13 +1200,15 @@ static const struct data_queue_desc rt2800pci_queue_tx = {
 	.entry_num		= 64,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
+	.winfo_size		= TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
 static const struct data_queue_desc rt2800pci_queue_bcn = {
 	.entry_num		= 8,
 	.data_size		= 0, /* No DMA required for beacons */
-	.desc_size		= TXWI_DESC_SIZE,
+	.desc_size		= TXD_DESC_SIZE,
+	.winfo_size		= TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_mmio),
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f322820..0cb6bbe 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -485,7 +485,7 @@ static void rt2800usb_write_tx_desc(struct queue_entry *entry,
 	 */
 	skbdesc->flags |= SKBDESC_DESC_IN_SKB;
 	skbdesc->desc = txi;
-	skbdesc->desc_len = entry->queue->desc_size;
+	skbdesc->desc_len = TXINFO_DESC_SIZE + entry->queue->winfo_size;
 }
 
 /*
@@ -730,11 +730,6 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	 * Process the RXWI structure.
 	 */
 	rt2800_process_rxwi(entry, rxdesc);
-
-	/*
-	 * Remove RXWI descriptor from start of buffer.
-	 */
-	skb_pull(entry->skb, entry->queue->desc_size - RXINFO_DESC_SIZE);
 }
 
 /*
@@ -858,21 +853,24 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 static const struct data_queue_desc rt2800usb_queue_rx = {
 	.entry_num		= 128,
 	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= RXINFO_DESC_SIZE + RXWI_DESC_SIZE,
+	.desc_size		= RXINFO_DESC_SIZE,
+	.winfo_size		= RXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2800usb_queue_tx = {
 	.entry_num		= 16,
 	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
+	.desc_size		= TXINFO_DESC_SIZE,
+	.winfo_size		= TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2800usb_queue_bcn = {
 	.entry_num		= 8,
 	.data_size		= MGMT_FRAME_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
+	.desc_size		= TXINFO_DESC_SIZE,
+	.winfo_size		= TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
@@ -898,21 +896,24 @@ static const struct rt2x00_ops rt2800usb_ops = {
 static const struct data_queue_desc rt2800usb_queue_rx_5592 = {
 	.entry_num		= 128,
 	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= RXINFO_DESC_SIZE + RXWI_DESC_SIZE_5592,
+	.desc_size		= RXINFO_DESC_SIZE,
+	.winfo_size		= RXWI_DESC_SIZE_5592,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2800usb_queue_tx_5592 = {
 	.entry_num		= 16,
 	.data_size		= AGGREGATION_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
+	.desc_size		= TXINFO_DESC_SIZE,
+	.winfo_size		= TXWI_DESC_SIZE_5592,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2800usb_queue_bcn_5592 = {
 	.entry_num		= 8,
 	.data_size		= MGMT_FRAME_SIZE,
-	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE_5592,
+	.desc_size		= TXINFO_DESC_SIZE,
+	.winfo_size		= TXWI_DESC_SIZE_5592,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 952a049..d2f894e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -35,7 +35,8 @@
 
 struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 {
-	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct data_queue *queue = entry->queue;
+	struct rt2x00_dev *rt2x00dev = queue->rt2x00dev;
 	struct sk_buff *skb;
 	struct skb_frame_desc *skbdesc;
 	unsigned int frame_size;
@@ -46,7 +47,7 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct queue_entry *entry, gfp_t gfp)
 	 * The frame size includes descriptor size, because the
 	 * hardware directly receive the frame into the skbuffer.
 	 */
-	frame_size = entry->queue->data_size + entry->queue->desc_size;
+	frame_size = queue->data_size + queue->desc_size + queue->winfo_size;
 
 	/*
 	 * The payload should be aligned to a 4-byte boundary,
@@ -1172,6 +1173,7 @@ static int rt2x00queue_alloc_entries(struct data_queue *queue,
 	queue->threshold = DIV_ROUND_UP(qdesc->entry_num, 10);
 	queue->data_size = qdesc->data_size;
 	queue->desc_size = qdesc->desc_size;
+	queue->winfo_size = qdesc->winfo_size;
 
 	/*
 	 * Allocate all queue entries.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 3d01371..4a7b34e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -479,7 +479,8 @@ struct data_queue {
 	unsigned short cw_max;
 
 	unsigned short data_size;
-	unsigned short desc_size;
+	unsigned char  desc_size;
+	unsigned char  winfo_size;
 
 	unsigned short usb_endpoint;
 	unsigned short usb_maxpacket;
@@ -499,7 +500,8 @@ struct data_queue {
 struct data_queue_desc {
 	unsigned short entry_num;
 	unsigned short data_size;
-	unsigned short desc_size;
+	unsigned char  desc_size;
+	unsigned char  winfo_size;
 	unsigned short priv_size;
 };
 
-- 
1.7.4.4

