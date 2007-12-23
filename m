Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:43829 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753355AbXLWAso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 19:48:44 -0500
Date: Sat, 22 Dec 2007 16:42:03 -0800
From: David Brownell <david-b@pacbell.net>
To: bjd@jooz.net
Subject: Re: [PATCH 1/8] Fix sparse warning: returning void-valued expression
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <11983602942818-git-send-email-bjd@jooz.net>
 <11983602952341-git-send-email-bjd@jooz.net>
In-Reply-To: <11983602952341-git-send-email-bjd@jooz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <20071223004203.5DED722313C@adsl-69-226-248-13.dsl.pltn13.pacbell.net> (sfid-20071223_004854_488906_8F72976B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From bjd@jooz.net  Sat Dec 22 13:52:53 2007
> From: Bjorge Dijkstra <bjd@jooz.net>
> To: dbrownell@users.sourceforge.net
> Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
> Subject: [PATCH 1/8] Fix sparse warning: returning void-valued expression
> Date: Sat, 22 Dec 2007 22:51:27 +0100
>
> rndis_unbind and usbnet_cdc_unbind don't return anything.
>
> Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
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
> -- 
> 1.5.2.5
>
