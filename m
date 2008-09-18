Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46889 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599AbYIRU2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:28:50 -0400
Date: Thu, 18 Sep 2008 17:28:45 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918202845.GV1583@khazad-dum.debian.net> (sfid-20080918_222854_141155_F7C8C231)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181948.27507.IvDoorn@gmail.com> <20080918190844.GO1583@khazad-dum.debian.net> <200809182217.41186.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809182217.41186.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > This depends on the hardware, for b43 the toggle() callback might not be needed,
> > > but for rt2x00 it does (Since the key press will only raise a GPIO bit and does not
> > > affect the radio in any way).
> > 
> > Hmm... please correct me if I misunderstood, but wouldn't that mean that
> > rt2x00 does not have a hardware rfkill line at all, and that instead it has
> > a GPIO pin that is used to communicate the desire to software-rfkill the
> > transmitter...  and the driver needs to do everything.
> 
> That is correct.

Yeah, thanks <deity> I noticed this post :-)  That will make it MUCH easier
for me to sync with you and actually grok what you are saying.

> > And if you don't emulate HARD_BLOCKED, you have to handle the input device
> > inside the rt2x00 driver, because the world outside (and that includes the
> > rfkill core and everything else) sure as heck won't know if you SOFT_BLOCKED
> > because of that GPIO pin, or because of something else.
> 
> Currently rt2x00 polls the GPIO pin every second (no interrupts are raised when the
> GPIO pin is toggled) and uses rfkill_force_state(SOFT_BLOCK/UNBLOCK) to rfkill

I just sent a post about it.  If you get a bit that tells you HW RFKILL
ACTIVE/INACTIVE (as opposed to "please toggle it"), you don't need to care
about whatever else is reading that thing.  You can always register an input
device, and issue EV_SW SW_WLAN or EV_SW SW_RFKILL_ALL (I'd sugest making it
configurable).  But do NOT issue EV_KEY, THAT one breaks if anything else is
also listening to that input signal.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
