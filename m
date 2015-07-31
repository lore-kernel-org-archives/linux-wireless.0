Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbbGaUvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 16:51:24 -0400
Date: Fri, 31 Jul 2015 13:51:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 24/28] staging: wilc1000: fix cast from pointer to
 integer warning
Message-ID: <20150731205123.GD1650@kroah.com> (sfid-20150731_225130_290075_95E08246)
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
 <1438328316-30197-25-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438328316-30197-25-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 04:38:32PM +0900, Tony Cho wrote:
> From: glen lee <glen.lee@atmel.com>
> 
> To use a pointer as as integer in arithmetic operation, cast type to uintptr_t
> as the data type.
> This patch changes casting (unsigned int) with (uintptr_t) to do arithmetic operation
> 
> Here is build warning.
> drivers/staging/wilc1000/linux_wlan.c:2385:20: warning: cast from pointer to
> integer of different size [-Wpointer-to-int-cast]
>    skb_reserve(skb, (unsigned int)skb->data & 0x3);
> 
> Signed-off-by: glen lee <glen.lee@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 5dcb30c..ec80849 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -2382,7 +2382,7 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
>  			return;
>  		}
>  
> -		skb_reserve(skb, (unsigned int)skb->data & 0x3);
> +		skb_reserve(skb, (uintptr_t)skb->data & 0x3);

Why is a cast needed at all here?

And again, don't use uintptr_t, it is not a kernel type.

I've stopped reviewing here, sorry, please fix up the series and resend.

thanks,

greg k-h
