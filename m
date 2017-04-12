Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35238 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752697AbdDLLGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 07:06:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: aviya.erenfeld@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] mac80211: correct MU-MIMO monitor follow functionality
Date: Wed, 12 Apr 2017 13:06:18 +0200
Message-Id: <20170412110621.8981-3-johannes@sipsolutions.net> (sfid-20170412_130635_985645_D7EF0A90)
In-Reply-To: <20170412110621.8981-1-johannes@sipsolutions.net>
References: <20170412110621.8981-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The MU-MIMO monitor follow functionality is broken because it
doesn't clear the MU-MIMO owner even if both follow features
are disabled. Fix that, and while at it move the code into a
new helper function. Call this also when creating a new monitor
interface to prepare for an upcoming cfg80211 change allowing
that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 78 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 58 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dc397815a8bf..3dd0b7511b84 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -22,6 +22,49 @@
 #include "mesh.h"
 #include "wme.h"
 
+static int ieee80211_set_mu_mimo_follow(struct ieee80211_sub_if_data *sdata,
+					struct vif_params *params)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *monitor_sdata;
+	bool mu_mimo_groups = false;
+	bool mu_mimo_follow = false;
+
+	monitor_sdata = rtnl_dereference(local->monitor_sdata);
+
+	if (!monitor_sdata)
+		return -EOPNOTSUPP;
+
+	if (params->vht_mumimo_groups) {
+		u64 membership;
+
+		BUILD_BUG_ON(sizeof(membership) != WLAN_MEMBERSHIP_LEN);
+
+		memcpy(monitor_sdata->vif.bss_conf.mu_group.membership,
+		       params->vht_mumimo_groups, WLAN_MEMBERSHIP_LEN);
+		memcpy(monitor_sdata->vif.bss_conf.mu_group.position,
+		       params->vht_mumimo_groups + WLAN_MEMBERSHIP_LEN,
+		       WLAN_USER_POSITION_LEN);
+		ieee80211_bss_info_change_notify(monitor_sdata,
+						 BSS_CHANGED_MU_GROUPS);
+		/* don't care about endianness - just check for 0 */
+		memcpy(&membership, params->vht_mumimo_groups,
+		       WLAN_MEMBERSHIP_LEN);
+		mu_mimo_groups = membership != 0;
+	}
+
+	if (params->vht_mumimo_follow_addr) {
+		mu_mimo_follow =
+			is_valid_ether_addr(params->vht_mumimo_follow_addr);
+		ether_addr_copy(monitor_sdata->u.mntr.mu_follow_addr,
+				params->vht_mumimo_follow_addr);
+	}
+
+	monitor_sdata->vif.mu_mimo_owner = mu_mimo_groups || mu_mimo_follow;
+
+	return 0;
+}
+
 static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 						const char *name,
 						unsigned char name_assign_type,
@@ -38,9 +81,17 @@ static struct wireless_dev *ieee80211_add_iface(struct wiphy *wiphy,
 	if (err)
 		return ERR_PTR(err);
 
-	if (type == NL80211_IFTYPE_MONITOR && flags) {
-		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
-		sdata->u.mntr.flags = *flags;
+	sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	if (type == NL80211_IFTYPE_MONITOR) {
+		err = ieee80211_set_mu_mimo_follow(sdata, params);
+		if (err) {
+			ieee80211_if_remove(sdata);
+			return NULL;
+		}
+
+		if (flags)
+			sdata->u.mntr.flags = *flags;
 	}
 
 	return wdev;
@@ -76,24 +127,11 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
 		struct ieee80211_local *local = sdata->local;
-		struct ieee80211_sub_if_data *monitor_sdata;
-		u32 mu_mntr_cap_flag = NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER;
-
-		monitor_sdata = rtnl_dereference(local->monitor_sdata);
-		if (monitor_sdata && params->vht_mumimo_groups) {
-			memcpy(monitor_sdata->vif.bss_conf.mu_group.membership,
-			       params->vht_mumimo_groups, WLAN_MEMBERSHIP_LEN);
-			memcpy(monitor_sdata->vif.bss_conf.mu_group.position,
-			       params->vht_mumimo_groups + WLAN_MEMBERSHIP_LEN,
-			       WLAN_USER_POSITION_LEN);
-			monitor_sdata->vif.mu_mimo_owner = true;
-			ieee80211_bss_info_change_notify(monitor_sdata,
-							 BSS_CHANGED_MU_GROUPS);
-		}
+		int err;
 
-		if (monitor_sdata && params->vht_mumimo_follow_addr)
-			ether_addr_copy(monitor_sdata->u.mntr.mu_follow_addr,
-					params->vht_mumimo_follow_addr);
+		err = ieee80211_set_mu_mimo_follow(sdata, params);
+		if (err)
+			return err;
 
 		if (!flags)
 			return 0;
-- 
2.11.0
