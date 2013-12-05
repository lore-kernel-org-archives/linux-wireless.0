Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3LEMgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 07:36:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/8] mac80211: optimise mixed AP/VLAN station removal
Date: Thu,  5 Dec 2013 13:35:55 +0100
Message-Id: <1386246956-14257-8-git-send-email-johannes@sipsolutions.net> (sfid-20131205_133613_031702_B177BAF4)
In-Reply-To: <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
References: <1386192610.5660.4.camel@jlt4.sipsolutions.net>
 <1386246956-14257-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Teach sta_info_flush() to optionally also remove stations
from all VLANs associated with an AP interface to optimise
the station removal (in particular, synchronize_net().)

To not have to add the vlans argument throughout, do some
refactoring.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c      | 4 +---
 net/mac80211/sta_info.c | 8 ++++++--
 net/mac80211/sta_info.h | 8 +++++++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f47c7c0..b045deb2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1097,9 +1097,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	if (old_probe_resp)
 		kfree_rcu(old_probe_resp, rcu_head);
 
-	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-		sta_info_flush(vlan);
-	sta_info_flush(sdata);
+	__sta_info_flush(sdata, true);
 	synchronize_net();
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		ieee80211_free_keys(vlan);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 89d449d..4576ba0 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -960,7 +960,7 @@ void sta_info_stop(struct ieee80211_local *local)
 }
 
 
-int sta_info_flush(struct ieee80211_sub_if_data *sdata)
+int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool vlans)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
@@ -969,9 +969,13 @@ int sta_info_flush(struct ieee80211_sub_if_data *sdata)
 
 	might_sleep();
 
+	WARN_ON(vlans && sdata->vif.type != NL80211_IFTYPE_AP);
+	WARN_ON(vlans && !sdata->bss);
+
 	mutex_lock(&local->sta_mtx);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
-		if (sdata == sta->sdata) {
+		if (sdata == sta->sdata ||
+		    (vlans && sdata->bss == sta->sdata->bss)) {
 			if (!WARN_ON(__sta_info_destroy_part1(sta)))
 				list_add(&sta->free_list, &free_list);
 			ret++;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 1f20664..82043e85 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -612,8 +612,14 @@ void sta_info_stop(struct ieee80211_local *local);
  * Returns the number of removed STA entries.
  *
  * @sdata: sdata to remove all stations from
+ * @vlans: if the given interface is an AP interface, also flush VLANs
  */
-int sta_info_flush(struct ieee80211_sub_if_data *sdata);
+int __sta_info_flush(struct ieee80211_sub_if_data *sdata, bool vlans);
+
+static inline int sta_info_flush(struct ieee80211_sub_if_data *sdata)
+{
+	return __sta_info_flush(sdata, false);
+}
 
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
-- 
1.8.4.rc3

