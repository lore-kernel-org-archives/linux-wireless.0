Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDA0C282CA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88EE6218D3
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfBMNrj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:47:39 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:33284 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfBMNrj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 08:47:39 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtusv-0005x0-8A; Wed, 13 Feb 2019 21:47:33 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtusp-0004LD-GL; Wed, 13 Feb 2019 21:47:27 +0800
Date:   Wed, 13 Feb 2019 21:47:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com
Subject: Re: [PATCH 1/2] mac80211: Use linked list instead of rhashtable walk
 for mesh tables
Message-ID: <20190213134727.iyrxk7utxmihj7ac@gondor.apana.org.au>
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
 <E1gtmu5-0001Vb-LI@gondobar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1gtmu5-0001Vb-LI@gondobar>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 01:16:13PM +0800, Herbert Xu wrote:
> The mesh table code walks over hash tables for two purposes.  First of
> all it's used as part of a netlink dump process, but it is also used
> for looking up entries to delete using criteria other than the hash
> key.
> 
> The second purpose is directly contrary to the design specification
> of rhashtable walks.  It is only meant for use by netlink dumps.
> 
> This is because rhashtable is resizable and you cannot obtain a
> stable walk over it during a resize process.
> 
> In fact mesh's use of rhashtable for dumping is bogus too.  Rather
> than using rhashtable walk's iterator to keep track of the current
> position, it always converts the current position to an integer
> which defeats the purpose of the iterator.
> 
> Therefore this patch converts all uses of rhashtable walk into a
> simple linked list.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

OK this patch is broken because there is no locking on the linked
list.  I'll repost the series.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
