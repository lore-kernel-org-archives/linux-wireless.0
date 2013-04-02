Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49838 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878Ab3DBAFS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Apr 2013 20:05:18 -0400
Received: from mailout-de.gmx.net ([10.1.76.34]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Mh7vz-1U1BGf0RzV-00MLlE for
 <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 02:05:16 +0200
Date: Tue, 2 Apr 2013 02:05:11 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Daniel Mack <daniel@zonque.org>, linville@tuxdriver.com
Subject: Re: mwifiex: infinite loop in mwifiex_main_process
Message-ID: <20130402000511.GA31921@blumentopf> (sfid-20130402_020522_672079_00821BE0)
References: <20130319095235.GA22962@blumentopf>
 <477F20668A386D41ADCC57781B1F70430D9DBCE43F@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DBCE43F@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Tue, Mar 19, 2013 at 03:37:52PM -0700, Bing Zhao wrote:
[snip]
> > 
> > [18017.214686] data sent 0
> > [18017.227548] wmm list empty 0
> > [18017.230592] tx_lock_flag 0
> > 
> > So it seems the wmm list has packets queued, but they are never
> > sent out. Adding a few more statements, it seems the problem is
> > in mwifiex_wmm_get_highest_priolist_ptr:
> > 
> > 	for (j = adapter->priv_num - 1; j >= 0; --j) {
> > 
> > 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
> > 				flags);
> > 		is_list_empty = list_empty(&adapter->bss_prio_tbl[j]
> > 				.bss_prio_head);
> > 		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
> > 				flags);
> > 		if (is_list_empty)
> > 			continue;
> > 
> > 		.... <snip> ...
> > 
> > 		do {
> > 			priv_tmp = bssprio_node->priv;
> > 			hqp = &priv_tmp->wmm.highest_queued_prio;
> > 
> > 			for (i = atomic_read(hqp); i >= LOW_PRIO_TID;
> > 					--i) {
> > 			...
> > 			... NEVER REACHED ...
> > 			...
> > 
> > 
> > So there are packets queued, but the highest_queued_prio is too
> > low, so they are never sent out.
> 
> Could you apply the debug patch attached to print out hqp number?

I tried the following patch with lesser impact on performance.

@@ -928,6 +947,10 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
                                }
                        }

+			spin_lock_irqsave(&priv_tmp->wmm.ra_list_spinlock, flags);
+			BUG_ON(atomic_read(&priv_tmp->wmm.tx_pkts_queued));
+			spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags);
+
                        /* No packet at any TID for this priv. Mark as such
                         * to skip checking TIDs for this priv (until pkt is
                         * added).
			atomic_set(hqp, NO_PKT_PRIO_TID);


Which crashed. Hence searching for queued packets and adding new ones is
not synchronized, new packets can be added while searching the WMM
queues. If a packet is added right before setting max prio to NO_PKT,
that packet is trapped and creates an infinite loop.

Because of the new packet tx_pkts_queued is at least 1, indicating wmm
lists are not empty. Opposing that max prio is NO_PKT, which means "skip
this wmm queue, it has no packets".
The infinite loop results, because the main loop checks the wmm lists
for not empty (tx_pkts_queued != 0), but then finds no packet since it
skips the wmm queue where it is located on. This will never end, unless
a new packet is added which will restore max prio.

One possible solution is is to rely on tx_pkts_queued solely for
checking wmm queue to be empty, and drop the NO_PKT define.

> > 
> > Is there a known issue, with highest_queued_prio getting out of
> > sync with the number of packets queued?
> 
> I'm not aware of any known issue related to highest_queued_prio.

seems to be intruduced with this patch:
17e8cec  05-16-2011 mwifiex: CPU mips optimization with NO_PKT_PRIO_TID

I was wondering why hasn't happened more frequently. Evtl. if the
interface is working in bridge mode, new packets might be added to the
WMM queue with the trapped packet. 2c

I prepared a few patches, fixing above bug as suggested and plus some
cleanup patches I did while trying to get an understanding. Pls review  

rgds,
Andi


 drivers/net/wireless/mwifiex/11n_aggr.c |   14 +----------
 drivers/net/wireless/mwifiex/init.c     |   22 +++++------------
 drivers/net/wireless/mwifiex/main.h     |    4 ---
 drivers/net/wireless/mwifiex/wmm.c      |  200 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------------------------------------------------------------
 drivers/net/wireless/mwifiex/wmm.h      |    3 +++
 5 files changed, 83 insertions(+), 160 deletions(-)



