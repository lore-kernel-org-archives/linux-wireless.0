Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E35FC004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DFEB20652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:25:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OAScHkQW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OAScHkQW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DFEB20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbeJWEpf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 00:45:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeJWEpf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 00:45:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB87A60CF4; Mon, 22 Oct 2018 20:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540239933;
        bh=07kHeUahCFF4s1X2Spcd/gf3Yap9uMb7IdJtqERLGk4=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=OAScHkQWAVVKZndgbCZ4hT42H6fEObSVpyvamMwaW1u8maI5w7TzvuNhD22KZl+Yk
         IMJN89KUnp3tNoibcGjKp5OMjJastZ4Q/XCoaf9Odnznsow68K1bmsUkP4wSkK2WAh
         bJBuzaixF6dopHMlpeQrtnkqWjeu5s/My65MXXc0=
Received: from [192.168.66.8] (bzq-79-176-46-220.red.bezeqint.net [79.176.46.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: liord@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21C4B60C1B;
        Mon, 22 Oct 2018 20:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540239933;
        bh=07kHeUahCFF4s1X2Spcd/gf3Yap9uMb7IdJtqERLGk4=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To:From;
        b=OAScHkQWAVVKZndgbCZ4hT42H6fEObSVpyvamMwaW1u8maI5w7TzvuNhD22KZl+Yk
         IMJN89KUnp3tNoibcGjKp5OMjJastZ4Q/XCoaf9Odnznsow68K1bmsUkP4wSkK2WAh
         bJBuzaixF6dopHMlpeQrtnkqWjeu5s/My65MXXc0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 21C4B60C1B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=liord@codeaurora.org
From:   Lior David <liord@codeaurora.org>
Subject: Re: [PATCH v6 1/2] cfg80211: add peer measurement with FTM initiator
 API
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
References: <20181017123727.12547-1-johannes@sipsolutions.net>
Message-ID: <dad6cddb-7ee4-c987-2326-49eba72c193c@codeaurora.org>
Date:   Mon, 22 Oct 2018 23:25:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181017123727.12547-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 10/17/2018 3:37 PM, Johannes Berg wrote:
[...]
Looks mostly good to me, some minor comments below...

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
> + * @ftms_per_burst: actual frames per burst negotiated
actual frames -> actual ftms

> +/**
> + * struct cfg80211_pmsr_ftm_request_peer - FTM request data
> + * @requested: indicates FTM is requested
> + * @preamble: frame preamble to use
> + * @burst_period: burst period to use
> + * @asap: indicates to use ASAP mode
> + * @num_bursts_exp: number of bursts exponent
> + * @burst_duration: burst duration
> + * @ftms_per_burst: number of frames per burst
frames -> ftms

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
> + * @ftm.max_bursts_exponent: maximum burst exponent supported
> + *	(set to 0 if not limited; note that setting this will necessarily
> + *	forbid using the value 15 to let the responder pick)
How can driver specify it only supports a single burst? (This is what our
internal wil6210 implementation currently supports...)

Thanks,
Lior
