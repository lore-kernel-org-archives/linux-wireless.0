Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36566 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdJAWrU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Oct 2017 18:47:20 -0400
Received: by mail-wr0-f195.google.com with SMTP id k10so2738163wrk.3
        for <linux-wireless@vger.kernel.org>; Sun, 01 Oct 2017 15:47:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1506793068-27445-3-git-send-email-alagusankar@silex-india.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com> <1506793068-27445-3-git-send-email-alagusankar@silex-india.com>
From: Steve deRosier <derosier@gmail.com>
Date: Sun, 1 Oct 2017 15:47:18 -0700
Message-ID: <CALLGbR+-G6pKcSPZo=xxJ66iQ0aMJo9xWWq8raSTt5rSASrM=w@mail.gmail.com> (sfid-20171002_004552_595687_1EADD2BC)
Subject: Re: [PATCH 02/11] ath10k_sdio: wb396 reference card fix
To: silexcommon@gmail.com
Cc: ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Alagu Sankar <alagusankar@silex-india.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alagu,


On Sat, Sep 30, 2017 at 10:37 AM, <silexcommon@gmail.com> wrote:
>
> From: Alagu Sankar <alagusankar@silex-india.com>
>
> The QCA9377-3 WB396 sdio reference card does not get initialized
> due to the conflict in uart gpio pins. This fix is not required
> for other QCA9377 sdio cards.
>
> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index b4f66cd..86247c8 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1708,8 +1708,15 @@ static int ath10k_init_uart(struct ath10k *ar)
>                 return ret;
>         }
>
> -       if (!uart_print)
> +       if (!uart_print) {
> +               /* Hack: override dbg TX pin to avoid side effects of default
> +                * GPIO_6 in QCA9377 WB396 reference card
> +                */
> +               if (ar->hif.bus == ATH10K_BUS_SDIO)
> +                       ath10k_bmi_write32(ar, hi_dbg_uart_txpin,
> +                                          ar->hw_params.uart_pin);

If it is indeed a "hack", then I don't think the maintainer should
accept this upstream. If you want it upstream you need a clean enough
implementation that doesn't need to be labeled a "hack".

Your commit message states that this is only needed for a very
specific card and not for other QCA9377 sdio cards. Yet, you're doing
this for all ATH10K_BUS_SDIO devices. Not good. I think that it's a
quirk and it's limited to a particular implementation of the device.
My suggestion: if it can be automatically determined, then do so
explicitly. If not, then it needs to be a DT setting or a module
parameter or something like that so the platform maker can decide to
do it. Having it affect all users of a SDIO QCA9377 when it doesn't
apply doesn't seem like a good idea to me.


- Steve
