Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:54913 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab0CIMQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:16:50 -0500
Received: by ewy8 with SMTP id 8so653646ewy.28
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:16:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075528.30616.58727.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075528.30616.58727.stgit@void>
Date: Tue, 9 Mar 2010 14:16:42 +0200
Message-ID: <40f31dec1003090416v7d69f28fv6b91e26d03787c3@mail.gmail.com>
Subject: Re: [PATCH 03/13] ath5k: preserve antenna settings
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> save antenna settings and preserve across resets.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/attach.c |    1 +
>  drivers/net/wireless/ath/ath5k/base.c   |    2 +-
>  drivers/net/wireless/ath/ath5k/phy.c    |    1 +
>  3 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
> index 4228444..c8bb102 100644
> --- a/drivers/net/wireless/ath/ath5k/attach.c
> +++ b/drivers/net/wireless/ath/ath5k/attach.c
> @@ -123,6 +123,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
>        ah->ah_cw_min = AR5K_TUNE_CWMIN;
>        ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
>        ah->ah_software_retry = false;
> +       ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
>
>        /*
>         * Find the mac version
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 85eb670..fd4dd3c 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2916,7 +2916,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
>         * then we must allow the user to set how many tx antennas we
>         * have available
>         */
> -       ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
> +       ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
>
>  unlock:
>        mutex_unlock(&sc->lock);
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index ffe253a..3fa4f4d 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1929,6 +1929,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
>
>        ah->ah_tx_ant = tx_ant;
>        ah->ah_ant_mode = ant_mode;
> +       ah->ah_def_ant = def_ant;
>
>        sta_id1 |= use_def_for_tx ? AR5K_STA_ID1_DEFAULT_ANTENNA : 0;
>        sta_id1 |= update_def_on_tx ? AR5K_STA_ID1_DESC_ANTENNA : 0;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
