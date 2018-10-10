Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14D4C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 567B220645
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 21:01:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDgtmoOw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 567B220645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbeJKEZp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 00:25:45 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:40331 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbeJKEZo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 00:25:44 -0400
Received: by mail-qk1-f180.google.com with SMTP id a13-v6so4109459qkc.7
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 14:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IVVJbQdHm+WbDGCFOViYYj7GeTWAxMIxdEuVM6K4gBs=;
        b=NDgtmoOwuCEOdRfLmu75upsYQpR5GKu4CAilux+dPgoG1DBZP+f23ecp3rFz514bQm
         OldCavR5fybjd78WCJOhQihPLYs1ji+xt1nmnpOi+JGF2Kc++5Ja8TnSJYbL87s1fE3S
         wp1Icb2LJKe+OPvfcoqkriPZNNW/M4zmM/qLQf66iukxadpI6JY8eGV+wzA8rUud1++G
         EpGk8+dUG0wKikI1VFNeIOP30I/rqRe5q04+glGWubI8/DVzMy5eX3GvRcspLW+5n+Ve
         ZMTMjz/wDUam0A57giCahusxsCAUv9Ey9WFZ7bL8dg4bkQTnnp5NvODqPZbY4x94fQSc
         w7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IVVJbQdHm+WbDGCFOViYYj7GeTWAxMIxdEuVM6K4gBs=;
        b=pRt5BouLGdeO7J3JemIuzMaUG7TCdph5bzy2OgBBKfRVfkBzXuvW8cdMK5F9bGBxK1
         ZNXt6XMSIQWWviG1eMdGpd/pJ6zNbhQudnzJX0uLzP9UpAmZ2pyOfksfvXDtFMeAoDIl
         jE2GkwdQIQI4wspSErVgtNBSijul233eijkHg/OSzsO6eWd78PGdo3+KDt8xod6QFGZr
         +xLYqS+TB9DFRZ65nC0HF9/R04Bg0YVFNzlDjgs2cpcBQv4bZEJ1ebuo6pUnmN1StnUZ
         D9InC5j2tZDpvtBabAViQGOXmmv4bw5RmDpPUPNZIZVWoIg17Q2+D2SuEvzCUGnnoeNS
         c6dQ==
X-Gm-Message-State: ABuFfohaXqgj8hORyvMJyD4VQwAVcsfdbEtGeJygJ47CEssEJKzvC8h1
        jXWskjjA9T0vwK1pRM4+9p0kK+7Nm2Lv2zrkFPM=
X-Google-Smtp-Source: ACcGV60Ne1hRgNVr8BgKhXfIRDDIPPuKtAHSgvzDN+ThEBAdqCWipseFTCL42xUpudcqm51F3YgvHe5U8HmdgPYhmWE=
X-Received: by 2002:a37:185f:: with SMTP id j92-v6mr26853072qkh.65.1539205308779;
 Wed, 10 Oct 2018 14:01:48 -0700 (PDT)
MIME-Version: 1.0
References: <a44e3947-29a9-d7ba-abec-59bc1b92b201@candelatech.com>
 <87pnwqaiso.fsf@toke.dk> <CAA93jw768_OOUB1w81_9Ck_XgSbDG4P2nBfuptT+SLXCf3voTA@mail.gmail.com>
 <01b77936-f6d4-271a-d7d2-0fd2cf70f7bd@candelatech.com> <CAA93jw6zjyBeyK2Ln8U4QfgxxES6y7E3opR7YxCpS-khBAea=w@mail.gmail.com>
 <ef20b70a-f885-911a-8e2f-837451974223@candelatech.com>
In-Reply-To: <ef20b70a-f885-911a-8e2f-837451974223@candelatech.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 10 Oct 2018 14:01:35 -0700
Message-ID: <CAA93jw62xzetUVecyO8xS7huZQJvZhu8v9aBjEG1OohftgzkkQ@mail.gmail.com>
Subject: Re: Tool to debug wifi pkt sniffs?
To:     Ben Greear <greearb@candelatech.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 1:44 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 10/10/2018 12:13 PM, Dave Taht wrote:
> > On Wed, Oct 10, 2018 at 10:10 AM Ben Greear <greearb@candelatech.com> w=
rote:
> >>
> >> On 10/03/2018 01:29 PM, Dave Taht wrote:
> >>> On Wed, Oct 3, 2018 at 1:16 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@toke.dk> wrote:
> >>>>
> >>>> Ben Greear <greearb@candelatech.com> writes:
> >>>>
> >>>>> Hello,
> >>>>>
> >>>>> I often find myself wanting to figure out what equipment is to blam=
e (and why)
> >>>>> in a wifi environment.
> >>>>>
> >>>>> I am thinking writing a tool that would parse a pcap file and look =
at frames
> >>>>> in enough detail to flag block-ack bugs, rate-ctrl bugs, guess at t=
he sniffer's
> >>>>> capture ability, etc.
> >>>>>
> >>>>> Does anyone have anything already written that they would like to s=
hare, or know
> >>>>> of projects that might already do some of this?
> >>>>
> >>>> Not sure if this fits your criteria, but Sven's tool to create airti=
me
> >>>> charts from packet sniffing data immediately came to mind:
> >>>>
> >>>> https://github.com/cloudtrax/airtime-pie-chart
> >>>
> >>> I have used that. Oy, it's a PITA. Some of kathie's code over here
> >>> (example: https://github.com/pollere/pping ) uses the slightly less
> >>> painful http://libtins.github.io/ library for parsing packets.
> >>
> >> I couldn't find anything that did what I wanted, so I wrote my own.
> >>
> >> The (perl) code is in the wifi-diag directory of this public repo:
> >>
> >> https://github.com/greearb/lanforge-scripts
> >>
> >> The rest of the scripts in that repo are not related to the wifi-diag =
script, so just ignore those.
> >>
> >> Here is example output for what I have so far:
> >>
> >> https://www.candelatech.com/oss/wifi-diag/netgear-up-5s/index.html
> >
> > I *miss* writing in perl. :)

I did take a quick look at the perl. It's been too long
> >
> > My guess from looking at that output that that was a udp flood test.
> > Do I win the internets?
>
> Yes, UDP upload test with 20 emulated stations, sending ~500 byte UDP fra=
mes.
> One thing we notice in the case we are debugging, is
> that the average time from transmitter station device receiving BA from t=
he AP
> to the transmitter station device putting the next AMPDU frame on air
> is 0.728ms for the problem AP, and 0.448ms for the good AP.

I'm not big on averages. A cdf plot would show you if the delay was consist=
ent
across the range or had a knee in it.

>
> I checked that the wmm config in the beacons for the two APs is the same.
>
> I am at a loss as to what could cause this delay, other than possibly the=
 problem
> AP has a funky transmitter than puts a bit of extra noise on the air afte=
r it
> is done transmitting a frame?

A possible explanation would be garbage at one or more tried mcs rate
(not successfully captured).
minstrel at least tries multiple mcs rates.

>
> The problem AP also has 5% retransmits vs about 2% for the good AP, and p=
roblem AP
> is typically using MCS8 instead of MCS9, but even so, I do not see how th=
at would explain
> the extra BA to AMPDU delay.

It's highly probable I'm misunderstanding you and would need to look
directly at the cap.

"typically using" says to me "more often trying the wrong rate"

>
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
