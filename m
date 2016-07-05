Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32920 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039AbcGEMXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:11 +0300
Message-Id: <1467721394-8195-5-git-send-email-luca@coelho.fi> (sfid-20160705_142332_130429_8FA49600)
In-Reply-To: <1467721394-8195-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 4/7] nl80211: Add info to scan results to support beacon report
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Beacon report radio measurement requires reporting observed BSSs
on the channels specified in the beacon request. If the measurement
mode is set to passive or active, it requires actually performing a
scan (passive or active, accordingly), and reporting the time that
the scan was started and the time each beacon/probe was received
(both in terms of TSF of the BSS of the requesting AP). If the
request mode is table, this information is optional.
In addition, the radio measurement request specifies the channel
dwell time for the measurement.

In order to use scan for beacon report when the mode is active or
passive, add a parameter to scan request that specifies the
channel dwell time, and add scan start time and beacon received time
to scan results information.

Supporting beacon report is required for Multi Band Operation (MBO).

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       | 40 +++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/nl80211.h | 42 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/scan.c          |  9 +++++++--
 net/wireless/core.c          |  4 ++--
 net/wireless/core.h          | 12 ++++++++++++
 net/wireless/nl80211.c       | 27 +++++++++++++++++++++++++++
 net/wireless/scan.c          | 18 ++++++++++++------
 net/wireless/trace.h         | 33 +++++++++++++++++++++++++--------
 8 files changed, 162 insertions(+), 23 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa4f0f7..e2658e3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1424,6 +1424,21 @@ struct cfg80211_ssid {
 };
 
 /**
+ * struct cfg80211_scan_info - information about completed scan
+ * @scan_start_tsf: scan start time in terms of the TSF of the BSS that the
+ *	wireless device that requested the scan is connected to. If this
+ *	information is not available, this field is left zero.
+ * @tsf_bssid: the BSSID according to which %scan_start_tsf is set.
+ * @aborted: set to true if the scan was aborted for any reason,
+ *	userspace will be notified of that
+ */
+struct cfg80211_scan_info {
+	u64 scan_start_tsf;
+	u8 tsf_bssid[ETH_ALEN] __aligned(2);
+	bool aborted;
+};
+
+/**
  * struct cfg80211_scan_request - scan request description
  *
  * @ssids: SSIDs to scan for (active scan only)
@@ -1433,12 +1448,17 @@ struct cfg80211_ssid {
  * @scan_width: channel width for scanning
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @duration: how long to listen on each channel, in TUs. If
+ *	%duration_mandatory is not set, this is the maximum dwell time and
+ *	the actual dwell time may be shorter.
+ * @duration_mandatory: if set, the scan duration must be as specified by the
+ *	%duration field.
  * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
  * @scan_start: time (in jiffies) when the scan started
  * @wdev: the wireless device to scan for
- * @aborted: (internal) scan request was notified as aborted
+ * @info: (internal) information about completed scan
  * @notified: (internal) scan request was notified as done or aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
  * @mac_addr: MAC address used with randomisation
@@ -1454,6 +1474,8 @@ struct cfg80211_scan_request {
 	enum nl80211_bss_scan_width scan_width;
 	const u8 *ie;
 	size_t ie_len;
+	u16 duration;
+	bool duration_mandatory;
 	u32 flags;
 
 	u32 rates[NUM_NL80211_BANDS];
@@ -1467,7 +1489,8 @@ struct cfg80211_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	unsigned long scan_start;
-	bool aborted, notified;
+	struct cfg80211_scan_info info;
+	bool notified;
 	bool no_cck;
 
 	/* keep last */
@@ -1600,12 +1623,19 @@ enum cfg80211_signal_type {
  *	buffered on the device) and be accurate to about 10ms.
  *	If the frame isn't buffered, just passing the return value of
  *	ktime_get_boot_ns() is likely appropriate.
+ * @parent_tsf: the time at the start of reception of the first octet of the
+ *	timestamp field of the frame. The time is the TSF of the BSS specified
+ *	by %parent_bssid.
+ * @parent_bssid: the BSS according to which %parent_tsf is set. This is set to
+ *	the BSS that requested the scan in which the beacon/probe was received.
  */
 struct cfg80211_inform_bss {
 	struct ieee80211_channel *chan;
 	enum nl80211_bss_scan_width scan_width;
 	s32 signal;
 	u64 boottime_ns;
+	u64 parent_tsf;
+	u8 parent_bssid[ETH_ALEN] __aligned(2);
 };
 
 /**
@@ -4067,10 +4097,10 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator);
  * cfg80211_scan_done - notify that scan finished
  *
  * @request: the corresponding scan request
- * @aborted: set to true if the scan was aborted for any reason,
- *	userspace will be notified of that
+ * @info: information about the completed scan
  */
-void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted);
+void cfg80211_scan_done(struct cfg80211_scan_request *request,
+			struct cfg80211_scan_info *info);
 
 /**
  * cfg80211_sched_scan_results - notify that new scan results are available
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1d7da78..b39ccab 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1848,6 +1848,22 @@ enum nl80211_commands {
  *	to turn that feature off set an invalid mac address
  *	(e.g. FF:FF:FF:FF:FF:FF)
  *
+ * @NL80211_ATTR_SCAN_START_TIME_TSF: The time at which the scan was actually
+ *	started (u64). The time is the TSF of the BSS the interface that
+ *	requested the scan is connected to (if available, otherwise this
+ *	attribute must not be included).
+ * @NL80211_ATTR_SCAN_START_TIME_TSF_BSSID: The BSS according to which
+ *	%NL80211_ATTR_SCAN_START_TIME_TSF is set.
+ * @NL80211_ATTR_MEASUREMENT_DURATION: measurement duration in TUs (u16). If
+ *	%NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY is not set, this is the
+ *	maximum measurement duration allowed. This attribute is used with
+ *	measurement requests. It can also be used with %NL80211_CMD_TRIGGER_SCAN
+ *	if the scan is used for beacon report radio measurement.
+ * @NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY: flag attribute that indicates
+ *	that the duration specified with %NL80211_ATTR_MEASUREMENT_DURATION is
+ *	mandatory. If this flag is not set, the duration is the maximum duration
+ *	and the actual measurement duration may be shorter.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2235,6 +2251,11 @@ enum nl80211_attrs {
 	NL80211_ATTR_MU_MIMO_GROUP_DATA,
 	NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR,
 
+	NL80211_ATTR_SCAN_START_TIME_TSF,
+	NL80211_ATTR_SCAN_START_TIME_TSF_BSSID,
+	NL80211_ATTR_MEASUREMENT_DURATION,
+	NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3496,6 +3517,12 @@ enum nl80211_bss_scan_width {
  *	was last updated by a received frame. The value is expected to be
  *	accurate to about 10ms. (u64, nanoseconds)
  * @NL80211_BSS_PAD: attribute used for padding for 64-bit alignment
+ * @NL80211_BSS_PARENT_TSF: the time at the start of reception of the first
+ *	octet of the timestamp field of the last beacon/probe received for
+ *	this BSS. The time is the TSF of the BSS specified by
+ *	@NL80211_BSS_PARENT_BSSID. (u64).
+ * @NL80211_BSS_PARENT_BSSID: the BSS according to which @NL80211_BSS_PARENT_TSF
+ *	is set.
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3517,6 +3544,8 @@ enum nl80211_bss {
 	NL80211_BSS_PRESP_DATA,
 	NL80211_BSS_LAST_SEEN_BOOTTIME,
 	NL80211_BSS_PAD,
+	NL80211_BSS_PARENT_TSF,
+	NL80211_BSS_PARENT_BSSID,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
@@ -4507,6 +4536,16 @@ enum nl80211_feature_flags {
  *	%NL80211_ATTR_MU_MIMO_GROUP_DATA attribute,
  *	or can be configured to follow a station by configuring the
  *	%NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR attribute.
+ * @NL80211_EXT_FEATURE_SCAN_START_TIME: This driver includes the actual
+ *	time the scan started in scan results event. The time is the TSF of
+ *	the BSS that the interface that requested the scan is connected to
+ *	(if available).
+ * @NL80211_EXT_FEATURE_BSS_PARENT_TSF: Per BSS, this driver reports the
+ *	time the last beacon/probe was received. The time is the TSF of the
+ *	BSS that the interface that requested the scan is connected to
+ *	(if available).
+ * @NL80211_EXT_FEATURE_SET_SCAN_DWELL: This driver supports configuration of
+ *	channel dwell time.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4515,6 +4554,9 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_VHT_IBSS,
 	NL80211_EXT_FEATURE_RRM,
 	NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER,
+	NL80211_EXT_FEATURE_SCAN_START_TIME,
+	NL80211_EXT_FEATURE_BSS_PARENT_TSF,
+	NL80211_EXT_FEATURE_SET_SCAN_DWELL,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f9648ef..4ec1c52 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -353,8 +353,13 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	scan_req = rcu_dereference_protected(local->scan_req,
 					     lockdep_is_held(&local->mtx));
 
-	if (scan_req != local->int_scan_req)
-		cfg80211_scan_done(scan_req, aborted);
+	if (scan_req != local->int_scan_req) {
+		struct cfg80211_scan_info info = {
+			.aborted = aborted,
+		};
+
+		cfg80211_scan_done(scan_req, &info);
+	}
 	RCU_INIT_POINTER(local->scan_req, NULL);
 
 	scan_sdata = rcu_dereference_protected(local->scan_sdata,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 39d9abd..7645e97 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -220,7 +220,7 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 
 	if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
 		if (WARN_ON(!rdev->scan_req->notified))
-			rdev->scan_req->aborted = true;
+			rdev->scan_req->info.aborted = true;
 		___cfg80211_scan_done(rdev, false);
 	}
 }
@@ -1087,7 +1087,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
 		if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
 			if (WARN_ON(!rdev->scan_req->notified))
-				rdev->scan_req->aborted = true;
+				rdev->scan_req->info.aborted = true;
 			___cfg80211_scan_done(rdev, false);
 		}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a4d547f..eee9144 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -141,6 +141,18 @@ struct cfg80211_internal_bss {
 	unsigned long refcount;
 	atomic_t hold;
 
+	/* time at the start of the reception of the first octet of the
+	 * timestamp field of the last beacon/probe received for this BSS.
+	 * The time is the TSF of the BSS specified by %parent_bssid.
+	 */
+	u64 parent_tsf;
+
+	/* the BSS according to which %parent_tsf is set. This is set to
+	 * the BSS that the interface that requested the scan was connected to
+	 * when the beacon/probe was received.
+	 */
+	u8 parent_bssid[ETH_ALEN] __aligned(2);
+
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 447026f..c53b546 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6223,6 +6223,19 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_MEASUREMENT_DURATION]) {
+		if (!wiphy_ext_feature_isset(wiphy,
+					NL80211_EXT_FEATURE_SET_SCAN_DWELL)) {
+			err = -EOPNOTSUPP;
+			goto out_free;
+		}
+
+		request->duration =
+			nla_get_u16(info->attrs[NL80211_ATTR_MEASUREMENT_DURATION]);
+		request->duration_mandatory =
+			nla_get_flag(info->attrs[NL80211_ATTR_MEASUREMENT_DURATION_MANDATORY]);
+	}
+
 	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
 			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
@@ -7056,6 +7069,13 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			jiffies_to_msecs(jiffies - intbss->ts)))
 		goto nla_put_failure;
 
+	if (intbss->parent_tsf &&
+	    (nla_put_u64_64bit(msg, NL80211_BSS_PARENT_TSF,
+			       intbss->parent_tsf, NL80211_BSS_PAD) ||
+	     nla_put(msg, NL80211_BSS_PARENT_BSSID, ETH_ALEN,
+		     intbss->parent_bssid)))
+		goto nla_put_failure;
+
 	if (intbss->ts_boottime &&
 	    nla_put_u64_64bit(msg, NL80211_BSS_LAST_SEEN_BOOTTIME,
 			      intbss->ts_boottime, NL80211_BSS_PAD))
@@ -11829,6 +11849,13 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	    nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags))
 		goto nla_put_failure;
 
+	if (req->info.scan_start_tsf &&
+	    (nla_put_u64_64bit(msg, NL80211_ATTR_SCAN_START_TIME_TSF,
+			       req->info.scan_start_tsf, NL80211_BSS_PAD) ||
+	     nla_put(msg, NL80211_ATTR_SCAN_START_TIME_TSF_BSSID, ETH_ALEN,
+		     req->info.tsf_bssid)))
+		goto nla_put_failure;
+
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ef2955c..0358e12 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2016	Intel Deutschland GmbH
  */
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -194,7 +195,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 	if (wdev->netdev)
 		cfg80211_sme_scan_done(wdev->netdev);
 
-	if (!request->aborted &&
+	if (!request->info.aborted &&
 	    request->flags & NL80211_SCAN_FLAG_FLUSH) {
 		/* flush entries from previous scans */
 		spin_lock_bh(&rdev->bss_lock);
@@ -202,10 +203,10 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 		spin_unlock_bh(&rdev->bss_lock);
 	}
 
-	msg = nl80211_build_scan_msg(rdev, wdev, request->aborted);
+	msg = nl80211_build_scan_msg(rdev, wdev, request->info.aborted);
 
 #ifdef CONFIG_CFG80211_WEXT
-	if (wdev->netdev && !request->aborted) {
+	if (wdev->netdev && !request->info.aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
 
 		wireless_send_event(wdev->netdev, SIOCGIWSCAN, &wrqu, NULL);
@@ -236,12 +237,13 @@ void __cfg80211_scan_done(struct work_struct *wk)
 	rtnl_unlock();
 }
 
-void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
+void cfg80211_scan_done(struct cfg80211_scan_request *request,
+			struct cfg80211_scan_info *info)
 {
-	trace_cfg80211_scan_done(request, aborted);
+	trace_cfg80211_scan_done(request, info);
 	WARN_ON(request != wiphy_to_rdev(request->wiphy)->scan_req);
 
-	request->aborted = aborted;
+	request->info = *info;
 	request->notified = true;
 	queue_work(cfg80211_wq, &wiphy_to_rdev(request->wiphy)->scan_done_wk);
 }
@@ -843,6 +845,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		found->pub.capability = tmp->pub.capability;
 		found->ts = tmp->ts;
 		found->ts_boottime = tmp->ts_boottime;
+		found->parent_tsf = tmp->parent_tsf;
+		ether_addr_copy(found->parent_bssid, tmp->parent_bssid);
 	} else {
 		struct cfg80211_internal_bss *new;
 		struct cfg80211_internal_bss *hidden;
@@ -1086,6 +1090,8 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 	tmp.ts_boottime = data->boottime_ns;
+	tmp.parent_tsf = data->parent_tsf;
+	ether_addr_copy(tmp.parent_bssid, data->parent_bssid);
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 3c1091a..72b5255 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2642,8 +2642,9 @@ TRACE_EVENT(cfg80211_tdls_oper_request,
 	);
 
 TRACE_EVENT(cfg80211_scan_done,
-	TP_PROTO(struct cfg80211_scan_request *request, bool aborted),
-	TP_ARGS(request, aborted),
+	TP_PROTO(struct cfg80211_scan_request *request,
+		 struct cfg80211_scan_info *info),
+	TP_ARGS(request, info),
 	TP_STRUCT__entry(
 		__field(u32, n_channels)
 		__dynamic_array(u8, ie, request ? request->ie_len : 0)
@@ -2652,6 +2653,8 @@ TRACE_EVENT(cfg80211_scan_done,
 		MAC_ENTRY(wiphy_mac)
 		__field(bool, no_cck)
 		__field(bool, aborted)
+		__field(u64, scan_start_tsf)
+		MAC_ENTRY(tsf_bssid)
 	),
 	TP_fast_assign(
 		if (request) {
@@ -2666,9 +2669,16 @@ TRACE_EVENT(cfg80211_scan_done,
 					   request->wiphy->perm_addr);
 			__entry->no_cck = request->no_cck;
 		}
-		__entry->aborted = aborted;
+		if (info) {
+			__entry->aborted = info->aborted;
+			__entry->scan_start_tsf = info->scan_start_tsf;
+			MAC_ASSIGN(tsf_bssid, info->tsf_bssid);
+		}
 	),
-	TP_printk("aborted: %s", BOOL_TO_STR(__entry->aborted))
+	TP_printk("aborted: %s, scan start (TSF): %llu, tsf_bssid: " MAC_PR_FMT,
+		  BOOL_TO_STR(__entry->aborted),
+		  (unsigned long long)__entry->scan_start_tsf,
+		  MAC_PR_ARG(tsf_bssid))
 );
 
 DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_results,
@@ -2721,6 +2731,8 @@ TRACE_EVENT(cfg80211_inform_bss_frame,
 		__dynamic_array(u8, mgmt, len)
 		__field(s32, signal)
 		__field(u64, ts_boottime)
+		__field(u64, parent_tsf)
+		MAC_ENTRY(parent_bssid)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
@@ -2730,10 +2742,15 @@ TRACE_EVENT(cfg80211_inform_bss_frame,
 			memcpy(__get_dynamic_array(mgmt), mgmt, len);
 		__entry->signal = data->signal;
 		__entry->ts_boottime = data->boottime_ns;
-	),
-	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT "(scan_width: %d) signal: %d, tsb:%llu",
-		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->scan_width,
-		  __entry->signal, (unsigned long long)__entry->ts_boottime)
+		__entry->parent_tsf = data->parent_tsf;
+		MAC_ASSIGN(parent_bssid, data->parent_bssid);
+	),
+	TP_printk(WIPHY_PR_FMT ", " CHAN_PR_FMT
+		  "(scan_width: %d) signal: %d, tsb:%llu, detect_tsf:%llu, tsf_bssid: "
+		  MAC_PR_FMT, WIPHY_PR_ARG, CHAN_PR_ARG, __entry->scan_width,
+		  __entry->signal, (unsigned long long)__entry->ts_boottime,
+		  (unsigned long long)__entry->parent_tsf,
+		  MAC_PR_ARG(parent_bssid))
 );
 
 DECLARE_EVENT_CLASS(cfg80211_bss_evt,
-- 
2.8.1

