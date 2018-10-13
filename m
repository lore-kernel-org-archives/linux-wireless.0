Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D25C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:55:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDBB120895
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 09:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mChFhrfv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VfMJZHGA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDBB120895
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbeJMRbf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 13:31:35 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbeJMRbe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 13:31:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C4E5760600; Sat, 13 Oct 2018 09:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539424504;
        bh=CFvYDjZpzPaTtca1o4qcYUTvW1WNR1chUY0ZdqdJVvc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mChFhrfvR2fnOQYm5ITAshIvmntjPoVk/iepFkNHPKuAcuny235JaR35b+iquqoWU
         UZWjd46yTuTS2Frfe9nvgmbmfbHKuSb3OmMJ3kx/m9yL1z94F8YDj0idUH96+hgrL/
         1yqwL2A0K4mmY409DCr5PQd9P6X3z8f23B7MmNBY=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2E3A060600;
        Sat, 13 Oct 2018 09:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539424503;
        bh=CFvYDjZpzPaTtca1o4qcYUTvW1WNR1chUY0ZdqdJVvc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VfMJZHGAGddnoc3mIEZZFqFLgv3sW314AwVdM909Ov74Adqo6EVSjzK3srUuXsdg0
         fuI/a2C6S+SwWKHWjGjVNRWVooHr7fO12tdHSkYmoTRXCQKA2Cy6LWbYi850G8t/IC
         mnDGnsm9vU3B0p3qCCQkM00eWLhOh78E0MO1BXrA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2E3A060600
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v3] cfg80211: add peer measurement with FTM API
References: <20181012100827.24195-1-johannes@sipsolutions.net>
Date:   Sat, 13 Oct 2018 12:55:00 +0300
In-Reply-To: <20181012100827.24195-1-johannes@sipsolutions.net> (Johannes
        Berg's message of "Fri, 12 Oct 2018 12:08:27 +0200")
Message-ID: <87tvlqp3wr.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

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
>  - make MAC address randomization optional
>  - change num bursts exponent default to 0 (1 burst, rather
>    rather than the old default of 15==don't care)

[...]

> @@ -3176,6 +3361,8 @@ struct cfg80211_ftm_responder_stats {
>   *
>   * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
>   *	Statistics should be cumulative, currently no way to reset is provided.
> + * @start_pmsr: start peer measurement (e.g. FTM)
> + * @abort_pmsr: abort peer measurement
>   */
>  struct cfg80211_ops {
>  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);

It would be nice to document if these ops can sleep or not.

-- 
Kalle Valo
