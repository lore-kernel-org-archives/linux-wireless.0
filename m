Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:51651 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369Ab2B1JvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 04:51:23 -0500
Received: by mail-lpp01m010-f52.google.com with SMTP id i5so1353860lah.39
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 01:51:22 -0800 (PST)
Message-ID: <1330422678.18637.28.camel@cumari> (sfid-20120228_105127_435367_45AA5426)
Subject: Re: [PATCH 3/7] wl12xx: reset link Tx queues when freeing it
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Feb 2012 11:51:18 +0200
In-Reply-To: <1330382494-31148-3-git-send-email-arik@wizery.com>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
	 <1330382494-31148-3-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-28 at 00:41 +0200, Arik Nemtsov wrote: 
> Before, the link was first freed (invalidating it in the map), and later
> on vif removal, all valid wlvif-related links were reset. Since these
> links were already invalid, we failed to reset them.
> The bug was made worse by op_stop, which set the tx_queue_count to 0
> arbitrarily. This resulted in a negative tx_queue_count in some scenarios.
> 
> Fix this by resetting the Tx-queues of a link when freeing it. Add a
> WARN_ON and reset all link Tx-queues in op_stop, to avoid a negative
> tx_queue_count.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
> index 6446e4d..311b5a2 100644
> --- a/drivers/net/wireless/wl12xx/tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -527,6 +527,7 @@ static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
>  	if (skb) {
>  		int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
>  		spin_lock_irqsave(&wl->wl_lock, flags);
> +		WARN_ON(wl->tx_queue_count[q] <= 0);
>  		wl->tx_queue_count[q]--;
>  		spin_unlock_irqrestore(&wl->wl_lock, flags);
>  	}
> @@ -602,6 +603,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
>  		skb = wl->dummy_packet;
>  		q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
>  		spin_lock_irqsave(&wl->wl_lock, flags);
> +		WARN_ON(wl->tx_queue_count[q] <= 0);
>  		wl->tx_queue_count[q]--;
>  		spin_unlock_irqrestore(&wl->wl_lock, flags);
>  	}

[...]

> @@ -973,8 +974,14 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
>  	struct sk_buff *skb;
>  	struct ieee80211_tx_info *info;
>  
> -	for (i = 0; i < NUM_TX_QUEUES; i++)
> -		wl->tx_queue_count[i] = 0;
> +	/* only reset the queues if something bad happened */
> +	if (WARN_ON(wl1271_tx_total_queue_count(wl) != 0)) {

Let's make all these WARN_ONs as WARN_ON_ONCE as it is recommended
nowadays.  This will make Kalle Valo happier. :)

I can do a quick sed before I apply this, if you agree.

-- 
Cheers,
Luca.

