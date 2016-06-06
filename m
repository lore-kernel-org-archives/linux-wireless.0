Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35095 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbcFFQza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2016 12:55:30 -0400
Received: by mail-oi0-f53.google.com with SMTP id w184so235390109oiw.2
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2016 09:55:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E1b9nQv-0001fc-00@www.xplot.org>
References: <CAA93jw4bwvzfOVqVAzAYJO1tmrpqEV3-=EjChgWdF-6qRhB+3Q@mail.gmail.com>
 <E1b9nQv-0001fc-00@www.xplot.org>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 6 Jun 2016 09:55:28 -0700
Message-ID: <CAA93jw7fdZhQvgCx7PXdB9yOS7ssKQFv6RG=RR2Hw9rjeXDYNQ@mail.gmail.com> (sfid-20160606_185534_766605_05EC1335)
Subject: Re: [RFC/RFT 2/5] ath9k: use mac80211 intermediate software queues
To: Tim Shepard <shep@alum.mit.edu>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	make-wifi-fast@lists.bufferbloat.net,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 5, 2016 at 10:50 PM, Tim Shepard <shep@alum.mit.edu> wrote:
>
>
>> > Thanks.  I've gotten no other feedback that suggests anyone else has
>> > read the code.  So I very much appreciate it.
>>
>> I not only read it but tested it extensively against the ath9k stock,
>> ath10k stock, ath10k -michal's fqmac 3.5 patches, and your ath9k
>> patches...
>
> My patch to ath9k shouldn't have any effect on any of the ath10k
> stuff.  It only cuts ath9k over to use the new intermediate queues.

Like the Sith, there are always at least two wifi chips on a link. One
behaving significantly differently (like flow queuing and codeling and
striving for airtime fairness) does affect the behavior of the other.

While I did do some ath9k to ath9k testing, I was mostly testing the
"whole enchalada". There are many, many moving parts left to swap out.

And the patchset I was testing included your fq_codel port for ath9k
but it was based on codel5.h. Michal's latest stuff reworked mainline
codel to be generically usable, and it *is* a different variant of the
algorithm.

The airtime-fair stuff does not as yet include fq_codel on top. It's a
MPU, and still puzzling as to why it did not get closer to perfect
fairness.

I also fiddled with the idea of dynamically altering the beacon's txop
sizes. A really short best effort  txop (94) was "Interesting". I need
to take apart how more beacons are constructed from non-linux vendors.

The whole enchalada is tasting pretty good thus far.

> I should point out again that Avery's observation that michal's
> mac80211 flow queueing patches and mac80211 codel stuff aren't needed
> to the improvement between competing client stations.

To *2* competing client stations, this is somewhat true at present.
There are at least 5 other (pending) factors to factor in.

* Toke's preliminary airtime-fair patches already showed a net gain in
bandwidth for the higher rate competing station. The "performance
anomaly", identified way back in 2003, is still with us without also
striving for airtime fairness.
* In order to hold latencies low with > 2 stations active, I advocate
gradually using shorter txops, which will improve behavior for
stations doing interactive tasks, and offering service sooner to
infrequently seen stations.
* In order to do gang scheduling for mu-mimo, we need to have several
2-3ms sized queues outstanding for the devices that can be mu-mimoed.
* Getting minstrel-blues in there to sample more dynamically would be nice
* Reducing retries and retransmits would be nice when already
congested. I'd also like to try QosNoack.


> All that's
> needed is to use the new mac80211 per-station per-tid intermediate
> queues and also set the IFF_NO_QUEUE bit.

It's a heckofastart.

>
> For ath9k, Felix's mac80211 interemediate queues patch (already in
> mainline Linux over a year ago), my patch to ath9k, and just
> Michal's first patch alone "[PATCHv3 1/5] mac80211: skip netdev
> queue control with software queuing" should (and seems to in
> testing I've done so far) get all the latency improvement there is
> to be had when the competing traffic is to a different client
> station.

I think it can be shaved from the presently observed 7-12ms minimum at
160mbit by another 2-3x. Also the codel implementation is not as yet
as tightly controlling queue size as I'd like - I haven't pushed it as
hard at sub 20mbit performance as I'd like (coping with being enraged
at networkmanager's over-use of channel scans was what I was at, last)
but I'm showing queue depth of well over 25ms at that rate right now
on the ath9k patch.

>
>
>
>> After losing my temper at the impact of channel scans...
>>
>> ( https://plus.google.com/u/0/107942175615993706558/posts/WA915Pt4SRN
>> ), I got told how to get rid of them for testing, and started redoing
>> the work when I got back from vacation.
>
> Heh... I've never seen that problem.  But I'm not running
> network-manager on any machine in my testbed.

I tend to think it is important to measure what happens in the real
world, to clearly identify what the real world problems actually are.

I let everybody else, with attenuators, and emulators, do whatever
they want. Me, I'm perpetually setting up real-world labs like the
yurtlab and sflab and the isclab to try to see what happens in
practice.

I now plan to put some work in on making channel scans less nasty and
to also look into what it takes to implement  802.11k, 802.11r and
802.11v.

or at the very least, nag people to get it more right.

https://bugzilla.gnome.org/show_bug.cgi?id=766482

NetworkManager's author suggests here that

https://blogs.gnome.org/dcbw/2016/05/16/networkmanager-and-wifi-scans/

"You can also advocate that your favorite WiFi interface add support
for NetworkManager’s RequestScan()"

>
>> > I looked for a way to ask mac80211 if there are any packets left in
>> > the intermediate queue without dequeueing a packet and I failed to
>> > find such an interface.
>>
>> qdisc->peek like function? A bitmap that says these stations have data
>> outstanding?
>>
>
> I'm not sure what you mean here.  Are you asking if that was what I
> was looking for in the existing mac80211 code?  If so, yes, that is
> what I was looking for.  Or are you suggesting (or agreeing) that
> indeed such an interface should be added to mac80211?

Yes, both.

> Though I don't see how it could be a bitmap...  stations don't have
> any obvious stable associated index into such a bitmap.

Mores the pity. I liked the idea of adapting something more qfq-like
than fq_codel like in parts of this. Allocating a fixed number of bits
(usually max_stations is set to like 128), and using array indexes for
various station related params (including rate stats), seems to be
simpler than chasing pointers around.

>
> The real problem might be the way all the code in ath9k/xmit.c is
> designed where it needs ath_tid_has_buffered() in so many places.

Yes, the ath9k is mroe than a bit hairy. :/

> Look at the mt76 driver, and see how it also maintains a small
> (probably only at most one packet ever) queue "retry_q" which
> sometimes does hold a packet which will get sent before it will
> pull another packet from ieee80211_tx_dequeue.  But the rest of the
> driver is structured so that a NULL return from mt76_txq_dequeue()
> is all it needs.  That's probably the sort of structure we ought to
> have in ath9k, but that's going to be a more invasive patch to
> ath9k (and I haven't figured out how to do it yet).

I did finally acquire a mt76 board to play with and I agree that that
that driver appears the most ideal to be prototyping with.

>
> I think we can get there incrementally though.  I hope the patch for
> ath9k that I've got now (and the one I hope to have soon that fixes
> the problem of not making use of hwq_max_pending() ) might be useful
> intermediate steps (that work, and provide improvements) then we can
> clean up ath9k removing mechanisms that are no longer needed (breaking
> the old transmit path, and somehow handling the chanctx stuff).

Groovy.

>
>
>                         -Tim Shepard
>                          shep@alum.mit.edu



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
