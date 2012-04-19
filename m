Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770Ab2DSEic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 00:38:32 -0400
Message-ID: <4F8F96CD.7060501@sipsolutions.net> (sfid-20120419_063835_162146_C9A5FADD)
Date: Wed, 18 Apr 2012 21:38:37 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/6] mac80211: Support getting sta_info stats via ethtool.
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>   <1334684807-14026-3-git-send-email-greearb@candelatech.com>   (sfid-20120417_194716_243783_5644375D) <1334713070.3725.14.camel@jlt3.sipsolutions.net>  <4F8E3905.70900@candelatech.com> <1334721645.3672.2.camel@jlt3.sipsolutions.net> <4F8EEB6C.1030605@candelatech.com> <4F8F42B0.8010306@sipsolutions.net> <4F8F4734.7050201@candelatech.com>
In-Reply-To: <4F8F4734.7050201@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 3:59 PM, Ben Greear wrote:
> On 04/18/2012 03:39 PM, Johannes Berg wrote:
>> On 4/18/2012 9:27 AM, Ben Greear wrote:
>>>> Oh, right, it's adding, I missed that. But is that really useful?
>>>
>>> It provides a summary for AP, and precise stats for managed station
>>> mode (excepting TDLS where it may return sums, it seems).
>>
>> I just have a feeling that people will rely on it working for managed
>> mode, and will forget about TDLS since it's uncommon now ... so I
>> really don't think this
>> will work well with people's (even yours!) expectations.
>
> Ok, how about for managed mode, I will find the first non-TDLS station
> matching the netdev, assign the values, and then quit looking for more
> stations.
>
> For all other modes, logic stays the same as it is now
> (add all stations' stats together as long as the station belongs
> to the netdev)?

Seems OK, but I'd implement it using the BSSID & getting the station 
rather than iterating? Though if you want the iteration for other 
interface types then I guess it'll be easier to just do it that way.

I just think it's bad to have relatively rare things like TDLS influence 
APIs that people might come to rely on.

johannes
