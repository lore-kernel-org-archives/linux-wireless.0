Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbZHJOCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 10:02:30 -0400
Subject: [PATCH] mac80211: take statistics before encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 16:01:54 +0200
Message-Id: <1249912914.32614.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When encryption is used, the number of bytes
sent to the peer increases by the IV and ICV.
This is accounted if software encryption is
used, but not if the devices does hardware
encryption. To make the numbers comparable,
never account for that overhead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-08-10 13:25:05.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-08-10 13:25:34.000000000 +0200
@@ -844,6 +844,23 @@ ieee80211_tx_h_fragment(struct ieee80211
 }
 
 static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
+{
+	struct sk_buff *skb = tx->skb;
+
+	if (!tx->sta)
+		return TX_CONTINUE;
+
+	tx->sta->tx_packets++;
+	do {
+		tx->sta->tx_fragments++;
+		tx->sta->tx_bytes += skb->len;
+	} while ((skb = skb->next));
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 {
 	if (!tx->key)
@@ -887,23 +904,6 @@ ieee80211_tx_h_calculate_duration(struct
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
-{
-	struct sk_buff *skb = tx->skb;
-
-	if (!tx->sta)
-		return TX_CONTINUE;
-
-	tx->sta->tx_packets++;
-	do {
-		tx->sta->tx_fragments++;
-		tx->sta->tx_bytes += skb->len;
-	} while ((skb = skb->next));
-
-	return TX_CONTINUE;
-}
-
 /* actual transmit path */
 
 /*
@@ -1213,9 +1213,9 @@ static int invoke_tx_handlers(struct iee
 	CALL_TXH(ieee80211_tx_h_sequence)
 	CALL_TXH(ieee80211_tx_h_fragment)
 	/* handlers after fragment must be aware of tx info fragmentation! */
+	CALL_TXH(ieee80211_tx_h_stats)
 	CALL_TXH(ieee80211_tx_h_encrypt)
 	CALL_TXH(ieee80211_tx_h_calculate_duration)
-	CALL_TXH(ieee80211_tx_h_stats)
 #undef CALL_TXH
 
  txh_done:


