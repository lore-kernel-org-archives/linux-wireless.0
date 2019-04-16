Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB28EC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990A12073F
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfDPHo4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:44:56 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:44530 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbfDPHo4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 03:44:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hGIls-0000C2-JG; Tue, 16 Apr 2019 15:44:48 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hGIlo-0008Ao-MH; Tue, 16 Apr 2019 15:44:44 +0800
Date:   Tue, 16 Apr 2019 15:44:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
Message-ID: <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name>
 <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Apr 14, 2019 at 11:44:17AM +0200, Arend Van Spriel wrote:
> + Herbert
> 
> On 3/16/2019 7:14 PM, Toke Høiland-Jørgensen wrote:
> > Felix Fietkau <nbd@nbd.name> writes:
> > 
> > > When using iTXQ, tx sequence number allocation and statistics are run at
> > > dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, which
> > > allows tx handlers to run on multiple CPUs in parallel.
> > 
> > Cool, didn't know about that flag.
> 
> It is water under the bridge as this patch got applied already, but I
> stumbled upon it just recently and didn't know about that flag either. So I
> looked for more information about it and found the definition [1], but the
> comment seemed important enough to send this reply.
> 
> 	NETIF_F_LLTX_BIT,	/* LockLess TX - deprecated. Please */
> 				/* do not use LLTX in new drivers */

The most obvious problem with LLTX is that it can cause AF_PACKET
to see packets twice.  But the more subtle issue is that with a
proper design this lock should have no contention anyway.

So please explain why you want to use this in your driver and where
the contention is coming from?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
