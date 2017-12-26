Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36482 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdLZLBw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Dec 2017 06:01:52 -0500
Received: by mail-wr0-f195.google.com with SMTP id u19so27978821wrc.3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Dec 2017 03:01:51 -0800 (PST)
Date: Tue, 26 Dec 2017 12:01:43 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 1/2] rt2x00: pause almost full queue early
In-Reply-To: <1513683236-13402-1-git-send-email-sgruszka@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1712261200050.17705@localhost.localdomain> (sfid-20171226_120200_437595_836C66A5)
References: <1513683236-13402-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a WL-330N3G device, these patches seems to make the situation much better.
In other words, I wasn't able to reproduce the stall on this chipset.
On MT7620 a stall was never seen directly, but tests with these patches revealed no stall.
So I think it's good to have these merged.

Tested-by: Enrico Mioso@gmail.com


On Tue, 19 Dec 2017, Stanislaw Gruszka wrote:

> Date: Tue, 19 Dec 2017 12:33:55
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> To: linux-wireless@vger.kernel.org
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
>     Enrico Mioso <mrkiko.rs@gmail.com>, Daniel Golle <daniel@makrotopia.org>,
>     Felix Fietkau <nbd@nbd.name>, Stanislaw Gruszka <sgruszka@redhat.com>
> Subject: [PATCH 1/2] rt2x00: pause almost full queue early
> 
> Do not drop &queue->tx_lock and acquire it again to pause queue when
> available entries are below the threshold.
>
> Patch should mitigate problem of frequently printed errors:
> "Error - Dropping frame due to full tx queue"
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> drivers/net/wireless/ralink/rt2x00/rt2x00mac.c   | 10 ----------
> drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |  8 ++++++++
> 2 files changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> index ecc96312a370..c8a6f163102f 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
> @@ -152,16 +152,6 @@ void rt2x00mac_tx(struct ieee80211_hw *hw,
> 	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, control->sta, false)))
> 		goto exit_fail;
>
> -	/*
> -	 * Pausing queue has to be serialized with rt2x00lib_txdone(). Note
> -	 * we should not use spin_lock_bh variant as bottom halve was already
> -	 * disabled before ieee80211_xmit() call.
> -	 */
> -	spin_lock(&queue->tx_lock);
> -	if (rt2x00queue_threshold(queue))
> -		rt2x00queue_pause_queue(queue);
> -	spin_unlock(&queue->tx_lock);
> -
> 	return;
>
>  exit_fail:
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> index a2c1ca5c76d1..1ad51e56bc59 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> @@ -715,6 +715,14 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
> 	rt2x00queue_kick_tx_queue(queue, &txdesc);
>
> out:
> +	/*
> +	 * Pausing queue has to be serialized with rt2x00lib_txdone(), so we
> +	 * do this under queue->tx_lock. Bottom halve was already disabled
> +	 * before ieee80211_xmit() call.
> +	 */
> +	if (rt2x00queue_threshold(queue))
> +		rt2x00queue_pause_queue(queue);
> +
> 	spin_unlock(&queue->tx_lock);
> 	return ret;
> }
> -- 
> 1.9.3
>
>
