Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:57376 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaLWRIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 12:08:11 -0500
Message-ID: <5499A15E.9080307@broadcom.com> (sfid-20141223_180814_336978_C604CB76)
Date: Tue, 23 Dec 2014 18:07:42 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 02/10] brcmfmac: Fix possible dereference of NULL pointer.
References: <1419162233-19492-1-git-send-email-arend@broadcom.com> <1419162233-19492-3-git-send-email-arend@broadcom.com>
In-Reply-To: <1419162233-19492-3-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/14 12:43, Arend van Spriel wrote:
> From: Hante Meuleman<meuleman@broadcom.com>
>
> With the introduction of WOWL for SDIO a possible dereference of a
> NULL pointer got introduced. Found by static checker.

Kalle,

Can you drop this patch and take the one from Mika instead with 
Message-ID: 
1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com [1]

Regards,
Arend

[1] 
http://mid.gmane.org/1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com

> Reported-by: Dan Carpenter<dan.carpenter@oracle.com>
> Reviewed-by: Arend Van Spriel<arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman<meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel<arend@broadcom.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 3c06e93..9583dcd 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -1070,7 +1070,7 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
>   	 */
>   	if ((sdio_get_host_pm_caps(sdiodev->func[1])&  MMC_PM_KEEP_POWER)&&
>   	((sdio_get_host_pm_caps(sdiodev->func[1])&  MMC_PM_WAKE_SDIO_IRQ) ||
> -	     (sdiodev->pdata->oob_irq_supported)))
> +	     ((sdiodev->pdata)&&  (sdiodev->pdata->oob_irq_supported))))
>   		bus_if->wowl_supported = true;
>   #endif
>

