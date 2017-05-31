Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34737 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbdEaLOA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 07:14:00 -0400
Received: by mail-io0-f194.google.com with SMTP id 12so1958244iol.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 04:14:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1496147754-2303-4-git-send-email-arend.vanspriel@broadcom.com>
References: <1496147754-2303-1-git-send-email-arend.vanspriel@broadcom.com> <1496147754-2303-4-git-send-email-arend.vanspriel@broadcom.com>
From: Enric Balletbo Serra <eballetbo@gmail.com>
Date: Wed, 31 May 2017 13:13:59 +0200
Message-ID: <CAFqH_53jVVsY_8g_Bq9yeOqbxQMiDBjwB5sVZfJ=LgbRtmbu7g@mail.gmail.com> (sfid-20170531_131404_951712_471F4C46)
Subject: Re: [RFT 3/3] brcmfmac: unbind all devices upon failure in firmware callback
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-05-30 14:35 GMT+02:00 Arend van Spriel <arend.vanspriel@broadcom.com>:
> In brcmf_sdio_firmware_callback() we need to unbind the driver from
> both sdio_func devices.
>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 270c0ad..a5b27a4 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -3988,14 +3988,14 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
>         u8 saveclk;
>
>         brcmf_dbg(TRACE, "Enter: dev=%s, err=%d\n", dev_name(dev), err);
> +       bus_if = dev_get_drvdata(dev);
> +       sdiodev = bus_if->bus_priv.sdio;
>         if (err)
>                 goto fail;
>
> -       bus_if = dev_get_drvdata(dev);
>         if (!bus_if->drvr)
>                 return;
>
> -       sdiodev = bus_if->bus_priv.sdio;
>         bus = sdiodev->bus;
>
>         /* try to download image and nvram to the dongle */
> @@ -4084,6 +4084,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
>  fail:
>         brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), err);
>         device_release_driver(dev);
> +       device_release_driver(&sdiodev->func[1]->dev);

missing device_release_driver(&sdiodev->func[2]->dev); ?

See my answers to the cover-letter.

>  }
>
>  struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
> --
> 1.9.1
>
