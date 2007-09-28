Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbXI1TvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 15:51:11 -0400
Subject: [PATCH] mac80211: implement cfg80211's change_interface hook
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 28 Sep 2007 21:52:27 +0200
Message-Id: <1191009147.22960.20.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This implements the cfg80211 change_interface hook that changes the
type of an interface and cleans up the code a bit.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/cfg.c |   75 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 18 deletions(-)

--- wireless-dev.orig/net/mac80211/cfg.c	2007-09-28 21:35:57.390086556 +0200
+++ wireless-dev/net/mac80211/cfg.c	2007-09-28 21:46:21.130086556 +0200
@@ -12,31 +12,35 @@
 #include "ieee80211_i.h"
 #include "cfg.h"
 
+static enum ieee80211_if_types
+nl80211_type_to_mac80211_type(enum nl80211_iftype type)
+{
+	switch (type) {
+	case NL80211_IFTYPE_UNSPECIFIED:
+		return IEEE80211_IF_TYPE_STA;
+	case NL80211_IFTYPE_ADHOC:
+		return IEEE80211_IF_TYPE_IBSS;
+	case NL80211_IFTYPE_STATION:
+		return IEEE80211_IF_TYPE_STA;
+	case NL80211_IFTYPE_MONITOR:
+		return IEEE80211_IF_TYPE_MNTR;
+	default:
+		return IEEE80211_IF_TYPE_INVALID;
+	}
+}
+
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       enum nl80211_iftype type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	int itype;
+	enum ieee80211_if_types itype;
 
 	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
 		return -ENODEV;
 
-	switch (type) {
-	case NL80211_IFTYPE_UNSPECIFIED:
-		itype = IEEE80211_IF_TYPE_STA;
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		itype = IEEE80211_IF_TYPE_IBSS;
-		break;
-	case NL80211_IFTYPE_STATION:
-		itype = IEEE80211_IF_TYPE_STA;
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		itype = IEEE80211_IF_TYPE_MNTR;
-		break;
-	default:
+	itype = nl80211_type_to_mac80211_type(type);
+	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
-	}
 
 	return ieee80211_if_add(local->mdev, name, NULL, itype);
 }
@@ -50,17 +54,52 @@ static int ieee80211_del_iface(struct wi
 	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
 		return -ENODEV;
 
-	dev = dev_get_by_index(ifindex);
+	/* we're under RTNL */
+	dev = __dev_get_by_index(ifindex);
 	if (!dev)
 		return 0;
 
 	name = dev->name;
-	dev_put(dev);
 
 	return ieee80211_if_remove(local->mdev, name, -1);
 }
 
+static int ieee80211_change_iface(struct wiphy *wiphy, int ifindex,
+				  enum nl80211_iftype type)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct net_device *dev;
+	enum ieee80211_if_types itype;
+	struct ieee80211_sub_if_data *sdata;
+
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
+		return -ENODEV;
+
+	/* we're under RTNL */
+	dev = __dev_get_by_index(ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	if (netif_running(dev))
+		return -EBUSY;
+
+	itype = nl80211_type_to_mac80211_type(type);
+	if (itype == IEEE80211_IF_TYPE_INVALID)
+		return -EINVAL;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+        if (sdata->type == IEEE80211_IF_TYPE_VLAN)
+		return -EOPNOTSUPP;
+
+	ieee80211_if_reinit(dev);
+	ieee80211_if_set_type(dev, itype);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
+	.change_virtual_intf = ieee80211_change_iface,
 };


