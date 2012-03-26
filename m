Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab2CZL5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 07:57:49 -0400
Message-ID: <1332763066.5435.0.camel@jlt3.sipsolutions.net> (sfid-20120326_135812_598916_AC830A51)
Subject: [RFC] mac80211: manage AP netdev carrier state
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Felix Fietkau <nbd@openwrt.org>
Date: Mon, 26 Mar 2012 13:57:46 +0200
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
 net/mac80211/cfg.c   |   10 +++++++++-
 net/mac80211/iface.c |    9 +++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

--- a/net/mac80211/cfg.c	2012-03-26 12:25:20.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-03-26 13:25:01.000000000 +0200
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
--- a/net/mac80211/iface.c	2012-03-26 13:19:37.000000000 +0200
+++ b/net/mac80211/iface.c	2012-03-26 13:23:41.000000000 +0200
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


