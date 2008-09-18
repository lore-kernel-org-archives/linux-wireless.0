Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57480 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482AbYIRQIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 12:08:10 -0400
Date: Thu, 18 Sep 2008 13:08:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918160803.GK1583@khazad-dum.debian.net> (sfid-20080918_180817_702215_0CD69C08)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181624.53050.IvDoorn@gmail.com> <20080918143754.GH1583@khazad-dum.debian.net> <200809181716.24355.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181716.24355.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > We had some threads about it, and I don't recall any real conclusions if we
> > should have "tx power off" be treated the same way as a software rfkill
> > block request would, or not.  I believe it ended up as "do whatever you want
> > in your driver" (i.e. no real conclusion).
> > 
> > So, the rfkill core is not even aware of any tx power changes, unless the
> > wireless device drivers decides to make it so by actively feeding it new
> > states through rfkill_force_state() when the tx power changes from off to
> > something else, and from something else to off.
> > 
> > rfkill will work right whether you do it or not...
> 
> Well as far as I am concerned, userspace configuration actions are not rfkill events
> and thus should rfkill not raise them as such. rfkill events are triggered by
> buttons/keys/switches/sliders whatever the manufacturer considered as a nice idea
> to control the wireless device.

Actually, rfkill-related INPUT events are triggered by buttons/keys
/switches/sliders.  rfkill events are sent over the uevent system and the
rfkill notifier chain, triggered by rfkill controllers changing state (and
they exist for on-screen-display support and such stuff).

I find it best to make real sure we are talking about INPUT events or
non-input events in any rfkill context, because they really are very
different for the rfkill core.

> Abusing rfkill to make userspace commands like "iwconfig txpower on/off" configurable
> by triggering rfkill events is just plain wrong and will mess up userspace tools/notifier chain
> listeners or whatever other tool is listening to rfkill.

I really don't care either way.  Currently the rfkill core will just work no
matter what is done re. tx power on/off, and I really don't know which way
would be better for the user.

I also have no idea if something in userspace will be confused to see an
rfkill event telling it a radio entered SOFT BLOCK when it issues an txpower
off.  If they do, they're hosed anyway, because the radio could have entered
the SOFT_BLOCK state for any other reason in that time window...

However, I still think it *is* a lot more complex for drivers that *happen
to already implement tx power off using the hardware support for software
rfkill lines* to keep the two things separate.  I have no idea if any
drivers do so.  The rfkill core can deal with it either way, as long as it
is properly informed of any relevant rfkill state changes.

> The rfkill layer was added for a specific reason:
> 	Control the wireless radios when the rfkill buttons/keys/switches/sliders was pressed.
> This was needed for areas where no RF radios are allowed (i.e. airplanes).

Yeah, but in order to do that properly, we had to make it a complete
read/write, push and pull interface to the rfkill controllers (because of
pesky firmware that changes it behind your back, etc) and do a clean,
complete separation from rfkill state propagation (rfkill uevents, notify
chain, rfkill->get_state/rfkill_force_state API) and rfkill command
propagation (input events).

That's done and finished, as far as I am concerned.  Maybe some enhancements
like make it poll()'able or somesuch might happen, but that's it as far as I
am concerned.

> Apparently we are now changing it to a global library where is displays the state of
> all radios grouped by type, and are basically providing a new interface for the user to
> where all configuration changes done in userspace result into new events reported to
> userspace.

Hmm?  I am working on the addition of enough userspace interface to let
rfkill-input be implemented in userspace, nothing more.   I can certainly
drop that work if you want me to, but I had the impression that you liked
the idea.

As for the "all configuration changes done in userspace result into new
events reported to userspace", well, I already explained the bit about set
txpower off above.  If you mean something else that I did or said, please
explain.

> If the user has userspace tools which listen to rfkill events, and the user performs
> a "iwconfig wlan0 txpower off" he does not want the userspace tool to listen to
> the event and raises a "hey somebody killed a radio, lets kill all other radios as well"

If any tool is doing something that braindamaged, get rid of the tool.

> Or should the user now first disable his rfkill-listener daemon before applying
> configuration actions to his wireless interface just to prevent events from occuring?

No rfkill-listener daemon should be ever doing something as retarded as
shutting down all other radios because a single radio was shutdown in a
general way.

The only scenario I know of that might need something *CLOSE* to that is
this one (which is part of the design guidelines of the rfkill core to
support):

1. The code has detected that it is running on a specifc platform where the
EV_SW SW_RFKILL_ALL button is tied *directly* to, say, b43 and you cannot
read that state from anywhere else.

   * Note that this is for specific platforms, and not the general case.

2. The code will then listen to b43 rfkill uevents, and ONLY FOR TRANSITIONS
THAT INVOLVE ENTERING OR EXITING RFKILL_STATE_HARD_BLOCKED, it will generate
EV_SW SW_RFKILL_ALL events.  Alternatively, you can use EV_SW SW_WLAN if you
want it to be type-based, etc.

   * Note that only changes involving a hardware rfkill line are of concern,
     simple changes between UNBLOCKED and SOFT_BLOCKED are ignored.

3. Something else (be it rfkill-input or some userspace thing) traps that
EV_SW *input* event, and orders rfkill to change the state of a set of
radios (all of them for SW_RFKILL_ALL, just WLAN for SW_WLAN, etc).

   * Note that the proper layer separation is kept, so input events are
     reacted to the same way, no matter where they were generated.

That would certainly ignore any rfkill state changes done through software,
no matter the source of the change (firmware, userland poking at sysfs,
rfkill-input acting upon a KEY_WLAN event, etc), and regardless of the
wireless driver separating set txtpower off from soft-blocking or not.  So
it would't be toggling the state of all (or all WLAN,etc) radios
erratically.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
