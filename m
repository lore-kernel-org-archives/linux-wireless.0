Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33822 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdATKaI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:30:08 -0500
Received: by mail-wm0-f53.google.com with SMTP id f73so12891050wmf.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 02:29:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
References: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 20 Jan 2017 11:29:38 +0100
Message-ID: <CAPDyKFom-LpjqRWcP_43wwH0BqS1CNH8Mf6QCLnBohmmwBR_Gg@mail.gmail.com> (sfid-20170120_113016_369009_2EC952D5)
Subject: Re: [PATCH] brcmfmac: add support for BCM43455 with modalias sdio:c00v02D0dA9BF
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 January 2017 at 11:17, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> BCM43455 is a more recent revision of the BCM4345. Some of the BCM43455
> got a dedicated SDIO device ID which is currently not supported by
> brcmfmac.
> Adding the new sdio_device_id to brcmfmac is enough to get the BCM43455
> supported because the chip itself is already supported (due to BCM4345
> support in the driver).
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

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
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4345),
> +       BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43455),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
>         { /* end: all zeroes */ }
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index d43ef96bf075..71b113e1223f 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -36,6 +36,7 @@
>  #define SDIO_DEVICE_ID_BROADCOM_43362          0xa962
>  #define SDIO_DEVICE_ID_BROADCOM_43430          0xa9a6
>  #define SDIO_DEVICE_ID_BROADCOM_4345           0x4345
> +#define SDIO_DEVICE_ID_BROADCOM_43455          0xa9bf
>  #define SDIO_DEVICE_ID_BROADCOM_4354           0x4354
>  #define SDIO_DEVICE_ID_BROADCOM_4356           0x4356
>
> --
> 2.11.0
>
