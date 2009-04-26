Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54886 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZDZONX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 10:13:23 -0400
Received: by ewy24 with SMTP id 24so1732506ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 26 Apr 2009 07:13:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/5] rt2x00: Move iv_len into tx descriptor data
Date: Sun, 26 Apr 2009 16:08:30 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200904261608.30384.IvDoorn@gmail.com> (sfid-20090426_161330_326133_95C5E29F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By placing the iv_len into the tx descriptor data and
by passing this data to the crypto IV handlers we can
save multiple calls to ieee80211_get_hdrlen_from_skb()
and some if-statements when copying/removing the IV data
from the outgoing frame.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   19 +++++++++----------
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   10 ++++++----
 drivers/net/wireless/rt2x00/rt2x00queue.c  |    8 ++------
 drivers/net/wireless/rt2x00/rt2x00queue.h  |    2 ++
 4 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 0b41845..ae31581 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -66,6 +66,7 @@ void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 
 	txdesc->key_idx = hw_key->hw_key_idx;
 	txdesc->iv_offset = ieee80211_get_hdrlen_from_skb(entry->skb);
+	txdesc->iv_len = hw_key->iv_len;
 
 	if (!(hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV))
 		__set_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc->flags);
@@ -103,34 +104,32 @@ unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev,
 	return overhead;
 }
 
-void rt2x00crypto_tx_copy_iv(struct sk_buff *skb, unsigned int iv_len)
+void rt2x00crypto_tx_copy_iv(struct sk_buff *skb, struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	unsigned int header_length = ieee80211_get_hdrlen_from_skb(skb);
 
-	if (unlikely(!iv_len))
+	if (unlikely(!txdesc->iv_len))
 		return;
 
 	/* Copy IV/EIV data */
-	memcpy(skbdesc->iv, skb->data + header_length, iv_len);
+	memcpy(skbdesc->iv, skb->data + txdesc->iv_offset, txdesc->iv_len);
 }
 
-void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, unsigned int iv_len)
+void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, struct txentry_desc *txdesc)
 {
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
-	unsigned int header_length = ieee80211_get_hdrlen_from_skb(skb);
 
-	if (unlikely(!iv_len))
+	if (unlikely(!txdesc->iv_len))
 		return;
 
 	/* Copy IV/EIV data */
-	memcpy(skbdesc->iv, skb->data + header_length, iv_len);
+	memcpy(skbdesc->iv, skb->data + txdesc->iv_offset, txdesc->iv_len);
 
 	/* Move ieee80211 header */
-	memmove(skb->data + iv_len, skb->data, header_length);
+	memmove(skb->data + txdesc->iv_len, skb->data, txdesc->iv_offset);
 
 	/* Pull buffer to correct size */
-	skb_pull(skb, iv_len);
+	skb_pull(skb, txdesc->iv_len);
 
 	/* IV/EIV data has officially be stripped */
 	skbdesc->flags |= FRAME_DESC_IV_STRIPPED;
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wireless/rt2x00/rt2x00lib.h
index a631613..af3c47b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -295,8 +295,10 @@ void rt2x00crypto_create_tx_descriptor(struct queue_entry *entry,
 				       struct txentry_desc *txdesc);
 unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev,
 				      struct sk_buff *skb);
-void rt2x00crypto_tx_copy_iv(struct sk_buff *skb, unsigned int iv_len);
-void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, unsigned int iv_len);
+void rt2x00crypto_tx_copy_iv(struct sk_buff *skb,
+			     struct txentry_desc *txdesc);
+void rt2x00crypto_tx_remove_iv(struct sk_buff *skb,
+			       struct txentry_desc *txdesc);
 void rt2x00crypto_tx_insert_iv(struct sk_buff *skb);
 void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, unsigned int align,
 			       unsigned int header_length,
@@ -319,12 +321,12 @@ static inline unsigned int rt2x00crypto_tx_overhead(struct rt2x00_dev *rt2x00dev
 }
 
 static inline void rt2x00crypto_tx_copy_iv(struct sk_buff *skb,
-					   unsigned int iv_len)
+					   struct txentry_desc *txdesc)
 {
 }
 
 static inline void rt2x00crypto_tx_remove_iv(struct sk_buff *skb,
-					     unsigned int iv_len)
+					     struct txentry_desc *txdesc)
 {
 }
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index a5664bd..6f78915 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -368,7 +368,6 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	struct queue_entry *entry = rt2x00queue_get_entry(queue, Q_INDEX);
 	struct txentry_desc txdesc;
 	struct skb_frame_desc *skbdesc;
-	unsigned int iv_len = 0;
 	u8 rate_idx, rate_flags;
 
 	if (unlikely(rt2x00queue_full(queue)))
@@ -390,9 +389,6 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	entry->skb = skb;
 	rt2x00queue_create_tx_descriptor(entry, &txdesc);
 
-	if (IEEE80211_SKB_CB(skb)->control.hw_key != NULL)
-		iv_len = IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;
-
 	/*
 	 * All information is retrieved from the skb->cb array,
 	 * now we should claim ownership of the driver part of that
@@ -415,9 +411,9 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
 	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags)) {
 		if (test_bit(DRIVER_REQUIRE_COPY_IV, &queue->rt2x00dev->flags))
-			rt2x00crypto_tx_copy_iv(skb, iv_len);
+			rt2x00crypto_tx_copy_iv(skb, &txdesc);
 		else
-			rt2x00crypto_tx_remove_iv(skb, iv_len);
+			rt2x00crypto_tx_remove_iv(skb, &txdesc);
 	}
 
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 97e2ab0..e3bfd73 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -280,6 +280,7 @@ enum txentry_desc_flags {
  * @cipher: Cipher type used for encryption.
  * @key_idx: Key index used for encryption.
  * @iv_offset: Position where IV should be inserted by hardware.
+ * @iv_len: Length of IV data.
  */
 struct txentry_desc {
 	unsigned long flags;
@@ -302,6 +303,7 @@ struct txentry_desc {
 	enum cipher cipher;
 	u16 key_idx;
 	u16 iv_offset;
+	u16 iv_len;
 };
 
 /**
-- 
1.6.2.3

