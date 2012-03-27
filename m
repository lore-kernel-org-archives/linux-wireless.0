Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2C0MUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 08:20:19 -0400
Message-Id: <20120327121921.578800559@sipsolutions.net> (sfid-20120327_142029_194523_1EFED34A)
Date: Tue, 27 Mar 2012 14:18:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] mac80211: inline ieee80211_add_pending_skbs
References: <20120327121835.299635879@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a trivial wrapper function, inline it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    7 +++++--
 net/mac80211/util.c        |    6 ------
 2 files changed, 5 insertions(+), 8 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-03-26 12:25:01.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2012-03-26 12:25:10.000000000 +0200
@@ -1432,11 +1432,14 @@ void ieee80211_stop_queue_by_reason(stru
 				    enum queue_stop_reason reason);
 void ieee80211_add_pending_skb(struct ieee80211_local *local,
 			       struct sk_buff *skb);
-void ieee80211_add_pending_skbs(struct ieee80211_local *local,
-				struct sk_buff_head *skbs);
 void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
 				   struct sk_buff_head *skbs,
 				   void (*fn)(void *data), void *data);
+static inline void ieee80211_add_pending_skbs(struct ieee80211_local *local,
+					      struct sk_buff_head *skbs)
+{
+	ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
+}
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
--- a/net/mac80211/util.c	2012-03-26 12:25:00.000000000 +0200
+++ b/net/mac80211/util.c	2012-03-26 12:25:10.000000000 +0200
@@ -404,12 +404,6 @@ void ieee80211_add_pending_skbs_fn(struc
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-void ieee80211_add_pending_skbs(struct ieee80211_local *local,
-				struct sk_buff_head *skbs)
-{
-	ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
-}
-
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				    enum queue_stop_reason reason)
 {


