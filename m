Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61968 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab1IOHOT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 03:14:19 -0400
Received: by wyh22 with SMTP id 22so2398479wyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2011 00:14:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316028183-33734-1-git-send-email-nbd@openwrt.org>
References: <1316028183-33734-1-git-send-email-nbd@openwrt.org>
Date: Thu, 15 Sep 2011 12:44:17 +0530
Message-ID: <CAD2nsn2G645x00RCLpk7xvT8iBxr+RGN=mdCVAN9jkjKNh7M7Q@mail.gmail.com> (sfid-20110915_091422_929645_E5DAEFEE)
Subject: Re: [PATCH 1/3] ath9k: fix enabling interrupts after a hardware error interrupt
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Thu, Sep 15, 2011 at 12:53 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> The interrupt handler increases the interrupt disable refcount, so the
> tasklet needs to always call ath9k_hw_enable_interrupts.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 8a17cff5..a3c3316 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -669,15 +669,15 @@ void ath9k_tasklet(unsigned long data)
>        u32 status = sc->intrstatus;
>        u32 rxmask;
>
> +       ath9k_ps_wakeup(sc);

this is done in ath_reset, is there any corner cases that I had missed ?

> +       spin_lock(&sc->sc_pcu_lock);

spin_lock_bh(&sc->sc_pcu_lock) in ath_reset_internal, won't be a
problem know, or should we need to move this lock

> +
>        if ((status & ATH9K_INT_FATAL) ||
>            (status & ATH9K_INT_BB_WATCHDOG)) {
>                ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
> -               return;
> +               goto out;
>        }
>
> -       ath9k_ps_wakeup(sc);
> -       spin_lock(&sc->sc_pcu_lock);
> -
>        /*
>         * Only run the baseband hang check if beacons stop working in AP or
>         * IBSS mode, because it has a high false positive rate. For station
> @@ -725,6 +725,7 @@ void ath9k_tasklet(unsigned long data)
>                if (status & ATH9K_INT_GENTIMER)
>                        ath_gen_timer_isr(sc->sc_ah);
>
> +out:
>        /* re-enable hardware interrupt */
>        ath9k_hw_enable_interrupts(ah);


this is done in ath_complete_reset, should we enable interrupts if
some times ath9k_hw_reset fails?
please correct me if I had understood wrongly. thanks!

>
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
