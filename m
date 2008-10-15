Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:62473 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbYJOQsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 12:48:23 -0400
Received: by gxk9 with SMTP id 9so7090807gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 09:48:21 -0700 (PDT)
Message-ID: <40f31dec0810150948u61f07426h9661848701de31cd@mail.gmail.com> (sfid-20081015_184844_381281_F7D3FF6E)
Date: Wed, 15 Oct 2008 19:48:21 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: fix mesh point operation
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <48f3f47b.16048e0a.19b4.ffffc4a4@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48f3f47b.16048e0a.19b4.ffffc4a4@mx.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/14 Andrey Yurovsky <andrey@cozybit.com>:
> This patch fixes mesh point operation (thanks to YanBo for pointing out the
> problem): make mesh point interfaces start beaconing when they come up and configure the RX filter in mesh mode so that mesh beacons and action frames are
> received.  Add mesh point to the check in ath5k_add_interface.  Tested with
> multiple AR5211 cards.
>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 1a24a22..467ece6 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2170,7 +2170,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)
>
>        if (sc->opmode == NL80211_IFTYPE_STATION) {
>                sc->imask |= AR5K_INT_BMISS;
> -       } else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
> +       } else if (sc->opmode == NL80211_IFTYPE_ADHOC ||
> +                  sc->opmode == NL80211_IFTYPE_MESH_POINT) {
>                /*
>                 * In IBSS mode we use a self-linked tx descriptor and let the
>                 * hardware send the beacons automatically. We have to load it
> @@ -2182,11 +2183,14 @@ ath5k_beacon_config(struct ath5k_softc *sc)
>
>                sc->imask |= AR5K_INT_SWBA;
>
> -               if (ath5k_hw_hasveol(ah)) {
> -                       spin_lock(&sc->block);
> -                       ath5k_beacon_send(sc);
> -                       spin_unlock(&sc->block);
> -               }
> +               if (sc->opmode == NL80211_IFTYPE_ADHOC) {
> +                       if (ath5k_hw_hasveol(ah)) {
> +                               spin_lock(&sc->block);
> +                               ath5k_beacon_send(sc);
> +                               spin_unlock(&sc->block);
> +                       }
> +               } else
> +                       ath5k_beacon_update_timers(sc, -1);
>        }
>        /* TODO else AP */
>
> @@ -2742,6 +2746,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
>        switch (conf->type) {
>        case NL80211_IFTYPE_STATION:
>        case NL80211_IFTYPE_ADHOC:
> +       case NL80211_IFTYPE_MESH_POINT:
>        case NL80211_IFTYPE_MONITOR:
>                sc->opmode = conf->type;
>                break;
> @@ -2813,7 +2818,8 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>        }
>
>        if (conf->changed & IEEE80211_IFCC_BEACON &&
> -           vif->type == NL80211_IFTYPE_ADHOC) {
> +           (vif->type == NL80211_IFTYPE_ADHOC ||
> +            vif->type == NL80211_IFTYPE_MESH_POINT)) {
>                struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
>                if (!beacon) {
>                        ret = -ENOMEM;
> @@ -2945,6 +2951,9 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>                sc->opmode == NL80211_IFTYPE_ADHOC) {
>                rfilt |= AR5K_RX_FILTER_BEACON;
>        }
> +       if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
> +               rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
> +                       AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
>
>        /* Set filters */
>        ath5k_hw_set_rx_filter(ah,rfilt);
> @@ -3062,7 +3071,8 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
>
>        ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
>
> -       if (sc->opmode != NL80211_IFTYPE_ADHOC) {
> +       if (sc->opmode != NL80211_IFTYPE_ADHOC &&
> +           sc->opmode != NL80211_IFTYPE_MESH_POINT) {
>                ret = -EIO;
>                goto end;
>        }
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
