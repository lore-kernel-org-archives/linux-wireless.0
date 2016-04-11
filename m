Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37736 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbcDKHZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2016 03:25:46 -0400
Received: by mail-wm0-f48.google.com with SMTP id n3so91769251wmn.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2016 00:25:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHqTa-0yEFYAFpSKyko1ET33GsN==_D8TpBeq6AtwLj4XMTW0A@mail.gmail.com>
References: <1458123478-1795-1-git-send-email-michal.kazior@tieto.com>
	<1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	<1458898052-20601-2-git-send-email-michal.kazior@tieto.com>
	<CAHqTa-0yEFYAFpSKyko1ET33GsN==_D8TpBeq6AtwLj4XMTW0A@mail.gmail.com>
Date: Mon, 11 Apr 2016 09:25:44 +0200
Message-ID: <CA+BoTQ=H+jh_wiSyo4sSWvdx0cpTiqxT5=HXqBEsRJP8R6NSfQ@mail.gmail.com> (sfid-20160411_092555_964720_A2FCDBB1)
Subject: Re: [PATCH 1/2] mac80211: implement fair queuing per txq
From: Michal Kazior <michal.kazior@tieto.com>
To: Avery Pennarun <apenwarr@gmail.com>
Cc: Tim Shepard <shep@alum.mit.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2016 at 06:37, Avery Pennarun <apenwarr@gmail.com> wrote:
> On Fri, Mar 25, 2016 at 5:27 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> mac80211's software queues were designed to work
>> very closely with device tx queues. They are
>> required to make use of 802.11 packet aggregation
>> easily and efficiently.
>>
>> However the logic imposed a per-AC queue limit.
>> With the limit too small mac80211 wasn't be able
>> to guarantee fairness across TIDs nor stations
>> because single burst to a slow station could
>> monopolize queues and reach per-AC limit
>> preventing traffic from other stations being
>> queued into mac80211's software queues. Having the
>> limit too large would make smart qdiscs, e.g.
>> fq_codel, a lot less efficient as they are
>> designed on the premise that they are very close
>> to the actualy device tx queues.
>
> As usual, I'm way behind on everything, but I have been testing this
> patch series in the background (no clear results to report yet) and
> wanted to comment at a very high level.  I think you are actually
> doing several stages of improvements all at once here:
>
> [0. Baseline: one big queue going into the driver]
> 1. Switch ath10k to mac80211 per-station queues.
> 2. Change per-station queues to use NO_QUEUE qdisc and *not* ever stop
> the kernel netdev queue (since there no longer is one).
> 3. Actively manage per-station queues with fq_codel.
> 4. DQL-like control system for managing hardware queues.

The #4 is not really part of this patch series (unless you add the
older RFCv2 with txop scheduling or ath10k RFC which tests global DQL
to the mix).

Otherwise you're correct. I would argue #1 doesn't really matter
because without it all other changes are no-op though.


> Just to clarify what I mean by #2, if I understand correctly, before
> this patch, the driver+mac80211 keeps track of the total number of
> packets in all the mac80211 queues.

It keeps track of number of packets per AC..


>  When the total exceeds a fixed
> amount (or when one of the per-station queues gets full?) mac80211
> tells the kernel to stop sending in new packets, so they sit around in
> the qdisc instead.

..and stops netdev subqueues (0..3) when this per-AC limit is reached.

That is all assuming you have a wake_tx_queue() based driver.
Otherwise mac80211 doesn't really do anything special. It stops
subqueues when driver asks it to (when internal driver/device queues
become full).


> The problem with this behaviour is we probably
> have a lot of packets for one station, and not many packets for other
> stations, even if the netdev qdisc has plenty of packets still waiting
> for those other stations.  When you then go to drain the mac80211
> queues in a round-robin fashion, only the fullest queue (corresponding
> to the busiest stream to the fastest station) can get optimal results.
> The driver can then either send out from the fullest queue (unfair but
> fast) or round robin using the non-full queues (fair but non-optimal
> speed).

Roughly, yes.


> Upon implementing #2, we would essentially never tell the kernel to
> stop sending packets; instead, it just always forwards them to
> mac80211, which needs to learn how to drop them instead of providing
> backpressure.  This moves the entire qdisc functionality into
> mac80211, hence the use of NO_QUEUE.

Correct.


> It's then obvious that if you just did the obvious thing (tail drop),
> you'll end up with high latency, so you added fq_codel to the mix.

Yes. Also the mere taildrop doesn't split flows so you end up bulky
TCP traffic delaying/starving, e.g. your ICMP (and other short/bursty
traffic) which might be considered a regression if someone used
fq_codel before.


> However, as people on this thread have noticed, fq_codel is
> complicated.  I'd like to be able to evaluate the performance impact
> of each of the above steps separately.  In particular, my theory is
> that if we implement #2 with just a simple FIFO queue per station,
> then if we have two stations competing (one slow, one fast), and
> dequeue aggregates using round robin, then we should get all of:
>
> a) Full airtime utilization and max-length aggregates
> and
> b) High latency only on busy stations, but near-zero latency on idle
> stations (because of round-robin servicing of the per-station queues).

Roughly, yes.


> Using just a tail drop implementation, it should be very easy for me
> to test that (a) and (b) are true.  It should also be strictly equal
> (one station) or better (multiple stations) than using mac80211 soft
> queues with the pfifo_fast qdisc.  If that isn't what happens, then
> we'll know something went wrong with that part of the code, and we can
> debug that before moving on to a wifi-aware fq_codel.
>
> So my request: do you mind splitting your patch into two patches, one
> that implements just NO_QUEUE and per-station fifo tail drop, with a
> second patch that converts the tail drop to fq_codel?

Hmm.. Actually it might be worth splitting it up into 3 patches:
 1. noqueue (taildrop)
 2. fq (headdrop)
 3. codel

In which case (2) should introduce additional intra-station flow
fairness (compared to (1)) and (3) should make tcp behave better,
right?

Moreover I'm thinking of making "fq" part reusable the same way
"codel" is (or attempts to be today at least), i.e. header trickery
for easy gluing. This should make it easier to fix non-mac80211
drivers as well with possibly little effort in the future. Thoughts?


> Another advantage of the split is that we could then test NO_QUEUE +
> tail_drop + DQL.  Again, that should be strictly better than the
> NO_QUEUE + tail_drop + fixed_driver_queue.  Then it might be easier to
> debug the (much more fiddly) fq_codel on top.
>
> Thoughts?

It does make sense to split it up.


Michał
