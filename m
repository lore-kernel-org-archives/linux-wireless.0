Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46057 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab3FSOWK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 10:22:10 -0400
Message-ID: <51C1BE8D.4020307@candelatech.com> (sfid-20130619_162215_159815_92AB5DC9)
Date: Wed, 19 Jun 2013 07:22:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] wireless:  Add memory usage debugging.
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>  (sfid-20130619_000356_212228_4AEA7C87) <1371635381.8349.9.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371635381.8349.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 02:49 AM, Johannes Berg wrote:
> On Tue, 2013-06-18 at 15:03 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The bss objects are reference counted, and the ies
>> are also tricky to keep track of.  Add option to
>> track allocation and freeing of the ies and bss objects,
>> and add debugfs files to show the current objects.
>
> I'm not really sure this is worth it -- you found the bug with
> kmemleak() after all. Having very specific things for all of this
> doesn't really seem worth it.

kmemleak didn't show the bss leaking though, so I spent several days
thinking ies pointers were being corrupted somehow.  I think the code
is not that intrusive, and since drivers also take bss refs, the problems
could come back in the future.

I didn't actually audit the drivers since I am not using that hardware,
by the way.

> Either way though, I can't apply the patches since they won't apply. I
> realize that you're working on 3.9, but you're going to have to send me
> patches I can apply to one of my trees (and right now, not really
> mac80211 but mac80211-next)

I started porting some patches to wireless-next yesterday..think that
would be a good enough tree to patch against?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

