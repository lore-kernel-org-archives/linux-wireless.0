Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3GPKpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 06:45:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2] cfg80211: add beacon measurements command
Date: Tue, 16 Jul 2013 13:45:16 +0300
Message-Id: <1373971517-315-2-git-send-email-johannes@sipsolutions.net> (sfid-20130716_124530_633655_046612BB)
In-Reply-To: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
References: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This new nl80211 command allow a user space application to
instruct the WiFi stack to let all the beacons through so
that measurements can be conducted on these beacons (i.e.
RSSI etc...)

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 12 ++++++++++++
 include/uapi/linux/nl80211.h | 10 ++++++++++
 net/wireless/nl80211.c       | 32 +++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      | 13 +++++++++++++
 net/wireless/trace.h         | 17 +++++++++++++++++
 5 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index aeaf6df..019e256 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2139,6 +2139,10 @@ struct cfg80211_update_ft_ies_params {
  * @crit_proto_stop: Indicates critical protocol no longer needs increased link
  *	reliability. This operation can not fail.
  * @set_coalesce: Set coalesce parameters.
+ *
+ * @beacon_measurement: Start / stops the beacon measurement. When enabled,
+ *	beacons should be let through cfg80211 to proceed to measurements (e.g.
+ *	RSSI analysis).
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2376,6 +2380,10 @@ struct cfg80211_ops {
 				   struct wireless_dev *wdev);
 	int	(*set_coalesce)(struct wiphy *wiphy,
 				struct cfg80211_coalesce *coalesce);
+
+	int	(*beacon_measurement)(struct wiphy *wiphy,
+				      struct wireless_dev *wdev,
+				      bool state);
 };
 
 /*
@@ -2441,6 +2449,9 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
+ * @WIPHY_FLAG_SUPPORTS_BEACON_MEAS: Device supports beacon measurements. Should
+ *	be set when the device can let all the beacon through up to cfg80211
+ *	to proceed to measurements (i.e. RSSI measurements).
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -2465,6 +2476,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
+	WIPHY_FLAG_SUPPORTS_BEACON_MEAS		= BIT(23),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index eb68735..1a5edad 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -676,6 +676,9 @@
  * @NL80211_CMD_GET_COALESCE: Get currently supported coalesce rules.
  * @NL80211_CMD_SET_COALESCE: Configure coalesce rules or clear existing rules.
  *
+ * @NL80211_CMD_BEACON_MEASUREMENT: Indicates the beacon measurement is
+ *	started / stopped. Disassociation should stop the measurements.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -841,6 +844,8 @@ enum nl80211_commands {
 	NL80211_CMD_GET_COALESCE,
 	NL80211_CMD_SET_COALESCE,
 
+	NL80211_CMD_BEACON_MEASUREMENT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1469,6 +1474,9 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_COALESCE_RULE: Coalesce rule information.
  *
+ * @NL80211_ATTR_BCON_MEAS_STATE: The state of the beacon measurements. This is
+ *	a flag attribute.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1771,6 +1779,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_COALESCE_RULE,
 
+	NL80211_ATTR_BCON_MEAS_STATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 03d4ef9..c2b43b6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -349,6 +349,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_PEER_AID] = { .type = NLA_U16 },
+	[NL80211_ATTR_BCON_MEAS_STATE] = { .type = NLA_FLAG, },
 };
 
 /* policy for the key attributes */
@@ -8646,6 +8647,27 @@ static int nl80211_crit_protocol_stop(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_beacon_measurement(struct sk_buff *skb,
+				      struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	bool state;
+
+
+	if (!rdev->ops->beacon_measurement ||
+	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_BEACON_MEAS))
+		return -EOPNOTSUPP;
+
+	/* Relevant for associated mgd interfaces only */
+	if (wdev->iftype != NL80211_IFTYPE_STATION || !wdev->current_bss)
+		return -EOPNOTSUPP;
+
+	state = info->attrs[NL80211_ATTR_BCON_MEAS_STATE];
+
+	return rdev_beacon_measurement(rdev, wdev, state);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -9361,7 +9383,15 @@ static struct genl_ops nl80211_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
-	}
+	},
+	{
+		.cmd = NL80211_CMD_BEACON_MEASUREMENT,
+		.doit = nl80211_beacon_measurement,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 9f15f0a..e5b0efb 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -923,4 +923,17 @@ static inline void rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_beacon_measurement(struct cfg80211_registered_device *rdev,
+			struct wireless_dev *wdev, bool state)
+{
+	int ret;
+
+	trace_rdev_beacon_measurement(&rdev->wiphy, wdev, state);
+	ret = rdev->ops->beacon_measurement(&rdev->wiphy, wdev, state);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 09af6eb..5f6e7f0 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1841,6 +1841,23 @@ TRACE_EVENT(rdev_crit_proto_stop,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
 
+TRACE_EVENT(rdev_beacon_measurement,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, bool state),
+	TP_ARGS(wiphy, wdev, state),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(bool, state)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->state = state;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT " %s",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, BOOL_TO_STR(__entry->state))
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.8.0

