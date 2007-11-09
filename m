Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:46272 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXKJC0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 21:26:41 -0500
Received: by wa-out-1112.google.com with SMTP id v27so794974wah
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2007 18:26:41 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 9 Nov 2007 15:02:28 -0800
Subject: [PATCH 2/4] o80211s: (nl80211) support for mesh interfaces and set_mesh_cfg command
Message-ID: <473516df.18bb720a.41e8.5fdc@mx.google.com> (sfid-20071110_022645_005653_498DB7A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This command allows to set the mesh ID for a (pre) 802.11s interface. In the
future it will also allow to set other parameters such as path selection
protocol, metric, default mesh ttl and other mesh parameters.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/ieee80211.h |    4 ++++
 include/linux/nl80211.h   |   10 +++++++++-
 include/net/cfg80211.h    |   14 ++++++++++++++
 net/wireless/nl80211.c    |   44 +++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 214821a..ee976ee 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -95,6 +95,7 @@
 #define IEEE80211_MAX_FRAME_LEN		2352
 
 #define IEEE80211_MAX_SSID_LEN		32
+#define IEEE80211_MAX_MESH_ID_LEN	32
 
 struct ieee80211_hdr {
 	__le16 frame_control;
@@ -319,6 +320,9 @@ enum ieee80211_eid {
 	WLAN_EID_HP_PARAMS = 8,
 	WLAN_EID_HP_TABLE = 9,
 	WLAN_EID_REQUEST = 10,
+	/* 802.11s */
+	WLAN_EID_MESH_CONFIG = 22,      /* Pending IEEE 802.11 ANA approval */
+	WLAN_EID_MESH_ID = 23,          /* Pending IEEE 802.11 ANA approval */
 	/* 802.11h */
 	WLAN_EID_PWR_CONSTRAINT = 32,
 	WLAN_EID_PWR_CAPABILITY = 33,
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 538ee1d..f31f71b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -36,6 +36,7 @@
  *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_WIPHY. Can also be sent from
  *	userspace to request deletion of a virtual interface, then requires
  *	attribute %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_SET_MESH_CFG: start mesh operation
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -56,6 +57,8 @@ enum nl80211_commands {
 
 	/* add commands here */
 
+	NL80211_CMD_SET_MESH_CFG,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -75,13 +78,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_IFNAME: network interface name
  * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
  *
+ * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_attrs {
 /* don't change the order or add anything inbetween, this is ABI! */
 	NL80211_ATTR_UNSPEC,
-
 	NL80211_ATTR_WIPHY,
 	NL80211_ATTR_WIPHY_NAME,
 
@@ -91,6 +95,8 @@ enum nl80211_attrs {
 
 	/* add attributes here, update the policy in nl80211.c */
 
+	NL80211_ATTR_MESH_ID,
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
@@ -105,6 +111,7 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
+ * @NL80211_IFTYPE_MESH: mesh point
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @__NL80211_IFTYPE_AFTER_LAST: internal use
  *
@@ -120,6 +127,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_AP_VLAN,
 	NL80211_IFTYPE_WDS,
 	NL80211_IFTYPE_MONITOR,
+	NL80211_IFTYPE_MESH,
 
 	/* keep last */
 	__NL80211_IFTYPE_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d30960e..731231c 100644
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
@@ -71,6 +81,8 @@ struct wiphy;
  *
  * @change_virtual_intf: change type of virtual interface
  *
+ * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
+ *
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -78,6 +90,8 @@ struct cfg80211_ops {
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
 				       enum nl80211_iftype type);
+	int     (*set_mesh_cfg)(struct wiphy *wiphy, struct net_device *dev,
+				struct mesh_params *params);
 };
 
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48b0d45..cfaaea6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -61,6 +61,8 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
+	[NL80211_ATTR_MESH_ID] = { .type = NLA_NUL_STRING,
+				.len = IEEE80211_MAX_MESH_ID_LEN },
 };
 
 /* message building helper */
@@ -157,7 +159,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return result;
 }
 
-
 static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct net_device *dev)
 {
@@ -335,6 +336,41 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
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
@@ -374,6 +410,12 @@ static struct genl_ops nl80211_ops[] = {
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



