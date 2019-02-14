Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75145C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 14:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5070B222D4
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 14:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391542AbfBNOE6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:04:58 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39798 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388734AbfBNOE6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 09:04:58 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1guHdE-0003D2-76; Thu, 14 Feb 2019 22:04:52 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1guHdD-0000PU-K6; Thu, 14 Feb 2019 22:04:51 +0800
Date:   Thu, 14 Feb 2019 22:04:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, j@w1.fi, tgraf@suug.ch
Subject: Re: [PATCH 2/4] mac80211: Free mpath object when rhashtable
 insertion fails
Message-ID: <20190214140451.45vzwoeehxtxjawb@gondor.apana.org.au>
References: <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
 <E1gtvgu-0006bT-4G@gondobar>
 <36adaef5c982ba10444d6f837b0d5c55ac953bdf.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36adaef5c982ba10444d6f837b0d5c55ac953bdf.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 04:04:29PM +0100, Johannes Berg wrote:
>
> Yes, that's a small change in behaviour as to when the generation
> counter is updated, but I'm pretty sure it really only needs updating
> when we inserted something, not if we found an old mpath.

I decided not to do this in my patch as it's not directly related
to the kfree issue.

But I agree that this makes more sense and we should make that
change in another patch.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
