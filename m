Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:52399 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbYHGRVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 13:21:50 -0400
Date: Thu, 7 Aug 2008 20:07:01 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: mac80211/cfg80211: Add BSS configuration options for AP mode
Message-ID: <20080807170701.GA21060@jm.kir.nu> (sfid-20080807_192153_563786_F6E7DDCC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change adds a new cfg80211 command, NL80211_CMD_SET_BSS, to allow
AP mode BSS parameters to be changed from user space (e.g., hostapd).
The drivers using mac80211 are expected to be modified with separate
changes to use the new BSS info parameter for short slot time in the
bss_info_changed() handler.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h
+++ wireless-testing/include/net/cfg80211.h
@@ -268,6 +268,23 @@ struct mpath_info {
 	u8 flags;
 };
 
+/**
+ * struct bss_parameters - BSS parameters
+ *
+ * Used to change BSS parameters (mainly for AP mode).
+ *
+ * @use_cts_prot: Whether to use CTS protection
+ *	(0 = no, 1 = yes, -1 = do not change)
+ * @use_short_preamble: Whether the use of short preambles is allowed
+ *	(0 = no, 1 = yes, -1 = do not change)
+ * @use_short_slot_time: Whether the use of short slot time is allowed
+ *	(0 = no, 1 = yes, -1 = do not change)
+ */
+struct bss_parameters {
+	int use_cts_prot;
+	int use_short_preamble;
+	int use_short_slot_time;
+};
 
 /* from net/wireless.h */
 struct wiphy;
@@ -318,6 +335,8 @@ struct wiphy;
  * @change_station: Modify a given station.
  *
  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
+ *
+ * @change_bss: Modify parameters for a given BSS.
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -370,6 +389,9 @@ struct cfg80211_ops {
 	int	(*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
 			       int idx, u8 *dst, u8 *next_hop,
 			       struct mpath_info *pinfo);
+
+	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
+			      struct bss_parameters *params);
 };
 
 #endif /* __NET_CFG80211_H */
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c
+++ wireless-testing/net/mac80211/cfg.c
@@ -1005,6 +1005,42 @@ static int ieee80211_dump_mpath(struct w
 }
 #endif
 
+static int ieee80211_change_bss(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct bss_parameters *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+	u32 changed = 0;
+
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
+		return -EINVAL;
+
+	if (params->use_cts_prot >= 0) {
+		sdata->bss_conf.use_cts_prot = params->use_cts_prot;
+		changed |= BSS_CHANGED_ERP_CTS_PROT;
+	}
+	if (params->use_short_preamble >= 0) {
+		sdata->bss_conf.use_short_preamble =
+			params->use_short_preamble;
+		changed |= BSS_CHANGED_ERP_PREAMBLE;
+	}
+	if (params->use_short_slot_time >= 0) {
+		sdata->bss_conf.use_short_slot =
+			params->use_short_slot_time;
+		changed |= BSS_CHANGED_ERP_SLOT;
+	}
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1028,4 +1064,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.get_mpath = ieee80211_get_mpath,
 	.dump_mpath = ieee80211_dump_mpath,
 #endif
+	.change_bss = ieee80211_change_bss,
 };
Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h
+++ wireless-testing/include/linux/nl80211.h
@@ -89,6 +89,8 @@
  * @NL80211_CMD_DEL_PATH: Remove a mesh path identified by %NL80211_ATTR_MAC
  *	or, if no MAC address given, all mesh paths, on the interface identified
  *	by %NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_SET_BSS: Set BSS attributes for BSS identified by
+ *	%NL80211_ATTR_IFINDEX.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -127,6 +129,8 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_MPATH,
 	NL80211_CMD_DEL_MPATH,
 
+	NL80211_CMD_SET_BSS,
+
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -134,6 +138,11 @@ enum nl80211_commands {
 	NL80211_CMD_MAX = __NL80211_CMD_AFTER_LAST - 1
 };
 
+/*
+ * Allow user space programs to use #ifdef on new commands by defining them
+ * here
+ */
+#define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -192,6 +201,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_MNTR_FLAGS: flags, nested element with NLA_FLAG attributes of
  *      &enum nl80211_mntr_flags.
  *
+ * @NL80211_ATTR_BSS_CTS_PROT: whether CTS protection is enabled (u8, 0 or 1)
+ * @NL80211_ATTR_BSS_SHORT_PREAMBLE: whether short preamble is enabled
+ *	(u8, 0 or 1)
+ * @NL80211_ATTR_BSS_SHORT_SLOT_TIME: whether short slot time enabled
+ *	(u8, 0 or 1)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -235,6 +250,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_MPATH_NEXT_HOP,
 	NL80211_ATTR_MPATH_INFO,
 
+	NL80211_ATTR_BSS_CTS_PROT,
+	NL80211_ATTR_BSS_SHORT_PREAMBLE,
+	NL80211_ATTR_BSS_SHORT_SLOT_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c
+++ wireless-testing/net/wireless/nl80211.c
@@ -87,6 +87,10 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_BSS_CTS_PROT] = { .type = NLA_U8 },
+	[NL80211_ATTR_BSS_SHORT_PREAMBLE] = { .type = NLA_U8 },
+	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] = { .type = NLA_U8 },
 };
 
 /* message building helper */
@@ -1525,6 +1529,48 @@ static int nl80211_del_mpath(struct sk_b
 	return err;
 }
 
+static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct bss_parameters params;
+
+	memset(&params, 0, sizeof(params));
+	/* default to not changing parameters */
+	params.use_cts_prot = -1;
+	params.use_short_preamble = -1;
+	params.use_short_slot_time = -1;
+
+	if (info->attrs[NL80211_ATTR_BSS_CTS_PROT])
+		params.use_cts_prot =
+		    nla_get_u8(info->attrs[NL80211_ATTR_BSS_CTS_PROT]);
+	if (info->attrs[NL80211_ATTR_BSS_SHORT_PREAMBLE])
+		params.use_short_preamble =
+		    nla_get_u8(info->attrs[NL80211_ATTR_BSS_SHORT_PREAMBLE]);
+	if (info->attrs[NL80211_ATTR_BSS_SHORT_SLOT_TIME])
+		params.use_short_slot_time =
+		    nla_get_u8(info->attrs[NL80211_ATTR_BSS_SHORT_SLOT_TIME]);
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->change_bss) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->change_bss(&drv->wiphy, dev, &params);
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
@@ -1656,6 +1702,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_BSS,
+		.doit = nl80211_set_bss,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
Index: wireless-testing/include/net/mac80211.h
===================================================================
--- wireless-testing.orig/include/net/mac80211.h
+++ wireless-testing/include/net/mac80211.h
@@ -158,12 +158,14 @@ struct ieee80211_low_level_stats {
  *	also implies a change in the AID.
  * @BSS_CHANGED_ERP_CTS_PROT: CTS protection changed
  * @BSS_CHANGED_ERP_PREAMBLE: preamble changed
+ * @BSS_CHANGED_ERP_SLOT: slot timing changed
  * @BSS_CHANGED_HT: 802.11n parameters changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
 	BSS_CHANGED_ERP_CTS_PROT	= 1<<1,
 	BSS_CHANGED_ERP_PREAMBLE	= 1<<2,
+	BSS_CHANGED_ERP_SLOT		= 1<<3,
 	BSS_CHANGED_HT                  = 1<<4,
 };
 
@@ -177,6 +179,7 @@ enum ieee80211_bss_change {
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble
+ * @use_short_slot: use short slot time (only relevant for ERP)
  * @dtim_period: num of beacons before the next DTIM, for PSM
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval
@@ -192,6 +195,7 @@ struct ieee80211_bss_conf {
 	/* erp related data */
 	bool use_cts_prot;
 	bool use_short_preamble;
+	bool use_short_slot;
 	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
@@ -420,6 +424,11 @@ struct ieee80211_rx_status {
  * @IEEE80211_CONF_PS: Enable 802.11 power save mode
  */
 enum ieee80211_conf_flags {
+	/*
+	 * TODO: IEEE80211_CONF_SHORT_SLOT_TIME will be removed once drivers
+	 * have been converted to use bss_info_changed() for slot time
+	 * configuration
+	 */
 	IEEE80211_CONF_SHORT_SLOT_TIME	= (1<<0),
 	IEEE80211_CONF_RADIOTAP		= (1<<1),
 	IEEE80211_CONF_SUPPORT_HT_MODE	= (1<<2),


-- 
Jouni Malinen                                            PGP id EFC895FA
