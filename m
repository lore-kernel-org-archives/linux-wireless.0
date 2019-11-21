Return-Path: <SRS0=bi0l=ZN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B0FC432C0
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 02:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE00D2084D
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 02:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NBa6RFFK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfKUCF3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Nov 2019 21:05:29 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41561 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUCF2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Nov 2019 21:05:28 -0500
Received: by mail-lj1-f196.google.com with SMTP id m4so1328729ljj.8
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2019 18:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W9y8MkDsGB3iTJs8dIiEn0Xm5mFuM3VtTw8TaYhfbSM=;
        b=NBa6RFFKKUzwTR1tKMWK4ke6RdtaKa59x12T2gFitkPW//apFo5r57LOwGXJ8HEOaS
         fOj7phRH2B/HVac94gu9WvV6nbyclT2X6SV2uf7o210SqZoV5l08xPhgJUYZPu7oejOk
         ZDS/KpdLoEZJBaIs4UjrnsajP8QXRf3KmsVDgm68E2IJxZOGNnuIFcyopv4YrGFEl9Ao
         FG5ILSBq8yWkqxVh04zn/hCReS6m/skw3DMTPj3lYrZDizv9w6yiLYhHWRG6/LZCbPBf
         XvBnLalYn3P0ADqiSgWataq69e2Ls81sFHlV9j5fAq+LEkRCd+OUK4+o2ilcIDmURg7W
         Kx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W9y8MkDsGB3iTJs8dIiEn0Xm5mFuM3VtTw8TaYhfbSM=;
        b=hCVztWBNW54WzgzonAiQZi1Az50m3cgHjl6kq5Kh/s1jsA1iMRgfLGzqUAbXxko67t
         S1n35vNlclYRBEegbP111DiKhIm9K6TCdrPPxy2yazVWKXUbH3JpmOOUt50biHYMIhPX
         XHjG13t5s4Rz7tBHwiPfkh7kEMbbbLNZasXULk/Y8plGHDo82B93zFIiGq6T8GNsRGyJ
         3irJDHvaYOYFqdmEAosKVw42DIPrhHOwZ9+eW/nhHvbEEbGt97GNzq4uHMGLKPv23Ywl
         NIOtoCrurUyqYfbpQVIvoz8GWcViFWo2Ks3OZGQlteKcW5r6t0XHH8aU9UC9pBDmQYlX
         me3A==
X-Gm-Message-State: APjAAAUITKKs8wXp8k0dwnSsxz3jCe6nSmcP7JF4cye5shHuxzzbMRWZ
        AoYVG6VZNZ4RkJncYVQqHCzvKuTaM9tJR0teOdVW6Q==
X-Google-Smtp-Source: APXvYqxKAUwS9iSLwSGZYRkTZavdu5y/XZl7s+/auYNw2yF0yO/BOqnXRvH/Pfy8Eex3WanUT/z+OMjOW4iUoSZ1g4g=
X-Received: by 2002:a2e:9ecf:: with SMTP id h15mr5166056ljk.173.1574301924723;
 Wed, 20 Nov 2019 18:05:24 -0800 (PST)
MIME-Version: 1.0
References: <20191115014846.126007-1-kyan@google.com> <CA+iem5vaeLR6v_nZ1YUZhfj32wF0DrvC2nyp8nb8qYAZLQjLdw@mail.gmail.com>
 <CAA93jw5wTbFV51oFJ6tFHLUMo=bau8fbU65k57bQjOHGJoCkkQ@mail.gmail.com>
 <CA+iem5s4ZY239Q4=Gwy3WrmVhcdhesirXph6XQoOP5w-nuWcYw@mail.gmail.com>
 <CAA93jw5t0TwBVv7_DVkJ_-NsVn0ODNHwU0orp2-+LPB45iFVoQ@mail.gmail.com>
 <CA+iem5uVJFcCYpJfhker-48XPrOf3a+NWr-nKnBtGmLX2yB_Lg@mail.gmail.com> <8736eiam8f.fsf@toke.dk>
In-Reply-To: <8736eiam8f.fsf@toke.dk>
From:   Kan Yan <kyan@google.com>
Date:   Wed, 20 Nov 2019 18:05:13 -0800
Message-ID: <CA+iem5tpfEmaWJ5Mw7xF9fb=XLceZpC1LM4Avo89Mn1fL7YZVw@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [PATCH v8 0/2] Implement Airtime-based Queue
 Limit (AQL)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Dave Taht <dave.taht@gmail.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kevin Hayes <kevinhayes@google.com>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Yibo Zhao <yiboz@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> It would be interesting to get some samples of the actual sojourn time
> as seen by CoDel in mac80211. Might be doable with bpftrace...

I will try to add some trace event to get the sojourn time for the
next round of tests.


On Wed, Nov 20, 2019 at 2:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Kan Yan <kyan@google.com> writes:
>
> >> Those were lovely, thanks!!!! Big win. Since you are on patch v10
> >> now.... Any chance you could turn ecn on and off and give it a go
> >> again in your next test run?
> >>
> >>
> >> Also:
> >>
> >> --step-size=3D.04 --socket-stats # the first is helpful to gain more
> >> detail, the second as to the behavior of the tcp stack.
> >
> > Thanks for the feedback! I will do more tests in a few days.
> >
> >
> >> Secondly - and AFTER this patchset stablizes, I'd like us to look into
> >> returning the codel default to 10ms or less
> >> from it's currently 20ms or worse setting. Tis another easy test
> >
> > Smaller CoDel "target" doesn't work well with wireless because the
> > dequeue behavior in wireless driver is very bursty. It is quite often
> > dequeues dozens of packets in one burst after one large aggregation is
> > completed, so smaller CoDel "target" can cause unnecessary packet
> > drop.
>
> It would be interesting to get some samples of the actual sojourn time
> as seen by CoDel in mac80211. Might be doable with bpftrace...
>
> -Toke
>
