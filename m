Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sbg-il.ceva-dsp.com ([195.82.128.8]:46900 "EHLO
	sbg-il.ceva-dsp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbbCJJH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 05:07:29 -0400
From: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: Get IV len from key conf and not cipher scheme
Date: Tue, 10 Mar 2015 08:52:23 +0000
Message-ID: <5842EA9CC042B141995329508713AD672105A821@ILMAIL1.corp.local> (sfid-20150310_100735_628578_9618E0C0)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Do not always dereference sta to get cipher scheme as
it may be null for broadcast messages.
Instead get IV length from key configuration which has been
initialized with cipher scheme.

Signed-off-by: Cedric Izoard <cedric.izoard@ceva-dsp.com>
---
  net/mac80211/wpa.c | 19 ++++++++-----------
  1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 75de6fa..ccf7997 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -780,9 +780,8 @@ ieee80211_crypto_cs_encrypt(struct ieee80211_tx_data 
*tx,
  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
  	struct ieee80211_key *key = tx->key;
  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	const struct ieee80211_cipher_scheme *cs = key->sta->cipher_scheme;
  	int hdrlen;
-	u8 *pos;
+	u8 *pos, iv_len = key->conf.iv_len;

  	if (info->control.hw_key &&
  	    !(info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)) {
@@ -790,14 +789,14 @@ ieee80211_crypto_cs_encrypt(struct 
ieee80211_tx_data *tx,
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
@@ -1217,11 +1216,9 @@ ieee80211_crypto_hw_encrypt(struct 
ieee80211_tx_data *tx)
  		if (!info->control.hw_key)
  			return TX_DROP;

-		if (tx->key->sta->cipher_scheme) {
-			res = ieee80211_crypto_cs_encrypt(tx, skb);
-			if (res != TX_CONTINUE)
-				return res;
-		}
+		res = ieee80211_crypto_cs_encrypt(tx, skb);
+		if (res != TX_CONTINUE)
+			return res;
  	}

  	ieee80211_tx_set_protected(tx);
-- 
1.9.1
