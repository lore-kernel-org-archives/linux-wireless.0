Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37784 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaHSSSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 14:18:45 -0400
Message-ID: <53F394FF.7050209@candelatech.com> (sfid-20140819_201852_665382_94C4D241)
Date: Tue, 19 Aug 2014 11:18:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <1518134.xFh23iA8q1@blech> <53EA5E53.9010704@candelatech.com> <8289144.MKHmP0uSFO@debian64> <53ECED3E.4080907@candelatech.com>
In-Reply-To: <53ECED3E.4080907@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2014 10:09 AM, Ben Greear wrote:
> On 08/14/2014 05:39 AM, Christian Lamparter wrote:
>> On Tuesday, August 12, 2014 11:34:59 AM Ben Greear wrote:
>>> On 08/10/2014 06:44 AM, Christian Lamparter wrote:
>>>> On Thursday, August 07, 2014 10:45:01 AM Ben Greear wrote:
>>>>> On 08/07/2014 07:05 AM, Christian Lamparter wrote:
>>>>>> Or: for every 16 Bytes of payload there is one fpu context save and
>>>>>> restore... ouch!
>>>>>
>>>>> Any idea if it would work to put the fpu_begin/end a bit higher
>>>>> and do all those 16 byte chunks in a batch without messing with
>>>>> the FPU for each chunk?
>>>>
>>>> It sort of works - see sample feature patch for aesni-intel-glue 
>>>> (taken from 3.16-wl). Older kernels (like 3.15, 3.14) need:
>>>> "crypto: allow blkcipher walks over AEAD data" [0] (and maybe more).
>>>>
>>>> The FPU save/restore overhead should be gone. Also, if the aesni
>>>> instructions can't be used, the implementation will fall back
>>>> to the original ccm(aes) code. Calculating the MAC is still much
>>>> more expensive than the payload encryption or decryption. However,
>>>> I can't see a way of making this more efficient without rewriting
>>>> and combining the parts I took from crypto/ccm.c into an several, 
>>>> dedicated assembler functions.
>>>
>>> Without encryption, I see download rate of around 400 - 420Mbps.
>>>
>>> So, your patch looks like a good improvement to me, and I'll be
>>> happy to test further patches if you happen to do those assembler
>>> optimizations you talk about above.
>>
>> Maybe, that will depend on what the results for: "wpa2, *HW*-crypt,
>> download, udp" are.
> 
> I'll do that test sometime soon and post the results.

I ran that today, and I get about the same throughput with hw-crypt or
sw-crypt (350-355Mbps UDP download goodput).

I still see 400+Mbps with Open authentication.

So, maybe the bottleneck now is elsewhere...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

