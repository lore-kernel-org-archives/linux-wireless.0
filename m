Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49468 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab0G1Uno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 16:43:44 -0400
Received: by gwb20 with SMTP id 20so1107614gwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 13:43:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280339151-37084-1-git-send-email-nbd@openwrt.org>
References: <1280339151-37084-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 28 Jul 2010 13:43:23 -0700
Message-ID: <AANLkTimZ8zTZWDcXwr7Hu2FT=gDPeCiiUFXcBmpYpp7M@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k: prevent calibration during off-channel
	activity
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 10:45 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Previously the software scan callback was used to indicate to the hardware,
> when it was safe to calibrate. This didn't really work properly, because it
> depends on a specific order of software scan callbacks vs. channel changes.
> Also, software scans are not the only thing that triggers off-channel
> activity, so it's better to use the newly added indication from mac80211 for
> this and not use the software scan callback for anything calibration related.
>
> This fixes at least some of the invalid noise floor readings that I've seen
> in AP mode on AR9160

Neat!

> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -154,6 +154,27 @@ void ath9k_ps_restore(struct ath_softc *sc)
>        spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>  }
>        spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
>  }
>
> +static void ath_start_ani(struct ath_common *common)
> +{
> +       struct ath_hw *ah = common->ah;
> +       unsigned long timestamp = jiffies_to_msecs(jiffies);
> +       struct ath_softc *sc = (struct ath_softc *) common->priv;
> +
> +       if (!(sc->sc_flags & SC_OP_ANI_RUN))
> +               return;
> +
> +       if (sc->sc_flags & SC_OP_OFFCHANNEL)
> +               return;
> +
> +       common->ani.longcal_timer = timestamp;
> +       common->ani.shortcal_timer = timestamp;
> +       common->ani.checkani_timer = timestamp;
> +
> +       mod_timer(&common->ani.timer,
> +                 jiffies +
> +                       msecs_to_jiffies((u32)ah->config.ani_poll_interval));
> +}

I would prefer if you do this sort of code shift in a separate patch.
In this case its pretty easy to see the code is the same so I think
its fine the way it is now but for next time please. Otherwise looks
good, thanks!!

  Luis
