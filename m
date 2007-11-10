Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37833 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbXKJAN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 19:13:27 -0500
Message-ID: <4734F7B6.7060505@trash.net> (sfid-20071110_001331_336507_3E136CB9)
Date: Sat, 10 Nov 2007 01:13:42 +0100
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
	David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Fix infinite loop on dev_mc_unsync()
References: <20071109151135.GA12982@pogo> <20071109183733.GA22714@pogo>	 <1194635236.19522.3.camel@localhost> <20071109192033.GB22714@pogo>	 <4734E962.3010603@trash.net> <1194653320.19522.28.camel@localhost>
In-Reply-To: <1194653320.19522.28.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches wrote:
> On Sat, 2007-11-10 at 00:12 +0100, Patrick McHardy wrote:
>   
>> This may cause a use-after-free since __dev_addr_delete frees the address
>> when all references are gone.
>>     
>
> How about a comment then?  Perhaps:
>
> diff --git a/net/core/dev_mcast.c b/net/core/dev_mcast.c
> index ae35405..63576aa 100644
> --- a/net/core/dev_mcast.c
> +++ b/net/core/dev_mcast.c
> @@ -165,16 +165,23 @@ void dev_mc_unsync(struct net_device *to, struct net_device *from)
>  	netif_tx_lock_bh(from);
>  	netif_tx_lock_bh(to);
>  
> +	/*
> +	  This while loop can't be written as
> +		for (da = from->mc_list; da; da = da->next)
> +	  da = from->mc_list and __dev_addr_delete can kfree(from->mc_list)
> +	  which could cause a use-after-free of da->next
> +	*/
>   

Seems unnecessary to me, we also don't comment each list_for_each_entry_safe
iteration. I consider the use of a seperate next variable self-explanatory.


