Return-Path: <SRS0=od2B=OZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F47C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 14:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B60F217FA
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 14:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbeLPOHC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Dec 2018 09:07:02 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:24047 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729822AbeLPOHC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Dec 2018 09:07:02 -0500
X-IronPort-AV: E=Sophos;i="5.56,361,1539640800"; 
   d="scan'208";a="1663952"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 16 Dec 2018 14:59:51 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9107"; a="6611860"
Received: from lx-amasri.mea.qualcomm.com ([10.18.172.210])
  by ironmsg01-ams.qualcomm.com with ESMTP; 16 Dec 2018 14:59:50 +0100
From:   Ahmad Masri <amasri@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH 1/2] cfg80211: Add Automatic Channel Selection (ACS) offload for AP
Date:   Sun, 16 Dec 2018 15:58:10 +0200
Message-Id: <1544968691-20679-2-git-send-email-amasri@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
References: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add ACS offload to let the device select a channel for AP from
a list of channels that the user-space provides. ACS can customize
the method of AP channel selection and add parameters like traffic
load, number of APs on channel and more.

Change-Id: I18cb8460b9418512ac7ac9f76fe8f7f379f2478b
Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
---
 include/net/cfg80211.h       |  33 ++++++++
 include/uapi/linux/nl80211.h |  65 ++++++++++++++++
 net/wireless/mlme.c          |  31 ++++++++
 net/wireless/nl80211.c       | 182 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h       |   6 ++
 net/wireless/rdev-ops.h      |  12 +++
 net/wireless/trace.h         |  23 ++++++
 7 files changed, 352 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ede7fcd..c3faa48 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -715,6 +715,17 @@ struct survey_info {
 	s8 noise;
 };
 
+/**
+ * struct cfg80211_acs_params - ACS parameters
+ * @n_channels: total number of channels for ACS
+ * @channels: list of chan_def to run ACS on
+ */
+struct cfg80211_acs_params {
+	u32 n_channels;
+	/* keep last */
+	struct cfg80211_chan_def channels[0];
+};
+
 #define CFG80211_MAX_WEP_KEYS	4
 
 /**
@@ -3377,6 +3388,11 @@ struct cfg80211_pmsr_request {
  *	Statistics should be cumulative, currently no way to reset is provided.
  * @start_pmsr: start peer measurement (e.g. FTM)
  * @abort_pmsr: abort peer measurement
+ * @acs: run automatic channel selection offload measurement to find the best
+ *	channel to start the AP on. Userspace provide a list of chan_defs, the
+ *	driver should perform ACS on the provided list and select best channel.
+ *	driver should call cfg80211_acs_result to complete this operation.
+ *	(invoked with the wireless_dev mutex held)
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3691,6 +3707,8 @@ struct cfg80211_ops {
 			      struct cfg80211_pmsr_request *request);
 	void	(*abort_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      struct cfg80211_pmsr_request *request);
+	int	(*acs)(struct wiphy *wiphy, struct net_device *dev,
+		       struct cfg80211_acs_params *params);
 };
 
 /*
@@ -4662,6 +4680,7 @@ struct wireless_dev {
 	unsigned long cac_start_time;
 	unsigned int cac_time_ms;
 
+	bool acs_started;
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -6362,6 +6381,20 @@ void cfg80211_cac_event(struct net_device *netdev,
 
 
 /**
+ * cfg80211_acs_result - ACS result notification
+ * @netdev: network device
+ * @chandef: chandef for the selected channel, NULL on unsuccessful operation
+ * @status: ACS status as specified in &enum nl80211_acs_status
+ * @gfp: context flags
+ *
+ * This function is called when ACS measurement is finished or aborted.
+ * This must be called to notify the completion of a ACS process.
+ */
+void cfg80211_acs_result(struct net_device *netdev,
+			 const struct cfg80211_chan_def *chandef,
+			 enum nl80211_acs_status status, gfp_t gfp);
+
+/**
  * cfg80211_gtk_rekey_notify - notify userspace about driver rekeying
  * @dev: network device
  * @bssid: BSSID of AP (to avoid races)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2b53c0e..b993b86f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1032,6 +1032,13 @@
  *	ht opmode or vht opmode changes using any of %NL80211_ATTR_SMPS_MODE,
  *	%NL80211_ATTR_CHANNEL_WIDTH,%NL80211_ATTR_NSS attributes with its
  *	address(specified in %NL80211_ATTR_MAC).
+ * @NL80211_CMD_ACS: For offloaded Automatic Channel Selection (ACS). Userspace
+ *	sends this command before starting an AP, the kernel indicates this
+ *	command after a channel was selected. When sent from userspace has
+ *	attribute NL80211_ATTR_CHAN_DEF for a list of channels (chan_def).
+ *	When sent from kernel has attributes NL80211_ATTR_ACS_STATUS which
+ *	provides the operation status and NL80211_ATTR_WIPHY_FREQ and other
+ *	chan_def attributes which describes the chosen channel.
  *
  * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
  *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
@@ -1277,6 +1284,7 @@ enum nl80211_commands {
 	NL80211_CMD_PEER_MEASUREMENT_START,
 	NL80211_CMD_PEER_MEASUREMENT_RESULT,
 	NL80211_CMD_PEER_MEASUREMENT_COMPLETE,
+	NL80211_CMD_ACS,
 
 	/* add new commands above here */
 
@@ -2273,6 +2281,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_HE_CAPABILITY: HE Capability information element (from
  *	association request when used with NL80211_CMD_NEW_STATION). Can be set
  *	only if %NL80211_STA_FLAG_WME is set.
+ * @NL80211_ATTR_ACS_STATUS: attribute in which kernel indicates ACS status
+ *	as defined in &enum nl80211_acs_status
+ * @NL80211_ATTR_CHAN_DEF: attribute for nesting chan_def parameters
+ *	as defined in &enum nl80211_ch_def_attr. The new attribute allows
+ *	userspace to send a list of struct cfg80211_chan_def. For example, ACS
+ *	command uses this attribute for sending a list of channels, for more
+ *	details see &NL80211_CMD_ACS.
  *
  * @NL80211_ATTR_FTM_RESPONDER: nested attribute which user-space can include
  *	in %NL80211_CMD_START_AP or %NL80211_CMD_SET_BEACON for fine timing
@@ -2741,6 +2756,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PEER_MEASUREMENTS,
 
+	NL80211_ATTR_ACS_STATUS,
+	NL80211_ATTR_CHAN_DEF,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4548,6 +4566,35 @@ enum nl80211_packet_pattern_attr {
 };
 
 /**
+ * enum nl80211_ch_def_attr - channel def attribute
+ * @__NL80211_ATTR_CH_DEF_INVALID: invalid number for nested attribute
+ * @NL80211_ATTR_CH_DEF_FREQ: frequency of the selected channel in MHz,
+ *	defines the channel together with the attributes
+ *	%NL80211_ATTR_CH_DEF_WIDTH and if needed %NL80211_ATTR_CH_DEF_FREQ1 and
+ *	%NL80211_ATTR_CH_DEF_FREQ2
+ * @NL80211_ATTR_CH_DEF_WIDTH: u32 attribute containing one of the values
+ *	of &enum nl80211_chan_width, describing the channel width. See the
+ *	documentation of the enum for more information.
+ * @NL80211_ATTR_CH_DEF_FREQ1: Center frequency of the first part of the
+ *	channel, used for anything but 20 MHz bandwidth
+ * @NL80211_ATTR_CH_DEF_FREQ2: Center frequency of the second part of the
+ *	channel, used only for 80+80 MHz bandwidth
+ * @__NL80211_ATTR_CH_DEF_AFTER_LAST: internal
+ * @NL80211_ATTR_CH_DEF_MAX: max attribute number
+ */
+enum nl80211_ch_def_attr {
+	__NL80211_ATTR_CH_DEF_INVALID,
+	NL80211_ATTR_CH_DEF_FREQ,
+	NL80211_ATTR_CH_DEF_WIDTH,
+	NL80211_ATTR_CH_DEF_FREQ1,
+	NL80211_ATTR_CH_DEF_FREQ2,
+
+	/* keep last */
+	__NL80211_ATTR_CH_DEF_AFTER_LAST,
+	NL80211_ATTR_CH_DEF_MAX = __NL80211_ATTR_CH_DEF_AFTER_LAST - 1
+};
+
+/**
  * struct nl80211_pattern_support - packet pattern support information
  * @max_patterns: maximum number of patterns supported
  * @min_pattern_len: minimum length of each pattern
@@ -5308,6 +5355,8 @@ enum nl80211_feature_flags {
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_ACS_OFFLOAD: The driver supports offload of ACS from
+ *	a list of channels provided by the userspace.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5348,6 +5397,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_ACS_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -5561,6 +5611,21 @@ enum nl80211_dfs_state {
 };
 
 /**
+ * enum nl80211_acs_status - ACS status
+ *
+ * status to be used to inform userspace about the result of the ACS offloaded
+ * measurement.
+ *
+ * @NL80211_ACS_SUCCESS: The ACS operation finished successfully
+ * @NL80211_ACS_FAILED: Failed to run the ACS. Userspace should choose a channel
+ *	by itself.
+ */
+enum nl80211_acs_status {
+	NL80211_ACS_SUCCESS,
+	NL80211_ACS_FAILED,
+};
+
+/**
  * enum enum nl80211_protocol_features - nl80211 protocol features
  * @NL80211_PROTOCOL_FEATURE_SPLIT_WIPHY_DUMP: nl80211 supports splitting
  *	wiphy dumps (if requested by the application with the attribute
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 1615e50..ed36d91 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -903,3 +903,34 @@ void cfg80211_cac_event(struct net_device *netdev,
 	nl80211_radar_notify(rdev, chandef, event, netdev, gfp);
 }
 EXPORT_SYMBOL(cfg80211_cac_event);
+
+void cfg80211_acs_result(struct net_device *netdev,
+			 const struct cfg80211_chan_def *chandef,
+			 enum nl80211_acs_status status, gfp_t gfp)
+{
+	struct wireless_dev *wdev = netdev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	if (WARN_ON(!wdev->acs_started))
+		return;
+
+	switch (status) {
+	case NL80211_ACS_SUCCESS:
+		if (!chandef) {
+			WARN_ON(1);
+			goto out;
+		}
+	case NL80211_ACS_FAILED:
+		break;
+	default:
+		WARN_ON(1);
+		goto out;
+	}
+	nl80211_acs_notify(rdev, chandef, status, netdev, gfp);
+
+out:
+	wdev->acs_started = false;
+	dev_put(netdev);
+}
+EXPORT_SYMBOL(cfg80211_acs_result);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5ec200e..bf25824 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -557,6 +557,8 @@ static int validate_ie_attr(const struct nlattr *attr,
 	[NL80211_ATTR_PEER_MEASUREMENTS] =
 		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
 				  nl80211_pmsr_attr_policy),
+
+	[NL80211_ATTR_CHAN_DEF] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -697,6 +699,15 @@ static int validate_ie_attr(const struct nlattr *attr,
 	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
 };
 
+/* policy for channel attributes */
+static const struct nla_policy
+nl80211_ch_def_policy[NL80211_ATTR_CH_DEF_MAX + 1] = {
+	[NL80211_ATTR_CH_DEF_FREQ] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_DEF_WIDTH] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_DEF_FREQ1] = { .type = NLA_U32 },
+	[NL80211_ATTR_CH_DEF_FREQ2] = { .type = NLA_U32 },
+};
+
 int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 			      struct cfg80211_registered_device **rdev,
 			      struct wireless_dev **wdev)
@@ -2561,6 +2572,66 @@ int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+static int
+nl80211_parse_chandef_new(struct cfg80211_registered_device *rdev,
+			  struct genl_info *info, struct nlattr *channel,
+			  struct cfg80211_chan_def *chandef)
+{
+	u32 control_freq;
+	struct nlattr *attrs[NL80211_ATTR_CH_DEF_MAX + 1];
+	int err;
+
+	if (!channel)
+		return -EINVAL;
+
+	err = nla_parse_nested(attrs, NL80211_ATTR_CH_DEF_MAX, channel,
+			       nl80211_ch_def_policy, info->extack);
+	if (err)
+		return err;
+
+
+	if (!attrs[NL80211_ATTR_CH_DEF_FREQ])
+		return -EINVAL;
+
+	control_freq = nla_get_u32(attrs[NL80211_ATTR_CH_DEF_FREQ]);
+
+	chandef->chan = ieee80211_get_channel(&rdev->wiphy, control_freq);
+	chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+	chandef->center_freq1 = control_freq;
+	chandef->center_freq2 = 0;
+
+	/* Primary channel not allowed */
+	if (!chandef->chan || chandef->chan->flags & IEEE80211_CHAN_DISABLED)
+		return -EINVAL;
+
+	if (attrs[NL80211_ATTR_CH_DEF_WIDTH]) {
+		chandef->width =
+			nla_get_u32(attrs[NL80211_ATTR_CH_DEF_WIDTH]);
+		if (attrs[NL80211_ATTR_CH_DEF_FREQ1])
+			chandef->center_freq1 =
+				nla_get_u32(
+					attrs[NL80211_ATTR_CH_DEF_FREQ1]);
+		if (attrs[NL80211_ATTR_CH_DEF_FREQ2])
+			chandef->center_freq2 =
+				nla_get_u32(
+					attrs[NL80211_ATTR_CH_DEF_FREQ2]);
+	}
+
+	if (!cfg80211_chandef_valid(chandef))
+		return -EINVAL;
+
+	if (!cfg80211_chandef_usable(&rdev->wiphy, chandef,
+				     IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	if ((chandef->width == NL80211_CHAN_WIDTH_5 ||
+	     chandef->width == NL80211_CHAN_WIDTH_10) &&
+	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_5_10_MHZ))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int __nl80211_set_channel(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev,
 				 struct genl_info *info)
@@ -13140,6 +13211,71 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+static int nl80211_acs(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_acs_params *request;
+	struct nlattr *attr;
+	struct wiphy *wiphy;
+	int ret, tmp, n_channels = 0, i = 0;
+
+	if (WARN_ON(wdev->acs_started))
+		return -EALREADY;
+
+	if (!rdev->ops->acs)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP)
+		return -EOPNOTSUPP;
+
+	wiphy = &rdev->wiphy;
+
+	if (!info->attrs[NL80211_ATTR_CHAN_DEF])
+		return -EINVAL;
+
+	nla_for_each_nested(attr,
+			    info->attrs[NL80211_ATTR_CHAN_DEF], tmp)
+		n_channels++;
+
+	if (!n_channels)
+		return -EINVAL;
+
+	request = kzalloc(sizeof(*request) +
+			  sizeof(struct cfg80211_chan_def) * n_channels,
+			  GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	nla_for_each_nested(attr,
+			    info->attrs[NL80211_ATTR_CHAN_DEF], tmp) {
+		struct cfg80211_chan_def chandef;
+
+		ret = nl80211_parse_chandef_new(rdev, info, attr, &chandef);
+		if (ret)
+			goto out_free;
+
+		request->channels[i++] = chandef;
+	}
+	request->n_channels = i;
+
+	wdev->acs_started = true;
+	dev_hold(dev);
+
+	wdev_lock(wdev);
+	ret = rdev_acs(rdev, dev, request);
+	if (ret) {
+		wdev->acs_started = false;
+		dev_put(dev);
+	}
+	wdev_unlock(wdev);
+
+ out_free:
+	kfree(request);
+	return ret;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -14066,6 +14202,15 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_ACS,
+		.doit = nl80211_acs,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -15656,6 +15801,43 @@ void cfg80211_ch_switch_started_notify(struct net_device *dev,
 	nlmsg_free(msg);
 }
 
+void
+nl80211_acs_notify(struct cfg80211_registered_device *rdev,
+		   const struct cfg80211_chan_def *chandef,
+		   enum nl80211_acs_status status,
+		   struct net_device *netdev, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_ACS);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_ACS_STATUS, status))
+		goto nla_put_failure;
+
+	if (nl80211_send_chandef(msg, chandef))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
 				       struct sta_opmode_info *sta_opmode,
 				       gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 531c82d..e406592 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -119,6 +119,12 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		     enum nl80211_radar_event event,
 		     struct net_device *netdev, gfp_t gfp);
 
+void
+nl80211_acs_notify(struct cfg80211_registered_device *rdev,
+		   const struct cfg80211_chan_def *chandef,
+		   enum nl80211_acs_status status,
+		   struct net_device *netdev, gfp_t gfp);
+
 void nl80211_send_ap_stopped(struct wireless_dev *wdev);
 
 void cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev);
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 5cb48d1..ebd9576 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1272,4 +1272,16 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int rdev_acs(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev,
+			   struct cfg80211_acs_params *params)
+{
+	int ret;
+
+	trace_rdev_acs(&rdev->wiphy, dev, params);
+	ret = rdev->ops->acs(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 44b2ce1..c841873 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2530,6 +2530,29 @@
 	TP_ARGS(wiphy, wdev, cookie)
 );
 
+TRACE_EVENT(rdev_acs,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_acs_params *params),
+
+	TP_ARGS(wiphy, netdev, params),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u32, n_channels)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->n_channels = params->n_channels;
+	),
+
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT
+		  ", num of channels: %u", WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  __entry->n_channels)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.9.1

