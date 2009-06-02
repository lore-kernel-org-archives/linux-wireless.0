Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50625 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbZFBImM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 04:42:12 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A24E3E4.1050505@tuffmail.co.uk>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <1243858256.5299.14.camel@johannes.local>
	 <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local> <4A24E3E4.1050505@tuffmail.co.uk>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 10:41:49 +0200
Message-Id: <1243932109.3192.73.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alan,

> >> If you really don't wanna have rfkilld _not_ impose a policy on cold
> >> boot, then we can certainly add that. However that is part of rfkilld
> >> and not the kernel.
> >>
> >> For global states, I am questioning the platform that actually has
> >> storage for global states. All platforms that I have seen so far store
> >> individual per device based states and not the global one.
> >>     
> >
> > Yeah, unfortunately the platform drivers do store/restore global state.
> > And in a sense that makes (made) sense since the default rfkill-input
> > policy was to toggle everything based on the platform button. It's icky
> > though.
> >
> > The problem with not telling rfkilld about this though is that the
> > kernel will suddenly impose a hotplug policy that rfkilld doesn't know
> > about. This might not even matter though since the _ADD will be sent
> > with that policy already applied, and if it wants to change the policy
> > rfkilld will do _CHANGE_ALL.
> >
> >   
> >> If you wanna just accept what the BIOS (or other OS) tells you then that
> >> is an acceptable policy. So rfkilld will just map key input events in
> >> that case. Fine by me. Question is if we can't do that right now? I
> >> think we just can.
> >>     
> >
> > Yes, we probably can do that right now, by making rfkilld start up
> > without setting a policy (CHANGE_ALL). It just doesn't know what the
> > policy is, then.
> >
> >   
> >> Question is if we really have a global state here. I doubt it since all
> >> of these are device specific states. And having the BIOS or ACPI dictate
> >> what state my external Bluetooth or WiFi device is in is pointless and a
> >> total broken concept.
> >>     
> >
> > Unfortunately that's how it worked before, it's part of the rfkill
> > legacy that it seems we'll have to accept. I guess we have only
> > ourselves to blame for not reviewing Henrique's rfkill implementation...
> >
> >   
> >>> You propose to exclude a feature that currently works, on the grounds 
> >>> that it is inherently broken.  But you haven't said that this has ever 
> >>> caused incorrect behavior.  All you have said so far is that it is a hack.
> >>>       
> >> This never worked so far. The mac80211 or Bluetooth subsystems have no
> >> RFKILL state and thus global states are not enforced. An external dongle
> >> without RFKILL support is not taken into account. You are not talking
> >> about global states here. They are all device specific. The device just
> >> happens to be a platform device builtin the system.
> >>     
> >
> > Right, but rfkill does actually have a function to set the global policy
> > state (rfkill_set_global_sw_state) which some platform drivers insist on
> > calling.
> >
> > The only reason we would need the NVS_REPORT then is to detect whether
> > or not anything in the kernel called rfkill_set_global_sw_state(). If we
> > can live with just configuring rfkilld for the (arguably broken) case
> > where somebody cares about this, I'm happy with removing it.
> >
> > Hope that helps clear up your confusion.
> >   
> 
> The reason for drivers doing this is that otherwise, the kernel forces 
> the new rfkill device to the current global default.  So this API is 
> used for the device to preserve it's current state - without it, we just 
> throw the NVS information away and no-one can get at it.
> 
> We could switch to using the non-global set_sw_state() after 
> registration.  But that's pretty nasty because it means most drivers 
> call set_sw_state() before registration, a few drivers call it 
> afterwards, and it's not going to be obvious why.  Plus I think it 
> bypasses EPO.  So I think some sort of separate API is needed.

as I said, we might need to fix drivers that register their RFKILL
switch with the wrong state to begin with. This is a driver issue and
that can be easily fixed inside the kernel.

Forget about this EPO crap. That is just a stupid concept anyway.

> If we can also export this NVS status to userspace somehow, then 
> userspace can distinguish between
> 
> a) rfkill is currently unblocked, because this was the kernel default, 
> so there's no reason not to override the state
> b) rfkill is currently unblocked, because this was restored from NVS, 
> which hopefully reflects the most recent request from the user.  rfkilld 
> is still able to override this state, but it would also be reasonable 
> not to.
> 
> I take Marcels point, if /dev/rfkill exposes a sub-optimal interface, it 
> can be very difficult to fix it.  It's probably better to fix the mess 
> of global states before trying to add NVS information to /dev/rfkill.
> 
> Btw, I think there's a third scenario to add to the other OS / BIOS 
> setup.  Some hardware has a handover mechanism, right?  Where the BIOS 
> handles rfkill keypresses by default, and toggles the soft rfkill state, 
> but allows the driver to take over when loaded.  So if the user presses 
> the key _before_ the driver gets loaded - they will see the wireless LED 
> change, and they will expect that state change to persist when the 
> driver is loaded.

We should be able to handle this properly without an extra operation in
the user interface.

Regards

Marcel


