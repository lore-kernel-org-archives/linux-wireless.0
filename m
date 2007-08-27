Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbXH0Ncr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 09:32:47 -0400
Subject: [PATCH] address comments from Michael Wu
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 15:33:53 +0200
Message-Id: <1188221633.7837.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The key selection changes had some things Michael Wu wasn't entirely
happy with, address these points.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-08-27 15:22:33.894646075 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-08-27 15:22:35.944646075 +0200
@@ -321,7 +321,6 @@ ieee80211_rx_h_load_key(struct ieee80211
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	int keyidx;
 	int hdrlen;
-	int trying_wep = 0;
 
 	/*
 	 * Key selection 101
@@ -350,12 +349,13 @@ ieee80211_rx_h_load_key(struct ieee80211
 	 * addressed to us nor a multicast frame.
 	 */
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return TXRX_DROP;
+		return TXRX_CONTINUE;
 
-	if (is_multicast_ether_addr(hdr->addr1) || !rx->sta) {
- find_by_index:
+	if (!is_multicast_ether_addr(hdr->addr1) && rx->sta && rx->sta->key) {
+		rx->key = rx->sta->key;
+	} else {
 		/*
-		 * The device doesn't give us the IV so won't be
+		 * The device doesn't give us the IV so we won't be
 		 * able to look up the key. That's ok though, we
 		 * don't need to decrypt the frame, we just won't
 		 * be able to keep statistics accurate.
@@ -369,33 +369,27 @@ ieee80211_rx_h_load_key(struct ieee80211
 		hdrlen = ieee80211_get_hdrlen(rx->fc);
 
 		if (rx->skb->len < 8 + hdrlen)
-			/* COUNT THIS? */
-			return TXRX_DROP;
+			return TXRX_DROP; /* TODO: count this? */
+
 		/*
 		 * no need to call ieee80211_wep_get_keyidx,
 		 * it verifies a bunch of things we've done already
 		 */
 		keyidx = rx->skb->data[hdrlen + 3] >> 6;
 
-		/*
-		 * TODO: handle IBSS! We can have per-STA group keys there!
-		 */
 		rx->key = rx->sdata->keys[keyidx];
 
 		/*
-		 * If we got here for WEP, make sure we got WEP
+		 * RSNA-protected unicast frames should always be sent with
+		 * pairwise or station-to-station keys, but for WEP we allow
+		 * using a key index as well.
 		 */
-		if (trying_wep && rx->key && rx->key->conf.alg != ALG_WEP)
+		if (rx->key && rx->key->conf.alg != ALG_WEP &&
+		    !is_multicast_ether_addr(hdr->addr1))
 			rx->key = NULL;
-	} else {
-		rx->key = rx->sta->key;
-		if (!rx->key) {
-			trying_wep = 1;
-			goto find_by_index;
-		}
 	}
 
-	if (rx->key && (rx->flags & IEEE80211_TXRXD_RXRA_MATCH)) {
+	if (rx->key) {
 		rx->key->tx_rx_count++;
 		if (unlikely(rx->local->key_tx_rx_threshold &&
 			     rx->key->tx_rx_count >


