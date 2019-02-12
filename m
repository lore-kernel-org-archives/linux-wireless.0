Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E953C282CE
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0B282190B
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 18:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732003AbfBLSnl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:43:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfBLSnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 13:43:40 -0500
Received: from localhost (96-89-128-221-static.hfc.comcastbusiness.net [96.89.128.221])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1781B14C50532;
        Tue, 12 Feb 2019 10:43:40 -0800 (PST)
Date:   Tue, 12 Feb 2019 10:43:39 -0800 (PST)
Message-Id: <20190212.104339.1794719792249723582.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, herbert@gondor.apana.org.au, johannes.berg@intel.com
Subject: Re: [PATCH v2] rhashtable: make walk safe from softirq context
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190206090721.8001-1-johannes@sipsolutions.net>
References: <20190206090721.8001-1-johannes@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 12 Feb 2019 10:43:40 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed,  6 Feb 2019 10:07:21 +0100

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

Herbert and Johannes, I need some guidance.

It seems Herbert wants the softirq usage of rhashtables removed, but
since things have been like this for so long that's not the most
reasonable requirement if we can fix it more simply with Johannes's
patch especially for -stable.

Thanks.
