Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AF93AE1B4
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788802440; cv=none; b=MtF3NjoYrO97TyzCW9JFrKJDh0FWlWMlYYwP9as/kNCx+sAl/WsO75Su4pR5gyh6XRNji1aXpbtCN8lmW4tLMK4aHe4XiviikUXpIsZ9ANcH+MDrUGDaXj1iAx4AKAOEeyEdr26/jrRLJXO/O0EsLmYxI/e9bRXQ9gzKGrSNQ6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788802440; c=relaxed/simple;
	bh=A+zDF/qJok5Q0B1CCoPFZROu/mZRWSPwwAcWb1aonrI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AbeDDQkVjk9nHJUa442JinXk4sRrsaShUuIzobWkfvhU8MC+jl2DmaytXs5IH++buw3ttrErj7cI/8lIe2ZragJQsOcwQPIIfWrdgttTmWJpuq0eaO1K55yPyMBH76j4XimxXsHqGKD7Ensg39Lpc1lDtZTffl0UG5cremj8w00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mmhgVulX; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mmhgVulX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788802439; x=1820338439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A+zDF/qJok5Q0B1CCoPFZROu/mZRWSPwwAcWb1aonrI=;
  b=mmhgVulXqCKTvuKhc/PdlM1tRmSdZuGYLVqXF8ZCHRB8I0/TwPjzW+9m
   o9dFTN/WHvvrpdFHgsiXWqXGU+bWnwj50cA+gYy5+//jTaNlUagpVzdmU
   /swwQVrx0ifH0XPqLjKYzuRMJvPyHJaNSHMiF0e3x6BwRJS92SvMgKGQv
   bAxFRX3WjhXhr3flZDn12UI4aKH5kayMBVROpgSXu2epv1Swb2g5/2lFC
   t1vpPNsg0/zm9d2EMRPzsj4DSxqGCVy3vG2rYxgN8+A6NMztx0ScQa/YT
   YmqZwCPVBRScE2F3YuegJmTrCMXpzviDu2drQk31WbeaqMGldQxWJq8D2
   A==;
X-CSE-ConnectionGUID: FDdzYgquQKeg/0EREOWzrA==
X-CSE-MsgGUID: Kqs3z7NDRBG0JdR2J4zY1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="99866315"
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="99866315"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:33:58 -0700
X-CSE-ConnectionGUID: p92XdJ06QsqpvwCHevtOwA==
X-CSE-MsgGUID: P5DjXrDhRmeDA8153ZWzkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,267,1779174000"; 
   d="scan'208";a="274917169"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2026 10:33:56 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless 1/2] wifi: cfg80211: add NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS
Date: Mon,  7 Sep 2026 20:35:56 +0300
Message-Id: <20260907203545.2185380c2557.Ice8839058e114f6f9783079807df446388187dda@changeid>
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
index 6461a7bd0169..59d76a0daf2c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4256,6 +4256,21 @@ struct cfg80211_nan_local_sched {
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
@@ -5204,6 +5219,12 @@ struct mgmt_frame_regs {
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
@@ -5590,6 +5611,9 @@ struct cfg80211_ops {
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
index d8fefefc11a9..fb300b0c4a28 100644
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
index e585da1d79c9..f44036ad43fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17763,6 +17763,69 @@ static int nl80211_nan_set_local_sched(struct sk_buff *skb,
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
@@ -20619,6 +20682,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
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

