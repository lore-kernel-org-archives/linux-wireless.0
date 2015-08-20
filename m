Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35801 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbHTP7x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 11:59:53 -0400
Received: by iodt126 with SMTP id t126so51315283iod.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2015 08:59:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55D4F34D.2010505@broadcom.com>
References: <1436553071-32423-1-git-send-email-arend@broadcom.com>
	<1436553071-32423-2-git-send-email-arend@broadcom.com>
	<CACna6ryt8iVUt18fODjDMiD-c3RLM22T2J_PM8NtEvBvWm8yBg@mail.gmail.com>
	<55D4F34D.2010505@broadcom.com>
Date: Thu, 20 Aug 2015 17:59:52 +0200
Message-ID: <CACna6rw9o3_mG3ZoDuRoBmVpVKuso52KXeeHr6R8nDotD4mwPQ@mail.gmail.com> (sfid-20150820_175956_462367_CCD13859)
Subject: Re: [PATCH v2 1/7] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2015 at 23:21, Arend van Spriel <arend@broadcom.com> wrote:
> subject changed to v2. So let's go over your beef.

I really hope none of my comment was mean or anything :)


> On 07/11/2015 07:09 PM, Rafał Miłecki wrote:
>>
>> On 10 July 2015 at 20:31, Arend van Spriel <arend@broadcom.com> wrote:
>>> +               data_len = fw->size;
>>> +               raw_nvram = false;
>>> +       } else {
>>> +               data = bcm47xx_nvram_get_contents(&data_len);
>>> +               if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
>>> +                       goto fail;
>>> +               raw_nvram = true;
>>> +       }
>>>
>>> -       if (fw) {
>>> -               nvram = brcmf_fw_nvram_strip(fw->data, fw->size,
>>> &nvram_length,
>>> +       if (data) {
>>> +               nvram = brcmf_fw_nvram_strip(data, data_len,
>>> &nvram_length,
>>>                                               fwctx->domain_nr,
>>> fwctx->bus_nr);
>>> -               release_firmware(fw);
>>> -               if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
>>> -                       goto fail;
>>> +               if (raw_nvram)
>>> +                       bcm47xx_nvram_release_contents(data);
>>
>>
>> This is cosmetical but maybe you could move above 2 lines next to the
>> release_firmware? So we have all freeing code at one please? Do you
>> think it would improve readability?
>> Nothing important thought. Feel free to ignore me here.
>
>
> confused! The release_firmware call is removed here, right?

Yes, you removed it from the "if (data) {" condition body but also
re-added right after it. AFAIR I got an impression it may make more
sense to have something like:
if (raw_nvram)
        bcm47xx_nvram_release_contents(data);
if (fw)
        release_firmware(fw);
but you can just ignore it if it doesn't sound clear.
