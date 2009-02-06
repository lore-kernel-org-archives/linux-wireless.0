Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58825 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZBFTCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 14:02:46 -0500
Received: from [172.20.29.59]([172.20.29.59]) (4136 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LVVxX-0000HiC@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Fri, 6 Feb 2009 11:01:51 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Fri, 6 Feb 2009 19:01:28 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
In-Reply-To: <20090206184445.GB7526@tuxdriver.com>
Message-ID: <Pine.LNX.4.64.0902061857410.25517@blonde.anvils> (sfid-20090206_200250_523667_097FEFB8)
References: <Pine.LNX.4.64.0901081740350.19523@blonde.anvils>
 <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com>
 <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com>
 <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet>
 <20090110201547.GA11261@hash.localnet> <Pine.LNX.4.64.0901131509080.9571@blonde.anvils>
 <20090113154204.M52697@bobcopeland.com> <Pine.LNX.4.64.0902061305530.15787@blonde.anvils>
 <20090206183443.M95991@bobcopeland.com> <20090206184445.GB7526@tuxdriver.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 Feb 2009, John W. Linville wrote:
> On Fri, Feb 06, 2009 at 01:37:49PM -0500, Bob Copeland wrote:
> > On Fri, 6 Feb 2009 13:12:34 +0000 (GMT), Hugh Dickins wrote
> > > Hi Bob,
> > > 
> > > On Tue, 13 Jan 2009, Bob Copeland wrote:
> > > > On Tue, 13 Jan 2009 15:35:29 +0000 (GMT), Hugh Dickins wrote
> > > > > But I haven't seen any allocation failure for several days.
> > > > > I didn't get any while trying to simplify the reproduction,
> > > > 
> > > > I'll go ahead and push this upstream then today or tomorrow; let me 
> > > > know if you run into any problems with more testing.
> > > 
> > > Just a prod: I've not seen your fix go into the 2.6.29-rc tree yet.
> > 
> > Good point, it is queued for 2.6.30.  John, would there be any problem
> > with including a8e3cd514, "ath5k: fix bf->skb==NULL panic in 
> > ath5k_tasklet_rx" for 2.6.29?
> 
> Hmmm...well it is a little big, but I guess it is OK.  Do you have
> an example of the stack trace?  Or a link to a bugzilla or somesuch
> would be even better...

Below is my original report: I didn't copy down the stacktrace,
and the kernel paniced with "Fatal exception in interrupt", so
nothing I can send you from the logs I'm afraid.

Hugh

>From hugh@veritas.com Thu Jan  8 13:49:47 2009
Date: Thu, 8 Jan 2009 13:49:44 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc:  <linux-wireless@vger.kernel.org>,  <ath5k-devel@lists.ath5k.org>
Subject: ath5k_tasklet_rx BUG_ON(bf->skb == NULL)

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
