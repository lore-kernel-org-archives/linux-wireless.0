Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from void.printf.net ([89.145.121.20]:48128 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab0INT1m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 15:27:42 -0400
Date: Tue, 14 Sep 2010 20:27:38 +0100
From: Chris Ball <cjb@laptop.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Subject: Re: [PATCH v1 7/8] sdio: enable Runtime PM for SDIO functions
Message-ID: <20100914192738.GB21918@void.printf.net>
References: <1283858949-11073-1-git-send-email-ohad@wizery.com> <1283858949-11073-8-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283858949-11073-8-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On Tue, Sep 07, 2010 at 02:29:08PM +0300, Ohad Ben-Cohen wrote:
> @@ -152,6 +173,11 @@ static int sdio_bus_remove(struct device *dev)
>  		sdio_release_host(func);
>  	}
>  
> +	pm_runtime_put_noidle(dev);
> +
> +	/* Undo the runtime PM settings in sdio_bus_probe() */
> +	pm_runtime_put_noidle(dev);
> +
>  	return 0;
>  }
>  

Nit:  This makes sense in context, but stands out as a possible paste
accident on first sight.  :)  I think it's worth adding a comment to
the first call; something like: 

> +     /* First, undo the increment made directly above */
> +     pm_runtime_put_noidle(dev);
> +     
> +     /* Then undo the runtime PM settings in sdio_bus_probe() */
> +     pm_runtime_put_noidle(dev);
> +     

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
