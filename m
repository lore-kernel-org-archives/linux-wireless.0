Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933180Ab2JZORG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:17:06 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use a counter for remain-on-channel cookie
Date: Fri, 26 Oct 2012 16:17:36 +0200
Message-Id: <1351261056-8284-1-git-send-email-johannes@sipsolutions.net> (sfid-20121026_161712_193279_E9BF90FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of using the pointer which can be re-used
fairly quickly due to allocator patterns and then
makes debugging difficult, maintain a counter and
use its value. Since it's a 64-bit value it can't
really wrap, but catch that case anyway since it
most likely points to a bug somewhere.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   21 +++++++++++++++------
 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/offchannel.c  |    7 +++----
 3 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 986e9a1..eebb70b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2382,13 +2382,22 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 		list_add_tail(&roc->list, &local->roc_list);
 
 	/*
-	 * cookie is either the roc (for normal roc)
+	 * cookie is either the roc cookie (for normal roc)
 	 * or the SKB (for mgmt TX)
 	 */
-	if (txskb)
+	if (!txskb) {
+		/* local->mtx protects this */
+		local->roc_cookie_counter++;
+		roc->cookie = local->roc_cookie_counter;
+		/* wow, you wrapped 64 bits ... more likely a bug */
+		if (WARN_ON(roc->cookie == 0)) {
+			roc->cookie = 1;
+			local->roc_cookie_counter++;
+		}
+		*cookie = roc->cookie;
+	} else {
 		*cookie = (unsigned long)txskb;
-	else
-		*cookie = (unsigned long)roc;
+	}
 
 	return 0;
 }
@@ -2423,7 +2432,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 		struct ieee80211_roc_work *dep, *tmp2;
 
 		list_for_each_entry_safe(dep, tmp2, &roc->dependents, list) {
-			if (!mgmt_tx && (unsigned long)dep != cookie)
+			if (!mgmt_tx && dep->cookie != cookie)
 				continue;
 			else if (mgmt_tx && dep->mgmt_tx_cookie != cookie)
 				continue;
@@ -2435,7 +2444,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 			return 0;
 		}
 
-		if (!mgmt_tx && (unsigned long)roc != cookie)
+		if (!mgmt_tx && roc->cookie != cookie)
 			continue;
 		else if (mgmt_tx && roc->mgmt_tx_cookie != cookie)
 			continue;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c0a3f7d5..37c08d3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -356,7 +356,7 @@ struct ieee80211_roc_work {
 
 	u32 duration, req_duration;
 	struct sk_buff *frame;
-	u64 mgmt_tx_cookie;
+	u64 cookie, mgmt_tx_cookie;
 };
 
 /* flags used in struct ieee80211_if_managed.flags */
@@ -1142,6 +1142,7 @@ struct ieee80211_local {
 	struct list_head roc_list;
 	struct work_struct hw_roc_start, hw_roc_done;
 	unsigned long hw_roc_start_time;
+	u64 roc_cookie_counter;
 
 	struct idr ack_status_frames;
 	spinlock_t ack_status_lock;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index c349f3a..0cd42d5 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -204,7 +204,7 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
 			roc->frame = NULL;
 		}
 	} else {
-		cfg80211_ready_on_channel(&roc->sdata->wdev, (unsigned long)roc,
+		cfg80211_ready_on_channel(&roc->sdata->wdev, roc->cookie,
 					  roc->chan, roc->chan_type,
 					  roc->req_duration, GFP_KERNEL);
 	}
@@ -320,9 +320,8 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 
 	if (!roc->mgmt_tx_cookie)
 		cfg80211_remain_on_channel_expired(&roc->sdata->wdev,
-						   (unsigned long)roc,
-						   roc->chan, roc->chan_type,
-						   GFP_KERNEL);
+						   roc->cookie, roc->chan,
+						   roc->chan_type, GFP_KERNEL);
 
 	list_for_each_entry_safe(dep, tmp, &roc->dependents, list)
 		ieee80211_roc_notify_destroy(dep);
-- 
1.7.10.4

