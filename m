Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f175.google.com ([209.85.128.175]:33587 "EHLO
        mail-wr0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdBPIi3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 03:38:29 -0500
Received: by mail-wr0-f175.google.com with SMTP id i10so6519316wrb.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2017 00:38:28 -0800 (PST)
Subject: Re: [PATCH V2 2/2] brcmfmac: don't warn user about NVRAM if fallback
 to platform one succeeds
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20170215222948.21030-1-zajec5@gmail.com>
 <20170216072636.7128-1-zajec5@gmail.com>
 <20170216072636.7128-2-zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d2b1cb64-a829-b433-2370-f2c47b9d0a5d@broadcom.com> (sfid-20170216_093849_014360_654185FA)
Date: Thu, 16 Feb 2017 09:38:23 +0100
MIME-Version: 1.0
In-Reply-To: <20170216072636.7128-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-2-2017 8:26, Rafał Miłecki wrote:
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

There are of course people with issues who take this warning as a straw
to clutch.

> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Update commit message as it wasn't clear enough (thanks Andy) & add extra
>     messages to the firmware.c.
> 
> Kalle, Arend: this patch is strictly related to the bigger 1/2. Could you ack
> this change as I expect this patchset to be picked by Ming, Luis or Greg?
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c  | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index c7c1e9906500..510a76d99eee 100644
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
> @@ -504,9 +510,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
>  		return;
>  	}
>  	fwctx->code = fw;
> -	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
> -				      fwctx->dev, GFP_KERNEL, fwctx,
> -				      brcmf_fw_request_nvram_done);
> +	ret = request_firmware_async(THIS_MODULE, FW_OPT_NO_WARN,
> +				     fwctx->nvram_name, fwctx->dev, GFP_KERNEL,
> +				     fwctx, brcmf_fw_request_nvram_done);

You changed the behaviour, because of your change in patch 1/2:

-	fw_work->opt_flags = FW_OPT_NOWAIT | FW_OPT_FALLBACK |
-		(uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
+	fw_work->opt_flags = FW_OPT_NOWAIT | opt_flags;

So: (FW_OPT_NOWAIT | FW_OPT_UEVENT) vs (FW_OPT_NOWAIT | FW_OPT_NO_WARN)

Regards,
Arend
