Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2D1C65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45E1320851
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 19:20:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=rsalveti-net.20150623.gappssmtp.com header.i=@rsalveti-net.20150623.gappssmtp.com header.b="qKb1sNRn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45E1320851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rsalveti.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbeLLTUo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 14:20:44 -0500
Received: from mail-lf1-f50.google.com ([209.85.167.50]:33969 "EHLO
        mail-lf1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbeLLTUo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 14:20:44 -0500
Received: by mail-lf1-f50.google.com with SMTP id p6so14436500lfc.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 11:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rsalveti-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nfHG+EMNEeVipp9f52XvsQEPrgw4MtSPZF74QYrdmeo=;
        b=qKb1sNRnF5LbnXQ8lIu/Kqssmk8NSBkDviCT8ApSiqlH8Oa2YI5ZR8ZpYvNZpChY1H
         HKHn0ejJDZmmIXrLqU1OuqrURo54kUxIyygMKYaGlm3um86rgWCdWaN5UBZvZW0gPJVM
         Wixam3kAkDBYMeWlrmIFu53b1PIwa+PV749q3Ew0Z45koWvaTQU9/sPw4CYbCLrqfJKJ
         nXzGzuh1wAoOQslGmp+zrKJr8nF334jWVZ6MLXqns8PewMQ7cGJIK7nc2KSvgAOGtFWr
         RQiwdQo6gIkfI8KAIteSBKoVExnS0KHauO22rNiG/efIrsBNZHq7VKVW2AOooL0EVVUl
         As2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nfHG+EMNEeVipp9f52XvsQEPrgw4MtSPZF74QYrdmeo=;
        b=GFCdqqADQT5iikK+PbIthSI9PwrJm6gmd5Qpw0DAhVg8NkaSZ+U0w5mi8NuHGkvcUm
         AGJ4vApect2/STo6KSn3a7lnUS4NNzjO13w5IzP+ehZkArrjyVB80n3HQclkx48Z3koX
         Pk4sdjBT2t3hvdDLlCAxzycsgMpoABHrLbGF10qGM4EJ12sYNoLXHBbn1z3e5gNVBX3S
         i/j21pgWJiSanhcAfQwXG7ma5h0wnGFx7gOc4IZgf1lm0ShS1RMNLeocVzMqSXOBEjKQ
         xmh7UTQKEFSErplET5btZDnueR2aFPSLV2dt+ErxJCgBS05YheCbC5OHxJbhdlKAaMMX
         sjZQ==
X-Gm-Message-State: AA+aEWaVb4Eur5KbGn3cVht03i2LKFiL1mnJFwDJ2jEcTr7+WwX3uwvn
        ITxFwUDFtH5fN51+kYVsd0IltClCbmLPJcxsoAH+Ng==
X-Google-Smtp-Source: AFSGD/VA+5xyRQ+u2oUQZuI+oRTdSyFi8Pi0wkJMAs0tggc5OAKBC88EOUb1HCutlW/vRpMB+5pYdox8dkiUB145oEA=
X-Received: by 2002:a19:cfc6:: with SMTP id f189mr13406862lfg.102.1544642441742;
 Wed, 12 Dec 2018 11:20:41 -0800 (PST)
MIME-Version: 1.0
References: <CAHYQr0pKurSS=nvLEaLzup1hgx4+RJ0CezA2nFeA=C4XBDQQog@mail.gmail.com>
 <20181211181944.GW39861@atomide.com> <CAHYQr0pk-WKM-aYR7ubM4GHx8PA82XP5ze9TW9WEJLzdO0f88A@mail.gmail.com>
 <20181211190128.GX39861@atomide.com> <CAHYQr0qc_Lav=1sEGcOmOykUftWRzd6+vis97eBpanEXzfUHaA@mail.gmail.com>
 <CALAqxLUVajBw_PkyhA0s=FhQQHWu1FBEMX+4oDTStRXr6L5Txw@mail.gmail.com>
 <20181211201221.GY39861@atomide.com> <CAHYQr0qffa_G2ZVnSsDfjqSgxuBBZB+8e6ZODpAWV_TMhqzFYg@mail.gmail.com>
 <CAHYQr0onAAMZ21YU59XOgNsVrZ-+33tUHfOa9aPr+hG2M0zb3g@mail.gmail.com> <20181212012539.GA39861@atomide.com>
In-Reply-To: <20181212012539.GA39861@atomide.com>
From:   Ricardo Salveti <rsalveti@rsalveti.net>
Date:   Wed, 12 Dec 2018 17:20:04 -0200
Message-ID: <CAHYQr0pqUpTCmN0f+DFA9KkEKkmtuXcAvf7tn7LqsHHa3QHSyg@mail.gmail.com>
Subject: Re: wlcore getting stuck on hikey after the runtime PM autosuspend
 support change
To:     Tony Lindgren <tony@atomide.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, anders.roxell@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 11, 2018 at 11:25 PM Tony Lindgren <tony@atomide.com> wrote:
>
> * Ricardo Salveti <rsalveti@rsalveti.net> [181211 21:51]:
> > Tried to change back wl12xx_sdio_power_off to use pm_runtime_put_sync
> > as a test, and noticed I always get -EBUSY when reproducing the hang,
> > so it looks like this could be a race between pm_runtime_put/get when
> > doing if down/up (and the side effect on the mmc controller).
>
> Hmm so -EBUSY for pm_runtime means transition is already happening
> and in many cases the test should be:
>
> error = pm_runtime_get(dev);
> if (error < 0 && error != -EBUSY) {
>         ...
> }
> ...
> pm_runtime_put(dev);
>
> Where are you getting it?

What I noticed is that with autosuspend support I always get -EBUSY in
wl12xx_sdio_power_off -> pm_runtime_put, and I would guess that the
additional delay here creates the issue later when bringing the
interface up again.

Without autosuspend I never get -EBUSY in wl12xx_sdio_power_off.

Cheers,
-- 
Ricardo Salveti de Araujo
