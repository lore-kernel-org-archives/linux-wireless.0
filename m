Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbYCaTGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 15:06:35 -0400
Subject: Re: [PATCH] [PATCH] prism54: set carrier flags correctly
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	Roy Marples <uberlord@gentoo.org>
In-Reply-To: <1206988135-12309-1-git-send-email-linville@tuxdriver.com>
References: <1206988135-12309-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 14:59:50 -0400
Message-Id: <1206989990.12973.9.camel@localhost.localdomain> (sfid-20080331_200639_536572_8083F257)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-31 at 14:28 -0400, John W. Linville wrote:
> From: Roy Marples <uberlord@gentoo.org>
> 
> prism54 should set the carrier flags correctly when it thinks the
> link can be used.
> 
> Signed-off-by: Roy Marples <uberlord@gentoo.org>
> ---
> I found this in my pile from a long time back.  Anyone have any
> comments on it?

Other than the fact that the carrier flag on wireless devices is kind of
useless, it's fine.  I guess it would be somewhat useful if we could
ensure that the carrier would be on _only_ when the card was
successfully associated and authenticated to the requested AP, but until
every driver was converted properly it would be useless because you
couldn't depend on it.

Dan

>  drivers/net/wireless/prism54/isl_ioctl.c  |    5 ++++-
>  drivers/net/wireless/prism54/islpci_dev.c |    4 +++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> index 838d510..25d42ac 100644
> --- a/drivers/net/wireless/prism54/isl_ioctl.c
> +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> @@ -2093,8 +2093,11 @@ link_changed(struct net_device *ndev, u32 bitrate)
>  		} else
>  			send_simple_event(netdev_priv(ndev),
>  					  "Link established");
> -	} else
> +		netif_carrier_on(ndev);
> +	} else {
>  		send_simple_event(netdev_priv(ndev), "Link lost");
> +		netif_carrier_off(ndev);
> +	}
>  }
>  
>  /* Beacon/ProbeResp payload header */
> diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
> index f057fd9..9c8c6f2 100644
> --- a/drivers/net/wireless/prism54/islpci_dev.c
> +++ b/drivers/net/wireless/prism54/islpci_dev.c
> @@ -386,7 +386,9 @@ islpci_open(struct net_device *ndev)
>  	}
>  
>  	netif_start_queue(ndev);
> -/*      netif_mark_up( ndev ); */
> +
> +	/* Turn off carrier unless we know we have associated */
> +	netif_carrier_off(ndev);
>  
>  	return 0;
>  }

