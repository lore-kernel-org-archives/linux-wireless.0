Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54882 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaFHPkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2014 11:40:42 -0400
Message-ID: <539483F9.9050401@candelatech.com> (sfid-20140608_174351_877101_8153F428)
Date: Sun, 08 Jun 2014 08:40:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com> <87egz3nxdn.fsf@kamboji.qca.qualcomm.com> <5390B632.7030305@candelatech.com> <87wqcumuuw.fsf@kamboji.qca.qualcomm.com> <5391E842.4010401@candelatech.com> <874mzwkher.fsf@kamboji.qca.qualcomm.com> <539330A1.9050307@candelatech.com> <877g4riz3w.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <877g4riz3w.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/08/2014 01:28 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 06/07/2014 05:55 AM, Kalle Valo wrote:
>>> Ben Greear <greearb@candelatech.com> writes:
>>>
>>>>>> I'm a bit leery of adding spin-locks in the dump routine just for
>>>>>> this, but I can add and use a new spin-lock if you prefer.
>>>>>
>>>>> Why a new spinlock? I didn't review the locking requirements, but I
>>>>> would first check ar->data_lock can be used.
>>>>
>>>> I think it has to be a spin-lock because the crash dump is gathered
>>>> in the irq handler, so I can't use a mutex as far as I know...
>>>>
>>>> I'll work on adding such a lock today.
>>>
>>> I asked why add a _new_ spinlock as ar->data_lock is already a spinlock.
>>
>> Surely we do not want to impede traffic flow just to dump debug info?
>
> I don't see data_lock being used anywhere in hotpath, but of course I
> might have missed something. Anyway, if for optimisation reasons we need
> to introduce a new lock that should happen for a specific case in hot
> path. Handling firmware debug log events is not in that category.
>
>> And, it is easier to review a specific spinlock rather than use one big
>> global-ish lock and have to review every use of that lock for issues.
>
> Sure, it's easier for you to just add a new lock and then forget :) But
> not for me who would have to maintain 20 different locks for years to
> come. My view is that a new lock should be added on very exceptional
> cases and with good justifications.

I have the opposite opinion on what makes it easy to maintain
locks, but I'll switch to the data-spinlock as you suggest.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
