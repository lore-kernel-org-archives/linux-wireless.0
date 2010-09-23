Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39602 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab0IWQ5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 12:57:43 -0400
Message-ID: <4C9B8703.7070907@candelatech.com>
Date: Thu, 23 Sep 2010 09:57:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support receiving data frames on multiple
 vifs.
References: <1285018776-21795-1-git-send-email-greearb@candelatech.com>	 <1285051641.3710.8.camel@jlt3.sipsolutions.net>	 <4C9B5CE4.9040806@candelatech.com> <1285250792.3770.110.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285250792.3770.110.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2010 07:06 AM, Johannes Berg wrote:
> On Thu, 2010-09-23 at 06:57 -0700, Ben Greear wrote:
>> On 09/20/2010 11:47 PM, Johannes Berg wrote:
>>> On Mon, 2010-09-20 at 14:39 -0700, greearb@candelatech.com wrote:
>>>> From: Ben Greear<greearb@candelatech.com>
>>>>
>>>> When using multiple STA interfaces on the same radio, some
>>>> data packets need to be received on all interfaces
>>>> (broadcast, for instance).
>>>>
>>>> Make the STA loop look similar to the mgt-data loop.
>>>>
>>>> Also, add logic to check RX_FLAG_MMIC_ERROR for last
>>>> interface in mgt-data loop.
>>>>
>>>> This needs review.
>>>
>>> Looks fine to me, I think.
>>
>> Does this need any more work before being accepted upstream?
>
> Well, I personally would've tried to reduce the code duplication between
> the two loops, but right now I'm not sure I see how to.

I could move some of the rx setup code into prepare_for_handlers,
but not sure how much that would help readability.

In my opinion, that would be a good candidate for a followup
patch instead of adding that to this patch, though.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

