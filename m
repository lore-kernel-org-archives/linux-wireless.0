Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53480 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbZFBISp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 04:18:45 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243929706.20064.7.camel@johannes.local>
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
	 <1243929706.20064.7.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 10:18:23 +0200
Message-Id: <1243930703.3192.59.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > If you really don't wanna have rfkilld _not_ impose a policy on cold
> > boot, then we can certainly add that. However that is part of rfkilld
> > and not the kernel.
> > 
> > For global states, I am questioning the platform that actually has
> > storage for global states. All platforms that I have seen so far store
> > individual per device based states and not the global one.
> 
> Yeah, unfortunately the platform drivers do store/restore global state.
> And in a sense that makes (made) sense since the default rfkill-input
> policy was to toggle everything based on the platform button. It's icky
> though.
> 
> The problem with not telling rfkilld about this though is that the
> kernel will suddenly impose a hotplug policy that rfkilld doesn't know
> about. This might not even matter though since the _ADD will be sent
> with that policy already applied, and if it wants to change the policy
> rfkilld will do _CHANGE_ALL.

that is my understanding. We will see the current states and if just
wanna notify about a global soft/hard-block we can send a CHANGE_ALL
after the ADD events (if we think that is useful for telling global
block state).

> > If you wanna just accept what the BIOS (or other OS) tells you then that
> > is an acceptable policy. So rfkilld will just map key input events in
> > that case. Fine by me. Question is if we can't do that right now? I
> > think we just can.
> 
> Yes, we probably can do that right now, by making rfkilld start up
> without setting a policy (CHANGE_ALL). It just doesn't know what the
> policy is, then.

That is actually fine since it is also not enforcing it. I don't see any
problem here at all.

> > Question is if we really have a global state here. I doubt it since all
> > of these are device specific states. And having the BIOS or ACPI dictate
> > what state my external Bluetooth or WiFi device is in is pointless and a
> > total broken concept.
> 
> Unfortunately that's how it worked before, it's part of the rfkill
> legacy that it seems we'll have to accept. I guess we have only
> ourselves to blame for not reviewing Henrique's rfkill implementation...

That is just utterly broken and I fully object to messing up a proper
new interface with some stupid legacy crap. It never worked before for
non-builtin devices anyway. It just happens to work on specific system
where everything was tight together. And these system are still working
fine without NVS_REPORT btw. My X200 and the EeePC showed no problems so
far.

> > > You propose to exclude a feature that currently works, on the grounds 
> > > that it is inherently broken.  But you haven't said that this has ever 
> > > caused incorrect behavior.  All you have said so far is that it is a hack.
> > 
> > This never worked so far. The mac80211 or Bluetooth subsystems have no
> > RFKILL state and thus global states are not enforced. An external dongle
> > without RFKILL support is not taken into account. You are not talking
> > about global states here. They are all device specific. The device just
> > happens to be a platform device builtin the system.
> 
> Right, but rfkill does actually have a function to set the global policy
> state (rfkill_set_global_sw_state) which some platform drivers insist on
> calling.

We just need to fix the platform drivers then. They should not set
global states since that is not what they are controlling. They control
the devices built-in to their platform/system. All this USB hotplug does
enough damage already and messing with global states is just wrong.

> The only reason we would need the NVS_REPORT then is to detect whether
> or not anything in the kernel called rfkill_set_global_sw_state(). If we
> can live with just configuring rfkilld for the (arguably broken) case
> where somebody cares about this, I'm happy with removing it.

Yes, please. Don't add this. Lets use our current base and start working
on rfkilld and see how it goes. I am assuming it is not as broken as
people think it is. I am against just adding new commands for the sake
of some wrong believes in legacy crap. Extending interfaces is simple,
but deprecating pieces is complicated.

> Hope that helps clear up your confusion.

I did have the same understanding here. Problem is just that we keep
mixing device specific and global states and that they are used wrongly.
And also platform devices are not necessary global. Linux just names
them platform if they have no proper root.

Regards

Marcel


