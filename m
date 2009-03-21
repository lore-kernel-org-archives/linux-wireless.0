Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53530 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbZCUQID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 12:08:03 -0400
Subject: [PATCH] cfg80211: accept no-op interface mode changes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 17:07:59 +0100
Message-Id: <1237651679.5100.272.camel@johannes.local> (sfid-20090321_170813_190951_412C7F28)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When somebody tries to set the interface mode to the existing
mode, don't ask the driver but silently accept the setting.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c     |   28 +++++++++++++++++++++-------
 net/wireless/wext-compat.c |   11 +++++++++--
 2 files changed, 30 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-03-21 17:06:12.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-03-21 17:06:19.000000000 +0100
@@ -607,6 +607,7 @@ static int nl80211_set_interface(struct 
 	enum nl80211_iftype type;
 	struct net_device *dev;
 	u32 _flags, *flags = NULL;
+	bool change = false;
 
 	memset(&params, 0, sizeof(params));
 
@@ -620,11 +621,17 @@ static int nl80211_set_interface(struct 
 	type = dev->ieee80211_ptr->iftype;
 	dev_put(dev);
 
-	err = -EINVAL;
 	if (info->attrs[NL80211_ATTR_IFTYPE]) {
-		type = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
-		if (type > NL80211_IFTYPE_MAX)
+		enum nl80211_iftype ntype;
+
+		ntype = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
+		if (type != ntype)
+			change = true;
+		type = ntype;
+		if (type > NL80211_IFTYPE_MAX) {
+			err = -EINVAL;
 			goto unlock;
+		}
 	}
 
 	if (!drv->ops->change_virtual_intf ||
@@ -640,6 +647,7 @@ static int nl80211_set_interface(struct 
 		}
 		params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
 		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
+		change = true;
 	}
 
 	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
@@ -649,12 +657,18 @@ static int nl80211_set_interface(struct 
 		}
 		err = parse_monitor_flags(info->attrs[NL80211_ATTR_MNTR_FLAGS],
 					  &_flags);
-		if (!err)
-			flags = &_flags;
+		if (err)
+			goto unlock;
+
+		flags = &_flags;
+		change = true;
 	}
 
-	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
-					    type, flags, &params);
+	if (change)
+		err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
+						    type, flags, &params);
+	else
+		err = 0;
 
 	dev = __dev_get_by_index(&init_net, ifindex);
 	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype != type));
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-03-21 17:06:11.000000000 +0100
+++ wireless-testing/net/wireless/wext-compat.c	2009-03-21 17:06:19.000000000 +0100
@@ -66,6 +66,7 @@ int cfg80211_wext_siwmode(struct net_dev
 	struct cfg80211_registered_device *rdev;
 	struct vif_params vifparams;
 	enum nl80211_iftype type;
+	int ret;
 
 	if (!wdev)
 		return -EOPNOTSUPP;
@@ -96,10 +97,16 @@ int cfg80211_wext_siwmode(struct net_dev
 		return -EINVAL;
 	}
 
+	if (type == wdev->iftype)
+		return 0;
+
 	memset(&vifparams, 0, sizeof(vifparams));
 
-	return rdev->ops->change_virtual_intf(wdev->wiphy, dev->ifindex, type,
-					      NULL, &vifparams);
+	ret = rdev->ops->change_virtual_intf(wdev->wiphy, dev->ifindex, type,
+					     NULL, &vifparams);
+	WARN_ON(!ret && wdev->iftype != type);
+
+	return ret;
 }
 EXPORT_SYMBOL(cfg80211_wext_siwmode);
 


