Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34407 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbcKORLU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 12:11:20 -0500
Received: by mail-wm0-f66.google.com with SMTP id g23so2027396wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 09:11:20 -0800 (PST)
Subject: Re: [RFC 06/12] ath10k: bmi: Added SOC reg read/write functions
To: Michal Kazior <michal.kazior@tieto.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
 <1479141222-8493-7-git-send-email-erik.stromdahl@gmail.com>
 <CA+BoTQ=jSun0Je6sVsZz-SaiDA6+nZxSTJF_5OH0unPkjm1gvw@mail.gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <5333e0c5-3449-5bcd-b467-3282d8b0a43b@gmail.com> (sfid-20161115_181123_983925_82E46997)
Date: Tue, 15 Nov 2016 18:11:17 +0100
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=jSun0Je6sVsZz-SaiDA6+nZxSTJF_5OH0unPkjm1gvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/15/2016 11:28 AM, Michal Kazior wrote:
> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
>> Added functions implementing the following BMI commands:
>>
>> BMI_READ_SOC_REGISTER
>> BMI_WRITE_SOC_REGISTER
>>
>> Reading and writing BMI registers is sometimes needed for
>> SDIO chipsets.
> 
> I didn't see ath10k_bmi_write_soc_reg nor ath10k_bmi_read_soc_reg
> being used in your Patch 12. Is this patch really necessary?
> 
> 

You are right, these functions are not used in patch 12. They are used
in some other patches that was not included in this series (needs more
cleanup before I can publish). I will remove them from the series.

> [...]
>> diff --git a/drivers/net/wireless/ath/ath10k/bmi.c b/drivers/net/wireless/ath/ath10k/bmi.c
>> index 2872d34..1c378a2 100644
>> --- a/drivers/net/wireless/ath/ath10k/bmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/bmi.c
>> @@ -97,7 +97,8 @@ int ath10k_bmi_read_memory(struct ath10k *ar,
>>         u32 rxlen;
>>         int ret;
>>
>> -       ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi read address 0x%x length %d\n",
>> +       ath10k_dbg(ar, ATH10K_DBG_BMI,
>> +                  "bmi read memory address 0x%x length %d\n",
>>                    address, length);
>>
>>         if (ar->bmi.done_sent) {
>> @@ -137,7 +138,8 @@ int ath10k_bmi_write_memory(struct ath10k *ar,
>>         u32 txlen;
>>         int ret;
>>
>> -       ath10k_dbg(ar, ATH10K_DBG_BMI, "bmi write address 0x%x length %d\n",
>> +       ath10k_dbg(ar, ATH10K_DBG_BMI,
>> +                  "bmi write memory address 0x%x length %d\n",
>>                    address, length);
>>
> 
> These 2 hunks shouldn't be modified in this patch. If you want to do a
> clean up this warrants a separate patch :)
> 
> 
> Michał
> 

Ok

/Erik
