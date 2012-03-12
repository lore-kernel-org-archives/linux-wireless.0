Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2CLMv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 08:51:59 -0400
Message-Id: <20120312125128.723482995@sipsolutions.net> (sfid-20120312_135203_327006_327D9C85)
Date: Mon, 12 Mar 2012 13:49:13 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: move RX WEP weak IV counting
References: <20120312124912.474580156@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is better done inside the WEP decrypt
function where it doesn't have to check all
the conditions any more since they've been
tested already.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c  |    7 -------
 net/mac80211/wep.c |   10 ++++++----
 net/mac80211/wep.h |    1 -
 3 files changed, 6 insertions(+), 12 deletions(-)

--- a/net/mac80211/rx.c	2012-03-12 13:22:21.000000000 +0100
+++ b/net/mac80211/rx.c	2012-03-12 13:22:57.000000000 +0100
@@ -1070,13 +1070,6 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	switch (rx->key->conf.cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 	case WLAN_CIPHER_SUITE_WEP104:
-		/* Check for weak IVs if possible */
-		if (rx->sta && ieee80211_is_data(fc) &&
-		    (!(status->flag & RX_FLAG_IV_STRIPPED) ||
-		     !(status->flag & RX_FLAG_DECRYPTED)) &&
-		    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
-			rx->sta->wep_weak_iv_count++;
-
 		result = ieee80211_crypto_wep_decrypt(rx);
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
--- a/net/mac80211/wep.c	2012-03-12 13:22:21.000000000 +0100
+++ b/net/mac80211/wep.c	2012-03-12 13:22:57.000000000 +0100
@@ -263,16 +263,14 @@ static int ieee80211_wep_decrypt(struct
 }
 
 
-bool ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key)
+static bool ieee80211_wep_is_weak_iv(struct sk_buff *skb,
+				     struct ieee80211_key *key)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	unsigned int hdrlen;
 	u8 *ivpos;
 	u32 iv;
 
-	if (!ieee80211_has_protected(hdr->frame_control))
-		return false;
-
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	ivpos = skb->data + hdrlen;
 	iv = (ivpos[0] << 16) | (ivpos[1] << 8) | ivpos[2];
@@ -292,9 +290,13 @@ ieee80211_crypto_wep_decrypt(struct ieee
 		return RX_CONTINUE;
 
 	if (!(status->flag & RX_FLAG_DECRYPTED)) {
+		if (rx->sta && ieee80211_wep_is_weak_iv(rx->skb, rx->key))
+			rx->sta->wep_weak_iv_count++;
 		if (ieee80211_wep_decrypt(rx->local, rx->skb, rx->key))
 			return RX_DROP_UNUSABLE;
 	} else if (!(status->flag & RX_FLAG_IV_STRIPPED)) {
+		if (rx->sta && ieee80211_wep_is_weak_iv(rx->skb, rx->key))
+			rx->sta->wep_weak_iv_count++;
 		ieee80211_wep_remove_iv(rx->local, rx->skb, rx->key);
 		/* remove ICV */
 		skb_trim(rx->skb, rx->skb->len - WEP_ICV_LEN);
--- a/net/mac80211/wep.h	2012-03-12 13:22:21.000000000 +0100
+++ b/net/mac80211/wep.h	2012-03-12 13:22:57.000000000 +0100
@@ -25,7 +25,6 @@ int ieee80211_wep_encrypt(struct ieee802
 			  const u8 *key, int keylen, int keyidx);
 int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 			       size_t klen, u8 *data, size_t data_len);
-bool ieee80211_wep_is_weak_iv(struct sk_buff *skb, struct ieee80211_key *key);
 
 ieee80211_rx_result
 ieee80211_crypto_wep_decrypt(struct ieee80211_rx_data *rx);


