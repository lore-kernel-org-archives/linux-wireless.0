Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:42489 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbZFGQgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 12:36:10 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A2BE520.6080207@tuffmail.co.uk>
References: <1243858256.5299.14.camel@johannes.local>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
	 <1244088806.4145.24.camel@localhost.localdomain>
	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
	 <1244389617.23850.102.camel@localhost.localdomain>
	 <4A2BE520.6080207@tuffmail.co.uk>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 18:35:36 +0200
Message-Id: <1244392536.23850.109.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alan,

> >>>>>>> We just need to fix the platform drivers then. They should not set
> >>>>>>> global states since that is not what they are controlling. They
> >>>>>>> control
> >>>>>>>               
> >>>>>> We should change things, yes.  So that the platform stores the global
> >>>>>> state.  That was half-broken on the old core (the platform stored the
> >>>>>> state of its own device, which could be out of sync with the global
> >>>>>> state), but the part of it setting the global state is correct.
> >>>>>>
> >>>>>> That needs a new in-kernel API to tie the core to platform drivers
> >>>>>> capable of storing global states without causing problems when drivers
> >>>>>> are unloaded, but it is not hard.
> >>>>>>
> >>>>>> As for NVS events, they have a clear use case: to let rfkilld know
> >>>>>> which
> >>>>>> global states it could leave alone the first time it loads, and which
> >>>>>> ones have to be restored...
> >>>>>>             
> >>>>> show me an example of a platform device that stores the global state. I
> >>>>> think you are confusing the word platform as in system with a platform
> >>>>> device. The ThinkPad Bluetooth and WWAN switches are platform devices
> >>>>> and control each one specific device. Same goes for the EeePC. They are
> >>>>> not controlling a global state.
> >>>>>           
> >>>> I don't know what big difference you see between the two uses of
> >>>> "platform",
> >>>> but I will just work around it to get something useful out of this mail.
> >>>>
> >>>> The laptop stores in NVS the state of its 'switches'.  This is as close as
> >>>> one gets from 'storing the global state'.   When the laptop boots,
> >>>> these devices get set by the firware to the state in NVS.  It is the best
> >>>> place to store global state, because these devices will be in their proper
> >>>> state (i.e. matching what will be the global state when the rfkill core
> >>>> loads) all the time.  It also gives you for free multi-OS/multi-kernel
> >>>> state
> >>>> storage for these devices, and compatibility with BIOSes that let you
> >>>> define
> >>>> the initial state for the devices in the firmware configuration, etc.
> >>>>         
> >>> it stores the state of its switches and why should these be enforced as
> >>> a global state? Who says that this is a global state? For me that sounds
> >>> like policy.
> >>>       
> >> We don't seem to be getting very far :-(.  I agree that these do not
> >> appear to be global states, just the states of individual rfkill
> >> devices.
> >>
> >> So I would propose the following changes.  (I'm happy to write the
> >> code as well, but I think it's easier to read English).
> >>
> >>  1) remove rfkill_set_global_sw_state()
> >>  2) rfkill devices with NVS can e.g. call rfkill_has_nvs() before
> >> registration, setting a flag.
> >>  3) the "has NVS" flag is reported by /dev/rfkill, (at least in ADD
> >> events, tho it may as well be set in all events)
> >>     
> >
> > you can do things like this already if you just set the states correctly
> > between rfkill_alloc and rfkill_register. So you should make sure you
> > register your RFKILL switch with the correct state and not toggle it
> > later. As far as I can tell the tpacpi driver does that already.
> >   
> 
> Ah.  I need to read the (rewritten) code again.

it could be still broken to some degree, but some stuff is just because
rfkill-input interferes. So disable rfkill-input via ioctl or not
compile it at all.

> I'm still more familiar with the old rfkill core.  My understanding was
> that the old core required drivers to say what their current state was,
> but if that differed from the global state then it would be changed to
> match.
> 
> >>  4) rfkill-input preserves existing behaviour - *if enabled* - by
> >> initializing the global state from individual devices which have NVS.
> >> (As before, each _type_ of rfkill device has its own global state).
> >>     
> >
> > That still sounds horribly wrong and has been for a long time, but
> > again, I don't care about rfkill-input since it will go away.
> >
> >   
> >>  5) rfkill devices with NVS will have their current state preserved,
> >> so long as the global state has not yet been set (by userspace or by
> >> rfkill-input).  Of course userspace can change the state in response
> >> to the device being added.
> >>     
> >
> > If you register your RFKILL switch properly, they do that already. See
> > my comment above. You start up with the proper state to begin with.
> >
> >   
> >>  => rfkilld then has the information required to implement the same
> >> policy as rfkill-input.  Furthermore, it will have enough information
> >> that it could implement file-based storage as a fallback, and still
> >> support NVS where available.
> >>
> >> It will also allow implementation (or configuration) of completely
> >> different policy to rfkill-input.  E.g. if your internal wireless
> >> w/NVS is broken and should be disabled, that can be done independently
> >> of your replacement USB wireless adaptor.
> >>     
> >
> > I did actually looked into this and userspace has all information
> > available to create a proper policy if you wanna treat your NVS states
> > (for example the tpacpi ones) as global states, you can easily do that
> > right now. It became really simple with /dev/rfkill.
> >   
> 
> I still think userspace is missing an important piece of information:
> whether the state of a certain rfkill device is persistent or not.
> 
> The driver knows exactly whether this is the case; from what you say it
> will call rfkill_set_state() before rfkill_register().  If it _doesn't_
> do this, there won't be any persistent state for userspace to retrieve
> anyway :-).
> 
> I don't think we should expect userspace to know whether or not a device
> has a persistent state.  Yes, it _could_ maintain whitelists, but why
> should it have to if the driver already knows?

If you want that, then the best approach seems an extra sysfs attribute
for this. It is not intrusive on the event API and lets udev etc. have
these information, too.

> > So I have code for adding full native and integrated RFKILL support to
> > the Bluetooth subsystem and that works nicely in conjunction with the
> > hardware killswitch my system has. I still have to test WiMAX and do
> > some modifications for the Ericsson MBM 3G stuff. So at some point we
> > should have softkill support for all major radios.
> 
> Nice.
> 
> > Only exception are
> > the 3G cards that present themselves as modems with PPP. They are to
> > tricky and I have no idea right now how we could integrate them.
> >   
> 
> Would a urfkill work, analagous to uinput?.  I.e. allow the userspace
> driver (whatever talks to the configuration interface) to export its own
> rfkill device.  I don't know what the uinput interface is, but you could
> create one by opening /dev/urfkill and writing the initial state, and
> destroy it on close().

Maybe. I am not sold on this right now, but I also haven't spend enough
time on this. We might just accept that these special external devices
can't be fixed easily anyway.

Regards

Marcel


