Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57331 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaFHIMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2014 04:12:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	<87y4xal6vb.fsf@kamboji.qca.qualcomm.com>
	<5391F51B.4020103@candelatech.com>
	<87zjhoj2rt.fsf@kamboji.qca.qualcomm.com>
	<53932FE1.6090506@candelatech.com>
Date: Sun, 8 Jun 2014 11:12:28 +0300
In-Reply-To: <53932FE1.6090506@candelatech.com> (Ben Greear's message of "Sat,
	7 Jun 2014 08:29:37 -0700")
Message-ID: <87bnu3izv7.fsf@kamboji.qca.qualcomm.com> (sfid-20140608_101249_079392_FA6F1EB1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>>>> Instead of doing atomic allocations multiple times in a loop, would it
>>>> be better to allocate just one buffer before the loop and free it
>>>> afterwards?
>>>
>>> There is no hard guarantee that the buffer lengths are the same,
>>> so I think it needs to remain as is.  Would rather not crap out
>>> because firmware suddenly got more clever...
>>
>> This is related to my earlier comment about having a max len for the
>> buffers. So why not come up with a sane max length, allocate once a
>> temporary buffer of that length and use the same buffer in the loop?
>
> I can fix it at a 4k chunk if you want.  Current firmware uses around 2k chunk
> I believe, and only two buffers, so either way it's not a lot of work for CPU.

I think we should have a max chunk size in ath10k anyway and using one
buffer makes sense in that case.

-- 
Kalle Valo
