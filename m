Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:58527 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3CGJbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 04:31:50 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] P2P find offload
Date: Thu, 7 Mar 2013 11:31:46 +0200
Message-ID: <7076584.7eoLUXqF3A@lx-vladimir> (sfid-20130307_103203_360649_6580738B)
In-Reply-To: <1686131.738LDv7O6j@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir> <1362412079.21028.34.camel@jlt4.sipsolutions.net> <1686131.738LDv7O6j@lx-vladimir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Something like the following for method. Attribute for PCP resolution not included yet.

>From 44b47e039b767cdc68d9299889d12b7e008638d5 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Mon, 4 Mar 2013 13:51:48 +0200
Subject: [PATCH] cfg80211: P2P find phase offload

Allow to implement P2P find phase in the driver/firmware.

Driver may provide methods start_p2p_find/stop_p2p_find in the cfg80211_ops;
to be called by supplicant through nl80211 layer.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   33 ++++++++++
 include/uapi/linux/nl80211.h |    3 +
 net/wireless/nl80211.c       |  143 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   20 ++++++
 net/wireless/trace.h         |   20 ++++++
 5 files changed, 219 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa26129..8882310 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1722,6 +1722,26 @@ struct cfg80211_gtk_rekey_data {
 };
 
 /**
+ * struct cfg80211_p2p_find_params - parameters for P2P find
+ * @probe_ie: IE's for probe frames
+ * @probe_ie_len: length, bytes, of @probe_ie
+ * @probe_resp_ie: IE's for probe response frames
+ * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
+ * @n_channels: number of channels to operate on
+ * @channels: channels to operate on
+ */
+struct cfg80211_p2p_find_params {
+	const u8 *probe_ie;
+	size_t probe_ie_len;
+	const u8 *probe_resp_ie;
+	size_t probe_resp_ie_len;
+
+	int n_channels;
+	/* Up to 4 social channels: 3 in 2.4GHz band + 1 in 60GHz band */
+	struct ieee80211_channel *channels[4];
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -1941,6 +1961,13 @@ struct cfg80211_gtk_rekey_data {
  *	advertise the support for MAC based ACL have to implement this callback.
  *
  * @start_radar_detection: Start radar detection in the driver.
+ *
+ * start_p2p_find: start P2P find phase
+ *	Parameters include IEs for probe/probe resp and channels to operate on
+ *	Parameters are not retained after call, driver need to copy data if
+ *	it need it later.
+ * stop_p2p_find: stop P2P find phase
+ *
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2168,6 +2195,12 @@ struct cfg80211_ops {
 	int	(*start_radar_detection)(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 struct cfg80211_chan_def *chandef);
+
+	int	(*start_p2p_find)(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  struct cfg80211_p2p_find_params *params);
+	void	(*stop_p2p_find)(struct wiphy *wiphy,
+				 struct wireless_dev *wdev);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c46bb01..6a0c263 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -765,6 +765,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_RADAR_DETECT,
 
+	NL80211_CMD_START_P2P_FIND,
+	NL80211_CMD_STOP_P2P_FIND,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 35545cc..c52e4b9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1207,6 +1207,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	}
 	CMD(start_p2p_device, START_P2P_DEVICE);
 	CMD(set_mcast_rate, SET_MCAST_RATE);
+	CMD(start_p2p_find, START_P2P_FIND);
+	CMD(stop_p2p_find, STOP_P2P_FIND);
 
 #ifdef CONFIG_NL80211_TESTMODE
 	CMD(testmode_cmd, TESTMODE);
@@ -7823,6 +7825,131 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int nl80211_start_p2p_find(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct wiphy *wiphy = &rdev->wiphy;
+	struct cfg80211_p2p_find_params params = {};
+	struct nlattr *attr_freq = info->attrs[NL80211_ATTR_SCAN_FREQUENCIES];
+	struct nlattr *attr;
+	struct sk_buff *msg = NULL;
+	void *hdr = NULL;
+	int err, tmp, n_channels, i;
+
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_PROBE_RESP]))
+		return -EINVAL;
+
+	if (!rdev->ops->start_p2p_find || !rdev->ops->stop_p2p_find)
+		return -EOPNOTSUPP;
+
+	if (rdev->scan_req)
+		return -EBUSY;
+
+	if (attr_freq) {
+		n_channels = validate_scan_freqs(attr_freq);
+		if (!n_channels || n_channels > ARRAY_SIZE(params.channels))
+			return -EINVAL;
+	}
+
+	i = 0;
+	if (attr_freq) {
+		/* user specified, bail out if channel not found */
+		nla_for_each_nested(attr, attr_freq, tmp) {
+			struct ieee80211_channel *chan;
+
+			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
+
+			if (!chan)
+				return -EINVAL;
+
+			/* ignore disabled channels */
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			params.channels[i] = chan;
+			i++;
+		}
+		if (!i)
+			return -EINVAL;
+	}
+
+	params.n_channels = i;
+
+	i = 0;
+
+	attr = info->attrs[NL80211_ATTR_IE];
+	if (attr) {
+		params.probe_ie_len = nla_len(attr);
+		params.probe_ie = nla_data(attr);
+	}
+
+	attr = info->attrs[NL80211_ATTR_IE_PROBE_RESP];
+	if (attr) {
+		params.probe_resp_ie_len = nla_len(attr);
+		params.probe_resp_ie = nla_data(attr);
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_START_P2P_FIND);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto free_msg;
+	}
+
+	err = rdev_start_p2p_find(rdev, wdev, &params);
+	if (err)
+		goto free_msg;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+ free_msg:
+	nlmsg_free(msg);
+	return err;
+}
+
+static int nl80211_stop_p2p_find(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct sk_buff *msg = NULL;
+	void *hdr = NULL;
+	int err;
+
+	if (!rdev->ops->start_p2p_find || !rdev->ops->stop_p2p_find)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_STOP_P2P_FIND);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto free_msg;
+	}
+
+	rdev_stop_p2p_find(rdev, wdev);
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+ free_msg:
+	nlmsg_free(msg);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -8499,6 +8626,22 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_START_P2P_FIND,
+		.doit = nl80211_start_p2p_find,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_P2P_FIND,
+		.doit = nl80211_stop_p2p_find,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 422d382..eea01aa 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -887,4 +887,24 @@ static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int rdev_start_p2p_find(struct cfg80211_registered_device *rdev,
+				      struct wireless_dev *wdev,
+				      struct cfg80211_p2p_find_params *params)
+{
+	int ret;
+	trace_rdev_start_p2p_find(&rdev->wiphy, wdev, params);
+	ret = rdev->ops->start_p2p_find(&rdev->wiphy, wdev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void rdev_stop_p2p_find(struct cfg80211_registered_device *rdev,
+				      struct wireless_dev *wdev)
+{
+	trace_rdev_stop_p2p_find(&rdev->wiphy, wdev);
+	rdev->ops->stop_p2p_find(&rdev->wiphy, wdev);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index b7a5313..20ba224 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1785,6 +1785,26 @@ TRACE_EVENT(rdev_set_mac_acl,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->acl_policy)
 );
 
+TRACE_EVENT(rdev_start_p2p_find,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_p2p_find_params *params),
+	TP_ARGS(wiphy, wdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
+);
+
+DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_p2p_find,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
+	TP_ARGS(wiphy, wdev)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.7.10.4


