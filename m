Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbZFIRnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 13:43:11 -0400
Subject: [PATCH] mac80211: clean up return value of
 __ieee80211_parse_tx_radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 19:42:38 +0200
Message-Id: <1244569358.18481.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return type has more than two values, but it can validly
only ever return TX_DROP and TX_CONTINUE, so use a bool
instead of ieee80211_tx_result.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-06-09 19:39:55.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-06-09 19:40:39.000000000 +0200
@@ -908,9 +908,8 @@ ieee80211_tx_h_stats(struct ieee80211_tx
  * deal with packet injection down monitor interface
  * with Radiotap Header -- only called for monitor mode interface
  */
-static ieee80211_tx_result
-__ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
-			      struct sk_buff *skb)
+static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
+					  struct sk_buff *skb)
 {
 	/*
 	 * this is the moment to interpret and discard the radiotap header that
@@ -983,7 +982,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 	}
 
 	if (ret != -ENOENT) /* ie, if we didn't simply run out of fields */
-		return TX_DROP;
+		return false;
 
 	/*
 	 * remove the radiotap header
@@ -992,7 +991,7 @@ __ieee80211_parse_tx_radiotap(struct iee
 	 */
 	skb_pull(skb, iterator.max_length);
 
-	return TX_CONTINUE;
+	return true;
 }
 
 /*
@@ -1026,7 +1025,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 	/* process and remove the injection radiotap header */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED)) {
-		if (__ieee80211_parse_tx_radiotap(tx, skb) == TX_DROP)
+		if (!__ieee80211_parse_tx_radiotap(tx, skb))
 			return TX_DROP;
 
 		/*


