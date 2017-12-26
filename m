Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40679 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdLZLCa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Dec 2017 06:02:30 -0500
Received: by mail-wm0-f67.google.com with SMTP id f206so34443756wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Dec 2017 03:02:30 -0800 (PST)
Date: Tue, 26 Dec 2017 12:02:23 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 2/2] rt2x00: do not pause queue unconditionally on error
 path
In-Reply-To: <1513683236-13402-2-git-send-email-sgruszka@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1712261201480.17705@localhost.localdomain> (sfid-20171226_120236_509534_BAB448BC)
References: <1513683236-13402-1-git-send-email-sgruszka@redhat.com> <1513683236-13402-2-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a WL-330N3G device, these patches seems to make the situation much better.
In other words, I wasn't able to reproduce the stall on this chipset.
On MT7620 a stall was never seen directly, but tests with these patches revealed no stall.
So I think it's good to have these merged.

Tested-by: Enrico Mioso <mrkiko.rs@gmail.com>


On Tue, 19 Dec 2017, Stanislaw Gruszka wrote:

> Date: Tue, 19 Dec 2017 12:33:56
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> To: linux-wireless@vger.kernel.org
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
>     Enrico Mioso <mrkiko.rs@gmail.com>, Daniel Golle <daniel@makrotopia.org>,
>     Felix Fietkau <nbd@nbd.name>, Stanislaw Gruszka <sgruszka@redhat.com>
> Subject: [PATCH 2/2] rt2x00: do not pause queue unconditionally on error path
> 
> Pausing queue without checking threshold is racy with txdone path.
> Moreover we do not need pause queue on any error, but only if queue
> is full - in case when we send RTS frame ( other cases of almost full
> queue are already handled in rt2x00queue_write_tx_frame() ).
>
> Patch fixes of theoretically possible problem of pausing empty
> queue.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 22 ++++++++++++++--------
> 1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> index c8a6f163102f..a971bc7a6b63 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> @@ -142,22 +142,28 @@ void rt2x00mac_tx(struct ieee80211_hw *hw,
> 	if (!rt2x00dev->ops->hw->set_rts_threshold &&
> 	    (tx_info->control.rates[0].flags & (IEEE80211_TX_RC_USE_RTS_CTS |
> 						IEEE80211_TX_RC_USE_CTS_PROTECT))) {
> -		if (rt2x00queue_available(queue) <= 1)
> -			goto exit_fail;
> +		if (rt2x00queue_available(queue) <= 1) {
> +			/*
> +			 * Recheck for full queue under lock to avoid race
> +			 * conditions with rt2x00lib_txdone().
> +			 */
> +			spin_lock(&queue->tx_lock);
> +			if (rt2x00queue_threshold(queue))
> +				rt2x00queue_pause_queue(queue);
> +			spin_unlock(&queue->tx_lock);
> +
> +			goto exit_free_skb;
> +		}
>
> 		if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb))
> -			goto exit_fail;
> +			goto exit_free_skb;
> 	}
>
> 	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, control->sta, false)))
> -		goto exit_fail;
> +		goto exit_free_skb;
>
> 	return;
>
> - exit_fail:
> -	spin_lock(&queue->tx_lock);
> -	rt2x00queue_pause_queue(queue);
> -	spin_unlock(&queue->tx_lock);
>  exit_free_skb:
> 	ieee80211_free_txskb(hw, skb);
> }
> -- 
> 1.9.3
>
>
