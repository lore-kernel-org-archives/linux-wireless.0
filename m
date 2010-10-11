Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45694 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab0JKSWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:22:37 -0400
Message-ID: <4CB355EA.5050902@candelatech.com>
Date: Mon, 11 Oct 2010 11:22:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Print wiphy name in sysfs.
References: <1286818139-1746-1-git-send-email-greearb@candelatech.com>	 <1286819927.3634.79.camel@jlt3.sipsolutions.net>	 <4CB351B2.4070803@candelatech.com> <1286820600.3634.80.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286820600.3634.80.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 11:10 AM, Johannes Berg wrote:
> On Mon, 2010-10-11 at 11:04 -0700, Ben Greear wrote:
>
>
>> I use this to determine the phy device for a particular network device:
>>
>> [root@dx-2u-ath5k lanforge]# cat /sys/class/net/wlan0/phy80211/name
>> wiphy0
>
> What's wrong with
>
> basename $(readlink /sys/class/net/wlan0/phy80211)

It looks like that could work, but it seems a lot easier to probe
network devices via normal manner, and then check if I can just
open and read /sys/class/net/[dev-name]/phy80211/name

I can do that easily from within a C/C++ program, where as
doing system calls and grabbing standard output is more of
a pain (and more overhead).

But, if you don't want to add my patch, it's not a big deal.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

