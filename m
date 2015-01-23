Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35618 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbAWKVS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 05:21:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix per-station group key get/del and memory leak
Date: Fri, 23 Jan 2015 11:21:14 +0100
Message-Id: <1422008474-30610-1-git-send-email-johannes@sipsolutions.net> (sfid-20150123_112121_645425_B8FF8D57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In case userspace attempts to obtain key information for or delete a
unicast key, this is currently erroneously rejected unless the driver
sets the WIPHY_FLAG_IBSS_RSN flag. Apparently enough drivers do so it
was never noticed.

Fix that, and while at it fix a potential memory leak: the error path
in the get_key() function was placed after allocating a message but
didn't free it - move it to a better place. Luckily admin permissions
are needed to call this operation.

Cc: stable@vger.kernel.org
Fixes: e31b82136d1ad ("cfg80211/mac80211: allow per-station GTKs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ca4b5133123..8887c6e5fca8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2854,6 +2854,9 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->get_key)
 		return -EOPNOTSUPP;
 
+	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
+		return -ENOENT;
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
@@ -2873,10 +2876,6 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr))
 		goto nla_put_failure;
 
-	if (pairwise && mac_addr &&
-	    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
-		return -ENOENT;
-
 	err = rdev_get_key(rdev, dev, key_idx, pairwise, mac_addr, &cookie,
 			   get_key_callback);
 
@@ -3047,7 +3046,7 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	wdev_lock(dev->ieee80211_ptr);
 	err = nl80211_key_allowed(dev->ieee80211_ptr);
 
-	if (key.type == NL80211_KEYTYPE_PAIRWISE && mac_addr &&
+	if (key.type == NL80211_KEYTYPE_GROUP && mac_addr &&
 	    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
 		err = -ENOENT;
 
-- 
2.1.4

