Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42247 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab1BIWxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 17:53:51 -0500
Received: by qwa26 with SMTP id 26so557365qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 14:53:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297288286.9734.28.camel@maggie>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	<AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	<1297288286.9734.28.camel@maggie>
Date: Wed, 9 Feb 2011 23:53:50 +0100
Message-ID: <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
Subject: Re: SSB AI support code
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 lutego 2011 22:51 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Wed, 2011-02-09 at 22:35 +0100, Rafał Miłecki wrote:
>> What about proposed solution?
>
> Well, I'm not going to maintain it due to a lack of devices,
> knowledge of the AI and a serious lack of additional time.
>
> However, I'm certainly OK with you adopting maintainership
> if people think that the code looks sane and should be merged.
>
> One thing I really don't like is the name-confusion introduced
> by this. We will have functions with the ssb_...() prefix
> that don't necessarily operate on ssb devices, but on AI devices
> instead, depending on the actual magic behind the scenes.
> That's one of the major things I tried hard to avoid in the
> SSB design from day 0 on.
> It's what I hated most about Broadcom's SB implementation (there it
> is pci_...() functions, which operate on PCI, SB or whatever else
> depending on some serious magic).
>
> So my proposal doesn't change: Create two separate busses (SSB and AI)
> and port the device drivers to work on both. That also implies
> decoupling the built-in SSB device drivers (CC, MIPS, EXTIF, PCICORE)
> from the SSB implementation.
> The code duplication will negligible.

OK, I think I'll need some your help with better understanding SSB.

AFAIK SSB is "box" (ssb_bus) containing cores (ssb_devices).

How do we talk with SSB? Is this that magic "Hostbus"? What does it
mean? Do we use one of the cores of ssb_bus to talk? Is this why I see
"ssb: Core 2 found: PCI-E (cc 0x820, rev 0x02, vendor 0x4243)"? If
only one core can be selected at time, how is this possible we selecre
802.11 core and we are still able to talk with SSB?

What are the other cores for? Why do we need driver for chipcommon,
mipscore? Are that cores internally accessed by 80211 core?

What is that whole AI? Is that replacement for SSB? Does it also
contains cores? What AI and SSB share?

-- 
Rafał
