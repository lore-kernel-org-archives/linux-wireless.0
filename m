Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:49035
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932299AbcIHP5v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2016 11:57:51 -0400
Subject: Re: mwifiex: propagate error if IRQ request fails in
 mwifiex_sdio_of()
To: Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20160903103520.8C69C6201B@smtp.codeaurora.org>
 <66735eb5-c831-8e06-337b-80ccfc392061@osg.samsung.com>
 <0f15fe320fa34ae287f8a6b91ec78a34@SC-EXCH04.marvell.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <c7e8b951-97dd-d2a5-4740-b6895d577f91@osg.samsung.com> (sfid-20160908_175813_070384_625E1CA8)
Date: Thu, 8 Sep 2016 11:57:43 -0400
MIME-Version: 1.0
In-Reply-To: <0f15fe320fa34ae287f8a6b91ec78a34@SC-EXCH04.marvell.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Amitkumar,

On 09/08/2016 11:55 AM, Amitkumar Karwar wrote:
> Hi Javier,
> 
>> From: Javier Martinez Canillas [mailto:javier@osg.samsung.com]
>> Sent: Tuesday, September 06, 2016 5:43 PM
>> To: Kalle Valo
>> Cc: linux-kernel@vger.kernel.org; Amitkumar Karwar;
>> netdev@vger.kernel.org; linux-wireless@vger.kernel.org; Nishant
>> Sarmukadam; Arend van Spriel
>> Subject: Re: mwifiex: propagate error if IRQ request fails in
>> mwifiex_sdio_of()
>>
>> Hello Kalle,
>>
>> On 09/03/2016 12:35 PM, Kalle Valo wrote:
>>> Javier Martinez Canillas <javier@osg.samsung.com> wrote:
>>>> If request_irq() fails in mwifiex_sdio_probe_of(), only an error
>>>> message is printed but the actual error is not propagated to the
>> caller function.
>>>>
>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>
>>> What's the conclusion with this patch? Should I drop it or take it?
>>>
>>> (The discussion is available from the patchwork link in the
>>> signature.)
>>>
>>
>> My understanding is that Arend agrees with the patch and that the
>> question raised was caused by looking at an older kernel version. IOW,
>> the patch is OK and should be picked.
>>
>> I'm adding Arend to cc, so can comment in case I misunderstood him
>> though.
>>
> 
> This error doesn't affect actual wifi functionality. Only thing is wakeup on interrupt when system is in suspended state won't work.
> I think, we can make below change. 
> 
> ------------------
> @@ -122,9 +122,11 @@ static int mwifiex_sdio_probe_of(struct device *dev, struct sdio_mmc_card *card)
>                                                IRQF_TRIGGER_LOW,
>                                                "wifi_wake", cfg);
>            if (ret) {
> -                    dev_err(dev,
> +                    dev_dbg(dev,
>                              "Failed to request irq_wifi %d (%d)\n",
>                              cfg->irq_wifi, ret);
> +                    card->plt_wake_cfg = NULL;
> +                    return 0;
>              }

I'm OK with that change. Feel free too add my Reviewed-by if you post it.

>                 disable_irq(cfg->irq_wifi);
>             }
> -----------------
> 
> Regards,
> Amitkumar
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
