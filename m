Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38552 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYIQOIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 10:08:30 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] b43: Issue warning when RFKILL_INPUT is not enabled
Date: Wed, 17 Sep 2008 16:07:55 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <48d00f81./8rb7yGSb9PmJx+R%Larry.Finger@lwfinger.net>
In-Reply-To: <48d00f81./8rb7yGSb9PmJx+R%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809171607.55403.mb@bu3sch.de> (sfid-20080917_160841_289661_99A9C74A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 September 2008 21:56:49 Larry Finger wrote:
> If the system is misconfigured with CONFIG_RFKILL set but CONFIG_RFKILL_INPUT
> not set, the built-in radio LEDs will not work. In the current code, no warning
> is issued.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This is material for the next merge.


ACK

> Larry
> 
> 
> Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
> +++ wireless-testing/drivers/net/wireless/b43/rfkill.c
> @@ -188,6 +188,11 @@ void b43_rfkill_init(struct b43_wldev *d
>  			"The built-in radio LED will not work.\n");
>  #endif /* CONFIG_RFKILL_INPUT */
>  
> +#if !defined(CONFIG_RFKILL_INPUT) && !defined(CONFIG_RFKILL_INPUT_MODULE)
> +	b43warn(wl, "The rfkill-input subsystem is not available. "
> +		"The built-in radio LED will not work.\n");
> +#endif
> +
>  	err = input_register_polled_device(rfk->poll_dev);
>  	if (err)
>  		goto err_unreg_rfk;
> 
> 



-- 
Greetings Michael.
