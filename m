Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31678C67863
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 08:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA6F320658
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 08:35:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA6F320658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sig21.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbeJVQx2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 12:53:28 -0400
Received: from mail.sig21.net ([80.244.240.74]:50899 "EHLO mail.sig21.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727611AbeJVQx2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 12:53:28 -0400
Received: from p54ae9eee.dip0.t-ipconnect.de ([84.174.158.238] helo=abc.local)
        by mail.sig21.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <js@sig21.net>)
        id 1gEVgm-0006cG-MP; Mon, 22 Oct 2018 10:35:53 +0200
Received: from js by abc.local with local (Exim 4.91)
        (envelope-from <js@sig21.net>)
        id 1gEVgm-0001nL-3v; Mon, 22 Oct 2018 10:35:52 +0200
Date:   Mon, 22 Oct 2018 10:35:52 +0200
From:   Johannes Stezenbach <js@sig21.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: 4.18.16: memory leak in sta_set_sinfo
Message-ID: <20181022083552.GA6878@sig21.net>
References: <20181022080214.GA6379@sig21.net>
 <f1f5e0839f4b1b68510b9db398995c859a19a19e.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1f5e0839f4b1b68510b9db398995c859a19a19e.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 22, 2018 at 10:25:07AM +0200, Johannes Berg wrote:
> On Mon, 2018-10-22 at 10:02 +0200, Johannes Stezenbach wrote:
> > 
> >     [<00000000b7b13d1a>] sta_set_sinfo+0x634/0x900 [mac80211]
> >     [<00000000a74db622>] ieee80211_get_station+0x50/0x70 [mac80211]
> >     [<000000009fd8a7aa>] cfg80211_wext_giwrate+0x111/0x2b0 [cfg80211]
> 
> > I guess it relates to
> > 0fdf1493b41 " mac80211: allocate and fill tidstats only when needed"
> > which Fixes: 8689c051a201 ("cfg80211: dynamically allocate per-tid stats for station info")
> 
> Yes, you're using wext which we don't any more, so we didn't see this.

Yes, disappointing that conky still uses wext.

> However, it's already fixed:
> 
> commit 848e616e66d4592fe9afc40743d3504deb7632b4
> Author: Stefan Seyfried <seife+kernel@b1-systems.com>
> Date:   Sun Sep 30 12:53:00 2018 +0200
> 
>     cfg80211: fix wext-compat memory leak
> 
> Hopefully that'll eventually propagate to stable.

Good to know it's fixed, but "hopefully" makes me wonder,
I'd love to hear the confirmation that it's been queued.
OTOH I'll apply the patch locally and eventually move to 4.19,
so what gives...

Thanks,
Johannes
