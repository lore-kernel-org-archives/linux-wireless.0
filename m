Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60796 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755481AbcJUMZU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:25:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>,
        jouni@qca.qualcomm.com, usdutt@qti.qualcomm.com,
        amarnath@qca.qualcomm.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] cfg80211: validate beacon int as part of iface combinations
Date: Fri, 21 Oct 2016 14:25:13 +0200
Message-Id: <1477052714-11223-3-git-send-email-johannes@sipsolutions.net> (sfid-20161021_142531_140574_5E3AB88D)
In-Reply-To: <1477052714-11223-1-git-send-email-johannes@sipsolutions.net>
References: <1477052714-11223-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Remove the pointless checking against interface combinations in
the initial basic beacon interval validation, that currently isn't
taking into account radar detection or channels properly. Instead,
just validate the basic range there, and then delay real checking
to the interface combination validation that drivers must do.

This means that drivers wanting to use the beacon_int_min_gcd will
now have to pass the new_beacon_int when validating the AP/mesh
start.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 12 +++-----
 net/wireless/util.c    | 82 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ec39f891b7a3..d1ffbc3a8e55 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -784,19 +784,15 @@ struct cfg80211_csa_settings {
  * @iftype_num: array with the number of interfaces of each interface
  *	type.  The index is the interface type as specified in &enum
  *	nl80211_iftype.
- * @beacon_int_gcd: a value specifying GCD of all beaconing interfaces,
- *	the GCD of a single value is considered the value itself, so for
- *	a single interface this should be set to that interface's beacon
- *	interval
- * @beacon_int_different: a flag indicating whether or not all beacon
- *	intervals (of beaconing interfaces) are different or not.
+ * @new_beacon_int: set this to the beacon interval of a new interface
+ *	that's not operating yet, if such is to be checked as part of
+ *	the verification
  */
 struct iface_combination_params {
 	int num_different_channels;
 	u8 radar_detect;
 	int iftype_num[NUM_NL80211_IFTYPES];
-	u32 beacon_int_gcd;
-	bool beacon_int_different;
+	u32 new_beacon_int;
 };
 
 /**
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 78bf53705466..40d7a6bf9432 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -13,6 +13,7 @@
 #include <net/dsfield.h>
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
+#include <linux/gcd.h>
 #include "core.h"
 #include "rdev-ops.h"
 
@@ -1558,47 +1559,52 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
 
-int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
-				 enum nl80211_iftype iftype, u32 beacon_int)
+static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
+				       u32 *beacon_int_gcd,
+				       bool *beacon_int_different)
 {
 	struct wireless_dev *wdev;
-	struct iface_combination_params params = {
-		.beacon_int_gcd = beacon_int,	/* GCD(n) = n */
-	};
 
-	if (beacon_int < 10 || beacon_int > 10000)
-		return -EINVAL;
+	*beacon_int_gcd = 0;
+	*beacon_int_different = false;
 
-	params.iftype_num[iftype] = 1;
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+	list_for_each_entry(wdev, &wiphy->wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 
-		params.iftype_num[wdev->iftype]++;
-	}
-
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		u32 bi_prev = wdev->beacon_interval;
-
-		if (!wdev->beacon_interval)
+		if (!*beacon_int_gcd) {
+			*beacon_int_gcd = wdev->beacon_interval;
 			continue;
+		}
 
-		/* slight optimisation - skip identical BIs */
-		if (wdev->beacon_interval == beacon_int)
+		if (wdev->beacon_interval == *beacon_int_gcd)
 			continue;
 
-		params.beacon_int_different = true;
-
-		/* Get the GCD */
-		while (bi_prev != 0) {
-			u32 tmp_bi = bi_prev;
+		*beacon_int_different = true;
+		*beacon_int_gcd = gcd(*beacon_int_gcd, wdev->beacon_interval);
+	}
 
-			bi_prev = params.beacon_int_gcd % bi_prev;
-			params.beacon_int_gcd = tmp_bi;
-		}
+	if (new_beacon_int && *beacon_int_gcd != new_beacon_int) {
+		*beacon_int_different = true;
+		*beacon_int_gcd = gcd(*beacon_int_gcd, new_beacon_int);
 	}
+}
 
-	return cfg80211_check_combinations(&rdev->wiphy, &params);
+int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
+				 enum nl80211_iftype iftype, u32 beacon_int)
+{
+	/*
+	 * This is just a basic pre-condition check; if interface combinations
+	 * are possible the driver must already be checking those with a call
+	 * to cfg80211_check_combinations(), in which case we'll validate more
+	 * through the cfg80211_calculate_bi_data() call and code in
+	 * cfg80211_iter_combinations().
+	 */
+
+	if (beacon_int < 10 || beacon_int > 10000)
+		return -EINVAL;
+
+	return 0;
 }
 
 int cfg80211_iter_combinations(struct wiphy *wiphy,
@@ -1612,6 +1618,21 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	int i, j, iftype;
 	int num_interfaces = 0;
 	u32 used_iftypes = 0;
+	u32 beacon_int_gcd;
+	bool beacon_int_different;
+
+	/*
+	 * This is a bit strange, since the iteration used to rely only on
+	 * the data given by the driver, but here it now relies on context,
+	 * in form of the currently operating interfaces.
+	 * This is OK for all current users, and saves us from having to
+	 * push the GCD calculations into all the drivers.
+	 * In the future, this should probably rely more on data that's in
+	 * cfg80211 already - the only thing not would appear to be any new
+	 * interfaces (while being brought up) and channel/radar data.
+	 */
+	cfg80211_calculate_bi_data(wiphy, params->new_beacon_int,
+				   &beacon_int_gcd, &beacon_int_different);
 
 	if (params->radar_detect) {
 		rcu_read_lock();
@@ -1674,12 +1695,11 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 		if ((all_iftypes & used_iftypes) != used_iftypes)
 			goto cont;
 
-		if (params->beacon_int_gcd) {
+		if (beacon_int_gcd) {
 			if (c->beacon_int_min_gcd &&
-			    params->beacon_int_gcd < c->beacon_int_min_gcd)
+			    beacon_int_gcd < c->beacon_int_min_gcd)
 				goto cont;
-			if (!c->beacon_int_min_gcd &&
-			    params->beacon_int_different)
+			if (!c->beacon_int_min_gcd && beacon_int_different)
 				goto cont;
 		}
 
-- 
2.8.1
