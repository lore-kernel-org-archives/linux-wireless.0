Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:16940 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbbE1SbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 14:31:08 -0400
Message-ID: <55675EE6.4020505@broadcom.com> (sfid-20150528_203112_692849_A535E632)
Date: Thu, 28 May 2015 20:31:02 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jason Andryuk <jandryuk@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Subject: Re: [PATCH] brcmfmac: fix invalid access to struct acpi_device fields
References: <1432747901-8472-1-git-send-email-arend@broadcom.com> <CAKf6xpuhDdRyQoYMxCQOkSvVzESkbWe=i4OvKm7C6hVRth6foA@mail.gmail.com>
In-Reply-To: <CAKf6xpuhDdRyQoYMxCQOkSvVzESkbWe=i4OvKm7C6hVRth6foA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/28/15 18:48, Jason Andryuk wrote:
> On Wed, May 27, 2015 at 1:31 PM, Arend van Spriel<arend@broadcom.com>  wrote:
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> index b0d0ff5..71779b9 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> @@ -1117,6 +1117,18 @@ MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
>>   static struct brcmfmac_sdio_platform_data *brcmfmac_sdio_pdata;
>>
>>
>> +static void brcmf_sdiod_acpi_set_power_manageable(struct device *dev,
>> +                                                 int val)
>> +{
>> +#if IS_ENABLED(CONFIG_ACPI)
>> +       struct acpi_device *adev;
>> +
>> +       adev = ACPI_COMPANION(dev);
>> +       if (adev)
>> +               adev->flags.power_manageable = 0;
>
> Shouldn't this be " = val"?

Definitely. The only place where it is called uses 0 for val parameter 
so there is no big issue, but I will fix it.

Thanks for spotting that bit.

Regards,
Arend

> -Jason
>
>> +#endif
>> +}
>> +
>>   static int brcmf_ops_sdio_probe(struct sdio_func *func,
>>                                  const struct sdio_device_id *id)
>>   {

