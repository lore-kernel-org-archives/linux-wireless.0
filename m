Return-Path: <SRS0=pq45=YD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2288FC4360C
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Oct 2019 20:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6F15214E0
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Oct 2019 20:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hraeavYl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJJUMK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Oct 2019 16:12:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35042 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725867AbfJJUMJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Oct 2019 16:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570738328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hhyg87nnGfeTsVzFBM5AQicPju/uAVCwWvYhzmC0GBw=;
        b=hraeavYlGkBAgzieohU7jjMVhVS1L5GtTWQUSL5TE9gNT0CG8koA9YJ/zRrJGCr9rHNoIW
        0L8UtAGuWCOBMKGpGm5L+h+6/97NnF80UoFb1Ypywx2Q6L8WCjpn0Qan4jygGbmUFdeYQs
        YXykf+CGui4nqKCGzOuqAYOmYjaQ/7o=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-zbkrrsm1P_aEMIGOIeWN9g-1; Thu, 10 Oct 2019 16:12:07 -0400
Received: by mail-lj1-f198.google.com with SMTP id x13so1244846ljj.18
        for <linux-wireless@vger.kernel.org>; Thu, 10 Oct 2019 13:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Hhyg87nnGfeTsVzFBM5AQicPju/uAVCwWvYhzmC0GBw=;
        b=VacmToj3MTiDuKbPASSAW0n8qw8/NTSDqRbuGBOeclGcBAJTuBeonoijxZZeKLXRNK
         Q6mZ8WGqSQQJikAlzV+Lu7l1vWeTU9dv5xlmCOOiU1BPjO3ITEeZYyXHAytjemvDxt+i
         5+11qU5VsQo23cox7uFdbJfaaagnLE34PQGkgXPh+oZVIKN/9WUJIxaWRaEfq9QO/G6v
         5wLmwitNwkmSJJuir5ZySIUheFLG0IySeaSRV/JRIEcm4t695SgBh4XYloc8x1elYiH4
         mFsSN12A/J99CESE6eWE6yosLhyR+p0LaK/138dylk8jR8FZSOn8hINGsWaLKMi7n1MG
         Rnog==
X-Gm-Message-State: APjAAAWeAtxaD6QgYnmZd92PSQogLVrzDE5+GG7UAY9KmUhzWe2FD/De
        LXA+ciuRWkPn2ks0chRdYsp7WURsPwWlTdFHJAfHnoMcGcoFMfnYkbW7Vcc9EBEFR8pTREvSlUe
        9EtbuT+DjOIDx0BD2yjtMg79x7gs=
X-Received: by 2002:ac2:43d9:: with SMTP id u25mr7258262lfl.142.1570738325646;
        Thu, 10 Oct 2019 13:12:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxttgSBDbiQ/AtjJb2ynuVWRmt+n7NwNsTfIRQfQEa39kbak+pVlQfDx4wA8MD0fn3vPX2tJw==
X-Received: by 2002:ac2:43d9:: with SMTP id u25mr7258254lfl.142.1570738325476;
        Thu, 10 Oct 2019 13:12:05 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id y22sm1590921lfb.75.2019.10.10.13.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 13:12:04 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B6EEF18063D; Thu, 10 Oct 2019 22:12:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kan Yan <kyan@google.com>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, nbd@nbd.name,
        ath10k@lists.infradead.org, yiboz@codeaurora.org
Subject: Re: [PATCH v3 1/2] mac80211: Implement Airtime-based Queue Limit (AQL)
In-Reply-To: <a2cc0ebecfb055c8b667db57d0469fe69054a69c.camel@sipsolutions.net>
References: <20191010022502.141862-1-kyan@google.com> <20191010022502.141862-2-kyan@google.com> <a2cc0ebecfb055c8b667db57d0469fe69054a69c.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 10 Oct 2019 22:12:03 +0200
Message-ID: <87ftk0jr70.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: zbkrrsm1P_aEMIGOIeWN9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi,
>
> A couple of points...
>
> First, I'd like Toke to review & ack this if possible :-)

Sure, I'll look at it. I'm away the rest of this week, but should
hopefully get some more time next week. It may be that it will take the
form of another submission that integrates this with the previous patch
I sent that put more of the calculation into mac80211 itself...

-Toke

