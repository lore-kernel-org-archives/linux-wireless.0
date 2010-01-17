Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab0AQAtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 19:49:13 -0500
Message-Id: <20100117004825.177097479@sipsolutions.net>
Date: Sun, 17 Jan 2010 01:47:58 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] mac80211: move control.hw_key assignment
References: <20100117004754.624627000@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 asks a driver to encrypt a frame, it
must assign the control.hw_key pointer for it to
know which key to use etc. Currently, mac80211 does
this whenever it would software-encrypt a frame.

Change the logic of this code to assign the hw_key
pointer when selecting the key, and later check it
when deciding whether to encrypt the frame or let
it be encrypted by the hardware. This allows us to
later simply skip the encryption function since it
no longer modifies the TX control.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tkip.c |   11 +++++-----
 net/mac80211/tx.c   |    9 ++++++++
 net/mac80211/wep.c  |   18 ++++++++--------
 net/mac80211/wpa.c  |   57 ++++++++++++++++++++--------------------------------
 4 files changed, 46 insertions(+), 49 deletions(-)

--- wireless-testing.orig/net/mac80211/tkip.c	2010-01-16 20:07:39.000000000 +0100
+++ wireless-testing/net/mac80211/tkip.c	2010-01-16 20:19:10.000000000 +0100
@@ -195,11 +195,13 @@ void ieee80211_get_tkip_key(struct ieee8
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_key);
 
-/* Encrypt packet payload with TKIP using @key. @pos is a pointer to the
+/*
+ * Encrypt packet payload with TKIP using @key. @pos is a pointer to the
  * beginning of the buffer containing payload. This payload must include
- * headroom of eight octets for IV and Ext. IV and taildroom of four octets
- * for ICV. @payload_len is the length of payload (_not_ including extra
- * headroom and tailroom). @ta is the transmitter addresses. */
+ * the IV/Ext.IV and space for (taildroom) four octets for ICV.
+ * @payload_len is the length of payload (_not_ including IV/ICV length).
+ * @ta is the transmitter addresses.
+ */
 void ieee80211_tkip_encrypt_data(struct crypto_blkcipher *tfm,
 				 struct ieee80211_key *key,
 				 u8 *pos, size_t payload_len, u8 *ta)
@@ -214,7 +216,6 @@ void ieee80211_tkip_encrypt_data(struct 
 
 	tkip_mixing_phase2(tk, ctx, ctx->iv16, rc4key);
 
-	pos = ieee80211_tkip_add_iv(pos, key, key->u.tkip.tx.iv16);
 	ieee80211_wep_encrypt_data(tfm, rc4key, 16, pos, payload_len);
 }
 
--- wireless-testing.orig/net/mac80211/wpa.c	2010-01-16 20:07:39.000000000 +0100
+++ wireless-testing/net/mac80211/wpa.c	2010-01-16 20:19:10.000000000 +0100
@@ -31,8 +31,8 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	unsigned int hdrlen;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb = tx->skb;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int authenticator;
-	int wpa_test = 0;
 	int tail;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -47,16 +47,15 @@ ieee80211_tx_h_michael_mic_add(struct ie
 	data = skb->data + hdrlen;
 	data_len = skb->len - hdrlen;
 
-	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
+	if (info->control.hw_key &&
 	    !(tx->flags & IEEE80211_TX_FRAGMENTED) &&
-	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) &&
-	    !wpa_test) {
-		/* hwaccel - with no need for preallocated room for MMIC */
+	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)) {
+		/* hwaccel - with no need for SW-generated MMIC */
 		return TX_CONTINUE;
 	}
 
 	tail = MICHAEL_MIC_LEN;
-	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+	if (!info->control.hw_key)
 		tail += TKIP_ICV_LEN;
 
 	if (WARN_ON(skb_tailroom(skb) < tail ||
@@ -147,17 +146,16 @@ static int tkip_encrypt_skb(struct ieee8
 	int len, tail;
 	u8 *pos;
 
-	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
-		/* hwaccel - with no need for preallocated room for IV/ICV */
-		info->control.hw_key = &tx->key->conf;
+	if (info->control.hw_key &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+		/* hwaccel - with no need for software-generated IV */
 		return 0;
 	}
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	len = skb->len - hdrlen;
 
-	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+	if (info->control.hw_key)
 		tail = 0;
 	else
 		tail = TKIP_ICV_LEN;
@@ -175,13 +173,11 @@ static int tkip_encrypt_skb(struct ieee8
 	if (key->u.tkip.tx.iv16 == 0)
 		key->u.tkip.tx.iv32++;
 
-	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-		/* hwaccel - with preallocated room for IV */
-		ieee80211_tkip_add_iv(pos, key, key->u.tkip.tx.iv16);
+	pos = ieee80211_tkip_add_iv(pos, key, key->u.tkip.tx.iv16);
 
-		info->control.hw_key = &tx->key->conf;
+	/* hwaccel - with software IV */
+	if (info->control.hw_key)
 		return 0;
-	}
 
 	/* Add room for ICV */
 	skb_put(skb, TKIP_ICV_LEN);
@@ -363,24 +359,20 @@ static int ccmp_encrypt_skb(struct ieee8
 	int hdrlen, len, tail;
 	u8 *pos, *pn;
 	int i;
-	bool skip_hw;
-
-	skip_hw = (tx->key->conf.flags & IEEE80211_KEY_FLAG_SW_MGMT) &&
-		ieee80211_is_mgmt(hdr->frame_control);
 
-	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) &&
-	    !(tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) &&
-	    !skip_hw) {
-		/* hwaccel - with no need for preallocated room for CCMP
-		 * header or MIC fields */
-		info->control.hw_key = &tx->key->conf;
+	if (info->control.hw_key &&
+	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV)) {
+		/*
+		 * hwaccel has no need for preallocated room for CCMP
+		 * header or MIC fields
+		 */
 		return 0;
 	}
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	len = skb->len - hdrlen;
 
-	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+	if (info->control.hw_key)
 		tail = 0;
 	else
 		tail = CCMP_MIC_LEN;
@@ -405,11 +397,9 @@ static int ccmp_encrypt_skb(struct ieee8
 
 	ccmp_pn2hdr(pos, pn, key->conf.keyidx);
 
-	if ((key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) && !skip_hw) {
-		/* hwaccel - with preallocated room for CCMP header */
-		info->control.hw_key = &tx->key->conf;
+	/* hwaccel - with software CCMP header */
+	if (info->control.hw_key)
 		return 0;
-	}
 
 	pos += CCMP_HDR_LEN;
 	ccmp_special_blocks(skb, pn, key->u.ccmp.tx_crypto_buf, 0);
@@ -525,11 +515,8 @@ ieee80211_crypto_aes_cmac_encrypt(struct
 	u8 *pn, aad[20];
 	int i;
 
-	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
-		/* hwaccel */
-		info->control.hw_key = &tx->key->conf;
+	if (info->control.hw_key)
 		return 0;
-	}
 
 	if (WARN_ON(skb_tailroom(skb) < sizeof(*mmie)))
 		return TX_DROP;
--- wireless-testing.orig/net/mac80211/wep.c	2010-01-16 20:07:39.000000000 +0100
+++ wireless-testing/net/mac80211/wep.c	2010-01-16 20:19:10.000000000 +0100
@@ -305,20 +305,20 @@ static int wep_encrypt_skb(struct ieee80
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
-	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
+	if (!info->control.hw_key) {
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key->conf.key,
 					  tx->key->conf.keylen,
 					  tx->key->conf.keyidx))
 			return -1;
-	} else {
-		info->control.hw_key = &tx->key->conf;
-		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
-			if (!ieee80211_wep_add_iv(tx->local, skb,
-						  tx->key->conf.keylen,
-						  tx->key->conf.keyidx))
-				return -1;
-		}
 	}
+
+	if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
+		if (!ieee80211_wep_add_iv(tx->local, skb,
+					  tx->key->conf.keylen,
+					  tx->key->conf.keyidx))
+			return -1;
+	}
+
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/tx.c	2010-01-16 20:19:05.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2010-01-16 20:19:10.000000000 +0100
@@ -529,6 +529,8 @@ ieee80211_tx_h_select_key(struct ieee802
 		tx->key = NULL;
 
 	if (tx->key) {
+		bool skip_hw = false;
+
 		tx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 
@@ -545,12 +547,19 @@ ieee80211_tx_h_select_key(struct ieee802
 			    !ieee80211_use_mfp(hdr->frame_control, tx->sta,
 					       tx->skb))
 				tx->key = NULL;
+			skip_hw = (tx->key->conf.flags &
+						IEEE80211_KEY_FLAG_SW_MGMT) &&
+				   ieee80211_is_mgmt(hdr->frame_control);
 			break;
 		case ALG_AES_CMAC:
 			if (!ieee80211_is_mgmt(hdr->frame_control))
 				tx->key = NULL;
 			break;
 		}
+
+		if (!skip_hw &&
+		    tx->key->conf.flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+			info->control.hw_key = &tx->key->conf;
 	}
 
 	return TX_CONTINUE;


