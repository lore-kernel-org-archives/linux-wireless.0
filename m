Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab1CAUgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:36:45 -0500
Received: by wyg36 with SMTP id 36so5089422wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:36:43 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 1/9] cfg80211: add WoW support
Date: Tue,  1 Mar 2011 22:36:36 +0200
Message-Id: <1299011804-13899-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <lrodriguez@atheros.com>

Add initial support for wake-on-wireless.
Let the user enable specific WoW triggers, and pass them
while calling suspend/resume.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 include/linux/nl80211.h |   42 +++++++++++++++++++++++++
 include/net/cfg80211.h  |   31 +++++++++++++++++--
 net/wireless/core.h     |    3 ++
 net/wireless/nl80211.c  |   78 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/sysfs.c    |    4 +-
 5 files changed, 153 insertions(+), 5 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 821ffb9..44f75f0 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -410,6 +410,18 @@
  *	notification. This event is used to indicate that an unprotected
  *	disassociation frame was dropped when MFP is in use.
  *
+ * @NL80211_CMD_GET_WOW: get Wake-on-Wireless-LAN (WoW) settings.
+ * @NL80211_CMD_SET_WOW: set Wake-on-Wireless-LAN (Wow) settings. Wake on
+ *	wireless makes use of standard Wake-on-LAN (WoL) frames, you receive
+ *	a WoW frame when your AP sends you a regular WOL frame. The difference
+ *	is you need to be associated to an AP in order to receive WoW frames,
+ *	so additional triggers are available for a wakeup.
+ *	A driver capable of WoW should initialize the wiphy with its supported
+ *	WoW triggers. Upon suspend cfg80211 will inform the driver of the user
+ *	enabled triggers. By default no WoW triggers are enabled.
+ *	For more information see:
+ *	http://wireless.kernel.org/en/users/Documentation/WoW
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -522,6 +534,9 @@ enum nl80211_commands {
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
+	NL80211_CMD_GET_WOW,
+	NL80211_CMD_SET_WOW,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -541,6 +556,8 @@ enum nl80211_commands {
 #define NL80211_CMD_DEAUTHENTICATE NL80211_CMD_DEAUTHENTICATE
 #define NL80211_CMD_DISASSOCIATE NL80211_CMD_DISASSOCIATE
 #define NL80211_CMD_REG_BEACON_HINT NL80211_CMD_REG_BEACON_HINT
+#define NL80211_CMD_GET_WOW NL80211_CMD_GET_WOW
+#define NL80211_CMD_SET_WOW NL80211_CMD_SET_WOW
 
 /* source-level API compatibility */
 #define NL80211_CMD_GET_MESH_PARAMS NL80211_CMD_GET_MESH_CONFIG
@@ -887,6 +904,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_MESH_CONFIG: Mesh configuration parameters, a nested attribute
  *	containing attributes from &enum nl80211_meshconf_params.
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
@@ -1074,6 +1097,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 
+	NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,
+	NL80211_ATTR_WOW_TRIGGERS_ENABLED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1999,4 +2025,20 @@ enum nl80211_tx_power_setting {
 	NL80211_TX_POWER_FIXED,
 };
 
+/**
+ * enum nl80211_wow_triggers - Wake-on-Wireless-LAN triggers
+ *
+ * @NL80211_WOW_TRIGGER_MAGIC_PACKET: wake up when a magic packet is received.
+ * @NL80211_WOW_TRIGGER_BMISS: wake up on a beacon loss.
+ * @NL80211_WOW_TRIGGER_ANYTHING: wake up by any irq. in this mode there is no
+ *	need for any special hw support but staying up while the host is being
+ *	suspended. however, any hw capability might be used in order to avoid
+ *	unnecessary wake-ups (e.g. beacon-filtering, arp-filtering, etc.)
+ */
+enum nl80211_wow_triggers {
+	NL80211_WOW_TRIGGER_MAGIC_PACKET	= 1 << 0,
+	NL80211_WOW_TRIGGER_BMISS		= 1 << 1,
+	NL80211_WOW_TRIGGER_ANYTHING		= 1 << 2,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 679a049..533eb18 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1043,6 +1043,20 @@ struct cfg80211_pmksa {
 	u8 *pmkid;
 };
 
+/*
+ * struct cfg80211_wow - Wake on Wireless-LAN support info
+ *
+ * This structure defines the enabled WoW triggers for the device.
+ * For now we only carry the enabled triggers but this is expected to grow
+ * once we add support for user patterns.
+ *
+ * @enabled_triggers: bitmap of enabled triggers (none by default).
+ *	The flags for this bitmask are %NL80211_WOW_TRIGGER_*.
+ */
+struct cfg80211_wow {
+	u32 enabled_triggers;
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -1056,8 +1070,13 @@ struct cfg80211_pmksa {
  * wireless extensions but this is subject to reevaluation as soon as this
  * code is used more widely and we have a first user without wext.
  *
- * @suspend: wiphy device needs to be suspended
+ * @suspend: wiphy device needs to be suspended.
+ *	@wow will contain the enabled Wake-on-Wireless triggers that should
+ *	be configured to the device.
  * @resume: wiphy device needs to be resumed
+ *	@wow will contain the enabled Wake-on-Wireless triggers that were
+ *	configured to the device (it does not tell what was the actual
+ *	wake-up reason).
  *
  * @add_virtual_intf: create a new virtual interface with the given name,
  *	must set the struct wireless_dev's iftype. Beware: You must create
@@ -1196,8 +1215,8 @@ struct cfg80211_pmksa {
  * @get_antenna: Get current antenna configuration from device (tx_ant, rx_ant).
  */
 struct cfg80211_ops {
-	int	(*suspend)(struct wiphy *wiphy);
-	int	(*resume)(struct wiphy *wiphy);
+	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wow *wow);
+	int	(*resume)(struct wiphy *wiphy, struct cfg80211_wow *wow);
 
 	struct net_device * (*add_virtual_intf)(struct wiphy *wiphy,
 						char *name,
@@ -1494,6 +1513,10 @@ struct ieee80211_txrx_stypes {
  *
  * @max_remain_on_channel_duration: Maximum time a remain-on-channel operation
  *	may request, if implemented.
+ * @supported_wow_triggers: bitmap of supported Wake-on-Wireless triggers.
+ *	The flags for this bitmask are %NL80211_WOW_TRIGGER_*. The driver
+ *	should set the capabilities before registering the wiphy. WoW triggers
+ *	which should be used are passed to the driver upon suspend.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1538,6 +1561,8 @@ struct wiphy {
 	u32 available_antennas_tx;
 	u32 available_antennas_rx;
 
+	u32 supported_wow_triggers;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 26a0a08..aa63760 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -70,6 +70,9 @@ struct cfg80211_registered_device {
 	struct work_struct conn_work;
 	struct work_struct event_work;
 
+	/* enabled WoW triggers (user configurable)*/
+	struct cfg80211_wow wow;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 864ddfb..eea7aae 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -172,6 +172,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+
+	[NL80211_ATTR_WOW_TRIGGERS_SUPPORTED] = { .type = NLA_U32 },
+	[NL80211_ATTR_WOW_TRIGGERS_ENABLED] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -4762,6 +4765,64 @@ static int nl80211_leave_mesh(struct sk_buff *skb, struct genl_info *info)
 	return cfg80211_leave_mesh(rdev, dev);
 }
 
+static int nl80211_get_wow(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	int err;
+	void *hdr;
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_WOW);
+	if (!hdr) {
+		err = -ENOBUFS;
+		goto free_msg;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_SUPPORTED,
+		    rdev->wiphy.supported_wow_triggers);
+	NLA_PUT_U32(msg, NL80211_ATTR_WOW_TRIGGERS_ENABLED,
+		    rdev->wow.enabled_triggers);
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	err = -ENOBUFS;
+free_msg:
+	nlmsg_free(msg);
+	return err;
+}
+
+static int nl80211_set_wow(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	u32 requested_trig, supported_trig;
+
+	if (!info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED])
+		return -EINVAL;
+
+	requested_trig =
+		nla_get_u32(info->attrs[NL80211_ATTR_WOW_TRIGGERS_ENABLED]);
+	supported_trig = rdev->wiphy.supported_wow_triggers;
+
+	/* check for unsupported triggers */
+	if ((requested_trig & supported_trig) != requested_trig)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Apply changes.
+	 * This information gets passed to the drivers during suspend.
+	 */
+	rdev->wow.enabled_triggers = requested_trig;
+
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -5260,6 +5321,23 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_WOW,
+		.doit = nl80211_get_wow,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_SET_WOW,
+		.doit = nl80211_set_wow,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 4294fa2..d2fb411 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -93,7 +93,7 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 
 	if (rdev->ops->suspend) {
 		rtnl_lock();
-		ret = rdev->ops->suspend(&rdev->wiphy);
+		ret = rdev->ops->suspend(&rdev->wiphy, &rdev->wow);
 		rtnl_unlock();
 	}
 
@@ -112,7 +112,7 @@ static int wiphy_resume(struct device *dev)
 
 	if (rdev->ops->resume) {
 		rtnl_lock();
-		ret = rdev->ops->resume(&rdev->wiphy);
+		ret = rdev->ops->resume(&rdev->wiphy, &rdev->wow);
 		rtnl_unlock();
 	}
 
-- 
1.7.0.4

