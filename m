Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:54446 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYAMRmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 12:42:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: fix use-after-free rfkill bug
Date: Sun, 13 Jan 2008 18:41:10 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20080113183014.675e64a3@morte>
In-Reply-To: <20080113183014.675e64a3@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200801131841.10393.mb@bu3sch.de> (sfid-20080113_174239_944599_EF24567F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 January 2008 18:30:14 Stefano Brivio wrote:
> Fix rfkill code which caused a use-after-free bug.
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> ---
> Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
> +++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
> @@ -138,8 +138,11 @@ void b43_rfkill_init(struct b43_wldev *d
>  	rfk->rfkill->user_claim_unsupported = 1;
>  
>  	rfk->poll_dev = input_allocate_polled_device();
> -	if (!rfk->poll_dev)
> -		goto err_free_rfk;
> +	if (!rfk->poll_dev) {
> +		rfkill_free(rfk->rfkill);
> +		goto err_freed_rfk;
> +	}
> +
>  	rfk->poll_dev->private = dev;
>  	rfk->poll_dev->poll = b43_rfkill_poll;
>  	rfk->poll_dev->poll_interval = 1000; /* msecs */
> @@ -175,8 +178,7 @@ err_unreg_rfk:
>  err_free_polldev:
>  	input_free_polled_device(rfk->poll_dev);
>  	rfk->poll_dev = NULL;
> -err_free_rfk:
> -	rfkill_free(rfk->rfkill);
> +err_freed_rfk:
>  	rfk->rfkill = NULL;
>  out_error:
>  	rfk->registered = 0;
> @@ -195,6 +197,5 @@ void b43_rfkill_exit(struct b43_wldev *d
>  	rfkill_unregister(rfk->rfkill);
>  	input_free_polled_device(rfk->poll_dev);
>  	rfk->poll_dev = NULL;
> -	rfkill_free(rfk->rfkill);
>  	rfk->rfkill = NULL;
>  }

Acked-by: Michael Buesch <mb@bu3sch.de>

-- 
Greetings Michael.
