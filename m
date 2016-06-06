Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.xplot.org ([66.92.66.146]:57087 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbcFFFug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 01:50:36 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: Dave Taht <dave.taht@gmail.com>
cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues 
In-reply-to: Your message of Sun, 05 Jun 2016 21:26:00 -0700.
             <CAA93jw4bwvzfOVqVAzAYJO1tmrpqEV3-=EjChgWdF-6qRhB+3Q@mail.gmail.com>
Date: Mon, 06 Jun 2016 01:50:41 -0400
Message-Id: <E1b9nQv-0001fc-00@www.xplot.org> (sfid-20160606_075040_512447_0CED48E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> > Thanks.  I've gotten no other feedback that suggests anyone else has
> > read the code.  So I very much appreciate it.
> 
> I not only read it but tested it extensively against the ath9k stock,
> ath10k stock, ath10k -michal's fqmac 3.5 patches, and your ath9k
> patches...

My patch to ath9k shouldn't have any effect on any of the ath10k
stuff.  It only cuts ath9k over to use the new intermediate queues.

I should point out again that Avery's observation that michal's
mac80211 flow queueing patches and mac80211 codel stuff aren't needed
to the improvement between competing client stations.  All that's
needed is to use the new mac80211 per-station per-tid intermediate
queues and also set the IFF_NO_QUEUE bit.

For ath9k, Felix's mac80211 interemediate queues patch (already in
mainline Linux over a year ago), my patch to ath9k, and just
Michal's first patch alone "[PATCHv3 1/5] mac80211: skip netdev
queue control with software queuing" should (and seems to in
testing I've done so far) get all the latency improvement there is
to be had when the competing traffic is to a different client
station.



> After losing my temper at the impact of channel scans...
> 
> ( https://plus.google.com/u/0/107942175615993706558/posts/WA915Pt4SRN
> ), I got told how to get rid of them for testing, and started redoing
> the work when I got back from vacation. 

Heh... I've never seen that problem.  But I'm not running
network-manager on any machine in my testbed.


> > I looked for a way to ask mac80211 if there are any packets left in
> > the intermediate queue without dequeueing a packet and I failed to
> > find such an interface.
> 
> qdisc->peek like function? A bitmap that says these stations have data
> outstanding?
> 

I'm not sure what you mean here.  Are you asking if that was what I
was looking for in the existing mac80211 code?  If so, yes, that is
what I was looking for.  Or are you suggesting (or agreeing) that
indeed such an interface should be added to mac80211?

Though I don't see how it could be a bitmap...  stations don't have
any obvious stable associated index into such a bitmap.

The real problem might be the way all the code in ath9k/xmit.c is
designed where it needs ath_tid_has_buffered() in so many places.

Look at the mt76 driver, and see how it also maintains a small
(probably only at most one packet ever) queue "retry_q" which
sometimes does hold a packet which will get sent before it will
pull another packet from ieee80211_tx_dequeue.  But the rest of the
driver is structured so that a NULL return from mt76_txq_dequeue()
is all it needs.  That's probably the sort of structure we ought to
have in ath9k, but that's going to be a more invasive patch to
ath9k (and I haven't figured out how to do it yet).

I think we can get there incrementally though.  I hope the patch for
ath9k that I've got now (and the one I hope to have soon that fixes
the problem of not making use of hwq_max_pending() ) might be useful
intermediate steps (that work, and provide improvements) then we can
clean up ath9k removing mechanisms that are no longer needed (breaking
the old transmit path, and somehow handling the chanctx stuff).


			-Tim Shepard
			 shep@alum.mit.edu
