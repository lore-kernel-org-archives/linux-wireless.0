Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46520 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1ITKGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 06:06:22 -0400
Received: by wyg34 with SMTP id 34so328292wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 03:06:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110919160124.GA3218@makis.lan>
References: <20110919160124.GA3218@makis.lan>
Date: Tue, 20 Sep 2011 15:36:21 +0530
Message-ID: <CAD2nsn0+hMHBLW_5mtJwxfu37_f3aw-8a7Y2tCkh-btVpcfYPQ@mail.gmail.com> (sfid-20110920_120625_908108_FE38C532)
Subject: Re: [RFT][PATCH] ath5k: Add rfkill_disable module parameter
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick,

On Mon, Sep 19, 2011 at 9:31 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> Add a module parameter to disable hw rf kill (GPIO interrupt) because in some cases when the card doesn't come with the laptop, EEPROM configuration
> doesn't match laptop's configuration and rf kill interrupt always fires up and disables hw. I thought of moving this to debugfs and make it per-card

i think this seems to happen with a card that comes with laptop.
AR5212802.11abg NIC (rev 01) in the lenovo T61

i just cannot bring up the card again once i toggle the rfkill switch
(unblock -> block -> unblock)
the card is still hard blocked.

quickly, i just commented out those function calls(same as your patch)
 in compat-wireless
ath5k_rfkill_hw_start(ah);
ath5k_rfkill_stop(ah);
as expected the problem disappears, but i can unblock the card via
soft-rfkill even when it is hard blocked.
is it ok to unblock via software unblock when the card is
hard-blocked?. please share your thoughts. meanwhile i will start
comparing ath5k and ath9k for this. thanks!

> but this way it's easier for users and distros to handle.
>
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index e9ea38d..000a65d 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -80,6 +80,10 @@ static int modparam_fastchanswitch;
>  module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
>  MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
>
> +static int ath5k_modparam_rfkill_disable;
> +module_param_named(rfkill_disable, ath5k_modparam_rfkill_disable, bool, S_IRUGO);
> +MODULE_PARM_DESC(rfkill_disable, "Disable hw rfkill support (GPIO interrupt).");
> +
>
>  /* Module info */
>  MODULE_AUTHOR("Jiri Slaby");
> @@ -2558,7 +2562,8 @@ int ath5k_start(struct ieee80211_hw *hw)
>        if (ret)
>                goto done;
>
> -       ath5k_rfkill_hw_start(ah);
> +       if (!ath5k_modparam_rfkill_disable)
> +               ath5k_rfkill_hw_start(ah);
>
>        /*
>         * Reset the key cache since some parts do not reset the
> @@ -2643,7 +2648,8 @@ void ath5k_stop(struct ieee80211_hw *hw)
>
>        cancel_delayed_work_sync(&ah->tx_complete_work);
>
> -       ath5k_rfkill_hw_stop(ah);
> +       if (!ath5k_modparam_rfkill_disable)
> +               ath5k_rfkill_hw_stop(ah);
>  }
>
>  /*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
