Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:55559 "EHLO mail2.tohojo.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbcGDRrJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 13:47:09 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tim Shepard <shep@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software
	queues.
References: <E1bJYSp-0001M8-00@www.xplot.org>
Date: Mon, 04 Jul 2016 19:46:53 +0200
In-Reply-To: <E1bJYSp-0001M8-00@www.xplot.org> (Tim Shepard's message of "Sat,
	02 Jul 2016 23:52:59 -0400")
Message-ID: <87lh1hnvn6.fsf@toke.dk> (sfid-20160704_194713_288470_E87B8085)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Shepard <shep@alum.mit.edu> writes:

> Thanks for unconfusing me a couple weeks ago, and cluing me into how
> the limit on ->pending_frames is not really relevant for the data
> packets that go through the new intermediate queues.
>
> But I'm not sure if this would allow us to remove the limit on
> pending_frames because even though normal data packets would not
> normally build up that many packets, there are other packet types
> which bypass the intermediate queues and are transmitted directly
> (also in most cases bypassing the ath9k internal queues in the way
> ath9k worked before we patched it to use the mac80211 intermediate
> queues).

Yes, but, well, since they're not queued they are not going to overflow
anything. The aggregation building logic stops at two queued aggregates,
so the default limit of 123 packets is never going to be hit when the
queue is moved into the mac80211 layer. So keeping the knobs around only
helps people who purposefully want to cripple their ability to do
aggregation; and it won't be doing what it promises (limiting qlen),
since that is now moved out of the driver. So IMO, removing the knobs is
the right thing to do. I have already updated my patch to do so, which
I'll send as a v2 once the other bits are resolved.

> Along similar lines, from reading the code I think your patch has
> introduced a bug (but I don't know how to demonstrate it at runtime).
>
> Looking in the body of ath_tx_start() at the result of applying your
> patch, we now see this:
>
> 	[...]
>
> 	/* Force queueing of all frames that belong to a virtual interface on
> 	 * a different channel context, to ensure that they are sent on the
> 	 * correct channel.
> 	 */
> 	if (((avp && avp->chanctx != sc->cur_chan) ||
> 	     sc->cur_chan->stopped) && !txctl->force_channel) {
> 		if (!txctl->an)
> 			txctl->an = &avp->mcast_node;
> 		queue = true;
> 		skip_uapsd = true;
> 	}
>
> 	if (!skip_uapsd && ps_resp) {
> 		ath_txq_unlock(sc, txq);
> 		txq = sc->tx.uapsdq;
> 		ath_txq_lock(sc, txq);
> 	} else if(WARN_ON(txctl->an && queue)) 
> 		ath_txq_unlock(sc, txq);
> 		return -EINVAL;
> 	}
>
> 	[...]
>
> In the case where the first if body above is run to force queuing of
> all packets (not just normal data packets), then the else case of the
> second if statement above will surely run and its if statement will
> surely be true, so your new WARN_ON will happen.

Yup, I'm aware of that (and it's why I put in the WARN_ON instead of
just removing those code paths). Haven't seen it trigger yet, but
haven't tried very hard either. Guess you're right that it requires
vifs on different channels...

> Earlier Felix said:
>
>> Channel context based queue handling can be dealt with by
>> stopping/starting relevant queues on channel context changes.
>
> But I don't see how to handle the case here where packets get passed
> to the driver with ath_tx_start() and wind up in the scenario above.

Well, presumably the upper layers won't try to transmit anything through
the old TX path if the start/stop logic is implemented properly. The
chanctx code already seems to call the ieee80211_{start,stop}_queue()
functions when changing context, so not sure what else is needed. Guess
I'll go see if I can provoke an actual triggering of the bug, unless
Felix elaborates on what he means before I get around to it (poke,
Felix? :)).

-Toke
