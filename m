Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41402 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0INOsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 10:48:30 -0400
Message-ID: <4C8F8B0D.8050902@candelatech.com>
Date: Tue, 14 Sep 2010 07:47:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [virtual-sta 1/3] mac80211:  Add more general interface iterator.
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com> <1284469166.3704.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284469166.3704.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 05:59 AM, Johannes Berg wrote:
> On Fri, 2010-09-10 at 15:04 -0700, greearb@candelatech.com wrote:
>
>> This allows callers to specify whether they want all
>> or just active interfaces,
>
> I thought about this, and I don't want to allow drivers to get at
> inactive interfaces. And with that, I don't think there's a need to
> restructure the code here. Also, since what you wanted wasn't the count
> but the STA interface count, you need your own iterator function anyway,
> no?

I'll see if I can get ath9k to use the normal iterator.  I didn't need my
own iterator, because I could just pass in NULL for iterator and pass
active_only as false.

I think you should consider returning the count for the number of times the
iterator was called because it's simple code, and it would save the same logic
in each driver's iterator methods (or at least, ath9k).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
