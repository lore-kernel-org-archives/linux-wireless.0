Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13641 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab0IACOV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 22:14:21 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 31 Aug 2010 19:14:16 -0700
Date: Tue, 31 Aug 2010 19:14:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Matt Smith <Matt.Smith@Atheros.com>,
	Kevin Hayes <kevin@Atheros.com>,
	David Quan <David.Quan@Atheros.com>
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast
 on sw scan
Message-ID: <20100901021418.GC12472@tux>
References: <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
 <1283183279.3691.82.camel@jlt3.sipsolutions.net>
 <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
 <1283191837.3694.13.camel@jlt3.sipsolutions.net>
 <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
 <1283265399.3733.18.camel@jlt3.sipsolutions.net>
 <AANLkTi=yRnMwTBq1ze8LaMCO521YutrtxJpBS0rGuvhJ@mail.gmail.com>
 <1283270092.3733.41.camel@jlt3.sipsolutions.net>
 <20100831165931.GC15752@tux>
 <1283278340.3733.56.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1283278340.3733.56.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 31, 2010 at 11:12:20AM -0700, Johannes Berg wrote:
> On Tue, 2010-08-31 at 09:59 -0700, Luis R. Rodriguez wrote:
> 
> > > > This is true, but why would they not be important for going off
> > > > channel ? The TSF sync seems just as important as waiting for the ACK
> > > > for the nullfunc from the AP.
> > > 
> > > Why? It doesn't seem important to me?
> > 
> > How else could you possibly do a reliable calculation for the computation of the
> > next DTIM?
> 
> Dunno what your TSF sync does, but a single beacon frame has all the
> relevant information for computing this.

Ok you have a point about the DTIM period and count being available on all
beacons but more on the TSF sync below.

> > So we do the TSF synch to more reliably know when we will get a DTIM and also
> > adjust our beacon miss interrupt. For offchannel operation know the DTIM
> > more accurately will help in our computation when going off channel.
> 
> Yeah but when _going_ offchannel we don't need to know exactly when it
> will happen in advance, we can just wait for the relevant thing to end
> and then go offchannel 

And how do we do this currently wait for the relevant things to end
in mac802111 prior to going offchannel ? We agree we don't, right. But
what we're trying to get more agreement on is what items we do need
to wait on. Let me clarify what I believe these are and show their
dependency graph:

  * ACK for nullfunc for offchannel operation - not handled yet
  * Do not go offchannel when we would expect the DTIM -- not handled yet

That's it! But the second one require some more consideration. Lets consider
the worst case scenerio. After we get the DTIM we will get all buffered
broadcast and multicast buffered frames from the AP. This will ultimately
vary depending on the size of your BSS, so you cannot easily compute this
as a station, unless you add some guess fudge factor and that will
ultimately be very subjective. So I argue you cannot calculate this
and instead it is easier to monitor for the broadcast / multicast data
sent by the AP and check when we get the last one (the more bit is off).

Do you agree with that? If not how else do you suggest we calculate this
on mac80211?

Now, lets consider an even harier situation. Say we use the above mechanism
but you missed the last frame that indicates that there are no more broadcast
and multicast traffic, your next best bet is to timeout on the next beacon
and assume no more broadcast / multicast traffic is pending. Consider this
situation now if our DTIM is 1 though and we happen to have a lot of noise
and happen to loose the last broadcast / multicast frame with the with the
more bit off... We just won't be able to go offchannel unless we are willing
to drop frames in that worst case scenerio and we really value our broadcast
and multicast frames. You could also deal with only going offchannel if
you do get this more bit off. If DTIM period is > 1 though then we have
more flexibility and can rely on the next beacon for a timeout indication
to know we can then go off channel.

Now, all this is sensitive to timing constraints lead by the DTIM count.
As the DTIM period increases it means we are able to skip more beacons for
going offchannel. Consider a DTIM period (also called DTIM interval on my
E3000 it seems) of 100. Granted, *today* on 802.11 you won't likely go
offchannel for more than:

  100 * beacon_interval * TU

But if we start doing more complex things while off channel (*cough*) or
consider a few years with new possible bands other than 2.4 GHz and 5 GHz,
you should be able to calculate with more accuracy what is the maximum time
you are allowed to go offchannel. You'll only get one shot at this calculation:
at the end of the next DTIM if you're already in power save mode. So if our
TSF is off from the last beacon you received from the AP then when going
offchannel you will likely not make the right computation.

> ... what am I missing?

Not sure if this helps. Please let me know.

> > > > And I'm saying its not. To wait for the DTIM you need to know the DTIM
> > > > count, and you could also miss a few DTIM beacons. 
> > > 
> > > What do you mean by "need to know the DTIM count"? You just need to look
> > > at every received beacon.
> > 
> > The DTIM count on the TIM information element tells stations how many beacons
> > must be transmitted before receiving the next DTIM. The DTIM count will be 0
> > when we've reached a DTIM.
> > 
> > http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings
> > 
> > If you do not know the DTIM count at which beacon will we get the DTIM?
> 
> Each beacon contains the count and period ... we're just going around in
> circles. You just need a single beacon frame.

OK sure.

> > It is a subjective matter, I agree, it depends how reliable you want
> > to claim mac80211 is for broadcast and multicast traffic when drivers
> > use sw scan. One key item that is more important though is if we are
> > only trying to be on our home channel when doing offchannel operation
> > for bg scanning then we must also send a PS-POLL to get our own buffered
> > unicast frames after DTIM.
> 
> No, we don't need to send PS-poll as we send a wakeup. I think, anyway.

How else would we get buffered unicast data from the AP?

> > > since it's not just as you did it now, but it really needs to be
> > > asynchronous with event callbacks,
> > 
> > In case of firmware timeouts? Or what?
> 
> No, just the polling you have now doesn't seem adequate.

Heh yeah, I agree with that completely. I just can't figure out
a better way yet. I suspect things would be a lot easier if all the
work ath9k did would be in mac80211 already.

> > > and error handling is also more
> > > complex in the mac80211/driver interaction case (what if the driver
> > > never returns the event in the timeout? then mac80211 asks for the next
> > > channel, but the driver _then_ returns the event? etc.)
> > 
> > So I am not sure what you are referring to here. Are you referring to
> > timeouts for calls we make on the driver for wait constraints or
> > are you referring to possible endless wait constraints?
> > 
> > If the first, then I do not follow.
> > 
> > If the later, then I think it shouldn't happen often enough *if* we
> > actually end up dealing with most constraints properly in mac80211.
> > 
> > Or maybe I just completely misunderstood this last point.
> 
> No, I'm referring to the fact that when we don't poll, we'll be waiting
> for the driver to tell us when we can go offchannel. But what if the
> driver for some reason doesn't tell us within an acceptable timeout
> period? Say it has endless constraints. Do we require drivers to
> _always_ tell us? What then if the driver's buggy? etc.

If we have all the work within mac80211 I don't suspect we'll need even
events, we'd just know immediately when going offchannel of the status
of the hardware. If we don't have all the wait constraints addressed in
mac80211 then yeah, things get fishy and we either need polling which we
both don't like or events.

Relying on events is kind of odd for scanning. Say a user issues a scan
while associated. The command will sit there and wait until the driver
sends an event for when its ready -- or we fail. I suppose that is not
so unreasonable..

> > Worst case scenerio we will just have to review this in more detail next week
> > in person on Thursday or Friday during the wireless summit.
> 
> Actually let's do that, since anything that isn't purely implemented in
> mac80211 should probably take into account multi-channel virtual
> interface operation as well, which we'll probably want to offload to the
> driver for scheduling between interfaces.

OK sure, but I may still need some sort of solution in the interim,
we'll see!

  Luis
