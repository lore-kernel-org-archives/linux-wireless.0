Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:37310 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753933AbeAZQ1P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 11:27:15 -0500
Subject: Re: [PATCH] bcma: Replace mdelay with usleep_range in
 bcma_pmu_resources_init
To: Kalle Valo <kvalo@codeaurora.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: zajec5@gmail.com, hauke@hauke-m.de, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1516958011-303-1-git-send-email-baijiaju1990@gmail.com>
 <87y3kkr436.fsf@purkki.adurom.net>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <207c3131-1f45-08c2-0da9-5f4fb3b65a41@lwfinger.net> (sfid-20180126_172804_751016_033D1731)
Date: Fri, 26 Jan 2018 10:27:12 -0600
MIME-Version: 1.0
In-Reply-To: <87y3kkr436.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2018 10:13 AM, Kalle Valo wrote:
> Jia-Ju Bai <baijiaju1990@gmail.com> writes:
> 
>> After checking all possible call chains to bcma_pmu_resources_init() here,
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
>> diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
>> index f1eb4d3..478948c 100644
>> --- a/drivers/bcma/driver_chipcommon_pmu.c
>> +++ b/drivers/bcma/driver_chipcommon_pmu.c
>> @@ -203,7 +203,7 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
>>   	 * Add some delay; allow resources to come up and settle.
>>   	 * Delay is required for SoC (early init).
>>   	 */
>> -	mdelay(2);
>> +	usleep_range(1500, 2000);
> 
> I would like to have an ack from someone familiar with bcma before I
> apply this.

No ack for this one.

Larry
