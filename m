Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8016AC282E1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D453218AD
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 08:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfDYIts (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 04:49:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55690 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfDYIts (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 04:49:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJa4d-0005ey-HY; Thu, 25 Apr 2019 10:49:43 +0200
Message-ID: <bf9053f2675959f966453b999b71f9446ad8eba2.camel@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Date:   Thu, 25 Apr 2019 10:49:42 +0200
In-Reply-To: <20190425084428.poni4y7mqox5up5t@gondor.apana.org.au>
References: <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
         <20190416093707.dtlwcmitzqopaeaw@gondor.apana.org.au>
         <e4c1a3ca0c0c160b7c271ab83deebcf096f38497.camel@sipsolutions.net>
         <20190416131346.u2uolljlrd5t2jro@gondor.apana.org.au>
         <87wojut7f7.fsf@toke.dk>
         <20190417033834.ep6t7r6ttvjek5g7@gondor.apana.org.au>
         <87tvexrnxm.fsf@toke.dk>
         <99da695257304d32b65e2db8b7ada06759087c90.camel@sipsolutions.net>
         <20190425083558.p3kqodaawr2jcfhr@gondor.apana.org.au>
         <0190c32f3d861d9d7a783090653645c5ae3a7fa3.camel@sipsolutions.net>
         <20190425084428.poni4y7mqox5up5t@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-25 at 16:44 +0800, Herbert Xu wrote:
> On Thu, Apr 25, 2019 at 10:39:52AM +0200, Johannes Berg wrote:
> > 
> > Yes, that's what I meant, it can only ever return NET_XMIT_SUCCESS or
> > NET_XMIT_CN. This will not trigger the code you mentioned before though.
> 
> You are right that it does not.  However, the fact that this
> congestion indication is lost is a bug rather than a feature.

You can argue that way, I guess.

However, *any* queue management algorithm that doesn't *solely* employ
tail drops will necessarily behave this way.

I would argue that you get better queue management if you don't solely
rely on tail drops, so I'd rather pick better queue management than this
(relatively obscure) congestion notification. The more commonly relevant
socket buffer size will work for both.

johannes

