Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1G0TNV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 15:13:21 -0400
Subject: Re: [PATCH] libertas_usb: use USB interface as parent device
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Wed, 27 Jul 2011 14:15:38 -0500
In-Reply-To: <20110721194344.9DDC99D401C@zog.reactivated.net>
References: <20110721194344.9DDC99D401C@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311794142.17655.3.camel@dcbw.foobar.com> (sfid-20110727_211328_094195_228214F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-07-21 at 20:43 +0100, Daniel Drake wrote:
> Currently, "udevadm info -a -p /sys/class/net/wlan0" doesn't mention
> the usb8xxx or libertas driver anywhere. This makes writing udev rules
> a bit uncomfortable.
> 
> Using the USB interface as the parent device corrects the hierarchy.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index b5acc39..e368b29 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -324,7 +324,7 @@ static int if_usb_probe(struct usb_interface *intf,
>  	}
>  	kparam_unblock_sysfs_write(fw_name);
>  
> -	if (!(priv = lbs_add_card(cardp, &udev->dev)))
> +	if (!(priv = lbs_add_card(cardp, &intf->dev)))
>  		goto err_prog_firmware;
>  
>  	cardp->priv = priv;


