Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601D6C282E3
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 09:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F468214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 09:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfDYJIA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 05:08:00 -0400
Received: from [5.180.42.13] ([5.180.42.13]:52700 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfDYJIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 05:08:00 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hJZrO-000355-Qa; Thu, 25 Apr 2019 16:36:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hJZrK-0002Cg-TB; Thu, 25 Apr 2019 16:35:58 +0800
Date:   Thu, 25 Apr 2019 16:35:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
Message-ID: <20190425083558.p3kqodaawr2jcfhr@gondor.apana.org.au>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99da695257304d32b65e2db8b7ada06759087c90.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 23, 2019 at 02:41:33PM +0200, Johannes Berg wrote:
>
> I guess there might be value in returning NET_XMIT_CN anyway, but I
> think you're right in that we can never return anything but
> NET_XMIT_SUCCESS or NET_XMIT_CN since we never drop this new packet,
> just older ones.
> 
> Which, btw, is exactly the same with net/sched/sch_fq_codel.c, AFAICT?

Pretty sure codel does return NET_XMIT_CN.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
