Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36616 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1AISTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 13:19:48 -0500
Message-ID: <4D29FC3F.2030103@openwrt.org>
Date: Sun, 09 Jan 2011 11:19:43 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Restart xmit logic in xmit watchdog.
References: <1294559160-29298-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294559160-29298-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-09 12:46 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> The system can get into a state where the xmit queue
> is stopped, but there are no packets pending, so
> the queue will not be restarted.
>
> Add logic to the xmit watchdog to attempt to restart
> the xmit logic if this situation is detected.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
>
> NOTE:  This is basically the same as a patch I posted
> a day or two ago.  It doesn't address the concern of the
> reviewer who NACK'd it, but my system will not properly
> transmit packets without this patch applied.  I realize
> this is a bit of a hack, but until we find and fix all
> of the other bugs, I think this patch or something similar
> should be applied.
>
> Still, this patch should not be applied unless given positive
> ACK by the ath9k developers.
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index d9a4144..1b3a62c 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1988,19 +1988,30 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
>   	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
>   }
>
> -static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
> +/* Has no locking. */
> +static void __ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
>   {
> -	struct ath_txq *txq;
> -
> -	txq = sc->tx.txq_map[qnum];
> -	spin_lock_bh(&txq->axq_lock);
>   	if (txq->stopped&&  txq->pending_frames<  ATH_MAX_QDEPTH) {
> -		if (ath_mac80211_start_queue(sc, qnum))
> +		if (ath_mac80211_start_queue(sc, txq->axq_qnum))
>   			txq->stopped = 0;
>   	}
> +}
This part is quite broken, I think you got confused with various types 
of queue numbers. txq->axq_qnum refers to the atheros hw queue index, 
whereas the qnum argument to this function refers to the mac80211 queue 
index (which is also the correct index for sc->tx.txq_map - not to be 
confused with the sc->tx.txq array).

Pushing the locking out to the caller side (with a wrapper) does sound 
like a good idea though.

- Felix
