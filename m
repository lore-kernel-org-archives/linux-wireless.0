Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60736 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab1ELSSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 14:18:48 -0400
Message-ID: <4DCC2485.4020808@candelatech.com> (sfid-20110512_201852_448706_7DBFEC87)
Date: Thu, 12 May 2011 11:18:45 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
References: <4DBF1967.9010604@candelatech.com>	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>	<4DC042A5.9050806@candelatech.com>	<BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com>	<4DC17DAE.9020808@candelatech.com>	<4DC47C04.1080604@candelatech.com>	<4DC83B03.5070002@candelatech.com> <BANLkTimtRz8SMTRnn57CUgkudJ6=_vK+kw@mail.gmail.com> <4DC9A557.9050405@candelatech.com>
In-Reply-To: <4DC9A557.9050405@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 01:51 PM, Ben Greear wrote:
> On 05/09/2011 07:21 PM, Adrian Chadd wrote:
>> On 10 May 2011 03:05, Ben Greear<greearb@candelatech.com> wrote:
>>
>>> The NIC is still showing up funky on the other system (Atom), even
>>> with the
>>> same 39-rc6+ kernel.
>>>
>>> This NIC is reliably showing up wrong on in this system, and the other
>>> is reliably showing up well, so I think the problem must be with
>>> the NIC or perhaps the ath9k driver.
>>>
>> When you say "other NIC", you mean "BC1A" revision, rather than "AC1E" ?
>>
>>> If anyone has any suggestions for how to debug this further, I'm
>>> interested...

I found something interesting:  In a third system, the NIC also fails
when in the pci <-> mini-pci adapter card, but it works
when plugged directly to the motherboard mini-pci slot.  So, in two
of the three systems with on-board mini-pci, it works, and in two of the three
systems it fails when using the adapter board.  So, I assume the problem
must be related to a bad interaction with the adapter board.

Could be that the bug is entirely in the adapter board..though of
course other NICs work fine in that adapter board....

Thanks,
Ben

>>
>> Can you try (much) earlier kernels? Ignore ath9k; ath9k shouldn't be
>> needed for the card device id to be setup on PCI bus reset or whenever
>> specifically it happens.
>
> I tried a stock F14 .35 kernel, same problem.
>
> I tried booting a .29 kernel, but F14 won't boot
> on so old of a kernel.
>
> Current plan is to just stick it in one of the VIA systems
> that it functions in and use it for testing..and never buy any
> more of those SR71-A NICs.
>
> The sparklan 127N 3x3 pci-e seems to be working very well, so
> I plan to start using them instead.
>
> Thanks,
> Ben
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

