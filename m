Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab2FTJFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 05:05:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/5] nl80211: refactor __cfg80211_rdev_from_info
Date: Wed, 20 Jun 2012 11:05:16 +0200
Message-Id: <1340183119-15340-3-git-send-email-johannes@sipsolutions.net> (sfid-20120620_110555_068869_E74E3FA9)
In-Reply-To: <1340183119-15340-1-git-send-email-johannes@sipsolutions.net>
References: <1340183119-15340-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Refactor the function to make it easier to
extend.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   59 +++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2d3541c..0ec9779 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -73,44 +73,47 @@ static int get_rdev_dev_by_ifindex(struct net *netns, struct nlattr **attrs,
 static struct cfg80211_registered_device *
 __cfg80211_rdev_from_info(struct genl_info *info)
 {
-	int ifindex;
-	struct cfg80211_registered_device *bywiphyidx = NULL, *byifidx = NULL;
-	struct net_device *dev;
-	int err = -EINVAL;
+	struct cfg80211_registered_device *rdev = NULL, *tmp;
+	struct net_device *netdev;
 
 	assert_cfg80211_lock();
 
-	if (info->attrs[NL80211_ATTR_WIPHY]) {
-		bywiphyidx = cfg80211_rdev_by_wiphy_idx(
+	if (!info->attrs[NL80211_ATTR_WIPHY] &&
+	    !info->attrs[NL80211_ATTR_IFINDEX])
+		return ERR_PTR(-EINVAL);
+
+	if (info->attrs[NL80211_ATTR_WIPHY])
+		rdev = cfg80211_rdev_by_wiphy_idx(
 				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
-		err = -ENODEV;
-	}
 
 	if (info->attrs[NL80211_ATTR_IFINDEX]) {
-		ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
-		dev = dev_get_by_index(genl_info_net(info), ifindex);
-		if (dev) {
-			if (dev->ieee80211_ptr)
-				byifidx =
-					wiphy_to_dev(dev->ieee80211_ptr->wiphy);
-			dev_put(dev);
-		}
-		err = -ENODEV;
-	}
+		int ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
+		netdev = dev_get_by_index(genl_info_net(info), ifindex);
+		if (netdev) {
+			if (netdev->ieee80211_ptr)
+				tmp = wiphy_to_dev(
+						netdev->ieee80211_ptr->wiphy);
+			else
+				tmp = NULL;
 
-	if (bywiphyidx && byifidx) {
-		if (bywiphyidx != byifidx)
-			return ERR_PTR(-EINVAL);
-		else
-			return bywiphyidx; /* == byifidx */
+			dev_put(netdev);
+
+			/* not wireless device -- return error */
+			if (!tmp)
+				return ERR_PTR(-EINVAL);
+
+			/* mismatch -- return error */
+			if (rdev && tmp != rdev)
+				return ERR_PTR(-EINVAL);
+
+			rdev = tmp;
+		}
 	}
-	if (bywiphyidx)
-		return bywiphyidx;
 
-	if (byifidx)
-		return byifidx;
+	if (rdev)
+		return rdev;
 
-	return ERR_PTR(err);
+	return ERR_PTR(-ENODEV);
 }
 
 /*
-- 
1.7.10

