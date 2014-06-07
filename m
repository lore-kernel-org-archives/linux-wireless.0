Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50197 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbaFGP3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 11:29:38 -0400
Message-ID: <53932FE1.6090506@candelatech.com> (sfid-20140607_172940_575913_06E03C39)
Date: Sat, 07 Jun 2014 08:29:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>	<87y4xal6vb.fsf@kamboji.qca.qualcomm.com>	<5391F51B.4020103@candelatech.com> <87zjhoj2rt.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zjhoj2rt.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/07/2014 05:57 AM, Kalle Valo wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 06/06/2014 02:33 AM, Kalle Valo wrote:
>>
>>>> +					kfree(buffer);
>>>> +					goto save_regs_and_restart;
>>>> +				}
>>>> +
>>>> +				ath10k_dbg_save_fw_dbg_buffer(ar, buffer,
>>>> +							      dbuf.length);
>>>> +				kfree(buffer);
>>>
>>> Instead of doing atomic allocations multiple times in a loop, would it
>>> be better to allocate just one buffer before the loop and free it
>>> afterwards?
>>
>> There is no hard guarantee that the buffer lengths are the same,
>> so I think it needs to remain as is.  Would rather not crap out
>> because firmware suddenly got more clever...
>
> This is related to my earlier comment about having a max len for the
> buffers. So why not come up with a sane max length, allocate once a
> temporary buffer of that length and use the same buffer in the loop?

I can fix it at a 4k chunk if you want.  Current firmware uses around 2k chunk
I believe, and only two buffers, so either way it's not a lot of work for CPU.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
