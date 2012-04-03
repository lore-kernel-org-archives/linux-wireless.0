Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab2DCIYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 04:24:05 -0400
Message-ID: <1333441440.3574.2.camel@jlt3.sipsolutions.net> (sfid-20120403_102420_268928_0D4F4CF6)
Subject: [PATCH] mac80211: manage AP netdev carrier state
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 03 Apr 2012 10:24:00 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The AP netdev is really only active when beaconing, so
manage the carrier state accordingly. Also do that for
VLAN interfaces enslaved to a given AP interface.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Javier, Thomas, I think this would also be useful for mesh to do.

 net/mac80211/cfg.c   |   10 +++++++++-
 net/mac80211/iface.c |    9 +++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/net/mac80211/cfg.c	2012-03-28 12:29:31.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-03-28 12:29:32.000000000 +0200
@@ -640,6 +640,10 @@ static int ieee80211_start_ap(struct wip
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 
+	netif_carrier_on(dev);
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		netif_carrier_on(vlan->dev);
+
 	return 0;
 }
 
@@ -665,7 +669,7 @@ static int ieee80211_change_beacon(struc
 
 static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata, *vlan;
 	struct beacon_data *old;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -674,6 +678,10 @@ static int ieee80211_stop_ap(struct wiph
 	if (!old)
 		return -ENOENT;
 
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		netif_carrier_off(vlan->dev);
+	netif_carrier_off(dev);
+
 	RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
 
 	kfree_rcu(old, rcu_head);
--- a/net/mac80211/iface.c	2012-03-28 12:29:32.000000000 +0200
+++ b/net/mac80211/iface.c	2012-03-28 12:29:32.000000000 +0200
@@ -254,7 +254,11 @@ static int ieee80211_do_open(struct net_
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
-		/* no need to tell driver */
+		/* no need to tell driver, but set carrier */
+		if (rtnl_dereference(sdata->bss->beacon))
+			netif_carrier_on(dev);
+		else
+			netif_carrier_off(dev);
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
@@ -294,7 +298,8 @@ static int ieee80211_do_open(struct net_
 		ieee80211_bss_info_change_notify(sdata, changed);
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		    sdata->vif.type == NL80211_IFTYPE_AP)
 			netif_carrier_off(dev);
 		else
 			netif_carrier_on(dev);


