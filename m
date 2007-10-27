Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:14625 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbXJ0LZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 07:25:31 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1035411fkz
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 04:25:29 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/21] rt2x00: Remove data_desc structure
Date: Sat, 27 Oct 2007 13:43:06 +0200
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <200710271334.34192.IvDoorn@gmail.com>
In-Reply-To: <200710271334.34192.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710271343.07001.IvDoorn@gmail.com> (sfid-20071027_122535_664565_DA5C4F34)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Coverty indicated that data_desc with a single
element array is bad coding style. This removes
the structure and forces everybody to use __le32.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c  |   10 +++++-----
 drivers/net/wireless/rt2x00/rt2400pci.h  |    4 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c  |   10 +++++-----
 drivers/net/wireless/rt2x00/rt2500pci.h  |    4 ++--
 drivers/net/wireless/rt2x00/rt2500usb.c  |    9 ++++-----
 drivers/net/wireless/rt2x00/rt2500usb.h  |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00.h     |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00dev.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c  |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00ring.h |   22 ++++------------------
 drivers/net/wireless/rt2x00/rt2x00usb.c  |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c    |   12 ++++++------
 drivers/net/wireless/rt2x00/rt61pci.h    |    4 ++--
 drivers/net/wireless/rt2x00/rt73usb.c    |    6 +++---
 drivers/net/wireless/rt2x00/rt73usb.h    |    4 ++--
 15 files changed, 44 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index f2d0feb..8889f6d 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -600,7 +600,7 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 static void rt2400pci_init_rxring(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring = rt2x00dev->rx;
-	struct data_desc *rxd;
+	__le32 *rxd;
 	unsigned int i;
 	u32 word;
 
@@ -630,7 +630,7 @@ static void rt2400pci_init_rxring(struct rt2x00_dev *rt2x00dev)
 static void rt2400pci_init_txring(struct rt2x00_dev *rt2x00dev, const int queue)
 {
 	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
-	struct data_desc *txd;
+	__le32 *txd;
 	unsigned int i;
 	u32 word;
 
@@ -1017,7 +1017,7 @@ static int rt2400pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct data_desc *txd,
+				    __le32 *txd,
 				    struct txdata_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
 				    unsigned int length,
@@ -1117,7 +1117,7 @@ static void rt2400pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2400pci_fill_rxdone(struct data_entry *entry,
 				  struct rxdata_entry_desc *desc)
 {
-	struct data_desc *rxd = entry->priv;
+	__le32 *rxd = entry->priv;
 	u32 word0;
 	u32 word2;
 
@@ -1147,7 +1147,7 @@ static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev, const int queue)
 {
 	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
 	struct data_entry *entry;
-	struct data_desc *txd;
+	__le32 *txd;
 	u32 word;
 	int tx_status;
 	int retry;
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
index ae22501..f5dbde7 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -803,8 +803,8 @@
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 8 * sizeof(struct data_desc) )
-#define RXD_DESC_SIZE			( 8 * sizeof(struct data_desc) )
+#define TXD_DESC_SIZE			( 8 * sizeof(__le32) )
+#define RXD_DESC_SIZE			( 8 * sizeof(__le32) )
 
 /*
  * TX descriptor format for TX, PRIO, ATIM and Beacon Ring.
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index fbda28e..0aedc46 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -691,7 +691,7 @@ dynamic_cca_tune:
 static void rt2500pci_init_rxring(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring = rt2x00dev->rx;
-	struct data_desc *rxd;
+	__le32 *rxd;
 	unsigned int i;
 	u32 word;
 
@@ -716,7 +716,7 @@ static void rt2500pci_init_rxring(struct rt2x00_dev *rt2x00dev)
 static void rt2500pci_init_txring(struct rt2x00_dev *rt2x00dev, const int queue)
 {
 	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
-	struct data_desc *txd;
+	__le32 *txd;
 	unsigned int i;
 	u32 word;
 
@@ -1167,7 +1167,7 @@ static int rt2500pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct data_desc *txd,
+				    __le32 *txd,
 				    struct txdata_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
 				    unsigned int length,
@@ -1251,7 +1251,7 @@ static void rt2500pci_kick_tx_queue(struct rt2x00_dev *rt2x00dev,
 static void rt2500pci_fill_rxdone(struct data_entry *entry,
 				  struct rxdata_entry_desc *desc)
 {
-	struct data_desc *rxd = entry->priv;
+	__le32 *rxd = entry->priv;
 	u32 word0;
 	u32 word2;
 
@@ -1278,7 +1278,7 @@ static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev, const int queue)
 {
 	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
 	struct data_entry *entry;
-	struct data_desc *txd;
+	__le32 *txd;
 	u32 word;
 	int tx_status;
 	int retry;
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
index d92aa56..92ba090 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -1082,8 +1082,8 @@
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 11 * sizeof(struct data_desc) )
-#define RXD_DESC_SIZE			( 11 * sizeof(struct data_desc) )
+#define TXD_DESC_SIZE			( 11 * sizeof(__le32) )
+#define RXD_DESC_SIZE			( 11 * sizeof(__le32) )
 
 /*
  * TX descriptor format for TX, PRIO, ATIM and Beacon Ring.
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index de89e60..041a847 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -990,7 +990,7 @@ static int rt2500usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				    struct data_desc *txd,
+				    __le32 *txd,
 				    struct txdata_entry_desc *desc,
 				    struct ieee80211_hdr *ieee80211hdr,
 				    unsigned int length,
@@ -1082,9 +1082,8 @@ static void rt2500usb_fill_rxdone(struct data_entry *entry,
 				  struct rxdata_entry_desc *desc)
 {
 	struct urb *urb = entry->priv;
-	struct data_desc *rxd = (struct data_desc *)(entry->skb->data +
-						     (urb->actual_length -
-						      entry->ring->desc_size));
+	__le32 *rxd = (__le32 *)(entry->skb->data +
+				 (urb->actual_length - entry->ring->desc_size));
 	u32 word0;
 	u32 word1;
 
@@ -1683,7 +1682,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	skb_push(skb, ring->desc_size);
 	memset(skb->data, 0, ring->desc_size);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
+	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 ring->desc_size),
 				skb->len - ring->desc_size, control);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h b/drivers/net/wireless/rt2x00/rt2500usb.h
index 2741840..9e04337 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -703,8 +703,8 @@
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 5 * sizeof(struct data_desc) )
-#define RXD_DESC_SIZE			( 4 * sizeof(struct data_desc) )
+#define TXD_DESC_SIZE			( 5 * sizeof(__le32) )
+#define RXD_DESC_SIZE			( 4 * sizeof(__le32) )
 
 /*
  * TX descriptor format for TX, PRIO, ATIM and Beacon Ring.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 82e061c..e41eb06 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -488,7 +488,7 @@ struct rt2x00lib_ops {
 	 * TX control handlers
 	 */
 	void (*write_tx_desc) (struct rt2x00_dev *rt2x00dev,
-			       struct data_desc *txd,
+			       __le32 *txd,
 			       struct txdata_entry_desc *desc,
 			       struct ieee80211_hdr *ieee80211hdr,
 			       unsigned int length,
@@ -882,7 +882,7 @@ void rt2x00lib_rxdone(struct data_entry *entry, struct sk_buff *skb,
  * TX descriptor initializer
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     struct data_desc *txd,
+			     __le32 *txd,
 			     struct ieee80211_hdr *ieee80211hdr,
 			     unsigned int length,
 			     struct ieee80211_tx_control *control);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 360f03a..304830b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -578,7 +578,7 @@ EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
  * TX descriptor initializer
  */
 void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-			     struct data_desc *txd,
+			     __le32 *txd,
 			     struct ieee80211_hdr *ieee80211hdr,
 			     unsigned int length,
 			     struct ieee80211_tx_control *control)
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index 2780df0..045b954 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -80,7 +80,7 @@ int rt2x00pci_write_tx_data(struct rt2x00_dev *rt2x00dev,
 {
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
-	struct data_desc *txd = entry->priv;
+	__le32 *txd = entry->priv;
 	u32 word;
 
 	if (rt2x00_ring_full(ring)) {
@@ -122,9 +122,9 @@ void rt2x00pci_rxdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring = rt2x00dev->rx;
 	struct data_entry *entry;
-	struct data_desc *rxd;
 	struct sk_buff *skb;
 	struct rxdata_entry_desc desc;
+	__le32 *rxd;
 	u32 word;
 
 	while (1) {
diff --git a/drivers/net/wireless/rt2x00/rt2x00ring.h b/drivers/net/wireless/rt2x00/rt2x00ring.h
index 1a864d3..ee6c423 100644
--- a/drivers/net/wireless/rt2x00/rt2x00ring.h
+++ b/drivers/net/wireless/rt2x00/rt2x00ring.h
@@ -27,20 +27,6 @@
 #define RT2X00RING_H
 
 /*
- * data_desc
- * Each data entry also contains a descriptor which is used by the
- * device to determine what should be done with the packet and
- * what the current status is.
- * This structure is greatly simplified, but the descriptors
- * are basically a list of little endian 32 bit values.
- * Make the array by default 1 word big, this will allow us
- * to use sizeof() correctly.
- */
-struct data_desc {
-	__le32 word[1];
-};
-
-/*
  * rxdata_entry_desc
  * Summary of information that has been read from the
  * RX frame descriptor.
@@ -253,16 +239,16 @@ static inline int rt2x00_ring_free(struct data_ring *ring)
 /*
  * TX/RX Descriptor access functions.
  */
-static inline void rt2x00_desc_read(struct data_desc *desc,
+static inline void rt2x00_desc_read(__le32 *desc,
 				    const u8 word, u32 *value)
 {
-	*value = le32_to_cpu(desc->word[word]);
+	*value = le32_to_cpu(desc[word]);
 }
 
-static inline void rt2x00_desc_write(struct data_desc *desc,
+static inline void rt2x00_desc_write(__le32 *desc,
 				     const u8 word, const u32 value)
 {
-	desc->word[word] = cpu_to_le32(value);
+	desc[word] = cpu_to_le32(value);
 }
 
 #endif /* RT2X00RING_H */
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 47a9e5d..dfafb0e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -113,7 +113,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	struct data_entry *entry = (struct data_entry *)urb->context;
 	struct data_ring *ring = entry->ring;
 	struct rt2x00_dev *rt2x00dev = ring->rt2x00dev;
-	struct data_desc *txd = (struct data_desc *)entry->skb->data;
+	__le32 *txd = (__le32 *)entry->skb->data;
 	u32 word;
 	int tx_status;
 
@@ -182,7 +182,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	skb_push(skb, ring->desc_size);
 	memset(skb->data, 0, ring->desc_size);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
+	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 ring->desc_size),
 				skb->len - ring->desc_size, control);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0b8aeec..37fe772 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -996,7 +996,7 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 static void rt61pci_init_rxring(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring = rt2x00dev->rx;
-	struct data_desc *rxd;
+	__le32 *rxd;
 	unsigned int i;
 	u32 word;
 
@@ -1021,7 +1021,7 @@ static void rt61pci_init_rxring(struct rt2x00_dev *rt2x00dev)
 static void rt61pci_init_txring(struct rt2x00_dev *rt2x00dev, const int queue)
 {
 	struct data_ring *ring = rt2x00lib_get_ring(rt2x00dev, queue);
-	struct data_desc *txd;
+	__le32 *txd;
 	unsigned int i;
 	u32 word;
 
@@ -1535,7 +1535,7 @@ static int rt61pci_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  struct data_desc *txd,
+				  __le32 *txd,
 				  struct txdata_entry_desc *desc,
 				  struct ieee80211_hdr *ieee80211hdr,
 				  unsigned int length,
@@ -1679,7 +1679,7 @@ static int rt61pci_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 static void rt61pci_fill_rxdone(struct data_entry *entry,
 			        struct rxdata_entry_desc *desc)
 {
-	struct data_desc *rxd = entry->priv;
+	__le32 *rxd = entry->priv;
 	u32 word0;
 	u32 word1;
 
@@ -1708,7 +1708,7 @@ static void rt61pci_txdone(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_ring *ring;
 	struct data_entry *entry;
-	struct data_desc *txd;
+	__le32 *txd;
 	u32 word;
 	u32 reg;
 	u32 old_reg;
@@ -2443,7 +2443,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skb_push(skb, TXD_DESC_SIZE);
 	memset(skb->data, 0, TXD_DESC_SIZE);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
+	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 TXD_DESC_SIZE),
 				skb->len - TXD_DESC_SIZE, control);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
index 50d9f6a..4c6524e 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -1246,8 +1246,8 @@ struct hw_pairwise_ta_entry {
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 16 * sizeof(struct data_desc) )
-#define RXD_DESC_SIZE			( 16 * sizeof(struct data_desc) )
+#define TXD_DESC_SIZE			( 16 * sizeof(__le32) )
+#define RXD_DESC_SIZE			( 16 * sizeof(__le32) )
 
 /*
  * TX descriptor format for TX, PRIO and Beacon Ring.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1c44081..d9cf997 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1203,7 +1203,7 @@ static int rt73usb_set_device_state(struct rt2x00_dev *rt2x00dev,
  * TX descriptor initialization
  */
 static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-				  struct data_desc *txd,
+				  __le32 *txd,
 				  struct txdata_entry_desc *desc,
 				  struct ieee80211_hdr *ieee80211hdr,
 				  unsigned int length,
@@ -1350,7 +1350,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 static void rt73usb_fill_rxdone(struct data_entry *entry,
 			        struct rxdata_entry_desc *desc)
 {
-	struct data_desc *rxd = (struct data_desc *)entry->skb->data;
+	__le32 *rxd = (__le32 *)entry->skb->data;
 	u32 word0;
 	u32 word1;
 
@@ -1953,7 +1953,7 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	skb_push(skb, TXD_DESC_SIZE);
 	memset(skb->data, 0, TXD_DESC_SIZE);
 
-	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
+	rt2x00lib_write_tx_desc(rt2x00dev, (__le32 *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 TXD_DESC_SIZE),
 				skb->len - TXD_DESC_SIZE, control);
diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
index b967df2..d49dcaa 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -866,8 +866,8 @@ struct hw_pairwise_ta_entry {
 /*
  * DMA descriptor defines.
  */
-#define TXD_DESC_SIZE			( 6 * sizeof(struct data_desc) )
-#define RXD_DESC_SIZE			( 6 * sizeof(struct data_desc) )
+#define TXD_DESC_SIZE			( 6 * sizeof(__le32) )
+#define RXD_DESC_SIZE			( 6 * sizeof(__le32) )
 
 /*
  * TX descriptor format for TX, PRIO and Beacon Ring.
-- 
1.5.3.4

