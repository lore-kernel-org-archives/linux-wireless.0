Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.cypress.com ([157.95.67.100]:45030 "EHLO
        smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751918AbdHHGxo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 02:53:44 -0400
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH v2 2/3] brcmfmac: Add support for CYW4373 SDIO/USB chipset
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
 <1501753079-1758-2-git-send-email-wright.feng@cypress.com>
 <59885CB5.2040007@broadcom.com>
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <b13203ce-e111-09ac-0339-c79d6767c752@cypress.com> (sfid-20170808_085347_569729_E29088EE)
Date: Tue, 8 Aug 2017 14:53:25 +0800
MIME-Version: 1.0
In-Reply-To: <59885CB5.2040007@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/07/2017 8:27, Arend van Spriel wrote:
> On 8/3/2017 11:37 AM, Wright Feng wrote:
>> From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>>
>> Add support for CYW4373 SDIO/USB chipset.
>> CYW4373 is a 1x1 dual-band 11ac chipset with 20/40/80Mhz channel support.
>> It's a WiFi/BT combo device.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>> ---
>> v2: add new chip(4737) info in commit message
> 
> comment below...
> 
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c     | 1 +
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c       | 4 +++-
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c        | 9 
>> ++++++++-
>>   drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 3 +++
>>   include/linux/mmc/sdio_ids.h                                  | 1 +
>>   6 files changed, 18 insertions(+), 2 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
>> index b733eb4..abacd54 100644
>> --- a/include/linux/mmc/sdio_ids.h
>> +++ b/include/linux/mmc/sdio_ids.h
>> @@ -39,6 +39,7 @@
>>   #define SDIO_DEVICE_ID_BROADCOM_43455        0xa9bf
>>   #define SDIO_DEVICE_ID_BROADCOM_4354        0x4354
>>   #define SDIO_DEVICE_ID_BROADCOM_4356        0x4356
>> +#define SDIO_DEVICE_ID_CYPRESS_4373        0x4373
> 
> So is there no specific Cypress SDIO vendor ID?
There is no Cypress SDIO vid. I believe the legacy chips 4343w ...etc. 
shipped are still using BRCM SDIO vid. Also, 4373 project was initiated 
in Broadcom so the default id was set to the Broadcom id. Will it a 
requirement to add Cypress vid here?


> 
>>   #define SDIO_VENDOR_ID_INTEL            0x0089
>>   #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX    0x1402
>>
> 
> .
> 
