Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1HJKja (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 06:39:30 -0400
Date: Wed, 10 Aug 2011 12:39:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: rt2800usb: fix races in tx queue
Message-ID: <20110810103904.GA8079@redhat.com> (sfid-20110810_123934_128193_EF8278F3)
References: <20110804124653.GB5739@redhat.com>
 <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
 <20110808092914.GA2168@redhat.com>
 <20110808093512.GB2168@redhat.com>
 <4E404D5C.30401@gmail.com>
 <20110809095050.GD2152@redhat.com>
 <20110809112624.GA2281@redhat.com>
 <20110809154540.GB2302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110809154540.GB2302@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 05:45:40PM +0200, Stanislaw Gruszka wrote:
> On Tue, Aug 09, 2011 at 01:26:24PM +0200, Stanislaw Gruszka wrote:
> > > > Second, I think it would be appropriate to split the patch in 2, or maybe 3, parts:
> > > > 	1. The hunk to rt2x00usb to reverse the entry flag handling and the tx dma done handling.
> > > > 	2. The hunk that checks that the entry on which the TX status is being reported has
> > > >            already been properly completed its TX done handling.
> > > > 	3. The remainder, i.e. the retrying of handling a TX status report if the entry hasn't been
> > > >            fully completed its TX done handling yet. 
> > > > 
> > > > The code in this area has been proven to be very fragile, so I prefer to make mini changes to it in
> > > > small steps, so that we can properly bisect which change exactly has caused a problem.
> > > > 
> > > > See further down for more thoughts.
> > > 
> > > Thanks for comments. I'll repost small patch that should fix the bug
> > > and don't do things you dislike.
> > 
> > Hmm, I planed to post the below patch, but unfortunately it does not fix
> > the crash on my system (rare reproducible after an hour of working). Seems
> > there are more problems here. Looks like there is possibility to mishmash
> > indexes i.e. make indexes like {Q_INDEX, Q_INDEX_DMA_DONE, Q_INDEX_DONE}
> > = {44, 54, 44}, whereas they should be {44, 44, 44} or {45, 43, 41}. 
> > Original patch seems to preventing this (fix or mask the problem), but 
> > honestly I do not understand way. I have to look more closely at it.
> 
> Ok, I think I found these other problems, seems we have also check 
> ENTRY_DATA_PENDING flags and add similar checks in rt2800usb_work_txdone
> when checking against failed I/O.
> 
> Justin, if you have opportunity test below patch (for 3.0 kernel). It does
> not crash here so far, but on my system bug is very rarely reproducible,
> so I have to test whole night or more to be sure.
> 
> Comments welcome. If patch is ok, I will split it into 2 parts and post
> officially.

This patch crashes as well. I have to debug this issue a bit more ...

Stanislaw 
