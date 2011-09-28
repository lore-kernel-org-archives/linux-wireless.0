Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39210 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1I1MNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 08:13:10 -0400
Message-Id: <20110928121129.854893439@sipsolutions.net> (sfid-20110928_141313_886989_9B32BA6D)
Date: Wed, 28 Sep 2011 14:08:54 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/15] mac80211: remove return value from add_pending_skbs
References: <20110928120849.882884360@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that we no longer use the return value, we no
longer need to maintain it either, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   10 +++++-----
 net/mac80211/util.c        |   17 +++++++----------
 2 files changed, 12 insertions(+), 15 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2011-09-28 11:44:04.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-09-28 13:22:26.000000000 +0200
@@ -1303,11 +1303,11 @@ void ieee80211_stop_queue_by_reason(stru
 				    enum queue_stop_reason reason);
 void ieee80211_add_pending_skb(struct ieee80211_local *local,
 			       struct sk_buff *skb);
-int ieee80211_add_pending_skbs(struct ieee80211_local *local,
-			       struct sk_buff_head *skbs);
-int ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
-				  struct sk_buff_head *skbs,
-				  void (*fn)(void *data), void *data);
+void ieee80211_add_pending_skbs(struct ieee80211_local *local,
+				struct sk_buff_head *skbs);
+void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
+				   struct sk_buff_head *skbs,
+				   void (*fn)(void *data), void *data);
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
--- a/net/mac80211/util.c	2011-09-28 13:18:05.000000000 +0200
+++ b/net/mac80211/util.c	2011-09-28 13:22:26.000000000 +0200
@@ -367,14 +367,14 @@ void ieee80211_add_pending_skb(struct ie
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-int ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
-				  struct sk_buff_head *skbs,
-				  void (*fn)(void *data), void *data)
+void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
+				   struct sk_buff_head *skbs,
+				   void (*fn)(void *data), void *data)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct sk_buff *skb;
 	unsigned long flags;
-	int queue, ret = 0, i;
+	int queue, i;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 	for (i = 0; i < hw->queues; i++)
@@ -389,7 +389,6 @@ int ieee80211_add_pending_skbs_fn(struct
 			continue;
 		}
 
-		ret++;
 		queue = skb_get_queue_mapping(skb);
 		__skb_queue_tail(&local->pending[queue], skb);
 	}
@@ -401,14 +400,12 @@ int ieee80211_add_pending_skbs_fn(struct
 		__ieee80211_wake_queue(hw, i,
 			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-
-	return ret;
 }
 
-int ieee80211_add_pending_skbs(struct ieee80211_local *local,
-			       struct sk_buff_head *skbs)
+void ieee80211_add_pending_skbs(struct ieee80211_local *local,
+				struct sk_buff_head *skbs)
 {
-	return ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
+	ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
 }
 
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,


