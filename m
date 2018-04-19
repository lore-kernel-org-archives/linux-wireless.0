Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60660 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751228AbeDSPZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 11:25:50 -0400
Subject: Re: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
To: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
References: <1524016176-3881-1-git-send-email-greearb@candelatech.com>
 <1524086817.3024.9.camel@sipsolutions.net>
 <f43d7ee4-7f27-b145-125e-32dbc31a27f1@candelatech.com>
 <1524119910.3024.12.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <173c5f98-36bc-2e52-1e64-3a5f89008d46@candelatech.com> (sfid-20180419_172557_019152_CA21EA2B)
Date: Thu, 19 Apr 2018 08:25:41 -0700
MIME-Version: 1.0
In-Reply-To: <1524119910.3024.12.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/18/2018 11:38 PM, Johannes Berg wrote:
> On Wed, 2018-04-18 at 14:51 -0700, Ben Greear wrote:
>
>>> It'd be pretty hard to know which flags are firmware stats?
>>
>> Yes, it is, but ethtool stats are difficult to understand in a generic
>> manner anyway, so someone using them is already likely aware of low-level
>> details of the driver(s) they are using.
>
> Right. Come to think of it though,
>
>> + * @get_ethtool_stats2: Return extended statistics about the device.
>> + *     This is only useful if the device maintains statistics not
>> + *     included in &struct rtnl_link_stats64.
>> + *      Takes a flags argument:  0 means all (same as get_ethtool_stats),
>> + *      0x1 (ETHTOOL_GS2_SKIP_FW) means skip firmware stats.
>> + *      Other flags are reserved for now.
>> + *      Same number of stats will be returned, but some of them might
>> + *      not be as accurate/refreshed.  This is to allow not querying
>> + *      firmware or other expensive-to-read stats, for instance.
>
> "skip" vs. "don't refresh" is a bit ambiguous - I'd argue better to
> either really skip and not return the non-refreshed ones (also helps
> with the identifying), or rename the flag.

In order to efficiently parse lots of stats over and over again, I probe
the stat names once on startup, map them to the variable I am trying to use
(since different drivers may have different names for the same basic stat),
and then I store the stat index.

On subsequent stat reads, I just grab stats and go right to the index to
store the stat.

If the stats indexes change, that will complicate my logic quite a bit.

Maybe the flag could be called:  ETHTOOL_GS2_NO_REFRESH_FW ?

>
> Also, wrt. the rest of the patch, I'd argue that it'd be worthwhile to
> write the spatch and just add the flags argument to "get_ethtool_stats"
> instead of adding a separate method - internally to the kernel it's not
> that hard to change.

Maybe this could be in followup patches?  It's going to touch a lot of files,
and might be hell to get merged all at once, and I've never used spatch, so
just maybe someone else will volunteer that part :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
