Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38275 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1JLKpc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 06:45:32 -0400
Received: by pzk1 with SMTP id 1so1255889pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2011 03:45:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E953FDB.9090709@qca.qualcomm.com>
References: <1317906725-31130-1-git-send-email-sangwook.lee@linaro.org>
	<4E953FDB.9090709@qca.qualcomm.com>
Date: Wed, 12 Oct 2011 11:45:32 +0100
Message-ID: <CADPsn1bWC6=dgoUn7_1--a=jcNHq0Hw6Drmg+8HcY5xPLVrSBA@mail.gmail.com> (sfid-20111012_124536_338003_3ACEA9C7)
Subject: Re: [PATCH] ath6kl: fix firmware start address for ar6003 hw2.0
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle

You wrote:
>>>Before I'm able to find a hw 2.0 device, can you try to debug this more?
>>>When scanning fails can check if ath6kldev_intr_bh_handler() is called
>>>or not? When scanning fails it usually happens because irqs are failing.

Yes, it seems true. when scanning fails. it failed to receive no more sdio irqs.
For the temporary testing, I made sdio polling kernel thread and then let it
call ath6kldev_intr_bh_handler(). With hw2.0, it works fine with
scanning issue.
Do you know any ideas to solve this problem clearly ?

Thanks
Sangwook


On 12 October 2011 08:20, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> On 10/06/2011 04:12 PM, Sangwook Lee wrote:
>> From: Kalle Valo <kvalo@qca.qualcomm.com>
>>
>> Sangwook found out that commit 639d0b89 ("ath6kl: read firmware start
>> address from hardware") broke firmware boot on ar6003 hw2.0 as it seems
>> it's not posible to automatically query the address from hardware. So
>> we need to hardcode the address for hw2.0.
>>
>> Reported-by: Sangwook Lee <sangwook.lee@linaro.org>
>> Tested-by: Sangwook Lee <sangwook.lee@linaro.org>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>> Kalle:
>> I slightly changed again. without running ath6kl_bmi_read() before,
>> ath6kl_bmi_execute() failed with hw2.0 board, but I am not clear about this reason.
>
> Hmm, that's strange. I didn't find any reason why this is needed.
>
>> @@ -1201,25 +1202,28 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
>>       }
>>
>>       /* read firmware start address */
>> -     ret = ath6kl_bmi_read(ar,
>> -                           ath6kl_get_hi_item_addr(ar,
>> -                                                   HI_ITEM(hi_app_start)),
>> -                           (u8 *) &address, sizeof(address));
>> +     ret = ath6kl_bmi_read(ar, ath6kl_get_hi_item_addr(ar,
>> +             HI_ITEM(hi_app_start)), (u8 *) &address, sizeof(address));
>
> You just change indentation here, right? So this part can be dropped.
>
> I have applied to ath6kl.git now. Thank you very much for your help!
>
> Kalle
>
