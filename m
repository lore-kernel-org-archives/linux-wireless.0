Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:45835 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754275AbYLJCjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 21:39:04 -0500
Message-ID: <493F2BC4.7040201@lwfinger.net> (sfid-20081210_033909_841420_F4ED193F)
Date: Tue, 09 Dec 2008 20:39:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] p54: enforce strict tx_queue limits
References: <200812092109.00988.chunkeey@web.de>
In-Reply-To: <200812092109.00988.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> The patch fixes an old FIXME in p54pci.c by moving the "queue full" 
> check into the common library, where we can deal with it properly.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> --- a/drivers/net/wireless/p54/p54common.c	2008-12-09 20:13:56.467888032 +0100
> +++ b/drivers/net/wireless/p54/p54common.c	2008-12-09 20:49:21.235888230 +0100
> @@ -889,7 +889,27 @@ static int p54_assign_address(struct iee
>  		return -EINVAL;
>  
>  	spin_lock_irqsave(&priv->tx_queue.lock, flags);
> +
>  	left = skb_queue_len(&priv->tx_queue);
> +	if (unlikely(left >= 28)) {
> +		/*
> +		 * The tx_queue is nearly full!
> +		 * We have throttle normal data traffic, because we must
> +		 * have a few spare slots for control frames left.
> +		 */
> +		ieee80211_stop_queues(dev);

I do not intend this as a criticism of the patch, but how do the queues get
restarted after this?

Larry

