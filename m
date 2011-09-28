Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55312 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1I1JgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 05:36:02 -0400
Received: by fxe4 with SMTP id 4so360088fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Sep 2011 02:36:00 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 1/5] nl80211: support sending TDLS commands/frames
Date: Wed, 28 Sep 2011 12:35:50 +0300
Message-Id: <1317202554-21221-1-git-send-email-arik@wizery.com> (sfid-20110928_113607_278973_B7C93BBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for sending high-level TDLS commands and TDLS frames via
NL80211_CMD_TDLS_OPER and NL80211_CMD_TDLS_MGMT, respectively. Add
appropriate cfg80211 callbacks for lower level drivers.

Add wiphy capability flags for TDLS support and advertise them via
nl80211.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
v1->2: remove currently unsued TDLS_ENABLE/DISABLE sub-commands for
TDLS oper. Make sure TDLS is supported by wiphy when executing TDLS
nl80211 functions.

 include/linux/nl80211.h |   42 ++++++++++++++++++++++++
 include/net/cfg80211.h  |   17 ++++++++++
 net/wireless/nl80211.c  |   81 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 139 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 460b12a..329fc9d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -502,6 +502,9 @@
  * @NL80211_CMD_PMKSA_CANDIDATE: This is used as an event to inform userspace
  *	of PMKSA caching dandidates.
  *
+ * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -628,6 +631,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_PMKSA_CANDIDATE,
 
+	NL80211_CMD_TDLS_OPER,
+	NL80211_CMD_TDLS_MGMT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1078,6 +1084,20 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMKSA_CANDIDATE: Nested attribute containing the PMKSA caching
  *	candidate information, see &enum nl80211_pmksa_candidate_attr.
  *
+ * @NL80211_ATTR_TDLS_ACTION: Low level TDLS action code (e.g. link setup
+ *	request, link setup confirm, link teardown, etc.). Values are
+ *	described in the TDLS (802.11z) specification.
+ * @NL80211_ATTR_TDLS_DIALOG_TOKEN: Non-zero token for uniquely identifying a
+ *	TDLS conversation between two devices.
+ * @NL80211_ATTR_TDLS_OPERATION: High level TDLS operation; see
+ *	&enum nl80211_tdls_operation, represented as a u8.
+ * @NL80211_ATTR_TDLS_SUPPORT: A flag indicating the device can operate
+ *	as a TDLS peer sta.
+ * @NL80211_ATTR_TDLS_EXTERNAL_SETUP: The TDLS discovery/setup and teardown
+ *	procedures should be performed by sending TDLS packets via
+ *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
+ *	used for asking the driver to perform a TDLS operation.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1298,6 +1318,12 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PMKSA_CANDIDATE,
 
+	NL80211_ATTR_TDLS_ACTION,
+	NL80211_ATTR_TDLS_DIALOG_TOKEN,
+	NL80211_ATTR_TDLS_OPERATION,
+	NL80211_ATTR_TDLS_SUPPORT,
+	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2591,4 +2617,20 @@ enum nl80211_pmksa_candidate_attr {
 	MAX_NL80211_PMKSA_CANDIDATE = NUM_NL80211_PMKSA_CANDIDATE - 1
 };
 
+/**
+ * enum nl80211_tdls_operation - values for %NL80211_ATTR_TDLS_OPERATION
+ * @NL80211_TDLS_DISCOVERY_REQ: Send a TDLS discovery request
+ * @NL80211_TDLS_SETUP: Setup TDLS link
+ * @NL80211_TDLS_TEARDOWN: Teardown a TDLS link which is already established
+ * @NL80211_TDLS_ENABLE_LINK: Enable TDLS link
+ * @NL80211_TDLS_DISABLE_LINK: Disable TDLS link
+ */
+enum nl80211_tdls_operation {
+	NL80211_TDLS_DISCOVERY_REQ,
+	NL80211_TDLS_SETUP,
+	NL80211_TDLS_TEARDOWN,
+	NL80211_TDLS_ENABLE_LINK,
+	NL80211_TDLS_DISABLE_LINK,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ccfdf3f..63a2e31 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1408,6 +1408,9 @@ struct cfg80211_gtk_rekey_data {
  * @set_ringparam: Set tx and rx ring sizes.
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
+ *
+ * @tdls_mgmt: Transmit a TDLS management frame.
+ * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1590,6 +1593,12 @@ struct cfg80211_ops {
 
 	int	(*set_rekey_data)(struct wiphy *wiphy, struct net_device *dev,
 				  struct cfg80211_gtk_rekey_data *data);
+
+	int	(*tdls_mgmt)(struct wiphy *wiphy, struct net_device *dev,
+			     u8 *peer, u8 action_code,  u8 dialog_token,
+			     u16 status_code, const u8 *buf, size_t len);
+	int	(*tdls_oper)(struct wiphy *wiphy, struct net_device *dev,
+			     u8 *peer, enum nl80211_tdls_operation oper);
 };
 
 /*
@@ -1642,6 +1651,12 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_FW_ROAM: The device supports roaming feature in the
  *	firmware.
  * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
+ * @WIPHY_FLAG_SUPPORTS_TDLS: The device supports TDLS (802.11z) operation.
+ * @WIPHY_FLAG_TDLS_EXTERNAL_SETUP: The device does not handle TDLS (802.11z)
+ *	link setup/discovery operations internally. Setup, discovery and
+ *	teardown packets should be sent through the @NL80211_CMD_TDLS_MGMT
+ *	command. When this flag is not set, @NL80211_CMD_TDLS_OPER should be
+ *	used for asking the driver/firmware to perform a TDLS operation.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1658,6 +1673,8 @@ enum wiphy_flags {
 	WIPHY_FLAG_ENFORCE_COMBINATIONS		= BIT(12),
 	WIPHY_FLAG_SUPPORTS_FW_ROAM		= BIT(13),
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
+	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
+	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c26a1da..f853a83 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -191,6 +191,11 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_ROAM_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SCHED_SCAN_MATCH] = { .type = NLA_NESTED },
+	[NL80211_ATTR_TDLS_ACTION] = { .type = NLA_U8 },
+	[NL80211_ATTR_TDLS_DIALOG_TOKEN] = { .type = NLA_U8 },
+	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
+	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -731,9 +736,12 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_MESH_AUTH);
 	if (dev->wiphy.flags & WIPHY_FLAG_AP_UAPSD)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_AP_UAPSD);
-
 	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FW_ROAM)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_ROAM_SUPPORT);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_TDLS_SUPPORT);
+	if (dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP);
 
 	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
 		sizeof(u32) * dev->wiphy.n_cipher_suites,
@@ -876,6 +884,10 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	}
 	CMD(set_channel, SET_CHANNEL);
 	CMD(set_wds_peer, SET_WDS_PEER);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) {
+		CMD(tdls_mgmt, TDLS_MGMT);
+		CMD(tdls_oper, TDLS_OPER);
+	}
 	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
 		CMD(sched_scan_start, START_SCHED_SCAN);
 
@@ -4972,6 +4984,57 @@ static int nl80211_flush_pmksa(struct sk_buff *skb, struct genl_info *info)
 	return rdev->ops->flush_pmksa(&rdev->wiphy, dev);
 }
 
+static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u8 action_code, dialog_token;
+	u16 status_code;
+	u8 *peer;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) ||
+	    !rdev->ops->tdls_mgmt)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_TDLS_ACTION] ||
+	    !info->attrs[NL80211_ATTR_STATUS_CODE] ||
+	    !info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN] ||
+	    !info->attrs[NL80211_ATTR_IE] ||
+	    !info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	action_code = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_ACTION]);
+	status_code = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
+	dialog_token = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN]);
+
+	return rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
+				    dialog_token, status_code,
+				    nla_data(info->attrs[NL80211_ATTR_IE]),
+				    nla_len(info->attrs[NL80211_ATTR_IE]));
+}
+
+static int nl80211_tdls_oper(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	enum nl80211_tdls_operation operation;
+	u8 *peer;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) ||
+	    !rdev->ops->tdls_oper)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_TDLS_OPERATION] ||
+	    !info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	operation = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_OPERATION]);
+	peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	return rdev->ops->tdls_oper(&rdev->wiphy, dev, peer, operation);
+}
+
 static int nl80211_remain_on_channel(struct sk_buff *skb,
 				     struct genl_info *info)
 {
@@ -6284,6 +6347,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_TDLS_MGMT,
+		.doit = nl80211_tdls_mgmt,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_TDLS_OPER,
+		.doit = nl80211_tdls_oper,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.4.1

