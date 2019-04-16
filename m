Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EBFC10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F3CD2073F
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:37:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfDPIhp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:37:45 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56142 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfDPIhp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:37:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hGJaz-0003Fv-As; Tue, 16 Apr 2019 10:37:37 +0200
Message-ID: <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date:   Tue, 16 Apr 2019 10:37:34 +0200
In-Reply-To: <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
References: <20190316170634.13125-1-nbd@nbd.name>
         <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk>
         <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
         <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
         <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
         <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-16 at 16:36 +0800, Herbert Xu wrote:
> On Tue, Apr 16, 2019 at 10:04:24AM +0200, Arend Van Spriel wrote:
> > 
> > I was just writing up an email clarifying my question. But let me summarize
> > this email thread. The patch from Felix adds this flag in mac80211 for
> > drivers that indicate to support pulling packets from the internal TXQ in
> > mac80211. I found it is deprecated, but as Felix mentioned it is used in
> > various parts of the network subsystem, ie. batman-adv, bridge, vlan, tunnel
> > implementations. So its use seems to be restricted rather than deprecated.
> > Given your response above I guess my question would be to get details about
> > what you call "proper design" as I think you are saying with that it is not
> > needed, right?
> 
> Essentially the only time it would be OK to use LLTX in its current
> form is if you have no TX queue/congestion feedback which is clearly
> not the case with wireless drivers.

It is true because we have an entire buffering layer in mac80211 (in
this case at least) and never push back to the stack.

johannes

