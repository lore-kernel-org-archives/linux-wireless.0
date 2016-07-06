Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33294 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbcGFSN7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 14:13:59 -0400
Subject: Re: [PATCH v2] ath9k: Switch to using mac80211 intermediate software
 queues.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org,
	make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org
References: <20160618190505.24038-1-toke@toke.dk>
 <20160706161612.16597-1-toke@toke.dk>
Cc: Tim Shepard <shep@alum.mit.edu>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <85779557-6c5a-fcd3-60cf-4d3c79aec652@nbd.name> (sfid-20160706_201403_400493_BAC48539)
Date: Wed, 6 Jul 2016 20:13:55 +0200
MIME-Version: 1.0
In-Reply-To: <20160706161612.16597-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-07-06 18:16, Toke Høiland-Jørgensen wrote:
> This switches ath9k over to using the mac80211 intermediate software
> queueing mechanism for data packets. It removes the queueing inside the
> driver, except for the retry queue, and instead pulls from mac80211 when
> a packet is needed. The retry queue is used to store a packet that was
> pulled but can't be sent immediately.
> 
> The old code path in ath_tx_start that would queue packets has been
> removed completely, as has the qlen limit tunables (since there's no
> longer a queue in the driver to limit).
> 
> Based on Tim's original patch set, but reworked quite thoroughly.
> 
> Cc: Tim Shepard <shep@alum.mit.edu>
> Cc: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
> Changes since v1:
>   - Remove the old intermediate queueing logic completely instead of
>     just disabling it.
>   - Remove the qlen debug tunables.
>   - Remove the force_channel parameter from struct txctl (since we just
>     removed the code path that was using it).
> 
>  drivers/net/wireless/ath/ath9k/ath9k.h     |  12 +-
>  drivers/net/wireless/ath/ath9k/channel.c   |   2 -
>  drivers/net/wireless/ath/ath9k/debug.c     |  14 +-
>  drivers/net/wireless/ath/ath9k/debug.h     |   2 -
>  drivers/net/wireless/ath/ath9k/debug_sta.c |   4 +-
>  drivers/net/wireless/ath/ath9k/init.c      |   2 +-
>  drivers/net/wireless/ath/ath9k/main.c      |   1 +
>  drivers/net/wireless/ath/ath9k/xmit.c      | 307 +++++++++++------------------
>  8 files changed, 130 insertions(+), 214 deletions(-)
Nice work!


> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index fe795fc..4077eeb 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -912,8 +923,16 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
>  		seqno = bf->bf_state.seqno;
>  
>  		/* do not step over block-ack window */
> -		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno))
> +		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, seqno)) {
> +			__skb_queue_tail(&tid->retry_q, skb);
> +
> +			/* If there are other skbs in the retry q, they are
> +			 * probably within the BAW, so loop immediately to get
> +			 * one of them. Otherwise the queue can get stuck. */
> +			if (!skb_queue_is_first(&tid->retry_q, skb))
> +				continue;
Not sure if this can happen, but if we ever somehow end up with two skbs
in the retry queue that do not fit into the Block-Ack window, there's
potential for an infinite loop here.

- Felix
