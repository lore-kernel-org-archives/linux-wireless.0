Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DC0C67839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 01:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C37820811
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 01:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C37820811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbeLLBqA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 20:46:00 -0500
Received: from muru.com ([72.249.23.125]:57636 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726201AbeLLBqA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 20:46:00 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 026118027;
        Wed, 12 Dec 2018 01:46:02 +0000 (UTC)
Date:   Tue, 11 Dec 2018 17:45:56 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ricardo Salveti <rsalveti@rsalveti.net>
Cc:     John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org,
        Eyal Reizer <eyalr@ti.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
Message-ID: <20181212014556.GC39861@atomide.com>
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
 <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com>
 <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHYQr0qhqce2QcwMLRMWnqhZTL4KzHKJLzt6tfCNLHUcEt9pyQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ricardo Salveti <rsalveti@rsalveti.net> [181211 20:45]:
> On Tue, Dec 11, 2018 at 6:23 PM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
> >
> > On Tue, Dec 11, 2018 at 6:12 PM Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > * John Stultz <john.stultz@linaro.org> [181211 19:51]:
> > > > On Tue, Dec 11, 2018 at 11:25 AM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
> > > > > Then tried to reproduce with a simple 'while true; do ip link set dev
> > > > > wlan0 down; ip link set dev wlan0 up; done;' and it was already enough
> > > > > to cause the same hang. Adding a simple sleep 1 after down/up is
> > > > > already enough to make it work, so something might be missing during
> > > > > the down/up process that only happens when they get called right after
> > > > > the other.
> > >
> > > With while true test above, I'm getting:
> > >
> > > wlcore: ERROR timeout waiting for the hardware to complete initialization
> > >
> > > Then after ctrl-c, wlan0 connects to the access point just fine
> > > for me.
> > >
> > > Is that what you're seeing or some oops?
> 
> Tried the same while true test on my beaglebone black wireless and
> also got a trace, but without hanging the kernel (sdio write failed
> instead):
> 
> root@beaglebone-yocto:~# while true; do ifconfig wlan0 down; ifconfig
> wlan0 up; done;
> [   31.467917] wlcore: down
> [   33.205670] ------------[ cut here ]------------
> [   33.211048] WARNING: CPU: 0 PID: 407 at
> drivers/net/wireless/ti/wlcore/sdio.c:145

Hmm OK so SDIO write failing. Adding also Eyal to Cc.

Regards,

Tony
