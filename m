Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36086 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdFWM1N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 08:27:13 -0400
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170621235022.25362-1-johannes@sipsolutions.net>
 <20170621235022.25362-3-johannes@sipsolutions.net>
 <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
 <1498112650.2246.1.camel@sipsolutions.net>
 <3735eb1d-89b5-b4ad-6657-d0d4e9642574@candelatech.com>
 <1498209700.2595.2.camel@sipsolutions.net>
Cc: nbd@nbd.name
From: Ben Greear <greearb@candelatech.com>
Message-ID: <89353e7a-5c61-eba3-fe34-0e7eadf7588e@candelatech.com> (sfid-20170623_142716_754235_75C67B9D)
Date: Fri, 23 Jun 2017 05:27:12 -0700
MIME-Version: 1.0
In-Reply-To: <1498209700.2595.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/23/2017 02:21 AM, Johannes Berg wrote:
> On Thu, 2017-06-22 at 07:43 -0700, Ben Greear wrote:
>>
>> On 06/21/2017 11:24 PM, Johannes Berg wrote:
>>> On Wed, 2017-06-21 at 17:02 -0700, Ben Greear wrote:
>>>> I think a comment for the above code block would be warranted
>>>> (and
>>>> for ath10k as well).
>>>>
>>>> I guess this is the part about dequeueing the frames immediately?
>>>
>>> Yeah, I figured it was pretty obvious, but I can add a comment :)
>>
>> It is fairly obvious today, but 6 months from now when someone tries
>> yet again to figure out WTF is ath10k doing, it will be one more
>> piece of mystery code!
>
> :-)
>
> Turns out this won't work well, I had misunderstood the TXQ code.
>
> We do need queueing for these frames, we just do it on the pending
> thing in mac80211... that's rather awful, and means we have to
> integrate much deeper with ath9k/ath10k to make any progress here.

I don't understand the code well enough to know if this matters or not,
but the ath10k wave-2 stuff has some txq prefetch logic in the firmware
(and support in the driver).  But, it doesn't prefetch for the mgt tid
as far as I can tell.  It somehow all mostly works anyway, but possibly this
would have some effect on your changes.  wave-1 (QCA 9880, etc) doesn't
do txq prefetch at all.  Any tricky changes to this logic would need to
test with both chipsets.

There are also NAPI deadlocks possible when firmware crashes at a bad time.
I am not sure there is anyone left working on ath10k with knowledge and time
to really dig into this in detail.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
