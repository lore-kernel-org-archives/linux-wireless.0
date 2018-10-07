Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390D7C65C1B
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 19:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3622086D
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 19:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Is9xtHpf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mbhta0Bh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE3622086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbeJHCsa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 22:48:30 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39682 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbeJHCs3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 22:48:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 931B060B1E; Sun,  7 Oct 2018 19:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538941206;
        bh=ZkNutn66ejwDDT4bay/x1MtidTCPeXuolOsIjmCOsp8=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=Is9xtHpfZJONv2XjvWgeN82bRPj0LP05hoZNtqVpuud5TNP6g/ok5OBdo99HnGPk9
         nK1C7hm7gUZ9CS9eCs9VUQo1uvD1b4N/zMjAUvntx6N4u8lTos5Quqef1sD2e4FvSo
         dbTdsx4FksVMt2LV1wBlw7NwcynJ5mXElwykVRbU=
Received: from [192.168.66.8] (bzq-109-65-87-249.red.bezeqint.net [109.65.87.249])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: liord@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D40F2601A1;
        Sun,  7 Oct 2018 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538941199;
        bh=ZkNutn66ejwDDT4bay/x1MtidTCPeXuolOsIjmCOsp8=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=Mbhta0Bh28s9HqNsm/sbT3bDV3kNbwISU2bzgH6XA0rGfFo2CsyRJ66RBXZcaGmMQ
         BB3ENzydWcqxx2U5w9iwvjzF9XhMhjY/ltNKwr5eYH9NLJOS6aHsDz+OkukB9vxyIx
         ht3R4komwkOk0zTYvUOn1TTKnV8e7IxEOkWOmduY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D40F2601A1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=liord@codeaurora.org
From:   Lior David <liord@codeaurora.org>
Subject: Re: [RFC v2] cfg80211: add peer measurement with FTM API
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
References: <20181001133511.25046-1-johannes@sipsolutions.net>
Message-ID: <b72e2702-64dd-4ac9-89a4-6fd4d03363ed@codeaurora.org>
Date:   Sun, 7 Oct 2018 22:39:54 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181001133511.25046-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

On 10/1/2018 4:35 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add a new "peer measurement" API, that can be used to measure
> certain things related to a peer. Right now, only implement
> FTM (flight time measurement) over it, but the idea is that
> it'll be extensible to also support measuring the necessary
> things to calculate e.g. angle-of-arrival for WiGig.
> 
It's good that you started with FTM only, we are still not sure about how
to best support AoA measurement, so better add it as a future patch.

> The API is structured to have a generic list of peers and
> channels to measure with/on, and then for each of those a
> set of measurements (again, only FTM right now) to perform.
> 
> Results availability is multicast on a new "peer-measurement"
> multicast group, and results can be retrieved by dumping the
> data given the measurement cookie. Note that dumping it from
> the netlink socket that started the measurement will delete
> data, to allow not hanging on to measurement data forever when
> the measurement is long-running and only updates periodically.
> 
Just curious, what's the advantage of this compared to sending the reply only on
the socket that started the measurement?

> Similarly, closing the controlling netlink socket will abort
> a running measurement automatically.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/cfg80211.h       | 243 ++++++++++++++++
>  include/uapi/linux/nl80211.h | 411 ++++++++++++++++++++++++++
>  net/wireless/Makefile        |   1 +
>  net/wireless/core.c          |  33 +++
>  net/wireless/core.h          |   4 +
>  net/wireless/nl80211.c       | 202 ++++++++++---
>  net/wireless/nl80211.h       |  42 +++
>  net/wireless/pmsr.c          | 678 +++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/rdev-ops.h      |  25 ++
>  net/wireless/trace.h         |  70 +++++
>  10 files changed, 1675 insertions(+), 34 deletions(-)
>  create mode 100644 net/wireless/pmsr.c
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 8f5ee2c2da04..f9d4872e5123 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2841,6 +2841,178 @@ struct cfg80211_ftm_responder_stats {
>  	u32 out_of_window_triggers_num;
>  };
>  
> +/**
> + * struct cfg80211_pmsr_ftm_result - FTM result
> + * @failure_reason: if this measurement failed (PMSR status is
> + *	%NL80211_PMSR_STATUS_FAILURE), this gives a more precise
> + *	reason than just "failure"
> + * @burst_index: if reporting partial results, this is the index
> + *	in [0 .. num_bursts-1] of the burst that's being reported
> + * @num_ftmr_attempts: number of FTM request frames transmitted
> + * @num_ftmr_successes: number of FTM request frames acked
> + * @busy_retry_time: if failure_reason is %NL80211_PMSR_FTM_FAILURE_PEER_BUSY,
> + *	fill this to indicate in how many seconds a retry is deemed possible
> + *	by the responder
> + * @num_bursts_exp: actual number of bursts exponent negotiated
> + * @burst_duration: actual burst duration negotiated
> + * @frames_per_burst: actual frames per burst negotiated
> + * @lci_len: length of LCI information (if present)
> + * @civicloc_len: length of civic location information (if present)
Consider naming lcr (location civic report) instead of civicloc (this is what we
used in our QCA vendor API)

> + * @lci: LCI data (may be %NULL)
> + * @civicloc: civic location data (may be %NULL)
> + * @rssi_avg: average RSSI over FTM action frames reported
> + * @rssi_spread: spread of the RSSI over FTM action frames reported
> + * @tx_rate: bitrate for transmitted FTM action frame response
> + * @rx_rate: bitrate of received FTM action frame
> + * @rtt_avg: average of RTTs measured (must have either this or @dist_avg)
> + * @rtt_variance: variance of RTTs measured (note that standard deviation is
> + *	the square root of the variance)
> + * @rtt_spread: spread of the RTTs measured
> + * @dist_avg: average of distances (mm) measured
> + *	(must have either this or @rtt_avg)
> + * @dist_variance: variance of distances measured (see also @rtt_variance)
> + * @dist_spread: spread of distances measured (see also @rtt_spread)
For debugging it might be useful to report the distance in each measurement, and
also the raw T1-T4 values. Having T1-T4 in user space also allow running clock
drift correction algorithm, if only final value is reported the FW/driver should
probably perform the correction. Anyhow guess this can be added in the future.
Also, Wigig chip has multiple antennas in a single array each covering a sector,
and WiFi may have multiple antenna arrays where one or more will be used for
measurement, this means we may provide low-accuracy AoA result - at minimum this
may tell you on which side of the AP you are... Consider adding this as optional
reporting, not critical for initial patch...

> + * @num_ftmr_attempts_valid: @num_ftmr_attempts is valid
> + * @num_ftmr_successes_valid: @num_ftmr_successes is valid
> + * @rssi_avg_valid: @rssi_avg is valid
> + * @rssi_spread_valid: @rssi_spread is valid
> + * @tx_rate_valid: @tx_rate is valid
> + * @rx_rate_valid: @rx_rate is valid
> + * @rtt_avg_valid: @rtt_avg is valid
> + * @rtt_variance_valid: @rtt_variance is valid
> + * @rtt_spread_valid: @rtt_spread is valid
> + * @dist_avg_valid: @dist_avg is valid
> + * @dist_variance_valid: @dist_variance is valid
> + * @dist_spread_valid: @dist_spread is valid
> + */
> +struct cfg80211_pmsr_ftm_result {
> +	const u8 *lci;
> +	const u8 *civicloc;
> +	unsigned int lci_len;
> +	unsigned int civicloc_len;
> +	enum nl80211_peer_measurement_ftm_failure_reasons failure_reason;
> +	u32 num_ftmr_attempts, num_ftmr_successes;
> +	s16 burst_index;
> +	u8 busy_retry_time;
> +	u8 num_bursts_exp;
> +	u8 burst_duration;
> +	u8 frames_per_burst;
> +	s32 rssi_avg;
> +	s32 rssi_spread;
> +	struct rate_info tx_rate, rx_rate;
> +	s64 rtt_avg;
> +	s64 rtt_variance;
> +	s64 rtt_spread;
> +	s64 dist_avg;
> +	s64 dist_variance;
> +	s64 dist_spread;
> +
> +	u16 num_ftmr_attempts_valid:1,
> +	    num_ftmr_successes_valid:1,
> +	    rssi_avg_valid:1,
> +	    rssi_spread_valid:1,
> +	    tx_rate_valid:1,
> +	    rx_rate_valid:1,
> +	    rtt_avg_valid:1,
> +	    rtt_variance_valid:1,
> +	    rtt_spread_valid:1,
> +	    dist_avg_valid:1,
> +	    dist_variance_valid:1,
> +	    dist_spread_valid:1;
> +};
> +
> +/**
> + * struct cfg80211_pmsr_result - peer measurement result
> + * @list: internal list for keeping results
> + * @addr: address of the peer
> + * @host_time: host time (use ktime_get_boottime() adjust to the time when the
> + *	measurement was made)
> + * @ap_tsf: AP's TSF at measurement time
> + * @status: status of the measurement
> + * @partial: indicates that this is a partial result for this type
Is partial set to false for the last result of this measurement type? This may
be useful, for example if requesting multiple measurement types, user space can
start processing one measurement type before the entire session is completed.

> + * @ap_tsf_valid: indicates the @ap_tsf value is valid
> + * @type: type of the measurement reported, note that we only support reporting
> + *	one type at a time, but you can report multiple results separately and
> + *	they're all aggregated for userspace.
> + */
> +struct cfg80211_pmsr_result {
> +	struct list_head list;
> +
> +	u64 host_time, ap_tsf;
> +	enum nl80211_peer_measurement_status status;
> +
> +	u8 addr[ETH_ALEN];
> +
> +	u8 partial:1,
> +	   ap_tsf_valid:1;
> +
> +	enum nl80211_peer_measurement_type type;
> +
> +	union {
> +		struct cfg80211_pmsr_ftm_result ftm;
> +	};
> +};
> +
> +/**
> + * struct cfg80211_pmsr_request_peer - peer data for a peer measurement request
> + * @addr: MAC address
> + * @chandef: channel to use
For connected station, usually you will want to do the measurement on the
connected channel (possibly some chips will not be able to do otherwise)
Maybe add option to use default channel?

> + * @report_ap_tsf: report the associated AP's TSF
> + * @ftm: FTM data, see in particular @ftm.requested
> + */
> +struct cfg80211_pmsr_request_peer {
> +	u8 addr[ETH_ALEN];
> +	struct cfg80211_chan_def chandef;
> +	bool report_ap_tsf;
> +	struct {
> +		enum nl80211_preamble preamble;
> +		u16 burst_period;
> +		bool requested;
Maybe "requested" should be the first field? it is common for all measurement
structures? Also maybe make this a separate structure, as we add measurement
types the generic structure will get quite large...

> +		bool asap;
> +		u8 num_bursts_exp;
> +		u8 burst_duration;
> +		u8 frames_per_burst;
> +		u8 ftmr_retries;
> +		bool request_lci;
> +		bool request_civicloc;
> +	} ftm;
> +};
> +
> +/**
> + * struct cfg80211_pmsr_request - peer measurement request
> + * @cookie: cookie, set by cfg80211
> + * @nl_portid: netlink portid - used by cfg80211
> + * @drv_data: driver data for this request, if required for aborting,
> + *	not otherwise freed or anything by cfg80211
> + * @complete: this request has completed
> + * @mac_addr: MAC address used for (randomised) request
> + * @mac_addr_mask: MAC address mask used for randomisation, bits that
> + *	are 0 in the mask should be randomised, bits that are 1 should
> + *	be taken from the @mac_addr
Our wil6210 driver does not support MAC randomization currently (we plan to add
this hopefully soon, needed for other features as well). This should be
optional, maybe there should be capability so user space can know if this is
supported.

> + * @list: used by cfg80211 to hold on to the request
> + * @timeout: timeout (in milliseconds) for the whole operation
> + * @n_peers: number of peers to do measurements with
> + * @peers: per-peer measurement request data
> + * @results: used by cfg80211 to store the reported results
> + */
> +struct cfg80211_pmsr_request {
> +	u64 cookie;
> +	void *drv_data;
> +	u32 n_peers;
> +	u32 nl_portid;
> +
> +	u32 timeout;
We might have a need to support continuous measurements that do not timeout,
does 0 mean no timeout?

> +	bool complete;
> +
> +	u8 mac_addr[ETH_ALEN] __aligned(2);
> +	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
> +
> +	struct list_head list;
> +	struct list_head results;
> +
> +	struct cfg80211_pmsr_request_peer peers[];
Add comment "must be last"...

> +};
> +
>  /**
>   * struct cfg80211_ops - backend description for wireless configuration
>   *
> @@ -3176,6 +3348,8 @@ struct cfg80211_ftm_responder_stats {
>   *
>   * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
>   *	Statistics should be cumulative, currently no way to reset is provided.
> + * @start_pmsr: start peer measurement (e.g. FTM)
> + * @abort_pmsr: abort peer measurement
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
> @@ -3485,6 +3659,11 @@ struct cfg80211_ops {
>  	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
>  				struct net_device *dev,
>  				struct cfg80211_ftm_responder_stats *ftm_stats);
> +
> +	int	(*start_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
> +			      struct cfg80211_pmsr_request *request);
> +	void	(*abort_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
> +			      struct cfg80211_pmsr_request *request);
>  };
>  
>  /*
> @@ -3856,6 +4035,31 @@ struct wiphy_iftype_ext_capab {
>  	u8 extended_capabilities_len;
>  };
>  
> +/**
> + * struct cfg80211_pmsr_capabilities - cfg80211 peer measurement capabilities
> + * @max_peers: maximum number of peers in a single measurement
> + * @report_ap_tsf: can report assoc AP's TSF for radio resource measurement
> + * @ftm.supported: FTM measurement is supported
> + * @ftm.asap: ASAP-mode is supported
> + * @ftm.non_asap: non-ASAP-mode is supported
> + * @ftm.request_lci: can request LCI data
> + * @ftm.request_civicloc: can request civic location data
> + * @ftm.preambles: bitmap of preambles supported (&enum nl80211_preamble)
> + * @ftm.bandwidths: bitmap of bandwidths supported (&enum nl80211_chan_width)
> + */
> +struct cfg80211_pmsr_capabilities {
> +	unsigned int max_peers;
> +	bool report_ap_tsf;
> +
> +	struct {
> +		bool supported;
> +		bool asap, non_asap;
> +		bool request_lci, request_civicloc;
> +		u32 preambles;
> +		u32 bandwidths;
> +	} ftm;
> +};
> +
>  /**
>   * struct wiphy - wireless hardware description
>   * @reg_notifier: the driver's regulatory notification callback,
> @@ -4020,6 +4224,8 @@ struct wiphy_iftype_ext_capab {
>   * @txq_limit: configuration of internal TX queue frame limit
>   * @txq_memory_limit: configuration internal TX queue memory limit
>   * @txq_quantum: configuration of internal TX queue scheduler quantum
> + *
> + * @pmsr_capa: peer measurement capabilities
>   */
>  struct wiphy {
>  	/* assign these fields before you register the wiphy */
> @@ -4156,6 +4362,8 @@ struct wiphy {
>  	u32 txq_memory_limit;
>  	u32 txq_quantum;
>  
> +	const struct cfg80211_pmsr_capabilities *pmsr_capa;
> +
>  	char priv[0] __aligned(NETDEV_ALIGN);
>  };
>  
> @@ -4358,6 +4566,9 @@ struct cfg80211_cqm_config;
>   * @owner_nlportid: (private) owner socket port ID
>   * @nl_owner_dead: (private) owner socket went away
>   * @cqm_config: (private) nl80211 RSSI monitor state
> + * @pmsr_list: (private) peer measurement requests
> + * @pmsr_lock: (private) peer measurements requests/results lock
> + * @pmsr_free_wk: (private) peer measurements cleanup work
>   */
>  struct wireless_dev {
>  	struct wiphy *wiphy;
> @@ -4429,6 +4640,10 @@ struct wireless_dev {
>  #endif
>  
>  	struct cfg80211_cqm_config *cqm_config;
> +
> +	struct list_head pmsr_list;
> +	spinlock_t pmsr_lock;
> +	struct work_struct pmsr_free_wk;
>  };
>  
>  static inline u8 *wdev_address(struct wireless_dev *wdev)
> @@ -6625,6 +6840,34 @@ int cfg80211_external_auth_request(struct net_device *netdev,
>  				   struct cfg80211_external_auth_params *params,
>  				   gfp_t gfp);
>  
> +/**
> + * cfg80211_pmsr_report - report peer measurement result data
> + * @wdev: the wireless device reporting the measurement
> + * @req: the original measurement request
> + * @result: the result data
> + * @more: indicates more data follows *immediately* (e.g. if firmware
> + *	reports many results at once), to avoid sending multiple
> + *	notifications to userspace
> + * @gfp: allocation flags
> + */
> +void cfg80211_pmsr_report(struct wireless_dev *wdev,
> +			  struct cfg80211_pmsr_request *req,
> +			  struct cfg80211_pmsr_result *result,
> +			  bool more, gfp_t gfp);
> +
> +/**
> + * cfg80211_pmsr_complete - report peer measurement completed
> + * @wdev: the wireless device reporting the measurement
> + * @req: the original measurement request
> + * @gfp: allocation flags
> + *
> + * Report that the entire measurement completed, after this
> + * the request pointer will no longer be valid.
> + */
> +void cfg80211_pmsr_complete(struct wireless_dev *wdev,
> +			    struct cfg80211_pmsr_request *req,
> +			    gfp_t gfp);
> +
>  /* Logging, debugging and troubleshooting/diagnostic helpers. */
>  
>  /* wiphy_printk helpers, similar to dev_printk */
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index dc6d5a1ef470..2e0f2357a32b 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -50,6 +50,7 @@
>  #define NL80211_MULTICAST_GROUP_MLME		"mlme"
>  #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
>  #define NL80211_MULTICAST_GROUP_NAN		"nan"
> +#define NL80211_MULTICAST_GROUP_PMSR		"peer-measurement"
>  #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
>  
>  /**
> @@ -1036,6 +1037,36 @@
>   * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
>   *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
>   *
> + * @NL80211_CMD_PEER_MEASUREMENT_START: start a (set of) peer measurement(s)
> + *	with the given parameters, which are encapsulated in the nested
> + *	%NL80211_ATTR_PEER_MEASUREMENTS attribute. Optionally, MAC address
> + *	randomization may be enabled and configured by specifying the
> + *	%NL80211_ATTR_MAC and %NL80211_ATTR_MAC_MASK attributes.
> + *	If a timeout is requested, use the %NL80211_ATTR_TIMEOUT attribute.
> + *	A u64 cookie for further %NL80211_ATTR_COOKIE use is is returned in
> + *	the netlink extended ack message.
> + *
> + *	To cancel a measurement, close the socket that requested it. This also
> + *	works to free any data left over and not yet dumped after measurements
> + *	are complete.
> + *
> + *	Depending on driver support it may or may not be possible to start
> + *	multiple concurrent measurements.
> + * @NL80211_CMD_PEER_MEASUREMENT_RESULT: This command number is used for two
> + *	purposes:
> + *	 1) notification from the driver that new (partial) measurement
> + *	    results are available
> + *	 2) with netlink dump to obtain the results
> + *	Both usage includes the measurement cookie (%NL80211_ATTR_COOKIE).
> + *
> + *	Note: When the netlink dump is invoked by the socket that originally
> + *	started the request, data that is dumped to userspace will be deleted
> + *	from the kernel. When the dump is invoked from another socket, data
> + *	will be kept.
> + * @NL80211_CMD_PEER_MEASUREMENT_COMPLETE: Notification only, indicating that
> + *	the measurement completed, using the measurement cookie
> + *	(%NL80211_ATTR_COOKIE).
> + *
>   * @NL80211_CMD_MAX: highest used command number
>   * @__NL80211_CMD_AFTER_LAST: internal use
>   */
> @@ -1250,6 +1281,10 @@ enum nl80211_commands {
>  
>  	NL80211_CMD_GET_FTM_RESPONDER_STATS,
>  
> +	NL80211_CMD_PEER_MEASUREMENT_START,
> +	NL80211_CMD_PEER_MEASUREMENT_RESULT,
> +	NL80211_CMD_PEER_MEASUREMENT_COMPLETE,
> +
>  	/* add new commands above here */
>  
>  	/* used to define NL80211_CMD_MAX below */
> @@ -2254,6 +2289,14 @@ enum nl80211_commands {
>   * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
>   *	statistics, see &enum nl80211_ftm_responder_stats.
>   *
> + * @NL80211_ATTR_TIMEOUT: Timeout for the given operation, in milliseconds (u32)
> + *
> + * @NL80211_ATTR_PEER_MEASUREMENTS: peer measurements request (and result)
> + *	data, uses nested attributes specified in
> + *	&enum nl80211_peer_measurement_attrs.
> + *	This is also used for capability advertisement in the wiphy information,
> + *	with the appropriate sub-attributes.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2699,6 +2742,10 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_FTM_RESPONDER_STATS,
>  
> +	NL80211_ATTR_TIMEOUT,
> +
> +	NL80211_ATTR_PEER_MEASUREMENTS,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -5898,4 +5945,368 @@ enum nl80211_ftm_responder_stats {
>  	NL80211_FTM_STATS_MAX = __NL80211_FTM_STATS_AFTER_LAST - 1
>  };
>  
> +/**
> + * enum nl80211_preamble - frame preamble types
> + * @NL80211_PREAMBLE_LEGACY: legacy (HR/DSSS, OFDM, ERP PHY) preamble
> + * @NL80211_PREAMBLE_HT: HT preamble
> + * @NL80211_PREAMBLE_VHT: VHT preamble
> + * @NL80211_PREAMBLE_DMG: DMG preamble
> + */
> +enum nl80211_preamble {
> +	NL80211_PREAMBLE_LEGACY,
> +	NL80211_PREAMBLE_HT,
> +	NL80211_PREAMBLE_VHT,
> +	NL80211_PREAMBLE_DMG,
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_type - peer measurement types
> + * @NL80211_PMSR_TYPE_INVALID: invalid/unused, needed as we use
> + *	these numbers also for attributes
> + *
> + * @NL80211_PMSR_TYPE_FTM: flight time measurement
> + *
> + * @NUM_NL80211_PMSR_TYPES: internal
> + * @NL80211_PMSR_TYPE_MAX: highest type number
> + */
> +enum nl80211_peer_measurement_type {
> +	NL80211_PMSR_TYPE_INVALID,
> +
> +	NL80211_PMSR_TYPE_FTM,
> +
> +	NUM_NL80211_PMSR_TYPES,
> +	NL80211_PMSR_TYPE_MAX = NUM_NL80211_PMSR_TYPES - 1
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_status - peer measurement status
> + * @NL80211_PMSR_STATUS_SUCCESS: measurement completed successfully
> + * @NL80211_PMSR_STATUS_REFUSED: measurement was locally refused
> + * @NL80211_PMSR_STATUS_TIMEOUT: measurement timed out
> + * @NL80211_PMSR_STATUS_FAILURE: measurement failed, a type-dependent
> + *	reason may be available in the response data
> + */
> +enum nl80211_peer_measurement_status {
> +	NL80211_PMSR_STATUS_SUCCESS,
> +	NL80211_PMSR_STATUS_REFUSED,
> +	NL80211_PMSR_STATUS_TIMEOUT,
> +	NL80211_PMSR_STATUS_FAILURE,
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_req - peer measurement request attributes
> + * @__NL80211_PMSR_REQ_ATTR_INVALID: invalid
> + *
> + * @NL80211_PMSR_REQ_ATTR_DATA: This is a nested attribute with measurement
> + *	type-specific request data inside. The attributes used are from the
> + *	enums named nl80211_peer_measurement_<type>_req.
> + * @NL80211_PMSR_REQ_ATTR_GET_AP_TSF: include AP TSF timestamp, if supported
> + *	(flag attribute)
> + *
> + * @NUM_NL80211_PMSR_REQ_ATTRS: internal
> + * @NL80211_PMSR_REQ_ATTR_MAX: highest attribute number
> + */
> +enum nl80211_peer_measurement_req {
> +	__NL80211_PMSR_REQ_ATTR_INVALID,
> +
> +	NL80211_PMSR_REQ_ATTR_DATA,
> +	NL80211_PMSR_REQ_ATTR_GET_AP_TSF,
> +
> +	/* keep last */
> +	NUM_NL80211_PMSR_REQ_ATTRS,
> +	NL80211_PMSR_REQ_ATTR_MAX = NUM_NL80211_PMSR_REQ_ATTRS - 1
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_resp - peer measurement response attributes
> + * @__NL80211_PMSR_RESP_ATTR_INVALID: invalid
> + *
> + * @NL80211_PMSR_RESP_ATTR_DATA: This is a nested attribute with measurement
> + *	type-specific results inside. The attributes used are from the enums
> + *	named nl80211_peer_measurement_<type>_resp.
> + * @NL80211_PMSR_RESP_ATTR_STATUS: u32 value with the measurement status
> + *	(using values from &enum nl80211_peer_measurement_status.)
> + * @NL80211_PMSR_RESP_ATTR_HOST_TIME: host time (%CLOCK_BOOTTIME) when the
> + *	result was measured; this value is not expected to be accurate to
> + *	more than 20ms. (u64, nanoseconds)
> + * @NL80211_PMSR_RESP_ATTR_AP_TSF: TSF of the AP that the interface
> + *	doing the measurement is connected to when the result was measured.
> + *	This shall be accurately reported if supported and requested
> + *	(u64, usec)
> + * @NL80211_PMSR_RESP_ATTR_PARTIAL: This is a partial result, e.g. when
> + *	multiple FTM bursts are reported separately this will be set in
> + *	all report entries.
> + * @NL80211_PMSR_RESP_ATTR_PAD: padding for 64-bit attributes, ignore
> + *
> + * @NUM_NL80211_PMSR_RESP_ATTRS: internal
> + * @NL80211_PMSR_RESP_ATTR_MAX: highest attribute number
> + */
> +enum nl80211_peer_measurement_resp {
> +	__NL80211_PMSR_RESP_ATTR_INVALID,
> +
> +	NL80211_PMSR_RESP_ATTR_DATA,
> +	NL80211_PMSR_RESP_ATTR_STATUS,
> +	NL80211_PMSR_RESP_ATTR_HOST_TIME,
> +	NL80211_PMSR_RESP_ATTR_AP_TSF,
> +	NL80211_PMSR_RESP_ATTR_PARTIAL,
> +	NL80211_PMSR_RESP_ATTR_PAD,
> +
> +	/* keep last */
> +	NUM_NL80211_PMSR_RESP_ATTRS,
> +	NL80211_PMSR_RESP_ATTR_MAX = NUM_NL80211_PMSR_RESP_ATTRS - 1
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_peer_attrs - peer attributes for measurement
> + * @__NL80211_PMSR_PEER_ATTR_INVALID: invalid
> + *
> + * @NL80211_PMSR_PEER_ATTR_ADDR: peer's MAC address
> + * @NL80211_PMSR_PEER_ATTR_CHAN: channel definition, nested, using top-level
> + *	attributes like %NL80211_ATTR_WIPHY_FREQ etc.
> + * @NL80211_PMSR_PEER_ATTR_REQ: This is a nested attribute indexed by
> + *	measurement type, with attributes from the
> + *	&enum nl80211_peer_measurement_req inside.
> + * @NL80211_PMSR_PEER_ATTR_RESP: This is a nested attribute indexed by
> + *	measurement type, with attributes from the
> + *	&enum nl80211_peer_measurement_resp inside.
> + *
> + * @NUM_NL80211_PMSR_PEER_ATTRS: internal
> + * @NL80211_PMSR_PEER_ATTR_MAX: highest attribute number
> + */
> +enum nl80211_peer_measurement_peer_attrs {
> +	__NL80211_PMSR_PEER_ATTR_INVALID,
> +
> +	NL80211_PMSR_PEER_ATTR_ADDR,
> +	NL80211_PMSR_PEER_ATTR_CHAN,
> +	NL80211_PMSR_PEER_ATTR_REQ,
> +	NL80211_PMSR_PEER_ATTR_RESP,
> +
> +	/* keep last */
> +	NUM_NL80211_PMSR_PEER_ATTRS,
> +	NL80211_PMSR_PEER_ATTR_MAX = NUM_NL80211_PMSR_PEER_ATTRS - 1,
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_attrs - peer measurement attributes
> + * @__NL80211_PMSR_ATTR_INVALID: invalid
> + *
> + * @NL80211_PMSR_ATTR_MAX_PEERS: u32 attribute used for capability
> + *	advertisement only, indicates the maximum number of peers
> + *	measurements can be done with in a single request
> + * @NL80211_PMSR_ATTR_REPORT_AP_TSF: flag attribute (in capability)
> + *	indicating that the connected AP's TSF can be reported in
> + *	measurement results
> + * @NL80211_PMSR_ATTR_TYPE_CAPA: capabilities reported by the device,
> + *	this contains a nesting indexed by measurement type, and
> + *	type-specific capabilities inside, which are from the enums
> + *	named nl80211_peer_measurement_<type>_capa.
> + * @NL80211_PMSR_ATTR_PEERS: nested attribute, the nesting index is
> + *	meaningless, just a list of peers to measure with, with the
> + *	sub-attributes taken from
> + *	&enum nl80211_peer_measurement_peer_attrs.
> + *
> + * @NUM_NL80211_PMSR_ATTR: internal
> + * @NL80211_PMSR_ATTR_MAX: highest attribute number
> + */
> +enum nl80211_peer_measurement_attrs {
> +	__NL80211_PMSR_ATTR_INVALID,
> +
> +	NL80211_PMSR_ATTR_MAX_PEERS,
> +	NL80211_PMSR_ATTR_REPORT_AP_TSF,
> +	NL80211_PMSR_ATTR_TYPE_CAPA,
> +	NL80211_PMSR_ATTR_PEERS,
> +
> +	/* keep last */
> +	NUM_NL80211_PMSR_ATTR,
> +	NL80211_PMSR_ATTR_MAX = NUM_NL80211_PMSR_ATTR - 1
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_ftm_capa - FTM capabilities
> + * @__NL80211_PMSR_FTM_CAPA_ATTR_INVALID: invalid
> + *
> + * @NL80211_PMSR_FTM_CAPA_ATTR_ASAP: flag attribute indicating ASAP mode
> + *	is supported
> + * @NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP: flag attribute indicating non-ASAP
> + *	mode is supported
> + * @NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI: flag attribute indicating if LCI
> + *	data can be requested during the measurement
> + * @NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC: flag attribute indicating if civic
> + *	location data can be requested during the measurement
> + * @NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES: u32 bitmap attribute of bits
> + *	from &enum nl80211_preamble.
> + * @NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS: bitmap of values from
> + *	&enum nl80211_chan_width indicating the supported channel
> + *	bandwidths for FTM. Note that a higher channel bandwidth may be
> + *	configured to allow for other measurements types with different
> + *	bandwidth requirement in the same measurement.
> + *
> + * @NUM_NL80211_PMSR_FTM_CAPA_ATTR: internal
> + * @NL80211_PMSR_FTM_CAPA_ATTR_MAX: highest attribute number
> + */
> +enum nl80211_peer_measurement_ftm_capa {
> +	__NL80211_PMSR_FTM_CAPA_ATTR_INVALID,
> +
> +	NL80211_PMSR_FTM_CAPA_ATTR_ASAP,
> +	NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP,
> +	NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI,
> +	NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC,
> +	NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES,
> +	NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS,
> +
> +	/* keep last */
> +	NUM_NL80211_PMSR_FTM_CAPA_ATTR,
> +	NL80211_PMSR_FTM_CAPA_ATTR_MAX = NUM_NL80211_PMSR_FTM_CAPA_ATTR - 1
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_ftm_req - FTM request attributes
> + * @__NL80211_PMSR_FTM_REQ_ATTR_INVALID: invalid
> + *
> + * @NL80211_PMSR_FTM_REQ_ATTR_ASAP: ASAP mode requested (flag)
> + * @NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE: preamble type (see
> + *	&enum nl80211_preamble), optional for DMG (u32)
> + * @NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP: number of bursts exponent as in
> + *	802.11-2016 9.4.2.168 "Fine Timing Measurement Parameters element"
> + *	(u8, 0-15, optional with default 15 i.e. "no preference")
> + * @NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD: interval between bursts in units
> + *	of 100ms (u16, optional with default 0)
> + * @NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION: burst duration, as in 802.11-2016
> + *	Table 9-257 "Burst Duration field encoding" (u8, 0-15, optional with
> + *	default 15 i.e. "no preference")
> + * @NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST: number of successful FTM frames
> + *	requested per burst
> + *	(u8, 0-31, optional with default 0 i.e. "no preference")
> + * @NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES: number of FTMR frame retries
> + *	(u8, default 3)
> + * @NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI: request LCI data (flag)
> + * @NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC: request civic location data (flag)
> + *
> + * @NUM_NL80211_PMSR_FTM_REQ_ATTR: internal
> + * @NL80211_PMSR_FTM_REQ_ATTR_MAX: highest attribute number
> + */
> +enum nl80211_peer_measurement_ftm_req {
> +	__NL80211_PMSR_FTM_REQ_ATTR_INVALID,
> +
> +	NL80211_PMSR_FTM_REQ_ATTR_ASAP,
> +	NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE,
> +	NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP,
> +	NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD,
> +	NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION,
> +	NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST,
> +	NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES,
> +	NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI,
> +	NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC,
> +
> +	/* keep last */
> +	NUM_NL80211_PMSR_FTM_REQ_ATTR,
> +	NL80211_PMSR_FTM_REQ_ATTR_MAX = NUM_NL80211_PMSR_FTM_REQ_ATTR - 1
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_ftm_failure_reasons - FTM failure reasons
> + * @NL80211_PMSR_FTM_FAILURE_UNSPECIFIED: unspecified failure, not used
> + * @NL80211_PMSR_FTM_FAILURE_NO_RESPONSE: no response from the FTM responder
> + * @NL80211_PMSR_FTM_FAILURE_REJECTED: FTM responder rejected measurement
> + * @NL80211_PMSR_FTM_FAILURE_WRONG_CHANNEL: we already know the peer is
> + *	on a different channel, so can't measure (if we didn't know, we'd
> + *	try and get no response)
> + * @NL80211_PMSR_FTM_FAILURE_PEER_NOT_CAPABLE: peer can't actually do FTM
> + * @NL80211_PMSR_FTM_FAILURE_INVALID_TIMESTAMP: invalid T1/T4 timestamps
> + *	received
> + * @NL80211_PMSR_FTM_FAILURE_PEER_BUSY: peer reports busy, you may retry
> + *	later (see %NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME)
> + * @NL80211_PMSR_FTM_FAILURE_BAD_CHANGED_PARAMS: parameters were changed
> + *	by the peer and are no longer supported
> + */
> +enum nl80211_peer_measurement_ftm_failure_reasons {
> +	NL80211_PMSR_FTM_FAILURE_UNSPECIFIED,
> +	NL80211_PMSR_FTM_FAILURE_NO_RESPONSE,
> +	NL80211_PMSR_FTM_FAILURE_REJECTED,
> +	NL80211_PMSR_FTM_FAILURE_WRONG_CHANNEL,
> +	NL80211_PMSR_FTM_FAILURE_PEER_NOT_CAPABLE,
> +	NL80211_PMSR_FTM_FAILURE_INVALID_TIMESTAMP,
> +	NL80211_PMSR_FTM_FAILURE_PEER_BUSY,
> +	NL80211_PMSR_FTM_FAILURE_BAD_CHANGED_PARAMS,
> +};
> +
> +/**
> + * enum nl80211_peer_measurement_ftm_resp - FTM response attributes
> + * @__NL80211_PMSR_FTM_RESP_ATTR_INVALID: invalid
> + *
> + * @NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON: FTM-specific failure reason
> + *	(u32, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX: optional, if bursts are reported
> + *	as separate results then it will be the burst index 0...(N-1) and
> + *	the top level will indicate partial results (u32)
> + * @NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS: number of FTM Request frames
> + *	transmitted (u32, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES: number of FTM Request frames
> + *	that were acknowleged (u32, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME: retry time received from the
> + *	busy peer (u32, seconds)
> + * @NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP: actual number of bursts exponent
> + *	used by the responder (similar to request, u8)
> + * @NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION: actual burst duration used by
> + *	the responder (similar to request, u8)
> + * @NL80211_PMSR_FTM_RESP_ATTR_FRAMES_PER_BURST: actual frames per burst used
> + *	by the responder (similar to request, u8)
> + * @NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG: average RSSI across all FTM action
> + *	frames (optional, s32, 1/2 dBm)
> + * @NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD: RSSI spread across all FTM action
> + *	frames (optional, s32, 1/2 dBm)
> + * @NL80211_PMSR_FTM_RESP_ATTR_TX_RATE: bitrate we used for the response to the
> + *	FTM action frame (optional, nested, using &enum nl80211_rate_info
> + *	attributes)
> + * @NL80211_PMSR_FTM_RESP_ATTR_RX_RATE: bitrate the responder used for the FTM
> + *	action frame (optional, nested, using &enum nl80211_rate_info attrs)
> + * @NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG: average RTT (s64, picoseconds, optional
> + *	but one of RTT/DIST must be present)
> + * @NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE: RTT variance (u64, ps^2, note that
> + *	standard deviation is the square root of variance, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD: RTT spread (u64, picoseconds,
> + *	optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG: average distance (s64, mm, optional
> + *	but one of RTT/DIST must be present)
> + * @NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE: distance variance (u64, mm^2, note
> + *	that standard deviation is the square root of variance, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD: distance spread (u64, mm, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_LCI: LCI data from peer (binary, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC: civic location data from peer
> + *	(binary, optional)
> + * @NL80211_PMSR_FTM_RESP_ATTR_PAD: ignore, for u64/s64 padding only
> + *
> + * @NUM_NL80211_PMSR_FTM_RESP_ATTR: internal
> + * @NL80211_PMSR_FTM_RESP_ATTR_MAX: highest attribute number
> + */
> +enum nl80211_peer_measurement_ftm_resp {
> +	__NL80211_PMSR_FTM_RESP_ATTR_INVALID,
> +
> +	NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON,
> +	NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX,
> +	NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS,
> +	NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES,
> +	NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME,
> +	NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP,
> +	NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION,
> +	NL80211_PMSR_FTM_RESP_ATTR_FRAMES_PER_BURST,
> +	NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG,
> +	NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD,
> +	NL80211_PMSR_FTM_RESP_ATTR_TX_RATE,
> +	NL80211_PMSR_FTM_RESP_ATTR_RX_RATE,
> +	NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG,
> +	NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE,
> +	NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD,
> +	NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG,
> +	NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE,
> +	NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD,
> +	NL80211_PMSR_FTM_RESP_ATTR_LCI,
> +	NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC,
> +	NL80211_PMSR_FTM_RESP_ATTR_PAD,
> +
> +	/* keep last */
> +	NUM_NL80211_PMSR_FTM_RESP_ATTR,
> +	NL80211_PMSR_FTM_RESP_ATTR_MAX = NUM_NL80211_PMSR_FTM_RESP_ATTR - 1
> +};
> +
>  #endif /* __LINUX_NL80211_H */
> diff --git a/net/wireless/Makefile b/net/wireless/Makefile
> index 1d84f91bbfb0..72a224ce8e0a 100644
> --- a/net/wireless/Makefile
> +++ b/net/wireless/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
>  
>  cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
>  cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o ocb.o
> +cfg80211-y += pmsr.o
>  cfg80211-$(CONFIG_OF) += of.o
>  cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
>  cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 5bd01058b9e6..677493dbfbf2 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -664,6 +664,34 @@ int wiphy_register(struct wiphy *wiphy)
>  		return -EINVAL;
>  #endif
>  
> +	if (WARN_ON(wiphy->pmsr_capa && !wiphy->pmsr_capa->ftm.supported))
> +		return -EINVAL;
> +
> +	if (wiphy->pmsr_capa && wiphy->pmsr_capa->ftm.supported) {
> +		if (WARN_ON(!wiphy->pmsr_capa->ftm.asap &&
> +			    !wiphy->pmsr_capa->ftm.non_asap))
> +			return -EINVAL;
> +		if (WARN_ON(!wiphy->pmsr_capa->ftm.preambles ||
> +			    !wiphy->pmsr_capa->ftm.bandwidths))
> +			return -EINVAL;
> +		if (WARN_ON(wiphy->pmsr_capa->ftm.preambles &
> +				~(BIT(NL80211_PREAMBLE_LEGACY) |
> +				  BIT(NL80211_PREAMBLE_HT) |
> +				  BIT(NL80211_PREAMBLE_VHT) |
> +				  BIT(NL80211_PREAMBLE_DMG))))
> +			return -EINVAL;
> +		if (WARN_ON(wiphy->pmsr_capa->ftm.bandwidths &
> +				~(BIT(NL80211_CHAN_WIDTH_20_NOHT) |
> +				  BIT(NL80211_CHAN_WIDTH_20) |
> +				  BIT(NL80211_CHAN_WIDTH_40) |
> +				  BIT(NL80211_CHAN_WIDTH_80) |
> +				  BIT(NL80211_CHAN_WIDTH_80P80) |
> +				  BIT(NL80211_CHAN_WIDTH_160) |
> +				  BIT(NL80211_CHAN_WIDTH_5) |
> +				  BIT(NL80211_CHAN_WIDTH_10))))
What should Wigig report here? it uses 2160Hz channel width. Maybe we need to
add additional width constant in separate patch, something like
NL80211_CHAN_WIDTH_2160_DMG

> +			return -EINVAL;
> +	}
> +
>  	/*
>  	 * if a wiphy has unsupported modes for regulatory channel enforcement,
>  	 * opt-out of enforcement checking
> @@ -1053,6 +1081,8 @@ static void __cfg80211_unregister_wdev(struct wireless_dev *wdev, bool sync)
>  		flush_work(&wdev->disconnect_wk);
>  
>  	cfg80211_cqm_config_free(wdev);
> +
> +	cfg80211_pmsr_free_wdev(wdev);
>  }
>  
>  void cfg80211_unregister_wdev(struct wireless_dev *wdev)
> @@ -1174,6 +1204,9 @@ void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
>  	spin_lock_init(&wdev->event_lock);
>  	INIT_LIST_HEAD(&wdev->mgmt_registrations);
>  	spin_lock_init(&wdev->mgmt_registrations_lock);
> +	INIT_LIST_HEAD(&wdev->pmsr_list);
> +	spin_lock_init(&wdev->pmsr_lock);
> +	INIT_WORK(&wdev->pmsr_free_wk, cfg80211_pmsr_free_wk);
>  
>  	/*
>  	 * We get here also when the interface changes network namespaces,
> diff --git a/net/wireless/core.h b/net/wireless/core.h
> index c61dbba8bf47..3f82d0ebb46b 100644
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -530,4 +530,8 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
>  
>  void cfg80211_cqm_config_free(struct wireless_dev *wdev);
>  
> +void cfg80211_release_pmsr(struct wireless_dev *wdev, u32 portid);
> +void cfg80211_pmsr_free_wdev(struct wireless_dev *wdev);
> +void cfg80211_pmsr_free_wk(struct work_struct *work);
> +
>  #endif /* __NET_WIRELESS_CORE_H */
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 36e26ac20638..7163cbc91ef3 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -34,20 +34,6 @@ static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
>  				   struct cfg80211_crypto_settings *settings,
>  				   int cipher_limit);
>  
> -/* the netlink family */
> -static struct genl_family nl80211_fam;
> -
> -/* multicast groups */
> -enum nl80211_multicast_groups {
> -	NL80211_MCGRP_CONFIG,
> -	NL80211_MCGRP_SCAN,
> -	NL80211_MCGRP_REGULATORY,
> -	NL80211_MCGRP_MLME,
> -	NL80211_MCGRP_VENDOR,
> -	NL80211_MCGRP_NAN,
> -	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
> -};
> -
>  static const struct genl_multicast_group nl80211_mcgrps[] = {
>  	[NL80211_MCGRP_CONFIG] = { .name = NL80211_MULTICAST_GROUP_CONFIG },
>  	[NL80211_MCGRP_SCAN] = { .name = NL80211_MULTICAST_GROUP_SCAN },
> @@ -55,6 +41,7 @@ static const struct genl_multicast_group nl80211_mcgrps[] = {
>  	[NL80211_MCGRP_MLME] = { .name = NL80211_MULTICAST_GROUP_MLME },
>  	[NL80211_MCGRP_VENDOR] = { .name = NL80211_MULTICAST_GROUP_VENDOR },
>  	[NL80211_MCGRP_NAN] = { .name = NL80211_MULTICAST_GROUP_NAN },
> +	[NL80211_MCGRP_PMSR] = { .name = NL80211_MULTICAST_GROUP_PMSR },
>  #ifdef CONFIG_NL80211_TESTMODE
>  	[NL80211_MCGRP_TESTMODE] = { .name = NL80211_MULTICAST_GROUP_TESTMODE }
>  #endif
> @@ -240,7 +227,62 @@ nl80211_ftm_responder_policy[NL80211_FTM_RESP_ATTR_MAX + 1] = {
>  					     .len = U8_MAX },
>  };
>  
> -static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
> +static const struct nla_policy
> +nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_FTM_REQ_ATTR_ASAP] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE] = { .type = NLA_U32 },
> +	[NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP] =
> +		NLA_POLICY_MAX(NLA_U8, 15),
> +	[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD] = { .type = NLA_U16 },
> +	[NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION] =
> +		NLA_POLICY_MAX(NLA_U8, 15),
> +	[NL80211_PMSR_FTM_REQ_ATTR_FRAMES_PER_BURST] =
> +		NLA_POLICY_MAX(NLA_U8, 15),
> +	[NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES] = { .type = NLA_U8 },
> +	[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI] = { .type = NLA_FLAG },
> +	[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC] = { .type = NLA_FLAG },
> +};
> +
> +static const struct nla_policy
> +nl80211_pmsr_req_data_policy[NL80211_PMSR_TYPE_MAX + 1] = {
> +	[NL80211_PMSR_TYPE_FTM] =
> +		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
> +				  nl80211_pmsr_ftm_req_attr_policy),
> +};
> +
> +static const struct nla_policy
> +nl80211_pmsr_req_attr_policy[NL80211_PMSR_REQ_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_REQ_ATTR_DATA] =
> +		NLA_POLICY_NESTED(NL80211_PMSR_TYPE_MAX,
> +				  nl80211_pmsr_req_data_policy),
> +	[NL80211_PMSR_REQ_ATTR_GET_AP_TSF] = { .type = NLA_FLAG },
> +};
> +
> +static const struct nla_policy
> +nl80211_psmr_peer_attr_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_PEER_ATTR_ADDR] = NLA_POLICY_ETH_ADDR,
> +	/*
> +	 * we could specify this again to be the top-level policy,
> +	 * but that would open us up to recursion problems ...
> +	 */
> +	[NL80211_PMSR_PEER_ATTR_CHAN] = { .type = NLA_NESTED },
> +	[NL80211_PMSR_PEER_ATTR_REQ] =
> +		NLA_POLICY_NESTED(NL80211_PMSR_REQ_ATTR_MAX,
> +				  nl80211_pmsr_req_attr_policy),
> +	[NL80211_PMSR_PEER_ATTR_RESP] = { .type = NLA_REJECT },
> +};
> +
> +static const struct nla_policy
> +nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
> +	[NL80211_PMSR_ATTR_MAX_PEERS] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_REPORT_AP_TSF] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_TYPE_CAPA] = { .type = NLA_REJECT },
> +	[NL80211_PMSR_ATTR_PEERS] =
> +		NLA_POLICY_NESTED_ARRAY(NL80211_PMSR_PEER_ATTR_MAX,
> +					nl80211_psmr_peer_attr_policy),
> +};
> +
> +const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>  	[NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
>  	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
>  				      .len = 20-1 },
> @@ -497,6 +539,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>  		.type = NLA_NESTED,
>  		.validation_data = nl80211_ftm_responder_policy,
>  	},
> +	[NL80211_ATTR_TIMEOUT] = { .type = NLA_U32 },
> +	[NL80211_ATTR_PEER_MEASUREMENTS] =
> +		NLA_POLICY_NESTED(NL80211_PMSR_FTM_REQ_ATTR_MAX,
> +				  nl80211_pmsr_attr_policy),
>  };
>  
>  /* policy for the key attributes */
> @@ -637,9 +683,9 @@ nl80211_packet_pattern_policy[MAX_NL80211_PKTPAT + 1] = {
>  	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
>  };
>  
> -static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
> -				     struct cfg80211_registered_device **rdev,
> -				     struct wireless_dev **wdev)
> +int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
> +			      struct cfg80211_registered_device **rdev,
> +			      struct wireless_dev **wdev)
>  {
>  	int err;
>  
> @@ -684,8 +730,8 @@ static int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
>  }
>  
>  /* message building helper */
> -static inline void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
> -				   int flags, u8 cmd)
> +void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
> +		     int flags, u8 cmd)
>  {
>  	/* since there is no private header just add the generic one */
>  	return genlmsg_put(skb, portid, seq, &nl80211_fam, flags, cmd);
> @@ -1615,6 +1661,79 @@ static int nl80211_add_commands_unsplit(struct cfg80211_registered_device *rdev,
>  	return -ENOBUFS;
>  }
>  
> +static int
> +nl80211_send_pmsr_ftm_capa(const struct cfg80211_pmsr_capabilities *cap,
> +			   struct sk_buff *msg)
> +{
> +	struct nlattr *ftm;
> +
> +	if (!cap->ftm.supported)
> +		return 0;
> +
> +	ftm = nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> +	if (!ftm)
> +		return -ENOBUFS;
> +
> +	if (cap->ftm.asap && nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_ASAP))
> +		return -ENOBUFS;
> +	if (cap->ftm.non_asap &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP))
> +		return -ENOBUFS;
> +	if (cap->ftm.request_lci &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI))
> +		return -ENOBUFS;
> +	if (cap->ftm.request_civicloc &&
> +	    nla_put_flag(msg, NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC))
> +		return -ENOBUFS;
> +	if (nla_put_u32(msg, NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES,
> +			cap->ftm.preambles))
> +		return -ENOBUFS;
> +	if (nla_put_u32(msg, NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS,
> +			cap->ftm.bandwidths))
> +		return -ENOBUFS;
> +
> +	nla_nest_end(msg, ftm);
> +	return 0;
> +}
> +
> +static int nl80211_send_pmsr_capa(struct cfg80211_registered_device *rdev,
> +				  struct sk_buff *msg)
> +{
> +	const struct cfg80211_pmsr_capabilities *cap = rdev->wiphy.pmsr_capa;
> +	struct nlattr *pmsr, *caps;
> +
> +	if (!cap)
> +		return 0;
> +
> +	/*
> +	 * we don't need to clean up anything here since the caller
> +	 * will genlmsg_cancel() if we fail
> +	 */
> +
> +	pmsr = nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
> +	if (!pmsr)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_PMSR_ATTR_MAX_PEERS, cap->max_peers))
> +		return -ENOBUFS;
> +
> +	if (cap->report_ap_tsf &&
> +	    nla_put_flag(msg, NL80211_PMSR_ATTR_REPORT_AP_TSF))
> +		return -ENOBUFS;
> +
> +	caps = nla_nest_start(msg, NL80211_PMSR_ATTR_TYPE_CAPA);
> +	if (!caps)
> +		return -ENOBUFS;
> +
> +	if (nl80211_send_pmsr_ftm_capa(cap, msg))
> +		return -ENOBUFS;
> +
> +	nla_nest_end(msg, caps);
> +	nla_nest_end(msg, pmsr);
> +
> +	return 0;
> +}
> +
>  struct nl80211_dump_wiphy_state {
>  	s64 filter_wiphy;
>  	long start;
> @@ -2118,6 +2237,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>  				goto nla_put_failure;
>  		}
>  
> +		state->split_start++;
> +		break;
> +	case 14:
> +		if (nl80211_send_pmsr_capa(rdev, msg))
> +			goto nla_put_failure;
> +
>  		/* done */
>  		state->split_start = 0;
>  		break;
> @@ -2318,9 +2443,9 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
>  		wdev->iftype == NL80211_IFTYPE_P2P_GO;
>  }
>  
> -static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
> -				 struct genl_info *info,
> -				 struct cfg80211_chan_def *chandef)
> +int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
> +			  struct genl_info *info,
> +			  struct cfg80211_chan_def *chandef)
>  {
>  	struct netlink_ext_ack *extack = info->extack;
>  	struct nlattr **attrs = info->attrs;
> @@ -2794,12 +2919,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>  	return 0;
>  }
>  
> -static inline u64 wdev_id(struct wireless_dev *wdev)
> -{
> -	return (u64)wdev->identifier |
> -	       ((u64)wiphy_to_rdev(wdev->wiphy)->wiphy_idx << 32);
> -}
> -
>  static int nl80211_send_chandef(struct sk_buff *msg,
>  				const struct cfg80211_chan_def *chandef)
>  {
> @@ -4520,8 +4639,7 @@ static int parse_station_flags(struct genl_info *info,
>  	return 0;
>  }
>  
> -static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
> -				 int attr)
> +bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info, int attr)
>  {
>  	struct nlattr *rate;
>  	u32 bitrate;
> @@ -6852,8 +6970,8 @@ static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
>  	return 0;
>  }
>  
> -static int nl80211_parse_random_mac(struct nlattr **attrs,
> -				    u8 *mac_addr, u8 *mac_addr_mask)
> +int nl80211_parse_random_mac(struct nlattr **attrs,
> +			     u8 *mac_addr, u8 *mac_addr_mask)
>  {
>  	int i;
>  
> @@ -13886,9 +14004,23 @@ static const struct genl_ops nl80211_ops[] = {
>  		.internal_flags = NL80211_FLAG_NEED_NETDEV |
>  				  NL80211_FLAG_NEED_RTNL,
>  	},
> +	{
> +		.cmd = NL80211_CMD_PEER_MEASUREMENT_START,
> +		.doit = nl80211_pmsr_start,
> +		.policy = nl80211_policy,
> +		.flags = GENL_UNS_ADMIN_PERM,
> +		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
> +				  NL80211_FLAG_NEED_RTNL,
> +	},
> +	{
> +		.cmd = NL80211_CMD_PEER_MEASUREMENT_RESULT,
> +		.dumpit = nl80211_pmsr_dump_results,
> +		.policy = nl80211_policy,
> +		.flags = GENL_UNS_ADMIN_PERM,
> +	},
>  };
>  
> -static struct genl_family nl80211_fam __ro_after_init = {
> +struct genl_family nl80211_fam __ro_after_init = {
>  	.name = NL80211_GENL_NAME,	/* have users key off the name instead */
>  	.hdrsize = 0,			/* no private header */
>  	.version = 1,			/* no particular meaning now */
> @@ -15869,6 +16001,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
>  			} else if (wdev->conn_owner_nlportid == notify->portid) {
>  				schedule_work(&wdev->disconnect_wk);
>  			}
> +
> +			cfg80211_release_pmsr(wdev, notify->portid);
>  		}
>  
>  		spin_lock_bh(&rdev->beacon_registrations_lock);
> diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
> index 79e47fe60c35..1ad58596d3d5 100644
> --- a/net/wireless/nl80211.h
> +++ b/net/wireless/nl80211.h
> @@ -4,8 +4,46 @@
>  
>  #include "core.h"
>  
> +/* multicast groups */
> +enum nl80211_multicast_groups {
> +	NL80211_MCGRP_CONFIG,
> +	NL80211_MCGRP_SCAN,
> +	NL80211_MCGRP_REGULATORY,
> +	NL80211_MCGRP_MLME,
> +	NL80211_MCGRP_VENDOR,
> +	NL80211_MCGRP_NAN,
> +	NL80211_MCGRP_PMSR,
> +	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
> +};
> +
> +extern struct genl_family nl80211_fam;
> +
>  int nl80211_init(void);
>  void nl80211_exit(void);
> +
> +extern const struct nla_policy nl80211_policy[NUM_NL80211_ATTR];
> +
> +void *nl80211hdr_put(struct sk_buff *skb, u32 portid, u32 seq,
> +		     int flags, u8 cmd);
> +bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
> +			  int attr);
> +
> +static inline u64 wdev_id(struct wireless_dev *wdev)
> +{
> +	return (u64)wdev->identifier |
> +	       ((u64)wiphy_to_rdev(wdev->wiphy)->wiphy_idx << 32);
> +}
> +
> +int nl80211_prepare_wdev_dump(struct netlink_callback *cb,
> +			      struct cfg80211_registered_device **rdev,
> +			      struct wireless_dev **wdev);
> +
> +int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
> +			  struct genl_info *info,
> +			  struct cfg80211_chan_def *chandef);
> +int nl80211_parse_random_mac(struct nlattr **attrs,
> +			     u8 *mac_addr, u8 *mac_addr_mask);
> +
>  void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
>  			  enum nl80211_commands cmd);
>  void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
> @@ -95,4 +133,8 @@ void nl80211_send_ap_stopped(struct wireless_dev *wdev);
>  
>  void cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev);
>  
> +/* peer measurement */
> +int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info);
> +int nl80211_pmsr_dump_results(struct sk_buff *skb, struct netlink_callback *cb);
> +
>  #endif /* __NET_WIRELESS_NL80211_H */
> diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
> new file mode 100644
> index 000000000000..f2bed20f33a5
> --- /dev/null
> +++ b/net/wireless/pmsr.c
> @@ -0,0 +1,678 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Copyright (C) 2018 Intel Corporation
> + */
> +#ifndef __PMSR_H
> +#define __PMSR_H
> +#include <net/cfg80211.h>
> +#include "core.h"
> +#include "nl80211.h"
> +#include "rdev-ops.h"
> +
> +static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
> +			  struct nlattr *ftmreq,
> +			  struct cfg80211_pmsr_request_peer *out,
> +			  struct genl_info *info)
> +{
> +	const struct cfg80211_pmsr_capabilities *capa = rdev->wiphy.pmsr_capa;
> +	struct nlattr *tb[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1];
> +	u32 preamble = NL80211_PREAMBLE_DMG; /* only optional in DMG */
> +
> +	/* validate existing data */
> +	if (!(rdev->wiphy.pmsr_capa->ftm.bandwidths & BIT(out->chandef.width))) {
> +		NL_SET_ERR_MSG(info->extack, "FTM: unsupported bandwidth");
> +		return -EINVAL;
> +	}
> +
> +	/* no validation needed - was already done via nested policy */
> +	nla_parse_nested(tb, NL80211_PMSR_FTM_REQ_ATTR_MAX, ftmreq, NULL, NULL);
> +
> +	if (tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE])
> +		preamble = nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE]);
> +
> +	/* set up values - struct is 0-initialized */
> +	out->ftm.requested = true;
> +
> +	switch (out->chandef.chan->band) {
> +	case NL80211_BAND_60GHZ:
> +		/* optional */
> +		break;
> +	default:
> +		if (!tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE]) {
> +			NL_SET_ERR_MSG(info->extack,
> +				       "FTM: must specify preamble");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (!(capa->ftm.preambles & BIT(preamble))) {
> +		NL_SET_ERR_MSG_ATTR(info->extack,
> +				    tb[NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE],
> +				    "FTM: invalid preamble");
> +		return -EINVAL;
> +	}
> +
> +	out->ftm.preamble = preamble;
> +
> +	out->ftm.burst_period = 0;
> +	if (tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD])
> +		out->ftm.burst_period =
> +			nla_get_u32(tb[NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD]);
> +
> +	out->ftm.asap = tb[NL80211_PMSR_FTM_REQ_ATTR_ASAP];
> +	if (out->ftm.asap && !capa->ftm.asap) {
> +		NL_SET_ERR_MSG_ATTR(info->extack,
> +				    tb[NL80211_PMSR_FTM_REQ_ATTR_ASAP],
> +				    "FTM: ASAP mode not supported");
> +		return -EINVAL;
> +	}
> +
> +	if (!out->ftm.asap && !capa->ftm.non_asap) {
> +		NL_SET_ERR_MSG(info->extack,
> +			       "FTM: non-ASAP mode not supported");
> +		return -EINVAL;
> +	}
> +
> +	out->ftm.num_bursts_exp = 15;
I prefer the default to be a single burst and not the maximum 2^15 bursts,
but not critical.

[rest truncated, looks good to me]

Thanks,
Lior
