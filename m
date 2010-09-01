Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0IAKlh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 06:41:37 -0400
Subject: Re: [RFC 0/3] mac80211: new API for handling broadcast / multicast
 on sw scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Matt Smith <Matt.Smith@Atheros.com>,
	Kevin Hayes <kevin@Atheros.com>,
	David Quan <David.Quan@Atheros.com>
In-Reply-To: <20100901021418.GC12472@tux>
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
	 <20100901021418.GC12472@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 12:41:34 +0200
Message-ID: <1283337694.4131.19.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-31 at 19:14 -0700, Luis R. Rodriguez wrote:

> > > So we do the TSF synch to more reliably know when we will get a DTIM and also
> > > adjust our beacon miss interrupt. For offchannel operation know the DTIM
> > > more accurately will help in our computation when going off channel.
> > 
> > Yeah but when _going_ offchannel we don't need to know exactly when it
> > will happen in advance, we can just wait for the relevant thing to end
> > and then go offchannel 
> 
> And how do we do this currently wait for the relevant things to end
> in mac802111 prior to going offchannel ? We agree we don't, right. 

Yes, we don't, right now.

> But
> what we're trying to get more agreement on is what items we do need
> to wait on. Let me clarify what I believe these are and show their
> dependency graph:
> 
>   * ACK for nullfunc for offchannel operation - not handled yet
>   * Do not go offchannel when we would expect the DTIM -- not handled yet
> 
> That's it!

Agreed.

> But the second one require some more consideration. Lets consider
> the worst case scenerio. After we get the DTIM we will get all buffered
> broadcast and multicast buffered frames from the AP. This will ultimately
> vary depending on the size of your BSS, so you cannot easily compute this
> as a station, unless you add some guess fudge factor and that will
> ultimately be very subjective. 

Yeah but you don't need to compute it... you can just wait for it.

> So I argue you cannot calculate this
> and instead it is easier to monitor for the broadcast / multicast data
> sent by the AP and check when we get the last one (the more bit is off).

Right.

> Do you agree with that? If not how else do you suggest we calculate this
> on mac80211?

Yes, I agree, we don't need to compute it beforehand.

> Now, lets consider an even harier situation. Say we use the above mechanism
> but you missed the last frame that indicates that there are no more broadcast
> and multicast traffic, your next best bet is to timeout on the next beacon
> and assume no more broadcast / multicast traffic is pending. Consider this
> situation now if our DTIM is 1 though and we happen to have a lot of noise
> and happen to loose the last broadcast / multicast frame with the with the
> more bit off... We just won't be able to go offchannel unless we are willing
> to drop frames in that worst case scenerio and we really value our broadcast
> and multicast frames. You could also deal with only going offchannel if
> you do get this more bit off. If DTIM period is > 1 though then we have
> more flexibility and can rely on the next beacon for a timeout indication
> to know we can then go off channel.

Yeah, but if you value your multicast traffic _that_ much, you'd better
know up front and never actually ask mac80211 to scan. If it's asked to
scan, the only sensible thing to do is to actually do a scan, even if
that might mean dropping some multicast traffic.

> Now, all this is sensitive to timing constraints lead by the DTIM count.
> As the DTIM period increases it means we are able to skip more beacons for
> going offchannel. Consider a DTIM period (also called DTIM interval on my
> E3000 it seems) of 100.

I realise you're doing this for illustration purposes, but a DTIM period
of 100 is insane, even with a short beacon interval.

> But if we start doing more complex things while off channel (*cough*) or
> consider a few years with new possible bands other than 2.4 GHz and 5 GHz,
> you should be able to calculate with more accuracy what is the maximum time
> you are allowed to go offchannel.

Hopefully, by then, 802.11v will be deployed in access points ...

> You'll only get one shot at this calculation:
> at the end of the next DTIM if you're already in power save mode. So if our
> TSF is off from the last beacon you received from the AP then when going
> offchannel you will likely not make the right computation.

Yet still, I see this as the other way around. With powersave, you're
limiting your saved power by all these factors, and you return for
multicast traffic etc. But when you ask for a scan, where's the
trade-off? Should we really make the scan basically useless in order to
not lose multicast frames? I say no, if you ask for a scan you've got to
consider the possibility it may cause dropping multicast frames.

> > > It is a subjective matter, I agree, it depends how reliable you want
> > > to claim mac80211 is for broadcast and multicast traffic when drivers
> > > use sw scan. One key item that is more important though is if we are
> > > only trying to be on our home channel when doing offchannel operation
> > > for bg scanning then we must also send a PS-POLL to get our own buffered
> > > unicast frames after DTIM.
> > 
> > No, we don't need to send PS-poll as we send a wakeup. I think, anyway.
> 
> How else would we get buffered unicast data from the AP?

We send a nullfunc wakeup to it, and it just flushes all the frames to
us.

> If we have all the work within mac80211 I don't suspect we'll need even
> events, we'd just know immediately when going offchannel of the status
> of the hardware. If we don't have all the wait constraints addressed in
> mac80211 then yeah, things get fishy and we either need polling which we
> both don't like or events.

Yeah, but the way I see it it's not so bad that we can't fairly easily
implement it in mac80211 now. You've stated before that we really only
need to wait for two things (I'll repeat them):
 * ACK for nullfunc for offchannel operation - not handled yet
 * Do not go offchannel when we would expect the DTIM -- not handled yet

ACK for nullfunc is pretty easy, really, but I suspect once you
implement flush it will no longer matter since we can just do this:
 1) stop sdata traffic
 2) drv_flush()
 3) queue up nullfunc frame on VO
 4) drv_flush() again
 5) do channel switch etc.

which will make sure the nullfunc frame went out _last_ and it actually
went out before we channel switch


DTIM handling is slightly more complicated, but all it really needs to
do is turn off powersave, and wait for the beacon. That doesn't seem so
complex to implement -- probably easier, in fact, than doing the stuff
you did properly without polling.

(of course, we should probably also re-implement software scanning in
terms of off-channel work, so we don't have to do everything twice)

johannes

