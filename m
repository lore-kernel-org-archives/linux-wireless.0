Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C7CEC282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0783F20857
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfDPJdG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:33:06 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46805 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfDPJdF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:33:05 -0400
Received: by mail-ed1-f68.google.com with SMTP id d1so17252062edd.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 02:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5sjO9VUEA4jV3Bv8flGLRZyqgBp1fQYsWYycUrRpo4M=;
        b=H1wm+suHLhjv/26Hy77p4lehMaBITFs04dg+4TMQjYwyyJxM+I0ChZ5SPI4Rq2nARw
         KNLzSyULTwmBBbDJtiHuNZmhBSc9GDNpW8mgcz5OTj4fXbZF/vutHPFCbLuN+bCLcfKB
         CC7uqrsE/jIO3hVbHNM7mLlyO6F0mJlU2n9+7HEN+bWBHfpsDqejVGctOuR/kG1qJ7CX
         w/mwb1HhAelNBqnUD0MjBFYsFZ9Fk28XfJJ2wjcoZjhh+IWJD27Je5mfcflWLMRP6Sok
         rut1Ss2swddAfKZ0r72wInXXRHJ7AsEQhFx1hTuKOu4Y7C66i2ZorpZI/5tj94VMbImq
         DBuQ==
X-Gm-Message-State: APjAAAWDELuMdF/UMkhtEi8hEAX+hGvpA9dOdAWcfWIR0wV/T/vglJJC
        iNLi90b51hdf0QW8V/um3wZdpQ==
X-Google-Smtp-Source: APXvYqzXD5Hsyy7+/YQpZasOOkAMIF3+VzFFq/NMyWxIQvCdVAoRx1M5g83uMfAc8QuG40D6T8/Y+Q==
X-Received: by 2002:a50:be06:: with SMTP id a6mr30026274edi.254.1555407184145;
        Tue, 16 Apr 2019 02:33:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s14sm5266645eda.26.2019.04.16.02.33.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 02:33:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EF2291800E8; Tue, 16 Apr 2019 10:33:01 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
In-Reply-To: <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
References: <20190316170634.13125-1-nbd@nbd.name> <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk> <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com> <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au> <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com> <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au> <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Apr 2019 10:33:01 +0100
Message-ID: <87ef62uwfm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2019-04-16 at 16:36 +0800, Herbert Xu wrote:
>> On Tue, Apr 16, 2019 at 10:04:24AM +0200, Arend Van Spriel wrote:
>> > 
>> > I was just writing up an email clarifying my question. But let me summarize
>> > this email thread. The patch from Felix adds this flag in mac80211 for
>> > drivers that indicate to support pulling packets from the internal TXQ in
>> > mac80211. I found it is deprecated, but as Felix mentioned it is used in
>> > various parts of the network subsystem, ie. batman-adv, bridge, vlan, tunnel
>> > implementations. So its use seems to be restricted rather than deprecated.
>> > Given your response above I guess my question would be to get details about
>> > what you call "proper design" as I think you are saying with that it is not
>> > needed, right?
>> 
>> Essentially the only time it would be OK to use LLTX in its current
>> form is if you have no TX queue/congestion feedback which is clearly
>> not the case with wireless drivers.
>
> It is true because we have an entire buffering layer in mac80211 (in
> this case at least) and never push back to the stack.

I'm wondering if we should be? For instance, fq_codel returns
NET_XMIT_CN if it drops a packet from the same flow that it enqueued to.
We could conceivably do the same in mac80211, although we'd have to
carry the return value out through quite a few layers. Not sure if this
is worth it?

Eric, do you have any insight into what impact the _CN return has from
fq_codel?

-Toke
