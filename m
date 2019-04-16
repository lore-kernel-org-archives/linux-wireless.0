Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DC1C282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 10:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2401206B6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 10:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfDPKCz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 06:02:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34064 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfDPKCy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 06:02:54 -0400
Received: by mail-ed1-f67.google.com with SMTP id a6so6108524edv.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 03:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6lECXrV1faWd8cZ0ssCQQiAMixFq35lEtPye/Ff+qzc=;
        b=p18e0eLHNLwvcL1+gXY6gujcxB4aNKJdxKQkuXLNA1z9Qu+CarheMz8pn5jTmPpX4e
         eEywXc6Et6uaWBluzUtfQiRGF4eZ4GkcpJK1zCuzQO6yLcLt3tk8ronb5r6j/zE6KNej
         x8LQHm6NMD/IsonTWeZLDidg8ha6KU0Z/XHmGMp2ecYlw3NdKQJlEBI1LicsZNIz6irK
         BgtzT8Gu+EY/ImGz9F7YznyViMXKEhzrUErea2y1C9rYXyBRlpPmkwadrOeew0K7nNhs
         jNrCMTnmRRMyGFEDhxz3yq6kiGJkj6xf4Awzdvae1eq7ZdtUTWIvbxhzd2SK/fMcxYVy
         fcnQ==
X-Gm-Message-State: APjAAAWpQj75UrBvwMh69oGe22nHxXsluJd8CyJrCSt14rDsAqqVTJIr
        vp3oywsuYzYQ1S/4A8YKSPZ9xA==
X-Google-Smtp-Source: APXvYqyyDA9B9sDhUwWD86x94LcqwzjpH6pnVBZcmOe2w9Y0eHCrcQ3MCXhJapvzWTj3KD3qAyhITQ==
X-Received: by 2002:a17:906:3e85:: with SMTP id a5mr44141442ejj.272.1555408973216;
        Tue, 16 Apr 2019 03:02:53 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id f58sm15849374edd.42.2019.04.16.03.02.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 03:02:52 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AE2CE1800E8; Tue, 16 Apr 2019 11:02:50 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
In-Reply-To: <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
References: <20190316170634.13125-1-nbd@nbd.name> <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk> <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com> <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au> <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com> <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au> <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net> <87ef62uwfm.fsf@toke.dk> <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net> <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au> <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Apr 2019 11:02:50 +0100
Message-ID: <8736miuv1x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2019-04-16 at 17:37 +0800, Herbert Xu wrote:
>> On Tue, Apr 16, 2019 at 11:33:50AM +0200, Johannes Berg wrote:
>> > On Tue, 2019-04-16 at 10:33 +0100, Toke Høiland-Jørgensen wrote:
>> > > 
>> > > > It is true because we have an entire buffering layer in mac80211 (in
>> > > > this case at least) and never push back to the stack.
>> > > 
>> > > I'm wondering if we should be?
>> > 
>> > I don't think so? We'd just buffer packets in yet another place.
>> 
>> But you do realise that you're giving up on the rich queueing
>> functionality that Linux provides (net/sched),
>
> Yes, that was a trade-off we always knew about. The model that Linux
> provides is just not suited for wifi.

As explained at great length here:
https://www.usenix.org/conference/atc17/technical-sessions/presentation/hoilan-jorgesen
(you already know that of course, Johannes)

>> not to mention
>> breaking certain applications that rely on congestion feedback?
>
> This I don't understand. The congestion feedback happens through socket
> buffer space etc. which is still there (as long as nobody sneaks in an
> skb_orphan() call)

Sure, for TCP, the TSQ mechanism should keep the upper-level queue low
as long as the SKBs are alive. But is this also the case for UDP?

-Toke
