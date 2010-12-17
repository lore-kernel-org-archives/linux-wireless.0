Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62048 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0LQBiB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 20:38:01 -0500
Received: by gyb11 with SMTP id 11so83598gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 17:38:01 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/3 v3] mac80211: Rename mesh_params to mesh_config to prepare for mesh_setup
Date: Thu, 16 Dec 2010 17:37:48 -0800
Message-Id: <1292549870-1743-1-git-send-email-javier@cozybit.com>
In-Reply-To: <1292525513.3612.26.camel@jlt3.sipsolutions.net>
References: <1292525513.3612.26.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh parameters can be to setup a mesh or to configure it.
This patch renames the ambiguous name mesh_params to mesh_config
in preparation for mesh_setup.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
v2: - separate mesh config and setup parametres and split the original patch
v3: - add #defines for source-level API compatibility

 include/linux/nl80211.h |   15 ++++++++++-----
 include/net/cfg80211.h  |    8 ++++----
 net/mac80211/cfg.c      |    8 ++++----
 net/wireless/nl80211.c  |   40 ++++++++++++++++++++--------------------
 4 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 1cee56b..d626ad2 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -172,10 +172,10 @@
  * 	to the specified ISO/IEC 3166-1 alpha2 country code. The core will
  * 	store this as a valid request and then query userspace for it.
  *
- * @NL80211_CMD_GET_MESH_PARAMS: Get mesh networking properties for the
+ * @NL80211_CMD_GET_MESH_CONFIG: Get mesh networking properties for the
  *	interface identified by %NL80211_ATTR_IFINDEX
  *
- * @NL80211_CMD_SET_MESH_PARAMS: Set mesh networking properties for the
+ * @NL80211_CMD_SET_MESH_CONFIG: Set mesh networking properties for the
  *      interface identified by %NL80211_ATTR_IFINDEX
  *
  * @NL80211_CMD_SET_MGMT_EXTRA_IE: Set extra IEs for management frames. The
@@ -441,8 +441,8 @@ enum nl80211_commands {
 	NL80211_CMD_SET_REG,
 	NL80211_CMD_REQ_SET_REG,
 
-	NL80211_CMD_GET_MESH_PARAMS,
-	NL80211_CMD_SET_MESH_PARAMS,
+	NL80211_CMD_GET_MESH_CONFIG,
+	NL80211_CMD_SET_MESH_CONFIG,
 
 	NL80211_CMD_SET_MGMT_EXTRA_IE /* reserved; not used */,
 
@@ -528,6 +528,10 @@ enum nl80211_commands {
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
 
+/* source-level API compatibility */
+#define NL80211_CMD_GET_MESH_PARAMS NL80211_CMD_GET_MESH_CONFIG
+#define NL80211_CMD_SET_MESH_PARAMS NL80211_CMD_SET_MESH_CONFIG
+
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
  *
@@ -912,7 +916,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_ALPHA2,
 	NL80211_ATTR_REG_RULES,
 
-	NL80211_ATTR_MESH_PARAMS,
+	NL80211_ATTR_MESH_CONFIG,
 
 	NL80211_ATTR_BSS_BASIC_RATES,
 
@@ -1048,6 +1052,7 @@ enum nl80211_attrs {
 
 /* source-level API compatibility */
 #define NL80211_ATTR_SCAN_GENERATION NL80211_ATTR_GENERATION
+#define	NL80211_ATTR_MESH_PARAMS NL80211_ATTR_MESH_CONFIG
 
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f45e15f..1bac74a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1096,9 +1096,9 @@ struct cfg80211_pmksa {
  * @get_mpath: get a mesh path for the given parameters
  * @dump_mpath: dump mesh path callback -- resume dump at index @idx
  *
- * @get_mesh_params: Put the current mesh parameters into *params
+ * @get_mesh_config: Get the current mesh configuration
  *
- * @update_mesh_params: Update mesh parameters on a running mesh.
+ * @update_mesh_config: Update mesh parameters on a running mesh.
  *	The mask is a bitfield which tells us which parameters to
  *	set, and which to leave alone.
  *
@@ -1246,10 +1246,10 @@ struct cfg80211_ops {
 	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
 			       int idx, u8 *dst, u8 *next_hop,
 			       struct mpath_info *pinfo);
-	int	(*get_mesh_params)(struct wiphy *wiphy,
+	int	(*get_mesh_config)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf);
-	int	(*update_mesh_params)(struct wiphy *wiphy,
+	int	(*update_mesh_config)(struct wiphy *wiphy,
 				      struct net_device *dev, u32 mask,
 				      const struct mesh_config *nconf);
 	int	(*join_mesh)(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ea06f92..1c94a2a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -984,7 +984,7 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static int ieee80211_get_mesh_params(struct wiphy *wiphy,
+static int ieee80211_get_mesh_config(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf)
 {
@@ -1000,7 +1000,7 @@ static inline bool _chg_mesh_attr(enum nl80211_meshconf_params parm, u32 mask)
 	return (mask >> (parm-1)) & 0x1;
 }
 
-static int ieee80211_update_mesh_params(struct wiphy *wiphy,
+static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 					struct net_device *dev, u32 mask,
 					const struct mesh_config *nconf)
 {
@@ -1787,8 +1787,8 @@ struct cfg80211_ops mac80211_config_ops = {
 	.change_mpath = ieee80211_change_mpath,
 	.get_mpath = ieee80211_get_mpath,
 	.dump_mpath = ieee80211_dump_mpath,
-	.update_mesh_params = ieee80211_update_mesh_params,
-	.get_mesh_params = ieee80211_get_mesh_params,
+	.update_mesh_config = ieee80211_update_mesh_config,
+	.get_mesh_config = ieee80211_get_mesh_config,
 	.join_mesh = ieee80211_join_mesh,
 	.leave_mesh = ieee80211_leave_mesh,
 #endif
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 594a6ac..d783dca 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -123,7 +123,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					   .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_BSS_HT_OPMODE] = { .type = NLA_U16 },
 
-	[NL80211_ATTR_MESH_PARAMS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
 
 	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HT_CAPABILITY_LEN },
@@ -719,7 +719,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	CMD(add_beacon, NEW_BEACON);
 	CMD(add_station, NEW_STATION);
 	CMD(add_mpath, NEW_MPATH);
-	CMD(update_mesh_params, SET_MESH_PARAMS);
+	CMD(update_mesh_config, SET_MESH_CONFIG);
 	CMD(change_bss, SET_BSS);
 	CMD(auth, AUTHENTICATE);
 	CMD(assoc, ASSOCIATE);
@@ -2673,7 +2673,7 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	return r;
 }
 
-static int nl80211_get_mesh_params(struct sk_buff *skb,
+static int nl80211_get_mesh_config(struct sk_buff *skb,
 				   struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -2688,7 +2688,7 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
-	if (!rdev->ops->get_mesh_params)
+	if (!rdev->ops->get_mesh_config)
 		return -EOPNOTSUPP;
 
 	wdev_lock(wdev);
@@ -2696,7 +2696,7 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 	if (!wdev->mesh_id_len)
 		memcpy(&cur_params, &default_mesh_config, sizeof(cur_params));
 	else
-		err = rdev->ops->get_mesh_params(&rdev->wiphy, dev,
+		err = rdev->ops->get_mesh_config(&rdev->wiphy, dev,
 						 &cur_params);
 	wdev_unlock(wdev);
 
@@ -2708,10 +2708,10 @@ static int nl80211_get_mesh_params(struct sk_buff *skb,
 	if (!msg)
 		return -ENOMEM;
 	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_GET_MESH_PARAMS);
+			     NL80211_CMD_GET_MESH_CONFIG);
 	if (!hdr)
 		goto nla_put_failure;
-	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_PARAMS);
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_CONFIG);
 	if (!pinfoattr)
 		goto nla_put_failure;
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
@@ -2773,7 +2773,7 @@ static const struct nla_policy nl80211_meshconf_params_policy[NL80211_MESHCONF_A
 	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
 };
 
-static int nl80211_parse_mesh_params(struct genl_info *info,
+static int nl80211_parse_mesh_config(struct genl_info *info,
 				     struct mesh_config *cfg,
 				     u32 *mask_out)
 {
@@ -2789,10 +2789,10 @@ do {\
 } while (0);\
 
 
-	if (!info->attrs[NL80211_ATTR_MESH_PARAMS])
+	if (!info->attrs[NL80211_ATTR_MESH_CONFIG])
 		return -EINVAL;
 	if (nla_parse_nested(tb, NL80211_MESHCONF_ATTR_MAX,
-			     info->attrs[NL80211_ATTR_MESH_PARAMS],
+			     info->attrs[NL80211_ATTR_MESH_CONFIG],
 			     nl80211_meshconf_params_policy))
 		return -EINVAL;
 
@@ -2847,7 +2847,7 @@ do {\
 #undef FILL_IN_MESH_PARAM_IF_SET
 }
 
-static int nl80211_update_mesh_params(struct sk_buff *skb,
+static int nl80211_update_mesh_config(struct sk_buff *skb,
 				      struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -2860,10 +2860,10 @@ static int nl80211_update_mesh_params(struct sk_buff *skb,
 	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
-	if (!rdev->ops->update_mesh_params)
+	if (!rdev->ops->update_mesh_config)
 		return -EOPNOTSUPP;
 
-	err = nl80211_parse_mesh_params(info, &cfg, &mask);
+	err = nl80211_parse_mesh_config(info, &cfg, &mask);
 	if (err)
 		return err;
 
@@ -2872,7 +2872,7 @@ static int nl80211_update_mesh_params(struct sk_buff *skb,
 		err = -ENOLINK;
 
 	if (!err)
-		err = rdev->ops->update_mesh_params(&rdev->wiphy, dev,
+		err = rdev->ops->update_mesh_config(&rdev->wiphy, dev,
 						    mask, &cfg);
 
 	wdev_unlock(wdev);
@@ -4672,9 +4672,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 	/* start with default */
 	memcpy(&cfg, &default_mesh_config, sizeof(cfg));
 
-	if (info->attrs[NL80211_ATTR_MESH_PARAMS]) {
+	if (info->attrs[NL80211_ATTR_MESH_CONFIG]) {
 		/* and parse parameters if given */
-		err = nl80211_parse_mesh_params(info, &cfg, NULL);
+		err = nl80211_parse_mesh_config(info, &cfg, NULL);
 		if (err)
 			return err;
 	}
@@ -4952,16 +4952,16 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = NL80211_CMD_GET_MESH_PARAMS,
-		.doit = nl80211_get_mesh_params,
+		.cmd = NL80211_CMD_GET_MESH_CONFIG,
+		.doit = nl80211_get_mesh_config,
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
-		.cmd = NL80211_CMD_SET_MESH_PARAMS,
-		.doit = nl80211_update_mesh_params,
+		.cmd = NL80211_CMD_SET_MESH_CONFIG,
+		.doit = nl80211_update_mesh_config,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-- 
1.7.1

