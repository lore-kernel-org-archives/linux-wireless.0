Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:1786 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbXKITHT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 14:07:19 -0500
Subject: Re: [PATCH] Fix infinite loop on dev_mc_unsync()
From: Joe Perches <joe@perches.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>,
	David Miller <davem@davemloft.net>
In-Reply-To: <20071109183733.GA22714@pogo>
References: <20071109151135.GA12982@pogo>  <20071109183733.GA22714@pogo>
Content-Type: text/plain
Date: Fri, 09 Nov 2007 11:07:16 -0800
Message-Id: <1194635236.19522.3.camel@localhost> (sfid-20071109_190725_739853_92651D53)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-11-09 at 13:51 -0500, Luis R. Rodriguez wrote:
> While reviewing net/core/dev_mcast.c I found what I think is an 
> infinite loop on dev_mc_unsync(). This fixes it. We make use of
> this guy on mac80211 in ieee80211_stop(). This is untested.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> 
> diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
> index 15241cf..5373c03 100644
> --- a/net/core/dev_mcast.c
> +++ b/net/core/dev_mcast.c
> @@ -168,8 +168,10 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
>  	da = from->mc_list;
>  	while (da != NULL) {
>  		next = da->next;
> -		if (!da->da_synced)
> +		if (!da->da_synced) {
> +			da = next;
>  			continue;
> +		}
>  		__dev_addr_delete(&to->mc_list, &to->mc_count,
>  				  da->da_addr, da->da_addrlen, 0);
>  		da->da_synced = 0;
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Perhaps this is clearer as:

void dev_mc_unsync(struct net_device *to, struct net_device *from)
{
	struct dev_addr_list *da;

	netif_tx_lock_bh(from);
	netif_tx_lock_bh(to);

	da = from->mc_list;
	while (da) {
		if (da->da_synced) {
			__dev_addr_delete(&to->mc_list, &to->mc_count,
					  da->da_addr, da->da_addrlen, 0);
			__dev_addr_delete(&from->mc_list, &from->mc_count,
					  da->da_addr, da->da_addrlen, 0);
			da->da_synced = 0;
		}
		da = da->next;
	}

	__dev_set_rx_mode(to);

	netif_tx_unlock_bh(to);
	netif_tx_unlock_bh(from);
}
EXPORT_SYMBOL(dev_mc_unsync);


