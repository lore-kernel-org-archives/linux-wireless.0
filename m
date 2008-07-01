Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYGAVTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 17:19:16 -0400
Subject: Re: [PATCH] libertas: support USB persistence on suspend/resume
	(resend)
From: Dan Williams <dcbw@redhat.com>
To: andrey@cozybit.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <486a7ae9.14be600a.11a8.ffffa94a@mx.google.com>
References: <486a7ae9.14be600a.11a8.ffffa94a@mx.google.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 17:18:06 -0400
Message-Id: <1214947086.28817.13.camel@localhost.localdomain> (sfid-20080701_231921_257356_1F0D3F42)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-01 at 11:43 -0700, andrey@cozybit.com wrote:
> Handle .reset_resume() so that libertas can survive suspend/resume without 
> reloading the firmware.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index 39b8fbb..aa3a4ff 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -962,6 +962,7 @@ static struct usb_driver if_usb_driver = {
>  	.id_table = if_usb_table,
>  	.suspend = if_usb_suspend,
>  	.resume = if_usb_resume,
> +	.reset_resume = if_usb_resume,
>  };
>  
>  static int __init if_usb_init_module(void)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

