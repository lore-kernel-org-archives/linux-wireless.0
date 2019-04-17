Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F64C282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDE2B2173C
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbfDQJ0G convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:26:06 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42886 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfDQJ0F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 05:26:05 -0400
Received: by mail-ed1-f65.google.com with SMTP id x61so20338340edc.9
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 02:26:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=kAlJ1TRnp64iVXKnwiKKBDLZ/BKMMFs5olzaVVrDTbs=;
        b=NicrfbqsdtqlHmg+zZ8NPyvT5vmGGC2s5oqT9JI39ha6q6ALA8ovxXiq2jkHxpdRlG
         7TxYSK96x5p3JRAMPLzIU/V7KLrUsRowTJdwfNdIfC2QQ2ujM3E1BGynM6EO9kZI3AWY
         +XIL9Sg0H6X6nqc1i2yM1Wi37Juo6tArajAnFMI37Xw5wQHyTXXiNo5t7Eomi+x/xIXq
         atoJUJwXUMQo/sZfMEZRgJTO71+ZalODoN3CwkfcjT0xrlTs/PeYM4sJbPcI+G/JL7x1
         U3Ibtfb47o3S1cMTV5GnUiOx7iObJP9FEMuTz9X37nXzF6WtIn9R2moyhC7f+3ebFh0r
         /+wg==
X-Gm-Message-State: APjAAAVDx894uqot7ETgjog2ZSCBcLSMWTxVYaUEbwoJgOQrPMDe3IkR
        xqvddphicWGqCtfeKNb+uw9q5w==
X-Google-Smtp-Source: APXvYqyWNhfDt5BzBztOX+H1/vrM2+tt6TcIUfHquVr3CpZUo8AENV/RelnxECZJjizJ/sMuO7ot8g==
X-Received: by 2002:a17:906:f91:: with SMTP id q17mr46082730ejj.63.1555493164142;
        Wed, 17 Apr 2019 02:26:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id d6sm4270973edq.65.2019.04.17.02.26.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 02:26:03 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 029C21800E8; Wed, 17 Apr 2019 10:17:09 +0100 (+01)
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
Date:   Wed, 17 Apr 2019 10:17:09 +0100
Message-ID: <87tvexrnxm.fsf@toke.dk>
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

Also, looking at udp.c, it seems it uses net_xmit_errno() - which means
that returning NET_XMIT_CN has the same effect as NET_XMIT_SUCCESS when
propagated back to userspace? Which would kinda defeat the point of
going to the trouble of propagating up the return code (the mac80211
queue will never drop the most recently enqueued packet)...

-Toke
