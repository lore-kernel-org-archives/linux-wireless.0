Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45040 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbeDSGid (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 02:38:33 -0400
Message-ID: <1524119910.3024.12.camel@sipsolutions.net> (sfid-20180419_083840_700659_AE9A2398)
Subject: Re: [PATCH 1/3] ethtool: Support ETHTOOL_GSTATS2 command.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Thu, 19 Apr 2018 08:38:30 +0200
In-Reply-To: <f43d7ee4-7f27-b145-125e-32dbc31a27f1@candelatech.com>
References: <1524016176-3881-1-git-send-email-greearb@candelatech.com>
         <1524086817.3024.9.camel@sipsolutions.net>
         <f43d7ee4-7f27-b145-125e-32dbc31a27f1@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-04-18 at 14:51 -0700, Ben Greear wrote:

> > It'd be pretty hard to know which flags are firmware stats?
> 
> Yes, it is, but ethtool stats are difficult to understand in a generic
> manner anyway, so someone using them is already likely aware of low-level
> details of the driver(s) they are using.

Right. Come to think of it though,

> + * @get_ethtool_stats2: Return extended statistics about the device.
> + *     This is only useful if the device maintains statistics not
> + *     included in &struct rtnl_link_stats64.
> + *      Takes a flags argument:  0 means all (same as get_ethtool_stats),
> + *      0x1 (ETHTOOL_GS2_SKIP_FW) means skip firmware stats.
> + *      Other flags are reserved for now.
> + *      Same number of stats will be returned, but some of them might
> + *      not be as accurate/refreshed.  This is to allow not querying
> + *      firmware or other expensive-to-read stats, for instance.

"skip" vs. "don't refresh" is a bit ambiguous - I'd argue better to
either really skip and not return the non-refreshed ones (also helps
with the identifying), or rename the flag.

Also, wrt. the rest of the patch, I'd argue that it'd be worthwhile to
write the spatch and just add the flags argument to "get_ethtool_stats"
instead of adding a separate method - internally to the kernel it's not
that hard to change.

> I posted the patches to netdev, ath10k and linux-wireless.  If I had only
> posted them individually to different lists I figure I'd be hearing about how
> the netdev patch is useless because it has no driver support, etc.

Sure. I missed netdev, perhaps because it was in To, or more likely
because I was too sleepy. Sorry for the noise.

johannes
