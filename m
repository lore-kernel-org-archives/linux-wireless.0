Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:46714 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab0CVKUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 06:20:15 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2MAJi4o014885
	for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 12:20:13 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: [RFC PATCHv6 1/2] cfg80211: Add connection quality monitoring support to nl80211
Date: Mon, 22 Mar 2010 12:15:42 +0200
Message-Id: <1269252943-2450-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for basic configuration of a connection quality monitoring to the
nl80211 interface, and basic support for notifying about triggered monitoring
events.

Via this interface a user-space connection manager may configure and receive
pre-warning events of deteriorating WLAN connection quality, and start
preparing for roaming in advance, before the connection is already lost.

An example usage of such a trigger is starting scanning for nearby AP's in
an attempt to find one with better connection quality, and associate to it
before the connection characteristics of the existing connection become too bad
or the association is even lost, leading in a prolonged delay in connectivity.

The interface currently supports only RSSI, but it could be later extended
to include other parameters, such as signal-to-noise ratio, if need for that
arises.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/linux/nl80211.h |   46 ++++++++++++++++
 include/net/cfg80211.h  |   19 +++++++
 net/wireless/mlme.c     |   13 +++++
 net/wireless/nl80211.c  |  131 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    6 ++
 5 files changed, 215 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 28ba20f..8994759 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -323,6 +323,12 @@
  *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
  *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
  *	the frame.
+ * @NL80211_CMD_SET_CQM: Connection quality monitor configuration. This command
+ *	is used to configure connection quality monitoring notification trigger
+ *	levels.
+ * @NL80211_CMD_NOTIFY_CQM: Connection quality monitor notification. This
+ *	command is used as an event to indicate the that a trigger level was
+ *	reached.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -419,6 +425,9 @@ enum nl80211_commands {
 	NL80211_CMD_SET_POWER_SAVE,
 	NL80211_CMD_GET_POWER_SAVE,
 
+	NL80211_CMD_SET_CQM,
+	NL80211_CMD_NOTIFY_CQM,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -691,6 +700,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
  *
+ * @NL80211_ATTR_CQM: connection quality monitor configuration in a
+ *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -842,6 +854,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PS_STATE,
 
+	NL80211_ATTR_CQM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1583,4 +1597,36 @@ enum nl80211_ps_state {
 	NL80211_PS_ENABLED,
 };
 
+/**
+ * enum nl80211_attr_cqm - connection quality monitor attributes
+ * @__NL80211_ATTR_CQM_INVALID: invalid
+ * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm (zero to disable)
+ * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm
+ * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
+ * @__NL80211_ATTR_CQM_AFTER_LAST: internal
+ * @NL80211_ATTR_CQM_MAX: highest key attribute
+ */
+enum nl80211_attr_cqm {
+	__NL80211_ATTR_CQM_INVALID,
+	NL80211_ATTR_CQM_RSSI_THOLD,
+	NL80211_ATTR_CQM_RSSI_HYST,
+	NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
+
+	/* keep last */
+	__NL80211_ATTR_CQM_AFTER_LAST,
+	NL80211_ATTR_CQM_MAX = __NL80211_ATTR_CQM_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_cqm_rssi_threshold_event - RSSI threshold event
+ * @NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW - The RSSI level is lower than the
+ *      configured threshold
+ * @NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH - The RSSI is higher than the
+ *      configured threshold
+ */
+enum nl80211_cqm_rssi_threshold_event {
+	NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+	NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3d134a1..868cfd3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1007,6 +1007,7 @@ struct cfg80211_pmksa {
  *	RSN IE. It allows for faster roaming between WPA2 BSSIDs.
  * @del_pmksa: Delete a cached PMKID.
  * @flush_pmksa: Flush all cached PMKIDs.
+ * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
  *
  */
 struct cfg80211_ops {
@@ -1152,6 +1153,10 @@ struct cfg80211_ops {
 
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
+
+	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       s32 rssi_thold, u32 rssi_hyst);
 };
 
 /*
@@ -2337,4 +2342,18 @@ bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
 void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
 			       const u8 *buf, size_t len, bool ack, gfp_t gfp);
 
+
+/**
+ * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
+ * @dev: network device
+ * @rssi_event: the triggered RSSI event
+ * @gfp: context flags
+ *
+ * This function is called when a configured connection quality monitoring
+ * rssi threshold reached event occurs.
+ */
+void cfg80211_cqm_rssi_notify(struct net_device *dev,
+			      enum nl80211_cqm_rssi_threshold_event rssi_event,
+			      gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 62bc885..0855f0d 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -894,3 +894,16 @@ void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
 	nl80211_send_action_tx_status(rdev, dev, cookie, buf, len, ack, gfp);
 }
 EXPORT_SYMBOL(cfg80211_action_tx_status);
+
+void cfg80211_cqm_rssi_notify(struct net_device *dev,
+			      enum nl80211_cqm_rssi_threshold_event rssi_event,
+			      gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	/* Indicate roaming trigger event to user space */
+	nl80211_send_cqm_rssi_notify(rdev, dev, rssi_event, gfp);
+}
+EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e447db0..a7fc3d8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -149,6 +149,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 };
 
 /* policy for the attributes */
@@ -4778,6 +4779,84 @@ unlock_rtnl:
 	return err;
 }
 
+static struct nla_policy
+nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] __read_mostly = {
+	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT] = { .type = NLA_U32 },
+};
+
+static int nl80211_set_cqm_rssi(struct genl_info *info,
+				s32 threshold, u32 hysteresis)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	int err;
+
+	if (threshold > 0)
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rdev;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_cqm_rssi_config) {
+		err = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	err = rdev->ops->set_cqm_rssi_config(wdev->wiphy, dev,
+					     threshold, hysteresis);
+
+unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+	rtnl_unlock();
+
+	return err;
+}
+
+static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
+	struct nlattr *cqm;
+	int err;
+
+	cqm = info->attrs[NL80211_ATTR_CQM];
+	if (!cqm) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, cqm,
+			       nl80211_attr_cqm_policy);
+	if (err)
+		goto out;
+
+	if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
+	    attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
+		s32 threshold;
+		u32 hysteresis;
+		threshold = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+		hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
+		err = nl80211_set_cqm_rssi(info, threshold, hysteresis);
+	} else
+		err = -EINVAL;
+
+out:
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -5082,6 +5161,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 	},
+	{
+		.cmd = NL80211_CMD_SET_CQM,
+		.doit = nl80211_set_cqm,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -5832,6 +5917,52 @@ void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void
+nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev,
+			     enum nl80211_cqm_rssi_threshold_event rssi_event,
+			     gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct nlattr *pinfoattr;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_CQM);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_CQM);
+	if (!pinfoattr)
+		goto nla_put_failure;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
+		    rssi_event);
+
+	nla_nest_end(msg, pinfoattr);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 4ca5111..2ad7fbc 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -82,4 +82,10 @@ void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
 				   const u8 *buf, size_t len, bool ack,
 				   gfp_t gfp);
 
+void
+nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev,
+			     enum nl80211_cqm_rssi_threshold_event rssi_event,
+			     gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.6.3.3

