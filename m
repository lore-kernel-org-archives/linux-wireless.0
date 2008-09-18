Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:59069 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbYIRUfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:35:37 -0400
Received: by ey-out-2122.google.com with SMTP id 6so34873eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 13:35:34 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 22:35:30 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181851.59182.IvDoorn@gmail.com> <20080918184709.GN1583@khazad-dum.debian.net>
In-Reply-To: <20080918184709.GN1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809182235.30355.IvDoorn@gmail.com> (sfid-20080918_223541_784521_C07DEB4A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > Actually, rfkill-related INPUT events are triggered by buttons/keys
> > > /switches/sliders.  rfkill events are sent over the uevent system and the
> > > rfkill notifier chain, triggered by rfkill controllers changing state (and
> > > they exist for on-screen-display support and such stuff).
> > 
> > Unfortunately this is no longer completely the case since you qualified
> > several drivers as "no valid input device" and those are not using the input devices
> > anymore. 
> 
> Passing rfkill state around using the input layer is broken, and caused real
> issues.  That is what cannot be done, that is what was fixed in the new API.
> But that does not preclude, e.g., b43, from also exporting input events...
> *as long as* it is done correctly.
> 
> The real issue is, how will b43 and rt2x00 *know* if they are in a platform
> where there is an input device directly tied to their hardware rfkill line?
> 
> How are they supposed to know whether that input device is a "rfkill all"
> button, or a "wlan rfkill button"?

We don't, that is the part where userspace tools would decide what to do.

> > Those drivers completely rely on rfkill_force_state() to send the RFKILL events
> > to userspace.
> 
> That's correct.
> 
> And they would now rely on something listening to either userspace events or
> attaching itself to the rfkill notify chain to issue input events, in those
> platforms that want it.
> 
> If you want me to write an rfkill-inputgen module that could be configured
> to do what b43 and rt2x00 won't do anymore, I can add that to the queue.  It
> should be simple enough, generic, and it would be optional.

I'm not sure. Any other driver developer have a strong opinion about this?

> Or one could just rework input device support for b43 and rt2x00, provide an
> "enable_input_event_generation" module paramenter, add a
> "generate_rfkill_all_event" boolean (that selects EV_SW SW_RFKILL_ALL or a
> new EV_SW SW_WLAN), and that's it.

Ugh, that sounds not-nice. ;)

> > Rfkill is supposed to listen to the RFKILL status in the hardware and not the RADIO status,
> 
> Agreed.  But issues will happen when RADIO status becomes mixed with RFKILL
> status because of some particular device requirement, or because of the way
> that device's driver is implemented.

I think those cases would be rare, and we need to find a solution for this in the
device driver. The current API of rfkill shouldn't be too hard for drivers to make
it usable for their implementation.

> > at the same time it is used to control the RADIO status (and not the RFKILL status).
> 
> As far as I am concerned, rfkill [the rfkill class] is to control the
> "wireless transmitter is allowed to emit energy" fact, and just THAT.

That is even a better wording. :)

> > This means that having a radio enabled is completely different then having the RFKILL blocked
> > 
> > For rt2x00 the following is possible:
> >  * Radio enabled
> >  * RFKILL status set to blocked
> 
> We agree on that.  As long as that means the transmitter is not emitting
> energy, a radio is [rfkill blocked] but it can very well be still [radio
> enabled], with the interface still UP, and even receiving packets depending
> on the technology and the hardware.
> 
> All a [rfkill blocked] device MUST NOT do is emit energy through its
> wireless transmitter.  Anything else is fair game.

Agreed.

> > What your new suggestion is that there is no difference between:
> >  * Pressing the RFKILL key on the laptop
> >  * Running "iwconfig wlan0 txpower off"
> 
> *If* the driver implements it that way.  I am not PROPOSING that drivers
> implement it that way.  I was pretty clear that I do not really prefer it
> either way.

Well I think we should try to be strict in this case, and just call it a rule. ;)

> > After that it is up to rfkill-input (which use was killed because some drivers were no longer valid
> > input devices), or any userspace tool to listen to the events and perform the right action:
> > Which is killing all wireless radios because we most likely entered an area where Wireless Radios
> > are not allowed.
> 
> See above.  If you feel we need to have an in-kernel way to generate the
> input-events that is not inside platform-specific devices and still in the
> kernel, I am well prepared to write a generic one.  But I want an
> acknowledgement that it is what you need, first.  I don't want to do that
> work and drop it later because I misunderstood you.

I have no strong feeling about this. This is something other developers might have
more input about before we decide one way or another.

> > > Hmm?  I am working on the addition of enough userspace interface to let
> > > rfkill-input be implemented in userspace, nothing more.   I can certainly
> > > drop that work if you want me to, but I had the impression that you liked
> > > the idea.
> > 
> > Userspace implementation is fine, but only when it reacts to actual RFKILL events.
> > userspace shouldn't care when the RADIO state changed, because those are
> > actions done by userspace itself.
> 
> That just means the wireless drivers need to know when something should make
> it to rfkill_force_state() or not.   But I *do* need some help on how to
> best word that in the docs.

Ok, I'll think of a good descriptive explanation which we can add to the docs.

> > > As for the "all configuration changes done in userspace result into new
> > > events reported to userspace", well, I already explained the bit about set
> > > txpower off above.  If you mean something else that I did or said, please
> > > explain.
> > 
> > * User a executes command: iwconfig wlan0 txpower off
> > * Driver for wlan0 switches radio off
> > * Driver for wlan0 reports SOFT_BLOCKED to rfkill
> 
> Ok, then the docs need to make it clear that it should not say SOFT_BLOCKED
> to rfkill if it is SOFT_BLOCKED *just because* of txpower off.

Right.

> And it has to be damn careful to never go out of SOFT_BLOCKED because of a
> txpower <non-off> if it was SOFT_BLOCKED because of RKFILL, etc.

Definately, if we are really clear that userspace configuration changes should not
trigger rfkill events we are also implying this. But it wouldn't hurt to make it extra
clear. :)

> > * rfkill sees state change, triggers notifier_block and uevent
> > * userpace gets the rfkill event
> 
> Yeah. The problem there is the "Driver for wlan0 reports SOFT_BLOCKED to
> rfkill".  As I said, I was NOT aware of any consensus about how THAT should
> be handled, but I have no strong feelings about it at all.
> 
> I am certainly not going to suggest (anymore) that anyone do it that way,
> since you feel strongly against it.  But I do not *know* how to properly
> word the docs to discourage it without making them terribly complicated.
> Please help me with THAT.

I will. :)

> I do think a post to linux-wireless about this issue IS warranted. It does
> mean some drivers need changes, and this detail is currently hidden inside
> this thread that I don't expect everyone to be reading.  But I will also
> leave that for you to handle, since you're the one who feels strongly about
> it.

b43 was the first driver I saw doing this, but once we have updated the documentation
I'll send out the email to linux-wireless. Reviewing all current rfkill users in the kernel
is also high on my todo list, so that could catch some drivers as well.

> > > > Or should the user now first disable his rfkill-listener daemon before applying
> > > > configuration actions to his wireless interface just to prevent events from occuring?
> > > 
> > > No rfkill-listener daemon should be ever doing something as retarded as
> > > shutting down all other radios because a single radio was shutdown in a
> > > general way.
> > 
> > Exactly, so why raise it as rfkill event then?
> 
> I am confused.  I don't know if I understand what you mean with this.
> 
> We generate events when rfkill controllers change state, so that OSD applets
> can tell you about it.   It can also be used to generate input events in
> some situations.
> 
> We do not generate them ONLY to convert them to input events once in a blue
> moon.
> 
> Indeed, something might still want to shutdown radios because of an specific
> rfkill event in a specific situation.  That is very different from what you
> were talking about, at least from my PoV.   That's why I wrote the stuff
> below:

I was refering to RFKILL events which would be triggered by the 'iwconfig wlan0 txpower off'
since those are not RFKILL events (triggered by a RFKILL device when the user presses
a RFKILL key).

> > > The only scenario I know of that might need something *CLOSE* to that is
> > > this one (which is part of the design guidelines of the rfkill core to
> > > support):
> > > 
> > > 1. The code has detected that it is running on a specifc platform where the
> > > EV_SW SW_RFKILL_ALL button is tied *directly* to, say, b43 and you cannot
> > > read that state from anywhere else.
> > > 
> > >    * Note that this is for specific platforms, and not the general case.
> > > 
> > > 2. The code will then listen to b43 rfkill uevents, and ONLY FOR TRANSITIONS
> > > THAT INVOLVE ENTERING OR EXITING RFKILL_STATE_HARD_BLOCKED, it will generate
> > > EV_SW SW_RFKILL_ALL events.  Alternatively, you can use EV_SW SW_WLAN if you
> > > want it to be type-based, etc.
> > > 
> > >    * Note that only changes involving a hardware rfkill line are of concern,
> > >      simple changes between UNBLOCKED and SOFT_BLOCKED are ignored.
> > > 
> > > 3. Something else (be it rfkill-input or some userspace thing) traps that
> > > EV_SW *input* event, and orders rfkill to change the state of a set of
> > > radios (all of them for SW_RFKILL_ALL, just WLAN for SW_WLAN, etc).
> > > 
> > >    * Note that the proper layer separation is kept, so input events are
> > >      reacted to the same way, no matter where they were generated.
> > > 
> > > That would certainly ignore any rfkill state changes done through software,
> > > no matter the source of the change (firmware, userland poking at sysfs,
> > > rfkill-input acting upon a KEY_WLAN event, etc), and regardless of the
> > > wireless driver separating set txtpower off from soft-blocking or not.  So
> > > it would't be toggling the state of all (or all WLAN,etc) radios
> > > erratically.
> 


