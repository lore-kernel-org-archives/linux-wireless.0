Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47789 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaHNRJV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 13:09:21 -0400
Message-ID: <53ECED3E.4080907@candelatech.com> (sfid-20140814_190932_932766_0530C999)
Date: Thu, 14 Aug 2014 10:09:18 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <1518134.xFh23iA8q1@blech> <53EA5E53.9010704@candelatech.com> <8289144.MKHmP0uSFO@debian64>
In-Reply-To: <8289144.MKHmP0uSFO@debian64>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2014 05:39 AM, Christian Lamparter wrote:
> On Tuesday, August 12, 2014 11:34:59 AM Ben Greear wrote:
>> On 08/10/2014 06:44 AM, Christian Lamparter wrote:
>>> On Thursday, August 07, 2014 10:45:01 AM Ben Greear wrote:
>>>> On 08/07/2014 07:05 AM, Christian Lamparter wrote:
>>>>> Or: for every 16 Bytes of payload there is one fpu context save and
>>>>> restore... ouch!
>>>>
>>>> Any idea if it would work to put the fpu_begin/end a bit higher
>>>> and do all those 16 byte chunks in a batch without messing with
>>>> the FPU for each chunk?
>>>
>>> It sort of works - see sample feature patch for aesni-intel-glue 
>>> (taken from 3.16-wl). Older kernels (like 3.15, 3.14) need:
>>> "crypto: allow blkcipher walks over AEAD data" [0] (and maybe more).
>>>
>>> The FPU save/restore overhead should be gone. Also, if the aesni
>>> instructions can't be used, the implementation will fall back
>>> to the original ccm(aes) code. Calculating the MAC is still much
>>> more expensive than the payload encryption or decryption. However,
>>> I can't see a way of making this more efficient without rewriting
>>> and combining the parts I took from crypto/ccm.c into an several, 
>>> dedicated assembler functions.
>>
>> Without encryption, I see download rate of around 400 - 420Mbps.
>>
>> So, your patch looks like a good improvement to me, and I'll be
>> happy to test further patches if you happen to do those assembler
>> optimizations you talk about above.
> 
> Maybe, that will depend on what the results for: "wpa2, *HW*-crypt,
> download, udp" are.

I'll do that test sometime soon and post the results.

>> Let me know if you would like more/different performance
>> stats. 
> 
> There's a test bench tool (tcrypt) to measure the performance 
> of any cipher. It would be interesting to know what the 
> performance/throughput it can produce without the overhead
> of any application. [Yep, I'm making a small patch to test that,
> but not before Saturday next week].
>   
>> Here is perf top of open authentication, download, UDP:
>>
>> Using WPA2, sw-crypt, download, UDP:
>>
>> Samples: 52K of event 'cycles', Event count (approx.): 13162827574
>>  24.78%  btserver              [.] 0x00000000000c598c
> Is btserver your "udp download" test application? What does it do, as
> it is accounting for nearly 25%?

btserver is our traffic generator.  In this case, it is mostly just
receiving UDP frames using non-blocking IO (using recvmmsg, in this case),
but it does a fair bit of stats gathering and
such.  It typically compares well with iperf as far as throughput goes,
but I'm sure it uses at least a bit more CPU as compared to iperf.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

