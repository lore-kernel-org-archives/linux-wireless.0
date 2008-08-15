Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:57312 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002AbYHOTeP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 15:34:15 -0400
Received: from a88-112-96-116.elisa-laajakaista.fi ([88.112.96.116] helo=jm)
	by hostap.isc.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <j@w1.fi>)
	id 1KU52Q-0001tH-Tj
	for linux-wireless@vger.kernel.org; Fri, 15 Aug 2008 12:32:46 -0700
Date: Fri, 15 Aug 2008 22:33:24 +0300
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211/cfg80211: Add vif configuration options
Message-ID: <20080815193324.GH7998@jm.kir.nu> (sfid-20080815_213419_513780_72D8D6C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been working with restoring userspace MLME functionality for client
mode. The patch below adds a new cfg80211 command for setting couple of
vif parameters. Does this approach look fine? The current wpa_supplicant
git tree has code for using the new command to enabled userspace MLME.
It is also using a monitor interface in the same way as hostapd is now
handling management frames. The goal of this new command is to be able
to add new vif/sdata-specific attributes in the future, if needed,
without having to define new nl80211 commands. I just added two
attributes now as an example of what can be done with the command (and
to get driver_nl80211.c in wpa_supplicant one step closer to using
cfg80211 instead of WEXT).


Index: wireless-testing/include/net/cfg80211.h
===================================================================
--- wireless-testing.orig/include/net/cfg80211.h
+++ wireless-testing/include/net/cfg80211.h
@@ -288,6 +288,21 @@ struct bss_parameters {
 	int use_short_slot_time;
 };
 
+/**
+ * struct vif_parameters - Virtual interface parameters
+ *
+ * Used to change virtual interface parameters.
+ *
+ * @drop_unencrypted: Whether to drop unencrypted frames
+ *	(0 = no, 1 = yes, -1 = do not change)
+ * @userspace_mlme: Whether to use userspace MLME
+ *	(0 = no, 1 = yes, -1 = do not change)
+ */
+struct vif_parameters {
+	int drop_unencrypted;
+	int userspace_mlme;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -341,6 +356,8 @@ struct wiphy;
  * @set_mesh_cfg: set mesh parameters (by now, just mesh id)
  *
  * @change_bss: Modify parameters for a given BSS.
+ *
+ * @change_vif: Modify parameters for a given virtual interface.
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -399,6 +416,9 @@ struct cfg80211_ops {
 
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
+
+	int	(*change_vif)(struct wiphy *wiphy, struct net_device *dev,
+			      struct vif_parameters *params);
 };
 
 #endif /* __NET_CFG80211_H */
Index: wireless-testing/net/mac80211/cfg.c
===================================================================
--- wireless-testing.orig/net/mac80211/cfg.c
+++ wireless-testing/net/mac80211/cfg.c
@@ -1079,6 +1079,28 @@ static int ieee80211_change_bss(struct w
 	return 0;
 }
 
+static int ieee80211_change_vif(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct vif_parameters *params)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
+
+	if (dev == local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (params->drop_unencrypted >= 0)
+		sdata->drop_unencrypted = params->drop_unencrypted;
+	if (params->userspace_mlme == 0)
+		sdata->flags &= ~IEEE80211_SDATA_USERSPACE_MLME;
+	else if (params->userspace_mlme >= 0)
+		sdata->flags |= IEEE80211_SDATA_USERSPACE_MLME;
+
+	return 0;
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1104,4 +1126,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.dump_mpath = ieee80211_dump_mpath,
 #endif
 	.change_bss = ieee80211_change_bss,
+	.change_vif = ieee80211_change_vif,
 };
Index: wireless-testing/include/linux/nl80211.h
===================================================================
--- wireless-testing.orig/include/linux/nl80211.h
+++ wireless-testing/include/linux/nl80211.h
@@ -91,6 +91,8 @@
  *	by %NL80211_ATTR_IFINDEX.
  * @NL80211_CMD_SET_BSS: Set BSS attributes for BSS identified by
  *	%NL80211_ATTR_IFINDEX.
+ * @NL80211_CMD_SET_VIF: Set virtual interface attributes for vif identified by
+ *	%NL80211_ATTR_IFINDEX.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -131,6 +133,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_BSS,
 
+	NL80211_CMD_SET_VIF,
+
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -143,6 +147,7 @@ enum nl80211_commands {
  * here
  */
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
+#define NL80211_CMD_SET_VIF NL80211_CMD_SET_VIF
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -207,6 +212,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_BSS_SHORT_SLOT_TIME: whether short slot time enabled
  *	(u8, 0 or 1)
  *
+ * @NL80211_ATTR_VIF_DROP_UNENCRYPTED: whether unencrypted frames will be
+ *	dropped (u8, 0 or 1)
+ * @NL80211_ATTR_VIF_USERSPACE_MLME: whether userspace MLME is used
+ *	(u8, 0 or 1)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -254,6 +264,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_BSS_SHORT_PREAMBLE,
 	NL80211_ATTR_BSS_SHORT_SLOT_TIME,
 
+	NL80211_ATTR_VIF_DROP_UNENCRYPTED,
+	NL80211_ATTR_VIF_USERSPACE_MLME,
+
 	NL80211_ATTR_KEY_DEFAULT_MGMT,
 
 	/* add attributes here, update the policy in nl80211.c */
Index: wireless-testing/net/wireless/nl80211.c
===================================================================
--- wireless-testing.orig/net/wireless/nl80211.c
+++ wireless-testing/net/wireless/nl80211.c
@@ -92,6 +92,9 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_BSS_SHORT_PREAMBLE] = { .type = NLA_U8 },
 	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] = { .type = NLA_U8 },
 
+	[NL80211_ATTR_VIF_DROP_UNENCRYPTED] = { .type = NLA_U8 },
+	[NL80211_ATTR_VIF_USERSPACE_MLME] = { .type = NLA_U8 },
+
 	[NL80211_ATTR_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 };
 
@@ -1588,6 +1591,44 @@ static int nl80211_set_bss(struct sk_buf
 	return err;
 }
 
+static int nl80211_set_vif(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct vif_parameters params;
+
+	memset(&params, 0, sizeof(params));
+	/* default to not changing parameters */
+	params.drop_unencrypted = -1;
+	params.userspace_mlme = -1;
+
+	if (info->attrs[NL80211_ATTR_VIF_DROP_UNENCRYPTED])
+		params.userspace_mlme =
+		    nla_get_u8(info->attrs[NL80211_ATTR_VIF_DROP_UNENCRYPTED]);
+	if (info->attrs[NL80211_ATTR_VIF_USERSPACE_MLME])
+		params.userspace_mlme =
+		    nla_get_u8(info->attrs[NL80211_ATTR_VIF_USERSPACE_MLME]);
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->change_vif) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->change_vif(&drv->wiphy, dev, &params);
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
@@ -1725,6 +1766,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_VIF,
+		.doit = nl80211_set_vif,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */

-- 
Jouni Malinen                                            PGP id EFC895FA
