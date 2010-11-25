Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab0KYJDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 04:03:35 -0500
Message-Id: <20101125090254.456149961@sipsolutions.net>
Date: Thu, 25 Nov 2010 10:02:29 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] nl80211/cfg80211: extend mgmt-tx API for off-channel
References: <20101125090228.087298683@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With p2p, it is sometimes necessary to transmit
a frame (typically an action frame) on another
channel than the current channel. Enable this
through the CMD_FRAME API, and allow it to wait
for a response. A new command allows that wait
to be aborted.

However, allow userspace to specify whether or
not it wants to allow off-channel TX, it may
actually want to use the same channel only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   25 ++++++++++++++++-----
 include/net/cfg80211.h  |   11 ++++++---
 net/mac80211/cfg.c      |    7 ++++-
 net/wireless/core.h     |    4 +--
 net/wireless/mlme.c     |    9 ++++---
 net/wireless/nl80211.c  |   57 ++++++++++++++++++++++++++++++++++++++++++------
 6 files changed, 91 insertions(+), 22 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-11-25 08:01:35.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2010-11-25 09:52:57.000000000 +0100
@@ -358,11 +358,16 @@
  *	user space application). %NL80211_ATTR_FRAME is used to specify the
  *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ (and
  *	optionally %NL80211_ATTR_WIPHY_CHANNEL_TYPE) is used to indicate on
- *	which channel the frame is to be transmitted or was received. This
- *	channel has to be the current channel (remain-on-channel or the
- *	operational channel). When called, this operation returns a cookie
- *	(%NL80211_ATTR_COOKIE) that will be included with the TX status event
- *	pertaining to the TX request.
+ *	which channel the frame is to be transmitted or was received. If this
+ *	channel is not the current channel (remain-on-channel or the
+ *	operational channel) the device will switch to the given channel and
+ *	transmit the frame, optionally waiting for a response for the time
+ *	specified using %NL80211_ATTR_DURATION. When called, this operation
+ *	returns a cookie (%NL80211_ATTR_COOKIE) that will be included with the
+ *	TX status event pertaining to the TX request.
+ * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
+ *	command may be used with the corresponding cookie to cancel the wait
+ *	time if it is known that it is no longer necessary.
  * @NL80211_CMD_ACTION: Alias for @NL80211_CMD_FRAME for backward compatibility.
  * @NL80211_CMD_FRAME_TX_STATUS: Report TX status of a management frame
  *	transmitted with %NL80211_CMD_FRAME. %NL80211_ATTR_COOKIE identifies
@@ -493,6 +498,8 @@ enum nl80211_commands {
 	NL80211_CMD_SET_CHANNEL,
 	NL80211_CMD_SET_WDS_PEER,
 
+	NL80211_CMD_FRAME_WAIT_CANCEL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -828,6 +835,12 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_MCAST_RATE: Multicast tx rate (in 100 kbps) for IBSS
  *
+ * @NL80211_ATTR_OFFCHANNEL_TX_OK: For management frame TX, the frame may be
+ *	transmitted on another channel when the channel given doesn't match
+ *	the current channel. If the current channel doesn't match and this
+ *	flag isn't set, the frame will be rejected. This is also used as an
+ *	nl80211 capability flag.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1002,6 +1015,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_MCAST_RATE,
 
+	NL80211_ATTR_OFFCHANNEL_TX_OK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2010-11-25 08:01:35.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-11-25 09:52:20.000000000 +0100
@@ -1134,7 +1134,9 @@ struct cfg80211_pmksa {
  * @cancel_remain_on_channel: Cancel an on-going remain-on-channel operation.
  *	This allows the operation to be terminated prior to timeout based on
  *	the duration value.
- * @mgmt_tx: Transmit a management frame
+ * @mgmt_tx: Transmit a management frame.
+ * @mgmt_tx_cancel_wait: Cancel the wait time from transmitting a management
+ *	frame on another channel
  *
  * @testmode_cmd: run a test mode command
  *
@@ -1291,10 +1293,13 @@ struct cfg80211_ops {
 					    u64 cookie);
 
 	int	(*mgmt_tx)(struct wiphy *wiphy, struct net_device *dev,
-			  struct ieee80211_channel *chan,
+			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
-			  bool channel_type_valid,
+			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, u64 *cookie);
+	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       u64 cookie);
 
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
--- wireless-testing.orig/net/wireless/nl80211.c	2010-11-25 08:01:35.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-11-25 09:53:48.000000000 +0100
@@ -163,16 +163,13 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 	[NL80211_ATTR_AP_ISOLATE] = { .type = NLA_U8 },
-
 	[NL80211_ATTR_WIPHY_TX_POWER_SETTING] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] = { .type = NLA_U32 },
-
 	[NL80211_ATTR_FRAME_TYPE] = { .type = NLA_U16 },
-
 	[NL80211_ATTR_WIPHY_ANTENNA_TX] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_ANTENNA_RX] = { .type = NLA_U32 },
-
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -677,6 +674,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
 	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
 	CMD(mgmt_tx, FRAME);
+	CMD(mgmt_tx_cancel_wait, FRAME_WAIT_CANCEL);
 	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
@@ -698,6 +696,10 @@ static int nl80211_send_wiphy(struct sk_
 
 	nla_nest_end(msg, nl_cmds);
 
+	/* for now at least assume all drivers have it */
+	if (dev->ops->mgmt_tx)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_OFFCHANNEL_TX_OK);
+
 	if (mgmt_stypes) {
 		u16 stypes;
 		struct nlattr *nl_ftypes, *nl_ifs;
@@ -4244,6 +4246,8 @@ static int nl80211_tx_mgmt(struct sk_buf
 	void *hdr;
 	u64 cookie;
 	struct sk_buff *msg;
+	unsigned int wait = 0;
+	bool offchan;
 
 	if (!info->attrs[NL80211_ATTR_FRAME] ||
 	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
@@ -4260,6 +4264,12 @@ static int nl80211_tx_mgmt(struct sk_buf
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
+	if (info->attrs[NL80211_ATTR_DURATION]) {
+		if (!rdev->ops->mgmt_tx_cancel_wait)
+			return -EINVAL;
+		wait = nla_get_u32(info->attrs[NL80211_ATTR_DURATION]);
+	}
+
 	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
 		channel_type = nla_get_u32(
 			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
@@ -4271,6 +4281,8 @@ static int nl80211_tx_mgmt(struct sk_buf
 		channel_type_valid = true;
 	}
 
+	offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
+
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 	chan = rdev_freq_to_chan(rdev, freq, channel_type);
 	if (chan == NULL)
@@ -4287,8 +4299,8 @@ static int nl80211_tx_mgmt(struct sk_buf
 		err = PTR_ERR(hdr);
 		goto free_msg;
 	}
-	err = cfg80211_mlme_mgmt_tx(rdev, dev, chan, channel_type,
-				    channel_type_valid,
+	err = cfg80211_mlme_mgmt_tx(rdev, dev, chan, offchan, channel_type,
+				    channel_type_valid, wait,
 				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
 				    &cookie);
@@ -4307,6 +4319,31 @@ static int nl80211_tx_mgmt(struct sk_buf
 	return err;
 }
 
+static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u64 cookie;
+
+	if (!info->attrs[NL80211_ATTR_COOKIE])
+		return -EINVAL;
+
+	if (!rdev->ops->mgmt_tx_cancel_wait)
+		return -EOPNOTSUPP;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
+
+	return rdev->ops->mgmt_tx_cancel_wait(&rdev->wiphy, dev, cookie);
+}
+
 static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -4877,6 +4914,14 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_FRAME_WAIT_CANCEL,
+		.doit = nl80211_tx_mgmt_cancel_wait,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
--- wireless-testing.orig/net/mac80211/cfg.c	2010-11-25 08:01:35.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-11-25 09:54:02.000000000 +0100
@@ -1552,9 +1552,9 @@ static int ieee80211_cancel_remain_on_ch
 }
 
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
-			     struct ieee80211_channel *chan,
+			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
-			     bool channel_type_valid,
+			     bool channel_type_valid, unsigned int wait,
 			     const u8 *buf, size_t len, u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1565,6 +1565,9 @@ static int ieee80211_mgmt_tx(struct wiph
 	u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
 		    IEEE80211_TX_CTL_REQ_TX_STATUS;
 
+	if (offchan)
+		return -EOPNOTSUPP;
+
 	/* Check that we are on the requested channel for transmission */
 	if (chan != local->tmp_channel &&
 	    chan != local->oper_channel)
--- wireless-testing.orig/net/wireless/core.h	2010-11-25 08:00:39.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2010-11-25 09:52:20.000000000 +0100
@@ -341,9 +341,9 @@ void cfg80211_mlme_unregister_socket(str
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev);
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
-			  struct ieee80211_channel *chan,
+			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
-			  bool channel_type_valid,
+			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, u64 *cookie);
 
 /* SME */
--- wireless-testing.orig/net/wireless/mlme.c	2010-11-25 08:01:35.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2010-11-25 08:02:22.000000000 +0100
@@ -864,9 +864,9 @@ void cfg80211_mlme_purge_registrations(s
 
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
-			  struct ieee80211_channel *chan,
+			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
-			  bool channel_type_valid,
+			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, u64 *cookie)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -946,8 +946,9 @@ int cfg80211_mlme_mgmt_tx(struct cfg8021
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
-	return rdev->ops->mgmt_tx(&rdev->wiphy, dev, chan, channel_type,
-				  channel_type_valid, buf, len, cookie);
+	return rdev->ops->mgmt_tx(&rdev->wiphy, dev, chan, offchan,
+				  channel_type, channel_type_valid,
+				  wait, buf, len, cookie);
 }
 
 bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,


