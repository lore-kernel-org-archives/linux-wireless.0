Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:32806 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbbE1Qsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 12:48:35 -0400
Received: by iebgx4 with SMTP id gx4so42972248ieb.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 09:48:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432747901-8472-1-git-send-email-arend@broadcom.com>
References: <1432747901-8472-1-git-send-email-arend@broadcom.com>
Date: Thu, 28 May 2015 12:48:34 -0400
Message-ID: <CAKf6xpuhDdRyQoYMxCQOkSvVzESkbWe=i4OvKm7C6hVRth6foA@mail.gmail.com> (sfid-20150528_184842_503195_F4D907F6)
Subject: Re: [PATCH] brcmfmac: fix invalid access to struct acpi_device fields
From: Jason Andryuk <jandryuk@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2015 at 1:31 PM, Arend van Spriel <arend@broadcom.com> wrote:
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index b0d0ff5..71779b9 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -1117,6 +1117,18 @@ MODULE_DEVICE_TABLE(sdio, brcmf_sdmmc_ids);
>  static struct brcmfmac_sdio_platform_data *brcmfmac_sdio_pdata;
>
>
> +static void brcmf_sdiod_acpi_set_power_manageable(struct device *dev,
> +                                                 int val)
> +{
> +#if IS_ENABLED(CONFIG_ACPI)
> +       struct acpi_device *adev;
> +
> +       adev = ACPI_COMPANION(dev);
> +       if (adev)
> +               adev->flags.power_manageable = 0;

Shouldn't this be " = val"?

-Jason

> +#endif
> +}
> +
>  static int brcmf_ops_sdio_probe(struct sdio_func *func,
>                                 const struct sdio_device_id *id)
>  {
