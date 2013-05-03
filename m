Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61397 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab3ECCgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 22:36:37 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so668107pde.18
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 19:36:36 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>, me@bobcopeland.com,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [RFC 12/12] {nl,mac}80211: allow mpath dump to span local MBSS
Date: Thu,  2 May 2013 19:34:02 -0700
Message-Id: <1367548442-8229-13-git-send-email-thomas@cozybit.com> (sfid-20130503_043640_612669_70B884F5)
In-Reply-To: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
References: <1367548442-8229-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow the user to specify a flag
NL80211_ATTR_MPATH_DUMP_MBSS along with an mpath dump
request to dump all paths in the interface's mbss.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/net/cfg80211.h       |    5 +++--
 include/uapi/linux/nl80211.h |    7 +++++--
 net/mac80211/cfg.c           |    8 +++++---
 net/mac80211/mesh.h          |    3 ++-
 net/mac80211/mesh_pathtbl.c  |    8 ++++++--
 net/wireless/nl80211.c       |   18 +++++++++++++++---
 net/wireless/rdev-ops.h      |   10 ++++++----
 7 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 21007e7..fa9a6e6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2087,8 +2087,9 @@ struct cfg80211_ops {
 			       u8 *dst, u8 *next_hop,
 			       struct mpath_info *pinfo);
 	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
-			       int idx, u8 *dst, u8 *next_hop,
-			       struct mpath_info *pinfo);
+			      int idx, struct net_device **pathdev,
+			      u8 *dst, u8 *next_hop,
+			      struct mpath_info *pinfo, bool mbss);
 	int	(*get_mesh_config)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 549ce133..6c1a03e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -205,8 +205,9 @@
  *	by %NL80211_ATTR_IFINDEX.
  *
  * @NL80211_CMD_GET_MPATH: Get mesh path attributes for mesh path to
- * 	destination %NL80211_ATTR_MAC on the interface identified by
- * 	%NL80211_ATTR_IFINDEX.
+ *	destination %NL80211_ATTR_MAC on the interface identified by
+ *	%NL80211_ATTR_IFINDEX. If %NL80211_ATTR_MPATH_MBSS is set, get all
+ *	mpaths in mbss, not just ones matched by %NL80211_ATTR_IFINDEX.
  * @NL80211_CMD_SET_MPATH:  Set mesh path attributes for mesh path to
  * 	destination %NL80211_ATTR_MAC on the interface identified by
  * 	%NL80211_ATTR_IFINDEX.
@@ -1729,6 +1730,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CRIT_PROT_ID,
 	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
 
+	NL80211_ATTR_MPATH_DUMP_MBSS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 398df0a..ff713d5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1681,8 +1681,9 @@ static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
-				 int idx, u8 *dst, u8 *next_hop,
-				 struct mpath_info *pinfo)
+				int idx, struct net_device **pathdev,
+				u8 *dst, u8 *next_hop,
+				struct mpath_info *pinfo, bool mbss)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
@@ -1690,13 +1691,14 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	rcu_read_lock();
-	mpath = mesh_path_lookup_by_idx(sdata, idx);
+	mpath = mesh_path_lookup_by_idx(sdata, idx, mbss);
 	if (!mpath) {
 		rcu_read_unlock();
 		return -ENOENT;
 	}
 	memcpy(dst, mpath->dst, ETH_ALEN);
 	mpath_set_pinfo(mpath, next_hop, pinfo);
+	*pathdev = mpath->sdata->wdev.netdev;
 	rcu_read_unlock();
 	return 0;
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index bf108ef..31b60f1 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -271,7 +271,8 @@ struct mesh_path *mpp_path_lookup(struct mesh_local_bss *mbss,
 int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		 const u8 *dst, const u8 *mpp);
 struct mesh_path *
-mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
+mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata,
+			int idx, bool mbss);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7df8f27..01b5738 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -400,13 +400,15 @@ mpp_path_lookup(struct mesh_local_bss *mbss, const u8 *dst)
  * mesh_path_lookup_by_idx - look up a path in the mesh path table by its index
  * @idx: index
  * @sdata: local subif, or NULL for all entries
+ * @mbss: match @idx against all mpaths in sdata's MBSS
  *
  * Returns: pointer to the mesh path structure, or NULL if not found.
  *
  * Locking: must be called within a read rcu section.
  */
 struct mesh_path *
-mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
+mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata,
+			int idx, bool mbss)
 {
 	struct mesh_table *tbl = rcu_dereference(mesh_paths);
 	struct mpath_node *node;
@@ -414,7 +416,9 @@ mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
 	int j = 0;
 
 	for_each_mesh_entry(tbl, node, i) {
-		if (sdata && node->mpath->sdata != sdata)
+		if (mbss && mbss(sdata) != mbss(node->mpath->sdata))
+			continue;
+		if (!mbss && sdata && sdata != node->mpath->sdata)
 			continue;
 		if (j++ == idx) {
 			if (mpath_expired(node->mpath)) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5925b13..f95dfff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -270,6 +270,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+	[NL80211_ATTR_MPATH_DUMP_MBSS] = { .type = NLA_FLAG },
 
 	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },
@@ -4222,9 +4223,12 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 	struct mpath_info pinfo;
 	struct cfg80211_registered_device *dev;
 	struct wireless_dev *wdev;
+	struct net_device *pathdev;
 	u8 dst[ETH_ALEN];
 	u8 next_hop[ETH_ALEN];
 	int path_idx = cb->args[2];
+	struct nlattr **tb = nl80211_fam.attrbuf;
+	bool mbss = false;
 	int err;
 
 	err = nl80211_prepare_wdev_dump(skb, cb, &dev, &wdev);
@@ -4241,9 +4245,17 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 		goto out_err;
 	}
 
+	err = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+			  tb, nl80211_fam.maxattr, nl80211_policy);
+	if (err)
+		return err;
+
+	mbss = nla_get_flag(tb[NL80211_ATTR_MPATH_DUMP_MBSS]);
+
 	while (1) {
-		err = rdev_dump_mpath(dev, wdev->netdev, path_idx, dst,
-				      next_hop, &pinfo);
+		err = rdev_dump_mpath(dev, wdev->netdev, path_idx,
+				      &pathdev, dst, next_hop,
+				      &pinfo, mbss);
 		if (err == -ENOENT)
 			break;
 		if (err)
@@ -4251,7 +4263,7 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 
 		if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).portid,
 				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				       wdev->netdev, dst, next_hop,
+				       pathdev, dst, next_hop,
 				       &pinfo) < 0)
 			goto out;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 9f15f0a..a543601 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -264,14 +264,16 @@ static inline int rdev_get_mpath(struct cfg80211_registered_device *rdev,
 }
 
 static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
-				  struct net_device *dev, int idx, u8 *dst,
-				  u8 *next_hop, struct mpath_info *pinfo)
+				  struct net_device *dev, int idx,
+				  struct net_device **pathdev,
+				  u8 *dst, u8 *next_hop,
+				  struct mpath_info *pinfo, bool mbss)
 
 {
 	int ret;
 	trace_rdev_dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop);
-	ret = rdev->ops->dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop,
-				     pinfo);
+	ret = rdev->ops->dump_mpath(&rdev->wiphy, dev, idx, pathdev,
+				    dst, next_hop, pinfo, mbss);
 	trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
 	return ret;
 }
-- 
1.7.10.4

