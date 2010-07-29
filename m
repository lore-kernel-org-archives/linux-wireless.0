Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.214.194]:33970 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0G2Oj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 10:39:56 -0400
Received: by iwn34 with SMTP id 34so53579iwn.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 07:39:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280408219-5293-3-git-send-email-vasanth@atheros.com>
References: <1280408219-5293-1-git-send-email-vasanth@atheros.com>
	<1280408219-5293-3-git-send-email-vasanth@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 29 Jul 2010 07:39:35 -0700
Message-ID: <AANLkTimiQZj7Gh5g+W0pcuWYFejt4EGQVCEQQ1aNvsk5@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath9k: Implement an algorithm for Antenna diversity
	and combining
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 29, 2010 at 5:56 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> This algorithm chooses the best main and alt lna out of
> LNA1, LNA2, LNA1+LNA2 and LNA1-LNA2 to improve rx for single
> chain chips(AR9285). This would greatly improve rx when there
> is only one antenna is connected with AR9285.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>

> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 243c177..8b4e4a6 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -531,6 +531,11 @@ static void ath9k_init_misc(struct ath_softc *sc)
>                sc->beacon.bslot[i] = NULL;
>                sc->beacon.bslot_aphy[i] = NULL;
>        }
> +
> +       if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) {
> +               memset(&sc->ant_comb, 0, sizeof(struct ath_ant_comb));

I do not believe this memset is required since we kzalloc()'d the ah struct.

> +               sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
> +       }
>  }
>
>  static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index da0cfe9..711e8d2 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1073,6 +1073,534 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
>                rxs->flag &= ~RX_FLAG_DECRYPTED;
>  }
>
> +/* Antenna diversity and combining */
> +static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
> +{

   <-- snip -->

> +       ath9k_hw_antdiv_comb_conf_get(sc->sc_ah, &div_ant_conf);

  <-- snip -->

> +       ath9k_hw_antdiv_comb_conf_set(sc->sc_ah, &div_ant_conf);

  <-- snip -->

> +}

Wow this routine is pretty large. Could you split this up into a few
helpers which describe what they do ?
Also notice how this ended up calling ath9k_hw_antdiv_comb_conf_get()
and ath9k_hw_antdiv_comb_conf_set(), the only callers of those
routines, and this itself is done when:

> +
>  int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>  {
>        struct ath_buf *bf;
> @@ -1210,6 +1738,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>                                              PS_WAIT_FOR_PSPOLL_DATA))))
>                        ath_rx_ps(sc, skb);
>
> +               if (ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
> +                       ath_ant_comb_scan(sc, &rs);
> +
>                ath_rx_send_to_mac80211(hw, sc, skb, rxs);
>
>  requeue:

So the call currently really does not require to be abstracted away
unless we expect another 1x1 device where it will have its own set of
calls, eventually.

  Luis
