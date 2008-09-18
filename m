Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40260 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757245AbYIRUcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:32:42 -0400
Date: Thu, 18 Sep 2008 17:32:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918203235.GW1583@khazad-dum.debian.net> (sfid-20080918_223248_949100_EFC57CD8)
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <20080918162440.GL1583@khazad-dum.debian.net> <48D2867D.6010501@lwfinger.net> <200809181920.10416.mb@bu3sch.de> <20080918202158.GT1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080918202158.GT1583@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Michael Buesch wrote:
> > On Thursday 18 September 2008 18:49:01 Larry Finger wrote:
> > > Henrique de Moraes Holschuh wrote:
> > > > The problem is in the "should".
> > > > 
> > > > Maybe something else than b43 (like firmware) changed the radio software
> > > > rfkill bit, and it does not match what mac80211 and userland requested
> > > > anymore.
> > > > 
> > > > What you need to pass to rfkill_force_state() is what the radio is currently
> > > > doing.  So, the state you need to send to rfkill_force_state has to be based
> > > > on the real state of the hardware's "soft switch bit".
> > > 
> > > The hardware does not have such a bit. Once it is initialized and
> > > mac80211 sends it a packet, it will try to send it. That is true even
> > > if the hardware switch is off. It just will not succeed.
> > 
> > Right, b43 does have two "bits". One read-only bit that tells the hardware
> > block state. This state can only be changed by physically pressing rfkill
> > button. The other "bit" is a read/write "bit" to turn off the radio in software.
> > If _either_ one bit is blocking the radio, it will be physically blocked.
> 
> A software-emulated rfkill line is still a SW rfkill line, and the rfkill
> core needs to know about it [but you don't want to have set txpower off
> state mixed in whatever you send back to the rfkill core].

I forgot to add that you don't always need to do a rfkill_force_state() just
because a SW rfkill line changed.

If that change can only come through the rfkill core (i.e. through the
toggle_radio() hook), the rfkill core already knows about it.

You *still* take the sw rfkill line into account when you do
rfkill_force_state().  It just might not be reason enough to actually call
rfkill_force_state().

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
