Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0HaSMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 14:12:23 -0400
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
	David Quan <David.Quan@atheros.com>
In-Reply-To: <20100831165931.GC15752@tux>
References: <1282979590-31113-1-git-send-email-lrodriguez@atheros.com>
	 <1283177949.3691.72.camel@jlt3.sipsolutions.net>
	 <AANLkTinOzTHn4okTdm=321sdAKy8z1ji_1K_SsDd_dH2@mail.gmail.com>
	 <1283183279.3691.82.camel@jlt3.sipsolutions.net>
	 <AANLkTi=bVRaDs6z6EavxCLFdMeNRhB=85yKtaHr-_hL-@mail.gmail.com>
	 <1283191837.3694.13.camel@jlt3.sipsolutions.net>
	 <AANLkTin9KBUTZSkiL-qMnToaMjXS9S3j3PzV-AZWa_9U@mail.gmail.com>
	 <1283265399.3733.18.camel@jlt3.sipsolutions.net>
	 <AANLkTi=yRnMwTBq1ze8LaMCO521YutrtxJpBS0rGuvhJ@mail.gmail.com>
	 <1283270092.3733.41.camel@jlt3.sipsolutions.net>
	 <20100831165931.GC15752@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 20:12:20 +0200
Message-ID: <1283278340.3733.56.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-31 at 09:59 -0700, Luis R. Rodriguez wrote:

> > > This is true, but why would they not be important for going off
> > > channel ? The TSF sync seems just as important as waiting for the ACK
> > > for the nullfunc from the AP.
> > 
> > Why? It doesn't seem important to me?
> 
> How else could you possibly do a reliable calculation for the computation of the
> next DTIM?

Dunno what your TSF sync does, but a single beacon frame has all the
relevant information for computing this.

> So we do the TSF synch to more reliably know when we will get a DTIM and also
> adjust our beacon miss interrupt. For offchannel operation know the DTIM
> more accurately will help in our computation when going off channel.

Yeah but when _going_ offchannel we don't need to know exactly when it
will happen in advance, we can just wait for the relevant thing to end
and then go offchannel ... what am I missing?

> > > And I'm saying its not. To wait for the DTIM you need to know the DTIM
> > > count, and you could also miss a few DTIM beacons. 
> > 
> > What do you mean by "need to know the DTIM count"? You just need to look
> > at every received beacon.
> 
> The DTIM count on the TIM information element tells stations how many beacons
> must be transmitted before receiving the next DTIM. The DTIM count will be 0
> when we've reached a DTIM.
> 
> http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings
> 
> If you do not know the DTIM count at which beacon will we get the DTIM?

Each beacon contains the count and period ... we're just going around in
circles. You just need a single beacon frame.

> It is a subjective matter, I agree, it depends how reliable you want
> to claim mac80211 is for broadcast and multicast traffic when drivers
> use sw scan. One key item that is more important though is if we are
> only trying to be on our home channel when doing offchannel operation
> for bg scanning then we must also send a PS-POLL to get our own buffered
> unicast frames after DTIM.

No, we don't need to send PS-poll as we send a wakeup. I think, anyway.

> > since it's not just as you did it now, but it really needs to be
> > asynchronous with event callbacks,
> 
> In case of firmware timeouts? Or what?

No, just the polling you have now doesn't seem adequate.

> > and error handling is also more
> > complex in the mac80211/driver interaction case (what if the driver
> > never returns the event in the timeout? then mac80211 asks for the next
> > channel, but the driver _then_ returns the event? etc.)
> 
> So I am not sure what you are referring to here. Are you referring to
> timeouts for calls we make on the driver for wait constraints or
> are you referring to possible endless wait constraints?
> 
> If the first, then I do not follow.
> 
> If the later, then I think it shouldn't happen often enough *if* we
> actually end up dealing with most constraints properly in mac80211.
> 
> Or maybe I just completely misunderstood this last point.

No, I'm referring to the fact that when we don't poll, we'll be waiting
for the driver to tell us when we can go offchannel. But what if the
driver for some reason doesn't tell us within an acceptable timeout
period? Say it has endless constraints. Do we require drivers to
_always_ tell us? What then if the driver's buggy? etc.

> Worst case scenerio we will just have to review this in more detail next week
> in person on Thursday or Friday during the wireless summit.

Actually let's do that, since anything that isn't purely implemented in
mac80211 should probably take into account multi-channel virtual
interface operation as well, which we'll probably want to offload to the
driver for scheduling between interfaces.

johannes

