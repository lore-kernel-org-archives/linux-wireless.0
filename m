Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64386 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0F1RA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jun 2010 13:00:59 -0400
Received: by wyb38 with SMTP id 38so1999345wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jun 2010 10:00:57 -0700 (PDT)
Message-ID: <4C28D552.30000@gmail.com>
Date: Mon, 28 Jun 2010 13:01:06 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: intel 5100/iwlagn bug in 2.6.35-rc2 during large file transfer
References: <4C198EF0.5080807@gmail.com>	 <1277225293.25793.2257.camel@rchatre-DESK>  <4C2383E2.8000909@gmail.com>	 <1277399636.25793.2389.camel@rchatre-DESK>  <4C23961D.7050500@gmail.com>	 <1277401731.25793.2391.camel@rchatre-DESK>  <4C24D926.7010806@gmail.com>	 <1277492229.13673.1297.camel@rchatre-DESK>  <4C278704.5040604@gmail.com> <1277742425.13673.1376.camel@rchatre-DESK>
In-Reply-To: <1277742425.13673.1376.camel@rchatre-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre wrote:
> On Sun, 2010-06-27 at 10:14 -0700, Richard Farina wrote:
>   
>>> ---
>>>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    5 +++--
>>>  drivers/net/wireless/iwlwifi/iwl-fh.h      |    2 +-
>>>  2 files changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
>>> index 0f292a2..2815ee7 100644
>>> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
>>> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
>>> @@ -613,7 +613,8 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>>>               }
>>>               spin_unlock_irqrestore(&rxq->lock, flags);
>>>
>>> -             if (rxq->free_count > RX_LOW_WATERMARK)
>>> +             if ((priority == GFP_ATOMIC) ||
>>> +                 (rxq->free_count > RX_LOW_WATERMARK / 4))
>>>                       gfp_mask |= __GFP_NOWARN;
>>>
>>>       
>
> Here I set the allocation mask to not print _any_ warnings when
> allocation is atomic ...
>
>
>   
>> [180257.090410] swapper: page allocation failure. order:1, mode:0x4020
>> [180257.090414] Pid: 0, comm: swapper Not tainted 2.6.34-pentoo-r2 #2
>> [180257.090416] Call Trace:
>>     
>
> ... clearly this is an allocation warning ...
>
>   
>> [180257.090418]  <IRQ>  [<ffffffff810984c0>]
>> __alloc_pages_nodemask+0x571/0x5b9
>> [180257.090437]  [<ffffffffa05162f3>] iwlagn_rx_allocate+0x98/0x2e0 [iwlagn]
>> [180257.090445]  [<ffffffffa051668c>] iwlagn_rx_replenish_now+0x16/0x23
>> [iwlagn]
>>     
>
> ... but it is an atomic one, which after the patch should not be
> printing _any_ warning ...
>
>   
I dunno, I really don't. but I did just verify the patch and it is 
correct and applied.

Thanks,
Rick
> I am very confused now.
>
> Reinette
>
>
>
>   

