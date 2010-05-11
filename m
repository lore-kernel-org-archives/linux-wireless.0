Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:36489 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755959Ab0EKIiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:38:50 -0400
Received: from vs3014.wh2.ocn.ne.jp (125.206.180.187)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0793377126
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 17:38:49 +0900 (JST)
Subject: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Tue, 11 May 2010 17:39:02 +0900
Message-ID: <20100511083900.28289.43864.stgit@tt-desk>
In-Reply-To: <20100511083121.28289.96180.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting TX and RX antenna configuration via nl80211/cfg80211.

The antenna configuration is defined as a bitmap of allowed antennas. This
bitmap is 8 bit at the moment, each bit representing one antenna. If multiple
antennas are selected, the driver may use diversity for receive and transmit.
This allows for a simple, yet flexible configuration interface for antennas,
while drivers may reject configurations they cannot support.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 include/linux/nl80211.h   |   12 +++++
 include/net/cfg80211.h    |    3 +
 include/net/mac80211.h    |    2 +
 net/mac80211/cfg.c        |   16 ++++++
 net/mac80211/driver-ops.h |   21 ++++++++
 net/wireless/nl80211.c    |  114 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 168 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index b7c77f9..46a2c76 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -341,6 +341,9 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_SET_ANTENNA: Set a bitmap of antennas to use.
+ * @NL80211_CMD_GET_ANTENNA: Get antenna configuration from driver.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -441,6 +444,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_CHANNEL,
 
+	NL80211_CMD_SET_ANTENNA,
+	NL80211_CMD_GET_ANTENNA,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -725,6 +731,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_AP_ISOLATE: (AP mode) Do not forward traffic between stations
  *	connected to this BSS.
  *
+ * @NL80211_ATTR_ANTENNA_TX: Bitmap of antennas to use for transmitting.
+ * @NL80211_ATTR_ANTENNA_RX: Bitmap of antennas to use for receiving.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -882,6 +891,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_AP_ISOLATE,
 
+	NL80211_ATTR_ANTENNA_TX,
+	NL80211_ATTR_ANTENNA_RX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b44a2e5..8861f40 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1176,6 +1176,9 @@ struct cfg80211_ops {
 	int	(*set_cqm_rssi_config)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       s32 rssi_thold, u32 rssi_hyst);
+
+	int	(*set_antenna)(struct wiphy *wiphy, u8 tx_ant, u8 rx_ant);
+	int	(*get_antenna)(struct wiphy *wiphy, u8 *tx_ant, u8 *rx_ant);
 };
 
 /*
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9448a5b..1a8f97a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1694,6 +1694,8 @@ struct ieee80211_ops {
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
 #endif
 	void (*flush)(struct ieee80211_hw *hw, bool drop);
+	int (*set_antenna)(struct ieee80211_hw *hw, u8 tx_ant, u8 rx_ant);
+	int (*get_antenna)(struct ieee80211_hw *hw, u8 *tx_ant, u8 *rx_ant);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c7000a6..efd04bc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1560,6 +1560,20 @@ static int ieee80211_action(struct wiphy *wiphy, struct net_device *dev,
 				    channel_type, buf, len, cookie);
 }
 
+static int ieee80211_set_antenna(struct wiphy *wiphy, u8 tx_ant, u8 rx_ant)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_set_antenna(local, tx_ant, rx_ant);
+}
+
+static int ieee80211_get_antenna(struct wiphy *wiphy, u8 *tx_ant, u8 *rx_ant)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_get_antenna(local, tx_ant, rx_ant);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1611,4 +1625,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.action = ieee80211_action,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_antenna = ieee80211_set_antenna,
+	.get_antenna = ieee80211_get_antenna,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 997008e..d6fe1b7 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -373,4 +373,25 @@ static inline void drv_flush(struct ieee80211_local *local, bool drop)
 	if (local->ops->flush)
 		local->ops->flush(&local->hw, drop);
 }
+
+static inline int drv_set_antenna(struct ieee80211_local *local,
+				  u8 tx_ant, u8 rx_ant)
+{
+	int ret = -EOPNOTSUPP;
+	might_sleep();
+	if (local->ops->set_antenna)
+		ret = local->ops->set_antenna(&local->hw, tx_ant, rx_ant);
+	return ret;
+}
+
+static inline int drv_get_antenna(struct ieee80211_local *local,
+				  u8 *tx_ant, u8 *rx_ant)
+{
+	int ret = -EOPNOTSUPP;
+	might_sleep();
+	if (local->ops->get_antenna)
+		ret = local->ops->get_antenna(&local->hw, tx_ant, rx_ant);
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index aaa1aad..dbfc126 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -153,6 +153,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
+	[NL80211_ATTR_ANTENNA_TX] = { .type = NLA_U8 },
+	[NL80211_ATTR_ANTENNA_RX] = { .type = NLA_U8 },
 };
 
 /* policy for the attributes */
@@ -4963,6 +4965,106 @@ out:
 	return err;
 }
 
+static int nl80211_set_antenna(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	int res;
+	u8 rx_ant = 0, tx_ant = 0;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY] ||
+	    !info->attrs[NL80211_ATTR_ANTENNA_TX] ||
+	    !info->attrs[NL80211_ATTR_ANTENNA_RX]) {
+		return -EINVAL;
+	}
+
+	tx_ant = nla_get_u8(info->attrs[NL80211_ATTR_ANTENNA_TX]);
+	rx_ant = nla_get_u8(info->attrs[NL80211_ATTR_ANTENNA_RX]);
+
+	rtnl_lock();
+
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev)) {
+		res = -ENODEV;
+		goto unlock_rtnl;
+	}
+
+	if (!rdev->ops->set_antenna) {
+		res = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	res = rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+
+ unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+
+ unlock_rtnl:
+	rtnl_unlock();
+	return res;
+}
+
+static int nl80211_get_antenna(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct sk_buff *msg;
+	void *hdr;
+	int res;
+	u8 tx_ant, rx_ant;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev)) {
+		res = -ENODEV;
+		goto unlock_rtnl;
+	}
+
+	if (!rdev->ops->get_antenna) {
+		res = -EOPNOTSUPP;
+		goto unlock_rdev;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		res = -ENOMEM;
+		goto unlock_rdev;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_GET_ANTENNA);
+	if (!hdr) {
+		res = -ENOMEM;
+		goto free_msg;
+	}
+
+	res = rdev->ops->get_antenna(&rdev->wiphy, &tx_ant, &rx_ant);
+	if (res)
+		goto free_msg;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_ANTENNA_TX, tx_ant);
+	NLA_PUT_U32(msg, NL80211_ATTR_ANTENNA_RX, rx_ant);
+
+	genlmsg_end(msg, hdr);
+	res = genlmsg_reply(msg, info);
+	goto unlock_rdev;
+
+ nla_put_failure:
+	res = -ENOBUFS;
+
+ free_msg:
+	nlmsg_free(msg);
+
+ unlock_rdev:
+	cfg80211_unlock_rdev(rdev);
+
+ unlock_rtnl:
+	rtnl_unlock();
+	return res;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -5279,6 +5381,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_ANTENNA,
+		.doit = nl80211_set_antenna,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_GET_ANTENNA,
+		.doit = nl80211_get_antenna,
+		.policy = nl80211_policy,
+		/* can be retrieved by unprivileged users */
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {

