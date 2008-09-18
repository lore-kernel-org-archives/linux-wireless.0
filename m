Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:61777 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbYIRUlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:41:06 -0400
Received: by nf-out-0910.google.com with SMTP id d3so46557nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 13:41:04 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 22:41:00 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809182006.58620.IvDoorn@gmail.com> <20080918201004.GR1583@khazad-dum.debian.net>
In-Reply-To: <20080918201004.GR1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809182241.00906.IvDoorn@gmail.com> (sfid-20080918_224115_709504_06B01314)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Johannes Berg wrote:
> > > On Thu, 2008-09-18 at 19:52 +0200, Ivo van Doorn wrote:
> > > > From rfkill.h:
> > > > 	RFKILL_STATE_SOFT_BLOCKED = 0,	/* Radio output blocked */
> > > > 	RFKILL_STATE_UNBLOCKED    = 1,	/* Radio output allowed */
> > > > 	RFKILL_STATE_HARD_BLOCKED = 2,	/* Output blocked, non-overrideable */
> > > > 
> > > > Since b43 has a rfkill mechanism that does switch of the radio when RFKILL is set to BLOCK
> > > > after a key press, it should send RFKILL_STATE_HARD_BLOCKED because rfkill cannot override
> > > > it.
> > > > 
> > > > rt2x00 hardware does not change the radio state when RFKILL is set to BLOCK after a key press,
> > > > the state is therefor overridable and it can send RFKILL_STATE_SOFT_BLOCKED to rfkill.
> > > 
> > > If rt2x00 has no meaning of "hardware blocked", why is the button not a
> > > simple input device?
> > 
> > Because I had that discussion with Henrique and that ended with a "it isn't a input device"...
> 
> Because I NEVER UNDERSTOOD it was not a hardware rfkill line until a few
> posts ago in this thread.  Argh.  My deepest apologies for that screw up.
> 
> Now that I do, my answer is "depends on how the platform used that input pin".
> 
> If it is directly connected to a switch (you get on/off from it) or a button
> (you get "I have been pressed, please toggle the state"), it is an input
> device.  [a]
> 
> If it is directly connected to some crap inside the platform, that is
> controlled by firmware, it is NOT an input device.  [b]

Ok, rt2x00 is definately [a]

> I hope it is a switch, and that you can just always provide an input device
> that issues some sort of EV_SW event (if you need it, we ask Dmitry to add
> EV_SW SW_WLAN).

Ok, I'll readd the input_polldev to rt2x00 again then. :)

Ivo
