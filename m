Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35758 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbYIRUKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:10:10 -0400
Date: Thu, 18 Sep 2008 17:10:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918201004.GR1583@khazad-dum.debian.net> (sfid-20080918_221014_012705_EFA2DB7A)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181952.15770.IvDoorn@gmail.com> <1221760449.9262.96.camel@johannes.berg> <200809182006.58620.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809182006.58620.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Johannes Berg wrote:
> > On Thu, 2008-09-18 at 19:52 +0200, Ivo van Doorn wrote:
> > > From rfkill.h:
> > > 	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
> > > 	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
> > > 	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */
> > > 
> > > Since b43 has a rfkill mechanism that does switch of the radio when RFKILL is set to BLOCK
> > > after a key press, it should send RFKILL_STATE_HARD_BLOCKED because rfkill cannot override
> > > it.
> > > 
> > > rt2x00 hardware does not change the radio state when RFKILL is set to BLOCK after a key press,
> > > the state is therefor overridable and it can send RFKILL_STATE_SOFT_BLOCKED to rfkill.
> > 
> > If rt2x00 has no meaning of "hardware blocked", why is the button not a
> > simple input device?
> 
> Because I had that discussion with Henrique and that ended with a "it isn't a input device"...

Because I NEVER UNDERSTOOD it was not a hardware rfkill line until a few
posts ago in this thread.  Argh.  My deepest apologies for that screw up.

Now that I do, my answer is "depends on how the platform used that input pin".

If it is directly connected to a switch (you get on/off from it) or a button
(you get "I have been pressed, please toggle the state"), it is an input
device.  [a]

If it is directly connected to some crap inside the platform, that is
controlled by firmware, it is NOT an input device.  [b]

And if it is always used in the same way, you can pick one of the two and go
with it.

If it is [b] and it is a *switch*, it won't cause any crap, you can just
always register an input device and go with it.

if it is [b] and it is a button, you CANNOT issue input events from it if
there is any driver driving the firmware's platform... or you would get
multiple events, which is a major issue for EV_KEY.

I hope it is a switch, and that you can just always provide an input device
that issues some sort of EV_SW event (if you need it, we ask Dmitry to add
EV_SW SW_WLAN).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
