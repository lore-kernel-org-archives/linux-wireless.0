Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46024 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754458AbeDTK0s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:26:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com,
        ckoenig.leichtzumerken@gmail.com, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 9/9] brcmfmac: use request_firmware_nowait2 to load firmware without warnings
References: <20180417153307.3693-1-andresx7@gmail.com>
        <20180417153307.3693-10-andresx7@gmail.com>
Date: Fri, 20 Apr 2018 13:26:42 +0300
In-Reply-To: <20180417153307.3693-10-andresx7@gmail.com> (Andres Rodriguez's
        message of "Tue, 17 Apr 2018 11:33:07 -0400")
Message-ID: <87h8o6i36l.fsf@kamboji.qca.qualcomm.com> (sfid-20180420_122715_322678_7F0346F7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andres Rodriguez <andresx7@gmail.com> writes:

> This reduces the unnecessary spew when trying to load optional firmware:
> "Direct firmware load for ... failed with error -2"
>
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

With wireless patches always CC linux-wireless list, please. Adding it
now.

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> index 091b52979e03..26db3ebd52dc 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
> @@ -503,8 +503,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
>  		goto done;
>  
>  	fwctx->code = fw;
> -	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
> -				      fwctx->dev, GFP_KERNEL, fwctx,
> +	ret = request_firmware_nowait(THIS_MODULE, true, false,

A perfect example why enums should be in function calls instead of
booleans, that "true, false" tells nothing to me and it would be time
consuming to check from headers files what it means. If you had proper
enums, for example "FIRMWARE_MODE_FOO, FIRMWARE_STATE_BAR", it would be
immediately obvious for the reader what the parameters are. Of course
the first boolean was already there before, but maybe change the new
boolean to an enum?

> +				      fwctx->nvram_name, fwctx->dev,
> +				      GFP_KERNEL, fwctx,
>  				      brcmf_fw_request_nvram_done);
>  
>  	/* pass NULL to nvram callback for bcm47xx fallback */
> @@ -547,7 +548,7 @@ int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
>  	fwctx->domain_nr = domain_nr;
>  	fwctx->bus_nr = bus_nr;
>  
> -	return request_firmware_nowait(THIS_MODULE, true, code, dev,
> +	return request_firmware_nowait2(THIS_MODULE, true, false, code, dev,
>  				       GFP_KERNEL, fwctx,
>  				       brcmf_fw_request_code_done);
>  }

Also the number two in the function name is not really telling anything.
I think that something like request_firmware_nowait_nowarn() would be
better, even if it's so ugly.

-- 
Kalle Valo
