Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:34677 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbcFSNu3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2016 09:50:29 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software
	queues.
References: <E1bEcwS-0006jR-00@www.xplot.org>
Date: Sun, 19 Jun 2016 15:50:23 +0200
In-Reply-To: <E1bEcwS-0006jR-00@www.xplot.org> (Tim Shepard's message of "Sun,
	19 Jun 2016 09:39:12 -0400")
Message-ID: <87twgpqodc.fsf@toke.dk> (sfid-20160619_155033_954274_AEE5BFB1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

>> 
>> You're right that it doesn't check the max. However, this is less of a
>> problem now that there is no intermediate queueing in the driver; and
>> indeed the utility of haven the qlen_* tunables is somewhat questionable
>> with the patch applied: The only thing this is going to control is the
>> size of the retry queue, and possible limit the size of the retry queue.
>> [....]
>
> The driver queues things up for the hardware to DMA and transmit.
> Something has to limit the amount of packets handed over to the
> hardware.  (We lack access to hardware documentation (grrrr!) but it
> appears to me that the hardware has a hard limit on how many packets
> can be handed to it.)

There's a ring buffer eight entries long that the aggregates (or
packets) are put on when actually being handed to the hardware.

This is in ath_txq->txq_fifo.

>> Because there's a second limit in play (which has always been there): in
>> ath_tx_sched_aggr() there is this check:
>> 
>> 	if ((aggr && txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) ||
>> 	    (!aggr && txq->axq_depth >= ATH_NON_AGGR_MIN_QDEPTH)) {
>> 		__skb_queue_tail(&tid->retry_q, bf->bf_mpdu);
>> 		*stop = true;
>> 		return false;
>> 	}
>> 
>> The two constants are 2 and 8 respectively. This means that, with
>> aggregation enabled, no more than two full aggregates will be queued up.
>> The size of the aggregates is dynamically computed from the current
>> rate: they are limited a maximum of four milliseconds of (estimated)
>> airtime (for the BE queue; the others have different limits).
>> 
>> So in a sense there's already a dynamic limit on the hardware queues.
>> Now, whether four milliseconds is the right maximum aggregate size might
>> be worth discussing. It is the maximum allowed by the standard. Dave and
>> I have been 
>
> Ah that may be the clue that I lacked.  There's got to be a dependency
> on processor speed (how quickly the system and driver can get another
> packet hooked up for transmission after completions) but perhaps with
> aggregates being so large in time, with full aggregates even the
> slowest processors are fast enough to avoid starvation.
>
> If there's no aggregation, a limit of some sort is needed (probably to
> prevent malfunction of the hardware/driver, but in any case to limit
> excess latency).  And this limit will depend on processor speed (and
> will need to be autotuned at runtime).

ATH_NON_AGGR_MIN_QDEPTH is 8 -- so yeah, the limit is higher if there is
no aggregation.

These are hard-coded values, so presumably they are large enough to keep
the hardware busy on most platforms (or someone would have noticed and
changed them?). So I doubt there is much to be gained to add a mechanism
to dynamically tune them (between 0 and 2?).

The exception being in case pulling from the mac80211 queue is too slow
to keep the hardware busy at the current settings. I see no problems
with this on my hardware, but that's an x86 box. I would probably hold
off on the dynamic tuning until having proven that there's actually a
bottleneck, though... ;)

-Toke
