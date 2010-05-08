Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2209 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002Ab0EHVke (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 17:40:34 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 5/9] rt2x00: Factor out RXWI processing to common rt2800 code.
Date: Sat,  8 May 2010 23:40:22 +0200
Message-Id: <1273354826-4335-6-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RXWI processing is exactly the same for rt2800pci and rt2800usb, so
make it common code.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   44 ++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |   57 +++++-------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   74 ++++++++++---------------------
 4 files changed, 79 insertions(+), 97 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 28d82ce..7410ac1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -335,6 +335,50 @@ void rt2800_write_txwi(struct sk_buff *skb, struct txentry_desc *txdesc)
 }
 EXPORT_SYMBOL_GPL(rt2800_write_txwi);
 
+void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *rxdesc)
+{
+	__le32 *rxwi = (__le32 *) skb->data;
+	u32 word;
+
+	rt2x00_desc_read(rxwi, 0, &word);
+
+	rxdesc->cipher = rt2x00_get_field32(word, RXWI_W0_UDF);
+	rxdesc->size = rt2x00_get_field32(word, RXWI_W0_MPDU_TOTAL_BYTE_COUNT);
+
+	rt2x00_desc_read(rxwi, 1, &word);
+
+	if (rt2x00_get_field32(word, RXWI_W1_SHORT_GI))
+		rxdesc->flags |= RX_FLAG_SHORT_GI;
+
+	if (rt2x00_get_field32(word, RXWI_W1_BW))
+		rxdesc->flags |= RX_FLAG_40MHZ;
+
+	/*
+	 * Detect RX rate, always use MCS as signal type.
+	 */
+	rxdesc->dev_flags |= RXDONE_SIGNAL_MCS;
+	rxdesc->signal = rt2x00_get_field32(word, RXWI_W1_MCS);
+	rxdesc->rate_mode = rt2x00_get_field32(word, RXWI_W1_PHYMODE);
+
+	/*
+	 * Mask of 0x8 bit to remove the short preamble flag.
+	 */
+	if (rxdesc->rate_mode == RATE_MODE_CCK)
+		rxdesc->signal &= ~0x8;
+
+	rt2x00_desc_read(rxwi, 2, &word);
+
+	rxdesc->rssi =
+	    (rt2x00_get_field32(word, RXWI_W2_RSSI0) +
+	     rt2x00_get_field32(word, RXWI_W2_RSSI1)) / 2;
+
+	/*
+	 * Remove RXWI descriptor from start of buffer.
+	 */
+	skb_pull(skb, RXWI_DESC_SIZE);
+}
+EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
+
 #ifdef CONFIG_RT2X00_LIB_DEBUGFS
 const struct rt2x00debug rt2800_rt2x00debug = {
 	.owner	= THIS_MODULE,
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index b805310..94de999 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -112,6 +112,7 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 arg0, const u8 arg1);
 
 void rt2800_write_txwi(struct sk_buff *skb, struct txentry_desc *txdesc);
+void rt2800_process_rxwi(struct sk_buff *skb, struct rxdone_entry_desc *txdesc);
 
 extern const struct rt2x00debug rt2800_rt2x00debug;
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index bd56cd1..308842a 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -770,20 +770,11 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct queue_entry_priv_pci *entry_priv = entry->priv_data;
 	__le32 *rxd = entry_priv->desc;
-	__le32 *rxwi = (__le32 *)entry->skb->data;
-	u32 rxd3;
-	u32 rxwi0;
-	u32 rxwi1;
-	u32 rxwi2;
-	u32 rxwi3;
-
-	rt2x00_desc_read(rxd, 3, &rxd3);
-	rt2x00_desc_read(rxwi, 0, &rxwi0);
-	rt2x00_desc_read(rxwi, 1, &rxwi1);
-	rt2x00_desc_read(rxwi, 2, &rxwi2);
-	rt2x00_desc_read(rxwi, 3, &rxwi3);
-
-	if (rt2x00_get_field32(rxd3, RXD_W3_CRC_ERROR))
+	u32 word;
+
+	rt2x00_desc_read(rxd, 3, &word);
+
+	if (rt2x00_get_field32(word, RXD_W3_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
 	/*
@@ -791,10 +782,9 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 	 * decryption. This prevents us from correct providing
 	 * correct statistics through debugfs.
 	 */
-	rxdesc->cipher = rt2x00_get_field32(rxwi0, RXWI_W0_UDF);
-	rxdesc->cipher_status = rt2x00_get_field32(rxd3, RXD_W3_CIPHER_ERROR);
+	rxdesc->cipher_status = rt2x00_get_field32(word, RXD_W3_CIPHER_ERROR);
 
-	if (rt2x00_get_field32(rxd3, RXD_W3_DECRYPTED)) {
+	if (rt2x00_get_field32(word, RXD_W3_DECRYPTED)) {
 		/*
 		 * Hardware has stripped IV/EIV data from 802.11 frame during
 		 * decryption. Unfortunately the descriptor doesn't contain
@@ -809,47 +799,22 @@ static void rt2800pci_fill_rxdone(struct queue_entry *entry,
 			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
 	}
 
-	if (rt2x00_get_field32(rxd3, RXD_W3_MY_BSS))
+	if (rt2x00_get_field32(word, RXD_W3_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
-	if (rt2x00_get_field32(rxd3, RXD_W3_L2PAD))
+	if (rt2x00_get_field32(word, RXD_W3_L2PAD))
 		rxdesc->dev_flags |= RXDONE_L2PAD;
 
-	if (rt2x00_get_field32(rxwi1, RXWI_W1_SHORT_GI))
-		rxdesc->flags |= RX_FLAG_SHORT_GI;
-
-	if (rt2x00_get_field32(rxwi1, RXWI_W1_BW))
-		rxdesc->flags |= RX_FLAG_40MHZ;
-
 	/*
-	 * Detect RX rate, always use MCS as signal type.
+	 * Process the RXWI structure that is at the start of the buffer.
 	 */
-	rxdesc->dev_flags |= RXDONE_SIGNAL_MCS;
-	rxdesc->rate_mode = rt2x00_get_field32(rxwi1, RXWI_W1_PHYMODE);
-	rxdesc->signal = rt2x00_get_field32(rxwi1, RXWI_W1_MCS);
-
-	/*
-	 * Mask of 0x8 bit to remove the short preamble flag.
-	 */
-	if (rxdesc->rate_mode == RATE_MODE_CCK)
-		rxdesc->signal &= ~0x8;
-
-	rxdesc->rssi =
-	    (rt2x00_get_field32(rxwi2, RXWI_W2_RSSI0) +
-	     rt2x00_get_field32(rxwi2, RXWI_W2_RSSI1)) / 2;
-
-	rxdesc->size = rt2x00_get_field32(rxwi0, RXWI_W0_MPDU_TOTAL_BYTE_COUNT);
+	rt2800_process_rxwi(entry->skb, rxdesc);
 
 	/*
 	 * Set RX IDX in register to inform hardware that we have handled
 	 * this entry and it is available for reuse again.
 	 */
 	rt2800_register_write(rt2x00dev, RX_CRX_IDX, entry->entry_idx);
-
-	/*
-	 * Remove TXWI descriptor from start of buffer.
-	 */
-	skb_pull(entry->skb, RXWI_DESC_SIZE);
 }
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index b39b858..db37119 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -507,53 +507,45 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	__le32 *rxi = (__le32 *)entry->skb->data;
-	__le32 *rxwi;
 	__le32 *rxd;
-	u32 rxi0;
-	u32 rxwi0;
-	u32 rxwi1;
-	u32 rxwi2;
-	u32 rxwi3;
-	u32 rxd0;
+	u32 word;
 	int rx_pkt_len;
 
 	/*
+	 * Copy descriptor to the skbdesc->desc buffer, making it safe from
+	 * moving of frame data in rt2x00usb.
+	 */
+	memcpy(skbdesc->desc, rxi, skbdesc->desc_len);
+
+	/*
 	 * RX frame format is :
 	 * | RXINFO | RXWI | header | L2 pad | payload | pad | RXD | USB pad |
 	 *          |<------------ rx_pkt_len -------------->|
 	 */
-	rt2x00_desc_read(rxi, 0, &rxi0);
-	rx_pkt_len = rt2x00_get_field32(rxi0, RXINFO_W0_USB_DMA_RX_PKT_LEN);
-
-	rxwi = (__le32 *)(entry->skb->data + RXINFO_DESC_SIZE);
+	rt2x00_desc_read(rxi, 0, &word);
+	rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
 
 	/*
-	 * FIXME : we need to check for rx_pkt_len validity
+	 * Remove the RXINFO structure from the sbk.
 	 */
-	rxd = (__le32 *)(entry->skb->data + RXINFO_DESC_SIZE + rx_pkt_len);
+	skb_pull(entry->skb, RXINFO_DESC_SIZE);
 
 	/*
-	 * Copy descriptor to the skbdesc->desc buffer, making it safe from
-	 * moving of frame data in rt2x00usb.
+	 * FIXME: we need to check for rx_pkt_len validity
 	 */
-	memcpy(skbdesc->desc, rxi, skbdesc->desc_len);
+	rxd = (__le32 *)(entry->skb->data + rx_pkt_len);
 
 	/*
 	 * It is now safe to read the descriptor on all architectures.
 	 */
-	rt2x00_desc_read(rxwi, 0, &rxwi0);
-	rt2x00_desc_read(rxwi, 1, &rxwi1);
-	rt2x00_desc_read(rxwi, 2, &rxwi2);
-	rt2x00_desc_read(rxwi, 3, &rxwi3);
-	rt2x00_desc_read(rxd, 0, &rxd0);
+	rt2x00_desc_read(rxd, 0, &word);
 
-	if (rt2x00_get_field32(rxd0, RXD_W0_CRC_ERROR))
+	if (rt2x00_get_field32(word, RXD_W0_CRC_ERROR))
 		rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
 
-	rxdesc->cipher = rt2x00_get_field32(rxwi0, RXWI_W0_UDF);
-	rxdesc->cipher_status = rt2x00_get_field32(rxd0, RXD_W0_CIPHER_ERROR);
+	rxdesc->cipher_status = rt2x00_get_field32(word, RXD_W0_CIPHER_ERROR);
 
-	if (rt2x00_get_field32(rxd0, RXD_W0_DECRYPTED)) {
+	if (rt2x00_get_field32(word, RXD_W0_DECRYPTED)) {
 		/*
 		 * Hardware has stripped IV/EIV data from 802.11 frame during
 		 * decryption. Unfortunately the descriptor doesn't contain
@@ -568,41 +560,21 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
 	}
 
-	if (rt2x00_get_field32(rxd0, RXD_W0_MY_BSS))
+	if (rt2x00_get_field32(word, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
-	if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD))
+	if (rt2x00_get_field32(word, RXD_W0_L2PAD))
 		rxdesc->dev_flags |= RXDONE_L2PAD;
 
-	if (rt2x00_get_field32(rxwi1, RXWI_W1_SHORT_GI))
-		rxdesc->flags |= RX_FLAG_SHORT_GI;
-
-	if (rt2x00_get_field32(rxwi1, RXWI_W1_BW))
-		rxdesc->flags |= RX_FLAG_40MHZ;
-
 	/*
-	 * Detect RX rate, always use MCS as signal type.
+	 * Remove RXD descriptor from end of buffer.
 	 */
-	rxdesc->dev_flags |= RXDONE_SIGNAL_MCS;
-	rxdesc->rate_mode = rt2x00_get_field32(rxwi1, RXWI_W1_PHYMODE);
-	rxdesc->signal = rt2x00_get_field32(rxwi1, RXWI_W1_MCS);
-
-	/*
-	 * Mask of 0x8 bit to remove the short preamble flag.
-	 */
-	if (rxdesc->rate_mode == RATE_MODE_CCK)
-		rxdesc->signal &= ~0x8;
-
-	rxdesc->rssi =
-	    (rt2x00_get_field32(rxwi2, RXWI_W2_RSSI0) +
-	     rt2x00_get_field32(rxwi2, RXWI_W2_RSSI1)) / 2;
-
-	rxdesc->size = rt2x00_get_field32(rxwi0, RXWI_W0_MPDU_TOTAL_BYTE_COUNT);
+	skb_trim(entry->skb, rx_pkt_len);
 
 	/*
-	 * Remove RXWI descriptor from start of buffer.
+	 * Process the RXWI structure.
 	 */
-	skb_pull(entry->skb, skbdesc->desc_len);
+	rt2800_process_rxwi(entry->skb, rxdesc);
 }
 
 /*
-- 
1.7.1

