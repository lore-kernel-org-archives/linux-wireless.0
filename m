Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:41413 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbbHTQOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 12:14:11 -0400
Message-ID: <55D5FCD1.2070304@broadcom.com> (sfid-20150820_181420_963063_A5D437FE)
Date: Thu, 20 Aug 2015 18:14:09 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH v2 1/7] brcmfmac: Add support for host platform NVRAM
 loading.
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>	<1436553071-32423-2-git-send-email-arend@broadcom.com>	<CACna6ryt8iVUt18fODjDMiD-c3RLM22T2J_PM8NtEvBvWm8yBg@mail.gmail.com>	<55D4F34D.2010505@broadcom.com> <CACna6rw9o3_mG3ZoDuRoBmVpVKuso52KXeeHr6R8nDotD4mwPQ@mail.gmail.com>
In-Reply-To: <CACna6rw9o3_mG3ZoDuRoBmVpVKuso52KXeeHr6R8nDotD4mwPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2015 05:59 PM, Rafał Miłecki wrote:
> On 19 August 2015 at 23:21, Arend van Spriel <arend@broadcom.com> wrote:
>> subject changed to v2. So let's go over your beef.
>
> I really hope none of my comment was mean or anything :)
>
>
>> On 07/11/2015 07:09 PM, Rafał Miłecki wrote:
>>>
>>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>>> +               data_len = fw->size;
>>>> +               raw_nvram = false;
>>>> +       } else {
>>>> +               data = bcm47xx_nvram_get_contents(&data_len);
>>>> +               if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
>>>> +                       goto fail;
>>>> +               raw_nvram = true;
>>>> +       }
>>>>
>>>> -       if (fw) {
>>>> -               nvram = brcmf_fw_nvram_strip(fw->data, fw->size,
>>>> &nvram_length,
>>>> +       if (data) {
>>>> +               nvram = brcmf_fw_nvram_strip(data, data_len,
>>>> &nvram_length,
>>>>                                                fwctx->domain_nr,
>>>> fwctx->bus_nr);
>>>> -               release_firmware(fw);
>>>> -               if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
>>>> -                       goto fail;
>>>> +               if (raw_nvram)
>>>> +                       bcm47xx_nvram_release_contents(data);
>>>
>>>
>>> This is cosmetical but maybe you could move above 2 lines next to the
>>> release_firmware? So we have all freeing code at one please? Do you
>>> think it would improve readability?
>>> Nothing important thought. Feel free to ignore me here.
>>
>>
>> confused! The release_firmware call is removed here, right?
>
> Yes, you removed it from the "if (data) {" condition body but also
> re-added right after it. AFAIR I got an impression it may make more
> sense to have something like:
> if (raw_nvram)
>          bcm47xx_nvram_release_contents(data);

I did not check whether bcm47xx_nvram_release_contents deals with data 
being NULL pointer. If so, I can change it.

Regards,
Arend

> if (fw)
>          release_firmware(fw);
> but you can just ignore it if it doesn't sound clear.
>

