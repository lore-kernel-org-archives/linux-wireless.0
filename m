Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51907 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbYIRRqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:46:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC V2] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 19:46:11 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d260b7.SG5SGntEQ00lxFKi%Larry.Finger@lwfinger.net> <200809181628.22544.IvDoorn@gmail.com> <20080918144836.GI1583@khazad-dum.debian.net>
In-Reply-To: <20080918144836.GI1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181946.11477.mb@bu3sch.de> (sfid-20080918_194639_629979_86A422D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008 16:48:36 Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > > On Thu, 18 Sep 2008, Larry Finger wrote:
> > > > The changes below, along with Henriques patch "[PATCH] rfkill: update
> > > > LEDs for all state changes", and the reversion of commit bc19d6e make
> > > > the wireless LED toggle correctly.
> > > > 
> > > > This version passes UNBLOCKED to rfkill when the hardware switch enables the radio.
> > > 
> > > As I said in an email I just sent (unfortunately, after you already sent
> > > this patch), whatever goes to rfkill_force_state must be the CURRENT state
> > > of the hardware.
> > > 
> > > So, depending on what happens to b43 hardware when the hardware switch
> > > enables it (i.e. does it enable for real, ignoring the software rfkill input
> > > lines?), this patch might or might not be correct.
> > 
> > As far as I can see the v2 patch is correct, it sends the BLOCK event when the
> > rfkill key was pressed to block the radio and the UNBLOCK event when the rfkill
> > key was pressed to unblock the radio.
> 
> If rfkill_force_state() is being used, you MUST send to it the *real* radio
> state.  Not the cached radio state, not "desired" radio state, not "user
> requested" radio state.  It has to be the *real* radio state.
> 
> If a device driver is not doing so, it is incorrect and either it must send
> the real radio state, or it should be doing something else than calling
> rfkill_force_state().

So well. You tell me this way, and Ivo tells me the other way around to not
announce SW_BLOCKED state ever. ;)
What's actually right?

-- 
Greetings Michael.
