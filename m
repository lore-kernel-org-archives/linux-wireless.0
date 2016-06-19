Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([23.30.144.12]:59810 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbcFSNkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2016 09:40:05 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software queues. 
In-reply-to: Your message of Sun, 19 Jun 2016 10:52:16 +0200.
             <87k2hlsgqn.fsf@toke.dk>
Date: Sun, 19 Jun 2016 09:39:12 -0400
Message-Id: <E1bEcwS-0006jR-00@www.xplot.org> (sfid-20160619_154022_671569_056D19E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> 
> You're right that it doesn't check the max. However, this is less of a
> problem now that there is no intermediate queueing in the driver; and
> indeed the utility of haven the qlen_* tunables is somewhat questionable
> with the patch applied: The only thing this is going to control is the
> size of the retry queue, and possible limit the size of the retry queue.
> [....]

The driver queues things up for the hardware to DMA and transmit.
Something has to limit the amount of packets handed over to the
hardware.  (We lack access to hardware documentation (grrrr!) but it
appears to me that the hardware has a hard limit on how many packets
can be handed to it.)

> > The second more mysterious bug which I'm still struggling to
> > understand is why doesn't large values in these ath9k/qlen_* (or more
> > accurately, given the first bug above, the failure to check these qlen
> > limit values at all) allow for increased hardware queue bloat (with
> > observable delay).
> 
> Because there's a second limit in play (which has always been there): in
> ath_tx_sched_aggr() there is this check:
> 
> 	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
> 	    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
> 		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
> 		*stop = true;
> 		return false;
> 	}
> 
> The two constants are 2 and 8 respectively. This means that, with
> aggregation enabled, no more than two full aggregates will be queued up.
> The size of the aggregates is dynamically computed from the current
> rate: they are limited a maximum of four milliseconds of (estimated)
> airtime (for the BE queue; the others have different limits).
> 
> So in a sense there's already a dynamic limit on the hardware queues.
> Now, whether four milliseconds is the right maximum aggregate size might
> be worth discussing. It is the maximum allowed by the standard. Dave and
> I have been 

Ah that may be the clue that I lacked.  There's got to be a dependency
on processor speed (how quickly the system and driver can get another
packet hooked up for transmission after completions) but perhaps with
aggregates being so large in time, with full aggregates even the
slowest processors are fast enough to avoid starvation.

If there's no aggregation, a limit of some sort is needed (probably to
prevent malfunction of the hardware/driver, but in any case to limit
excess latency).  And this limit will depend on processor speed (and
will need to be autotuned at runtime).


			-Tim Shepard
			 shep@alum.mit.edu

