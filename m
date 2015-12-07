Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34793 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbbLGVFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 16:05:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>,
	Anatol Pomozov <anatol.pomozov@gmail.com>,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 2/4] nl80211: add fine timing measurement support
Date: Mon,  7 Dec 2015 22:04:51 +0100
Message-Id: <1449522293-13710-3-git-send-email-johannes@sipsolutions.net> (sfid-20151207_220516_388350_C228E113)
In-Reply-To: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
References: <1449522293-13710-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Add support for generic measurements that allow userspace to request a
measurement and receive the result. The result will be sent only to the
socket requesting the measurement, and the measurement can be aborted
by closing that socket.

The only supported measurement right now is fine timing measurement.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 189 ++++++++++++++++++
 include/uapi/linux/nl80211.h | 271 ++++++++++++++++++++++++++
 net/wireless/core.c          |  57 +++++-
 net/wireless/core.h          |  12 ++
 net/wireless/nl80211.c       | 452 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  27 +++
 net/wireless/trace.h         |  55 ++++++
 7 files changed, 1062 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9bcaaf7cd15a..fce5c002ebbe 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2222,6 +2222,161 @@ struct cfg80211_qos_map {
 };
 
 /**
+ * struct cfg80211_ftm_target - data for an FTM target (FTM responder)
+ *
+ * @cookie: Extra data for the use of the invoking component. This will be
+ *	passed back to the caller in the response, along with the rest of the
+ *	request.
+ * @chan_def: target's channel info
+ * @bssid: target's BSSID.
+ * @one_sided: whether to perform a one-sided (flag set) or two-sided (flag
+ *	clear) measurement.
+ * @asap: Whether to perform the measurement in ASAP mode. Ignored if one-sided.
+ * @lci: Whether to query for LCI in the request. Ignored if one-sided.
+ * @civic: Whether to query for CIVIC in the request. Ignored if one-sided.
+ * @num_of_bursts: number of measurement iterations.
+ * @burst_period: Measurement periodicity in units of 100ms. Ignored if num of
+ *	bursts is 1.
+ * @samples_per_burst: Number of measurement frames requested per burst.
+ * @retries: Number of retries per sample.
+ */
+struct cfg80211_ftm_target {
+	u64 cookie;
+	struct cfg80211_chan_def chan_def;
+	u8 bssid[ETH_ALEN];
+	bool one_sided;
+	bool asap;
+	bool lci;
+	bool civic;
+	u16 num_of_bursts;
+	u16 burst_period;
+	u8 samples_per_burst;
+	u8 retries;
+};
+
+/**
+ * struct cfg80211_ftm_request - data for FTM requests
+ *
+ * @report_tsf: if true, report the TSF of the AP to which the vif is
+ *	associated. Not relevant if the vif is not associated.
+ * @timeout: Timespan within which measurement should complete. Given in units
+ *	of 100ms.
+ * @macaddr_template: Sets the fixed part of a randomized mac address.
+ * @macaddr_mask: Bits set to 1 shall be copied from @macaddr_template. Bits set
+ *	to 0 shall be randomized by the device.
+ * @num_of_targets: Number of targets (with which to perform a measurement)
+ *	contained in this request (see @targets). &num_of_target will not
+ *	exceed the value reported for the device in
+ *	%NL80211_ATTR_MAX_TOTAL_FTM_TARGETS.
+ * @targets: List of targets with which to perform the measurement. This list is
+ *	dynamically allocated when the request arrives, and should be released
+ *	using kfree by the underlying driver when it is no longer required.
+ *	Amongst these targets, the number of 2-sided requests will not exceed
+ *	the value reported for the device in
+ *	%NL80211_ATTR_MAX_TWO_SIDED_FTM_TARGETS.
+ */
+struct cfg80211_ftm_request {
+	bool report_tsf;
+	u8 timeout;
+	u8 macaddr_template[ETH_ALEN];
+	u8 macaddr_mask[ETH_ALEN];
+	u8 num_of_targets;
+	struct cfg80211_ftm_target *targets;
+};
+
+/**
+ * struct cfg80211_msrment_request - measurement request data
+ *
+ * @type: Type of measurement. Determines the actual type of the union field
+ *	below.
+ * @nl_portid: the netlink port used for this request
+ * @u: Data for the specific required measurement type.
+ */
+struct cfg80211_msrment_request {
+	enum nl80211_msrment_type type;
+	u32 nl_portid;
+	union {
+		struct cfg80211_ftm_request ftm;
+	} u;
+};
+
+/**
+ * struct cfg80211_ftm_result - data for an FTM result of a single target
+ *
+ * @status: Status of measurement
+ * @complete: Whether this measurement is the last one expected for this target.
+ *	This implies that resources associated with this target may be released.
+ * @target: Pointer to the corresponding FTM target given in the request.
+ * @host_time: Time in which:
+ *	- in case of error - error was detected
+ *	- in case of success - successful measurement started
+ *	Given value is in nanoseconds elapsed since host boot time
+ *	(referring to CLOCK_BOOTTIME).
+ *	Note that this reported value is an estimation of the actual event time,
+ *	with expected error of up to 20ms off the actual mark. Underlying
+ *	devices must make sure they comply with this limited tolerance.
+ * @tsf: Same as %host_time, but in the expressed as the TSF of the AP the vif
+ *	is associated to. This value is not an estimation. If field
+ *	&report_tsf in the request is not set, this field is ignored.
+ * @burst_index: Ordinal number of currently reported measurement iteration.
+ * @rssi: Measured RSSI, given in dBm. Valid values range: -128-0.
+ * @rssi_spread: The difference between max and min measured RSSI values
+ * @rate_info: Used rate-related data.
+ * @rtt: The Round Trip Time that took for the last measurement for current
+ *	target, in nsec.
+ * @rtt_variance: The variance of the RTT values measured for current target, in
+ *	nsec^2.
+ * @rtt_spread: The difference between max and min RTT values measured for
+ *	the current target in the current session, in nsec.
+ */
+struct cfg80211_ftm_result {
+	enum nl80211_ftm_response_status status;
+	bool complete;
+	struct cfg80211_ftm_target *target;
+	u64 host_time;
+	u64 tsf;
+	u8 burst_index;
+	s8 rssi;
+	u8 rssi_spread;
+	struct rate_info rate_info;
+	u32 rtt;
+	u32 rtt_variance;
+	u32 rtt_spread;
+};
+
+/**
+ * struct cfg80211_ftm_results - data for FTM results of all targets
+ *
+ * @num_of_entries: num of entries in the results array
+ * @entries: an array of FTM results. this array is both allocated and
+ *	released in the driver.
+ */
+struct cfg80211_ftm_results {
+	u8 num_of_entries;
+	struct cfg80211_ftm_result *entries;
+};
+
+/**
+ * struct cfg80211_msrment_response - measurement response data
+ * @cookie: Identifier of current measurement response, matching the one given
+ *	in the request.
+ * @type: Type of measurement. Determines the actual type of the union field
+ *	below.
+ * @status: Status of current measurement response.
+ * @nl_portid: netlink port this response should be sent to
+ * @u: Data for the specific reported measurement type.
+ */
+struct cfg80211_msrment_response {
+	u64 cookie;
+	enum nl80211_msrment_type type;
+	enum nl80211_msrment_status status;
+	u32 nl_portid;
+	union {
+		struct cfg80211_ftm_results ftm;
+	} u;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2494,6 +2649,12 @@ struct cfg80211_qos_map {
  *	and returning to the base channel for communication with the AP.
  * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
  *	peers must be on the base channel when the call completes.
+ *
+ * @perform_msrment: Perform a measurement according to the given request. Once
+ *	this function returns, the given request pointer in no longer valid.
+ *	The cookie must be filled to a unique value for this request, for later
+ *	possible aborting.
+ * @abort_msrment: Abort a previously requested measurement.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2759,6 +2920,12 @@ struct cfg80211_ops {
 	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      const u8 *addr);
+	int	(*perform_msrment)(struct wiphy *wiphy,
+				   struct wireless_dev *wdev,
+				   struct cfg80211_msrment_request *request,
+				   u64 *cookie);
+	int	(*abort_msrment)(struct wiphy *wiphy, struct wireless_dev *wdev,
+				 u64 cookie);
 };
 
 /*
@@ -2805,6 +2972,8 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_5_10_MHZ: Device supports 5 MHz and 10 MHz channels.
  * @WIPHY_FLAG_HAS_CHANNEL_SWITCH: Device supports channel switch in
  *	beaconing mode (AP, IBSS, Mesh, ...).
+ * @WIPHY_FLAG_SUPPORTS_FTM_INITIATOR: Device supports 802.11 Fine Timing
+ *	Measurement Initiator.
  */
 enum wiphy_flags {
 	/* use hole at 0 */
@@ -2830,6 +2999,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_HAS_CHANNEL_SWITCH		= BIT(23),
+	WIPHY_FLAG_SUPPORTS_FTM_INITIATOR	= BIT(24),
 };
 
 /**
@@ -3178,6 +3348,11 @@ struct wiphy_vendor_command {
  *	low rssi when a frame is heard on different channel, then it should set
  *	this variable to the maximal offset for which it can compensate.
  *	This value should be set in MHz.
+ *
+ * @max_two_sided_ftm_targets: max number of 2-sided targets allowed in an FTM
+ *	request.
+ * @max_total_ftm_targets: max number of targets (both 1-sided and 2-sided) in
+ *	an FTM request. A value of 0 implies no FTM support.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3300,6 +3475,9 @@ struct wiphy {
 	u8 max_num_csa_counters;
 	u8 max_adj_channel_rssi_comp;
 
+	u8 max_two_sided_ftm_targets;
+	u8 max_total_ftm_targets;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -5218,6 +5396,17 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
 unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
 
 /**
+ * cfg80211_measurement_response - notify regarding a measurement response
+ *
+ * @wiphy: the wiphy
+ * @response: a response for which to notify
+ * @gfp: allocation flags
+ */
+void cfg80211_measurement_response(struct wiphy *wiphy,
+				   struct cfg80211_msrment_response *response,
+				   gfp_t gfp);
+
+/**
  * cfg80211_check_combinations - check interface combinations
  *
  * @wiphy: the wiphy
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5b7b5ebe7ca8..009043d67c9e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -824,6 +824,23 @@
  *	not running. The driver indicates the status of the scan through
  *	cfg80211_scan_done().
  *
+ * @NL80211_CMD_MSRMENT_REQUEST: Request to perform some type of measurement.
+ *	Request type is given by %NL80211_ATTR_MSRMENT_TYPE. Additional data is
+ *	given according to the request type.
+ *	When called, this operation returns a cookie (%NL80211_ATTR_COOKIE)
+ *	that will be included with any events pertaining to this request.
+ *	In order to abort the request, the socket which sent the request needs
+ *	to be closed. It is strongly recommended that each request will have a
+ *	separate socket.
+ * @NL80211_CMD_MSRMENT_RESPONSE: Reports measurement results in response to a
+ *	previous measurement request. A cookie matching the previous request is
+ *	given by %NL80211_ATTR_COOKIE. Response type is given by
+ *	%NL80211_ATTR_MSRMENT_TYPE. Response status is given by
+ *	%NL80211_ATTR_MSRMENT_STATUS. Additional data is given according to the
+ *	request type.
+ *	This message might be sent multiple times for one response, splitting
+ *	the response into several segments. The @NL80211_ATTR_LAST_MSG flag
+ *	should be set in the last message of the response.
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1012,6 +1029,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_ABORT_SCAN,
 
+	NL80211_CMD_MSRMENT_REQUEST,
+	NL80211_CMD_MSRMENT_RESPONSE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1790,6 +1810,25 @@ enum nl80211_commands {
  *	between scans. The scan plans are executed sequentially.
  *	Each scan plan is a nested attribute of &enum nl80211_sched_scan_plan.
  *
+ * @NL80211_ATTR_MSRMENT_TYPE: Type of current measurement request/response.
+ *	(values defined in &enum nl80211_msrment_type).
+ * @NL80211_ATTR_MSRMENT_STATUS: Status of current measurement response.
+ *	(values defined in &enum nl80211_msrment_status)
+ * @NL80211_ATTR_MSRMENT_FTM_REQUEST: Container for data of an FTM measurement
+ *	request (nested. see &enum nl80211_ftm_request)
+ * @NL80211_ATTR_MSRMENT_FTM_RESPONSE: An AP with which a measurement was
+ *	attempted (nested. see &enum nl80211_ftm_response_entry)
+ *	An FTM response consists of series of such messages, where the last
+ *	message is marked with the @NL80211_ATTR_LAST_MSG flag.
+ * @NL80211_ATTR_MAX_TWO_SIDED_FTM_TARGETS: Max number of 2-sided targets
+ *	allowed by the device in an FTM request. Not in use in case FTM is not
+ *	supported. (u32)
+ * @NL80211_ATTR_MAX_TOTAL_FTM_TARGETS: Max number of targets (both 1-sided and
+ *	2-sided) allowed by the device in an FTM request. Not in use in case FTM
+ *	is not supported. (u32)
+ * @NL80211_ATTR_LAST_MSG: Indicates that this message is the last one in the
+ *	series of messages. (flag)
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2164,6 +2203,16 @@ enum nl80211_attrs {
 	NL80211_ATTR_MAX_SCAN_PLAN_ITERATIONS,
 	NL80211_ATTR_SCHED_SCAN_PLANS,
 
+	NL80211_ATTR_MSRMENT_TYPE,
+	NL80211_ATTR_MSRMENT_STATUS,
+
+	NL80211_ATTR_MSRMENT_FTM_REQUEST,
+	NL80211_ATTR_MSRMENT_FTM_RESPONSE,
+	NL80211_ATTR_MAX_TWO_SIDED_FTM_TARGETS,
+	NL80211_ATTR_MAX_TOTAL_FTM_TARGETS,
+
+	NL80211_ATTR_LAST_MSG,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4651,4 +4700,226 @@ enum nl80211_sched_scan_plan {
 		__NL80211_SCHED_SCAN_PLAN_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_msrment_type - measurement types
+ *
+ * Used to indicate the requested/reported measurement type in
+ * %NL80211_CMD_MSRMENT_REQUEST or %NL80211_CMD_MSRMENT_RESPONSE.
+ *
+ * @NL80211_MSRMENT_TYPE_FTM: Fine Timing Measurement.
+ *	An FTM request should be constructed according to &enum
+ *	nl80211_ftm_request.
+ *	An FTM response is a serie of messages, each meassage including a
+ *	single FTM target, described in &enum nl80211_ftm_target. The last
+ *	message in the serie is marked with the @NL80211_ATTR_LAST_MSG flag.
+ *	Status @NL80211_MSRMENT_STATUS_REFUSED is used if the device is not
+ *	available for FTM operations. Status @NL80211_MSRMENT_STATUS_FAIL is
+ *	used if the device attempted to perform the measurements, but all failed
+ *	for local reasons. In these both cases, no response is included in the
+ *	message. In other cases @NL80211_MSRMENT_STATUS_SUCCESS is used.
+ *	In the latter case, internal status of each target is used to
+ *	indicate the measurement status of each particular target.
+ */
+enum nl80211_msrment_type {
+	NL80211_MSRMENT_TYPE_FTM,
+};
+
+/**
+ * enum nl80211_msrment_status - measurement response status values
+ *
+ * @NL80211_MSRMENT_STATUS_SUCCESS: Measurement performed. This does not mean
+ *	every sub-measurement was successful, but only that as a whole, the
+ *	operation succeeded. More detailed status should reside in the internal
+ *	parts of the response, and according to the measurement type.
+ * @NL80211_MSRMENT_STATUS_REFUSED: Device is refusing to perform the required
+ *	measurement. Note that not every measurement can be performed at every
+ *	given moment in time. See specific measurement details for execution
+ *	conditions.
+ * @NL80211_MSRMENT_STATUS_FAIL: Measurement failed.
+ */
+enum nl80211_msrment_status {
+	NL80211_MSRMENT_STATUS_SUCCESS,
+	NL80211_MSRMENT_STATUS_REFUSED,
+	NL80211_MSRMENT_STATUS_FAIL,
+};
+
+/**
+ * enum nl80211_ftm_target - attributes for an FTM target
+ *
+ * An FTM target is a station with which to perform measurements.
+ *
+ * @__NL80211_FTM_TARGET_ATTR_INVALID: invalid
+ * @NL80211_FTM_TARGET_ATTR_FREQ: Target's frequency (u32)
+ * @NL80211_FTM_TARGET_ATTR_BW: Target's channel bandwidth. Only BWs supported
+ *	by the device are allowed. (u8, one of &enum nl80211_chan_width)
+ * @NL80211_FTM_TARGET_ATTR_CNTR_FREQ_1: Center freq., 1st segment, if relevant
+ *	(u32)
+ * @NL80211_FTM_TARGET_ATTR_CNTR_FREQ_2: Center freq., 2nd segment, if relevant
+ *	(u32)
+ * @NL80211_FTM_TARGET_ATTR_BSSID: Target's BSSID (6 octets)
+ * @NL80211_FTM_TARGET_ATTR_ONE_SIDED: whether to perform a one-sided (flag set)
+ *	or two-sided (flag clear) measurement. (flag)
+ * @NL80211_FTM_TARGET_ATTR_NUM_OF_BURSTS: number of measurement iterations.
+ *	Optional (default: 1). (u16)
+ * @NL80211_FTM_TARGET_ATTR_BURST_PERIOD: Measurement periodicity in units of
+ *	100ms. Ignored if num of bursts is 1. (u16)
+ * @NL80211_FTM_TARGET_ATTR_SAMPLES_PER_BURST: Number of measurement frames
+ *	requested per burst. Optional (default: 2) (u8)
+ * @NL80211_FTM_TARGET_ATTR_RETRIES: Number of retries per sample.
+ *	Optional (default: 3). (u8)
+ * @NL80211_FTM_TARGET_ATTR_ASAP: Whether to perform the measurement in ASAP
+ *	mode. Ignored if one-sided. (flag)
+ * @NL80211_FTM_TARGET_QUERY_LCI: Whether to include an LCI query in the
+ *	request. (flag)
+ * @NL80211_FTM_TARGET_QUERY_CIVIC: Whether to include a CIVIC query in the
+ *	request. (flag)
+ * @NL80211_FTM_TARGET_ATTR_COOKIE: Extra data for the use of the invoking
+ *	component. This will be passed back to the caller in the response, along
+ *	with the rest of the request. Optional. (u64)
+ * @__NL80211_FTM_TARGET_ATTR_AFTER_LAST: internal
+ * @NL80211_FTM_TARGET_ATTR_MAX: highest FTM target attribute
+ */
+enum nl80211_ftm_target {
+	__NL80211_FTM_TARGET_ATTR_INVALID,
+	NL80211_FTM_TARGET_ATTR_FREQ,
+	NL80211_FTM_TARGET_ATTR_BW,
+	NL80211_FTM_TARGET_ATTR_CNTR_FREQ_1,
+	NL80211_FTM_TARGET_ATTR_CNTR_FREQ_2,
+	NL80211_FTM_TARGET_ATTR_BSSID,
+	NL80211_FTM_TARGET_ATTR_ONE_SIDED,
+	NL80211_FTM_TARGET_ATTR_NUM_OF_BURSTS,
+	NL80211_FTM_TARGET_ATTR_BURST_PERIOD,
+	NL80211_FTM_TARGET_ATTR_SAMPLES_PER_BURST,
+	NL80211_FTM_TARGET_ATTR_RETRIES,
+	NL80211_FTM_TARGET_ATTR_ASAP,
+	NL80211_FTM_TARGET_ATTR_QUERY_LCI,
+	NL80211_FTM_TARGET_ATTR_QUERY_CIVIC,
+	NL80211_FTM_TARGET_ATTR_COOKIE,
+
+	/* keep last */
+	__NL80211_FTM_TARGET_ATTR_AFTER_LAST,
+	NL80211_FTM_TARGET_ATTR_MAX = __NL80211_FTM_TARGET_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_ftm_request - attributes for an FTM request
+ *
+ * Note: Only a single FTM request can be handled at a time.
+ *
+ * @__NL80211_FTM_REQ_ATTR_INVALID: invalid
+ * @NL80211_FTM_REQ_ATTR_TIMEOUT: Timespan within which measurement should
+ *	complete. Given in tenths of a second. Optional (default: 50). (u8)
+ * @NL80211_FTM_REQ_ATTR_MACADDR_TEMPLATE: Device will use the given template
+ *	(and mask, see ahead) to generate a mac address for identification. This
+ *	attribute sets the fixed part of a randomized mac address. (6 octets)
+ *	The MC bit must be set to 0.
+ * @NL80211_FTM_REQ_ATTR_MACADDR_MASK: Mask for mac address randomization. Bits
+ *	set to 1 shall be copied from %NL80211_FTM_REQ_ATTR_MACADDR_TEMPLATE.
+ *	Bits set to 0 shall be randomized by the device.
+ *	MC bit should not be randomized(set to 1). (6 octets)
+ * @NL80211_FTM_REQ_ATTR_REPORT_TSF: Flag that indicates to use the associated
+ *	AP's TSF in the %NL80211_FTM_RESP_ENTRY_ATTR_TSF field in the response.
+ *	Useful for RRM requests, where an associated AP requires to perform FTM,
+ *	and expects a timestamp in its own TSF. If not set, no tsf value is
+ *	reported in the response. Ignored if no AP is associated. (flag)
+ * @NL80211_FTM_REQ_ATTR_TARGETS: List of targets with which to perform
+ *	measurements. Length shall not exceed the value reported for the device
+ *	in %NL80211_ATTR_MAX_TOTAL_FTM_TARGETS. Among these targets, the number
+ *	of 2-sided requests shall not exceed the value reported for the device
+ *	in %NL80211_ATTR_MAX_2_SIDED_FTM_TARGETS.
+ *	(nested. see &enum nl80211_ftm_target)
+ *
+ * @__NL80211_FTM_REQ_ATTR_AFTER_LAST: internal
+ * @NL80211_FTM_REQ_ATTR_MAX: highest FTM request attribute
+ */
+enum nl80211_ftm_request {
+	__NL80211_FTM_REQ_ATTR_INVALID,
+	NL80211_FTM_REQ_ATTR_TIMEOUT,
+	NL80211_FTM_REQ_ATTR_MACADDR_TEMPLATE,
+	NL80211_FTM_REQ_ATTR_MACADDR_MASK,
+	NL80211_FTM_REQ_ATTR_REPORT_TSF,
+	NL80211_FTM_REQ_ATTR_TARGETS,
+
+	/* keep last */
+	__NL80211_FTM_REQ_ATTR_AFTER_LAST,
+	NL80211_FTM_REQ_ATTR_MAX = __NL80211_FTM_REQ_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_ftm_response_status - status of an FTM measurement attempt
+ *
+ * @NL80211_FTM_RESP_SUCCESS: Successful measurement, given results are valid.
+ * @NL80211_FTM_RESP_TARGET_INCAPAB: Target reported incapable
+ * @NL80211_FTM_RESP_TARGET_BUSY: Target reported busy
+ * @NL80211_FTM_RESP_FAIL: Failed for some other reason.
+ */
+enum nl80211_ftm_response_status {
+	NL80211_FTM_RESP_SUCCESS,
+	NL80211_FTM_RESP_TARGET_INCAPAB,
+	NL80211_FTM_RESP_TARGET_BUSY,
+	NL80211_FTM_RESP_FAIL,
+};
+
+/**
+ * enum nl80211_ftm_response_entry - attributes for an FTM response entry
+ *
+ * An FTM response entry represents a single target with which an FTM
+ *	measurement was attempted.
+ *
+ * @__NL80211_FTM_RESP_ENTRY_ATTR_INVALID: invalid
+ * @NL80211_FTM_RESP_ENTRY_ATTR_STATUS: Status of measurement. (u8, one of
+ *	&enum nl80211_ftm_response_status)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_COMPLETE: Whether this measurement is the last
+ *	one expected for this target. This implies that resources associated
+ *	with this target may be released. (flag)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_TARGET: The corresponding FTM target entry in
+ *	the measurement request. (nested. see &enum nl80211_ftm_target)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_HOST_TIME: Time, given in nanoseconds since
+ *	host boot time(referring to CLOCK_BOOTTIME), in which:
+ *	- in case of error - error was detected
+ *	- in case of success - successful measurement started
+ *	Note that this reported value is an estimation of the actual event time,
+ *	with expected error of up to 20ms off the actual mark. Underlying
+ *	devices must make sure they comply with this limited tolerance. (u64)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_TSF: Same as %NL80211_FTM_RESP_ATTR_HOST_TIME,
+ *	but the value is TSF of the associated AP. Optional - present only if
+ *	%NL80211_FTM_REQ_ATTR_AP_REPORT_TSF was set in the request, and an
+ *	associated AP exists. Also, this value is not an estimation. (u64)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_BURST_INDEX: Ordinal number of currently
+ *	reported measurement iteration. (u8)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_RSSI: Measured RSSI, given in dBm. Valid values
+ *	range: -128-0. (s8)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_RSSI_SPREAD: The difference between max and min
+ *	measured RSSI values. (u8)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_RATE_INFO: Rate-related data. (nested. see enum
+ *	nl80211_rate_info)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_RTT: The Round Trip Time that took for the last
+ *	measurement for current target, in nsec. (u32)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_RTT_VAR: The variance of the RTT values measured
+ *	for current target, in nsec^2. (u32)
+ * @NL80211_FTM_RESP_ENTRY_ATTR_RTT_SPREAD: The difference between max and min
+ *	RTT values measured for the current target in the current session, given
+ *	in nsec (u32)
+ */
+enum nl80211_ftm_response_entry {
+	__NL80211_FTM_RESP_ENTRY_ATTR_INVALID,
+	NL80211_FTM_RESP_ENTRY_ATTR_STATUS,
+	NL80211_FTM_RESP_ENTRY_ATTR_COMPLETE,
+	NL80211_FTM_RESP_ENTRY_ATTR_TARGET,
+	NL80211_FTM_RESP_ENTRY_ATTR_HOST_TIME,
+	NL80211_FTM_RESP_ENTRY_ATTR_TSF,
+	NL80211_FTM_RESP_ENTRY_ATTR_BURST_INDEX,
+	NL80211_FTM_RESP_ENTRY_ATTR_RSSI,
+	NL80211_FTM_RESP_ENTRY_ATTR_RSSI_SPREAD,
+	NL80211_FTM_RESP_ENTRY_ATTR_RATE_INFO,
+	NL80211_FTM_RESP_ENTRY_ATTR_RTT,
+	NL80211_FTM_RESP_ENTRY_ATTR_RTT_VAR,
+	NL80211_FTM_RESP_ENTRY_ATTR_RTT_SPREAD,
+
+	/* keep last */
+	__NL80211_FTM_RESP_ENTRY_ATTR_AFTER_LAST,
+	NL80211_FTM_RESP_ENTRY_ATTR_MAX =
+	__NL80211_FTM_RESP_ENTRY_ATTR_AFTER_LAST - 1,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index b0915515640e..ad201b991544 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright 2015	Intel Deutschland GmbH
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -334,6 +335,33 @@ static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void cfg80211_abort_msrment_wk(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+	struct cfg80211_active_msrment *msrment, *tmp;
+	LIST_HEAD(msrments_list);
+
+	rdev = container_of(work, struct cfg80211_registered_device,
+			    msrment_abort_wk);
+
+	spin_lock_bh(&rdev->msrments_lock);
+	list_for_each_entry_safe(msrment, tmp, &rdev->msrments_list, list) {
+		if (msrment->nl_portid != 0)
+			continue;
+		list_del(&msrment->list);
+		list_add(&msrment->list, &msrments_list);
+	}
+	spin_unlock_bh(&rdev->msrments_lock);
+
+	rtnl_lock();
+	list_for_each_entry_safe(msrment, tmp, &msrments_list, list) {
+		rdev_abort_msrment(rdev, msrment->wdev, msrment->cookie);
+		list_del(&msrment->list);
+		kfree(msrment);
+	}
+	rtnl_unlock();
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
@@ -405,6 +433,9 @@ use_default_name:
 	spin_lock_init(&rdev->beacon_registrations_lock);
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
+	spin_lock_init(&rdev->msrments_lock);
+	INIT_LIST_HEAD(&rdev->msrments_list);
+	INIT_WORK(&rdev->msrment_abort_wk, cfg80211_abort_msrment_wk);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
 	INIT_LIST_HEAD(&rdev->mlme_unreg);
@@ -616,6 +647,10 @@ int wiphy_register(struct wiphy *wiphy)
 		     !rdev->ops->set_mac_acl)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->flags & WIPHY_FLAG_SUPPORTS_FTM_INITIATOR) &&
+		    (!rdev->ops->perform_msrment || !rdev->ops->abort_msrment)))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
@@ -779,9 +814,11 @@ void wiphy_unregister(struct wiphy *wiphy)
 		rfkill_unregister(rdev->rfkill);
 
 	rtnl_lock();
+	/* since we no longer have any wdevs, the list should be empty */
+	WARN_ON(!list_empty(&rdev->msrments_list));
+
 	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
 	rdev->wiphy.registered = false;
-
 	WARN_ON(!list_empty(&rdev->wdev_list));
 
 	/*
@@ -810,6 +847,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->destroy_work);
 	flush_work(&rdev->sched_scan_stop_wk);
 	flush_work(&rdev->mlme_unreg_wk);
+	flush_work(&rdev->msrment_abort_wk);
 
 #ifdef CONFIG_PM
 	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
@@ -852,9 +890,26 @@ EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct cfg80211_active_msrment *msrment, *tmp;
+	LIST_HEAD(msrments_list);
 
 	ASSERT_RTNL();
 
+	spin_lock_bh(&rdev->msrments_lock);
+	list_for_each_entry_safe(msrment, tmp, &rdev->msrments_list, list) {
+		if (msrment->wdev != wdev)
+			continue;
+		list_del(&msrment->list);
+		list_add(&msrment->list, &msrments_list);
+	}
+	spin_unlock_bh(&rdev->msrments_lock);
+
+	list_for_each_entry_safe(msrment, tmp, &msrments_list, list) {
+		rdev_abort_msrment(rdev, wdev, msrment->cookie);
+		list_del(&msrment->list);
+		kfree(msrment);
+	}
+
 	if (WARN_ON(wdev->netdev))
 		return;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 022ccad06cbe..4c1d98a9a2a8 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -2,6 +2,7 @@
  * Wireless configuration interface internals.
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2015	Intel Deutschland GmbH
  */
 #ifndef __NET_WIRELESS_CORE_H
 #define __NET_WIRELESS_CORE_H
@@ -63,6 +64,10 @@ struct cfg80211_registered_device {
 	spinlock_t mlme_unreg_lock;
 	struct work_struct mlme_unreg_wk;
 
+	spinlock_t msrments_lock;
+	struct list_head msrments_list;
+	struct work_struct msrment_abort_wk;
+
 	/* protected by RTNL only */
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
@@ -258,6 +263,13 @@ struct cfg80211_iface_destroy {
 	u32 nlportid;
 };
 
+struct cfg80211_active_msrment {
+	struct wireless_dev *wdev;
+	struct list_head list;
+	u64 cookie;
+	u32 nl_portid;
+};
+
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev);
 
 /* free object */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 243c6cbc99ab..a2cec336963f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -401,6 +401,13 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_MSRMENT_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_MSRMENT_STATUS] = { .type = NLA_U8 },
+	[NL80211_ATTR_MSRMENT_FTM_REQUEST] = { .type = NLA_NESTED },
+	[NL80211_ATTR_MSRMENT_FTM_RESPONSE] = { .type = NLA_NESTED },
+	[NL80211_ATTR_MAX_TWO_SIDED_FTM_TARGETS] = { .type = NLA_U8 },
+	[NL80211_ATTR_MAX_TOTAL_FTM_TARGETS] = { .type = NLA_U8 },
+	[NL80211_ATTR_LAST_MSG] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -1389,6 +1396,14 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if (nl80211_put_iftypes(msg, NL80211_ATTR_SUPPORTED_IFTYPES,
 					rdev->wiphy.interface_modes))
 				goto nla_put_failure;
+
+		if ((rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FTM_INITIATOR) &&
+		    (nla_put_u32(msg, NL80211_ATTR_MAX_TWO_SIDED_FTM_TARGETS,
+				 rdev->wiphy.max_two_sided_ftm_targets) ||
+		     nla_put_u32(msg, NL80211_ATTR_MAX_TOTAL_FTM_TARGETS,
+				 rdev->wiphy.max_total_ftm_targets)))
+			goto nla_put_failure;
+
 		state->split_start++;
 		if (state->split)
 			break;
@@ -10632,6 +10647,236 @@ static int nl80211_tdls_cancel_channel_switch(struct sk_buff *skb,
 	return 0;
 }
 
+/* policy for the attributes of a single ftm target */
+static const struct nla_policy
+nl80211_ftm_target_policy[NL80211_FTM_TARGET_ATTR_MAX + 1] = {
+	[NL80211_FTM_TARGET_ATTR_FREQ] = { .type = NLA_U32 },
+	[NL80211_FTM_TARGET_ATTR_BW] = { .type = NLA_U8 },
+	[NL80211_FTM_TARGET_ATTR_CNTR_FREQ_1] = { .type = NLA_U32 },
+	[NL80211_FTM_TARGET_ATTR_CNTR_FREQ_2] = { .type = NLA_U32 },
+	[NL80211_FTM_TARGET_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_FTM_TARGET_ATTR_ONE_SIDED] = { .type = NLA_FLAG },
+	[NL80211_FTM_TARGET_ATTR_NUM_OF_BURSTS] = { .type = NLA_U16 },
+	[NL80211_FTM_TARGET_ATTR_BURST_PERIOD] = { .type = NLA_U16 },
+	[NL80211_FTM_TARGET_ATTR_SAMPLES_PER_BURST] = { .type = NLA_U8 },
+	[NL80211_FTM_TARGET_ATTR_RETRIES] = { .type = NLA_U8 },
+	[NL80211_FTM_TARGET_ATTR_ASAP] = { .type = NLA_FLAG },
+	[NL80211_FTM_TARGET_ATTR_QUERY_LCI] = { .type = NLA_FLAG },
+	[NL80211_FTM_TARGET_ATTR_QUERY_CIVIC] = { .type = NLA_FLAG },
+	[NL80211_FTM_TARGET_ATTR_COOKIE] = { .type = NLA_U64 },
+};
+
+static int nl80211_parse_ftm_target(struct cfg80211_registered_device *rdev,
+				    struct nlattr *ftm_target_attr,
+				    struct cfg80211_ftm_target *target)
+{
+	struct nlattr *tb[NL80211_FTM_TARGET_ATTR_MAX + 1];
+	int err;
+
+	err = nla_parse_nested(tb, NL80211_FTM_TARGET_ATTR_MAX, ftm_target_attr,
+			       nl80211_ftm_target_policy);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_FTM_TARGET_ATTR_BSSID] ||
+	    !tb[NL80211_FTM_TARGET_ATTR_FREQ] ||
+	    !tb[NL80211_FTM_TARGET_ATTR_BW])
+		return -EINVAL;
+
+	nla_memcpy(target->bssid, tb[NL80211_FTM_TARGET_ATTR_BSSID], ETH_ALEN);
+
+	target->chan_def.chan = ieee80211_get_channel(&rdev->wiphy,
+		nla_get_u32(tb[NL80211_FTM_TARGET_ATTR_FREQ]));
+
+	target->chan_def.width = nla_get_u8(tb[NL80211_FTM_TARGET_ATTR_BW]);
+
+	if (tb[NL80211_FTM_TARGET_ATTR_CNTR_FREQ_1])
+		target->chan_def.center_freq1 =
+			nla_get_u32(tb[NL80211_FTM_TARGET_ATTR_CNTR_FREQ_1]);
+	else
+		target->chan_def.center_freq1 =
+			target->chan_def.chan->center_freq;
+
+	if (tb[NL80211_FTM_TARGET_ATTR_CNTR_FREQ_2])
+		target->chan_def.center_freq2 =
+			nla_get_u32(tb[NL80211_FTM_TARGET_ATTR_CNTR_FREQ_2]);
+
+	if (!cfg80211_chandef_valid(&target->chan_def))
+		return -EINVAL;
+
+	if (!tb[NL80211_FTM_TARGET_ATTR_NUM_OF_BURSTS])
+		target->num_of_bursts = 1;
+	else
+		target->num_of_bursts =
+			nla_get_u16(tb[NL80211_FTM_TARGET_ATTR_NUM_OF_BURSTS]);
+
+	if (target->num_of_bursts == 1) {
+		if (!tb[NL80211_FTM_TARGET_ATTR_BURST_PERIOD])
+			return -EINVAL;
+		target->burst_period =
+			nla_get_u16(tb[NL80211_FTM_TARGET_ATTR_BURST_PERIOD]);
+	}
+
+	target->samples_per_burst =
+		tb[NL80211_FTM_TARGET_ATTR_SAMPLES_PER_BURST] ?
+		nla_get_u8(tb[NL80211_FTM_TARGET_ATTR_SAMPLES_PER_BURST]) : 2;
+
+	if (!tb[NL80211_FTM_TARGET_ATTR_RETRIES])
+		target->retries = 3;
+	else
+		target->retries =
+			nla_get_u8(tb[NL80211_FTM_TARGET_ATTR_RETRIES]);
+
+	target->one_sided = nla_get_flag(tb[NL80211_FTM_TARGET_ATTR_ONE_SIDED]);
+	target->asap = nla_get_flag(tb[NL80211_FTM_TARGET_ATTR_ASAP]);
+	target->lci = nla_get_flag(tb[NL80211_FTM_TARGET_ATTR_QUERY_LCI]);
+	target->civic = nla_get_flag(tb[NL80211_FTM_TARGET_ATTR_QUERY_CIVIC]);
+
+	if (tb[NL80211_FTM_TARGET_ATTR_COOKIE])
+		target->cookie =
+			nla_get_u64(tb[NL80211_FTM_TARGET_ATTR_COOKIE]);
+
+	return 0;
+}
+
+/* policy for the ftm request attributes */
+static const struct nla_policy
+nl80211_ftm_request_policy[NL80211_FTM_REQ_ATTR_MAX + 1] = {
+	[NL80211_FTM_REQ_ATTR_TIMEOUT] = { .type = NLA_U8 },
+	[NL80211_FTM_REQ_ATTR_MACADDR_TEMPLATE] = { .len = ETH_ALEN  },
+	[NL80211_FTM_REQ_ATTR_MACADDR_MASK] = { .len = ETH_ALEN  },
+	[NL80211_FTM_REQ_ATTR_REPORT_TSF] = { .type = NLA_FLAG },
+	[NL80211_FTM_REQ_ATTR_TARGETS] = { .type = NLA_NESTED },
+};
+
+static int nl80211_parse_ftm_request(struct cfg80211_registered_device *rdev,
+				     struct nlattr *ftm_attr,
+				     struct cfg80211_ftm_request *ftm)
+{
+	struct nlattr *tb[NL80211_FTM_REQ_ATTR_MAX + 1];
+	struct nlattr *ap_attr;
+	int tmp, i, two_sided_counter;
+	int err;
+
+	err = nla_parse_nested(tb, NL80211_FTM_REQ_ATTR_MAX, ftm_attr,
+			       nl80211_ftm_request_policy);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_FTM_REQ_ATTR_MACADDR_TEMPLATE] ||
+	    !tb[NL80211_FTM_REQ_ATTR_MACADDR_MASK] ||
+	    !tb[NL80211_FTM_REQ_ATTR_TARGETS])
+		return -EINVAL;
+
+	if (nl80211_parse_random_mac(tb[NL80211_FTM_REQ_ATTR_MACADDR_TEMPLATE],
+				     tb[NL80211_FTM_REQ_ATTR_MACADDR_MASK],
+				     ftm->macaddr_template, ftm->macaddr_mask))
+		return -EINVAL;
+
+	if (!tb[NL80211_FTM_REQ_ATTR_TIMEOUT])
+		ftm->timeout = 50;
+	else
+		ftm->timeout = nla_get_u8(tb[NL80211_FTM_REQ_ATTR_TIMEOUT]);
+
+	if (tb[NL80211_FTM_REQ_ATTR_REPORT_TSF])
+		ftm->report_tsf = true;
+
+	nla_for_each_nested(ap_attr, tb[NL80211_FTM_REQ_ATTR_TARGETS], tmp)
+		ftm->num_of_targets++;
+	ftm->targets = kcalloc(ftm->num_of_targets,
+			       sizeof(struct cfg80211_ftm_target), GFP_KERNEL);
+	if (!ftm->targets)
+		return -ENOMEM;
+
+	i = 0;
+	two_sided_counter = 0;
+	nla_for_each_nested(ap_attr, tb[NL80211_FTM_REQ_ATTR_TARGETS], tmp) {
+		err = nl80211_parse_ftm_target(rdev, ap_attr, &ftm->targets[i]);
+		if (err)
+			goto free_targets;
+		if (!ftm->targets[i].one_sided)
+			two_sided_counter++;
+		i++;
+	}
+	if (ftm->num_of_targets > rdev->wiphy.max_total_ftm_targets ||
+	    two_sided_counter > rdev->wiphy.max_two_sided_ftm_targets)
+		goto free_targets;
+
+	return 0;
+
+free_targets:
+	kfree(ftm->targets);
+	return -EINVAL;
+}
+
+static void nl80211_msrment_request_free(struct cfg80211_msrment_request *req)
+{
+	switch (req->type) {
+	case NL80211_MSRMENT_TYPE_FTM:
+		kfree(req->u.ftm.targets);
+		req->u.ftm.targets = NULL;
+		break;
+	default:
+		break;
+	}
+}
+
+static int nl80211_msrment_request(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_msrment_request request = {0};
+	struct cfg80211_active_msrment *msrment = NULL;
+	u64 cookie = 0;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_MSRMENT_TYPE])
+		return -EINVAL;
+	request.type = nla_get_u32(info->attrs[NL80211_ATTR_MSRMENT_TYPE]);
+	request.nl_portid = info->snd_portid;
+
+	switch (request.type) {
+	case NL80211_MSRMENT_TYPE_FTM:
+		if (!info->attrs[NL80211_ATTR_MSRMENT_FTM_REQUEST])
+			return -EINVAL;
+		err = nl80211_parse_ftm_request(rdev,
+			info->attrs[NL80211_ATTR_MSRMENT_FTM_REQUEST],
+			&request.u.ftm);
+		if (err)
+			return err;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	msrment = kzalloc(sizeof(*msrment), GFP_KERNEL);
+	if (!msrment) {
+		err = -ENOMEM;
+		goto free_request;
+	}
+
+	err = rdev_perform_msrment(rdev, wdev, &request, &cookie);
+	if (err)
+		goto free_request;
+
+	WARN_ON(!cookie);
+
+	msrment->wdev = wdev;
+	msrment->cookie = cookie;
+	msrment->nl_portid = info->snd_portid;
+	spin_lock_bh(&rdev->msrments_lock);
+	list_add_tail(&msrment->list, &rdev->msrments_list);
+	spin_unlock_bh(&rdev->msrments_lock);
+
+	return 0;
+
+free_request:
+	kfree(msrment);
+	nl80211_msrment_request_free(&request);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -11458,6 +11703,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_MSRMENT_REQUEST,
+		.doit = nl80211_msrment_request,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
@@ -13211,6 +13464,7 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 		bool schedule_scan_stop = false;
 		struct cfg80211_sched_scan_request *sched_scan_req =
 			rcu_dereference(rdev->sched_scan_req);
+		struct cfg80211_active_msrment *msrment;
 
 		if (sched_scan_req && notify->portid &&
 		    sched_scan_req->owner_nlportid == notify->portid)
@@ -13234,6 +13488,15 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 		}
 		spin_unlock_bh(&rdev->beacon_registrations_lock);
 
+		spin_lock_bh(&rdev->msrments_lock);
+		list_for_each_entry(msrment, &rdev->msrments_list, list) {
+			if (msrment->nl_portid == notify->portid) {
+				msrment->nl_portid = 0;
+				schedule_work(&rdev->msrment_abort_wk);
+			}
+		}
+		spin_unlock_bh(&rdev->msrments_lock);
+
 		if (schedule_destroy_work) {
 			struct cfg80211_iface_destroy *destroy;
 
@@ -13351,6 +13614,195 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
 
+static int nl80211_put_ftm_resp_target(struct sk_buff *msg,
+				       struct cfg80211_ftm_target *target)
+{
+	struct nlattr *attr =
+		nla_nest_start(msg, NL80211_FTM_RESP_ENTRY_ATTR_TARGET);
+
+	if (!attr)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_FTM_TARGET_ATTR_FREQ,
+			target->chan_def.chan->center_freq) ||
+	    nla_put_u8(msg, NL80211_FTM_TARGET_ATTR_BW,
+		       target->chan_def.width) ||
+	    nla_put_u32(msg, NL80211_FTM_TARGET_ATTR_CNTR_FREQ_1,
+			target->chan_def.center_freq1) ||
+	    nla_put_u32(msg, NL80211_FTM_TARGET_ATTR_CNTR_FREQ_2,
+			target->chan_def.center_freq2) ||
+	    nla_put(msg, NL80211_FTM_TARGET_ATTR_BSSID, ETH_ALEN,
+		    target->bssid) ||
+	    nla_put_u16(msg, NL80211_FTM_TARGET_ATTR_NUM_OF_BURSTS,
+		       target->num_of_bursts) ||
+	    nla_put_u16(msg, NL80211_FTM_TARGET_ATTR_BURST_PERIOD,
+			target->burst_period) ||
+	    nla_put_u8(msg, NL80211_FTM_TARGET_ATTR_SAMPLES_PER_BURST,
+		       target->samples_per_burst) ||
+	    nla_put_u8(msg, NL80211_FTM_TARGET_ATTR_RETRIES, target->retries) ||
+	    nla_put_u64(msg, NL80211_FTM_TARGET_ATTR_COOKIE, target->cookie))
+		return -ENOBUFS;
+
+	if (target->one_sided &&
+	    nla_put_flag(msg, NL80211_FTM_TARGET_ATTR_ONE_SIDED))
+		return -ENOBUFS;
+
+	if (target->asap && nla_put_flag(msg, NL80211_FTM_TARGET_ATTR_ASAP))
+		return -ENOBUFS;
+
+	if (target->lci && nla_put_flag(msg, NL80211_FTM_TARGET_ATTR_QUERY_LCI))
+		return -ENOBUFS;
+
+	if (target->civic &&
+	    nla_put_flag(msg, NL80211_FTM_TARGET_ATTR_QUERY_CIVIC))
+		return -ENOBUFS;
+
+	nla_nest_end(msg, attr);
+	return 0;
+}
+
+static int nl80211_put_ftm_result(struct sk_buff *msg,
+				  struct cfg80211_ftm_result *ftm)
+{
+	struct nlattr *resp = nla_nest_start(msg,
+					     NL80211_ATTR_MSRMENT_FTM_RESPONSE);
+
+	if (!resp)
+		return -ENOBUFS;
+
+	if (nla_put_u8(msg, NL80211_FTM_RESP_ENTRY_ATTR_STATUS, ftm->status) ||
+	    (ftm->complete &&
+	     nla_put_flag(msg, NL80211_FTM_RESP_ENTRY_ATTR_COMPLETE)) ||
+	    nl80211_put_ftm_resp_target(msg, ftm->target) ||
+	    nla_put_u64(msg, NL80211_FTM_RESP_ENTRY_ATTR_HOST_TIME,
+			ftm->host_time) ||
+	    (ftm->tsf && nla_put_u64(msg, NL80211_FTM_RESP_ENTRY_ATTR_TSF,
+				     ftm->tsf)) ||
+	    nla_put_u8(msg, NL80211_FTM_RESP_ENTRY_ATTR_BURST_INDEX,
+		       ftm->burst_index) ||
+	    nla_put_s8(msg, NL80211_FTM_RESP_ENTRY_ATTR_RSSI, ftm->rssi) ||
+	    nla_put_u8(msg, NL80211_FTM_RESP_ENTRY_ATTR_RSSI_SPREAD,
+		       ftm->rssi_spread) ||
+	    nl80211_put_sta_rate(msg, &ftm->rate_info,
+				 NL80211_FTM_RESP_ENTRY_ATTR_RATE_INFO) ||
+	    nla_put_u32(msg, NL80211_FTM_RESP_ENTRY_ATTR_RTT, ftm->rtt) ||
+	    nla_put_u32(msg, NL80211_FTM_RESP_ENTRY_ATTR_RTT_VAR,
+			ftm->rtt_variance) ||
+	    nla_put_u32(msg, NL80211_FTM_RESP_ENTRY_ATTR_RTT_SPREAD,
+			ftm->rtt_spread))
+		return -ENOBUFS;
+
+	nla_nest_end(msg, resp);
+
+	return 0;
+}
+
+static struct sk_buff *
+nl80211_alloc_measurement_response(struct wiphy *wiphy,
+				   struct cfg80211_msrment_response *response,
+				   void **hdr, gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct sk_buff *msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+
+	if (!msg)
+		return NULL;
+
+	*hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_MSRMENT_RESPONSE);
+	if (!*hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u64(msg, NL80211_ATTR_COOKIE, response->cookie) ||
+	    nla_put_u32(msg, NL80211_ATTR_MSRMENT_TYPE, response->type) ||
+	    nla_put_u8(msg, NL80211_ATTR_MSRMENT_STATUS, response->status))
+		goto nla_put_failure;
+
+	return msg;
+
+nla_put_failure:
+	WARN_ON(1);
+	nlmsg_free(msg);
+	return NULL;
+}
+
+static void
+nl80211_send_measurement_response(struct wiphy *wiphy,
+				  struct cfg80211_msrment_response *response,
+				  struct sk_buff *msg, void *hdr)
+{
+	genlmsg_end(msg, hdr);
+	genlmsg_unicast(wiphy_net(wiphy), msg, response->nl_portid);
+}
+
+static void nl80211_ftm_response(struct wiphy *wiphy,
+				 struct cfg80211_msrment_response *response,
+				 gfp_t gfp)
+{
+	void *hdr;
+	struct cfg80211_ftm_results ftm = response->u.ftm;
+	struct sk_buff *msg;
+	int i;
+
+	for (i = 0; i < ftm.num_of_entries; i++) {
+		msg = nl80211_alloc_measurement_response(wiphy, response,
+							 &hdr, gfp);
+		if (!msg)
+			return;
+
+		if (nl80211_put_ftm_result(msg, &ftm.entries[i]))
+			goto nla_put_failure;
+
+		if (i == ftm.num_of_entries - 1 &&
+		    nla_put_flag(msg, NL80211_ATTR_LAST_MSG))
+			goto nla_put_failure;
+
+		nl80211_send_measurement_response(wiphy, response, msg, hdr);
+	}
+
+	return;
+
+nla_put_failure:
+	WARN_ON(1);
+	nlmsg_free(msg);
+}
+
+void cfg80211_measurement_response(struct wiphy *wiphy,
+				   struct cfg80211_msrment_response *response,
+				   gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct cfg80211_active_msrment *tmp, *msrment = NULL;
+
+	trace_cfg80211_measurement_response(wiphy, response);
+
+	spin_lock_bh(&rdev->msrments_lock);
+	list_for_each_entry(tmp, &rdev->msrments_list, list) {
+		if (tmp->cookie == tmp->cookie) {
+			msrment = tmp;
+			list_del(&tmp->list);
+			break;
+		}
+	}
+	spin_unlock_bh(&rdev->msrments_lock);
+
+	/* if not found or no portid it was canceled already */
+	if (!msrment || !msrment->nl_portid)
+		goto free;
+
+	switch (response->type) {
+	case NL80211_MSRMENT_TYPE_FTM:
+		nl80211_ftm_response(wiphy, response, gfp);
+		break;
+	default:
+		WARN(1, "invalid measurement type %d\n", response->type);
+		break;
+	};
+ free:
+	kfree(msrment);
+}
+EXPORT_SYMBOL(cfg80211_measurement_response);
+
 void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 {
 	struct wiphy *wiphy = wdev->wiphy;
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 8ae0c04f9fc7..1d4f326a0161 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1071,4 +1071,31 @@ rdev_set_coalesce(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int rdev_perform_msrment(struct cfg80211_registered_device *rdev,
+				       struct wireless_dev *wdev,
+				       struct cfg80211_msrment_request *request,
+				       u64 *cookie)
+{
+	int ret = -ENOTSUPP;
+
+	trace_rdev_perform_msrment(&rdev->wiphy, wdev, request);
+	if (rdev->ops->perform_msrment)
+		ret = rdev->ops->perform_msrment(&rdev->wiphy, wdev,
+						 request, cookie);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	return ret;
+}
+
+static inline int rdev_abort_msrment(struct cfg80211_registered_device *rdev,
+				     struct wireless_dev *wdev, u64 cookie)
+{
+	int ret = -ENOTSUPP;
+
+	trace_rdev_abort_msrment(&rdev->wiphy, wdev, cookie);
+	if (rdev->ops->abort_msrment)
+		ret = rdev->ops->abort_msrment(&rdev->wiphy, wdev, cookie);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 09b242b09bed..86377dcc4199 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2120,6 +2120,41 @@ TRACE_EVENT(rdev_tdls_cancel_channel_switch,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
 );
 
+TRACE_EVENT(rdev_perform_msrment,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 struct cfg80211_msrment_request *request),
+	TP_ARGS(wiphy, wdev, request),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(enum nl80211_msrment_type, type)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->type = request->type;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", type %d",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->type)
+);
+
+TRACE_EVENT(rdev_abort_msrment,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, u64 cookie),
+	TP_ARGS(wiphy, wdev, cookie),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u64, cookie)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", cookie %llu",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->cookie)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
@@ -2841,6 +2876,26 @@ TRACE_EVENT(cfg80211_ft_event,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(target_ap))
 );
 
+TRACE_EVENT(cfg80211_measurement_response,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct cfg80211_msrment_response *response),
+	TP_ARGS(wiphy, response),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(u64, cookie)
+		__field(enum nl80211_msrment_type, type)
+		__field(enum nl80211_msrment_status, status)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->cookie = response->cookie;
+		__entry->type = response->type;
+		__entry->status = response->status;
+	),
+	TP_printk(WIPHY_PR_FMT ", cookie %llu, type %d, status %d",
+		  WIPHY_PR_ARG, __entry->cookie, __entry->type, __entry->status)
+);
+
 TRACE_EVENT(cfg80211_stop_iface,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev),
-- 
2.6.2

