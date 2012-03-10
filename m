Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60071 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab2CJKs1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 05:48:27 -0500
Received: by vcqp1 with SMTP id p1so2312498vcq.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2012 02:48:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331348259-14985-1-git-send-email-ashok@cozybit.com>
References: <1331348259-14985-1-git-send-email-ashok@cozybit.com>
Date: Sat, 10 Mar 2012 16:18:26 +0530
Message-ID: <CAD2nsn0ZfNx923wZubs2Xi=eueJN+FevCAY8VUUHDMAHV6uBpw@mail.gmail.com> (sfid-20120310_114831_045910_FDE64245)
Subject: Re: [PATCH v2] ath9k: Fix mactime from being clobbered in rx_status
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	zefir.kurtisi@neratec.com, chunkeey@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2012 at 8:27 AM, Ashok Nagarajan <ashok@cozybit.com> wrote:
> mactime was being overwritten by the function ath9k_rx_skb_preprocess. Fixed by
> memsetting rx_status in ath_rx_tasklet.

thanks for fixing this. now i can see a proper non-zero MAC time stamp
in ath9k sniffer.

>
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
> v1:
> Fix reverting "ath9k: trivial: reorder rx_tasklet processing" logic (Christian
> Lamparter)
>  drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 1b1b279..f4ae3ba 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -982,8 +982,6 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
>  {
>        struct ath_hw *ah = common->ah;
>
> -       memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
> -
>        /*
>         * everything but the rate is checked here, the rate check is done
>         * separately to avoid doing two lookups for a rate for each frame.
> @@ -1841,6 +1839,8 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>                if (sc->sc_flags & SC_OP_RXFLUSH)
>                        goto requeue_drop_frag;
>
> +               memset(rxs, 0, sizeof(struct ieee80211_rx_status));
> +
>                rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
>                if (rs.rs_tstamp > tsf_lower &&
>                    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
