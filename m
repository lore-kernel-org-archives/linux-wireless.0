Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab0LAVDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 16:03:14 -0500
Message-Id: <20101201210225.740820680@sipsolutions.net>
Date: Wed, 01 Dec 2010 21:59:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org
Subject: [RFC 3/5] cfg80211: require add_virtual_intf to return new dev
References: <20101201205939.009530439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

cfg80211 used to do all its bookkeeping in
the notifier, but some new stuff will have
to use local variables so make the callback
return the netdev pointer.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |   11 +++++++----
 net/mac80211/cfg.c     |   20 ++++++++++++--------
 net/wireless/nl80211.c |    7 +++++--
 3 files changed, 24 insertions(+), 14 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-12-01 21:06:31.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-12-01 21:07:35.000000000 +0100
@@ -1031,7 +1031,8 @@ struct cfg80211_pmksa {
  *
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype. Beware: You must create
- *	the new netdev in the wiphy's network namespace!
+ *	the new netdev in the wiphy's network namespace! Returns the netdev,
+ *	or an ERR_PTR.
  *
  * @del_virtual_intf: remove the virtual interface determined by ifindex.
  *
@@ -1159,9 +1160,11 @@ struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
 	int	(*resume)(struct wiphy *wiphy);
 
-	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
-				    enum nl80211_iftype type, u32 *flags,
-				    struct vif_params *params);
+	struct net_device * (*add_virtual_intf)(struct wiphy *wiphy,
+						char *name,
+						enum nl80211_iftype type,
+						u32 *flags,
+						struct vif_params *params);
 	int	(*del_virtual_intf)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*change_virtual_intf)(struct wiphy *wiphy,
 				       struct net_device *dev,
--- wireless-testing.orig/net/mac80211/cfg.c	2010-12-01 21:08:42.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-12-01 21:10:10.000000000 +0100
@@ -19,9 +19,10 @@
 #include "rate.h"
 #include "mesh.h"
 
-static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
-			       enum nl80211_iftype type, u32 *flags,
-			       struct vif_params *params)
+static struct net_device *ieee80211_add_iface(struct wiphy *wiphy, char *name,
+					      enum nl80211_iftype type,
+					      u32 *flags,
+					      struct vif_params *params)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
@@ -29,12 +30,15 @@ static int ieee80211_add_iface(struct wi
 	int err;
 
 	err = ieee80211_if_add(local, name, &dev, type, params);
-	if (err || type != NL80211_IFTYPE_MONITOR || !flags)
-		return err;
+	if (err)
+		return ERR_PTR(err);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	sdata->u.mntr_flags = *flags;
-	return 0;
+	if (type == NL80211_IFTYPE_MONITOR && flags) {
+		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+		sdata->u.mntr_flags = *flags;
+	}
+
+	return dev;
 }
 
 static int ieee80211_del_iface(struct wiphy *wiphy, struct net_device *dev)
--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-01 21:07:56.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-12-01 21:08:25.000000000 +0100
@@ -1368,6 +1368,7 @@ static int nl80211_new_interface(struct
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct vif_params params;
+	struct net_device *dev;
 	int err;
 	enum nl80211_iftype type = NL80211_IFTYPE_UNSPECIFIED;
 	u32 flags;
@@ -1403,11 +1404,13 @@ static int nl80211_new_interface(struct
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
-	err = rdev->ops->add_virtual_intf(&rdev->wiphy,
+	dev = rdev->ops->add_virtual_intf(&rdev->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
 		type, err ? NULL : &flags, &params);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
 
-	return err;
+	return 0;
 }
 
 static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)


