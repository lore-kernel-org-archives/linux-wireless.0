Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39544 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab2DRQ11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 12:27:27 -0400
Message-ID: <4F8EEB6C.1030605@candelatech.com> (sfid-20120418_182731_026960_E2405696)
Date: Wed, 18 Apr 2012 09:27:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/6] mac80211: Support getting sta_info stats via ethtool.
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>   <1334684807-14026-3-git-send-email-greearb@candelatech.com>   (sfid-20120417_194716_243783_5644375D) <1334713070.3725.14.camel@jlt3.sipsolutions.net>  <4F8E3905.70900@candelatech.com> <1334721645.3672.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334721645.3672.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 09:00 PM, Johannes Berg wrote:
> On Tue, 2012-04-17 at 20:46 -0700, Ben Greear wrote:
>
>>>> +	rcu_read_lock();
>>>> +	list_for_each_entry_rcu(sta,&local->sta_list, list) {
>>>
>>> This doesn't seem right -- shouldn't it look up the BSSID or something
>>> and only work on managed interfaces? What if there really are two
>>> stations on this interface -- then it'll just overwrite it and return a
>>> random station's data? That's useless.
>>
>> Well, its weird at least.
>>
>> But, if there are multiple stations, like for APs??, then it will
>> add the station's stats together.  Perhaps not horribly useful, but better
>> than nothing.
>
> Oh, right, it's adding, I missed that. But is that really useful?

It provides a summary for AP, and precise stats for managed station
mode (excepting TDLS where it may return sums, it seems).

I could just return all zeros for non managed
station interfaces, but I *have* to return some value, so it seems
little loss to just add the station stats together.

>> For managed interface, I *think* they don't have more than one station, right?
>
> You can't rely on it. Typically they will, but with TDLS there might be
> multiple.
>
>> And, as for the underlying driver stats and survey stats (in later patches),
>> that is only probed once.  I guess if you somehow had two
>> stations on different channels on the same network device,
>> the survey stats would be a bit dodgy, but it does return
>> the freq for the stats in question, so at least you know
>> what you are getting.
>
> A single netdev is always going to be on a single channel. Actually, I
> take that back, I think TDLS can work out of channel too, but we don't
> support that right now.

So, based on your response, a sum still seems most useful to me.  The ethtool
API gives no way to request any subset of stats, so all I can key off of
is the netdev.

I have some plans percolating to add some new ethtool API to get subsets
of stats, but that is likely a ways off, and of course it may not be
accepted regardless.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

