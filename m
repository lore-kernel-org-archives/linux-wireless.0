Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33499 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753147AbdCIIR4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:17:56 -0500
Received: by mail-wm0-f45.google.com with SMTP id v203so20137942wmg.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Mar 2017 00:17:55 -0800 (PST)
Subject: Re: [PATCH v3] brcmfmac: Do not print the firmware version as an
 error
To: Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170308082321.4755-1-hdegoede@redhat.com>
 <1488990890.2210.33.camel@perches.com>
 <797bce36-7887-24cb-2389-9a9e3c0d9760@redhat.com>
 <1488995605.2210.36.camel@perches.com>
 <333cdc50-9def-9af8-5081-cd776b4e0512@broadcom.com>
 <6b632474-7521-8b24-0ee6-48f390b14d24@redhat.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <dae22737-4c0f-d988-a8ba-109b18d232b2@broadcom.com> (sfid-20170309_091830_639023_6E86DC86)
Date: Thu, 9 Mar 2017 09:17:51 +0100
MIME-Version: 1.0
In-Reply-To: <6b632474-7521-8b24-0ee6-48f390b14d24@redhat.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9-3-2017 9:09, Hans de Goede wrote:
> Hi all,
> 
> On 08-03-17 21:44, Arend Van Spriel wrote:
>>
>>
>> On 8-3-2017 18:53, Joe Perches wrote:
>>> On Wed, 2017-03-08 at 17:57 +0100, Hans de Goede wrote:
>>>> Hi,
>>>
>>> And hello back to you.
>>
>> Also hello.
>>
>>>> On 08-03-17 17:34, Joe Perches wrote:
>>>>> On Wed, 2017-03-08 at 09:23 +0100, Hans de Goede wrote:
>>>>>> Using pr_err for things which are not errors is a bad idea. E.g. it
>>>>>> will cause the plymouth bootsplash screen to drop back to the text
>>>>>> console so that the user can see the error, which is not what we
>>>>>> normally want to happen.
>>>>>>
>>>>>> Instead add a new brcmf_info macro and use that.
>>>>>>
>>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>>> ---
>>>>>> Changes in v2:
>>>>>> -Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case
>>>>>> Changes in v3:
>>>>>> -Use do { } while (0) around macro
>>>>>
>>>>> why?  Single statement macros do not need a do/while
>>>>
>>>> Because Arend ask me to during review of v2.
>>>
>>> Well, maybe Arend should learn that single statement macros
>>> don't need do/while guards and that do/while guards are
>>> generally not used in the kernel for single statements.
>>
>> Always good to learn from an expert. The intent behind my remark was to
>> follow the same pattern as brcmf_err for the sake of consistency. I was
>> not clear.
> 
> Ok, so what is it going to be, are we going to keep this as is
> with the do .. while added or shall I do a v4 dropping it again?

Sorry, Hans

My bad. Let's stick with v3 and I will do a follow-up patch.

Regards,
Arend

> Regards,
> 
> Hans
