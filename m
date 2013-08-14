Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52408 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759823Ab3HNNbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 09:31:06 -0400
Received: by mail-lb0-f170.google.com with SMTP id r10so6901663lbi.15
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 06:31:04 -0700 (PDT)
From: Johan Almbladh <ja@anyfi.net>
To: johannes@sipsolutions.net
Cc: ordex@autistici.org, linux-wireless@vger.kernel.org,
	Johan Almbladh <ja@anyfi.net>
Subject: [PATCHv2 2/2] mac80211: non-functional change of rx handler location
Date: Wed, 14 Aug 2013 15:29:47 +0200
Message-Id: <1376486987-23224-2-git-send-email-ja@anyfi.net> (sfid-20130814_153112_557821_8B124EC1)
In-Reply-To: <1376486987-23224-1-git-send-email-ja@anyfi.net>
References: <1376323275.11514.26.camel@jlt4.sipsolutions.net>
 <1376486987-23224-1-git-send-email-ja@anyfi.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the location of the rx handler functions to match
the new order in which they are invoked.

Tested-by: Johan Almbladh <ja@anyfi.net>
Signed-off-by: Johan Almbladh <ja@anyfi.net>
---
 net/mac80211/rx.c |  402 ++++++++++++++++++++++++++---------------------------
 1 file changed, 201 insertions(+), 201 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0f0017d..a84f319 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1055,207 +1055,6 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
-{
-	struct sk_buff *skb = rx->skb;
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	int keyidx;
-	int hdrlen;
-	ieee80211_rx_result result = RX_DROP_UNUSABLE;
-	struct ieee80211_key *sta_ptk = NULL;
-	int mmie_keyidx = -1;
-	__le16 fc;
-
-	/*
-	 * Key selection 101
-	 *
-	 * There are four types of keys:
-	 *  - GTK (group keys)
-	 *  - IGTK (group keys for management frames)
-	 *  - PTK (pairwise keys)
-	 *  - STK (station-to-station pairwise keys)
-	 *
-	 * When selecting a key, we have to distinguish between multicast
-	 * (including broadcast) and unicast frames, the latter can only
-	 * use PTKs and STKs while the former always use GTKs and IGTKs.
-	 * Unless, of course, actual WEP keys ("pre-RSNA") are used, then
-	 * unicast frames can also use key indices like GTKs. Hence, if we
-	 * don't have a PTK/STK we check the key index for a WEP key.
-	 *
-	 * Note that in a regular BSS, multicast frames are sent by the
-	 * AP only, associated stations unicast the frame to the AP first
-	 * which then multicasts it on their behalf.
-	 *
-	 * There is also a slight problem in IBSS mode: GTKs are negotiated
-	 * with each station, that is something we don't currently handle.
-	 * The spec seems to expect that one negotiates the same key with
-	 * every station but there's no such requirement; VLANs could be
-	 * possible.
-	 */
-
-	/*
-	 * No point in finding a key and decrypting if the frame is neither
-	 * addressed to us nor a multicast frame.
-	 */
-	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
-		return RX_CONTINUE;
-
-	/* start without a key */
-	rx->key = NULL;
-
-	if (rx->sta)
-		sta_ptk = rcu_dereference(rx->sta->ptk);
-
-	fc = hdr->frame_control;
-
-	if (!ieee80211_has_protected(fc))
-		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
-
-	if (!is_multicast_ether_addr(hdr->addr1) && sta_ptk) {
-		rx->key = sta_ptk;
-		if ((status->flag & RX_FLAG_DECRYPTED) &&
-		    (status->flag & RX_FLAG_IV_STRIPPED))
-			return RX_CONTINUE;
-		/* Skip decryption if the frame is not protected. */
-		if (!ieee80211_has_protected(fc))
-			return RX_CONTINUE;
-	} else if (mmie_keyidx >= 0) {
-		/* Broadcast/multicast robust management frame / BIP */
-		if ((status->flag & RX_FLAG_DECRYPTED) &&
-		    (status->flag & RX_FLAG_IV_STRIPPED))
-			return RX_CONTINUE;
-
-		if (mmie_keyidx < NUM_DEFAULT_KEYS ||
-		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
-			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
-		if (rx->sta)
-			rx->key = rcu_dereference(rx->sta->gtk[mmie_keyidx]);
-		if (!rx->key)
-			rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
-	} else if (!ieee80211_has_protected(fc)) {
-		/*
-		 * The frame was not protected, so skip decryption. However, we
-		 * need to set rx->key if there is a key that could have been
-		 * used so that the frame may be dropped if encryption would
-		 * have been expected.
-		 */
-		struct ieee80211_key *key = NULL;
-		struct ieee80211_sub_if_data *sdata = rx->sdata;
-		int i;
-
-		if (ieee80211_is_mgmt(fc) &&
-		    is_multicast_ether_addr(hdr->addr1) &&
-		    (key = rcu_dereference(rx->sdata->default_mgmt_key)))
-			rx->key = key;
-		else {
-			if (rx->sta) {
-				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-					key = rcu_dereference(rx->sta->gtk[i]);
-					if (key)
-						break;
-				}
-			}
-			if (!key) {
-				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
-					key = rcu_dereference(sdata->keys[i]);
-					if (key)
-						break;
-				}
-			}
-			if (key)
-				rx->key = key;
-		}
-		return RX_CONTINUE;
-	} else {
-		u8 keyid;
-		/*
-		 * The device doesn't give us the IV so we won't be
-		 * able to look up the key. That's ok though, we
-		 * don't need to decrypt the frame, we just won't
-		 * be able to keep statistics accurate.
-		 * Except for key threshold notifications, should
-		 * we somehow allow the driver to tell us which key
-		 * the hardware used if this flag is set?
-		 */
-		if ((status->flag & RX_FLAG_DECRYPTED) &&
-		    (status->flag & RX_FLAG_IV_STRIPPED))
-			return RX_CONTINUE;
-
-		hdrlen = ieee80211_hdrlen(fc);
-
-		if (rx->skb->len < 8 + hdrlen)
-			return RX_DROP_UNUSABLE; /* TODO: count this? */
-
-		/*
-		 * no need to call ieee80211_wep_get_keyidx,
-		 * it verifies a bunch of things we've done already
-		 */
-		skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
-		keyidx = keyid >> 6;
-
-		/* check per-station GTK first, if multicast packet */
-		if (is_multicast_ether_addr(hdr->addr1) && rx->sta)
-			rx->key = rcu_dereference(rx->sta->gtk[keyidx]);
-
-		/* if not found, try default key */
-		if (!rx->key) {
-			rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
-
-			/*
-			 * RSNA-protected unicast frames should always be
-			 * sent with pairwise or station-to-station keys,
-			 * but for WEP we allow using a key index as well.
-			 */
-			if (rx->key &&
-			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
-			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
-			    !is_multicast_ether_addr(hdr->addr1))
-				rx->key = NULL;
-		}
-	}
-
-	if (rx->key) {
-		if (unlikely(rx->key->flags & KEY_FLAG_TAINTED))
-			return RX_DROP_MONITOR;
-
-		rx->key->tx_rx_count++;
-		/* TODO: add threshold stuff again */
-	} else {
-		return RX_DROP_MONITOR;
-	}
-
-	switch (rx->key->conf.cipher) {
-	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
-		result = ieee80211_crypto_wep_decrypt(rx);
-		break;
-	case WLAN_CIPHER_SUITE_TKIP:
-		result = ieee80211_crypto_tkip_decrypt(rx);
-		break;
-	case WLAN_CIPHER_SUITE_CCMP:
-		result = ieee80211_crypto_ccmp_decrypt(rx);
-		break;
-	case WLAN_CIPHER_SUITE_AES_CMAC:
-		result = ieee80211_crypto_aes_cmac_decrypt(rx);
-		break;
-	default:
-		/*
-		 * We can reach here only with HW-only algorithms
-		 * but why didn't it decrypt the frame?!
-		 */
-		return RX_DROP_UNUSABLE;
-	}
-
-	/* the hdr variable is invalid after the decrypt handlers */
-
-	/* either the frame has been decrypted or will be dropped */
-	status->flag |= RX_FLAG_DECRYPTED;
-
-	return result;
-}
-
-static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local;
@@ -1556,6 +1355,207 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	return RX_CONTINUE;
 } /* ieee80211_rx_h_sta_process */
 
+static ieee80211_rx_result debug_noinline
+ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
+{
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	int keyidx;
+	int hdrlen;
+	ieee80211_rx_result result = RX_DROP_UNUSABLE;
+	struct ieee80211_key *sta_ptk = NULL;
+	int mmie_keyidx = -1;
+	__le16 fc;
+
+	/*
+	 * Key selection 101
+	 *
+	 * There are four types of keys:
+	 *  - GTK (group keys)
+	 *  - IGTK (group keys for management frames)
+	 *  - PTK (pairwise keys)
+	 *  - STK (station-to-station pairwise keys)
+	 *
+	 * When selecting a key, we have to distinguish between multicast
+	 * (including broadcast) and unicast frames, the latter can only
+	 * use PTKs and STKs while the former always use GTKs and IGTKs.
+	 * Unless, of course, actual WEP keys ("pre-RSNA") are used, then
+	 * unicast frames can also use key indices like GTKs. Hence, if we
+	 * don't have a PTK/STK we check the key index for a WEP key.
+	 *
+	 * Note that in a regular BSS, multicast frames are sent by the
+	 * AP only, associated stations unicast the frame to the AP first
+	 * which then multicasts it on their behalf.
+	 *
+	 * There is also a slight problem in IBSS mode: GTKs are negotiated
+	 * with each station, that is something we don't currently handle.
+	 * The spec seems to expect that one negotiates the same key with
+	 * every station but there's no such requirement; VLANs could be
+	 * possible.
+	 */
+
+	/*
+	 * No point in finding a key and decrypting if the frame is neither
+	 * addressed to us nor a multicast frame.
+	 */
+	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
+		return RX_CONTINUE;
+
+	/* start without a key */
+	rx->key = NULL;
+
+	if (rx->sta)
+		sta_ptk = rcu_dereference(rx->sta->ptk);
+
+	fc = hdr->frame_control;
+
+	if (!ieee80211_has_protected(fc))
+		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
+
+	if (!is_multicast_ether_addr(hdr->addr1) && sta_ptk) {
+		rx->key = sta_ptk;
+		if ((status->flag & RX_FLAG_DECRYPTED) &&
+		    (status->flag & RX_FLAG_IV_STRIPPED))
+			return RX_CONTINUE;
+		/* Skip decryption if the frame is not protected. */
+		if (!ieee80211_has_protected(fc))
+			return RX_CONTINUE;
+	} else if (mmie_keyidx >= 0) {
+		/* Broadcast/multicast robust management frame / BIP */
+		if ((status->flag & RX_FLAG_DECRYPTED) &&
+		    (status->flag & RX_FLAG_IV_STRIPPED))
+			return RX_CONTINUE;
+
+		if (mmie_keyidx < NUM_DEFAULT_KEYS ||
+		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
+			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
+		if (rx->sta)
+			rx->key = rcu_dereference(rx->sta->gtk[mmie_keyidx]);
+		if (!rx->key)
+			rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
+	} else if (!ieee80211_has_protected(fc)) {
+		/*
+		 * The frame was not protected, so skip decryption. However, we
+		 * need to set rx->key if there is a key that could have been
+		 * used so that the frame may be dropped if encryption would
+		 * have been expected.
+		 */
+		struct ieee80211_key *key = NULL;
+		struct ieee80211_sub_if_data *sdata = rx->sdata;
+		int i;
+
+		if (ieee80211_is_mgmt(fc) &&
+		    is_multicast_ether_addr(hdr->addr1) &&
+		    (key = rcu_dereference(rx->sdata->default_mgmt_key)))
+			rx->key = key;
+		else {
+			if (rx->sta) {
+				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+					key = rcu_dereference(rx->sta->gtk[i]);
+					if (key)
+						break;
+				}
+			}
+			if (!key) {
+				for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
+					key = rcu_dereference(sdata->keys[i]);
+					if (key)
+						break;
+				}
+			}
+			if (key)
+				rx->key = key;
+		}
+		return RX_CONTINUE;
+	} else {
+		u8 keyid;
+		/*
+		 * The device doesn't give us the IV so we won't be
+		 * able to look up the key. That's ok though, we
+		 * don't need to decrypt the frame, we just won't
+		 * be able to keep statistics accurate.
+		 * Except for key threshold notifications, should
+		 * we somehow allow the driver to tell us which key
+		 * the hardware used if this flag is set?
+		 */
+		if ((status->flag & RX_FLAG_DECRYPTED) &&
+		    (status->flag & RX_FLAG_IV_STRIPPED))
+			return RX_CONTINUE;
+
+		hdrlen = ieee80211_hdrlen(fc);
+
+		if (rx->skb->len < 8 + hdrlen)
+			return RX_DROP_UNUSABLE; /* TODO: count this? */
+
+		/*
+		 * no need to call ieee80211_wep_get_keyidx,
+		 * it verifies a bunch of things we've done already
+		 */
+		skb_copy_bits(rx->skb, hdrlen + 3, &keyid, 1);
+		keyidx = keyid >> 6;
+
+		/* check per-station GTK first, if multicast packet */
+		if (is_multicast_ether_addr(hdr->addr1) && rx->sta)
+			rx->key = rcu_dereference(rx->sta->gtk[keyidx]);
+
+		/* if not found, try default key */
+		if (!rx->key) {
+			rx->key = rcu_dereference(rx->sdata->keys[keyidx]);
+
+			/*
+			 * RSNA-protected unicast frames should always be
+			 * sent with pairwise or station-to-station keys,
+			 * but for WEP we allow using a key index as well.
+			 */
+			if (rx->key &&
+			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
+			    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
+			    !is_multicast_ether_addr(hdr->addr1))
+				rx->key = NULL;
+		}
+	}
+
+	if (rx->key) {
+		if (unlikely(rx->key->flags & KEY_FLAG_TAINTED))
+			return RX_DROP_MONITOR;
+
+		rx->key->tx_rx_count++;
+		/* TODO: add threshold stuff again */
+	} else {
+		return RX_DROP_MONITOR;
+	}
+
+	switch (rx->key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		result = ieee80211_crypto_wep_decrypt(rx);
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		result = ieee80211_crypto_tkip_decrypt(rx);
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		result = ieee80211_crypto_ccmp_decrypt(rx);
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		result = ieee80211_crypto_aes_cmac_decrypt(rx);
+		break;
+	default:
+		/*
+		 * We can reach here only with HW-only algorithms
+		 * but why didn't it decrypt the frame?!
+		 */
+		return RX_DROP_UNUSABLE;
+	}
+
+	/* the hdr variable is invalid after the decrypt handlers */
+
+	/* either the frame has been decrypted or will be dropped */
+	status->flag |= RX_FLAG_DECRYPTED;
+
+	return result;
+}
+
 static inline struct ieee80211_fragment_entry *
 ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 			 unsigned int frag, unsigned int seq, int rx_queue,
-- 
1.7.9.5

