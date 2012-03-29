Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41485 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab2C2QJd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 12:09:33 -0400
Message-ID: <4F748937.1070203@candelatech.com> (sfid-20120329_180943_351472_6B3F1AF6)
Date: Thu, 29 Mar 2012 09:09:27 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bryan Phillippe <Bryan.Phillippe@watchguard.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
References: <4F57B7E6.1050103@candelatech.com>    <D6CE340A-7CE4-42DA-B1C3-4137C1D13BFF@watchguard.com>    <4F735EF5.3010708@candelatech.com>   <1332961193.3479.40.camel@jlt3.sipsolutions.net>   <4F73620D.507@candelatech.com>  <1332962004.3479.42.camel@jlt3.sipsolutions.net>  <4F736A5A.4030408@candelatech.com> <1333003130.3611.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1333003130.3611.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2012 11:38 PM, Johannes Berg wrote:
> On Wed, 2012-03-28 at 12:45 -0700, Ben Greear wrote:
>> On 03/28/2012 12:13 PM, Johannes Berg wrote:
>>> On Wed, 2012-03-28 at 12:10 -0700, Ben Greear wrote:
>>>> On 03/28/2012 11:59 AM, Johannes Berg wrote:
>>
>>>>> Hm. Maybe this is the problem?
>>>>>
>>>>> http://p.sipsolutions.net/d432de678ae3ff17.txt
>>>>
>>>> I don't see any code that matches that in 3.3.0 (nothing with nl80211_start_ap, for instance)
>>>
>>> ah, well, it's set_beacon there or so
>>>
>>> johannes
>>
>>
>> I tried this patch, but it still spews (see below)
>
>> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:12 check_sdata_in_driver+0x26/0x2b [mac80211]()
>
>>    [<c04263d1>] warn_slowpath_common+0x65/0x7a
>>    [<f96a28d1>] ? check_sdata_in_driver+0x26/0x2b [mac80211]
>>    [<c042644a>] warn_slowpath_fmt+0x26/0x2a
>>    [<f96a28d1>] check_sdata_in_driver+0x26/0x2b [mac80211]
>>    [<f96a3438>] ieee80211_set_txq_params+0x97/0xec [mac80211]
>
> but now it's coming from elsewhere, see this patch?
>
> http://p.sipsolutions.net/b8506c9d7ce8a119.txt

That fixes the problem for me, or at least the easily-reproducible part.

I did have to modify the patch to work on 3.3.0 since it has no start_ap
and the beacon method is named a bit differently.

I'm going to apply this to my patch set and will let you know if
I see anything else strange.

Thanks!
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

