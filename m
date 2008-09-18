Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:58313 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbYIRURq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:17:46 -0400
Received: by ey-out-2122.google.com with SMTP id 6so31733eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 13:17:44 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 22:17:40 +0200
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181948.27507.IvDoorn@gmail.com> <20080918190844.GO1583@khazad-dum.debian.net>
In-Reply-To: <20080918190844.GO1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809182217.41186.IvDoorn@gmail.com> (sfid-20080918_221753_080405_28F837A4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > This depends on the hardware, for b43 the toggle() callback might not be needed,
> > but for rt2x00 it does (Since the key press will only raise a GPIO bit and does not
> > affect the radio in any way).
> 
> Hmm... please correct me if I misunderstood, but wouldn't that mean that
> rt2x00 does not have a hardware rfkill line at all, and that instead it has
> a GPIO pin that is used to communicate the desire to software-rfkill the
> transmitter...  and the driver needs to do everything.

That is correct.

> If the above is wrong, don't bother with the rest of this email.
> 
> If the above is correct, you'd not have HARD_BLOCKED at all in rt2x00, just
> SOFT_BLOCK.  Unless you somehow emulated HARD_BLOCKED.

True, and that is why rt2x00 is generating the SOFT_BLOCK. :)

> Without a real hardware rfkill line, the only way to have HARD_BLOCKED is
> through software emulation inside the driver, but that is only safe if you
> are absolutely SURE no firmware or other crap will poke at the hardware
> behind your back.

I am sure of that.

> And if you don't emulate HARD_BLOCKED, you have to handle the input device
> inside the rt2x00 driver, because the world outside (and that includes the
> rfkill core and everything else) sure as heck won't know if you SOFT_BLOCKED
> because of that GPIO pin, or because of something else.

Currently rt2x00 polls the GPIO pin every second (no interrupts are raised when the
GPIO pin is toggled) and uses rfkill_force_state(SOFT_BLOCK/UNBLOCK) to rfkill

Ivo
