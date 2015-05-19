Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58912 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbbESLgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 07:36:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't split remain-on-channel for coalescing
Date: Tue, 19 May 2015 13:36:38 +0200
Message-Id: <1432035398-26586-1-git-send-email-johannes@sipsolutions.net> (sfid-20150519_133647_363810_F1ECF023)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to remain-on-channel scheduling delays, when we split an ROC
while coalescing, we'll usually get a picture like this:

existing ROC:  |------------------|
current time:              ^
new ROC:                   |------|              |-------|

If the expected response frames are then transmitted by the peer
in the hole between the two fragments of the new ROC, we miss
them and the process (e.g. ANQP query) fails.

mac80211 expects that the window to miss something is small:

existing ROC:  |------------------|
new ROC:                   |------||-------|

but that's normally not the case.

To avoid this problem, coalesce only if the new ROC's duration
is <= the remaining time on the existing one:

existing ROC:  |------------------|
new ROC:                   |-----|

and never split a new one but schedule it afterwards instead:

existing ROC:  |------------------|
new ROC:                                       |-------------|

type=bugfix
bug=not-tracked
fixes=unknown

Reported-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: EliadX Peller <eliad@wizery.com>
Reviewed-by: Matti Gottlieb <matti.gottlieb@intel.com>
Tested-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         | 59 +++++++++-------------------------------------
 net/mac80211/ieee80211_i.h |  6 -----
 2 files changed, 11 insertions(+), 54 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3469bbdc891c..b97dcad9d1f8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2538,51 +2538,22 @@ static bool ieee80211_coalesce_started_roc(struct ieee80211_local *local,
 					   struct ieee80211_roc_work *new_roc,
 					   struct ieee80211_roc_work *cur_roc)
 {
-	unsigned long j = jiffies;
-	unsigned long cur_roc_end = cur_roc->hw_start_time +
-				    msecs_to_jiffies(cur_roc->duration);
-	struct ieee80211_roc_work *next_roc;
-	int new_dur;
+	unsigned long now = jiffies;
+	unsigned long remaining = cur_roc->hw_start_time +
+				  msecs_to_jiffies(cur_roc->duration) -
+				  now;
 
 	if (WARN_ON(!cur_roc->started || !cur_roc->hw_begun))
 		return false;
 
-	if (time_after(j + IEEE80211_ROC_MIN_LEFT, cur_roc_end))
+	/* if it doesn't fit entirely, schedule a new one */
+	if (new_roc->duration > jiffies_to_msecs(remaining))
 		return false;
 
 	ieee80211_handle_roc_started(new_roc);
 
-	new_dur = new_roc->duration - jiffies_to_msecs(cur_roc_end - j);
-
-	/* cur_roc is long enough - add new_roc to the dependents list. */
-	if (new_dur <= 0) {
-		list_add_tail(&new_roc->list, &cur_roc->dependents);
-		return true;
-	}
-
-	new_roc->duration = new_dur;
-
-	/*
-	 * if cur_roc was already coalesced before, we might
-	 * want to extend the next roc instead of adding
-	 * a new one.
-	 */
-	next_roc = list_entry(cur_roc->list.next,
-			      struct ieee80211_roc_work, list);
-	if (&next_roc->list != &local->roc_list &&
-	    next_roc->chan == new_roc->chan &&
-	    next_roc->sdata == new_roc->sdata &&
-	    !WARN_ON(next_roc->started)) {
-		list_add_tail(&new_roc->list, &next_roc->dependents);
-		next_roc->duration = max(next_roc->duration,
-					 new_roc->duration);
-		next_roc->type = max(next_roc->type, new_roc->type);
-		return true;
-	}
-
-	/* add right after cur_roc */
-	list_add(&new_roc->list, &cur_roc->list);
-
+	/* add to dependents so we send the expired event properly */
+	list_add_tail(&new_roc->list, &cur_roc->dependents);
 	return true;
 }
 
@@ -2695,17 +2666,9 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 			 * In the offloaded ROC case, if it hasn't begun, add
 			 * this new one to the dependent list to be handled
 			 * when the master one begins. If it has begun,
-			 * check that there's still a minimum time left and
-			 * if so, start this one, transmitting the frame, but
-			 * add it to the list directly after this one with
-			 * a reduced time so we'll ask the driver to execute
-			 * it right after finishing the previous one, in the
-			 * hope that it'll also be executed right afterwards,
-			 * effectively extending the old one.
-			 * If there's no minimum time left, just add it to the
-			 * normal list.
-			 * TODO: the ROC type is ignored here, assuming that it
-			 * is better to immediately use the current ROC.
+			 * check if it fits entirely within the existing one,
+			 * in which case it will just be dependent as well.
+			 * Otherwise, schedule it by itself.
 			 */
 			if (!tmp->hw_begun) {
 				list_add_tail(&roc->list, &tmp->dependents);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2c4fe45ea38a..695fedb9cc96 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -322,12 +322,6 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
-#if HZ/100 == 0
-#define IEEE80211_ROC_MIN_LEFT	1
-#else
-#define IEEE80211_ROC_MIN_LEFT	(HZ/100)
-#endif
-
 struct ieee80211_roc_work {
 	struct list_head list;
 	struct list_head dependents;
-- 
2.1.4

