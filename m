Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.228]:19631 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYJTRpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 13:45:41 -0400
Received: by wx-out-0506.google.com with SMTP id h27so874853wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 10:45:40 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Date: Mon, 20 Oct 2008 10:40:01 -0700
Subject: [PATCH v2] Add nl80211 commands to get and set o11s mesh networking parameters
From: colin@cozybit.com
Message-ID: <48fcc3c2.38652c0a.297d.533e@mx.google.com> (sfid-20081020_194546_775680_98F2849E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two new commands are NL80211_CMD_GET_MESH_PARAMS and
NL80211_CMD_SET_MESH_PARAMS. There is a new attribute enum,
NL80211_ATTR_MESH_PARAMS, which enumerates the various mesh configuration
parameters.

Moved struct mesh_config from mac80211/ieee80211_i.h to net/cfg80211.h.
nl80211_get_mesh_params and nl80211_set_mesh_params unpack the netlink messages
and ask the driver to get or set the configuration.  This is done via two new
function stubs, get_mesh_params and set_mesh_params, in struct cfg80211_ops.
---
 include/linux/nl80211.h    |   86 ++++++++++++++++++++
 include/net/cfg80211.h     |   32 +++++++-
 net/mac80211/cfg.c         |   68 ++++++++++++++++
 net/mac80211/ieee80211_i.h |   21 +-----
 net/wireless/nl80211.c     |  193 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 379 insertions(+), 21 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 9bad654..40d7b27 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -106,6 +106,12 @@
  * 	to the the specified ISO/IEC 3166-1 alpha2 country code. The core will
  * 	store this as a valid request and then query userspace for it.
  *
+ * @NL80211_CMD_GET_MESH_PARAMS: Get mesh networking properties for the
+ *	interface identified by %NL80211_ATTR_IFINDEX
+ *
+ * @NL80211_CMD_SET_MESH_PARAMS: Set mesh networking properties for the
+ *      interface identified by %NL80211_ATTR_IFINDEX
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -148,6 +154,9 @@ enum nl80211_commands {
 	NL80211_CMD_SET_REG,
 	NL80211_CMD_REQ_SET_REG,
 
+	NL80211_CMD_GET_MESH_PARAMS,
+	NL80211_CMD_SET_MESH_PARAMS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -296,6 +305,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_REG_ALPHA2,
 	NL80211_ATTR_REG_RULES,
 
+	NL80211_ATTR_MESH_PARAMS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -594,4 +605,79 @@ enum nl80211_mntr_flags {
 	NL80211_MNTR_FLAG_MAX = __NL80211_MNTR_FLAG_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_meshconf_params - mesh configuration parameters
+ *
+ * Mesh configuration parameters
+ *
+ * @__NL80211_MESHCONF_INVALID: internal use
+ *
+ * @NL80211_MESHCONF_RETRY_TIMEOUT: specifies the initial retry timeout in
+ * millisecond units, used by the Peer Link Open message
+ *
+ * @NL80211_MESHCONF_CONFIRM_TIMEOUT: specifies the inital confirm timeout, in
+ * millisecond units, used by the peer link management to close a peer link
+ *
+ * @NL80211_MESHCONF_HOLDING_TIMEOUT: specifies the holding timeout, in
+ * millisecond units
+ *
+ * @NL80211_MESHCONF_MAX_PEER_LINKS: maximum number of peer links allowed
+ * on this mesh interface
+ *
+ * @NL80211_MESHCONF_MAX_RETRIES: specifies the maximum number of peer link
+ * open retries that can be sent to establish a new peer link instance in a
+ * mesh
+ *
+ * @NL80211_MESHCONF_TTL: specifies the value of TTL field set at a source mesh
+ * point.
+ *
+ * @NL80211_MESHCONF_AUTO_OPEN_PLINKS: whether we should automatically
+ * open peer links when we detect compatible mesh peers.
+ *
+ * @NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES: the number of action frames
+ * containing a PREQ that an MP can send to a particular destination (path
+ * target)
+ *
+ * @NL80211_MESHCONF_PATH_REFRESH_TIME: how frequently to refresh mesh paths
+ * (in milliseconds)
+ *
+ * @NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT: minimum length of time to wait
+ * until giving up on a path discovery (in milliseconds)
+ *
+ * @NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT: The time (in TUs) for which mesh
+ * points receiving a PREQ shall consider the forwarding information from the
+ * root to be valid. (TU = time unit)
+ *
+ * @NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL: The minimum interval of time (in
+ * TUs) during which an MP can send only one action frame containing a PREQ
+ * reference element
+ *
+ * @NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME: The interval of time (in TUs)
+ * that it takes for an HWMP information element to propagate across the mesh
+ *
+ * @NL80211_MESHCONF_ATTR_MAX: highest possible mesh configuration attribute
+ *
+ * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_meshconf_params {
+	__NL80211_MESHCONF_INVALID,
+	NL80211_MESHCONF_RETRY_TIMEOUT,
+	NL80211_MESHCONF_CONFIRM_TIMEOUT,
+	NL80211_MESHCONF_HOLDING_TIMEOUT,
+	NL80211_MESHCONF_MAX_PEER_LINKS,
+	NL80211_MESHCONF_MAX_RETRIES,
+	NL80211_MESHCONF_TTL,
+	NL80211_MESHCONF_AUTO_OPEN_PLINKS,
+	NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
+	NL80211_MESHCONF_PATH_REFRESH_TIME,
+	NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
+	NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
+	NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
+	NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+
+	/* keep last */
+	__NL80211_MESHCONF_ATTR_AFTER_LAST,
+	NL80211_MESHCONF_ATTR_MAX = __NL80211_MESHCONF_ATTR_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0e85ec3..03e1e88 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -347,6 +347,25 @@ struct ieee80211_regdomain {
 	.flags = reg_flags, \
 	}
 
+struct mesh_config {
+	/* Timeouts in ms */
+	/* Mesh plink management parameters */
+	u16 dot11MeshRetryTimeout;
+	u16 dot11MeshConfirmTimeout;
+	u16 dot11MeshHoldingTimeout;
+	u16 dot11MeshMaxPeerLinks;
+	u8  dot11MeshMaxRetries;
+	u8  dot11MeshTTL;
+	bool auto_open_plinks;
+	/* HWMP parameters */
+	u8  dot11MeshHWMPmaxPREQretries;
+	u32 path_refresh_time;
+	u16 min_discovery_timeout;
+	u32 dot11MeshHWMPactivePathTimeout;
+	u16 dot11MeshHWMPpreqMinInterval;
+	u16 dot11MeshHWMPnetDiameterTraversalTime;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -397,6 +416,12 @@ struct wiphy;
  *
  * @change_station: Modify a given station.
  *
+ * @get_mesh_params: Put the current mesh parameters into *params
+ *
+ * @set_mesh_params: Set mesh parameters.
+ *	The mask is a bitfield which tells us which parameters to
+ *	set, and which to leave alone.
+ *
  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
  *
  * @change_bss: Modify parameters for a given BSS.
@@ -452,7 +477,12 @@ struct cfg80211_ops {
 	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
 			       int idx, u8 *dst, u8 *next_hop,
 			       struct mpath_info *pinfo);
-
+	int	(*get_mesh_params)(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct mesh_config *conf);
+	int	(*set_mesh_params)(struct wiphy *wiphy,
+				struct net_device *dev,
+				const struct mesh_config *nconf, u32 mask);
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8ea3090..f681608 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -949,6 +949,72 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
 	rcu_read_unlock();
 	return 0;
 }
+
+static int ieee80211_get_mesh_params(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct mesh_config *conf)
+{
+	struct ieee80211_sub_if_data *sdata;
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+		return -ENOTSUPP;
+	memcpy(conf, &(sdata->u.mesh.mshcfg), sizeof(struct mesh_config));
+	return 0;
+}
+
+static inline bool _chg_mesh_attr(enum nl80211_meshconf_params parm, u32 mask)
+{
+	return (mask >> (parm-1)) & 0x1;
+}
+
+static int ieee80211_set_mesh_params(struct wiphy *wiphy,
+				struct net_device *dev,
+				const struct mesh_config *nconf, u32 mask)
+{
+	struct mesh_config *conf;
+	struct ieee80211_sub_if_data *sdata;
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+		return -ENOTSUPP;
+
+	/* Set the config options which we are interested in setting */
+	conf = &(sdata->u.mesh.mshcfg);
+	if (_chg_mesh_attr(NL80211_MESHCONF_RETRY_TIMEOUT, mask))
+		conf->dot11MeshRetryTimeout = nconf->dot11MeshRetryTimeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_CONFIRM_TIMEOUT, mask))
+		conf->dot11MeshConfirmTimeout = nconf->dot11MeshConfirmTimeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HOLDING_TIMEOUT, mask))
+		conf->dot11MeshHoldingTimeout = nconf->dot11MeshHoldingTimeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_MAX_PEER_LINKS, mask))
+		conf->dot11MeshMaxPeerLinks = nconf->dot11MeshMaxPeerLinks;
+	if (_chg_mesh_attr(NL80211_MESHCONF_MAX_RETRIES, mask))
+		conf->dot11MeshMaxRetries = nconf->dot11MeshMaxRetries;
+	if (_chg_mesh_attr(NL80211_MESHCONF_TTL, mask))
+		conf->dot11MeshTTL = nconf->dot11MeshTTL;
+	if (_chg_mesh_attr(NL80211_MESHCONF_AUTO_OPEN_PLINKS, mask))
+		conf->auto_open_plinks = nconf->auto_open_plinks;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES, mask))
+		conf->dot11MeshHWMPmaxPREQretries =
+			nconf->dot11MeshHWMPmaxPREQretries;
+	if (_chg_mesh_attr(NL80211_MESHCONF_PATH_REFRESH_TIME, mask))
+		conf->path_refresh_time = nconf->path_refresh_time;
+	if (_chg_mesh_attr(NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT, mask))
+		conf->min_discovery_timeout = nconf->min_discovery_timeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT, mask))
+		conf->dot11MeshHWMPactivePathTimeout =
+			nconf->dot11MeshHWMPactivePathTimeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL, mask))
+		conf->dot11MeshHWMPpreqMinInterval =
+			nconf->dot11MeshHWMPpreqMinInterval;
+	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+			   mask))
+		conf->dot11MeshHWMPnetDiameterTraversalTime =
+			nconf->dot11MeshHWMPnetDiameterTraversalTime;
+	return 0;
+}
+
 #endif
 
 static int ieee80211_change_bss(struct wiphy *wiphy,
@@ -1005,6 +1071,8 @@ struct cfg80211_ops mac80211_config_ops = {
 	.change_mpath = ieee80211_change_mpath,
 	.get_mpath = ieee80211_get_mpath,
 	.dump_mpath = ieee80211_dump_mpath,
+	.set_mesh_params = ieee80211_set_mesh_params,
+	.get_mesh_params = ieee80211_get_mesh_params,
 #endif
 	.change_bss = ieee80211_change_bss,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8198447..7a4a3c4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
+#include <net/cfg80211.h>
 #include <net/wireless.h>
 #include <net/iw_handler.h>
 #include <net/mac80211.h>
@@ -255,26 +256,6 @@ struct mesh_preq_queue {
 	u8 flags;
 };
 
-struct mesh_config {
-	/* Timeouts in ms */
-	/* Mesh plink management parameters */
-	u16 dot11MeshRetryTimeout;
-	u16 dot11MeshConfirmTimeout;
-	u16 dot11MeshHoldingTimeout;
-	u16 dot11MeshMaxPeerLinks;
-	u8  dot11MeshMaxRetries;
-	u8  dot11MeshTTL;
-	bool auto_open_plinks;
-	/* HWMP parameters */
-	u8  dot11MeshHWMPmaxPREQretries;
-	u32 path_refresh_time;
-	u16 min_discovery_timeout;
-	u32 dot11MeshHWMPactivePathTimeout;
-	u16 dot11MeshHWMPpreqMinInterval;
-	u16 dot11MeshHWMPnetDiameterTraversalTime;
-};
-
-
 /* flags used in struct ieee80211_if_sta.flags */
 #define IEEE80211_STA_SSID_SET		BIT(0)
 #define IEEE80211_STA_BSSID_SET		BIT(1)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 572793c..9d42330 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -96,6 +96,8 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_BSS_SHORT_PREAMBLE] = { .type = NLA_U8 },
 	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] = { .type = NLA_U8 },
 
+	[NL80211_ATTR_MESH_PARAMS] = { .type = NLA_NESTED },
+
 	[NL80211_ATTR_HT_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HT_CAPABILITY_LEN },
 };
@@ -1685,6 +1687,185 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 	return r;
 }
 
+static int nl80211_get_mesh_params(struct sk_buff *skb,
+	struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct mesh_config cur_params;
+	int err;
+	struct net_device *dev;
+	void *hdr;
+	struct nlattr *pinfoattr;
+	struct sk_buff *msg;
+
+	/* Look up our device */
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	/* Get the mesh params */
+	rtnl_lock();
+	err = drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
+	rtnl_unlock();
+	if (err)
+		goto out;
+
+	/* Draw up a netlink message to send back */
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOBUFS;
+		goto out;
+	}
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_MESH_PARAMS);
+	if (!hdr)
+		goto nla_put_failure;
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_PARAMS);
+	if (!pinfoattr)
+		goto nla_put_failure;
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_RETRY_TIMEOUT,
+			cur_params.dot11MeshRetryTimeout);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_CONFIRM_TIMEOUT,
+			cur_params.dot11MeshConfirmTimeout);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_HOLDING_TIMEOUT,
+			cur_params.dot11MeshHoldingTimeout);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_MAX_PEER_LINKS,
+			cur_params.dot11MeshMaxPeerLinks);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_MAX_RETRIES,
+			cur_params.dot11MeshMaxRetries);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_TTL,
+			cur_params.dot11MeshTTL);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_AUTO_OPEN_PLINKS,
+			cur_params.auto_open_plinks);
+	NLA_PUT_U8(msg, NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES,
+			cur_params.dot11MeshHWMPmaxPREQretries);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_PATH_REFRESH_TIME,
+			cur_params.path_refresh_time);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT,
+			cur_params.min_discovery_timeout);
+	NLA_PUT_U32(msg, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
+			cur_params.dot11MeshHWMPactivePathTimeout);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
+			cur_params.dot11MeshHWMPpreqMinInterval);
+	NLA_PUT_U16(msg, NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+			cur_params.dot11MeshHWMPnetDiameterTraversalTime);
+	nla_nest_end(msg, pinfoattr);
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	err = -EMSGSIZE;
+out:
+	/* Cleanup */
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+#define FILL_IN_MESH_PARAM_IF_SET(table, cfg, param, attr_num, nla_fn) \
+do {\
+	if (table[attr_num]) {\
+		cfg.param = nla_fn(table[attr_num]); \
+	} \
+} while (0);\
+
+static struct nla_policy
+nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] __read_mostly = {
+	[NL80211_MESHCONF_RETRY_TIMEOUT] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_CONFIRM_TIMEOUT] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HOLDING_TIMEOUT] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_MAX_PEER_LINKS] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_MAX_RETRIES] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_TTL] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_AUTO_OPEN_PLINKS] = { .type = NLA_U8 },
+
+	[NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES] = { .type = NLA_U8 },
+	[NL80211_MESHCONF_PATH_REFRESH_TIME] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL] = { .type = NLA_U16 },
+	[NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME] = { .type = NLA_U16 },
+};
+
+static int nl80211_set_mesh_params(struct sk_buff *skb, struct genl_info *info)
+{
+	int err, i;
+	u32 mask;
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct mesh_config cfg;
+	struct nlattr *tb[NL80211_MESHCONF_ATTR_MAX + 1];
+	struct nlattr *parent_attr;
+
+	parent_attr = info->attrs[NL80211_ATTR_MESH_PARAMS];
+	if (!parent_attr)
+		return -EINVAL;
+	if (nla_parse_nested(tb, NL80211_MESHCONF_ATTR_MAX,
+			parent_attr, nl80211_meshconf_params_policy))
+		return -EINVAL;
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	/* This makes sure that there aren't more than 32 mesh config
+	 * parameters (otherwise our bitfield scheme would not work.) */
+	BUILD_BUG_ON(NL80211_MESHCONF_ATTR_MAX > 32);
+
+	/* Set the mask */
+	mask = 0;
+	for (i = 0; i < NL80211_MESHCONF_ATTR_MAX; ++i)
+		if (tb[i+1])
+			mask |= (1 << i);
+
+	/* Fill in the params struct */
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout,
+			NL80211_MESHCONF_RETRY_TIMEOUT, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConfirmTimeout,
+			NL80211_MESHCONF_CONFIRM_TIMEOUT, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHoldingTimeout,
+			NL80211_MESHCONF_HOLDING_TIMEOUT, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxPeerLinks,
+			NL80211_MESHCONF_MAX_PEER_LINKS, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshMaxRetries,
+			NL80211_MESHCONF_MAX_RETRIES, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshTTL,
+			NL80211_MESHCONF_TTL, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, auto_open_plinks,
+			NL80211_MESHCONF_AUTO_OPEN_PLINKS, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPmaxPREQretries,
+			NL80211_MESHCONF_HWMP_MAX_PREQ_RETRIES, nla_get_u8);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, path_refresh_time,
+			NL80211_MESHCONF_PATH_REFRESH_TIME, nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, min_discovery_timeout,
+			NL80211_MESHCONF_MIN_DISCOVERY_TIMEOUT, nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathTimeout,
+			NL80211_MESHCONF_HWMP_ACTIVE_PATH_TIMEOUT,
+			nla_get_u32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPpreqMinInterval,
+			NL80211_MESHCONF_HWMP_PREQ_MIN_INTERVAL,
+			nla_get_u16);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
+			dot11MeshHWMPnetDiameterTraversalTime,
+			NL80211_MESHCONF_HWMP_NET_DIAM_TRVS_TIME,
+			nla_get_u16);
+
+	/* Apply changes */
+	rtnl_lock();
+	err = drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
+	rtnl_unlock();
+
+	/* cleanup */
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+#undef FILL_IN_MESH_PARAM_IF_SET
+
 static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
@@ -1902,6 +2083,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_GET_MESH_PARAMS,
+		.doit = nl80211_get_mesh_params,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_SET_MESH_PARAMS,
+		.doit = nl80211_set_mesh_params,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
-- 
1.5.4.3



