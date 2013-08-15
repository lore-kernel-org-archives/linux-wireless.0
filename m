Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56149 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3HOLwS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 07:52:18 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v14 2/2] cfg80211: P2P find phase offload
Date: Thu, 15 Aug 2013 14:51:29 +0300
Message-ID: <1376567489-1863-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130815_135221_629848_8CC4EC77)
In-Reply-To: <1376567489-1863-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1376567489-1863-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to implement P2P find phase in the driver/firmware.

Offload scheme designed as follows:

- Driver provide methods start_p2p_find and stop_p2p_find in the cfg80211_ops;
- wpa_supplicant analyses methods supported to discover p2p offload support;
to perform p2p scan, wpa_supplicant:
- perform legacy scan, through driver's cfg80211_ops 'scan' method
- configure rx management filter to get probe-request and probe-response frames
- start p2p find via driver's cfg80211_ops start_p2p_find method
- driver start p2p find with hardware and notify wpa_supplicant with
  cfg80211_p2p_find_notify_start()
- driver/firmware toggle search/listen states. Received probe-request and
  probe-response frames passed to the wpa_supplicant via cfg80211_rx_mgmt;
  replied by driver/firmware probe-request frames indicated with
  NL80211_RXMGMT_FLAG_REPLIED flag
- when wpa_supplicant wants to stop p2p find, it calls driver's
  cfg80211_ops stop_p2p_find method. Alternatively, driver/firmware may decide
  to stop p2p find. In all cases, driver notifies wpa_supplicant using
  cfg80211_p2p_find_notify_end()

All driver to user space communication done through nl80211 layer.

Offloaded P2P find does not support variations like progressive scan.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/net/cfg80211.h       |  76 ++++++++++++++++
 include/uapi/linux/nl80211.h |  10 +++
 net/wireless/nl80211.c       | 210 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  19 ++++
 net/wireless/trace.h         |  44 +++++++++
 5 files changed, 359 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1ee9d3..c831f8b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1924,6 +1924,36 @@ struct cfg80211_update_ft_ies_params {
 };
 
 /**
+ * struct cfg80211_p2p_find_params - parameters for P2P find
+ * @probe_ie: extra IE's for probe frames
+ * @probe_ie_len: length, bytes, of @probe_ie
+ * @probe_resp_ie: extra IE's for probe response frames
+ * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
+ *	Driver/firmware may add additional IE's as well as modify
+ *	provided ones; typical IE's to be added are
+ *	WLAN_EID_EXT_SUPP_RATES, WLAN_EID_DS_PARAMS,
+ *	WLAN_EID_HT_CAPABILITY.
+ * @min_discoverable_interval: and
+ * @max_discoverable_interval: min/max for random multiplier of 100TU's
+ *	for the listen state duration
+ * @listen_channel: channel to listen on; not NULL
+ * @n_channels: number of channels to operate on
+ * @channels: channels to operate on; non-empty list
+ */
+struct cfg80211_p2p_find_params {
+	const u8 *probe_ie;
+	size_t probe_ie_len;
+	const u8 *probe_resp_ie;
+	size_t probe_resp_ie_len;
+	u32 min_discoverable_interval;
+	u32 max_discoverable_interval;
+	struct ieee80211_channel *listen_channel;
+
+	int n_channels;
+	struct ieee80211_channel **channels;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2165,6 +2195,24 @@ struct cfg80211_update_ft_ies_params {
  * @set_coalesce: Set coalesce parameters.
  *
  * @channel_switch: initiate channel-switch procedure (with CSA)
+ *
+ * @start_p2p_find: start P2P find phase
+ *	Parameters include IEs for probe/probe-resp frames;
+ *	and channels to operate on.
+ *	Parameters are not retained after call, driver need to copy data if
+ *	it need it later.
+ *	P2P find can't run concurrently with ROC or scan,
+ *	conflict with scan detected by cfg80211 and -EBUSY returned;
+ *	and driver should check for ROC and return -EBUSY to indicate conflict.
+ *	While performing P2P discovery, driver should report received
+ *	probe-request and probe-response frames via cfg80211_rx_mgmt
+ *	accordingly to the rx mgmt filter, as set by mgmt_frame_register().
+ *	If device indicates NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD, it may
+ *	reply some matching probes and replied probes may be not reported to
+ *	the upper layers; otherwise it must not reply any probe.
+ * @stop_p2p_find: stop P2P find phase
+ *	After stopping p2p find, driver should call
+ *	cfg80211_p2p_find_notify_end() to inform upper layers
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2406,6 +2454,12 @@ struct cfg80211_ops {
 	int	(*channel_switch)(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  struct cfg80211_csa_settings *params);
+
+	int	(*start_p2p_find)(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  struct cfg80211_p2p_find_params *params);
+	void	(*stop_p2p_find)(struct wiphy *wiphy,
+				 struct wireless_dev *wdev);
 };
 
 /*
@@ -3062,6 +3116,7 @@ struct wireless_dev {
 	struct mutex mtx;
 
 	bool use_4addr, p2p_started;
+	bool p2p_find_active; /* protected by rtnl */
 
 	u8 address[ETH_ALEN] __aligned(sizeof(u16));
 
@@ -4376,6 +4431,27 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
  */
 void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
 
+/**
+ * cfg80211_p2p_find_notify_start - report p2p find phase started
+ * @wdev: the wireless device reporting the event
+ * @gfp: allocation flags
+ */
+void cfg80211_p2p_find_notify_start(struct wireless_dev *wdev, gfp_t gfp);
+
+/**
+ * cfg80211_p2p_find_notify_end - report p2p find phase ended
+ * @wdev: the wireless device reporting the event
+ * @gfp: allocation flags
+ *
+ * p2p find phase may be ended either unsolicited or in response to
+ * ops->stop_p2p_find. If called out of context of ops->stop_p2p_find,
+ * should be protected with rtnl_lock()
+ *
+ * In any case, if @start_p2p_find from driver's struct cfg80211_ops called,
+ * @cfg80211_p2p_find_notify_end should be eventually called
+ */
+void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fc1665e..5a00bd61 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -853,6 +853,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_CHANNEL_SWITCH,
 
+	NL80211_CMD_START_P2P_FIND,
+	NL80211_CMD_STOP_P2P_FIND,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1497,6 +1500,10 @@ enum nl80211_commands {
  *	As specified in the enum nl80211_rxmgmt_flags.
  *	Passed from cfg80211_rx_mgmt()
  *
+ * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL:
+ * @NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL: min/max discoverable interval
+ *	for the p2p find, multiple of 100 TUs, represented as u32
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1807,6 +1814,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RXMGMT_FLAGS,
 
+	NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL,
+	NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8dbb289..d2a85f1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,6 +354,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CSA_IES] = { .type = NLA_NESTED },
 	[NL80211_ATTR_CSA_C_OFF_BEACON] = { .type = NLA_U16 },
 	[NL80211_ATTR_CSA_C_OFF_PRESP] = { .type = NLA_U16 },
+	[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -1431,6 +1433,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
 			if (dev->wiphy.flags & WIPHY_FLAG_HAS_CHANNEL_SWITCH)
 				CMD(channel_switch, CHANNEL_SWITCH);
+			CMD(start_p2p_find, START_P2P_FIND);
+			CMD(stop_p2p_find, STOP_P2P_FIND);
 		}
 
 #ifdef CONFIG_NL80211_TESTMODE
@@ -8762,6 +8766,157 @@ static int nl80211_crit_protocol_stop(struct sk_buff *skb,
 	return 0;
 }
 
+static int p2p_find_handle_channel(struct wiphy *wiphy,
+				    struct cfg80211_p2p_find_params *params,
+				    u32 freq)
+{
+	struct ieee80211_channel *chan = ieee80211_get_channel(wiphy, freq);
+
+	if (!chan)
+		return -EINVAL;
+
+	/* ignore disabled channels */
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		return 0;
+
+	params->channels[params->n_channels++] = chan;
+	return 0;
+}
+
+static int nl80211_start_p2p_find(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct wiphy *wiphy = &rdev->wiphy;
+	/*
+	 * Defaults, as defined in the spec
+	 * Ref: Wi-Fi Peer-to-Peer (P2P) Technical Specification v1.1
+	 * Clause: 3.1.2.1.3 Find Phase
+	 */
+	struct cfg80211_p2p_find_params params = {
+		.min_discoverable_interval = 1,
+		.max_discoverable_interval = 3,
+	};
+	/* P2P spec defines social channels 1,6,11 @2.4GHz and 2 @60GHz */
+	static u32 social_freqs[] = {2412, 2437, 2462, 60480};
+	struct nlattr *attr_freq = info->attrs[NL80211_ATTR_SCAN_FREQUENCIES];
+	struct nlattr *attr_l_freq = info->attrs[NL80211_ATTR_WIPHY_FREQ];
+	struct nlattr *attr;
+	int err, tmp, n_channels;
+	struct ieee80211_channel *chan;
+
+	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->start_p2p_find || !rdev->ops->stop_p2p_find)
+		return -EOPNOTSUPP;
+
+	if (!attr_l_freq)
+		return -EINVAL;
+
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE_PROBE_RESP]))
+		return -EINVAL;
+
+	if (rdev->scan_req)
+		return -EBUSY;
+
+	if (wdev->p2p_find_active)
+		return -EBUSY;
+
+	chan = ieee80211_get_channel(wiphy, nla_get_u32(attr_l_freq));
+	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+	params.listen_channel = chan;
+
+	attr = info->attrs[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL];
+	if (attr)
+		params.min_discoverable_interval = nla_get_u32(attr);
+
+	attr = info->attrs[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL];
+	if (attr)
+		params.max_discoverable_interval = nla_get_u32(attr);
+
+	if (params.min_discoverable_interval >
+	    params.max_discoverable_interval)
+		return -EINVAL;
+
+	if (attr_freq) {
+		n_channels = validate_scan_freqs(attr_freq);
+		if (!n_channels)
+			return -EINVAL;
+	} else {
+		n_channels = ARRAY_SIZE(social_freqs);
+	}
+	params.channels = kcalloc(n_channels, sizeof(*params.channels),
+				  GFP_KERNEL);
+	if (!params.channels)
+		return -ENOMEM;
+
+	if (attr_freq) {
+		/* user specified, bail out if channel not found */
+		nla_for_each_nested(attr, attr_freq, tmp) {
+			err = p2p_find_handle_channel(wiphy, &params,
+						      nla_get_u32(attr));
+			if (err)
+				goto out_free;
+		}
+	} else { /* all supported social channels */
+		/* ignore errors for non-existing channels */
+		for (tmp = 0; tmp < ARRAY_SIZE(social_freqs); tmp++) {
+			p2p_find_handle_channel(wiphy, &params,
+						social_freqs[tmp]);
+		}
+	}
+	if (!params.n_channels) {
+		err = -EINVAL;
+		goto out_free;
+	}
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
+	wdev->p2p_find_active = true;
+	err = rdev_start_p2p_find(rdev, wdev, &params);
+	if (err)
+		wdev->p2p_find_active = false;
+
+out_free:
+	kfree(params.channels);
+
+	return err;
+}
+
+static int nl80211_stop_p2p_find(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+
+	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->start_p2p_find || !rdev->ops->stop_p2p_find)
+		return -EOPNOTSUPP;
+
+	if (!wdev->p2p_find_active)
+		return -ENOENT;
+
+	rdev_stop_p2p_find(rdev, wdev);
+
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -9435,6 +9590,22 @@ static struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
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
+	{
 		.cmd = NL80211_CMD_GET_PROTOCOL_FEATURES,
 		.doit = nl80211_get_protocol_features,
 		.policy = nl80211_policy,
@@ -11126,6 +11297,45 @@ void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
 }
 EXPORT_SYMBOL(cfg80211_tdls_oper_request);
 
+static
+void cfg80211_p2p_find_notify(struct wireless_dev *wdev, int cmd, gfp_t gfp)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	trace_cfg80211_p2p_find_notify(wdev, cmd);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
+void cfg80211_p2p_find_notify_start(struct wireless_dev *wdev, gfp_t gfp)
+{
+	cfg80211_p2p_find_notify(wdev, NL80211_CMD_START_P2P_FIND, gfp);
+}
+EXPORT_SYMBOL(cfg80211_p2p_find_notify_start);
+
+void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp)
+{
+	ASSERT_RTNL();
+	cfg80211_p2p_find_notify(wdev, NL80211_CMD_STOP_P2P_FIND, gfp);
+	wdev->p2p_find_active = false;
+}
+EXPORT_SYMBOL(cfg80211_p2p_find_notify_end);
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index de870d4..6c3f463 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -935,4 +935,23 @@ static inline int rdev_channel_switch(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
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
index f0ebdcd..ec5b0cd 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1874,6 +1874,36 @@ TRACE_EVENT(rdev_channel_switch,
 		  __entry->counter_offset_presp)
 );
 
+TRACE_EVENT(rdev_start_p2p_find,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_p2p_find_params *params),
+	TP_ARGS(wiphy, wdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u32, min_di)
+		__field(u32, max_di)
+		__field(u32, listen_freq)
+		__field(int, n_channels)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->min_di = params->min_discoverable_interval;
+		__entry->max_di = params->max_discoverable_interval;
+		__entry->listen_freq = params->listen_channel->center_freq;
+		__entry->n_channels = params->n_channels;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", listen %d MHz, disc. int. [%d..%d], n_channels %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->listen_freq,
+		  __entry->min_di, __entry->max_di, __entry->n_channels)
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
@@ -2557,6 +2587,20 @@ TRACE_EVENT(cfg80211_ft_event,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(target_ap))
 );
 
+TRACE_EVENT(cfg80211_p2p_find_notify,
+	TP_PROTO(struct wireless_dev *wdev, int cmd),
+	TP_ARGS(wdev, cmd),
+	TP_STRUCT__entry(
+		WDEV_ENTRY
+		__field(int, cmd)
+	),
+	TP_fast_assign(
+		WDEV_ASSIGN;
+		__entry->cmd = cmd;
+	),
+	TP_printk(WDEV_PR_FMT ", cmd: %d", WDEV_PR_ARG, __entry->cmd)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.8.1.2

