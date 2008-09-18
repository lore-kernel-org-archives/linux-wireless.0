Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:55977 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbYIRQwF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 12:52:05 -0400
Received: by ug-out-1314.google.com with SMTP id k3so777928ugf.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 09:52:03 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 18:51:58 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181716.24355.IvDoorn@gmail.com> <20080918160803.GK1583@khazad-dum.debian.net>
In-Reply-To: <20080918160803.GK1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181851.59182.IvDoorn@gmail.com> (sfid-20080918_185212_022051_35BD5B5B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > > We had some threads about it, and I don't recall any real conclusions if we
> > > should have "tx power off" be treated the same way as a software rfkill
> > > block request would, or not.  I believe it ended up as "do whatever you want
> > > in your driver" (i.e. no real conclusion).
> > > 
> > > So, the rfkill core is not even aware of any tx power changes, unless the
> > > wireless device drivers decides to make it so by actively feeding it new
> > > states through rfkill_force_state() when the tx power changes from off to
> > > something else, and from something else to off.
> > > 
> > > rfkill will work right whether you do it or not...
> > 
> > Well as far as I am concerned, userspace configuration actions are not rfkill events
> > and thus should rfkill not raise them as such. rfkill events are triggered by
> > buttons/keys/switches/sliders whatever the manufacturer considered as a nice idea
> > to control the wireless device.
> 
> Actually, rfkill-related INPUT events are triggered by buttons/keys
> /switches/sliders.  rfkill events are sent over the uevent system and the
> rfkill notifier chain, triggered by rfkill controllers changing state (and
> they exist for on-screen-display support and such stuff).

Unfortunately this is no longer completely the case since you qualified
several drivers as "no valid input device" and those are not using the input devices
anymore. 

Among those drivers are rt2x00, and I believe b43 as well (hence the patch send by Larry
to remove the input device).

Those drivers completely rely on rfkill_force_state() to send the RFKILL events
to userspace.

> I find it best to make real sure we are talking about INPUT events or
> non-input events in any rfkill context, because they really are very
> different for the rfkill core.

True, and that is where the problems are now coming from...

> > Abusing rfkill to make userspace commands like "iwconfig txpower on/off" configurable
> > by triggering rfkill events is just plain wrong and will mess up userspace tools/notifier chain
> > listeners or whatever other tool is listening to rfkill.
> 
> I really don't care either way.  Currently the rfkill core will just work no
> matter what is done re. tx power on/off, and I really don't know which way
> would be better for the user.

Rfkill is supposed to listen to the RFKILL status in the hardware and not the RADIO status,
at the same time it is used to control the RADIO status (and not the RFKILL status).
This means that having a radio enabled is completely different then having the RFKILL blocked

For rt2x00 the following is possible:
 * Radio enabled
 * RFKILL status set to blocked

The device will happily send and receive data while the RFKILL status is set to disabled,
hence it needs rfkill to disable the radio. And thus it sends SOFT_BLOCKED to rfkill which
is the valid status to indicate the RFKILL status is set to blocked and thus the RADIO should
be disabled.

What your new suggestion is that there is no difference between:
 * Pressing the RFKILL key on the laptop
 * Running "iwconfig wlan0 txpower off"

While both have a different meaning and should be threated differently. And since this is
the RFKILL layer, we should only concern ourselves with the RFKILL status and RFKILL events
and not userspace configuration.

The only possible userspace configuration which matters for RFKILL is that the SOFT_BLOCK
can be lifted (while the HW_BLOCK cannot).

After that it is up to rfkill-input (which use was killed because some drivers were no longer valid
input devices), or any userspace tool to listen to the events and perform the right action:
Which is killing all wireless radios because we most likely entered an area where Wireless Radios
are not allowed.

> I also have no idea if something in userspace will be confused to see an
> rfkill event telling it a radio entered SOFT BLOCK when it issues an txpower
> off.  If they do, they're hosed anyway, because the radio could have entered
> the SOFT_BLOCK state for any other reason in that time window...
> 
> However, I still think it *is* a lot more complex for drivers that *happen
> to already implement tx power off using the hardware support for software
> rfkill lines* to keep the two things separate.  I have no idea if any
> drivers do so.  The rfkill core can deal with it either way, as long as it
> is properly informed of any relevant rfkill state changes.

Your are mixing the RFKILL and RADIO status. They are different and on only
for some hardware they are the same. But such hardware uses the HW_BLOCK status
to indicate the RADIO status cannot be set to a state which does not match the RADIO state.

> > The rfkill layer was added for a specific reason:
> > 	Control the wireless radios when the rfkill buttons/keys/switches/sliders was pressed.
> > This was needed for areas where no RF radios are allowed (i.e. airplanes).
> 
> Yeah, but in order to do that properly, we had to make it a complete
> read/write, push and pull interface to the rfkill controllers (because of
> pesky firmware that changes it behind your back, etc) and do a clean,
> complete separation from rfkill state propagation (rfkill uevents, notify
> chain, rfkill->get_state/rfkill_force_state API) and rfkill command
> propagation (input events).

That is right, and those changes were correct. However that doesn't mean rfkill
should be used to combine the RFKILL and RADIO state.

> That's done and finished, as far as I am concerned.  Maybe some enhancements
> like make it poll()'able or somesuch might happen, but that's it as far as I
> am concerned.
>
> > Apparently we are now changing it to a global library where is displays the state of
> > all radios grouped by type, and are basically providing a new interface for the user to
> > where all configuration changes done in userspace result into new events reported to
> > userspace.
> 
> Hmm?  I am working on the addition of enough userspace interface to let
> rfkill-input be implemented in userspace, nothing more.   I can certainly
> drop that work if you want me to, but I had the impression that you liked
> the idea.

Userspace implementation is fine, but only when it reacts to actual RFKILL events.
userspace shouldn't care when the RADIO state changed, because those are
actions done by userspace itself.

> As for the "all configuration changes done in userspace result into new
> events reported to userspace", well, I already explained the bit about set
> txpower off above.  If you mean something else that I did or said, please
> explain.

* User a executes command: iwconfig wlan0 txpower off
* Driver for wlan0 switches radio off
* Driver for wlan0 reports SOFT_BLOCKED to rfkill
* rfkill sees state change, triggers notifier_block and uevent
* userpace gets the rfkill event

> > If the user has userspace tools which listen to rfkill events, and the user performs
> > a "iwconfig wlan0 txpower off" he does not want the userspace tool to listen to
> > the event and raises a "hey somebody killed a radio, lets kill all other radios as well"
> 
> If any tool is doing something that braindamaged, get rid of the tool.

Well than it means it won't perform the task of disabling wireless hardware while
in an airplane...

> > Or should the user now first disable his rfkill-listener daemon before applying
> > configuration actions to his wireless interface just to prevent events from occuring?
> 
> No rfkill-listener daemon should be ever doing something as retarded as
> shutting down all other radios because a single radio was shutdown in a
> general way.

Exactly, so why raise it as rfkill event then?

> The only scenario I know of that might need something *CLOSE* to that is
> this one (which is part of the design guidelines of the rfkill core to
> support):
> 
> 1. The code has detected that it is running on a specifc platform where the
> EV_SW SW_RFKILL_ALL button is tied *directly* to, say, b43 and you cannot
> read that state from anywhere else.
> 
>    * Note that this is for specific platforms, and not the general case.
> 
> 2. The code will then listen to b43 rfkill uevents, and ONLY FOR TRANSITIONS
> THAT INVOLVE ENTERING OR EXITING RFKILL_STATE_HARD_BLOCKED, it will generate
> EV_SW SW_RFKILL_ALL events.  Alternatively, you can use EV_SW SW_WLAN if you
> want it to be type-based, etc.
> 
>    * Note that only changes involving a hardware rfkill line are of concern,
>      simple changes between UNBLOCKED and SOFT_BLOCKED are ignored.
> 
> 3. Something else (be it rfkill-input or some userspace thing) traps that
> EV_SW *input* event, and orders rfkill to change the state of a set of
> radios (all of them for SW_RFKILL_ALL, just WLAN for SW_WLAN, etc).
> 
>    * Note that the proper layer separation is kept, so input events are
>      reacted to the same way, no matter where they were generated.
> 
> That would certainly ignore any rfkill state changes done through software,
> no matter the source of the change (firmware, userland poking at sysfs,
> rfkill-input acting upon a KEY_WLAN event, etc), and regardless of the
> wireless driver separating set txtpower off from soft-blocking or not.  So
> it would't be toggling the state of all (or all WLAN,etc) radios
> erratically.

Ivo
