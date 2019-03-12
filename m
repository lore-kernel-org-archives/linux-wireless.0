Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD996C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 18:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E1E1206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 18:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ky8FfZ6k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbfCLSrw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 14:47:52 -0400
Received: from mail-oi1-f176.google.com ([209.85.167.176]:45158 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfCLSrw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 14:47:52 -0400
Received: by mail-oi1-f176.google.com with SMTP id t82so2953138oie.12
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 11:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nDpfcPjNrMM7TDhzeStytHgdWqvyxKAN5oLo7QiK3GI=;
        b=ky8FfZ6kEPq2eP32VKFX5m/iXrrm6JzSRAsxYuLyLhzwIyWiT5CvBFhoXVZdomgify
         YtV92QHsUbkZma5SP4ZKNbYlBOTsIaHLOhKIv6ewNXyrvND64xszyIHHmRYRKHfFQrkU
         +/1y73rYCBVjIVopjyPRzCg3djWg3SS/xU5fvKDVubNOAO6khr8BN6eyH2iiU4y08ABa
         O8lelJFqFUazE206FdGAKIHcQKOs328RQ7l+WAtiP8Wo+ejgpHc+YdXMOmSF78cI8SDE
         Edvj1kL0ga14v7+IiPTY4bUENJ4hUT1rsLxw5fB6z2sMPUb/HGqfglFA6x2VlKyIToGw
         3jYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nDpfcPjNrMM7TDhzeStytHgdWqvyxKAN5oLo7QiK3GI=;
        b=besdfPmV9Ksd5lDP9i1lchkWxasmgf7GqjybG6+CESus82R3V3b1aQ1GVzjq4QZvcD
         /I6qN4N7IYS8y1qbZ02cm6O3FG0UFfkIChR4uE2q81aZZQ49g/KGUfIjfIu0LwlIZ4tQ
         +3jXvi6GzvKX+CSOKJYaHX5pSqQBfgHONHG0La75aWK1BlUEHiDJYV2Xr9Kns1PscHN7
         JUhQ2pGJMCmqNQA3eGeipjlhTXGMLgJUewaqY95oEoxrGkLpYLAMPDyzcqcbrUVlorWZ
         IsuBo9LRhpcHJtEm0g6SpxqNeSpJLmF8jRLvUrP5R0Mg5r7HeFg4inyK6tJSgWTfNGlJ
         rKHQ==
X-Gm-Message-State: APjAAAWffUqYkZ/C8A29kGFduiAZJ8aFPQBqs1TsWGOWa0bo5IbJcP+b
        S0voB2TGMW1zJy2g3wlAHE9KbwoLEjGMY+BmP3/Ti+5H91Q=
X-Google-Smtp-Source: APXvYqzXjggm4Rtk8U5zrdOG6eCRna3NFZzsxyTxPzKg+Y4+65gh8skMD30jHH6F0e3JWvCvCE1KivaM8gDoif+db3o=
X-Received: by 2002:aca:c1c1:: with SMTP id r184mr2504091oif.146.1552416470971;
 Tue, 12 Mar 2019 11:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <f90f210372b8c7f7efae0c43ab3ae925c334bc0e.camel@sipsolutions.net>
 <871s3qn91h.fsf@toke.dk> <5d26367411cf2b50d4cf237640598d1952f17673.camel@sipsolutions.net>
In-Reply-To: <5d26367411cf2b50d4cf237640598d1952f17673.camel@sipsolutions.net>
From:   Kirtika Ruchandani <kirtika@google.com>
Date:   Tue, 12 Mar 2019 11:47:37 -0700
Message-ID: <CAOXD1idg8OisNL_+_-2CceZxZUmU1NbCQzJxnDh4kj-2sFNC4w@mail.gmail.com>
Subject: Re: wireless workshop coming soon :-)
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 1, 2019 at 3:12 AM Johannes Berg <johannes@sipsolutions.net> wr=
ote:
>
> On Fri, 2019-03-01 at 12:11 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
> > Johannes Berg <johannes@sipsolutions.net> writes:
> >
> > > Please add your favourite topics to
> > >
> > > https://wireless.wiki.kernel.org/en/developers/summits/prague-2019
> > >
> > > I've added a few I think we should discuss at this stage, so also see=
 if
> > > you have an opinion on those :-)
> >
> > Cool! Could we schedule the scheduling and airtime fairness topics afte=
r
> > 10:30? Have a tutorial to run in the morning and would obviously like t=
o
> > participate in those discussions ;)
>
> Yeah, I'm aware. I also have a conflict with the netlink workshop, so
> Kalle will have to take over for me some of the time :-)
>

More people may be interested in knowing what is being covered
at the wireless workshop until 10.30 so we can make a call on which
one to attend?
