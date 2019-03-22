Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB30C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 20:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F40CD2190A
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 20:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibsgaard-io.20150623.gappssmtp.com header.i=@ibsgaard-io.20150623.gappssmtp.com header.b="O40CKOXo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfCVUkQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 16:40:16 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:35440 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbfCVUkQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 16:40:16 -0400
Received: by mail-it1-f195.google.com with SMTP id w15so5466245itc.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 13:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ibsgaard-io.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3RYrlJBAd5RXJNAy7UusN4Ej4akzvmGng0DULBeetKc=;
        b=O40CKOXowM+h+qpXlwj7kzAP9j/Enpm2VPNarJOY/OGvX+FqGMZ2jvnw8pgaSHXKGK
         ZKfUdS2KacXCLylwu+y+WbyTX8djR4XhO8Qho5ovDX52LwHn5TCsZ8EsDS9gwY6m5nm9
         ConrscDFQUDEK9Qo8avtcoAYTsVV8NgjuZISBCGaJnCVUHKM/TWGgnXTIQk+pRB78CjV
         0sZ6k28iampexR1Dff7lfwJfwxhnVinN5SW4q8C81ZorJg6YMEb87x+t4MI7ZsZFMiKm
         bcoBINAffoo+UzygzCSeYawDXFIM5qsZhwxvGRux446XDmG7DtqiZQgtqOLbzpzBQ4Rx
         JxMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3RYrlJBAd5RXJNAy7UusN4Ej4akzvmGng0DULBeetKc=;
        b=L7Pi1S02xQVr6JA9HyqlM9w4lF5Cgv6BVoScLb+ICzbw847vsPFDMP1whC+nvfef4s
         Hfqs8SPiII41iOGvpVI1VjLOC83JMsjxKxrgBYmV8mvLAhwZFCUsRi1KcwR+hePwKlfn
         TGh6S6eSeMkYoJU2IVius1HdDZG/H4nrqjNlX/KgXbpipvxj5o8VX7ieD9WeADADu+T7
         1CiYA8kcuBHGyKi5jt5wcy43Y9Hvn/Vd/d+PKdiQH/YUWXKKaVRMWETPVJKS/B75+1Rk
         HoyCpotNy99P+XMERbBtV/51Xr1XbTZkn3sB0pMvu10Tvlxbcj+FARKNEf6NEvKufRWA
         a1jw==
X-Gm-Message-State: APjAAAVtSTj+Sfcnj8hr1J5IpcE0o1E0SGUdYA5NCnX5RzFgVYvhj6UL
        JgrmvSivF9beq8Gafjg73rbEwJvQRvN1+gj6G+QsvetH
X-Google-Smtp-Source: APXvYqwbbOpIMYLvGHnmBxJiLFQGgmuDcPV5KHZpQ6XrbJep5XReEZ2iY4cK0Vao+d2qfvhwwptk5SZZ9yey2ZVVYf8=
X-Received: by 2002:a24:75c7:: with SMTP id y190mr693217itc.108.1553287214856;
 Fri, 22 Mar 2019 13:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com>
 <83dad8c2478e141e382b02056389ba281bc72720.camel@sipsolutions.net>
In-Reply-To: <83dad8c2478e141e382b02056389ba281bc72720.camel@sipsolutions.net>
From:   thomas <thomas@ibsgaard.io>
Date:   Fri, 22 Mar 2019 13:40:04 -0700
Message-ID: <CABWD38kCrzns2RkShGDY6ip99fAFM3Ar_n6zDhk73KHxLTDbpQ@mail.gmail.com>
Subject: Re: preparing for 802.11ah channels
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 15, 2019 at 2:47 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Sat, 2019-02-16 at 15:45 -0800, thomas pedersen wrote:
> > Hello,
> >
> > I'm working on defining new channels for S1G PHYs in mac80211. These
> > are in the 900MHz range and center frequency for the 1MHz channels are
> > on a half MHz, while the existing channel definitions are in units of
> > MHz.
>
> Yay... :)
>
> > In order to support the new channels we could change the internal
> > center frequency units to KHz and extend the nl80211 API so
> > NL80211_FREQUENCY_ATTR_FREQ and NL80211_ATTR_WIPHY_FREQ get _KHZ
> > variants while renaming the original attributes to _MHZ to reflect the
> > units.
>
> The nl80211 API seems straightforward, yeah.
>
> > From looking at the code it looks like this should be fairly
> > straightforward, if involving a lot of changes since the driver
> > declarations would have to change too. Am I missing something
> > obviously wrong, or does this sound reasonable?
>
> I'm not sure I agree about all the driver changes being straightforward.
> In theory yes, but ... ;-)
>
> I guess you'd define a new band (NL80211_BAND_S1G or something?), so
> perhaps there's a way we can get away with doing it only on that band?
>
> OTOH, I guess if you change center_freq1 to center_freq1_khz or
> something then you compile-fail everywhere ...

Yeah it gets ugly quick to have additional freq_khz members,
especially when doing comparisons etc.

The kernel part was not too bad, there are only 3 structs or so to
worry about. hostap on the other hand is incredibly hairy :)

Thomas
