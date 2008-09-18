Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46367 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754347AbYIRTIw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 15:08:52 -0400
Date: Thu, 18 Sep 2008 16:08:44 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918190844.GO1583@khazad-dum.debian.net> (sfid-20080918_210855_443805_A91C56D4)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181553.29140.IvDoorn@gmail.com> <200809181937.38257.mb@bu3sch.de> <200809181948.27507.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181948.27507.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> This depends on the hardware, for b43 the toggle() callback might not be needed,
> but for rt2x00 it does (Since the key press will only raise a GPIO bit and does not
> affect the radio in any way).

Hmm... please correct me if I misunderstood, but wouldn't that mean that
rt2x00 does not have a hardware rfkill line at all, and that instead it has
a GPIO pin that is used to communicate the desire to software-rfkill the
transmitter...  and the driver needs to do everything.

If the above is wrong, don't bother with the rest of this email.

If the above is correct, you'd not have HARD_BLOCKED at all in rt2x00, just
SOFT_BLOCK.  Unless you somehow emulated HARD_BLOCKED.

Without a real hardware rfkill line, the only way to have HARD_BLOCKED is
through software emulation inside the driver, but that is only safe if you
are absolutely SURE no firmware or other crap will poke at the hardware
behind your back.

And if you don't emulate HARD_BLOCKED, you have to handle the input device
inside the rt2x00 driver, because the world outside (and that includes the
rfkill core and everything else) sure as heck won't know if you SOFT_BLOCKED
because of that GPIO pin, or because of something else.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
