Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:57362 "EHLO
	sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbCKPGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 11:06:23 -0400
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: johannes Berg <johannes@sipsolutions.net>,
	"Stepanov, Max" <Max.Stepanov@intel.com>
Subject: [PATCH v3] mac80211: Get-IV-len-from-key-conf-and-not-cipher-scheme
Date: Wed, 11 Mar 2015 15:06:16 +0000
Message-ID: <5842EA9CC042B141995329508713AD672105ACA7@ILMAIL1.corp.local> (sfid-20150311_160627_231608_5E9414DE)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a key is installed using a cipher scheme, a new flag
IEE80211_KEY_FLAG_CIPHER_SCHEME is set.
This flag is used on TX path to test for "cipher scheme"
key, instead of testing for sta->cipher_scheme as sta
is NULL for bcast/mcast messages.
For cipher scheme key, security header length is then
read from key->conf.iv_len initialized with cs->hdr_len.
---
 include/net/mac80211.h |  5 ++++-
 net/mac80211/key.c     |  1 +
 net/mac80211/wpa.c     | 13 ++++++-------
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a7756e4..74af5cf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1318,6 +1318,8 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
  * @IEEE80211_KEY_FLAG_RESERVE_TAILROOM: This flag should be set by the
  *	driver for a key to indicate that sufficient tailroom must always
  *	be reserved for ICV or MIC, even when HW encryption is enabled.
+ * @IEEE80211_KEY_FLAG_CIPHER_SCHEME: Set by mac80211, this flag indicates
+ *      that the key has been installed using a cipher scheme.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(0),
@@ -1328,6 +1330,7 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_PUT_IV_SPACE		= BIT(5),
 	IEEE80211_KEY_FLAG_RX_MGMT		= BIT(6),
 	IEEE80211_KEY_FLAG_RESERVE_TAILROOM	= BIT(7),
+	IEEE80211_KEY_FLAG_CIPHER_SCHEME	= BIT(8),
 };
 
 /**
@@ -1356,7 +1359,7 @@ struct ieee80211_key_conf {
 	u8 icv_len;
 	u8 iv_len;
 	u8 hw_key_idx;
-	u8 flags;
+	u16 flags;
 	s8 keyidx;
 	u8 keylen;
 	u8 key[0];
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 0825d76..10870a6 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -492,6 +492,7 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 				for (j = 0; j < len; j++)
 					key->u.gen.rx_pn[i][j] =
 							seq[len - j - 1];
+			key->conf.flags |= IEEE80211_KEY_FLAG_CIPHER_SCHEME;
 		}
 	}
 	memcpy(key->conf.key, key_data, key_len);
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 75de6fa..5f21bd3 100644
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
+		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_CIPHER_SCHEME) {
 			res = ieee80211_crypto_cs_encrypt(tx, skb);
 			if (res != TX_CONTINUE)
 				return res;
-- 
1.9.1
