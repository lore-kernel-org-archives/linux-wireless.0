Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53024 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751641AbdFUXuZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 19:50:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/6] mac80211: fix VLAN handling with TXQs
Date: Thu, 22 Jun 2017 01:50:18 +0200
Message-Id: <20170621235022.25362-2-johannes@sipsolutions.net> (sfid-20170622_015036_602329_6DB279CF)
In-Reply-To: <20170621235022.25362-1-johannes@sipsolutions.net>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With TXQs, the AP_VLAN interfaces are resolved to their owner AP
interface when enqueuing the frame, which makes sense since the
frame really goes out on that as far as the driver is concerned.

However, this introduces a problem: frames to be encrypted with
a VLAN-specific GTK will now be encrypted with the AP GTK, since
the information about which virtual interface to use to select
the key is taken from the TXQ.

Fix this by preserving info->control.vif and using that in the
dequeue function. This now requires doing the driver-mapping
in the dequeue as well.

TODO: need to purge frames when stopping the AP_VLAN interface!!

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 15 ++-------------
 net/mac80211/tx.c      | 39 +++++++++++++++++++++++++++++++--------
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b2b5419467cc..263cb30d77c8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -919,21 +919,10 @@ struct ieee80211_tx_info {
 				unsigned long jiffies;
 			};
 			/* NB: vif can be NULL for injected frames */
-			union {
-				/* NB: vif can be NULL for injected frames */
-				struct ieee80211_vif *vif;
-
-				/* When packets are enqueued on txq it's easy
-				 * to re-construct the vif pointer. There's no
-				 * more space in tx_info so it can be used to
-				 * store the necessary enqueue time for packet
-				 * sojourn time computation.
-				 */
-				codel_time_t enqueue_time;
-			};
+			struct ieee80211_vif *vif;
 			struct ieee80211_key_conf *hw_key;
 			u32 flags;
-			/* 4 bytes free */
+			codel_time_t enqueue_time;
 		} control;
 		struct {
 			u64 cookie;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8858f4f185e9..bd609326d77c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1276,11 +1276,6 @@ static void ieee80211_set_skb_enqueue_time(struct sk_buff *skb)
 	IEEE80211_SKB_CB(skb)->control.enqueue_time = codel_get_time();
 }
 
-static void ieee80211_set_skb_vif(struct sk_buff *skb, struct txq_info *txqi)
-{
-	IEEE80211_SKB_CB(skb)->control.vif = txqi->txq.vif;
-}
-
 static u32 codel_skb_len_func(const struct sk_buff *skb)
 {
 	return skb->len;
@@ -3414,6 +3409,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result r;
+	struct ieee80211_vif *vif;
 
 	spin_lock_bh(&fq->lock);
 
@@ -3430,8 +3426,6 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	if (!skb)
 		goto out;
 
-	ieee80211_set_skb_vif(skb, txqi);
-
 	hdr = (struct ieee80211_hdr *)skb->data;
 	info = IEEE80211_SKB_CB(skb);
 
@@ -3439,7 +3433,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 	__skb_queue_head_init(&tx.skbs);
 	tx.local = local;
 	tx.skb = skb;
-	tx.sdata = vif_to_sdata(info->control.vif);
+	if (info->control.vif)
+		tx.sdata = vif_to_sdata(info->control.vif);
 
 	if (txq->sta)
 		tx.sta = container_of(txq->sta, struct sta_info, sta);
@@ -3488,6 +3483,34 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		}
 	}
 
+	switch (tx.sdata->vif.type) {
+	case NL80211_IFTYPE_MONITOR:
+		if (tx.sdata->u.mntr.flags & MONITOR_FLAG_ACTIVE) {
+			vif = &tx.sdata->vif;
+			break;
+		}
+		tx.sdata = rcu_dereference(local->monitor_sdata);
+		if (tx.sdata) {
+			vif = &tx.sdata->vif;
+			info->hw_queue =
+				vif->hw_queue[skb_get_queue_mapping(skb)];
+		} else if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
+			ieee80211_free_txskb(&local->hw, skb);
+			goto begin;
+		} else {
+			vif = NULL;
+		}
+		break;
+	case NL80211_IFTYPE_AP_VLAN:
+		tx.sdata = container_of(tx.sdata->bss,
+					struct ieee80211_sub_if_data, u.ap);
+		/* fall through */
+	default:
+		vif = &tx.sdata->vif;
+		break;
+	}
+
+	IEEE80211_SKB_CB(skb)->control.vif = vif;
 out:
 	spin_unlock_bh(&fq->lock);
 
-- 
2.11.0
