Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50051 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbaIQPPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 11:15:12 -0400
Date: Wed, 17 Sep 2014 11:11:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Loic Poulain <loic.poulain@intel.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: rfkill: gpio: Fix clock status
Message-ID: <20140917151142.GA13392@tuxdriver.com> (sfid-20140917_171520_252605_D4325991)
References: <1410872038-4604-1-git-send-email-loic.poulain@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1410872038-4604-1-git-send-email-loic.poulain@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2014 at 02:53:58PM +0200, Loic Poulain wrote:
> Clock is disabled when the device is blocked.
> So, clock_enabled is the logical negation of "blocked".
> 
> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
> ---
>  net/rfkill/rfkill-gpio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 14c98e4..408e51f 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -54,7 +54,7 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
>  	if (blocked && !IS_ERR(rfkill->clk) && rfkill->clk_enabled)
>  		clk_disable(rfkill->clk);
>  
> -	rfkill->clk_enabled = blocked;
> +	rfkill->clk_enabled = !blocked;
>  
>  	return 0;
>  }

This looks like the right fix, but...the code has been that way for
a long time.  If this patch is correct, how has this gone undetected
for so long?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
