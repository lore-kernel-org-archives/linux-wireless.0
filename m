Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59590 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbZCWQc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:27 -0400
Message-Id: <20090323163052.038036544@sipsolutions.net> (sfid-20090323_173234_173519_2321C6FB)
References: <20090323162834.154525349@sipsolutions.net>
Date: Mon, 23 Mar 2009 17:28:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] mac80211: fix A-MPDU queue assignment
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Internally, mac80211 requires the skb's queue mapping to be set
to the AC queue, not the virtual A-MPDU queue. This is not done
correctly currently, this patch moves the code down to directly
before the driver is invoked and adds a comment that it will be
moved into the driver later.

Since this requires __ieee80211_tx() to have the sta pointer,
make sure to provide it in ieee80211_tx_pending().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2009-03-23 13:59:20.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-23 14:03:45.000000000 +0100
@@ -1024,13 +1024,8 @@ __ieee80211_tx_prepare(struct ieee80211_
 
 		spin_lock_irqsave(&tx->sta->lock, flags);
 		state = &tx->sta->ampdu_mlme.tid_state_tx[tid];
-		if (*state == HT_AGG_STATE_OPERATIONAL) {
+		if (*state == HT_AGG_STATE_OPERATIONAL)
 			info->flags |= IEEE80211_TX_CTL_AMPDU;
-			if (local->hw.ampdu_queues)
-				skb_set_queue_mapping(
-					skb, tx->local->hw.queues +
-					     tx->sta->tid_to_tx_q[tid]);
-		}
 		spin_unlock_irqrestore(&tx->sta->lock, flags);
 	}
 
@@ -1103,10 +1098,29 @@ static int __ieee80211_tx(struct ieee802
 					    skb_get_queue_mapping(skb)))
 			return IEEE80211_TX_PENDING;
 
-		if (fragm) {
-			info = IEEE80211_SKB_CB(skb);
+		info = IEEE80211_SKB_CB(skb);
+
+		if (fragm)
 			info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
 					 IEEE80211_TX_CTL_FIRST_FRAGMENT);
+
+		/*
+		 * Internally, we need to have the queue mapping point to
+		 * the real AC queue, not the virtual A-MPDU queue. This
+		 * now finally sets the queue to what the driver wants.
+		 * We will later move this down into the only driver that
+		 * needs it, iwlwifi.
+		 */
+		if (tx->sta && local->hw.ampdu_queues &&
+		    info->flags & IEEE80211_TX_CTL_AMPDU) {
+			unsigned long flags;
+			u8 *qc = ieee80211_get_qos_ctl((void *) skb->data);
+			int tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+
+			spin_lock_irqsave(&tx->sta->lock, flags);
+			skb_set_queue_mapping(skb, local->hw.queues +
+						   tx->sta->tid_to_tx_q[tid]);
+			spin_unlock_irqrestore(&tx->sta->lock, flags);
 		}
 
 		next = skb->next;
@@ -1817,9 +1831,11 @@ void ieee80211_tx_pending(unsigned long 
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
 	struct net_device *dev = local->mdev;
 	struct ieee80211_tx_stored_packet *store;
+	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_data tx;
 	int i, ret;
 
+	rcu_read_lock();
 	netif_tx_lock_bh(dev);
 	for (i = 0; i < local->hw.queues; i++) {
 		/* Check that this queue is ok */
@@ -1839,6 +1855,8 @@ void ieee80211_tx_pending(unsigned long 
 		store = &local->pending_packet[i];
 		tx.flags = 0;
 		tx.skb = store->skb;
+		hdr = (struct ieee80211_hdr *)tx.skb->data;
+		tx.sta = sta_info_get(local, hdr->addr1);
 		ret = __ieee80211_tx(local, &tx);
 		store->skb = tx.skb;
 		if (!ret) {
@@ -1847,6 +1865,7 @@ void ieee80211_tx_pending(unsigned long 
 		}
 	}
 	netif_tx_unlock_bh(dev);
+	rcu_read_unlock();
 }
 
 /* functions for drivers to get certain frames */

-- 

