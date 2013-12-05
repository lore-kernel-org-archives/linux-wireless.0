Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51751 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab3LEMgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/8] mac80211: optimise synchronize_net() for sta_info_flush
Date: Thu,  5 Dec 2013 13:35:54 +0100
Message-Id: <1386246956-14257-7-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133620_180762_C06D51F5)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no reason to have one synchronize_net() for each
removed station, refactor the code slightly to have just
a single synchronize_net() for all stations.

Note that this is currently useless as hostapd removes
stations one by one and this coalescing never happens.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 42 +++++++++++++++++++++++++++++++++++++++---
 net/mac80211/sta_info.h |  2 +-
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 08e5076..89d449d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -794,7 +794,7 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 	return have_buffered;
 }
 
-int __must_check __sta_info_destroy(struct sta_info *sta)
+static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
@@ -831,7 +831,23 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	    rcu_access_pointer(sdata->u.vlan.sta) == sta)
 		RCU_INIT_POINTER(sdata->u.vlan.sta, NULL);
 
-	synchronize_net();
+	return 0;
+}
+
+static void __sta_info_destroy_part2(struct sta_info *sta)
+{
+	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	int ret;
+
+	/*
+	 * NOTE: This assumes at least synchronize_net() was done
+	 *	 after _part1 and before _part2!
+	 */
+
+	might_sleep();
+	lockdep_assert_held(&local->sta_mtx);
+
 	/* now keys can no longer be reached */
 	ieee80211_free_sta_keys(local, sta);
 
@@ -863,6 +879,18 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	ieee80211_recalc_min_chandef(sdata);
 
 	cleanup_single_sta(sta);
+}
+
+int __must_check __sta_info_destroy(struct sta_info *sta)
+{
+	int err = __sta_info_destroy_part1(sta);
+
+	if (err)
+		return err;
+
+	synchronize_net();
+
+	__sta_info_destroy_part2(sta);
 
 	return 0;
 }
@@ -936,6 +964,7 @@ int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
+	LIST_HEAD(free_list);
 	int ret = 0;
 
 	might_sleep();
@@ -943,10 +972,17 @@ int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
 		if (sdata == sta->sdata) {
-			WARN_ON(__sta_info_destroy(sta));
+			if (!WARN_ON(__sta_info_destroy_part1(sta)))
+				list_add(&sta->free_list, &free_list);
 			ret++;
 		}
 	}
+
+	if (!list_empty(&free_list)) {
+		synchronize_net();
+		list_for_each_entry_safe(sta, tmp, &free_list, free_list)
+			__sta_info_destroy_part2(sta);
+	}
 	mutex_unlock(&local->sta_mtx);
 
 	return ret;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9104f81..1f20664 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -329,7 +329,7 @@ struct ieee80211_tx_latency_stat {
  */
 struct sta_info {
 	/* General information, mostly static */
-	struct list_head list;
+	struct list_head list, free_list;
 	struct rcu_head rcu_head;
 	struct sta_info __rcu *hnext;
 	struct ieee80211_local *local;
-- 
1.8.4.rc3

