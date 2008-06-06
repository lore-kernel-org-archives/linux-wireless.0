Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYFFD0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 23:26:40 -0400
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <1212696826.13915.1256967905@webmail.messagingengine.com>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
	 <1212549017-30144-2-git-send-email-hmh@hmh.eng.br>
	 <1212611246.4018.12.camel@localhost.localdomain>
	 <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
	 <20080605003808.GA16599@khazad-dum.debian.net>
	 <1212667955.25730.29.camel@localhost.localdomain>
	 <20080605130323.GB3413@khazad-dum.debian.net>
	 <1212677207.28545.56.camel@localhost.localdomain>
	 <1212696826.13915.1256967905@webmail.messagingengine.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 23:26:03 -0400
Message-Id: <1212722763.1026.17.camel@localhost.localdomain> (sfid-20080606_052646_691430_C5946E6B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-05 at 17:13 -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 05 Jun 2008 10:46:47 -0400, "Dan Williams" <dcbw@redhat.com> said:
> > On Thu, 2008-06-05 at 10:03 -0300, Henrique de Moraes Holschuh wrote:
> > > On Thu, 05 Jun 2008, Dan Williams wrote:
> > > > a) hard switches that kill the radio and notify the driver
> > > 
> > > rfkill class material, yes.
> > > 
> > > > b) hard switches that notify the driver but do not directly kill the
> > > > radio
> > > 
> > > These are input devices, and not directly related to the rfkill class
> > > (but related to the rfkill subsystem).
> > 
> > So in your mind, these drivers would re-emit state changes of their
> > rfkill switches back into the kernel input layer, correct?
> 
> Yes.  And the funny thing is, they are supposed not to ACT by themselves
> at all, they are to wait for someone to tell them to through the rfkill class.
> 
> (NOTE: this applies only to scenario (b) above.  It is NOT valid for other
> scenarios like (a) or (c) or any other).
> 
> 
> To be more clear:
> 
> MODULE  FOO  (driver for the foo wireless device).
> * Ties to the input layer, and reports pressure of the "hard switch that notify
> the driver (MODULE FOO) but do not directly kill the radio (device foo)" using
> the proper input event.
> 
> It does NOTHING further with the information that the button/switch was pressed.
> Really.  It just generates the input event and sends it.
> 
> * Uses the rfkill class connected to the device foo in the device tree to receive
> commands to toggle the real device rfkill state.
> 
> If some input event is indeed supposed to cause the device state to change, the
> driver gets called back through the rfkill class toggle_radio() hook.
> 
> So, the button press would go through the input layer to SOMETHING ELSE (likely
> to rfkill-input), which would take the **policy** decision of what to do with
> that event, and then cause the appropriate rfkill class instances to change their
> state.
> 
> So, MODULE FOO would get a hook call (toggle_radio) through the rfkill class, in
> order to do something about the input event MODULE FOO itself generated.
> 
> Or it might not get that hook call, if the local admin wanted something different
> to happen.
> 
> > > > c) hard switches that disconnect the device from its bus entirely (most
> > > > BT rfkill)
> > > 
> > > These are also rfkill class material.
> > > 
> > > > d) hard switches that notify BIOS only (not the driver) and rely on
> > > > special laptop drivers (hp-wmi, toshiba-laptop, etc) to notify the
> > > > system
> > > 
> > > If they just notify the BIOS, they are input devices.  If they cause the
> > > BIOS to mess with the transmitters, they are rfkill class material.
> > 
> > Obviously here, the laptop specific driver would re-emit the state
> > change into the the kernel input layer since it is handled by a
> > completely separate driver than the radio itself is handled by?
> 
> Correct.  The platform driver might actually also register notifier callbacks
> on the rfkill subsystem, and, for example, automatically promote all b43
> rfkill status changes into input events if this is the correct thing to
> do for THAT specific platform (it is NOT the correct thing to do by
> default, so b43 can't do it itself).
> 
> > > > e) keyboard "soft" switches that are simply input layer buttons (like Fn
> > > > +F5 on thinkpads) and don't toggle
> > > 
> > > These are input devices in almost all cases.  But since you brought up
> > > thinkpads, I better warn you that the Fn+F5 in a ThinkPad, depending on
> > > thinkpad BIOS revision and ACPI HKEY mask state, *is* active and will
> > > mess with the transmitters directly (and thus it is not an input
> > > device).  thinkpad-acpi forces it to "just an input device" state by
> > > default to keep things sane.
> > > 
> > > > Besides that, we can rfkill radios in software through commands like
> > > > "iwconfig wlan0 txpower off".
> > > 
> > > Yeah.  This could be also rfkill material, if you want to have rfkill as
> > > another *way* to interact with the same functionality.  It could cause
> > > some minor issues (like which power do I set the transmitter to, if it
> > > is turned off by txpower off, but someone undos that through rfkill?)
> > > but it would work.
> > 
> > I want _one_ interface to get the radio block state (either blocked or
> > unblocked) for any device that has a radio, be it WiFi, WiMAX, BT, WWAN,
> > UWB, etc.
> 
> rfkill is supposed to be it, yes.
> 
> > I also want _one_ interface to determine how many rfkill switches the
> > system has, and what their state is (either blocking radios or not
> > blocking radios).  This is what the current rfkill system seems to
> > provide.
> 
> It provides that information PARTIALLY.  Currently, you can enumerate
> all rfkill interfaces through sysfs, and you can interact with each
> one separately.  However, you cannot interact with the internal type-
> specific global switches (which are NOT rfkill class) inside
> rfkill-input.
> 
> I haven't solved that problem to my satisfaction yet, so the only patch
> I have for it has not seen the light of the net.  It is too ugly to live
> IMHO.
> 
> So, I'd say the individual rfkill class sysfs interface is nearly complete
> (we need to add the third state or do something else to tell you when
> a radio is blocked and cannot be unblocked).
> 
> But the rfkill subsystem interface (deals with rfkill-input) to userspace
> is NOT feature-complete yet.   This really, really shouldn't bother NM,
> it is HAL-layer level stuff.

It bothers NM because NM uses HAL for rfkill information, and HAL
doesn't yet handle the difference between hardkill and softkill.  That's
exactly what I'm trying to fix here.

> > I don't want to have to use SIOCGIWTXPOW for wifi, something else for
> > BT, something else for WWAN, something else for WiMAX, just to figure
> > out whether a radio is blocked or unblocked.  That's just wrong but
> > something that we can eventually fix.
> 
> Well, the problem is that SIOCGIWTXPOW is NOT a direct equivalent to rfkill,
> rfkill has no concept of attenuation (or amplification, for that matter).

Yeah, but that's not really relevant here.  All we need is "radio
blocked" or "radio unblocked" as a property on the transmitter device.
We don't are about the signal power, we just care about whether the
radio is blocked or unblocked.

> It is up for the wireless people to decide if their SIOCGIWTXPOW controls
> are the same exposed by rfkill or not, and what to do when reenabling from
> a txpower off (probably you will have to recall the last non-off txpower 
> and use that).  The rfkill subsystem really doesn't care, as long as you
> don't do it by adding more than one rfkill class to the same device.
> 
> > So, it seems I was confused about the scope of the current rfkill
> > system.  While it probably should be "rfkill_switch" I'm not sure we can
> > change that now.  While it would be nice to have a single interface to
> > query radio power state, that can be a future improvement.
> 
> I think it is a better idea to fix what we have, first.  Let it settle
> down, and then take the full view and check if you need to enhance it,
> replace it, or design something else that goes along with it.  I'd bet on
> the third option, but it is a bit early to tell.
> 
> > > > Only (a), (b), (c), and sometimes (d) actually kill the radio and block
> > > > changes by the user.  Otherwise, it's up to userspace to kill the radios
> > > > when events come in.
> > > 
> > > If it doesn't kill the radio, it is not rfkill class material.  At most,
> > > it could be an input device that issues events related to rfkill.
> > 
> > Right, I misunderstood the original scope of the kernel rfkill stuff.  I
> > thought it covered everything except case E (pure input-layer only
> > buttons).
> 
> It sort of does, in the sense that rfkill (not the rfkill class!) defines
> how the input layer should be used for these events.
> 
> > I'd like the rfkill system to eventually cover cases A - D, and also
> > handle radio block state notifications and queries.  I'm willing to help
> > code that.  Actual power levels of the radio is probably best left up to
> > the device-specific subsystem, but at least the state (and events!) of
> > "radio now blocked" or "radio now unblocked" are useful to have.
> 
> Unless I missed something, I have provided you with that for cases
> A to D already.  What I didn't provide you with was "radio now blocked and
> you cannot unblock it", *yet*.  You have convinced me it is something 
> needed, and if left to my own devices, I will implement it as a third
> state.

But again, we don't need a third state!  We need to separate the radio
block state from the rfkill switch state.

Not all radios have rfkill switches attached to them, and thus having a
3rd rfkill state just doesn't work.  In the case of hp-wmi, there is no
killswitch associated with the wireless device, it's handled by BIOS and
does not necessarily have interaction with the transmitter.

Having a 3rd state on a killswitch which can't physically _have_ 3
states isn't right.  The switch is often completely independent of the
radio, and that's something we need to represent.

Because of that, the toggle_radio() member of struct rfkill just isn't
in the right place.  That changes _radio_ block state, but since struct
rfkill is the _switch_, toggle_radio() is wrong here.  In the case of
hp-wmi, there's no radio to toggle, since it's a hardswitch, and since
hp-wmi isn't a wireless driver!

Again, we need to separate radio block state from switch state, because
they are two different things.  We don't need to break anything here; we
just need to add some bits for radio block state.

Dan

> HOWEVER, rfkill can't provide you with "radio is enabled, configured, 
> operational and transmitting" status.  It really can't say much of what
> is happening in the unblocked state.
> 
> > > Currently we can't differentiate "block changes by the user" from "the
> > > kernel can change the state if you ask it to".  I agree this is a
> > > desireable feature, and I'd rather add a third rfkill_state to propagate
> > > that information.
> > 
> > Well... I still think this is best as a _radio_ property, not as a
> > killswitch property.  Physical switches are physical, you can't change
> > the state and thus the third state here isn't useful.  If we separate
> > switch state from radio power state that makes it clear (at least to
> > me).
> 
> But then you have more than one "switch" per radio, which needs changes
> to rfkill (currently, you are NOT to do it).
> 
> Currently, one is to think of a rfkill class as the representation of
> the "radio property".  Which means you *lose the information* of which
> underlying hardware/firmware reason the device has to be blocked.
> 
> I think we are actually better off by losing that information, it is
> not useful for UIs (you need to know the device is force-blocked, not
> WHY it is blocked or force-blocked -- that is highly platform-specific).
> 
> > Since the current rfkillX device is the _switch_, and since I'm not
> > aware of any machines where the BIOS synthesizes a toggle state from a
> > non-toggle button, maybe we should punt this until such a device
> > actually turns up?
> 
> The current rfkillX device represents the radio state, which means it might
> need to synthesize it from various hardware bits.
> 
> E.g.  Let's look at a possible conversion of IPW2200 to the rfkill class.
> 
> The IPW2200 driver has TWO rfkill "registers":
>    R1 - Read/Write, controlled by the driver
>    R2 - Read-Only, reflects an input pin in the hardware and cannot be
>         overriden.
> 
> The IPW2000 driver would register just *one* instance of the rfkill class,
> and it would return the status as this.
> 
> Assume R1 active high, and R2 active high.  Active means BLOCK RADIO.
> 
>   rfkill_status = (R1 | R2) ? RFKILL_STATUS_OFF : RFKILL_STATUS_ON.
> 
> I.e. if either one (or both) of the registers are blocking the radio, it
> reports the status as RFKILL_STATUS_OFF.  Otherwise, it reports the status
> as RFKILL_STATUS_ON (unblocked).
> 
> Now, for the toggle_radio function in pseudo-code:
> 
>   switch (new_state) {
>    case RFKILL_STATUS_ON:
>        if (R2) {
>            R1 = 1; /* fail safe, least surprise */
>            return -EPERM;  /* cannot override! */
>        }
>        R1 = 0;
>        break;
>    case RFKILL_STATUS_OFF:
>        R1 = 1;
>        break;
>    }
> 
> There are possible variations, the most pressing one that comes to mind
> is whether we should force the R1 switch to 1 or 0 when R2 is 1 on the
> RFKILL_STATUS_ON branch.  I used the "won't EVER cause the radio to be
> unblocked by surprise" alternative.
> 
> However, now userspace really gets to know if the ipw2200 radio is blocked or not,
> it doesn't have to hunt down two different rfkill class instances for it.  And it
> just needs to listen to uevents (which HAL should be taught to export to DBUS) for
> ipw2200 to know when the status changes, no pooling or even reading of sysfs
> attributes would be required.
> 
> If you wanted to also handle txpower off through rfkill, you'd take the state of
> txpower into consideration on the code above, and still have only ONE rfkillX
> instance for the ipw2200 device.
> 
> > > > The only thing I personally care about is separating radio state from
> > > > switch state so that I can distinguish a softkill (via ex. iwconfig
> > > > wlan0 txpower off) from a hardkill via a real killswitch.
> > > 
> > > Ok, so what you care about is to know if you COULD CHANGE THE STATE,
> > > correct?
> > 
> > Could change the radio _block_ state, yes.  rfkill switch state no,
> 
> I mean the radio _block_ state.  See above.  One rfkill class per device,
> synthesizing the state of n, n>=1 real switches.  So, you get the radio
> block state from it.
> 
> > because I don't know of any examples of those and frankly I think it's
> > easier to just make the user flip the switch again.  Keeping it simpler
> > is better.
> 
> I'd agree with this view, least surprise is good, and the way the whole
> rfkill idea was engineered to leave the transmitter BLOCKED in cause of
> doubt.
> 
> > > The third state would tell you that.
> > > 
> > > > Why should a "device rfkill state" be in a separate module?  Radio state
> > > > _is_ rfkill state.  rfkill switches turn the radio on or off but
> > > 
> > > device-wide rfkill state is rfkill state.  radio state could be
> > > anything.
> > 
> > I started using "radio block state" in this mail instead.
> 
> Ok, radio block state is also good.  As long as we both know exactly
> what we mean by it.
> 
> > > But yes, I understand what you want.  The two states you talk about are
> > > the same if you have only ONE rfkill class attached to a device, and
> > > they are different (but related) things when you have MORE than one
> > > rfkill class attached to a device.
> > 
> > What situations would have more than one rfkill class attached to the
> > device?
> 
> If you try to model IPW2200 or other hardware with many rfkill input signals
> as one signal per rfkill class.  That's something that is probably NOT a good
> idea at all.
> 
> > > IMO, we should attach just one rfkill class per transmitter device, and
> > > handle the "you cannot change the state" possibility by adding a third
> > > state to rfkill_state.
> > 
> > Right about the one rfkill class per device than drives a killswitch.
> > But that's not necessarily the transmitter device.  It might be a child
> > of the laptop module if it's a BIOS switch that also kills the radio
> > automatically.  In the case of hp-wmi, it provides 3 different rfkill
> > class devices.
> 
> Which is why I want to do it in a way we don't have to know what is a
> child of what, slaved to what, master of what...
> 
> > > > devices should have _one_ method of turning themselves off through
> > > > either hardware or software, and the system that provides that method
> > > > should be the rfkill system.
> > > 
> > > We don't agree there.  If you use "devices should have _one_ method of
> > > *forcing themselves off* outside of the normal control path of interface
> > > up/down", THEN we agree.
> > 
> > Right, all devices with transmitters should have _one_ method of
> > blocking and unblocking their transmitters.
> 
> OK.
> 
> > > The reason is extremely simple: rfkill CANNOT TURN SOMETHING ON.  If it
> > > *was* ON, and you used rfkill to turn it OFF, than yes, when you "stop
> > > turning it OFF through rfkill", it will go back to ON.
> > > 
> > > But if it was not ON in the first place, it won't go to ON when you stop
> > > turning it OFF through rfkill.  It will just remain OFF, unless
> > > something else that is NOT rfkill hooks into the event and takes the
> > > oportunity to do whatever is needed (such as configure the interface and
> > > bring it up) to bring the device to ON state.
> > 
> > Good point.
> 
> It is a very central point to rfkill, if you lose track of it, things get
> very confusing, very very quickly.
> 
> > > > > Anyway, if we are to use various *related* rfkill switches per device,
> > > > > rfkill needs further changes, including an extra callback into the
> > > > > driver, so as to be able to export the device rfkill state also in all
> > > > > switch rfkill state events (otherwise these events become quite useless
> > > > > for many uses).
> > > > 
> > > > But yes, there would need to be a "device rfkill state" changed event
> > > > and another call to get the device rfkill state.
> > > 
> > > Indeed.  It is a possiblity.  I still feel a third addition to
> > > rfkill_state and the use of only ONE rfkill class per transmitter device
> > > is a better way to do it.
> > 
> > As I said above, I think I disagree about the third state.  I think the
> > best thing to do is keep the general rfkill switch operation as it is
> > now (only 2 states, blocked and unblocked), and eventually add a
> > standard "radio block state" sysfs entry on the _transmitter_ device
> > with 3 values: hw-blocked, sw-blocked, and unblocked.
> 
> If we mandate the one-rfkill-class-per-transmitter rule, you now have two
> attributes that say the very same thing, except that the old one (the one
> we currently have) lacks the force-blocked state.  So basically, you just
> avoided a minor ABI change by not adding the third state to rfkill_state.
> 
> If we mandate the one-rfkill-class-per-kill-line rule, you will add 
> complexity, now a driver like IPW2200 would need at least two rfkill
> class instances.   In THIS case, the new attribute conveys interesting
> information, but OTOH, NM and any user application will have to deal
> with more than one rfkill sysfs instance per device, and we will have
> weird issues to deal with, like how to deal with user_claim...
> 
> The reason I insist on the third state so much is that rfkill *really*
> was not designed to cope with two or more per transmitter.  You now
> have to mess with various rfkill switches to get something to happen
> (and most of the time, all but one will EPERM you, because they are
> read-only, and my subconsious mind is severely screaming up this is
> a BAD IDEA, we currently forbid read-only switches and I recall there
> were some subtle issues with the input layer events for read-only
> stuff).
> 
> > Does that sound OK?  I feel like I have a better understanding of what
> 
> It WOULD work, I think.  But for the reasons above, I am more inclined
> to add a third state.  It is much simpler on the code, and it has no
> drawbacks I can see, while the multiple rfkill per device approach does
> have some (and it gives me a bad feeling every time I consider it).
> 
> What whould be the technical advantages of a separate attribute
> from your UI (NM) point of view?  That is not yet clear to me, at
> all.  Assume you will only get ONE rfkillX interface per device,
> which means it DOES reflect the block/unblock state of the device.
> 

