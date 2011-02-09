Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37194 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1BIXRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 18:17:06 -0500
Received: by vxb37 with SMTP id 37so363550vxb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 15:17:04 -0800 (PST)
Message-ID: <4D5320AA.5020405@lwfinger.net>
Date: Wed, 09 Feb 2011 17:18:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	=?UTF-8?B?TWljaGE=?= =?UTF-8?B?ZWwgQsO8c2No?= <mb@bu3sch.de>
CC: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org
Subject: Re: SSB AI support code
References: <1297258590.17400.37.camel@dev.znau.edu.ua>	<AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>	<1297288286.9734.28.camel@maggie> <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
In-Reply-To: <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 04:53 PM, Rafał Miłecki wrote:
> W dniu 9 lutego 2011 22:51 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
>> On Wed, 2011-02-09 at 22:35 +0100, Rafał Miłecki wrote:
>>> What about proposed solution?
>>
>> Well, I'm not going to maintain it due to a lack of devices,
>> knowledge of the AI and a serious lack of additional time.
>>
>> However, I'm certainly OK with you adopting maintainership
>> if people think that the code looks sane and should be merged.
>>
>> One thing I really don't like is the name-confusion introduced
>> by this. We will have functions with the ssb_...() prefix
>> that don't necessarily operate on ssb devices, but on AI devices
>> instead, depending on the actual magic behind the scenes.
>> That's one of the major things I tried hard to avoid in the
>> SSB design from day 0 on.
>> It's what I hated most about Broadcom's SB implementation (there it
>> is pci_...() functions, which operate on PCI, SB or whatever else
>> depending on some serious magic).
>>
>> So my proposal doesn't change: Create two separate busses (SSB and AI)
>> and port the device drivers to work on both. That also implies
>> decoupling the built-in SSB device drivers (CC, MIPS, EXTIF, PCICORE)
>> from the SSB implementation.
>> The code duplication will negligible.
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
> 
> What are the other cores for? Why do we need driver for chipcommon,
> mipscore? Are that cores internally accessed by 80211 core?
> 
> What is that whole AI? Is that replacement for SSB? Does it also
> contains cores? What AI and SSB share?

Michael,

Do you have a copy of the BCM5365P for Rafal? The link in the specs
(http://voodoowarez.com/bcm5365p.pdf) is apparently no longer available. My
recollection is that it had a good description of the SSB.

Larry
