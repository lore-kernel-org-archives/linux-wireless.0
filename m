Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:44348 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750954AbeAOTkg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 14:40:36 -0500
Received: by mail-wm0-f66.google.com with SMTP id t74so3987600wme.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 11:40:36 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Make sure CLM downloading is optional
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180115171053.8802-1-bjorn.andersson@linaro.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5D03B2.3070002@broadcom.com> (sfid-20180115_204147_516762_4C352FF4)
Date: Mon, 15 Jan 2018 20:40:34 +0100
MIME-Version: 1.0
In-Reply-To: <20180115171053.8802-1-bjorn.andersson@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/15/2018 6:10 PM, Bjorn Andersson wrote:
> The presence of a CLM file is described as optional, but missing the clm
> blob causes the preinit to return unsuccessfully. Fix this by ignoring
> the return value of the brcmf_c_process_clm_blob().
>
> Also remove the extra debug print, as brcmf_c_process_clm_blob() already
> did print a useful error message before returning.
>
> Fixes: fdd0bd88ceae ("brcmfmac: add CLM download support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>
> This regression was introduced in v4.15-rc1, but I unfortunately didn't test
> WiFi until now. Included a Cc to stable@ in case you choose to pick this up
> after v4.15.

Hi Bjorn,

Thanks for looking into this. Actually there already have been a couple 
of fixes posted on the linux-wireless list. [1] was rejected, [2] is 
being discussed, and [2] was posted by me and I was awaiting response 
from the guy reporting it.

Now the thing is that for old (Broadcom) firmware this is optional. 
Those firmwares don't even have CLM support and those that do have the 
CLM data embedded in firmware. However, Cypress wants to provide their 
customers with firmware without CLM data. For those devices it is not 
optional. I still prefer we add a mechanism to the driver to detect 
that, but we do not have that yet.

Now regarding your patch some comments below ...

>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> index 6a59d0609d30..0c67ba6ae135 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> @@ -278,12 +278,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>   	}
>   	ri->result = err;
>
> -	/* Do any CLM downloading */
> -	err = brcmf_c_process_clm_blob(ifp);
> -	if (err < 0) {
> -		brcmf_err("download CLM blob file failed, %d\n", err);
> -		goto done;
> -	}
> +	/* Do any optional CLM downloading */
> +	brcmf_c_process_clm_blob(ifp);

The error print is indeed redundant and should be removed here. However, 
brcmf_c_process_clm_blob() also returns -ENOMEM upon allocation failure 
and I would still fail the driver probe for that.

Regards,
Arend

[1] https://patchwork.kernel.org/patch/10106571/
[2] https://patchwork.kernel.org/patch/10159731/
[3] https://patchwork.kernel.org/patch/10154595/
