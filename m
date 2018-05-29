Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2HcF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:32:05 -0400
Subject: Re: [RFC] mac80211: add stop/start logic for software TXQs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgens?= =?UTF-8?Q?en?=
        <toke@toke.dk>
References: <1526672192-3873-1-git-send-email-mpubbise@codeaurora.org>
 <1527068760.3759.13.camel@sipsolutions.net>
 <af87d35a-f5d8-0766-b650-0ba3e941e839@codeaurora.org>
 <1527494784.8221.1.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <0d71d9f0-42cf-ce73-0c44-bbbe6b32b275@codeaurora.org> (sfid-20180529_093252_557034_475F7AF4)
Date: Tue, 29 May 2018 13:02:01 +0530
MIME-Version: 1.0
In-Reply-To: <1527494784.8221.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 5/28/2018 1:36 PM, Johannes Berg wrote:
> On Mon, 2018-05-28 at 12:49 +0530, Manikanta Pubbisetty wrote:
>>> This doesn't seem right, all the logic that clears the TXQ_STOP etc.
>>> still needs to be invoked, otherwise your TXQ will get stuck completely
>>> since you'll never run this code again.
>> If the queues are blocked more than the block ack timeout then the
>> traffic should be sent only in the next BA session.
>> I am not really sure whether the queues will be blocked more than the
>> block ack timeout value unless the queues are stopped because of
>> multiple reasons.
>> In any case, traffic will be pushed out in subsequent BA sessions, no?
> I'm not really sure what you're saying, but it sounds almost like you're
> confusing a "BA session" with a single A-MPDU? The session will get
> stuck if you do the code this way, I think.

Okay.

>>> Also, you have the same problem as above - you never re-run this code so
>>>    you'd get stuck completely.
>> I didn't get your point here. By the time the queues gets started again,
>> there could be possibility that the station might have been back to
>> sleep. In this case, it is better not to send the traffic, no?
>> Anyways, station would receive the traffic in the next cycle when it is
>> out of sleep. Considering codel logic, there could be frame drops
>> though; maybe I am missing something?
> But this is still the old code before cycling, so you never get here
> during the TX cycle you're thinking of?

I did not understand your question fully ;-)
But then, as discussed earlier, it is best to mark the queues on which 
driver attempted to dequeue and then release the packets once queues are 
woken up.

Thanks,
Manikanta
