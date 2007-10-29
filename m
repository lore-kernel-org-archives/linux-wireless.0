Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:28911 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXJaBo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 21:44:29 -0400
Received: by rv-out-0910.google.com with SMTP id k20so2040416rvb
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 18:44:28 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 29 Oct 2007 15:21:56 -0700
Subject: [PATCH 3/7] o80211s: (nl80211) support for mesh interfaces and set_mesh_cfg command
Message-ID: <4727ddfc.0ebb720a.6c35.3211@mx.google.com> (sfid-20071031_014431_252300_C7C0470A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/ieee80211.h |    4 ++++
 include/linux/nl80211.h   |   11 +++++++++++
 include/net/cfg80211.h    |   14 ++++++++++++++
 net/wireless/nl80211.c    |   44 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 30621c2..897b9cd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -95,6 +95,7 @@
    WEP IV and ICV. (this interpretation suggested by Ramiro Barreiro) */
 
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
index 538ee1d..0e6abae 100644
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
@@ -56,6 +57,9 @@ enum nl80211_commands {
 
 	/* add commands here */
 
+	/* %input: ifindex, mesh_id */
+	NL80211_CMD_SET_MESH_CFG,
+
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
@@ -75,6 +79,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_IFNAME: network interface name
  * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
  *
+ * @NL80211_ATTR_MESH_ID: mesh id (1-32 bytes)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -91,6 +97,9 @@ enum nl80211_attrs {
 
 	/* add attributes here, update the policy in nl80211.c */
 
+	/* %type: nulstring */
+	NL80211_ATTR_MESH_ID,
+
 	__NL80211_ATTR_AFTER_LAST,
 	NL80211_ATTR_MAX = __NL80211_ATTR_AFTER_LAST - 1
 };
@@ -105,6 +114,7 @@ enum nl80211_attrs {
  * @NL80211_IFTYPE_AP_VLAN: VLAN interface for access points
  * @NL80211_IFTYPE_WDS: wireless distribution interface
  * @NL80211_IFTYPE_MONITOR: monitor interface receiving all frames
+ * @NL80211_IFTYPE_MESH: mesh point
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @__NL80211_IFTYPE_AFTER_LAST: internal use
  *
@@ -120,6 +130,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_AP_VLAN,
 	NL80211_IFTYPE_WDS,
 	NL80211_IFTYPE_MONITOR,
+	NL80211_IFTYPE_MESH,
 
 	/* keep last */
 	__NL80211_IFTYPE_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d30960e..3518313 100644
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
index 48b0d45..c056877 100644
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
@@ -335,6 +337,41 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_set_mesh_cfg(struct sk_buff *skb, struct genl_info *info)
+{
+       struct cfg80211_registered_device *drv;
+       int err;
+       struct net_device *dev;
+       struct mesh_params params;
+
+       memset(&params, 0, sizeof(params));
+
+       err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+       if (err)
+               return err;
+
+       if (!drv->ops->set_mesh_cfg) {
+               err = -EOPNOTSUPP;
+               goto out;
+       }
+
+       if (!info->attrs[NL80211_ATTR_MESH_ID])
+               return -EINVAL;
+
+       params.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
+       /* Cut null character */
+       params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]) - 1 ;
+
+       rtnl_lock();
+       err = drv->ops->set_mesh_cfg(&drv->wiphy, dev, &params);
+       rtnl_unlock();
+
+ out:
+       cfg80211_put_dev(drv);
+       dev_put(dev);
+       return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -374,6 +411,13 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_MESH_CFG,
+		.doit = nl80211_set_mesh_cfg,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+
 };
 
 /* multicast groups */
-- 
1.5.2.5



