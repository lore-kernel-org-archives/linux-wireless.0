Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:52790 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2KAB6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 21:58:01 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so918645dak.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 18:58:00 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH v2] [nl,cfg,mac]80211: Add nl80211 command to get mesh network statistics
Date: Wed, 31 Oct 2012 18:57:53 -0700
Message-Id: <1351735073-12011-1-git-send-email-ashok@cozybit.com> (sfid-20121101_025817_982706_2613EDD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The command NL80211_CMD_GET_MESH_STATS gets the statistical information about
the mesh network. Currently, the following statistics are provided:

1. Mesh forwarded multicast frames
2. Mesh forwarded unicast frames
3. Mesh total forwarded frames
4. Dropped frames due to mesh_ttl == 0
5. Dropped frames due to no route found
6. Dropped frames due to congestion

The attibute NL80211_ATTR_MESH_STATS enumerates the various mesh statistical
parameters. A new call back get_mesh_stats() is added. mesh_stats struct is
moved from mac80211/ieee80211_i.h to net/cfg80211.h.

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
v2: 
	struct mesh_stats gets cfg80211_ prefix (Johannes)
	mesh_stats members' types change from u32 to u64 (Johannes)
	Fix a typo in commit message

 include/net/cfg80211.h        |   26 +++++++++++++++
 include/uapi/linux/nl80211.h  |   43 +++++++++++++++++++++++++
 net/mac80211/cfg.c            |   12 +++++++
 net/mac80211/debugfs_netdev.c |   21 +++++++++---
 net/mac80211/ieee80211_i.h    |   11 +------
 net/wireless/nl80211.c        |   71 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 168 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c696457..c0a4c05 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -817,6 +817,27 @@ struct bss_parameters {
 };
 
 /**
+ * struct cfg80211_mesh_stats - 802.11s mesh statistics
+ *
+ * Used to provide statistical information about mesh
+ *
+ * @fwded_mcast: Mesh forwarded multicast frames
+ * @fwded_unicast: Mesh forwarded unicast frames
+ * @fwded_frames: Mesh total forwarded frames
+ * @dropped_frames_ttl: Not transmitted since mesh_ttl == 0
+ * @dropped_frames_no_route: Not transmitted, no route found
+ * @dropped_frames_congestion: Not forwarded due to congestion
+ */
+struct cfg80211_mesh_stats {
+	u64 fwded_mcast;
+	u64 fwded_unicast;
+	u64 fwded_frames;
+	u64 dropped_frames_ttl;
+	u64 dropped_frames_no_route;
+	u64 dropped_frames_congestion;
+};
+
+/**
  * struct mesh_config - 802.11s mesh configuration
  *
  * These parameters can be changed while the mesh is active.
@@ -1507,6 +1528,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @get_mesh_config: Get the current mesh configuration
  *
+ * @get_mesh_stats: Get the current mesh statistics
+ *
  * @update_mesh_config: Update mesh parameters on a running mesh.
  *	The mask is a bitfield which tells us which parameters to
  *	set, and which to leave alone.
@@ -1703,6 +1726,9 @@ struct cfg80211_ops {
 	int	(*get_mesh_config)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf);
+	int	(*get_mesh_stats)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_mesh_stats *stats);
 	int	(*update_mesh_config)(struct wiphy *wiphy,
 				      struct net_device *dev, u32 mask,
 				      const struct mesh_config *nconf);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 617d0fb..2c440cf 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -578,6 +578,9 @@
  *	station, due to particular reason. %NL80211_ATTR_CONN_FAILED_REASON
  *	is used for this.
  *
+ * @NL80211_CMD_GET_MESH_STATS: Get mesh networking statistics for the
+ *	interface identified by %NL80211_ATTR_IFINDEX
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -726,6 +729,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONN_FAILED,
 
+	NL80211_CMD_GET_MESH_STATS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1281,6 +1286,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
  *
+ * @NL80211_CMD_GET_MESH_STATS: Get mesh networking statistics for the
+ *	interface identified by %NL80211_ATTR_IFINDEX
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1544,6 +1552,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCAN_FLAGS,
 
+	NL80211_ATTR_MESH_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2203,6 +2213,39 @@ enum nl80211_mntr_flags {
 };
 
 /**
+ * enum nl80211_mesh_stats - mesh statisitics
+ *
+ * Provide statistical information about mesh.
+ *
+ * @__NL80211_MESH_STATS_INVALID: internal use
+ * @NL80211_MESH_STATS_FWDED_MCAST: specifies the number of mesh forwarded
+ *	multicast frames
+ * @NL80211_MESH_STATS_FWDED_UNICAST: specifies the number of mesh forwarded
+ *	unicast frames
+ * @NL80211_MESH_STATS_FWDED_FRAMES: specifies the total number of mesh
+ *	forwarded frames
+ * @NL80211_MESH_STATS_DROPPED_FRAMES_TTL: specifies the number of mesh frames
+ *	dropped since mesh_ttl == 0
+ * @NL80211_MESH_STATS_DROPPED_FRAMES_NO_ROUTE: specifies the number of mesh
+ *	frames dropped due to no route found
+ * @NL80211_MESH_STATS_DROPPED_FRAMES_CONGESTION: specifies the number of mesh
+ *	frames dropped due to congestion
+ */
+enum nl80211_mesh_stats {
+	__NL80211_MESH_STATS_INVALID,
+	NL80211_MESH_STATS_FWDED_MCAST,
+	NL80211_MESH_STATS_FWDED_UNICAST,
+	NL80211_MESH_STATS_FWDED_FRAMES,
+	NL80211_MESH_STATS_DROPPED_FRAMES_TTL,
+	NL80211_MESH_STATS_DROPPED_FRAMES_NO_ROUTE,
+	NL80211_MESH_STATS_DROPPED_FRAMES_CONGESTION,
+
+	/* keep last */
+	__NL80211_MESH_STATS_ATTR_AFTER_LAST,
+	NL80211_MESH_STATS_ATTR_MAX = __NL80211_MESH_STATS_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_meshconf_params - mesh configuration parameters
  *
  * Mesh configuration parameters. These can be changed while the mesh is
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5eab132..4628894 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1514,6 +1514,17 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_get_mesh_stats(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct cfg80211_mesh_stats *stats)
+{
+	struct ieee80211_sub_if_data *sdata;
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	memcpy(stats, &sdata->u.mesh.mshstats, sizeof(*stats));
+	return 0;
+}
+
 static int ieee80211_get_mesh_config(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf)
@@ -3112,6 +3123,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_mpath = ieee80211_get_mpath,
 	.dump_mpath = ieee80211_dump_mpath,
 	.update_mesh_config = ieee80211_update_mesh_config,
+	.get_mesh_stats = ieee80211_get_mesh_stats,
 	.get_mesh_config = ieee80211_get_mesh_config,
 	.join_mesh = ieee80211_join_mesh,
 	.leave_mesh = ieee80211_leave_mesh,
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 3393ad5..783ea9e 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -115,6 +115,15 @@ static ssize_t ieee80211_if_fmt_##name(					\
 	return scnprintf(buf, buflen, "%pM\n", sdata->field);		\
 }
 
+#define IEEE80211_IF_FMT_U64(name, field)				\
+static ssize_t ieee80211_if_fmt_##name(					\
+	const struct ieee80211_sub_if_data *sdata, char *buf,		\
+	int buflen)							\
+{									\
+	return scnprintf(buf, buflen, "%llu\n",				\
+			 (unsigned long long) sdata->field);		\
+}
+
 #define IEEE80211_IF_FMT_DEC_DIV_16(name, field)			\
 static ssize_t ieee80211_if_fmt_##name(					\
 	const struct ieee80211_sub_if_data *sdata,			\
@@ -463,14 +472,14 @@ IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
 
 #ifdef CONFIG_MAC80211_MESH
 /* Mesh stats attributes */
-IEEE80211_IF_FILE(fwded_mcast, u.mesh.mshstats.fwded_mcast, DEC);
-IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, DEC);
-IEEE80211_IF_FILE(fwded_frames, u.mesh.mshstats.fwded_frames, DEC);
-IEEE80211_IF_FILE(dropped_frames_ttl, u.mesh.mshstats.dropped_frames_ttl, DEC);
+IEEE80211_IF_FILE(fwded_mcast, u.mesh.mshstats.fwded_mcast, U64);
+IEEE80211_IF_FILE(fwded_unicast, u.mesh.mshstats.fwded_unicast, U64);
+IEEE80211_IF_FILE(fwded_frames, u.mesh.mshstats.fwded_frames, U64);
+IEEE80211_IF_FILE(dropped_frames_ttl, u.mesh.mshstats.dropped_frames_ttl, U64);
 IEEE80211_IF_FILE(dropped_frames_congestion,
-		  u.mesh.mshstats.dropped_frames_congestion, DEC);
+		  u.mesh.mshstats.dropped_frames_congestion, U64);
 IEEE80211_IF_FILE(dropped_frames_no_route,
-		  u.mesh.mshstats.dropped_frames_no_route, DEC);
+		  u.mesh.mshstats.dropped_frames_no_route, U64);
 IEEE80211_IF_FILE(estab_plinks, u.mesh.estab_plinks, ATOMIC);
 
 /* Mesh parameters */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3026519..96c0eaf 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -313,15 +313,6 @@ struct ieee80211_if_vlan {
 	struct sta_info __rcu *sta;
 };
 
-struct mesh_stats {
-	__u32 fwded_mcast;		/* Mesh forwarded multicast frames */
-	__u32 fwded_unicast;		/* Mesh forwarded unicast frames */
-	__u32 fwded_frames;		/* Mesh total forwarded frames */
-	__u32 dropped_frames_ttl;	/* Not transmitted since mesh_ttl == 0*/
-	__u32 dropped_frames_no_route;	/* Not transmitted, no route found */
-	__u32 dropped_frames_congestion;/* Not forwarded due to congestion */
-};
-
 #define PREQ_Q_F_START		0x1
 #define PREQ_Q_F_REFRESH	0x2
 struct mesh_preq_queue {
@@ -600,7 +591,7 @@ struct ieee80211_if_mesh {
 	spinlock_t mesh_preq_queue_lock;
 	struct mesh_preq_queue preq_queue;
 	int preq_queue_len;
-	struct mesh_stats mshstats;
+	struct cfg80211_mesh_stats mshstats;
 	struct mesh_config mshcfg;
 	atomic_t estab_plinks;
 	u32 mesh_seqnum;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8c08578..34d087d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -275,6 +275,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					   .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_BSS_HT_OPMODE] = { .type = NLA_U16 },
 
+	[NL80211_ATTR_MESH_STATS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
 	[NL80211_ATTR_SUPPORT_MESH_AUTH] = { .type = NLA_FLAG },
 
@@ -3680,6 +3681,68 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	return r;
 }
 
+static int nl80211_get_mesh_stats(struct sk_buff *skb,
+				  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_mesh_stats cur_stats;
+	int err = 0;
+	void *hdr;
+	struct nlattr *pinfoattr;
+	struct sk_buff *msg;
+
+	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->get_mesh_stats)
+		return -EOPNOTSUPP;
+
+	wdev_lock(wdev);
+
+	err = rdev->ops->get_mesh_stats(&rdev->wiphy, dev, &cur_stats);
+	wdev_unlock(wdev);
+
+	if (err)
+		return err;
+
+	/* Draw up a netlink message to send back */
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_GET_MESH_STATS);
+	if (!hdr)
+		goto out;
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_STATS);
+	if (!pinfoattr)
+		goto nla_put_failure;
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put_u32(msg, NL80211_MESH_STATS_FWDED_MCAST,
+			cur_stats.fwded_mcast) ||
+	    nla_put_u32(msg, NL80211_MESH_STATS_FWDED_UNICAST,
+			cur_stats.fwded_unicast) ||
+	    nla_put_u32(msg, NL80211_MESH_STATS_FWDED_FRAMES,
+			cur_stats.fwded_frames) ||
+	    nla_put_u32(msg, NL80211_MESH_STATS_DROPPED_FRAMES_TTL,
+			cur_stats.dropped_frames_ttl) ||
+	    nla_put_u32(msg, NL80211_MESH_STATS_DROPPED_FRAMES_NO_ROUTE,
+			cur_stats.dropped_frames_no_route) ||
+	    nla_put_u32(msg, NL80211_MESH_STATS_DROPPED_FRAMES_CONGESTION,
+			cur_stats.dropped_frames_congestion))
+		goto nla_put_failure;
+	nla_nest_end(msg, pinfoattr);
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+ out:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
 static int nl80211_get_mesh_config(struct sk_buff *skb,
 				   struct genl_info *info)
 {
@@ -7275,6 +7338,14 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
+		.cmd = NL80211_CMD_GET_MESH_STATS,
+		.doit = nl80211_get_mesh_stats,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_GET_MESH_CONFIG,
 		.doit = nl80211_get_mesh_config,
 		.policy = nl80211_policy,
-- 
1.7.5.4

