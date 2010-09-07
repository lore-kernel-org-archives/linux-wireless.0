Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:58369 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab0IGND2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 09:03:28 -0400
Message-ID: <4C8637D2.5070703@csr.com>
Date: Tue, 07 Sep 2010 14:02:10 +0100
From: David Vrabel <david.vrabel@csr.com>
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Subject: Re: [PATCH v1 8/8] wireless: wl1271_sdio: enable Runtime PM
References: <1283858949-11073-1-git-send-email-ohad@wizery.com> <1283858949-11073-9-git-send-email-ohad@wizery.com>
In-Reply-To: <1283858949-11073-9-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen wrote:
> Enable runtime pm for the wl1271 SDIO device.
> 
> We request power whenever the WLAN interface is brought up,
> and release it after the WLAN interface is taken down.
> 
> As a result, power is released immediately after probe returns,
> since at that point power has not been explicitly requested yet
> (i.e. the WLAN interface is still down).
[...]
> @@ -233,6 +241,8 @@ static int __devinit wl1271_probe(struct sdio_func *func,
>  
>  	sdio_set_drvdata(func, wl);
>  
> +	pm_runtime_put_noidle(&func->dev);

I find this a little odd and confusing as this is releasing the
reference taken by mmc core from inside the function driver.

Instead, I would suggest changing all existing SDIO function drivers to
call pm_runtime_get() in probe() and pm_runtime_put() in remove().  I
think this makes the runtime PM usage more obvious from a function
driver point of view.

> +
>  	wl1271_notice("initialized");
>  
>  	return 0;
> @@ -255,6 +265,8 @@ static void __devexit wl1271_remove(struct sdio_func *func)
>  
>  	wl1271_unregister_hw(wl);
>  	wl1271_free_hw(wl);
> +
> +	pm_runtime_get_noresume(&func->dev);
>  }
>  
>  static struct sdio_driver wl1271_sdio_driver = {

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
