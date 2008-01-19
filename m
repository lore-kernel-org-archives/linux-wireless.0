Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:8938 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbYASWmL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 17:42:11 -0500
Received: by py-out-1112.google.com with SMTP id u52so2192418pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jan 2008 14:42:11 -0800 (PST)
Message-ID: <43e72e890801191442q142588e8iee83bb774259807e@mail.gmail.com> (sfid-20080119_224215_622927_06B80DC8)
Date: Sat, 19 Jan 2008 17:42:10 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 4/4] ath5k: beacon interval is in TU
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <20080118125140.6342.95789.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125018.6342.94435.stgit@one>
	 <20080118125140.6342.95789.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 18, 2008 7:51 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> the beacon interval is passed by mac80211 in TU already, so we can directly use
> it without conversion. also update the comments about TU (1 TU is defined by
> 802.11 as 1024usec).
>
> drivers/net/wireless/ath5k/ath5k.h:     Changes-licensed-under: ISC
> drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
> drivers/net/wireless/ath5k/base.h:      Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>
>  drivers/net/wireless/ath5k/ath5k.h |    4 ++--
>  drivers/net/wireless/ath5k/base.c  |    4 ++--
>  drivers/net/wireless/ath5k/base.h  |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
>
> diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
> index 878609f..c79066b 100644
> --- a/drivers/net/wireless/ath5k/ath5k.h
> +++ b/drivers/net/wireless/ath5k/ath5k.h
> @@ -486,8 +486,8 @@ struct ath5k_beacon_state {
>   * TSF to TU conversion:
>   *
>   * TSF is a 64bit value in usec (microseconds).
> - * TU is a 32bit value in roughly msec (milliseconds): usec / 1024
> - * (1000ms equals 976 TU)
> + * TU is a 32bit value and defined by IEEE802.11 (page 6) as "A measurement of
> + * time equal to 1024 usec", so it's roughly milliseconds (usec / 1024).
>   */
>  #define TSF_TO_TU(_tsf) (u32)((_tsf) >> 10)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index bb1745f..784b359 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2550,7 +2550,7 @@ ath5k_config(struct ieee80211_hw *hw,
>  {
>         struct ath5k_softc *sc = hw->priv;
>
> -       sc->bintval = conf->beacon_int * 1000 / 1024;
> +       sc->bintval = conf->beacon_int;
>         ath5k_setcurmode(sc, conf->phymode);
>
>         return ath5k_chan_set(sc, conf->chan);
> @@ -2566,7 +2566,7 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>
>         /* Set to a reasonable value. Note that this will
>          * be set to mac80211's value at ath5k_config(). */
> -       sc->bintval = 1000 * 1000 / 1024;
> +       sc->bintval = 1000;

Sure, although as I noted this value will be later set by mac80211
through ath5k_config().

Acked-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

  Luis
