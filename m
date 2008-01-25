Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36433 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754535AbYAYBU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 20:20:26 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 10/14] [rndis_host] Add rndis_early_init function pointer to 'struct rndis_data'.
Date: Thu, 24 Jan 2008 17:10:35 -0800
Cc: linux-wireless@vger.kernel.org, bjd@jooz.net,
	netdev@vger.kernel.org
References: <20080120001438.25718.96722.stgit@fate.lan>
In-Reply-To: <20080120001438.25718.96722.stgit@fate.lan>
MIME-Version: 1.0
Message-Id: <200801241710.35528.david-b@pacbell.net> (sfid-20080125_012046_346085_E27C6560)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 19 January 2008, Jussi Kivilinna wrote:
> Function pointer is for rndis minidrivers that need to do work on device right
> after RNDIS_INIT. For example setting device specific configuration parameters
> with OID_GEN_RNDIS_CONFIG_PARAMETER.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Could this -- and #11/14 -- instead be generalized a bit,
so they're not RNDIS-specific?  At least in name; the
only user for now would be the rndis_host code.

The generalization would presumably be "early_init" and
"link_change", paired with doc comments reflecting that
they're usable by any driver stack built over the usbnet
framework core.

There's no point IMO to having generalizable hooks be
restricted this way.

- Dave


> ---
> 
>  drivers/net/usb/rndis_host.c |    6 ++++++
>  drivers/net/usb/usbnet.h     |    3 +++
>  2 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 1d6bf0a..22e5ca1 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -336,6 +336,12 @@ int generic_rndis_bind(struct usbnet *dev, struct usb_interface *intf)
>  		dev->hard_mtu, tmp, dev->rx_urb_size,
>  		1 << le32_to_cpu(u.init_c->packet_alignment));
>  
> +	/* module has some device initialization code needs to be done right
> +	 * after RNDIS_INIT */
> +	if (dev->driver_info->rndis_early_init &&
> +			dev->driver_info->rndis_early_init(dev) != 0)
> +		goto halt_fail_and_release;
> +
>  	/* Get designated host ethernet address */
>  	reply_len = ETH_ALEN;
>  	retval = rndis_query(dev, intf, u.buf, OID_802_3_PERMANENT_ADDRESS,
> diff --git a/drivers/net/usb/usbnet.h b/drivers/net/usb/usbnet.h
> index 0b4bf09..2bc5f76 100644
> --- a/drivers/net/usb/usbnet.h
> +++ b/drivers/net/usb/usbnet.h
> @@ -116,6 +116,9 @@ struct driver_info {
>  	struct sk_buff	*(*tx_fixup)(struct usbnet *dev,
>  				struct sk_buff *skb, gfp_t flags);
>  
> +	/* rndis minidriver early initialization code, can sleep */
> +	int	(*rndis_early_init)(struct usbnet *dev);
> +
>  	/* for new devices, use the descriptor-reading code instead */
>  	int		in;		/* rx endpoint */
>  	int		out;		/* tx endpoint */
> 


