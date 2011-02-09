Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59547 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab1BIXKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 18:10:15 -0500
Subject: Re: SSB AI support code
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com> (sfid-20110209_235402_132054_FFFFFFFFCF302BC4)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 (sfid-20110209_235402_132054_FFFFFFFFCF302BC4)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 00:10:08 +0100
Message-ID: <1297293008.9734.45.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 23:53 +0100, Rafał Miłecki wrote: 
> OK, I think I'll need some your help with better understanding SSB.
> 
> AFAIK SSB is "box" (ssb_bus) containing cores (ssb_devices).

SSB and AI are just simple interconnects that can be used on-chip
or on embedded boards. The devices connected to this interconnect
(or bus) are the "cores".

> How do we talk with SSB? Is this that magic "Hostbus"? What does it
> mean? Do we use one of the cores of ssb_bus to talk? Is this why I see
> "ssb: Core 2 found: PCI-E (cc 0x820, rev 0x02, vendor 0x4243)"? If
> only one core can be selected at time, how is this possible we selecre
> 802.11 core and we are still able to talk with SSB?

That completely depends on what hostbus we're on. It's completely hidden
by SSB's I/O ops. For the trivial case without any hostbus (embedded),
the cores
are simply mapped into MMIO one after another. For the PCI hostbus case,
the MMIO has to be remapped (through PCI config space) on each
core switch. (Core switches are completely hidden from the device 
drivers). PCMCIA and SDIO are similar.

> What are the other cores for? Why do we need driver for chipcommon,
> mipscore? Are that cores internally accessed by 80211 core?

The chipcommon is a management core for the interconnect.

Device drivers are (mostly) distinct. There are a few exceptions.
Built-in device drivers (drivers/ssb/driver_....c) have some
interdependencies. However, b43, b44 and ssb-gige are completely
independent, for example.

> What is that whole AI? Is that replacement for SSB? Does it also
> contains cores? What AI and SSB share?

It is a replacement that shares some register API and design
decisions with SSB.
People who worked some time with broadcom stuff will recognize the
pattern: Take old stuff -> redesign it -> put lots of workarounds
and patching layers on top of it to be theoretically compatible
with old code -> fail at being fully compatible -> release it.

-- 
Greetings Michael.

