Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A34C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5453E20651
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 09:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbfDPJd4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 05:33:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56812 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfDPJd4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 05:33:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hGKTQ-0004NK-0C; Tue, 16 Apr 2019 11:33:52 +0200
Message-ID: <95f86cf69dee05a176625925657cf0df0e97b5c9.camel@sipsolutions.net>
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Date:   Tue, 16 Apr 2019 11:33:50 +0200
In-Reply-To: <87ef62uwfm.fsf@toke.dk> (sfid-20190416_113304_931802_4A5932B5)
References: <20190316170634.13125-1-nbd@nbd.name>
         <20190316170634.13125-5-nbd@nbd.name> <87sgvmvg9g.fsf@toke.dk>
         <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
         <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
         <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
         <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
         <eab39dd804405854997e50102f3d0ff925feb8d2.camel@sipsolutions.net>
         <87ef62uwfm.fsf@toke.dk> (sfid-20190416_113304_931802_4A5932B5)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-16 at 10:33 +0100, Toke Høiland-Jørgensen wrote:
> 
> > It is true because we have an entire buffering layer in mac80211 (in
> > this case at least) and never push back to the stack.
> 
> I'm wondering if we should be?

I don't think so? We'd just buffer packets in yet another place.

johannes


