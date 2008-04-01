Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbYDAUpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 16:45:24 -0400
Subject: Re: [PATCH] [PATCH] prism54: set carrier flags correctly
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Roy Marples <uberlord@gentoo.org>
In-Reply-To: <20080401191736.GC4810@ruslug.rutgers.edu>
References: <1206988135-12309-1-git-send-email-linville@tuxdriver.com>
	 <1206989990.12973.9.camel@localhost.localdomain>
	 <20080401191736.GC4810@ruslug.rutgers.edu>
Content-Type: text/plain
Date: Tue, 01 Apr 2008 16:43:30 -0400
Message-Id: <1207082610.3235.0.camel@localhost.localdomain> (sfid-20080401_214528_890424_121506EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-01 at 15:17 -0400, Luis R. Rodriguez wrote:
> On Mon, Mar 31, 2008 at 02:59:50PM -0400, Dan Williams wrote:
> > On Mon, 2008-03-31 at 14:28 -0400, John W. Linville wrote:
> > > From: Roy Marples <uberlord@gentoo.org>
> > > 
> > > prism54 should set the carrier flags correctly when it thinks the
> > > link can be used.
> > > 
> > > Signed-off-by: Roy Marples <uberlord@gentoo.org>
> > > ---
> > > I found this in my pile from a long time back.  Anyone have any
> > > comments on it?
> > 
> > Other than the fact that the carrier flag on wireless devices is kind of
> > useless, it's fine. 
> 
> Agreed, so sure, this is OK but I rather we turn the carrier on
> or off *before* sending an event, like this.

+1 from me, that's the right sequence.

Dan

> Signed-off-by: Roy Marples <uberlord@gentoo.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
> 
> diff --git a/drivers/net/wireless/prism54/isl_ioctl.c b/drivers/net/wireless/prism54/isl_ioctl.c
> index 2e25e19..e5b3c28 100644
> --- a/drivers/net/wireless/prism54/isl_ioctl.c
> +++ b/drivers/net/wireless/prism54/isl_ioctl.c
> @@ -2081,6 +2081,7 @@ link_changed(struct net_device *ndev, u32 bitrate)
>  	islpci_private *priv = netdev_priv(ndev);
>  
>  	if (bitrate) {
> +		netif_carrier_on(ndev);
>  		if (priv->iw_mode == IW_MODE_INFRA) {
>  			union iwreq_data uwrq;
>  			prism54_get_wap(ndev, NULL, (struct sockaddr *) &uwrq,
> @@ -2089,8 +2090,10 @@ link_changed(struct net_device *ndev, u32 bitrate)
>  		} else
>  			send_simple_event(netdev_priv(ndev),
>  					  "Link established");
> -	} else
> +	} else {
> +		netif_carrier_off(ndev);
>  		send_simple_event(netdev_priv(ndev), "Link lost");
> +	}
>  }
>  
>  /* Beacon/ProbeResp payload header */
> diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
> index eb7c1c6..04c2638 100644
> --- a/drivers/net/wireless/prism54/islpci_dev.c
> +++ b/drivers/net/wireless/prism54/islpci_dev.c
> @@ -387,7 +387,9 @@ islpci_open(struct net_device *ndev)
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

