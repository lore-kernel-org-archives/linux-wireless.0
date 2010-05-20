Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:57077 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0ETMvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 08:51:08 -0400
Received: by ewy8 with SMTP id 8so3003404ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 05:51:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100519013049.22206.42069.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
	 <20100519013049.22206.42069.stgit@tt-desk>
Date: Thu, 20 May 2010 15:51:06 +0300
Message-ID: <AANLkTikuP6xUT6-iI-7p44QhIjkb0ItCwQeJ4EbRgLiP@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2 02/20] ath5k: wake queues on reset
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/19 Bruno Randolf <br1@einfach.org>:
> We can wake all queues after a chip reset since everything should be set up and
> we are ready to transmit. If we don't do that we might end up starting up with
> stopped queues, not beeing able to transmit. (This started to happen after
> "ath5k: clean up queue manipulation" but since periodic calibration also
> stopped and started the queues this effect was hidden most of the time).
>
> This way we can also get rid of the superfluous ath5k_reset_wake() function.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   17 +++--------------
>  1 files changed, 3 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index fbd5fc7..9f9107b 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -222,7 +222,6 @@ static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
>  static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
>                struct ath5k_txq *txq);
>  static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan);
> -static int ath5k_reset_wake(struct ath5k_softc *sc);
>  static int ath5k_start(struct ieee80211_hw *hw);
>  static void ath5k_stop(struct ieee80211_hw *hw);
>  static int ath5k_add_interface(struct ieee80211_hw *hw,
> @@ -2770,7 +2769,7 @@ ath5k_tasklet_reset(unsigned long data)
>  {
>        struct ath5k_softc *sc = (void *)data;
>
> -       ath5k_reset_wake(sc);
> +       ath5k_reset(sc, sc->curchan);
>  }
>
>  /*
> @@ -2941,23 +2940,13 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>        ath5k_beacon_config(sc);
>        /* intrs are enabled by ath5k_beacon_config */
>
> +       ieee80211_wake_queues(sc->hw);
> +
>        return 0;
>  err:
>        return ret;
>  }
>
> -static int
> -ath5k_reset_wake(struct ath5k_softc *sc)
> -{
> -       int ret;
> -
> -       ret = ath5k_reset(sc, sc->curchan);
> -       if (!ret)
> -               ieee80211_wake_queues(sc->hw);
> -
> -       return ret;
> -}
> -
>  static int ath5k_start(struct ieee80211_hw *hw)
>  {
>        return ath5k_init(hw->priv);
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
