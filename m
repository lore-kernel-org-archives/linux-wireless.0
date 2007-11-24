Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:64500 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXKXQwE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 11:52:04 -0500
Date: Sat, 24 Nov 2007 17:52:01 +0100
From: Ulrich Kunitz <kune@deine-taler.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>,
	David Miller <davem@davemloft.net>
Subject: Re: ZD1211RW unaligned accesses...
Message-ID: <20071124165201.GA31677@deine-taler.de> (sfid-20071124_165214_888211_D82137D6)
References: <20071120.040546.222294375.davem@davemloft.net> <47442BFC.8090008@hotmail.com> <20071124150216.GA28153@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071124150216.GA28153@gondor.apana.org.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herbert Xu wrote:

> So please try the following patch (instead of the original one)
> which should fix all the unailgned accesses in do_rx.
> 
> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
> index a903645..d06b05b 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -1166,15 +1166,16 @@ static void do_rx(unsigned long mac_ptr)
>  int zd_mac_rx_irq(struct zd_mac *mac, const u8 *buffer, unsigned int length)
>  {
>  	struct sk_buff *skb;
> +	unsigned int hlen = ALIGN(sizeof(struct zd_rt_hdr), 16);
>  
> -	skb = dev_alloc_skb(sizeof(struct zd_rt_hdr) + length);
> +	skb = dev_alloc_skb(hlen + length);
>  	if (!skb) {
>  		struct ieee80211_device *ieee = zd_mac_to_ieee80211(mac);
>  		dev_warn(zd_mac_dev(mac), "Could not allocate skb.\n");
>  		ieee->stats.rx_dropped++;
>  		return -ENOMEM;
>  	}
> -	skb_reserve(skb, sizeof(struct zd_rt_hdr));
> +	skb_reserve(skb, hlen - ZD_PLCP_HEADER_SIZE);
>  	memcpy(__skb_put(skb, length), buffer, length);
>  	skb_queue_tail(&mac->rx_queue, skb);
>  	tasklet_schedule(&mac->rx_tasklet);

ACK. This patch should solve it and is better than my patch.

-- 
Uli Kunitz
