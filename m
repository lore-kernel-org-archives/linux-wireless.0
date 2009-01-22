Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:56787 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbZAVRkd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 12:40:33 -0500
Received: by gxk14 with SMTP id 14so3949430gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 09:40:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232631861-6028-7-git-send-email-me@bobcopeland.com>
References: <1232631861-6028-7-git-send-email-me@bobcopeland.com>
Date: Thu, 22 Jan 2009 19:40:31 +0200
Message-ID: <40f31dec0901220940w2fa2594chedfcd9c1efee7ff7@mail.gmail.com> (sfid-20090122_184035_748808_B665CAB1)
Subject: Re: [PATCH 6/6] ath5k: honor the RTS/CTS bits
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/22 Bob Copeland <me@bobcopeland.com>:
> The ath5k driver didn't use set_rts_threshold or use_cts_prot, and also
> didn't check the IEEE80211_TX_RC_USE_{RTS_CTS,CTS_PROTECT} RC flags.
> Tell the hardware about these so RTS/CTS will work, and so the device
> will work better in mixed b/g environments.
>
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 85f7f07..57971a9 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1182,6 +1182,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>        unsigned int mrr_rate[3], mrr_tries[3];
>        int i, ret;
>        u16 hw_rate;
> +       u16 cts_rate = 0;
> +       u16 duration = 0;
>        u8 rc_flags;
>
>        flags = AR5K_TXDESC_INTREQ | AR5K_TXDESC_CLRDMASK;
> @@ -1201,6 +1203,19 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>
>        pktlen = skb->len;
>
> +       if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
> +               flags |= AR5K_TXDESC_RTSENA;
> +               cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
> +               duration = le16_to_cpu(ieee80211_rts_duration(sc->hw,
> +                       sc->vif, pktlen, info));
> +       }
> +       if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
> +               flags |= AR5K_TXDESC_CTSENA;
> +               cts_rate = ieee80211_get_rts_cts_rate(sc->hw, info)->hw_value;
> +               duration = le16_to_cpu(ieee80211_ctstoself_duration(sc->hw,
> +                       sc->vif, pktlen, info));
> +       }
> +
>        if (info->control.hw_key) {
>                keyidx = info->control.hw_key->hw_key_idx;
>                pktlen += info->control.hw_key->icv_len;
> @@ -1209,7 +1224,8 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>                ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
>                (sc->power_level * 2),
>                hw_rate,
> -               info->control.rates[0].count, keyidx, 0, flags, 0, 0);
> +               info->control.rates[0].count, keyidx, 0, flags,
> +               cts_rate, duration);
>        if (ret)
>                goto err_unmap;
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
