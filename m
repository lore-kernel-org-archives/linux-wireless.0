Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BA7C282DA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32C6B20652
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbfDPJhS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:37:18 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:46906 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfDPJhR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:37:17 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hGKWb-00036f-U3; Tue, 16 Apr 2019 17:37:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hGKWa-0008MZ-1x; Tue, 16 Apr 2019 17:37:08 +0800
Date:   Tue, 16 Apr 2019 17:37:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
Message-ID: <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au>
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name>
 <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
 <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
 <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
 <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
 <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
 <87ef62uwfm.fsf@toke.dk>
 <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 16, 2019 at 11:33:50AM +0200, Johannes Berg wrote:
> On Tue, 2019-04-16 at 10:33 +0100, Toke Høiland-Jørgensen wrote:
> > 
> > > It is true because we have an entire buffering layer in mac80211 (in
> > > this case at least) and never push back to the stack.
> > 
> > I'm wondering if we should be?
> 
> I don't think so? We'd just buffer packets in yet another place.

But you do realise that you're giving up on the rich queueing
functionality that Linux provides (net/sched), not to mention
breaking certain applications that rely on congestion feedback?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
