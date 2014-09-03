Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:26323 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaICMcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/10] mac80211: combine roc with the "next roc" if possible
Date: Wed,  3 Sep 2014 15:25:06 +0300
Message-Id: <1409747106-30717-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143259_333098_876CDFE8)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If the remaining time in the current roc is not long
enough, mac80211 adds the new roc right after it
(if they have similar params).

However, in case of multiple rocs, the "next roc"
is not considered, resulting in multiple rocs,
each one with its own duration.

Refactor the code a bit and consider the next roc,
so a single max roc will be used instead of
multiple rocs (which might last much longer).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 77 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 53 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index edeab09..8eea032 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2359,6 +2359,58 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	return 0;
 }
 
+static bool ieee80211_coalesce_started_roc(struct ieee80211_local *local,
+					   struct ieee80211_roc_work *new_roc,
+					   struct ieee80211_roc_work *cur_roc)
+{
+	unsigned long j = jiffies;
+	unsigned long cur_roc_end = cur_roc->hw_start_time +
+				    msecs_to_jiffies(cur_roc->duration);
+	struct ieee80211_roc_work *next_roc;
+	int new_dur;
+
+	if (WARN_ON(!cur_roc->started || !cur_roc->hw_begun))
+		return false;
+
+	if (time_after(j + IEEE80211_ROC_MIN_LEFT, cur_roc_end))
+		return false;
+
+	ieee80211_handle_roc_started(new_roc);
+
+	new_dur = new_roc->duration - jiffies_to_msecs(cur_roc_end - j);
+
+	/* cur_roc is long enough - add new_roc to the dependents list. */
+	if (new_dur <= 0) {
+		list_add_tail(&new_roc->list, &cur_roc->dependents);
+		return true;
+	}
+
+	new_roc->duration = new_dur;
+
+	/*
+	 * if cur_roc was already coalesced before, we might
+	 * want to extend the next roc instead of adding
+	 * a new one.
+	 */
+	next_roc = list_entry(cur_roc->list.next,
+			      struct ieee80211_roc_work, list);
+	if (&next_roc->list != &local->roc_list &&
+	    next_roc->chan == new_roc->chan &&
+	    next_roc->sdata == new_roc->sdata &&
+	    !WARN_ON(next_roc->started)) {
+		list_add_tail(&new_roc->list, &next_roc->dependents);
+		next_roc->duration = max(next_roc->duration,
+					 new_roc->duration);
+		next_roc->type = max(next_roc->type, new_roc->type);
+		return true;
+	}
+
+	/* add right after cur_roc */
+	list_add(&new_roc->list, &cur_roc->list);
+
+	return true;
+}
+
 static int ieee80211_start_roc_work(struct ieee80211_local *local,
 				    struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_channel *channel,
@@ -2464,8 +2516,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
 		/* If it has already started, it's more difficult ... */
 		if (local->ops->remain_on_channel) {
-			unsigned long j = jiffies;
-
 			/*
 			 * In the offloaded ROC case, if it hasn't begun, add
 			 * this new one to the dependent list to be handled
@@ -2488,29 +2538,8 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 				break;
 			}
 
-			if (time_before(j + IEEE80211_ROC_MIN_LEFT,
-					tmp->hw_start_time +
-					msecs_to_jiffies(tmp->duration))) {
-				int new_dur;
-
-				ieee80211_handle_roc_started(roc);
-
-				new_dur = roc->duration -
-					  jiffies_to_msecs(tmp->hw_start_time +
-							   msecs_to_jiffies(
-								tmp->duration) -
-							   j);
-
-				if (new_dur > 0) {
-					/* add right after tmp */
-					roc->duration = new_dur;
-					list_add(&roc->list, &tmp->list);
-				} else {
-					list_add_tail(&roc->list,
-						      &tmp->dependents);
-				}
+			if (ieee80211_coalesce_started_roc(local, roc, tmp))
 				queued = true;
-			}
 		} else if (del_timer_sync(&tmp->work.timer)) {
 			unsigned long new_end;
 
-- 
1.9.1

