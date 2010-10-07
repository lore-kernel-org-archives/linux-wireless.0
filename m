Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JGLKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 07:10:40 -0400
Subject: [PATCH] nl80211: use new genl helpers for WDS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bill Jordan <bjordan@rajant.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 13:10:30 +0200
Message-ID: <1286449830.3657.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Bill Jordan's patch to allow setting the WDS
peer crossed with my patch removing all the
boilerplate code in nl80211, and consequently
he didn't make use of it yet. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   45 ++++++++++++---------------------------------
 1 file changed, 12 insertions(+), 33 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2010-10-07 13:04:15.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-10-07 13:10:07.000000000 +0200
@@ -876,48 +876,25 @@ static int nl80211_set_channel(struct sk
 
 static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *rdev;
-	struct wireless_dev *wdev;
-	struct net_device *dev;
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	u8 *bssid;
-	int err;
 
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
-	rtnl_lock();
-
-	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
-	if (err)
-		goto unlock_rtnl;
-
-	wdev = dev->ieee80211_ptr;
-
-	if (netif_running(dev)) {
-		err = -EBUSY;
-		goto out;
-	}
+	if (netif_running(dev))
+		return -EBUSY;
 
-	if (!rdev->ops->set_wds_peer) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	if (!rdev->ops->set_wds_peer)
+		return -EOPNOTSUPP;
 
-	if (wdev->iftype != NL80211_IFTYPE_WDS) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	if (wdev->iftype != NL80211_IFTYPE_WDS)
+		return -EOPNOTSUPP;
 
 	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	err = rdev->ops->set_wds_peer(wdev->wiphy, dev, bssid);
-
-out:
-	cfg80211_unlock_rdev(rdev);
-	dev_put(dev);
-unlock_rtnl:
-	rtnl_unlock();
-
-	return err;
+	return rdev->ops->set_wds_peer(wdev->wiphy, dev, bssid);
 }
 
 
@@ -4860,6 +4837,8 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_set_wds_peer,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
 	},
 };
 


