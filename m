Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36381 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754248AbYAYBUV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 20:20:21 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 04/14] [rndis_host] Halt device if rndis_bind fails.
Date: Thu, 24 Jan 2008 16:55:14 -0800
Cc: linux-wireless@vger.kernel.org, bjd@jooz.net,
	netdev@vger.kernel.org
References: <20080120001404.25718.6901.stgit@fate.lan>
In-Reply-To: <20080120001404.25718.6901.stgit@fate.lan>
MIME-Version: 1.0
Message-Id: <200801241655.14572.david-b@pacbell.net> (sfid-20080125_012129_666017_61F39BCE)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 19 January 2008, Jussi Kivilinna wrote:
> When bind fails after device was initialized, shutdown device properly
> by sending RNDIS_MSG_HALT.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
> 
>  drivers/net/usb/rndis_host.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 42b161c..c686025 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -467,6 +467,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
>  		struct rndis_query_c	*get_c;
>  		struct rndis_set	*set;
>  		struct rndis_set_c	*set_c;
> +		struct rndis_halt	*halt;
>  	} u;
>  	u32			tmp;
>  	int			reply_len;
> @@ -517,7 +518,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
>  				"dev can't take %u byte packets (max %u)\n",
>  				dev->hard_mtu, tmp);
>  			retval = -EINVAL;
> -			goto fail_and_release;
> +			goto halt_fail_and_release;
>  		}
>  		dev->hard_mtu = tmp;
>  		net->mtu = dev->hard_mtu - net->hard_header_len;
> @@ -539,7 +540,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
>  			48, (void **) &bp, &reply_len);
>  	if (unlikely(retval< 0)) {
>  		dev_err(&intf->dev, "rndis get ethaddr, %d\n", retval);
> -		goto fail_and_release;
> +		goto halt_fail_and_release;
>  	}
>  	memcpy(net->dev_addr, bp, ETH_ALEN);
>  
> @@ -555,7 +556,7 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
>  	retval = rndis_command(dev, u.header);
>  	if (unlikely(retval < 0)) {
>  		dev_err(&intf->dev, "rndis set packet filter, %d\n", retval);
> -		goto fail_and_release;
> +		goto halt_fail_and_release;
>  	}
>  
>  	retval = 0;
> @@ -563,6 +564,11 @@ static int rndis_bind(struct usbnet *dev, struct usb_interface *intf)
>  	kfree(u.buf);
>  	return retval;
>  
> +halt_fail_and_release:
> +	memset(u.halt, 0, sizeof *u.halt);
> +	u.halt->msg_type = RNDIS_MSG_HALT;
> +	u.halt->msg_len = ccpu2(sizeof *u.halt);
> +	(void) rndis_command(dev, (void *)u.halt);
>  fail_and_release:
>  	usb_set_intfdata(info->data, NULL);
>  	usb_driver_release_interface(driver_of(intf), info->data);
> 


