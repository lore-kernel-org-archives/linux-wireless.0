Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:46044 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966503AbeF2Pjs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 11:39:48 -0400
Received: by mail-io0-f194.google.com with SMTP id l25-v6so8808798ioh.12
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 08:39:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180627185845.31799-1-daniel@zonque.org>
References: <20180627185845.31799-1-daniel@zonque.org>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Fri, 29 Jun 2018 17:39:47 +0200
Message-ID: <CAPDyKFr7snWsk=194u4nKs4301tUARByuEPSFop_fzxn6HVQDQ@mail.gmail.com> (sfid-20180629_173955_605827_32E4DAD2)
Subject: Re: [PATCH v2] libertas: fix suspend and resume for SDIO connected cards
To: Daniel Mack <daniel@zonque.org>
Cc: Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 June 2018 at 20:58, Daniel Mack <daniel@zonque.org> wrote:
> Prior to commit 573185cc7e64 ("mmc: core: Invoke sdio func driver's PM
> callbacks from the sdio bus"), the MMC core used to call into the power
> management functions of SDIO clients itself and removed the card if the
> return code was non-zero. IOW, the mmc handled errors gracefully and didn=
't
> upchain them to the pm core.
>
> Since this change, the mmc core relies on generic power management
> functions which treat all errors as a reason to cancel the suspend
> immediately. This causes suspend attempts to fail when the libertas
> driver is loaded.
>
> To fix this, power down the card explicitly in if_sdio_suspend() when we
> know we're about to lose power and return success. Also set a flag in the=
se
> cases, and power up the card again in if_sdio_resume().
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Chris Ball <chris@printf.net>

Looks good to me! Should be a candidate for stable as well!?

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

I have some additional related changes in mind for the libertas SDIO
driver, however let me post patches for us to discuss around instead.

Kind regards
Uffe

> ---
> v1 =E2=86=92 v2:
> * Reworded patch subject
> * Added wait_event(card->pwron_waitq, card->priv->fw_ready)
>
>  drivers/net/wireless/marvell/libertas/dev.h   |  1 +
>  .../net/wireless/marvell/libertas/if_sdio.c   | 30 +++++++++++++++----
>  2 files changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas/dev.h b/drivers/net/wi=
reless/marvell/libertas/dev.h
> index dd1ee1f0af48..469134930026 100644
> --- a/drivers/net/wireless/marvell/libertas/dev.h
> +++ b/drivers/net/wireless/marvell/libertas/dev.h
> @@ -104,6 +104,7 @@ struct lbs_private {
>         u8 fw_ready;
>         u8 surpriseremoved;
>         u8 setup_fw_on_resume;
> +       u8 power_up_on_resume;
>         int (*hw_host_to_card) (struct lbs_private *priv, u8 type, u8 *pa=
yload, u16 nb);
>         void (*reset_card) (struct lbs_private *priv);
>         int (*power_save) (struct lbs_private *priv);
> diff --git a/drivers/net/wireless/marvell/libertas/if_sdio.c b/drivers/ne=
t/wireless/marvell/libertas/if_sdio.c
> index 2300e796c6ab..43743c26c071 100644
> --- a/drivers/net/wireless/marvell/libertas/if_sdio.c
> +++ b/drivers/net/wireless/marvell/libertas/if_sdio.c
> @@ -1290,15 +1290,23 @@ static void if_sdio_remove(struct sdio_func *func=
)
>  static int if_sdio_suspend(struct device *dev)
>  {
>         struct sdio_func *func =3D dev_to_sdio_func(dev);
> -       int ret;
>         struct if_sdio_card *card =3D sdio_get_drvdata(func);
> +       struct lbs_private *priv =3D card->priv;
> +       int ret;
>
>         mmc_pm_flag_t flags =3D sdio_get_host_pm_caps(func);
> +       priv->power_up_on_resume =3D false;
>
>         /* If we're powered off anyway, just let the mmc layer remove the
>          * card. */
> -       if (!lbs_iface_active(card->priv))
> -               return -ENOSYS;
> +       if (!lbs_iface_active(priv)) {
> +               if (priv->fw_ready) {
> +                       priv->power_up_on_resume =3D true;
> +                       if_sdio_power_off(card);
> +               }
> +
> +               return 0;
> +       }
>
>         dev_info(dev, "%s: suspend: PM flags =3D 0x%x\n",
>                  sdio_func_id(func), flags);
> @@ -1306,9 +1314,14 @@ static int if_sdio_suspend(struct device *dev)
>         /* If we aren't being asked to wake on anything, we should bail o=
ut
>          * and let the SD stack power down the card.
>          */
> -       if (card->priv->wol_criteria =3D=3D EHS_REMOVE_WAKEUP) {
> +       if (priv->wol_criteria =3D=3D EHS_REMOVE_WAKEUP) {
>                 dev_info(dev, "Suspend without wake params -- powering do=
wn card\n");
> -               return -ENOSYS;
> +               if (priv->fw_ready) {
> +                       priv->power_up_on_resume =3D true;
> +                       if_sdio_power_off(card);
> +               }
> +
> +               return 0;
>         }
>
>         if (!(flags & MMC_PM_KEEP_POWER)) {
> @@ -1321,7 +1334,7 @@ static int if_sdio_suspend(struct device *dev)
>         if (ret)
>                 return ret;
>
> -       ret =3D lbs_suspend(card->priv);
> +       ret =3D lbs_suspend(priv);
>         if (ret)
>                 return ret;
>
> @@ -1336,6 +1349,11 @@ static int if_sdio_resume(struct device *dev)
>
>         dev_info(dev, "%s: resume: we're back\n", sdio_func_id(func));
>
> +       if (card->priv->power_up_on_resume) {
> +               if_sdio_power_on(card);
> +               wait_event(card->pwron_waitq, card->priv->fw_ready);
> +       }
> +
>         ret =3D lbs_resume(card->priv);
>
>         return ret;
> --
> 2.17.1
>
