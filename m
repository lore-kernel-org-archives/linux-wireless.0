Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53126 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760802Ab3DCNhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 09:37:24 -0400
Message-ID: <515C308F.7030506@candelatech.com> (sfid-20130403_153727_786583_8DBF9DFC)
Date: Wed, 03 Apr 2013 06:37:19 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  Hashing by VIF addr for rx of data packets.
References: <515B6D98.4060303@candelatech.com>  (sfid-20130403_014533_732333_9EEA2246) <1364993169.8351.34.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364993169.8351.34.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 05:46 AM, Johannes Berg wrote:
> On Tue, 2013-04-02 at 16:45 -0700, Ben Greear wrote:
>> I notice that the rx logic currently walks through all stations when a NIC receives
>> a packet.
>>
>> With the attached patch, total TCP download throughput goes from 70Mbps to 190Mbps on
>> my test system (Atom 1.6Ghz) with 50 station VIFs receiving TCP data streams.
>>
>> The basic idea is to hash on the VIF addr (ie, what you see in 'ifconfig wlan0' as MAC
>> address), and then look up stations using the hdr->addr1 in the rx logic.
>>
>> The attached patch probably breaks monitor interfaces and other VIFs other than AP and
>> STA.  It also changes the behaviour of PROMISC, but I'm not sure that is bad (is
>> the old behaviour needed for anything useful?)
>>
>> I'm thinking to store a count of all VIF types on a radio, and make
>> this hash code only be enabled when only STA and AP exist.  Maybe later optimize
>> so we can quickly find monitor or other VIF types to handle them properly.
>>
>> Comments and suggestions are welcome.
>
> Hmmm. I'm not really convinced this will make sense upstream. I'm kinda
> fine with the single-station cache, but maintaining a whole other hash
> table seems too much overhead for every use case but yours.

Yeah, aside from multiple stations, I'm not sure it helps anything.  It would
require a different scheme to help with multiple VAP I think, and I'm not
sure there are any other multi-vif use cases out there...

>> +		/* If we have only station and AP interfaces, then hash on
>> +		 * the destination MAC (ie, local sdata MAC).  Could add other
>> +		 * device types as well, perhaps.  This changes 'promisc' behaviour,
>> +		 * but not sure that is a bad thing.
>> +		 */
>> +		if (!is_multicast_ether_addr(hdr->addr1)) {
>> +			sta = sta_info_get_by_vif(local, hdr->addr1);
>
> AFAICT, this is also wrong for TDLS and other cases where we might
> receive a frame that's not from the AP, even if it's only by accident or
> from an attacker.

I think patch is probably wrong for any VIF that can be associated with more than
one station (such as APs).  I'm going to re-work the vhash to only include
Station VIFS and see how that works for my test case.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

