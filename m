Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:48112 "EHLO
	sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933481AbbCQKrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 06:47:43 -0400
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4] mac80211: Get IV len from key conf and not cipher scheme
Date: Tue, 17 Mar 2015 10:47:33 +0000
Message-ID: <5842EA9CC042B141995329508713AD672105BFDA@ILMAIL1.corp.local> (sfid-20150317_114758_426679_69B0B607)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


When a key is installed using a cipher scheme, a new internal
flag KEY_FLAG_CIPHER_SCHEME is set.
This flag is used on TX path to test for "cipher scheme"
key, instead of testing for sta->cipher_scheme as sta
is NULL for bcast/mcast messages.
For cipher scheme key, security header length is then
read from key->conf.iv_len initialized with cs->hdr_len.

Signed-off-by: Cedric Izoard <cedric.izoard@ceva-dsp.com>
---
 net/mac80211/key.c |  1 +
 net/mac80211/key.h |  1 +
 net/mac80211/wpa.c | 13 ++++++-------
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0825d76..2291cd7 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -492,6 +492,7 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 				for (j = 0; j < len; j++)
 					key->u.gen.rx_pn[i][j] =
 							seq[len - j - 1];
+			key->flags |= KEY_FLAG_CIPHER_SCHEME;
 		}
 	}
 	memcpy(key->conf.key, key_data, key_len);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index d57a9915..2fe2e2b 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -34,6 +34,7 @@ struct sta_info;
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
 	KEY_FLAG_TAINTED		= BIT(1),
+	KEY_FLAG_CIPHER_SCHEME		= BIT(2),
 };
 
 enum ieee80211_internal_tkip_state {
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 75de6fa..9d63d93 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -780,9 +780,8 @@ ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_key *key = tx->key;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	const struct ieee80211_cipher_scheme *cs = key->sta->cipher_scheme;
 	int hdrlen;
-	u8 *pos;
+	u8 *pos, iv_len = key->conf.iv_len;
 
 	if (info->control.hw_key &&
 	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
@@ -790,14 +789,14 @@ ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data *tx,
 		return TX_CONTINUE;
 	}
 
-	if (unlikely(skb_headroom(skb) < cs->hdr_len &&
-		     pskb_expand_head(skb, cs->hdr_len, 0, GFP_ATOMIC)))
+	if (unlikely(skb_headroom(skb) < iv_len &&
+		     pskb_expand_head(skb, iv_len, 0, GFP_ATOMIC)))
 		return TX_DROP;
 
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 
-	pos = skb_push(skb, cs->hdr_len);
-	memmove(pos, pos + cs->hdr_len, hdrlen);
+	pos = skb_push(skb, iv_len);
+	memmove(pos, pos + iv_len, hdrlen);
 
 	return TX_CONTINUE;
 }
@@ -1217,7 +1216,7 @@ ieee80211_crypto_hw_encrypt(struct ieee80211_tx_data *tx)
 		if (!info->control.hw_key)
 			return TX_DROP;
 
-		if (tx->key->sta->cipher_scheme) {
+		if (tx->key->flags & KEY_FLAG_CIPHER_SCHEME) {
 			res = ieee80211_crypto_cs_encrypt(tx, skb);
 			if (res != TX_CONTINUE)
 				return res;
-- 
1.9.1

