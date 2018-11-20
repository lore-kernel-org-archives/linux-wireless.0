Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C68C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 00:13:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DC3D20851
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 00:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCF1bC2b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DC3D20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbeKTKkJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 05:40:09 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45354 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732000AbeKTKkI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 05:40:08 -0500
Received: by mail-qk1-f194.google.com with SMTP id d135so159796qkc.12
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2018 16:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3537RudzD9yhRIeRECPAZ5fbqp9e5UmrqWm08FUbKME=;
        b=UCF1bC2bov+CS1yJIMXDEeMkdtz0CQ4CN7tZnAjWlpfKXsLn2D1sLa1ahs+jXVqM+C
         bczOKyxW2umwnNZorevYuMxetb6HlQSf1q6Wd6AIATHRioQmh4RPtGxyXHpa8RczlY5P
         EFlV6YgWhpkAYHUCpX33t2MT3m4WbDA4eTdh3b3nUdgzFpPswVllBgzMC5BKcv95U62N
         MstMfDQWR8JcUq83gVJ9os0DUCgq8zRLCwYQ9rsieJjTm9bNm8io9VWkms5EZ+POt/OS
         sm4IlQzr5r7Xm038ZQSe7Oy1tsAQclo6/IIITr9FlQyoMdJCNTJjKS43h7jvzXT/hd6S
         TBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3537RudzD9yhRIeRECPAZ5fbqp9e5UmrqWm08FUbKME=;
        b=qpABAypuoTSggHT8JMYtmmj8NALvmXkefW/sepMyUWwcF1PNhtAjeLTREAoyPnu58k
         p+G2dFHmNpW1XX4kNPPbLYBPXbxp4mazs8zr9E9KdK0AZDyuatfPpMZS9FuZS2mOF3Wh
         YLoM1BuT0SkWbowYYWuHKQu9/MbfVXX32siUgOlCcEctlUe7/kSgtkotaRU00M3Q1h2K
         gdHhGeNgtNI1GkX8xX2hZghupJVLXV6K7Qfw+hZ+XzJgPKQJcStuIsqMam6qOcea6TV0
         TnUWvH1fcMqlfZJxn/I6Hp1Wyh8ROb/R6B8nTgZPPx+PApX01AbmvLDy7PdNQRjciMwg
         AqKA==
X-Gm-Message-State: AGRZ1gLJsAe/ruxjmjHcWc0KUYXdbbQXmVqgonYvhBIALUHEZeTQRV+q
        0RrLnz9Baya6s4N5TCNE9c0zTj0+E3Flu1fIAgo=
X-Google-Smtp-Source: AJdET5eByaE+CMvvZfhAvvGJFVH3RoeXA0SQI9DuKi8opieH5xqc3gwZqIxtzY9NYYfQrA3R7VG8U4in5An/5ehrr4A=
X-Received: by 2002:ac8:6606:: with SMTP id c6mr23111609qtp.376.1542672834122;
 Mon, 19 Nov 2018 16:13:54 -0800 (PST)
MIME-Version: 1.0
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
 <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
 <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk>
 <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name> <87sh02tfsp.fsf@toke.dk>
 <878t1p2bqz.fsf@taht.net> <87muq4sn50.fsf@toke.dk> <4DD985B6-7DBE-42F8-AC87-D6B40CEAE553@superduper.net>
 <CAA93jw4Cih5HkHYUOy7Vr5G7zi0KkKmNnNohDAVaj65goWOh+A@mail.gmail.com> <b0662c97-fb17-3f9d-693e-2fec92535076@candelatech.com>
In-Reply-To: <b0662c97-fb17-3f9d-693e-2fec92535076@candelatech.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 19 Nov 2018 16:13:42 -0800
Message-ID: <CAA93jw5tgKcRM9x0gd-7SKf=qBbjhSip64e1oQqUB6N67FhdmA@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting
 and scheduling to TXQs
To:     Ben Greear <greearb@candelatech.com>
Cc:     Simon Barber <simon@superduper.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 19, 2018 at 3:56 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 11/19/2018 03:47 PM, Dave Taht wrote:
> > On Mon, Nov 19, 2018 at 3:30 PM Simon Barber <simon@superduper.net> wro=
te:
> >>
> >>
> >>
> >> On Nov 19, 2018, at 2:44 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@to=
ke.dk> wrote:
> >>
> >> Dave Taht <dave@taht.net> writes:
> >>
> >> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
> >>
> >> Felix Fietkau <nbd@nbd.name> writes:
> >>
> >> On 2018-11-14 18:40, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>
> >> This part doesn't really make much sense to me, but maybe I'm
> >> misunderstanding how the code works.
> >> Let's assume we have a driver like ath9k or mt76, which tries to keep =
a
> >>
> >> =E2=80=A6.
> >>
> >>
> >> Well, there's going to be a BQL-like queue limit (but for airtime) on
> >> top, which drivers can opt-in to if the hardware has too much queueing=
.
> >>
> >>
> >> Very happy to read this - I first talked to Dave Taht about the need f=
or Time Queue Limits more than 5 years ago!
> >
> > Michal faked up a dql estimator 3 (?) years ago. it worked.
> >
> > http://blog.cerowrt.org/post/dql_on_wifi_2/
> >
> > As a side note, in *any* real world working mu-mimo situation at any
> > scale, on any equipment, does anyone have any stats on how often the
> > feature is actually used and useful?
> >
> > My personal guess, from looking at the standard, was in home
> > scenarios, usage would be about... 0, and in a controlled environment
> > in a football stadium, quite a lot.
> >
> > In a office or apartment complex, I figured interference and so forth
> > would make it a negative benefit due to retransmits.
> >
> > I felt when that part of the standard rolled around... that mu-mimo
> > was an idea that should never have escaped the lab. I can be convinced
> > by data, that we can aim for a higher goal here. But it would be
> > comforting to have a measured non-lab, real-world, at real world
> > rates, result for it, on some platform, of it actually being useful.
>
> We're working on building a lab with 20 or 30 mixed 'real' devices
> using various different /AC NICs (QCA wave2 on OpenWRT, Fedora, realtek U=
SB 8812au on OpenWRT, Fedora,
> and some Intel NICs in NUCs on Windows, and maybe more).  I'm not actuall=
y sure if that realtek
>   or the NUCs can do MU-MIMO or not, but the QCA NICs will be able to.  I=
t should be at least somewhat similar
> to a classroom environment or coffee shop.

In the last 3 coffee shops I went to, I could hear over 30 APs on
competing SSIDs, running G, N, and AC,
occupying every available channel.

> I'll let you know what we find
> as far as how well MU-MIMO improves things or not.

Thank you. My lab is shut down and I'm selling off the gear, so all I
can do anymore is be grumpy.

>
> At least in simple test cases (one 1x1 stations, one 2x2 station, with 4x=
4 MU-MIMO AP),
> it works very well for increased download throughput.

Is that a UDP or TCP test?

My specific "most important" benchmark for wifi is web PLT with lots
of stations. That's the most common wifi use case, IMHO.
Some videoconferencing, voip, ssh, etc. One big upload, one big
download, going on somewhere, sometimes. Slashdot
for me is 78 separate ssl'd tcp flows, a dozen + dns lookups, over 2.2 seco=
nds.

bulk downloads rarely figure in except for streaming video, and that
peaks out generally at 20Mbit/sec for most people.

So while I do like the potential in mu-mimo to, schedule lower service
times on a per station basis, I see too many
variable rates and interference in the real world, and not enough
simultaneity between schedulable stations, and a ton of acks,
for me to imagine there's much of a real-world difference from mu-mimo
in anything other than a well managed office or stadium.

People going for the max download throughput with the max number of
stations... PLT, PLT is a way better benchmark.

I can certainly be convinced by data, and I look forward to your experiment=
s.

> In home setups, I'd guess that the DSL or Cable Modem or other uplink is =
the bottleneck

Offices too. Wifi - aside from interference and range issues lowering
the rate, only becomes the bottleneck at internet speeds >
40Mbits/sec.

We are certainly starting to see wifi become more of the bottleneck,
while running at rates, generally, far lower than what people bench
at.

> way more often than the wifi is, even if your are just running /n.  But, =
maybe that is just
> my experience living out at the end of a long skinny phone line all these=
 years.

Fiber networks and newer cable connections now crack 100mbits, and
there you do see all that nifty fq_codel-ly chocolatey goodness
kicking in....

but I do tend to think the optimization focus should be at low rates
with lots of stations for plt more than bandwidth.

> Thanks,
> Ben
>
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
