Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54865 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2KJCoR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 21:44:17 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.7] mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge
Date: Sat, 10 Nov 2012 03:44:14 +0100
Message-Id: <1352515454-21067-1-git-send-email-nbd@openwrt.org> (sfid-20121110_034426_365213_44C815B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes more wifi status skb leaks, leading to hostapd/wpa_supplicant hangs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/mac80211/ieee80211_i.h | 2 ++
 net/mac80211/sta_info.c    | 6 +++---
 net/mac80211/status.c      | 9 +++++++++
 net/mac80211/tx.c          | 9 ++++++---
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3026519..32e4785 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1377,6 +1377,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f7bb54f..8dc8335 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -122,8 +122,8 @@ static void free_sta_work(struct work_struct *wk)
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->tx_filtered[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->ps_tx_buf[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->tx_filtered[ac]);
 	}
 
 #ifdef CONFIG_MAC80211_MESH
@@ -146,7 +146,7 @@ static void free_sta_work(struct work_struct *wk)
 		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
 		if (!tid_tx)
 			continue;
-		__skb_queue_purge(&tid_tx->pending);
+		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
 		kfree(tid_tx);
 	}
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 21fa5c7..2482478 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -669,3 +669,12 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb)
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL(ieee80211_free_txskb);
+
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(skbs)))
+		ieee80211_free_txskb(hw, skb);
+}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 065f81c..6f19818 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1361,7 +1361,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 		if (tx->skb)
 			ieee80211_free_txskb(&tx->local->hw, tx->skb);
 		else
-			__skb_queue_purge(&tx->skbs);
+			ieee80211_purge_tx_queue(&tx->local->hw, &tx->skbs);
 		return -1;
 	} else if (unlikely(res == TX_QUEUED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_queued);
@@ -2160,10 +2160,13 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
  */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local)
 {
+	struct sk_buff *skb;
 	int i;
 
-	for (i = 0; i < local->hw.queues; i++)
-		skb_queue_purge(&local->pending[i]);
+	for (i = 0; i < local->hw.queues; i++) {
+		while ((skb = skb_dequeue(&local->pending[i])) != NULL)
+			ieee80211_free_txskb(&local->hw, skb);
+	}
 }
 
 /*
-- 
1.7.12.2

