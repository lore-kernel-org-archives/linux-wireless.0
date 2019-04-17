Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF2FC282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D0C206B6
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbfDQJJW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:09:22 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35681 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbfDQJJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 05:09:21 -0400
Received: by mail-ed1-f66.google.com with SMTP id y67so7044785ede.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 02:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=18lFKbOS/U/l2KDx3Fo/rQIZJiYwPqExpBDpziDRRWY=;
        b=DbMR3VMGi9EeOVhDY/yGO2ECVLinSJKex5AYqZXeU87s3SDjBpjOguUPZeyf0CWTyW
         MYVFFPSX/0FrGfxzjFlvLKXBEThPyrjQIDP90lMRmRtPajpPelXGBSCvPz27r4UFh+id
         i5gArV8spGcoglFjmObD/Pie3oa2DKuXgmScp2Xkf65d/oGcjwTw5BzfdTmauqZYS9SQ
         /XdpiySOLa3tS0BLmACXsqiyjnIA7G1wMz6pnH3bM7Sj44zDTAF7MwlSw8re43vkOXM+
         mB+t671veFOUypmrLkMd2zFlLmTtYuGofzAb+BLzOkR9iuXpvNm61WOK54cJYpZbqBXj
         HmZg==
X-Gm-Message-State: APjAAAWs0jt48eC0W/CZkIETmHUU9ymmCblhVWKHqklmiYktbz71Oade
        LU8hA4Z0YNX0MEss5KfsYJ+mIg==
X-Google-Smtp-Source: APXvYqzwFtHksBnQP0ztuTpYs4FLfY9HwhGEXQByGUZAGvWn8UHv5k+fC+5CsUHfTY4PABgLrBxVSw==
X-Received: by 2002:aa7:da92:: with SMTP id q18mr4432820eds.223.1555492159781;
        Wed, 17 Apr 2019 02:09:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id bq15sm10185970ejb.12.2019.04.17.02.09.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 02:09:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 128601800E8; Wed, 17 Apr 2019 10:09:17 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
In-Reply-To: <20190417033834.ep6t7r6ttvjek5g7@gondor.apana.org.au>
References: <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au> <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com> <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au> <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net> <87ef62uwfm.fsf@toke.dk> <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net> <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au> <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net> <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au> <87wojut7f7.fsf@toke.dk> <20190417033834.ep6t7r6ttvjek5g7@gondor.apana.org.au>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 17 Apr 2019 10:09:16 +0100
Message-ID: <87wojtroar.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Tue, Apr 16, 2019 at 02:18:36PM +0100, Toke Høiland-Jørgensen wrote:
>>
>> > The congestion control happens at two levels. You are right that the
>> > socket buffer acts as one limit. However, other applications may also
>> > rely on the TX queue being full as the throttle (by setting a
>> > sufficiently large socket buffer size).
>> 
>> Do you happen to have an example of an application that does this that
>> could be used for testing? :)
>
> Have a look at
>
> commit 6ce9e7b5fe3195d1ae6e3a0753d4ddcac5cd699e
> Author: Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Wed Sep 2 18:05:33 2009 -0700
>
>     ip: Report qdisc packet drops
>
> You should be able to do a UDP flood while setting IP_RECVERR to
> detect the packet drop due to a full queue which AFAICS will never
> happen with the current mac80211 setup.

Yup, got that part. Was just wondering if you know of any applications
that already do this, that I could test without having to write my
own... :)

-Toke
