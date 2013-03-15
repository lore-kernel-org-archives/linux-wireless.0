Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56561 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3COD0l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 23:26:41 -0400
Message-ID: <514294ED.7040909@candelatech.com> (sfid-20130315_042649_372677_B07339CB)
Date: Thu, 14 Mar 2013 20:26:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Optimizing performance for lots of virtual stations.
References: <5142074C.1060708@candelatech.com> <51425963.2000904@openwrt.org> <51425AB1.9090603@candelatech.com> <51427CFF.1020105@openwrt.org>
In-Reply-To: <51427CFF.1020105@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/14/2013 06:44 PM, Felix Fietkau wrote:
> On 2013-03-15 12:18 AM, Ben Greear wrote:
>> On 03/14/2013 04:12 PM, Felix Fietkau wrote:
>>> On 2013-03-14 6:22 PM, Ben Greear wrote:
>>>> I've been doing some performance testing, and having lots of
>>>> stations causes quite a drag:  total throughput with 1 station: 250Mbps TCP throughput,
>>>> total with 50 stations:  225 Mbps, and with 128 stations: 20-40Mbps (it varies a lot..not so sure why).
>>>>
>>>> I poked around in the rx logic and it seems the rx-data path is fairly
>>>> clean for data packets.  But, from what I can tell, each beacon is going
>>>> to cause an skb_copy() call and a queued work-item for each station interface,
>>>> and there are going to be lots of beacons per second in most scenarios...
>>>>
>>>> I was wondering if this could be optimized a bit to special case beacons
>>>> and not make a new copy (or possibly move some of the beacon handling
>>>> logic up to the radio object and out of the sdata).
>>>>
>>>> And of course, it could be there are more important optimizations...I'm curious
>>>> if anyone is aware of any other code that should be optimized to have better
>>>> performance with lots of stations...
>>> How about doing some profiling with lots of stations - that should
>>> hopefully reveal where the real bottleneck is.
>>> By the way, with that many stations and low throughput, is the CPU usage
>>> on your system significantly higher, or could it just be some extra
>>> latency introduced somewhere else in the code?
>>
>> CPU load is fairly high, but doesn't seem to just be CPU bound.  Maybe
>> lots and lots of work items all piled up or something like that...
>>
>> I'll work on some profiling as soon as I get a chance.
>>
>> I'm suspicious that the the management frame handling will
>> need some optimization though..I think it basically copies
>> the skb and broadcasts all mgt frames to all running stations....
> Here's another thing that might be negatively affecting your tests. The
> driver has a 128-packet buffer limit per hardware queue for aggregation.
> With too many stations, they will be competing for a very limited number
> of buffers, making aggregation a lot less effective.
> Increasing the number of buffers is a bad idea here, as it will harm
> environments with fewer stations due to bufferbloat.
>
> What's required to fix this properly is better queue management,
> something that will require some bigger changes to the ath9k tx path and
> some mac80211 changes as well. It's on my TODO list, but I don't know
> when I'll get around to implementing it.

I thought of that as well, but I saw something that made me think rx
might be a big part of it as well:

With 50 stations each trying to transmit a 5Mbps TCP stream, I get around 210-220Mbps
of total TCP throughput.  But, if I simply add another 78 associated stations and do
not run any traffic on them, throughput drops to about 80Mbps.

But, when I add traffic on those extra 78 stations, total throughput does drop
down to around 20-40Mbps, so that part could easily be tx aggregation issues...

Would the tx-bytes-all / xmit-ampdus ratio give an idea of how well aggregation
is working?  (As reported by the ath9k xmit debugfs file).

I think I'll be better at trying to optimize the rx path than the tx path,
as I get endlessly confused when trying to figure out the ath9k xmit path,
but I can almost start to understand the mac80211 rx path after a while :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

