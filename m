Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49006 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab0IXVdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 17:33:22 -0400
Message-ID: <4C9D191B.9090307@candelatech.com>
Date: Fri, 24 Sep 2010 14:33:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless] wireless:  Keep phy name consistent across module
 reloads.
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com>	 <1285362170.11036.1.camel@jlt3.sipsolutions.net>	 <4C9D13AC.4080308@candelatech.com>	 <1285363135.11036.7.camel@jlt3.sipsolutions.net>	 <4C9D1760.3040103@candelatech.com> <1285363861.11036.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285363861.11036.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2010 02:31 PM, Johannes Berg wrote:
> On Fri, 2010-09-24 at 14:25 -0700, Ben Greear wrote:
>
>>> Actually, right now it doesn't even allow you to use a "phy%d" name,
>>> which is because I don't want (sysfs, debugfs) errors coming from doing
>>> "iw phy0 set name phy1" and then plugging in a new device ... In doing
>>> that, I manage to avoid having to allocate two different numbers...
>>
>> I tried rename few months ago, to rename back to phy0, and it failed
>> for no obvious reason..so I just assumed rename didn't work at all.
>> Would you like a patch to print something in kernel logs when someone
>> tries to rename to phy%d?
>
> Well, if you want to work on getting an unused phy%d name this would be
> kinda pointless, no?
>
>>> I suppose it'd be possible to treat this more like interfaces. Want to
>>> also make it per net namespace? ;-)
>>
>> Probably best for all involved if I don't mess with namespaces right now,
>> but I'll be happy to work on (or test) a patch to find the first un-used phyX name,
>> if that's what you mean.
>
> I think that'd be OK, even if maybe at this point a little unexpected?

I'll give it a try right quick.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

