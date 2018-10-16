Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430E1C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 09:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1776A205F4
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 09:15:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1776A205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbeJPRFG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 13:05:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52066 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbeJPRFF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 13:05:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCLRv-00038X-8C; Tue, 16 Oct 2018 11:15:35 +0200
Message-ID: <ffa3dae454a5e0be00f6001845d3bca24e96a52e.camel@sipsolutions.net>
Subject: Re: [RFC v3] cfg80211: add peer measurement with FTM API
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Date:   Tue, 16 Oct 2018 11:15:22 +0200
In-Reply-To: <20181012100827.24195-1-johannes@sipsolutions.net> (sfid-20181012_120854_265156_44F5E1AA)
References: <20181012100827.24195-1-johannes@sipsolutions.net>
         (sfid-20181012_120854_265156_44F5E1AA)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


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

Forgot to say ... I didn't make the channel optional (yet), because I
think that doing so now could possibly cause an issue where it's
required for some devices and not required for others, unless we can do
lookups in cfg80211. But if we can do it there, then userspace can also
easily do it (station dump is the only data cfg80211 has), so then
there's not that much point ...

I think we could relax this later if we really needed to.

johannes

