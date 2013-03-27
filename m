Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3C0Wd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 18:33:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/3] mac80211: purge remain-on-channel items when suspending
Date: Wed, 27 Mar 2013 23:33:20 +0100
Message-Id: <1364423602-18821-2-git-send-email-johannes@sipsolutions.net> (sfid-20130327_233337_623465_12D40431)
In-Reply-To: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
References: <1364423602-18821-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

They can't really be executed while suspended and could
trigger work warnings, so abort all ROC items. When the
system resumes the notifications about this will be
delivered to userspace which can then act accordingly
(though it will assume they were canceled/finished.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h | 3 ++-
 net/mac80211/iface.c       | 2 +-
 net/mac80211/offchannel.c  | 6 +++---
 net/mac80211/pm.c          | 2 ++
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 99fe4ce..84fa129 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1314,7 +1314,8 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
 void ieee80211_offchannel_return(struct ieee80211_local *local);
 void ieee80211_roc_setup(struct ieee80211_local *local);
 void ieee80211_start_next_roc(struct ieee80211_local *local);
-void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata);
+void ieee80211_roc_purge(struct ieee80211_local *local,
+			 struct ieee80211_sub_if_data *sdata);
 void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc);
 void ieee80211_sw_roc_work(struct work_struct *work);
 void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index e995419..aadb471 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -714,7 +714,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	if (sdata->dev)
 		netif_tx_stop_all_queues(sdata->dev);
 
-	ieee80211_roc_purge(sdata);
+	ieee80211_roc_purge(local, sdata);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		ieee80211_mgd_stop(sdata);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index b01eb73..e19d6cf 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -436,15 +436,15 @@ void ieee80211_roc_setup(struct ieee80211_local *local)
 	INIT_LIST_HEAD(&local->roc_list);
 }
 
-void ieee80211_roc_purge(struct ieee80211_sub_if_data *sdata)
+void ieee80211_roc_purge(struct ieee80211_local *local,
+			 struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_roc_work *roc, *tmp;
 	LIST_HEAD(tmp_list);
 
 	mutex_lock(&local->mtx);
 	list_for_each_entry_safe(roc, tmp, &local->roc_list, list) {
-		if (roc->sdata != sdata)
+		if (sdata && roc->sdata != sdata)
 			continue;
 
 		if (roc->started && local->ops->remain_on_channel) {
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 3d16f4e..b98d927 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -19,6 +19,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	ieee80211_dfs_cac_cancel(local);
 
+	ieee80211_roc_purge(local, NULL);
+
 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
-- 
1.8.0

