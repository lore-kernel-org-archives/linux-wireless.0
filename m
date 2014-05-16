Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35525 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375AbaEPOLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 10:11:12 -0400
Message-ID: <53761C7F.80505@candelatech.com> (sfid-20140516_161115_655390_9B62D00A)
Date: Fri, 16 May 2014 07:11:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:  improve vdev map handling.
References: <1398882179-17100-1-git-send-email-greearb@candelatech.com> <878uq16e08.fsf@kamboji.qca.qualcomm.com> <53761A35.2000308@candelatech.com> <87bnux4y42.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bnux4y42.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2014 07:06 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
> 
>> On 05/16/2014 06:37 AM, Kalle Valo wrote:
>>
>>>> -	ar->free_vdev_map &= ~BIT(arvif->vdev_id);
>>>> +	ar->free_vdev_map &= ~(1 << arvif->vdev_id);
>>>
>>> Why remove the BIT()? Not that it matters much, I just think it's easier
>>> to read when BIT() macro is used. Would be good to convert all cases to
>>> use BIT anyway, but that's for a separate patch.
>>
>> BIT doesn't work on 64-bit numbers (ie, if vdev_id > 31)
> 
> Oh, I didn't know that. Too bad, but then removing it makes sense.
> 
>> and it takes a long time to figure out exactly what it does (try
>> grepping for BIT). Open-coding means much easier to fully understand
>> the code.
> 
> All Linux engineers should know what BIT() does. If not, they should
> learn that ;)

Yeah, but see your comment above :P

Pain in the ass to track down the difference between (1 << x) and (1LLU << x),
and even worse when it's hidden behind a macro.

Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

