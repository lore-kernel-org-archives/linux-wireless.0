Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab1HIPqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:46:07 -0400
Date: Tue, 9 Aug 2011 17:45:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: rt2800usb: fix races in tx queue
Message-ID: <20110809154540.GB2302@redhat.com> (sfid-20110809_174612_085463_105952EC)
References: <20110804124653.GB5739@redhat.com>
 <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
 <20110808092914.GA2168@redhat.com>
 <20110808093512.GB2168@redhat.com>
 <4E404D5C.30401@gmail.com>
 <20110809095050.GD2152@redhat.com>
 <20110809112624.GA2281@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110809112624.GA2281@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 09, 2011 at 01:26:24PM +0200, Stanislaw Gruszka wrote:
> > > Second, I think it would be appropriate to split the patch in 2, or maybe 3, parts:
> > > 	1. The hunk to rt2x00usb to reverse the entry flag handling and the tx dma done handling.
> > > 	2. The hunk that checks that the entry on which the TX status is being reported has
> > >            already been properly completed its TX done handling.
> > > 	3. The remainder, i.e. the retrying of handling a TX status report if the entry hasn't been
> > >            fully completed its TX done handling yet. 
> > > 
> > > The code in this area has been proven to be very fragile, so I prefer to make mini changes to it in
> > > small steps, so that we can properly bisect which change exactly has caused a problem.
> > > 
> > > See further down for more thoughts.
> > 
> > Thanks for comments. I'll repost small patch that should fix the bug
> > and don't do things you dislike.
> 
> Hmm, I planed to post the below patch, but unfortunately it does not fix
> the crash on my system (rare reproducible after an hour of working). Seems
> there are more problems here. Looks like there is possibility to mishmash
> indexes i.e. make indexes like {Q_INDEX, Q_INDEX_DMA_DONE, Q_INDEX_DONE}
> = {44, 54, 44}, whereas they should be {44, 44, 44} or {45, 43, 41}. 
> Original patch seems to preventing this (fix or mask the problem), but 
> honestly I do not understand way. I have to look more closely at it.

Ok, I think I found these other problems, seems we have also check 
ENTRY_DATA_PENDING flags and add similar checks in rt2800usb_work_txdone
when checking against failed I/O.

Justin, if you have opportunity test below patch (for 3.0 kernel). It does
not crash here so far, but on my system bug is very rarely reproducible,
so I have to test whole night or more to be sure.

Comments welcome. If patch is ok, I will split it into 2 parts and post
officially.

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2a6aa85..49a9c76 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -607,6 +607,16 @@ static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	int wcid, ack, pid;
 	int tx_wcid, tx_ack, tx_pid;
 
+	if (test_bit(ENTRY_DATA_PENDING, &entry->flags) ||
+	    test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
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
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ba82c97..3dfb4f3 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -477,8 +477,11 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 		while (!rt2x00queue_empty(queue)) {
 			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 
-			if (test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags))
+			if (test_bit(ENTRY_DATA_PENDING, &entry->flags) ||
+			    test_bit(ENTRY_OWNER_DEVICE_DATA, &entry->flags) ||
+			    !test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 				break;
+
 			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
 				rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
 			else if (rt2x00queue_status_timeout(entry))
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 8f90f62..7ec9e4f 100644
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

 
