Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40249 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbYIRQYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 12:24:48 -0400
Date: Thu, 18 Sep 2008 13:24:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918162440.GL1583@khazad-dum.debian.net> (sfid-20080918_182511_853674_11791D08)
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918142405.GG1583@khazad-dum.debian.net> <200809181628.22544.IvDoorn@gmail.com> <20080918144836.GI1583@khazad-dum.debian.net> <48D27103.1050709@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48D27103.1050709@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Larry Finger wrote:
> Henrique de Moraes Holschuh wrote:
> > IMHO if tx power off is handled by the wireless device driver through the
> > software rfkill line, it DOES MEAN the radio goes into rfkill SOFT_BLOCK.
> > 
> > As long as the rfkill class is kept syncronized with reality through the use
> > of rfkill_force_state(), this WILL work just fine, because no input events
> > that change any other devices are ever sent by the rfkill core.
> > 
> > Now, if any input event generation (by the wireless device driver, since
> > rfkill core NEVER does it) is in the picture, it could be more complicated
> > (or not... after all, an *INPUT DEVICE* switch would simply *always* match
> > the *particular* hardware rfkill input line it is tied to, regardless of
> > radio state -- the input device does not CARE at all about the software
> > rfkill lines, other hardware rfkill lines, wireless tx power state, or phase
> > of the moon).
> 
> OK, now I'm totally confused. I realize that English is probably not
> your first language, but simple declarative sentences would be nice.

I will try :)

> The situation with b43 is as follows:
> 
> (a) When the hardware switch is off, the radio is hardware blocked.
>
> (b) When the hardware switch is on, the radio should follow whatever
> mac80211 and userland wants.

The problem is in the "should".

Maybe something else than b43 (like firmware) changed the radio software
rfkill bit, and it does not match what mac80211 and userland requested
anymore.

What you need to pass to rfkill_force_state() is what the radio is currently
doing.  So, the state you need to send to rfkill_force_state has to be based
on the real state of the hardware's "soft switch bit".

If the hardware "soft switch" bit is write-only, you have no choice but to
use the mac80211 value like your V2 patch does, BTW.

> What should b43 do to make this happen? Does V2 do it right?

Read the software switch state from the hardware instead of using what
mac80211/user wants.  That's all.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
