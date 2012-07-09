Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2GIMiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 08:38:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/8] nl80211: retrieve interface data by wdev
Date: Mon,  9 Jul 2012 14:37:58 +0200
Message-Id: <1341837483-18001-4-git-send-email-johannes@sipsolutions.net> (sfid-20120709_143819_006037_085C6660)
In-Reply-To: <1341837483-18001-1-git-send-email-johannes@sipsolutions.net>
References: <1341837483-18001-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since soon there will be virtual interfaces that
don't have a netdev, use the wdev identifier for
the API to retrieve interface data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 27cd18e..5800c49 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1731,21 +1731,25 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-			      struct net_device *dev)
+			      struct wireless_dev *wdev)
 {
+	struct net_device *dev = wdev->netdev;
 	void *hdr;
-	u64 wdev_id = (u64)dev->ieee80211_ptr->identifier |
+	u64 wdev_id = (u64)wdev->identifier |
 		      ((u64)rdev->wiphy_idx << 32);
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_INTERFACE);
 	if (!hdr)
 		return -1;
 
-	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_string(msg, NL80211_ATTR_IFNAME, dev->name) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFTYPE,
-			dev->ieee80211_ptr->iftype) ||
+	if (dev &&
+	    (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	     nla_put_string(msg, NL80211_ATTR_IFNAME, dev->name) ||
+	     nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, dev->dev_addr)))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFTYPE, wdev->iftype) ||
 	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			rdev->devlist_generation ^
@@ -1794,7 +1798,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			}
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).pid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					       rdev, wdev->netdev) < 0) {
+					       rdev, wdev) < 0) {
 				mutex_unlock(&rdev->devlist_mtx);
 				goto out;
 			}
@@ -1817,14 +1821,14 @@ static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct sk_buff *msg;
 	struct cfg80211_registered_device *dev = info->user_ptr[0];
-	struct net_device *netdev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
 	if (nl80211_send_iface(msg, info->snd_pid, info->snd_seq, 0,
-			       dev, netdev) < 0) {
+			       dev, wdev) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -6833,7 +6837,7 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_interface,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags = NL80211_FLAG_NEED_NETDEV,
+		.internal_flags = NL80211_FLAG_NEED_WDEV,
 	},
 	{
 		.cmd = NL80211_CMD_SET_INTERFACE,
-- 
1.7.10.4

