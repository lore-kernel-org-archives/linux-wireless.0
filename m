Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35481 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbbDVHcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 03:32:33 -0400
Received: by qcbii10 with SMTP id ii10so88813859qcb.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2015 00:32:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429035033-14076-8-git-send-email-arend@broadcom.com>
References: <1429035033-14076-1-git-send-email-arend@broadcom.com>
	<1429035033-14076-8-git-send-email-arend@broadcom.com>
Date: Wed, 22 Apr 2015 09:32:32 +0200
Message-ID: <CAPDyKFqGb81m9ExECL1ZCea8OuhekH+aWiXC=8zafnLN2T02Vw@mail.gmail.com> (sfid-20150422_093251_608847_CCF5C30B)
Subject: Re: [PATCH 07/10] brcmfmac: fix sdio suspend and resume
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 April 2015 at 20:10, Arend van Spriel <arend@broadcom.com> wrote:
> commit 330b4e4be937 ("brcmfmac: Add wowl support for SDIO devices.")
> changed the behaviour by removing the MMC_PM_KEEP_POWER flag for
> non-wowl scenario, which needs to be restored. Another necessary
> change is to mark the card as being non-removable. With this in place
> the suspend resume test passes successfully doing:
>
>  # echo devices > /sys/power/pm_test
>  # echo mem > /sys/power/state
>
> Note that power may still be switched off when system is going
> in S3 state.
>
> Reported-by: Fu, Zhonghui <<zhonghui.fu@linux.intel.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> index 9b508bd..8a69544 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
> @@ -1011,6 +1011,14 @@ static int brcmf_sdiod_remove(struct brcmf_sdio_dev *sdiodev)
>         return 0;
>  }
>
> +static void brcmf_sdiod_host_fixup(struct mmc_host *host)
> +{
> +       /* runtime-pm powers off the device */
> +       pm_runtime_forbid(host->parent);

That you need this, clearly shows that something is broken in the mmc
core/host layer.

Could you elaborate a bit on what configuration you are using. Like
what mmc host, which SDIO bus speed mode.

And have you tested different configurations? Like what happens if you
use a different SDIO bus speed mode?

> +       /* avoid removal detection upon resume */
> +       host->caps |= MMC_CAP_NONREMOVABLE;
> +}
> +
>  static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
>  {
>         struct sdio_func *func;
> @@ -1076,7 +1084,7 @@ static int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
>                 ret = -ENODEV;
>                 goto out;
>         }
> -       pm_runtime_forbid(host->parent);
> +       brcmf_sdiod_host_fixup(host);
>  out:
>         if (ret)
>                 brcmf_sdiod_remove(sdiodev);
> @@ -1246,15 +1254,15 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
>         brcmf_sdiod_freezer_on(sdiodev);
>         brcmf_sdio_wd_timer(sdiodev->bus, 0);
>
> +       sdio_flags = MMC_PM_KEEP_POWER;
>         if (sdiodev->wowl_enabled) {
> -               sdio_flags = MMC_PM_KEEP_POWER;
>                 if (sdiodev->pdata->oob_irq_supported)
>                         enable_irq_wake(sdiodev->pdata->oob_irq_nr);
>                 else
> -                       sdio_flags = MMC_PM_WAKE_SDIO_IRQ;
> -               if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
> -                       brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
> +                       sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
>         }
> +       if (sdio_set_host_pm_flags(sdiodev->func[1], sdio_flags))
> +               brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
>         return 0;
>  }
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Kind regards
Uffe
