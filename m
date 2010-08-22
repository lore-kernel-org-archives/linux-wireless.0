Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32807 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab0HVVB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 17:01:59 -0400
Received: by pvg2 with SMTP id 2so2032539pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 14:01:58 -0700 (PDT)
Message-ID: <4C719086.3030107@lwfinger.net>
Date: Sun, 22 Aug 2010 16:03:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54usb: fix off-by-one on !CONFIG_PM
References: <201008222241.33364.chunkeey@googlemail.com>
In-Reply-To: <201008222241.33364.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2010 03:41 PM, Christian Lamparter wrote:
> The ISL3887 chip needs a USB reset, whenever the
> usb-frontend module "p54usb" is reloaded.
> 
> This patch fixes an off-by-one bug, if the user
> is running a kernel without the CONFIG_PM option
> set and for some reason (e.g.: compat-wireless)
> wants to switch between different p54usb modules.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> index ad59595..063248b 100644
> --- a/drivers/net/wireless/p54/p54usb.c
> +++ b/drivers/net/wireless/p54/p54usb.c
> @@ -930,8 +930,8 @@ static int __devinit p54u_probe(struct usb_interface *intf,
>  #ifdef CONFIG_PM
>  		/* ISL3887 needs a full reset on resume */
>  		udev->reset_resume = 1;
> +#endif /* CONFIG_PM */
>  		err = p54u_device_reset(dev);
> -#endif
>  
>  		priv->hw_type = P54U_3887;
>  		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);

ACK.

Larry
