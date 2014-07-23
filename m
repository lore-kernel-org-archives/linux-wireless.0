Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56527 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbaGWLrV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 07:47:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] cfg80211: add traffic stream API
Date: Wed, 23 Jul 2014 13:47:05 +0200
Message-Id: <1406116026-27514-2-git-send-email-johannes@sipsolutions.net> (sfid-20140723_134725_780259_C8A20C49)
In-Reply-To: <1406116026-27514-1-git-send-email-johannes@sipsolutions.net>
References: <1406116026-27514-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add nl80211 and driver API to validate, add and delete traffic
streams with appropriate settings.

The API calls for userspace doing the action frame handshake
with the peer, and then allows only to set up the parameters
in the driver. To avoid setting up a session only to tear it
down again, the validate API is provided, but the real usage
later can still fail so userspace must be prepared for that.

Change-Id: Ie0fdef0534485e9977dd4a75e8eb9b871cde6eb9
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h    |  3 ++
 include/net/cfg80211.h       | 17 +++++++++
 include/uapi/linux/nl80211.h | 28 ++++++++++++++
 net/wireless/nl80211.c       | 91 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 31 +++++++++++++++
 net/wireless/trace.h         | 45 ++++++++++++++++++++++
 6 files changed, 215 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 72be3753fac5..e63bfd1a752f 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -167,6 +167,9 @@ static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
 
 #define IEEE80211_NUM_TIDS		16
 
+/* number of user priorities 802.11 uses */
+#define IEEE80211_NUM_UPS		8
+
 #define IEEE80211_QOS_CTL_LEN		2
 /* 1d tag mask */
 #define IEEE80211_QOS_CTL_TAG1D_MASK		0x0007
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 38b4ab918ea6..3f5d2c6c1019 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2313,6 +2313,17 @@ struct cfg80211_qos_map {
  * @set_ap_chanwidth: Set the AP (including P2P GO) mode channel width for the
  *	given interface This is used e.g. for dynamic HT 20/40 MHz channel width
  *	changes during the lifetime of the BSS.
+ *
+ * @add_tx_ts: validate (if admitted_time is 0) or add a TX TS to the device
+ *	with the given parameters; action frame exchange has been handled by
+ *	userspace so this just has to modify the TX path to take the TS into
+ *	account.
+ *	If the admitted time is 0 just validate the parameters to make sure
+ *	the session can be created at all; it is valid to just always return
+ *	success for that but that may result in inefficient behaviour (handshake
+ *	with the peer followed by immediate teardown when the addition is later
+ *	rejected)
+ * @del_tx_ts: remove an existing TX TS
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2553,6 +2564,12 @@ struct cfg80211_ops {
 
 	int	(*set_ap_chanwidth)(struct wiphy *wiphy, struct net_device *dev,
 				    struct cfg80211_chan_def *chandef);
+
+	int	(*add_tx_ts)(struct wiphy *wiphy, struct net_device *dev,
+			     u8 tsid, const u8 *peer, u8 user_prio,
+			     u16 admitted_time);
+	int	(*del_tx_ts)(struct wiphy *wiphy, struct net_device *dev,
+			     u8 tsid, const u8 *peer);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f614e8965104..116f458a08c4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -733,6 +733,22 @@
  *	QoS mapping is relevant for IP packets, it is only valid during an
  *	association. This is cleared on disassociation and AP restart.
  *
+ * @NL80211_CMD_ADD_TX_TS: Ask the kernel to add a traffic stream for the given
+ *	%NL80211_ATTR_TSID and %NL80211_ATTR_MAC with %NL80211_ATTR_USER_PRIO
+ *	and %NL80211_ATTR_ADMITTED_TIME parameters.
+ *	Note that the action frame handshake with the AP shall be handled by
+ *	userspace via the normal management RX/TX framework, this only sets
+ *	up the TX TS in the driver/device.
+ *	If the admitted time attribute is not added then the request just checks
+ *	if a subsequent setup could be successful, the intent is to use this to
+ *	avoid setting up a session with the AP when local restrictions would
+ *	make that impossible. However, the subsequent "real" setup may still
+ *	fail even if the check was successful.
+ * @NL80211_CMD_DEL_TX_TS: Remove an existing TS with the %NL80211_ATTR_TSID
+ *	and %NL80211_ATTR_MAC parameters. It isn't necessary to call this
+ *	before removing a station entry entirely, or before disassociating
+ *	or similar, cleanup will happen in the driver/device in this case.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -906,6 +922,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_CH_SWITCH_STARTED_NOTIFY,
 
+	NL80211_CMD_ADD_TX_TS,
+	NL80211_CMD_DEL_TX_TS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1607,6 +1626,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
  *
+ * @NL80211_ATTR_TSID: a TSID value (u8 attribute)
+ * @NL80211_ATTR_USER_PRIO: user priority value (u8 attribute)
+ * @NL80211_ATTR_ADMITTED_TIME: admitted time in units of 32 microseconds
+ *	(per second) (u16 attribute)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1948,6 +1972,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX_CSA_COUNTERS,
 	NL80211_ATTR_TDLS_INITIATOR,
 
+	NL80211_ATTR_TSID,
+	NL80211_ATTR_USER_PRIO,
+	NL80211_ATTR_ADMITTED_TIME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f34446df91df..7d26ae452b50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -395,6 +395,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_PEER_CAPABILITY] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFACE_SOCKET_OWNER] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CSA_C_OFFSETS_TX] = { .type = NLA_BINARY },
+	[NL80211_ATTR_TSID] = { .type = NLA_U8 },
+	[NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
+	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 };
 
 /* policy for the key attributes */
@@ -1514,6 +1517,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			if (rdev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
 				CMD(channel_switch, CHANNEL_SWITCH);
 			CMD(set_qos_map, SET_QOS_MAP);
+			CMD(add_tx_ts, ADD_TX_TS);
 		}
 		/* add into the if now */
 #undef CMD
@@ -9424,6 +9428,77 @@ static int nl80211_set_qos_map(struct sk_buff *skb,
 	return ret;
 }
 
+static int nl80211_add_tx_ts(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const u8 *peer;
+	u8 tsid, up;
+	u16 admitted_time = 0;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_TSID] || !info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_USER_PRIO])
+		return -EINVAL;
+
+	tsid = nla_get_u8(info->attrs[NL80211_ATTR_TSID]);
+	if (tsid >= IEEE80211_NUM_TIDS)
+		return -EINVAL;
+	peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	up = nla_get_u8(info->attrs[NL80211_ATTR_USER_PRIO]);
+	if (up >= IEEE80211_NUM_UPS)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_ADMITTED_TIME]) {
+		admitted_time =
+			nla_get_u16(info->attrs[NL80211_ATTR_ADMITTED_TIME]);
+		if (!admitted_time)
+			return -EINVAL;
+	}
+
+	wdev_lock(wdev);
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		if (wdev->current_bss)
+			break;
+		err = -ENOTCONN;
+		goto out;
+	default:
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = rdev_add_tx_ts(rdev, dev, tsid, peer, up, admitted_time);
+
+ out:
+	wdev_unlock(wdev);
+	return err;
+}
+
+static int nl80211_del_tx_ts(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const u8 *peer;
+	u8 tsid;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_TSID] || !info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	tsid = nla_get_u8(info->attrs[NL80211_ATTR_TSID]);
+	peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	wdev_lock(wdev);
+	err = rdev_del_tx_ts(rdev, dev, tsid, peer);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -10170,6 +10245,22 @@ static __genl_const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_ADD_TX_TS,
+		.doit = nl80211_add_tx_ts,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_TX_TS,
+		.doit = nl80211_del_tx_ts,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 765b3f7b6ad3..6a1867f54f8e 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -915,4 +915,35 @@ rdev_set_ap_chanwidth(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_add_tx_ts(struct cfg80211_registered_device *rdev,
+	       struct net_device *dev, u8 tsid, const u8 *peer,
+	       u8 user_prio, u16 admitted_time)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_add_tx_ts(&rdev->wiphy, dev, tsid, peer,
+			     user_prio, admitted_time);
+	if (rdev->ops->add_tx_ts)
+		ret = rdev->ops->add_tx_ts(&rdev->wiphy, dev, tsid, peer,
+					   user_prio, admitted_time);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
+static inline int
+rdev_del_tx_ts(struct cfg80211_registered_device *rdev,
+	       struct net_device *dev, u8 tsid, const u8 *peer)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_del_tx_ts(&rdev->wiphy, dev, tsid, peer);
+	if (rdev->ops->del_tx_ts)
+		ret = rdev->ops->del_tx_ts(&rdev->wiphy, dev, tsid, peer);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0f0901efbe34..9e30c200992c 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1896,6 +1896,51 @@ TRACE_EVENT(rdev_set_ap_chanwidth,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
+TRACE_EVENT(rdev_add_tx_ts,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u8 tsid, const u8 *peer, u8 user_prio, u16 admitted_time),
+	TP_ARGS(wiphy, netdev, tsid, peer, user_prio, admitted_time),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u8, tsid)
+		__field(u8, user_prio)
+		__field(u16, admitted_time)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->tsid = tsid;
+		__entry->user_prio = user_prio;
+		__entry->admitted_time = admitted_time;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT ", TSID %d, UP %d, time %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->tsid, __entry->user_prio, __entry->admitted_time)
+);
+
+TRACE_EVENT(rdev_del_tx_ts,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u8 tsid, const u8 *peer),
+	TP_ARGS(wiphy, netdev, tsid, peer),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u8, tsid)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->tsid = tsid;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT ", TSID %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->tsid)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.0.0

