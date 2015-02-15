Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22346 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbBOIbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 03:31:33 -0500
Message-ID: <54E05961.7000201@broadcom.com> (sfid-20150215_093137_690400_1895BF83)
Date: Sun, 15 Feb 2015 09:31:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Pat Erley <pat-lkml@erley.org>
CC: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
	Kalle Valo <kvalo@codeaurora.org>, <brudley@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>, <meuleman@broadcom.com>,
	<linville@tuxdriver.com>, <pieterpg@broadcom.com>,
	<hdegoede@redhat.com>, <wens@csie.org>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] brcmfmac: avoid duplicated suspend/resume operation
References: <54DC1D7D.5050407@linux.intel.com> <54E0072D.3020802@linux.intel.com> <54E01209.7010300@erley.org>
In-Reply-To: <54E01209.7010300@erley.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/15 04:27, Pat Erley wrote:
> On 02/14/2015 08:40 PM, Fu, Zhonghui wrote:
>>
>> Any comments to this patch? Can it be accepted?

I assume that patches are queued up until after the merge window that we 
are currently in.

>> Thanks,
>> Zhonghui
>>
>> On 2015/2/12 11:26, Fu, Zhonghui wrote:
>>> From a05d35ab334c20970c236fb971dae88810078c88 Mon Sep 17 00:00:00 2001
>>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>> Date: Thu, 12 Feb 2015 10:49:35 +0800
>>> Subject: [PATCH v3] brcmfmac: avoid duplicated suspend/resume operation
>>>
>>> WiFi chip has 2 SDIO functions, and PM core will trigger
>>> twice suspend/resume operations for one WiFi chip to do
>>> the same things. This patch avoid this case.
>>>
>>> Acked-by: Arend van Spriel <arend@broadcom.com>
>>> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>> ---
>>> Changes in v3:
>>> - Rebase to wireless-drivers-next/master branch
>>>
>>> drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 13 ++++++++++++-
>>> 1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>> b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>> index 7944224..b8832a7 100644
>>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>> @@ -1117,9 +1117,13 @@ static int brcmf_ops_sdio_suspend(struct
>>> device *dev)
>>> struct brcmf_bus *bus_if;
>>> struct brcmf_sdio_dev *sdiodev;
>>> mmc_pm_flag_t sdio_flags;
>>> + struct sdio_func *func = dev_to_sdio_func(dev);
>>>
>>> brcmf_dbg(SDIO, "Enter\n");
>>>
>>> + if (func->num == 2)
>>> + return 0;
>>> +
>
> Should it be >= 2 instead of == 2 so that if, in the future, a 3+
> SDIO function chip comes out, it's already handled? Not that that
> should hold up the patch or anything, just a curiosity.

The driver only claims functions 1 and 2 during the probe so that assure 
it works for SDIO devices that have more than two functions.

Regards,
Arend

>>> bus_if = dev_get_drvdata(dev);
>>> sdiodev = bus_if->bus_priv.sdio;
>>>
>>> @@ -1148,9 +1152,16 @@ static int brcmf_ops_sdio_suspend(struct
>>> device *dev)
>>> static int brcmf_ops_sdio_resume(struct device *dev)
>>> {
>>> struct brcmf_bus *bus_if = dev_get_drvdata(dev);
>>> - struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
>>> + struct brcmf_sdio_dev *sdiodev;
>>> + struct sdio_func *func = dev_to_sdio_func(dev);
>>>
>>> brcmf_dbg(SDIO, "Enter\n");
>>> +
>>> + if (func->num == 2)
>>> + return 0;
>>> +
>>> + sdiodev = bus_if->bus_priv.sdio;
>>> +
>>> if (sdiodev->pdata && sdiodev->pdata->oob_irq_supported)
>>> disable_irq_wake(sdiodev->pdata->oob_irq_nr);
>>> brcmf_sdio_wd_timer(sdiodev->bus, BRCMF_WD_POLL_MS);
>>> -- 1.9.1
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>

