Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763445AbYBVOOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 09:14:31 -0500
Subject: Re: [PATCH] PS3: gelic: Link the wireless net_device structure to
	the corresponding device structure
From: Dan Williams <dcbw@redhat.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080222163604.CFC0.40F06B3A@sm.sony.co.jp>
References: <20080222163604.CFC0.40F06B3A@sm.sony.co.jp>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 09:11:23 -0500
Message-Id: <1203689483.29957.0.camel@localhost.localdomain> (sfid-20080222_141439_206833_93FE738A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-02-22 at 16:45 +0900, Masakazu Mokuno wrote:
> Link the net_device structure of the wireless part to the
> corresponding device structure.  
> 
> Without this, the sysfs node for this net_device would not have
> 'device' link.
> 
> Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>

Hmm; I must have missed this in the review.  But it does need to be
there, good catch.

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/ps3_gelic_wireless.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/net/ps3_gelic_wireless.c
> +++ b/drivers/net/ps3_gelic_wireless.c
> @@ -2690,6 +2690,7 @@ int gelic_wl_driver_probe(struct gelic_c
>  		return -ENOMEM;
>  
>  	/* setup net_device structure */
> +	SET_NETDEV_DEV(netdev, &card->dev->core);
>  	gelic_wl_setup_netdev_ops(netdev);
>  
>  	/* setup some of net_device and register it */
> 

