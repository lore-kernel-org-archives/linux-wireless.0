Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55402 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756080AbYGGVVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:21:22 -0400
Date: Mon, 7 Jul 2008 18:21:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Andrew Lutomirski <luto@myrealbox.com>
Cc: thomasw@gmail.com, zhu.yi@intel.com,
	linux-wireless@vger.kernel.org, dcbw@redhat.com
Subject: Re: Question on rfkill double block
Message-ID: <20080707212116.GC3166@khazad-dum.debian.net> (sfid-20080707_232126_430453_95EE9FC8)
References: <1214982208.14590.473.camel@debian.sh.intel.com> <20080702193202.GA20410@khazad-dum.debian.net> <1ba2fa240807051428i3f49f621i7b583bec58a02869@mail.gmail.com> <20080706002037.GD21973@khazad-dum.debian.net> <48719F2F.5060301@myrealbox.com> <20080707165634.GA24815@khazad-dum.debian.net> <cb0375e10807071147u5a8ce6bsd6193a2e11dac24@mail.gmail.com> <cb0375e10807071218w3dacef45kaaaba102ecc03c59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cb0375e10807071218w3dacef45kaaaba102ecc03c59@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 07 Jul 2008, Andrew Lutomirski wrote:
> OK, got a "bug" for you.  I'm not sure whether it's a bug in rfkill,
> rfkill-input, iwlwifi, thinkpad-acpi, or the way they all interact.

Just in case it is not a bug, please add a printk to thinpad-acpi's sysfs
and procfs handle to get notified when something in userspace orders it to
enable/disable bluetooth through the non-rfkill interface.  You might catch
some userspace script doing the nasty ;-)

> But if I toggle bluetooth off (killed and therefore not present in the
> system per thinkpad-acpi), then block wlan with the switch, then
> unblock wlan with the switch, then bluetooth turns back on.  This only
> happens with rfkill-input loaded.  I hope this isn't the intended
> behavior.

It is, but I have plans to try to give rfkill-input a different behaviour.
Right now, EV_SW SW_RFKILL_ALL ON  means "turn every radio on" for
rfkill-input.  I'd like to give it an option of doing instead "revert last
EV_SW SW_RFKILL_ALL OFF".

But that patch has to wait a bit, still.  There are others in the TODO queue
before it, some of which will change the way rfkill_epo has to work, so I
want to do them first to not do the same work twice.

> So the right input events are generated (or maybe not -- should
> thinkpad-acpi generate events at all for a hardware switch?), but it

Yes, it is an input device, and thinkpad-acpi is the closest driver to the
switch, so it is the one which should handle it.

Imagine that you have a WLAN USB dongle.  Wouldn't you want it to also be
subject to the hardware switch in the general case?  If thinkpad-acpi
doesn't issue input events for the switch, that would never happen.

> looks like rfkill-input thinks that it's supposed to turn bluetooth on
> when the switch goes on.

Exactly.

> Is this an artifact of the present design or is it just a bug?

Current implementation, actually.  The design says it could do anything.
rfkill-input implements the easier behaviour (unblock all), but it could do
other things too (including nothing, to let an application call up a GUI
pannel and ask the user).

It is in the TODO queue.

> (My mental picture of how it should work is that there should be
> "switches" and "switchable things," both of which show up in sysfs,

Can you use the terms "rfkill controller", "rfkill line" and "input device"
(as defined in the rfkill documentation) so that I know for sure what you
mean, please? 

> and which can be wired up arbitrarily (consistent with hardware, so a
> switch that physically controls an rfkill line couldn't be unwired
> from it) in sysfs, kinda like led triggers.  "switches" would be

The current design asks for a topology-agnostic model.  To do otherwise
would mean we have to teach rfkill about the topology, which is something
that is machine-model-specific... and much more complex.

*WHEN* the rfkill work I am attempting to do is finally ready, you will be
able to just move rfkill-input out of the way (either disable it or just
rmmod it), and implement in userspace whatever your heart desires.

When rfkill-input is inactive, the only thing that messes with the rfkill
state of the devices is the "non-modifiable wiring" done by hardware or
firmware. So you'd be able to do the "custom virtual wiring" you want.

In fact, right now you can already do what you want by just rmmoding
rfkill-input.  The only thing you can't really do from userspace right now
is to tell rfkill what the state of a newly-registered rfkill switch should
be.  You will have to change it to the state you want after it is
registered.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
