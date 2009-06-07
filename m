Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59555 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZFGMit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:38:49 -0400
Received: by bwz9 with SMTP id 9so2475228bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 05:38:50 -0700 (PDT)
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <1244088806.4145.24.camel@localhost.localdomain>
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
Date: Sun, 7 Jun 2009 13:38:50 +0100
Message-ID: <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/4/09, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Henrique,
>
>> > > > We just need to fix the platform drivers then. They should not set
>> > > > global states since that is not what they are controlling. They
>> > > > control
>> > >
>> > > We should change things, yes.  So that the platform stores the global
>> > > state.  That was half-broken on the old core (the platform stored the
>> > > state of its own device, which could be out of sync with the global
>> > > state), but the part of it setting the global state is correct.
>> > >
>> > > That needs a new in-kernel API to tie the core to platform drivers
>> > > capable of storing global states without causing problems when drivers
>> > > are unloaded, but it is not hard.
>> > >
>> > > As for NVS events, they have a clear use case: to let rfkilld know
>> > > which
>> > > global states it could leave alone the first time it loads, and which
>> > > ones have to be restored...
>> >
>> > show me an example of a platform device that stores the global state. I
>> > think you are confusing the word platform as in system with a platform
>> > device. The ThinkPad Bluetooth and WWAN switches are platform devices
>> > and control each one specific device. Same goes for the EeePC. They are
>> > not controlling a global state.
>>
>> I don't know what big difference you see between the two uses of
>> "platform",
>> but I will just work around it to get something useful out of this mail.
>>
>> The laptop stores in NVS the state of its 'switches'.  This is as close as
>> one gets from 'storing the global state'.   When the laptop boots,
>> these devices get set by the firware to the state in NVS.  It is the best
>> place to store global state, because these devices will be in their proper
>> state (i.e. matching what will be the global state when the rfkill core
>> loads) all the time.  It also gives you for free multi-OS/multi-kernel
>> state
>> storage for these devices, and compatibility with BIOSes that let you
>> define
>> the initial state for the devices in the firmware configuration, etc.
>
> it stores the state of its switches and why should these be enforced as
> a global state? Who says that this is a global state? For me that sounds
> like policy.

We don't seem to be getting very far :-(.  I agree that these do not
appear to be global states, just the states of individual rfkill
devices.

So I would propose the following changes.  (I'm happy to write the
code as well, but I think it's easier to read English).

 1) remove rfkill_set_global_sw_state()
 2) rfkill devices with NVS can e.g. call rfkill_has_nvs() before
registration, setting a flag.
 3) the "has NVS" flag is reported by /dev/rfkill, (at least in ADD
events, tho it may as well be set in all events)
 4) rfkill-input preserves existing behaviour - *if enabled* - by
initializing the global state from individual devices which have NVS.
(As before, each _type_ of rfkill device has its own global state).
 5) rfkill devices with NVS will have their current state preserved,
so long as the global state has not yet been set (by userspace or by
rfkill-input).  Of course userspace can change the state in response
to the device being added.

 => rfkilld then has the information required to implement the same
policy as rfkill-input.  Furthermore, it will have enough information
that it could implement file-based storage as a fallback, and still
support NVS where available.

It will also allow implementation (or configuration) of completely
different policy to rfkill-input.  E.g. if your internal wireless
w/NVS is broken and should be disabled, that can be done independently
of your replacement USB wireless adaptor.

Comments?
Alan
