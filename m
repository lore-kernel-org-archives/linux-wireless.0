Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab2IDSmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 14:42:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: don't hang on to sched_scan_ies
Date: Tue,  4 Sep 2012 20:42:49 +0200
Message-Id: <1346784169-2929-1-git-send-email-johannes@sipsolutions.net> (sfid-20120904_204223_738128_C3F5DE70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to keep a copy of the scheduled
scan IEs after the driver has been told, if it
requires a copy it must make one. Therefore, we
can move sched_scan_ies into the function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/scan.c        |   39 ++++++++++++++-------------------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b58c8fb..9d5d26e 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1012,7 +1012,6 @@ struct ieee80211_local {
 	int scan_channel_idx;
 	int scan_ies_len;
 
-	struct ieee80211_sched_scan_ies sched_scan_ies;
 	struct work_struct sched_scan_stopped_work;
 	struct ieee80211_sub_if_data __rcu *sched_scan_sdata;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index de09d1f..ccfa35e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -921,6 +921,7 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sched_scan_ies sched_scan_ies;
 	int ret, i;
 
 	mutex_lock(&local->mtx);
@@ -939,33 +940,28 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 		if (!local->hw.wiphy->bands[i])
 			continue;
 
-		local->sched_scan_ies.ie[i] = kzalloc(2 +
-						      IEEE80211_MAX_SSID_LEN +
-						      local->scan_ies_len +
-						      req->ie_len,
-						      GFP_KERNEL);
-		if (!local->sched_scan_ies.ie[i]) {
+		sched_scan_ies.ie[i] = kzalloc(2 + IEEE80211_MAX_SSID_LEN +
+					       local->scan_ies_len +
+					       req->ie_len,
+					       GFP_KERNEL);
+		if (!sched_scan_ies.ie[i]) {
 			ret = -ENOMEM;
 			goto out_free;
 		}
 
-		local->sched_scan_ies.len[i] =
-			ieee80211_build_preq_ies(local,
-						 local->sched_scan_ies.ie[i],
+		sched_scan_ies.len[i] =
+			ieee80211_build_preq_ies(local, sched_scan_ies.ie[i],
 						 req->ie, req->ie_len, i,
 						 (u32) -1, 0);
 	}
 
-	ret = drv_sched_scan_start(local, sdata, req,
-				   &local->sched_scan_ies);
-	if (ret == 0) {
+	ret = drv_sched_scan_start(local, sdata, req, &sched_scan_ies);
+	if (ret == 0)
 		rcu_assign_pointer(local->sched_scan_sdata, sdata);
-		goto out;
-	}
 
 out_free:
 	while (i > 0)
-		kfree(local->sched_scan_ies.ie[--i]);
+		kfree(sched_scan_ies.ie[--i]);
 out:
 	mutex_unlock(&local->mtx);
 	return ret;
@@ -974,7 +970,7 @@ out:
 int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	int ret = 0, i;
+	int ret = 0;
 
 	mutex_lock(&local->mtx);
 
@@ -983,12 +979,9 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 		goto out;
 	}
 
-	if (rcu_access_pointer(local->sched_scan_sdata)) {
-		for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-			kfree(local->sched_scan_ies.ie[i]);
-
+	if (rcu_access_pointer(local->sched_scan_sdata))
 		drv_sched_scan_stop(local, sdata);
-	}
+
 out:
 	mutex_unlock(&local->mtx);
 
@@ -1010,7 +1003,6 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local,
 			     sched_scan_stopped_work);
-	int i;
 
 	mutex_lock(&local->mtx);
 
@@ -1019,9 +1011,6 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 		return;
 	}
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
-		kfree(local->sched_scan_ies.ie[i]);
-
 	rcu_assign_pointer(local->sched_scan_sdata, NULL);
 
 	mutex_unlock(&local->mtx);
-- 
1.7.10.4

