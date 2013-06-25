Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40919 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3FYNmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 09:42:55 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>, Peer@vger.kernel.org,
	Ilan <ilan.peer@intel.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v12 2/2] cfg80211: P2P find phase offload
Date: Tue, 25 Jun 2013 16:42:36 +0300
Message-ID: <1372167756-17928-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130625_154258_542058_8F37B4E0)
In-Reply-To: <1372167756-17928-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1372167756-17928-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow to implement P2P find phase in the driver/firmware.

Offload scheme designed as follows:

- Driver provide methods start_p2p_find and stop_p2p_find in the cfg80211_ops;
- Driver indicate firmware or driver responds to the probe requests by setting
  feature NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD
- wpa_supplicant analyses methods supported to discover p2p offload support;
- wpa_supplicant analyses feature flags to discover p2p probe response
  offload support;
to perform p2p scan, wpa_supplicant:
- perform legacy scan, through driver's cfg80211_ops 'scan' method
- configure rx management filter to get probe-request and probe-response frames
- start p2p find via driver's cfg80211_ops start_p2p_find method
- driver start p2p find with hardware and notify wpa_supplicant with
  cfg80211_p2p_find_notify_start()
- driver/firmware toggle search/listen states. Received probe-request and
  probe-response frames passed to the wpa_supplicant via cfg80211_rx_mgmt
- when wpa_supplicant wants to stop p2p find, it calls driver's
  cfg80211_ops stop_p2p_find method. Alternatively, driver/firmware may decide
  to stop p2p find. In all cases, driver notifies wpa_supplicant using
  cfg80211_p2p_find_notify_end()

All driver to user space communication done through nl80211 layer.

Offloaded P2P find does not support variations like progressive scan.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/net/cfg80211.h       |  76 ++++++++++++++++++
 include/uapi/linux/nl80211.h |  14 ++++
 net/wireless/nl80211.c       | 180 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  19 +++++
 net/wireless/trace.h         |  44 +++++++++++
 5 files changed, 333 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8347500..e3cc49c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1805,6 +1805,38 @@ struct cfg80211_update_ft_ies_params {
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
+ * @channels: channels to operate on
+ *	may be NULL, in this case driver suppose to scan for all social
+ *	channels; or channel set should be non-empty (n_channels > 0)
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
@@ -2043,6 +2075,24 @@ struct cfg80211_update_ft_ies_params {
  *	driver can take the most appropriate actions.
  * @crit_proto_stop: Indicates critical protocol no longer needs increased link
  *	reliability. This operation can not fail.
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
@@ -2278,6 +2328,12 @@ struct cfg80211_ops {
 				    u16 duration);
 	void	(*crit_proto_stop)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*start_p2p_find)(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  struct cfg80211_p2p_find_params *params);
+	void	(*stop_p2p_find)(struct wiphy *wiphy,
+				 struct wireless_dev *wdev);
 };
 
 /*
@@ -4177,6 +4233,26 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
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
+ * ops->stop_p2p_find
+ *
+ * In any case, if @start_p2p_find from driver's struct cfg80211_ops called,
+ * @cfg80211_p2p_find_notify_end should be eventually called
+ */
+void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f125d2c..3a2f2b0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -810,6 +810,9 @@ enum nl80211_commands {
 	NL80211_CMD_CRIT_PROTOCOL_START,
 	NL80211_CMD_CRIT_PROTOCOL_STOP,
 
+	NL80211_CMD_START_P2P_FIND,
+	NL80211_CMD_STOP_P2P_FIND,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1438,6 +1441,10 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_RXMGMT_FLAGS: flags for cfg80211_rx_mgmt, u32
  *
+ * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL:
+ * @NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL: min/max discoverable interval
+ *	for the p2p find, multiple of 100 TUs, represented as u32
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1740,6 +1747,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_RXMGMT_FLAGS,
 
+	NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL,
+	NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3592,6 +3602,9 @@ enum nl80211_ap_sme_features {
  *	interface. An active monitor interface behaves like a normal monitor
  *	interface, but gets added to the driver. It ensures that incoming
  *	unicast packets directed at the configured interface address get ACKed.
+ * @NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD: When in P2P find phase,
+ *	the device may respond to some probe-requests in hardware;
+ *	replied probe-requests may be not reported to the upper layers.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3612,6 +3625,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 15,
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
+	NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD		= 1 << 18,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 65c5578..a36ff7e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -349,6 +349,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_PEER_AID] = { .type = NLA_U16 },
+	[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -1387,6 +1389,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		if (split) {
 			CMD(crit_proto_start, CRIT_PROTOCOL_START);
 			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
+			CMD(start_p2p_find, START_P2P_FIND);
+			CMD(stop_p2p_find, STOP_P2P_FIND);
 		}
 
 #ifdef CONFIG_NL80211_TESTMODE
@@ -8306,6 +8310,129 @@ static int nl80211_crit_protocol_stop(struct sk_buff *skb,
 	return 0;
 }
 
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
+	struct nlattr *attr_freq = info->attrs[NL80211_ATTR_SCAN_FREQUENCIES];
+	struct nlattr *attr_l_freq = info->attrs[NL80211_ATTR_WIPHY_FREQ];
+	struct nlattr *attr;
+	int err, tmp, n_channels, i = 0;
+	struct ieee80211_channel **channels = NULL;
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
+	chan = ieee80211_get_channel(wiphy, nla_get_u32(attr_l_freq));
+	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+	params.listen_channel = chan;
+
+	if (attr_freq) {
+		n_channels = validate_scan_freqs(attr_freq);
+		if (!n_channels)
+			return -EINVAL;
+
+		channels = kzalloc(n_channels * sizeof(*channels), GFP_KERNEL);
+		if (!channels)
+			return -ENOMEM;
+
+		/* user specified, bail out if channel not found */
+		nla_for_each_nested(attr, attr_freq, tmp) {
+			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
+
+			if (!chan) {
+				err = -EINVAL;
+				goto out_free;
+			}
+
+			/* ignore disabled channels */
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			params.channels[i] = chan;
+			i++;
+		}
+		if (!i) {
+			err = -EINVAL;
+			goto out_free;
+		}
+
+		params.n_channels = i;
+		params.channels = channels;
+	}
+
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
+	attr = info->attrs[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL];
+	if (attr)
+		params.min_discoverable_interval = nla_get_u32(attr);
+
+	attr = info->attrs[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL];
+	if (attr)
+		params.max_discoverable_interval = nla_get_u32(attr);
+
+	err = rdev_start_p2p_find(rdev, wdev, &params);
+
+out_free:
+	kfree(channels);
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
+	rdev_stop_p2p_find(rdev, wdev);
+
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -8978,6 +9105,22 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -10645,6 +10788,43 @@ void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
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
+	cfg80211_p2p_find_notify(wdev, NL80211_CMD_STOP_P2P_FIND, gfp);
+}
+EXPORT_SYMBOL(cfg80211_p2p_find_notify_end);
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 9f15f0a..94ff98a 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -923,4 +923,23 @@ static inline void rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
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
index e1534baf..d4e4886 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1841,6 +1841,36 @@ TRACE_EVENT(rdev_crit_proto_stop,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
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
@@ -2520,6 +2550,20 @@ TRACE_EVENT(cfg80211_ft_event,
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

