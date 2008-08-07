Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:38802 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYHGNla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 09:41:30 -0400
Date: Thu, 7 Aug 2008 16:40:44 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211/cfg80211: Add BSS configuration options for AP mode
Message-ID: <20080807134043.GA5138@jm.kir.nu> (sfid-20080807_154146_716057_0805FDEF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been looking at adding some of the missing configuration options to
allow AP mode in mac80211 to remain in sync with hostapd. The patch
below introduces a new cfg80211 command for setting BSS parameters and
adds three initial attributes for this command (CTS protection, short
preamble, short slot time). I would expect CTS protection and short
preamble to work as-is, but short slot time will need some more code to
notify the driver that it needs to change configuration. Based on a
quick test with hostapd, it looks like these parameters can be
successfully passed from there to mac80211.

Could you please take a quick look at whether this looks like a correct
way of introducing new functionality into cfg80211? I'll finish the
short slot time part in mac80211 and post an updated patch as a proper
submission later.


Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h
+++ wireless-testing/include/net/cfg80211.h
@@ -270,6 +270,23 @@ struct mpath_info {
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
@@ -322,6 +339,8 @@ struct wiphy;
  * @change_station: Modify a given station.
  *
  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
+ *
+ * @change_bss: Modify parameters for a given BSS.
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -377,6 +396,9 @@ struct cfg80211_ops {
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
@@ -1055,6 +1055,35 @@ static int ieee80211_dump_mpath(struct w
 }
 #endif
 
+static int ieee80211_change_bss(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct bss_parameters *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	printk(KERN_DEBUG "JKM-%s: cts=%d preamble=%d slot=%d\n",
+	       __func__, params->use_cts_prot, params->use_short_preamble,
+	       params->use_short_slot_time);
+	if (params->use_cts_prot >= 0)
+		sdata->bss_conf.use_cts_prot = params->use_cts_prot;
+	if (params->use_short_preamble >= 0)
+		sdata->bss_conf.use_short_preamble =
+			params->use_short_preamble;
+#if 0 /* TODO: need to notify low-level driver */
+	if (params->use_short_slot_time >= 0)
+		sdata->bss_conf.use_short_slot_time =
+			params->use_short_slot_time;
+#endif
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1079,4 +1108,5 @@ struct cfg80211_ops mac80211_config_ops 
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
@@ -237,6 +252,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_KEY_DEFAULT_MGMT,
 
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
@@ -89,6 +89,10 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
 
 	[NL80211_ATTR_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
+
+	[NL80211_ATTR_BSS_CTS_PROT] = { .type = NLA_U8 },
+	[NL80211_ATTR_BSS_SHORT_PREAMBLE] = { .type = NLA_U8 },
+	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] = { .type = NLA_U8 },
 };
 
 /* message building helper */
@@ -1560,6 +1564,48 @@ static int nl80211_del_mpath(struct sk_b
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
@@ -1691,6 +1737,12 @@ static struct genl_ops nl80211_ops[] = {
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

-- 
Jouni Malinen                                            PGP id EFC895FA
