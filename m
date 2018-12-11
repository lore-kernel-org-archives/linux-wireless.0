Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99BD8C67839
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D2FD2084E
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:01:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D2FD2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbeLKTBb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 14:01:31 -0500
Received: from muru.com ([72.249.23.125]:57504 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbeLKTBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 14:01:31 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 8DB978027;
        Tue, 11 Dec 2018 19:01:34 +0000 (UTC)
Date:   Tue, 11 Dec 2018 11:01:28 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ricardo Salveti <rsalveti@rsalveti.net>
Cc:     linux-wireless@vger.kernel.org, john.stultz@linaro.org
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
Message-ID: <20181211190128.GX39861@atomide.com>
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com>
 <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:53]:
> Hi,
> 
> On Tue, Dec 11, 2018 at 4:19 PM Tony Lindgren <tony@atomide.com> wrote:
> >
> > Hi,
> >
> > * Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:06]:
> > > John, did you have any similar issue on your test environment with
> > > kernel >= 4.19?
> >
> > This sounds like the same issue that got fixed in the dts
> > earlier?
> >
> > f904390ac8b2 ("arm64: dts: hikey: Define wl1835 power capabilities")
> 
> keep-power-in-suspend was removed in 8883ac1db3e2 ("arm64: dts: hikey:
> Remove keep-power-in-suspend property"), but I just tested after
> adding that property back in and made no difference.

OK

> The funny thing is that it works fine if I disable NetworkManager MAC
> address randomization.

Hmm. I wonder if there's pm_runtime_get() and put missing
around some calls. Do you know the related iw commands
that happen there to try to reproduce this manually?

Regards,

Tony
