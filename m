Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36842 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdHHJgi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 05:36:38 -0400
Received: by mail-wm0-f53.google.com with SMTP id t201so2403452wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 02:36:38 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] brcmfmac: Add support for CYW4373 SDIO/USB chipset
To: chi-hsien.lin@cypress.com, Wright Feng <wright.feng@cypress.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
 <1501753079-1758-2-git-send-email-wright.feng@cypress.com>
 <59885CB5.2040007@broadcom.com>
 <b13203ce-e111-09ac-0339-c79d6767c752@cypress.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <23cc6e03-c859-8ff6-f0aa-3dfcd3f3fbe4@broadcom.com> (sfid-20170808_113642_891841_0DD8A774)
Date: Tue, 8 Aug 2017 11:36:36 +0200
MIME-Version: 1.0
In-Reply-To: <b13203ce-e111-09ac-0339-c79d6767c752@cypress.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08-08-17 08:53, Chi-Hsien Lin wrote:
> 
> 
> On 08/07/2017 8:27, Arend van Spriel wrote:
>> On 8/3/2017 11:37 AM, Wright Feng wrote:
>>> From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>>>
>>> Add support for CYW4373 SDIO/USB chipset.
>>> CYW4373 is a 1x1 dual-band 11ac chipset with 20/40/80Mhz channel
>>> support.
>>> It's a WiFi/BT combo device.
>>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>>> ---
>>> v2: add new chip(4737) info in commit message
>>
>> comment below...
>>
>>> ---
>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c     | 1 +
>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       | 4 +++-
>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 9
>>> ++++++++-
>>>   drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 3 +++
>>>   include/linux/mmc/sdio_ids.h                                  | 1 +
>>>   6 files changed, 18 insertions(+), 2 deletions(-)
>>>
>>
>> [...]
>>
>>> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
>>> index b733eb4..abacd54 100644
>>> --- a/include/linux/mmc/sdio_ids.h
>>> +++ b/include/linux/mmc/sdio_ids.h
>>> @@ -39,6 +39,7 @@
>>>   #define SDIO_DEVICE_ID_BROADCOM_43455        0xa9bf
>>>   #define SDIO_DEVICE_ID_BROADCOM_4354        0x4354
>>>   #define SDIO_DEVICE_ID_BROADCOM_4356        0x4356
>>> +#define SDIO_DEVICE_ID_CYPRESS_4373        0x4373
>>
>> So is there no specific Cypress SDIO vendor ID?
> There is no Cypress SDIO vid. I believe the legacy chips 4343w ...etc.
> shipped are still using BRCM SDIO vid. Also, 4373 project was initiated
> in Broadcom so the default id was set to the Broadcom id. Will it a
> requirement to add Cypress vid here?

I was just wondering about it. It seems appropriate to do so although I
understand the 4373 history of things. Also for USB (in this same patch)
you seem to have used a Cypress USB vendor id so things just did not
look consistent. Hence I raised my comment.

Regards,
Arend

>>
>>>   #define SDIO_VENDOR_ID_INTEL            0x0089
>>>   #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX    0x1402
>>>
>>
>> .
>>
