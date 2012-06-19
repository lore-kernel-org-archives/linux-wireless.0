Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52369 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2FSOvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 07/17] nl80211: add NL80211_FLAG_NEED_WDEV
Date: Tue, 19 Jun 2012 16:50:46 +0200
Message-Id: <1340117456-10154-8-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165112_727485_7D9F3038)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some nl80211 callbacks will soon need the wdev instead
of the netdev, so add NL80211_FLAG_NEED_WDEV to allow
them to request that. Add NL80211_FLAG_NEED_WDEV_UP as
well which checks the netdev is UP if one exists.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   57 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6bf9da0..375a1cf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6671,6 +6671,10 @@ static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
 #define NL80211_FLAG_CHECK_NETDEV_UP	0x08
 #define NL80211_FLAG_NEED_NETDEV_UP	(NL80211_FLAG_NEED_NETDEV |\
 					 NL80211_FLAG_CHECK_NETDEV_UP)
+#define NL80211_FLAG_NEED_WDEV		0x10
+/* If a netdev is associated, it must be UP */
+#define NL80211_FLAG_NEED_WDEV_UP	(NL80211_FLAG_NEED_WDEV |\
+					 NL80211_FLAG_CHECK_NETDEV_UP)
 
 static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info)
@@ -6691,7 +6695,8 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			return PTR_ERR(rdev);
 		}
 		info->user_ptr[0] = rdev;
-	} else if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
+	} else if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV ||
+		   ops->internal_flags & NL80211_FLAG_NEED_WDEV) {
 		mutex_lock(&cfg80211_mutex);
 		wdev = __cfg80211_wdev_from_attrs(genl_info_net(info),
 						  info->attrs);
@@ -6702,31 +6707,39 @@ static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			return PTR_ERR(wdev);
 		}
 
-		if (!wdev->netdev) {
-			mutex_unlock(&cfg80211_mutex);
-			if (rtnl)
-				rtnl_unlock();
-			return -EINVAL;
-		}
-
 		dev = wdev->netdev;
 		rdev = wiphy_to_dev(wdev->wiphy);
 
-		if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
-		    !netif_running(dev)) {
-			mutex_unlock(&cfg80211_mutex);
-			if (rtnl)
-				rtnl_unlock();
-			return -ENETDOWN;
+		if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
+			if (!dev) {
+				mutex_unlock(&cfg80211_mutex);
+				if (rtnl)
+					rtnl_unlock();
+				return -EINVAL;
+			}
+
+			info->user_ptr[1] = dev;
+		} else {
+			info->user_ptr[1] = wdev;
+		}
+
+		if (dev) {
+			if (ops->internal_flags & NL80211_FLAG_CHECK_NETDEV_UP &&
+			    !netif_running(dev)) {
+				mutex_unlock(&cfg80211_mutex);
+				if (rtnl)
+					rtnl_unlock();
+				return -ENETDOWN;
+			}
+
+			dev_hold(dev);
 		}
 
-		dev_hold(dev);
 		cfg80211_lock_rdev(rdev);
 
 		mutex_unlock(&cfg80211_mutex);
 
 		info->user_ptr[0] = rdev;
-		info->user_ptr[1] = dev;
 	}
 
 	return 0;
@@ -6737,8 +6750,16 @@ static void nl80211_post_doit(struct genl_ops *ops, struct sk_buff *skb,
 {
 	if (info->user_ptr[0])
 		cfg80211_unlock_rdev(info->user_ptr[0]);
-	if (info->user_ptr[1])
-		dev_put(info->user_ptr[1]);
+	if (info->user_ptr[1]) {
+		if (ops->internal_flags & NL80211_FLAG_NEED_WDEV) {
+			struct wireless_dev *wdev = info->user_ptr[1];
+
+			if (wdev->netdev)
+				dev_put(wdev->netdev);
+		} else {
+			dev_put(info->user_ptr[1]);
+		}
+	}
 	if (ops->internal_flags & NL80211_FLAG_NEED_RTNL)
 		rtnl_unlock();
 }
-- 
1.7.10

