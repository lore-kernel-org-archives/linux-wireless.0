Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:61376 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbYLBRXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 12:23:12 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1637200nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 09:23:10 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/5] rt2x00: Optimize IV/EIV handling
Date: Tue, 2 Dec 2008 18:19:48 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200812021819.23756.IvDoorn@gmail.com>
In-Reply-To: <200812021819.23756.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812021819.48603.IvDoorn@gmail.com> (sfid-20081202_182318_091955_539A174A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IV and EIV belong to eachother and don't require
2 seperate fields. Instead they can logically be
merged into a single array with size 2.

With this approach we can simplify the code in
rt2x00crypto.c by using a single memcpy() when
copying the iv/eiv data. Additionally we can
move some code out of if-statements because the
if-statement would always be true.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00crypto.c |   44 +++++++++-------------------
 drivers/net/wireless/rt2x00/rt2x00queue.h  |   12 ++-----
 drivers/net/wireless/rt2x00/rt61pci.c      |    8 ++--
 drivers/net/wireless/rt2x00/rt73usb.c      |    8 ++--
 4 files changed, 26 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index 5a858e5..e0fc7c1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -78,10 +78,7 @@ void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, unsigned int iv_len)
 		return;
 
 	/* Copy IV/EIV data */
-	if (iv_len >= 4)
-		memcpy(&skbdesc->iv, skb->data + header_length, 4);
-	if (iv_len >= 8)
-		memcpy(&skbdesc->eiv, skb->data + header_length + 4, 4);
+	memcpy(skbdesc->iv, skb->data + header_length, iv_len);
 
 	/* Move ieee80211 header */
 	memmove(skb->data + iv_len, skb->data, header_length);
@@ -98,7 +95,7 @@ void rt2x00crypto_tx_insert_iv(struct sk_buff *skb)
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
 	unsigned int header_length = ieee80211_get_hdrlen_from_skb(skb);
 	const unsigned int iv_len =
-	    ((!!(skbdesc->iv)) * 4) + ((!!(skbdesc->eiv)) * 4);
+	    ((!!(skbdesc->iv[0])) * 4) + ((!!(skbdesc->iv[1])) * 4);
 
 	if (!(skbdesc->flags & FRAME_DESC_IV_STRIPPED))
 		return;
@@ -109,10 +106,7 @@ void rt2x00crypto_tx_insert_iv(struct sk_buff *skb)
 	memmove(skb->data, skb->data + iv_len, header_length);
 
 	/* Copy IV/EIV data */
-	if (iv_len >= 4)
-		memcpy(skb->data + header_length, &skbdesc->iv, 4);
-	if (iv_len >= 8)
-		memcpy(skb->data + header_length + 4, &skbdesc->eiv, 4);
+	memcpy(skb->data + header_length, skbdesc->iv, iv_len);
 
 	/* IV/EIV data has returned into the frame */
 	skbdesc->flags &= ~FRAME_DESC_IV_STRIPPED;
@@ -172,17 +166,9 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, unsigned int align,
 		header_length);
 	transfer += header_length;
 
-	/* Copy IV data */
-	if (iv_len >= 4) {
-		memcpy(skb->data + transfer, &rxdesc->iv, 4);
-		transfer += 4;
-	}
-
-	/* Copy EIV data */
-	if (iv_len >= 8) {
-		memcpy(skb->data + transfer, &rxdesc->eiv, 4);
-		transfer += 4;
-	}
+	/* Copy IV/EIV data */
+	memcpy(skb->data + transfer, rxdesc->iv, iv_len);
+	transfer += iv_len;
 
 	/* Move payload */
 	if (align) {
@@ -198,16 +184,14 @@ void rt2x00crypto_rx_insert_iv(struct sk_buff *skb, unsigned int align,
 	 */
 	transfer += payload_len;
 
-	/* Copy ICV data */
-	if (icv_len >= 4) {
-		memcpy(skb->data + transfer, &rxdesc->icv, 4);
-		/*
-		 * AES appends 8 bytes, we can't fill the upper
-		 * 4 bytes, but mac80211 doesn't care about what
-		 * we provide here anyway and strips it immediately.
-		 */
-		transfer += icv_len;
-	}
+	/*
+	 * Copy ICV data
+	 * AES appends 8 bytes, we can't fill the upper
+	 * 4 bytes, but mac80211 doesn't care about what
+	 * we provide here anyway and strips it immediately.
+	 */
+	memcpy(skb->data + transfer, &rxdesc->icv, 4);
+	transfer += icv_len;
 
 	/* IV/EIV/ICV has been inserted into frame */
 	rxdesc->size = transfer;
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 2e99ab5..7889f91 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -109,8 +109,7 @@ enum skb_frame_desc_flags {
  * @desc: Pointer to descriptor part of the frame.
  *	Note that this pointer could point to something outside
  *	of the scope of the skb->data pointer.
- * @iv: IV data used during encryption/decryption.
- * @eiv: EIV data used during encryption/decryption.
+ * @iv: IV/EIV data used during encryption/decryption.
  * @skb_dma: (PCI-only) the DMA address associated with the sk buffer.
  * @entry: The entry to which this sk buffer belongs.
  */
@@ -123,8 +122,7 @@ struct skb_frame_desc {
 
 	void *desc;
 
-	__le32 iv;
-	__le32 eiv;
+	__le32 iv[2];
 
 	dma_addr_t skb_dma;
 
@@ -168,8 +166,7 @@ enum rxdone_entry_desc_flags {
  * @dev_flags: Ralink receive flags (See &enum rxdone_entry_desc_flags).
  * @cipher: Cipher type used during decryption.
  * @cipher_status: Decryption status.
- * @iv: IV data used during decryption.
- * @eiv: EIV data used during decryption.
+ * @iv: IV/EIV data used during decryption.
  * @icv: ICV data used during decryption.
  */
 struct rxdone_entry_desc {
@@ -182,8 +179,7 @@ struct rxdone_entry_desc {
 	u8 cipher;
 	u8 cipher_status;
 
-	__le32 iv;
-	__le32 eiv;
+	__le32 iv[2];
 	__le32 icv;
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index a66f80a..ce0fde4 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1778,8 +1778,8 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 2, word);
 
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
-		_rt2x00_desc_write(txd, 3, skbdesc->iv);
-		_rt2x00_desc_write(txd, 4, skbdesc->eiv);
+		_rt2x00_desc_write(txd, 3, skbdesc->iv[0]);
+		_rt2x00_desc_write(txd, 4, skbdesc->iv[1]);
 	}
 
 	rt2x00_desc_read(txd, 5, &word);
@@ -1949,8 +1949,8 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
 	}
 
 	if (rxdesc->cipher != CIPHER_NONE) {
-		_rt2x00_desc_read(entry_priv->desc, 2, &rxdesc->iv);
-		_rt2x00_desc_read(entry_priv->desc, 3, &rxdesc->eiv);
+		_rt2x00_desc_read(entry_priv->desc, 2, &rxdesc->iv[0]);
+		_rt2x00_desc_read(entry_priv->desc, 3, &rxdesc->iv[1]);
 		_rt2x00_desc_read(entry_priv->desc, 4, &rxdesc->icv);
 
 		/*
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 0c39384..79475a8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1428,8 +1428,8 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_desc_write(txd, 2, word);
 
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags)) {
-		_rt2x00_desc_write(txd, 3, skbdesc->iv);
-		_rt2x00_desc_write(txd, 4, skbdesc->eiv);
+		_rt2x00_desc_write(txd, 3, skbdesc->iv[0]);
+		_rt2x00_desc_write(txd, 4, skbdesc->iv[1]);
 	}
 
 	rt2x00_desc_read(txd, 5, &word);
@@ -1618,8 +1618,8 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 	}
 
 	if (rxdesc->cipher != CIPHER_NONE) {
-		_rt2x00_desc_read(rxd, 2, &rxdesc->iv);
-		_rt2x00_desc_read(rxd, 3, &rxdesc->eiv);
+		_rt2x00_desc_read(rxd, 2, &rxdesc->iv[0]);
+		_rt2x00_desc_read(rxd, 3, &rxdesc->iv[1]);
 		_rt2x00_desc_read(rxd, 4, &rxdesc->icv);
 
 		/*
-- 
1.5.6.1

