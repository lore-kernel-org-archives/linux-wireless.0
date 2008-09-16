Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2767 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYIPHfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 03:35:32 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, ron.rindjunsky@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [RFC V2] mac80211: re-enable aggregation on 2.6.27
Date: Tue, 16 Sep 2008 10:35:08 +0300
Message-Id: <1221550508-3338-1-git-send-email-tomas.winkler@intel.com> (sfid-20080916_093540_882243_61D51DD4)
In-Reply-To: <>
References: <>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-enable aggregation by addressing skb->cb overwrites
after insertion into the qdisc. Aggregation was disabled
after the new TX multiqueue changes were introduced. Instead
of relying on the skb->cb we use two flags on the skb.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Users have been reporting low rates on 2.6.27 with 11n drivers, the
problem is been 11n aggregation was disabled due to the new TX multique
changes. We should have addressed this sooner but we just got to it now.

Without addressing this we won't get 11n aggregation on 2.6.27. I tried
to minimize the changes required. I'm about to test this, it compiles.

If this doesn't get upstream for 27 perhaps distributions are willing to
carry it around then and if so oh well (grr...).

V2:
 1. removed skbuff ->is_part_ampdu
 2. fixed compilation warnings

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/skbuff.h |    4 ++++
 include/net/mac80211.h |    2 --
 net/mac80211/main.c    |    7 ++-----
 net/mac80211/rx.c      |    7 ++-----
 net/mac80211/tx.c      |    3 +++
 net/mac80211/wme.c     |   19 ++++---------------
 6 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9099237..4724211 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -244,6 +244,9 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_verd: traffic control verdict
  *	@ndisc_nodetype: router type (from link layer)
  *	@do_not_encrypt: set to prevent encryption of this frame
+ *	@requeue: set to indicate that the wireless core should attempt
+ *		a software retry on this frame if we failed to
+ *		receive an ACK for it
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
@@ -319,6 +322,7 @@ struct sk_buff {
 #endif
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
 	__u8			do_not_encrypt:1;
+	__u8			requeue:1;
 #endif
 	/* 0/13/14 bit hole */
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ff137fd..cce2e79 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -215,7 +215,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: TBD
  * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
  *	station
- * @IEEE80211_TX_CTL_REQUEUE: TBD
  * @IEEE80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
  * @IEEE80211_TX_CTL_SHORT_PREAMBLE: TBD
  * @IEEE80211_TX_CTL_LONG_RETRY_LIMIT: this frame should be send using the
@@ -257,7 +256,6 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_NO_ACK			= BIT(4),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(5),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(6),
-	IEEE80211_TX_CTL_REQUEUE		= BIT(7),
 	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(8),
 	IEEE80211_TX_CTL_SHORT_PREAMBLE		= BIT(9),
 	IEEE80211_TX_CTL_LONG_RETRY_LIMIT	= BIT(10),
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index aa5a191..6d57eac 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1293,8 +1293,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 					    struct sta_info *sta,
 					    struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	sta->tx_filtered_count++;
 
 	/*
@@ -1341,10 +1339,9 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
-	if (!test_sta_flags(sta, WLAN_STA_PS) &&
-	    !(info->flags & IEEE80211_TX_CTL_REQUEUE)) {
+	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
 		/* Software retry the packet once */
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		ieee80211_remove_tx_extra(local, sta->key, skb);
 		dev_queue_xmit(skb);
 		return;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6db8545..3e3c870 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -666,7 +666,6 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 	struct sk_buff *skb;
 	int sent = 0;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_info *info;
 	DECLARE_MAC_BUF(mac);
 
 	sdata = sta->sdata;
@@ -685,13 +684,11 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 
 	/* Send all buffered frames to the station */
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-		info = IEEE80211_SKB_CB(skb);
 		sent++;
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		dev_queue_xmit(skb);
 	}
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		info = IEEE80211_SKB_CB(skb);
 		local->total_ps_buffered--;
 		sent++;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -699,7 +696,7 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 		       "since STA not sleeping anymore\n", dev->name,
 		       print_mac(mac, sta->addr), sta->aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		dev_queue_xmit(skb);
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4788f7b..b25113f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -655,6 +655,9 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
 	seq = &tx->sta->tid_seq[tid];
 
+	if (tx->sta->ampdu_mlme.tid_state_tx[tid] == HT_AGG_STATE_OPERATIONAL)
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
+
 	hdr->seq_ctrl = cpu_to_le16(*seq);
 
 	/* Increase the sequence number. */
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4310e2f..c53bd56 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -113,11 +113,11 @@ static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
 	return ieee802_1d_to_ac[skb->priority];
 }
 
+/* XXX: Remove usage of tid_to_tx_q and only map frames to an AC */
 u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
@@ -126,7 +126,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;
 
-	if (info->flags & IEEE80211_TX_CTL_REQUEUE) {
+	if (skb->requeue) {
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
@@ -135,12 +135,8 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 			int ampdu_queue = sta->tid_to_tx_q[tid];
 
 			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool)) {
+			    test_bit(ampdu_queue, local->queue_pool))
 				queue = ampdu_queue;
-				info->flags |= IEEE80211_TX_CTL_AMPDU;
-			} else {
-				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-			}
 		}
 		rcu_read_unlock();
 
@@ -169,12 +165,8 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 			struct ieee80211_hw *hw = &local->hw;
 
 			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool)) {
+			    test_bit(ampdu_queue, local->queue_pool))
 				queue = ampdu_queue;
-				info->flags |= IEEE80211_TX_CTL_AMPDU;
-			} else {
-				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-			}
 		}
 
 		rcu_read_unlock();
@@ -188,9 +180,6 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 {
 	int i;
 
-	/* XXX: currently broken due to cb/requeue use */
-	return -EPERM;
-
 	/* prepare the filter and save it for the SW queue
 	 * matching the received HW queue */
 
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

