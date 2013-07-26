Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42859 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab3GZPWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 11:22:42 -0400
Message-ID: <51F29439.3050607@candelatech.com> (sfid-20130726_172248_453630_BC74C453)
Date: Fri, 26 Jul 2013 08:22:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [WT PATCH 4/6] mac80211: Add per-sdata station hash, and sdata
 hash.
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>   <1372546738-25827-4-git-send-email-greearb@candelatech.com>   (sfid-20130630_005944_514926_D21D8724) <1373532936.8201.5.camel@jlt4.sipsolutions.net>  <51DECF5B.7040002@candelatech.com> <1374828780.8248.24.camel@jlt4.sipsolutions.net> <51F247C1.3090702@openwrt.org>
In-Reply-To: <51F247C1.3090702@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2013 02:56 AM, Felix Fietkau wrote:
> On 2013-07-26 10:53 AM, Johannes Berg wrote:
>> On Thu, 2013-07-11 at 08:29 -0700, Ben Greear wrote:
>>
>>>> I also don't like maintaining two separate hash tables and all that.
>>>>
>>>> I'd reconsider if you actually remove the hash entirely, but that'll be
>>>> tricky to walk the station list and will quite possibly make the RX path
>>>> there more expensive?
>>>
>>> Remove local->sta_hash ?
>>
>> To be honest, I'm undecided. Yes, I was thinking that, but I also think
>> having a huge hashtable like that for each virtual interface is way
>> overkill, in particular for station interfaces that usually have one
>> peer (the AP) and maybe a few TDLS peers. Or P2P-Device interfaces that
>> have no peers at all ...
>>
>> I don't see a good way to improve the hash either, since we don't always
>> (e.g. in RX path) have the interface address.
> How about mixing in the interface address into the hash. Theoretically
> you should always have that available, even in the rx path. Multicast
> data packets contain the BSSID, so you can get the address from there.
> You just need to be careful about checking the DS bits to figure out
> which address to use ;)
> I think this is a much better solution than duplicating the hash, or
> moving it into sdata entirely.

I think I could probably get rid of the big global per wiphy hash and
use the per-wiphy sdata-hash and per-sdata station hashes.

To me, that is cleanest because it gives a nice ownership relationship
between wiphy, sdata, and stations.

For what it's worth, my hashing scheme has been working well on highly
loaded APs and Station machines.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

