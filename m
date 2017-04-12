Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35250 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752837AbdDLLG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 07:06:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: aviya.erenfeld@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/6] mac80211: use common code for monitor options in add/change
Date: Wed, 12 Apr 2017 13:06:21 +0200
Message-Id: <20170412110621.8981-6-johannes@sipsolutions.net> (sfid-20170412_130634_643028_12035135)
In-Reply-To: <20170412110621.8981-1-johannes@sipsolutions.net>
References: <20170412110621.8981-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Refactor the code to have common code for changing monitor
options when adding and changing virtual interfaces. This
will make it easier to add BPF filters to both paths. Note
that this code carefully checks the error conditions first
and only then applies the changes, to guarantee atomicity.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 121 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 63 insertions(+), 58 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index de52fe3e0ce6..4ff03c88022e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -22,31 +22,23 @@
 #include "mesh.h"
 #include "wme.h"
 
-static int ieee80211_set_mu_mimo_follow(struct ieee80211_sub_if_data *sdata,
-					struct vif_params *params)
+static void ieee80211_set_mu_mimo_follow(struct ieee80211_sub_if_data *sdata,
+					 struct vif_params *params)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sub_if_data *monitor_sdata;
 	bool mu_mimo_groups = false;
 	bool mu_mimo_follow = false;
 
-	monitor_sdata = rtnl_dereference(local->monitor_sdata);
-
-	if (!monitor_sdata)
-		return -EOPNOTSUPP;
-
 	if (params->vht_mumimo_groups) {
 		u64 membership;
 
 		BUILD_BUG_ON(sizeof(membership) != WLAN_MEMBERSHIP_LEN);
 
-		memcpy(monitor_sdata->vif.bss_conf.mu_group.membership,
+		memcpy(sdata->vif.bss_conf.mu_group.membership,
 		       params->vht_mumimo_groups, WLAN_MEMBERSHIP_LEN);
-		memcpy(monitor_sdata->vif.bss_conf.mu_group.position,
+		memcpy(sdata->vif.bss_conf.mu_group.position,
 		       params->vht_mumimo_groups + WLAN_MEMBERSHIP_LEN,
 		       WLAN_USER_POSITION_LEN);
-		ieee80211_bss_info_change_notify(monitor_sdata,
-						 BSS_CHANGED_MU_GROUPS);
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_MU_GROUPS);
 		/* don't care about endianness - just check for 0 */
 		memcpy(&membership, params->vht_mumimo_groups,
 		       WLAN_MEMBERSHIP_LEN);
@@ -56,11 +48,63 @@ static int ieee80211_set_mu_mimo_follow(struct ieee80211_sub_if_data *sdata,
 	if (params->vht_mumimo_follow_addr) {
 		mu_mimo_follow =
 			is_valid_ether_addr(params->vht_mumimo_follow_addr);
-		ether_addr_copy(monitor_sdata->u.mntr.mu_follow_addr,
+		ether_addr_copy(sdata->u.mntr.mu_follow_addr,
 				params->vht_mumimo_follow_addr);
 	}
 
-	monitor_sdata->vif.mu_mimo_owner = mu_mimo_groups || mu_mimo_follow;
+	sdata->vif.mu_mimo_owner = mu_mimo_groups || mu_mimo_follow;
+}
+
+static int ieee80211_set_mon_options(struct ieee80211_sub_if_data *sdata,
+				     struct vif_params *params)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *monitor_sdata;
+
+	/* check flags first */
+	if (params->flags && ieee80211_sdata_running(sdata)) {
+		u32 mask = MONITOR_FLAG_COOK_FRAMES | MONITOR_FLAG_ACTIVE;
+
+		/*
+		 * Prohibit MONITOR_FLAG_COOK_FRAMES and
+		 * MONITOR_FLAG_ACTIVE to be changed while the
+		 * interface is up.
+		 * Else we would need to add a lot of cruft
+		 * to update everything:
+		 *	cooked_mntrs, monitor and all fif_* counters
+		 *	reconfigure hardware
+		 */
+		if ((params->flags & mask) != (sdata->u.mntr.flags & mask))
+			return -EBUSY;
+	}
+
+	/* also validate MU-MIMO change */
+	monitor_sdata = rtnl_dereference(local->monitor_sdata);
+
+	if (!monitor_sdata &&
+	    (params->vht_mumimo_groups || params->vht_mumimo_follow_addr))
+		return -EOPNOTSUPP;
+
+	/* apply all changes now - no failures allowed */
+
+	ieee80211_set_mu_mimo_follow(monitor_sdata, params);
+
+	if (params->flags) {
+		if (ieee80211_sdata_running(sdata)) {
+			ieee80211_adjust_monitor_flags(sdata, -1);
+			sdata->u.mntr.flags = params->flags;
+			ieee80211_adjust_monitor_flags(sdata, 1);
+
+			ieee80211_configure_filter(local);
+		} else {
+			/*
+			 * Because the interface is down, ieee80211_do_stop
+			 * and ieee80211_do_open take care of "everything"
+			 * mentioned in the comment above.
+			 */
+			sdata->u.mntr.flags = params->flags;
+		}
+	}
 
 	return 0;
 }
@@ -83,13 +127,11 @@ static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 	sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
 	if (type == NL80211_IFTYPE_MONITOR) {
-		err = ieee80211_set_mu_mimo_follow(sdata, params);
+		err = ieee80211_set_mon_options(sdata, params);
 		if (err) {
 			ieee80211_if_remove(sdata);
 			return NULL;
 		}
-
-		sdata->u.mntr.flags = params->flags;
 	}
 
 	return wdev;
@@ -124,46 +166,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 	}
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
-		struct ieee80211_local *local = sdata->local;
-		int err;
-
-		err = ieee80211_set_mu_mimo_follow(sdata, params);
-		if (err)
-			return err;
-
-		if (!params->flags)
-			return 0;
-
-		if (ieee80211_sdata_running(sdata)) {
-			u32 mask = MONITOR_FLAG_COOK_FRAMES |
-				   MONITOR_FLAG_ACTIVE;
-
-			/*
-			 * Prohibit MONITOR_FLAG_COOK_FRAMES and
-			 * MONITOR_FLAG_ACTIVE to be changed while the
-			 * interface is up.
-			 * Else we would need to add a lot of cruft
-			 * to update everything:
-			 *	cooked_mntrs, monitor and all fif_* counters
-			 *	reconfigure hardware
-			 */
-			if ((params->flags & mask) !=
-			    (sdata->u.mntr.flags & mask))
-				return -EBUSY;
-
-			ieee80211_adjust_monitor_flags(sdata, -1);
-			sdata->u.mntr.flags = params->flags;
-			ieee80211_adjust_monitor_flags(sdata, 1);
-
-			ieee80211_configure_filter(local);
-		} else {
-			/*
-			 * Because the interface is down, ieee80211_do_stop
-			 * and ieee80211_do_open take care of "everything"
-			 * mentioned in the comment above.
-			 */
-			sdata->u.mntr.flags = params->flags;
-		}
+		ret = ieee80211_set_mon_options(sdata, params);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
-- 
2.11.0
