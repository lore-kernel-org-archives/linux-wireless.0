Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60258 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0JKSuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:50:23 -0400
Message-ID: <4CB35C6C.4060606@candelatech.com>
Date: Mon, 11 Oct 2010 11:50:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless:  Print wiphy name in sysfs.
References: <1286818139-1746-1-git-send-email-greearb@candelatech.com>	 <1286819927.3634.79.camel@jlt3.sipsolutions.net>	 <4CB351B2.4070803@candelatech.com>	 <1286820600.3634.80.camel@jlt3.sipsolutions.net>	 <4CB355EA.5050902@candelatech.com> <1286822565.3634.83.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286822565.3634.83.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 11:42 AM, Johannes Berg wrote:
> On Mon, 2010-10-11 at 11:22 -0700, Ben Greear wrote:
>
>>> basename $(readlink /sys/class/net/wlan0/phy80211)
>>
>> It looks like that could work, but it seems a lot easier to probe
>> network devices via normal manner, and then check if I can just
>> open and read /sys/class/net/[dev-name]/phy80211/name
>>
>> I can do that easily from within a C/C++ program, where as
>> doing system calls and grabbing standard output is more of
>> a pain (and more overhead).
>>
>> But, if you don't want to add my patch, it's not a big deal.
>
> I don't really mind, it just didn't seem necessary. FWIW, readlink(2) is
> also a system call that your C program could use, but if you want the
> patch instead I guess that's fine.

I think it offers a bit of use at a small cost, but certainly
it's not a critical improvement.

If the maintainer picks it up, I'll happily use it..if not,
I can carry it in my own tree or use readdir or something.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

