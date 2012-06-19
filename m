Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab2FSOvB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 03/17] nl80211: fix netns separation
Date: Tue, 19 Jun 2012 16:50:42 +0200
Message-Id: <1340117456-10154-4-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165122_966773_881B0FBB)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are currently a few ways to "escape"
the network namespace and access a wiphy
that belongs to another namespace. Add a
netns argument to the relevant functions
to fix this.

One remaining issue with testmode will be
fixed in a follow-up patch.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0ec9779..af23291 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -71,7 +71,7 @@ static int get_rdev_dev_by_ifindex(struct net *netns, struct nlattr **attrs,
 }
 
 static struct cfg80211_registered_device *
-__cfg80211_rdev_from_info(struct genl_info *info)
+__cfg80211_rdev_from_info(struct net *netns, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = NULL, *tmp;
 	struct net_device *netdev;
@@ -88,7 +88,7 @@ __cfg80211_rdev_from_info(struct genl_info *info)
 
 	if (info->attrs[NL80211_ATTR_IFINDEX]) {
 		int ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
-		netdev = dev_get_by_index(genl_info_net(info), ifindex);
+		netdev = dev_get_by_index(netns, ifindex);
 		if (netdev) {
 			if (netdev->ieee80211_ptr)
 				tmp = wiphy_to_dev(
@@ -110,10 +110,13 @@ __cfg80211_rdev_from_info(struct genl_info *info)
 		}
 	}
 
-	if (rdev)
-		return rdev;
+	if (!rdev)
+		return ERR_PTR(-ENODEV);
 
-	return ERR_PTR(-ENODEV);
+	if (netns != wiphy_net(&rdev->wiphy))
+		return ERR_PTR(-ENODEV);
+
+	return rdev;
 }
 
 /*
@@ -137,12 +140,12 @@ __cfg80211_rdev_from_info(struct genl_info *info)
  * be checked with IS_ERR() for errors.
  */
 static struct cfg80211_registered_device *
-cfg80211_get_dev_from_info(struct genl_info *info)
+cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
 
 	mutex_lock(&cfg80211_mutex);
-	rdev = __cfg80211_rdev_from_info(info);
+	rdev = __cfg80211_rdev_from_info(netns, info);
 
 	/* if it is not an error we grab the lock on
 	 * it to assure it won't be going away while
@@ -1419,7 +1422,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (!netdev) {
-		rdev = __cfg80211_rdev_from_info(info);
+		rdev = __cfg80211_rdev_from_info(genl_info_net(info), info);
 		if (IS_ERR(rdev)) {
 			mutex_unlock(&cfg80211_mutex);
 			return PTR_ERR(rdev);
@@ -6623,7 +6626,7 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 		rtnl_lock();
 
 	if (ops->internal_flags & NL80211_FLAG_NEED_WIPHY) {
-		rdev = cfg80211_get_dev_from_info(info);
+		rdev = cfg80211_get_dev_from_info(genl_info_net(info), info);
 		if (IS_ERR(rdev)) {
 			if (rtnl)
 				rtnl_unlock();
-- 
1.7.10

