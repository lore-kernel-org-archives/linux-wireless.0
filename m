Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0818FC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF2122077C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:32:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RZrzWP9T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF2122077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbeJLSD4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 14:03:56 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:41831 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbeJLSD4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 14:03:56 -0400
Received: by mail-ed1-f65.google.com with SMTP id x31-v6so11024895edd.8
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=v/SY8IbyLr+W7B1jtPbrw50rl/1yg1lonYRAZ1e3gmA=;
        b=RZrzWP9THVk+zbSJATWLqekzdPxxV5oSldezqHTsbOKRxizq93CXJ+FeTm9bRxjGXL
         wkcjnV6MnIEPmrAFStKQI6w7FXUbkRfsoW84t3uPSzLdpe6EJKa01rjVe8YEjnxphxlY
         pdsDNn3y/eSenPj1Wm6C8OucT4s49Z6nHccqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=v/SY8IbyLr+W7B1jtPbrw50rl/1yg1lonYRAZ1e3gmA=;
        b=hNG1UX4FIFKgw25YoPWMp8r0V9D3b5xZyRSNgrAjqiglFlKjg9YWaTLJbiY9dm/1ME
         SRCRh2sV8GDf9C9VXp2nb8rx2PaOVA7SxAxWQ6jmLDfwxbs6cqLp+OfrhDzR5T5uGA3y
         BJlO/RbhhDpDBIJ7+hCC9NPvu5DRG1rU/41+mreLgY0WQac4C2/g3+X01UUeo95+lNDM
         Y3laGlAwE1Zxp8VgVH+dkonLfUc1nzRhFknFSWRV/RfGavV3wQJb8RlTYQ5X9BqP2P/r
         FikTYGJFSjq9mZRkRyG+P5w1dpNAuDI/RZ9H+xl8eN0gdBCL6g5aOx+uGSa1cUTY0zy1
         8Hyw==
X-Gm-Message-State: ABuFfoiGIP2/5IADI9Bn/NBTmVwwR1rcIgJnbSVpddlyfXKZV0L7rRVZ
        dvTaM1rqGimcWlwbiMYGoquBUQ==
X-Google-Smtp-Source: ACcGV61755mEdB/U6eOzGUVG4kwArxldw+Gtp4CP313iZzsnr1VAuMsgPm71feRJI6PpjThldmKZvQ==
X-Received: by 2002:a50:a588:: with SMTP id a8-v6mr8176531edc.289.1539340325596;
        Fri, 12 Oct 2018 03:32:05 -0700 (PDT)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y8-v6sm636622edd.43.2018.10.12.03.32.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Oct 2018 03:32:04 -0700 (PDT)
Subject: Re: [RFC v3] cfg80211: add peer measurement with FTM API
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20181012100827.24195-1-johannes@sipsolutions.net>
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dc9bc6d3-6a95-3ca5-a231-14ed3e2fe302@broadcom.com>
Date:   Fri, 12 Oct 2018 12:32:03 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181012100827.24195-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/12/2018 12:08 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Add a new "peer measurement" API, that can be used to measure
> certain things related to a peer. Right now, only implement
> FTM (flight time measurement) over it, but the idea is that
> it'll be extensible to also support measuring the necessary
> things to calculate e.g. angle-of-arrival for WiGig.
>
> The API is structured to have a generic list of peers and
> channels to measure with/on, and then for each of those a
> set of measurements (again, only FTM right now) to perform.
>
> Results are sent to the requesting socket, including a final
> complete message.
>
> Closing the controlling netlink socket will abort a running
> measurement.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

You have no recollection what happened in the earlier versions, right? :-p

> v3:
>  - add a bit to report "final" for partial results
>  - remove list keeping etc. and just unicast out the results
>    to the requester (big code reduction ...)
>  - also send complete message unicast, and as a result
>    remove the multicast group
>  - separate out struct cfg80211_pmsr_ftm_request_peer
>    from struct cfg80211_pmsr_request_peer
>  - document timeout == 0 if no timeout
>  - disallow setting timeout nl80211 attribute to 0,
>    must not include attribute for no timeout

All these negations make my head spin (a little). Let's look at the 
actual documentation further down...

>  - make MAC address randomization optional
>  - change num bursts exponent default to 0 (1 burst, rather
>    rather than the old default of 15==don't care)
> ---
>  include/net/cfg80211.h       | 255 +++++++++++++++++++
>  include/uapi/linux/nl80211.h | 410 ++++++++++++++++++++++++++++++
>  net/wireless/Makefile        |   1 +
>  net/wireless/core.c          |  33 +++
>  net/wireless/core.h          |   4 +
>  net/wireless/nl80211.c       | 200 ++++++++++++---
>  net/wireless/nl80211.h       |  41 +++
>  net/wireless/pmsr.c          | 576 +++++++++++++++++++++++++++++++++++++++++++
>  net/wireless/rdev-ops.h      |  25 ++
>  net/wireless/trace.h         |  68 +++++
>  10 files changed, 1579 insertions(+), 34 deletions(-)
>  create mode 100644 net/wireless/pmsr.c
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 0e16e723dcef..2837ea5f37e1 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -2841,6 +2841,191 @@ struct cfg80211_ftm_responder_stats {
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

Maybe there is a good reason, but can we move the above line a bit down...

> +	s16 burst_index;
> +	u8 busy_retry_time;
> +	u8 num_bursts_exp;
> +	u8 burst_duration;
> +	u8 frames_per_burst;

ie. here so they match with valid bitfields below.

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

Did not expect to learn something new about C standard ;-) At least I 
never seen comma separated bitfield definition in a struct. Nice.

> +};
> +

[...]

> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index dc6d5a1ef470..40be8968f60b 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2254,6 +2282,14 @@ enum nl80211_commands {
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
> @@ -2699,6 +2735,10 @@ enum nl80211_attrs {
>
>  	NL80211_ATTR_FTM_RESPONDER_STATS,
>
> +	NL80211_ATTR_TIMEOUT,
> +

Guess you consider reuse of the TIMEOUT attribute? I checked the policy 
definition in nl80211_policy so it disallows 0 value as mentioned in the 
changelog. How about adding that to the documentation here, ie. "when 
timeout attribute is not provided the timeout is disabled for the given 
operation" or something like that.

Regards,
Arend
