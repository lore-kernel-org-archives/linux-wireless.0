Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AEEC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B94F20868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B94F20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbeJLRka (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:40:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:46872 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbeJLRk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:40:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAuN7-0000e7-9G; Fri, 12 Oct 2018 12:08:41 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v3] cfg80211: add peer measurement with FTM API
Date:   Fri, 12 Oct 2018 12:08:27 +0200
Message-Id: <20181012100827.24195-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add a new "peer measurement" API, that can be used to measure
certain things related to a peer. Right now, only implement
FTM (flight time measurement) over it, but the idea is that
it'll be extensible to also support measuring the necessary
things to calculate e.g. angle-of-arrival for WiGig.

The API is structured to have a generic list of peers and
channels to measure with/on, and then for each of those a
set of measurements (again, only FTM right now) to perform.

Results are sent to the requesting socket, including a final
complete message.

Closing the controlling netlink socket will abort a running
measurement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v3:
 - add a bit to report "final" for partial results
 - remove list keeping etc. and just unicast out the results
   to the requester (big code reduction ...)
 - also send complete message unicast, and as a result
   remove the multicast group
 - separate out struct cfg80211_pmsr_ftm_request_peer
   from struct cfg80211_pmsr_request_peer
 - document timeout == 0 if no timeout
 - disallow setting timeout nl80211 attribute to 0,
   must not include attribute for no timeout
 - make MAC address randomization optional
 - change num bursts exponent default to 0 (1 burst, rather
   rather than the old default of 15==don't care)
---
 include/net/cfg80211.h       | 255 +++++++++++++++++++
 include/uapi/linux/nl80211.h | 410 ++++++++++++++++++++++++++++++
 net/wireless/Makefile        |   1 +
 net/wireless/core.c          |  33 +++
 net/wireless/core.h          |   4 +
 net/wireless/nl80211.c       | 200 ++++++++++++---
 net/wireless/nl80211.h       |  41 +++
 net/wireless/pmsr.c          | 576 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  25 ++
 net/wireless/trace.h         |  68 +++++
 10 files changed, 1579 insertions(+), 34 deletions(-)
 create mode 100644 net/wireless/pmsr.c

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0e16e723dcef..2837ea5f37e1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2841,6 +2841,191 @@ struct cfg80211_ftm_responder_stats {
 	u32 out_of_window_triggers_num;
 };
 
+/**
+ * struct cfg80211_pmsr_ftm_result - FTM result
+ * @failure_reason: if this measurement failed (PMSR status is
+ *	%NL80211_PMSR_STATUS_FAILURE), this gives a more precise
+ *	reason than just "failure"
+ * @burst_index: if reporting partial results, this is the index
+ *	in [0 .. num_bursts-1] of the burst that's being reported
+ * @num_ftmr_attempts: number of FTM request frames transmitted
+ * @num_ftmr_successes: number of FTM request frames acked
+ * @busy_retry_time: if failure_reason is %NL80211_PMSR_FTM_FAILURE_PEER_BUSY,
+ *	fill this to indicate in how many seconds a retry is deemed possible
+ *	by the responder
+ * @num_bursts_exp: actual number of bursts exponent negotiated
+ * @burst_duration: actual burst duration negotiated
+ * @frames_per_burst: actual frames per burst negotiated
+ * @lci_len: length of LCI information (if present)
+ * @civicloc_len: length of civic location information (if present)
+ * @lci: LCI data (may be %NULL)
+ * @civicloc: civic location data (may be %NULL)
+ * @rssi_avg: average RSSI over FTM action frames reported
+ * @rssi_spread: spread of the RSSI over FTM action frames reported
+ * @tx_rate: bitrate for transmitted FTM action frame response
+ * @rx_rate: bitrate of received FTM action frame
+ * @rtt_avg: average of RTTs measured (must have either this or @dist_avg)
+ * @rtt_variance: variance of RTTs measured (note that standard deviation is
+ *	the square root of the variance)
+ * @rtt_spread: spread of the RTTs measured
+ * @dist_avg: average of distances (mm) measured
+ *	(must have either this or @rtt_avg)
+ * @dist_variance: variance of distances measured (see also @rtt_variance)
+ * @dist_spread: spread of distances measured (see also @rtt_spread)
+ * @num_ftmr_attempts_valid: @num_ftmr_attempts is valid
+ * @num_ftmr_successes_valid: @num_ftmr_successes is valid
+ * @rssi_avg_valid: @rssi_avg is valid
+ * @rssi_spread_valid: @rssi_spread is valid
+ * @tx_rate_valid: @tx_rate is valid
+ * @rx_rate_valid: @rx_rate is valid
+ * @rtt_avg_valid: @rtt_avg is valid
+ * @rtt_variance_valid: @rtt_variance is valid
+ * @rtt_spread_valid: @rtt_spread is valid
+ * @dist_avg_valid: @dist_avg is valid
+ * @dist_variance_valid: @dist_variance is valid
+ * @dist_spread_valid: @dist_spread is valid
+ */
+struct cfg80211_pmsr_ftm_result {
+	const u8 *lci;
+	const u8 *civicloc;
+	unsigned int lci_len;
+	unsigned int civicloc_len;
+	enum nl80211_peer_measurement_ftm_failure_reasons failure_reason;
+	u32 num_ftmr_attempts, num_ftmr_successes;
+	s16 burst_index;
+	u8 busy_retry_time;
+	u8 num_bursts_exp;
+	u8 burst_duration;
+	u8 frames_per_burst;
+	s32 rssi_avg;
+	s32 rssi_spread;
+	struct rate_info tx_rate, rx_rate;
+	s64 rtt_avg;
+	s64 rtt_variance;
+	s64 rtt_spread;
+	s64 dist_avg;
+	s64 dist_variance;
+	s64 dist_spread;
+
+	u16 num_ftmr_attempts_valid:1,
+	    num_ftmr_successes_valid:1,
+	    rssi_avg_valid:1,
+	    rssi_spread_valid:1,
+	    tx_rate_valid:1,
+	    rx_rate_valid:1,
+	    rtt_avg_valid:1,
+	    rtt_variance_valid:1,
+	    rtt_spread_valid:1,
+	    dist_avg_valid:1,
+	    dist_variance_valid:1,
+	    dist_spread_valid:1;
+};
+
+/**
+ * struct cfg80211_pmsr_result - peer measurement result
+ * @addr: address of the peer
+ * @host_time: host time (use ktime_get_boottime() adjust to the time when the
+ *	measurement was made)
+ * @ap_tsf: AP's TSF at measurement time
+ * @status: status of the measurement
+ * @partial: indicates that this is a partial result for this type
+ * @final: if reporting partial results, mark this as the last one
+ * @ap_tsf_valid: indicates the @ap_tsf value is valid
+ * @type: type of the measurement reported, note that we only support reporting
+ *	one type at a time, but you can report multiple results separately and
+ *	they're all aggregated for userspace.
+ */
+struct cfg80211_pmsr_result {
+	u64 host_time, ap_tsf;
+	enum nl80211_peer_measurement_status status;
+
+	u8 addr[ETH_ALEN];
+
+	u8 partial:1,
+	   final:1,
+	   ap_tsf_valid:1;
+
+	enum nl80211_peer_measurement_type type;
+
+	union {
+		struct cfg80211_pmsr_ftm_result ftm;
+	};
+};
+
+/**
+ * struct cfg80211_pmsr_ftm_request_peer - FTM request data
+ * @requested: indicates FTM is requested
+ * @preamble: frame preamble to use
+ * @burst_period: burst period to use
+ * @asap: indicates to use ASAP mode
+ * @num_bursts_exp: number of bursts exponent
+ * @burst_duration: burst duration
+ * @frames_per_burst: number of frames per burst
+ * @ftmr_retries: number of retries for FTM request
+ * @request_lci: request LCI information
+ * @request_civicloc: request civic location information
+ *
+ * See also nl80211 for the respective attribute documentation.
+ */
+struct cfg80211_pmsr_ftm_request_peer {
+	enum nl80211_preamble preamble;
+	u16 burst_period;
+	bool requested;
+	bool asap;
+	u8 num_bursts_exp;
+	u8 burst_duration;
+	u8 frames_per_burst;
+	u8 ftmr_retries;
+	bool request_lci;
+	bool request_civicloc;
+};
+
+/**
+ * struct cfg80211_pmsr_request_peer - peer data for a peer measurement request
+ * @addr: MAC address
+ * @chandef: channel to use
+ * @report_ap_tsf: report the associated AP's TSF
+ * @ftm: FTM data, see &struct cfg80211_pmsr_ftm_request_peer
+ */
+struct cfg80211_pmsr_request_peer {
+	u8 addr[ETH_ALEN];
+	struct cfg80211_chan_def chandef;
+	bool report_ap_tsf;
+	struct cfg80211_pmsr_ftm_request_peer ftm;
+};
+
+/**
+ * struct cfg80211_pmsr_request - peer measurement request
+ * @cookie: cookie, set by cfg80211
+ * @nl_portid: netlink portid - used by cfg80211
+ * @drv_data: driver data for this request, if required for aborting,
+ *	not otherwise freed or anything by cfg80211
+ * @mac_addr: MAC address used for (randomised) request
+ * @mac_addr_mask: MAC address mask used for randomisation, bits that
+ *	are 0 in the mask should be randomised, bits that are 1 should
+ *	be taken from the @mac_addr
+ * @list: used by cfg80211 to hold on to the request
+ * @timeout: timeout (in milliseconds) for the whole operation, if
+ *	zero it means there's no timeout
+ * @n_peers: number of peers to do measurements with
+ * @peers: per-peer measurement request data
+ */
+struct cfg80211_pmsr_request {
+	u64 cookie;
+	void *drv_data;
+	u32 n_peers;
+	u32 nl_portid;
+
+	u32 timeout;
+
+	u8 mac_addr[ETH_ALEN] __aligned(2);
+	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
+
+	struct list_head list;
+
+	struct cfg80211_pmsr_request_peer peers[];
+};
+
 /**
  * struct cfg80211_ops - backend description for wireless configuration
  *
@@ -3176,6 +3361,8 @@ struct cfg80211_ftm_responder_stats {
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ * @start_pmsr: start peer measurement (e.g. FTM)
+ * @abort_pmsr: abort peer measurement
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3485,6 +3672,11 @@ struct cfg80211_ops {
 	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct cfg80211_ftm_responder_stats *ftm_stats);
+
+	int	(*start_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			      struct cfg80211_pmsr_request *request);
+	void	(*abort_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			      struct cfg80211_pmsr_request *request);
 };
 
 /*
@@ -3856,6 +4048,33 @@ struct wiphy_iftype_ext_capab {
 	u8 extended_capabilities_len;
 };
 
+/**
+ * struct cfg80211_pmsr_capabilities - cfg80211 peer measurement capabilities
+ * @max_peers: maximum number of peers in a single measurement
+ * @report_ap_tsf: can report assoc AP's TSF for radio resource measurement
+ * @randomize_mac_addr: can randomize MAC address for measurement
+ * @ftm.supported: FTM measurement is supported
+ * @ftm.asap: ASAP-mode is supported
+ * @ftm.non_asap: non-ASAP-mode is supported
+ * @ftm.request_lci: can request LCI data
+ * @ftm.request_civicloc: can request civic location data
+ * @ftm.preambles: bitmap of preambles supported (&enum nl80211_preamble)
+ * @ftm.bandwidths: bitmap of bandwidths supported (&enum nl80211_chan_width)
+ */
+struct cfg80211_pmsr_capabilities {
+	unsigned int max_peers;
+	bool report_ap_tsf;
+	bool randomize_mac_addr;
+
+	struct {
+		bool supported;
+		bool asap, non_asap;
+		bool request_lci, request_civicloc;
+		u32 preambles;
+		u32 bandwidths;
+	} ftm;
+};
+
 /**
  * struct wiphy - wireless hardware description
  * @reg_notifier: the driver's regulatory notification callback,
@@ -4020,6 +4239,8 @@ struct wiphy_iftype_ext_capab {
  * @txq_limit: configuration of internal TX queue frame limit
  * @txq_memory_limit: configuration internal TX queue memory limit
  * @txq_quantum: configuration of internal TX queue scheduler quantum
+ *
+ * @pmsr_capa: peer measurement capabilities
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -4156,6 +4377,8 @@ struct wiphy {
 	u32 txq_memory_limit;
 	u32 txq_quantum;
 
+	const struct cfg80211_pmsr_capabilities *pmsr_capa;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -4358,6 +4581,9 @@ struct cfg80211_cqm_config;
  * @owner_nlportid: (private) owner socket port ID
  * @nl_owner_dead: (private) owner socket went away
  * @cqm_config: (private) nl80211 RSSI monitor state
+ * @pmsr_list: (private) peer measurement requests
+ * @pmsr_lock: (private) peer measurements requests/results lock
+ * @pmsr_free_wk: (private) peer measurements cleanup work
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -4429,6 +4655,10 @@ struct wireless_dev {
 #endif
 
 	struct cfg80211_cqm_config *cqm_config;
+
+	struct list_head pmsr_list;
+	spinlock_t pmsr_lock;
+	struct work_struct pmsr_free_wk;
 };
 
 static inline u8 *wdev_address(struct wireless_dev *wdev)
@@ -6623,6 +6853,31 @@ int cfg80211_external_auth_request(struct net_device *netdev,
 				   struct cfg80211_external_auth_params *params,
 				   gfp_t gfp);
 
+/**
+ * cfg80211_pmsr_report - report peer measurement result data
+ * @wdev: the wireless device reporting the measurement
+ * @req: the original measurement request
+ * @result: the result data
+ * @gfp: allocation flags
+ */
+void cfg80211_pmsr_report(struct wireless_dev *wdev,
+			  struct cfg80211_pmsr_request *req,
+			  struct cfg80211_pmsr_result *result,
+			  gfp_t gfp);
+
+/**
+ * cfg80211_pmsr_complete - report peer measurement completed
+ * @wdev: the wireless device reporting the measurement
+ * @req: the original measurement request
+ * @gfp: allocation flags
+ *
+ * Report that the entire measurement completed, after this
+ * the request pointer will no longer be valid.
+ */
+void cfg80211_pmsr_complete(struct wireless_dev *wdev,
+			    struct cfg80211_pmsr_request *req,
+			    gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dc6d5a1ef470..40be8968f60b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1036,6 +1036,30 @@
  * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
  *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
  *
+ * @NL80211_CMD_PEER_MEASUREMENT_START: start a (set of) peer measurement(s)
+ *	with the given parameters, which are encapsulated in the nested
+ *	%NL80211_ATTR_PEER_MEASUREMENTS attribute. Optionally, MAC address
+ *	randomization may be enabled and configured by specifying the
+ *	%NL80211_ATTR_MAC and %NL80211_ATTR_MAC_MASK attributes.
+ *	If a timeout is requested, use the %NL80211_ATTR_TIMEOUT attribute.
+ *	A u64 cookie for further %NL80211_ATTR_COOKIE use is is returned in
+ *	the netlink extended ack message.
+ *
+ *	To cancel a measurement, close the socket that requested it.
+ *
+ *	Measurement results are reported to the socket that requested the
+ *	measurement using @NL80211_CMD_PEER_MEASUREMENT_RESULT when they
+ *	become available, so applications must ensure a large enough socket
+ *	buffer size.
+ *
+ *	Depending on driver support it may or may not be possible to start
+ *	multiple concurrent measurements.
+ * @NL80211_CMD_PEER_MEASUREMENT_RESULT: This command number is used for the
+ *	result notification from the driver to the requesting socket.
+ * @NL80211_CMD_PEER_MEASUREMENT_COMPLETE: Notification only, indicating that
+ *	the measurement completed, using the measurement cookie
+ *	(%NL80211_ATTR_COOKIE).
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1250,6 +1274,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_FTM_RESPONDER_STATS,
 
+	NL80211_CMD_PEER_MEASUREMENT_START,
+	NL80211_CMD_PEER_MEASUREMENT_RESULT,
+	NL80211_CMD_PEER_MEASUREMENT_COMPLETE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2254,6 +2282,14 @@ enum nl80211_commands {
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
  *
+ * @NL80211_ATTR_TIMEOUT: Timeout for the given operation, in milliseconds (u32)
+ *
+ * @NL80211_ATTR_PEER_MEASUREMENTS: peer measurements request (and result)
+ *	data, uses nested attributes specified in
+ *	&enum nl80211_peer_measurement_attrs.
+ *	This is also used for capability advertisement in the wiphy information,
+ *	with the appropriate sub-attributes.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2699,6 +2735,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FTM_RESPONDER_STATS,
 
+	NL80211_ATTR_TIMEOUT,
+
+	NL80211_ATTR_PEER_MEASUREMENTS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5898,4 +5938,374 @@ enum nl80211_ftm_responder_stats {
 	NL80211_FTM_STATS_MAX = __NL80211_FTM_STATS_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_preamble - frame preamble types
+ * @NL80211_PREAMBLE_LEGACY: legacy (HR/DSSS, OFDM, ERP PHY) preamble
+ * @NL80211_PREAMBLE_HT: HT preamble
+ * @NL80211_PREAMBLE_VHT: VHT preamble
+ * @NL80211_PREAMBLE_DMG: DMG preamble
+ */
+enum nl80211_preamble {
+	NL80211_PREAMBLE_LEGACY,
+	NL80211_PREAMBLE_HT,
+	NL80211_PREAMBLE_VHT,
+	NL80211_PREAMBLE_DMG,
+};
+
+/**
+ * enum nl80211_peer_measurement_type - peer measurement types
+ * @NL80211_PMSR_TYPE_INVALID: invalid/unused, needed as we use
+ *	these numbers also for attributes
+ *
+ * @NL80211_PMSR_TYPE_FTM: flight time measurement
+ *
+ * @NUM_NL80211_PMSR_TYPES: internal
+ * @NL80211_PMSR_TYPE_MAX: highest type number
+ */
+enum nl80211_peer_measurement_type {
+	NL80211_PMSR_TYPE_INVALID,
+
+	NL80211_PMSR_TYPE_FTM,
+
+	NUM_NL80211_PMSR_TYPES,
+	NL80211_PMSR_TYPE_MAX = NUM_NL80211_PMSR_TYPES - 1
+};
+
+/**
+ * enum nl80211_peer_measurement_status - peer measurement status
+ * @NL80211_PMSR_STATUS_SUCCESS: measurement completed successfully
+ * @NL80211_PMSR_STATUS_REFUSED: measurement was locally refused
+ * @NL80211_PMSR_STATUS_TIMEOUT: measurement timed out
+ * @NL80211_PMSR_STATUS_FAILURE: measurement failed, a type-dependent
+ *	reason may be available in the response data
+ */
+enum nl80211_peer_measurement_status {
+	NL80211_PMSR_STATUS_SUCCESS,
+	NL80211_PMSR_STATUS_REFUSED,
+	NL80211_PMSR_STATUS_TIMEOUT,
+	NL80211_PMSR_STATUS_FAILURE,
+};
+
+/**
+ * enum nl80211_peer_measurement_req - peer measurement request attributes
+ * @__NL80211_PMSR_REQ_ATTR_INVALID: invalid
+ *
+ * @NL80211_PMSR_REQ_ATTR_DATA: This is a nested attribute with measurement
+ *	type-specific request data inside. The attributes used are from the
+ *	enums named nl80211_peer_measurement_<type>_req.
+ * @NL80211_PMSR_REQ_ATTR_GET_AP_TSF: include AP TSF timestamp, if supported
+ *	(flag attribute)
+ *
+ * @NUM_NL80211_PMSR_REQ_ATTRS: internal
+ * @NL80211_PMSR_REQ_ATTR_MAX: highest attribute number
+ */
+enum nl80211_peer_measurement_req {
+	__NL80211_PMSR_REQ_ATTR_INVALID,
+
+	NL80211_PMSR_REQ_ATTR_DATA,
+	NL80211_PMSR_REQ_ATTR_GET_AP_TSF,
+
+	/* keep last */
+	NUM_NL80211_PMSR_REQ_ATTRS,
+	NL80211_PMSR_REQ_ATTR_MAX = NUM_NL80211_PMSR_REQ_ATTRS - 1
+};
+
+/**
+ * enum nl80211_peer_measurement_resp - peer measurement response attributes
+ * @__NL80211_PMSR_RESP_ATTR_INVALID: invalid
+ *
+ * @NL80211_PMSR_RESP_ATTR_DATA: This is a nested attribute with measurement
+ *	type-specific results inside. The attributes used are from the enums
+ *	named nl80211_peer_measurement_<type>_resp.
+ * @NL80211_PMSR_RESP_ATTR_STATUS: u32 value with the measurement status
+ *	(using values from &enum nl80211_peer_measurement_status.)
+ * @NL80211_PMSR_RESP_ATTR_HOST_TIME: host time (%CLOCK_BOOTTIME) when the
+ *	result was measured; this value is not expected to be accurate to
+ *	more than 20ms. (u64, nanoseconds)
+ * @NL80211_PMSR_RESP_ATTR_AP_TSF: TSF of the AP that the interface
+ *	doing the measurement is connected to when the result was measured.
+ *	This shall be accurately reported if supported and requested
+ *	(u64, usec)
+ * @NL80211_PMSR_RESP_ATTR_PARTIAL: This is a partial result, e.g. when
+ *	multiple FTM bursts are reported separately this will be set in
+ *	all report entries.
+ * @NL80211_PMSR_RESP_ATTR_FINAL: Out of partial results, this is the
+ *	final one reported.
+ * @NL80211_PMSR_RESP_ATTR_PAD: padding for 64-bit attributes, ignore
+ *
+ * @NUM_NL80211_PMSR_RESP_ATTRS: internal
+ * @NL80211_PMSR_RESP_ATTR_MAX: highest attribute number
+ */
+enum nl80211_peer_measurement_resp {
+	__NL80211_PMSR_RESP_ATTR_INVALID,
+
+	NL80211_PMSR_RESP_ATTR_DATA,
+	NL80211_PMSR_RESP_ATTR_STATUS,
+	NL80211_PMSR_RESP_ATTR_HOST_TIME,
+	NL80211_PMSR_RESP_ATTR_AP_TSF,
+	NL80211_PMSR_RESP_ATTR_PARTIAL,
+	NL80211_PMSR_RESP_ATTR_FINAL,
+	NL80211_PMSR_RESP_ATTR_PAD,
+
+	/* keep last */
+	NUM_NL80211_PMSR_RESP_ATTRS,
+	NL80211_PMSR_RESP_ATTR_MAX = NUM_NL80211_PMSR_RESP_ATTRS - 1
+};
+
+/**
+ * enum nl80211_peer_measurement_peer_attrs - peer attributes for measurement
+ * @__NL80211_PMSR_PEER_ATTR_INVALID: invalid
+ *
+ * @NL80211_PMSR_PEER_ATTR_ADDR: peer's MAC address
+ * @NL80211_PMSR_PEER_ATTR_CHAN: channel definition, nested, using top-level
+ *	attributes like %NL80211_ATTR_WIPHY_FREQ etc.
+ * @NL80211_PMSR_PEER_ATTR_REQ: This is a nested attribute indexed by
+ *	measurement type, with attributes from the
+ *	&enum nl80211_peer_measurement_req inside.
+ * @NL80211_PMSR_PEER_ATTR_RESP: This is a nested attribute indexed by
+ *	measurement type, with attributes from the
+ *	&enum nl80211_peer_measurement_resp inside.
+ *
+ * @NUM_NL80211_PMSR_PEER_ATTRS: internal
+ * @NL80211_PMSR_PEER_ATTR_MAX: highest attribute number
+ */
+enum nl80211_peer_measurement_peer_attrs {
+	__NL80211_PMSR_PEER_ATTR_INVALID,
+
+	NL80211_PMSR_PEER_ATTR_ADDR,
+	NL80211_PMSR_PEER_ATTR_CHAN,
+	NL80211_PMSR_PEER_ATTR_REQ,
+	NL80211_PMSR_PEER_ATTR_RESP,
+
+	/* keep last */
+	NUM_NL80211_PMSR_PEER_ATTRS,
+	NL80211_PMSR_PEER_ATTR_MAX = NUM_NL80211_PMSR_PEER_ATTRS - 1,
+};
+
+/**
+ * enum nl80211_peer_measurement_attrs - peer measurement attributes
+ * @__NL80211_PMSR_ATTR_INVALID: invalid
+ *
+ * @NL80211_PMSR_ATTR_MAX_PEERS: u32 attribute used for capability
+ *	advertisement only, indicates the maximum number of peers
+ *	measurements can be done with in a single request
+ * @NL80211_PMSR_ATTR_REPORT_AP_TSF: flag attribute in capability
+ *	indicating that the connected AP's TSF can be reported in
+ *	measurement results
+ * @NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR: flag attribute in capability
+ *	indicating that MAC address randomization is supported.
+ * @NL80211_PMSR_ATTR_TYPE_CAPA: capabilities reported by the device,
+ *	this contains a nesting indexed by measurement type, and
+ *	type-specific capabilities inside, which are from the enums
+ *	named nl80211_peer_measurement_<type>_capa.
+ * @NL80211_PMSR_ATTR_PEERS: nested attribute, the nesting index is
+ *	meaningless, just a list of peers to measure with, with the
+ *	sub-attributes taken from
+ *	&enum nl80211_peer_measurement_peer_attrs.
+ *
+ * @NUM_NL80211_PMSR_ATTR: internal
+ * @NL80211_PMSR_ATTR_MAX: highest attribute number
+ */
+enum nl80211_peer_measurement_attrs {
+	__NL80211_PMSR_ATTR_INVALID,
+
+	NL80211_PMSR_ATTR_MAX_PEERS,
+	NL80211_PMSR_ATTR_REPORT_AP_TSF,
+	NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR,
+	NL80211_PMSR_ATTR_TYPE_CAPA,
+	NL80211_PMSR_ATTR_PEERS,
+
+	/* keep last */
+	NUM_NL80211_PMSR_ATTR,
+	NL80211_PMSR_ATTR_MAX = NUM_NL80211_PMSR_ATTR - 1
+};
+
+/**
+ * enum nl80211_peer_measurement_ftm_capa - FTM capabilities
+ * @__NL80211_PMSR_FTM_CAPA_ATTR_INVALID: invalid
+ *
+ * @NL80211_PMSR_FTM_CAPA_ATTR_ASAP: flag attribute indicating ASAP mode
+ *	is supported
+ * @NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP: flag attribute indicating non-ASAP
+ *	mode is supported
+ * @NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI: flag attribute indicating if LCI
+ *	data can be requested during the measurement
+ * @NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC: flag attribute indicating if civic
+ *	location data can be requested during the measurement
+ * @NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES: u32 bitmap attribute of bits
+ *	from &enum nl80211_preamble.
+ * @NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS: bitmap of values from
+ *	&enum nl80211_chan_width indicating the supported channel
+ *	bandwidths for FTM. Note that a higher channel bandwidth may be
+ *	configured to allow for other measurements types with different
+ *	bandwidth requirement in the same measurement.
+ *
+ * @NUM_NL80211_PMSR_FTM_CAPA_ATTR: internal
+ * @NL80211_PMSR_FTM_CAPA_ATTR_MAX: highest attribute number
+ */
+enum nl80211_peer_measurement_ftm_capa {
+	__NL80211_PMSR_FTM_CAPA_ATTR_INVALID,
+
+	NL80211_PMSR_FTM_CAPA_ATTR_ASAP,
+	NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP,
+	NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI,
+	NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC,
+	NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES,
+	NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS,
+
+	/* keep last */
+	NUM_NL80211_PMSR_FTM_CAPA_ATTR,
+	NL80211_PMSR_FTM_CAPA_ATTR_MAX = NUM_NL80211_PMSR_FTM_CAPA_ATTR - 1
+};
+
+/**
+ * enum nl80211_peer_measurement_ftm_req - FTM request attributes
+ * @__NL80211_PMSR_FTM_REQ_ATTR_INVALID: invalid
+ *
+ * @NL80211_PMSR_FTM_REQ_ATTR_ASAP: ASAP mode requested (flag)
+ * @NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE: preamble type (see
+ *	&enum nl80211_preamble), optional for DMG (u32)
+ * @NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP: number of bursts exponent as in
+ *	802.11-2016 9.4.2.168 "Fine Timing Measurement Parameters element"
+ *	(u8, 0-15, optional with default 15 i.e. "no preference")
+ * @NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD: interval between bursts in units
+ *	of 100ms (u16, optional with default 0)
+ * @NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION: burst duration, as in 802.11-2016
+ *	Table 9-257 "Burst Duration field encoding" (u8, 0-15, optional with
+ *	default 15 i.e. "no preference")
+ * @NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST: number of successful FTM frames
+ *	requested per burst
+ *	(u8, 0-31, optional with default 0 i.e. "no preference")
+ * @NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES: number of FTMR frame retries
+ *	(u8, default 3)
+ * @NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI: request LCI data (flag)
+ * @NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC: request civic location data (flag)
+ *
+ * @NUM_NL80211_PMSR_FTM_REQ_ATTR: internal
+ * @NL80211_PMSR_FTM_REQ_ATTR_MAX: highest attribute number
+ */
+enum nl80211_peer_measurement_ftm_req {
+	__NL80211_PMSR_FTM_REQ_ATTR_INVALID,
+
+	NL80211_PMSR_FTM_REQ_ATTR_ASAP,
+	NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE,
+	NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP,
+	NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD,
+	NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION,
+	NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST,
+	NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES,
+	NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI,
+	NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC,
+
+	/* keep last */
+	NUM_NL80211_PMSR_FTM_REQ_ATTR,
+	NL80211_PMSR_FTM_REQ_ATTR_MAX = NUM_NL80211_PMSR_FTM_REQ_ATTR - 1
+};
+
+/**
+ * enum nl80211_peer_measurement_ftm_failure_reasons - FTM failure reasons
+ * @NL80211_PMSR_FTM_FAILURE_UNSPECIFIED: unspecified failure, not used
+ * @NL80211_PMSR_FTM_FAILURE_NO_RESPONSE: no response from the FTM responder
+ * @NL80211_PMSR_FTM_FAILURE_REJECTED: FTM responder rejected measurement
+ * @NL80211_PMSR_FTM_FAILURE_WRONG_CHANNEL: we already know the peer is
+ *	on a different channel, so can't measure (if we didn't know, we'd
+ *	try and get no response)
+ * @NL80211_PMSR_FTM_FAILURE_PEER_NOT_CAPABLE: peer can't actually do FTM
+ * @NL80211_PMSR_FTM_FAILURE_INVALID_TIMESTAMP: invalid T1/T4 timestamps
+ *	received
+ * @NL80211_PMSR_FTM_FAILURE_PEER_BUSY: peer reports busy, you may retry
+ *	later (see %NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME)
+ * @NL80211_PMSR_FTM_FAILURE_BAD_CHANGED_PARAMS: parameters were changed
+ *	by the peer and are no longer supported
+ */
+enum nl80211_peer_measurement_ftm_failure_reasons {
+	NL80211_PMSR_FTM_FAILURE_UNSPECIFIED,
+	NL80211_PMSR_FTM_FAILURE_NO_RESPONSE,
+	NL80211_PMSR_FTM_FAILURE_REJECTED,
+	NL80211_PMSR_FTM_FAILURE_WRONG_CHANNEL,
+	NL80211_PMSR_FTM_FAILURE_PEER_NOT_CAPABLE,
+	NL80211_PMSR_FTM_FAILURE_INVALID_TIMESTAMP,
+	NL80211_PMSR_FTM_FAILURE_PEER_BUSY,
+	NL80211_PMSR_FTM_FAILURE_BAD_CHANGED_PARAMS,
+};
+
+/**
+ * enum nl80211_peer_measurement_ftm_resp - FTM response attributes
+ * @__NL80211_PMSR_FTM_RESP_ATTR_INVALID: invalid
+ *
+ * @NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON: FTM-specific failure reason
+ *	(u32, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX: optional, if bursts are reported
+ *	as separate results then it will be the burst index 0...(N-1) and
+ *	the top level will indicate partial results (u32)
+ * @NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS: number of FTM Request frames
+ *	transmitted (u32, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES: number of FTM Request frames
+ *	that were acknowleged (u32, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME: retry time received from the
+ *	busy peer (u32, seconds)
+ * @NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP: actual number of bursts exponent
+ *	used by the responder (similar to request, u8)
+ * @NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION: actual burst duration used by
+ *	the responder (similar to request, u8)
+ * @NL80211_PMSR_FTM_RESP_ATTR_FRAMES_PER_BURST: actual frames per burst used
+ *	by the responder (similar to request, u8)
+ * @NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG: average RSSI across all FTM action
+ *	frames (optional, s32, 1/2 dBm)
+ * @NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD: RSSI spread across all FTM action
+ *	frames (optional, s32, 1/2 dBm)
+ * @NL80211_PMSR_FTM_RESP_ATTR_TX_RATE: bitrate we used for the response to the
+ *	FTM action frame (optional, nested, using &enum nl80211_rate_info
+ *	attributes)
+ * @NL80211_PMSR_FTM_RESP_ATTR_RX_RATE: bitrate the responder used for the FTM
+ *	action frame (optional, nested, using &enum nl80211_rate_info attrs)
+ * @NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG: average RTT (s64, picoseconds, optional
+ *	but one of RTT/DIST must be present)
+ * @NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE: RTT variance (u64, ps^2, note that
+ *	standard deviation is the square root of variance, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD: RTT spread (u64, picoseconds,
+ *	optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG: average distance (s64, mm, optional
+ *	but one of RTT/DIST must be present)
+ * @NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE: distance variance (u64, mm^2, note
+ *	that standard deviation is the square root of variance, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD: distance spread (u64, mm, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_LCI: LCI data from peer (binary, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC: civic location data from peer
+ *	(binary, optional)
+ * @NL80211_PMSR_FTM_RESP_ATTR_PAD: ignore, for u64/s64 padding only
+ *
+ * @NUM_NL80211_PMSR_FTM_RESP_ATTR: internal
+ * @NL80211_PMSR_FTM_RESP_ATTR_MAX: highest attribute number
+ */
+enum nl80211_peer_measurement_ftm_resp {
+	__NL80211_PMSR_FTM_RESP_ATTR_INVALID,
+
+	NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON,
+	NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX,
+	NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS,
+	NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES,
+	NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME,
+	NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP,
+	NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION,
+	NL80211_PMSR_FTM_RESP_ATTR_FRAMES_PER_BURST,
+	NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG,
+	NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD,
+	NL80211_PMSR_FTM_RESP_ATTR_TX_RATE,
+	NL80211_PMSR_FTM_RESP_ATTR_RX_RATE,
+	NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG,
+	NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE,
+	NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD,
+	NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG,
+	NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE,
+	NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD,
+	NL80211_PMSR_FTM_RESP_ATTR_LCI,
+	NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC,
+	NL80211_PMSR_FTM_RESP_ATTR_PAD,
+
+	/* keep last */
+	NUM_NL80211_PMSR_FTM_RESP_ATTR,
+	NL80211_PMSR_FTM_RESP_ATTR_MAX = NUM_NL80211_PMSR_FTM_RESP_ATTR - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 1d84f91bbfb0..72a224ce8e0a 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
 cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o ocb.o
+cfg80211-y += pmsr.o
 cfg80211-$(CONFIG_OF) += of.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5bd01058b9e6..677493dbfbf2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -664,6 +664,34 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 #endif
 
+	if (WARN_ON(wiphy->pmsr_capa && !wiphy->pmsr_capa->ftm.supported))
+		return -EINVAL;
+
+	if (wiphy->pmsr_capa && wiphy->pmsr_capa->ftm.supported) {
+		if (WARN_ON(!wiphy->pmsr_capa->ftm.asap &&
+			    !wiphy->pmsr_capa->ftm.non_asap))
+			return -EINVAL;
+		if (WARN_ON(!wiphy->pmsr_capa->ftm.preambles ||
+			    !wiphy->pmsr_capa->ftm.bandwidths))
+			return -EINVAL;
+		if (WARN_ON(wiphy->pmsr_capa->ftm.preambles &
+				~(BIT(NL80211_PREAMBLE_LEGACY) |
+				  BIT(NL80211_PREAMBLE_HT) |
+				  BIT(NL80211_PREAMBLE_VHT) |
+				  BIT(NL80211_PREAMBLE_DMG))))
+			return -EINVAL;
+		if (WARN_ON(wiphy->pmsr_capa->ftm.bandwidths &
+				~(BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+				  BIT(NL80211_CHAN_WIDTH_20) |
+				  BIT(NL80211_CHAN_WIDTH_40) |
+				  BIT(NL80211_CHAN_WIDTH_80) |
+				  BIT(NL80211_CHAN_WIDTH_80P80) |
+				  BIT(NL80211_CHAN_WIDTH_160) |
+				  BIT(NL80211_CHAN_WIDTH_5) |
+				  BIT(NL80211_CHAN_WIDTH_10))))
+			return -EINVAL;
+	}
+
 	/*
 	 * if a wiphy has unsupported modes for regulatory channel enforcement,
 	 * opt-out of enforcement checking
@@ -1053,6 +1081,8 @@ static void __cfg80211_unregister_wdev(struct wireless_dev *wdev, bool sync)
 		flush_work(&wdev->disconnect_wk);
 
 	cfg80211_cqm_config_free(wdev);
+
+	cfg80211_pmsr_free_wdev(wdev);
 }
 
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
@@ -1174,6 +1204,9 @@ void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
 	spin_lock_init(&wdev->event_lock);
 	INIT_LIST_HEAD(&wdev->mgmt_registrations);
 	spin_lock_init(&wdev->mgmt_registrations_lock);
+	INIT_LIST_HEAD(&wdev->pmsr_list);
+	spin_lock_init(&wdev->pmsr_lock);
+	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
 
 	/*
 	 * We get here also when the interface changes network namespaces,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index c61dbba8bf47..3f82d0ebb46b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -530,4 +530,8 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 
 void cfg80211_cqm_config_free(struct wireless_dev *wdev);
 
+void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid);
+void cfg80211_pmsr_free_wdev(struct wireless_dev *wdev);
+void cfg80211_pmsr_free_wk(struct work_struct *work);
+
 #endif /* __NET_WIRELESS_CORE_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 758bb069d000..254c9e7eb739 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -34,20 +34,6 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				   struct cfg80211_crypto_settings *settings,
 				   int cipher_limit);
 
-/* the netlink family */
-static struct genl_family nl80211_fam;
-
-/* multicast groups */
-enum nl80211_multicast_groups {
-	NL80211_MCGRP_CONFIG,
-	NL80211_MCGRP_SCAN,
-	NL80211_MCGRP_REGULATORY,
-	NL80211_MCGRP_MLME,
-	NL80211_MCGRP_VENDOR,
-	NL80211_MCGRP_NAN,
-	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
-};
-
 static const struct genl_multicast_group nl80211_mcgrps[] = {
 	[NL80211_MCGRP_CONFIG] = { .name = NL80211_MULTICAST_GROUP_CONFIG },
 	[NL80211_MCGRP_SCAN] = { .name = NL80211_MULTICAST_GROUP_SCAN },
@@ -240,7 +226,63 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
 					     .len = U8_MAX },
 };
 
-static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
+static const struct nla_policy
+nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
+	[NL80211_PMSR_FTM_REQ_ATTR_ASAP] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE] = { .type = NLA_U32 },
+	[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP] =
+		NLA_POLICY_MAX(NLA_U8, 15),
+	[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD] = { .type = NLA_U16 },
+	[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION] =
+		NLA_POLICY_MAX(NLA_U8, 15),
+	[NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST] =
+		NLA_POLICY_MAX(NLA_U8, 15),
+	[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES] = { .type = NLA_U8 },
+	[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC] = { .type = NLA_FLAG },
+};
+
+static const struct nla_policy
+nl80211_pmsr_req_data_policy[NL80211_PMSR_TYPE_MAX + 1] = {
+	[NL80211_PMSR_TYPE_FTM] =
+		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
+				  nl80211_pmsr_ftm_req_attr_policy),
+};
+
+static const struct nla_policy
+nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
+	[NL80211_PMSR_REQ_ATTR_DATA] =
+		NLA_POLICY_NESTED(NL80211_PMSR_TYPE_MAX,
+				  nl80211_pmsr_req_data_policy),
+	[NL80211_PMSR_REQ_ATTR_GET_AP_TSF] = { .type = NLA_FLAG },
+};
+
+static const struct nla_policy
+nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
+	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR,
+	/*
+	 * we could specify this again to be the top-level policy,
+	 * but that would open us up to recursion problems ...
+	 */
+	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_NESTED },
+	[NL80211_PMSR_PEER_ATTR_REQ] =
+		NLA_POLICY_NESTED(NL80211_PMSR_REQ_ATTR_MAX,
+				  nl80211_pmsr_req_attr_policy),
+	[NL80211_PMSR_PEER_ATTR_RESP] = { .type = NLA_REJECT },
+};
+
+static const struct nla_policy
+nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
+	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
+	[NL80211_PMSR_ATTR_PEERS] =
+		NLA_POLICY_NESTED_ARRAY(NL80211_PMSR_PEER_ATTR_MAX,
+					nl80211_psmr_peer_attr_policy),
+};
+
+const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = 20-1 },
@@ -497,6 +539,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		.type = NLA_NESTED,
 		.validation_data = nl80211_ftm_responder_policy,
 	},
+	[NL80211_ATTR_TIMEOUT] = NLA_POLICY_MIN(NLA_U32, 1),
+	[NL80211_ATTR_PEER_MEASUREMENTS] =
+		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
+				  nl80211_pmsr_attr_policy),
 };
 
 /* policy for the key attributes */
@@ -637,9 +683,9 @@ nl80211_packet_pattern_policy[MAX_NL80211_PKTPAT + 1] = {
 	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
 };
 
-static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
-				     struct cfg80211_registered_device **rdev,
-				     struct wireless_dev **wdev)
+int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
+			      struct cfg80211_registered_device **rdev,
+			      struct wireless_dev **wdev)
 {
 	int err;
 
@@ -684,8 +730,8 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
 }
 
 /* message building helper */
-static inline void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
-				   int flags, u8 cmd)
+void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
+		     int flags, u8 cmd)
 {
 	/* since there is no private header just add the generic one */
 	return genlmsg_put(skb, portid, seq, &nl80211_fam, flags, cmd);
@@ -1615,6 +1661,83 @@ static int nl80211_add_commands_unsplit(struct cfg80211_registered_device *rdev,
 	return -ENOBUFS;
 }
 
+static int
+nl80211_send_pmsr_ftm_capa(const struct cfg80211_pmsr_capabilities *cap,
+			   struct sk_buff *msg)
+{
+	struct nlattr *ftm;
+
+	if (!cap->ftm.supported)
+		return 0;
+
+	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
+	if (!ftm)
+		return -ENOBUFS;
+
+	if (cap->ftm.asap && nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_ASAP))
+		return -ENOBUFS;
+	if (cap->ftm.non_asap &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP))
+		return -ENOBUFS;
+	if (cap->ftm.request_lci &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI))
+		return -ENOBUFS;
+	if (cap->ftm.request_civicloc &&
+	    nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC))
+		return -ENOBUFS;
+	if (nla_put_u32(msg, NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES,
+			cap->ftm.preambles))
+		return -ENOBUFS;
+	if (nla_put_u32(msg, NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS,
+			cap->ftm.bandwidths))
+		return -ENOBUFS;
+
+	nla_nest_end(msg, ftm);
+	return 0;
+}
+
+static int nl80211_send_pmsr_capa(struct cfg80211_registered_device *rdev,
+				  struct sk_buff *msg)
+{
+	const struct cfg80211_pmsr_capabilities *cap = rdev->wiphy.pmsr_capa;
+	struct nlattr *pmsr, *caps;
+
+	if (!cap)
+		return 0;
+
+	/*
+	 * we don't need to clean up anything here since the caller
+	 * will genlmsg_cancel() if we fail
+	 */
+
+	pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
+	if (!pmsr)
+		return -ENOBUFS;
+
+	if (nla_put_u32(msg, NL80211_PMSR_ATTR_MAX_PEERS, cap->max_peers))
+		return -ENOBUFS;
+
+	if (cap->report_ap_tsf &&
+	    nla_put_flag(msg, NL80211_PMSR_ATTR_REPORT_AP_TSF))
+		return -ENOBUFS;
+
+	if (cap->randomize_mac_addr &&
+	    nla_put_flag(msg, NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR))
+		return -ENOBUFS;
+
+	caps = nla_nest_start(msg, NL80211_PMSR_ATTR_TYPE_CAPA);
+	if (!caps)
+		return -ENOBUFS;
+
+	if (nl80211_send_pmsr_ftm_capa(cap, msg))
+		return -ENOBUFS;
+
+	nla_nest_end(msg, caps);
+	nla_nest_end(msg, pmsr);
+
+	return 0;
+}
+
 struct nl80211_dump_wiphy_state {
 	s64 filter_wiphy;
 	long start;
@@ -2118,6 +2241,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				goto nla_put_failure;
 		}
 
+		state->split_start++;
+		break;
+	case 14:
+		if (nl80211_send_pmsr_capa(rdev, msg))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -2318,9 +2447,9 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;
 }
 
-static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
-				 struct genl_info *info,
-				 struct cfg80211_chan_def *chandef)
+int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
+			  struct genl_info *info,
+			  struct cfg80211_chan_def *chandef)
 {
 	struct netlink_ext_ack *extack = info->extack;
 	struct nlattr **attrs = info->attrs;
@@ -2794,12 +2923,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
-static inline u64 wdev_id(struct wireless_dev *wdev)
-{
-	return (u64)wdev->identifier |
-	       ((u64)wiphy_to_rdev(wdev->wiphy)->wiphy_idx << 32);
-}
-
 static int nl80211_send_chandef(struct sk_buff *msg,
 				const struct cfg80211_chan_def *chandef)
 {
@@ -4521,8 +4644,7 @@ static int parse_station_flags(struct genl_info *info,
 	return 0;
 }
 
-static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
-				 int attr)
+bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info, int attr)
 {
 	struct nlattr *rate;
 	u32 bitrate;
@@ -6853,8 +6975,8 @@ static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
 	return 0;
 }
 
-static int nl80211_parse_random_mac(struct nlattr **attrs,
-				    u8 *mac_addr, u8 *mac_addr_mask)
+int nl80211_parse_random_mac(struct nlattr **attrs,
+			     u8 *mac_addr, u8 *mac_addr_mask)
 {
 	int i;
 
@@ -13896,9 +14018,17 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_PEER_MEASUREMENT_START,
+		.doit = nl80211_pmsr_start,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
-static struct genl_family nl80211_fam __ro_after_init = {
+struct genl_family nl80211_fam __ro_after_init = {
 	.name = NL80211_GENL_NAME,	/* have users key off the name instead */
 	.hdrsize = 0,			/* no private header */
 	.version = 1,			/* no particular meaning now */
@@ -15879,6 +16009,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 			} else if (wdev->conn_owner_nlportid == notify->portid) {
 				schedule_work(&wdev->disconnect_wk);
 			}
+
+			cfg80211_release_pmsr(wdev, notify->portid);
 		}
 
 		spin_lock_bh(&rdev->beacon_registrations_lock);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 79e47fe60c35..1c689b270a9f 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -4,8 +4,45 @@
 
 #include "core.h"
 
+/* multicast groups */
+enum nl80211_multicast_groups {
+	NL80211_MCGRP_CONFIG,
+	NL80211_MCGRP_SCAN,
+	NL80211_MCGRP_REGULATORY,
+	NL80211_MCGRP_MLME,
+	NL80211_MCGRP_VENDOR,
+	NL80211_MCGRP_NAN,
+	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
+};
+
+extern struct genl_family nl80211_fam;
+
 int nl80211_init(void);
 void nl80211_exit(void);
+
+extern const struct nla_policy nl80211_policy[NUM_NL80211_ATTR];
+
+void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
+		     int flags, u8 cmd);
+bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
+			  int attr);
+
+static inline u64 wdev_id(struct wireless_dev *wdev)
+{
+	return (u64)wdev->identifier |
+	       ((u64)wiphy_to_rdev(wdev->wiphy)->wiphy_idx << 32);
+}
+
+int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
+			      struct cfg80211_registered_device **rdev,
+			      struct wireless_dev **wdev);
+
+int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
+			  struct genl_info *info,
+			  struct cfg80211_chan_def *chandef);
+int nl80211_parse_random_mac(struct nlattr **attrs,
+			     u8 *mac_addr, u8 *mac_addr_mask);
+
 void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
 			  enum nl80211_commands cmd);
 void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
@@ -95,4 +132,8 @@ void nl80211_send_ap_stopped(struct wireless_dev *wdev);
 
 void cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev);
 
+/* peer measurement */
+int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
+int nl80211_pmsr_dump_results(struct sk_buff *skb, struct netlink_callback *cb);
+
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
new file mode 100644
index 000000000000..881ba894eead
--- /dev/null
+++ b/net/wireless/pmsr.c
@@ -0,0 +1,576 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Copyright (C) 2018 Intel Corporation
+ */
+#ifndef __PMSR_H
+#define __PMSR_H
+#include <net/cfg80211.h>
+#include "core.h"
+#include "nl80211.h"
+#include "rdev-ops.h"
+
+static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
+			  struct nlattr *ftmreq,
+			  struct cfg80211_pmsr_request_peer *out,
+			  struct genl_info *info)
+{
+	const struct cfg80211_pmsr_capabilities *capa = rdev->wiphy.pmsr_capa;
+	struct nlattr *tb[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1];
+	u32 preamble = NL80211_PREAMBLE_DMG; /* only optional in DMG */
+
+	/* validate existing data */
+	if (!(rdev->wiphy.pmsr_capa->ftm.bandwidths & BIT(out->chandef.width))) {
+		NL_SET_ERR_MSG(info->extack, "FTM: unsupported bandwidth");
+		return -EINVAL;
+	}
+
+	/* no validation needed - was already done via nested policy */
+	nla_parse_nested(tb, NL80211_PMSR_FTM_REQ_ATTR_MAX, ftmreq, NULL, NULL);
+
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE])
+		preamble = nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE]);
+
+	/* set up values - struct is 0-initialized */
+	out->ftm.requested = true;
+
+	switch (out->chandef.chan->band) {
+	case NL80211_BAND_60GHZ:
+		/* optional */
+		break;
+	default:
+		if (!tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE]) {
+			NL_SET_ERR_MSG(info->extack,
+				       "FTM: must specify preamble");
+			return -EINVAL;
+		}
+	}
+
+	if (!(capa->ftm.preambles & BIT(preamble))) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE],
+				    "FTM: invalid preamble");
+		return -EINVAL;
+	}
+
+	out->ftm.preamble = preamble;
+
+	out->ftm.burst_period = 0;
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD])
+		out->ftm.burst_period =
+			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD]);
+
+	out->ftm.asap = tb[NL80211_PMSR_FTM_REQ_ATTR_ASAP];
+	if (out->ftm.asap && !capa->ftm.asap) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_PMSR_FTM_REQ_ATTR_ASAP],
+				    "FTM: ASAP mode not supported");
+		return -EINVAL;
+	}
+
+	if (!out->ftm.asap && !capa->ftm.non_asap) {
+		NL_SET_ERR_MSG(info->extack,
+			       "FTM: non-ASAP mode not supported");
+		return -EINVAL;
+	}
+
+	out->ftm.num_bursts_exp = 0;
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP])
+		out->ftm.num_bursts_exp =
+			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP]);
+
+	out->ftm.burst_duration = 15;
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION])
+		out->ftm.burst_duration =
+			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION]);
+
+	out->ftm.frames_per_burst = 0;
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST])
+		out->ftm.frames_per_burst =
+			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST]);
+
+	out->ftm.ftmr_retries = 3;
+	if (tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES])
+		out->ftm.ftmr_retries =
+			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES]);
+
+	out->ftm.request_lci = tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI];
+	if (out->ftm.request_lci && !capa->ftm.request_lci) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI],
+				    "FTM: LCI request not supported");
+	}
+
+	out->ftm.request_civicloc =
+		tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC];
+	if (out->ftm.request_civicloc && !capa->ftm.request_civicloc) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC],
+			    "FTM: civic location request not supported");
+	}
+
+	return 0;
+}
+
+static int pmsr_parse_peer(struct cfg80211_registered_device *rdev,
+			   struct nlattr *peer,
+			   struct cfg80211_pmsr_request_peer *out,
+			   struct genl_info *info)
+{
+	struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
+	struct nlattr *req[NL80211_PMSR_REQ_ATTR_MAX + 1];
+	struct nlattr *treq;
+	int err, rem;
+
+	/* no validation needed - was already done via nested policy */
+	nla_parse_nested(tb, NL80211_PMSR_PEER_ATTR_MAX, peer, NULL, NULL);
+
+	if (!tb[NL80211_PMSR_PEER_ATTR_ADDR] ||
+	    !tb[NL80211_PMSR_PEER_ATTR_CHAN] ||
+	    !tb[NL80211_PMSR_PEER_ATTR_REQ]) {
+		NL_SET_ERR_MSG_ATTR(info->extack, peer, "insufficient peer data");
+		return -EINVAL;
+	}
+
+	memcpy(out->addr, nla_data(tb[NL80211_PMSR_PEER_ATTR_ADDR]), ETH_ALEN);
+
+	/* reuse info->attrs */
+	memset(info->attrs, 0, sizeof(*info->attrs) * (NL80211_ATTR_MAX + 1));
+	/* need to validate here, we don't want to have validation recursion */
+	err = nla_parse_nested(info->attrs, NL80211_ATTR_MAX,
+			       tb[NL80211_PMSR_PEER_ATTR_CHAN],
+			       nl80211_policy, info->extack);
+	if (err)
+		return err;
+
+	err = nl80211_parse_chandef(rdev, info, &out->chandef);
+	if (err)
+		return err;
+
+	/* no validation needed - was already done via nested policy */
+	nla_parse_nested(req, NL80211_PMSR_REQ_ATTR_MAX,
+			 tb[NL80211_PMSR_PEER_ATTR_REQ],
+			 NULL, NULL);
+
+	if (!req[NL80211_PMSR_REQ_ATTR_DATA]) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    tb[NL80211_PMSR_PEER_ATTR_REQ],
+				    "missing request type/data");
+		return -EINVAL;
+	}
+
+	if (req[NL80211_PMSR_REQ_ATTR_GET_AP_TSF])
+		out->report_ap_tsf = true;
+
+	if (out->report_ap_tsf && !rdev->wiphy.pmsr_capa->report_ap_tsf) {
+		NL_SET_ERR_MSG_ATTR(info->extack,
+				    req[NL80211_PMSR_REQ_ATTR_GET_AP_TSF],
+				    "reporting AP TSF is not supported");
+		return -EINVAL;
+	}
+
+	nla_for_each_nested(treq, req[NL80211_PMSR_REQ_ATTR_DATA], rem) {
+		switch (nla_type(treq)) {
+		case NL80211_PMSR_TYPE_FTM:
+			err = pmsr_parse_ftm(rdev, treq, out, info);
+			break;
+		default:
+			NL_SET_ERR_MSG_ATTR(info->extack, treq,
+					    "unsupported measurement type");
+			err = -EINVAL;
+		}
+	}
+
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *reqattr = info->attrs[NL80211_ATTR_PEER_MEASUREMENTS];
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct cfg80211_pmsr_request *req;
+	struct nlattr *peers, *peer;
+	int count, rem, err, idx;
+
+	if (!rdev->wiphy.pmsr_capa)
+		return -EOPNOTSUPP;
+
+	if (!reqattr)
+		return -EINVAL;
+
+	peers = nla_find(nla_data(reqattr), nla_len(reqattr),
+			 NL80211_PMSR_ATTR_PEERS);
+	if (!peers)
+		return -EINVAL;
+
+	count = 0;
+	nla_for_each_nested(peer, peers, rem) {
+		count++;
+
+		if (count > rdev->wiphy.pmsr_capa->max_peers) {
+			NL_SET_ERR_MSG_ATTR(info->extack, peer,
+					    "Too many peers used");
+			return -EINVAL;
+		}
+	}
+
+	req = kzalloc(struct_size(req, peers, count), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	if (info->attrs[NL80211_ATTR_TIMEOUT])
+		req->timeout = nla_get_u32(info->attrs[NL80211_ATTR_TIMEOUT]);
+
+	if (info->attrs[NL80211_ATTR_MAC]) {
+		if (!rdev->wiphy.pmsr_capa->randomize_mac_addr) {
+			NL_SET_ERR_MSG_ATTR(info->extack,
+					    info->attrs[NL80211_ATTR_MAC],
+					    "device cannot randomize MAC address");
+			return -EINVAL;
+		}
+
+		err = nl80211_parse_random_mac(info->attrs, req->mac_addr,
+					       req->mac_addr_mask);
+		if (err)
+			return err;
+	} else {
+		memcpy(req->mac_addr, nla_data(info->attrs[NL80211_ATTR_MAC]),
+		       ETH_ALEN);
+		memset(req->mac_addr_mask, 0xff, ETH_ALEN);
+	}
+
+	idx = 0;
+	nla_for_each_nested(peer, peers, rem) {
+		/* NB: this reuses info->attrs, but we no longer need it */
+		err = pmsr_parse_peer(rdev, peer, &req->peers[idx], info);
+		if (err)
+			goto out_err;
+		idx++;
+	}
+
+	req->n_peers = count;
+	req->cookie = cfg80211_assign_cookie(rdev);
+
+	err = rdev_start_pmsr(rdev, wdev, req);
+	if (err)
+		goto out_err;
+
+	list_add_tail(&req->list, &wdev->pmsr_list);
+
+	nl_set_extack_cookie_u64(info->extack, req->cookie);
+	return 0;
+out_err:
+	kfree(req);
+	return err;
+}
+
+void cfg80211_pmsr_complete(struct wireless_dev *wdev,
+			    struct cfg80211_pmsr_request *req,
+			    gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	trace_cfg80211_pmsr_complete(wdev->wiphy, wdev, req->cookie);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		goto free_request;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_PEER_MEASUREMENT_COMPLETE);
+	if (!hdr)
+		goto free_msg;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD))
+		goto free_msg;
+
+	if (nla_put_u64_64bit(msg, NL80211_ATTR_COOKIE, req->cookie,
+			      NL80211_ATTR_PAD))
+		goto free_msg;
+
+	genlmsg_end(msg, hdr);
+	genlmsg_unicast(wiphy_net(wdev->wiphy), msg, req->nl_portid);
+	goto free_request;
+free_msg:
+	nlmsg_free(msg);
+free_request:
+	spin_lock_bh(&wdev->pmsr_lock);
+	list_del(&req->list);
+	spin_unlock_bh(&wdev->pmsr_lock);
+	kfree(req);
+}
+EXPORT_SYMBOL_GPL(cfg80211_pmsr_complete);
+
+static int nl80211_pmsr_send_ftm_res(struct sk_buff *msg,
+				     struct cfg80211_pmsr_result *res)
+{
+	if (res->status == NL80211_PMSR_STATUS_FAILURE) {
+		if (nla_put_u32(msg, NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON,
+				res->ftm.failure_reason))
+			goto error;
+
+		if (res->ftm.failure_reason ==
+			NL80211_PMSR_FTM_FAILURE_PEER_BUSY &&
+		    res->ftm.busy_retry_time &&
+		    nla_put_u32(msg, NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME,
+				res->ftm.busy_retry_time))
+			goto error;
+
+		return 0;
+	}
+
+#define PUT(tp, attr, val)						\
+	do {								\
+		if (nla_put_##tp(msg,					\
+			 NL80211_PMSR_FTM_RESP_ATTR_##attr,		\
+			 res->ftm.val))					\
+		goto error;						\
+	} while (0)
+
+#define PUTOPT(tp, attr, val)						\
+	do {								\
+		if (res->ftm.val##_valid)				\
+			PUT(tp, attr, val);				\
+	} while (0)
+
+#define PUT_U64(attr, val)						\
+	do {								\
+		if (nla_put_u64_64bit(msg,				\
+				      NL80211_PMSR_FTM_RESP_ATTR_##attr,\
+				      res->ftm.val,			\
+				      NL80211_PMSR_FTM_RESP_ATTR_PAD))	\
+			goto error;					\
+	} while (0)
+
+#define PUTOPT_U64(attr, val)						\
+	do {								\
+		if (res->ftm.val##_valid)				\
+			PUT_U64(attr, val);				\
+	} while (0)
+
+	if (res->ftm.burst_index >= 0)
+		PUT(u32, BURST_INDEX, burst_index);
+	PUTOPT(u32, NUM_FTMR_ATTEMPTS, num_ftmr_attempts);
+	PUTOPT(u32, NUM_FTMR_SUCCESSES, num_ftmr_successes);
+	PUT(u8, NUM_BURSTS_EXP, num_bursts_exp);
+	PUT(u8, BURST_DURATION, burst_duration);
+	PUT(u8, FRAMES_PER_BURST, frames_per_burst);
+	PUTOPT(s32, RSSI_AVG, rssi_avg);
+	PUTOPT(s32, RSSI_SPREAD, rssi_spread);
+	if (res->ftm.tx_rate_valid &&
+	    !nl80211_put_sta_rate(msg, &res->ftm.tx_rate,
+				  NL80211_PMSR_FTM_RESP_ATTR_TX_RATE))
+		goto error;
+	if (res->ftm.rx_rate_valid &&
+	    !nl80211_put_sta_rate(msg, &res->ftm.rx_rate,
+				  NL80211_PMSR_FTM_RESP_ATTR_RX_RATE))
+		goto error;
+	PUTOPT_U64(RTT_AVG, rtt_avg);
+	PUTOPT_U64(RTT_VARIANCE, rtt_variance);
+	PUTOPT_U64(RTT_SPREAD, rtt_spread);
+	PUTOPT_U64(DIST_AVG, dist_avg);
+	PUTOPT_U64(DIST_VARIANCE, dist_variance);
+	PUTOPT_U64(DIST_SPREAD, dist_spread);
+	if (res->ftm.lci && res->ftm.lci_len &&
+	    nla_put(msg, NL80211_PMSR_FTM_RESP_ATTR_LCI,
+		    res->ftm.lci_len, res->ftm.lci))
+		goto error;
+	if (res->ftm.civicloc && res->ftm.civicloc_len &&
+	    nla_put(msg, NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC,
+		    res->ftm.civicloc_len, res->ftm.civicloc))
+		goto error;
+#undef PUT
+#undef PUTOPT
+#undef PUT_U64
+#undef PUTOPT_U64
+
+	return 0;
+error:
+	return -ENOSPC;
+}
+
+static int nl80211_pmsr_send_result(struct sk_buff *msg,
+				    struct cfg80211_pmsr_result *res)
+{
+	struct nlattr *pmsr, *peers, *peer, *resp, *data, *typedata;
+
+	pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
+	if (!pmsr)
+		goto error;
+
+	peers = nla_nest_start(msg, NL80211_PMSR_ATTR_PEERS);
+	if (!peers)
+		goto error;
+
+	peer = nla_nest_start(msg, 1);
+	if (!peer)
+		goto error;
+
+	if (nla_put(msg, NL80211_PMSR_PEER_ATTR_ADDR, ETH_ALEN, res->addr))
+		goto error;
+
+	resp = nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_RESP);
+	if (!resp)
+		goto error;
+
+	if (nla_put_u32(msg, NL80211_PMSR_RESP_ATTR_STATUS, res->status) ||
+	    nla_put_u64_64bit(msg, NL80211_PMSR_RESP_ATTR_HOST_TIME,
+			      res->host_time, NL80211_PMSR_RESP_ATTR_PAD))
+		goto error;
+
+	if (res->ap_tsf_valid &&
+	    nla_put_u64_64bit(msg, NL80211_PMSR_RESP_ATTR_AP_TSF,
+			      res->host_time, NL80211_PMSR_RESP_ATTR_PAD))
+		goto error;
+
+	WARN_ON(res->final && !res->partial);
+	if (res->partial && nla_put_flag(msg, NL80211_PMSR_RESP_ATTR_PARTIAL))
+		goto error;
+	if (res->final && nla_put_flag(msg, NL80211_PMSR_RESP_ATTR_FINAL))
+		goto error;
+
+	data = nla_nest_start(msg, NL80211_PMSR_RESP_ATTR_DATA);
+	if (!data)
+		goto error;
+
+	typedata = nla_nest_start(msg, res->type);
+	if (!typedata)
+		goto error;
+
+	switch (res->type) {
+	case NL80211_PMSR_TYPE_FTM:
+		if (nl80211_pmsr_send_ftm_res(msg, res))
+			goto error;
+		break;
+	default:
+		WARN_ON(1);
+	}
+
+	nla_nest_end(msg, typedata);
+	nla_nest_end(msg, data);
+	nla_nest_end(msg, resp);
+	nla_nest_end(msg, peer);
+	nla_nest_end(msg, peers);
+	nla_nest_end(msg, pmsr);
+
+	return 0;
+error:
+	return -ENOSPC;
+}
+
+void cfg80211_pmsr_report(struct wireless_dev *wdev,
+			  struct cfg80211_pmsr_request *req,
+			  struct cfg80211_pmsr_result *result,
+			  gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	trace_cfg80211_pmsr_report(wdev->wiphy, wdev, req->cookie,
+				   result->addr);
+
+	/*
+	 * Currently, only variable items are LCI and civic location,
+	 * both of which are reasonably short so we don't need to
+	 * worry about them here for the allocation.
+	 */
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_PEER_MEASUREMENT_RESULT);
+	if (!hdr)
+		goto free;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD))
+		goto free;
+
+	if (nla_put_u64_64bit(msg, NL80211_ATTR_COOKIE, req->cookie,
+			      NL80211_ATTR_PAD))
+		goto free;
+
+	err = nl80211_pmsr_send_result(msg, result);
+	if (err) {
+		pr_err_ratelimited("peer measurement result: message didn't fit!");
+		goto free;
+	}
+
+	genlmsg_end(msg, hdr);
+	genlmsg_unicast(wiphy_net(wdev->wiphy), msg, req->nl_portid);
+	return;
+free:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL_GPL(cfg80211_pmsr_report);
+
+void cfg80211_pmsr_free_wk(struct work_struct *work)
+{
+	struct wireless_dev *wdev = container_of(work, struct wireless_dev,
+						 pmsr_free_wk);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct cfg80211_pmsr_request *req, *tmp;
+	LIST_HEAD(free_list);
+
+	spin_lock_bh(&wdev->pmsr_lock);
+	list_for_each_entry_safe(req, tmp, &wdev->pmsr_list, list) {
+		if (req->nl_portid)
+			continue;
+		list_move_tail(&req->list, &free_list);
+	}
+	spin_unlock_bh(&wdev->pmsr_lock);
+
+	list_for_each_entry_safe(req, tmp, &free_list, list) {
+		wdev_lock(wdev);
+		rdev_abort_pmsr(rdev, wdev, req);
+		wdev_unlock(wdev);
+
+		kfree(req);
+	}
+}
+
+void cfg80211_pmsr_free_wdev(struct wireless_dev *wdev)
+{
+	struct cfg80211_pmsr_request *req;
+	bool found = false;
+
+	spin_lock_bh(&wdev->pmsr_lock);
+	list_for_each_entry(req, &wdev->pmsr_list, list) {
+		found = true;
+		req->nl_portid = 0;
+	}
+	spin_unlock_bh(&wdev->pmsr_lock);
+
+	if (found)
+		schedule_work(&wdev->pmsr_free_wk);
+	flush_work(&wdev->pmsr_free_wk);
+	WARN_ON(!list_empty(&wdev->pmsr_list));
+}
+
+void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid)
+{
+	struct cfg80211_pmsr_request *req;
+
+	spin_lock_bh(&wdev->pmsr_lock);
+	list_for_each_entry(req, &wdev->pmsr_list, list) {
+		if (req->nl_portid == portid) {
+			req->nl_portid = 0;
+			schedule_work(&wdev->pmsr_free_wk);
+		}
+	}
+	spin_unlock_bh(&wdev->pmsr_lock);
+}
+
+#endif /* __PMSR_H */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 51380b5c32f2..5cb48d135fab 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1247,4 +1247,29 @@ rdev_get_ftm_responder_stats(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_start_pmsr(struct cfg80211_registered_device *rdev,
+		struct wireless_dev *wdev,
+		struct cfg80211_pmsr_request *request)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_start_pmsr(&rdev->wiphy, wdev, request->cookie);
+	if (rdev->ops->start_pmsr)
+		ret = rdev->ops->start_pmsr(&rdev->wiphy, wdev, request);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void
+rdev_abort_pmsr(struct cfg80211_registered_device *rdev,
+		struct wireless_dev *wdev,
+		struct cfg80211_pmsr_request *request)
+{
+	trace_rdev_abort_pmsr(&rdev->wiphy, wdev, request->cookie);
+	if (rdev->ops->abort_pmsr)
+		rdev->ops->abort_pmsr(&rdev->wiphy, wdev, request);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index c6a9446b4e6b..5324a0b56b17 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -361,6 +361,24 @@ DECLARE_EVENT_CLASS(wiphy_wdev_evt,
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT, WIPHY_PR_ARG, WDEV_PR_ARG)
 );
 
+DECLARE_EVENT_CLASS(wiphy_wdev_cookie_evt,
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
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", cookie: %lld",
+		  WIPHY_PR_ARG, WDEV_PR_ARG,
+		  (unsigned long long)__entry->cookie)
+);
+
 DEFINE_EVENT(wiphy_wdev_evt, rdev_return_wdev,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev),
 	TP_ARGS(wiphy, wdev)
@@ -2502,6 +2520,16 @@ TRACE_EVENT(rdev_get_ftm_responder_stats,
 		__entry->out_of_window)
 );
 
+DEFINE_EVENT(wiphy_wdev_cookie_evt, rdev_start_pmsr,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, u64 cookie),
+	TP_ARGS(wiphy, wdev, cookie)
+);
+
+DEFINE_EVENT(wiphy_wdev_cookie_evt, rdev_abort_pmsr,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, u64 cookie),
+	TP_ARGS(wiphy, wdev, cookie)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
@@ -3294,6 +3322,46 @@ TRACE_EVENT(cfg80211_stop_iface,
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
+
+TRACE_EVENT(cfg80211_pmsr_report,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u64 cookie, const u8 *addr),
+	TP_ARGS(wiphy, wdev, cookie, addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u64, cookie)
+		MAC_ENTRY(addr)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+		MAC_ASSIGN(addr, addr);
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", cookie:%lld, " MAC_PR_FMT,
+		  WIPHY_PR_ARG, WDEV_PR_ARG,
+		  (unsigned long long)__entry->cookie,
+		  MAC_PR_ARG(addr))
+);
+
+TRACE_EVENT(cfg80211_pmsr_complete,
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
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", cookie:%lld",
+		  WIPHY_PR_ARG, WDEV_PR_ARG,
+		  (unsigned long long)__entry->cookie)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.14.4

