Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF043C282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 02:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D2EE20872
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 02:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbfDQCLQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 22:11:16 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:51174 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbfDQCLP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 22:11:15 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hGa2U-0005PP-EZ; Wed, 17 Apr 2019 10:11:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hGa2P-000113-PW; Wed, 17 Apr 2019 10:11:01 +0800
Date:   Wed, 17 Apr 2019 10:11:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
Message-ID: <20190417021101.5a32gox2ivbcgsbp@gondor.apana.org.au>
References: <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
 <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
 <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
 <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
 <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
 <87ef62uwfm.fsf@toke.dk>
 <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
 <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au>
 <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
 <8736miuv1x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8736miuv1x.fsf@toke.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 16, 2019 at 11:02:50AM +0100, Toke Høiland-Jørgensen wrote:
> 
> As explained at great length here:
> https://www.usenix.org/conference/atc17/technical-sessions/presentation/hoilan-jorgesen
> (you already know that of course, Johannes)

I can understand that wireless needs its own queueing scheme, but
it still seems wrong to place that under net/mac80211 as opposed
to having it as a first-class citizen under net/sched.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
