Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab2FSOvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 08/17] nl80211: retrieve interface data by wdev
Date: Tue, 19 Jun 2012 16:50:47 +0200
Message-Id: <1340117456-10154-9-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165140_871272_144B044F)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
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
index 375a1cf..a6258dc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1716,21 +1716,25 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
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
@@ -1784,7 +1788,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			}
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).pid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					       rdev, wdev->netdev) < 0) {
+					       rdev, wdev) < 0) {
 				mutex_unlock(&rdev->devlist_mtx);
 				goto out;
 			}
@@ -1807,14 +1811,14 @@ static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
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
@@ -6786,7 +6790,7 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_interface,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
-		.internal_flags = NL80211_FLAG_NEED_NETDEV,
+		.internal_flags = NL80211_FLAG_NEED_WDEV,
 	},
 	{
 		.cmd = NL80211_CMD_SET_INTERFACE,
-- 
1.7.10

