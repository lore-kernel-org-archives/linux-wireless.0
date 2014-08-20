Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51320 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaHTVEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 17:04:39 -0400
Message-ID: <53F50D63.2040500@candelatech.com> (sfid-20140820_230443_224909_9FD6C257)
Date: Wed, 20 Aug 2014 14:04:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
References: <5338F1B8.5040305@candelatech.com> <53ECED3E.4080907@candelatech.com> <53F394FF.7050209@candelatech.com> <1478683.D306USvBEk@debian64>
In-Reply-To: <1478683.D306USvBEk@debian64>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/20/2014 01:47 PM, Christian Lamparter wrote:
> On Tuesday, August 19, 2014 11:18:39 AM Ben Greear wrote:
>> On 08/14/2014 10:09 AM, Ben Greear wrote:
>>> On 08/14/2014 05:39 AM, Christian Lamparter wrote:
>>>> On Tuesday, August 12, 2014 11:34:59 AM Ben Greear wrote:
>>>>>
>>>>> Without encryption, I see download rate of around 400 - 420Mbps.
>>>>>
>>>>> So, your patch looks like a good improvement to me, and I'll be
>>>>> happy to test further patches if you happen to do those assembler
>>>>> optimizations you talk about above.
>>>>
>>>> Maybe, that will depend on what the results for: "wpa2, *HW*-crypt,
>>>> download, udp" are.
>>>
>>> I'll do that test sometime soon and post the results.
>>
>> I ran that today, and I get about the same throughput with hw-crypt or
>> sw-crypt (350-355Mbps UDP download goodput).
>>
>> I still see 400+Mbps with Open authentication.
>>
>> So, maybe the bottleneck now is elsewhere...
> Can you rule out that the "udp generator" (either the application
> or the hardware) is now the bottleneck for this test? [Does the
> datasheet mention the throughput of the hw-crypto? Or do you know
> someone at QCA which can tell you if the hardware is filling up
> the aggregates with additional padding to meet the MPDU start
> spacing]

It is unlikely the UDP generator acts differently for encrypted v/s open
traffic, and since the NIC is supposed to do offload in hw-crypt mode,
the rest of the stack should be similar as well.

Other ath10k users report similar open & wpa2 throughput, so
it may be something in my kernel or firmware or configs.
I will run some additional tests when I get a chance...

> I'll look into the assembler implementation of aes-ccm. But I'm
> afraid that this won't increase the throughput (and only decrease
> the load on the CPU a bit).

I think you are right, and probably it is not worth much effort at
this point, at least as far as my setup is concerned.

> Also, just for fun: what goodput can you achieve over gbit ethernet?
> [Because ethernet is also affected by filtering, bridging,
> pcie-throughput... if it is setup in the same way so you could
> rule out that iptables, its friends or the pcie-port is a
> bottleneck].

Since Open runs faster, it shouldn't be pci-e bus or CPU bottleneck.
This class of system can generally sustain near 1 Gbps throughput
on wired Ethernet.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
