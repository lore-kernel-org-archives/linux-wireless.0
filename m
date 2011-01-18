Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1ARJEr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 04:04:47 -0500
Subject: Re: Fwd: [PATCH 06/10] mac80211: add HW flag for disabling auto
 link-PS in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <AANLkTiky+j6P9oibrWzDzfNugrADtb9p21TVn7WFAY6_@mail.gmail.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-7-git-send-email-arik@wizery.com>
	 <1295167829.3574.10.camel@jlt3.sipsolutions.net>
	 <AANLkTik=WDsehr0EgW7QemfdmokvaLzg1ugASwiuCOXt@mail.gmail.com>
	 <AANLkTi=FRAjCxOBAtXFdzwSqG6DQ+oneoe-THQjsd_Wx@mail.gmail.com>
	 <1295256929.3726.2.camel@jlt3.sipsolutions.net>
	 <AANLkTiky+j6P9oibrWzDzfNugrADtb9p21TVn7WFAY6_@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jan 2011 10:05:31 +0100
Message-ID: <1295341531.3563.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 00:47 +0200, Arik Nemtsov wrote:

> > anyway. I'd appreciate if you could actually see which things would
> > potentially race -- I took a brief look into these functions and it
> > didn't look like there are actually races except of these two against
> > each other maybe?
> 
> Upon closer examination, I could find no races in the RX path. A race
> of ps_start/stop is possible of course, but I guess we can demand the
> calls to be synchronized against each other?

Yeah that seems fair. It'd be a strange driver too anyway, come to think
of it, since this is all from the device so needs to be processed from a
tasklet or whatever anyway.

> I did notice some concurrency that can happen in the TX path. I think
> the same essential race is described in
> ieee80211_handle_filtered_frame() between RX and TX paths. Only this
> time the PS state is changed manually and not in the RX handler. The
> warning in ieee80211_handle_filtered_frame() can be expanded to
> include:
> "always change PS state of connected stations before TX status events
> if ordering can be unknown, for example with different interrupt
> status bits."

Right, that was RX first, then TX status, I guess it can be extended a
bit. But really, this race doesn't apply since the entire PS state
management is done by the device here, and mac80211 just follows it.

> > > sta_notify is pretty useless when the low level driver calls toggles
> > > the PS-mode by itself. How about I simply remove the call to
> > > sta_notify in case IEEE80211_HW_AP_LINK_PS is set?
> > > If a low level driver needs to do some deferred processing after a
> > > PS-mode transition, it can queue a work on its own..
> >
> > Yes, that's probably a good idea -- but definitely needs to be
> > documented in the sta_notify docs. OTOH, mac80211 de-bounces sta_notify
> > in a way. Maybe that needs to be done for the function call as well,
> > maybe via a return value?
> >
> 
> I'm afraid I didn't catch your meaning here.

Well if for instance the station happens to send two frames with the PM
bit set, meaning that it is in PS-poll mode but doesn't want to wake up
even though it's transmitting a frame, mac80211 will only call
sta_notify once for the first frame to tell the driver the station went
to sleep -- the second frame just indicates that it's still asleep.

The same might happen with this, but of course it depends on what the
device does. If the driver will call the new API function twice, then
mac80211 will be very confused. Therefore, I think the new API function
should do some checks about whether the station is already asleep/awake
before invoking ap_sta_ps_start/end so that the counters are correct.

In this case, the driver might want to know if the station was already
in the indicated state -- this might be indicated by the return value.

johannes

