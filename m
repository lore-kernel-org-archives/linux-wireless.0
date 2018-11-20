Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDABC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 00:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5BC220870
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 00:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FI39PiPs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5BC220870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732400AbeKTLEJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 06:04:09 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39046 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731130AbeKTLEJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 06:04:09 -0500
Received: by mail-qk1-f196.google.com with SMTP id q70so277097qkh.6
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2018 16:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HdxjTs/LYe1j7u0t/lTSchkORRrbl0dw1TMizoDsXvA=;
        b=FI39PiPsqFIGKJ8K0oIqT3QQaUO/XeOD+7KBV4KGyvy67zaiNh5jvEYrarha4NbEwK
         3SZecym06iKeyfx1Q8qdWPN4fRm/c6LOA4Zi9Rvis+vlkl1PmMhcFD6rFk4OxKUeC2do
         Qx4DjiO9PzTs3JptdCaJmMlI6HGFfl9YCLsUytIUQxyKFd95yrU3nBVf9XdZR/1kWdYW
         qNJySAzbQl91JsMOrs88AxdDJjKWb28Ds08/WXqfzplAiOQXBMB0XNuVnEcUCfSovt5L
         A9EDk+Gt1n21/+yLeFeCIzDTF5chHItLeo70Fb9QCZkd1JPxSBuWh4tkXlmCGwJ7MAA6
         fMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HdxjTs/LYe1j7u0t/lTSchkORRrbl0dw1TMizoDsXvA=;
        b=mjMa3fjhrzrPzQ04SpcmAAm743N+zZqXAi6aWe1WPPN57IOMff9rbnke9fG7CYOpcx
         eAiuWRCWBMUpJhnU4yl98i+5yVVIp4QChDqPEG5ekYNuyLGZH3y/37HrI1SLu5FmO1EM
         rrApXyg70jwdqxY0WcPUqUkNpJCLOebSYI/aT9gteXU8DmDzZvZXx7+493SDCRIu/J/m
         epQLh2Zo82BXOC29bsd/POnyTf6Rag/mZ0QjVGXSoSgjm3suvThfybI1TqgDIATvJp/K
         acKhL2SqZ4OG9EOYUb8nPQd4f9+NzvwSAtfUxDEAbL8/W0KPHLM87pttt4sWDwBGsgo2
         NpLA==
X-Gm-Message-State: AGRZ1gJ1fZHgZ2TCETOWpsXcPxyhiF/HTRvYMsv75Nzml3A6V/CHXGVf
        xiFmfzQTn/f58c+n06/C9BpJ8xPrzzfgFE5+hG0=
X-Google-Smtp-Source: AJdET5dsJAMk59j5kIXGtkbmKWCd0NGzTSkEM16Kw8jpSITLvwHkeSuwpypANrlgu8/vMJx/rltUntdrfIK0xfYGUwo=
X-Received: by 2002:a37:18d5:: with SMTP id 82mr22130272qky.65.1542674266795;
 Mon, 19 Nov 2018 16:37:46 -0800 (PST)
MIME-Version: 1.0
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
 <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
 <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk>
 <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name> <87sh02tfsp.fsf@toke.dk>
 <878t1p2bqz.fsf@taht.net> <87muq4sn50.fsf@toke.dk> <4DD985B6-7DBE-42F8-AC87-D6B40CEAE553@superduper.net>
 <CAA93jw4Cih5HkHYUOy7Vr5G7zi0KkKmNnNohDAVaj65goWOh+A@mail.gmail.com>
 <b0662c97-fb17-3f9d-693e-2fec92535076@candelatech.com> <CAA93jw5tgKcRM9x0gd-7SKf=qBbjhSip64e1oQqUB6N67FhdmA@mail.gmail.com>
 <6beaeb84-b705-335b-93a7-36176495099b@candelatech.com>
In-Reply-To: <6beaeb84-b705-335b-93a7-36176495099b@candelatech.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 19 Nov 2018 16:37:34 -0800
Message-ID: <CAA93jw55KywLAMEo=hHcqGdB1-qV3-3CCQe+T6GMNZwR6kRhJw@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting
 and scheduling to TXQs
To:     Ben Greear <greearb@candelatech.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Simon Barber <simon@superduper.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 19, 2018 at 4:20 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 11/19/2018 04:13 PM, Dave Taht wrote:
> > On Mon, Nov 19, 2018 at 3:56 PM Ben Greear <greearb@candelatech.com> wr=
ote:
> >>
> >> On 11/19/2018 03:47 PM, Dave Taht wrote:
> >>> On Mon, Nov 19, 2018 at 3:30 PM Simon Barber <simon@superduper.net> w=
rote:
> >>>>
> >>>>
> >>>>
> >>>> On Nov 19, 2018, at 2:44 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:
> >>>>
> >>>> Dave Taht <dave@taht.net> writes:
> >>>>
> >>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
> >>>>
> >>>> Felix Fietkau <nbd@nbd.name> writes:
> >>>>
> >>>> On 2018-11-14 18:40, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >>>>
> >>>> This part doesn't really make much sense to me, but maybe I'm
> >>>> misunderstanding how the code works.
> >>>> Let's assume we have a driver like ath9k or mt76, which tries to kee=
p a
> >>>>
> >>>> =E2=80=A6.
> >>>>
> >>>>
> >>>> Well, there's going to be a BQL-like queue limit (but for airtime) o=
n
> >>>> top, which drivers can opt-in to if the hardware has too much queuei=
ng.
> >>>>
> >>>>
> >>>> Very happy to read this - I first talked to Dave Taht about the need=
 for Time Queue Limits more than 5 years ago!
> >>>
> >>> Michal faked up a dql estimator 3 (?) years ago. it worked.
> >>>
> >>> http://blog.cerowrt.org/post/dql_on_wifi_2/
> >>>
> >>> As a side note, in *any* real world working mu-mimo situation at any
> >>> scale, on any equipment, does anyone have any stats on how often the
> >>> feature is actually used and useful?
> >>>
> >>> My personal guess, from looking at the standard, was in home
> >>> scenarios, usage would be about... 0, and in a controlled environment
> >>> in a football stadium, quite a lot.
> >>>
> >>> In a office or apartment complex, I figured interference and so forth
> >>> would make it a negative benefit due to retransmits.
> >>>
> >>> I felt when that part of the standard rolled around... that mu-mimo
> >>> was an idea that should never have escaped the lab. I can be convince=
d
> >>> by data, that we can aim for a higher goal here. But it would be
> >>> comforting to have a measured non-lab, real-world, at real world
> >>> rates, result for it, on some platform, of it actually being useful.
> >>
> >> We're working on building a lab with 20 or 30 mixed 'real' devices
> >> using various different /AC NICs (QCA wave2 on OpenWRT, Fedora, realte=
k USB 8812au on OpenWRT, Fedora,
> >> and some Intel NICs in NUCs on Windows, and maybe more).  I'm not actu=
ally sure if that realtek
> >>   or the NUCs can do MU-MIMO or not, but the QCA NICs will be able to.=
  It should be at least somewhat similar
> >> to a classroom environment or coffee shop.
> >
> > In the last 3 coffee shops I went to, I could hear over 30 APs on
> > competing SSIDs, running G, N, and AC,
> > occupying every available channel.
>
> I especially like when someone uses channel 3 because, I guess, they
> think it is un-used :)

I think avery actually found a case where that was a benefit, in an
apartment building that had each per-apartment AP
located at exactly the same place on every floor.

I do wish I could go back in time and explain the four colour theorem
to whoever allocated the 2.4ghz wifi band, and then explain even that
was a planar rather than 3D problem.

The 3D coloring problem I visualize as the scene in Aliens 2, where
the monsters just waltz in over the ceiling panels. To me it's an
indelible image kind of superimposed over the interfering waves in the
air, full of gore, goo, and blood...

>
> I'm not sure if this was a fluke or not, but at Starbucks recently I sat =
outside,
> right next to their window, and could not scan their AP at all.  Previous=
ly, I sat
> inside, 3 feet away through the glass, and got great signal.  I wonder wh=
at that was
> all about!  Maybe special tinting that blocks RF?  Or just dumb luck of s=
ome sort.

Ya know, I could definitely see a market for a material like that! I'd
like it for my car, so bluetooth wouldn't escape.

anyway, just blowing off steam. :) When v4 of this rolls around + BQL?
I can get some results back on it too. One less than perfect option or
the other would be better than continuing to have lousy wifi in all
cases on all platforms.

> Thanks,
> Ben
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
