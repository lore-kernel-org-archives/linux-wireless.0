Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936482Ab3DRXEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 19:04:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: david.spinadel@intel.com, arend@broadcom.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: allow using wdev identifiers to get scan results
Date: Fri, 19 Apr 2013 01:04:26 +0200
Message-Id: <1366326266-19783-1-git-send-email-johannes@sipsolutions.net> (sfid-20130419_010438_313582_6CFC095E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Most dump callbacks, including the scan results one, use
the netdev to identify what to do, which is incorrect for
the P2P_DEVICE support, it needs to be able to get the
scan result from the wdev. Change all dumps to unify the
code, but ones other than scan don't really support being
executed on a wdev that has no netdev.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 166 +++++++++++++++++++++++++++----------------------
 1 file changed, 91 insertions(+), 75 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f924d45..8c8a579 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -447,62 +447,69 @@ nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
 	[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI] = { .type = NLA_U32 },
 };
 
-/* ifidx get helper */
-static int nl80211_get_ifidx(struct netlink_callback *cb)
+static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
+				     struct netlink_callback *cb,
+				     struct cfg80211_registered_device **rdev,
+				     struct wireless_dev **wdev)
 {
-	int res;
-
-	res = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
-			  nl80211_fam.attrbuf, nl80211_fam.maxattr,
-			  nl80211_policy);
-	if (res)
-		return res;
-
-	if (!nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX])
-		return -EINVAL;
+	int err;
 
-	res = nla_get_u32(nl80211_fam.attrbuf[NL80211_ATTR_IFINDEX]);
-	if (!res)
-		return -EINVAL;
-	return res;
-}
+	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
 
-static int nl80211_prepare_netdev_dump(struct sk_buff *skb,
-				       struct netlink_callback *cb,
-				       struct cfg80211_registered_device **rdev,
-				       struct net_device **dev)
-{
-	int ifidx = cb->args[0];
-	int err;
+	if (!cb->args[0]) {
+		err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+				  nl80211_fam.attrbuf, nl80211_fam.maxattr,
+				  nl80211_policy);
+		if (err)
+			goto out_unlock;
 
-	if (!ifidx)
-		ifidx = nl80211_get_ifidx(cb);
-	if (ifidx < 0)
-		return ifidx;
+		*wdev = __cfg80211_wdev_from_attrs(sock_net(skb->sk),
+						   nl80211_fam.attrbuf);
+		if (IS_ERR(*wdev)) {
+			err = PTR_ERR(*wdev);
+			goto out_unlock;
+		}
+		*rdev = wiphy_to_dev((*wdev)->wiphy);
+		cb->args[0] = (*rdev)->wiphy_idx;
+		cb->args[1] = (*wdev)->identifier;
+	} else {
+		struct wiphy *wiphy = wiphy_idx_to_wiphy(cb->args[0]);
+		struct wireless_dev *tmp;
 
-	cb->args[0] = ifidx;
+		if (!wiphy) {
+			err = -ENODEV;
+			goto out_unlock;
+		}
+		*rdev = wiphy_to_dev(wiphy);
+		*wdev = NULL;
 
-	rtnl_lock();
+		mutex_lock(&(*rdev)->devlist_mtx);
+		list_for_each_entry(tmp, &(*rdev)->wdev_list, list) {
+			if (tmp->identifier == cb->args[1]) {
+				*wdev = tmp;
+				break;
+			}
+		}
+		mutex_unlock(&(*rdev)->devlist_mtx);
 
-	*dev = __dev_get_by_index(sock_net(skb->sk), ifidx);
-	if (!*dev) {
-		err = -ENODEV;
-		goto out_rtnl;
+		if (!*wdev) {
+			err = -ENODEV;
+			goto out_unlock;
+		}
 	}
 
-	*rdev = cfg80211_get_dev_from_ifindex(sock_net(skb->sk), ifidx);
-	if (IS_ERR(*rdev)) {
-		err = PTR_ERR(*rdev);
-		goto out_rtnl;
-	}
+	cfg80211_lock_rdev(*rdev);
 
+	mutex_unlock(&cfg80211_mutex);
 	return 0;
- out_rtnl:
+ out_unlock:
+	mutex_unlock(&cfg80211_mutex);
 	rtnl_unlock();
 	return err;
 }
 
-static void nl80211_finish_netdev_dump(struct cfg80211_registered_device *rdev)
+static void nl80211_finish_wdev_dump(struct cfg80211_registered_device *rdev)
 {
 	cfg80211_unlock_rdev(rdev);
 	rtnl_unlock();
@@ -3525,15 +3532,20 @@ static int nl80211_dump_station(struct sk_buff *skb,
 {
 	struct station_info sinfo;
 	struct cfg80211_registered_device *dev;
-	struct net_device *netdev;
+	struct wireless_dev *wdev;
 	u8 mac_addr[ETH_ALEN];
-	int sta_idx = cb->args[1];
+	int sta_idx = cb->args[2];
 	int err;
 
-	err = nl80211_prepare_netdev_dump(skb, cb, &dev, &netdev);
+	err = nl80211_prepare_wdev_dump(skb, cb, &dev, &wdev);
 	if (err)
 		return err;
 
+	if (!wdev->netdev) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
 	if (!dev->ops->dump_station) {
 		err = -EOPNOTSUPP;
 		goto out_err;
@@ -3541,7 +3553,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 
 	while (1) {
 		memset(&sinfo, 0, sizeof(sinfo));
-		err = rdev_dump_station(dev, netdev, sta_idx,
+		err = rdev_dump_station(dev, wdev->netdev, sta_idx,
 					mac_addr, &sinfo);
 		if (err == -ENOENT)
 			break;
@@ -3551,7 +3563,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 		if (nl80211_send_station(skb,
 				NETLINK_CB(cb->skb).portid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				dev, netdev, mac_addr,
+				dev, wdev->netdev, mac_addr,
 				&sinfo) < 0)
 			goto out;
 
@@ -3560,10 +3572,10 @@ static int nl80211_dump_station(struct sk_buff *skb,
 
 
  out:
-	cb->args[1] = sta_idx;
+	cb->args[2] = sta_idx;
 	err = skb->len;
  out_err:
-	nl80211_finish_netdev_dump(dev);
+	nl80211_finish_wdev_dump(dev);
 
 	return err;
 }
@@ -4167,13 +4179,13 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 {
 	struct mpath_info pinfo;
 	struct cfg80211_registered_device *dev;
-	struct net_device *netdev;
+	struct wireless_dev *wdev;
 	u8 dst[ETH_ALEN];
 	u8 next_hop[ETH_ALEN];
-	int path_idx = cb->args[1];
+	int path_idx = cb->args[2];
 	int err;
 
-	err = nl80211_prepare_netdev_dump(skb, cb, &dev, &netdev);
+	err = nl80211_prepare_wdev_dump(skb, cb, &dev, &wdev);
 	if (err)
 		return err;
 
@@ -4182,14 +4194,14 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 		goto out_err;
 	}
 
-	if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT) {
+	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT) {
 		err = -EOPNOTSUPP;
 		goto out_err;
 	}
 
 	while (1) {
-		err = rdev_dump_mpath(dev, netdev, path_idx, dst, next_hop,
-				      &pinfo);
+		err = rdev_dump_mpath(dev, wdev->netdev, path_idx, dst,
+				      next_hop, &pinfo);
 		if (err == -ENOENT)
 			break;
 		if (err)
@@ -4197,7 +4209,7 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 
 		if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).portid,
 				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				       netdev, dst, next_hop,
+				       wdev->netdev, dst, next_hop,
 				       &pinfo) < 0)
 			goto out;
 
@@ -4206,10 +4218,10 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 
 
  out:
-	cb->args[1] = path_idx;
+	cb->args[2] = path_idx;
 	err = skb->len;
  out_err:
-	nl80211_finish_netdev_dump(dev);
+	nl80211_finish_wdev_dump(dev);
 	return err;
 }
 
@@ -5552,9 +5564,13 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 
 	genl_dump_check_consistent(cb, hdr, &nl80211_fam);
 
-	if (nla_put_u32(msg, NL80211_ATTR_GENERATION, rdev->bss_generation) ||
+	if (nla_put_u32(msg, NL80211_ATTR_GENERATION, rdev->bss_generation))
+		goto nla_put_failure;
+	if (wdev->netdev &&
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex))
 		goto nla_put_failure;
+	if (nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+		goto nla_put_failure;
 
 	bss = nla_nest_start(msg, NL80211_ATTR_BSS);
 	if (!bss)
@@ -5634,22 +5650,18 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 	return -EMSGSIZE;
 }
 
-static int nl80211_dump_scan(struct sk_buff *skb,
-			     struct netlink_callback *cb)
+static int nl80211_dump_scan(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct cfg80211_registered_device *rdev;
-	struct net_device *dev;
 	struct cfg80211_internal_bss *scan;
 	struct wireless_dev *wdev;
-	int start = cb->args[1], idx = 0;
+	int start = cb->args[2], idx = 0;
 	int err;
 
-	err = nl80211_prepare_netdev_dump(skb, cb, &rdev, &dev);
+	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
 	if (err)
 		return err;
 
-	wdev = dev->ieee80211_ptr;
-
 	wdev_lock(wdev);
 	spin_lock_bh(&rdev->bss_lock);
 	cfg80211_bss_expire(rdev);
@@ -5670,8 +5682,8 @@ static int nl80211_dump_scan(struct sk_buff *skb,
 	spin_unlock_bh(&rdev->bss_lock);
 	wdev_unlock(wdev);
 
-	cb->args[1] = idx;
-	nl80211_finish_netdev_dump(rdev);
+	cb->args[2] = idx;
+	nl80211_finish_wdev_dump(rdev);
 
 	return skb->len;
 }
@@ -5740,14 +5752,19 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 {
 	struct survey_info survey;
 	struct cfg80211_registered_device *dev;
-	struct net_device *netdev;
-	int survey_idx = cb->args[1];
+	struct wireless_dev *wdev;
+	int survey_idx = cb->args[2];
 	int res;
 
-	res = nl80211_prepare_netdev_dump(skb, cb, &dev, &netdev);
+	res = nl80211_prepare_wdev_dump(skb, cb, &dev, &wdev);
 	if (res)
 		return res;
 
+	if (!wdev->netdev) {
+		res = -EINVAL;
+		goto out_err;
+	}
+
 	if (!dev->ops->dump_survey) {
 		res = -EOPNOTSUPP;
 		goto out_err;
@@ -5756,7 +5773,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 	while (1) {
 		struct ieee80211_channel *chan;
 
-		res = rdev_dump_survey(dev, netdev, survey_idx, &survey);
+		res = rdev_dump_survey(dev, wdev->netdev, survey_idx, &survey);
 		if (res == -ENOENT)
 			break;
 		if (res)
@@ -5778,17 +5795,16 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 		if (nl80211_send_survey(skb,
 				NETLINK_CB(cb->skb).portid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				netdev,
-				&survey) < 0)
+				wdev->netdev, &survey) < 0)
 			goto out;
 		survey_idx++;
 	}
 
  out:
-	cb->args[1] = survey_idx;
+	cb->args[2] = survey_idx;
 	res = skb->len;
  out_err:
-	nl80211_finish_netdev_dump(dev);
+	nl80211_finish_wdev_dump(dev);
 	return res;
 }
 
-- 
1.8.0

