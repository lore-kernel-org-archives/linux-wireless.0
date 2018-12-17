Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D65A7C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 15:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3F12145D
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 15:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MuS0TSgR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbeLQPHz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 10:07:55 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36032 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbeLQPHy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 10:07:54 -0500
Received: by mail-io1-f67.google.com with SMTP id m19so10227246ioh.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 07:07:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DOvCVBq7i9mnrlHaTdPuXXyRqx4UkWqaHNCAPUE5PRs=;
        b=MuS0TSgRwAaP54FAqI7yrx6WoULWwojh/4fOD1PrJvVR8rK4chfuKQAMeEEk7XOz8C
         kKk3k2f/hKzH/S33OnvucxeWG5xYP+DGdbMozvMu0trfji+OFhm1HNmm1V9O+FlR0rDE
         yyOpN4mQs8zb0vugjchLYEodErkgz7bElQVa+KRvu7OTYodqgzGiunTrDeLnWUfLqhz7
         BTfevNESD+ws+77Syu6fRdSNSf66LkQYV4IzkvKwy3zCQdZtgYGvxFPdWLHHNpNkrrpW
         jVkLR3fIyS20EezcHxGh9F1DVsXN0JKm8/qXP5ZQ7nypoBS3xyPeXUXLZWAM2T+CjAjR
         FgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DOvCVBq7i9mnrlHaTdPuXXyRqx4UkWqaHNCAPUE5PRs=;
        b=dSzJ+D2WA80C4Vj0l1L1QbK9unP35gs2au4f46KlcOJF+t0dE/gJmma9Ihl7fpocOi
         oZOuiMPssFJPIss0LmNW4Si1KtP2P4fFbj0vKP+OCU6O0MhqIdTvUF+Zd6hTagg7grDU
         Meai/+Y0HXpqGQ4gNAxUsHwlVUu7lenCPhyz2es+a4sqIKmlYtbHX9lbrpzDWA8kVRIE
         jkkhRHOMvdTV6vbEhHtgBoK8bwU86c+xQVHMQxS34diqILK/XgHWBu1JkqLRq4nSpQyz
         +eYwhOUX+nhlcOUevdHrkfvaa4c8Vz9AebAzfbROonj1uzfBz7EM9+GHPH9eiGtmzoDs
         1LZw==
X-Gm-Message-State: AA+aEWaM2DLIRSKBrpQymvw+DoAuAPPgm6OWaMIUzm/7a4pHhDoYVdBx
        mXH85Aj3GHJzeIXKQ49UL510KbSzSnRt3hGePpc=
X-Google-Smtp-Source: AFSGD/Ui7FKrTLh8/1zqjN4TPf04AAyL2ti56DNGCKduBZSEb7ta6foZ1HxOkA/8pb8c10l27wF5d6O3//jsDFxfviY=
X-Received: by 2002:a5e:dc03:: with SMTP id b3mr10005391iok.27.1545059273242;
 Mon, 17 Dec 2018 07:07:53 -0800 (PST)
MIME-Version: 1.0
References: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
 <20181213143947.GA11947@localhost.localdomain> <CAM0KTbCMrcXNFHUFEmoHg+nseN1GkegqAM0GSuWBDHP=gVgi=w@mail.gmail.com>
 <dd275289-99d0-54a8-9ac5-cb137123950a@gmail.com>
In-Reply-To: <dd275289-99d0-54a8-9ac5-cb137123950a@gmail.com>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Mon, 17 Dec 2018 10:07:43 -0500
Message-ID: <CAM0KTbBV_YZqt6kkrKeY5tRtKn10UOLQY3EyTKPY+zLzht7sgg@mail.gmail.com>
Subject: Re: mt76x[02]u 802.11w support
To:     Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        sgruszka@redhat.com, linux-mediatek@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Dec 16, 2018 at 5:39 AM Matthias Brugger <matthias.bgg@gmail.com> wrote:
>
>
>
> On 15/12/2018 04:43, Sid Hayn wrote:
> > On Thu, Dec 13, 2018 at 9:39 AM Lorenzo Bianconi
> > <lorenzo.bianconi@redhat.com> wrote:
> >>
> >>> Per a conversation with Lorenzo, it seems that 802.11w for mt76x[02]u
> >>> has only been fixed in 4.20.  As 4.19 is a LTS kernel, I'd like to
> >>> request that work be backported.  While the improvements in 4.20 and
> >>> 4.21 are already fairly obvious, a lot of people will be running 4.19
> >>> for years to come.  This is good hardware, with a working driver
> >>> (thanks team) but in the next few months excitement is going to turn
> >>> toward WPA3 which requires working 802.11w.
> >>>
> >>> Pretty please backport 802.11w support to 4.19
> >>
> >> IIRC the isse is just on mt76x0u, mt76x2u should work
> >
> > I can confirm that it does work on mt76x2u on 4.19.5; so my request is
> > to backport 802.11w (software crypto I believe) support for mt76x0u to
> > 4.19 LTS.  Pretty please :-)
> >
>
> Stable kernel are not used to do feature backports but just bug fixes. Please
> reach out to your favorite Linux distribution to backport this driver into their
> kernel. That's the value add a distro has :)
>
That is a valid fact, however, fixing broken 802.11w, a required part
of the standard, feels like a valid bug fix to me.  Especially since
in 4.19.5 a patch to fix monitor mode was added for the same driver.
Interestingly when I asked for the monitor mode patch to be ported it
was initially refused and then just kind of happened a few weeks
later.  In this case I have a much stronger case, a required feature
of the wifi driver is broken, and this is an LTS kernel.

I also feel compelled to point out that this doesn't matter at all to
me personally.  I will be on 4.20 ten seconds after it comes out, but
many many people use distros which run LTS kernels like 4.19 for
years.  Those people will be missing a required feature for wpa3, and
APs with support (and certification) are already appearing.  So I
close by politely requesting that this bug gets fixed :-)

-Zero

> Regards,
> Matthias
>
> > Just in case it helps to confirm what is needed, here is the error
> > from wpa_supplicant when trying to connect to an 802.11w AP
> > wlan0: WPA: Failed to configure IGTK to the driver
> > wlan0: RSN: Failed to configure IGTK
> >
> > thanks,
> > Zero
> >
> >>
> >> Regards,
> >> Lorenzo
> >>
> >>>
> >>> Thanks,
> >>> Zero
> >
> > _______________________________________________
> > Linux-mediatek mailing list
> > Linux-mediatek@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-mediatek
> >
