Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EEFC282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB334218D3
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 13:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389077AbfBMNnR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 08:43:17 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:33204 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731945AbfBMNnQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 08:43:16 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtuoc-0005n7-HP; Wed, 13 Feb 2019 21:43:06 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtuoa-0004KF-C3; Wed, 13 Feb 2019 21:43:04 +0800
Date:   Wed, 13 Feb 2019 21:43:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Julia Lawall <julia.lawall@lip6.fr>
Cc:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com, kbuild-all@01.org
Subject: Re: [PATCH 2/2] mac80211: Free mpath object when rhashtable
 insertion fails (fwd)
Message-ID: <20190213134304.po7ccz3fnki3cdoh@gondor.apana.org.au>
References: <alpine.DEB.2.20.1902131349440.3561@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1902131349440.3561@hadrien>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 01:50:20PM +0100, Julia Lawall wrote:
> Perhaps a return is needed after line 436.

I don't think so.  The kfree only occurs in the case where the
hash table insertion fails.  While we should only return an error
if both the hash table insertion failed and the error is not due
to an existing entry (EEXIST).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
