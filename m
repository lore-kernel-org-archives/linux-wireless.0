Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:48164 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1IVFtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 01:49:21 -0400
Received: by gwj16 with SMTP id 16so1308296gwj.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 22:49:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316028267-34187-9-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
	<1316028267-34187-2-git-send-email-nbd@openwrt.org>
	<1316028267-34187-3-git-send-email-nbd@openwrt.org>
	<1316028267-34187-4-git-send-email-nbd@openwrt.org>
	<1316028267-34187-5-git-send-email-nbd@openwrt.org>
	<1316028267-34187-6-git-send-email-nbd@openwrt.org>
	<1316028267-34187-7-git-send-email-nbd@openwrt.org>
	<1316028267-34187-8-git-send-email-nbd@openwrt.org>
	<1316028267-34187-9-git-send-email-nbd@openwrt.org>
Date: Thu, 22 Sep 2011 11:19:20 +0530
Message-ID: <CAJqpcCQ9gpKG1ivvDReSyvMq9i5kxwDmRZwvNbYfRhwByOOC4w@mail.gmail.com> (sfid-20110922_074930_925203_E4A39593)
Subject: Re: [PATCH 09/12] ath9k: optimize ath9k_ps_restore
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 15, 2011 at 12:54 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> ath_hw_cycle_counters_update only needs to be called if the power state
> changes. Most of the time this does not happen, even when ps_usecount
> goes down to 0.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/main.c |   17 +++++++++++------
>  1 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index a75810a..a16f539 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -111,24 +111,29 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
>  void ath9k_ps_restore(struct ath_softc *sc)
>  {
>        struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +       enum ath9k_power_mode mode;
>        unsigned long flags;
>
>        spin_lock_irqsave(&sc->sc_pm_lock, flags);
>        if (--sc->ps_usecount != 0)
>                goto unlock;
>
> -       spin_lock(&common->cc_lock);
> -       ath_hw_cycle_counters_update(common);
> -       spin_unlock(&common->cc_lock);
> -
>        if (sc->ps_idle)
> -               ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_FULL_SLEEP);
> +               mode = ATH9K_PM_FULL_SLEEP;
>        else if (sc->ps_enabled &&
>                 !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
>                              PS_WAIT_FOR_CAB |
>                              PS_WAIT_FOR_PSPOLL_DATA |
>                              PS_WAIT_FOR_TX_ACK)))
> -               ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
> +               mode = ATH9K_PM_NETWORK_SLEEP;

What is the use of setting the mode above if you use NETWORK_SLEEP by
default in the below code.

> +       else
> +               goto unlock;
> +
> +       spin_lock(&common->cc_lock);
> +       ath_hw_cycle_counters_update(common);
> +       spin_unlock(&common->cc_lock);
> +
> +       ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);

huh???

It shows this patch was never tested and please clarify what you tried
to achieve with this patch. Do you ever test a patch before sending it
upstream?

There is no wonder Johannes reports that power save is completely
broken with ath9k if we have patches like these. We have better work
to concentrate on, than to fix the regression your patch introduces
every time.

Please fix this and __test__ properly.

>
>  unlock:
>        spin_unlock_irqrestore(&sc->sc_pm_lock, flags);

Vivek.
