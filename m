Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9950C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A502073F
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 08:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfDPIgr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 04:36:47 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:45258 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfDPIgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 04:36:47 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hGJa3-0001Qn-J3; Tue, 16 Apr 2019 16:36:39 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hGJa0-0008Fb-5J; Tue, 16 Apr 2019 16:36:36 +0800
Date:   Tue, 16 Apr 2019 16:36:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate
 tx queues
Message-ID: <20190416083636.5ttvezqyhzr2worg@gondor.apana.org.au>
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name>
 <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
 <20190416074444.pdubbh6fbibdnhi7@gondor.apana.org.au>
 <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73b18131-2777-da5c-a6ee-9d9b3e13cd06@broadcom.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 16, 2019 at 10:04:24AM +0200, Arend Van Spriel wrote:
> 
> I was just writing up an email clarifying my question. But let me summarize
> this email thread. The patch from Felix adds this flag in mac80211 for
> drivers that indicate to support pulling packets from the internal TXQ in
> mac80211. I found it is deprecated, but as Felix mentioned it is used in
> various parts of the network subsystem, ie. batman-adv, bridge, vlan, tunnel
> implementations. So its use seems to be restricted rather than deprecated.
> Given your response above I guess my question would be to get details about
> what you call "proper design" as I think you are saying with that it is not
> needed, right?

Essentially the only time it would be OK to use LLTX in its current
form is if you have no TX queue/congestion feedback which is clearly
not the case with wireless drivers.

Chers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
