Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:44294 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYBDVXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:23:44 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1548589rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:23:44 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 10:51:38 -0800
Subject: [PATCH 02/13] o11s: (nl80211/cfg80211) support for mesh interfaces and set_mesh_cfg command
Message-ID: <47a7825f.03b48c0a.7362.5cd9@mx.google.com> (sfid-20080204_212410_095702_D5CB4C0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This command allows setting the mesh ID for a (pre) 802.11s mesh interface. If
this command is not used, mesh interfaces will use the wildcard, zero-length
mesh ID.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/nl80211.h |    8 ++++++++
 include/net/cfg80211.h  |   13 +++++++++++++
 net/mac80211/cfg.c      |   28 ++++++++++++++++++++++++++++
 net/wireless/nl80211.c  |   43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 6369506..71c6125 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -48,6 +48,7 @@
  *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_WIPHY. Can also be sent from
  *	userspace to request deletion of a virtual interface, then requires
  *	attribute %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_SET_MESH_CFG: start mesh operation
  *
  * @NL80211_CMD_GET_KEY: Get sequence counter information for a key specified
  *	by %NL80211_ATTR_KEY_IDX and/or %NL80211_ATTR_MAC.
@@ -112,6 +113,8 @@ enum nl80211_commands {
 
 	/* add commands here */
 
+	NL80211_CMD_SET_MESH_CFG,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -163,6 +166,7 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_WIPHY_BANDS: Information about an operating bands,
  *	consisting of a nested array.
+ * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes)
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -202,6 +206,8 @@ enum nl80211_attrs {
 
 	/* add attributes here, update the policy in nl80211.c */
 
+	NL80211_ATTR_MESH_ID,
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
@@ -218,6 +224,7 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
+ * @NL80211_IFTYPE_MESH_POINT: mesh point
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @__NL80211_IFTYPE_AFTER_LAST: internal use
  *
@@ -233,6 +240,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_AP_VLAN,
 	NL80211_IFTYPE_WDS,
 	NL80211_IFTYPE_MONITOR,
+	NL80211_IFTYPE_MESH_POINT,
 
 	/* keep last */
 	__NL80211_IFTYPE_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bcc480b..b09e258 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -12,6 +12,16 @@
  * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
  */
 
+/*
+ * struct mesh_params - describes mesh parameters
+ * @mesh_id: mesh ID to use
+ * @mesh_id_len: length of the mesh ID
+ */
+struct mesh_params {
+       u8 *mesh_id;
+       int mesh_id_len;
+};
+
 /* Radiotap header iteration
  *   implemented in net/wireless/radiotap.c
  *   docs in Documentation/networking/radiotap-headers.txt
@@ -187,6 +197,7 @@ struct wiphy;
  *
  * @add_key: add a key with the given parameters. @mac_addr will be %NULL
  *	when adding a group key.
+ * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
  *
  * @get_key: get information about the key with the given parameters.
  *	@mac_addr will be %NULL when requesting information for a group
@@ -245,6 +256,8 @@ struct cfg80211_ops {
 				  u8 *mac, struct station_parameters *params);
 	int	(*get_station)(struct wiphy *wiphy, struct net_device *dev,
 			       u8 *mac, struct station_stats *stats);
+	int     (*set_mesh_cfg)(struct wiphy *wiphy, struct net_device *dev,
+				struct mesh_params *params);
 };
 
 #endif /* __NET_CFG80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 15b8cf9..416ce05 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -28,6 +28,8 @@ nl80211_type_to_mac80211_type(enum nl80211_iftype type)
 		return IEEE80211_IF_TYPE_STA;
 	case NL80211_IFTYPE_MONITOR:
 		return IEEE80211_IF_TYPE_MNTR;
+	case NL80211_IFTYPE_MESH_POINT:
+		return IEEE80211_IF_TYPE_MESH_POINT;
 	default:
 		return IEEE80211_IF_TYPE_INVALID;
 	}
@@ -637,6 +639,31 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_if_set_mesh_cfg(struct wiphy *wiphy,
+		struct net_device *dev, struct mesh_params *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_sub_if_data *sdata = NULL;
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
+		return -ENODEV;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+		return -EINVAL;
+
+	ifsta = &sdata->u.sta;
+	ifsta->mesh_id_len = params->mesh_id_len;
+	if (params->mesh_id_len)
+		memcpy(ifsta->mesh_id, params->mesh_id, params->mesh_id_len);
+
+	/* If the iface is down, it will be configure when it is opened */
+	if (netif_running(dev))
+		ieee80211_if_config(dev);
+	return 0;
+}
+
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -652,4 +679,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.del_station = ieee80211_del_station,
 	.change_station = ieee80211_change_station,
 	.get_station = ieee80211_get_station,
+	.set_mesh_cfg = ieee80211_if_set_mesh_cfg,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b123f58..d332683 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -82,6 +82,8 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_STA_SUPPORTED_RATES] = { .type = NLA_BINARY,
 					       .len = NL80211_MAX_SUPP_RATES },
 	[NL80211_ATTR_STA_VLAN] = { .type = NLA_U32 },
+	[NL80211_ATTR_MESH_ID] = { .type = NLA_NUL_STRING,
+				.len = IEEE80211_MAX_MESH_ID_LEN },
 };
 
 /* message building helper */
@@ -1079,6 +1081,41 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_set_mesh_cfg(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct mesh_params params;
+
+	memset(&params, 0, sizeof(params));
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->set_mesh_cfg) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!info->attrs[NL80211_ATTR_MESH_ID])
+		return -EINVAL;
+
+	params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
+	/* Cut null character */
+	params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]) - 1 ;
+
+	rtnl_lock();
+	err = drv->ops->set_mesh_cfg(&drv->wiphy, dev, &params);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -1185,6 +1222,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_MESH_CFG,
+		.doit = nl80211_set_mesh_cfg,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
-- 
1.5.2.5



