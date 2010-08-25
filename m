Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0HYU6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 16:58:23 -0400
Message-Id: <20100825205726.924659600@sipsolutions.net>
Date: Wed, 25 Aug 2010 22:56:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/6] mac80211: split out concurrent vif checks
References: <20100825205619.152295081@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Split the concurrent virtual interface checks
into a new function that can be used to check
for any given new interface type.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c |   43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- wireless-testing.orig/net/mac80211/iface.c	2010-08-25 22:01:50.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-08-25 22:38:19.000000000 +0200
@@ -94,20 +94,14 @@ static inline int identical_mac_addr_all
 			 type2 == NL80211_IFTYPE_AP_VLAN));
 }
 
-static int ieee80211_open(struct net_device *dev)
+static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
+					    enum nl80211_iftype iftype)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_sub_if_data *nsdata;
 	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta;
-	u32 changed = 0;
-	int res;
-	u32 hw_reconf_flags = 0;
+	struct ieee80211_sub_if_data *nsdata;
+	struct net_device *dev = sdata->dev;
 
-	/* fail early if user set an invalid address */
-	if (!is_zero_ether_addr(dev->dev_addr) &&
-	    !is_valid_ether_addr(dev->dev_addr))
-		return -EADDRNOTAVAIL;
+	ASSERT_RTNL();
 
 	/* we hold the RTNL here so can safely walk the list */
 	list_for_each_entry(nsdata, &local->interfaces, list) {
@@ -124,7 +118,7 @@ static int ieee80211_open(struct net_dev
 			 * belonging to the same hardware. Then, however, we're
 			 * faced with having to adopt two different TSF timers...
 			 */
-			if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
+			if (iftype == NL80211_IFTYPE_ADHOC &&
 			    nsdata->vif.type == NL80211_IFTYPE_ADHOC)
 				return -EBUSY;
 
@@ -138,19 +132,40 @@ static int ieee80211_open(struct net_dev
 			/*
 			 * check whether it may have the same address
 			 */
-			if (!identical_mac_addr_allowed(sdata->vif.type,
+			if (!identical_mac_addr_allowed(iftype,
 							nsdata->vif.type))
 				return -ENOTUNIQ;
 
 			/*
 			 * can only add VLANs to enabled APs
 			 */
-			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+			if (iftype == NL80211_IFTYPE_AP_VLAN &&
 			    nsdata->vif.type == NL80211_IFTYPE_AP)
 				sdata->bss = &nsdata->u.ap;
 		}
 	}
 
+	return 0;
+}
+
+static int ieee80211_open(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	u32 changed = 0;
+	int res;
+	u32 hw_reconf_flags = 0;
+
+	/* fail early if user set an invalid address */
+	if (!is_zero_ether_addr(dev->dev_addr) &&
+	    !is_valid_ether_addr(dev->dev_addr))
+		return -EADDRNOTAVAIL;
+
+	res = ieee80211_check_concurrent_iface(sdata, sdata->vif.type);
+	if (res)
+		return res;
+
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_WDS:
 		if (!is_valid_ether_addr(sdata->u.wds.remote_addr))


