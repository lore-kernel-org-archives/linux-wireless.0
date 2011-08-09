Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab1HIL02 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 07:26:28 -0400
Date: Tue, 9 Aug 2011 13:26:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: rt2800usb: fix races in tx queue
Message-ID: <20110809112624.GA2281@redhat.com> (sfid-20110809_132631_800227_CAB65B56)
References: <20110804124653.GB5739@redhat.com>
 <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
 <20110808092914.GA2168@redhat.com>
 <20110808093512.GB2168@redhat.com>
 <4E404D5C.30401@gmail.com>
 <20110809095050.GD2152@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110809095050.GD2152@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 11:50:50AM +0200, Stanislaw Gruszka wrote:
> Hello Gertjan 
> 
> On Mon, Aug 08, 2011 at 10:55:56PM +0200, Gertjan van Wingerde wrote:
> > Sorry for responding this late. I just didn't find the bandwidth to look at this earlier :-(
> > 
> > First of all, I don't think stable should be cc-ed on this particular patch. Although the ideas
> > of the patch are certainly applicable to the stable trees, this patch will simply not apply to
> > 3.0 or earlier, since the code you are patching has been moved around between 3.0 and 3.1.
> 
> CCing stable mean that we want that fix in stable kernel, not that patch
> have to apply cleanly. When greg-kh will be applying patch on stable tries,
> I'll provide proper backport.
> 
> > Second, I think it would be appropriate to split the patch in 2, or maybe 3, parts:
> > 	1. The hunk to rt2x00usb to reverse the entry flag handling and the tx dma done handling.
> > 	2. The hunk that checks that the entry on which the TX status is being reported has
> >            already been properly completed its TX done handling.
> > 	3. The remainder, i.e. the retrying of handling a TX status report if the entry hasn't been
> >            fully completed its TX done handling yet. 
> > 
> > The code in this area has been proven to be very fragile, so I prefer to make mini changes to it in
> > small steps, so that we can properly bisect which change exactly has caused a problem.
> > 
> > See further down for more thoughts.
> 
> Thanks for comments. I'll repost small patch that should fix the bug
> and don't do things you dislike.

Hmm, I planed to post the below patch, but unfortunately it does not fix
the crash on my system (rare reproducible after an hour of working). Seems
there are more problems here. Looks like there is possibility to mishmash
indexes i.e. make indexes like {Q_INDEX, Q_INDEX_DMA_DONE, Q_INDEX_DONE}
= {44, 54, 44}, whereas they should be {44, 44, 44} or {45, 43, 41}. 
Original patch seems to preventing this (fix or mask the problem), but 
honestly I do not understand way. I have to look more closely at it.

Stanislaw

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 5075593..d8b27ae 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -464,6 +464,15 @@ static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	int wcid, ack, pid;
 	int tx_wcid, tx_ack, tx_pid;
 
+	if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+	    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags)) {
+		WARNING(entry->queue->rt2x00dev,
+			"Data pending for entry %u in queue %u\n",
+			entry->entry_idx, entry->queue->qid);
+		cond_resched();
+		return false;
+	}
+
 	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
 	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
 	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index b6b4542..32eb5aa 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -265,14 +265,13 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	if (!test_and_clear_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
 		return;
 
-	if (rt2x00dev->ops->lib->tx_dma_done)
-		rt2x00dev->ops->lib->tx_dma_done(entry);
-
 	/*
 	 * Report the frame as DMA done
 	 */
 	rt2x00lib_dmadone(entry);
 
+	if (rt2x00dev->ops->lib->tx_dma_done)
+		rt2x00dev->ops->lib->tx_dma_done(entry);
 	/*
 	 * Check if the frame was correctly uploaded
 	 */
