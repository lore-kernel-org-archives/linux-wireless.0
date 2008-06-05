Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083AbYFEMNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 08:13:17 -0400
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <20080605003808.GA16599@khazad-dum.debian.net>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	 <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
	 <1212611246.4018.12.camel@localhost.localdomain>
	 <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <20080605003808.GA16599@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 08:12:35 -0400
Message-Id: <1212667955.25730.29.camel@localhost.localdomain> (sfid-20080605_141320_721594_2987E190)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 21:38 -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 05 Jun 2008, Tomas Winkler wrote:
> > SW should be able to more sw radio switch regardless of hw switch so
> 
> Be extremely careful with "should" and any ideas you might have of the
> capabilities of rf switch hardware, because chances are firmware-based
> switches will frustate you.   In fact, you're wrong.  Some firmware
> softswitches don't let you change their status when there is also a
> hardware switch present, and that hardware switch is in the "block
> transmissions" state.

What are we talking about with "sw switch"?  AFAIK there are a few types
of rfkill switches:

a) hard switches that kill the radio and notify the driver
b) hard switches that notify the driver but do not directly kill the
radio
c) hard switches that disconnect the device from its bus entirely (most
BT rfkill)
d) hard switches that notify BIOS only (not the driver) and rely on
special laptop drivers (hp-wmi, toshiba-laptop, etc) to notify the
system
e) keyboard "soft" switches that are simply input layer buttons (like Fn
+F5 on thinkpads) and don't toggle

Besides that, we can rfkill radios in software through commands like
"iwconfig wlan0 txpower off".

Only (a), (b), (c), and sometimes (d) actually kill the radio and block
changes by the user.  Otherwise, it's up to userspace to kill the radios
when events come in.

> > I believe it's better to have separate sysfs entry for sw and hw switch states.
> > hw sysfs file should be read only.
> 
> When you do this (have more than one rfkill class for the same device),
> the kernel events and uevents are not able to propagate the real state
> of the device anymore:  upon the recepit of any event, you need to
> *locate* all rfkill switches attached to that device, query them all,
> and only if all of them are in state RFKILL_STATE_ON, will the device be
> in RFKILL_STATE_ON.

The only thing I personally care about is separating radio state from
switch state so that I can distinguish a softkill (via ex. iwconfig
wlan0 txpower off) from a hardkill via a real killswitch.

I still don't quite know what "sw switch" means here...

> So, we'd need to change the rfkill class to avoid all that hassle (see
> more on this below).
> 
> Sincerely, I heavly prefer to add a third state (RFKILL_STATE_HARDOFF or
> something like that).  That is a safe path that will have no subtle
> interactions with the way rfkill is meant to be used.  I am not so sure
> the other possibilities have this advantage, even if I cannot pinpoint
> what interactions they could cause right now.
> 
> > I agree it good to keep radio state separately as well.
> 
> I don't like this either, unless by "separate" you mean outside of
> rfkill entirely.

Why should a "device rfkill state" be in a separate module?  Radio state
_is_ rfkill state.  rfkill switches turn the radio on or off but
ultimately it's the radio itself that determines whether anything is
actually killed or not.  Whether software (iwconfig wlan0 txpower off)
or hardware (flip a switch somewhere) turns the radio off, the result is
the same.  The radio is killed and no longer transmitting.  Thats what
rfkill is.

Every driver that does anything wireless should be handling rfkill
events and providing rfkill state through the same mechanism.  I don't
want to treat BT, WWAN, WiMAX, WiFi, UWB, BT differently.  All those
devices should have _one_ method of turning themselves off through
either hardware or software, and the system that provides that method
should be the rfkill system.

> What you seem to be calling "radio state" is the effective state of a
> device with more than one kill line (be it software or hardware).  We
> could call that "device rfkill state" instead of "switch rfkill state"
> to avoid confusion, I suppose.

That seems fine, I guess.

> Anyway, if we are to use various *related* rfkill switches per device,
> rfkill needs further changes, including an extra callback into the
> driver, so as to be able to export the device rfkill state also in all
> switch rfkill state events (otherwise these events become quite useless
> for many uses).

But yes, there would need to be a "device rfkill state" changed event
and another call to get the device rfkill state.

> It is more complicated and heavyweight a solution for very little gain
> when compared to the addition of a third RFKILL_STATE state, IMO.
> Remeber that multiple related switches per device adds complexity to the
> INTERFACE, and therefore to all applications that use that interface.
> 
> > Third I think this patch use opposite logic as used currently in
> > practice. RFKILL_ON means that radio is off .
> 
> The correct reading of rfkill class states are:
> 
> RFKILL_STATE_ON:  transmitter is UNBLOCKED and *may* operate
> RFKILL_STATE_OFF: transmitter is BLOCKED and will *NOT* operate.
> 
> Nothing else is correct.
> 
> We could certainly rename these states to
> 
> enum rfkill_state {
> 	RFKILL_STATE_BLOCKED = 0,
> 	RFKILL_STATE_UNBLOCKED = 1,
> };
> 
> #define RFKILL_STATE_ON RFKILL_STATE_UNBLOCKED
> #define RFKILL_STATE_OFF RFKILL_STATE_BLOCKED
> 
> Ivo, do you want a patch that does the above (plus the documentation
> changes, of course)?

Yeah, that would probably be better.  I kept having to go back to
rfkill.txt because I kept mixing up what "on" meant.

Dan

