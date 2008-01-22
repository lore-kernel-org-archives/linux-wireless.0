Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:6040 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbYAVBfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 20:35:54 -0500
Received: by an-out-0708.google.com with SMTP id d31so489421and.103
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2008 17:35:53 -0800 (PST)
Message-ID: <40f31dec0801211735j5d528c97w8ba46ac2ac5f659f@mail.gmail.com> (sfid-20080122_013557_902289_B6240889)
Date: Tue, 22 Jan 2008 03:35:53 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 2/2] ath5k: always extend rx timestamp with tsf
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20080121020945.3818.74270.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080121020924.3818.46553.stgit@one>
	 <20080121020945.3818.74270.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/21, Bruno Randolf <bruno@thinktube.com>:
> always extend the rx timestamp with the local TSF, since this information is
> also needed for proper IBSS merging. this is done in the tasklet for now, maybe
> has to be moved to the interrupt handler like in madwifi.
>
> drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>
>  drivers/net/wireless/ath5k/base.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 6bbee64..d7d274f 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1725,11 +1725,18 @@ accept:
>                         skb_pull(skb, pad);
>                 }
>
> -               if (sc->opmode == IEEE80211_IF_TYPE_MNTR)
> -                       rxs.mactime = ath5k_extend_tsf(sc->ah,
> -                                       ds->ds_rxstat.rs_tstamp);
> -               else
> -                       rxs.mactime = ds->ds_rxstat.rs_tstamp;
> +               /*
> +                * always extend the mac timestamp, since this information is
> +                * also needed for proper IBSS merging.
> +                *
> +                * XXX: it might be too late to do it here, since rs_tstamp is
> +                * 15bit only. that means TSF extension has to be done within
> +                * 32768usec (about 32ms). it might be necessary to move this to
> +                * the interrupt handler, like it is done in madwifi.
> +                */
> +               rxs.mactime = ath5k_extend_tsf(sc->ah, ds->ds_rxstat.rs_tstamp);
> +               rxs.flag |= RX_FLAG_TSFT;
> +
>                 rxs.freq = sc->curchan->freq;
>                 rxs.channel = sc->curchan->chan;
>                 rxs.phymode = sc->curmode;
>
>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
