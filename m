Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36249 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab0AQPBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 10:01:06 -0500
Message-Id: <20100117145923.793261600@sipsolutions.net>
Date: Sun, 17 Jan 2010 15:49:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [RFC/RFT 2/2] cfg80211/mac80211: allow registering for and sending
 action frames
References: <20100117144918.773071520@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jouni Malinen <jouni.malinen@atheros.com>

This implements a new command to register for action frames
that userspace wants to handle instead of the in-kernel
rejection. It is then responsible for rejecting ones that
it decided not to handle. There is no unregistration, but
the socket can be closed for that.

Frames that are not registered for will not be forwarded
to userspace and will be rejected by the kernel, the
cfg80211 API helps implementing that.

Additionally, this patch adds a new command that allows
doing action frame transmission from userspace. It can be
used either to exchange action frames on the current
operational channel (e.g., with the AP with which we are
currently associated) or to exchange off-channel Public
Action frames with the remain-on-channel command.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h    |   41 ++++++-
 include/net/cfg80211.h     |   47 +++++++-
 include/net/mac80211.h     |    6 -
 net/mac80211/cfg.c         |   12 +-
 net/mac80211/ieee80211_i.h |    6 -
 net/mac80211/mlme.c        |   35 ++++++
 net/mac80211/rx.c          |   39 +++++-
 net/mac80211/status.c      |    7 +
 net/wireless/core.c        |    4 
 net/wireless/core.h        |    9 +
 net/wireless/mlme.c        |  166 ++++++++++++++++++++++++++++
 net/wireless/nl80211.c     |  260 ++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h     |    8 +
 13 files changed, 623 insertions(+), 17 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2010-01-17 15:47:56.000000000 +0100
@@ -1848,28 +1848,25 @@ ieee80211_rx_h_action(struct ieee80211_r
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct sk_buff *nskb;
+	struct ieee80211_rx_status *status;
 	int len = rx->skb->len;
 
 	if (!ieee80211_is_action(mgmt->frame_control))
 		return RX_CONTINUE;
 
-	if (!rx->sta)
+	/* drop too small frames */
+	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return RX_DROP_UNUSABLE;
 
-	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+	if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
 		return RX_DROP_UNUSABLE;
 
-	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
+	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_UNUSABLE;
 
-	/* drop too small frames */
-	if (len < IEEE80211_MIN_ACTION_SIZE)
+	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
 		return RX_DROP_UNUSABLE;
 
-	/* return action frames that have *only* category */
-	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
-		goto return_frame;
-
 	switch (mgmt->u.action.category) {
 	case WLAN_CATEGORY_BACK:
 		/*
@@ -1883,6 +1880,10 @@ ieee80211_rx_h_action(struct ieee80211_r
 		    sdata->vif.type != NL80211_IFTYPE_AP)
 			break;
 
+		/* verify action_code is present */
+		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+			break;
+
 		switch (mgmt->u.action.u.addba_req.action_code) {
 		case WLAN_ACTION_ADDBA_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
@@ -1911,6 +1912,10 @@ ieee80211_rx_h_action(struct ieee80211_r
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
 			break;
 
+		/* verify action_code is present */
+		if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+			break;
+
 		switch (mgmt->u.action.u.measurement.action_code) {
 		case WLAN_ACTION_SPCT_MSR_REQ:
 			if (len < (IEEE80211_MIN_ACTION_SIZE +
@@ -1946,7 +1951,7 @@ ieee80211_rx_h_action(struct ieee80211_r
 		}
 		break;
 	}
- return_frame:
+
 	/*
 	 * For AP mode, hostapd is responsible for handling any action
 	 * frames that we didn't handle, including returning unknown
@@ -1958,6 +1963,20 @@ ieee80211_rx_h_action(struct ieee80211_r
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		return RX_DROP_MONITOR;
 
+	/*
+	 * Getting here means the kernel doesn't know how to handle
+	 * it, but maybe userspace does ... include returned frames
+	 * so userspace can register for those to know whether ones
+	 * it transmitted were processed or returned.
+	 */
+	status = IEEE80211_SKB_RXCB(rx->skb);
+
+	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    cfg80211_rx_action(rx->sdata->dev, status->freq,
+			       rx->skb->data, rx->skb->len,
+			       GFP_ATOMIC))
+		goto handled;
+
 	/* do not return rejected action frames */
 	if (mgmt->u.action.category & 0x80)
 		return RX_DROP_UNUSABLE;
--- wireless-testing.orig/net/wireless/core.h	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2010-01-17 15:36:27.000000000 +0100
@@ -329,6 +329,15 @@ void __cfg80211_connect_result(struct ne
 			       const u8 *resp_ie, size_t resp_ie_len,
 			       u16 status, bool wextev,
 			       struct cfg80211_bss *bss);
+int cfg80211_mlme_register_action(struct wireless_dev *wdev, u32 snd_pid,
+				  const u8 *match_data, int match_len);
+void cfg80211_mlme_unregister_actions(struct wireless_dev *wdev, u32 nlpid);
+void cfg80211_mlme_purge_actions(struct wireless_dev *wdev);
+int cfg80211_mlme_action(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_channel_type channel_type,
+			 const u8 *buf, size_t len, u64 *cookie);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/nl80211.c	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-01-17 15:37:21.000000000 +0100
@@ -1,7 +1,7 @@
 /*
  * This is the new netlink-based wireless configuration interface.
  *
- * Copyright 2006-2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  */
 
 #include <linux/if.h>
@@ -145,6 +145,9 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
 	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_FRAME] = { .type = NLA_BINARY,
+				 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
 };
 
 /* policy for the attributes */
@@ -577,6 +580,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(flush_pmksa, FLUSH_PMKSA);
 	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
 	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
+	CMD(action, ACTION);
 	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
@@ -4547,6 +4551,139 @@ static int nl80211_set_tx_bitrate_mask(s
 	return err;
 }
 
+static int nl80211_register_action(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_FRAME_MATCH])
+		return -EINVAL;
+
+	if (nla_len(info->attrs[NL80211_ATTR_FRAME_MATCH]) < 1)
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* not much point in registering if we can't reply */
+	if (!rdev->ops->action) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = cfg80211_mlme_register_action(dev->ieee80211_ptr, info->snd_pid,
+			nla_data(info->attrs[NL80211_ATTR_FRAME_MATCH]),
+			nla_len(info->attrs[NL80211_ATTR_FRAME_MATCH]));
+ out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+ unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_action(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
+	struct ieee80211_channel *chan;
+	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	u32 freq;
+	int err;
+	void *hdr;
+	u64 cookie;
+	struct sk_buff *msg;
+
+	if (!info->attrs[NL80211_ATTR_FRAME] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!rdev->ops->action) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
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
+			     NL80211_CMD_ACTION);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto free_msg;
+	}
+	err = cfg80211_mlme_action(rdev, dev, chan, channel_type,
+				   nla_data(info->attrs[NL80211_ATTR_FRAME]),
+				   nla_len(info->attrs[NL80211_ATTR_FRAME]),
+				   &cookie);
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
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -4827,6 +4964,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_REGISTER_ACTION,
+		.doit = nl80211_register_action,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_ACTION,
+		.doit = nl80211_action,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -5499,6 +5648,110 @@ void nl80211_send_sta_event(struct cfg80
 				nl80211_mlme_mcgrp.id, gfp);
 }
 
+int nl80211_send_action(struct cfg80211_registered_device *rdev,
+			struct net_device *netdev, u32 nlpid,
+			int freq, const u8 *buf, size_t len, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_ACTION);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return -ENOMEM;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	err = genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlpid);
+	if (err < 0)
+		return err;
+	return 0;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev, u64 cookie,
+				   const u8 *buf, size_t len, bool ack,
+				   gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_ACTION_TX_STATUS);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
+	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
+	if (ack)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_ACK);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
+static int nl80211_netlink_notify(struct notifier_block * nb,
+				  unsigned long state,
+				  void *_notify)
+{
+	struct netlink_notify *notify = _notify;
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+
+	if (state != NETLINK_URELEASE)
+		return NOTIFY_DONE;
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list)
+		list_for_each_entry_rcu(wdev, &rdev->netdev_list, list)
+			cfg80211_mlme_unregister_actions(wdev, notify->pid);
+
+	rcu_read_unlock();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nl80211_netlink_notifier = {
+	.notifier_call = nl80211_netlink_notify,
+};
+
 /* initialisation/exit functions */
 
 int nl80211_init(void)
@@ -5532,6 +5785,10 @@ int nl80211_init(void)
 		goto err_out;
 #endif
 
+	err = netlink_register_notifier(&nl80211_netlink_notifier);
+	if (err)
+		goto err_out;
+
 	return 0;
  err_out:
 	genl_unregister_family(&nl80211_fam);
@@ -5540,5 +5797,6 @@ int nl80211_init(void)
 
 void nl80211_exit(void)
 {
+	netlink_unregister_notifier(&nl80211_netlink_notifier);
 	genl_unregister_family(&nl80211_fam);
 }
--- wireless-testing.orig/net/wireless/nl80211.h	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.h	2010-01-17 15:36:27.000000000 +0100
@@ -74,4 +74,12 @@ void nl80211_send_sta_event(struct cfg80
 			    struct net_device *dev, const u8 *mac_addr,
 			    struct station_info *sinfo, gfp_t gfp);
 
+int nl80211_send_action(struct cfg80211_registered_device *rdev,
+			struct net_device *netdev, u32 nlpid, int freq,
+			const u8 *buf, size_t len, gfp_t gfp);
+void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev, u64 cookie,
+				   const u8 *buf, size_t len, bool ack,
+				   gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
--- wireless-testing.orig/include/linux/nl80211.h	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2010-01-17 15:36:27.000000000 +0100
@@ -3,7 +3,7 @@
 /*
  * 802.11 netlink interface public header
  *
- * Copyright 2006, 2007, 2008 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2008 Michael Wu <flamingice@sourmilk.net>
  * Copyright 2008 Luis Carlos Cobo <luisca@cozybit.com>
  * Copyright 2008 Michael Buesch <mb@bu3sch.de>
@@ -299,6 +299,31 @@
  *	rate selection. %NL80211_ATTR_IFINDEX is used to specify the interface
  *	and @NL80211_ATTR_TX_RATES the set of allowed rates.
  *
+ * @NL80211_CMD_REGISTER_ACTION: Register for receiving certain action frames
+ *	(via @NL80211_CMD_ACTION) for processing in userspace. This command
+ *	requires an interface index and a match attribute containing the first
+ *	few bytes of the frame that should match, e.g. a single byte for only
+ *	a category match or four bytes for vendor frames including the OUI.
+ *	The registration cannot be dropped, but is removed automatically
+ *	when the netlink socket is closed. Multiple registrations can be made.
+ * @NL80211_CMD_ACTION: Action frame TX request and RX notification. This
+ *	command is used both as a request to transmit an Action frame and as an
+ *	event indicating reception of an Action frame that was not processed in
+ *	kernel code, but is for us (i.e., which may need to be processed in a
+ *	user space application). %NL80211_ATTR_FRAME is used to specify the
+ *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ (and
+ *	optionally %NL80211_ATTR_WIPHY_CHANNEL_TYPE) is used to indicate on
+ *	which channel the frame is to be transmitted or was received. This
+ *	channel has to be the current channel (remain-on-channel or the
+ *	operational channel). When called, this operation returns a cookie
+ *	(%NL80211_ATTR_COOKIE) that will be included with the TX status event
+ *	pertaining to the TX request.
+ * @NL80211_CMD_ACTION_TX_STATUS: Report TX status of an Action frame
+ *	transmitted with %NL80211_CMD_ACTION. %NL80211_ATTR_COOKIE identifies
+ *	the TX command and %NL80211_ATTR_FRAME includes the contents of the
+ *	frame. %NL80211_ATTR_ACK flag is included if the recipient acknowledged
+ *	the frame.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -387,6 +412,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_TX_BITRATE_MASK,
 
+	NL80211_CMD_REGISTER_ACTION,
+	NL80211_CMD_ACTION,
+	NL80211_CMD_ACTION_TX_STATUS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -653,6 +682,12 @@ enum nl80211_commands {
  *	rates based on negotiated supported rates information. This attribute
  *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
  *
+ * @NL80211_ATTR_FRAME_MATCH: A binary attribute which typically must contain
+ *	at least one byte, currently used with @NL80211_CMD_REGISTER_ACTION.
+ *
+ * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
+ *	acknowledged by the recipient.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -798,6 +833,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_RATES,
 
+	NL80211_ATTR_FRAME_MATCH,
+
+	NL80211_ATTR_ACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/include/net/cfg80211.h	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-01-17 15:36:27.000000000 +0100
@@ -3,7 +3,7 @@
 /*
  * 802.11 device and configuration interface
  *
- * Copyright 2006-2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -998,6 +998,7 @@ struct cfg80211_pmksa {
  * @cancel_remain_on_channel: Cancel an on-going remain-on-channel operation.
  *	This allows the operation to be terminated prior to timeout based on
  *	the duration value.
+ * @action: Transmit an action frame
  *
  * @testmode_cmd: run a test mode command
  *
@@ -1144,6 +1145,11 @@ struct cfg80211_ops {
 					    struct net_device *dev,
 					    u64 cookie);
 
+	int	(*action)(struct wiphy *wiphy, struct net_device *dev,
+			  struct ieee80211_channel *chan,
+			  enum nl80211_channel_type channel_type,
+			  const u8 *buf, size_t len, u64 *cookie);
+
 	/* some temporary stuff to finish wext */
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
 				  bool enabled, int timeout);
@@ -1425,6 +1431,8 @@ struct cfg80211_cached_keys;
  *	set by driver (if supported) on add_interface BEFORE registering the
  *	netdev and may otherwise be used by driver read-only, will be update
  *	by cfg80211 on change_interface
+ * @action_registrations: list of registrations for action frames
+ * @action_registrations_lock: lock for the list
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -1434,6 +1442,9 @@ struct wireless_dev {
 	struct list_head list;
 	struct net_device *netdev;
 
+	struct list_head action_registrations;
+	spinlock_t action_registrations_lock;
+
 	struct mutex mtx;
 
 	struct work_struct cleanup_work;
@@ -2210,4 +2221,38 @@ void cfg80211_remain_on_channel_expired(
 void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 		      struct station_info *sinfo, gfp_t gfp);
 
+/**
+ * cfg80211_rx_action - notification of received, unprocessed Action frame
+ * @dev: network device
+ * @freq: Frequency on which the frame was received in MHz
+ * @buf: Action frame (header + body)
+ * @len: length of the frame data
+ * @gfp: context flags
+ * Returns %true if a user space application is responsible for rejecting the
+ *	unrecognized Action frame; %false if no such application is registered
+ *	(i.e., the driver is responsible for rejecting the unrecognized Action
+ *	frame)
+ *
+ * This function is called whenever an Action frame is received for a station
+ * mode interface, but is not processed in kernel.
+ */
+bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
+			size_t len, gfp_t gfp);
+
+/**
+ * cfg80211_action_tx_status - notification of TX status for Action frame
+ * @dev: network device
+ * @cookie: Cookie returned by cfg80211_ops::action()
+ * @buf: Action frame (header + body)
+ * @len: length of the frame data
+ * @ack: Whether frame was acknowledged
+ * @gfp: context flags
+ *
+ * This function is called whenever an Action frame was requested to be
+ * transmitted with cfg80211_ops::action() to report the TX status of the
+ * transmission attempt.
+ */
+void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
+			       const u8 *buf, size_t len, bool ack, gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/mac80211/cfg.c	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-01-17 15:36:27.000000000 +0100
@@ -1,7 +1,7 @@
 /*
  * mac80211 configuration hooks for cfg80211
  *
- * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -1461,6 +1461,15 @@ static int ieee80211_cancel_remain_on_ch
 	return ieee80211_wk_cancel_remain_on_channel(sdata, cookie);
 }
 
+static int ieee80211_action(struct wiphy *wiphy, struct net_device *dev,
+			    struct ieee80211_channel *chan,
+			    enum nl80211_channel_type channel_type,
+			    const u8 *buf, size_t len, u64 *cookie)
+{
+	return ieee80211_mgd_action(IEEE80211_DEV_TO_SUB_IF(dev), chan,
+				    channel_type, buf, len, cookie);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1509,4 +1518,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.set_bitrate_mask = ieee80211_set_bitrate_mask,
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
+	.action = ieee80211_action,
 };
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-01-17 15:36:27.000000000 +0100
@@ -2,7 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
- * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -967,6 +967,10 @@ int ieee80211_mgd_deauth(struct ieee8021
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req,
 			   void *cookie);
+int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_channel_type channel_type,
+			 const u8 *buf, size_t len, u64 *cookie);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					  struct sk_buff *skb);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
--- wireless-testing.orig/net/mac80211/mlme.c	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2010-01-17 15:38:42.000000000 +0100
@@ -2057,3 +2057,38 @@ int ieee80211_mgd_disassoc(struct ieee80
 
 	return 0;
 }
+
+int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_channel_type channel_type,
+			 const u8 *buf, size_t len, u64 *cookie)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct sk_buff *skb;
+
+	/* Check that we are on the requested channel for transmission */
+	if ((chan != local->tmp_channel ||
+	     channel_type != local->tmp_channel_type) &&
+	    (chan != local->oper_channel ||
+	     channel_type != local->oper_channel_type))
+		return -EBUSY;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + len);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	memcpy(skb_put(skb, len), buf, len);
+
+	if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
+		IEEE80211_SKB_CB(skb)->flags |=
+			IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_NL80211_FRAME_TX |
+		IEEE80211_TX_CTL_REQ_TX_STATUS;
+	skb->dev = sdata->dev;
+	ieee80211_tx_skb(sdata, skb);
+
+	*cookie = (unsigned long) skb;
+	return 0;
+}
--- wireless-testing.orig/net/wireless/mlme.c	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2010-01-17 15:36:27.000000000 +0100
@@ -728,3 +728,169 @@ void cfg80211_new_sta(struct net_device 
 	nl80211_send_sta_event(rdev, dev, mac_addr, sinfo, gfp);
 }
 EXPORT_SYMBOL(cfg80211_new_sta);
+
+struct cfg80211_action_registration {
+	struct list_head list;
+
+	u32 nlpid;
+
+	int match_len;
+
+	u8 match[];
+};
+
+int cfg80211_mlme_register_action(struct wireless_dev *wdev, u32 snd_pid,
+				  const u8 *match_data, int match_len)
+{
+	struct cfg80211_action_registration *reg, *nreg;
+	unsigned long flags;
+	int err = 0;
+
+	nreg = kzalloc(sizeof(*reg) + match_len, GFP_KERNEL);
+	if (!nreg)
+		return -ENOMEM;
+
+	spin_lock_bh(&wdev->action_registrations_lock);
+
+	list_for_each_entry(reg, &wdev->action_registrations, list) {
+		int mlen = min(match_len, reg->match_len);
+
+		if (memcmp(reg->match, match_data, mlen) == 0) {
+			err = -EALREADY;
+			break;
+		}
+	}
+
+	if (err) {
+		kfree(nreg);
+		goto out;
+	}
+
+	memcpy(nreg->match, match_data, match_len);
+	nreg->nlpid = snd_pid;
+	list_add(&nreg->list, &wdev->action_registrations);
+
+ out:
+	spin_unlock_bh(&wdev->action_registrations_lock);
+	return err;
+}
+
+void cfg80211_mlme_unregister_actions(struct wireless_dev *wdev, u32 nlpid)
+{
+	struct cfg80211_action_registration *reg, *tmp;
+
+	spin_lock_bh(&wdev->action_registrations_lock);
+
+	list_for_each_entry_safe(reg, tmp, &wdev->action_registrations, list) {
+		if (reg->nlpid == nlpid) {
+			list_del(&reg->list);
+			kfree(reg);
+		}
+	}
+
+	spin_unlock_bh(&wdev->action_registrations_lock);
+}
+
+void cfg80211_mlme_purge_actions(struct wireless_dev *wdev)
+{
+	struct cfg80211_action_registration *reg, *tmp;
+
+	spin_lock_bh(&wdev->action_registrations_lock);
+
+	list_for_each_entry_safe(reg, tmp, &wdev->action_registrations, list) {
+		list_del(&reg->list);
+		kfree(reg);
+	}
+
+	spin_unlock_bh(&wdev->action_registrations_lock);
+}
+
+int cfg80211_mlme_action(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_channel_type channel_type,
+			 const u8 *buf, size_t len, u64 *cookie)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const struct ieee80211_mgmt *mgmt;
+
+	if (rdev->ops->action == NULL)
+		return -EOPNOTSUPP;
+	if (len < 24 + 1)
+		return -EINVAL;
+
+	mgmt = (const struct ieee80211_mgmt *) buf;
+	if (!ieee80211_is_action(mgmt->frame_control))
+		return -EINVAL;
+	if (mgmt->u.action.category != WLAN_CATEGORY_PUBLIC) {
+		/* Verify that we are associated with the destination AP */
+		if (!wdev->current_bss ||
+		    memcmp(wdev->current_bss->pub.bssid, mgmt->bssid,
+			   ETH_ALEN) != 0 ||
+		    memcmp(wdev->current_bss->pub.bssid, mgmt->da,
+			   ETH_ALEN) != 0)
+			return -ENOTCONN;
+	}
+
+	if (memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0)
+		return -EINVAL;
+
+	/* Transmit the Action frame as requested by user space */
+	return rdev->ops->action(&rdev->wiphy, dev, chan, channel_type,
+				 buf, len, cookie);
+}
+
+bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
+			size_t len, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_action_registration *reg;
+	const u8 *action_data;
+	int action_data_len;
+	bool result = false;
+
+	/* frame length - min size excluding category */
+	action_data_len = len - (IEEE80211_MIN_ACTION_SIZE - 1);
+
+	/* action data starts with category */
+	action_data = buf + IEEE80211_MIN_ACTION_SIZE - 1;
+
+	spin_lock_bh(&wdev->action_registrations_lock);
+
+	list_for_each_entry(reg, &wdev->action_registrations, list) {
+		if (reg->match_len > action_data_len)
+			continue;
+
+		if (memcmp(reg->match, action_data, reg->match_len))
+			continue;
+
+		/* found match! */
+
+		/* Indicate the received Action frame to user space */
+		if (nl80211_send_action(rdev, dev, reg->nlpid, freq,
+					buf, len, gfp))
+			continue;
+
+		result = true;
+		break;
+	}
+
+	spin_unlock_bh(&wdev->action_registrations_lock);
+
+	return result;
+}
+EXPORT_SYMBOL(cfg80211_rx_action);
+
+void cfg80211_action_tx_status(struct net_device *dev, u64 cookie,
+			       const u8 *buf, size_t len, bool ack, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	/* Indicate TX status of the Action frame to user space */
+	nl80211_send_action_tx_status(rdev, dev, cookie, buf, len, ack, gfp);
+}
+EXPORT_SYMBOL(cfg80211_action_tx_status);
--- wireless-testing.orig/include/net/mac80211.h	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2010-01-17 15:36:27.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
- * Copyright 2007-2008	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -274,6 +274,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_RETRANSMISSION: This frame is being retransmitted
  *	after TX status because the destination was asleep, it must not
  *	be modified again (no seqno assignment, crypto, etc.)
+ * @IEEE80211_TX_CTL_NL80211_FRAME_TX: Frame was requested through nl80211
+ *	MLME command (internal to mac80211 to figure out whether to send TX
+ *	status to user space)
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -295,6 +298,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
 	IEEE80211_TX_INTFL_RETRANSMISSION	= BIT(19),
+	IEEE80211_TX_CTL_NL80211_FRAME_TX	= BIT(20),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/status.c	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2010-01-17 15:39:00.000000000 +0100
@@ -2,7 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2005-2006, Devicescape Software, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
- * Copyright 2008-2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2008-2010	Johannes Berg <johannes@sipsolutions.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -272,6 +272,11 @@ void ieee80211_tx_status(struct ieee8021
 			local->dot11FailedCount++;
 	}
 
+	if (info->flags & IEEE80211_TX_CTL_NL80211_FRAME_TX)
+		cfg80211_action_tx_status(
+			skb->dev, (unsigned long) skb, skb->data, skb->len,
+			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);
+
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 
--- wireless-testing.orig/net/wireless/core.c	2010-01-17 15:28:43.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2010-01-17 15:36:27.000000000 +0100
@@ -665,6 +665,9 @@ static int cfg80211_netdev_notifier_call
 		INIT_WORK(&wdev->cleanup_work, wdev_cleanup_work);
 		INIT_LIST_HEAD(&wdev->event_list);
 		spin_lock_init(&wdev->event_lock);
+		INIT_LIST_HEAD(&wdev->action_registrations);
+		spin_lock_init(&wdev->action_registrations_lock);
+
 		mutex_lock(&rdev->devlist_mtx);
 		list_add_rcu(&wdev->list, &rdev->netdev_list);
 		rdev->devlist_generation++;
@@ -780,6 +783,7 @@ static int cfg80211_netdev_notifier_call
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_rcu(&wdev->list);
 			rdev->devlist_generation++;
+			cfg80211_mlme_purge_actions(wdev);
 #ifdef CONFIG_CFG80211_WEXT
 			kfree(wdev->wext.keys);
 #endif


