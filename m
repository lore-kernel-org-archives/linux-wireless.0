Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from up.icubehost.com ([185.62.36.194]:52278 "EHLO up.icubehost.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750770AbdJBH6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 03:58:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 02 Oct 2017 12:32:15 +0530
From: Alagu Sankar <alagusankar@silex-india.com>
To: Steve deRosier <derosier@gmail.com>
Cc: silexcommon@gmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 02/11] ath10k_sdio: wb396 reference card fix
In-Reply-To: <CALLGbR+-G6pKcSPZo=xxJ66iQ0aMJo9xWWq8raSTt5rSASrM=w@mail.gmail.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
 <1506793068-27445-3-git-send-email-alagusankar@silex-india.com>
 <CALLGbR+-G6pKcSPZo=xxJ66iQ0aMJo9xWWq8raSTt5rSASrM=w@mail.gmail.com>
Message-ID: <bc6a860a4d655c65583a9da26cb4c63e@silex-india.com> (sfid-20171002_095624_187385_A044E731)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

On 2017-10-02 04:17, Steve deRosier wrote:
> Hi Alagu,
> 
> 
> On Sat, Sep 30, 2017 at 10:37 AM, <silexcommon@gmail.com> wrote:
>> 
>> From: Alagu Sankar <alagusankar@silex-india.com>
>> 
>> The QCA9377-3 WB396 sdio reference card does not get initialized
>> due to the conflict in uart gpio pins. This fix is not required
>> for other QCA9377 sdio cards.
>> 
>> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/core.c 
>> b/drivers/net/wireless/ath/ath10k/core.c
>> index b4f66cd..86247c8 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -1708,8 +1708,15 @@ static int ath10k_init_uart(struct ath10k *ar)
>>                 return ret;
>>         }
>> 
>> -       if (!uart_print)
>> +       if (!uart_print) {
>> +               /* Hack: override dbg TX pin to avoid side effects of 
>> default
>> +                * GPIO_6 in QCA9377 WB396 reference card
>> +                */
>> +               if (ar->hif.bus == ATH10K_BUS_SDIO)
>> +                       ath10k_bmi_write32(ar, hi_dbg_uart_txpin,
>> +                                          ar->hw_params.uart_pin);
> 
> If it is indeed a "hack", then I don't think the maintainer should
> accept this upstream. If you want it upstream you need a clean enough
> implementation that doesn't need to be labeled a "hack".

It is a hack as per the qcacld reference driver.

> Your commit message states that this is only needed for a very
> specific card and not for other QCA9377 sdio cards. Yet, you're doing
> this for all ATH10K_BUS_SDIO devices. Not good. I think that it's a
> quirk and it's limited to a particular implementation of the device.
> My suggestion: if it can be automatically determined, then do so
> explicitly. If not, then it needs to be a DT setting or a module
> parameter or something like that so the platform maker can decide to
> do it. Having it affect all users of a SDIO QCA9377 when it doesn't
> apply doesn't seem like a good idea to me.
> 
> 
> - Steve

Got it. The qcacld reference driver had it for all the QCA9377 sdio 
cards.
But we found it to be a problem only for the WB396 reference card. Will
have this checked again and release a v2 patch accordingly.

Best Regards,
Alagu Sankar
