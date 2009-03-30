Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42023 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755955AbZC3UsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:48:09 -0400
Date: Mon, 30 Mar 2009 17:48:00 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: [RFC] rfkill: rewrite
Message-ID: <20090330204800.GC23749@khazad-dum.debian.net> (sfid-20090330_224812_393211_E3AC7116)
References: <1238349195.24972.5.camel@johannes.local> <1238406057.24972.23.camel@johannes.local> <20090330132911.GC11934@khazad-dum.debian.net> <1238422114.5970.6.camel@johannes.local> <20090330173421.GB23749@khazad-dum.debian.net> <1238434878.5970.17.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238434878.5970.17.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Mar 2009, Johannes Berg wrote:
> Thanks for the explanation. I guess that kinda makes sense. One thing
> I'm entirely sure about -- I had removed the sw default state setter --
> I guess this code still requires then? I was thinking the sw default

Yes, thinkpad-acpi wants it.  It uses that to make sure the bluethooth
and wwan rfkill _global_ state is kept across machine shutdown and
reboots (I can't do that for UWB because Lenovo didn't add persistence
for UWB for some reason).

Here's how it works:

0.  Platform boots with the radio states that were in NVRAM

1.  thinkpad-acpi loads
    1a. reads radio states from firmware, and stores to rfkill core
        default state for the specific radio type
    1b. registers the rfkill switch.  The core will cause the just
        registered rfkill switch state to be changed to match the
        current global state for that switch type... which probably
        is what thinkpad-acpi tried to set in 1a.

(normal system lifecycle)

2.  thinkpad-acpi unload (or machine shutdown via platform bus
    shutdown)
    2a. commands firmware to store current radio state to NVRAM


So, if thinkpad-acpi is the first rfkill driver of a certain radio
type to load, it will cause the state for that radio type to be
persistent.   If it is not the first driver to load, well, there is
nothing we can do, and the radio state will be whatever is the current
global state for that radio.

The rfkill core tries to keep global states, that are per type. That's
why the default is per type (and not per rfkill controller).

Without it, all rfkill types will initally be either blocked or
unblocked, depending on a module parameter for the rfkill core.

> state should be set for the devices it applies to, but it seems that if
> the master rfkill switch is set to "transmitter off" then one needs to
> set the default state (for all USB transmitters etc) to off, correct?

Well, the default is applied to a _type_, so it is valid for all
switches of that type.

It is probably a good idea to have the rfkill core sanitize the
attempt to set the default state, and force it to "block" if EPO is
active (I don't recall if I checked for this failure mode in the old
code).

On a _thinkpad_, the state stored in NVRAM will be overriden by the
master switch, because the driver gets that information very
indirectly (the firmware sets the initial rfkill controller state from
NVRAM, and the driver just reads the rfkill controlled state at
startup -- and if the master switch is active, the driver will read
all rfkill controllers as blocked).   A driver that could get the
persistent state directly from NVRAM might not be so limited.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
