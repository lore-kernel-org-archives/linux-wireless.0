Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbZLWMXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:23:11 -0500
Message-Id: <20091223121617.157382560@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH next 12/18] cfg80211: add remain-on-channel command
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <jouni.malinen@atheros.com>

Add new commands for requesting the driver to remain awake
on a specified channel for the specified amount of time
(and another command to cancel such an operation). This
can be used to implement userspace-controlled off-channel
operations, like Public Action frame exchange on another
channel than the operation channel.

The off-channel operation should behave similarly to scan,
i.e. the local station (if associated) moves into power
save mode to request the AP to buffer frames for it and
then moves to the other channel to allow the off-channel
operation to be completed. The duration parameter can be
used to request enough time to receive a response from
the target station.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |   36 +++++++
 include/net/cfg80211.h  |   47 ++++++++++
 net/wireless/chan.c     |   41 +++++----
 net/wireless/core.h     |    3 
 net/wireless/mlme.c     |   27 +++++
 net/wireless/nl80211.c  |  218 +++++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h  |   11 ++
 7 files changed, 368 insertions(+), 15 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-12-23 13:10:05.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2009-12-23 13:11:25.000000000 +0100
@@ -270,6 +270,31 @@
  * @NL80211_CMD_SET_WIPHY_NETNS: Set a wiphy's netns. Note that all devices
  *	associated with this wiphy must be down and will follow.
  *
+ * @NL80211_CMD_REMAIN_ON_CHANNEL: Request to remain awake on the specified
+ *	channel for the specified amount of time. This can be used to do
+ *	off-channel operations like transmit a Public Action frame and wait for
+ *	a response while being associated to an AP on another channel.
+ *	%NL80211_ATTR_WIPHY or %NL80211_ATTR_IFINDEX is used to specify which
+ *	radio is used. %NL80211_ATTR_WIPHY_FREQ is used to specify the
+ *	frequency for the operation and %NL80211_ATTR_WIPHY_CHANNEL_TYPE may be
+ *	optionally used to specify additional channel parameters.
+ *	%NL80211_ATTR_DURATION is used to specify the duration in milliseconds
+ *	to remain on the channel. This command is also used as an event to
+ *	notify when the requested duration starts (it may take a while for the
+ *	driver to schedule this time due to other concurrent needs for the
+ *	radio).
+ *	When called, this operation returns a cookie (%NL80211_ATTR_COOKIE)
+ *	that will be included with any events pertaining to this request;
+ *	the cookie is also used to cancel the request.
+ * @NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL: This command can be used to cancel a
+ *	pending remain-on-channel duration if the desired operation has been
+ *	completed prior to expiration of the originally requested duration.
+ *	%NL80211_ATTR_WIPHY or %NL80211_ATTR_IFINDEX is used to specify the
+ *	radio. The %NL80211_ATTR_COOKIE attribute must be given as well to
+ *	uniquely identify the request.
+ *	This command is also used as an event to notify when a requested
+ *	remain-on-channel duration has expired.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -353,6 +378,9 @@ enum nl80211_commands {
 	NL80211_CMD_DEL_PMKSA,
 	NL80211_CMD_FLUSH_PMKSA,
 
+	NL80211_CMD_REMAIN_ON_CHANNEL,
+	NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -606,6 +634,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_MAX_NUM_PMKIDS: maximum number of PMKIDs a firmware can
  *	cache, a wiphy attribute.
  *
+ * @NL80211_ATTR_DURATION: Duration of an operation in milliseconds, u32.
+ *
+ * @NL80211_ATTR_COOKIE: Generic 64-bit cookie to identify objects.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -743,6 +775,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKID,
 	NL80211_ATTR_MAX_NUM_PMKIDS,
 
+	NL80211_ATTR_DURATION,
+
+	NL80211_ATTR_COOKIE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/net/wireless/core.h	2009-12-23 13:10:04.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2009-12-23 13:11:25.000000000 +0100
@@ -374,6 +374,9 @@ void cfg80211_process_rdev_events(struct
 struct ieee80211_channel *
 rdev_fixed_channel(struct cfg80211_registered_device *rdev,
 		   struct wireless_dev *for_wdev);
+struct ieee80211_channel *
+rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
+		  int freq, enum nl80211_channel_type channel_type);
 int rdev_set_freq(struct cfg80211_registered_device *rdev,
 		  struct wireless_dev *for_wdev,
 		  int freq, enum nl80211_channel_type channel_type);
--- wireless-testing.orig/net/wireless/chan.c	2009-12-23 13:10:04.000000000 +0100
+++ wireless-testing/net/wireless/chan.c	2009-12-23 13:11:25.000000000 +0100
@@ -41,44 +41,57 @@ rdev_fixed_channel(struct cfg80211_regis
 	return result;
 }
 
-int rdev_set_freq(struct cfg80211_registered_device *rdev,
-		  struct wireless_dev *for_wdev,
+struct ieee80211_channel *
+rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
 		  int freq, enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_channel *chan;
 	struct ieee80211_sta_ht_cap *ht_cap;
-	int result;
-
-	if (rdev_fixed_channel(rdev, for_wdev))
-		return -EBUSY;
-
-	if (!rdev->ops->set_channel)
-		return -EOPNOTSUPP;
 
 	chan = ieee80211_get_channel(&rdev->wiphy, freq);
 
 	/* Primary channel not allowed */
 	if (!chan || chan->flags & IEEE80211_CHAN_DISABLED)
-		return -EINVAL;
+		return NULL;
 
 	if (channel_type == NL80211_CHAN_HT40MINUS &&
 	    chan->flags & IEEE80211_CHAN_NO_HT40MINUS)
-		return -EINVAL;
+		return NULL;
 	else if (channel_type == NL80211_CHAN_HT40PLUS &&
 		 chan->flags & IEEE80211_CHAN_NO_HT40PLUS)
-		return -EINVAL;
+		return NULL;
 
 	ht_cap = &rdev->wiphy.bands[chan->band]->ht_cap;
 
 	if (channel_type != NL80211_CHAN_NO_HT) {
 		if (!ht_cap->ht_supported)
-			return -EINVAL;
+			return NULL;
 
 		if (!(ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) ||
 		    ht_cap->cap & IEEE80211_HT_CAP_40MHZ_INTOLERANT)
-			return -EINVAL;
+			return NULL;
 	}
 
+	return chan;
+}
+
+int rdev_set_freq(struct cfg80211_registered_device *rdev,
+		  struct wireless_dev *for_wdev,
+		  int freq, enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_channel *chan;
+	int result;
+
+	if (rdev_fixed_channel(rdev, for_wdev))
+		return -EBUSY;
+
+	if (!rdev->ops->set_channel)
+		return -EOPNOTSUPP;
+
+	chan = rdev_freq_to_chan(rdev, freq, channel_type);
+	if (!chan)
+		return -EINVAL;
+
 	result = rdev->ops->set_channel(&rdev->wiphy, chan, channel_type);
 	if (result)
 		return result;
--- wireless-testing.orig/include/net/cfg80211.h	2009-12-23 13:10:04.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2009-12-23 13:11:25.000000000 +0100
@@ -988,6 +988,15 @@ struct cfg80211_pmksa {
  *
  * @dump_survey: get site survey information.
  *
+ * @remain_on_channel: Request the driver to remain awake on the specified
+ *	channel for the specified duration to complete an off-channel
+ *	operation (e.g., public action frame exchange). When the driver is
+ *	ready on the requested channel, it must indicate this with an event
+ *	notification by calling cfg80211_ready_on_channel().
+ * @cancel_remain_on_channel: Cancel an on-going remain-on-channel operation.
+ *	This allows the operation to be terminated prior to timeout based on
+ *	the duration value.
+ *
  * @testmode_cmd: run a test mode command
  *
  * @set_pmksa: Cache a PMKID for a BSSID. This is mostly useful for fullmac
@@ -1123,6 +1132,16 @@ struct cfg80211_ops {
 			     struct cfg80211_pmksa *pmksa);
 	int	(*flush_pmksa)(struct wiphy *wiphy, struct net_device *netdev);
 
+	int	(*remain_on_channel)(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     struct ieee80211_channel *chan,
+				     enum nl80211_channel_type channel_type,
+				     unsigned int duration,
+				     u64 *cookie);
+	int	(*cancel_remain_on_channel)(struct wiphy *wiphy,
+					    struct net_device *dev,
+					    u64 cookie);
+
 	/* some temporary stuff to finish wext */
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
@@ -2147,5 +2166,33 @@ void cfg80211_roamed(struct net_device *
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
 			   u8 *ie, size_t ie_len, gfp_t gfp);
 
+/**
+ * cfg80211_ready_on_channel - notification of remain_on_channel start
+ * @dev: network device
+ * @cookie: the request cookie
+ * @chan: The current channel (from remain_on_channel request)
+ * @channel_type: Channel type
+ * @duration: Duration in milliseconds that the driver intents to remain on the
+ *	channel
+ * @gfp: allocation flags
+ */
+void cfg80211_ready_on_channel(struct net_device *dev, u64 cookie,
+			       struct ieee80211_channel *chan,
+			       enum nl80211_channel_type channel_type,
+			       unsigned int duration, gfp_t gfp);
+
+/**
+ * cfg80211_remain_on_channel_expired - remain_on_channel duration expired
+ * @dev: network device
+ * @cookie: the request cookie
+ * @chan: The current channel (from remain_on_channel request)
+ * @channel_type: Channel type
+ * @gfp: allocation flags
+ */
+void cfg80211_remain_on_channel_expired(struct net_device *dev,
+					u64 cookie,
+					struct ieee80211_channel *chan,
+					enum nl80211_channel_type channel_type,
+					gfp_t gfp);
 
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/wireless/mlme.c	2009-12-23 13:11:10.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2009-12-23 13:11:25.000000000 +0100
@@ -691,3 +691,30 @@ void cfg80211_mlme_down(struct cfg80211_
 		}
 	}
 }
+
+void cfg80211_ready_on_channel(struct net_device *dev, u64 cookie,
+			       struct ieee80211_channel *chan,
+			       enum nl80211_channel_type channel_type,
+			       unsigned int duration, gfp_t gfp)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_remain_on_channel(rdev, dev, cookie, chan, channel_type,
+				       duration, gfp);
+}
+EXPORT_SYMBOL(cfg80211_ready_on_channel);
+
+void cfg80211_remain_on_channel_expired(struct net_device *dev,
+					u64 cookie,
+					struct ieee80211_channel *chan,
+					enum nl80211_channel_type channel_type,
+					gfp_t gfp)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_remain_on_channel_cancel(rdev, dev, cookie, chan,
+					      channel_type, gfp);
+}
+EXPORT_SYMBOL(cfg80211_remain_on_channel_expired);
--- wireless-testing.orig/net/wireless/nl80211.c	2009-12-23 13:10:04.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-12-23 13:11:25.000000000 +0100
@@ -141,6 +141,8 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_4ADDR] = { .type = NLA_U8 },
 	[NL80211_ATTR_PMKID] = { .type = NLA_BINARY,
 				 .len = WLAN_PMKID_LEN },
+	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
+	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
 };
 
 /* policy for the attributes */
@@ -569,6 +571,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(set_pmksa, SET_PMKSA);
 	CMD(del_pmksa, DEL_PMKSA);
 	CMD(flush_pmksa, FLUSH_PMKSA);
+	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
 	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
@@ -4289,6 +4292,143 @@ static int nl80211_flush_pmksa(struct sk
 
 }
 
+static int nl80211_remain_on_channel(struct sk_buff *skb,
+				     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	struct ieee80211_channel *chan;
+	struct sk_buff *msg;
+	void *hdr;
+	u64 cookie;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	u32 freq, duration;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
+	    !info->attrs[NL80211_ATTR_DURATION])
+		return -EINVAL;
+
+	duration = nla_get_u32(info->attrs[NL80211_ATTR_DURATION]);
+
+	/*
+	 * We should be on that channel for at least one jiffie,
+	 * and more than 5 seconds seems excessive.
+	 */
+	if (!duration || !msecs_to_jiffies(duration) || duration > 5000)
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!rdev->ops->remain_on_channel) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
+		channel_type = nla_get_u32(
+			info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
+		if (channel_type != NL80211_CHAN_NO_HT &&
+		    channel_type != NL80211_CHAN_HT20 &&
+		    channel_type != NL80211_CHAN_HT40PLUS &&
+		    channel_type != NL80211_CHAN_HT40MINUS)
+			err = -EINVAL;
+			goto out;
+	}
+
+	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
+	chan = rdev_freq_to_chan(rdev, freq, channel_type);
+	if (chan == NULL) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_REMAIN_ON_CHANNEL);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto free_msg;
+	}
+
+	err = rdev->ops->remain_on_channel(&rdev->wiphy, dev, chan,
+					   channel_type, duration, &cookie);
+
+	if (err)
+		goto free_msg;
+
+	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_reply(msg, info);
+	goto out;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+ free_msg:
+	nlmsg_free(msg);
+ out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+ unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_cancel_remain_on_channel(struct sk_buff *skb,
+					    struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	u64 cookie;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_COOKIE])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!rdev->ops->cancel_remain_on_channel) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
+
+	err = rdev->ops->cancel_remain_on_channel(&rdev->wiphy, dev, cookie);
+
+ out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+ unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -4551,8 +4691,20 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
-
+	{
+		.cmd = NL80211_CMD_REMAIN_ON_CHANNEL,
+		.doit = nl80211_remain_on_channel,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
+		.doit = nl80211_cancel_remain_on_channel,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
+
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
 };
@@ -5140,6 +5292,70 @@ nla_put_failure:
 	nlmsg_free(msg);
 }
 
+static void nl80211_send_remain_on_chan_event(
+	int cmd, struct cfg80211_registered_device *rdev,
+	struct net_device *netdev, u64 cookie,
+	struct ieee80211_channel *chan,
+	enum nl80211_channel_type channel_type,
+	unsigned int duration, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, chan->center_freq);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, channel_type);
+	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
+
+	if (cmd == NL80211_CMD_REMAIN_ON_CHANNEL)
+		NLA_PUT_U32(msg, NL80211_ATTR_DURATION, duration);
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
+void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
+				    struct net_device *netdev, u64 cookie,
+				    struct ieee80211_channel *chan,
+				    enum nl80211_channel_type channel_type,
+				    unsigned int duration, gfp_t gfp)
+{
+	nl80211_send_remain_on_chan_event(NL80211_CMD_REMAIN_ON_CHANNEL,
+					  rdev, netdev, cookie, chan,
+					  channel_type, duration, gfp);
+}
+
+void nl80211_send_remain_on_channel_cancel(
+	struct cfg80211_registered_device *rdev, struct net_device *netdev,
+	u64 cookie, struct ieee80211_channel *chan,
+	enum nl80211_channel_type channel_type, gfp_t gfp)
+{
+	nl80211_send_remain_on_chan_event(NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
+					  rdev, netdev, cookie, chan,
+					  channel_type, 0, gfp);
+}
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
--- wireless-testing.orig/net/wireless/nl80211.h	2009-12-23 13:10:04.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.h	2009-12-23 13:11:25.000000000 +0100
@@ -59,4 +59,15 @@ void nl80211_send_ibss_bssid(struct cfg8
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp);
 
+void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
+				    struct net_device *netdev,
+				    u64 cookie,
+				    struct ieee80211_channel *chan,
+				    enum nl80211_channel_type channel_type,
+				    unsigned int duration, gfp_t gfp);
+void nl80211_send_remain_on_channel_cancel(
+	struct cfg80211_registered_device *rdev, struct net_device *netdev,
+	u64 cookie, struct ieee80211_channel *chan,
+	enum nl80211_channel_type channel_type, gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */


