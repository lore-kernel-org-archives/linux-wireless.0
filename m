Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755082AbcLSK6f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:58:35 -0500
Subject: [PATCH v2] cfg80211: add set/get link loss profile
To: Kalle Valo <kvalo@codeaurora.org>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
 <8737izqw0q.fsf@purkki.adurom.net>
 <b1ab1406-d996-fc03-d0a2-b8028c7c0044@codeaurora.org>
 <8737ipm4jy.fsf@kamboji.qca.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com
From: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Message-ID: <9bdf0a3a-1283-21c5-0739-e0b48dd9ddcc@codeaurora.org> (sfid-20161219_115929_249909_B6FB5EAB)
Date: Mon, 19 Dec 2016 12:58:31 +0200
MIME-Version: 1.0
In-Reply-To: <8737ipm4jy.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 7e41d45179a8762a7d2e1653db35751c19c8c747 Mon Sep 17 00:00:00 2001
From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Date: Sun, 18 Dec 2016 15:06:38 +0200
Subject: [PATCH] cfg80211: add set/get link loss profile

Introduce NL80211_CMD_SET_LINK_LOSS_PROFILE and
NL80211_CMD_GET_LINK_LOSS_PROFILE needed by user space to configure the
link loss profile.
The link loss profile represents the priority of maintaining link up
(connection to AP) in different link quality environments.
This is intended for full mac80211 drivers. Typically link loss detection
is offloaded to firmware, since it requires close monitoring of the RF.
The firmware will disconnect when link quality drops.
There are scenarios that require to lose connection faster once reduced
link quality is detected in order to maintain better user experience.
This can be used in AP and station mode.
Example use case is FST (Fast Session Transfer), where we have a fast
11ad connection but close-range and a backup 11ac connection which is
"always on". In such cases if we detect poor link quality in the active
11ad band we prefer to disconnect and switch to the backup 11ac connection
with the good link quality. This will be reached by setting "aggressive"
profile that will cause more rapid disconnect in such cases.
Three types of behavior for link loss are defined:
LINK_LOSS_PROFILE_RELAXED: prefer maintaining link up even in a poor
link quality environment.
LINK_LOSS_PROFILE_DEFAULT: The default behavior for maintaining link
up vs link quality.
LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link up in a poor link
quality environment.
New cfg80211 API also been added, set/get_link_loss_profile.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 18 ++++++++
 include/net/cfg80211.h                      | 13 ++++++
 include/uapi/linux/nl80211.h                | 32 +++++++++++++
 net/wireless/nl80211.c                      | 70 +++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h                     | 28 ++++++++++++
 net/wireless/trace.h                        | 39 ++++++++++++++++
 6 files changed, 200 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6aa3ff4..681b792 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1499,6 +1499,22 @@ static int wil_cfg80211_set_power_mgmt(struct wiphy *wiphy,
 	return rc;
 }
 
+static int
+wil_cfg80211_set_link_loss_profile(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   enum nl80211_link_loss_profile profile,
+				   const u8 *addr)
+{
+	return -ENOTSUPP;
+}
+
+static enum nl80211_link_loss_profile
+wil_cfg80211_get_link_loss_profile(struct wiphy *wiphy,
+				   struct wireless_dev *wdev, const u8 *addr)
+{
+	return -ENOTSUPP;
+}
+
 static struct cfg80211_ops wil_cfg80211_ops = {
 	.add_virtual_intf = wil_cfg80211_add_iface,
 	.del_virtual_intf = wil_cfg80211_del_iface,
@@ -1528,6 +1544,8 @@ static struct cfg80211_ops wil_cfg80211_ops = {
 	.start_p2p_device = wil_cfg80211_start_p2p_device,
 	.stop_p2p_device = wil_cfg80211_stop_p2p_device,
 	.set_power_mgmt = wil_cfg80211_set_power_mgmt,
+	.set_link_loss_profile = wil_cfg80211_set_link_loss_profile,
+	.get_link_loss_profile = wil_cfg80211_get_link_loss_profile,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ca2ac1c..7c2e420 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2764,6 +2764,10 @@ struct cfg80211_nan_func {
  *	All other parameters must be ignored.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
+ *
+ * @set_link_loss_profile: Set link loss profile for specific connection.
+ * @get_link_loss_profile: Get the current link loss profile of specific
+ *	connection.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3048,6 +3052,15 @@ struct cfg80211_ops {
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
+
+	int	(*set_link_loss_profile)(struct wiphy *wiphy,
+					 struct wireless_dev *wdev,
+					 enum nl80211_link_loss_profile profile,
+					 const u8 *addr);
+	enum nl80211_link_loss_profile	(*get_link_loss_profile)(
+					 struct wiphy *wiphy,
+					 struct wireless_dev *wdev,
+					 const u8 *addr);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d74e10b..7723294 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -894,6 +894,11 @@
  *	does not result in a change for the current association. Currently,
  *	only the %NL80211_ATTR_IE data is used and updated with this command.
  *
+ * @NL80211_CMD_SET_LINK_LOSS_PROFILE: Set link loss profile (behavior) for
+ *	specific connection.
+ * @NL80211_CMD_GET_LINK_LOSS_PROFILE: Get current link loss profile of specific
+ *	connection.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1093,6 +1098,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_CONNECT_PARAMS,
 
+	NL80211_CMD_SET_LINK_LOSS_PROFILE,
+	NL80211_CMD_GET_LINK_LOSS_PROFILE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1980,6 +1988,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_BSSID: The BSSID of the AP. Note that %NL80211_ATTR_MAC is also
  *	used in various commands/events for specifying the BSSID.
  *
+ * @NL80211_ATTR_LINK_LOSS_PROFILE: attribute that indicate the link loss
+ *	behavior using &enum nl80211_link_loss_profile values.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2386,6 +2397,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSSID,
 
+	NL80211_ATTR_LINK_LOSS_PROFILE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5188,4 +5201,23 @@ enum nl80211_nan_match_attributes {
 	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
 };
 
+/**
+ * enum nl80211_link_loss_profile.
+ *
+ * Used by set_link_loss_profile() and get_link_loss_profile()
+ * to set/get link loss behavior.
+ *
+ * @NL80211_LINK_LOSS_PROFILE_RELAXED: prefer maintaining link
+ *	up even in poor link quality environment
+ * @NL80211_LINK_LOSS_PROFILE_DEFAULT: The default behavior for
+ *	maintaining link up vs link quality.
+ * @NL80211_LINK_LOSS_PROFILE_AGGRESSIVE: prefer losing link
+ *	up in poor link quality environment
+ */
+enum nl80211_link_loss_profile {
+	NL80211_LINK_LOSS_PROFILE_RELAXED,
+	NL80211_LINK_LOSS_PROFILE_DEFAULT,
+	NL80211_LINK_LOSS_PROFILE_AGGRESSIVE
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2369265..e160630 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -405,6 +405,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
 	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_LINK_LOSS_PROFILE] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -11817,6 +11818,60 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 	return rdev_set_multicast_to_unicast(rdev, dev, enabled);
 }
 
+static int nl80211_set_link_loss_profile(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	enum nl80211_link_loss_profile profile;
+	const u8 *addr;
+	int ret;
+
+	if (!info->attrs[NL80211_ATTR_LINK_LOSS_PROFILE] ||
+	    !info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	profile = nla_get_u8(info->attrs[NL80211_ATTR_LINK_LOSS_PROFILE]);
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (profile != NL80211_LINK_LOSS_PROFILE_RELAXED &&
+	    profile != NL80211_LINK_LOSS_PROFILE_DEFAULT &&
+	    profile != NL80211_LINK_LOSS_PROFILE_AGGRESSIVE)
+		return -EINVAL;
+
+	if (!rdev->ops->set_link_loss_profile)
+		return -EOPNOTSUPP;
+
+	wdev_lock(wdev);
+	ret = rdev_set_link_loss_profile(rdev, wdev, profile, addr);
+	wdev_unlock(wdev);
+
+	return ret;
+}
+
+static int nl80211_get_link_loss_profile(struct sk_buff *skb,
+					 struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	const u8 *addr;
+	enum nl80211_link_loss_profile profile;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (!rdev->ops->get_link_loss_profile)
+		return -EOPNOTSUPP;
+
+	wdev_lock(wdev);
+	profile = rdev_get_link_loss_profile(rdev, wdev, addr);
+	wdev_unlock(wdev);
+
+	return profile;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -12692,6 +12747,21 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+	.cmd = NL80211_CMD_SET_LINK_LOSS_PROFILE,
+		.doit = nl80211_set_link_loss_profile,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+	.cmd = NL80211_CMD_GET_LINK_LOSS_PROFILE,
+		.doit = nl80211_get_link_loss_profile,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 2f42507..caf0127 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1153,4 +1153,32 @@ rdev_set_coalesce(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int
+rdev_set_link_loss_profile(struct cfg80211_registered_device *rdev,
+			   struct wireless_dev *wdev,
+			   enum nl80211_link_loss_profile profile,
+			   const u8 *addr)
+{
+	int ret;
+
+	trace_rdev_set_link_loss_profile(&rdev->wiphy, wdev, profile, addr);
+	ret = rdev->ops->set_link_loss_profile(&rdev->wiphy, wdev, profile,
+					       addr);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline enum nl80211_link_loss_profile
+rdev_get_link_loss_profile(struct cfg80211_registered_device *rdev,
+			   struct wireless_dev *wdev,
+			   const u8 *addr)
+{
+	enum nl80211_link_loss_profile profile;
+
+	trace_rdev_get_link_loss_profile(&rdev->wiphy, wdev, addr);
+	profile = rdev->ops->get_link_loss_profile(&rdev->wiphy, wdev, addr);
+	trace_rdev_return_int(&rdev->wiphy, profile);
+	return profile;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ea1b47e..3af813b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2230,6 +2230,45 @@ TRACE_EVENT(rdev_tdls_cancel_channel_switch,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
 );
 
+TRACE_EVENT(rdev_set_link_loss_profile,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 enum nl80211_link_loss_profile profile, const u8 *addr),
+	TP_ARGS(wiphy, wdev, profile, addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(enum nl80211_link_loss_profile, profile)
+		MAC_ENTRY(addr)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->profile = profile;
+		MAC_ASSIGN(addr, addr);
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", " MAC_PR_FMT ", PROFILE %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, MAC_PR_ARG(addr),
+		  __entry->profile)
+);
+
+TRACE_EVENT(rdev_get_link_loss_profile,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 const u8 *addr),
+	TP_ARGS(wiphy, wdev, addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		MAC_ENTRY(addr)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", " MAC_PR_FMT, WIPHY_PR_ARG,
+		  WDEV_PR_ARG, MAC_PR_ARG(addr))
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.5.0
