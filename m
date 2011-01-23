Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65238 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1AWVDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 16:03:11 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so3406578fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 13:03:10 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 2/6] nl80211: Pass probe response data to drivers
Date: Sun, 23 Jan 2011 23:02:55 +0200
Message-Id: <1295816579-28925-3-git-send-email-arik@wizery.com>
In-Reply-To: <1295816579-28925-1-git-send-email-arik@wizery.com>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow usermode to pass probe-response data. This data can be used as a
template probe-response offloading.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/linux/nl80211.h |    9 +++++++++
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 821ffb9..ba19c4b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -410,6 +410,9 @@
  *	notification. This event is used to indicate that an unprotected
  *	disassociation frame was dropped when MFP is in use.
  *
+ * @NL80211_CMD_SET_PROBE_RESP: Set a Probe Response template to an access
+ *	point interface
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -522,6 +525,8 @@ enum nl80211_commands {
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
+	NL80211_CMD_SET_PROBE_RESP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -887,6 +892,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_MESH_CONFIG: Mesh configuration parameters, a nested attribute
  *	containing attributes from &enum nl80211_meshconf_params.
  *
+ * @NL80211_ATTR_PROBE_RESP: Probe Response template data
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1074,6 +1081,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_TX,
 	NL80211_ATTR_WIPHY_ANTENNA_AVAIL_RX,
 
+	NL80211_ATTR_PROBE_RESP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 03b1b0c..8b3f427 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1366,6 +1366,9 @@ struct cfg80211_ops {
 
 	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
 	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
+
+	int	(*set_probe_resp)(struct wiphy *wiphy, struct net_device *dev,
+				  u8 *resp, size_t resp_len);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ce5453d..50151a2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -172,6 +172,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_PROBE_RESP] = { .type = NLA_BINARY,
+				      .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* policy for the key attributes */
@@ -1917,6 +1919,28 @@ static int nl80211_del_beacon(struct sk_buff *skb, struct genl_info *info)
 	return rdev->ops->del_beacon(&rdev->wiphy, dev);
 }
 
+static int nl80211_set_probe_resp(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u8 *resp;
+	size_t resp_len;
+
+	if (!rdev->ops->set_probe_resp)
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_PROBE_RESP])
+		return -EINVAL;
+
+	resp = nla_data(info->attrs[NL80211_ATTR_PROBE_RESP]);
+	resp_len = nla_len(info->attrs[NL80211_ATTR_PROBE_RESP]);
+
+	return rdev->ops->set_probe_resp(&rdev->wiphy, dev, resp, resp_len);
+}
+
 static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_AUTHORIZED] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_SHORT_PREAMBLE] = { .type = NLA_FLAG },
@@ -5266,6 +5290,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_PROBE_RESP,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.doit = nl80211_set_probe_resp,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.1

