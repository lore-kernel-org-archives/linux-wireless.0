Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60462 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab1IOKcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:32:09 -0400
Received: by eya28 with SMTP id 28so244608eya.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 03:32:08 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Kalyan C Gaddam <chakkal@iit.edu>, Arik Nemtsov <arik@wizery.com>
Subject: [RFC 1/5] nl80211: support sending TDLS commands/frames
Date: Thu, 15 Sep 2011 13:25:30 +0300
Message-Id: <1316082334-7664-2-git-send-email-arik@wizery.com> (sfid-20110915_123212_984058_7E58D247)
In-Reply-To: <1316082334-7664-1-git-send-email-arik@wizery.com>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for sending high-level TDLS commands and TDLS frames via
NL80211_CMD_TDLS_OPER and NL80211_CMD_TDLS_MGMT, respectively.

Add appropriate cfg80211 callbacks for lower level drivers.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Cc: Kalyan C Gaddam <chakkal@iit.edu>
---
 include/linux/nl80211.h |   38 +++++++++++++++++++++++++
 include/net/cfg80211.h  |    9 ++++++
 net/wireless/nl80211.c  |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3769303..e21e023 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -499,6 +499,9 @@
  *	this command may also be sent by the driver as an MLME event to
  *	inform userspace of the new replay counter.
  *
+ * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
+ * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -623,6 +626,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_REKEY_OFFLOAD,
 
+	NL80211_CMD_TDLS_OPER,
+	NL80211_CMD_TDLS_MGMT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1042,6 +1048,14 @@ enum nl80211_commands {
  *	(Re)Association Response frames when the driver (or firmware) replies to
  *	(Re)Association Request frames.
  *
+ * @NL80211_ATTR_TDLS_ACTION: Low level TDLS action code (e.g. link setup
+ *	request, link setup confirm, link teardown, etc.). Values are
+ *	described in the TDLS (802.11z) specification.
+ * @NL80211_ATTR_TDLS_DIALOG_TOKEN: Non-zero token for uniquely identifying a
+ *	TDLS conversation between two devices.
+ * @NL80211_ATTR_TDLS_OPERATION: High level TDLS operation; see
+ *	&enum nl80211_tdls_operation, represented as a u8.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1252,6 +1266,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_PROBE_RESP,
 	NL80211_ATTR_IE_ASSOC_RESP,
 
+	NL80211_ATTR_TDLS_ACTION,
+	NL80211_ATTR_TDLS_DIALOG_TOKEN,
+	NL80211_ATTR_TDLS_OPERATION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2482,4 +2500,24 @@ enum nl80211_hidden_ssid {
 	NL80211_HIDDEN_SSID_ZERO_CONTENTS
 };
 
+/**
+ * enum nl80211_tdls_operation - values for %NL80211_ATTR_TDLS_OPERATION
+ * @NL80211_TDLS_DISCOVERY_REQ: Send a TDLS discovery request
+ * @NL80211_TDLS_SETUP: Setup TDLS link
+ * @NL80211_TDLS_TEARDOWN: Teardown a TDLS link which is already established
+ * @NL80211_TDLS_ENABLE_LINK: Enable TDLS link
+ * @NL80211_TDLS_DISABLE_LINK: Disable TDLS link
+ * @NL80211_TDLS_ENABLE: (Re-)Enable TDLS operation
+ * @NL80211_TDLS_DISABLE: Disable TDLS operation
+ */
+enum nl80211_tdls_operation {
+	NL80211_TDLS_DISCOVERY_REQ,
+	NL80211_TDLS_SETUP,
+	NL80211_TDLS_TEARDOWN,
+	NL80211_TDLS_ENABLE_LINK,
+	NL80211_TDLS_DISABLE_LINK,
+	NL80211_TDLS_ENABLE,
+	NL80211_TDLS_DISABLE
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a37f264..a899e34 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1386,6 +1386,9 @@ struct cfg80211_gtk_rekey_data {
  * @set_ringparam: Set tx and rx ring sizes.
  *
  * @get_ringparam: Get tx and rx ring current and maximum sizes.
+ *
+ * @tdls_mgmt: Transmit a TDLS management frame.
+ * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1568,6 +1571,12 @@ struct cfg80211_ops {
 
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 57ecfa4..74a4ad4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -189,6 +189,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_TDLS_ACTION] = { .type = NLA_U8 },
+	[NL80211_ATTR_TDLS_DIALOG_TOKEN] = { .type = NLA_U8 },
+	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -861,6 +864,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	}
 	CMD(set_channel, SET_CHANNEL);
 	CMD(set_wds_peer, SET_WDS_PEER);
+	CMD(tdls_mgmt, TDLS_MGMT);
+	CMD(tdls_oper, TDLS_OPER);
 	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
 		CMD(sched_scan_start, START_SCHED_SCAN);
 
@@ -4869,6 +4874,55 @@ static int nl80211_flush_pmksa(struct sk_buff *skb, struct genl_info *info)
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
+	if (!rdev->ops->tdls_mgmt)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_TDLS_ACTION] ||
+	    !info->attrs[NL80211_ATTR_STATUS_CODE] ||
+	    !info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN] ||
+	    !info->attrs[NL80211_ATTR_FRAME] ||
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
+				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
+				    nla_len(info->attrs[NL80211_ATTR_FRAME]));
+}
+
+static int nl80211_tdls_oper(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	enum nl80211_tdls_operation operation;
+	u8 *peer;
+
+	if (!rdev->ops->tdls_oper)
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
@@ -6181,6 +6235,22 @@ static struct genl_ops nl80211_ops[] = {
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

