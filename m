Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:57373 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbYGBXbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 19:31:01 -0400
Received: by wa-out-1112.google.com with SMTP id j37so358818waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jul 2008 16:31:00 -0700 (PDT)
Subject: [PATCH 3/4] mac80211: pass scratch buffer directly, remove
	additional pointers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 16:30:52 -0700
Message-Id: <1215041452.16647.8.camel@brick> (sfid-20080703_013105_963246_DA1678DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recalculate the offset pointers in the ccmp calculations rather than
in the callers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/aes_ccm.c |   13 ++++++++-----
 net/mac80211/aes_ccm.h |    4 ++--
 net/mac80211/wpa.c     |   26 ++++++++++----------------
 3 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index 4d4c2df..e756ed9 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -53,15 +53,17 @@ static inline void aes_ccm_prepare(struct crypto_cipher *tfm, u8 *b_0, u8 *aad,
 

 void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
-			       u8 *b_0, u8 *aad, u8 *data, size_t data_len,
+			       u8 *data, size_t data_len,
 			       u8 *cdata, u8 *mic)
 {
 	int i, j, last_len, num_blocks;
-	u8 *pos, *cpos, *b, *s_0, *e;
+	u8 *pos, *cpos, *b, *s_0, *e, *b_0, *aad;
 
 	b = scratch;
 	s_0 = scratch + AES_BLOCK_LEN;
 	e = scratch + 2 * AES_BLOCK_LEN;
+	b_0 = scratch + 3 * AES_BLOCK_LEN;
+	aad = scratch + 4 * AES_BLOCK_LEN;
 
 	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
 	last_len = data_len % AES_BLOCK_LEN;
@@ -92,15 +94,16 @@ void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
 

 int ieee80211_aes_ccm_decrypt(struct crypto_cipher *tfm, u8 *scratch,
-			      u8 *b_0, u8 *aad, u8 *cdata, size_t data_len,
-			      u8 *mic, u8 *data)
+			      u8 *cdata, size_t data_len, u8 *mic, u8 *data)
 {
 	int i, j, last_len, num_blocks;
-	u8 *pos, *cpos, *b, *s_0, *a;
+	u8 *pos, *cpos, *b, *s_0, *a, *b_0, *aad;
 
 	b = scratch;
 	s_0 = scratch + AES_BLOCK_LEN;
 	a = scratch + 2 * AES_BLOCK_LEN;
+	b_0 = scratch + 3 * AES_BLOCK_LEN;
+	aad = scratch + 4 * AES_BLOCK_LEN;
 
 	num_blocks = DIV_ROUND_UP(data_len, AES_BLOCK_LEN);
 	last_len = data_len % AES_BLOCK_LEN;
diff --git a/net/mac80211/aes_ccm.h b/net/mac80211/aes_ccm.h
index 8cd0f14..6e7820e 100644
--- a/net/mac80211/aes_ccm.h
+++ b/net/mac80211/aes_ccm.h
@@ -16,10 +16,10 @@
 
 struct crypto_cipher *ieee80211_aes_key_setup_encrypt(const u8 key[]);
 void ieee80211_aes_ccm_encrypt(struct crypto_cipher *tfm, u8 *scratch,
-			       u8 *b_0, u8 *aad, u8 *data, size_t data_len,
+			       u8 *data, size_t data_len,
 			       u8 *cdata, u8 *mic);
 int ieee80211_aes_ccm_decrypt(struct crypto_cipher *tfm, u8 *scratch,
-			      u8 *b_0, u8 *aad, u8 *cdata, size_t data_len,
+			      u8 *cdata, size_t data_len,
 			      u8 *mic, u8 *data);
 void ieee80211_aes_key_free(struct crypto_cipher *tfm);
 
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index ec2ae86..2f33df0 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -274,16 +274,20 @@ ieee80211_crypto_tkip_decrypt(struct ieee80211_rx_data *rx)
 }
 

-static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *b_0, u8 *aad,
+static void ccmp_special_blocks(struct sk_buff *skb, u8 *pn, u8 *scratch,
 				int encrypted)
 {
 	__le16 mask_fc;
 	int a4_included;
 	u8 qos_tid;
+	u8 *b_0, *aad;
 	u16 data_len, len_a;
 	unsigned int hdrlen;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 
+	b_0 = scratch + 3 * AES_BLOCK_LEN;
+	aad = scratch + 4 * AES_BLOCK_LEN;
+
 	/*
 	 * Mask FC: zero subtype b4 b5 b6
 	 * Retry, PwrMgt, MoreData; set Protected
@@ -367,7 +371,7 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, len, tail;
-	u8 *pos, *pn, *b_0, *aad, *scratch;
+	u8 *pos, *pn;
 	int i;
 
 	info->control.icv_len = CCMP_MIC_LEN;
@@ -381,10 +385,6 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 		return 0;
 	}
 
-	scratch = key->u.ccmp.tx_crypto_buf;
-	b_0 = scratch + 3 * AES_BLOCK_LEN;
-	aad = scratch + 4 * AES_BLOCK_LEN;
-
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	len = skb->len - hdrlen;
 
@@ -420,8 +420,8 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	}
 
 	pos += CCMP_HDR_LEN;
-	ccmp_special_blocks(skb, pn, b_0, aad, 0);
-	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, scratch, b_0, aad, pos, len,
+	ccmp_special_blocks(skb, pn, key->u.ccmp.tx_crypto_buf, 0);
+	ieee80211_aes_ccm_encrypt(key->u.ccmp.tfm, key->u.ccmp.tx_crypto_buf, pos, len,
 				  pos, skb_put(skb, CCMP_MIC_LEN));
 
 	return 0;
@@ -483,16 +483,10 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx)
 
 	if (!(rx->status->flag & RX_FLAG_DECRYPTED)) {
 		/* hardware didn't decrypt/verify MIC */
-		u8 *scratch, *b_0, *aad;
-
-		scratch = key->u.ccmp.rx_crypto_buf;
-		b_0 = scratch + 3 * AES_BLOCK_LEN;
-		aad = scratch + 4 * AES_BLOCK_LEN;
-
-		ccmp_special_blocks(skb, pn, b_0, aad, 1);
+		ccmp_special_blocks(skb, pn, key->u.ccmp.rx_crypto_buf, 1);
 
 		if (ieee80211_aes_ccm_decrypt(
-			    key->u.ccmp.tfm, scratch, b_0, aad,
+			    key->u.ccmp.tfm, key->u.ccmp.rx_crypto_buf,
 			    skb->data + hdrlen + CCMP_HDR_LEN, data_len,
 			    skb->data + skb->len - CCMP_MIC_LEN,
 			    skb->data + hdrlen + CCMP_HDR_LEN)) {
-- 
1.5.6.1.242.g4f9d0


