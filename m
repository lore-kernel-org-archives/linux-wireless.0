Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34172 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbbEDLQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 07:16:59 -0400
Received: by qkgx75 with SMTP id x75so82265182qkg.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 04:16:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <553FBA3B.5010507@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-8-git-send-email-arend@broadcom.com>
	<CAPDyKFqGb81m9ExECL1ZCea8OuhekH+aWiXC=8zafnLN2T02Vw@mail.gmail.com>
	<87egn45ixq.fsf@kamboji.qca.qualcomm.com>
	<553FBA3B.5010507@broadcom.com>
Date: Mon, 4 May 2015 13:16:58 +0200
Message-ID: <CAPDyKFoPt5tDLYMFoqiprD4sc3R_s5_wOci-ranbq6TGskHtHQ@mail.gmail.com> (sfid-20150504_131703_676631_DB4A3BFB)
Subject: Re: [PATCH 07/10] brcmfmac: fix sdio suspend and resume
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Arend van Spriel <arend@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 April 2015 at 18:50, Arend van Spriel <arend@broadcom.com> wrote:
> On 04/28/15 18:14, Kalle Valo wrote:
>>
>> Ulf Hansson<ulf.hansson@linaro.org>  writes:
>>
>>> On 14 April 2015 at 20:10, Arend van Spriel<arend@broadcom.com>  wrote:
>>>>
>>>> commit 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
>>>> changed the behaviour by removing the MMC_PM_KEEP_POWER flag for
>>>> non-wowl scenario, which needs to be restored. Another necessary
>>>> change is to mark the card as being non-removable. With this in place
>>>> the suspend resume test passes successfully doing:
>>>>
>>>>   # echo devices>  /sys/power/pm_test
>>>>   # echo mem>  /sys/power/state
>>>>
>>>> Note that power may still be switched off when system is going
>>>> in S3 state.
>>>>
>>>> Reported-by: Fu, Zhonghui<<zhonghui.fu@linux.intel.com>
>>>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>>>> Reviewed-by: Franky (Zhenhui) Lin<frankyl@broadcom.com>
>>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>>> ---
>>>>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 18
>>>> +++++++++++++-----
>>>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>>> b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>>> index 9b508bd..8a69544 100644
>>>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>>>> @@ -1011,6 +1011,14 @@ static int brcmf_sdiod_remove(struct
>>>> brcmf_sdio_dev *sdiodev)
>>>>          return 0;
>>>>   }
>>>>
>>>> +static void brcmf_sdiod_host_fixup(struct mmc_host *host)
>>>> +{
>>>> +       /* runtime-pm powers off the device */
>>>> +       pm_runtime_forbid(host->parent);
>>>
>>>
>>> That you need this, clearly shows that something is broken in the mmc
>>> core/host layer.
>>>
>>> Could you elaborate a bit on what configuration you are using. Like
>>> what mmc host, which SDIO bus speed mode.
>>>
>>> And have you tested different configurations? Like what happens if you
>>> use a different SDIO bus speed mode?
>>
>>
>> So what should I do with this patch? Good to commit still?
>
>
> I think so, but I am biased ;-) Seriously, this enables people that have
> brcmfmac devices hooked up through runtime-pm capable host controllers to
> use wifi. So while we need to work to proper runtime-pm support for SDIO
> function drivers with proper interaction with the MMC stack this patch
> provides a short term solution/workaround at the cost of being a bit less
> power efficient.

I agree that this seems to be the only viable short-term solution.
The only concern I have, is that we might drop the focus to find a
proper long-term solution. But, let's try to avoid that.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe
