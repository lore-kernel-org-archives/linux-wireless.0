Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:35710 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZGYMq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 08:46:59 -0400
Subject: Re: [patch] wireless: ERR_PTR vs null
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Carpenter <error27@gmail.com>
Cc: samuel.ortiz@intel.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0907241000250.11771@bicker>
References: <alpine.DEB.2.00.0907241000250.11771@bicker>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 14:46:05 +0200
Message-Id: <1248525965.28545.158.camel@violet>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> iwm_wdev_alloc() returns an ERR_PTR on failure and not null.  It also 
> prints its own dev_err() message so I removed that as well.
> 
> Compile tested only.  Sorry.  
> Found by smatch (http://repo.or.cz/w/smatch.git).
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> --- orig/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-07-24 09:56:49.000000000 +0300
> +++ devel/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-07-24 09:57:31.000000000 +0300
> @@ -106,10 +106,8 @@
>  	int ret = 0;
>  
>  	wdev = iwm_wdev_alloc(sizeof_bus, dev);
> -	if (!wdev) {
> -		dev_err(dev, "no memory for wireless device instance\n");
> -		return ERR_PTR(-ENOMEM);
> -	}
> +	if (IS_ERR(wdev))
> +		return wdev;
>  
>  	iwm = wdev_to_iwm(wdev);
>  	iwm->bus_ops = if_ops;

I just quickly double-checked with the code. Patch looks good.

Regards

Marcel


