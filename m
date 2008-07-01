Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plexity.net ([206.123.115.38]:40790 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050AbYGAVDx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 17:03:53 -0400
Date: Tue, 1 Jul 2008 12:52:59 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: andrey@cozybit.com
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: support USB persistence on suspend/resume (resend)
Message-ID: <20080701195259.GA6109@plexity.net> (sfid-20080701_230359_449002_7E6B0F24)
Reply-To: dsaxena@plexity.net
References: <486a7ae9.14be600a.11a8.ffffa94a@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <486a7ae9.14be600a.11a8.ffffa94a@mx.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


We need this on the OLPC XO to ensure that we don't loose connectivity to 
the mesh and/or AP during our aggressive suspend/resume cycling that we 
are doing (suspend after 30s of inactivity and working towards even more
agressive s/r cycles).

Signed-off-by: Deepak Saxena <dsaxena@laptop.org>

On Jul 01 2008, at 11:43, andrey@cozybit.com was caught saying:
> Handle .reset_resume() so that libertas can survive suspend/resume without 
> reloading the firmware.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
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
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev

-- 
   _____   __o  Deepak Saxena - Living CarFree and CareFree          (o>
------    -\<,  "When I see an adult on a bicycle, I do not despair  //\
 ----- ( )/ ( )  for the future of the human race." -H.G Wells       V_/_
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
