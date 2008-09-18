Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43157 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754390AbYIRVhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 17:37:33 -0400
Date: Thu, 18 Sep 2008 18:36:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918213657.GY1583@khazad-dum.debian.net> (sfid-20080918_233737_304177_8EB7DE01)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809182006.58620.IvDoorn@gmail.com> <20080918201004.GR1583@khazad-dum.debian.net> <200809182241.00906.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809182241.00906.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > On Thursday 18 September 2008, Johannes Berg wrote:
> > > > On Thu, 2008-09-18 at 19:52 +0200, Ivo van Doorn wrote:
> > > > > From rfkill.h:
> > > > > 	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
> > > > > 	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
> > > > > 	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */
> > > > > 
> > > > > Since b43 has a rfkill mechanism that does switch of the radio when RFKILL is set to BLOCK
> > > > > after a key press, it should send RFKILL_STATE_HARD_BLOCKED because rfkill cannot override
> > > > > it.
> > > > > 
> > > > > rt2x00 hardware does not change the radio state when RFKILL is set to BLOCK after a key press,
> > > > > the state is therefor overridable and it can send RFKILL_STATE_SOFT_BLOCKED to rfkill.
> > > > 
> > > > If rt2x00 has no meaning of "hardware blocked", why is the button not a
> > > > simple input device?
> > > 
> > > Because I had that discussion with Henrique and that ended with a "it isn't a input device"...
> > 
> > Because I NEVER UNDERSTOOD it was not a hardware rfkill line until a few
> > posts ago in this thread.  Argh.  My deepest apologies for that screw up.
> > 
> > Now that I do, my answer is "depends on how the platform used that input pin".
> > 
> > If it is directly connected to a switch (you get on/off from it) or a button
> > (you get "I have been pressed, please toggle the state"), it is an input
> > device.  [a]
> > 
> > If it is directly connected to some crap inside the platform, that is
> > controlled by firmware, it is NOT an input device.  [b]
> 
> Ok, rt2x00 is definately [a]
> 
> > I hope it is a switch, and that you can just always provide an input device
> > that issues some sort of EV_SW event (if you need it, we ask Dmitry to add
> > EV_SW SW_WLAN).
> 
> Ok, I'll readd the input_polldev to rt2x00 again then. :)

But do use EV_SW if it is a switch, please :-)  Even if that means a need to
get EV_SW SW_WLAN out of Dmitry...  I don't know if rt2x000 wants SW_WLAN or
SW_RFKILL_ALL.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
