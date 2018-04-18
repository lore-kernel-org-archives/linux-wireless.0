Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47368 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbeDRVvj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 17:51:39 -0400
Subject: Re: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
To: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
References: <1524016176-3881-1-git-send-email-greearb@candelatech.com>
 <1524086817.3024.9.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <f43d7ee4-7f27-b145-125e-32dbc31a27f1@candelatech.com> (sfid-20180418_235146_373828_D450586E)
Date: Wed, 18 Apr 2018 14:51:36 -0700
MIME-Version: 1.0
In-Reply-To: <1524086817.3024.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/18/2018 02:26 PM, Johannes Berg wrote:
> On Tue, 2018-04-17 at 18:49 -0700, greearb@candelatech.com wrote:
>>
>> + * @get_ethtool_stats2: Return extended statistics about the device.
>> + *	This is only useful if the device maintains statistics not
>> + *	included in &struct rtnl_link_stats64.
>> + *      Takes a flags argument:  0 means all (same as get_ethtool_stats),
>> + *      0x1 (ETHTOOL_GS2_SKIP_FW) means skip firmware stats.
>> + *      Other flags are reserved for now.
>
> It'd be pretty hard to know which flags are firmware stats?

Yes, it is, but ethtool stats are difficult to understand in a generic
manner anyway, so someone using them is already likely aware of low-level
details of the driver(s) they are using.

In my case, I have lots of virtual stations (or APs), and I want stats
for them as well as for the 'radio', so I would probe the first vdev with
flags of 'skip-none' to get all stats, including radio (firmware) stats.

And then the rest I would just probe the non-firmware stats.

To be honest, I was slightly amused that anyone expressed interest in
this patch originally, but maybe other people have similar use case
and/or drivers with slow-to-acquire stats.

> Anyway, there's no way I'm going to take this patch, so you need to
> float it on netdev first (best CC us here) and get it applied there
> before we can do anything on the wifi side.

I posted the patches to netdev, ath10k and linux-wireless.  If I had only
posted them individually to different lists I figure I'd be hearing about how
the netdev patch is useless because it has no driver support, etc.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
