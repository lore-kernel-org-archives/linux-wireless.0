Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53340 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab3CORuU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 13:50:20 -0400
Message-ID: <51435F59.7050403@candelatech.com> (sfid-20130315_185024_528645_1BF3260C)
Date: Fri, 15 Mar 2013 10:50:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Optimizing performance for lots of virtual stations.
References: <5142074C.1060708@candelatech.com> <51425963.2000904@openwrt.org> <51425AB1.9090603@candelatech.com> <51427CFF.1020105@openwrt.org> <514294ED.7040909@candelatech.com> <514356F3.4030408@candelatech.com>
In-Reply-To: <514356F3.4030408@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2013 10:14 AM, Ben Greear wrote:
> I probably should have done this first of course..but here is a 'perf top' on
> the station machine (50 TCP streams transmitting on each of 50 stations,
> and 78 associated-but-mostly-idle stations:
>
> Looks like sta_info_get would be a good place to start :)
>
>
> ---------------------------------------------------------------------------------------------------------------------------
>     PerfTop:    1890 irqs/sec  kernel:87.9%  exact:  0.0% [1000Hz cycles],  (all, 2 CPUs)
> ---------------------------------------------------------------------------------------------------------------------------
>
>               samples  pcnt function                        DSO
>               _______ _____ _______________________________ ______________
>
>               2261.00 20.8% sta_info_get                    [mac80211]

Ahh, crap...I see the problem.  The 'sta->addr' is the MAC of the VAP,
so if I have 100 stations all connected to the same AP, then the hashing
is worthless and just ends up being a linear search.

Probably not going to be fun to fix that!

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

