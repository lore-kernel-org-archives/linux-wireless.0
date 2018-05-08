Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:45441 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753856AbeEHH6g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 03:58:36 -0400
Received: by mail-io0-f194.google.com with SMTP id c9-v6so30967981iob.12
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 00:58:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1525416503-832-1-git-send-email-sean@lano.id.au>
References: <1525416503-832-1-git-send-email-sean@lano.id.au>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 8 May 2018 09:58:34 +0200
Message-ID: <CAPDyKFr62-+EF_GRbUSa=VOQfYa3c3HHZCR_LsN67k1yVkNNFw@mail.gmail.com> (sfid-20180508_095840_477948_07802D06)
Subject: Re: [PATCH] brcmfmac: Add support for bcm43364 wireless chipset
To: Sean Lanigan <sean@lano.id.au>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Molton <ian@mnementh.co.uk>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 May 2018 at 08:48, Sean Lanigan <sean@lano.id.au> wrote:
> Add support for the BCM43364 chipset via an SDIO interface, as used in
> e.g. the Murata 1FX module.
>
> The BCM43364 uses the same firmware as the BCM43430 (which is already
> included), the only difference is the omission of Bluetooth.
>
> However, the SDIO_ID for the BCM43364 is 02D0:A9A4, giving it a MODALIAS
> of sdio:c00v02D0dA9A4, which doesn't get recognised and hence doesn't
> load the brcmfmac module. Adding the 'A9A4' ID in the appropriate place
> triggers the brcmfmac driver to load, and then correctly use the
> firmware file 'brcmfmac43430-sdio.bin'.
>
>
> Signed-off-by: Sean Lanigan <sean@lano.id.au>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Arend, I assume you want to pick this up? If not, just tell and I can do it.

Kind regards
Uffe

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
>  include/linux/mmc/sdio_ids.h                              | 1 +
>  2 files changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index 0b68240..4648a3d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -963,6 +963,7 @@ static const struct sdio_device_id brcmf_sdmmc_ids[] = {
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43340),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43341),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43362),
> +       BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43364),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4335_4339),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4339),
>         BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43430),
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index cdd66a5..0a7abe8 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -35,6 +35,7 @@
>  #define SDIO_DEVICE_ID_BROADCOM_4335_4339      0x4335
>  #define SDIO_DEVICE_ID_BROADCOM_4339           0x4339
>  #define SDIO_DEVICE_ID_BROADCOM_43362          0xa962
> +#define SDIO_DEVICE_ID_BROADCOM_43364          0xa9a4
>  #define SDIO_DEVICE_ID_BROADCOM_43430          0xa9a6
>  #define SDIO_DEVICE_ID_BROADCOM_4345           0x4345
>  #define SDIO_DEVICE_ID_BROADCOM_43455          0xa9bf
> --
> 2.7.4
>
