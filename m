Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:42039 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZK1PcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 10:32:23 -0500
Message-ID: <4B114288.2000409@tuffmail.co.uk>
Date: Sat, 28 Nov 2009 15:32:24 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ian Molton <ian.molton@collabora.co.uk>,
	linux-acpi@vger.kernel.org, Corentin Chary <corentincj@iksaif.net>
Subject: Re: rfkill: persistent device suspend/resume
References: <4A37A3E1.8060606@tuffmail.co.uk> <1245161645.13461.3.camel@johannes.local> <4A37AEB7.6060405@tuffmail.co.uk> <20090618030806.GE29569@khazad-dum.debian.net> <20091128124158.GB17373@khazad-dum.debian.net>
In-Reply-To: <20091128124158.GB17373@khazad-dum.debian.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> On Thu, 18 Jun 2009, Henrique de Moraes Holschuh wrote:
>   
>>> The setting of the "persistent" flag is also made more explicit using
>>> a new rfkill_init_sw_state() function, instead of special-casing
>>> rfkill_set_sw_state() when it is called before registration.
>>>
>>> Suspend is a bit of a corner case so we try to get away without adding
>>> another hack to rfkill-input - it's going to be removed soon.
>>> If the state does change over suspend, users will simply have to prod
>>> rfkill-input twice in order to toggle the state.
>>>       
>
> Well, I acked it, but I didn't do my job properly and didn't notice the
> above.
>
> Suspend/resume is not much of a corner case at all:  unless overriden by
> some weird policy that doesn't even exist right now (the only one that comes
> to mind is to have it always off upon resume in highly-critical
> environments), we really want to restore the hardware to the previous soft
> state, subject to any changes on any hard state that happened while the
> machine was sleeping.
>
> And any "weird policy" we might implement would have to come through the
> core anyway.  So, we really should be taking advantage of the fact that the
> rfkill class will resume *after* the device, and let the core call the
> backend (unconditionally, so it is also a way to make sure the
> firmware/hardware is in sync with the core) to set the proper state after a
> resume.
>
> The backend will be able to update any hard states before the rfkill class
> resume code runs, so this will always work fine.   It also allows the
> backend driver to ask the platform to resume with radios disabled, so that
> if we _ever_ decide to change the core to have a different policy to what
> should be done to radios on resume (e.g. leave them off and wait for
> userspace to tell us what to do :) ), that will need no change to drivers
> (and radios won't get turned on just to be turned off, etc).
>
> It will also let us remove a few LOC from eeepc-laptop and avoid adding a
> few LOC to thinkpad-acpi (which has a regression since 2.6.30 because failed
> to notice I would have to handle resume).
>
> What do you guys think?   I will cook up a patch to implement the above, but
> if there are any objections to the idea, I'd like to hear it ASAP, as I do
> have a regression to fix :)
>
> Note: eeepc-laptop and thinkpad-acpi are the only rfkill persistent devices
> in-tree

"Suspend/resume is not much of a corner case at all"


Sorry for my naff patch description. The actual corner case is when the 
soft rfkill state changes between when we suspend and resume.


"we really want to restore the hardware to the previous soft state"

Context warning: this only affects "persistent" rfkill devices. We 
currently do this for everything except thinkpad-acpi and eeepc-laptop.

Blame Marcel, the current choice was his suggestion :). I think his 
argument was that restoring the state could impose policy, and that this 
would be bad. I didn't resist too hard because his principle provides a 
marginal feature in eeepc-laptop.

[That said, I later noticed that it speeds up resume from s2ram. 
eeepc-laptop is 'special'; its WLDS method takes a whole second to run.]

To elaborate:

The state in NV-ram may be changed deliberately. On eeepc-laptop, you 
can change it in the BIOS setup screen - and then resume from 
hibernation. Marcel suggests that overriding this change would be a 
policy decision, which userspace should be able to control. The simplest 
way to do so is to simply preserve the state (and emit an event to 
notify userspace of the change).

I thought thinkpad-acpi might also allow such changes. At least for some 
controls, the BIOS defaults to implementing them itself, right? Even if 
this isn't true for rfkill on the thinkpad, it's a possibility we may 
encounter in future. Imagine a system where this happens:

- hibernate
- boot resume kernel
- user presses rfkill key -> BIOS toggles the rfkill state
- load kernel from hibernation image
- rfkill resume now unconditionally overrides the rfkill state

So your suggestion forces users to accept corner case behaviour like 
this. Marcel's position appears to come from writing a userspace daemon 
which provides persistent state for all rfkill devices. That is, if we 
want to keep in-kernel handling of persistent state in the long run, we 
have to justify it by addressing the corner cases which only the kernel 
can solve.

rfkill-input is scheduled for removal in anticipation of rfkilld. If you 
want to schedule removal of persistent rfkill devices in anticipation of 
"rfkilld with persistence", that would seem just as reasonable :-p. I'm 
sure Johannes would then accept the small change to the rfkill core to 
fix this regression.

Alan
