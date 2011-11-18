Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51538 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1KRLCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:02:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv3 2/3] wireless: Add NoAck per tid Support
Date: Fri, 18 Nov 2011 12:01:47 +0100
Message-Id: <1321614110-32392-3-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111118_120217_968887_FE99736B)
In-Reply-To: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch contains the configuration changes in nl80211/cfg80211.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 include/linux/nl80211.h |   10 ++++++++++
 include/net/cfg80211.h  |    6 ++++++
 net/wireless/nl80211.c  |   28 ++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f9261c2..b99e50d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -538,6 +538,9 @@
  *	OLBC handling in hostapd. Beacons are reported in %NL80211_CMD_FRAME
  *	messages. Note that per PHY only one application may register.
  *
+ * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
+ *      No Acknowledgement Policy should be applied.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -675,6 +678,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_UNEXPECTED_4ADDR_FRAME,
 
+	NL80211_CMD_SET_NOACK_MAP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1170,6 +1175,9 @@ enum nl80211_commands {
  *	probe-response frame. The DA field in the 802.11 header is zero-ed out,
  *	to be filled by the FW.
  *
+ * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
+ *      up to 16 TIDs.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1408,6 +1416,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PROBE_RESP,
 
+	NL80211_ATTR_NOACK_MAP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8d7ba09..2720f2e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1442,6 +1442,8 @@ struct cfg80211_gtk_rekey_data {
  *
  * @probe_client: probe an associated client, must return a cookie that it
  *	later passes to cfg80211_probe_status().
+ *
+ * @set_noack_map: Set the NoAck Map for the TIDs.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1635,6 +1637,10 @@ struct cfg80211_ops {
 	int	(*probe_client)(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *peer, u64 *cookie);
 
+	int	(*set_noack_map)(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  u16 noack_map);
+
 	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6bc7c4b..a0c2c13 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -199,6 +199,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_DONT_WAIT_FOR_ACK] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PROBE_RESP] = { .type = NLA_BINARY,
 				      .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+
 };
 
 /* policy for the key attributes */
@@ -1743,6 +1745,23 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	return rdev->ops->del_virtual_intf(&rdev->wiphy, dev);
 }
 
+static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u16 noack_map;
+
+	if (!info->attrs[NL80211_ATTR_NOACK_MAP])
+		return -EINVAL;
+
+	if (!rdev->ops->set_noack_map)
+		return -EOPNOTSUPP;
+
+	noack_map = nla_get_u16(info->attrs[NL80211_ATTR_NOACK_MAP]);
+
+	return rdev->ops->set_noack_map(&rdev->wiphy, dev, noack_map);
+}
+
 struct get_key_cookie {
 	struct sk_buff *msg;
 	int error;
@@ -6529,6 +6548,15 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_NOACK_MAP,
+		.doit = nl80211_set_noack_map,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.7.3

