Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EFEC5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 032EF20811
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 19:25:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="J1jn3ZSN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 032EF20811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbeLKTZp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 14:25:45 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45098 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeLKTZo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 14:25:44 -0500
Received: by mail-lj1-f196.google.com with SMTP id s5-v6so14012594ljd.12
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2018 11:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MGGhQOeG++szNKVo4Ee1QFWFOzo11fkPSH0wfFDUrLw=;
        b=J1jn3ZSNoLJkQLpxYtwMuS2HvKBEbyQCGdoMOo0UNXjHt3UdUvYGdvy4fUlNUIJpWD
         mAGjiZdNOTYkEl0Qgwb7n8mNcr3Stt03RjmE2On3avchAGE3I+qkJCCr3dJ6GjkrnAs3
         YNXW3LOSYfGrJDIYiApDeMP6vjzfR8FT4941Ml6kjTJlRw31zwJpQK55CpA7JlciWOvh
         7n35/YGUdU0dpDOy5iZp319HzjUAc15k3KcA5eyvP7U5n2k5I93RSPjCRa0xB1Zz9JPw
         NCdho/ZSP3scMWtMthL2/CVqZAZXDeWvWQEND+F2rvFa+30RsyAX8XY5pRjhTpohqDmQ
         dP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MGGhQOeG++szNKVo4Ee1QFWFOzo11fkPSH0wfFDUrLw=;
        b=aJxGcPKJW5hhV3Piby3NpUm+etljP1CjfnnGPTyki4T8Gvichisni2xfILTqfAfkE9
         HzwKcidBh5yznpm0alcKkuR+AK86RudQ2ZwteL0yg39e4PTYUFXcVO7si/dXI9Ay+1bE
         hqBKImC55C6uBmmLxQa8JTx0FxBsDZEKW+24SSOmNsGM1+ywjrb6G5HGNP04ucaky/p5
         38HAaffcTlIpKI3Ak12e5MD4hYozwlNzz/+w+mj7CH2NDz2/Vp/i92kXb9Rh52bfkYdx
         HuwgzJANoEfs7hgbjcUSLAXVkHxvK/UHyb1YwHBp1zZPwMzT19knJBqD5dqwIy5W06Y9
         vk6g==
X-Gm-Message-State: AA+aEWZxRjNrkVxbU8+GTRfgg0q6fB7UGZReXg00+uBHVypxDsRxApnH
        +8tRuX7g9kmpoB/e++ZZ2Ph1hhaxBitWmqXd4DmWgw==
X-Google-Smtp-Source: AFSGD/XFEDCunQK6qlulEdEz6TO1MJpZI/9aYOURf5lQ3/UBDLTRIXR5ftzb14rzgM2qSFS2YMUBrV7PYKBqjF/0J48=
X-Received: by 2002:a2e:2d11:: with SMTP id t17-v6mr10541217ljt.159.1544556342484;
 Tue, 11 Dec 2018 11:25:42 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com>
In-Reply-To: <20181211190128.GX39861@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Tue, 11 Dec 2018 17:25:05 -0200
Message-ID: <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     linux-wireless@vger.kernel.org, john.stultz@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 5:01 PM Tony Lindgren <tony@atomide.com> wrote:
>
> * Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:53]:
> > Hi,
> >
> > On Tue, Dec 11, 2018 at 4:19 PM Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > Hi,
> > >
> > > * Ricardo Salveti <rsalveti@rsalveti.net> [181211 18:06]:
> > > > John, did you have any similar issue on your test environment with
> > > > kernel >= 4.19?
> > >
> > > This sounds like the same issue that got fixed in the dts
> > > earlier?
> > >
> > > f904390ac8b2 ("arm64: dts: hikey: Define wl1835 power capabilities")
> >
> > keep-power-in-suspend was removed in 8883ac1db3e2 ("arm64: dts: hikey:
> > Remove keep-power-in-suspend property"), but I just tested after
> > adding that property back in and made no difference.
>
> OK
>
> > The funny thing is that it works fine if I disable NetworkManager MAC
> > address randomization.
>
> Hmm. I wonder if there's pm_runtime_get() and put missing
> around some calls. Do you know the related iw commands
> that happen there to try to reproduce this manually?

Checking why this only happens with NetworkManager when MAC address
randomization is enabled, I noticed that NM performs the following
when starting:

Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3914]
device[0x5575703fe0] (wlan0): bringing up device 3
Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3915]
platform: link: setting up "wlan0" (3)
Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3939]
device[0x5575703fe0] (wlan0): taking down device 3
Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.3940]
platform: link: setting down "wlan0" (3)
Dec 11 18:59:04 hikey NetworkManager[1506]: <info>  [1544554744.4072]
device (wlan0): set-hw-addr: set MAC address to 22:D4:B1:49:B5:DB
(scanning)
Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.4072]
device[0x5575703fe0] (wlan0): bringing up device 3
Dec 11 18:59:04 hikey NetworkManager[1506]: <debug> [1544554744.4073]
platform: link: setting up "wlan0" (3)

Then tried to reproduce with a simple 'while true; do ip link set dev
wlan0 down; ip link set dev wlan0 up; done;' and it was already enough
to cause the same hang. Adding a simple sleep 1 after down/up is
already enough to make it work, so something might be missing during
the down/up process that only happens when they get called right after
the other.

And it works fine with NetworkManager when I disable MAC address
randomization simply because it only brings the interface up once,
avoiding the hang.

Will enable debug and try to get a better trace.

Thanks,
-- 
Ricardo Salveti de Araujo
