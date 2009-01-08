Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50528 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288AbZAHNtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 08:49:50 -0500
Received: from [172.20.18.193]([172.20.18.193]) (1847 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LKvGQ-0002SXC@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Thu, 8 Jan 2009 05:49:34 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Thu, 8 Jan 2009 13:49:44 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Jiri Slaby <jirislaby@gmail.com>
cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Message-ID: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils> (sfid-20090108_144956_159448_46161596)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for the ath5k wireless driver,
which I've just started using on an Aspire One.

When running swapping load tests, wireless alive but not in active use,
I've now twice hit the BUG_ON(bf->skb == NULL) in ath5k_tasklet_rx().

First time was with 2.6.28 plus kdb patch,
kernel BUG at drivers/net/wireless/ath5k/base.c:1675!
and poking around the messages I could see before that an
ath5k phy0: can't alloc skbuff of size 2673, after a
swapper: page allocation failure, order:0 mode:0x4020
on a call from dev_alloc_skb(), with memory summary.

Second time was with yesterday's 2.6.28-git, no kdb,
kernel BUG at drivers/net/wireless/ath5k/base.c:1683!
running ath5k_tasklet_rx() from under do_softirq(),
Kernel panic - not syncing: Fatal exception in interrupt
so I couldn't see more; but at the top of the screen, the
last three lines of a page allocation failure memory summary.

So, that BUG_ON(bf->skb == NULL) appears to be unsafe under
memory pressure; but the fix wasn't obvious to me, so over
to you!

I'd be glad to try patches, of course, but it's not happening
often enough for me to report back success quickly - unless I
stumble on a quicker way to reproduce it, it'll need a week or
two to grow confident of a fix.

Thanks,
Hugh
