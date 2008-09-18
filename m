Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:47669 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756690AbYIROsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 10:48:43 -0400
Date: Thu, 18 Sep 2008 11:48:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918144836.GI1583@khazad-dum.debian.net> (sfid-20080918_164901_696669_364B080A)
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918142405.GG1583@khazad-dum.debian.net> <200809181628.22544.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181628.22544.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > On Thu, 18 Sep 2008, Larry Finger wrote:
> > > The changes below, along with Henriques patch "[PATCH] rfkill: update
> > > LEDs for all state changes", and the reversion of commit bc19d6e make
> > > the wireless LED toggle correctly.
> > > 
> > > This version passes UNBLOCKED to rfkill when the hardware switch enables the radio.
> > 
> > As I said in an email I just sent (unfortunately, after you already sent
> > this patch), whatever goes to rfkill_force_state must be the CURRENT state
> > of the hardware.
> > 
> > So, depending on what happens to b43 hardware when the hardware switch
> > enables it (i.e. does it enable for real, ignoring the software rfkill input
> > lines?), this patch might or might not be correct.
> 
> As far as I can see the v2 patch is correct, it sends the BLOCK event when the
> rfkill key was pressed to block the radio and the UNBLOCK event when the rfkill
> key was pressed to unblock the radio.

If rfkill_force_state() is being used, you MUST send to it the *real* radio
state.  Not the cached radio state, not "desired" radio state, not "user
requested" radio state.  It has to be the *real* radio state.

If a device driver is not doing so, it is incorrect and either it must send
the real radio state, or it should be doing something else than calling
rfkill_force_state().

> The change compared to v1 was needed to prevent BLOCK events to be send
> when user has manually disabled the radio for the interface through another
> interface then rfkill (and thus wasn't a rfkill event).

IMHO if tx power off is handled by the wireless device driver through the
software rfkill line, it DOES MEAN the radio goes into rfkill SOFT_BLOCK.

As long as the rfkill class is kept syncronized with reality through the use
of rfkill_force_state(), this WILL work just fine, because no input events
that change any other devices are ever sent by the rfkill core.

Now, if any input event generation (by the wireless device driver, since
rfkill core NEVER does it) is in the picture, it could be more complicated
(or not... after all, an *INPUT DEVICE* switch would simply *always* match
the *particular* hardware rfkill input line it is tied to, regardless of
radio state -- the input device does not CARE at all about the software
rfkill lines, other hardware rfkill lines, wireless tx power state, or phase
of the moon).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
