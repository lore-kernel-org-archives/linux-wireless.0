Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33296 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdBUJ5L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 04:57:11 -0500
Received: by mail-qt0-f170.google.com with SMTP id b16so57362438qte.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 01:57:11 -0800 (PST)
Subject: Re: [PATCH V3 2/2] brcmfmac: don't warn user about NVRAM if fallback
 to platform one succeeds
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20170216072636.7128-1-zajec5@gmail.com>
 <20170221094754.15406-1-zajec5@gmail.com>
 <20170221094754.15406-2-zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9ac0557a-2746-bc61-7397-a7fa58a02787@broadcom.com> (sfid-20170221_105739_247965_2D0941D4)
Date: Tue, 21 Feb 2017 10:57:07 +0100
MIME-Version: 1.0
In-Reply-To: <20170221094754.15406-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-2-2017 10:47, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Failing to load NVRAM file isn't critical if we manage to get platform
> one in the fallback path. It means warnings like:
> [   10.801506] brcmfmac 0000:01:00.0: Direct firmware load for brcm/brcmfmac43602-pcie.txt failed with error -2
> are unnecessary & disturbing for people with platform NVRAM. This is
> very common case for Broadcom home routers.
> 
> So instead of printing warning immediately with the firmware subsystem
> let's first try our fallback code. If that fails as well, then it's a
> right moment to print an error.
> 
> This should reduce amount of false reports from users seeing this
> warning while having wireless working perfectly fine.

I think FW_OPT_NO_WARN does not cover all warnings in firmware_class
although I did not check. Anyway...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Update commit message as it wasn't clear enough (thanks Andy) & add extra
>     messages to the firmware.c.
> V3: Set FW_OPT_UEVENT to don't change behavior
> 
> Kalle, Arend: this patch is strictly related to the bigger 1/2. Could you ack
> this change as I expect this patchset to be picked by Ming, Luis or Greg?
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index c7c1e9906500..6dbcceff2529 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -462,8 +462,14 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
>  		raw_nvram = false;
>  	} else {
>  		data = bcm47xx_nvram_get_contents(&data_len);
> -		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
> -			goto fail;
> +		if (!data) {
> +			brcmf_dbg(TRACE, "Failed to get platform NVRAM\n");
> +			if (!(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL)) {
> +				brcmf_err("Loading NVRAM from %s and using platform one both failed\n",
> +					  fwctx->nvram_name);
> +				goto fail;
> +			}
> +		}
>  		raw_nvram = true;
>  	}
>  
> @@ -504,9 +510,10 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
>  		return;
>  	}
>  	fwctx->code = fw;
> -	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
> -				      fwctx->dev, GFP_KERNEL, fwctx,
> -				      brcmf_fw_request_nvram_done);
> +	ret = request_firmware_async(THIS_MODULE,
> +				     FW_OPT_UEVENT | FW_OPT_NO_WARN,
> +				     fwctx->nvram_name, fwctx->dev, GFP_KERNEL,
> +				     fwctx, brcmf_fw_request_nvram_done);
