Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:32337 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbZAVRl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 12:41:28 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1977363yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 09:41:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232631861-6028-2-git-send-email-me@bobcopeland.com>
References: <1232631861-6028-2-git-send-email-me@bobcopeland.com>
Date: Thu, 22 Jan 2009 19:41:27 +0200
Message-ID: <40f31dec0901220941v4901dbe1kb46a7c9d76276457@mail.gmail.com> (sfid-20090122_184146_297509_456DE443)
Subject: Re: [PATCH 1/6] ath5k: fix locking in ath5k_config
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/22 Bob Copeland <me@bobcopeland.com>:
> ath5k_config updates the software context without taking sc->lock.
>
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 747b496..1e1222c 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1021,6 +1021,8 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
>  * it's done by reseting the chip.  To accomplish this we must
>  * first cleanup any pending DMA, then restart stuff after a la
>  * ath5k_init.
> + *
> + * Called with sc->lock.
>  */
>  static int
>  ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
> @@ -2825,11 +2827,17 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
>  {
>        struct ath5k_softc *sc = hw->priv;
>        struct ieee80211_conf *conf = &hw->conf;
> +       int ret;
> +
> +       mutex_lock(&sc->lock);
>
>        sc->bintval = conf->beacon_int;
>        sc->power_level = conf->power_level;
>
> -       return ath5k_chan_set(sc, conf->channel);
> +       ret = ath5k_chan_set(sc, conf->channel);
> +
> +       mutex_unlock(&sc->lock);
> +       return ret;
>  }
>
>  static int

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
