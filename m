Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:39351 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbaIELoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:44:10 -0400
Received: by mail-lb0-f169.google.com with SMTP id p9so2624674lbv.14
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2014 04:44:07 -0700 (PDT)
From: Henning Rogge <hrogge@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Subject: [PATCH v2 1/2] Add two new cfg80211 operations for querying the  content of the the mac80211s proxy path table
Date: Fri, 05 Sep 2014 13:44:05 +0200
Message-ID: <3091373.D4b2F0pKM5@rogge-hp-probook-6470b> (sfid-20140905_134414_478408_BBE6083E)
In-Reply-To: <2453987.UPN20YN3D3@rogge-hp-probook-6470b>
References: <2453987.UPN20YN3D3@rogge-hp-probook-6470b>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Henning Rogge" <henning.rogge <at> fkie.fraunhofer.de>

This patch adds the get_mpp and dump_mpp cfg80211_ops to allow
querying the mac80211s proxy path table via netlink.

---
 include/net/cfg80211.h       |  7 ++++
 include/uapi/linux/nl80211.h |  6 +++
 net/wireless/nl80211.c       | 99 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 27 +++++++++++-
 net/wireless/trace.h         | 45 ++++++++++++++++++++
 5 files changed, 183 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0a080c4..cda05f4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2139,6 +2139,8 @@ struct cfg80211_qos_map {
  * @change_mpath: change a given mesh path
  * @get_mpath: get a mesh path for the given parameters
  * @dump_mpath: dump mesh path callback -- resume dump at index @idx
+ * @get_mpp: get a mesh proxy path for the given parameters
+ * @dump_mpp: dump mesh proxy path callback -- resume dump at index @idx
  * @join_mesh: join the mesh network with the specified parameters
  *	(invoked with the wireless_dev mutex held)
  * @leave_mesh: leave the current mesh network
@@ -2378,6 +2380,11 @@ struct cfg80211_ops {
 	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
 			      int idx, u8 *dst, u8 *next_hop,
 			      struct mpath_info *pinfo);
+	int	(*get_mpp)(struct wiphy *wiphy, struct net_device *dev,
+			   u8 *dst, u8 *mpp, struct mpath_info *pinfo);
+	int	(*dump_mpp)(struct wiphy *wiphy, struct net_device *dev,
+			    int idx, u8 *dst, u8 *mpp,
+			    struct mpath_info *pinfo);
 	int	(*get_mesh_config)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f1db15b..80cff48 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -722,6 +722,10 @@
  *	QoS mapping is relevant for IP packets, it is only valid during an
  *	association. This is cleared on disassociation and AP restart.
  *
+ * @NL80211_CMD_GET_MPP: Get mesh path attributes for mesh proxy path to
+ *	destination %NL80211_ATTR_MAC on the interface identified by
+ *	%NL80211_ATTR_IFINDEX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -893,6 +897,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_QOS_MAP,
 
+	NL80211_CMD_GET_MPP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df7b133..1e33f2f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4581,6 +4581,96 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
 	return rdev_del_mpath(rdev, dev, dst);
 }
 
+static int nl80211_get_mpp(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	int err;
+	struct net_device *dev = info->user_ptr[1];
+	struct mpath_info pinfo;
+	struct sk_buff *msg;
+	u8 *dst = NULL;
+	u8 mpp[ETH_ALEN];
+
+	memset(&pinfo, 0, sizeof(pinfo));
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (!rdev->ops->get_mpp)
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	err = rdev_get_mpp(rdev, dev, dst, mpp, &pinfo);
+	if (err)
+		return err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	if (nl80211_send_mpath(msg, info->snd_portid, info->snd_seq, 0,
+			       dev, dst, mpp, &pinfo) < 0) {
+		nlmsg_free(msg);
+		return -ENOBUFS;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int nl80211_dump_mpp(struct sk_buff *skb,
+			    struct netlink_callback *cb)
+{
+	struct mpath_info pinfo;
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	u8 dst[ETH_ALEN];
+	u8 mpp[ETH_ALEN];
+	int path_idx = cb->args[2];
+	int err;
+
+	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
+	if (err)
+		return err;
+
+	if (!rdev->ops->dump_mpp) {
+		err = -EOPNOTSUPP;
+		goto out_err;
+	}
+
+	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT) {
+		err = -EOPNOTSUPP;
+		goto out_err;
+	}
+
+	while (1) {
+		err = rdev_dump_mpp(rdev, wdev->netdev, path_idx, dst,
+				    mpp, &pinfo);
+		if (err == -ENOENT)
+			break;
+		if (err)
+			goto out_err;
+
+		if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).portid,
+				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				       wdev->netdev, dst, mpp,
+				       &pinfo) < 0)
+			goto out;
+
+		path_idx++;
+	}
+
+ out:
+	cb->args[2] = path_idx;
+	err = skb->len;
+ out_err:
+	nl80211_finish_wdev_dump(rdev);
+	return err;
+}
+
 static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -9603,6 +9693,15 @@ static const struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_GET_MPP,
+		.doit = nl80211_get_mpp,
+		.dumpit = nl80211_dump_mpp,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_SET_MPATH,
 		.doit = nl80211_set_mpath,
 		.policy = nl80211_policy,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 56c2240..e5560d5 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -263,6 +263,18 @@ static inline int rdev_get_mpath(struct cfg80211_registered_device *rdev,
 
 }
 
+static inline int rdev_get_mpp(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev, u8 *dst, u8 *mpp,
+			       struct mpath_info *pinfo)
+{
+	int ret;
+
+	trace_rdev_get_mpp(&rdev->wiphy, dev, dst, mpp);
+	ret = rdev->ops->get_mpp(&rdev->wiphy, dev, dst, mpp, pinfo);
+	trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
+	return ret;
+}
+
 static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev, int idx, u8 *dst,
 				  u8 *next_hop, struct mpath_info *pinfo)
@@ -271,7 +283,20 @@ static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
 	int ret;
 	trace_rdev_dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop);
 	ret = rdev->ops->dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop,
-				     pinfo);
+				    pinfo);
+	trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
+	return ret;
+}
+
+static inline int rdev_dump_mpp(struct cfg80211_registered_device *rdev,
+				struct net_device *dev, int idx, u8 *dst,
+				u8 *mpp, struct mpath_info *pinfo)
+
+{
+	int ret;
+
+	trace_rdev_dump_mpp(&rdev->wiphy, dev, idx, dst, mpp);
+	ret = rdev->ops->dump_mpp(&rdev->wiphy, dev, idx, dst, mpp, pinfo);
 	trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0c524cd..57ab727 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -801,6 +801,51 @@ TRACE_EVENT(rdev_dump_mpath,
 		  MAC_PR_ARG(next_hop))
 );
 
+TRACE_EVENT(rdev_get_mpp,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u8 *dst, u8 *mpp),
+	TP_ARGS(wiphy, netdev, dst, mpp),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(dst)
+		MAC_ENTRY(mpp)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(dst, dst);
+		MAC_ASSIGN(mpp, mpp);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", destination: " MAC_PR_FMT
+		  ", mpp: " MAC_PR_FMT, WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  MAC_PR_ARG(dst), MAC_PR_ARG(mpp))
+);
+
+TRACE_EVENT(rdev_dump_mpp,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int idx,
+		 u8 *dst, u8 *mpp),
+	TP_ARGS(wiphy, netdev, idx, mpp, dst),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(dst)
+		MAC_ENTRY(mpp)
+		__field(int, idx)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(dst, dst);
+		MAC_ASSIGN(mpp, mpp);
+		__entry->idx = idx;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", index: %d, destination: "
+		  MAC_PR_FMT ", mpp: " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->idx, MAC_PR_ARG(dst),
+		  MAC_PR_ARG(mpp))
+);
+
 TRACE_EVENT(rdev_return_int_mpath_info,
 	TP_PROTO(struct wiphy *wiphy, int ret, struct mpath_info *pinfo),
 	TP_ARGS(wiphy, ret, pinfo),
-- 
1.9.1


