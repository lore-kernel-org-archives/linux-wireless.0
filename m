Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:57769 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754356AbYIRPRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 11:17:25 -0400
Message-ID: <48D27103.1050709@lwfinger.net> (sfid-20080918_171743_470866_793ACA13)
Date: Thu, 18 Sep 2008 10:17:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Ivo van Doorn <ivdoorn@gmail.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918142405.GG1583@khazad-dum.debian.net> <200809181628.22544.IvDoorn@gmail.com> <20080918144836.GI1583@khazad-dum.debian.net>
In-Reply-To: <20080918144836.GI1583@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> 
> IMHO if tx power off is handled by the wireless device driver through the
> software rfkill line, it DOES MEAN the radio goes into rfkill SOFT_BLOCK.
> 
> As long as the rfkill class is kept syncronized with reality through the use
> of rfkill_force_state(), this WILL work just fine, because no input events
> that change any other devices are ever sent by the rfkill core.
> 
> Now, if any input event generation (by the wireless device driver, since
> rfkill core NEVER does it) is in the picture, it could be more complicated
> (or not... after all, an *INPUT DEVICE* switch would simply *always* match
> the *particular* hardware rfkill input line it is tied to, regardless of
> radio state -- the input device does not CARE at all about the software
> rfkill lines, other hardware rfkill lines, wireless tx power state, or phase
> of the moon).

OK, now I'm totally confused. I realize that English is probably not
your first language, but simple declarative sentences would be nice.

The situation with b43 is as follows:

(a) When the hardware switch is off, the radio is hardware blocked.

(b) When the hardware switch is on, the radio should follow whatever
mac80211 and userland wants.

What should b43 do to make this happen? Does V2 do it right?

Larry
