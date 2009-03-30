Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37831 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750962AbZC3Re0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 13:34:26 -0400
Date: Mon, 30 Mar 2009 14:34:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330173421.GB23749@khazad-dum.debian.net> (sfid-20090330_193429_363051_4E117444)
References: <1238349195.24972.5.camel@johannes.local> <1238406057.24972.23.camel@johannes.local> <20090330132911.GC11934@khazad-dum.debian.net> <1238422114.5970.6.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238422114.5970.6.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes!

On Mon, 30 Mar 2009, Johannes Berg wrote:

> On Mon, 2009-03-30 at 10:29 -0300, Henrique de Moraes Holschuh wrote:
> > On Mon, 30 Mar 2009, Johannes Berg wrote:
> > >  * thinkpad_acpi.c
> > >    -> need help, convoluted code I don't understand at all, looks like
> > >       another candidate for rewriting
> > 
> > Heh.  I will take care of it, obviously.   As for rewriting, well, a cleanup
> > is in the queue.
> 
> Heh, thanks. I appreciate any help even if the golden rule still is that
> those who change the API get to fix users :)
> 
> Thinkpad in particular confuses me due to the way it uses force_state
> and input. Is it like Dell in that the button press causes a soft block?

There are three independent rfkill controllers in a thinkpad: UWB, WWAN,
bluetooth.  They're hierarchically slaved to the master radio-kill switch in
the standard EPO way:  if the master switch is active, all rfkill
controllers are forced active (all radios are killed).  If the master switch
is not active, each rfkill controller can be independently set to kill or
not their respective radio.

When the user moves the phisical radio-kill switch, the thinkpad embedded
controller hard-kills every USB-attached radio (as in: cut power and kick
off-bus), raises the hardware rfkill line on the mini-PCI/mini-PCIe slots
(which will hard-block Intel wireless devices.  I think the Atheros ones
ignore it).   And sends us an event over ACPI (HKEY event 7000).

That event is used by the driver as a hint to check the state of all rfkill
controllers, and sync the core (thus, it causes calls to
rfkill_force_state()).  It is also sent to userspace as an input event (so
that rfkill-input can go and block other radios, such as USB dongles, etc).

It is also possible to request that hard-kill in the BIOS: the thinkpad
boots with all radios rfkilled (the BIOS tells the EC to radio-kill
everything and to keep them killed), and there is absolutely _nothing_ one
can do to unblock them, until a reboot and BIOS reconfig is done.

Anyway, thinkpad-acpi is a _hybrid_ driver as far as rfkill is concerned.
It has rfkill controllers, but it has an input device side too.

There is some highly paranoid logic in thinkpad-acpi that basically enforces
the radio-kill switch even if the firmware goes rogue on us and decides not
to do it.  This is just to guarantee that all thinkpads will behave the same
way, if there is one or two models out there with a weird firmware.  You can
ignore it when trying to understand the information flow in the driver, if I
ripped it out, most (all?) thinkpads would behave just the same.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
