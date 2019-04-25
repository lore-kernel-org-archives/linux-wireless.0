Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E425CC282E3
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B452020578
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfDYIkA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 04:40:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55524 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfDYIkA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 04:40:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJZv7-0005Lx-UC; Thu, 25 Apr 2019 10:39:54 +0200
Message-ID: <0190c32f3d861d9d7a783090653645c5ae3a7fa3.camel@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Date:   Thu, 25 Apr 2019 10:39:52 +0200
In-Reply-To: <20190425083558.p3kqodaawr2jcfhr@gondor.apana.org.au>
References: <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
         <87ef62uwfm.fsf@toke.dk>
         <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
         <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au>
         <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
         <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
         <87wojut7f7.fsf@toke.dk>
         <20190417033834.ep6t7r6ttvjek5g7@gondor.apana.org.au>
         <87tvexrnxm.fsf@toke.dk>
         <99da695257304d32b65e2db8b7ada06759087c90.camel@sipsolutions.net>
         <20190425083558.p3kqodaawr2jcfhr@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-25 at 16:35 +0800, Herbert Xu wrote:
> On Tue, Apr 23, 2019 at 02:41:33PM +0200, Johannes Berg wrote:
> > 
> > I guess there might be value in returning NET_XMIT_CN anyway, but I
> > think you're right in that we can never return anything but
> > NET_XMIT_SUCCESS or NET_XMIT_CN since we never drop this new packet,
> > just older ones.
> > 
> > Which, btw, is exactly the same with net/sched/sch_fq_codel.c, AFAICT?
> 
> Pretty sure codel does return NET_XMIT_CN.

Yes, that's what I meant, it can only ever return NET_XMIT_SUCCESS or
NET_XMIT_CN. This will not trigger the code you mentioned before though.

johannes

