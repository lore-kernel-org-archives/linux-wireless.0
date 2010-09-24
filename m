Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40244 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660Ab0IXVKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 17:10:15 -0400
Message-ID: <4C9D13AC.4080308@candelatech.com>
Date: Fri, 24 Sep 2010 14:10:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless] wireless:  Keep phy name consistent across module
 reloads.
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com> <1285362170.11036.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285362170.11036.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2010 02:02 PM, Johannes Berg wrote:
> On Tue, 2010-09-21 at 16:57 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> It adds needless pain to user-space scripts to change the name
>> of the phy on each module reload.  Instead, find the first
>> index.
>
> Crap, I clearly missed this patch, John, please revert this.
>
> We cannot do this because otherwise operations you attempt to do one one
> PHY will race with re-creating of the same phy index. For the same
> reason, interface indexes aren't reused for netdevs.
>
> If this bothers you so much, you can easily write a udev rule that
> renames all your phys to "myphy" or whatever.

Sorry about that.

Would a similar patch be acceptable that just set the name to the first
available phyX, but left the index to increment monotomically as it does
now be OK?

I'd really like to not have to deal with udev if possible!

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

