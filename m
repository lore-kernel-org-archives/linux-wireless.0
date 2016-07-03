Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([23.30.144.12]:36492 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbcGCDxJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2016 23:53:09 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
cc: linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
	Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: Switch to using mac80211 intermediate software queues. 
In-reply-to: Your message of Sat, 18 Jun 2016 21:05:05 +0200.
             <20160618190505.24038-1-toke@toke.dk>
Date: Sat, 02 Jul 2016 23:52:59 -0400
Message-Id: <E1bJYSp-0001M8-00@www.xplot.org> (sfid-20160703_055342_590611_AEDA9F0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




Toke,

I've been tesing your ath9k patch (using it instead of my earlier
ath9k patch) and plan to continue testing it.

Thanks for unconfusing me a couple weeks ago, and cluing me into how
the limit on ->pending_frames is not really relevant for the data
packets that go through the new intermediate queues.

But I'm not sure if this would allow us to remove the limit on
pending_frames because even though normal data packets would not
normally build up that many packets, there are other packet types
which bypass the intermediate queues and are transmitted directly
(also in most cases bypassing the ath9k internal queues in the way
ath9k worked before we patched it to use the mac80211 intermediate
queues).


Along similar lines, from reading the code I think your patch has
introduced a bug (but I don't know how to demonstrate it at runtime).

Looking in the body of ath_tx_start() at the result of applying your
patch, we now see this:

	[...]

	/* Force queueing of all frames that belong to a virtual interface on
	 * a different channel context, to ensure that they are sent on the
	 * correct channel.
	 */
	if (((avp && avp->chanctx != sc->cur_chan) ||
	     sc->cur_chan->stopped) && !txctl->force_channel) {
		if (!txctl->an)
			txctl->an = &avp->mcast_node;
		queue = true;
		skip_uapsd = true;
	}

	if (!skip_uapsd && ps_resp) {
		ath_txq_unlock(sc, txq);
		txq = sc->tx.uapsdq;
		ath_txq_lock(sc, txq);
	} else if(WARN_ON(txctl->an && queue)) 
		ath_txq_unlock(sc, txq);
		return -EINVAL;
	}

	[...]


In the case where the first if body above is run to force queuing of
all packets (not just normal data packets), then the else case of the
second if statement above will surely run and its if statement will
surely be true, so your new WARN_ON will happen.

This is why I left the previous ath9k internal queueing mechanisms in
place.  I couldn't figure out how to handle the above case without
leaving the ath9k internal queueing mechanisms.

I'm not sure how to test for this though... I don't know what sort of
configuration scenario I would need to set up to generate the above
situation and trigger the warning. (Presumably, it involves multiple
vifs on different channels.)  But unless the first if statement body
is dead code that can never happen, I think you've introduced a bug
here (with a good WARN_ON to make it obvious when it happens).

Earlier Felix said:

> Channel context based queue handling can be dealt with by
> stopping/starting relevant queues on channel context changes.

But I don't see how to handle the case here where packets get passed
to the driver with ath_tx_start() and wind up in the scenario above.


			-Tim Shepard
			 shep@alum.mit.edu


