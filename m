Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDA2C282CC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 17:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA3C20B1F
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 17:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730164AbfBFRkP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 12:40:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:32792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730103AbfBFRkO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 12:40:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 575E313ED1F58;
        Wed,  6 Feb 2019 09:40:13 -0800 (PST)
Date:   Wed, 06 Feb 2019 09:40:12 -0800 (PST)
Message-Id: <20190206.094012.2135082565786833693.davem@davemloft.net>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, herbert@gondor.apana.org.au
Subject: Re: [PATCH] rhashtable: use irq-safe spinlock in
 rhashtable_rehash_table()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <726dba28e925c6ade53f362c4f48b2ee28841dc2.camel@sipsolutions.net>
References: <20190205143706.28371-1-johannes@sipsolutions.net>
        <726dba28e925c6ade53f362c4f48b2ee28841dc2.camel@sipsolutions.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Feb 2019 09:40:13 -0800 (PST)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 06 Feb 2019 09:15:15 +0100

> On Tue, 2019-02-05 at 15:37 +0100, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>> 
>> When an rhashtabl walk is done from irq/bh context, we rightfully
>> get a lockdep complaint saying that we could get a (soft-)IRQ in
>> the middle of a rehash. This happened e.g. in mac80211 as it does
>> a walk in soft-irq context.
>> 
>> Fix this by using irq-safe locking here. We don't need _irqsave()
>> as we know this will be called only in process context from the
>> workqueue. We could get away with _bh() but that seems a bit less
>> generic, though I'm not sure anyone would want to do a walk from
>> a real IRQ handler.
> 
> Please drop this, it doesn't make sense.
> 
> I'll resend with all the spinlock usage changed to either _bh or
> _irqsave(), since it makes no sense to enforce any kind of outside
> BH/irq disabling for purposes of the inner lock.

Ok.
