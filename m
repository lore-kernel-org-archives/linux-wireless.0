Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:30788 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYIRPQ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 11:16:29 -0400
Received: by ey-out-2122.google.com with SMTP id 6so1656102eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 08:16:28 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Date: Thu, 18 Sep 2008 17:16:24 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181624.53050.IvDoorn@gmail.com> <20080918143754.GH1583@khazad-dum.debian.net>
In-Reply-To: <20080918143754.GH1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181716.24355.IvDoorn@gmail.com> (sfid-20080918_171633_332132_C97D9DFE)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > > On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > > > If it is something coming from mac80211, then you do not want
> > > > to send a SOFT_BLOCKED event since that will cause all other radios
> > > > to be switched off simply because the b43 interface has not been
> > > > enabled.
> > > 
> > > Drivers ARE supposed to be able to set their radio state to their heart's
> > > content, without messing with any other devices.  There are no constraints
> > > to calls to rfkill_force_state(), other than the current issue that it must
> > > not be done from an atomic context.
> > 
> > My main point was that when the radio is not enabled because the user
> > did something like "iwconfig wlan0 txpower off" then this is not an rfkill
> > SOFT_BLOCKED event. Since that command has nothing to do with the
> > entire rfkill layer.
> 
> We had some threads about it, and I don't recall any real conclusions if we
> should have "tx power off" be treated the same way as a software rfkill
> block request would, or not.  I believe it ended up as "do whatever you want
> in your driver" (i.e. no real conclusion).
> 
> So, the rfkill core is not even aware of any tx power changes, unless the
> wireless device drivers decides to make it so by actively feeding it new
> states through rfkill_force_state() when the tx power changes from off to
> something else, and from something else to off.
> 
> rfkill will work right whether you do it or not...

Well as far as I am concerned, userspace configuration actions are not rfkill events
and thus should rfkill not raise them as such. rfkill events are triggered by
buttons/keys/switches/sliders whatever the manufacturer considered as a nice idea
to control the wireless device.

Abusing rfkill to make userspace commands like "iwconfig txpower on/off" configurable
by triggering rfkill events is just plain wrong and will mess up userspace tools/notifier chain
listeners or whatever other tool is listening to rfkill.

The rfkill layer was added for a specific reason:
	Control the wireless radios when the rfkill buttons/keys/switches/sliders was pressed.
This was needed for areas where no RF radios are allowed (i.e. airplanes).

Apparently we are now changing it to a global library where is displays the state of
all radios grouped by type, and are basically providing a new interface for the user to
where all configuration changes done in userspace result into new events reported to
userspace.

When the userspace tool listens to rfkill events it is not, or most accurate, should not
be interested in the events from userspace (which it probably caused itself)
but from the events coming from the hardware.

If the user has userspace tools which listen to rfkill events, and the user performs
a "iwconfig wlan0 txpower off" he does not want the userspace tool to listen to
the event and raises a "hey somebody killed a radio, lets kill all other radios as well"

Or should the user now first disable his rfkill-listener daemon before applying
configuration actions to his wireless interface just to prevent events from occuring?

> > When you consider such commands as rfkill events you get wrong behavior
> > because it would trigger a SOFT_BLOCK in rfkill which will be send to all
> > registered drivers who can disable their radio off as well. And that is
> > definately not what you want...
> 
> ...because this is incorrect.
> 
> No transmitter-specific rfkill events cause this, at least as far as the
> rfkill core is concerned.  They are sent to userspace and the notify chain,
> yes.  And either userspace or another kernel module might, if it is feeling
> wrong on the head, change that event into a request to mess with all radios.
> 
> But right now, none will.  rfkill-input only cares about INPUT EVENTS, but
> the rfkill core never *issues* any input events, ever.

True, but I am not talking about rfkill-input alone.
I am talking about whatever rfkill event listener, and that can be either rfkill-input
notify chain listener or a uevent listener.
They are all allowed to perform actions based on the rfkill events.
 
> Unless b43 is still issuing INPUT EVENTS even after the patch?  It
> shouldn't.

That part is being removed with this patch.

Ivo


