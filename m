Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5883 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbZG0B1D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 21:27:03 -0400
Subject: Re: [patch] wireless: ERR_PTR vs null
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "Ortiz, Samuel" <samuel.ortiz@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0907241000250.11771@bicker>
References: <alpine.DEB.2.00.0907241000250.11771@bicker>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 09:26:59 +0800
Message-Id: <1248658019.3747.94.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-07-25 at 20:22 +0800, Dan Carpenter wrote:
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

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

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

