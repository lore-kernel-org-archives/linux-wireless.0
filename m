Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D2EC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DC7E20835
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731303AbfDQIgF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:36:05 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40611 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728815AbfDQIgF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 04:36:05 -0400
Received: by mail-ed1-f66.google.com with SMTP id d46so15422125eda.7
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 01:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=VYXPLMzS2L3NEuIvF9Zqlc1sEufo5VsP3GxfWStSls8=;
        b=PftAAwfszWJIjs/ApTVIbudOTrvX7mZc49+Wbznz+kg3lTY272tphAKhKM1Oq+NH/c
         GMg45x67ZPdPZM8Pzh1GY9mNODVij1xtN+soxGHL0H2y1JUPSZEay3VhreVkRsepJA8/
         6VH4h89UT+rHXTKz2B08zgDXEUxvH8bVcjavk70+EBZLzOqoG1ApQeUqAwAfNRTCkj2e
         bbJj8mKGrQKLIxsFqH6BMpfbqyZLh8FiOECMNT1DzoAniBqwLk0gyO4Xu5ujGIQjo3U/
         3DbQdWtPkCvr4nBrl2d88MS9LS6JesRXxUGwrDzg8JBgDcar4k/UJgVmZ+Nrb+37QYUO
         8AOg==
X-Gm-Message-State: APjAAAVXS3xxOPK1xiFyIBnDJlZMyBj2F4ydNu4E5AWyHe/J3SrhvDTp
        aFSfLZ+5z/8MBqiQfuYIN7tGXQ==
X-Google-Smtp-Source: APXvYqxh0PhqZpa6jlQPf4fzPGwI/6lognZO7+QlqTeirQgTEz+ZDQwQr/HJHFoK20EYOM1QwrAEGQ==
X-Received: by 2002:a17:906:8247:: with SMTP id f7mr45679482ejx.216.1555490163423;
        Wed, 17 Apr 2019 01:36:03 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id i9sm6157988edk.56.2019.04.17.01.36.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 01:36:02 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D589B1800E8; Wed, 17 Apr 2019 09:28:51 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
In-Reply-To: <20190417021101.5a32gox2ivbcgsbp@gondor.apana.org.au>
References: <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com> <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au> <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com> <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au> <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net> <87ef62uwfm.fsf@toke.dk> <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net> <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au> <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net> <8736miuv1x.fsf@toke.dk> <20190417021101.5a32gox2ivbcgsbp@gondor.apana.org.au>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 17 Apr 2019 09:28:51 +0100
Message-ID: <875zrdt4qk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Tue, Apr 16, 2019 at 11:02:50AM +0100, Toke Høiland-Jørgensen wrote:
>> 
>> As explained at great length here:
>> https://www.usenix.org/conference/atc17/technical-sessions/presentation/hoilan-jorgesen
>> (you already know that of course, Johannes)
>
> I can understand that wireless needs its own queueing scheme, but it
> still seems wrong to place that under net/mac80211 as opposed to
> having it as a first-class citizen under net/sched.

This is because we need to resolve the MAC-layer destination station (or
rather, TID) and tie the queueing to that, because of aggregation. We
also use the queueing structure for scheduling stations to achieve
airtime fairness. Both of these would be decidedly non-trivial to pull
up to the qdisc layer. Rather, having them in mac80211 means drivers
don't need to do their own ad-hoc queueing (which was the case before,
leading extra bufferbloat).

Most of the actual queueing structure code lives in
include/net/fq_impl.h, though, so it's not actually that
mac80211-specific. I've been thinking about porting the relevant qdiscs
to use the same code, but I'm not sure that it's worth the trouble.

-Toke
