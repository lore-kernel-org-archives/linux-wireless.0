Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30195C4151A
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 08:15:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D35218A1
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 08:15:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfBFIPU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 03:15:20 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51030 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfBFIPU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 03:15:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1grIMW-0006k1-Ji; Wed, 06 Feb 2019 09:15:16 +0100
Message-ID: <726dba28e925c6ade53f362c4f48b2ee28841dc2.camel@sipsolutions.net>
Subject: Re: [PATCH] rhashtable: use irq-safe spinlock in
 rhashtable_rehash_table()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jouni Malinen <j@w1.fi>, Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed, 06 Feb 2019 09:15:15 +0100
In-Reply-To: <20190205143706.28371-1-johannes@sipsolutions.net> (sfid-20190205_153723_180040_9C5B8C26)
References: <20190205143706.28371-1-johannes@sipsolutions.net>
         (sfid-20190205_153723_180040_9C5B8C26)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-02-05 at 15:37 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When an rhashtabl walk is done from irq/bh context, we rightfully
> get a lockdep complaint saying that we could get a (soft-)IRQ in
> the middle of a rehash. This happened e.g. in mac80211 as it does
> a walk in soft-irq context.
> 
> Fix this by using irq-safe locking here. We don't need _irqsave()
> as we know this will be called only in process context from the
> workqueue. We could get away with _bh() but that seems a bit less
> generic, though I'm not sure anyone would want to do a walk from
> a real IRQ handler.

Please drop this, it doesn't make sense.

I'll resend with all the spinlock usage changed to either _bh or
_irqsave(), since it makes no sense to enforce any kind of outside
BH/irq disabling for purposes of the inner lock.

johannes

