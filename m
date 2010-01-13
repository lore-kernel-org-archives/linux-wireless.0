Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57191 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754867Ab0AMKMR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 05:12:17 -0500
Date: Wed, 13 Jan 2010 12:11:26 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, j@w1.fi
Subject: [PATCH] cfg80211/mac80211: Add TX/RX commands for Action frames
Message-ID: <20100113101126.GA12548@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new commands can be used to implement user space -controlled
Action frame exchanges. These can be used either to exchange Action
frames on the current operational channel (e.g., with the AP with
which we are currently associated) or to exchange off-channel Public
Action frames with the remain-on-channel command.

This patch adds couple of to-do items to handle rejecting of unknown
Action frames. This is required by IEEE 802.11, but we do not
currently handle it in mac80211. To do this properly with optional
user space control of some Action frame subtypes, a new mechanism will
be needed to register user space handlers and to unregister these when
the netlink socket is closed.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h    |   26 ++++++
 include/net/cfg80211.h     |   40 ++++++++++
 include/net/mac80211.h     |    4 +
 net/mac80211/cfg.c         |   10 ++
 net/mac80211/ieee80211_i.h |    4 +
 net/mac80211/mlme.c        |   35 +++++++++
 net/mac80211/rx.c          |   28 +++++--
 net/mac80211/status.c      |    6 +
 net/wireless/core.h        |    5 +
 net/wireless/mlme.c        |   65 ++++++++++++++++
 net/wireless/nl80211.c     |  175 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h     |    8 ++
 12 files changed, 401 insertions(+), 5 deletions(-)

--- uml.orig/net/mac80211/rx.c	2010-01-13 10:41:51.000000000 +0200
+++ uml/net/mac80211/rx.c	2010-01-13 12:03:57.000000000 +0200
@@ -1848,21 +1848,22 @@ ieee80211_rx_h_action(struct ieee80211_r
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	int len = rx->skb->len;
+	struct ieee80211_rx_status *status;
 
 	if (!ieee80211_is_action(mgmt->frame_control))
 		return RX_CONTINUE;
 
-	if (!rx->sta)
+	/* all categories we currently handle have action_code */
+	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
 		return RX_DROP_MONITOR;
 
-	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
+	if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
 		return RX_DROP_MONITOR;
 
-	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
+	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
-	/* all categories we currently handle have action_code */
-	if (len < IEEE80211_MIN_ACTION_SIZE + 1)
+	if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
 		return RX_DROP_MONITOR;
 
 	switch (mgmt->u.action.category) {
@@ -1950,6 +1951,23 @@ ieee80211_rx_h_action(struct ieee80211_r
 		if (mgmt->u.action.category & 0x80)
 			return RX_DROP_MONITOR;
 
+		status = IEEE80211_SKB_RXCB(rx->skb);
+		/*
+		 * TODO: something needs to reject unrecognized Action frames
+		 * per IEEE 802.11-2007 7.3.1.11. If there is a userspace app
+		 * handling these, it should do this. If not, mac80211 should
+		 * send the rejection frame.
+		 */
+		if (sdata->vif.type != NL80211_IFTYPE_STATION ||
+		    !cfg80211_rx_action(rx->sdata->dev, status->freq,
+					rx->skb->data, rx->skb->len,
+					GFP_ATOMIC)) {
+			/*
+			 * TODO: Reject unrecognized Action frame per IEEE
+			 * 802.11-2007 7.3.1.11.
+			 */
+		}
+
 		return RX_CONTINUE;
 	}
 
--- uml.orig/net/wireless/core.h	2010-01-13 10:41:52.000000000 +0200
+++ uml/net/wireless/core.h	2010-01-13 11:11:17.000000000 +0200
@@ -328,6 +328,11 @@ void __cfg80211_connect_result(struct ne
 			       const u8 *resp_ie, size_t resp_ie_len,
 			       u16 status, bool wextev,
 			       struct cfg80211_bss *bss);
+int cfg80211_mlme_action(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_channel_type channel_type,
+			 const u8 *buf, size_t len, u64 *cookie);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
--- uml.orig/net/wireless/nl80211.c	2010-01-13 10:41:52.000000000 +0200
+++ uml/net/wireless/nl80211.c	2010-01-13 11:11:17.000000000 +0200
@@ -145,6 +145,8 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_DURATION] = { .type = NLA_U32 },
 	[NL80211_ATTR_COOKIE] = { .type = NLA_U64 },
 	[NL80211_ATTR_TX_RATES] = { .type = NLA_NESTED },
+	[NL80211_ATTR_FRAME] = { .type = NLA_BINARY,
+				 .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* policy for the attributes */
@@ -577,6 +579,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(flush_pmksa, FLUSH_PMKSA);
 	CMD(remain_on_channel, REMAIN_ON_CHANNEL);
 	CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
+	CMD(action, ACTION);
 	if (dev->wiphy.flags & WIPHY_FLAG_NETNS_OK) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
@@ -4547,6 +4550,99 @@ static int nl80211_set_tx_bitrate_mask(s
 	return err;
 }
 
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
+nla_put_failure:
+	err = -ENOBUFS;
+free_msg:
+	nlmsg_free(msg);
+out:
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
@@ -4827,6 +4923,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_ACTION,
+		.doit = nl80211_action,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -5499,6 +5601,79 @@ void nl80211_send_sta_event(struct cfg80
 				nl80211_mlme_mcgrp.id, gfp);
 }
 
+void nl80211_send_action(struct cfg80211_registered_device *rdev,
+			 struct net_device *netdev, int freq, const u8 *buf,
+			 size_t len, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_ACTION);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, len, buf);
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
 /* initialisation/exit functions */
 
 int nl80211_init(void)
--- uml.orig/net/wireless/nl80211.h	2010-01-12 18:49:29.000000000 +0200
+++ uml/net/wireless/nl80211.h	2010-01-13 11:11:17.000000000 +0200
@@ -74,4 +74,12 @@ void nl80211_send_sta_event(struct cfg80
 			    struct net_device *dev, const u8 *mac_addr,
 			    struct station_info *sinfo, gfp_t gfp);
 
+void nl80211_send_action(struct cfg80211_registered_device *rdev,
+			 struct net_device *netdev, int freq,
+			 const u8 *buf, size_t len, gfp_t gfp);
+void nl80211_send_action_tx_status(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev, u64 cookie,
+				   const u8 *buf, size_t len, bool ack,
+				   gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
--- uml.orig/include/linux/nl80211.h	2010-01-13 10:41:51.000000000 +0200
+++ uml/include/linux/nl80211.h	2010-01-13 12:06:49.000000000 +0200
@@ -299,6 +299,24 @@
  *	rate selection. %NL80211_ATTR_IFINDEX is used to specify the interface
  *	and @NL80211_ATTR_TX_RATES the set of allowed rates.
  *
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
@@ -387,6 +405,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_TX_BITRATE_MASK,
 
+	NL80211_CMD_ACTION,
+	NL80211_CMD_ACTION_TX_STATUS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -653,6 +674,9 @@ enum nl80211_commands {
  *	rates based on negotiated supported rates information. This attribute
  *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
  *
+ * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
+ *	acknowledged by the recipient.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -798,6 +822,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_RATES,
 
+	NL80211_ATTR_ACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2010-01-13 10:41:51.000000000 +0200
+++ uml/include/net/cfg80211.h	2010-01-13 11:11:17.000000000 +0200
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
@@ -2210,4 +2216,38 @@ void cfg80211_remain_on_channel_expired(
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
--- uml.orig/net/mac80211/cfg.c	2010-01-13 10:41:51.000000000 +0200
+++ uml/net/mac80211/cfg.c	2010-01-13 11:11:17.000000000 +0200
@@ -1451,6 +1451,15 @@ static int ieee80211_cancel_remain_on_ch
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
@@ -1499,4 +1508,5 @@ struct cfg80211_ops mac80211_config_ops 
 	.set_bitrate_mask = ieee80211_set_bitrate_mask,
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
+	.action = ieee80211_action,
 };
--- uml.orig/net/mac80211/ieee80211_i.h	2010-01-13 10:41:51.000000000 +0200
+++ uml/net/mac80211/ieee80211_i.h	2010-01-13 11:11:17.000000000 +0200
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
--- uml.orig/net/mac80211/mlme.c	2010-01-13 10:41:51.000000000 +0200
+++ uml/net/mac80211/mlme.c	2010-01-13 12:08:38.000000000 +0200
@@ -2055,3 +2055,38 @@ int ieee80211_mgd_disassoc(struct ieee80
 
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
+	*cookie = (u64) skb;
+	return 0;
+}
--- uml.orig/net/wireless/mlme.c	2010-01-12 18:49:29.000000000 +0200
+++ uml/net/wireless/mlme.c	2010-01-13 11:11:17.000000000 +0200
@@ -728,3 +728,68 @@ void cfg80211_new_sta(struct net_device 
 	nl80211_send_sta_event(rdev, dev, mac_addr, sinfo, gfp);
 }
 EXPORT_SYMBOL(cfg80211_new_sta);
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
+
+	/* Indicate the received Action frame to user space */
+	nl80211_send_action(rdev, dev, freq, buf, len, gfp);
+
+	/*
+	 * TODO: return false if there is no user space app registered to be
+	 * responsible for action frames
+	 */
+	return true;
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
--- uml.orig/include/net/mac80211.h	2010-01-13 10:41:51.000000000 +0200
+++ uml/include/net/mac80211.h	2010-01-13 11:11:17.000000000 +0200
@@ -270,6 +270,9 @@ struct ieee80211_bss_conf {
  *	transmit function after the current frame, this can be used
  *	by drivers to kick the DMA queue only if unset or when the
  *	queue gets full.
+ * @IEEE80211_TX_CTL_NL80211_FRAME_TX: Frame was requested through nl80211
+ *	MLME command (internal to mac80211 to figure out whether to send TX
+ *	status to user space)
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -290,6 +293,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_INTFL_DONT_ENCRYPT		= BIT(16),
 	IEEE80211_TX_CTL_PSPOLL_RESPONSE	= BIT(17),
 	IEEE80211_TX_CTL_MORE_FRAMES		= BIT(18),
+	IEEE80211_TX_CTL_NL80211_FRAME_TX	= BIT(19),
 };
 
 /**
--- uml.orig/net/mac80211/status.c	2010-01-12 18:49:29.000000000 +0200
+++ uml/net/mac80211/status.c	2010-01-13 11:11:17.000000000 +0200
@@ -286,6 +286,12 @@ void ieee80211_tx_status(struct ieee8021
 			local->dot11FailedCount++;
 	}
 
+	if (info->flags & IEEE80211_TX_CTL_NL80211_FRAME_TX) {
+		cfg80211_action_tx_status(
+			skb->dev, (u64) skb, skb->data, skb->len,
+			!!(info->flags & IEEE80211_TX_STAT_ACK), GFP_ATOMIC);
+	}
+
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
