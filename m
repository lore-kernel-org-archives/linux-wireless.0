Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:48332 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750977AbdFABDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 21:03:42 -0400
Message-ID: <592F6843.9000204@163.com> (sfid-20170601_030416_224926_845EF037)
Date: Thu, 01 Jun 2017 09:05:07 +0800
From: Jia-Ju Bai <baijiaju1990@163.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix a sleep-in-atomic bug in b43legacy_attr_interfmode_store
References: <1496226547-5921-1-git-send-email-baijiaju1990@163.com> <85905124-7167-aeb0-8aff-4ceec09e9542@lwfinger.net>
In-Reply-To: <85905124-7167-aeb0-8aff-4ceec09e9542@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2017 01:33 AM, Larry Finger wrote:
> On 05/31/2017 05:29 AM, Jia-Ju Bai wrote:
>> The driver may sleep under a spin lock, and the function call path is:
>> b43legacy_attr_interfmode_store (acquire the lock by spin_lock_irqsave)
>>    b43legacy_radio_set_interference_mitigation
>>      b43legacy_radio_interference_mitigation_disable
>>        b43legacy_calc_nrssi_slope
>>          b43legacy_synth_pu_workaround
>>            might_sleep and msleep --> may sleep
>>
>> Fixing it may be complex, and a possible way is to remove
>> spin_lock_irqsave and spin_lock_irqrestore in
>> b43legacy_attr_interfmode_store, and the code has been protected by
>> mutex_lock and mutex_unlock.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
>> ---
>>   drivers/net/wireless/broadcom/b43legacy/sysfs.c |    2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/b43legacy/sysfs.c 
>> b/drivers/net/wireless/broadcom/b43legacy/sysfs.c
>> index 2a1da15..9ede143 100644
>> --- a/drivers/net/wireless/broadcom/b43legacy/sysfs.c
>> +++ b/drivers/net/wireless/broadcom/b43legacy/sysfs.c
>> @@ -137,14 +137,12 @@ static ssize_t 
>> b43legacy_attr_interfmode_store(struct device *dev,
>>       }
>>         mutex_lock(&wldev->wl->mutex);
>> -    spin_lock_irqsave(&wldev->wl->irq_lock, flags);
>>         err = b43legacy_radio_set_interference_mitigation(wldev, mode);
>>       if (err)
>>           b43legacyerr(wldev->wl, "Interference Mitigation not "
>>                  "supported by device\n");
>>       mmiowb();
>> -    spin_unlock_irqrestore(&wldev->wl->irq_lock, flags);
>>       mutex_unlock(&wldev->wl->mutex);
>>         return err ? err : count;
>>
>
> Jia-Ju,
>
> Did you actually observe the attempt to sleep under the spin lock, or 
> did you discover this using some tool? In other words, have either of 
> your patches been tested?
>
> Larry
>
Hi,

In fact, my reported bugs are found by a static analysis tool written by 
me, and they are checked by my review of the driver code.
I admit my patches are not well tested, and they may not well fix the bugs.
I am looking forward to opinions and suggestions :)

Thanks,
Jia-Ju Bai
