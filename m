Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59597 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbZCWQcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:32 -0400
Message-Id: <20090323163052.569487987@sipsolutions.net> (sfid-20090323_173234_371105_420F4773)
References: <20090323162834.154525349@sipsolutions.net>
Date: Mon, 23 Mar 2009 17:28:38 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/8] mac80211: clean up __ieee80211_tx args
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__ieee80211_tx takes a struct ieee80211_tx_data argument, but only
uses a few of its members, namely 'skb' and 'sta'. Make that explicit,
so that less internal knowledge is required in ieee80211_tx_pending
and the possibility of introducing errors here is removed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-03-23 14:03:45.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-23 14:03:46.000000000 +0100
@@ -1084,9 +1084,10 @@ static int ieee80211_tx_prepare(struct i
 }
 
 static int __ieee80211_tx(struct ieee80211_local *local,
-			  struct ieee80211_tx_data *tx)
+			  struct sk_buff **skbp,
+			  struct sta_info *sta)
 {
-	struct sk_buff *skb = tx->skb, *next;
+	struct sk_buff *skb = *skbp, *next;
 	struct ieee80211_tx_info *info;
 	int ret;
 	bool fragm = false;
@@ -1111,23 +1112,23 @@ static int __ieee80211_tx(struct ieee802
 		 * We will later move this down into the only driver that
 		 * needs it, iwlwifi.
 		 */
-		if (tx->sta && local->hw.ampdu_queues &&
+		if (sta && local->hw.ampdu_queues &&
 		    info->flags & IEEE80211_TX_CTL_AMPDU) {
 			unsigned long flags;
 			u8 *qc = ieee80211_get_qos_ctl((void *) skb->data);
 			int tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 
-			spin_lock_irqsave(&tx->sta->lock, flags);
+			spin_lock_irqsave(&sta->lock, flags);
 			skb_set_queue_mapping(skb, local->hw.queues +
-						   tx->sta->tid_to_tx_q[tid]);
-			spin_unlock_irqrestore(&tx->sta->lock, flags);
+						   sta->tid_to_tx_q[tid]);
+			spin_unlock_irqrestore(&sta->lock, flags);
 		}
 
 		next = skb->next;
 		ret = local->ops->tx(local_to_hw(local), skb);
 		if (ret != NETDEV_TX_OK)
 			return IEEE80211_TX_AGAIN;
-		tx->skb = skb = next;
+		*skbp = skb = next;
 		ieee80211_led_tx(local, 1);
 		fragm = true;
 	}
@@ -1223,7 +1224,7 @@ static int ieee80211_tx(struct net_devic
 
 	retries = 0;
  retry:
-	ret = __ieee80211_tx(local, &tx);
+	ret = __ieee80211_tx(local, &tx.skb, tx.sta);
 	switch (ret) {
 	case IEEE80211_TX_OK:
 		break;
@@ -1831,7 +1832,6 @@ void ieee80211_tx_pending(unsigned long 
 	struct net_device *dev = local->mdev;
 	struct ieee80211_hdr *hdr;
 	unsigned long flags;
-	struct ieee80211_tx_data tx;
 	int i, ret;
 	bool next;
 
@@ -1862,14 +1862,15 @@ void ieee80211_tx_pending(unsigned long 
 		netif_start_subqueue(local->mdev, i);
 
 		while (!skb_queue_empty(&local->pending[i])) {
-			tx.flags = 0;
-			tx.skb = skb_dequeue(&local->pending[i]);
-			hdr = (struct ieee80211_hdr *)tx.skb->data;
-			tx.sta = sta_info_get(local, hdr->addr1);
+			struct sk_buff *skb = skb_dequeue(&local->pending[i]);
+			struct sta_info *sta;
+
+			hdr = (struct ieee80211_hdr *)skb->data;
+			sta = sta_info_get(local, hdr->addr1);
 
-			ret = __ieee80211_tx(local, &tx);
+			ret = __ieee80211_tx(local, &skb, sta);
 			if (ret != IEEE80211_TX_OK) {
-				skb_queue_head(&local->pending[i], tx.skb);
+				skb_queue_head(&local->pending[i], skb);
 				break;
 			}
 		}

-- 

