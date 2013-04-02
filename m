Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:60513 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681Ab3DBTgz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:36:55 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LmQiS-1UvtbD1lv0-00Zz8O for
 <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 21:36:53 +0200
Date: Tue, 2 Apr 2013 21:35:55 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Daniel Mack <daniel@zonque.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: mwifiex: infinite loop in mwifiex_main_process
Message-ID: <20130402193555.GA14343@blumentopf> (sfid-20130402_213703_697443_73C8A13A)
References: <20130319095235.GA22962@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DBCE43F@SC-VEXCH1.marvell.com>
 <20130402000511.GA31921@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DDAAFDA@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DDAAFDA@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 02, 2013 at 11:16:26AM -0700, Bing Zhao wrote:
> Hi Andi,
> 
> [...]
> 
> > +			spin_lock_irqsave(&priv_tmp->wmm.ra_list_spinlock, flags);
> > +			BUG_ON(atomic_read(&priv_tmp->wmm.tx_pkts_queued));
> > +			spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags);
> > +
> >                         /* No packet at any TID for this priv. Mark as such
> >                          * to skip checking TIDs for this priv (until pkt is
> >                          * added).
> > 			atomic_set(hqp, NO_PKT_PRIO_TID);
> > 
> > 
> > Which crashed. Hence searching for queued packets and adding new ones is
> > not synchronized, new packets can be added while searching the WMM
> > queues. If a packet is added right before setting max prio to NO_PKT,
> > that packet is trapped and creates an infinite loop.
> > 
> > Because of the new packet tx_pkts_queued is at least 1, indicating wmm
> > lists are not empty. Opposing that max prio is NO_PKT, which means "skip
> > this wmm queue, it has no packets".
> > The infinite loop results, because the main loop checks the wmm lists
> > for not empty (tx_pkts_queued != 0), but then finds no packet since it
> > skips the wmm queue where it is located on. This will never end, unless
> > a new packet is added which will restore max prio.
> 
> Thanks for your analysis.
> 
> > One possible solution is is to rely on tx_pkts_queued solely for
> > checking wmm queue to be empty, and drop the NO_PKT define.
> 
> FYI, Yogesh suggested another fix (attached).

Started with similar patch, but then learned that NO_PKT_PRIO_TID
is not needed at all. It only adds complexity, rely on
tx_pkts_queued!

On top, bss_prio_tbl should be locked as well.

> 
> [...]
> 
> > seems to be intruduced with this patch:
> > 17e8cec  05-16-2011 mwifiex: CPU mips optimization with NO_PKT_PRIO_TID
> > 
> > I was wondering why hasn't happened more frequently. Evtl. if the
> > interface is working in bridge mode, new packets might be added to the
> > WMM queue with the trapped packet. 2c
> > 
> > I prepared a few patches, fixing above bug as suggested and plus some
> > cleanup patches I did while trying to get an understanding. Pls review.
> 
> Thanks for the patches. We will review them and run some WMM tests.

Thanks, looking forward to that. 

Andi


