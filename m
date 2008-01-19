Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:47494 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYASWU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 17:20:58 -0500
Received: by py-out-1112.google.com with SMTP id u52so2187111pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jan 2008 14:20:56 -0800 (PST)
Message-ID: <43e72e890801191420p5c25e32aid790748a982bd54d@mail.gmail.com> (sfid-20080119_222103_009243_0B2215FA)
Date: Sat, 19 Jan 2008 17:20:56 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 2/4] ath5k: always extend rx timestamp with tsf
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <20080118125059.6342.18514.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125018.6342.94435.stgit@one>
	 <20080118125059.6342.18514.stgit@one>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 18, 2008 7:50 AM, Bruno Randolf <bruno@thinktube.com> wrote:
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
> index 6bbee64..bb1745f 100644
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
> +                * 32.768usec = 32ms. it might be necessary to move this to the
> +                * interrupt handler, like it is done in madwifi.
> +                */

I'm trying to understand this a bit more and am confused. The TSF
timer is based on 1MHz clock so it has a resolution of 1 microsecond
(us). For 15 bits that would mean 32768 us so don't you mean it should
be done within 32.768 ms instead of usec (or us)?

> +               rxs.mactime = ath5k_extend_tsf(sc->ah, ds->ds_rxstat.rs_tstamp);
> +               rxs.flag |= RX_FLAG_TSFT;
> +
>                 rxs.freq = sc->curchan->freq;
>                 rxs.channel = sc->curchan->chan;
>                 rxs.phymode = sc->curmode;
>
>

Right now we only use mactime and even RX_FLAG_TSFT within mac80211 in
rx.c on ieee80211_rx_monitor() for IEEE80211_RADIOTAP_TSFT so right
now these changes would seem to do nothing. Should we be using this
for something else -- if so what is it?

  Luis
