Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438B4C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 19:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1EE62075B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 19:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOhiGoyi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E1EE62075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbeJKCgz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 22:36:55 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:45146 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727214AbeJKCgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 22:36:55 -0400
Received: by mail-qt1-f179.google.com with SMTP id e10-v6so6993239qtq.12
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 12:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jz5lmU4KP/qnlRUxoUZwzaow3sJYdCX8KMPU4GF39Nk=;
        b=ZOhiGoyiLWY4lxmvOdTR9h7hrFFtd2WxHQocSyoQ7LuIdgoUw9r2y/L6Lvzd9Q4aer
         bngqWKk4arOlx/pTj6DX1OqqTxmIONQ15MLsKkwZeuBZHRRZDqDc5s+7Ji3I2QfiduJK
         7fT6+cOCEqUQcukpzre1flWHQHl2kECxC3ZDp/fuqhVNzXNHVueeOq3+vO5/UjmRAZZu
         BTZEs/J+X2zR8qpCnQlHDXgWVpqlnFRIBZLHM1uRngneMKDf5NOO2OBGFvebQN5pUmRK
         L7Qv4K0idMwAsM19FrOyiVWLoD3sTRtU6gT4jwZ7XvPPC9/QTCk3IT69L+3UqVaIX8kw
         aB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jz5lmU4KP/qnlRUxoUZwzaow3sJYdCX8KMPU4GF39Nk=;
        b=fjU07sO+iCfTO0BE9Zmey/QRGLxS9bvMgNMS9Z5Y0m1gKP+siFQXTEh7KqiW0KM1L8
         OA2KdZAqLSlf40OM3MP8gWuY9ZoXfkqjPdlrrYhAXIHe5nGZVjlEdfJYyD/Cw7nyQpQE
         iWeL9gr96M6auKNF0a36cBtkC3E6LkcFKaqnnE6u4YuMKxyNpdJcebMA9sC0uOca9CT2
         MD75GYY9hW13y8+6IwrdvghQj93BdNAy+bSNSBrSRSg/0InpCvCp+aji5mWz0ReM1bZX
         fLwdOaW6NML+Vb3ZBo2UHaa4KZAk1OfgGavKwD+ncZu2iZ0du/zHK9dWTyQuy9GggQXG
         0THQ==
X-Gm-Message-State: ABuFfoiskuDcS3EMVmlXUeQxevMFlMjzzvy7Io3f0XK2KEIMHJZ7NIUD
        pZpcv7S42t1rrTy1inxXtRoWTqAa2ddtN4AvPYjX0Q==
X-Google-Smtp-Source: ACcGV610klnaT8RJFGXBRaG+A47BERM+Yw9XItYTemt9WRh+daO5S7HfprsnnKUbHjWWOGxkS8tYsnRnb3tXC64VsnI=
X-Received: by 2002:ac8:3261:: with SMTP id y30-v6mr28510153qta.175.1539198803507;
 Wed, 10 Oct 2018 12:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <a44e3947-29a9-d7ba-abec-59bc1b92b201@candelatech.com>
 <87pnwqaiso.fsf@toke.dk> <CAA93jw768_OOUB1w81_9Ck_XgSbDG4P2nBfuptT+SLXCf3voTA@mail.gmail.com>
 <01b77936-f6d4-271a-d7d2-0fd2cf70f7bd@candelatech.com>
In-Reply-To: <01b77936-f6d4-271a-d7d2-0fd2cf70f7bd@candelatech.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 10 Oct 2018 12:13:11 -0700
Message-ID: <CAA93jw6zjyBeyK2Ln8U4QfgxxES6y7E3opR7YxCpS-khBAea=w@mail.gmail.com>
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

On Wed, Oct 10, 2018 at 10:10 AM Ben Greear <greearb@candelatech.com> wrote=
:
>
> On 10/03/2018 01:29 PM, Dave Taht wrote:
> > On Wed, Oct 3, 2018 at 1:16 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@t=
oke.dk> wrote:
> >>
> >> Ben Greear <greearb@candelatech.com> writes:
> >>
> >>> Hello,
> >>>
> >>> I often find myself wanting to figure out what equipment is to blame =
(and why)
> >>> in a wifi environment.
> >>>
> >>> I am thinking writing a tool that would parse a pcap file and look at=
 frames
> >>> in enough detail to flag block-ack bugs, rate-ctrl bugs, guess at the=
 sniffer's
> >>> capture ability, etc.
> >>>
> >>> Does anyone have anything already written that they would like to sha=
re, or know
> >>> of projects that might already do some of this?
> >>
> >> Not sure if this fits your criteria, but Sven's tool to create airtime
> >> charts from packet sniffing data immediately came to mind:
> >>
> >> https://github.com/cloudtrax/airtime-pie-chart
> >
> > I have used that. Oy, it's a PITA. Some of kathie's code over here
> > (example: https://github.com/pollere/pping ) uses the slightly less
> > painful http://libtins.github.io/ library for parsing packets.
>
> I couldn't find anything that did what I wanted, so I wrote my own.
>
> The (perl) code is in the wifi-diag directory of this public repo:
>
> https://github.com/greearb/lanforge-scripts
>
> The rest of the scripts in that repo are not related to the wifi-diag scr=
ipt, so just ignore those.
>
> Here is example output for what I have so far:
>
> https://www.candelatech.com/oss/wifi-diag/netgear-up-5s/index.html

I *miss* writing in perl. :)

My guess from looking at that output that that was a udp flood test.
Do I win the internets?

>
> The general idea is to get a performance test going, and then use tshark =
or similar
> to grab a short sample (my script is slow, it can process only about 400 =
packets per second
> on my desktop, so a 5 sec capture at full speed takes around 5 minutes to=
 process),
> and then pipe that decoded pcap into my script.
>
> It tries to pay attention to latencies between block-ack and next AMPDU f=
rame,
> MCS distributions, packet-type distributions, retries, and other
> such things.  I'm guessing tweaking wmm settings (or changing QoS in the =
generated traffic)
> would be visible in this kind of metric, for instance.
>
> The goal is to be able to answer the question of why one AP is faster or =
slower than another
> when running the same test case.
>
> Feedback (and even patches) is welcome...what other things can I report t=
hat would
> be helpful?
>
>
> Thanks,
> Ben
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
