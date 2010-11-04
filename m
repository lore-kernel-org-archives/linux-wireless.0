Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0KDTnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:43:40 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1320245eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:43:39 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 02/13] rt2x00: Sync Tx and RX ring sizes with legacy drivers
Date: Thu, 4 Nov 2010 20:37:22 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
References: <201011042037.00178.IvDoorn@gmail.com>
In-Reply-To: <201011042037.00178.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011042037.23442.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

All rt2x00 devices used the same Tx and Rx ring size (24 entries) till
now. Newer devices (like rt2800) can however make use of a larger TX and
RX ring due to 11n capabilities (AMPDUs of size 64 for example).

Hence, bring rt2x00 in sync with the legacy drivers and use the same TX
and RX ring sizes. Also remove the global defines RX_ENTRIES, TX_ENTRIES,
BEACON_ENTRIES and ATIM_ENTRIES and use per driver values.

That is 24 entries for rt2400pci, 32 entries for rt2500pci, rt2500usb,
rt61pci and rt73usb and 128 (RX) and 64 (TX) for rt2800pci and rt2800usb.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c   |    8 ++++----
 drivers/net/wireless/rt2x00/rt2500pci.c   |    8 ++++----
 drivers/net/wireless/rt2x00/rt2500usb.c   |    8 ++++----
 drivers/net/wireless/rt2x00/rt2800lib.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2800pci.c   |    8 ++++----
 drivers/net/wireless/rt2x00/rt2800usb.c   |    9 +++++----
 drivers/net/wireless/rt2x00/rt2x00queue.h |   16 ----------------
 drivers/net/wireless/rt2x00/rt61pci.c     |    8 ++++----
 drivers/net/wireless/rt2x00/rt73usb.c     |    6 +++---
 9 files changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4f420a9..c94aa1e 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1640,28 +1640,28 @@ static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
 };
 
 static const struct data_queue_desc rt2400pci_queue_rx = {
-	.entry_num		= RX_ENTRIES,
+	.entry_num		= 24,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2400pci_queue_tx = {
-	.entry_num		= TX_ENTRIES,
+	.entry_num		= 24,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2400pci_queue_bcn = {
-	.entry_num		= BEACON_ENTRIES,
+	.entry_num		= 1,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2400pci_queue_atim = {
-	.entry_num		= ATIM_ENTRIES,
+	.entry_num		= 8,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 97feb7a..ab6c9ec 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1937,28 +1937,28 @@ static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
 };
 
 static const struct data_queue_desc rt2500pci_queue_rx = {
-	.entry_num		= RX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2500pci_queue_tx = {
-	.entry_num		= TX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2500pci_queue_bcn = {
-	.entry_num		= BEACON_ENTRIES,
+	.entry_num		= 1,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2500pci_queue_atim = {
-	.entry_num		= ATIM_ENTRIES,
+	.entry_num		= 8,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 93e44c7..725ae34 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1829,28 +1829,28 @@ static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
 };
 
 static const struct data_queue_desc rt2500usb_queue_rx = {
-	.entry_num		= RX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2500usb_queue_tx = {
-	.entry_num		= TX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2500usb_queue_bcn = {
-	.entry_num		= BEACON_ENTRIES,
+	.entry_num		= 1,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb_bcn),
 };
 
 static const struct data_queue_desc rt2500usb_queue_atim = {
-	.entry_num		= ATIM_ENTRIES,
+	.entry_num		= 8,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 54bf085..b1738bb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -727,7 +727,7 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 	 * that the TX_STA_FIFO stack has a size of 16. We stick to our
 	 * tx ring size for now.
 	 */
-	for (i = 0; i < TX_ENTRIES; i++) {
+	for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
 		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &reg);
 		if (!rt2x00_get_field32(reg, TX_STA_FIFO_VALID))
 			break;
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b267395..2c12b59 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -777,7 +777,7 @@ static void rt2800pci_txstatus_interrupt(struct rt2x00_dev *rt2x00dev)
 	 * Since we have only one producer and one consumer we don't
 	 * need to lock the kfifo.
 	 */
-	for (i = 0; i < TX_ENTRIES; i++) {
+	for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
 		rt2800_register_read(rt2x00dev, TX_STA_FIFO, &status);
 
 		if (!rt2x00_get_field32(status, TX_STA_FIFO_VALID))
@@ -991,21 +991,21 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 };
 
 static const struct data_queue_desc rt2800pci_queue_rx = {
-	.entry_num		= RX_ENTRIES,
+	.entry_num		= 128,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2800pci_queue_tx = {
-	.entry_num		= TX_ENTRIES,
+	.entry_num		= 64,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt2800pci_queue_bcn = {
-	.entry_num		= 8 * BEACON_ENTRIES,
+	.entry_num		= 8,
 	.data_size		= 0, /* No DMA required for beacons */
 	.desc_size		= TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 3dff56e..3f44131 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -165,7 +165,8 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 	 * this limit so reduce the number to prevent errors.
 	 */
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_LIMIT,
-			   ((RX_ENTRIES * DATA_FRAME_SIZE) / 1024) - 3);
+			   ((rt2x00dev->ops->rx->entry_num * DATA_FRAME_SIZE)
+			    / 1024) - 3);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
 	rt2800_register_write(rt2x00dev, USB_DMA_CFG, reg);
@@ -553,21 +554,21 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 };
 
 static const struct data_queue_desc rt2800usb_queue_rx = {
-	.entry_num		= RX_ENTRIES,
+	.entry_num		= 128,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= RXINFO_DESC_SIZE + RXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2800usb_queue_tx = {
-	.entry_num		= TX_ENTRIES,
+	.entry_num		= 64,
 	.data_size		= AGGREGATION_SIZE,
 	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt2800usb_queue_bcn = {
-	.entry_num		= 8 * BEACON_ENTRIES,
+	.entry_num		= 8,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXINFO_DESC_SIZE + TXWI_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index d81d85f..64acfb6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -43,22 +43,6 @@
 #define AGGREGATION_SIZE	3840
 
 /**
- * DOC: Number of entries per queue
- *
- * Under normal load without fragmentation, 12 entries are sufficient
- * without the queue being filled up to the maximum. When using fragmentation
- * and the queue threshold code, we need to add some additional margins to
- * make sure the queue will never (or only under extreme load) fill up
- * completely.
- * Since we don't use preallocated DMA, having a large number of queue entries
- * will have minimal impact on the memory requirements for the queue.
- */
-#define RX_ENTRIES	24
-#define TX_ENTRIES	24
-#define BEACON_ENTRIES	1
-#define ATIM_ENTRIES	8
-
-/**
  * enum data_queue_qid: Queue identification
  *
  * @QID_AC_BE: AC BE queue
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index af548c8..3232336 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2078,7 +2078,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 	 * that the TX_STA_FIFO stack has a size of 16. We stick to our
 	 * tx ring size for now.
 	 */
-	for (i = 0; i < TX_ENTRIES; i++) {
+	for (i = 0; i < rt2x00dev->ops->tx->entry_num; i++) {
 		rt2x00pci_register_read(rt2x00dev, STA_CSR4, &reg);
 		if (!rt2x00_get_field32(reg, STA_CSR4_VALID))
 			break;
@@ -2857,21 +2857,21 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 };
 
 static const struct data_queue_desc rt61pci_queue_rx = {
-	.entry_num		= RX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt61pci_queue_tx = {
-	.entry_num		= TX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
 };
 
 static const struct data_queue_desc rt61pci_queue_bcn = {
-	.entry_num		= 4 * BEACON_ENTRIES,
+	.entry_num		= 4,
 	.data_size		= 0, /* No DMA required for beacons */
 	.desc_size		= TXINFO_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_pci),
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9be8089..67447ec 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2296,21 +2296,21 @@ static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 };
 
 static const struct data_queue_desc rt73usb_queue_rx = {
-	.entry_num		= RX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= RXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt73usb_queue_tx = {
-	.entry_num		= TX_ENTRIES,
+	.entry_num		= 32,
 	.data_size		= DATA_FRAME_SIZE,
 	.desc_size		= TXD_DESC_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
 };
 
 static const struct data_queue_desc rt73usb_queue_bcn = {
-	.entry_num		= 4 * BEACON_ENTRIES,
+	.entry_num		= 4,
 	.data_size		= MGMT_FRAME_SIZE,
 	.desc_size		= TXINFO_SIZE,
 	.priv_size		= sizeof(struct queue_entry_priv_usb),
-- 
1.7.2.3

