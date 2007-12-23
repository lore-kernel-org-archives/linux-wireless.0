Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:21911 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753676AbXLWAvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 19:51:13 -0500
Date: Sat, 22 Dec 2007 16:51:11 -0800
From: David Brownell <david-b@pacbell.net>
To: bjd@jooz.net
Subject: Re: [PATCH 3/8] [PATCH] Use 1KB buffer in rndis_unbind
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	jussi.kivilinna@mbnet.fi
References: <11983602942818-git-send-email-bjd@jooz.net>
 <11983602953865-git-send-email-bjd@jooz.net>
In-Reply-To: <11983602953865-git-send-email-bjd@jooz.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-Id: <20071223005111.E699A230E0A@adsl-69-226-248-13.dsl.pltn13.pacbell.net> (sfid-20071223_005117_199366_A0BC966D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From bjd@jooz.net  Sat Dec 22 13:53:03 2007
> From: Bjorge Dijkstra <bjd@jooz.net>
> To: dbrownell@users.sourceforge.net
> Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
> 	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Subject: [PATCH 3/8] [PATCH] Use 1KB buffer in rndis_unbind
> Date: Sat, 22 Dec 2007 22:51:29 +0100
>
> From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>
> rndis_command requires the caller to pass in a buffer of at least 1KB.
>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> Signed-off-by: Bjorge Dijkstra <bjd@jooz.net>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

> ---
>  drivers/net/usb/rndis_host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
> index 96ef6a9..42b161c 100644
> --- a/drivers/net/usb/rndis_host.c
> +++ b/drivers/net/usb/rndis_host.c
> @@ -577,7 +577,7 @@ static void rndis_unbind(struct usbnet *dev, struct usb_interface *intf)
>  	struct rndis_halt	*halt;
>  
>  	/* try to clear any rndis state/activity (no i/o from stack!) */
> -	halt = kzalloc(sizeof *halt, GFP_KERNEL);
> +	halt = kzalloc(CONTROL_BUFFER_SIZE, GFP_KERNEL);
>  	if (halt) {
>  		halt->msg_type = RNDIS_MSG_HALT;
>  		halt->msg_len = ccpu2(sizeof *halt);
> -- 
> 1.5.2.5
>
