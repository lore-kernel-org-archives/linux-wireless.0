Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:14267 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZAVRVT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 12:21:19 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1972069yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 09:21:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232631861-6028-3-git-send-email-me@bobcopeland.com>
References: <1232631861-6028-3-git-send-email-me@bobcopeland.com>
Date: Thu, 22 Jan 2009 19:21:18 +0200
Message-ID: <40f31dec0901220921seb222efw35e35281a5d4a583@mail.gmail.com> (sfid-20090122_182125_499918_C8283AFD)
Subject: Re: [PATCH 2/6] ath5k: set up rf_banks array at attach time
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/22 Bob Copeland <me@bobcopeland.com>:
> ah_rf_banks was being created lazily the first time we did a reset,
> and the function pointer was also determined every time we reloaded the
> registers.  This change moves the initialization portion into a function
> called at attach time and adds the function pointer to the ath5k_hw
> struct so that reset can be called from atomic context.
>
> Changes to attach.c, phy.c, reset.c
> Changes-licensed-under: ISC
>
> Changes to ath5k.h
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/ath5k.h  |    4 +++-
>  drivers/net/wireless/ath5k/attach.c |    4 ++++
>  drivers/net/wireless/ath5k/phy.c    |   28 ++++++++++------------------
>  drivers/net/wireless/ath5k/reset.c  |    3 ++-
>  4 files changed, 19 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> index 183ffc8..71426ea 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -1149,6 +1149,8 @@ struct ath5k_hw {
>                struct ath5k_tx_status *);
>        int (*ah_proc_rx_desc)(struct ath5k_hw *, struct ath5k_desc *,
>                struct ath5k_rx_status *);
> +       int (*ah_hw_load_rfregs)(struct ath5k_hw *, struct ieee80211_channel *,
> +               unsigned int mode);
>  };
>
>  /*
> @@ -1260,7 +1262,7 @@ extern int ath5k_hw_disable_pspoll(struct ath5k_hw *ah);
>  extern int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel);
>
>  /* Initialize RF */
> -extern int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel, unsigned int mode);
> +extern int ath5k_hw_init_rfregs(struct ath5k_hw *ah);
>  extern int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq);
>  extern enum ath5k_rfgain ath5k_hw_get_rf_gain(struct ath5k_hw *ah);
>  extern int ath5k_hw_set_rfgain_opt(struct ath5k_hw *ah);
> diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath5k/attach.c
> index dea378f..59e7e46 100644
> --- a/drivers/net/wireless/ath5k/attach.c
> +++ b/drivers/net/wireless/ath5k/attach.c
> @@ -333,6 +333,10 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
>
>        ath5k_hw_set_rfgain_opt(ah);
>
> +       ret = ath5k_hw_init_rfregs(ah);
> +       if (ret)
> +               goto err_free;
> +
>        return ah;
>  err_free:
>        kfree(ah);
> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> index 7ba18e0..a12a085 100644
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -1583,13 +1583,12 @@ static int ath5k_hw_rf5413_rfregs(struct ath5k_hw *ah,
>  }
>
>  /*
> - * Initialize RF
> + * Initialize RF function pointers
>  */
> -int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
> -               unsigned int mode)
> +int ath5k_hw_init_rfregs(struct ath5k_hw *ah)
>  {
> -       int (*func)(struct ath5k_hw *, struct ieee80211_channel *, unsigned int);
> -       int ret;
> +       int (*func)(struct ath5k_hw *, struct ieee80211_channel *,
> +               unsigned int);
>
>        switch (ah->ah_radio) {
>        case AR5K_RF5111:
> @@ -1619,20 +1618,13 @@ int ath5k_hw_rfregs(struct ath5k_hw *ah, struct ieee80211_channel *channel,
>                return -EINVAL;
>        }
>
> -       if (ah->ah_rf_banks == NULL) {
> -               /* XXX do extra checks? */
> -               ah->ah_rf_banks = kmalloc(ah->ah_rf_banks_size, GFP_KERNEL);
> -               if (ah->ah_rf_banks == NULL) {
> -                       ATH5K_ERR(ah->ah_sc, "out of memory\n");
> -                       return -ENOMEM;
> -               }
> +       ah->ah_rf_banks = kmalloc(ah->ah_rf_banks_size, GFP_KERNEL);
> +       if (!ah->ah_rf_banks) {
> +               ATH5K_ERR(ah->ah_sc, "out of memory\n");
> +               return -ENOMEM;
>        }
> -
> -       ret = func(ah, channel, mode);
> -       if (!ret)
> -               ah->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
> -
> -       return ret;
> +       ah->ah_hw_load_rfregs = func;
> +       return 0;
>  }
>
>  int ath5k_hw_rfgain(struct ath5k_hw *ah, unsigned int freq)
> diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
> index dc2d7d8..c7cd380 100644
> --- a/drivers/net/wireless/ath5k/reset.c
> +++ b/drivers/net/wireless/ath5k/reset.c
> @@ -603,9 +603,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>                /*
>                 * Write RF registers
>                 */
> -               ret = ath5k_hw_rfregs(ah, channel, mode);
> +               ret = ah->ah_hw_load_rfregs(ah, channel, mode);
>                if (ret)
>                        return ret;
> +               ah->ah_rf_gain = AR5K_RFGAIN_INACTIVE;
>
>                /*
>                 * Configure additional registers

I've updated phy.c etc on my local tree (check out
http://www.linuxwireless.org/en/users/Drivers/ath5k#ath5kTODO) and
i've already fixed that (also fixed the whole rf buffer thing). Please
give me some time to test it and i'll submit the patches.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
