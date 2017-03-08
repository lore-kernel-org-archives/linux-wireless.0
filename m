Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751772AbdCHKdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 05:33:01 -0500
Subject: Re: [PATCH v2 1/4] brcmfmac: Do not print the firmware version as an
 error
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <5f6bb4d4-1bf1-cd5b-96ba-fc45e641aa95@broadcom.com>
 <6c1dd576-7571-e85f-ee43-8e9e69a76679@redhat.com>
 <ecb4cc58-8cf5-1ca6-7649-fe4e97ac2149@broadcom.com>
 <87a88w851p.fsf@kamboji.qca.qualcomm.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <8cd33792-0a44-fbce-f485-218b8c126625@redhat.com> (sfid-20170308_113315_102511_7CEAED5E)
Date: Wed, 8 Mar 2017 11:08:27 +0100
MIME-Version: 1.0
In-Reply-To: <87a88w851p.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HI,

On 08-03-17 10:57, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 8-3-2017 9:23, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 07-03-17 10:59, Arend Van Spriel wrote:
>>>> On 27-2-2017 22:45, Hans de Goede wrote:
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
>>>>> ---
>>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>>>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 3 +++
>>>>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git
>>>>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>>>>> index 3e15d64..6d565f1 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>>>>> @@ -161,7 +161,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>>>>>      strsep(&ptr, "\n");
>>>>>
>>>>>      /* Print fw version info */
>>>>> -    brcmf_err("Firmware version = %s\n", buf);
>>>>> +    brcmf_info("Firmware version = %s\n", buf);
>>>>>
>>>>>      /* locate firmware version number for ethtool */
>>>>>      ptr = strrchr(buf, ' ') + 1;
>>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>>>>> index 6687812..605f260 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>>>>> @@ -59,11 +59,14 @@
>>>>>              pr_err("%s: " fmt, __func__, ##__VA_ARGS__);    \
>>>>>      } while (0)
>>>>>  #endif
>>>>> +#define brcmf_info(fmt, ...)    pr_info("%s: " fmt, __func__,
>>>>> ##__VA_ARGS__)
>>>>
>>>> Prefer using the same style as for brcmf_err, ie. using do {} while (0)
>>>
>>> OK, v3 with this fixed coming up.
>>
>> I think Kalle prefers the whole series to be resubmitted.
>>
>> Kalle,
>>
>> Can you confirm (or deny)?
>
> Exactly, I want to apply the full series (with the highest version
> number). Not waste time guessing what patches I should take and what to
> drop, with the increased risk of guessing wrong.

Ok, so patch 2/4 is still under discussion (and may be so for a while)
shall I send a new version with that patch dropped ?  And then send
that patch (or a modified version) separately later ?

Regards,

Hans

>
