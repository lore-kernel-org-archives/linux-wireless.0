Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:42160 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0CLLha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 06:37:30 -0500
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2CBbFqG015086
	for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 05:37:28 -0600
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2CBb6aC028203
	for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 13:37:07 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 1/2] cfg80211: Add roaming trigger support to nl80211
Date: Fri, 12 Mar 2010 13:34:30 +0200
Message-Id: <1268393671-5498-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1268393671-5498-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268393671-5498-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for basic configuration of a roaming RSSI trigger to the nl80211
interface, and basic support for notifying about trigger events.

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
 include/linux/nl80211.h |   21 ++++++++
 include/net/cfg80211.h  |   33 ++++++++++++
 net/wireless/core.c     |   12 +++++
 net/wireless/mlme.c     |   25 +++++++++
 net/wireless/nl80211.c  |  125 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    5 ++
 6 files changed, 221 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 28ba20f..8154c10 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -323,6 +323,10 @@
  *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
  *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
  *	the frame.
+ * @NL80211_CMD_SET_ROAM_TRIGGER: Roaming RSSI trigger level configuration and
+ *      notification. This command is used both as a command (to configure
+ *      a trigger level) and as an event (to indicate the configured level was
+ *      reached.)
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -419,6 +423,8 @@ enum nl80211_commands {
 	NL80211_CMD_SET_POWER_SAVE,
 	NL80211_CMD_GET_POWER_SAVE,
 
+	NL80211_CMD_SET_ROAM_TRIGGER,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -842,6 +848,11 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PS_STATE,
 
+	NL80211_ATTR_RTRIG_RSSI_STATE,
+	NL80211_ATTR_RTRIG_RSSI_THOLD,
+	NL80211_ATTR_RTRIG_RSSI_HYST,
+	NL80211_ATTR_RTRIG_LEVEL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1583,4 +1594,14 @@ enum nl80211_ps_state {
 	NL80211_PS_ENABLED,
 };
 
+enum nl80211_rtrig_rssi_state {
+	NL80211_RTRIG_RSSI_DISABLED,
+	NL80211_RTRIG_RSSI_ENABLED,
+};
+
+enum nl80211_rtrig_level {
+	NL80211_RTRIG_HIGH,
+	NL80211_RTRIG_LOW,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3d134a1..3d10578 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1007,6 +1007,7 @@ struct cfg80211_pmksa {
  *	RSN IE. It allows for faster roaming between WPA2 BSSIDs.
  * @del_pmksa: Delete a cached PMKID.
  * @flush_pmksa: Flush all cached PMKIDs.
+ * @set_roam_trigger: Configure roaming trigger notification RSSI threshold.
  *
  */
 struct cfg80211_ops {
@@ -1152,6 +1153,10 @@ struct cfg80211_ops {
 
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
+
+	int	(*set_roam_trigger)(struct wiphy *wiphy, struct net_device *dev,
+				    bool rssi_enabled, s8 rssi_thold,
+				    u8 rssi_hyst);
 };
 
 /*
@@ -1491,6 +1496,10 @@ struct wireless_dev {
 	bool ps;
 	int ps_timeout;
 
+	bool rtrig_rssi;
+	s8 rtrig_rssi_thold;
+	u8 rtrig_rssi_hyst;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -2337,4 +2346,28 @@ bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
 void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
 			       const u8 *buf, size_t len, bool ack, gfp_t gfp);
 
+
+/**
+ * enum ieee80211_roam_trigger_level - supported frequency bands
+ *
+ * @IEEE80211_ROAM_TRIGGER_LOW: current RSSI level is below the threshold
+ * @IEEE80211_ROAM_TRIGGER_HIGH: current RSSI level is above the threshold
+ */
+
+enum ieee80211_roam_trigger_level {
+	IEEE80211_ROAM_TRIGGER_LEVEL_LOW,
+	IEEE80211_ROAM_TRIGGER_LEVEL_HIGH,
+};
+
+/**
+ * cfg80211_roam_trigger - notification of a roaming trigger event
+ * @dev: network device
+ * @level: current level of the RSSI
+ * @gfp: context flags
+ *
+ * This function is called when a configured roaming trigger event occurs.
+ */
+void cfg80211_roam_trigger(struct net_device *dev,
+			   enum ieee80211_roam_trigger_level level, gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7fdb940..c8156d6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -713,6 +713,18 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 				wdev->ps = false;
 			}
 
+		wdev->rtrig_rssi = false;
+		wdev->rtrig_rssi_thold = -75;
+		wdev->rtrig_rssi_hyst = 2;
+		if (rdev->ops->set_roam_trigger)
+			if (rdev->ops->set_roam_trigger(wdev->wiphy, dev,
+							wdev->rtrig_rssi,
+							wdev->rtrig_rssi_thold,
+							wdev->rtrig_rssi_hyst)) {
+				/* assume this means it's off */
+				wdev->rtrig_rssi = false;
+			}
+
 		if (!dev->ethtool_ops)
 			dev->ethtool_ops = &cfg80211_ethtool_ops;
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 62bc885..cba6365 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -894,3 +894,28 @@ void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
 	nl80211_send_action_tx_status(rdev, dev, cookie, buf, len, ack, gfp);
 }
 EXPORT_SYMBOL(cfg80211_action_tx_status);
+
+void cfg80211_roam_trigger(struct net_device *dev,
+			   enum ieee80211_roam_trigger_level level, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	enum nl80211_rtrig_level nllevel;
+
+	switch (level) {
+	case IEEE80211_ROAM_TRIGGER_LEVEL_LOW:
+		nllevel = NL80211_RTRIG_LOW;
+		break;
+	case IEEE80211_ROAM_TRIGGER_LEVEL_HIGH:
+		nllevel = NL80211_RTRIG_HIGH;
+		break;
+	default:
+		WARN_ON(1);
+		return;
+	}
+
+	/* Indicate roaming trigger event to user space */
+	nl80211_send_roam_trigger(rdev, dev, nllevel, gfp);
+}
+EXPORT_SYMBOL(cfg80211_roam_trigger);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e447db0..6f5bbd3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -149,6 +149,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_RTRIG_RSSI_STATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_RTRIG_RSSI_THOLD] = { .type = NLA_U8 },
+	[NL80211_ATTR_RTRIG_RSSI_HYST] = { .type = NLA_U8 },
+	[NL80211_ATTR_RTRIG_LEVEL] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -4778,6 +4782,85 @@ unlock_rtnl:
 	return err;
 }
 
+static int nl80211_set_roam_trigger(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	u8 rssi_state;
+	u8 rssi_thold;
+	u8 rssi_hyst;
+
+	bool state;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_RTRIG_RSSI_STATE] &&
+	    !info->attrs[NL80211_ATTR_RTRIG_RSSI_THOLD] &&
+	    !info->attrs[NL80211_ATTR_RTRIG_RSSI_HYST]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rssi_state = nla_get_u32(info->attrs[NL80211_ATTR_RTRIG_RSSI_STATE]);
+	if (rssi_state != NL80211_RTRIG_RSSI_DISABLED &&
+	    rssi_state != NL80211_RTRIG_RSSI_ENABLED) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rssi_thold = nla_get_u8(info->attrs[NL80211_ATTR_RTRIG_RSSI_THOLD]);
+	if (rssi_thold > 100) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rssi_hyst = nla_get_u8(info->attrs[NL80211_ATTR_RTRIG_RSSI_HYST]);
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
+	if (!rdev->ops->set_roam_trigger) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	state = (rssi_state == NL80211_RTRIG_RSSI_ENABLED) ? true : false;
+
+	if (state == wdev->rtrig_rssi &&
+	    wdev->rtrig_rssi_thold == rssi_thold &&
+	    wdev->rtrig_rssi_hyst == -rssi_hyst)
+		goto unlock_rdev;
+
+	wdev->rtrig_rssi = state;
+	wdev->rtrig_rssi_thold = rssi_thold;
+	wdev->rtrig_rssi_hyst = rssi_hyst;
+
+	if (rdev->ops->set_roam_trigger(wdev->wiphy, dev,
+					wdev->rtrig_rssi,
+					wdev->rtrig_rssi_thold,
+					wdev->rtrig_rssi_hyst)) {
+		/* assume this means it's off */
+		wdev->rtrig_rssi = false;
+	}
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
@@ -5082,6 +5165,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		/* can be retrieved by unprivileged users */
 	},
+	{
+		.cmd = NL80211_CMD_SET_ROAM_TRIGGER,
+		.doit = nl80211_set_roam_trigger,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -5832,6 +5921,42 @@ void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_send_roam_trigger(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev,
+			       enum nl80211_rtrig_level level,
+			       gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SET_ROAM_TRIGGER);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_RTRIG_LEVEL, level);
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
index 4ca5111..12c9069 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -82,4 +82,9 @@ void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
 				   const u8 *buf, size_t len, bool ack,
 				   gfp_t gfp);
 
+void nl80211_send_roam_trigger(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev,
+			       enum nl80211_rtrig_level level,
+			       gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.6.3.3

