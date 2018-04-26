Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:38350 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbeDZIOw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 04:14:52 -0400
Date: Thu, 26 Apr 2018 11:14:48 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] net: rfkill: gpio: fix memory leak in probe error path
Message-ID: <20180426081448.GB17550@kuha.fi.intel.com> (sfid-20180426_101525_628405_900B7ABA)
References: <20180426073152.7953-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180426073152.7953-1-johan@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 26, 2018 at 09:31:52AM +0200, Johan Hovold wrote:
> Make sure to free the rfkill device in case registration fails during
> probe.
> 
> Fixes: 5e7ca3937fbe ("net: rfkill: gpio: convert to resource managed allocation")
> Cc: stable <stable@vger.kernel.org>	# 3.13
> Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>

Good catch. FWIW:

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  net/rfkill/rfkill-gpio.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 41bd496531d4..00192a996be0 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -137,13 +137,18 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
>  
>  	ret = rfkill_register(rfkill->rfkill_dev);
>  	if (ret < 0)
> -		return ret;
> +		goto err_destroy;
>  
>  	platform_set_drvdata(pdev, rfkill);
>  
>  	dev_info(&pdev->dev, "%s device registered.\n", rfkill->name);
>  
>  	return 0;
> +
> +err_destroy:
> +	rfkill_destroy(rfkill->rfkill_dev);
> +
> +	return ret;
>  }
>  
>  static int rfkill_gpio_remove(struct platform_device *pdev)
> -- 
> 2.17.0

-- 
heikki
