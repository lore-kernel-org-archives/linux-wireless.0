Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2425 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755134Ab3BVJH4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 04:07:56 -0500
From: "Piotr Haber" <phaber@broadcom.com>
To: linux-wireless@vger.kernel.org
cc: "Piotr Haber" <phaber@broadcom.com>
Subject: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
Date: Fri, 22 Feb 2013 10:08:11 +0100
Message-ID: <1361524092-4814-2-git-send-email-phaber@broadcom.com> (sfid-20130222_100804_524805_03F665CB)
In-Reply-To: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
References: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices share antenna/analog front end between Wifi
and Bluetooth. The hardware coexistence interface allows
them to do so, but there are situations when it would
be beneficial if software had a way to have influence on it
as well. It can be used to protect time sensitive
traffic in presence of Bluetooth voice stream,
for an example EAPOL handshake or DHCP negotiation.

This patch adds new attribute to SET_WIPHY command
and a new field in struct wiphy to allow control of the
coexistence behavior. Devices that do not share resources
with Bluetooth can ignore this parameter.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Piotr Haber <phaber@broadcom.com>
---
 include/net/cfg80211.h       |    4 ++++
 include/uapi/linux/nl80211.h |   20 ++++++++++++++++++++
 net/wireless/nl80211.c       |   22 +++++++++++++++++++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 36e076e..3db21be 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1526,6 +1526,7 @@ struct cfg80211_connect_params {
  * @WIPHY_PARAM_FRAG_THRESHOLD: wiphy->frag_threshold has changed
  * @WIPHY_PARAM_RTS_THRESHOLD: wiphy->rts_threshold has changed
  * @WIPHY_PARAM_COVERAGE_CLASS: coverage class changed
+ * @WIPHY_PARAM_BTCOEX: Bluetooth coexistence mode changed
  */
 enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_SHORT		= 1 << 0,
@@ -1533,6 +1534,7 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_FRAG_THRESHOLD	= 1 << 2,
 	WIPHY_PARAM_RTS_THRESHOLD	= 1 << 3,
 	WIPHY_PARAM_COVERAGE_CLASS	= 1 << 4,
+	WIPHY_PARAM_BTCOEX_MODE		= 1 << 5,
 };
 
 /*
@@ -2322,6 +2324,7 @@ struct wiphy_wowlan_support {
  * @max_sched_scan_ie_len: same as max_scan_ie_len, but for scheduled
  *	scans
  * @coverage_class: current coverage class
+ * @btcoex_mode: Wifi-Bluetooth coexistence mode
  * @fw_version: firmware version for ethtool reporting
  * @hw_version: hardware version for ethtool reporting
  * @max_num_pmkids: maximum number of PMKIDs supported by device
@@ -2401,6 +2404,7 @@ struct wiphy {
 	u32 frag_threshold;
 	u32 rts_threshold;
 	u8 coverage_class;
+	enum nl80211_btcoex_mode btcoex_mode;
 
 	char fw_version[ETHTOOL_BUSINFO_LEN];
 	u32 hw_version;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5b7dbc1..a96e1c9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1336,6 +1336,9 @@ enum nl80211_commands {
  *	number of MAC addresses that a device can support for MAC
  *	ACL.
  *
+ * @NL80211_ATTR_WIPHY_BTCOEX_MODE: u8 attribute to control
+ *	Wifi - Bluetooth coexistence mode
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1614,6 +1617,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MAC_ACL_MAX,
 
+	NL80211_ATTR_WIPHY_BTCOEX_MODE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3323,4 +3328,19 @@ enum nl80211_acl_policy {
 	NL80211_ACL_POLICY_DENY_UNLESS_LISTED,
 };
 
+/**
+ * enum nl80211_btcoex_mode - Bluetooth coexistence mode
+ *
+ * Control Wifi - Bluetooth coexistence mode,
+ * to be used with %NL80211_ATTR_WIPHY_BTCOEX_MODE.
+ *
+ * @NL80211_BTCOEX_ENABLED: enable coexistence
+ * @NL80211_BTCOEX_DISABLED: disable coexistence, give Wifi
+ *	traffic priority over Bluetooth
+ */
+enum nl80211_btcoex_mode {
+	NL80211_BTCOEX_ENABLED,
+	NL80211_BTCOEX_DISABLED,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b5978ab..f8f99ef 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -367,6 +367,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_P2P_OPPPS] = { .type = NLA_U8 },
 	[NL80211_ATTR_ACL_POLICY] = {. type = NLA_U32 },
 	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_WIPHY_BTCOEX_MODE] = { .type = NLA_U8},
 };
 
 /* policy for the key attributes */
@@ -914,7 +915,9 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	    nla_put_u16(msg, NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
 			dev->wiphy.max_sched_scan_ie_len) ||
 	    nla_put_u8(msg, NL80211_ATTR_MAX_MATCH_SETS,
-		       dev->wiphy.max_match_sets))
+		       dev->wiphy.max_match_sets) ||
+	    nla_put_u8(msg, NL80211_ATTR_WIPHY_BTCOEX_MODE,
+		       dev->wiphy.btcoex_mode))
 		goto nla_put_failure;
 
 	if ((dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN) &&
@@ -1528,6 +1531,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	u8 retry_short = 0, retry_long = 0;
 	u32 frag_threshold = 0, rts_threshold = 0;
 	u8 coverage_class = 0;
+	enum nl80211_btcoex_mode btcoex_mode = NL80211_BTCOEX_ENABLED;
 
 	/*
 	 * Try to find the wiphy and netdev. Normally this
@@ -1745,10 +1749,22 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		changed |= WIPHY_PARAM_COVERAGE_CLASS;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_BTCOEX_MODE]) {
+		btcoex_mode = nla_get_u8(
+			info->attrs[NL80211_ATTR_WIPHY_BTCOEX_MODE]);
+		if (btcoex_mode != NL80211_BTCOEX_ENABLED &&
+		    btcoex_mode != NL80211_BTCOEX_DISABLED) {
+			result = -EINVAL;
+			goto bad_res;
+		}
+		changed |= WIPHY_PARAM_BTCOEX_MODE;
+	}
+
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
 		u32 old_frag_threshold, old_rts_threshold;
 		u8 old_coverage_class;
+		enum nl80211_btcoex_mode old_btcoex_mode;
 
 		if (!rdev->ops->set_wiphy_params) {
 			result = -EOPNOTSUPP;
@@ -1760,6 +1776,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		old_frag_threshold = rdev->wiphy.frag_threshold;
 		old_rts_threshold = rdev->wiphy.rts_threshold;
 		old_coverage_class = rdev->wiphy.coverage_class;
+		old_btcoex_mode = rdev->wiphy.btcoex_mode;
 
 		if (changed & WIPHY_PARAM_RETRY_SHORT)
 			rdev->wiphy.retry_short = retry_short;
@@ -1771,6 +1788,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.rts_threshold = rts_threshold;
 		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 			rdev->wiphy.coverage_class = coverage_class;
+		if (changed & WIPHY_PARAM_BTCOEX_MODE)
+			rdev->wiphy.btcoex_mode = btcoex_mode;
 
 		result = rdev_set_wiphy_params(rdev, changed);
 		if (result) {
@@ -1779,6 +1798,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.frag_threshold = old_frag_threshold;
 			rdev->wiphy.rts_threshold = old_rts_threshold;
 			rdev->wiphy.coverage_class = old_coverage_class;
+			rdev->wiphy.btcoex_mode = old_btcoex_mode;
 		}
 	}
 
-- 
1.7.9.5


