Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36346 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753910AbYAYBUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 20:20:19 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 01/14] Fix sparse warning: returning void-valued expression
Date: Thu, 24 Jan 2008 16:52:12 -0800
Cc: linux-wireless@vger.kernel.org, bjd@jooz.net,
	netdev@vger.kernel.org
References: <20080120001348.25718.36756.stgit@fate.lan>
In-Reply-To: <20080120001348.25718.36756.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801241652.12357.david-b@pacbell.net> (sfid-20080125_012037_835754_D3C7049E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 19 January 2008, Jussi Kivilinna wrote:
> From: Bjorge Dijkstra <bjd@jooz.net>
> 
> rndis_unbind and usbnet_cdc_unbind don't return anything.
> 
> Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
> 
>  drivers/net/usb/rndis_host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 1ebe325..96ef6a9 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -585,7 +585,7 @@ static void rndis_unbind(struct usbnet *dev, struct usb_interface *intf)
>  		kfree(halt);
>  	}
>  
> -	return usbnet_cdc_unbind(dev, intf);
> +	usbnet_cdc_unbind(dev, intf);
>  }
>  
>  /*
> 


