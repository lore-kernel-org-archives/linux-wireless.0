Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:5419 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbYGXPtG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 11:49:06 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: fix-fragmentation-kludge.patch
Date: Thu, 24 Jul 2008 18:46:44 +0300
Message-Id: <1216914404-29029-1-git-send-email-tomas.winkler@intel.com> (sfid-20080724_174911_374365_3897EECE)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch make mac80211 transmit correctly fragmented packet after
queue was stopped

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/tx.c          |   17 +++++++++++++----
 net/mac80211/util.c        |    1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3ac23b8..98e0283 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -580,6 +580,7 @@ struct ieee80211_local {
 	struct timer_list sta_cleanup;
 
 	unsigned long queues_pending[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
+	unsigned long queues_pending_run[BITS_TO_LONGS(IEEE80211_MAX_QUEUES)];
 	struct ieee80211_tx_stored_packet pending_packet[IEEE80211_MAX_QUEUES];
 	struct tasklet_struct tx_pending_tasklet;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2b912cf..4d9f9cb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1061,13 +1061,15 @@ static int ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 static int __ieee80211_tx(struct ieee80211_local *local, struct sk_buff *skb,
 			  struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info;
 	int ret, i;
 
-	if (netif_subqueue_stopped(local->mdev, skb))
-		return IEEE80211_TX_AGAIN;
 
 	if (skb) {
+		if (netif_subqueue_stopped(local->mdev, skb))
+			return IEEE80211_TX_AGAIN;
+		info =  IEEE80211_SKB_CB(skb);
+
 		ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
 				     "TX to low-level driver", skb);
 		ret = local->ops->tx(local_to_hw(local), skb);
@@ -1216,6 +1218,7 @@ retry:
 
 		if (ret == IEEE80211_TX_FRAG_AGAIN)
 			skb = NULL;
+
 		set_bit(queue, local->queues_pending);
 		smp_mb();
 		/*
@@ -1246,6 +1249,7 @@ retry:
 		store->last_frag_rate_idx = tx.last_frag_rate_idx;
 		store->last_frag_rate_ctrl_probe =
 			!!(tx.flags & IEEE80211_TX_PROBE_LAST_FRAG);
+
 	}
  out:
 	rcu_read_unlock();
@@ -1721,14 +1725,19 @@ void ieee80211_tx_pending(unsigned long data)
 	netif_tx_lock_bh(dev);
 	for (i = 0; i < ieee80211_num_regular_queues(&local->hw); i++) {
 		/* Check that this queue is ok */
-		if (__netif_subqueue_stopped(local->mdev, i))
+		if (__netif_subqueue_stopped(local->mdev, i) &&
+		    !test_bit(i, local->queues_pending_run))
 			continue;
 
 		if (!test_bit(i, local->queues_pending)) {
+			clear_bit(i, local->queues_pending_run);
 			ieee80211_wake_queue(&local->hw, i);
 			continue;
 		}
 
+		clear_bit(i, local->queues_pending_run);
+		netif_start_subqueue(local->mdev, i);
+
 		store = &local->pending_packet[i];
 		tx.extra_frag = store->extra_frag;
 		tx.num_extra_frag = store->num_extra_frag;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89ce4e0..02af3e8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -361,6 +361,7 @@ void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	if (test_bit(queue, local->queues_pending)) {
+		set_bit(queue, local->queues_pending_run);
 		tasklet_schedule(&local->tx_pending_tasklet);
 	} else {
 		if (ieee80211_is_multiqueue(local)) {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

