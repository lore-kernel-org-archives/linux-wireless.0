Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:29615 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYLCQac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 11:30:32 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1538562eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 08:30:31 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] rt2x00: Move crypto TX descriptor handling to rt2x00crypto.c
Date: Wed, 3 Dec 2008 17:29:48 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200812031729.21220.IvDoorn@gmail.com>
In-Reply-To: <200812031729.21220.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812031729.48357.IvDoorn@gmail.com> (sfid-20081203_173037_495835_9FF4C664)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move all code which determines the right TX descriptor
fields specific to crypto support into rt2x00crypto.c.
This makes the code in rt2x00queue more simpler and
better concentrates all crypto code into a single location.

With this we can also remove some ifdefs in rt2x00queue.c
since the code inside the ifdef is either very small, or
only calling empty functions (see empty function definitions
in rt2x00lib.h).

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   23 ++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2x00lib.h    |    9 +++++++-
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   29 ++++-----------------------
 3 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index c6709b3..37ad0d2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -46,6 +46,29 @@ enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *key)
 	}
 }
 
+void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
+				       struct txentry_desc *txdesc)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
+	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
+
+	__set_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags);
+
+	txdesc->cipher = rt2x00crypto_key_to_cipher(hw_key);
+
+	if (hw_key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
+		__set_bit(ENTRY_TXD_ENCRYPT_PAIRWISE, &txdesc->flags);
+
+	txdesc->key_idx = hw_key->hw_key_idx;
+	txdesc->iv_offset = ieee80211_get_hdrlen_from_skb(entry->skb);
+
+	if (!(hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV))
+		__set_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags);
+
+	if (!(hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+		__set_bit(ENTRY_TXD_ENCRYPT_MMIC, &txdesc->flags);
+}
+
 unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info)
 {
 	struct ieee80211_key_conf *key = tx_info->control.hw_key;
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index 1e18937..0302432 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -218,6 +218,8 @@ static inline void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
  */
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *key);
+void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
+				       struct txentry_desc *txdesc);
 unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info);
 void rt2x00crypto_tx_copy_iv(struct sk_buff *skb, unsigned int iv_len);
 void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, unsigned int iv_len);
@@ -231,6 +233,11 @@ static inline enum cipher rt2x00crypto_key_to_cipher(struct ieee80211_key_conf *
 	return CIPHER_NONE;
 }
 
+static inline void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
+						     struct txentry_desc *txdesc)
+{
+}
+
 static inline unsigned int rt2x00crypto_tx_overhead(struct ieee80211_tx_info *tx_info)
 {
 	return 0;
@@ -256,7 +263,7 @@ static inline void rt2x00crypto_rx_insert_iv(struct sk_buff *skb,
 					     struct rxdone_entry_desc *rxdesc)
 {
 }
-#endif
+#endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
 /*
  * RFkill handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index e4a1dbe..eaec6bd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -55,14 +55,12 @@ struct sk_buff *rt2x00queue_alloc_rxskb(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * For IV/EIV/ICV assembly we must make sure there is
 	 * at least 8 bytes bytes available in headroom for IV/EIV
-	 * and 4 bytes for ICV data as tailroon.
+	 * and 8 bytes for ICV data as tailroon.
 	 */
-#ifdef CONFIG_RT2X00_LIB_CRYPTO
 	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags)) {
 		head_size += 8;
-		tail_size += 4;
+		tail_size += 8;
 	}
-#endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
 	/*
 	 * Allocate skbuffer.
@@ -174,7 +172,7 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	txdesc->cw_max = entry->queue->cw_max;
 	txdesc->aifs = entry->queue->aifs;
 
-	/* Data length + CRC + IV/EIV/ICV/MMIC (when using encryption) */
+	/* Data length + CRC */
 	data_length = entry->skb->len + 4;
 
 	/*
@@ -183,34 +181,17 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK))
 		__set_bit(ENTRY_TXD_ACK, &txdesc->flags);
 
-#ifdef CONFIG_RT2X00_LIB_CRYPTO
 	if (test_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags) &&
 	    !entry->skb->do_not_encrypt) {
-		struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
-
-		__set_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags);
-
-		txdesc->cipher = rt2x00crypto_key_to_cipher(hw_key);
-
-		if (hw_key->flags & IEEE80211_KEY_FLAG_PAIRWISE)
-			__set_bit(ENTRY_TXD_ENCRYPT_PAIRWISE, &txdesc->flags);
-
-		txdesc->key_idx = hw_key->hw_key_idx;
-		txdesc->iv_offset = ieee80211_get_hdrlen_from_skb(entry->skb);
+		/* Apply crypto specific descriptor information */
+		rt2x00crypto_create_tx_descriptor(entry, txdesc);
 
 		/*
 		 * Extend frame length to include all encryption overhead
 		 * that will be added by the hardware.
 		 */
 		data_length += rt2x00crypto_tx_overhead(tx_info);
-
-		if (!(hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV))
-			__set_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags);
-
-		if (!(hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
-			__set_bit(ENTRY_TXD_ENCRYPT_MMIC, &txdesc->flags);
 	}
-#endif /* CONFIG_RT2X00_LIB_CRYPTO */
 
 	/*
 	 * Check if this is a RTS/CTS frame
-- 
1.5.6.1

