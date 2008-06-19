Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58272 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYFSX1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 19:27:08 -0400
Message-Id: <20080619232433.748395000@sipsolutions.net> (sfid-20080620_012712_239099_17BBF70C)
References: <20080619232229.202159000@sipsolutions.net>
Date: Fri, 20 Jun 2008 01:22:30 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: add single function calling tx handlers
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This modifies mac80211 to only have a single function calling the
TX handlers rather than them being invoked in multiple places.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   82 ++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 42 deletions(-)

--- everything.orig/net/mac80211/tx.c	2008-06-20 01:05:01.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-06-20 01:05:02.000000000 +0200
@@ -1106,13 +1106,46 @@ static int __ieee80211_tx(struct ieee802
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
+	if (unlikely(res == TX_DROP)) {
+		I802_DEBUG_INC(local->tx_handlers_drop);
+		dev_kfree_skb(skb);
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
@@ -1141,26 +1174,8 @@ static int ieee80211_tx(struct net_devic
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
@@ -1210,6 +1225,7 @@ retry:
 		store->last_frag_rate_ctrl_probe =
 			!!(tx.flags & IEEE80211_TX_PROBE_LAST_FRAG);
 	}
+ out:
 	rcu_read_unlock();
 	return 0;
 
@@ -1960,9 +1976,7 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
 	struct sta_info *sta;
-	ieee80211_tx_handler *handler;
 	struct ieee80211_tx_data tx;
-	ieee80211_tx_result res = TX_DROP;
 	struct net_device *bdev;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
@@ -2013,25 +2027,9 @@ ieee80211_get_buffered_bc(struct ieee802
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

-- 

