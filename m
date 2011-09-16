Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42312 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab1IPOLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 10:11:43 -0400
Message-ID: <4E73591A.8070309@qca.qualcomm.com> (sfid-20110916_161147_082882_69776A60)
Date: Fri, 16 Sep 2011 19:41:38 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: properly assign a boolean type
References: <1316180020-9982-1-git-send-email-mohammed@qca.qualcomm.com>	 <1316180237.4130.37.camel@jlt3.sipsolutions.net>	 <4E7354D8.40507@qca.qualcomm.com>	 <1316181679.4130.38.camel@jlt3.sipsolutions.net>	 <4E735701.9080609@qca.qualcomm.com> <1316182109.4130.39.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316182109.4130.39.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 September 2011 07:38 PM, Johannes Berg wrote:
> On Fri, 2011-09-16 at 19:32 +0530, mohammed wrote:
>> On Friday 16 September 2011 07:31 PM, Johannes Berg wrote:
>>> On Fri, 2011-09-16 at 19:23 +0530, mohammed wrote:
>>>
>>>>>> @@ -235,7 +235,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
>>>>>>     	else
>>>>>>     		rfkill->state&= ~RFKILL_BLOCK_HW;
>>>>>>     	*change = prev != blocked;
>>>>>> -	any = rfkill->state&    RFKILL_BLOCK_ANY;
>>>>>> +	any = !!(rfkill->state&    RFKILL_BLOCK_ANY);
>>>>>
>>>>> I believe this is not necessary since "any" is a "bool" and as such
>>>>> should cast correctly to 0/1.
>>>
>>>> I agree the older one works perfectly fine. I stumbled upon this when i
>>>> was trying to understand rfkill. but will not this change make it look
>>>> better ? if it looks like a too trivial please drop it. Thanks!
>>>
>>> Sure, whatever, I don't care; we can change it, but I think it'll
>>> generate exactly the same code :)
>>
>> oh ok, thanks.
>
> Sure. I just wanted to clarify that it was to make the coder nicer, not
> to fix a bug or so.

no it does not fixes any bug :) thanks a lot for reviewing.

>
> johannes
>

