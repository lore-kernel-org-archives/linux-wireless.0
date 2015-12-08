Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35376 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965041AbbLHOGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:06:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 9/9] mac80211: reprogram in interface order
Date: Tue,  8 Dec 2015 16:04:39 +0200
Message-Id: <1449583479-26658-10-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151208_150647_908724_FBCC33BD)
In-Reply-To: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1449583479-26658-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During reprogramming, mac80211 currently first adds all the channel
contexts, then binds them to the vifs and then goes to reconfigure
all the interfaces. Drivers might, perhaps implicitly, rely on the
operation order for certain things that typically happen within a
single function elsewhere in mac80211. To avoid problems with that,
reorder the code in mac80211's restart/reprogramming to work fully
within the interface loop so that the order of operations is like
in normal operation.

For iwlwifi, this fixes a firmware crash when reprogramming with an
AP/GO interface active.

Reported-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 76 ++++++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1a26ebd..f4b2c04 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1726,6 +1726,27 @@ static void ieee80211_assign_chanctx(struct ieee80211_local *local,
 	mutex_unlock(&local->chanctx_mtx);
 }
 
+static void ieee80211_reconfig_stations(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	/* add STAs back */
+	mutex_lock(&local->sta_mtx);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		enum ieee80211_sta_state state;
+
+		if (!sta->uploaded || sta->sdata != sdata)
+			continue;
+
+		for (state = IEEE80211_STA_NOTEXIST;
+		     state < sta->sta_state; state++)
+			WARN_ON(drv_sta_state(local, sta->sdata, sta, state,
+					      state + 1));
+	}
+	mutex_unlock(&local->sta_mtx);
+}
+
 int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
@@ -1861,50 +1882,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 				WARN_ON(drv_add_chanctx(local, ctx));
 		mutex_unlock(&local->chanctx_mtx);
 
-		list_for_each_entry(sdata, &local->interfaces, list) {
-			if (!ieee80211_sdata_running(sdata))
-				continue;
-			ieee80211_assign_chanctx(local, sdata);
-		}
-
 		sdata = rtnl_dereference(local->monitor_sdata);
 		if (sdata && ieee80211_sdata_running(sdata))
 			ieee80211_assign_chanctx(local, sdata);
 	}
 
-	/* add STAs back */
-	mutex_lock(&local->sta_mtx);
-	list_for_each_entry(sta, &local->sta_list, list) {
-		enum ieee80211_sta_state state;
-
-		if (!sta->uploaded)
-			continue;
-
-		/* AP-mode stations will be added later */
-		if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
-			continue;
-
-		for (state = IEEE80211_STA_NOTEXIST;
-		     state < sta->sta_state; state++)
-			WARN_ON(drv_sta_state(local, sta->sdata, sta, state,
-					      state + 1));
-	}
-	mutex_unlock(&local->sta_mtx);
-
-	/* reconfigure tx conf */
-	if (hw->queues >= IEEE80211_NUM_ACS) {
-		list_for_each_entry(sdata, &local->interfaces, list) {
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-			    sdata->vif.type == NL80211_IFTYPE_MONITOR ||
-			    !ieee80211_sdata_running(sdata))
-				continue;
-
-			for (i = 0; i < IEEE80211_NUM_ACS; i++)
-				drv_conf_tx(local, sdata, i,
-					    &sdata->tx_conf[i]);
-		}
-	}
-
 	/* reconfigure hardware */
 	ieee80211_hw_config(local, ~0);
 
@@ -1917,6 +1899,22 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
+		ieee80211_assign_chanctx(local, sdata);
+
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_AP_VLAN:
+		case NL80211_IFTYPE_MONITOR:
+			break;
+		default:
+			ieee80211_reconfig_stations(sdata);
+			/* fall through */
+		case NL80211_IFTYPE_AP: /* AP stations are handled later */
+			for (i = 0; i < IEEE80211_NUM_ACS; i++)
+				drv_conf_tx(local, sdata, i,
+					    &sdata->tx_conf[i]);
+			break;
+		}
+
 		/* common change flags for all interface types */
 		changed = BSS_CHANGED_ERP_CTS_PROT |
 			  BSS_CHANGED_ERP_PREAMBLE |
-- 
2.5.0

