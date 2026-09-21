Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294D1485CC1
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 18:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790017171; cv=none; b=BDWSoDqBk3jE6Zt/96wep432G60SVKz53jS4bGnzCX3oBSy6W5diS0piqWVuLsbrT76xIdsM4umwFPgWWwYSUKnnu0zsZgOwWtcwqUhzXqNuTXDl+saSDy5bQK3ZBOYFSSwgjG7a6UGq6JmZElaQEjLKIFM7zdpkdVjVsYcgofg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790017171; c=relaxed/simple;
	bh=RyB0S2bxXiBx1l0jBao0oN5P8LCmS2kKVb95gtCCh5I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=XcdROzUx5B4hX3Qz1xpCoGmHkM1RkmscEiAqtMfWuFbvIoKM6rY4vymAsVT7UooSc73fStbO1mnAaG0gMYngbjhC8CuyjMUIOlmULnqDYI8gWOd5n7NpQ0AkKFQ88G+hYUvvzMI6mw2XmLtMQa4qR4jaADwbZ+1mSBzaJ5u2hNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FOf+4BI0; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FOf+4BI0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790017169; x=1821553169;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RyB0S2bxXiBx1l0jBao0oN5P8LCmS2kKVb95gtCCh5I=;
  b=FOf+4BI0gCv/s7H7axb9/MI9EqG1pRzVVwqAiccHrgQPNKTEoX0fPAOD
   8k6R7JhCNNK50LzOOyEEomIonhfdtkuIJcv4AIqsor8QzMQfvJitV8cX6
   3uoVDkQ2h+qsEegFuG8wKvDPlmAfSb0/eFyNSTtQDjb04nWwvGas+tQrb
   iJsaTdEgTkBI1BH+6Go4/MZ1iOblyXC223D6my5pAQMMtjOHgeJdsGcBH
   o//t4xop16c2TEckEKgihq4532kALtM5O81VLTJ21r8+vPrAMqC8DEWDn
   ZJ4M9vDF4BlZeFcbcM+3W69xk+vVLrcY6YD6kDbQry3rfy65ZmB3Io9je
   Q==;
X-CSE-ConnectionGUID: StOx5ZtpQUiUYuMDOreyjA==
X-CSE-MsgGUID: hdwQWQfwS6yl/Ij/3XqQow==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="101155177"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="101155177"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 11:59:28 -0700
X-CSE-ConnectionGUID: 0T+BdzStSQWXqOtJ7UDewg==
X-CSE-MsgGUID: p+7ly/zKSYyNHR34izsbug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277573332"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 11:59:27 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 1/2] wifi: cfg80211: add NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS
Date: Mon, 21 Sep 2026 22:00:22 +0300
Message-Id: <20260921215936.2efc32011e73.Ice8839058e114f6f9783079807df446388187dda@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Add a new NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS command that lets user
space mark a set of NAN channels as non-evacuable. The command carries
the channels as nested NL80211_ATTR_NAN_CHANNEL attributes (chandef
only) and replaces the entire set of non-evacuable channels; channels
not included in the list become evacuable again.

All provided channels must already exist in the current local schedule,
otherwise -ENOENT is returned. The command is rejected with -EBUSY
while a schedule update is pending.

This prevents the kernel from evacuating channels that carry NDC or
immutable schedules, so evacuating these channels would break existing
NDP connections.

Fixes: 154b0296c0ec ("wifi: nl80211: Add a notification to notify NAN channel evacuation")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 include/net/cfg80211.h       | 24 +++++++++++++
 include/uapi/linux/nl80211.h | 31 ++++++++++++++++
 net/wireless/core.c          | 35 ++++++++++++++++++
 net/wireless/core.h          |  4 +++
 net/wireless/nl80211.c       | 69 ++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 +++++++++
 net/wireless/trace.h         | 25 +++++++++++++
 7 files changed, 205 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9aa7d2d4a184..43551dd4328e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4258,6 +4258,21 @@ struct cfg80211_nan_local_sched {
 	struct cfg80211_nan_channel nan_channels[] __counted_by(n_channels);
 };
 
+/**
+ * struct cfg80211_nan_non_evac_channels - NAN non-evacuable channels
+ *
+ * This struct defines the set of NAN local schedule channels that must not
+ * be evacuated for concurrent operations.
+ *
+ * @n_channels: number of channel definitions in %chandefs.
+ * @chandefs: array of channel definitions that must not be evacuated. Each
+ *	must match a channel of the current local schedule.
+ */
+struct cfg80211_nan_non_evac_channels {
+	u8 n_channels;
+	struct cfg80211_chan_def chandefs[] __counted_by(n_channels);
+};
+
 /**
  * struct cfg80211_nan_peer_map - NAN peer schedule map
  *
@@ -5206,6 +5221,12 @@ struct mgmt_frame_regs {
  *	schedule, the full new schedule is provided - partial updates are not
  *	supported, and the new schedule completely replaces the previous one.
  *
+ * @nan_set_non_evac_channels: set the list of local schedule channels that
+ *	must not be evacuated for concurrent operations. The provided list
+ *	replaces the previous set; channels of the current schedule that are
+ *	not included become evacuable again. All provided channels are
+ *	guaranteed by cfg80211 to belong to the current local schedule.
+ *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
  *
  * @get_txq_stats: Get TXQ stats for interface or phy. If wdev is %NULL, this
@@ -5592,6 +5613,9 @@ struct cfg80211_ops {
 	int	(*nan_set_peer_sched)(struct wiphy *wiphy,
 				      struct wireless_dev *wdev,
 				      struct cfg80211_nan_peer_sched *sched);
+	int	(*nan_set_non_evac_channels)(struct wiphy *wiphy,
+					     struct wireless_dev *wdev,
+					     struct cfg80211_nan_non_evac_channels *channels);
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a2ccb8d66b8..ff7b5157e8cf 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1383,6 +1383,13 @@
  *	from the device to perform an announced schedule update. See
  *	%NL80211_ATTR_NAN_SCHED_DEFERRED for more details.
  *	If not set, the schedule should be applied immediately.
+ *	Setting a new schedule is always allowed and is never treated as an
+ *	evacuation, even if it removes channels that were previously marked as
+ *	non-evacuable with %NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS. The
+ *	non-evacuable marking is a per-channel property of the schedule:
+ *	channels that remain in the new schedule keep their marking, channels
+ *	that are removed simply lose it, and newly added channels are
+ *	evacuable by default.
  * @NL80211_CMD_NAN_SCHED_UPDATE_DONE: Event sent to user space to notify that
  *	a deferred local NAN schedule update (requested with
  *	%NL80211_CMD_NAN_SET_LOCAL_SCHED and %NL80211_ATTR_NAN_SCHED_DEFERRED)
@@ -1427,6 +1434,28 @@
  * @NL80211_CMD_STOP_PD: Stop the PD operation, identified by
  *	its %NL80211_ATTR_WDEV interface.
  *
+ * @NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS: Set the list of NAN local schedule
+ *	channels that must not be evacuated. NAN must be operational
+ *	(%NL80211_CMD_START_NAN was executed) and a local schedule must have
+ *	been set (%NL80211_CMD_NAN_SET_LOCAL_SCHED). The command carries zero
+ *	or more nested %NL80211_ATTR_NAN_CHANNEL attributes, each identifying a
+ *	channel (by its channel definition) of the current local schedule that
+ *	must not be evacuated for concurrent operations. The provided list
+ *	replaces the previous set of non-evacuable channels; channels of the
+ *	current schedule that are not included become evacuable again. All
+ *	provided channels must exist in the current local schedule, otherwise
+ *	the command fails. This is used to protect channels carrying NDC or
+ *	immutable schedules, whose evacuation would break existing NDP
+ *	connections.
+ *	The non-evacuable marking is a per-channel property of the current
+ *	local schedule and only affects evacuation for concurrent operations;
+ *	it does not prevent the schedule itself from being changed. Removing a
+ *	channel from the schedule with %NL80211_CMD_NAN_SET_LOCAL_SCHED is a
+ *	user-initiated change, not an evacuation, and is allowed even for a
+ *	non-evacuable channel. Across a schedule update, channels that remain
+ *	keep their non-evacuable marking, removed channels lose it, and newly
+ *	added channels are evacuable by default; issue this command again to
+ *	change the non-evacuable set.
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1705,6 +1734,8 @@ enum nl80211_commands {
 	NL80211_CMD_START_PD,
 	NL80211_CMD_STOP_PD,
 
+	NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index d13310fef691..2f46243773f9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -325,6 +325,41 @@ int cfg80211_nan_set_local_schedule(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+int cfg80211_nan_set_non_evac_channels(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev,
+				       struct cfg80211_nan_non_evac_channels *channels)
+{
+	lockdep_assert_held(&rdev->wiphy.mtx);
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN || !wdev_running(wdev))
+		return -EINVAL;
+
+	/*
+	 * Don't allow updating the non-evacuable channels while a deferred
+	 * schedule update is pending, as the set of channels may still change.
+	 */
+	if (wdev->u.nan.sched_update_pending)
+		return -EBUSY;
+
+	/* All provided channels must belong to the current local schedule. */
+	for (int i = 0; i < channels->n_channels; i++) {
+		bool found = false;
+
+		for (int j = 0; j < wdev->u.nan.n_channels; j++) {
+			if (cfg80211_chandef_identical(&wdev->u.nan.chandefs[j],
+						       &channels->chandefs[i])) {
+				found = true;
+				break;
+			}
+		}
+
+		if (!found)
+			return -ENOENT;
+	}
+
+	return rdev_nan_set_non_evac_channels(rdev, wdev, channels);
+}
+
 void cfg80211_stop_pd(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev)
 {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b4610f6685dc..4ee48b937080 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -565,6 +565,10 @@ int cfg80211_nan_set_local_schedule(struct cfg80211_registered_device *rdev,
 				    struct wireless_dev *wdev,
 				    struct cfg80211_nan_local_sched *sched);
 
+int cfg80211_nan_set_non_evac_channels(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev,
+				       struct cfg80211_nan_non_evac_channels *channels);
+
 struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		    struct cfg80211_internal_bss *tmp,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ab5a14f5fe28..bb1abc9d18e2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17767,6 +17767,69 @@ static int nl80211_nan_set_local_sched(struct sk_buff *skb,
 	return cfg80211_nan_set_local_schedule(rdev, wdev, sched);
 }
 
+static int
+nl80211_parse_non_evac_channel(struct cfg80211_registered_device *rdev,
+			       struct nlattr *channel, struct genl_info *info,
+			       struct cfg80211_chan_def *chandef)
+{
+	struct nlattr **channel_parsed __free(kfree) =
+		kcalloc(NL80211_ATTR_MAX + 1, sizeof(*channel_parsed),
+			GFP_KERNEL);
+	int ret;
+
+	if (!channel_parsed)
+		return -ENOMEM;
+
+	ret = nla_parse_nested(channel_parsed, NL80211_ATTR_MAX, channel, NULL,
+			       info->extack);
+	if (ret)
+		return ret;
+
+	return nl80211_parse_chandef(rdev, info->extack, channel_parsed,
+				     chandef, false);
+}
+
+static int nl80211_nan_set_non_evac_channels(struct sk_buff *skb,
+					     struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	int rem, i = 0, n_channels = 0;
+	struct nlattr *channel;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!wdev_running(wdev))
+		return -ENOTCONN;
+
+	/* Count how many channel attributes we got */
+	nlmsg_for_each_attr_type(channel, NL80211_ATTR_NAN_CHANNEL,
+				 info->nlhdr, GENL_HDRLEN, rem)
+		n_channels++;
+
+	struct cfg80211_nan_non_evac_channels *channels __free(kfree) =
+		kzalloc(struct_size(channels, chandefs, n_channels),
+			GFP_KERNEL);
+	if (!channels)
+		return -ENOMEM;
+
+	channels->n_channels = n_channels;
+
+	nlmsg_for_each_attr_type(channel, NL80211_ATTR_NAN_CHANNEL,
+				 info->nlhdr, GENL_HDRLEN, rem) {
+		int ret;
+
+		ret = nl80211_parse_non_evac_channel(rdev, channel, info,
+						     &channels->chandefs[i]);
+		if (ret)
+			return ret;
+		i++;
+	}
+
+	return cfg80211_nan_set_non_evac_channels(rdev, wdev, channels);
+}
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
@@ -20629,6 +20692,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
 	},
+	{
+		.cmd = NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS,
+		.doit = nl80211_nan_set_non_evac_channels,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_WDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 46849fe8d0b3..269258c94a42 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1093,6 +1093,23 @@ rdev_nan_set_peer_sched(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_nan_set_non_evac_channels(struct cfg80211_registered_device *rdev,
+			       struct wireless_dev *wdev,
+			       struct cfg80211_nan_non_evac_channels *channels)
+{
+	int ret;
+
+	trace_rdev_nan_set_non_evac_channels(&rdev->wiphy, wdev, channels);
+	if (rdev->ops->nan_set_non_evac_channels)
+		ret = rdev->ops->nan_set_non_evac_channels(&rdev->wiphy, wdev,
+							   channels);
+	else
+		ret = -EOPNOTSUPP;
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_start_pd(struct cfg80211_registered_device *rdev,
 				struct wireless_dev *wdev)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8c2a91b85c39..435dc58cafbe 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2483,6 +2483,31 @@ TRACE_EVENT(rdev_nan_set_peer_sched,
 	)
 );
 
+TRACE_EVENT(rdev_nan_set_non_evac_channels,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_nan_non_evac_channels *channels),
+	TP_ARGS(wiphy, wdev, channels),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u8, n_channels)
+		__dynamic_array(u32, freqs, channels->n_channels)
+	),
+	TP_fast_assign(
+		u32 *freqs = __get_dynamic_array(freqs);
+
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->n_channels = channels->n_channels;
+		for (int i = 0; i < channels->n_channels; i++)
+			freqs[i] = channels->chandefs[i].chan->center_freq;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", n_channels: %u, freqs: %s",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->n_channels,
+		  __print_array(__get_dynamic_array(freqs),
+				__entry->n_channels, sizeof(u32)))
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
-- 
2.34.1

