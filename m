Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A67DC5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:51:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F352B20870
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:51:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ejtISQsm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F352B20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbeLKTvN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 14:51:13 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55089 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbeLKTvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 14:51:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id a62so3494544wmh.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 11:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=urB1o6XsWk5Z8cIQlMwO5fCDHpVrXQcEFn7700HI+wQ=;
        b=ejtISQsmt9rJp2W6+LGfp2n8P5ZKJ7AIE496bqMZIjtOnGcSVnnmJ1u9/CPHZ+2suN
         x3S/kXOWWP4j9Btcst/N/HrzyFrLe/ovm44nozolemvVSusgAAoe4CzXYKPl0aIqbsUT
         H1gtXEqtvIa6vZmuU6ozra5MAhAdT67HGN7sQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=urB1o6XsWk5Z8cIQlMwO5fCDHpVrXQcEFn7700HI+wQ=;
        b=HCHOn3iZgdLmP3jMBBpE4iE2mFz+OX1gvaCu1iCROXo/B3QeuCTn7bCR8whPnStoL8
         U7gF8cjIQSCkDpBLlx46hb0am+Ywq8DkdclRdLMvPwlWkeEgbhL80y7oxc7NVJy9msvc
         QcrIbM3Z6CD7KQuKiICF/Mv0d7Ehj2hvWFqpXnVTs1+EPJjLGmF7t9n5mjKPSz/3gIcI
         D0WBFR2pz2DumMlHEAs5gDTAijD68zcGrb9HUv4aknK5GGIGBjBveRJ4yjv7AIU8Lqdm
         YyK11OgOnQ69hCizn4NqtJ0+NwuyavxCzOj9q31QdudVPuk8m9pg4pwyApnqwm+3OtqL
         g5gA==
X-Gm-Message-State: AA+aEWY7PG6z+DB1dyMtXPcaRVPc4X5pj/cBUmENyhIa0UxBLXzzmkid
        0I7zG/rwzvl9UXRWf2Dp3XyjrQvTgzYBitYZK/URzQ==
X-Google-Smtp-Source: AFSGD/XpQEicb77ktd3NV6ZHgSth0ucEUVe+cTeqmFAQ3gEEGek9kNvvz1yGugo5Fbc6XSbMpojE2sxV/nAEfenOyTw=
X-Received: by 2002:a1c:de57:: with SMTP id v84mr3549714wmg.55.1544557869967;
 Tue, 11 Dec 2018 11:51:09 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
In-Reply-To: <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 11 Dec 2018 11:50:56 -0800
Message-ID: <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     rsalveti@rsalveti.net
Cc:     Tony Lindgren <tony@atomide.com>, linux-wireless@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 11:25 AM Ricardo Salveti <rsalveti@rsalveti.net> wrote:
>
> On Tue, Dec 11, 2018 at 5:01 PM Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:53]:
> > > Hi,
> > >
> > > On Tue, Dec 11, 2018 at 4:19 PM Tony Lindgren <tony@atomide.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > * Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:06]:
> > > > > John, did you have any similar issue on your test environment with
> > > > > kernel >= 4.19?
> > > >
> > > > This sounds like the same issue that got fixed in the dts
> > > > earlier?
> > > >
> > > > f904390ac8b2 ("arm64: dts: hikey: Define wl1835 power capabilities")
> > >
> > > keep-power-in-suspend was removed in 8883ac1db3e2 ("arm64: dts: hikey:
> > > Remove keep-power-in-suspend property"), but I just tested after
> > > adding that property back in and made no difference.
> >
> > OK
> >
> > > The funny thing is that it works fine if I disable NetworkManager MAC
> > > address randomization.
> >
> > Hmm. I wonder if there's pm_runtime_get() and put missing
> > around some calls. Do you know the related iw commands
> > that happen there to try to reproduce this manually?
>
> Checking why this only happens with NetworkManager when MAC address
> randomization is enabled, I noticed that NM performs the following
> when starting:
>
> Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3914]
> device[0x5575703fe0] (wlan0): bringing up device 3
> Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3915]
> platform: link: setting up "wlan0" (3)
> Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3939]
> device[0x5575703fe0] (wlan0): taking down device 3
> Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3940]
> platform: link: setting down "wlan0" (3)
> Dec 11 18:59:04 hikey NetworkManager[1506]: <info>  [1544554744.4072]
> device (wlan0): set-hw-addr: set MAC address to 22:D4:B1:49:B5:DB
> (scanning)
> Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.4072]
> device[0x5575703fe0] (wlan0): bringing up device 3
> Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.4073]
> platform: link: setting up "wlan0" (3)
>
> Then tried to reproduce with a simple 'while true; do ip link set dev
> wlan0 down; ip link set dev wlan0 up; done;' and it was already enough
> to cause the same hang. Adding a simple sleep 1 after down/up is
> already enough to make it work, so something might be missing during
> the down/up process that only happens when they get called right after
> the other.
>
> And it works fine with NetworkManager when I disable MAC address
> randomization simply because it only brings the interface up once,
> avoiding the hang.
>
> Will enable debug and try to get a better trace.

I'm not totally sure you're both seeing the same issue, but if its
helpful, here's the bug that Anders was working:
https://bugs.linaro.org/show_bug.cgi?id=3960

There's some mixing of a separate USB issue that has since been
resolved. But from the notes in that bug, Anders had possibly isolated
the wlcore issue down to the following commit:
https://git.linaro.org/people/anders.roxell/linux.git/commit/?h=tests-lwcore&id=598bfffb593d3fd0e31e790d604b44c9c5df368e

I wonder if something in that pm_runtime change effects this?

thanks
-john
