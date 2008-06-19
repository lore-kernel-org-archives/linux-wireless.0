Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbYFSMT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 08:19:58 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1K9J7M-0004hW-Iv
	for linux-wireless@vger.kernel.org; Thu, 19 Jun 2008 14:19:56 +0200
Subject: [RFC 1/2] consolidate TX handler code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 14:19:16 +0200
Message-Id: <1213877956.8967.1.camel@johannes.berg> (sfid-20080619_142002_910996_E0F09190)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Untested so far, this isn't the interesting part.

---
 net/mac80211/tx.c |   86 +++++++++++++++++++++++++++---------------------------
 1 file changed, 44 insertions(+), 42 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-06-19 13:47:40.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-19 14:00:33.000000000 +0200
@@ -1105,13 +1105,50 @@ static int __ieee80211_tx(struct ieee802
 	return IEEE80211_TX_OK;
 }
 
+/*
+ * Invoke TX handlers, return 0 on success and non-zero if the
+ * frame was dropped or queued.
+ */
+static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_local *local = tx->local;
+	struct sk_buff *skb = tx->skb;
+	ieee80211_tx_handler *handler;
+	ieee80211_tx_result res = TX_DROP;
+	int i;
+
+	for (handler = ieee80211_tx_handlers; *handler != NULL; handler++) {
+		res = (*handler)(tx);
+		if (res != TX_CONTINUE)
+			break;
+	}
+
+	if (WARN_ON(tx->skb != skb))
+		res = TX_DROP;
+
+	if (unlikely(res == TX_DROP)) {
+		I802_DEBUG_INC(local->tx_handlers_drop);
+		if (skb)
+			dev_kfree_skb(skb);
+		for (i = 0; i < tx->num_extra_frag; i++)
+			if (tx->extra_frag[i])
+				dev_kfree_skb(tx->extra_frag[i]);
+		kfree(tx->extra_frag);
+		return -1;
+	} else if (unlikely(res == TX_QUEUED)) {
+		I802_DEBUG_INC(local->tx_handlers_queued);
+		return -1;
+	}
+
+	return 0;
+}
+
 static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
-	ieee80211_tx_handler *handler;
 	struct ieee80211_tx_data tx;
-	ieee80211_tx_result res = TX_DROP, res_prepare;
+	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret, i, retries = 0;
 	u16 queue;
@@ -1140,26 +1177,8 @@ static int ieee80211_tx(struct net_devic
 	tx.channel = local->hw.conf.channel;
 	info->band = tx.channel->band;
 
-	for (handler = ieee80211_tx_handlers; *handler != NULL;
-	     handler++) {
-		res = (*handler)(&tx);
-		if (res != TX_CONTINUE)
-			break;
-	}
-
-	if (WARN_ON(tx.skb != skb))
-		goto drop;
-
-	if (unlikely(res == TX_DROP)) {
-		I802_DEBUG_INC(local->tx_handlers_drop);
-		goto drop;
-	}
-
-	if (unlikely(res == TX_QUEUED)) {
-		I802_DEBUG_INC(local->tx_handlers_queued);
-		rcu_read_unlock();
-		return 0;
-	}
+	if (invoke_tx_handlers(&tx))
+		goto out;
 
 retry:
 	ret = __ieee80211_tx(local, skb, &tx);
@@ -1209,6 +1228,7 @@ retry:
 		store->last_frag_rate_ctrl_probe =
 			!!(tx.flags & IEEE80211_TX_PROBE_LAST_FRAG);
 	}
+ out:
 	rcu_read_unlock();
 	return 0;
 
@@ -1959,9 +1979,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
 	struct sta_info *sta;
-	ieee80211_tx_handler *handler;
 	struct ieee80211_tx_data tx;
-	ieee80211_tx_result res = TX_DROP;
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
@@ -2012,25 +2030,9 @@ ieee80211_get_buffered_bc(struct ieee802
 	tx.channel = local->hw.conf.channel;
 	info->band = tx.channel->band;
 
-	for (handler = ieee80211_tx_handlers; *handler != NULL; handler++) {
-		res = (*handler)(&tx);
-		if (res == TX_DROP || res == TX_QUEUED)
-			break;
-	}
-
-	if (WARN_ON(tx.skb != skb))
-		res = TX_DROP;
-
-	if (res == TX_DROP) {
-		I802_DEBUG_INC(local->tx_handlers_drop);
-		dev_kfree_skb(skb);
-		skb = NULL;
-	} else if (res == TX_QUEUED) {
-		I802_DEBUG_INC(local->tx_handlers_queued);
+	if (invoke_tx_handlers(&tx))
 		skb = NULL;
-	}
-
-out:
+ out:
 	rcu_read_unlock();
 
 	return skb;


