Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33442 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754487AbYIRSrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:47:18 -0400
Date: Thu, 18 Sep 2008 15:47:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918184709.GN1583@khazad-dum.debian.net> (sfid-20080918_204723_031094_B6AF070E)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181716.24355.IvDoorn@gmail.com> <20080918160803.GK1583@khazad-dum.debian.net> <200809181851.59182.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181851.59182.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > Actually, rfkill-related INPUT events are triggered by buttons/keys
> > /switches/sliders.  rfkill events are sent over the uevent system and the
> > rfkill notifier chain, triggered by rfkill controllers changing state (and
> > they exist for on-screen-display support and such stuff).
> 
> Unfortunately this is no longer completely the case since you qualified
> several drivers as "no valid input device" and those are not using the input devices
> anymore. 

Passing rfkill state around using the input layer is broken, and caused real
issues.  That is what cannot be done, that is what was fixed in the new API.
But that does not preclude, e.g., b43, from also exporting input events...
*as long as* it is done correctly.

The real issue is, how will b43 and rt2x00 *know* if they are in a platform
where there is an input device directly tied to their hardware rfkill line?

How are they supposed to know whether that input device is a "rfkill all"
button, or a "wlan rfkill button"?

Either DMI lists, or configuration through module parameters, or runtime
bringuing up/down the input device upon userspace commands would br needed
for that.

And I said as much in the past.  But it is an horrible way of doing things,
so I have also provided a way to kick that from the wireless device driver
to userspace, or to a different platform module.

But you can *certainly* still do it in b43 and rt2x00, if you want to.
We might even add rfkill core *helpers* to do it, I suppose.  I just don't
see that as being the best way to go about it, but it would work.

> Those drivers completely rely on rfkill_force_state() to send the RFKILL events
> to userspace.

That's correct.

And they would now rely on something listening to either userspace events or
attaching itself to the rfkill notify chain to issue input events, in those
platforms that want it.

If you want me to write an rfkill-inputgen module that could be configured
to do what b43 and rt2x00 won't do anymore, I can add that to the queue.  It
should be simple enough, generic, and it would be optional.

Or one could just rework input device support for b43 and rt2x00, provide an
"enable_input_event_generation" module paramenter, add a
"generate_rfkill_all_event" boolean (that selects EV_SW SW_RFKILL_ALL or a
new EV_SW SW_WLAN), and that's it.

Note that you must be using the rfkill_force_state() for the above to work,
and you want to do it before you send the input events to be on the safe
side.  You must also only issue EV_SW events.  EV_KEY is not safe, as it can
cause state ping-pong.

If all the above care is taken (use only EV_SW events, make sure
rfkill->state is current), it will work, and it is supported.

> Rfkill is supposed to listen to the RFKILL status in the hardware and not the RADIO status,

Agreed.  But issues will happen when RADIO status becomes mixed with RFKILL
status because of some particular device requirement, or because of the way
that device's driver is implemented.

> at the same time it is used to control the RADIO status (and not the RFKILL status).

As far as I am concerned, rfkill [the rfkill class] is to control the
"wireless transmitter is allowed to emit energy" fact, and just THAT.

The other parts of the rfkill core exist to make that control system-wide
based on input events (like KEY_WLAN, etc).

> This means that having a radio enabled is completely different then having the RFKILL blocked
> 
> For rt2x00 the following is possible:
>  * Radio enabled
>  * RFKILL status set to blocked

We agree on that.  As long as that means the transmitter is not emitting
energy, a radio is [rfkill blocked] but it can very well be still [radio
enabled], with the interface still UP, and even receiving packets depending
on the technology and the hardware.

All a [rfkill blocked] device MUST NOT do is emit energy through its
wireless transmitter.  Anything else is fair game.

> What your new suggestion is that there is no difference between:
>  * Pressing the RFKILL key on the laptop
>  * Running "iwconfig wlan0 txpower off"

*If* the driver implements it that way.  I am not PROPOSING that drivers
implement it that way.  I was pretty clear that I do not really prefer it
either way.

In fact, I sent a reply about how it might go in order for the driver to
still differentiate between txpower off and RFKILL SOFT_BLOCK, even if it
has to use the same hardware bit for both operations.

It is more work for the driver developer, but if that's how it should be
done, I certainly don't mind.  I do think it would be best if all drivers
did it the same way, though, but I really, *really* don't feel strongly
about it at all.

> While both have a different meaning and should be threated differently. And since this is
> the RFKILL layer, we should only concern ourselves with the RFKILL status and RFKILL events
> and not userspace configuration.

Agreed.

> The only possible userspace configuration which matters for RFKILL is that the SOFT_BLOCK
> can be lifted (while the HW_BLOCK cannot).

Agreed.

> After that it is up to rfkill-input (which use was killed because some drivers were no longer valid
> input devices), or any userspace tool to listen to the events and perform the right action:
> Which is killing all wireless radios because we most likely entered an area where Wireless Radios
> are not allowed.

See above.  If you feel we need to have an in-kernel way to generate the
input-events that is not inside platform-specific devices and still in the
kernel, I am well prepared to write a generic one.  But I want an
acknowledgement that it is what you need, first.  I don't want to do that
work and drop it later because I misunderstood you.

> > Hmm?  I am working on the addition of enough userspace interface to let
> > rfkill-input be implemented in userspace, nothing more.   I can certainly
> > drop that work if you want me to, but I had the impression that you liked
> > the idea.
> 
> Userspace implementation is fine, but only when it reacts to actual RFKILL events.
> userspace shouldn't care when the RADIO state changed, because those are
> actions done by userspace itself.

That just means the wireless drivers need to know when something should make
it to rfkill_force_state() or not.   But I *do* need some help on how to
best word that in the docs.

> > As for the "all configuration changes done in userspace result into new
> > events reported to userspace", well, I already explained the bit about set
> > txpower off above.  If you mean something else that I did or said, please
> > explain.
> 
> * User a executes command: iwconfig wlan0 txpower off
> * Driver for wlan0 switches radio off
> * Driver for wlan0 reports SOFT_BLOCKED to rfkill

Ok, then the docs need to make it clear that it should not say SOFT_BLOCKED
to rfkill if it is SOFT_BLOCKED *just because* of txpower off.

And it has to be damn careful to never go out of SOFT_BLOCKED because of a
txpower <non-off> if it was SOFT_BLOCKED because of RKFILL, etc.

> * rfkill sees state change, triggers notifier_block and uevent
> * userpace gets the rfkill event

Yeah. The problem there is the "Driver for wlan0 reports SOFT_BLOCKED to
rfkill".  As I said, I was NOT aware of any consensus about how THAT should
be handled, but I have no strong feelings about it at all.

I am certainly not going to suggest (anymore) that anyone do it that way,
since you feel strongly against it.  But I do not *know* how to properly
word the docs to discourage it without making them terribly complicated.
Please help me with THAT.

I do think a post to linux-wireless about this issue IS warranted. It does
mean some drivers need changes, and this detail is currently hidden inside
this thread that I don't expect everyone to be reading.  But I will also
leave that for you to handle, since you're the one who feels strongly about
it.

> > > Or should the user now first disable his rfkill-listener daemon before applying
> > > configuration actions to his wireless interface just to prevent events from occuring?
> > 
> > No rfkill-listener daemon should be ever doing something as retarded as
> > shutting down all other radios because a single radio was shutdown in a
> > general way.
> 
> Exactly, so why raise it as rfkill event then?

I am confused.  I don't know if I understand what you mean with this.

We generate events when rfkill controllers change state, so that OSD applets
can tell you about it.   It can also be used to generate input events in
some situations.

We do not generate them ONLY to convert them to input events once in a blue
moon.

Indeed, something might still want to shutdown radios because of an specific
rfkill event in a specific situation.  That is very different from what you
were talking about, at least from my PoV.   That's why I wrote the stuff
below:

> > The only scenario I know of that might need something *CLOSE* to that is
> > this one (which is part of the design guidelines of the rfkill core to
> > support):
> > 
> > 1. The code has detected that it is running on a specifc platform where the
> > EV_SW SW_RFKILL_ALL button is tied *directly* to, say, b43 and you cannot
> > read that state from anywhere else.
> > 
> >    * Note that this is for specific platforms, and not the general case.
> > 
> > 2. The code will then listen to b43 rfkill uevents, and ONLY FOR TRANSITIONS
> > THAT INVOLVE ENTERING OR EXITING RFKILL_STATE_HARD_BLOCKED, it will generate
> > EV_SW SW_RFKILL_ALL events.  Alternatively, you can use EV_SW SW_WLAN if you
> > want it to be type-based, etc.
> > 
> >    * Note that only changes involving a hardware rfkill line are of concern,
> >      simple changes between UNBLOCKED and SOFT_BLOCKED are ignored.
> > 
> > 3. Something else (be it rfkill-input or some userspace thing) traps that
> > EV_SW *input* event, and orders rfkill to change the state of a set of
> > radios (all of them for SW_RFKILL_ALL, just WLAN for SW_WLAN, etc).
> > 
> >    * Note that the proper layer separation is kept, so input events are
> >      reacted to the same way, no matter where they were generated.
> > 
> > That would certainly ignore any rfkill state changes done through software,
> > no matter the source of the change (firmware, userland poking at sysfs,
> > rfkill-input acting upon a KEY_WLAN event, etc), and regardless of the
> > wireless driver separating set txtpower off from soft-blocking or not.  So
> > it would't be toggling the state of all (or all WLAN,etc) radios
> > erratically.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
