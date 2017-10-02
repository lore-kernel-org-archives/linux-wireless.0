Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33852 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750903AbdJBJGp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 05:06:45 -0400
Received: by mail-lf0-f66.google.com with SMTP id h80so1969805lfe.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Oct 2017 02:06:44 -0700 (PDT)
Subject: Re: [PATCH 02/11] ath10k_sdio: wb396 reference card fix
To: Alagu Sankar <alagusankar@silex-india.com>,
        Steve deRosier <derosier@gmail.com>
Cc: silexcommon@gmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <1506793068-27445-3-git-send-email-alagusankar@silex-india.com>
 <CALLGbR+-G6pKcSPZo=xxJ66iQ0aMJo9xWWq8raSTt5rSASrM=w@mail.gmail.com>
 <bc6a860a4d655c65583a9da26cb4c63e@silex-india.com>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <427bfce1-5adb-9cad-b674-e42f8005bb02@gmail.com> (sfid-20171002_110459_463768_722ACABC)
Date: Mon, 2 Oct 2017 11:06:42 +0200
MIME-Version: 1.0
In-Reply-To: <bc6a860a4d655c65583a9da26cb4c63e@silex-india.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alagu,

On 2017-10-02 09:02, Alagu Sankar wrote:
> Hi Steve,
> 
> On 2017-10-02 04:17, Steve deRosier wrote:
>> Hi Alagu,
>>
>>
>> On Sat, Sep 30, 2017 at 10:37 AM, <silexcommon@gmail.com> wrote:
>>>
>>> From: Alagu Sankar <alagusankar@silex-india.com>
>>>
>>> The QCA9377-3 WB396 sdio reference card does not get initialized
>>> due to the conflict in uart gpio pins. This fix is not required
>>> for other QCA9377 sdio cards.
>>>
>>> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
>>> ---
>>>  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++++-
>>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
>>> index b4f66cd..86247c8 100644
>>> --- a/drivers/net/wireless/ath/ath10k/core.c
>>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>>> @@ -1708,8 +1708,15 @@ static int ath10k_init_uart(struct ath10k *ar)
>>>                 return ret;
>>>         }
>>>
>>> -       if (!uart_print)
>>> +       if (!uart_print) {
>>> +               /* Hack: override dbg TX pin to avoid side effects of default
>>> +                * GPIO_6 in QCA9377 WB396 reference card
>>> +                */
>>> +               if (ar->hif.bus == ATH10K_BUS_SDIO)
>>> +                       ath10k_bmi_write32(ar, hi_dbg_uart_txpin,
>>> +                                          ar->hw_params.uart_pin);
>>
>> If it is indeed a "hack", then I don't think the maintainer should
>> accept this upstream. If you want it upstream you need a clean enough
>> implementation that doesn't need to be labeled a "hack".
> 
> It is a hack as per the qcacld reference driver.
> 
>> Your commit message states that this is only needed for a very
>> specific card and not for other QCA9377 sdio cards. Yet, you're doing
>> this for all ATH10K_BUS_SDIO devices. Not good. I think that it's a
>> quirk and it's limited to a particular implementation of the device.
>> My suggestion: if it can be automatically determined, then do so
>> explicitly. If not, then it needs to be a DT setting or a module
>> parameter or something like that so the platform maker can decide to
>> do it. Having it affect all users of a SDIO QCA9377 when it doesn't
>> apply doesn't seem like a good idea to me.
>>
>>
>> - Steve
> 
> Got it. The qcacld reference driver had it for all the QCA9377 sdio cards.
> But we found it to be a problem only for the WB396 reference card. Will
> have this checked again and release a v2 patch accordingly.
> 
While you are at it, you might as well change the commit comments to:

"ath10k: sdio: <description>"

or perhaps just:

"ath10k: <description>"

> Best Regards,
> Alagu Sankar
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
