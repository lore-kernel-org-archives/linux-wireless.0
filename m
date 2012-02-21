Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48625 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab2BULLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 06:11:41 -0500
Received: by vbjk17 with SMTP id k17so4076249vbj.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2012 03:11:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20291.25199.584747.537695@gargle.gargle.HOWL>
References: <20291.25199.584747.537695@gargle.gargle.HOWL>
Date: Tue, 21 Feb 2012 16:41:40 +0530
Message-ID: <CAD2nsn2bPffcbPcJAn1BG25Q-XTR8sJCHFwh_siGmneme7JpYQ@mail.gmail.com> (sfid-20120221_121145_523191_D0A30AC4)
Subject: Re: [RFC/WIP 09/22] ath9k: Initialize BTCOEX scheme using a helper
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 21, 2012 at 2:52 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Setting up the required scheme can be done as part of the
> BTCOEX initialization path and it doesn't belong in
> ath9k_hw_fill_cap_info() anyway.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/btcoex.c |   34 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/btcoex.h |    1 +
>  drivers/net/wireless/ath/ath9k/gpio.c   |    2 +
>  drivers/net/wireless/ath/ath9k/hw.c     |   25 ----------------------
>  4 files changed, 37 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
> index 6566952..5365959 100644
> --- a/drivers/net/wireless/ath/ath9k/btcoex.c
> +++ b/drivers/net/wireless/ath/ath9k/btcoex.c
> @@ -98,6 +98,40 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
>  }
>  EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
>
> +void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah)
> +{
> +       struct ath_common *common = ath9k_hw_common(ah);
> +       struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
> +
> +       /*
> +        * Check if BTCOEX is globally disabled.
> +        */
> +       if (!common->btcoex_enabled) {
> +               btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
> +               return;
> +       }
> +
> +       if (AR_SREV_9462(ah)) {
> +               btcoex_hw->scheme = ATH_BTCOEX_CFG_MCI;
> +       } else if (AR_SREV_9300_20_OR_LATER(ah)) {
> +               btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
> +               btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9300;
> +               btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9300;
> +               btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO_9300;
> +       } else if (AR_SREV_9280_20_OR_LATER(ah)) {
> +               btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9280;
> +               btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9280;
> +
> +               if (AR_SREV_9285(ah)) {
> +                       btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
> +                       btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO_9285;
> +               } else {
> +                       btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
> +               }
> +       }
> +}
> +EXPORT_SYMBOL(ath9k_hw_btcoex_init_scheme);
> +
>  void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
>  {
>        struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
> diff --git a/drivers/net/wireless/ath/ath9k/btcoex.h b/drivers/net/wireless/ath/ath9k/btcoex.h
> index 0cb15cd..10627b4 100644
> --- a/drivers/net/wireless/ath/ath9k/btcoex.h
> +++ b/drivers/net/wireless/ath/ath9k/btcoex.h
> @@ -97,6 +97,7 @@ struct ath_btcoex_hw {
>        u32 wlan_weight[AR9300_NUM_WLAN_WEIGHTS];
>  };
>
> +void ath9k_hw_btcoex_init_scheme(struct ath_hw *ah);
>  void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah);
>  void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah);
>  void ath9k_hw_btcoex_init_mci(struct ath_hw *ah);
> diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
> index 3ab62af..c2238ff 100644
> --- a/drivers/net/wireless/ath/ath9k/gpio.c
> +++ b/drivers/net/wireless/ath/ath9k/gpio.c
> @@ -391,6 +391,8 @@ int ath9k_init_btcoex(struct ath_softc *sc)
>        struct ath_hw *ah = sc->sc_ah;
>        int r;
>
> +       ath9k_hw_btcoex_init_scheme(ah);
> +
>        switch (ath9k_hw_get_btcoex_scheme(sc->sc_ah)) {
>        case ATH_BTCOEX_CFG_NONE:
>                break;
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index cb46d41..f4b121f 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -2303,7 +2303,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
>        struct ath9k_hw_capabilities *pCap = &ah->caps;
>        struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
>        struct ath_common *common = ath9k_hw_common(ah);
> -       struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
>        unsigned int chip_chainmask;
>
>        u16 eeval;
> @@ -2422,30 +2421,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
>        else
>                pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
>
> -       if (common->btcoex_enabled) {
> -               if (AR_SREV_9462(ah))
> -                       btcoex_hw->scheme = ATH_BTCOEX_CFG_MCI;
> -               else if (AR_SREV_9300_20_OR_LATER(ah)) {
> -                       btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
> -                       btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9300;
> -                       btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9300;
> -                       btcoex_hw->btpriority_gpio = ATH_BTPRIORITY_GPIO_9300;
> -               } else if (AR_SREV_9280_20_OR_LATER(ah)) {
> -                       btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO_9280;
> -                       btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO_9280;
> -
> -                       if (AR_SREV_9285(ah)) {
> -                               btcoex_hw->scheme = ATH_BTCOEX_CFG_3WIRE;
> -                               btcoex_hw->btpriority_gpio =
> -                                               ATH_BTPRIORITY_GPIO_9285;
> -                       } else {
> -                               btcoex_hw->scheme = ATH_BTCOEX_CFG_2WIRE;
> -                       }
> -               }
> -       } else {
> -               btcoex_hw->scheme = ATH_BTCOEX_CFG_NONE;
> -       }
> -
>        if (AR_SREV_9300_20_OR_LATER(ah)) {
>                pCap->hw_caps |= ATH9K_HW_CAP_EDMA | ATH9K_HW_CAP_FASTCLOCK;
>                if (!AR_SREV_9330(ah) && !AR_SREV_9485(ah))
> --
> 1.7.9.1
>

is it possible to move it to gpio.c, except we are initializing btcoex
related GPIO pins so logically gpio.c could be a good idea. pls let me
know if i had missed something


-- 
thanks,
shafi
