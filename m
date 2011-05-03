Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47072 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1ECSAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 14:00:08 -0400
Message-ID: <4DC042A5.9050806@candelatech.com> (sfid-20110503_200012_799181_7B684E11)
Date: Tue, 03 May 2011 11:00:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for 3x3 Atheros NICs using ath9k driver.
References: <4DBF1967.9010604@candelatech.com> <BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
In-Reply-To: <BANLkTimYks_+QRUNURtbRy+S941fL04HRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2011 11:13 PM, Adrian Chadd wrote:
> The AR9160/SR71-A should be supported by ath9k. They're just 2x2
> stream devices using 3 radios.
>
> What do you mean by "not even supported" ?
>
> If the SR71-A isn't working for you then please email the ath9k list
> and I'll take a look. I have a bunch of SR71-A hardware here to tinker
> with.

Here's the lspci for the SR71-A that doesn't work with ath9k:

03:00.0 Ethernet controller: Atheros Communications Inc. AR5008 Wireless Network Adapter (rev 01)
	Subsystem: Atheros Communications Inc. Device ee1c
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 15
	Region 0: Memory at febf0000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] #80 [0000]
	Capabilities: [80] #00 [0000]

The only visual difference we saw is that there is a chip labeled AR9160-AC1E
on the one above, and the ones that work have instead:  AR9160-BC1A

The SR71-A that *does* work, works very well for us.  The problem is just that we
cannot be sure of what we are receiving when we order stuff because the name
is the same for both NICs.

Thanks,
Ben


>
>
>
>
> Adrian
>
> On 3 May 2011 04:51, Ben Greear<greearb@candelatech.com>  wrote:
>> Hello!
>>
>> We are trying to find some Atheros NICs that support 3x3
>> MIMO, but we are having a hard time.
>>
>> We mistakenly ordered some Ubiquity SR71-A NICs, but those aren't
>> even supported by ath9k it seems (visible chipset is AR9160-AC1E).
>> There are some other SR71 NICs that *do* work (AR9160-BC1A), but
>> hard to order that specific version.
>>
>> Sparklan seems to make one based on AR9380, but they are not
>> in stock any place we could find.
>>
>> Anyone know of any others that are available to the public
>> in small quantities?
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear<greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

