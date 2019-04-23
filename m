Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0BBC282E1
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D80672175B
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfDWMlm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 08:41:42 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:32790 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfDWMll (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 08:41:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hIujv-0007rP-1P; Tue, 23 Apr 2019 14:41:35 +0200
Message-ID: <99da695257304d32b65e2db8b7ada06759087c90.camel@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Date:   Tue, 23 Apr 2019 14:41:33 +0200
In-Reply-To: <87tvexrnxm.fsf@toke.dk> (sfid-20190417_112604_778209_602EB19C)
References: <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
         <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
         <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
         <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
         <87ef62uwfm.fsf@toke.dk>
         <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
         <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au>
         <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
         <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
         <87wojut7f7.fsf@toke.dk>
         <20190417033834.ep6t7r6ttvjek5g7@gondor.apana.org.au>
         <87tvexrnxm.fsf@toke.dk> (sfid-20190417_112604_778209_602EB19C)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-17 at 10:17 +0100, Toke Høiland-Jørgensen wrote:
> Herbert Xu <herbert@gondor.apana.org.au> writes:
> 
> > On Tue, Apr 16, 2019 at 02:18:36PM +0100, Toke Høiland-Jørgensen wrote:
> > > 
> > > > The congestion control happens at two levels. You are right that the
> > > > socket buffer acts as one limit. However, other applications may also
> > > > rely on the TX queue being full as the throttle (by setting a
> > > > sufficiently large socket buffer size).
> > > 
> > > Do you happen to have an example of an application that does this that
> > > could be used for testing? :)
> > 
> > Have a look at
> > 
> > commit 6ce9e7b5fe3195d1ae6e3a0753d4ddcac5cd699e
> > Author: Eric Dumazet <eric.dumazet@gmail.com>
> > Date:   Wed Sep 2 18:05:33 2009 -0700
> > 
> >     ip: Report qdisc packet drops
> > 
> > You should be able to do a UDP flood while setting IP_RECVERR to
> > detect the packet drop due to a full queue which AFAICS will never
> > happen with the current mac80211 setup.
> 
> Also, looking at udp.c, it seems it uses net_xmit_errno() - which means
> that returning NET_XMIT_CN has the same effect as NET_XMIT_SUCCESS when
> propagated back to userspace? Which would kinda defeat the point of
> going to the trouble of propagating up the return code (the mac80211
> queue will never drop the most recently enqueued packet)...

I guess there might be value in returning NET_XMIT_CN anyway, but I
think you're right in that we can never return anything but
NET_XMIT_SUCCESS or NET_XMIT_CN since we never drop this new packet,
just older ones.

Which, btw, is exactly the same with net/sched/sch_fq_codel.c, AFAICT?

johannes

