Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47438 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753862AbdCIIKp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 03:10:45 -0500
Subject: Re: [PATCH v3] brcmfmac: Do not print the firmware version as an
 error
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Joe Perches <joe@perches.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170308082321.4755-1-hdegoede@redhat.com>
 <1488990890.2210.33.camel@perches.com>
 <797bce36-7887-24cb-2389-9a9e3c0d9760@redhat.com>
 <1488995605.2210.36.camel@perches.com>
 <333cdc50-9def-9af8-5081-cd776b4e0512@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <6b632474-7521-8b24-0ee6-48f390b14d24@redhat.com> (sfid-20170309_091051_821559_0F63561C)
Date: Thu, 9 Mar 2017 09:09:17 +0100
MIME-Version: 1.0
In-Reply-To: <333cdc50-9def-9af8-5081-cd776b4e0512@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

On 08-03-17 21:44, Arend Van Spriel wrote:
>
>
> On 8-3-2017 18:53, Joe Perches wrote:
>> On Wed, 2017-03-08 at 17:57 +0100, Hans de Goede wrote:
>>> Hi,
>>
>> And hello back to you.
>
> Also hello.
>
>>> On 08-03-17 17:34, Joe Perches wrote:
>>>> On Wed, 2017-03-08 at 09:23 +0100, Hans de Goede wrote:
>>>>> Using pr_err for things which are not errors is a bad idea. E.g. it
>>>>> will cause the plymouth bootsplash screen to drop back to the text
>>>>> console so that the user can see the error, which is not what we
>>>>> normally want to happen.
>>>>>
>>>>> Instead add a new brcmf_info macro and use that.
>>>>>
>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>> ---
>>>>> Changes in v2:
>>>>> -Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case
>>>>> Changes in v3:
>>>>> -Use do { } while (0) around macro
>>>>
>>>> why?  Single statement macros do not need a do/while
>>>
>>> Because Arend ask me to during review of v2.
>>
>> Well, maybe Arend should learn that single statement macros
>> don't need do/while guards and that do/while guards are
>> generally not used in the kernel for single statements.
>
> Always good to learn from an expert. The intent behind my remark was to
> follow the same pattern as brcmf_err for the sake of consistency. I was
> not clear.

Ok, so what is it going to be, are we going to keep this as is
with the do .. while added or shall I do a v4 dropping it again?

Regards,

Hans
