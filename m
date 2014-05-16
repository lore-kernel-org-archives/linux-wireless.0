Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34850 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaEPN0F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 09:26:05 -0400
Message-ID: <537611EB.9050208@candelatech.com> (sfid-20140516_152609_669994_73B60461)
Date: Fri, 16 May 2014 06:26:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k:  improve vdev map handling.
References: <1398882179-17100-1-git-send-email-greearb@candelatech.com> <87fvk96ewc.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fvk96ewc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/16/2014 06:18 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Check vdev map has space before calling ffs,
>> fix invalid cleanup in failure to create vdev
>> case.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> Why? What motivated you to write this? If you saw a bug, it would be
> good to document the bug in the commit log.
>
>> This is compile-tested only.
>
> It's two weeks since you posted this, sorry for taking so long. But have
> you managed to test this by now?

The code is cleaner with my patch, and it makes it easier to
use the 64-bit version of ffs.

I have tested this extensively in my tree with the 64-bit version
of ffs so that I can have more than 32 vdevs.

It does fix a problem I found through code inspection as well,
when it did not properly release a slot in a failure path.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
