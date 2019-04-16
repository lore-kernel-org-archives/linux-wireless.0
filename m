Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B364FC282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 13:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C41C20870
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 13:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfDPNSl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 09:18:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38708 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDPNSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 09:18:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id d13so17871241edr.5
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 06:18:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=T31j8dSLULl0ZPjhVbp1/+FqUaiH1+Chf65fzKw/kRA=;
        b=k3eXKLEZRgJWc2ZmPY3f3fXQ4CstaWksKB/5HhlNU/dH3VAb/gt0RDjMECx6x1ZAOR
         L8gm1WY6ELaYwI0/aHGfN48ShrViOGxFVytJ5w9EPkcbOVfH3iOpoF1wXohNV9Bjtvz0
         3F4ZZoArvuJSXdOv6tgGmmlVKTdPPjOzEA8EyMlapb9oEBS/KNtdfC3K8LZkVPyTWZ1i
         jmx1aBXaX9XQelhOZs/wZ+yfwBQ11aS8Ogg35XZh4pqxS8fXSxXDaWitSYNj3PcLnVKw
         Cu6eg1eBWwoS0hX7W7BcamsR2YZ6LHk0WYViOev5C44PI9G7keqXBMSIYFQ5/9PxhUXS
         K5MA==
X-Gm-Message-State: APjAAAUHaHKJD+NJri1Y/Hs1mIxqcEz3mNjZLWvcDFWH9SOdI8i+l02N
        T0Ecf0IwpR+ZtDE3e7KGqJLFrw==
X-Google-Smtp-Source: APXvYqyM8anSG6SXYY9V8F/M/y/bhHbPW2PK/ZYj9qtAW7j4PQmrJD8BMSH4p32QyajtdSbTXWhNUA==
X-Received: by 2002:a17:906:a291:: with SMTP id i17mr3972663ejz.180.1555420719116;
        Tue, 16 Apr 2019 06:18:39 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d6sm3477760edq.65.2019.04.16.06.18.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Apr 2019 06:18:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C2E391800E8; Tue, 16 Apr 2019 14:18:36 +0100 (+01)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
In-Reply-To: <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
References: <87sgvmvg9g.fsf@toke.dk> <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com> <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au> <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com> <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au> <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net> <87ef62uwfm.fsf@toke.dk> <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net> <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au> <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net> <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 16 Apr 2019 14:18:36 +0100
Message-ID: <87wojut7f7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Tue, Apr 16, 2019 at 11:39:56AM +0200, Johannes Berg wrote:
>> 
>> > not to mention
>> > breaking certain applications that rely on congestion feedback?
>> 
>> This I don't understand. The congestion feedback happens through socket
>> buffer space etc. which is still there (as long as nobody sneaks in an
>> skb_orphan() call)
>
> The congestion control happens at two levels. You are right that the
> socket buffer acts as one limit. However, other applications may also
> rely on the TX queue being full as the throttle (by setting a
> sufficiently large socket buffer size).

Do you happen to have an example of an application that does this that
could be used for testing? :)

-Toke
