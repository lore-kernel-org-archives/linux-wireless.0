Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55545 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1IVPt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 11:49:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R6lX9-0002Nc-Gl
	for linux-wireless@vger.kernel.org; Thu, 22 Sep 2011 17:49:55 +0200
Message-Id: <20110922154849.928940640@sipsolutions.net> (sfid-20110922_175006_041362_CD312298)
Date: Thu, 22 Sep 2011 17:47:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 05/15] mac80211: remove return value from add_pending_skbs
References: <20110922154726.521122680@sipsolutions.net>
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

--- a/net/mac80211/ieee80211_i.h	2011-09-22 14:38:52.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-09-22 14:38:55.000000000 +0200
@@ -1302,11 +1302,11 @@ void ieee80211_stop_queue_by_reason(stru
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
--- a/net/mac80211/util.c	2011-09-22 14:38:52.000000000 +0200
+++ b/net/mac80211/util.c	2011-09-22 14:38:55.000000000 +0200
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


