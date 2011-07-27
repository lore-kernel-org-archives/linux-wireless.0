Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab1G0TNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 15:13:24 -0400
Subject: Re: [PATCH] libertas_usb: program OLPC EC wakeup mask for
 wake-on-WLAN
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Wed, 27 Jul 2011 14:16:05 -0500
In-Reply-To: <20110727161900.DE2109D401C@zog.reactivated.net>
References: <20110727161900.DE2109D401C@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311794166.17655.4.camel@dcbw.foobar.com> (sfid-20110727_211346_430219_2CA6CFD8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-27 at 17:19 +0100, Daniel Drake wrote:
> OLPC power management code has recently gone upstream. This piece
> completes the puzzle for libertas_usb, which now programs the OLPC EC
> for wlan wakeups when they have been requested.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_usb.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> Depends on some patches that were into Linus's tree yesterday.
> 
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index b5acc39..8f73e80 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -1112,6 +1112,15 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
>  	if (priv->psstate != PS_STATE_FULL_POWER)
>  		return -1;
>  
> +#ifdef CONFIG_OLPC
> +	if (machine_is_olpc()) {
> +		if (priv->wol_criteria == EHS_REMOVE_WAKEUP)
> +			olpc_ec_wakeup_clear(EC_SCI_SRC_WLAN);
> +		else
> +			olpc_ec_wakeup_set(EC_SCI_SRC_WLAN);
> +	}
> +#endif
> +
>  	ret = lbs_suspend(priv);
>  	if (ret)
>  		goto out;


