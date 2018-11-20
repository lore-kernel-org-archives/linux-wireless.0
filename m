Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38759C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 01:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA03F20851
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 01:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8o1RwGX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA03F20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbeKTLbW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 06:31:22 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:36617 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbeKTLbW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 06:31:22 -0500
Received: by mail-qk1-f195.google.com with SMTP id o125so378493qkf.3
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2018 17:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IG/yV/Vy7MQ6qX/+3j25QWzm1BAnZehuu0MwaOBuDQw=;
        b=X8o1RwGXx6BmyQt6c2cOLSbjAZJTn3eAnWAFXF18bAedZ5jpxogVWE5Kc9IrBHkCwq
         62qgb7kP3VwiAw6ZaXq2Vzt+nmciCj1oPwJ/HkFUZiPdLCjlq1NAa7Sixe9xst3zyJJN
         nkG0TiBd1grsr+TGKGfPHKIt1xfgtuw8KUl2iaZSaHdXaJOpFwiszWN4WNongW19y2AO
         Y7NxjGhOCBAoYvyc6HMbtqpO4a8rRuj1nL7UROfPV2kLBQxL+KkOYwzViaZZI9+1YeK0
         CLW2TmW8MQbA6K16GrSSdmSPVhUY8h8Pe4TLrD9xN1vqN+lSylzafICWdxL+RqoCRCzL
         8BvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IG/yV/Vy7MQ6qX/+3j25QWzm1BAnZehuu0MwaOBuDQw=;
        b=eLoRMis6keLfHJDz2o2ayHO7GHs20w3ZVuPnTtUEEbBK303wBPfEpPym6ECiYqvtvT
         auRoweTzR+4zJpp+msqeDTWuOhnC0U0sKLJZJRnZnRTtZpA74jk11cpguM8+JZdTySKx
         OBZQ/ICFCEQSkSnua6e1zMQI6PKdwLtauoo/pM+O1A/knxlmOxLh62ndTtlG8nXldSLc
         19/vCmc5GSZ4K7jz8OZQ7jeZN9Ar7MnxajxPPONl0eoJ2H15Iorh3EPuqXyB97PbxEYC
         tRzrz1yDHyRPk8HYTfF/e1+Yx2GGReJBepBwJ15/hhHQxREqWpm73kShLg12uuCsJxlY
         p+IQ==
X-Gm-Message-State: AGRZ1gJPnND6L5NbNXuO+fbcbFdKGolYGLv9C8fBk636P9cOTLrpzrj3
        WmYbmCnd1rqr00olH1F3XCfYll2tO8t42JhbLn8=
X-Google-Smtp-Source: AJdET5cUaenW4Azn/L7OaH6FYNnJmA1QtNq9/I/5r3e+dv0smlCZh9A2szZgP+guwWSHHixKDs2vaCcUQueRVJl83Q0=
X-Received: by 2002:ac8:3065:: with SMTP id g34mr24032768qte.136.1542675895230;
 Mon, 19 Nov 2018 17:04:55 -0800 (PST)
MIME-Version: 1.0
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
 <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
 <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk>
 <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name> <87sh02tfsp.fsf@toke.dk>
 <878t1p2bqz.fsf@taht.net> <87muq4sn50.fsf@toke.dk> <4DD985B6-7DBE-42F8-AC87-D6B40CEAE553@superduper.net>
 <CAA93jw4Cih5HkHYUOy7Vr5G7zi0KkKmNnNohDAVaj65goWOh+A@mail.gmail.com>
 <b0662c97-fb17-3f9d-693e-2fec92535076@candelatech.com> <CAA93jw5tgKcRM9x0gd-7SKf=qBbjhSip64e1oQqUB6N67FhdmA@mail.gmail.com>
 <6beaeb84-b705-335b-93a7-36176495099b@candelatech.com> <46F43681-DF84-4E08-9426-328BA7AE1CED@superduper.net>
In-Reply-To: <46F43681-DF84-4E08-9426-328BA7AE1CED@superduper.net>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 19 Nov 2018 17:04:43 -0800
Message-ID: <CAA93jw60e-oV_axeNg6JoJGXhjUxbr==nnRvoBiJS3eQF_ZO3A@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting
 and scheduling to TXQs
To:     Simon Barber <simon@superduper.net>
Cc:     Ben Greear <greearb@candelatech.com>,
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

On Mon, Nov 19, 2018 at 4:52 PM Simon Barber <simon@superduper.net> wrote:
>
> Low-e glass, it=E2=80=99s a thin metallic film used to reflect infra-red =
to keep heat in or out. Totally blocks/reflects RF.

Very cool. I imagine it's hell on cell too?

I can see this stuff becoming very popular in places where keeping the
good wifi in is important. Could cover floors and ceilings with it to.
Cars could be tempest rated...

/me goes looking for stock to buy

> Simon
>
> On Nov 19, 2018, at 4:20 PM, Ben Greear <greearb@candelatech.com> wrote:
>
> On 11/19/2018 04:13 PM, Dave Taht wrote:
>
> On Mon, Nov 19, 2018 at 3:56 PM Ben Greear <greearb@candelatech.com> wrot=
e:
>
>
> On 11/19/2018 03:47 PM, Dave Taht wrote:
>
> On Mon, Nov 19, 2018 at 3:30 PM Simon Barber <simon@superduper.net> wrote=
:
>
>
>
>
> On Nov 19, 2018, at 2:44 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.=
dk> wrote:
>
> Dave Taht <dave@taht.net> writes:
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
> Felix Fietkau <nbd@nbd.name> writes:
>
> On 2018-11-14 18:40, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
> This part doesn't really make much sense to me, but maybe I'm
> misunderstanding how the code works.
> Let's assume we have a driver like ath9k or mt76, which tries to keep a
>
> =E2=80=A6.
>
>
> Well, there's going to be a BQL-like queue limit (but for airtime) on
> top, which drivers can opt-in to if the hardware has too much queueing.
>
>
> Very happy to read this - I first talked to Dave Taht about the need for =
Time Queue Limits more than 5 years ago!
>
>
> Michal faked up a dql estimator 3 (?) years ago. it worked.
>
> http://blog.cerowrt.org/post/dql_on_wifi_2/
>
> As a side note, in *any* real world working mu-mimo situation at any
> scale, on any equipment, does anyone have any stats on how often the
> feature is actually used and useful?
>
> My personal guess, from looking at the standard, was in home
> scenarios, usage would be about... 0, and in a controlled environment
> in a football stadium, quite a lot.
>
> In a office or apartment complex, I figured interference and so forth
> would make it a negative benefit due to retransmits.
>
> I felt when that part of the standard rolled around... that mu-mimo
> was an idea that should never have escaped the lab. I can be convinced
> by data, that we can aim for a higher goal here. But it would be
> comforting to have a measured non-lab, real-world, at real world
> rates, result for it, on some platform, of it actually being useful.
>
>
> We're working on building a lab with 20 or 30 mixed 'real' devices
> using various different /AC NICs (QCA wave2 on OpenWRT, Fedora, realtek U=
SB 8812au on OpenWRT, Fedora,
> and some Intel NICs in NUCs on Windows, and maybe more).  I'm not actuall=
y sure if that realtek
>  or the NUCs can do MU-MIMO or not, but the QCA NICs will be able to.  It=
 should be at least somewhat similar
> to a classroom environment or coffee shop.
>
>
> In the last 3 coffee shops I went to, I could hear over 30 APs on
> competing SSIDs, running G, N, and AC,
> occupying every available channel.
>
>
> I especially like when someone uses channel 3 because, I guess, they
> think it is un-used :)
>
> I'm not sure if this was a fluke or not, but at Starbucks recently I sat =
outside,
> right next to their window, and could not scan their AP at all.  Previous=
ly, I sat
> inside, 3 feet away through the glass, and got great signal.  I wonder wh=
at that was
> all about!  Maybe special tinting that blocks RF?  Or just dumb luck of s=
ome sort.
>
> Thanks,
> Ben
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>


--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
