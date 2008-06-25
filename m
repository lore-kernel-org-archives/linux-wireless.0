Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:26583 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbYFYLLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 07:11:22 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1128709ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2008 04:11:17 -0700 (PDT)
Message-ID: <486227D2.6030801@gmail.com> (sfid-20080625_131126_522454_338E98B3)
Date: Wed, 25 Jun 2008 13:11:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Subject: Re: Small cleanups
References: <20080625102553.GA2648@elf.ucw.cz>
In-Reply-To: <20080625102553.GA2648@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Machek napsal(a):
> Small whitespace cleanups for wireless drivers
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

The ath5k part
Acked-by: Jiri Slaby <jirislaby@gmail.com>

Thanks!

> diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
> index 32019fb..329be62 100644
> --- a/drivers/net/wireless/airo.c
> +++ b/drivers/net/wireless/airo.c
[...]
> @@ -5530,11 +5530,13 @@ static int airo_pci_suspend(struct pci_d
>  	Cmd cmd;
>  	Resp rsp;
>  
> -	if ((ai->APList == NULL) &&
> -		(ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL)) == NULL)
> +	if (!ai->APList)
> +		ai->APList = kmalloc(sizeof(APListRid), GFP_KERNEL);
> +	if (!ai->APList)
>  		return -ENOMEM;
> -	if ((ai->SSID == NULL) &&
> -		(ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL)) == NULL)
> +	if (!ai->SSID)
> +		ai->SSID = kmalloc(sizeof(SsidRid), GFP_KERNEL);
> +	if (!ai->SSID)
>  		return -ENOMEM;

Would you mind sending another patch which would fix the potential leak?

> @@ -5615,15 +5614,11 @@ #endif
>  		airo_entry->gid = proc_gid;
>  	}
>  
> -	for( i = 0; i < 4 && io[i] && irq[i]; i++ ) {
> +	for (i = 0; i < 4 && io[i] && irq[i]; i++) {
>  		airo_print_info("", "Trying to configure ISA adapter at irq=%d "
>  			"io=0x%x", irq[i], io[i] );
>  		if (init_airo_card( irq[i], io[i], 0, NULL ))
> -#if 0
> -			have_isa_dev = 1;
> -#else
>  			/* do nothing */ ;
> -#endif

Why not just remove the if?

>  	}
>  
>  #ifdef CONFIG_PCI

