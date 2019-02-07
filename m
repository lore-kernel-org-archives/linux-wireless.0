Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6761C282CC
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75A572147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 13:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfBGNkQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 08:40:16 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:55786 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfBGNkQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 08:40:16 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1grjuX-0007Ps-S0; Thu, 07 Feb 2019 21:40:13 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1grjuQ-0006d8-Qi; Thu, 07 Feb 2019 21:40:06 +0800
Date:   Thu, 7 Feb 2019 21:40:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Thomas Graf <tgraf@suug.ch>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2] rhashtable: make walk safe from softirq context
Message-ID: <20190207134006.gmuooqmyc5womcaf@gondor.apana.org.au>
References: <20190206090721.8001-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206090721.8001-1-johannes@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 06, 2019 at 10:07:21AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When an rhashtable walk is done from softirq context, we rightfully
> get a lockdep complaint saying that we could get a softirq in the
> middle of a rehash, and thus deadlock on &ht->lock. This happened
> e.g. in mac80211 as it does a walk in softirq context.
> 
> Fix this by using spin_lock_bh() wherever we use the &ht->lock.
> 
> Initially, I thought it would be sufficient to do this only in the
> rehash (rhashtable_rehash_table), but I changed my mind:
>  * the caller doesn't really need to disable softirqs across all
>    of the rhashtable_walk_* functions, only those parts that they
>    actually do within the lock need it
>  * maybe more importantly, it would still lead to massive lockdep
>    complaints - false positives, but hard to fix - because lockdep
>    wouldn't know about different ht->lock instances, and thus one
>    user of the code doing a walk w/o any locking (when it only ever
>    uses process context this is fine) vs. another user like in wifi
>    where we noticed this problem would still cause it to complain.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jouni Malinen <j@w1.fi>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

This interface wasn't designed for use in softirq contexts.

Could you please show me who is doing this so I can review that
to see whether it's a legitimate use of this API?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
