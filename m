Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54483 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298AbbD1QOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 12:14:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/10] brcmfmac: fix sdio suspend and resume
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-8-git-send-email-arend@broadcom.com>
	<CAPDyKFqGb81m9ExECL1ZCea8OuhekH+aWiXC=8zafnLN2T02Vw@mail.gmail.com>
Date: Tue, 28 Apr 2015 19:14:25 +0300
In-Reply-To: <CAPDyKFqGb81m9ExECL1ZCea8OuhekH+aWiXC=8zafnLN2T02Vw@mail.gmail.com>
	(Ulf Hansson's message of "Wed, 22 Apr 2015 09:32:32 +0200")
Message-ID: <87egn45ixq.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_181434_360488_F5D56B4E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ulf Hansson <ulf.hansson@linaro.org> writes:

> On 14 April 2015 at 20:10, Arend van Spriel <arend@broadcom.com> wrote:
>> commit 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
>> changed the behaviour by removing the MMC_PM_KEEP_POWER flag for
>> non-wowl scenario, which needs to be restored. Another necessary
>> change is to mark the card as being non-removable. With this in place
>> the suspend resume test passes successfully doing:
>>
>>  # echo devices > /sys/power/pm_test
>>  # echo mem > /sys/power/state
>>
>> Note that power may still be switched off when system is going
>> in S3 state.
>>
>> Reported-by: Fu, Zhonghui <<zhonghui.fu@linux.intel.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> index 9b508bd..8a69544 100644
>> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
>> @@ -1011,6 +1011,14 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
>>         return 0;
>>  }
>>
>> +static void brcmf_sdiod_host_fixup(struct mmc_host *host)
>> +{
>> +       /* runtime-pm powers off the device */
>> +       pm_runtime_forbid(host->parent);
>
> That you need this, clearly shows that something is broken in the mmc
> core/host layer.
>
> Could you elaborate a bit on what configuration you are using. Like
> what mmc host, which SDIO bus speed mode.
>
> And have you tested different configurations? Like what happens if you
> use a different SDIO bus speed mode?

So what should I do with this patch? Good to commit still?

-- 
Kalle Valo
