Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60244 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab3CYM2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 08:28:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Felix Liao <Felix.Liao@watchguard.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] mac80211: fix remain-on-channel cancel crash
Date: Mon, 25 Mar 2013 13:27:54 +0100
Message-Id: <1364214474-18735-1-git-send-email-johannes@sipsolutions.net> (sfid-20130325_132805_669021_23CDE191)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a ROC item is canceled just as it expires, the work
struct may be scheduled while it is running (and waiting
for the mutex). This results in it being run after being
freed, which obviously crashes.

To fix this don't free it when aborting is requested but
instead mark it as "to be freed", which makes the work a
no-op and allows freeing it outside.

Cc: stable@vger.kernel.org [3.6+]
Reported-by: Jouni Malinen <j@w1.fi>
Tested-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  6 ++++--
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/offchannel.c  | 23 +++++++++++++++++------
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fb30681..a689360 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2582,7 +2582,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 			list_del(&dep->list);
 			mutex_unlock(&local->mtx);
 
-			ieee80211_roc_notify_destroy(dep);
+			ieee80211_roc_notify_destroy(dep, true);
 			return 0;
 		}
 
@@ -2622,7 +2622,7 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 			ieee80211_start_next_roc(local);
 		mutex_unlock(&local->mtx);
 
-		ieee80211_roc_notify_destroy(found);
+		ieee80211_roc_notify_destroy(found, true);
 	} else {
 		/* work may be pending so use it all the time */
 		found->abort = true;
@@ -2632,6 +2632,8 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 
 		/* work will clean up etc */
 		flush_delayed_work(&found->work);
+		WARN_ON(!found->to_be_freed);
+		kfree(found);
 	}
 
 	return 0;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3e2314e..5672533 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -309,6 +309,7 @@ struct ieee80211_roc_work {
 	struct ieee80211_channel *chan;
 
 	bool started, abort, hw_begun, notified;
+	bool to_be_freed;
 
 	unsigned long hw_start_time;
 
@@ -1347,7 +1348,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
 void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata);
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc);
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free);
 void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index cc79b4a..430bd25 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -297,10 +297,13 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 	}
 }
 
-void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
+void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc, bool free)
 {
 	struct ieee80211_roc_work *dep, *tmp;
 
+	if (WARN_ON(roc->to_be_freed))
+		return;
+
 	/* was never transmitted */
 	if (roc->frame) {
 		cfg80211_mgmt_tx_status(&roc->sdata->wdev,
@@ -316,9 +319,12 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 						   GFP_KERNEL);
 
 	list_for_each_entry_safe(dep, tmp, &roc->dependents, list)
-		ieee80211_roc_notify_destroy(dep);
+		ieee80211_roc_notify_destroy(dep, true);
 
-	kfree(roc);
+	if (free)
+		kfree(roc);
+	else
+		roc->to_be_freed = true;
 }
 
 void ieee80211_sw_roc_work(struct work_struct *work)
@@ -331,6 +337,9 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 
 	mutex_lock(&local->mtx);
 
+	if (roc->to_be_freed)
+		goto out_unlock;
+
 	if (roc->abort)
 		goto finish;
 
@@ -370,7 +379,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
  finish:
 		list_del(&roc->list);
 		started = roc->started;
-		ieee80211_roc_notify_destroy(roc);
+		ieee80211_roc_notify_destroy(roc, !roc->abort);
 
 		if (started) {
 			drv_flush(local, false);
@@ -410,7 +419,7 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 
 	list_del(&roc->list);
 
-	ieee80211_roc_notify_destroy(roc);
+	ieee80211_roc_notify_destroy(roc, true);
 
 	/* if there's another roc, start it now */
 	ieee80211_start_next_roc(local);
@@ -460,12 +469,14 @@ void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
 	list_for_each_entry_safe(roc, tmp, &tmp_list, list) {
 		if (local->ops->remain_on_channel) {
 			list_del(&roc->list);
-			ieee80211_roc_notify_destroy(roc);
+			ieee80211_roc_notify_destroy(roc, true);
 		} else {
 			ieee80211_queue_delayed_work(&local->hw, &roc->work, 0);
 
 			/* work will clean up etc */
 			flush_delayed_work(&roc->work);
+			WARN_ON(!roc->to_be_freed);
+			kfree(roc);
 		}
 	}
 
-- 
1.8.0

