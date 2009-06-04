Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:48009 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZFDENu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 00:13:50 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Marcel Holtmann <marcel@holtmann.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090603213340.GB22809@khazad-dum.debian.net>
References: <1243858256.5299.14.camel@johannes.local>
	 <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
Content-Type: text/plain
Date: Thu, 04 Jun 2009 06:13:26 +0200
Message-Id: <1244088806.4145.24.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henrique,

> > > > We just need to fix the platform drivers then. They should not set
> > > > global states since that is not what they are controlling. They control
> > > 
> > > We should change things, yes.  So that the platform stores the global
> > > state.  That was half-broken on the old core (the platform stored the
> > > state of its own device, which could be out of sync with the global
> > > state), but the part of it setting the global state is correct.
> > > 
> > > That needs a new in-kernel API to tie the core to platform drivers
> > > capable of storing global states without causing problems when drivers
> > > are unloaded, but it is not hard.
> > > 
> > > As for NVS events, they have a clear use case: to let rfkilld know which
> > > global states it could leave alone the first time it loads, and which
> > > ones have to be restored...
> > 
> > show me an example of a platform device that stores the global state. I
> > think you are confusing the word platform as in system with a platform
> > device. The ThinkPad Bluetooth and WWAN switches are platform devices
> > and control each one specific device. Same goes for the EeePC. They are
> > not controlling a global state.
> 
> I don't know what big difference you see between the two uses of "platform",
> but I will just work around it to get something useful out of this mail.
> 
> The laptop stores in NVS the state of its 'switches'.  This is as close as
> one gets from 'storing the global state'.   When the laptop boots,
> these devices get set by the firware to the state in NVS.  It is the best
> place to store global state, because these devices will be in their proper
> state (i.e. matching what will be the global state when the rfkill core
> loads) all the time.  It also gives you for free multi-OS/multi-kernel state
> storage for these devices, and compatibility with BIOSes that let you define
> the initial state for the devices in the firmware configuration, etc.

it stores the state of its switches and why should these be enforced as
a global state? Who says that this is a global state? For me that sounds
like policy.

> There.  I didn't use the 'p' word once.  Now, please tell me why show we
> just dump the storage done by the firmware in NVS, and instead store the
> global state for those switches in userspace?

We are getting OP_ADD for these switches when opening /dev/rfkill and it
is up to a userspace policy to either enforce this on all attached
devices or not.

> If it was a extremely complicated and fragile thing to do, it would be a
> different matter, but it isn't.  It isn't even ugly code, even after we fix
> it to be all about global states.

This is not about ugly code or anything alike. We wanna get the RFKILL
subsystem cleaned up now. And just overloading it with things that might
be a good idea is bad. Enhancing it later when it is actually needed is
way easy. And I am not convinced even a little bit that we should treat
the firmware stored states as global. They are not global states. You
are just abusing them as this.

Regards

Marcel


