Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab2AEPdl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 10:33:41 -0500
Message-Id: <20120105153229.027613982@sipsolutions.net> (sfid-20120105_163345_607465_D746BD55)
Date: Thu, 05 Jan 2012 16:30:49 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/8] mac80211: implement sta_add/sta_remove in sta_state
References: <20120105153043.568616380@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of maintaining separate sta_add/sta_remove
callsites, implement it in sta_state when the driver
has no sta_state implementation.

The only behavioural change this should cause is in
secure mesh mode: with this the station entries will
only be created after the stations are set to AUTH.
Given which drivers support mesh, this seems to not
be a problem.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/driver-ops.h |   11 ++++++++++-
 net/mac80211/pm.c         |    2 --
 net/mac80211/sta_info.c   |   23 +++++++++--------------
 net/mac80211/util.c       |    2 --
 4 files changed, 19 insertions(+), 19 deletions(-)

--- a/net/mac80211/sta_info.c	2012-01-05 16:22:36.000000000 +0100
+++ b/net/mac80211/sta_info.c	2012-01-05 16:29:46.000000000 +0100
@@ -367,7 +367,12 @@ static int sta_info_insert_drv_state(str
 	}
 
 	if (!err) {
-		sta->uploaded = true;
+		/*
+		 * Drivers using legacy sta_add/sta_remove callbacks only
+		 * get uploaded set to true after sta_add is called.
+		 */
+		if (!local->ops->sta_add)
+			sta->uploaded = true;
 		return 0;
 	}
 
@@ -419,18 +424,9 @@ static int sta_info_insert_finish(struct
 
 	if (!sta->dummy || dummy_reinsert) {
 		/* notify driver */
-		err = drv_sta_add(local, sdata, &sta->sta);
-		if (err) {
-			if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
-				goto out_err;
-			printk(KERN_DEBUG "%s: failed to add IBSS STA %pM to "
-					  "driver (%d) - keeping it anyway.\n",
-			       sdata->name, sta->sta.addr, err);
-		} else {
-			err = sta_info_insert_drv_state(local, sdata, sta);
-			if (err)
-				goto out_err;
-		}
+		err = sta_info_insert_drv_state(local, sdata, sta);
+		if (err)
+			goto out_err;
 	}
 
 	if (!dummy_reinsert) {
@@ -812,7 +808,6 @@ int __must_check __sta_info_destroy(stru
 	}
 
 	if (sta->uploaded) {
-		drv_sta_remove(local, sdata, &sta->sta);
 		ret = drv_sta_state(local, sdata, sta, IEEE80211_STA_NONE,
 				    IEEE80211_STA_NOTEXIST);
 		WARN_ON_ONCE(ret != 0);
--- a/net/mac80211/util.c	2012-01-05 16:09:23.000000000 +0100
+++ b/net/mac80211/util.c	2012-01-05 16:29:46.000000000 +0100
@@ -1188,8 +1188,6 @@ int ieee80211_reconfig(struct ieee80211_
 		if (sta->uploaded) {
 			enum ieee80211_sta_state state;
 
-			WARN_ON(drv_sta_add(local, sta->sdata, &sta->sta));
-
 			for (state = IEEE80211_STA_NOTEXIST;
 			     state < sta->sta_state - 1; state++)
 				WARN_ON(drv_sta_state(local, sta->sdata, sta,
--- a/net/mac80211/pm.c	2012-01-05 16:09:23.000000000 +0100
+++ b/net/mac80211/pm.c	2012-01-05 16:29:46.000000000 +0100
@@ -100,8 +100,6 @@ int __ieee80211_suspend(struct ieee80211
 		if (sta->uploaded) {
 			enum ieee80211_sta_state state;
 
-			drv_sta_remove(local, sta->sdata, &sta->sta);
-
 			state = sta->sta_state;
 			for (; state > IEEE80211_STA_NOTEXIST; state--)
 				WARN_ON(drv_sta_state(local, sdata, sta,
--- a/net/mac80211/driver-ops.h	2012-01-05 16:09:23.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2012-01-05 16:29:46.000000000 +0100
@@ -493,9 +493,18 @@ int drv_sta_state(struct ieee80211_local
 	check_sdata_in_driver(sdata);
 
 	trace_drv_sta_state(local, sdata, &sta->sta, old_state, new_state);
-	if (local->ops->sta_state)
+	if (local->ops->sta_state) {
 		ret = local->ops->sta_state(&local->hw, &sdata->vif, &sta->sta,
 					    old_state, new_state);
+	} else if (old_state == IEEE80211_STA_AUTH &&
+		   new_state == IEEE80211_STA_ASSOC) {
+		ret = drv_sta_add(local, sdata, &sta->sta);
+		if (ret == 0)
+			sta->uploaded = true;
+	} else if (old_state == IEEE80211_STA_ASSOC &&
+		   new_state == IEEE80211_STA_AUTH) {
+		drv_sta_remove(local, sdata, &sta->sta);
+	}
 	trace_drv_return_int(local, ret);
 	return ret;
 }


