Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab0E1MYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 08:24:24 -0400
Subject: [PATCH] mac80211: move WEP weak IV check
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 14:24:19 +0200
Message-ID: <1275049460.3909.99.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I suspect the compiler will do this optimisation
anyway, but it seems cleaner to move this into
the WEP switch case.

Also make rx_h_decrypt use a local variable for
the frame_control so that we don't need to reload
the hdr variable for this after linearizing.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-05-28 14:16:34.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-05-28 14:22:59.000000000 +0200
@@ -825,6 +825,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	ieee80211_rx_result result = RX_DROP_UNUSABLE;
 	struct ieee80211_key *stakey = NULL;
 	int mmie_keyidx = -1;
+	__le16 fc;
 
 	/*
 	 * Key selection 101
@@ -866,13 +867,15 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	if (rx->sta)
 		stakey = rcu_dereference(rx->sta->key);
 
-	if (!ieee80211_has_protected(hdr->frame_control))
+	fc = hdr->frame_control;
+
+	if (!ieee80211_has_protected(fc))
 		mmie_keyidx = ieee80211_get_mmie_keyidx(rx->skb);
 
 	if (!is_multicast_ether_addr(hdr->addr1) && stakey) {
 		rx->key = stakey;
 		/* Skip decryption if the frame is not protected. */
-		if (!ieee80211_has_protected(hdr->frame_control))
+		if (!ieee80211_has_protected(fc))
 			return RX_CONTINUE;
 	} else if (mmie_keyidx >= 0) {
 		/* Broadcast/multicast robust management frame / BIP */
@@ -884,7 +887,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS)
 			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
 		rx->key = rcu_dereference(rx->sdata->keys[mmie_keyidx]);
-	} else if (!ieee80211_has_protected(hdr->frame_control)) {
+	} else if (!ieee80211_has_protected(fc)) {
 		/*
 		 * The frame was not protected, so skip decryption. However, we
 		 * need to set rx->key if there is a key that could have been
@@ -892,7 +895,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		 * have been expected.
 		 */
 		struct ieee80211_key *key = NULL;
-		if (ieee80211_is_mgmt(hdr->frame_control) &&
+		if (ieee80211_is_mgmt(fc) &&
 		    is_multicast_ether_addr(hdr->addr1) &&
 		    (key = rcu_dereference(rx->sdata->default_mgmt_key)))
 			rx->key = key;
@@ -914,7 +917,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 		    (status->flag & RX_FLAG_IV_STRIPPED))
 			return RX_CONTINUE;
 
-		hdrlen = ieee80211_hdrlen(hdr->frame_control);
+		hdrlen = ieee80211_hdrlen(fc);
 
 		if (rx->skb->len < 8 + hdrlen)
 			return RX_DROP_UNUSABLE; /* TODO: count this? */
@@ -947,19 +950,17 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 
 	if (skb_linearize(rx->skb))
 		return RX_DROP_UNUSABLE;
-
-	hdr = (struct ieee80211_hdr *)rx->skb->data;
-
-	/* Check for weak IVs if possible */
-	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
-	    ieee80211_is_data(hdr->frame_control) &&
-	    (!(status->flag & RX_FLAG_IV_STRIPPED) ||
-	     !(status->flag & RX_FLAG_DECRYPTED)) &&
-	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
-		rx->sta->wep_weak_iv_count++;
+	/* the hdr variable is invalid now! */
 
 	switch (rx->key->conf.alg) {
 	case ALG_WEP:
+		/* Check for weak IVs if possible */
+		if (rx->sta && ieee80211_is_data(fc) &&
+		    (!(status->flag & RX_FLAG_IV_STRIPPED) ||
+		     !(status->flag & RX_FLAG_DECRYPTED)) &&
+		    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
+			rx->sta->wep_weak_iv_count++;
+
 		result = ieee80211_crypto_wep_decrypt(rx);
 		break;
 	case ALG_TKIP:


