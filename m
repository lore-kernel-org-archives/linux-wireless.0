Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbXIZPyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 11:54:49 -0400
Message-Id: <20070926155433.189259000@sipsolutions.net>
References: <20070926155313.955049000@sipsolutions.net>
Date: Wed, 26 Sep 2007 17:53:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [patch 2/7] mac80211: consolidate decryption more
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, we have three RX handlers doing the decryption.
This patch changes it to have only one handler doing
everything, thereby getting rid of many duplicate checks.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/rx.c |   46 ++++++++++++----------------------------------
 1 file changed, 12 insertions(+), 34 deletions(-)

--- wireless-dev.orig/net/mac80211/rx.c	2007-09-26 17:21:46.987337342 +0200
+++ wireless-dev/net/mac80211/rx.c	2007-09-26 17:21:48.997337342 +0200
@@ -419,7 +419,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 
 
 static ieee80211_txrx_result
-ieee80211_rx_h_load_key(struct ieee80211_txrx_data *rx)
+ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	int keyidx;
@@ -456,7 +456,7 @@ ieee80211_rx_h_load_key(struct ieee80211
 		return TXRX_CONTINUE;
 
 	/*
-	 * No point in finding a key if the frame is neither
+	 * No point in finding a key and decrypting if the frame is neither
 	 * addressed to us nor a multicast frame.
 	 */
 	if (!(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
@@ -507,42 +507,21 @@ ieee80211_rx_h_load_key(struct ieee80211
 	if (rx->key) {
 		rx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
-	}
-
-	return TXRX_CONTINUE;
-}
-
-static ieee80211_txrx_result
-ieee80211_rx_h_wep_weak_iv_detection(struct ieee80211_txrx_data *rx)
-{
-	if (!rx->sta || !(rx->fc & IEEE80211_FCTL_PROTECTED) ||
-	    (rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
-	    !rx->key || rx->key->conf.alg != ALG_WEP ||
-	    !(rx->flags & IEEE80211_TXRXD_RXRA_MATCH))
-		return TXRX_CONTINUE;
-
-	/* Check for weak IVs, if hwaccel did not remove IV from the frame */
-	if (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) ||
-	    !(rx->u.rx.status->flag & RX_FLAG_DECRYPTED))
-		if (ieee80211_wep_is_weak_iv(rx->skb, rx->key))
-			rx->sta->wep_weak_iv_count++;
-
-	return TXRX_CONTINUE;
-}
-
-static ieee80211_txrx_result
-ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
-{
-	if (!(rx->fc & IEEE80211_FCTL_PROTECTED))
-		return TXRX_CONTINUE;
-
-	if (!rx->key) {
+	} else {
 		if (net_ratelimit())
 			printk(KERN_DEBUG "%s: RX protected frame,"
 			       " but have no key\n", rx->dev->name);
 		return TXRX_DROP;
 	}
 
+	/* Check for weak IVs if possible */
+	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
+	    ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA) &&
+	    (!(rx->u.rx.status->flag & RX_FLAG_IV_STRIPPED) ||
+	     !(rx->u.rx.status->flag & RX_FLAG_DECRYPTED)) &&
+	    ieee80211_wep_is_weak_iv(rx->skb, rx->key))
+		rx->sta->wep_weak_iv_count++;
+
 	switch (rx->key->conf.alg) {
 	case ALG_WEP:
 		return ieee80211_crypto_wep_decrypt(rx);
@@ -551,6 +530,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	case ALG_CCMP:
 		return ieee80211_crypto_ccmp_decrypt(rx);
 	case ALG_NONE:
+		WARN_ON(1);
 		return TXRX_CONTINUE;
 	}
 
@@ -1348,8 +1328,6 @@ ieee80211_rx_handler ieee80211_rx_handle
 	ieee80211_rx_h_if_stats,
 	ieee80211_rx_h_passive_scan,
 	ieee80211_rx_h_check,
-	ieee80211_rx_h_load_key,
-	ieee80211_rx_h_wep_weak_iv_detection,
 	ieee80211_rx_h_decrypt,
 	ieee80211_rx_h_sta_process,
 	ieee80211_rx_h_defragment,

-- 

