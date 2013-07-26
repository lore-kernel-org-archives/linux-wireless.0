Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34197 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3GZP1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 11:27:32 -0400
Message-ID: <51F29560.3080605@candelatech.com> (sfid-20130726_172738_931197_BE581283)
Date: Fri, 26 Jul 2013 08:27:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [WT PATCH 4/6] mac80211: Add per-sdata station hash, and sdata
 hash.
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>   <1372546738-25827-4-git-send-email-greearb@candelatech.com>   (sfid-20130630_005944_514926_D21D8724) <1373532936.8201.5.camel@jlt4.sipsolutions.net>  <51DECF5B.7040002@candelatech.com> <1374828780.8248.24.camel@jlt4.sipsolutions.net>
In-Reply-To: <1374828780.8248.24.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/26/2013 01:53 AM, Johannes Berg wrote:
> On Thu, 2013-07-11 at 08:29 -0700, Ben Greear wrote:
>
>>> I also don't like maintaining two separate hash tables and all that.
>>>
>>> I'd reconsider if you actually remove the hash entirely, but that'll be
>>> tricky to walk the station list and will quite possibly make the RX path
>>> there more expensive?
>>
>> Remove local->sta_hash ?
>
> To be honest, I'm undecided. Yes, I was thinking that, but I also think
> having a huge hashtable like that for each virtual interface is way
> overkill, in particular for station interfaces that usually have one
> peer (the AP) and maybe a few TDLS peers. Or P2P-Device interfaces that
> have no peers at all ...
>
> I don't see a good way to improve the hash either, since we don't always
> (e.g. in RX path) have the interface address.
>
> The basic problem really is that the hash now is designed to work well
> for more regular use cases than yours, where you talk to any number of
> different stations but degrades really badly when you talk only to a
> single one many times. That use case is really special, and I don't want
> to 'fix' that in a way that would make the other use case significantly
> worse in memory consumption or CPU utilisation.

I could make the hash size configurable I suppose, or just make it always
be small for stations and larger for AP interfaces.  That should
mitigate the memory usage issues.  The sdata hash in the wiphy can
remain big, but there are rarely more than a few wiphy in a system, so
I think the cost is low for that.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

