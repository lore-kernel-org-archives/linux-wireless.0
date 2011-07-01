Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44892 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab1GAWP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:15:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Qcm0B-0007Mw-Ka
	for linux-wireless@vger.kernel.org; Sat, 02 Jul 2011 00:15:55 +0200
Message-Id: <20110701221533.846716160@sipsolutions.net> (sfid-20110702_001605_678620_87CFAFA1)
Date: Sat, 02 Jul 2011 00:13:23 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 2/3] cfg80211/nl80211: support GTK rekey offload
References: <20110701221321.478559320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In certain circumstances, like WoWLAN scenarios,
devices may implement (partial) GTK rekeying on
the device to avoid waking up the host for it.

In order to successfully go through GTK rekeying,
the KEK, KCK and the replay counter are required.

Add API to let the supplicant hand the parameters
to the driver which may store it for future GTK
rekey operations.

Note that, of course, if GTK rekeying is done by
the device, the EAP frame must not be passed up
to userspace, instead a rekey event needs to be
sent to let userspace update its replay counter.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   39 ++++++++++++++++
 include/net/cfg80211.h  |   26 +++++++++++
 net/wireless/mlme.c     |   11 ++++
 net/wireless/nl80211.c  |  113 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 +
 5 files changed, 193 insertions(+)

--- a/include/linux/nl80211.h	2011-07-02 00:00:35.000000000 +0200
+++ b/include/linux/nl80211.h	2011-07-02 00:00:44.000000000 +0200
@@ -483,6 +483,14 @@
  *	more background information, see
  *	http://wireless.kernel.org/en/users/Documentation/WoWLAN.
  *
+ * @NL80211_CMD_SET_REKEY_OFFLOAD: This command is used give the driver
+ *	the necessary information for supporting GTK rekey offload. This
+ *	feature is typically used during WoWLAN. The configuration data
+ *	is contained in %NL80211_ATTR_REKEY_DATA (which is nested and
+ *	contains the data in sub-attributes). After rekeying happened,
+ *	this command may also be sent by the driver as an MLME event to
+ *	inform userspace of the new replay counter.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -605,6 +613,8 @@ enum nl80211_commands {
 	NL80211_CMD_SCHED_SCAN_RESULTS,
 	NL80211_CMD_SCHED_SCAN_STOPPED,
 
+	NL80211_CMD_SET_REKEY_OFFLOAD,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -996,6 +1006,9 @@ enum nl80211_commands {
  *	are managed in software: interfaces of these types aren't subject to
  *	any restrictions in their number or combinations.
  *
+ * @%NL80211_ATTR_REKEY_DATA: nested attribute containing the information
+ *	necessary for GTK rekeying in the device, see &enum nl80211_rekey_data.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1194,6 +1207,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_INTERFACE_COMBINATIONS,
 	NL80211_ATTR_SOFTWARE_IFTYPES,
 
+	NL80211_ATTR_REKEY_DATA,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2361,4 +2376,28 @@ enum nl80211_plink_state {
 	MAX_NL80211_PLINK_STATES = NUM_NL80211_PLINK_STATES - 1
 };
 
+#define NL80211_KCK_LEN			16
+#define NL80211_KEK_LEN			16
+#define NL80211_REPLAY_CTR_LEN		8
+
+/**
+ * enum nl80211_rekey_data - attributes for GTK rekey offload
+ * @__NL80211_REKEY_DATA_INVALID: invalid number for nested attributes
+ * @NL80211_REKEY_DATA_KEK: key encryption key (binary)
+ * @NL80211_REKEY_DATA_KCK: key confirmation key (binary)
+ * @NL80211_REKEY_DATA_REPLAY_CTR: replay counter (binary)
+ * @NUM_NL80211_REKEY_DATA: number of rekey attributes (internal)
+ * @MAX_NL80211_REKEY_DATA: highest rekey attribute (internal)
+ */
+enum nl80211_rekey_data {
+	__NL80211_REKEY_DATA_INVALID,
+	NL80211_REKEY_DATA_KEK,
+	NL80211_REKEY_DATA_KCK,
+	NL80211_REKEY_DATA_REPLAY_CTR,
+
+	/* keep last */
+	NUM_NL80211_REKEY_DATA,
+	MAX_NL80211_REKEY_DATA = NUM_NL80211_REKEY_DATA - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- a/include/net/cfg80211.h	2011-07-02 00:00:35.000000000 +0200
+++ b/include/net/cfg80211.h	2011-07-02 00:00:44.000000000 +0200
@@ -1154,6 +1154,18 @@ struct cfg80211_wowlan {
 };
 
 /**
+ * struct cfg80211_gtk_rekey_data - rekey data
+ * @kek: key encryption key
+ * @kck: key confirmation key
+ * @replay_ctr: replay counter
+ */
+struct cfg80211_gtk_rekey_data {
+	u8 kek[NL80211_KEK_LEN];
+	u8 kck[NL80211_KCK_LEN];
+	u8 replay_ctr[NL80211_REPLAY_CTR_LEN];
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -1197,6 +1209,8 @@ struct cfg80211_wowlan {
  *
  * @set_default_mgmt_key: set the default management frame key on an interface
  *
+ * @set_rekey_data: give the data necessary for GTK rekeying to the driver
+ *
  * @add_beacon: Add a beacon with given parameters, @head, @interval
  *	and @dtim_period will be valid, @tail is optional.
  * @set_beacon: Change the beacon parameters for an access point mode
@@ -1499,6 +1513,9 @@ struct cfg80211_ops {
 				struct net_device *dev,
 				struct cfg80211_sched_scan_request *request);
 	int	(*sched_scan_stop)(struct wiphy *wiphy, struct net_device *dev);
+
+	int	(*set_rekey_data)(struct wiphy *wiphy, struct net_device *dev,
+				  struct cfg80211_gtk_rekey_data *data);
 };
 
 /*
@@ -3033,6 +3050,15 @@ void cfg80211_cqm_rssi_notify(struct net
 void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 				 const u8 *peer, u32 num_packets, gfp_t gfp);
 
+/**
+ * cfg80211_gtk_rekey_notify - notify userspace about driver rekeying
+ * @dev: network device
+ * @bssid: BSSID of AP (to avoid races)
+ * @replay_ctr: new replay counter
+ */
+void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
+			       const u8 *replay_ctr, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
--- a/net/wireless/nl80211.c	2011-07-02 00:00:35.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-07-02 00:00:44.000000000 +0200
@@ -176,6 +176,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_WOWLAN_TRIGGERS] = { .type = NLA_NESTED },
 	[NL80211_ATTR_STA_PLINK_STATE] = { .type = NLA_U8 },
 	[NL80211_ATTR_SCHED_SCAN_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_ATTR_REKEY_DATA] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -206,6 +207,14 @@ nl80211_wowlan_policy[NUM_NL80211_WOWLAN
 	[NL80211_WOWLAN_TRIG_PKT_PATTERN] = { .type = NLA_NESTED },
 };
 
+/* policy for GTK rekey offload attributes */
+static const struct nla_policy
+nl80211_rekey_policy[NUM_NL80211_REKEY_DATA] = {
+	[NL80211_REKEY_DATA_KEK] = { .len = NL80211_KEK_LEN },
+	[NL80211_REKEY_DATA_KCK] = { .len = NL80211_KCK_LEN },
+	[NL80211_REKEY_DATA_REPLAY_CTR] = { .len = NL80211_REPLAY_CTR_LEN },
+};
+
 /* ifidx get helper */
 static int nl80211_get_ifidx(struct netlink_callback *cb)
 {
@@ -5408,6 +5417,57 @@ static int nl80211_set_wowlan(struct sk_
 	return err;
 }
 
+static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct nlattr *tb[NUM_NL80211_REKEY_DATA];
+	struct cfg80211_gtk_rekey_data rekey_data;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_REKEY_DATA])
+		return -EINVAL;
+
+	err = nla_parse(tb, MAX_NL80211_REKEY_DATA,
+			nla_data(info->attrs[NL80211_ATTR_REKEY_DATA]),
+			nla_len(info->attrs[NL80211_ATTR_REKEY_DATA]),
+			nl80211_rekey_policy);
+	if (err)
+		return err;
+
+	if (nla_len(tb[NL80211_REKEY_DATA_REPLAY_CTR]) != NL80211_REPLAY_CTR_LEN)
+		return -ERANGE;
+	if (nla_len(tb[NL80211_REKEY_DATA_KEK]) != NL80211_KEK_LEN)
+		return -ERANGE;
+	if (nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN)
+		return -ERANGE;
+
+	memcpy(rekey_data.kek, nla_data(tb[NL80211_REKEY_DATA_KEK]),
+	       NL80211_KEK_LEN);
+	memcpy(rekey_data.kck, nla_data(tb[NL80211_REKEY_DATA_KCK]),
+	       NL80211_KCK_LEN);
+	memcpy(rekey_data.replay_ctr,
+	       nla_data(tb[NL80211_REKEY_DATA_REPLAY_CTR]),
+	       NL80211_REPLAY_CTR_LEN);
+
+	wdev_lock(wdev);
+	if (!wdev->current_bss) {
+		err = -ENOTCONN;
+		goto out;
+	}
+
+	if (!rdev->ops->set_rekey_data) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = rdev->ops->set_rekey_data(&rdev->wiphy, dev, &rekey_data);
+ out:
+	wdev_unlock(wdev);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -5939,6 +5999,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WIPHY |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_REKEY_OFFLOAD,
+		.doit = nl80211_set_rekey_data,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -6871,6 +6939,51 @@ nl80211_send_cqm_rssi_notify(struct cfg8
 
 	if (genlmsg_end(msg, hdr) < 0) {
 		nlmsg_free(msg);
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
+void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
+			      struct net_device *netdev, const u8 *bssid,
+			      const u8 *replay_ctr, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct nlattr *rekey_attr;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_SET_REKEY_OFFLOAD);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid);
+
+	rekey_attr = nla_nest_start(msg, NL80211_ATTR_REKEY_DATA);
+	if (!rekey_attr)
+		goto nla_put_failure;
+
+	NLA_PUT(msg, NL80211_REKEY_DATA_REPLAY_CTR,
+		NL80211_REPLAY_CTR_LEN, replay_ctr);
+
+	nla_nest_end(msg, rekey_attr);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
 		return;
 	}
 
--- a/net/wireless/mlme.c	2011-07-02 00:00:35.000000000 +0200
+++ b/net/wireless/mlme.c	2011-07-02 00:00:44.000000000 +0200
@@ -1084,3 +1084,14 @@ void cfg80211_cqm_pktloss_notify(struct
 	nl80211_send_cqm_pktloss_notify(rdev, dev, peer, num_packets, gfp);
 }
 EXPORT_SYMBOL(cfg80211_cqm_pktloss_notify);
+
+void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
+			       const u8 *replay_ctr, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_gtk_rekey_notify(rdev, dev, bssid, replay_ctr, gfp);
+}
+EXPORT_SYMBOL(cfg80211_gtk_rekey_notify);
--- a/net/wireless/nl80211.h	2011-07-02 00:00:35.000000000 +0200
+++ b/net/wireless/nl80211.h	2011-07-02 00:00:44.000000000 +0200
@@ -109,4 +109,8 @@ nl80211_send_cqm_pktloss_notify(struct c
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp);
 
+void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
+			      struct net_device *netdev, const u8 *bssid,
+			      const u8 *replay_ctr, gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */


