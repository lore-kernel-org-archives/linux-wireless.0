Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935910Ab2JYRG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 13:06:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v3 1/2] mac80211: move AP teardown code to correct place
Date: Thu, 25 Oct 2012 19:07:00 +0200
Message-Id: <1351184821-23315-2-git-send-email-johannes@sipsolutions.net> (sfid-20121025_190635_345682_BFE109E4)
In-Reply-To: <1351184821-23315-1-git-send-email-johannes@sipsolutions.net>
References: <1351184821-23315-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since cfg80211 will now call the explicit stop_ap
operation when an AP interface goes down, move all
teardown code there and remove it from interface
handling. The only thing that needs to stay is the
code to dev_close() all dependent VLANs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c   |   27 ++++++++++++++++++---------
 net/mac80211/iface.c |   19 -------------------
 2 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e880db6..aeb18d7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -953,26 +953,35 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata, *vlan;
-	struct beacon_data *old;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *vlan;
+	struct ieee80211_local *local = sdata->local;
+	struct beacon_data *old_beacon;
+	struct probe_resp *old_probe_resp;
 
-	old = rtnl_dereference(sdata->u.ap.beacon);
-	if (!old)
+	old_beacon = rtnl_dereference(sdata->u.ap.beacon);
+	if (!old_beacon)
 		return -ENOENT;
+	old_probe_resp = rtnl_dereference(sdata->u.ap.probe_resp);
 
+	/* turn off carrier for this interface and dependent VLANs */
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
 		netif_carrier_off(vlan->dev);
 	netif_carrier_off(dev);
 
+	/* remove beacon and probe response */
 	RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+	RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
+	kfree_rcu(old_beacon, rcu_head);
+	kfree_rcu(old_probe_resp, rcu_head);
 
-	kfree_rcu(old, rcu_head);
-
-	sta_info_flush(sdata->local, sdata);
+	sta_info_flush(local, sdata);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
 
+	/* free all potentially still buffered bcast frames */
+	local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
+	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
+
 	ieee80211_vif_release_channel(sdata);
 
 	return 0;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index be817d1..702e9b5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -779,31 +779,12 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_sub_if_data *vlan, *tmpsdata;
-		struct beacon_data *old_beacon =
-			rtnl_dereference(sdata->u.ap.beacon);
-		struct probe_resp *old_probe_resp =
-			rtnl_dereference(sdata->u.ap.probe_resp);
-
-		/* sdata_running will return false, so this will disable */
-		ieee80211_bss_info_change_notify(sdata,
-						 BSS_CHANGED_BEACON_ENABLED);
-
-		/* remove beacon and probe response */
-		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
-		RCU_INIT_POINTER(sdata->u.ap.probe_resp, NULL);
-		synchronize_rcu();
-		kfree(old_beacon);
-		kfree(old_probe_resp);
 
 		/* down all dependent devices, that is VLANs */
 		list_for_each_entry_safe(vlan, tmpsdata, &sdata->u.ap.vlans,
 					 u.vlan.list)
 			dev_close(vlan->dev);
 		WARN_ON(!list_empty(&sdata->u.ap.vlans));
-
-		/* free all potentially still buffered bcast frames */
-		local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
-		skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 	} else if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		ieee80211_mgd_stop(sdata);
 	}
-- 
1.7.10.4

