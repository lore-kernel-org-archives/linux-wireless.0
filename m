Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16993 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1IPNxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 09:53:39 -0400
Message-ID: <4E7354D8.40507@qca.qualcomm.com> (sfid-20110916_155342_487037_FD130250)
Date: Fri, 16 Sep 2011 19:23:28 +0530
From: mohammed <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: properly assign a boolean type
References: <1316180020-9982-1-git-send-email-mohammed@qca.qualcomm.com> <1316180237.4130.37.camel@jlt3.sipsolutions.net>
In-Reply-To: <1316180237.4130.37.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 September 2011 07:07 PM, Johannes Berg wrote:
> On Fri, 2011-09-16 at 19:03 +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> ---
>>   net/rfkill/core.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
>> index be90640..5be1957 100644
>> --- a/net/rfkill/core.c
>> +++ b/net/rfkill/core.c
>> @@ -235,7 +235,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
>>   	else
>>   		rfkill->state&= ~RFKILL_BLOCK_HW;
>>   	*change = prev != blocked;
>> -	any = rfkill->state&  RFKILL_BLOCK_ANY;
>> +	any = !!(rfkill->state&  RFKILL_BLOCK_ANY);
>
> I believe this is not necessary since "any" is a "bool" and as such
> should cast correctly to 0/1.

Hi johannes,

I agree the older one works perfectly fine. I stumbled upon this when i 
was trying to understand rfkill. but will not this change make it look 
better ? if it looks like a too trivial please drop it. Thanks!


>
> johannes
>

