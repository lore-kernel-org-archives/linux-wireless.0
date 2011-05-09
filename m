Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52339 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab1EITFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 15:05:42 -0400
Message-ID: <4DC83B03.5070002@candelatech.com> (sfid-20110509_210549_910436_49C27E5E)
Date: Mon, 09 May 2011 12:05:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
References: <4DBF1967.9010604@candelatech.com>	<BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>	<4DC042A5.9050806@candelatech.com> <BANLkTikuw4uSOL5zoMa9QzOsajnSyhEsGQ@mail.gmail.com> <4DC17DAE.9020808@candelatech.com> <4DC47C04.1080604@candelatech.com>
In-Reply-To: <4DC47C04.1080604@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2011 03:53 PM, Ben Greear wrote:
> On 05/04/2011 09:24 AM, Ben Greear wrote:
>> On 05/04/2011 09:16 AM, Adrian Chadd wrote:
>>> On 4 May 2011 02:00, Ben Greear<greearb@candelatech.com> wrote:
>>>
>>>> Here's the lspci for the SR71-A that doesn't work with ath9k:
>>>>
>>>> 03:00.0 Ethernet controller: Atheros Communications Inc. AR5008
>>>> Wireless
>>>> Network Adapter (rev 01)
>>>> Subsystem: Atheros Communications Inc. Device ee1c
>>>
>>> ... ee1c? Err, that isn't right. Not by a very, very long shot.
>>>
>>> What board are you putting this into?
>>>
>>>> From FreeBSD on a RSPRO (ar71xx mips):
>>>
>>> ath0@pci0:0:17:0: class=0x028000 card=0x40820777 chip=0x0027168c
>>> rev=0x01 hdr=0x00
>>> vendor = 'Atheros Communications Inc.'
>>> class = network
>>>
>>> That definitely, positively is the same AC1A revision that you have.
>>> It even does 11n(ag) too. Honest. I've seen it. :-)
>>>
>>> This and the previous AR93xx "0xabcd" device id post is starting to
>>> sound a lot like something's not waking up the PCI bus and/or chip
>>> "right" in order to get the PCI vendor id init'ed from the EEPROM..
>>
>> Well, I put in one NIC, it works fine, I put in the other, and it
>> doesn't.
>>
>> Same system, reproducible on other systems from same manufacturer
>> (Lanner, LEC 2010E).
>>
>> Haven't tried it on a totally different motherboard. I'll send you this
>> broken NIC if you want...I'm too tight on time to hack on it now...
>
> So, you were right. I put this NIC in another system (VIA C3) and it
> comes up
> as AR9160 and loads ath9k driver just fine.
>
> 00:0c.0 Network controller: Atheros Communications Inc. AR9160
> 802.11abgn Wireless PCI Adapter (rev 01)
> Subsystem: Device 0777:4082
> Flags: bus master, 66MHz, medium devsel, latency 168, IRQ 18
> Memory at f6000000 (32-bit, non-prefetchable) [size=64K]
> Capabilities: [44] Power Management version 2
> Kernel driver in use: ath9k
> Kernel modules: ath9k

The NIC is still showing up funky on the other system (Atom), even with the
same 39-rc6+ kernel.

This NIC is reliably showing up wrong on in this system, and the other
is reliably showing up well, so I think the problem must be with
the NIC or perhaps the ath9k driver.

If anyone has any suggestions for how to debug this further, I'm
interested...

Thanks,
Ben

>
> Thanks,
> Ben
>
>>
>> Ben
>>
>>
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

