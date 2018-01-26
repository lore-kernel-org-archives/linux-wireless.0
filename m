Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34458 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbeAZQeK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 11:34:10 -0500
Subject: Re: [PATCH] bcma: Replace mdelay with usleep_range in
 bcma_pmu_resources_init
To: Larry Finger <Larry.Finger@lwfinger.net>, zajec5@gmail.com,
        hauke@hauke-m.de
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1516958011-303-1-git-send-email-baijiaju1990@gmail.com>
 <b0ae2efe-9b90-0e5f-d53a-d045e76b213c@lwfinger.net>
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <f8c701d1-853f-ab35-15c8-451330ab02f4@gmail.com> (sfid-20180126_173437_708721_92D92212)
Date: Sat, 27 Jan 2018 00:33:49 +0800
MIME-Version: 1.0
In-Reply-To: <b0ae2efe-9b90-0e5f-d53a-d045e76b213c@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2018/1/27 0:26, Larry Finger wrote:
> On 01/26/2018 03:13 AM, Jia-Ju Bai wrote:
>> After checking all possible call chains to bcma_pmu_resources_init() 
>> here,
>> my tool finds that this function is never called in atomic context,
>> namely never in an interrupt handler or holding a spinlock.
>> Thus mdelay can be replaced with usleep_range to avoid busy wait.
>>
>> This is found by a static analysis tool named DCNS written by myself.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>> ---
>>   drivers/bcma/driver_chipcommon_pmu.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/bcma/driver_chipcommon_pmu.c 
>> b/drivers/bcma/driver_chipcommon_pmu.c
>> index f1eb4d3..478948c 100644
>> --- a/drivers/bcma/driver_chipcommon_pmu.c
>> +++ b/drivers/bcma/driver_chipcommon_pmu.c
>> @@ -203,7 +203,7 @@ static void bcma_pmu_resources_init(struct 
>> bcma_drv_cc *cc)
>>        * Add some delay; allow resources to come up and settle.
>>        * Delay is required for SoC (early init).
>>        */
>> -    mdelay(2);
>> +    usleep_range(1500, 2000);
>
> I have no idea how critical this delay might be, but it would be safer 
> to never make the sleep be shorter than the original delay. Using 
> (2000, 2500) would be a better choice of arguments for usleep_range().

Okay, I have used usleep_range(2000, 2500) and sent patch v2.


Thanks,
Jia-Ju Bai
