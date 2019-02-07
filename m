Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2029C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 21:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9333221907
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 21:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfBGVsj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 16:48:39 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57874 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfBGVsj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 16:48:39 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1grrXB-00029f-Bq; Fri, 08 Feb 2019 05:48:37 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1grrX8-0007WQ-A9; Fri, 08 Feb 2019 05:48:34 +0800
Date:   Fri, 8 Feb 2019 05:48:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH v2] rhashtable: make walk safe from softirq context
Message-ID: <20190207214834.awrpkxunnvfdorbe@gondor.apana.org.au>
References: <20190206090721.8001-1-johannes@sipsolutions.net>
 <20190207134006.gmuooqmyc5womcaf@gondor.apana.org.au>
 <fee1bdca8bb21a472a75c1a43fa61aad7fe4bff5.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fee1bdca8bb21a472a75c1a43fa61aad7fe4bff5.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Feb 07, 2019 at 02:50:54PM +0100, Johannes Berg wrote:
> 
> > This interface wasn't designed for use in softirq contexts.
> 
> Well, it clearly was used there. You even gave it a gfp_t argument in
> rhashtable_walk_init(), so you can't really claim it wasn't designed for
> this. I see now that it's ignored, but still?

I see.  This was added behind my back so I wasn't aware of it.

> > Could you please show me who is doing this so I can review that
> > to see whether it's a legitimate use of this API?
> 
> I'm sure you'll say it's not legitimate, but it still exists ;-)
> 
> mesh_plink_broken() gets called from the TX status path, via
> ieee80211s_update_metric().

Let me take a look.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
