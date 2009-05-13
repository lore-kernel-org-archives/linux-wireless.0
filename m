Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914AbZEMJVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:21:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC v2 3/5] cfg80211: add WoW support
Date: Wed, 13 May 2009 05:20:59 -0400
Message-Id: <1242206461-30793-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   37 ++++++++++++++
 include/net/cfg80211.h  |   28 +++++++++++
 net/wireless/nl80211.c  |  121 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 186 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 58c4ee1..5d9e469 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -240,6 +240,9 @@
  * @NL80211_CMD_LEAVE_IBSS: Leave the IBSS -- no special arguments, the IBSS is
  *	determined by the network interface.
  *
+ * @NL80211_CMD_GET_WOW: get Wake-on-Wireless-LAN settings.
+ * @NL80211_CMD_SET_WOW: set Wake-on-Wireless-LAN settings.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -308,6 +311,9 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_IBSS,
 	NL80211_CMD_LEAVE_IBSS,
 
+	NL80211_CMD_GET_WOW,
+	NL80211_CMD_SET_WOW,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -327,6 +333,8 @@ enum nl80211_commands {
 #define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
+#define NL80211_CMD_GET_WOW NL80211_CMD_GET_WOW
+#define NL80211_CMD_SET_WOW NL80211_CMD_SET_WOW
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -499,6 +507,12 @@ enum nl80211_commands {
  *	this attribute can be used
  *	with %NL80211_CMD_ASSOCIATE request
  *
+ * @NL80211_ATTR_WOW_TRIGGERS_SUPPORTED: the supported WoW triggers
+ * @NL80211_ATTR_WOW_TRIGGERS_ENABLED: used by %NL80211_CMD_SET_WOW to
+ *	indicate which WoW triggers should be enabled. This is also
+ *	used by %NL80211_CMD_GET_WOW to get the currently enabled WoW
+ *	triggers.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -603,6 +617,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USE_MFP,
 
+	NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,
+	NL80211_ATTR_WOW_TRIGGERS_ENABLED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1196,4 +1213,24 @@ enum nl80211_mfp {
 	NL80211_MFP_REQUIRED,
 };
 
+/**
+ * enum nl80211_wow_triggers - Wake-on-Wireless-LAN triggers
+ *
+ * NL80211_WOW_TRIGGER_MAGIC_PACKET: a wake signal will be sent to the
+ *     devices if a magic packet is received.
+ * NL80211_WOW_TRIGGER_BMISS: WoW signal will be sent to the device when
+ *     a beacon has been missed by the associated AP.
+ * NL80211_WOW_TRIGGER_LINK_CHANGE: a wake signal will be sent to
+ *     the device if a link change is detected on the device.
+ * NL80211_WOW_TRIGGER_USER_PATTERN: a wake sigal will be sent to the
+ *     device if a user configurable pattern is received by
+ *     the device.
+ */
+enum nl80211_wow_triggers {
+	NL80211_WOW_TRIGGER_MAGIC_PACKET	= 1 << 0,
+	NL80211_WOW_TRIGGER_BMISS		= 1 << 1,
+	NL80211_WOW_TRIGGER_LINK_CHANGE		= 1 << 2,
+	NL80211_WOW_TRIGGER_PATTERN		= 1 << 3,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5906440..5944707 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -765,6 +765,25 @@ enum wiphy_params_flags {
 };
 
 /**
+ * struct cfg80211_wow - Wake on Wireless-LAN support info
+ *
+ * This structure defines the WoW triggers supported by the device
+ * and also what specific WoW triggers the user wants enabled. To use
+ * WoW you can use standard ethernet utilities as you would with
+ * Wake-on-LAN.
+ *
+ * @triggers_supported: supported bitmask of WoW triggers.
+ *	The flags for this bitmask are %NL80211_WOW_TRIGGER_*.
+ * @triggers_enabled: enabled triggers by the user. Default
+ *	is to disable all triggers. The flags for this bitmask
+ *	are %NL80211_WOW_TRIGGER_*.
+ */
+struct cfg80211_wow {
+	u32 triggers_supported;
+	u32 triggers_enabled;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -849,6 +868,8 @@ enum wiphy_params_flags {
  *	@changed bitfield (see &enum wiphy_params_flags) describes which values
  *	have changed. The actual parameter values are available in
  *	struct wiphy. If returning an error, no value should be changed.
+ *
+ * @set_wow: used to inform the device which WoW triggers should be enabled.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -940,6 +961,7 @@ struct cfg80211_ops {
 	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
 
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
+	int	(*set_wow)(struct wiphy *wiphy, u32 triggers);
 };
 
 /*
@@ -965,6 +987,11 @@ struct cfg80211_ops {
  * 	channels at a later time. This can be used for devices which do not
  * 	have calibration information gauranteed for frequencies or settings
  * 	outside of its regulatory domain.
+ * @wow: Wake-on-Wireless-LAN configuration struct. The driver should
+ *	set the capabilities before registering the wiphy. When we
+ *	get a request to enable certain WoW events we will inform
+ *	the driver through the set_wow() callback. If this is successfull
+ *	we then set the passed triggers as enabled on the wiphy'w wow struct.
  * @reg_notifier: the driver's regulatory notification callback
  * @regd: the driver's regulatory domain, if one was requested via
  * 	the regulatory_hint() API. This can be used by the driver
@@ -992,6 +1019,7 @@ struct wiphy {
 	bool strict_regulatory;
 
 	enum cfg80211_signal_type signal_type;
+	struct cfg80211_wow wow;
 
 	int bss_priv_size;
 	u8 max_scan_ssids;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0c703b6..25fa6bd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -123,6 +123,9 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_FREQ_FIXED] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TIMED_OUT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_USE_MFP] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_WOW_TRIGGERS_SUPPORTED] = { .type = NLA_U32 },
+	[NL80211_ATTR_WOW_TRIGGERS_ENABLED] = { .type = NLA_U32 },
 };
 
 /* IE validation */
@@ -3270,6 +3273,112 @@ unlock_rtnl:
 	return err;
 }
 
+static int nl80211_get_wow(struct sk_buff *skb,
+			   struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct wiphy *wiphy;
+	int err;
+	void *hdr;
+	struct sk_buff *msg;
+
+	rtnl_lock();
+
+	/* Look up our device */
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto out_rtnl;
+
+	wiphy = &drv->wiphy;
+
+	/* Draw up a netlink message to send back */
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOBUFS;
+		goto out;
+	}
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_WOW);
+	if (!hdr)
+		goto nla_put_failure;
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,
+		    wiphy->wow.triggers_supported);
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_ENABLED,
+		    wiphy->wow.triggers_enabled);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	err = -EMSGSIZE;
+ out:
+	/* Cleanup */
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
+static int nl80211_set_wow(struct sk_buff *skb, struct genl_info *info)
+{
+	int err;
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct wiphy *wiphy;
+	u32 triggers_requested;
+
+	if (!info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto out_rtnl;
+
+	if (!drv->ops->set_wow) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+
+	if (!wiphy->wow.triggers_supported) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	triggers_requested =
+		nla_get_u32(info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);
+
+	if (!(wiphy->wow.triggers_supported & triggers_requested)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* Apply changes */
+	err = drv->ops->set_wow(&drv->wiphy, triggers_requested);
+
+	if (err)
+		goto out;
+
+	wiphy->wow.triggers_enabled = triggers_requested;
+
+ out:
+	/* cleanup */
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -3483,6 +3592,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_GET_WOW,
+		.doit = nl80211_get_wow,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_SET_WOW,
+		.doit = nl80211_set_wow,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
-- 
1.6.0.6

