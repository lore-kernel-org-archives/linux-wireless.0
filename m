Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46087 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2JHMjh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 08:39:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.7] mac80211: use ieee80211_free_txskb to fix possible skb leaks
Date: Mon,  8 Oct 2012 14:39:33 +0200
Message-Id: <1349699973-90027-1-git-send-email-nbd@openwrt.org> (sfid-20121008_143940_623196_B58ABD44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few places free skbs using dev_kfree_skb even though they're called
after ieee80211_subif_start_xmit might have cloned it for tracking tx
status. Use ieee80211_free_txskb here to prevent skb leaks.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/mac80211/status.c |    4 ++--
 net/mac80211/tx.c     |   22 ++++++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 2ce8973..3af0cc4 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -34,7 +34,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 		skb_queue_len(&local->skb_queue_unreliable);
 	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
-		dev_kfree_skb_irq(skb);
+		ieee80211_free_txskb(hw, skb);
 		tmp--;
 		I802_DEBUG_INC(local->tx_status_drop);
 	}
@@ -159,7 +159,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 			   "dropped TX filtered frame, queue_len=%d PS=%d @%lu\n",
 			   skb_queue_len(&sta->tx_filtered[ac]),
 			   !!test_sta_flag(sta, WLAN_STA_PS_STA), jiffies);
-	dev_kfree_skb(skb);
+	ieee80211_free_txskb(&local->hw, skb);
 }
 
 static void ieee80211_check_pending_bar(struct sta_info *sta, u8 *addr, u8 tid)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e0e0d1d..c9bf83f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -354,7 +354,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 			total += skb_queue_len(&sta->ps_tx_buf[ac]);
 			if (skb) {
 				purged++;
-				dev_kfree_skb(skb);
+				ieee80211_free_txskb(&local->hw, skb);
 				break;
 			}
 		}
@@ -466,7 +466,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 			ps_dbg(tx->sdata,
 			       "STA %pM TX buffer for AC %d full - dropping oldest frame\n",
 			       sta->sta.addr, ac);
-			dev_kfree_skb(old);
+			ieee80211_free_txskb(&local->hw, old);
 		} else
 			tx->local->total_ps_buffered++;
 
@@ -1103,7 +1103,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		spin_unlock(&tx->sta->lock);
 
 		if (purge_skb)
-			dev_kfree_skb(purge_skb);
+			ieee80211_free_txskb(&tx->local->hw, purge_skb);
 	}
 
 	/* reset session timer */
@@ -1214,7 +1214,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (WARN_ON_ONCE(q >= local->hw.queues)) {
 			__skb_unlink(skb, skbs);
-			dev_kfree_skb(skb);
+			ieee80211_free_txskb(&local->hw, skb);
 			continue;
 		}
 #endif
@@ -1356,7 +1356,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop);
 		if (tx->skb)
-			dev_kfree_skb(tx->skb);
+			ieee80211_free_txskb(&tx->local->hw, tx->skb);
 		else
 			__skb_queue_purge(&tx->skbs);
 		return -1;
@@ -1393,7 +1393,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	res_prepare = ieee80211_tx_prepare(sdata, &tx, skb);
 
 	if (unlikely(res_prepare == TX_DROP)) {
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 		goto out;
 	} else if (unlikely(res_prepare == TX_QUEUED)) {
 		goto out;
@@ -1465,7 +1465,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	headroom = max_t(int, 0, headroom);
 
 	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 		rcu_read_unlock();
 		return;
 	}
@@ -2050,8 +2050,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		head_need += IEEE80211_ENCRYPT_HEADROOM;
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
-		if (ieee80211_skb_resize(sdata, skb, head_need, true))
-			goto fail;
+		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
+			ieee80211_free_txskb(&local->hw, skb);
+			return NETDEV_TX_OK;
+		}
 	}
 
 	if (encaps_data) {
@@ -2184,7 +2186,7 @@ void ieee80211_tx_pending(unsigned long data)
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 			if (WARN_ON(!info->control.vif)) {
-				kfree_skb(skb);
+				ieee80211_free_txskb(&local->hw, skb);
 				continue;
 			}
 
-- 
1.7.9.6 (Apple Git-31.1)

