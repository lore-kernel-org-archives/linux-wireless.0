Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46387 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbYFEND2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 09:03:28 -0400
Date: Thu, 5 Jun 2008 10:03:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
Message-ID: <20080605130323.GB3413@khazad-dum.debian.net> (sfid-20080605_150356_062050_CE4DB605)
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br> <1212549017-30144-2-git-send-email-hmh@hmh.eng.br> <1212611246.4018.12.camel@localhost.localdomain> <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com> <20080605003808.GA16599@khazad-dum.debian.net> <1212667955.25730.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1212667955.25730.29.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 05 Jun 2008, Dan Williams wrote:
> What are we talking about with "sw switch"?  AFAIK there are a few types
> of rfkill switches:

I called softkill (in these emails, that term is nowhere in rfkill
documentation) something you can change state.  hardkill something you
cannot.

I certianly don't mind using different terms, but keep the above in mind
when reading any previous replies from me.

> a) hard switches that kill the radio and notify the driver

rfkill class material, yes.

> b) hard switches that notify the driver but do not directly kill the
> radio

These are input devices, and not directly related to the rfkill class
(but related to the rfkill subsystem).

> c) hard switches that disconnect the device from its bus entirely (most
> BT rfkill)

These are also rfkill class material.

> d) hard switches that notify BIOS only (not the driver) and rely on
> special laptop drivers (hp-wmi, toshiba-laptop, etc) to notify the
> system

If they just notify the BIOS, they are input devices.  If they cause the
BIOS to mess with the transmitters, they are rfkill class material.

> e) keyboard "soft" switches that are simply input layer buttons (like Fn
> +F5 on thinkpads) and don't toggle

These are input devices in almost all cases.  But since you brought up
thinkpads, I better warn you that the Fn+F5 in a ThinkPad, depending on
thinkpad BIOS revision and ACPI HKEY mask state, *is* active and will
mess with the transmitters directly (and thus it is not an input
device).  thinkpad-acpi forces it to "just an input device" state by
default to keep things sane.

> Besides that, we can rfkill radios in software through commands like
> "iwconfig wlan0 txpower off".

Yeah.  This could be also rfkill material, if you want to have rfkill as
another *way* to interact with the same functionality.  It could cause
some minor issues (like which power do I set the transmitter to, if it
is turned off by txpower off, but someone undos that through rfkill?)
but it would work.

> Only (a), (b), (c), and sometimes (d) actually kill the radio and block
> changes by the user.  Otherwise, it's up to userspace to kill the radios
> when events come in.

If it doesn't kill the radio, it is not rfkill class material.  At most,
it could be an input device that issues events related to rfkill.

Currently we can't differentiate "block changes by the user" from "the
kernel can change the state if you ask it to".  I agree this is a
desireable feature, and I'd rather add a third rfkill_state to propagate
that information.

> > > I believe it's better to have separate sysfs entry for sw and hw switch states.
> > > hw sysfs file should be read only.
> > 
> > When you do this (have more than one rfkill class for the same device),
> > the kernel events and uevents are not able to propagate the real state
> > of the device anymore:  upon the recepit of any event, you need to
> > *locate* all rfkill switches attached to that device, query them all,
> > and only if all of them are in state RFKILL_STATE_ON, will the device be
> > in RFKILL_STATE_ON.
> 
> The only thing I personally care about is separating radio state from
> switch state so that I can distinguish a softkill (via ex. iwconfig
> wlan0 txpower off) from a hardkill via a real killswitch.

Ok, so what you care about is to know if you COULD CHANGE THE STATE,
correct?

The third state would tell you that.

> Why should a "device rfkill state" be in a separate module?  Radio state
> _is_ rfkill state.  rfkill switches turn the radio on or off but

device-wide rfkill state is rfkill state.  radio state could be
anything.

But yes, I understand what you want.  The two states you talk about are
the same if you have only ONE rfkill class attached to a device, and
they are different (but related) things when you have MORE than one
rfkill class attached to a device.

IMO, we should attach just one rfkill class per transmitter device, and
handle the "you cannot change the state" possibility by adding a third
state to rfkill_state.

> ultimately it's the radio itself that determines whether anything is
> actually killed or not.  Whether software (iwconfig wlan0 txpower off)
> or hardware (flip a switch somewhere) turns the radio off, the result is
> the same.  The radio is killed and no longer transmitting.  Thats what
> rfkill is.

Keep in mind that rfkill != rfkill class.

> Every driver that does anything wireless should be handling rfkill
> events and providing rfkill state through the same mechanism.  I don't
> want to treat BT, WWAN, WiMAX, WiFi, UWB, BT differently.  All those

We agree there.

> devices should have _one_ method of turning themselves off through
> either hardware or software, and the system that provides that method
> should be the rfkill system.

We don't agree there.  If you use "devices should have _one_ method of
*forcing themselves off* outside of the normal control path of interface
up/down", THEN we agree.

The reason is extremely simple: rfkill CANNOT TURN SOMETHING ON.  If it
*was* ON, and you used rfkill to turn it OFF, than yes, when you "stop
turning it OFF through rfkill", it will go back to ON.

But if it was not ON in the first place, it won't go to ON when you stop
turning it OFF through rfkill.  It will just remain OFF, unless
something else that is NOT rfkill hooks into the event and takes the
oportunity to do whatever is needed (such as configure the interface and
bring it up) to bring the device to ON state.

> > What you seem to be calling "radio state" is the effective state of a
> > device with more than one kill line (be it software or hardware).  We
> > could call that "device rfkill state" instead of "switch rfkill state"
> > to avoid confusion, I suppose.
> 
> That seems fine, I guess.

Ok.

> > Anyway, if we are to use various *related* rfkill switches per device,
> > rfkill needs further changes, including an extra callback into the
> > driver, so as to be able to export the device rfkill state also in all
> > switch rfkill state events (otherwise these events become quite useless
> > for many uses).
> 
> But yes, there would need to be a "device rfkill state" changed event
> and another call to get the device rfkill state.

Indeed.  It is a possiblity.  I still feel a third addition to
rfkill_state and the use of only ONE rfkill class per transmitter device
is a better way to do it.

I really don't want to go through drawing the entire topology of rfkill
switches (including drive-based ones, hardware and firmware based ones)
in a thinkpad and start playing the "how do I break it" game again when
there are rfkill-input, input devices, global states (for every rfkill
class of the same type there is a global state that is used to sync them
when some events happen, see rfkill-input) and userspace.

A third "rfkill_state" and just ONE rfkill class per transmitter device
is something I know will work fine.  It appears to me that it would also
address your need to know if you can toggle the state or not.  If we
could agree on doing it that way, I will write up the extra patches (on
top of those already submitted here) to implement it on rfkill.h and
net/rfkill/*.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
