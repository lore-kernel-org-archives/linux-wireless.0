Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbYIPSlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:41:37 -0400
Subject: [PATCH] cfg80211: reject invalid configuration items
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 20:39:36 +0200
Message-Id: <1221590376.8916.55.camel@johannes.berg> (sfid-20080916_204150_986199_7D30D9C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reject configuring mesh-id for non-mesh, monitor flags for non-monitor.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- everything.orig/net/wireless/nl80211.c	2008-09-16 20:34:40.000000000 +0200
+++ everything/net/wireless/nl80211.c	2008-09-16 20:37:21.000000000 +0200
@@ -418,7 +418,7 @@ static int nl80211_set_interface(struct 
 	int err, ifindex;
 	enum nl80211_iftype type;
 	struct net_device *dev;
-	u32 flags;
+	u32 _flags, *flags = NULL;
 
 	memset(&params, 0, sizeof(params));
 
@@ -442,18 +442,28 @@ static int nl80211_set_interface(struct 
 		goto unlock;
 	}
 
-	if (type == NL80211_IFTYPE_MESH_POINT &&
-	    info->attrs[NL80211_ATTR_MESH_ID]) {
+	if (info->attrs[NL80211_ATTR_MESH_ID]) {
+		if (type != NL80211_IFTYPE_MESH_POINT) {
+			err = -EINVAL;
+			goto unlock;
+		}
 		params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
 		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
 	}
 
+	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
+		if (type != NL80211_IFTYPE_MONITOR) {
+			err = -EINVAL;
+			goto unlock;
+		}
+		err = parse_monitor_flags(info->attrs[NL80211_ATTR_MNTR_FLAGS],
+					  &_flags);
+		if (!err)
+			flags = &_flags;
+	}
 	rtnl_lock();
-	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
-				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
-				  &flags);
 	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
-					    type, err ? NULL : &flags, &params);
+					    type, flags, &params);
 
 	dev = __dev_get_by_index(&init_net, ifindex);
 	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype != type));


