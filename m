Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34560 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbdAPKuR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 05:50:17 -0500
Received: by mail-pf0-f172.google.com with SMTP id e4so14489827pfg.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 02:50:17 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: add support for BCM43455 with modalias
 sdio:c00v02D0dA9BF
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-mmc@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        ulf.hansson@linaro.org
References: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2e008b34-9da9-2278-b3f4-039db6397499@broadcom.com> (sfid-20170116_115021_240625_1A7B83DA)
Date: Mon, 16 Jan 2017 11:50:11 +0100
MIME-Version: 1.0
In-Reply-To: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-1-2017 11:17, Martin Blumenstingl wrote:
> BCM43455 is a more recent revision of the BCM4345. Some of the BCM43455
> got a dedicated SDIO device ID which is currently not supported by
> brcmfmac.
> Adding the new sdio_device_id to brcmfmac is enough to get the BCM43455
> supported because the chip itself is already supported (due to BCM4345
> support in the driver).

Hopefully Kalle can take this through his tree, ie. wireless-drivers-next.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> This is the proper patch following the (short) discussion from [0]
> 
> [0] https://marc.info/?l=linux-wireless&m=148455981002310&w=2
> 
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
>  include/linux/mmc/sdio_ids.h                              | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 72139b579b18..5bc2ba214735 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -1104,6 +1104,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345),
> +	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
>  	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
>  	{ /* end: all zeroes */ }
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index d43ef96bf075..71b113e1223f 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -36,6 +36,7 @@
>  #define SDIO_DEVICE_ID_BROADCOM_43362		0xa962
>  #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
>  #define SDIO_DEVICE_ID_BROADCOM_4345		0x4345
> +#define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
>  #define SDIO_DEVICE_ID_BROADCOM_4354		0x4354
>  #define SDIO_DEVICE_ID_BROADCOM_4356		0x4356
>  
> 
