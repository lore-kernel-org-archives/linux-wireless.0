Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6F6DC43610
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 23:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C8312080C
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 23:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFU5zmGA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C8312080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732161AbeKTKN0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 05:13:26 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38052 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732156AbeKTKNZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 05:13:25 -0500
Received: by mail-qk1-f194.google.com with SMTP id d19so126862qkg.5
        for <linux-wireless@vger.kernel.org>; Mon, 19 Nov 2018 15:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tN46XviYnAbD1eX9aBi3MqcZSKzPvBLgD/FsKoh/wb4=;
        b=dFU5zmGAYH4tTUyMpPMoL933pOXmt9FV1owYwvBcrDUF1wbNJhU9mJB84nhhX4zTjb
         HcZPgtDmKm29r8s+efgqPGBW/xynfue7Q1Y7PPODg//SzYdOTy8ob9ArvU/ivDsIkhAT
         Wv8BtA99mfT52I8GPIxvR/0+B4E9pzdc7DVS+qeXV8WGBN/NVo9Cyao09jh6imjQsEoY
         baCeIPIvEjo/CFaHmQbVdyXbpexd5KrRs8pFbt0ftPkzSEFxw/CYL7iwXmD1qW66CBpx
         e4+R9FOf4+QJTco04IuElntYMtgQhILYcspbUHYb/XasMXaqUGgxQqI6TZMMRVe9nDRD
         SN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tN46XviYnAbD1eX9aBi3MqcZSKzPvBLgD/FsKoh/wb4=;
        b=mqggo/bG7IXByKg/NTyqVxSDty9wcyS3OCMNBMatYO4wkfcCdTrlqSJ1XWWul3qqsJ
         +qBmKAaylO4Ornaw7aKFHAsYYT6bDbBD7tAf097ReEW+nbgxkQ5Q13c+NJHXT+IiaWzF
         Sz5mCO2zSWa9jBcPhQJG7MCZHsPSwvApjrRQtC6MLTbKCPyo3JtX7cLBpCtWqz6t5obu
         BIQIKi3zCmtOZUy1I10oeWehblpZU+ZeSsbpVQ16SH0Cb+omttnZKuRAyCMqPU/vd2dB
         4YCGlJQh4AQF8XEyxsNagiiWT8bm5gzjmFtchBgruTg2JEouKT9DMKeTMp7bEZJL6rwQ
         gbiQ==
X-Gm-Message-State: AGRZ1gL4AJP6J/SA8CGj3vB/aSl282zGUsqn6dhBIQ+7QIX0uekOeg81
        NfplelW40HakOUjV5uql/8Q2RYuRPw+2LqwkoBw=
X-Google-Smtp-Source: AJdET5cid060atrRzroLFq21PEjVZ2Wap5PC08RTlIE5PwXAMWjbTmcOx925EolYQuq2uJhe1UDJtf00Cxs2MVUdDJo=
X-Received: by 2002:ac8:6606:: with SMTP id c6mr23040596qtp.376.1542671237142;
 Mon, 19 Nov 2018 15:47:17 -0800 (PST)
MIME-Version: 1.0
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
 <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
 <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk>
 <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name> <87sh02tfsp.fsf@toke.dk>
 <878t1p2bqz.fsf@taht.net> <87muq4sn50.fsf@toke.dk> <4DD985B6-7DBE-42F8-AC87-D6B40CEAE553@superduper.net>
In-Reply-To: <4DD985B6-7DBE-42F8-AC87-D6B40CEAE553@superduper.net>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 19 Nov 2018 15:47:05 -0800
Message-ID: <CAA93jw4Cih5HkHYUOy7Vr5G7zi0KkKmNnNohDAVaj65goWOh+A@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [PATCH v3 3/6] mac80211: Add airtime accounting
 and scheduling to TXQs
To:     Simon Barber <simon@superduper.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
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

On Mon, Nov 19, 2018 at 3:30 PM Simon Barber <simon@superduper.net> wrote:
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

Michal faked up a dql estimator 3 (?) years ago. it worked.

http://blog.cerowrt.org/post/dql_on_wifi_2/

As a side note, in *any* real world working mu-mimo situation at any
scale, on any equipment, does anyone have any stats on how often the
feature is actually used and useful?

My personal guess, from looking at the standard, was in home
scenarios, usage would be about... 0, and in a controlled environment
in a football stadium, quite a lot.

In a office or apartment complex, I figured interference and so forth
would make it a negative benefit due to retransmits.

I felt when that part of the standard rolled around... that mu-mimo
was an idea that should never have escaped the lab. I can be convinced
by data, that we can aim for a higher goal here. But it would be
comforting to have a measured non-lab, real-world, at real world
rates, result for it, on some platform, of it actually being useful.

> Simon
>
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
