Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:35406 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3CQI4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 04:56:17 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] P2P find offload
Date: Sun, 17 Mar 2013 10:56:12 +0200
Message-ID: <1958495.JVcc1yGep9@lx-vladimir> (sfid-20130317_095622_543997_4116C8D6)
In-Reply-To: <1363372823.8656.41.camel@jlt4.sipsolutions.net>
References: <3408094.SIuA27EmQ5@lx-vladimir> <2799886.P5v870j3h2@lx-vladimir> <1363372823.8656.41.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, March 15, 2013 07:40:23 PM Johannes Berg wrote:
> 
> > Allow to implement P2P find phase in the driver/firmware.
> > 
> > Offload scheme designed as follows:
> > 
> > - Driver provide methods start_p2p_find and stop_p2p_find in the cfg80211_ops;
> >   indicates support for p2p find offload by setting feature
> >   NL80211_FEATURE_P2P_FIND_OFFLOAD
> 
> Why not just indicate the command presence rather than a feature flag?

I also thought this way, it was my impression you was asking for feature flag
earlier:
--cut--
> You're also entirely missing feature advertising, so userspace can only
> guess whether it's supported or not ...
--cut--

But I should be mis-interpreting, let's remove feature flag.

> > - perform legacy scan, through driver's cfg80211_ops 'scan' method
> 
> Why the legacy scan? btw this is what I was worried about -- this API
> robs us of the ability to do "progressive" p2p scan.

It is how P2P spec defines device discovery (P2P specification v1.3_D4):

3.1.2.1 Basic mechanisms of Device Discovery
The objective of P2P Device Discovery is to find P2P Devices and quickly
determine the P2P Device to which a connection will be attempted.
P2P Device Discovery consists of two major phases: Scan and Find, which are
described in detail in the following sections.
<skip>
3.1.2.1.2 Scan Phase
The Scan Phase uses the scanning process defined in IEEE Std 802.11-2007 [1]
for a non-DMG network and defined in [15][16] for a DMG network. It may be
used by a P2P Device to find P2P Devices or P2P Groups and to locate the best
potential Operating Channel to establish a P2P Group. In the Scan Phase,
devices collect information about surrounding devices or networks by scanning
all supported channels.


So it is spec that says P2P scan includes legacy scan. Actually, prpposed API
do not mandate it, in makes possible to use any scan variations. Comment text
outlines typical scan flow.

For "progressive" P2P scan - do you mean normal scan or find phase? For normal
scan, nothing changes and one can use any scan optimisations. For find phase -
spec don't let you do so, it pretty much mandates what and when to do.

> > - configure rx management filter to get probe-request and probe-response frames
> 
> Interesting, so this is pretty much bypassing the scan BSS table
> mechanism. I guess it makes sense though.

Yes, indeed. Probe requests it is how 'listening' peer discovers the
'searching' one. And, I don't want P2P stuff to mix with BSS table, as
it likely to confuse legacy scan logic.

> > - driver start p2p find with hardware and notify wpa_supplicant with
> >   cfg80211_p2p_find_notify(NL80211_CMD_START_P2P_FIND)
> 
> See other mail -- is that really useful?

I copied it here:

> Is there really much value in indications, rather than having it start
> right away? Similarly, in particular if sending probe responses is
> offloaded, is there really any reason for userspace to care? OTOH, we
> also send an indication when a scan starts, so maybe it's useful that
> way. Just seems that the code requesting this would assume that if it
> didn't get an error, it will be started, and not really care about when
> it really started operating.

There are 2 points:
1) timing. For hardware, it may take time to really start find phase.
For card I am working on now, 60G one, it tooks some 150ms.
I suppose, upper layers may be confused with this delay.
2) hardware may decide to end find phase on its own, in this case 'end'
notification is a must; it seems more consistent to provide both 'start'
and 'end'.

> >   cfg80211_p2p_find_notify(NL80211_CMD_STOP_P2P_FIND)
> 
> btw, if both are needed I'd prefer not to give a command number here,
> it's useless to give anything else and this is a bit confusing.

OK, will do it. Split this to 2 functions,
cfg80211_p2p_find_notify_start() and cfg80211_p2p_find_notify_end(),
yes?

Open question: can supplicant be interested in more details, like when
'search' started, and when 'listen' started for particular channel?

> >  /**
> > + * struct cfg80211_p2p_find_params - parameters for P2P find
> > + * @probe_ie: IE's for probe frames
> 
> probe request, presumably?

Yes, but spec call it 'probe', it does not use 'probe request' term.

> 
> Also, this is probably *additional* IEs, i.e. supported rates etc. are
> expected to be created by the driver?

In params for start_ap, it is called 'extra' IE's;
I will call it the same here for consistency.

> 
> > + * @probe_resp_ie: IE's for probe response frames
> 
> similarly here?
> 
> > + * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
> > + * @min_discoverable_interval and
> 
> need : otherwise it's not valid kernel-doc

OK

> 
> > + * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL,
> 
> same here

OK

> 
> > +	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
> > +				nl80211_scan_mcgrp.id, GFP_KERNEL);
> 
> indentation
I double checked, identation seems OK. Checkpatch also fine.

For trace.h, whole file uses one-tab identation after TRACE_EVENT
or DEFINE_EVENT; yes it is not what checkpatch likes.
But, should I follow the file style or properly indent my additions
in non-consistent with the rest of file style?
I left it with the same identation as the rest of file.


> johannes

Patch follows

Thanks, Vladimir

>From fa8c2a98b61ad8cbdd42ac41385f5839b49dba6a Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Sun, 10 Mar 2013 15:52:37 +0200
Subject: [PATCH v3] cfg80211: P2P find phase offload

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

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   56 ++++++++++++++
 include/uapi/linux/nl80211.h |   13 ++++
 net/wireless/nl80211.c       |  167 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   19 +++++
 net/wireless/trace.h         |   34 +++++++++
 5 files changed, 289 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bdba9b6..e2fdbb8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1780,6 +1780,30 @@ struct cfg80211_update_ft_ies_params {
 };
 
 /**
+ * struct cfg80211_p2p_find_params - parameters for P2P find
+ * @probe_ie: extra IE's for probe frames
+ * @probe_ie_len: length, bytes, of @probe_ie
+ * @probe_resp_ie: extra IE's for probe response frames
+ * @probe_resp_ie_len: length, bytes, of @probe_resp_ie
+ * @min_discoverable_interval: and
+ * @max_discoverable_interval: min/max for random multiplier of 100TU's
+ *	for the listen state duration
+ * @n_channels: number of channels to operate on
+ * @channels: channels to operate on
+ */
+struct cfg80211_p2p_find_params {
+	const u8 *probe_ie;
+	size_t probe_ie_len;
+	const u8 *probe_resp_ie;
+	size_t probe_resp_ie_len;
+	u32 min_discoverable_interval;
+	u32 max_discoverable_interval;
+
+	int n_channels;
+	struct ieee80211_channel **channels;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -1998,6 +2022,15 @@ struct cfg80211_update_ft_ies_params {
  *	advertise the support for MAC based ACL have to implement this callback.
  *
  * @start_radar_detection: Start radar detection in the driver.
+ *
+ * start_p2p_find: start P2P find phase
+ *	Parameters include IEs for probe/probe-resp frames;
+ *	and channels to operate on.
+ *	Parameters are not retained after call, driver need to copy data if
+ *	it need it later.
+ *	P2P find can't run concurrently with ROC or scan, and driver should
+ *	check this.
+ * stop_p2p_find: stop P2P find phase
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2227,6 +2260,12 @@ struct cfg80211_ops {
 					 struct cfg80211_chan_def *chandef);
 	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_update_ft_ies_params *ftie);
+
+	int	(*start_p2p_find)(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  struct cfg80211_p2p_find_params *params);
+	void	(*stop_p2p_find)(struct wiphy *wiphy,
+				 struct wireless_dev *wdev);
 };
 
 /*
@@ -4122,6 +4161,23 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				   struct cfg80211_wowlan_wakeup *wakeup,
 				   gfp_t gfp);
 
+/**
+ * cfg80211_p2p_find_notify_start - report p2p find state started
+ * @wdev: the wireless device reporting the event
+ * @gfp: allocation flags
+ */
+void cfg80211_p2p_find_notify_start(struct wireless_dev *wdev, gfp_t gfp);
+
+/**
+ * cfg80211_p2p_find_notify_end - report p2p find state ended
+ * @wdev: the wireless device reporting the event
+ * @gfp: allocation flags
+ *
+ * p2p find state may be ended either unsolicited or in response to
+ * @ops->p2p_stop_find
+ */
+void cfg80211_p2p_find_notify_end(struct wireless_dev *wdev, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 79da871..c8a8fe0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -798,6 +798,9 @@ enum nl80211_commands {
 	NL80211_CMD_UPDATE_FT_IES,
 	NL80211_CMD_FT_EVENT,
 
+	NL80211_CMD_START_P2P_FIND,
+	NL80211_CMD_STOP_P2P_FIND,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1414,6 +1417,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_IE_RIC: Resource Information Container Information
  *	Element
  *
+ * @NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL:
+ * @NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL: min/max discoverable interval
+ *	for the p2p find, represented as u32
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1709,6 +1716,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_MDID,
 	NL80211_ATTR_IE_RIC,
 
+	NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL,
+	NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3538,6 +3548,8 @@ enum nl80211_ap_sme_features {
  *	Peering Management entity which may be implemented by registering for
  *	beacons or NL80211_CMD_NEW_PEER_CANDIDATE events. The mesh beacon is
  *	still generated by the driver.
+ * @NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD: When in P2P find phase,
+ *	the device responds to probe-requests in hardware.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3557,6 +3569,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_ADVERTISE_CHAN_LIMITS		= 1 << 14,
 	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 15,
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
+	NL80211_FEATURE_P2P_PROBE_RESP_OFFLOAD		= 1 << 17,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f924d45..374a667 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -378,6 +378,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_MDID] = { .type = NLA_U16 },
 	[NL80211_ATTR_IE_RIC] = { .type = NLA_BINARY,
 				  .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_MIN_DISCOVERABLE_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_ATTR_MAX_DISCOVERABLE_INTERVAL] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -1417,6 +1419,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		}
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
+	CMD(start_p2p_find, START_P2P_FIND);
+	CMD(stop_p2p_find, STOP_P2P_FIND);
 
 #ifdef CONFIG_NL80211_TESTMODE
 		CMD(testmode_cmd, TESTMODE);
@@ -8196,6 +8200,113 @@ static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
 	return rdev_update_ft_ies(rdev, dev, &ft_params);
 }
 
+static int nl80211_start_p2p_find(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct wiphy *wiphy = &rdev->wiphy;
+	struct cfg80211_p2p_find_params params = {};
+	struct nlattr *attr_freq = info->attrs[NL80211_ATTR_SCAN_FREQUENCIES];
+	struct nlattr *attr;
+	int err, tmp, n_channels, i = 0;
+	struct ieee80211_channel **channels = NULL;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_STATION:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
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
+		if (!n_channels)
+			return -EINVAL;
+
+		channels = kzalloc(n_channels * sizeof(*channels), GFP_KERNEL);
+		if (!channels)
+			return -ENOMEM;
+
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
@@ -8873,6 +8984,22 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -10547,6 +10674,46 @@ void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
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
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
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
index d77e1c1..5e43d50 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -901,4 +901,23 @@ static inline int rdev_update_ft_ies(struct cfg80211_registered_device *rdev,
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
index 23e063b..d2faecc 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1805,6 +1805,26 @@ TRACE_EVENT(rdev_update_ft_ies,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->md)
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
@@ -2459,6 +2479,20 @@ TRACE_EVENT(cfg80211_ft_event,
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
1.7.10.4




