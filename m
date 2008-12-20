Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:34119 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYLTKCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:15 -0500
Received: by mail-ew0-f17.google.com with SMTP id 10so1457128ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:14 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 10/15] rt2x00: Move code into seperate functions
Date: Sat, 20 Dec 2008 10:58:33 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201057.02583.IvDoorn@gmail.com> <200812201057.47712.IvDoorn@gmail.com>
In-Reply-To: <200812201057.47712.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201058.33821.IvDoorn@gmail.com> (sfid-20081220_110904_569707_B2120FC7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some functions have grown rapidly in size over the last time,
some of those functions (like the rt2x00queue_create_tx_descriptor)
will further increase in size soon, so it is best to start cutting
it into logical pieces.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   13 ++-
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    6 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c    |   40 +++---
 drivers/net/wireless/rt2x00/rt2x00queue.c  |  191 ++++++++++++++-------------
 4 files changed, 137 insertions(+), 113 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 37ad0d2..f30bda2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -49,9 +49,14 @@ enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *key)
 void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 				       struct txentry_desc *txdesc)
 {
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 
+	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) ||
+	    !hw_key || entry->skb->do_not_encrypt)
+		return;
+
 	__set_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags);
 
 	txdesc->cipher = rt2x00crypto_key_to_cipher(hw_key);
@@ -69,11 +74,17 @@ void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 		__set_bit(ENTRY_TXD_ENCRYPT_MMIC, &txdesc->flags);
 }
 
-unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info)
+unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev,
+				      struct sk_buff *skb)
 {
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_key_conf *key = tx_info->control.hw_key;
 	unsigned int overhead = 0;
 
+	if (!test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) ||
+	    !key || skb->do_not_encrypt)
+		return overhead;
+
 	/*
 	 * Extend frame length to include IV/EIV/ICV/MMIC,
 	 * note that these lengths should only be added when
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index a6b7e00..1e80a83 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -293,7 +293,8 @@ static inline void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
 enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *key);
 void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 				       struct txentry_desc *txdesc);
-unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info);
+unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev,
+				      struct sk_buff *skb);
 void rt2x00crypto_tx_copy_iv(struct sk_buff *skb, unsigned int iv_len);
 void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, unsigned int iv_len);
 void rt2x00crypto_tx_insert_iv(struct sk_buff *skb);
@@ -311,7 +312,8 @@ static inline void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 {
 }
 
-static inline unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info)
+static inline unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev,
+						    struct sk_buff *skb)
 {
 	return 0;
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e6fba83..bf7755a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -79,8 +79,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	 * RTS/CTS frame should use the length of the frame plus any
 	 * encryption overhead that will be added by the hardware.
 	 */
-	if (!frag_skb->do_not_encrypt)
-		data_length += rt2x00crypto_tx_overhead(tx_info);
+	data_length += rt2x00crypto_tx_overhead(rt2x00dev, skb);
 
 	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT)
 		ieee80211_ctstoself_get(rt2x00dev->hw, tx_info->control.vif,
@@ -484,6 +483,24 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
+static void memcpy_tkip(struct rt2x00lib_crypto *crypto, u8 *key, u8 key_len)
+{
+	if (key_len > NL80211_TKIP_DATA_OFFSET_ENCR_KEY)
+		memcpy(&crypto->key,
+		       &key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY],
+		       sizeof(crypto->key));
+
+	if (key_len > NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY)
+		memcpy(&crypto->tx_mic,
+		       &key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY],
+		       sizeof(crypto->tx_mic));
+
+	if (key_len > NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY)
+		memcpy(&crypto->rx_mic,
+		       &key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY],
+		       sizeof(crypto->rx_mic));
+}
+
 int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		      const u8 *local_address, const u8 *address,
 		      struct ieee80211_key_conf *key)
@@ -521,22 +538,9 @@ int rt2x00mac_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	crypto.cmd = cmd;
 	crypto.address = address;
 
-	if (crypto.cipher == CIPHER_TKIP) {
-		if (key->keylen > NL80211_TKIP_DATA_OFFSET_ENCR_KEY)
-			memcpy(&crypto.key,
-			       &key->key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY],
-			       sizeof(crypto.key));
-
-		if (key->keylen > NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY)
-			memcpy(&crypto.tx_mic,
-			       &key->key[NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY],
-			       sizeof(crypto.tx_mic));
-
-		if (key->keylen > NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY)
-			memcpy(&crypto.rx_mic,
-			       &key->key[NL80211_TKIP_DATA_OFFSET_RX_MIC_KEY],
-			       sizeof(crypto.rx_mic));
-	} else
+	if (crypto.cipher == CIPHER_TKIP)
+		memcpy_tkip(&crypto, &key->key[0], key->keylen);
+	else
 		memcpy(&crypto.key, &key->key[0], key->keylen);
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 0777120..efb2875 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -148,6 +148,95 @@ void rt2x00queue_free_skb(struct rt2x00_dev *rt2x00dev, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 
+static void rt2x00queue_create_tx_descriptor_seq(struct queue_entry *entry,
+						 struct txentry_desc *txdesc)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)entry->skb->data;
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
+	unsigned long irqflags;
+
+	if (!(tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) ||
+	    unlikely(!tx_info->control.vif))
+		return;
+
+	/*
+	 * Hardware should insert sequence counter.
+	 * FIXME: We insert a software sequence counter first for
+	 * hardware that doesn't support hardware sequence counting.
+	 *
+	 * This is wrong because beacons are not getting sequence
+	 * numbers assigned properly.
+	 *
+	 * A secondary problem exists for drivers that cannot toggle
+	 * sequence counting per-frame, since those will override the
+	 * sequence counter given by mac80211.
+	 */
+	spin_lock_irqsave(&intf->seqlock, irqflags);
+
+	if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
+		intf->seqno += 0x10;
+	hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+	hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
+
+	spin_unlock_irqrestore(&intf->seqlock, irqflags);
+
+	__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
+}
+
+static void rt2x00queue_create_tx_descriptor_plcp(struct queue_entry *entry,
+						  struct txentry_desc *txdesc,
+						  struct ieee80211_rate *rate)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	const struct rt2x00_rate *hwrate = rt2x00_get_rate(rate->hw_value);
+	unsigned int data_length;
+	unsigned int duration;
+	unsigned int residual;
+
+	/* Data length + CRC + Crypto overhead (IV/EIV/ICV/MIC) */
+	data_length = entry->skb->len + 4;
+	data_length += rt2x00crypto_tx_overhead(rt2x00dev, entry->skb);
+
+	/*
+	 * PLCP setup
+	 * Length calculation depends on OFDM/CCK rate.
+	 */
+	txdesc->signal = hwrate->plcp;
+	txdesc->service = 0x04;
+
+	if (hwrate->flags & DEV_RATE_OFDM) {
+		txdesc->length_high = (data_length >> 6) & 0x3f;
+		txdesc->length_low = data_length & 0x3f;
+	} else {
+		/*
+		 * Convert length to microseconds.
+		 */
+		residual = GET_DURATION_RES(data_length, hwrate->bitrate);
+		duration = GET_DURATION(data_length, hwrate->bitrate);
+
+		if (residual != 0) {
+			duration++;
+
+			/*
+			 * Check if we need to set the Length Extension
+			 */
+			if (hwrate->bitrate == 110 && residual <= 30)
+				txdesc->service |= 0x80;
+		}
+
+		txdesc->length_high = (duration >> 8) & 0xff;
+		txdesc->length_low = duration & 0xff;
+
+		/*
+		 * When preamble is enabled we should set the
+		 * preamble bit for the signal.
+		 */
+		if (rt2x00_get_rate_preamble(rate->hw_value))
+			txdesc->signal |= 0x08;
+	}
+}
+
 static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 					     struct txentry_desc *txdesc)
 {
@@ -157,10 +246,6 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	struct ieee80211_rate *rate =
 	    ieee80211_get_tx_rate(rt2x00dev->hw, tx_info);
 	const struct rt2x00_rate *hwrate;
-	unsigned int data_length;
-	unsigned int duration;
-	unsigned int residual;
-	unsigned long irqflags;
 
 	memset(txdesc, 0, sizeof(*txdesc));
 
@@ -172,27 +257,12 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	txdesc->cw_max = entry->queue->cw_max;
 	txdesc->aifs = entry->queue->aifs;
 
-	/* Data length + CRC */
-	data_length = entry->skb->len + 4;
-
 	/*
 	 * Check whether this frame is to be acked.
 	 */
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK))
 		__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
 
-	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) &&
-	    !entry->skb->do_not_encrypt) {
-		/* Apply crypto specific descriptor information */
-		rt2x00crypto_create_tx_descriptor(entry, txdesc);
-
-		/*
-		 * Extend frame length to include all encryption overhead
-		 * that will be added by the hardware.
-		 */
-		data_length += rt2x00crypto_tx_overhead(tx_info);
-	}
-
 	/*
 	 * Check if this is a RTS/CTS frame
 	 */
@@ -236,86 +306,23 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	 * Set ifs to IFS_SIFS when the this is not the first fragment,
 	 * or this fragment came after RTS/CTS.
 	 */
-	if (test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags)) {
-		txdesc->ifs = IFS_SIFS;
-	} else if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT) {
+	if ((tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT) &&
+	    !test_bit(ENTRY_TXD_RTS_FRAME, &txdesc->flags)) {
 		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags);
 		txdesc->ifs = IFS_BACKOFF;
-	} else {
+	} else
 		txdesc->ifs = IFS_SIFS;
-	}
-
-	/*
-	 * Hardware should insert sequence counter.
-	 * FIXME: We insert a software sequence counter first for
-	 * hardware that doesn't support hardware sequence counting.
-	 *
-	 * This is wrong because beacons are not getting sequence
-	 * numbers assigned properly.
-	 *
-	 * A secondary problem exists for drivers that cannot toggle
-	 * sequence counting per-frame, since those will override the
-	 * sequence counter given by mac80211.
-	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		if (likely(tx_info->control.vif)) {
-			struct rt2x00_intf *intf;
-
-			intf = vif_to_intf(tx_info->control.vif);
 
-			spin_lock_irqsave(&intf->seqlock, irqflags);
-
-			if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
-				intf->seqno += 0x10;
-			hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-			hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
-
-			spin_unlock_irqrestore(&intf->seqlock, irqflags);
-
-			__set_bit(ENTRY_TXD_GENERATE_SEQ, &txdesc->flags);
-		}
-	}
-
-	/*
-	 * PLCP setup
-	 * Length calculation depends on OFDM/CCK rate.
-	 */
 	hwrate = rt2x00_get_rate(rate->hw_value);
-	txdesc->signal = hwrate->plcp;
-	txdesc->service = 0x04;
-
-	if (hwrate->flags & DEV_RATE_OFDM) {
+	if (hwrate->flags & DEV_RATE_OFDM)
 		__set_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags);
 
-		txdesc->length_high = (data_length >> 6) & 0x3f;
-		txdesc->length_low = data_length & 0x3f;
-	} else {
-		/*
-		 * Convert length to microseconds.
-		 */
-		residual = GET_DURATION_RES(data_length, hwrate->bitrate);
-		duration = GET_DURATION(data_length, hwrate->bitrate);
-
-		if (residual != 0) {
-			duration++;
-
-			/*
-			 * Check if we need to set the Length Extension
-			 */
-			if (hwrate->bitrate == 110 && residual <= 30)
-				txdesc->service |= 0x80;
-		}
-
-		txdesc->length_high = (duration >> 8) & 0xff;
-		txdesc->length_low = duration & 0xff;
-
-		/*
-		 * When preamble is enabled we should set the
-		 * preamble bit for the signal.
-		 */
-		if (rt2x00_get_rate_preamble(rate->hw_value))
-			txdesc->signal |= 0x08;
-	}
+	/*
+	 * Apply TX descriptor handling by components
+	 */
+	rt2x00crypto_create_tx_descriptor(entry, txdesc);
+	rt2x00queue_create_tx_descriptor_seq(entry, txdesc);
+	rt2x00queue_create_tx_descriptor_plcp(entry, txdesc, rate);
 }
 
 static void rt2x00queue_write_tx_descriptor(struct queue_entry *entry,
-- 
1.5.6.1

