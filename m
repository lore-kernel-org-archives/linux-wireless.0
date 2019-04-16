Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1399FC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E183220652
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfDPJiZ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:38:25 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44511 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfDPJiZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:38:25 -0400
Received: by mail-ed1-f65.google.com with SMTP id i13so6599727edf.11
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 02:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=u3Wnch/kp/JrEWHGJ4nMKuOid2a8kLUM6nGYjqvtYGE=;
        b=GRnojMuuLC+mJlTKciBGmDHhJItLFE4qkgsVBSE83Xnz1gEcUR6I5Zuu0kLRZ6oGQI
         7bcPx1lf3FwmoZ+E0hdGtwdjSJYAX1WPNVZAGKWH4rEVIS3w66Ps2AQHPHC3xkQ5E8H6
         8dcsUA9/tHQgEA1QD4HawePn/eYGd86dHxjwr6nlXSfCCeJAUyWGkE3m/lpXCmwLEpza
         Oe2irFVDpSsQoXVttsvpb97YCwOw0y+XCsZ+PHfssDrTQ1FBhR5bpO6Qq9ePqABFX7lZ
         csaqw1Y2hnaKDW5jpVS9HjC+6kWuhpaI66nifGQkrC/uTdusoQBoaOvFuZPQSVXKnxpx
         UpfQ==
X-Gm-Message-State: APjAAAUoB7NSmzxohmuy1e0wy19RVXy3mGeypvC+ZABQEa2boiaY6/BY
        KB8fGwe+GbKFGROzi4VFXJUhSw==
X-Google-Smtp-Source: APXvYqwHIKlcWZ6RRv69FtlTD2oc7noS/Z3/UDVaXbulhbSsA2rREkk/tVfu+lljDCAGONZD8nMZhA==
X-Received: by 2002:a17:906:a2c6:: with SMTP id by6mr43394927ejb.134.1555407504039;
        Tue, 16 Apr 2019 02:38:24 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id x18sm4414282ejd.66.2019.04.16.02.38.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 02:38:23 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4B03F1800E8; Tue, 16 Apr 2019 10:38:22 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
In-Reply-To: <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
References: <20190316170634.13125-1-nbd@nbd.name> <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk> <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com> <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au> <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com> <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au> <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net> <87ef62uwfm.fsf@toke.dk> <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Apr 2019 10:38:22 +0100
Message-ID: <878swauw6p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2019-04-16 at 10:33 +0100, Toke Høiland-Jørgensen wrote:
>> 
>> > It is true because we have an entire buffering layer in mac80211 (in
>> > this case at least) and never push back to the stack.
>> 
>> I'm wondering if we should be?
>
> I don't think so? We'd just buffer packets in yet another place.

Wouldn't we get pushback all the way to the application socket? I.e.,
an UDP application would get sendto() failures?

-Toke
