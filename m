Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:26369 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbbBELqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 06:46:32 -0500
Message-ID: <54D35814.4070503@broadcom.com> (sfid-20150205_124658_904143_2FAE7F43)
Date: Thu, 5 Feb 2015 12:46:28 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
CC: <brudley@broadcom.com>, Franky Lin <frankyl@broadcom.com>,
	<meuleman@broadcom.com>, Kalle Valo <kvalo@codeaurora.org>,
	<linville@tuxdriver.com>, <pieterpg@broadcom.com>,
	<hdegoede@redhat.com>, <wens@csie.org>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54C5AA8C.4010005@linux.intel.com> <54D35545.7010600@linux.intel.com>
In-Reply-To: <54D35545.7010600@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/15 12:34, Fu, Zhonghui wrote:
> What comments about the new patch?  Can this new patch be accepted?

Hi Zhonghui

Last reply from Kalle was that it did not apply to his tree and 
recommended to use version numbering so "[PATCH V2] <subject>".

> Thanks,
> Zhonghui
>
> On 2015/1/26 10:46, Fu, Zhonghui wrote:
>>  From ff39ed4af9f1c50358fe92ec4c8eaac9db183e00 Mon Sep 17 00:00:00 2001
>> From: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>> Date: Mon, 26 Jan 2015 10:13:21 +0800
>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>>
>> WiFi chip has 2 SDIO functions, and PM core will trigger
>> twice suspend/resume operations for one WiFi chip to do
>> the same things. This patch avoid this case.
>>
>> Acked-by: Arend van Spriel<arend@broadcom.com>
>> Signed-off-by: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>> ---
And when using version info a change log here is even better. Although 
admittedly I lost track which version this would be ;-)

Regards,
Arend
---
>>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |   17 +++++++++++++++--
>>   1 files changed, 15 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> index 9880dae..618b545 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> @@ -1139,11 +1139,17 @@ void brcmf_sdio_wowl_config(struct device *dev, bool enabled)
>>   static int brcmf_ops_sdio_suspend(struct device *dev)
>>   {
>>   	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
>> -	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
>> +	struct brcmf_sdio_dev *sdiodev;
>>   	mmc_pm_flag_t sdio_flags;
>> +	struct sdio_func *func = dev_to_sdio_func(dev);
>>
>>   	brcmf_dbg(SDIO, "Enter\n");
>>
>> +	if (func->num == 2)
>> +		return 0;
>> +
>> +	sdiodev = bus_if->bus_priv.sdio;
>> +
>>   	atomic_set(&sdiodev->suspend, true);
>>
>>   	if (sdiodev->wowl_enabled) {
>> @@ -1164,9 +1170,16 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
>>   static int brcmf_ops_sdio_resume(struct device *dev)
>>   {
>>   	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
>> -	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
>> +	struct brcmf_sdio_dev *sdiodev;
>> +	struct sdio_func *func = dev_to_sdio_func(dev);
>>
>>   	brcmf_dbg(SDIO, "Enter\n");
>> +
>> +	if (func->num == 2)
>> +		return 0;
>> +
>> +	sdiodev = bus_if->bus_priv.sdio;
>> +
>>   	if (sdiodev->pdata&&  sdiodev->pdata->oob_irq_supported)
>>   		disable_irq_wake(sdiodev->pdata->oob_irq_nr);
>>   	brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
>> -- 1.7.1
>>
>

