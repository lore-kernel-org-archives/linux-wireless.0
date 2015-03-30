Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbbC3OOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:14:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 5/5] cfg80211: provide a function to report a match for NAN
Date: Mon, 30 Mar 2015 17:14:20 +0300
Message-Id: <1427724860-1992-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150330_161440_431527_F5E9B953)
In-Reply-To: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide a function the driver can call to report a match.
This will send the event to the user space.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h       | 24 +++++++++++++
 include/uapi/linux/nl80211.h | 37 ++++++++++++++++++++
 net/wireless/nl80211.c       | 82 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 143 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 56ed869..8913c2b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5192,6 +5192,30 @@ wiphy_ext_feature_isset(struct wiphy *wiphy,
 	return (ft_byte & BIT(ftidx % 8)) != 0;
 }
 
+/**
+ * cfg80211_nan_match - report a match for a NAN function.
+ * @wdev: the wireless device reporting the match
+ * @type: the type of the function that had a match. If it is
+ *	%NL80211_NAN_FUNC_SUBSCRIBE it means that we heard a publisher.
+ *	If it is %NL80211_NAN_FUNC_PUBLISH, it means that we replied to
+ *	an active subscriber with a solicited publish.
+ *	If it is %NL80211_NAN_FUNC_FOLLOW_UP, we received a follow up.
+ * @inst_id: the local instance id
+ * @peer_inst_id: the instance id of the peer's function
+ * @addr: the MAC address of the peer
+ * @info: the Service Specific Info from the peer (if any)
+ * @info_len: the length of the &info
+ * @gfp: allocation flags
+ *
+ * This function reports that the a NAN function had a match. This
+ * can be a subscribe that had a match or a solicited publish that
+ * was sent. It can also be a follow up that was received.
+ */
+void cfg80211_nan_match(struct wireless_dev *wdev,
+			enum nl80211_nan_function_type type,
+			u8 inst_id, u8 peer_inst_id, const u8 *addr,
+			const u8 *info, u8 info_len, gfp_t gfp);
+
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 471879d..e9aaf1e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -815,6 +815,8 @@
  * @NL80211_CMD_CHANGE_NAN_MASTER_PREF: Changes the master preference while NAN
  *	is operational. It must contain a valid %NL80211_ATTR_NAN_MASTER_PREF
  *	attribute.
+ * @NL80211_CMD_NAN_FUNC_MATCH: Notification sent when a match is reported.
+ *	This will contain a %NL80211_ATTR_NAN_MATCH nested attribute.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1007,6 +1009,7 @@ enum nl80211_commands {
 	NL80211_CMD_ADD_NAN_FUNCTION,
 	NL80211_CMD_RM_NAN_FUNCTION,
 	NL80211_CMD_CHANGE_NAN_MASTER_PREF,
+	NL80211_CMD_NAN_MATCH,
 
 	/* add new commands above here */
 
@@ -1773,6 +1776,8 @@ enum nl80211_commands {
  *	attribute.
  * @NL80211_ATTR_NAN_FUNC_INST_ID: the instance id of a %NL80211_ATTR_NAN_FUNC.
  *	Its type is u8 and it cannot be 0.
+ * @NL80211_ATTR_NAN_MATCH: used to report a match. This is a nested attribute.
+ *	See &enum nl80211_nan_match_attributes.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2144,6 +2149,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_MASTER_PREF,
 	NL80211_ATTR_NAN_FUNC,
 	NL80211_ATTR_NAN_FUNC_INST_ID,
+	NL80211_ATTR_NAN_MATCH,
 	
 	NL80211_ATTR_REG_INDOOR,
 
@@ -4728,4 +4734,35 @@ enum nl80211_nan_srf_attributes {
 	NL80211_NAN_SRF_ATTR_MAX = NUM_NL80211_NAN_SRF_ATTR - 1,
 };
 
+/**
+ * enum nl80211_nan_match_attributes - NAN match attributes
+ * @__NL80211_NAN_MATCH_INVALID: invalid
+ * @NL80211_NAN_MATCH_FUNC_TYPE: &enum nl80211_nan_function_type (u8). This is
+ *	the type of the function which had a match.
+ * @NL80211_NAN_MATCH_INSTANCE_ID: The instance ID of the local function that
+ *	had a match. This is a u8.
+ * @NL80211_NAN_MATCH_PEER_INSTANCE_ID: The instance ID of the peer's function
+ *	that caused the match. This is a u8.
+ *	specified in NAN spec. This is a binary attribute.
+ * @NL80211_NAN_MATCH_MAC: The MAC address of the peer. This attribute is
+ *	binary.
+ * @NL80211_NAN_MATCH_SERVICE_INFO: array of bytes describing the peer's
+ *	service specific info. This is a binary attribute.
+ *
+ * @NUM_NL80211_NAN_MATCH_ATTR: internal
+ * @NL80211_NAN_MATCH_ATTR_MAX: highest NAN match attribute
+ */
+enum nl80211_nan_match_attributes {
+	__NL80211_NAN_MATCH_INVALID,
+	NL80211_NAN_MATCH_FUNC_TYPE,
+	NL80211_NAN_MATCH_INSTANCE_ID,
+	NL80211_NAN_MATCH_PEER_INSTANCE_ID,
+	NL80211_NAN_MATCH_MAC,
+	NL80211_NAN_MATCH_SERVICE_INFO,
+
+	/* keep last */
+	NUM_NL80211_NAN_MATCH_ATTR,
+	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_FUNC_ATTR - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f1cd4e3..22162d1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -509,6 +509,20 @@ nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
 	[NL80211_NAN_FUNC_TX_MATCH_FILTER] = { .type = NLA_NESTED },
 };
 
+/* policy for NAN match attributes */
+static const struct nla_policy
+nl80211_nan_match_policy[NL80211_NAN_MATCH_ATTR_MAX + 1] = {
+	[NL80211_NAN_MATCH_FUNC_TYPE] = { .type = NLA_U8 },
+	[NL80211_NAN_MATCH_INSTANCE_ID] = { .type = NLA_U8 },
+	[NL80211_NAN_MATCH_PEER_INSTANCE_ID] = { .type = NLA_U8 },
+	[NL80211_NAN_MATCH_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[NL80211_NAN_MATCH_SERVICE_INFO] = {
+		.type = NLA_BINARY,
+		.len = NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN
+	},
+
+};
+
 /* policy for Service Response Filter attributes */
 static const struct nla_policy
 nl80211_nan_srf_policy[NL80211_NAN_SRF_ATTR_MAX + 1] = {
@@ -10145,6 +10159,74 @@ static int nl80211_nan_change_master_pref(struct sk_buff *skb,
 	return rdev_nan_change_master_pref(rdev, wdev, master_pref);
 }
 
+static void
+nl80211_send_nan_match(struct cfg80211_registered_device *rdev,
+		       struct wireless_dev *wdev,
+		       enum nl80211_nan_function_type type,
+		       u8 inst_id, u8 peer_inst_id, const u8 *addr,
+		       const u8 *info, u8 info_len, gfp_t gfp)
+{
+	struct nlattr *match;
+	struct sk_buff *msg;
+	void *hdr;
+
+	if (WARN_ON(!inst_id || !peer_inst_id || !addr))
+		return;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NAN_MATCH);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    (wdev->netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+					 wdev->netdev->ifindex)) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)))
+		goto nla_put_failure;
+
+	match = nla_nest_start(msg, NL80211_ATTR_NAN_MATCH);
+	if (!match)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_MATCH_FUNC_TYPE, type) ||
+	    nla_put_u8(msg, NL80211_NAN_MATCH_INSTANCE_ID, inst_id) ||
+	    nla_put_u8(msg, NL80211_NAN_MATCH_PEER_INSTANCE_ID, peer_inst_id) ||
+	    nla_put(msg, NL80211_NAN_MATCH_MAC, ETH_ALEN, addr))
+		goto nla_put_failure;
+
+	if (info && info_len &&
+	    nla_put(msg, NL80211_NAN_MATCH_SERVICE_INFO, info_len, info))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+void cfg80211_nan_match(struct wireless_dev *wdev,
+			enum nl80211_nan_function_type type,
+			u8 inst_id, u8 peer_inst_id, const u8 *addr,
+			const u8 *info, u8 info_len, gfp_t gfp)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	nl80211_send_nan_match(rdev, wdev, type, inst_id, peer_inst_id, addr,
+			       info, info_len, gfp);
+}
+EXPORT_SYMBOL(cfg80211_nan_match);
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
-- 
1.9.1

