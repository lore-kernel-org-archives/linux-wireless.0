Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E48C10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 08:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C2B420850
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 08:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfDMIEt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 04:04:49 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43467 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfDMIEt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 04:04:49 -0400
Received: by mail-qt1-f195.google.com with SMTP id v32so13880392qtc.10
        for <linux-wireless@vger.kernel.org>; Sat, 13 Apr 2019 01:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=smnKHWuOFJZqAePo6qj23bqEy7V/3xuE6B5qLgeMSXA=;
        b=KnGMf54Leog0516WPHwFNmJ77DTmRdnh7g1pRJPBEoQ2H2dVqD1BiJtcb7nKqQVA3Q
         UQdaZ/QHVQVdqEGECvK2RQvlMrIrtIru1jYpnSdXPM+Adv6xZSnNTxMwxBgymMM9f8vX
         gBBI8Itw8PuEP3FJ+3r8jwKP9uS96rHc5R5Vq6u+IlP7mx5KuVhIzfOVlGRSsMBEXUHj
         o4C3/AtZACWO8EZIvKIqicpsn2flk02h+h/OFPknfGvjoAPpViztI/22mlmoN3KvXnVQ
         oa95uA2tEgTYzPPCsSP8p7VdDj+rNYvXfsgQMfVYYH5/WTWaVLOT5Z+bcgB02H8vbIyF
         mXIA==
X-Gm-Message-State: APjAAAXsqD4hAL+Wls7chsA43N0yWiTW/rKUt5rFVHL8WJUpfNcws8qc
        rrD82gSxPA6+R57KIbSP4dqIot9D5imut5Ay/xI=
X-Google-Smtp-Source: APXvYqz/NXonmFaULKZIM6tB4sj8yD4V37n+n0ufLfUtAzq8D74TI2TMROgY3Or7hE2gJ5Z0EPGFhVON7fSzJDOxs8k=
X-Received: by 2002:a0c:9ac1:: with SMTP id k1mr52230246qvf.36.1555142687887;
 Sat, 13 Apr 2019 01:04:47 -0700 (PDT)
MIME-Version: 1.0
References: <1555105210-22996-1-git-send-email-greearb@candelatech.com>
 <1555105210-22996-2-git-send-email-greearb@candelatech.com>
 <CAOXD1ifE_rxU0fV6tXK2WpdOU2x9-b0J4cGsuqf3whi7YapBzA@mail.gmail.com>
 <ab7f61a1-0af6-a754-d9a0-388ebd0c8f15@candelatech.com> <CAOXD1icnusnOZ0b0n6eTD6PRoEcf_tHVgivmCEPM1KsWu1uEng@mail.gmail.com>
 <CAK8P3a2DVgneKY9XMQe_LFuECNR7qvLtJV-g-skC4EUDA40+-g@mail.gmail.com>
In-Reply-To: <CAK8P3a2DVgneKY9XMQe_LFuECNR7qvLtJV-g-skC4EUDA40+-g@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 13 Apr 2019 10:04:30 +0200
Message-ID: <CAK8P3a0DrFs_17WyHXFqrxubZ8y3=JyirkV4LczRVkQMnRHZ5w@mail.gmail.com>
Subject: Re: [PATCH 2/2] iw: Print current time in station info dump
To:     Kirtika Ruchandani <kirtika@google.com>
Cc:     Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Tina Ruchandani <ruchandani.tina@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Apr 13, 2019 at 10:00 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sat, Apr 13, 2019 at 12:07 AM Kirtika Ruchandani <kirtika@google.com> wrote:
> >
> > On Fri, Apr 12, 2019 at 2:49 PM Ben Greear <greearb@candelatech.com> wrote:
> > >
> > > On 4/12/19 2:43 PM, Kirtika Ruchandani wrote:
> > > > On Fri, Apr 12, 2019 at 2:40 PM <greearb@candelatech.com> wrote:
> > > >>
> > > >> From: Ben Greear <greearb@candelatech.com>
> > > >>
> > > >> This lets us more precisely calculate the absolute timestamp
> > > >> of last-rix (ie, now - idle).
> > > >
> > > > Can you use 64-bit timestamps? struct timeval suffers from the
> > > > overflow after 2038 problem.
> > >
> > > What is the preferred API to do this?  Whatever it is, it would need
> > > to compile on old crufty systems as well.
> >
> > I am not sure what the guidance for userspace is. The kernel uses
> > 'struct timespec64' I think.
> > Arnd (cc-ed) who has mostly led the 2038 problem in the kernel might
> > have more input on the
> > "old crufty systems" part.
>
> I'm not sure what you are trying to do, and there are different
> answers depending on the usecase.
>
> For getting the time in the kernel, see Documentation/core-api/timekeeping.rst
> do_gettimeofday() is going away for many reasons, so don't use that.
> It sounds like you want "ktime_to_ms(ktime_get())" here.
>
> In userspace interfaces, you should pass 64-bit nanoseconds as returned
> by ktime_get_ns().
>
> If you want to pretty-print the current wall-clock, use the %pt format string
> on a 'struct rtc_time'.

Ah, I see now this was just userspace code. In that case, using gettimeofday()
works fine, it will end up using a 64-bit version of 'timeval', and converting
that to 64-bit milliseconds is safe.

Using clock_gettime() is generally preferred over gettimeofday() since it
avoids the conversion from nanoseconds to microseconds (which you then
convert to milliseconds).

       Arnd
