Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3AaPdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:33:52 -0500
Message-ID: <1359646451.8415.81.camel@jlt4.sipsolutions.net> (sfid-20130131_163355_692875_B1076FD3)
Subject: Re: [RFC 2/3] mac80211: mesh power save doze scheduling
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Thu, 31 Jan 2013 16:34:11 +0100
In-Reply-To: <510A8C7E.9070602@cozybit.com> (sfid-20130131_162345_969361_FC634F51)
References: <1358936360-7795-1-git-send-email-marco@cozybit.com>
	  <1358936360-7795-3-git-send-email-marco@cozybit.com>
	  (sfid-20130123_111932_695381_467B8C3D) <1359640314.8415.31.camel@jlt4.sipsolutions.net>
	 <510A8C7E.9070602@cozybit.com> (sfid-20130131_162345_969361_FC634F51)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 16:23 +0100, Marco Porsch wrote:
> On 01/31/2013 02:51 PM, Johannes Berg wrote:
> > On Wed, 2013-01-23 at 11:19 +0100, Marco Porsch wrote:
> >
> >> Expose a callback ieee80211_mps_init for drivers to register
> >> mesh powersave ops:
> >> - hw_doze - put the radio to sleep now
> >> - hw_wakeup - wake the radio up for frame RX
> >> These ops may be extended in the future to allow drivers/HW to
> >> implement mesh PS themselves. (The current design goal was to
> >> concentrate mesh PS routines in mac80211 to keep driver
> >> modifications minimal.
> >>
> >> Track the beacon timing information of peers we are in PS mode
> >> towards. Set a per-STA hrtimer which will trigger a wakeup right
> >> before the peer's next TBTT.
> >> Also use the same hrtimer to go to sleep mode after not
> >> receiving a beacon in a defined time margin. In this case
> >> calculate the next TBTT and increase the margin.
> >>
> >> For mesh Awake Windows wakeup on SWBA (beacon_get_tim) and start
> >> a timer which triggers a hw_doze call on expiry.
> >
> > Hmm. I'm not completely happy with this hrtimer stuff in mac80211.
> > There's a lot of (USB) hardware that could never implement such a thing,
> > but could, conceivably, implement this differently?
> 
> The use of hrtimers for MPS is debatable currently. The approach of 
> calculating the peer's TSF should be accurate to the usec. Good timing 
> here directly affects the energy savings. On the other handside the 
> margin of 5ms used shows that something is not working as expected yet. 
> If this cannot be fixed, I may as well use regular timers here. How 
> strongly do you oppose hrtimers? :)

Oh it's not the user of hrtimers vs. timers (although first using an
hrtimer and then kicking off to a work struct seems ... pointless and
questionable), it's more the fact that you're starting to put real-time
behaviour into mac80211. I'm not entirely convinced that is the right
approach for "core" mac80211.

> > So I think you should (at least attempt to) make an implementation that
> > is less tied to the exact timing implementation. Maybe program the
> > wakeup TBTT in advance.  Maybe with a small library the driver can
> > connect to this that uses hrtimers to implement it? That could then also
> > assume that callbacks need not sleep, thus allowing to reduce
> > TBTT_MARGIN.
>  >
> > In theory I think with ath9k you could even use hardware timers &
> > interrupts to wake the hardware, thus probably being able to reduce
> > TBTT_MARGIN significantly.
> 
> Earlier, I had successfully implemented wakeups using ath9k HW before we 
> at cozybit decided to concentrate all code in mac80211. Concerning ath9k 
> it worked fine but required more callbacks to mac80211 and will 
> eventually add redundant code that has to be maintained to multiple drivers.

The question isn't so much about concentrating the code, I think you can
still do that for most devices, and use hrtimers more effectively, if
you somewhat put it off to the side in a less integrated way. I'm
thinking that, for example, if I ever wanted to implement this with our
current device (not likely, but just for perspective) we'd definitely
want to program the firmware to do all the real-time behaviour. In fact,
I suspect we probably could with the new MVM firmware API.

Therefore, I think it would be better to have a more generic
time-oriented interface in mac80211, and put the actual implementation
of the events a bit separately in a way that it is optional for drivers
and not used in the API.

johannes

