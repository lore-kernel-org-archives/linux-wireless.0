Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F77C282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 19:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC4F12064A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 19:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbfDPTNe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 15:13:34 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:37918 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727647AbfDPTNd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 15:13:33 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hGTWA-0000Do-Lx; Tue, 16 Apr 2019 21:13:21 +0200
Message-ID: <8678e1a4eb816878867f71878e8fe7c225f1b7f7.camel@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Date:   Tue, 16 Apr 2019 21:13:16 +0200
In-Reply-To: <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
References: <87sgvmvg9g.fsf@toke.dk>
         <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
         <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
         <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
         <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
         <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
         <87ef62uwfm.fsf@toke.dk>
         <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
         <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au>
         <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
         <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-16 at 21:13 +0800, Herbert Xu wrote:
> On Tue, Apr 16, 2019 at 11:39:56AM +0200, Johannes Berg wrote:
> > 
> > > not to mention
> > > breaking certain applications that rely on congestion feedback?
> > 
> > This I don't understand. The congestion feedback happens through socket
> > buffer space etc. which is still there (as long as nobody sneaks in an
> > skb_orphan() call)
> 
> The congestion control happens at two levels.  You are right that
> the socket buffer acts as one limit.  However, other applications
> may also rely on the TX queue being full as the throttle (by setting
> a sufficiently large socket buffer size).

I'm not sure how they'd even realize this, other than packets getting
dropped? Which of course we do here as well, we didn't invent something
that let's us expand memory arbitrarily ;-)

johannes

