Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:48611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437AbXB1OHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:15 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562551nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:14 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 23/28] rt2x00: Cleanup ring entry handlers
Date: Wed, 28 Feb 2007 15:07:08 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.08138.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup access to the data and descriptor fields inside a ring entry.
PCI devices can use the direct pointers instead of the inlined functions.
Also move the generic functions for eeprom/descriptor access to rt2x00.h

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 3226d76..5ad5d75 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -192,53 +192,6 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, RFCSR, reg);
 }
 
-/*
- * EEPROM access.
- * The EEPROM is being accessed by word index.
- */
-static void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
-	const u8 word)
-{
-	return (void*)&rt2x00dev->eeprom[word];
-}
-
-static void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 *data)
-{
-	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
-}
-
-static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 data)
-{
-	rt2x00dev->eeprom[word] = cpu_to_le16(data);
-}
-
-/*
- * TX/RX Descriptor access functions.
- */
-static inline void* rt2x00_data_addr(struct data_entry *entry)
-{
-	return entry->data_addr;
-}
-
-static inline struct data_desc* rt2x00_desc_addr(struct data_entry *entry)
-{
-	return entry->priv;
-}
-
-static inline void rt2x00_desc_read(struct data_desc *desc,
-	const u8 word, u32 *value)
-{
-	*value = le32_to_cpu(desc->word[word]);
-}
-
-static inline void rt2x00_desc_write(struct data_desc *desc,
-	const u8 word, const u32 value)
-{
-	desc->word[word] = cpu_to_le32(value);
-}
-
 #ifdef CONFIG_RT2X00_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
@@ -930,7 +883,7 @@ static void rt2400pci_init_rxring(struct rt2x00_dev *rt2x00dev,
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		rxd = rt2x00_desc_addr(&ring->entry[i]);
+		rxd = ring->entry[i].priv;
 
 		rt2x00_desc_read(rxd, 2, &word);
 		rt2x00_set_field32(&word, RXD_W2_BUFFER_LENGTH,
@@ -963,7 +916,7 @@ static void rt2400pci_init_txring(struct rt2x00_dev *rt2x00dev,
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		txd = rt2x00_desc_addr(&ring->entry[i]);
+		txd = ring->entry[i].priv;
 
 		rt2x00_desc_read(txd, 1, &word);
 		rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS,
@@ -1871,8 +1824,8 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw,
 	/*
 	 * Update the beacon entry.
 	 */
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt2400pci_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
+	memcpy(entry->data_addr, skb->data, skb->len);
+	rt2400pci_write_tx_desc(rt2x00dev, entry->priv,
 		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	return 0;
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 5554b3e..9763da5 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -192,53 +192,6 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, RFCSR, reg);
 }
 
-/*
- * EEPROM access.
- * The EEPROM is being accessed by word index.
- */
-static void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
-	const u8 word)
-{
-	return (void*)&rt2x00dev->eeprom[word];
-}
-
-static void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 *data)
-{
-	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
-}
-
-static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 data)
-{
-	rt2x00dev->eeprom[word] = cpu_to_le16(data);
-}
-
-/*
- * TX/RX Descriptor access functions.
- */
-static inline void* rt2x00_data_addr(struct data_entry *entry)
-{
-	return entry->data_addr;
-}
-
-static inline struct data_desc* rt2x00_desc_addr(struct data_entry *entry)
-{
-	return entry->priv;
-}
-
-static inline void rt2x00_desc_read(struct data_desc *desc,
-	const u8 word, u32 *value)
-{
-	*value = le32_to_cpu(desc->word[word]);
-}
-
-static inline void rt2x00_desc_write(struct data_desc *desc,
-	const u8 word, const u32 value)
-{
-	desc->word[word] = cpu_to_le32(value);
-}
-
 #ifdef CONFIG_RT2X00_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
@@ -1021,7 +974,7 @@ static void rt2500pci_init_rxring(struct rt2x00_dev *rt2x00dev,
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		rxd = rt2x00_desc_addr(&ring->entry[i]);
+		rxd = ring->entry[i].priv;
 
 		rt2x00_desc_read(rxd, 1, &word);
 		rt2x00_set_field32(&word, RXD_W1_BUFFER_ADDRESS,
@@ -1049,7 +1002,7 @@ static void rt2500pci_init_txring(struct rt2x00_dev *rt2x00dev,
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		txd = rt2x00_desc_addr(&ring->entry[i]);
+		txd = ring->entry[i].priv;
 
 		rt2x00_desc_read(txd, 1, &word);
 		rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS,
@@ -2009,8 +1962,8 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw,
 	/*
 	 * Update the beacon entry.
 	 */
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt2500pci_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
+	memcpy(entry->data_addr, skb->data, skb->len);
+	rt2500pci_write_tx_desc(rt2x00dev, entry->priv,
 		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	return 0;
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index abbe032..bfad5a6 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -234,43 +234,6 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, PHY_CSR10, reg);
 }
 
-/*
- * EEPROM access.
- * The EEPROM is being accessed by word index.
- */
-static void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
-	const u8 word)
-{
-	return (void*)&rt2x00dev->eeprom[word];
-}
-
-static void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 *data)
-{
-	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
-}
-
-static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 data)
-{
-	rt2x00dev->eeprom[word] = cpu_to_le16(data);
-}
-
-/*
- * TX/RX Descriptor access functions.
- */
-static inline void rt2x00_desc_read(struct data_desc *desc,
-	const u8 word, u32 *value)
-{
-	*value = le32_to_cpu(desc->word[word]);
-}
-
-static inline void rt2x00_desc_write(struct data_desc *desc,
-	const u8 word, const u32 value)
-{
-	desc->word[word] = cpu_to_le32(value);
-}
-
 #ifdef CONFIG_RT2X00_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u16)) )
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
index 1b2a0fb..3bd8271 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00.h
@@ -701,6 +701,21 @@ static inline int rt2x00_ring_free(struct data_ring *ring)
 }
 
 /*
+ * TX/RX Descriptor access functions.
+ */
+static inline void rt2x00_desc_read(struct data_desc *desc,
+	const u8 word, u32 *value)
+{
+	*value = le32_to_cpu(desc->word[word]);
+}
+
+static inline void rt2x00_desc_write(struct data_desc *desc,
+	const u8 word, const u32 value)
+{
+	desc->word[word] = cpu_to_le32(value);
+}
+
+/*
  * To optimize the quality of the link we need to store
  * the quality of received frames and periodically
  * optimize the link.
@@ -1165,6 +1180,28 @@ static inline struct data_ring* rt2x00_get_ring(
 	return NULL;
 }
 
+/*
+ * EEPROM access.
+ * The EEPROM is being accessed by word index.
+ */
+static inline void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
+	const u8 word)
+{
+	return (void*)&rt2x00dev->eeprom[word];
+}
+
+static inline void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
+	const u8 word, u16 *data)
+{
+	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
+}
+
+static inline void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
+	const u8 word, u16 data)
+{
+	rt2x00dev->eeprom[word] = cpu_to_le16(data);
+}
+
 static inline void rt2x00_update_tx_stats(struct rt2x00_dev *rt2x00dev,
 	struct ieee80211_tx_status *tx_status, const int status,
 	const int is_ack, const int is_rts)
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 267f39e..ec149d1 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -223,53 +223,6 @@ static void rt2x00_mcu_request(const struct rt2x00_dev *rt2x00dev,
 	rt2x00_register_write(rt2x00dev, HOST_CMD_CSR, reg);
 }
 
-/*
- * EEPROM access.
- * The EEPROM is being accessed by word index.
- */
-static void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
-	const u8 word)
-{
-	return (void*)&rt2x00dev->eeprom[word];
-}
-
-static void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 *data)
-{
-	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
-}
-
-static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 data)
-{
-	rt2x00dev->eeprom[word] = cpu_to_le16(data);
-}
-
-/*
- * TX/RX Descriptor access functions.
- */
-static inline void* rt2x00_data_addr(struct data_entry *entry)
-{
-	return entry->data_addr;
-}
-
-static inline struct data_desc* rt2x00_desc_addr(struct data_entry *entry)
-{
-	return entry->priv;
-}
-
-static inline void rt2x00_desc_read(struct data_desc *desc,
-	const u8 word, u32 *value)
-{
-	*value = le32_to_cpu(desc->word[word]);
-}
-
-static inline void rt2x00_desc_write(struct data_desc *desc,
-	const u8 word, const u32 value)
-{
-	desc->word[word] = cpu_to_le32(value);
-}
-
 #ifdef CONFIG_RT2X00_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
@@ -1302,7 +1255,7 @@ static void rt61pci_init_rxring(struct rt2x00_dev *rt2x00dev,
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		rxd = rt2x00_desc_addr(&ring->entry[i]);
+		rxd = ring->entry[i].priv;
 
 		rt2x00_desc_read(rxd, 5, &word);
 		rt2x00_set_field32(&word, RXD_W5_BUFFER_PHYSICAL_ADDRESS,
@@ -1330,7 +1283,7 @@ static void rt61pci_init_txring(struct rt2x00_dev *rt2x00dev,
 	ring->type = ring_type;
 
 	for (i = 0; i < ring->stats.limit; i++) {
-		txd = rt2x00_desc_addr(&ring->entry[i]);
+		txd = ring->entry[i].priv;
 
 		rt2x00_desc_read(txd, 1, &word);
 		rt2x00_set_field32(&word, TXD_W1_BUFFER_COUNT, 1);
@@ -2335,8 +2288,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw,
 	/*
 	 * Update the beacon entry.
 	 */
-	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt61pci_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
+	memcpy(entry->data_addr, skb->data, skb->len);
+	rt61pci_write_tx_desc(rt2x00dev, entry->priv,
 		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	return 0;
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index b24ecea..ffecc64 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -230,43 +230,6 @@ rf_write:
 	rt2x00_register_write(rt2x00dev, PHY_CSR4, reg);
 }
 
-/*
- * EEPROM access.
- * The EEPROM is being accessed by word index.
- */
-static void* rt2x00_eeprom_addr(const struct rt2x00_dev *rt2x00dev,
-	const u8 word)
-{
-	return (void*)&rt2x00dev->eeprom[word];
-}
-
-static void rt2x00_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 *data)
-{
-	*data = le16_to_cpu(rt2x00dev->eeprom[word]);
-}
-
-static void rt2x00_eeprom_write(const struct rt2x00_dev *rt2x00dev,
-	const u8 word, u16 data)
-{
-	rt2x00dev->eeprom[word] = cpu_to_le16(data);
-}
-
-/*
- * TX/RX Descriptor access functions.
- */
-static inline void rt2x00_desc_read(struct data_desc *desc,
-	const u8 word, u32 *value)
-{
-	*value = le32_to_cpu(desc->word[word]);
-}
-
-static inline void rt2x00_desc_write(struct data_desc *desc,
-	const u8 word, const u32 value)
-{
-	desc->word[word] = cpu_to_le32(value);
-}
-
 #ifdef CONFIG_RT2X00_DEBUGFS
 #define CSR_OFFSET(__word)	( CSR_REG_BASE + ((__word) * sizeof(u32)) )
 
