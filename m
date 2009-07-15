Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52584 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678AbZGOAWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:22:03 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/5] cfg80211: add WoW support
Date: Tue, 14 Jul 2009 20:21:58 -0400
Message-Id: <1247617320-20163-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We support a set and get for WoW parameters. We support
setting of 3 type of triggers:

 * Magic Packet
 * Beacon miss
 * Link change (no longer associated)

Not yet supported:

 * User pattern match

The user pattern match will need a parser as patterns
can be customized. It should be noted WoW will require
suspend to S3 Hot (power cable plugged), and proper
BIOS support to receive PCI PMEs and kick the box on.

For USB this may be easier and no BIOS intervention should
be required.

Drivers which support WoW must set their supported hardware/driver
triggers on the wiphy's cfg80211 wow_triggers_supported. cfg80211
drivers will be informed of the enabled wow triggers through the
suspend() cfg80211 callback. By default we disable all triggers.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   46 +++++++++++++++++++
 include/net/cfg80211.h  |   26 ++++++++++-
 net/wireless/core.h     |    3 +
 net/wireless/nl80211.c  |  116 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/sysfs.c    |    2 +-
 5 files changed, 190 insertions(+), 3 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 962e223..0c869ca 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -262,6 +262,18 @@
  *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
  *	%NL80211_ATTR_REASON_CODE attributes are used.
  *
+ * @NL80211_CMD_GET_WOW: get Wake-on-Wireless-LAN (WoW) settings.
+ * @NL80211_CMD_SET_WOW: set Wake-on-Wireless-LAN (Wow) settings. Wake on
+ *	wireless makes use of standard Wake-on-LAN (WoL) frames, you receive
+ *	a WoW frame when your AP sends you a regular WOL frame. The difference
+ *	difference WoL is you need to be associated to an AP in order to
+ *	receive WoW frames, so additional triggers are available for a wakeup.
+ *	A driver capable of WoW should initialize the wiphy with its supported
+ *	WoW triggers. Upon suspend cfg80211 will inform the driver of the user
+ *	enabled triggers. By default no WoW triggers are enabled.
+ *	For more information see:
+ *	http://wireless.kernel.org/en/users/Documentation/WoW
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -336,6 +348,9 @@ enum nl80211_commands {
 	NL80211_CMD_ROAM,
 	NL80211_CMD_DISCONNECT,
 
+	NL80211_CMD_GET_WOW,
+	NL80211_CMD_SET_WOW,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -355,6 +370,8 @@ enum nl80211_commands {
 #define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
+#define NL80211_CMD_GET_WOW NL80211_CMD_GET_WOW
+#define NL80211_CMD_SET_WOW NL80211_CMD_SET_WOW
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -573,6 +590,12 @@ enum nl80211_commands {
  *	and join_ibss(), key information is in a nested attribute each
  *	with %NL80211_KEY_* sub-attributes
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
@@ -701,6 +724,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_KEY,
 	NL80211_ATTR_KEYS,
 
+	NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,
+	NL80211_ATTR_WOW_TRIGGERS_ENABLED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1372,4 +1398,24 @@ enum nl80211_key_attributes {
 	NL80211_KEY_MAX = __NL80211_KEY_AFTER_LAST - 1
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
+ * NL80211_WOW_TRIGGER_USER_PATTERN: a wake signal will be sent to the
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
index a981ca8..d45fcec 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -828,6 +828,21 @@ struct cfg80211_bitrate_mask {
 	u32 maxrate; /* in kbps, 0 == no limit */
 };
 
+/*
+ * struct cfg80211_wow - Wake on Wireless-LAN support info
+ *
+ * This structure defines the WoW triggers enabled and set for the device.
+ * For now we only carry the supported tiggers but this is expected to grow
+ * once we add support for user patterns.
+ *
+ * @triggers_enabled: enabled triggers by the user. Default
+ *	is to disable all triggers. The flags for this bitmask
+ *	are %NL80211_WOW_TRIGGER_*.
+ */
+struct cfg80211_wow {
+	u32 triggers_enabled;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -841,7 +856,8 @@ struct cfg80211_bitrate_mask {
  * wireless extensions but this is subject to reevaluation as soon as this
  * code is used more widely and we have a first user without wext.
  *
- * @suspend: wiphy device needs to be suspended
+ * @suspend: wiphy device needs to be suspended. We pass the struct cfg80211_wow
+ *	so the device enables the appropriate triggers during suspend.
  * @resume: wiphy device needs to be resumed
  *
  * @add_virtual_intf: create a new virtual interface with the given name,
@@ -931,7 +947,7 @@ struct cfg80211_bitrate_mask {
  * @testmode_cmd: run a test mode command
  */
 struct cfg80211_ops {
-	int	(*suspend)(struct wiphy *wiphy);
+	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wow *wow);
 	int	(*resume)(struct wiphy *wiphy);
 
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -1088,6 +1104,10 @@ struct cfg80211_ops {
  * @frag_threshold: Fragmentation threshold (dot11FragmentationThreshold);
  *	-1 = fragmentation disabled, only odd values >= 256 used
  * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
+ * @wow_triggers_supported: supported bitmask of Wake-on-Wireless triggers.
+ *	The flags for this bitmask are %NL80211_WOW_TRIGGER_*. The driver
+ *	should set the capabilities before registering the wiphy. WoW triggers
+ *	which should be used are passed to the driver upon suspend.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1115,6 +1135,8 @@ struct wiphy {
 	u32 frag_threshold;
 	u32 rts_threshold;
 
+	u32 wow_triggers_supported;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 2ec8ddb..1d250cd 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -66,6 +66,9 @@ struct cfg80211_registered_device {
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
+	/* Used to keep track of user configurable triggers */
+	struct cfg80211_wow wow;
+
 #ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
 	struct wiphy_debugfsdentries {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6dad3e7..50de866 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -133,6 +133,9 @@ static struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] __read_mostly = {
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
+
+	[NL80211_ATTR_WOW_TRIGGERS_SUPPORTED] = { .type = NLA_U32 },
+	[NL80211_ATTR_WOW_TRIGGERS_ENABLED] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -4023,6 +4026,109 @@ unlock_rtnl:
 	return err;
 }
 
+static int nl80211_get_wow(struct sk_buff *skb,
+			   struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	struct wiphy *wiphy;
+	int err;
+	void *hdr;
+	struct sk_buff *msg;
+
+	rtnl_lock();
+
+	/* Look up our device */
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	if (err)
+		goto out_rtnl;
+
+	wiphy = &rdev->wiphy;
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
+		    wiphy->wow_triggers_supported);
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_ENABLED,
+		    rdev->wow.triggers_enabled);
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
+	cfg80211_unlock_rdev(rdev);
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
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	struct wiphy *wiphy;
+	u32 triggers_requested;
+
+	if (!info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	if (err)
+		goto out_rtnl;
+
+	wiphy = &rdev->wiphy;
+
+	if (!wiphy->wow_triggers_supported) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	triggers_requested =
+		nla_get_u32(info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);
+
+	/* Needs a pattern attribute implemented and passed to the driver */
+	if (triggers_requested & NL80211_WOW_TRIGGER_PATTERN)
+		return -EOPNOTSUPP;
+
+	if (!(wiphy->wow_triggers_supported & triggers_requested)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/*
+	 * Apply changes. This information gets passed to the
+	 * drivers during suspend.
+	 */
+	rdev->wow.triggers_enabled = triggers_requested;
+
+ out:
+	/* cleanup */
+	cfg80211_unlock_rdev(rdev);
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
@@ -4253,6 +4359,16 @@ static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_DISCONNECT,
 		.doit = nl80211_disconnect,
+	},
+	{
+		.cmd = NL80211_CMD_GET_WOW,
+		.doit = nl80211_get_wow,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = NL80211_CMD_SET_WOW,
+		.doit = nl80211_set_wow,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index efe3c5c..8b60a5b 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -64,7 +64,7 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 
 	if (rdev->ops->suspend) {
 		rtnl_lock();
-		ret = rdev->ops->suspend(&rdev->wiphy);
+		ret = rdev->ops->suspend(&rdev->wiphy, &rdev->wow);
 		rtnl_unlock();
 	}
 
-- 
1.6.0.6

