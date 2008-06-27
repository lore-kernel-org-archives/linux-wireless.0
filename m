Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764270AbYF0VlF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 17:41:05 -0400
Subject: Re: [PATCH 1/2] rfkill: rename the rfkill_state states and add
	block-locked state
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Fabien Crespel <fabien@crespel.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
In-Reply-To: <20080627213524.GA8266@khazad-dum.debian.net>
References: <1214254004-32652-1-git-send-email-hmh@hmh.eng.br>
	 <1214254004-32652-2-git-send-email-hmh@hmh.eng.br>
	 <1214591028.24579.18.camel@localhost.localdomain>
	 <20080627213524.GA8266@khazad-dum.debian.net>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 17:39:47 -0400
Message-Id: <1214602787.9373.11.camel@localhost.localdomain> (sfid-20080627_234114_696753_C9B53EAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-27 at 18:35 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 27 Jun 2008, Dan Williams wrote:
> > On Mon, 2008-06-23 at 17:46 -0300, Henrique de Moraes Holschuh wrote:
> > > The current naming of rfkill_state causes a lot of confusion: not only the
> > > "kill" in rfkill suggests negative logic, but also the fact that rfkill cannot
> > > turn anything on (it can just force something off or stop forcing something
> > > off) is often forgotten.
> > > 
> > > Rename RFKILL_STATE_OFF to RFKILL_STATE_SOFT_BLOCKED (transmitter is blocked
> > > and will not operate; state can be changed by a toggle_radio request), and
> > > RFKILL_STATE_ON to RFKILL_STATE_UNBLOCKED (transmitter is not blocked, and may
> > > operate).
> > > 
> > > Also, add a new third state, RFKILL_STATE_HARD_BLOCKED (transmitter is blocked
> > > and will not operate; state cannot be changed through a toggle_radio request),
> > > which is used by drivers to indicate a wireless transmiter was blocked by a
> > > hardware rfkill line that accepts no overrides.
> > > 
> > > Keep the old names as #defines, but document them as deprecated.  This way,
> > > drivers can be converted to the new names *and* verified to actually use rfkill
> > > correctly one by one.
> > > 
> > > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > Thanks for doing this!
> > 
> > So with this patch, in the case where ex. hp-wmi advertises a killswitch
> > and the wlan driver itself doesn't have one, when NM wants to softkill
> > the radio, should NM do a SIOCSIWTXPOW or softblock the hp-wmi
> > killswitch?  Or would the wlan driver implement an rfkill handler and
> 
> I thought a lot about it, and I personally feel it is better to keep
> SIOCSIWTXPOW separate from rfkill.  This is a driver layer thing, and rfkill
> doesn't care either way, but IMHO it is less confusing for the user if
> iwconfig txpower doesn't change the rfkill status of a device.
> 
> This means NM would be trying to set the class/rfkill*/state to
> RFKILL_STATE_SOFT_BLOCKED for the devices it wants to block.
> 
> And the way to be able to do it without going insane really is to start
> adding rfkill subsystem support to all wireless network drivers, so your
> WLAN devices will all have a rfkill class related to them.

Right, but that's the part we don't yet have, correct?  Can I just start
adding rfkill capability with the patchset you just posted to drivers
like airo and atmel even though they don't have killswitches themselves?
That's the conceptual problem here; cards like airo and atmel don't have
killswitches, and since /sys/class/rfkill/rfkillX are _switches_ right
now, it gets confusing when a device that isn't a killswitch would start
providing rfkillX.

Dan

> > thus have /sys/class/rfkill/rfkillX as well?  My understanding of what
> > would happen here got buried in all the mails last time around.  If the
> > transmitter is not tied to a physical killswitch, but the killswitch is
> > provided by another module (laptop specific driver for example), do we
> > assume the rfkill state is authoritative or do we check each radio via
> > it's own specific method?
> 
> Unless HAL can tell you about it, and you teach HAL the topology for every
> laptop model (something I consider Not Doable), you really are supposed to
> try to ignore as much as possible the topology of kill switches.
> 
> So, you add topology agnostic UIs to NM that let the user:
>   1. Easily try to set the state of all devices of a given type
>   2. Try to set the state of a particular device.
>   3. Try to set the state of all devices (shortcut to "for all types, do (1)
>      above).
> 
> hp-wmi's and thinkpad-acpi's softswitches would show up just like any
> another device.  The user would quickly learn that changing the state of
> these devices has an effect of hardblocking others.
> 
> When I get to improving the interface to the global state (i.e. add the
> attributes needed to implement rfkill-input in userspace), you will be
> able to do more, or to do the above in an easier way.
> 

