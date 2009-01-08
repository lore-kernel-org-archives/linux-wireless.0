Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:19437 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZAHOrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 09:47:03 -0500
Received: by fk-out-0910.google.com with SMTP id 18so4486571fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 06:47:02 -0800 (PST)
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
In-Reply-To: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 16:46:57 +0200
Message-Id: <1231426017.922.2.camel@maxim-laptop> (sfid-20090108_154711_898368_804B206A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-08 at 13:49 +0000, Hugh Dickins wrote:
> Thank you for the ath5k wireless driver,
> which I've just started using on an Aspire One.
> 
> When running swapping load tests, wireless alive but not in active use,
> I've now twice hit the BUG_ON(bf->skb == NULL) in ath5k_tasklet_rx().
> 
> First time was with 2.6.28 plus kdb patch,
> kernel BUG at drivers/net/wireless/ath5k/base.c:1675!
> and poking around the messages I could see before that an
> ath5k phy0: can't alloc skbuff of size 2673, after a
> swapper: page allocation failure, order:0 mode:0x4020
> on a call from dev_alloc_skb(), with memory summary.
> 
> Second time was with yesterday's 2.6.28-git, no kdb,
> kernel BUG at drivers/net/wireless/ath5k/base.c:1683!
> running ath5k_tasklet_rx() from under do_softirq(),
> Kernel panic - not syncing: Fatal exception in interrupt
> so I couldn't see more; but at the top of the screen, the
> last three lines of a page allocation failure memory summary.
> 
> So, that BUG_ON(bf->skb == NULL) appears to be unsafe under
> memory pressure; but the fix wasn't obvious to me, so over
> to you!
> 
> I'd be glad to try patches, of course, but it's not happening
> often enough for me to report back success quickly - unless I
> stumble on a quicker way to reproduce it, it'll need a week or
> two to grow confident of a fix.
> 
> Thanks,
> Hugh


I use aspire one, and I don't see that, did this happen several times?


Could you try compat-wireless:

http://wireless.kernel.org/en/users/Download


It has many fixes that made my wireless on that notebook more or less
usable.

Best regards,
	Maxim Levitsky

