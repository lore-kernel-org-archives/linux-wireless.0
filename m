Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:58975 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbbH2INe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2015 04:13:34 -0400
Message-ID: <55E169AB.3080309@broadcom.com> (sfid-20150829_101358_343457_301CAA5B)
Date: Sat, 29 Aug 2015 10:13:31 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH V2 3/7] brcmfmac: Increase nr of supported flowrings.
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>	<1439708139-7527-4-git-send-email-arend@broadcom.com>	<CACna6ryL04p-cHptZnvYZ9fvnGn3FafN9PPNxsMPPfmdkSEjnA@mail.gmail.com>	<55DB26FC.1060707@broadcom.com> <CACna6ry3_4u_xAmeU8Hsoc96ZeVKFSq9zHL-yTFDT1hrgJa_BA@mail.gmail.com>
In-Reply-To: <CACna6ry3_4u_xAmeU8Hsoc96ZeVKFSq9zHL-yTFDT1hrgJa_BA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2015 10:02 PM, Rafał Miłecki wrote:
> On 24 August 2015 at 16:15, Arend van Spriel <arend@broadcom.com> wrote:
>> On 08/19/2015 11:56 PM, Rafał Miłecki wrote:
>>>
>>> On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
>>>>
>>>> From: Hante Meuleman <meuleman@broadcom.com>
>>>>
>>>> Next generation devices will have firmware which will have more
>>>> than 256 flowrings. This patch increases the maximum number of
>>>> supported flowrings to 512.
>>>>
>>>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>>>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>>>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>>>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>>>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>>>
>>>
>>> This is a patch that for my device triggers:
>>> Unable to handle kernel NULL pointer dereference at virtual address
>>> 00000014
>>>
>>> It seems to happen even when using only 1 AP interface.
>>
>>
>> Hi Rafał,
>>
>> What happens is that your platform has no memory to allocate a flowring for
>> tx and there is a bug in handling the returned error. Can you try it with
>> following applied. You will still have memory issue so for OpenWrt you may
>> need to limit to 256 anyway. Hante found another issue with hash_id in
>> struct brcmf_flowring so we are not entirely sure which issue caused the
>> null pointer deref so your feedback is appreciated.
>>
>> Regards,
>> Arend
>> ---
>>   drivers/net/wireless/brcm80211/brcmfmac/flowring.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
>> b/drivers/net/wi
>> index 5b7a8ee..9fb50b3 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
>> @@ -151,11 +151,11 @@ u32 brcmf_flowring_create(struct brcmf_flowring *flow,
>> u8
>>                                  break;
>>                  }
>>                  if (i == flow->nrofrings)
>> -                       return -ENOMEM;
>> +                       return BRCMF_FLOWRING_INVALID_ID;
>>
>>                  ring = kzalloc(sizeof(*ring), GFP_ATOMIC);
>>                  if (!ring)
>> -                       return -ENOMEM;
>> +                       return BRCMF_FLOWRING_INVALID_ID;
>>
>>                  memcpy(hash[hash_idx].mac, mac, ETH_ALEN);
>>                  hash[hash_idx].fifo = fifo;
>
> Unfortunately this patch didn't help. I tied it on top of V3 of your
> last series plus "brcmfmac: Increase nr of supported flowrings.".

First about the warnings in core.c:1144. I believe they are fixed by one 
of the patches submitted last week [1].

Now about the problem upon start_xmit. The theory was that you had 
allocation failure leading to the null pointer deref. If you don't see 
any allocation failure on your setup that theory seems invalid. So there 
is another root cause that we need to find.

> I tried it 3 times, once I even got early NULL pointer dereference,
> when starting AP interface (before any STA connecting to it).

This seems like a different issue. Thanks for reporting. We will look 
into this.

Regards,
Arend

[1] https://patchwork.kernel.org/patch/7079891/

