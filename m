Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51251 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950AbZFCVdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 17:33:44 -0400
Date: Wed, 3 Jun 2009 18:33:40 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: create useful userspace interface
Message-ID: <20090603213340.GB22809@khazad-dum.debian.net>
References: <1243858256.5299.14.camel@johannes.local> <1243867620.3015.17.camel@localhost.localdomain> <4A23FD91.8020200@tuffmail.co.uk> <1243885494.3015.29.camel@localhost.localdomain> <4A24559D.7010201@tuffmail.co.uk> <1243928308.3192.38.camel@localhost.localdomain> <1243929706.20064.7.camel@johannes.local> <1243930703.3192.59.camel@localhost.localdomain> <20090603040315.GA10464@khazad-dum.debian.net> <1244008652.4145.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244008652.4145.7.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 03 Jun 2009, Marcel Holtmann wrote:
> > > We just need to fix the platform drivers then. They should not set
> > > global states since that is not what they are controlling. They control
> > 
> > We should change things, yes.  So that the platform stores the global
> > state.  That was half-broken on the old core (the platform stored the
> > state of its own device, which could be out of sync with the global
> > state), but the part of it setting the global state is correct.
> > 
> > That needs a new in-kernel API to tie the core to platform drivers
> > capable of storing global states without causing problems when drivers
> > are unloaded, but it is not hard.
> > 
> > As for NVS events, they have a clear use case: to let rfkilld know which
> > global states it could leave alone the first time it loads, and which
> > ones have to be restored...
> 
> show me an example of a platform device that stores the global state. I
> think you are confusing the word platform as in system with a platform
> device. The ThinkPad Bluetooth and WWAN switches are platform devices
> and control each one specific device. Same goes for the EeePC. They are
> not controlling a global state.

I don't know what big difference you see between the two uses of "platform",
but I will just work around it to get something useful out of this mail.

The laptop stores in NVS the state of its 'switches'.  This is as close as
one gets from 'storing the global state'.   When the laptop boots,
these devices get set by the firware to the state in NVS.  It is the best
place to store global state, because these devices will be in their proper
state (i.e. matching what will be the global state when the rfkill core
loads) all the time.  It also gives you for free multi-OS/multi-kernel state
storage for these devices, and compatibility with BIOSes that let you define
the initial state for the devices in the firmware configuration, etc.

There.  I didn't use the 'p' word once.  Now, please tell me why show we
just dump the storage done by the firmware in NVS, and instead store the
global state for those switches in userspace?

If it was a extremely complicated and fragile thing to do, it would be a
different matter, but it isn't.  It isn't even ugly code, even after we fix
it to be all about global states.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
