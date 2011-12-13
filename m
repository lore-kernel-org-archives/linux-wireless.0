Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab1LMQWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 11:22:11 -0500
Subject: [PATCH] nl80211: accept testmode dump with netdev
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Hsu, Kenny" <kenny.hsu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 17:22:05 +0100
Message-ID: <1323793325.3355.27.camel@jlt3.sipsolutions.net> (sfid-20111213_172216_641435_A7F9B851)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All nl80211 commands that need only the wiphy
still allow identifying it by giving an interface
index, except, as Kenny pointed out, the testmode
dump support.

Fix this by looking up the wiphy via the ifidx in
this case as well.

Tested-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |   50 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

--- a/net/wireless/nl80211.c	2011-12-10 17:32:28.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-12-13 14:56:19.000000000 +0100
@@ -47,22 +47,21 @@ static struct genl_family nl80211_fam =
 };
 
 /* internal helper: get rdev and dev */
-static int get_rdev_dev_by_info_ifindex(struct genl_info *info,
-				       struct cfg80211_registered_device **rdev,
-				       struct net_device **dev)
+static int get_rdev_dev_by_ifindex(struct net *netns, struct nlattr **attrs,
+				   struct cfg80211_registered_device **rdev,
+				   struct net_device **dev)
 {
-	struct nlattr **attrs = info->attrs;
 	int ifindex;
 
 	if (!attrs[NL80211_ATTR_IFINDEX])
 		return -EINVAL;
 
 	ifindex = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
-	*dev = dev_get_by_index(genl_info_net(info), ifindex);
+	*dev = dev_get_by_index(netns, ifindex);
 	if (!*dev)
 		return -ENODEV;
 
-	*rdev = cfg80211_get_dev_from_ifindex(genl_info_net(info), ifindex);
+	*rdev = cfg80211_get_dev_from_ifindex(netns, ifindex);
 	if (IS_ERR(*rdev)) {
 		dev_put(*dev);
 		return PTR_ERR(*rdev);
@@ -4795,7 +4794,7 @@ static int nl80211_testmode_do(struct sk
 static int nl80211_testmode_dump(struct sk_buff *skb,
 				 struct netlink_callback *cb)
 {
-	struct cfg80211_registered_device *dev;
+	struct cfg80211_registered_device *rdev;
 	int err;
 	long phy_idx;
 	void *data = NULL;
@@ -4813,9 +4812,21 @@ static int nl80211_testmode_dump(struct
 				  nl80211_policy);
 		if (err)
 			return err;
-		if (!nl80211_fam.attrbuf[NL80211_ATTR_WIPHY])
-			return -EINVAL;
-		phy_idx = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_WIPHY]);
+		if (nl80211_fam.attrbuf[NL80211_ATTR_WIPHY]) {
+			phy_idx = nla_get_u32(
+				nl80211_fam.attrbuf[NL80211_ATTR_WIPHY]);
+		} else {
+			struct net_device *netdev;
+
+			err = get_rdev_dev_by_ifindex(sock_net(skb->sk),
+						      nl80211_fam.attrbuf,
+						      &rdev, &netdev);
+			if (err)
+				return err;
+			dev_put(netdev);
+			phy_idx = rdev->wiphy_idx;
+			cfg80211_unlock_rdev(rdev);
+		}
 		if (nl80211_fam.attrbuf[NL80211_ATTR_TESTDATA])
 			cb->args[1] =
 				(long)nl80211_fam.attrbuf[NL80211_ATTR_TESTDATA];
@@ -4827,15 +4838,15 @@ static int nl80211_testmode_dump(struct
 	}
 
 	mutex_lock(&cfg80211_mutex);
-	dev = cfg80211_rdev_by_wiphy_idx(phy_idx);
-	if (!dev) {
+	rdev = cfg80211_rdev_by_wiphy_idx(phy_idx);
+	if (!rdev) {
 		mutex_unlock(&cfg80211_mutex);
 		return -ENOENT;
 	}
-	cfg80211_lock_rdev(dev);
+	cfg80211_lock_rdev(rdev);
 	mutex_unlock(&cfg80211_mutex);
 
-	if (!dev->ops->testmode_dump) {
+	if (!rdev->ops->testmode_dump) {
 		err = -EOPNOTSUPP;
 		goto out_err;
 	}
@@ -4846,7 +4857,7 @@ static int nl80211_testmode_dump(struct
 					   NL80211_CMD_TESTMODE);
 		struct nlattr *tmdata;
 
-		if (nla_put_u32(skb, NL80211_ATTR_WIPHY, dev->wiphy_idx) < 0) {
+		if (nla_put_u32(skb, NL80211_ATTR_WIPHY, phy_idx) < 0) {
 			genlmsg_cancel(skb, hdr);
 			break;
 		}
@@ -4856,8 +4867,8 @@ static int nl80211_testmode_dump(struct
 			genlmsg_cancel(skb, hdr);
 			break;
 		}
-		err = dev->ops->testmode_dump(&dev->wiphy, skb, cb,
-					      data, data_len);
+		err = rdev->ops->testmode_dump(&rdev->wiphy, skb, cb,
+					       data, data_len);
 		nla_nest_end(skb, tmdata);
 
 		if (err == -ENOBUFS || err == -ENOENT) {
@@ -4875,7 +4886,7 @@ static int nl80211_testmode_dump(struct
 	/* see above */
 	cb->args[0] = phy_idx + 1;
  out_err:
-	cfg80211_unlock_rdev(dev);
+	cfg80211_unlock_rdev(rdev);
 	return err;
 }
 
@@ -6110,7 +6121,8 @@ static int nl80211_pre_doit(struct genl_
 		}
 		info->user_ptr[0] = rdev;
 	} else if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
-		err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+		err = get_rdev_dev_by_ifindex(genl_info_net(info), info->attrs,
+					      &rdev, &dev);
 		if (err) {
 			if (rtnl)
 				rtnl_unlock();


