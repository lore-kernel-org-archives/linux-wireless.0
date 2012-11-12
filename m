Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51516 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab2KLTRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 14:17:36 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so4496200pad.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 11:17:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
References: <1352746438-2404-1-git-send-email-thomas@cozybit.com>
Date: Mon, 12 Nov 2012 11:17:36 -0800
Message-ID: <CAJ-Vmom4Q9ToOokeLf91tSDmmPDehcqfofuPu=wL+=Pf4fUr_g@mail.gmail.com> (sfid-20121112_201740_095601_586907CE)
Subject: Re: [PATCH] ath5k: RX timestamp is reported at end of frame
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@qca.qualcomm.com, me@bobcopeland.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

It may be; that's the problem. :/



Adrian

On 12 November 2012 10:53, Thomas Pedersen <thomas@cozybit.com> wrote:
> This is true for at least AR5213, and shouldn't be different for other
> ath5k PHYs.
>
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 9f31cfa..ae1a2fe 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -1335,20 +1335,9 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
>          * 15bit only. that means TSF extension has to be done within
>          * 32768usec (about 32ms). it might be necessary to move this to
>          * the interrupt handler, like it is done in madwifi.
> -        *
> -        * Unfortunately we don't know when the hardware takes the rx
> -        * timestamp (beginning of phy frame, data frame, end of rx?).
> -        * The only thing we know is that it is hardware specific...
> -        * On AR5213 it seems the rx timestamp is at the end of the
> -        * frame, but I'm not sure.
> -        *
> -        * NOTE: mac80211 defines mactime at the beginning of the first
> -        * data symbol. Since we don't have any time references it's
> -        * impossible to comply to that. This affects IBSS merge only
> -        * right now, so it's not too bad...
>          */
>         rxs->mactime = ath5k_extend_tsf(ah, rs->rs_tstamp);
> -       rxs->flag |= RX_FLAG_MACTIME_MPDU;
> +       rxs->flag |= RX_FLAG_MACTIME_END;
>
>         rxs->freq = ah->curchan->center_freq;
>         rxs->band = ah->curchan->band;
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
