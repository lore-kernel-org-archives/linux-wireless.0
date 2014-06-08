Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15763 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaFHI27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2014 04:28:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	<87egz3nxdn.fsf@kamboji.qca.qualcomm.com>
	<5390B632.7030305@candelatech.com>
	<87wqcumuuw.fsf@kamboji.qca.qualcomm.com>
	<5391E842.4010401@candelatech.com>
	<874mzwkher.fsf@kamboji.qca.qualcomm.com>
	<539330A1.9050307@candelatech.com>
Date: Sun, 8 Jun 2014 11:28:51 +0300
In-Reply-To: <539330A1.9050307@candelatech.com> (Ben Greear's message of "Sat,
	7 Jun 2014 08:32:49 -0700")
Message-ID: <877g4riz3w.fsf@kamboji.qca.qualcomm.com> (sfid-20140608_102911_428603_5303D27B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/07/2014 05:55 AM, Kalle Valo wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>>>> I'm a bit leery of adding spin-locks in the dump routine just for
>>>>> this, but I can add and use a new spin-lock if you prefer.
>>>>
>>>> Why a new spinlock? I didn't review the locking requirements, but I
>>>> would first check ar->data_lock can be used.
>>>
>>> I think it has to be a spin-lock because the crash dump is gathered
>>> in the irq handler, so I can't use a mutex as far as I know...
>>>
>>> I'll work on adding such a lock today.
>>
>> I asked why add a _new_ spinlock as ar->data_lock is already a spinlock.
>
> Surely we do not want to impede traffic flow just to dump debug info?

I don't see data_lock being used anywhere in hotpath, but of course I
might have missed something. Anyway, if for optimisation reasons we need
to introduce a new lock that should happen for a specific case in hot
path. Handling firmware debug log events is not in that category.

> And, it is easier to review a specific spinlock rather than use one big
> global-ish lock and have to review every use of that lock for issues.

Sure, it's easier for you to just add a new lock and then forget :) But
not for me who would have to maintain 20 different locks for years to
come. My view is that a new lock should be added on very exceptional
cases and with good justifications.

-- 
Kalle Valo
