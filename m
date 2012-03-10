Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36207 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836Ab2CJBGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 20:06:51 -0500
Received: by wejx9 with SMTP id x9so1538669wej.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 17:06:49 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ashok Nagarajan <ashok@cozybit.com>
Subject: Re: [PATCH] ath9k: Fix mactime from being clobbered in rx_status
Date: Sat, 10 Mar 2012 02:06:46 +0100
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
References: <1331340008-1713-1-git-send-email-ashok@cozybit.com>
In-Reply-To: <1331340008-1713-1-git-send-email-ashok@cozybit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201203100206.46537.chunkeey@googlemail.com> (sfid-20120310_020654_640655_642B3CF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 10 March 2012 01:40:08 Ashok Nagarajan wrote:
> mactime was being overwritten by the function
> ath9k_rx_skb_preprocess.  Fixed by calling the
> function before setting the mactime.

This looks rather odd... In essence you're trying to revert
"ath9k: trivial: reorder rx_tasklet processing"

Anyway, I 'CC'ed the original author Zefir Kurtisi. So if
there are any open question, now is the time.

> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  drivers/net/wireless/ath/ath9k/recv.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index 1b1b279..52a0466 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -1841,6 +1841,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>  		if (sc->sc_flags & SC_OP_RXFLUSH)
>  			goto requeue_drop_frag;
>  
> +		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
> +						 rxs, &decrypt_error);
> +

Instead of moving ath9k_rx_skb_preprocess around, you could just
put the memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
right here.

[Also, why leave the if (retval) check behind?]

>  		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
>  		if (rs.rs_tstamp > tsf_lower &&
>  		    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
> @@ -1850,8 +1853,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>  		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
>  			rxs->mactime += 0x100000000ULL;
>  
> -		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
> -						 rxs, &decrypt_error);
>  		if (retval)
>  			goto requeue_drop_frag;
		^^ that one
