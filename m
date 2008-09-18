Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33554 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767AbYIRUYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:24:14 -0400
Date: Thu, 18 Sep 2008 17:24:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918202406.GU1583@khazad-dum.debian.net> (sfid-20080918_222416_959466_1AE082CF)
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <200809181628.22544.IvDoorn@gmail.com> <20080918144836.GI1583@khazad-dum.debian.net> <200809181946.11477.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181946.11477.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Michael Buesch wrote:
> On Thursday 18 September 2008 16:48:36 Henrique de Moraes Holschuh wrote:
> > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > > > On Thu, 18 Sep 2008, Larry Finger wrote:
> > > > > The changes below, along with Henriques patch "[PATCH] rfkill: update
> > > > > LEDs for all state changes", and the reversion of commit bc19d6e make
> > > > > the wireless LED toggle correctly.
> > > > > 
> > > > > This version passes UNBLOCKED to rfkill when the hardware switch enables the radio.
> > > > 
> > > > As I said in an email I just sent (unfortunately, after you already sent
> > > > this patch), whatever goes to rfkill_force_state must be the CURRENT state
> > > > of the hardware.
> > > > 
> > > > So, depending on what happens to b43 hardware when the hardware switch
> > > > enables it (i.e. does it enable for real, ignoring the software rfkill input
> > > > lines?), this patch might or might not be correct.
> > > 
> > > As far as I can see the v2 patch is correct, it sends the BLOCK event when the
> > > rfkill key was pressed to block the radio and the UNBLOCK event when the rfkill
> > > key was pressed to unblock the radio.
> > 
> > If rfkill_force_state() is being used, you MUST send to it the *real* radio
> > state.  Not the cached radio state, not "desired" radio state, not "user
> > requested" radio state.  It has to be the *real* radio state.
> > 
> > If a device driver is not doing so, it is incorrect and either it must send
> > the real radio state, or it should be doing something else than calling
> > rfkill_force_state().
> 
> So well. You tell me this way, and Ivo tells me the other way around to not
> announce SW_BLOCKED state ever. ;)
> What's actually right?

Let me actually understand what Ivo means, and I will get back to you.

What he DOES NOT want is to have any RADIO state (as in stuff that takes
into account set txpower off, etc) being fed back into the rfkill core.

And I have no idea of that stuff you read from mac80211 has them mixed in,
or is exclusive for rfkill.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
