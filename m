Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2FSOvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 04/17] nl80211: change __cfg80211_rdev_from_info
Date: Tue, 19 Jun 2012 16:50:43 +0200
Message-Id: <1340117456-10154-5-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165116_942707_DBA6D131)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Change the function to __cfg80211_rdev_from_attrs
to take attributes instead of the info struct to
make it usable from dump callbacks for testmode.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index af23291..7e94d4d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -71,23 +71,23 @@ static int get_rdev_dev_by_ifindex(struct net *netns, struct nlattr **attrs,
 }
 
 static struct cfg80211_registered_device *
-__cfg80211_rdev_from_info(struct net *netns, struct genl_info *info)
+__cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 {
 	struct cfg80211_registered_device *rdev = NULL, *tmp;
 	struct net_device *netdev;
 
 	assert_cfg80211_lock();
 
-	if (!info->attrs[NL80211_ATTR_WIPHY] &&
-	    !info->attrs[NL80211_ATTR_IFINDEX])
+	if (!attrs[NL80211_ATTR_WIPHY] &&
+	    !attrs[NL80211_ATTR_IFINDEX])
 		return ERR_PTR(-EINVAL);
 
-	if (info->attrs[NL80211_ATTR_WIPHY])
+	if (attrs[NL80211_ATTR_WIPHY])
 		rdev = cfg80211_rdev_by_wiphy_idx(
-				nla_get_u32(info->attrs[NL80211_ATTR_WIPHY]));
+				nla_get_u32(attrs[NL80211_ATTR_WIPHY]));
 
-	if (info->attrs[NL80211_ATTR_IFINDEX]) {
-		int ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
+	if (attrs[NL80211_ATTR_IFINDEX]) {
+		int ifindex = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
 		netdev = dev_get_by_index(netns, ifindex);
 		if (netdev) {
 			if (netdev->ieee80211_ptr)
@@ -145,7 +145,7 @@ cfg80211_get_dev_from_info(struct net *netns, struct genl_info *info)
 	struct cfg80211_registered_device *rdev;
 
 	mutex_lock(&cfg80211_mutex);
-	rdev = __cfg80211_rdev_from_info(netns, info);
+	rdev = __cfg80211_rdev_from_attrs(netns, info->attrs);
 
 	/* if it is not an error we grab the lock on
 	 * it to assure it won't be going away while
@@ -1422,7 +1422,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (!netdev) {
-		rdev = __cfg80211_rdev_from_info(genl_info_net(info), info);
+		rdev = __cfg80211_rdev_from_attrs(genl_info_net(info),
+						  info->attrs);
 		if (IS_ERR(rdev)) {
 			mutex_unlock(&cfg80211_mutex);
 			return PTR_ERR(rdev);
-- 
1.7.10

