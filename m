Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1JUOZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG2H-0008Us-O7
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:25 +0200
Message-Id: <20111021142428.731853959@sipsolutions.net> (sfid-20111021_162530_276952_0730CC5C)
Date: Fri, 21 Oct 2011 16:23:28 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 06/12] nl80211: add API to probe a client
References: <20111021142322.229128720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the AP SME in hostapd is used it wants to
probe the clients when they have been idle for
some time. Add explicit API to support this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: - indicate both ack/non-ack status for cookie validity

 include/linux/nl80211.h |   10 ++++
 include/net/cfg80211.h  |   17 +++++++
 net/wireless/nl80211.c  |  104 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 131 insertions(+)

--- a/include/linux/nl80211.h	2011-10-21 12:07:41.000000000 +0200
+++ b/include/linux/nl80211.h	2011-10-21 12:07:42.000000000 +0200
@@ -520,6 +520,14 @@
  *	If used as the command, must have an interface index, and you can
  *	only unsubscribe from the event by closing the socket.
  *
+ * @NL80211_CMD_PROBE_CLIENT: Probe an associated station on an AP interface
+ *	by sending a null data frame to it and reporting when the frame is
+ *	acknowleged. This is used to allow timing out inactive clients. Uses
+ *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_MAC. The command returns a
+ *	direct reply with an %NL80211_ATTR_COOKIE that is later used to match
+ *	up the event with the request. The event includes the same data and
+ *	has %NL80211_ATTR_ACK set if the frame was ACKed.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -651,6 +659,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_UNEXPECTED_FRAME,
 
+	NL80211_CMD_PROBE_CLIENT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- a/include/net/cfg80211.h	2011-10-21 12:07:41.000000000 +0200
+++ b/include/net/cfg80211.h	2011-10-21 12:07:42.000000000 +0200
@@ -1428,6 +1428,9 @@ struct cfg80211_gtk_rekey_data {
  *
  * @tdls_mgmt: Transmit a TDLS management frame.
  * @tdls_oper: Perform a high-level TDLS operation (e.g. TDLS link setup).
+ *
+ * @probe_client: probe an associated client, must return a cookie that it
+ *	later passes to cfg80211_probe_status().
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1617,6 +1620,9 @@ struct cfg80211_ops {
 			     u16 status_code, const u8 *buf, size_t len);
 	int	(*tdls_oper)(struct wiphy *wiphy, struct net_device *dev,
 			     u8 *peer, enum nl80211_tdls_operation oper);
+
+	int	(*probe_client)(struct wiphy *wiphy, struct net_device *dev,
+				const u8 *peer, u64 *cookie);
 };
 
 /*
@@ -3210,6 +3216,17 @@ void cfg80211_pmksa_candidate_notify(str
 bool cfg80211_rx_spurious_frame(struct net_device *dev,
 				const u8 *addr, gfp_t gfp);
 
+/**
+ * cfg80211_probe_status - notify userspace about probe status
+ * @dev: the device the probe was sent on
+ * @addr: the address of the peer
+ * @cookie: the cookie filled in @probe_client previously
+ * @acked: indicates whether probe was acked or not
+ * @gfp: allocation flags
+ */
+void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
+			   u64 cookie, bool acked, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
--- a/net/wireless/nl80211.c	2011-10-21 12:07:41.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-10-21 12:07:42.000000000 +0200
@@ -891,6 +891,7 @@ static int nl80211_send_wiphy(struct sk_
 	}
 	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
 		CMD(sched_scan_start, START_SCHED_SCAN);
+	CMD(probe_client, PROBE_CLIENT);
 
 #undef CMD
 
@@ -5848,6 +5849,59 @@ static int nl80211_register_unexpected_f
 	return 0;
 }
 
+static int nl80211_probe_client(struct sk_buff *skb,
+				struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct sk_buff *msg;
+	void *hdr;
+	const u8 *addr;
+	u64 cookie;
+	int err;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	if (!rdev->ops->probe_client)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_PROBE_CLIENT);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto free_msg;
+	}
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	err = rdev->ops->probe_client(&rdev->wiphy, dev, addr, &cookie);
+	if (err)
+		goto free_msg;
+
+	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+ nla_put_failure:
+	err = -ENOBUFS;
+ free_msg:
+	nlmsg_free(msg);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -6411,6 +6465,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_PROBE_CLIENT,
+		.doit = nl80211_probe_client,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -7532,6 +7594,48 @@ nl80211_send_cqm_pktloss_notify(struct c
 	nlmsg_free(msg);
 }
 
+void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
+			   u64 cookie, bool acked, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_PROBE_CLIENT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, addr);
+	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
+	if (acked)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_ACK);
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0) {
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
+EXPORT_SYMBOL(cfg80211_probe_status);
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)


