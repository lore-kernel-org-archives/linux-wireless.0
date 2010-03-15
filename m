Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:18163 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936231Ab0COM7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 08:59:06 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FCvjxv001645
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 07:59:03 -0500
Received: from localhost.localdomain (trdhcp21227.nmp.nokia.com [172.22.212.27])
	by mgw-sa01.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2FCwXrM010482
	for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 14:58:34 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCHv2 1/2] cfg80211: Add connection quality monitoring support to nl80211
Date: Mon, 15 Mar 2010 14:55:50 +0200
Message-Id: <1268657751-1042-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
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
 include/linux/nl80211.h |   36 ++++++++++++++
 include/net/cfg80211.h  |   17 +++++++
 net/wireless/mlme.c     |   12 +++++
 net/wireless/nl80211.c  |  123 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 ++
 5 files changed, 193 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 28ba20f..322776c 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -323,6 +323,10 @@
  *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
  *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
  *	the frame.
+ * @NL80211_CMD_SET_CQM: Connection quality monitor configuration and
+ *      notification. This command is used both as a command (to configure
+ *      a trigger level) and as an event (to indicate the configured level was
+ *      reached.)
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -419,6 +423,8 @@ enum nl80211_commands {
 	NL80211_CMD_SET_POWER_SAVE,
 	NL80211_CMD_GET_POWER_SAVE,
 
+	NL80211_CMD_SET_CQM,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -691,6 +697,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
  *
+ * @NL80211_ATTR_CQM: connection quality monitor configuration in a
+ *	nested attribute with %NL80211_ATTR_CQM_* sub-attributes.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -842,6 +851,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PS_STATE,
 
+	NL80211_ATTR_CQM,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1583,4 +1594,29 @@ enum nl80211_ps_state {
 	NL80211_PS_ENABLED,
 };
 
+/**
+ * enum nl80211_attr_cqm - connection quality monitor attributes
+ * @__NL80211_ATTR_CQM_INVALID: invalid
+ * @NL80211_ATTR_CQM_RSSI_THOLD: RSSI threshold in dBm
+ * @NL80211_ATTR_CQM_RSSI_HYST: RSSI hysteresis in dBm
+ * @NL80211_ATTR_CQM_RSSI_LEVEL: Current level in relation to threshold
+ * @__NL80211_ATTR_CQM_AFTER_LAST: internal
+ * @NL80211_ATTR_CQM_MAX: highest key attribute
+ */
+enum nl80211_attr_cqm {
+	__NL80211_ATTR_CQM_INVALID,
+	NL80211_ATTR_CQM_RSSI_THOLD,
+	NL80211_ATTR_CQM_RSSI_HYST,
+	NL80211_ATTR_CQM_RSSI_LEVEL,
+
+	/* keep last */
+	__NL80211_ATTR_CQM_AFTER_LAST,
+	NL80211_ATTR_CQM_MAX = __NL80211_ATTR_CQM_AFTER_LAST - 1
+};
+
+enum nl80211_cqm_level {
+	NL80211_CQM_LEVEL_HIGH,
+	NL80211_CQM_LEVEL_LOW,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3d134a1..5f48472 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1007,6 +1007,7 @@ struct cfg80211_pmksa {
  *	RSN IE. It allows for faster roaming between WPA2 BSSIDs.
  * @del_pmksa: Delete a cached PMKID.
  * @flush_pmksa: Flush all cached PMKIDs.
+ * @set_cqm_config: Configure cqm RSSI notification threshold.
  *
  */
 struct cfg80211_ops {
@@ -1152,6 +1153,9 @@ struct cfg80211_ops {
 
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
+
+	int	(*set_cqm_config)(struct wiphy *wiphy, struct net_device *dev,
+				  s8 rssi_thold, u8 rssi_hyst);
 };
 
 /*
@@ -2337,4 +2341,17 @@ bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
 void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
 			       const u8 *buf, size_t len, bool ack, gfp_t gfp);
 
+
+/**
+ * cfg80211_cqm_notify - notification of a connection quality monitoring event
+ * @dev: network device
+ * @rssi_level: current level of the RSSI
+ * @gfp: context flags
+ *
+ * This function is called, when a configured connection quality monitoring
+ * event occurs.
+ */
+void cfg80211_cqm_notify(struct net_device *dev,
+			 enum nl80211_cqm_level rssi_level, gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 62bc885..9d7edc8 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -894,3 +894,15 @@ void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
 	nl80211_send_action_tx_status(rdev, dev, cookie, buf, len, ack, gfp);
 }
 EXPORT_SYMBOL(cfg80211_action_tx_status);
+
+void cfg80211_cqm_notify(struct net_device *dev,
+			 enum nl80211_cqm_level rssi_level, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	/* Indicate roaming trigger event to user space */
+	nl80211_send_cqm_notify(rdev, dev, rssi_level, gfp);
+}
+EXPORT_SYMBOL(cfg80211_cqm_notify);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e447db0..d0f4bd4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -149,6 +149,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 };
 
 /* policy for the attributes */
@@ -4778,6 +4779,79 @@ unlock_rtnl:
 	return err;
 }
 
+static struct nla_policy
+nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX+1] __read_mostly = {
+	[NL80211_ATTR_CQM_RSSI_THOLD] = { .type = NLA_U8 },
+	[NL80211_ATTR_CQM_RSSI_HYST] = { .type = NLA_U8 },
+	[NL80211_ATTR_CQM_RSSI_LEVEL] = { .type = NLA_U32 },
+};
+
+static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
+	struct nlattr *cqm;
+	u8 rssi_thold;
+	u8 rssi_hyst;
+	int err;
+
+	cqm = info->attrs[NL80211_ATTR_CQM];
+	if (cqm) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, cqm,
+			       nl80211_attr_cqm_policy);
+	if (err)
+		goto out;
+
+
+	if (!attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
+	    !attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rssi_thold = nla_get_u8(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+	if (rssi_thold > 100) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rssi_hyst = nla_get_u8(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
+	if (rssi_hyst > 10) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rdev;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_cqm_config) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = rdev->ops->set_cqm_config(wdev->wiphy, dev,
+					rssi_thold, -rssi_hyst);
+
+unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+	rtnl_unlock();
+
+out:
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -5082,6 +5156,12 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -5832,6 +5912,49 @@ void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_send_cqm_notify(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev,
+			     enum nl80211_cqm_level rssi_level,
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
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SET_CQM);
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
+	NLA_PUT_U32(msg, NL80211_ATTR_CQM_RSSI_LEVEL, rssi_level);
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
index 4ca5111..93a17c5 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -82,4 +82,9 @@ void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
 				   const u8 *buf, size_t len, bool ack,
 				   gfp_t gfp);
 
+void nl80211_send_cqm_notify(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev,
+			     enum nl80211_cqm_level rssi_level,
+			     gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.6.3.3

