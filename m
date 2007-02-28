Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49309 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489AbXB1OHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:34 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562649nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:33 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/28] rt2x00: Don't pass a skb directly with write_tx_desc
Date: Wed, 28 Feb 2007 15:07:17 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.17267.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't pass a skb directly with write_tx_desc. Instead send a
pointer to the ieee80211hdr and the frame length.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
index 4c943ac..27e151d 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
@@ -1441,13 +1441,12 @@ static struct sk_buff* rt2400pci_create_rts(struct ieee80211_hw *hw,
  * TX descriptor initialization
  */
 static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-	struct data_desc *txd, struct sk_buff *skb,
-	struct ieee80211_tx_control *control)
+	struct data_desc *txd, struct ieee80211_hdr *ieee80211hdr,
+	unsigned int length, struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	int tx_rate;
 	u32 word;
-	u32 length;
+	u32 duration;
 	u32 residual;
 	u16 length_high;
 	u16 length_low;
@@ -1503,27 +1502,22 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		ifs = IFS_BACKOFF;
 
 	/*
-	 * Add 4 bytes for FCS.
-	 */
-	length = skb->len + FCS_LEN;
-
-	/*
 	 * Convert length to microseconds.
 	 */
 	bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
-	residual = get_duration_res(length, bitrate);
-	length = get_duration(length, bitrate);
+	residual = get_duration_res(length + FCS_LEN, bitrate);
+	duration = get_duration(length + FCS_LEN, bitrate);
 
 	if (residual)
-		length++;
+		duration++;
 
 	/*
 	 * Create the signal and service values, the values are stored
 	 * as if it was a BBP register including the busy bit
 	 * and register number.
 	 */
-	length_high = 0x8000 | 0x0700 | (length >> 8);
-	length_low = 0x8000 | 0x0800 | (length & 0xff);
+	length_high = 0x8000 | 0x0700 | (duration >> 8);
+	length_low = 0x8000 | 0x0800 | (duration & 0xff);
 
 	signal = 0x8000 | 0x0500 | DEVICE_GET_RATE_FIELD(tx_rate, PLCP);
 	if (DEVICE_GET_RATE_FIELD(tx_rate, PREAMBLE))
@@ -1537,7 +1531,7 @@ static void rt2400pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	 * Start writing the descriptor words.
 	 */
 	rt2x00_desc_read(txd, 2, &word);
-	rt2x00_set_field32(&word, TXD_W2_DATABYTE_COUNT, skb->len);
+	rt2x00_set_field32(&word, TXD_W2_DATABYTE_COUNT, length);
 	rt2x00_desc_write(txd, 2, word);
 
 	rt2x00_desc_read(txd, 3, &word);
@@ -1866,7 +1860,8 @@ static int rt2400pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt2x00_set_sequence(skb, &rt2x00dev->interface.sequence);
 
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt2400pci_write_tx_desc(rt2x00dev, txd, skb, control);
+	rt2400pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	if (is_rts_frame(frame_control))
 		SET_FLAG(entry, ENTRY_RTS_FRAME);
@@ -2352,7 +2347,7 @@ static int rt2400pci_beacon_update(struct ieee80211_hw *hw,
 	 */
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
 	rt2400pci_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
-		skb, control);
+		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
index 038e384..6234d20 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1568,14 +1568,13 @@ static struct sk_buff* rt2500pci_create_rts(struct ieee80211_hw *hw,
  * TX descriptor initialization
  */
 static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-	struct data_desc *txd, struct sk_buff *skb,
-	struct ieee80211_tx_control *control)
+	struct data_desc *txd, struct ieee80211_hdr *ieee80211hdr,
+	unsigned int length, struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	struct data_ring *ring;
 	int tx_rate;
 	u32 word;
-	u32 length;
+	u32 duration;
 	u32 residual;
 	u16 length_high;
 	u16 length_low;
@@ -1645,18 +1644,13 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		ifs = IFS_BACKOFF;
 
 	/*
-	 * Add 4 bytes for FCS.
-	 */
-	length = skb->len + FCS_LEN;
-
-	/*
 	 * How the length should be processed depends
 	 * on if we are working with OFDM rates or not.
 	 */
 	if (ofdm_rate) {
 		residual = 0;
-		length_high = (length >> 6) & 0x3f;
-		length_low = (length & 0x3f);
+		length_high = ((length + FCS_LEN) >> 6) & 0x3f;
+		length_low = ((length + FCS_LEN) & 0x3f);
 
 	} else {
 		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
@@ -1664,14 +1658,14 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Convert length to microseconds.
 		 */
-		residual = get_duration_res(length, bitrate);
-		length = get_duration(length, bitrate);
+		residual = get_duration_res(length + FCS_LEN, bitrate);
+		duration = get_duration(length + FCS_LEN, bitrate);
 
 		if (residual != 0)
-			length++;
+			duration++;
 
-		length_high = length >> 8;
-		length_low = length & 0xff;
+		length_high = duration >> 8;
+		length_low = duration & 0xff;
 	}
 
 	/*
@@ -1717,7 +1711,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
 	rt2x00_set_field32(&word, TXD_W0_IFS, ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
@@ -2032,7 +2026,8 @@ static int rt2500pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	rt2x00_set_sequence(skb, &rt2x00dev->interface.sequence);
 
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt2500pci_write_tx_desc(rt2x00dev, txd, skb, control);
+	rt2500pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	if (is_rts_frame(frame_control))
 		SET_FLAG(entry, ENTRY_RTS_FRAME);
@@ -2510,7 +2505,7 @@ static int rt2500pci_beacon_update(struct ieee80211_hw *hw,
 	 */
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
 	rt2500pci_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
-		skb, control);
+		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
index 483b1ba..c8c0f5a 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1533,14 +1533,13 @@ static struct sk_buff* rt2500usb_create_rts(struct ieee80211_hw *hw,
  * TX descriptor initialization
  */
 static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-	struct data_desc *txd, struct sk_buff *skb,
-	struct ieee80211_tx_control *control)
+	struct data_desc *txd, struct ieee80211_hdr *ieee80211hdr,
+	unsigned int length, struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	struct data_ring *ring;
 	int tx_rate;
 	u32 word;
-	u32 length;
+	u32 duration;
 	u32 residual;
 	u16 length_high;
 	u16 length_low;
@@ -1616,18 +1615,13 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		ifs = IFS_BACKOFF;
 
 	/*
-	 * Add 4 bytes for FCS.
-	 */
-	length = skb->len + FCS_LEN;
-
-	/*
 	 * How the length should be processed depends
 	 * on if we are working with OFDM rates or not.
 	 */
 	if (ofdm_rate) {
 		residual = 0;
-		length_high = (length >> 6) & 0x3f;
-		length_low = (length & 0x3f);
+		length_high = ((length + FCS_LEN) >> 6) & 0x3f;
+		length_low = ((length + FCS_LEN) & 0x3f);
 
 	} else {
 		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
@@ -1635,14 +1629,14 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Convert length to microseconds.
 		 */
-		residual = get_duration_res(length, bitrate);
-		length = get_duration(length, bitrate);
+		residual = get_duration_res(length + FCS_LEN, bitrate);
+		duration = get_duration(length + FCS_LEN, bitrate);
 
 		if (residual != 0)
-			length++;
+			duration++;
 
-		length_high = length >> 8;
-		length_low = length & 0xff;
+		length_high = duration >> 8;
+		length_low = duration & 0xff;
 	}
 
 	/*
@@ -1682,7 +1676,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_OFDM, ofdm_rate);
 	rt2x00_set_field32(&word, TXD_W0_NEW_SEQ, new_seq);
 	rt2x00_set_field32(&word, TXD_W0_IFS, ifs);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
@@ -1958,7 +1952,8 @@ static int rt2500usb_tx(struct ieee80211_hw *hw,
 	}
 
 	memcpy(rt2x00_txdata_addr(entry), skb->data, skb->len);
-	rt2500usb_write_tx_desc(rt2x00dev, txd, skb, control);
+	rt2500usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	if (is_rts_frame(frame_control))
 		SET_FLAG(entry, ENTRY_RTS_FRAME);
@@ -2408,8 +2403,8 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 * Update the beacon entry.
 	 */
 	memcpy(rt2x00_txdata_addr(entry), skb->data, skb->len);
-	rt2500usb_write_tx_desc(rt2x00dev,
-		rt2x00_txdesc_addr(entry), skb, control);
+	rt2500usb_write_tx_desc(rt2x00dev, rt2x00_txdesc_addr(entry),
+		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	SET_FLAG(entry, ENTRY_OWNER_NIC);
 	usb_fill_bulk_urb(
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 3739c2f..4224a57 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -2005,14 +2005,13 @@ static struct sk_buff* rt61pci_create_rts(struct ieee80211_hw *hw,
  * TX descriptor initialization
  */
 static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-	struct data_desc *txd, struct sk_buff *skb,
-	struct ieee80211_tx_control *control)
+	struct data_desc *txd, struct ieee80211_hdr *ieee80211hdr,
+	unsigned int length, struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	struct data_ring *ring;
 	int tx_rate;
 	u32 word;
-	u32 length;
+	u32 duration;
 	u32 residual;
 	u16 length_high;
 	u16 length_low;
@@ -2022,7 +2021,6 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	char ofdm_rate;
 	char req_timestamp;
 	char more_frag;
-	char req_seq;
 	char ifs;
 	char queue;
 	u8 signal;
@@ -2067,11 +2065,6 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	more_frag = !!(ieee80211_get_morefrag(ieee80211hdr));
 
 	/*
-	 * Check if we require to enable the hw sequence counter.
-	 */
-	req_seq = !!(rt2x00_require_sequence(ieee80211hdr));
-
-	/*
 	 * Beacons and probe responses require the tsf timestamp
 	 * to be inserted into the frame.
 	 */
@@ -2097,18 +2090,13 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		queue = 15;
 
 	/*
-	 * Add 4 bytes for FCS.
-	 */
-	length = skb->len + FCS_LEN;
-
-	/*
 	 * How the length should be processed depends
 	 * on if we are working with OFDM rates or not.
 	 */
 	if (ofdm_rate) {
 		residual = 0;
-		length_high = (length >> 6) & 0x3f;
-		length_low = (length & 0x3f);
+		length_high = ((length + FCS_LEN) >> 6) & 0x3f;
+		length_low = ((length + FCS_LEN) & 0x3f);
 
 	} else {
 		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
@@ -2116,14 +2104,14 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Convert length to microseconds.
 		 */
-		residual = get_duration_res(length, bitrate);
-		length = get_duration(length, bitrate);
+		residual = get_duration_res(length + FCS_LEN, bitrate);
+		duration = get_duration(length + FCS_LEN, bitrate);
 
 		if (residual != 0)
-			length++;
+			duration++;
 
-		length_high = length >> 8;
-		length_low = length & 0xff;
+		length_high = duration >> 8;
+		length_low = duration & 0xff;
 	}
 
 	/*
@@ -2146,7 +2134,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, ring->tx_params.cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, ring->tx_params.cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, req_seq);
+	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, 1);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
@@ -2163,7 +2151,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 5, word);
 
 	rt2x00_desc_read(txd, 11, &word);
-	rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, skb->len);
+	rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0, length);
 	rt2x00_desc_write(txd, 11, word);
 
 	rt2x00_desc_read(txd, 0, &word);
@@ -2177,7 +2165,7 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_IFS, ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
@@ -2512,7 +2500,8 @@ static int rt61pci_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt61pci_write_tx_desc(rt2x00dev, txd, skb, control);
+	rt61pci_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	if (is_rts_frame(frame_control))
 		SET_FLAG(entry, ENTRY_RTS_FRAME);
@@ -2998,7 +2987,7 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw,
 	 */
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
 	rt61pci_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
-		skb, control);
+		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 85ae23e..ef16d82 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1784,14 +1784,13 @@ static struct sk_buff* rt73usb_create_rts(struct ieee80211_hw *hw,
  * TX descriptor initialization
  */
 static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
-	struct data_desc *txd, struct sk_buff *skb,
-	struct ieee80211_tx_control *control)
+	struct data_desc *txd, struct ieee80211_hdr *ieee80211hdr,
+	unsigned int length, struct ieee80211_tx_control *control)
 {
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr*)skb->data;
 	struct data_ring *ring;
 	int tx_rate;
 	u32 word;
-	u32 length;
+	u32 duration;
 	u32 residual;
 	u16 length_high;
 	u16 length_low;
@@ -1801,7 +1800,6 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	char ofdm_rate;
 	char req_timestamp;
 	char more_frag;
-	char req_seq;
 	char ifs;
 	char queue;
 	u8 signal;
@@ -1846,11 +1844,6 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	more_frag = !!(ieee80211_get_morefrag(ieee80211hdr));
 
 	/*
-	 * Check if we require to enable the hw sequence counter.
-	 */
-	req_seq = !!(rt2x00_require_sequence(ieee80211hdr));
-
-	/*
 	 * Beacons and probe responses require the tsf timestamp
 	 * to be inserted into the frame.
 	 */
@@ -1876,18 +1869,13 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		queue = 15;
 
 	/*
-	 * Add 4 bytes for FCS.
-	 */
-	length = skb->len + FCS_LEN;
-
-	/*
 	 * How the length should be processed depends
 	 * on if we are working with OFDM rates or not.
 	 */
 	if (ofdm_rate) {
 		residual = 0;
-		length_high = (length >> 6) & 0x3f;
-		length_low = (length & 0x3f);
+		length_high = ((length + FCS_LEN) >> 6) & 0x3f;
+		length_low = ((length + FCS_LEN) & 0x3f);
 
 	} else {
 		bitrate = DEVICE_GET_RATE_FIELD(tx_rate, RATE);
@@ -1895,14 +1883,14 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * Convert length to microseconds.
 		 */
-		residual = get_duration_res(length, bitrate);
-		length = get_duration(length, bitrate);
+		residual = get_duration_res(length + FCS_LEN, bitrate);
+		duration = get_duration(length + FCS_LEN, bitrate);
 
 		if (residual != 0)
-			length++;
+			duration++;
 
-		length_high = length >> 8;
-		length_low = length & 0xff;
+		length_high = duration >> 8;
+		length_low = duration & 0xff;
 	}
 
 	/*
@@ -1925,7 +1913,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W1_CWMIN, ring->tx_params.cw_min);
 	rt2x00_set_field32(&word, TXD_W1_CWMAX, ring->tx_params.cw_max);
 	rt2x00_set_field32(&word, TXD_W1_IV_OFFSET, IEEE80211_HEADER);
-	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, req_seq);
+	rt2x00_set_field32(&word, TXD_W1_HW_SEQUENCE, 1);
 	rt2x00_desc_write(txd, 1, word);
 
 	rt2x00_desc_read(txd, 2, &word);
@@ -1951,7 +1939,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXD_W0_IFS, ifs);
 	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE, 0);
 	rt2x00_set_field32(&word, TXD_W0_TKIP_MIC, 0);
-	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
+	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, length);
 	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
 	rt2x00_desc_write(txd, 0, word);
 }
@@ -2218,7 +2206,8 @@ static int rt73usb_tx(struct ieee80211_hw *hw,
 	}
 
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt73usb_write_tx_desc(rt2x00dev, txd, skb, control);
+	rt73usb_write_tx_desc(rt2x00dev, txd, ieee80211hdr,
+		skb->len, control);
 	memcpy(&entry->tx_status.control, control, sizeof(*control));
 	if (is_rts_frame(frame_control))
 		SET_FLAG(entry, ENTRY_RTS_FRAME);
@@ -2713,8 +2702,8 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw,
 	 * Update the beacon entry.
 	 */
 	memcpy(rt2x00_data_addr(entry), skb->data, skb->len);
-	rt73usb_write_tx_desc(rt2x00dev,
-		rt2x00_desc_addr(entry), skb, control);
+	rt73usb_write_tx_desc(rt2x00dev, rt2x00_desc_addr(entry),
+		(struct ieee80211_hdr *)skb->data, skb->len, control);
 
 	SET_FLAG(entry, ENTRY_OWNER_NIC);
 	usb_fill_bulk_urb(
