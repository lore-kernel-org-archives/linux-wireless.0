Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6A0C6783B
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B6BA20849
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 20:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B6BA20849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbeLKUMZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 15:12:25 -0500
Received: from muru.com ([72.249.23.125]:57528 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbeLKUMZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 15:12:25 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id E9E378027;
        Tue, 11 Dec 2018 20:12:27 +0000 (UTC)
Date:   Tue, 11 Dec 2018 12:12:21 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     John Stultz <john.stultz@linaro.org>
Cc:     rsalveti@rsalveti.net, linux-wireless@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
Message-ID: <20181211201221.GY39861@atomide.com>
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
 <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* John Stultz <john.stultz@linaro.org> [181211 19:51]:
> On Tue, Dec 11, 2018 at 11:25 AM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
> > Then tried to reproduce with a simple 'while true; do ip link set dev
> > wlan0 down; ip link set dev wlan0 up; done;' and it was already enough
> > to cause the same hang. Adding a simple sleep 1 after down/up is
> > already enough to make it work, so something might be missing during
> > the down/up process that only happens when they get called right after
> > the other.

With while true test above, I'm getting:

wlcore: ERROR timeout waiting for the hardware to complete initialization

Then after ctrl-c, wlan0 connects to the access point just fine
for me.

Is that what you're seeing or some oops?

> > And it works fine with NetworkManager when I disable MAC address
> > randomization simply because it only brings the interface up once,
> > avoiding the hang.
> >
> > Will enable debug and try to get a better trace.
> 
> I'm not totally sure you're both seeing the same issue, but if its
> helpful, here's the bug that Anders was working:
> https://bugs.linaro.org/show_bug.cgi?id=3960
> 
> There's some mixing of a separate USB issue that has since been
> resolved. But from the notes in that bug, Anders had possibly isolated
> the wlcore issue down to the following commit:
> https://git.linaro.org/people/anders.roxell/linux.git/commit/?h=tests-lwcore&id=598bfffb593d3fd0e31e790d604b44c9c5df368e
> 
> I wonder if something in that pm_runtime change effects this?

Maybe yeah. Anyways, should be trivial to fix now once we figure
out how to reproduce it manually :)

Regards,

Tony
