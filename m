Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:60272 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab1BIXiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 18:38:06 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000020162.msg
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 01:37:29 +0200
Subject: Re: SSB AI support code
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 10 Feb 2011 01:30:34 +0200
Message-Id: <1297294234.12795.2.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> W dniu 9 lutego 2011 22:51 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> > On Wed, 2011-02-09 at 22:35 +0100, Rafał Miłecki wrote:
> >> What about proposed solution?
> >
> > Well, I'm not going to maintain it due to a lack of devices,
> > knowledge of the AI and a serious lack of additional time.
> >
> > However, I'm certainly OK with you adopting maintainership
> > if people think that the code looks sane and should be merged.
> >
> > One thing I really don't like is the name-confusion introduced
> > by this. We will have functions with the ssb_...() prefix
> > that don't necessarily operate on ssb devices, but on AI devices
> > instead, depending on the actual magic behind the scenes.
> > That's one of the major things I tried hard to avoid in the
> > SSB design from day 0 on.
> > It's what I hated most about Broadcom's SB implementation (there it
> > is pci_...() functions, which operate on PCI, SB or whatever else
> > depending on some serious magic).
> >
> > So my proposal doesn't change: Create two separate busses (SSB and AI)
> > and port the device drivers to work on both. That also implies
> > decoupling the built-in SSB device drivers (CC, MIPS, EXTIF, PCICORE)
> > from the SSB implementation.
> > The code duplication will negligible.
> 
> OK, I think I'll need some your help with better understanding SSB.
> 
> AFAIK SSB is "box" (ssb_bus) containing cores (ssb_devices).
> 
> How do we talk with SSB? Is this that magic "Hostbus"? What does it
> mean? Do we use one of the cores of ssb_bus to talk? Is this why I see
> "ssb: Core 2 found: PCI-E (cc 0x820, rev 0x02, vendor 0x4243)"? If
> only one core can be selected at time, how is this possible we selecre
> 802.11 core and we are still able to talk with SSB?
Not like I know how is that actually expressed in hardware. But here is
what I understood from broadcom's sources for SB/AI buses. Would be much
appreciated for comments on this or maybe some good and fat .pdf's (not
actually hope I will ever see one, seems its like top-secret stuff).

SB/AI cores - some hw interconnecting actual device to bus services.
Some cores (like b11, b44 etc) can talk to bus directly without
intermediate hw, others (like ohci on some bcm socs) wrapped by sumthing
working the way out to the cpu on behalf of device. Bus provides access
to each core and therefore to each final device by means of mmio. Some
of these registers are to manage device'-to-bus and versa workflow (like
tmslow/high, dma control regs, etc), others are solely device registers
(like mii phy access) to controler device itself. Each device registers'
set is mapped into memory one after another 4K space for each core.
For some systems (plain SSB bus) base is at SSB_ENUM_BASE, for others
(connected over e. g. PCI or PCMCIA) prior accessing device ssb code
must "ask" host bus to map ssb core registers' into cpu addrspace prior
accessing it.
When you see "Core xxx found" its ssb scan code iterating through cores'
register space. Either just +0x1000 mmio regs base or requesting
underlying bus to switch active core before probing next one and then
reading/parsing their IDHI register for identification data.

> What are the other cores for? Why do we need driver for chipcommon,
> mipscore? Are that cores internally accessed by 80211 core?
Prior to using any core, very same as b43 one, others (mipscore, usb,
b44, etc.) must be set up properly.
Therefore drivers exists. Chipcommon need setup as well - it handles
cpu/mem/bus/clocks, power control, built-in uarts and might be much
more. Its like "wrapper" core for indirect bus management.
And I dont know if 80211 is talking directly to any other core except
maybe chipcommon.

> What is that whole AI? Is that replacement for SSB? Does it also
> contains cores? What AI and SSB share?
> 
While I was struggling with emailer in mine goddamn sloooooooow gnome
x-win terminal Michael already extremely precisely told what AI is ;)

Have nice day,
George


