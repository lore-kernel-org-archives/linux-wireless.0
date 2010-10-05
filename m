Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37083 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0JEIlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 04:41:49 -0400
Subject: [PATCH] mac80211: fix deadlock with multiple interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAA6468.3030706@candelatech.com>
References: <4CAA6468.3030706@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 10:41:47 +0200
Message-ID: <1286268107.3641.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The locking around ieee80211_recalc_smps is
buggy -- it cannot acquire another interface's
mutex while the iflist mutex is held because
another code path could be holding the iface
mutex and trying to acquire the iflist mutex.

But the locking is also unnecessary, we only
check "ifmgd->associated" as a bool, and don't
use the pointer (in check_mgd_smps).

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ieee80211_i.h |    3 +--
 net/mac80211/main.c        |    2 +-
 net/mac80211/mlme.c        |    2 +-
 net/mac80211/util.c        |   20 +++-----------------
 5 files changed, 7 insertions(+), 22 deletions(-)

--- wirelmac80211: fix deadlock with multiple interfacesess-testing.orig/net/mac80211/cfg.c	2010-10-05 10:37:21.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-10-05 10:37:29.000000000 +0200
@@ -1380,7 +1380,7 @@ int __ieee80211_request_smps(struct ieee
 	if (!sdata->u.mgd.associated ||
 	    sdata->vif.bss_conf.channel_type == NL80211_CHAN_NO_HT) {
 		mutex_lock(&sdata->local->iflist_mtx);
-		ieee80211_recalc_smps(sdata->local, sdata);
+		ieee80211_recalc_smps(sdata->local);
 		mutex_unlock(&sdata->local->iflist_mtx);
 		return 0;
 	}
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-10-05 10:37:11.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-10-05 10:37:16.000000000 +0200
@@ -1292,8 +1292,7 @@ u32 ieee80211_sta_get_rates(struct ieee8
 			    enum ieee80211_band band);
 int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 			     enum ieee80211_smps_mode smps_mode);
-void ieee80211_recalc_smps(struct ieee80211_local *local,
-			   struct ieee80211_sub_if_data *forsdata);
+void ieee80211_recalc_smps(struct ieee80211_local *local);
 
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
--- wireless-testing.orig/net/mac80211/main.c	2010-10-05 10:37:36.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-10-05 10:37:43.000000000 +0200
@@ -329,7 +329,7 @@ static void ieee80211_recalc_smps_work(s
 		container_of(work, struct ieee80211_local, recalc_smps);
 
 	mutex_lock(&local->iflist_mtx);
-	ieee80211_recalc_smps(local, NULL);
+	ieee80211_recalc_smps(local);
 	mutex_unlock(&local->iflist_mtx);
 }
 
--- wireless-testing.orig/net/mac80211/mlme.c	2010-10-05 10:37:36.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-10-05 10:37:48.000000000 +0200
@@ -913,7 +913,7 @@ static void ieee80211_set_associated(str
 
 	mutex_lock(&local->iflist_mtx);
 	ieee80211_recalc_ps(local, -1);
-	ieee80211_recalc_smps(local, sdata);
+	ieee80211_recalc_smps(local);
 	mutex_unlock(&local->iflist_mtx);
 
 	netif_tx_start_all_queues(sdata->dev);
--- wireless-testing.orig/net/mac80211/util.c	2010-10-05 10:36:21.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-10-05 10:37:06.000000000 +0200
@@ -1297,16 +1297,12 @@ static int check_mgd_smps(struct ieee802
 }
 
 /* must hold iflist_mtx */
-void ieee80211_recalc_smps(struct ieee80211_local *local,
-			   struct ieee80211_sub_if_data *forsdata)
+void ieee80211_recalc_smps(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_OFF;
 	int count = 0;
 
-	if (forsdata)
-		lockdep_assert_held(&forsdata->u.mgd.mtx);
-
 	lockdep_assert_held(&local->iflist_mtx);
 
 	/*
@@ -1324,18 +1320,8 @@ void ieee80211_recalc_smps(struct ieee80
 			continue;
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			goto set;
-		if (sdata != forsdata) {
-			/*
-			 * This nested is ok -- we are holding the iflist_mtx
-			 * so can't get here twice or so. But it's required
-			 * since normally we acquire it first and then the
-			 * iflist_mtx.
-			 */
-			mutex_lock_nested(&sdata->u.mgd.mtx, SINGLE_DEPTH_NESTING);
-			count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
-			mutex_unlock(&sdata->u.mgd.mtx);
-		} else
-			count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
+
+		count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
 
 		if (count > 1) {
 			smps_mode = IEEE80211_SMPS_OFF;


