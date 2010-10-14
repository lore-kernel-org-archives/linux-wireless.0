Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0JNPz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 11:55:58 -0400
Subject: Re: [PATCH] libertas: Communicate USB transfer errors
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org, pgf@laptop.org, steve@cozybit.com
In-Reply-To: <20101013191456.BA0A99D401B@zog.reactivated.net>
References: <20101013191456.BA0A99D401B@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Oct 2010 10:59:17 -0500
Message-ID: <1287071957.7921.36.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-13 at 20:14 +0100, Daniel Drake wrote:
> From: Paul Fox <pgf@laptop.org>
> 
> The return code was being overwritten with -1.
> Useful for debugging.
> 
> Signed-off-by: Paul Fox <pgf@laptop.org>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_usb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index 3ff6106..16e2575 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -472,11 +472,12 @@ static int if_usb_reset_device(struct if_usb_card *cardp)
>   */
>  static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb)
>  {
> -	int ret = -1;
> +	int ret;
>  
>  	/* check if device is removed */
>  	if (cardp->surprise_removed) {
>  		lbs_deb_usbd(&cardp->udev->dev, "Device removed\n");
> +		ret = -ENODEV;
>  		goto tx_ret;
>  	}
>  
> @@ -489,7 +490,6 @@ static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload, uint16_t nb
>  
>  	if ((ret = usb_submit_urb(cardp->tx_urb, GFP_ATOMIC))) {
>  		lbs_deb_usbd(&cardp->udev->dev, "usb_submit_urb failed: %d\n", ret);
> -		ret = -1;
>  	} else {
>  		lbs_deb_usb2(&cardp->udev->dev, "usb_submit_urb success\n");
>  		ret = 0;


