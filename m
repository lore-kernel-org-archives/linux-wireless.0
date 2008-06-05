Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbYFEOrS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 10:47:18 -0400
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <20080605130323.GB3413@khazad-dum.debian.net>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	 <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
	 <1212611246.4018.12.camel@localhost.localdomain>
	 <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <20080605003808.GA16599@khazad-dum.debian.net>
	 <1212667955.25730.29.camel@localhost.localdomain>
	 <20080605130323.GB3413@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 10:46:47 -0400
Message-Id: <1212677207.28545.56.camel@localhost.localdomain> (sfid-20080605_164724_700789_8541B07E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-05 at 10:03 -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 05 Jun 2008, Dan Williams wrote:
> > What are we talking about with "sw switch"?  AFAIK there are a few types
> > of rfkill switches:
> 
> I called softkill (in these emails, that term is nowhere in rfkill
> documentation) something you can change state.  hardkill something you
> cannot.

Fair enough.

> I certianly don't mind using different terms, but keep the above in mind
> when reading any previous replies from me.
> 
> > a) hard switches that kill the radio and notify the driver
> 
> rfkill class material, yes.
> 
> > b) hard switches that notify the driver but do not directly kill the
> > radio
> 
> These are input devices, and not directly related to the rfkill class
> (but related to the rfkill subsystem).

So in your mind, these drivers would re-emit state changes of their
rfkill switches back into the kernel input layer, correct?

> > c) hard switches that disconnect the device from its bus entirely (most
> > BT rfkill)
> 
> These are also rfkill class material.
> 
> > d) hard switches that notify BIOS only (not the driver) and rely on
> > special laptop drivers (hp-wmi, toshiba-laptop, etc) to notify the
> > system
> 
> If they just notify the BIOS, they are input devices.  If they cause the
> BIOS to mess with the transmitters, they are rfkill class material.

Obviously here, the laptop specific driver would re-emit the state
change into the the kernel input layer since it is handled by a
completely separate driver than the radio itself is handled by?

> > e) keyboard "soft" switches that are simply input layer buttons (like Fn
> > +F5 on thinkpads) and don't toggle
> 
> These are input devices in almost all cases.  But since you brought up
> thinkpads, I better warn you that the Fn+F5 in a ThinkPad, depending on
> thinkpad BIOS revision and ACPI HKEY mask state, *is* active and will
> mess with the transmitters directly (and thus it is not an input
> device).  thinkpad-acpi forces it to "just an input device" state by
> default to keep things sane.
> 
> > Besides that, we can rfkill radios in software through commands like
> > "iwconfig wlan0 txpower off".
> 
> Yeah.  This could be also rfkill material, if you want to have rfkill as
> another *way* to interact with the same functionality.  It could cause
> some minor issues (like which power do I set the transmitter to, if it
> is turned off by txpower off, but someone undos that through rfkill?)
> but it would work.

I want _one_ interface to get the radio block state (either blocked or
unblocked) for any device that has a radio, be it WiFi, WiMAX, BT, WWAN,
UWB, etc.

I also want _one_ interface to determine how many rfkill switches the
system has, and what their state is (either blocking radios or not
blocking radios).  This is what the current rfkill system seems to
provide.

I don't want to have to use SIOCGIWTXPOW for wifi, something else for
BT, something else for WWAN, something else for WiMAX, just to figure
out whether a radio is blocked or unblocked.  That's just wrong but
something that we can eventually fix.

So, it seems I was confused about the scope of the current rfkill
system.  While it probably should be "rfkill_switch" I'm not sure we can
change that now.  While it would be nice to have a single interface to
query radio power state, that can be a future improvement.

> > Only (a), (b), (c), and sometimes (d) actually kill the radio and block
> > changes by the user.  Otherwise, it's up to userspace to kill the radios
> > when events come in.
> 
> If it doesn't kill the radio, it is not rfkill class material.  At most,
> it could be an input device that issues events related to rfkill.

Right, I misunderstood the original scope of the kernel rfkill stuff.  I
thought it covered everything except case E (pure input-layer only
buttons).

I'd like the rfkill system to eventually cover cases A - D, and also
handle radio block state notifications and queries.  I'm willing to help
code that.  Actual power levels of the radio is probably best left up to
the device-specific subsystem, but at least the state (and events!) of
"radio now blocked" or "radio now unblocked" are useful to have.

> Currently we can't differentiate "block changes by the user" from "the
> kernel can change the state if you ask it to".  I agree this is a
> desireable feature, and I'd rather add a third rfkill_state to propagate
> that information.

Well... I still think this is best as a _radio_ property, not as a
killswitch property.  Physical switches are physical, you can't change
the state and thus the third state here isn't useful.  If we separate
switch state from radio power state that makes it clear (at least to
me).

Since the current rfkillX device is the _switch_, and since I'm not
aware of any machines where the BIOS synthesizes a toggle state from a
non-toggle button, maybe we should punt this until such a device
actually turns up?

> > > > I believe it's better to have separate sysfs entry for sw and hw switch states.
> > > > hw sysfs file should be read only.
> > > 
> > > When you do this (have more than one rfkill class for the same device),
> > > the kernel events and uevents are not able to propagate the real state
> > > of the device anymore:  upon the recepit of any event, you need to
> > > *locate* all rfkill switches attached to that device, query them all,
> > > and only if all of them are in state RFKILL_STATE_ON, will the device be
> > > in RFKILL_STATE_ON.
> > 
> > The only thing I personally care about is separating radio state from
> > switch state so that I can distinguish a softkill (via ex. iwconfig
> > wlan0 txpower off) from a hardkill via a real killswitch.
> 
> Ok, so what you care about is to know if you COULD CHANGE THE STATE,
> correct?

Could change the radio _block_ state, yes.  rfkill switch state no,
because I don't know of any examples of those and frankly I think it's
easier to just make the user flip the switch again.  Keeping it simpler
is better.

> The third state would tell you that.
> 
> > Why should a "device rfkill state" be in a separate module?  Radio state
> > _is_ rfkill state.  rfkill switches turn the radio on or off but
> 
> device-wide rfkill state is rfkill state.  radio state could be
> anything.

I started using "radio block state" in this mail instead.

> But yes, I understand what you want.  The two states you talk about are
> the same if you have only ONE rfkill class attached to a device, and
> they are different (but related) things when you have MORE than one
> rfkill class attached to a device.

What situations would have more than one rfkill class attached to the
device?

> IMO, we should attach just one rfkill class per transmitter device, and
> handle the "you cannot change the state" possibility by adding a third
> state to rfkill_state.

Right about the one rfkill class per device than drives a killswitch.
But that's not necessarily the transmitter device.  It might be a child
of the laptop module if it's a BIOS switch that also kills the radio
automatically.  In the case of hp-wmi, it provides 3 different rfkill
class devices.

> > ultimately it's the radio itself that determines whether anything is
> > actually killed or not.  Whether software (iwconfig wlan0 txpower off)
> > or hardware (flip a switch somewhere) turns the radio off, the result is
> > the same.  The radio is killed and no longer transmitting.  Thats what
> > rfkill is.
> 
> Keep in mind that rfkill != rfkill class.
> 
> > Every driver that does anything wireless should be handling rfkill
> > events and providing rfkill state through the same mechanism.  I don't
> > want to treat BT, WWAN, WiMAX, WiFi, UWB, BT differently.  All those
> 
> We agree there.
> 
> > devices should have _one_ method of turning themselves off through
> > either hardware or software, and the system that provides that method
> > should be the rfkill system.
> 
> We don't agree there.  If you use "devices should have _one_ method of
> *forcing themselves off* outside of the normal control path of interface
> up/down", THEN we agree.

Right, all devices with transmitters should have _one_ method of
blocking and unblocking their transmitters.

> The reason is extremely simple: rfkill CANNOT TURN SOMETHING ON.  If it
> *was* ON, and you used rfkill to turn it OFF, than yes, when you "stop
> turning it OFF through rfkill", it will go back to ON.
> 
> But if it was not ON in the first place, it won't go to ON when you stop
> turning it OFF through rfkill.  It will just remain OFF, unless
> something else that is NOT rfkill hooks into the event and takes the
> oportunity to do whatever is needed (such as configure the interface and
> bring it up) to bring the device to ON state.

Good point.

> > > What you seem to be calling "radio state" is the effective state of a
> > > device with more than one kill line (be it software or hardware).  We
> > > could call that "device rfkill state" instead of "switch rfkill state"
> > > to avoid confusion, I suppose.
> > 
> > That seems fine, I guess.
> 
> Ok.
> 
> > > Anyway, if we are to use various *related* rfkill switches per device,
> > > rfkill needs further changes, including an extra callback into the
> > > driver, so as to be able to export the device rfkill state also in all
> > > switch rfkill state events (otherwise these events become quite useless
> > > for many uses).
> > 
> > But yes, there would need to be a "device rfkill state" changed event
> > and another call to get the device rfkill state.
> 
> Indeed.  It is a possiblity.  I still feel a third addition to
> rfkill_state and the use of only ONE rfkill class per transmitter device
> is a better way to do it.

As I said above, I think I disagree about the third state.  I think the
best thing to do is keep the general rfkill switch operation as it is
now (only 2 states, blocked and unblocked), and eventually add a
standard "radio block state" sysfs entry on the _transmitter_ device
with 3 values: hw-blocked, sw-blocked, and unblocked.

Does that sound OK?  I feel like I have a better understanding of what
rfkill is _today_, and I think the latest patchset you posted adds some
great functionality (notifications) that we really need.  Thanks for the
work here.

Dan


> I really don't want to go through drawing the entire topology of rfkill
> switches (including drive-based ones, hardware and firmware based ones)
> in a thinkpad and start playing the "how do I break it" game again when
> there are rfkill-input, input devices, global states (for every rfkill
> class of the same type there is a global state that is used to sync them
> when some events happen, see rfkill-input) and userspace.
> 
> A third "rfkill_state" and just ONE rfkill class per transmitter device
> is something I know will work fine.  It appears to me that it would also
> address your need to know if you can toggle the state or not.  If we
> could agree on doing it that way, I will write up the extra patches (on
> top of those already submitted here) to implement it on rfkill.h and
> net/rfkill/*.
> 

