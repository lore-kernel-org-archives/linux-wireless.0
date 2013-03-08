Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43025 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHVP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 16:15:26 -0500
Date: Fri, 8 Mar 2013 16:02:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?Q?Micha=C5=82?= Pecio <michal.pecio@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] orinoco_usb: don't release nonexistent firmware
Message-ID: <20130308210220.GD402@tuxdriver.com> (sfid-20130308_221529_795176_DDFC4E90)
References: <20130307233341.6738c6e6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130307233341.6738c6e6@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch seems to have a lot of whitespace damage, etc.  Please
revise it into something that applies with 'git am' and resubmit?

On Thu, Mar 07, 2013 at 11:33:41PM +0100, Michał Pecio wrote:
> From: Michal Pecio <michal.pecio@gmail.com>
> 
> Initialize fw_entry to NULL to prevent cleanup code from passing
> bogus pointer to release_firmware() when priv allocation fails.
> 
> Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
> ---
> 
> Applies against v3.8.2.
> 
> Issue found by a static checker. I don't own this hardware so the
> patch hasn't been tested.
> 
> Should be valid, though.
> 
> 
>  drivers/net/wireless/orinoco/orinoco_usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c
> b/drivers/net/wireless/orinoco/orinoco_usb.c index 01624dc..2e998ac
> 100644 --- a/drivers/net/wireless/orinoco/orinoco_usb.c
> +++ b/drivers/net/wireless/orinoco/orinoco_usb.c
> @@ -1578,7 +1578,7 @@ static int ezusb_probe(struct usb_interface
> *interface, struct ezusb_priv *upriv = NULL;
>  	struct usb_interface_descriptor *iface_desc;
>  	struct usb_endpoint_descriptor *ep;
> -	const struct firmware *fw_entry;
> +	const struct firmware *fw_entry = NULL;
>  	int retval = 0;
>  	int i;
>  
> -- 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
