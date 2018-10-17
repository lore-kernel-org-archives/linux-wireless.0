Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2178CECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C12792150D
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d6uxEJ2S";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ckUj6ZD5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C12792150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbeJQTr3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:47:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeJQTr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 15:47:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 21F2E6130A; Wed, 17 Oct 2018 11:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539777127;
        bh=sjazHHFBuTnNWbh8EHAqlIEyl00am7zgguPVG7EHs1E=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=d6uxEJ2S79txheLWQCLQ6hh3kuH2P4a829FiciJU76K6+n8waKaVY4c2bLBlzD9Ws
         asPJ6X7cHHIIwHQxEOJ1PQr1LMl5dpGGq+29xaLQCGyho8jeqan+WSwlSuw0kw+Roc
         7ZsdcdUCFGfX9QkLsZ7KI+3MsibfdfG10VPYnfGc=
Received: from [10.18.172.103] (unknown [185.23.60.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: liord@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0DFE60712;
        Wed, 17 Oct 2018 11:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539777125;
        bh=sjazHHFBuTnNWbh8EHAqlIEyl00am7zgguPVG7EHs1E=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=ckUj6ZD5hu1nRZ6SlqcLyePxGTv9pB4MCkpoaX/F+pdKVGVMJK087c+SuQpYeztjf
         96ho4z1SoNMJVBw+XuCxXaRQRfxQ9GCoi01PIfEVsIm8IRwNlCCzPuCgLMnmCxmuZg
         7QuXP3g5u4zvI+qQZ5TqyGCwvi+hx2kNjrwcTjGU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D0DFE60712
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=liord@codeaurora.org
From:   Lior David <liord@codeaurora.org>
Subject: Re: [PATCH v4 1/2] cfg80211: add peer measurement with FTM initiator
 API
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
References: <20181016093049.28771-1-johannes@sipsolutions.net>
Message-ID: <a0958f28-6466-a339-1b04-a003fac8cc10@codeaurora.org>
Date:   Wed, 17 Oct 2018 14:52:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181016093049.28771-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 10/16/2018 12:30 PM, Johannes Berg wrote:

[...]
> + * @rtt_avg: average of RTTs measured (must have either this or @dist_avg)
> + * @rtt_variance: variance of RTTs measured (note that standard deviation is
> + *	the square root of the variance)
> + * @rtt_spread: spread of the RTTs measured
> + * @dist_avg: average of distances (mm) measured
> + *	(must have either this or @rtt_avg)
> + * @dist_variance: variance of distances measured (see also @rtt_variance)
> + * @dist_spread: spread of distances measured (see also @rtt_spread)
I don't remember much from my statistics class, can you please provide some
details about the variance and spread fields? Alternatively I can look at the
first driver implementation for reference, unless it is calculated by FW :-)


> +
> +/**
> + * struct cfg80211_pmsr_result - peer measurement result
> + * @addr: address of the peer
> + * @host_time: host time (use ktime_get_boottime() adjust to the time when the
> + *	measurement was made)
> + * @ap_tsf: AP's TSF at measurement time
> + * @status: status of the measurement
> + * @partial: indicates that this is a partial result for this type
> + * @final: if reporting partial results, mark this as the last one
Maybe it is enough to have just the "final" bit? I mean if final bit is clear
doesn't this imply the result is partial since more results will follow?

[...]

>  /*
> @@ -3863,6 +4055,33 @@ struct wiphy_iftype_ext_capab {
>  	u8 extended_capabilities_len;
>  };
>  
> +/**
> + * struct cfg80211_pmsr_capabilities - cfg80211 peer measurement capabilities
> + * @max_peers: maximum number of peers in a single measurement
> + * @report_ap_tsf: can report assoc AP's TSF for radio resource measurement
> + * @randomize_mac_addr: can randomize MAC address for measurement
> + * @ftm.supported: FTM measurement is supported
> + * @ftm.asap: ASAP-mode is supported
> + * @ftm.non_asap: non-ASAP-mode is supported
> + * @ftm.request_lci: can request LCI data
> + * @ftm.request_civicloc: can request civic location data
> + * @ftm.preambles: bitmap of preambles supported (&enum nl80211_preamble)
> + * @ftm.bandwidths: bitmap of bandwidths supported (&enum nl80211_chan_width)
Consider adding ftm.max_bursts (or max_bursts_exponent) and
ftm.max_measurements_per_burst (is this the same as frames_per_burst?). For
example in our implementation we can't do more than 6 measurements per burst
because of resource limitations.

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
Ok I see variance and spread are better documented here, maybe move the units
information to the above structure definitions?


[...]
> diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
> index 79e47fe60c35..1c689b270a9f 100644
> --- a/net/wireless/nl80211.h
> +++ b/net/wireless/nl80211.h
> @@ -4,8 +4,45 @@
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
> +	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
> +};
> +
Are these changes needed anymore since you don't send results as multicast?

[snipped the rest, looks ok]


Thanks,
Lior
