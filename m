Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35167 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbbIVMQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 08:16:11 -0400
Date: Tue, 22 Sep 2015 17:46:00 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, Johnny Kim <johnny.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tony Cho <tony.cho@atmel.com>, Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH] staging: wicl1000: fix dereference after free in
 wilc_wlan_cleanup()
Message-ID: <20150922121600.GA16336@sudip-pc> (sfid-20150922_141628_116085_9EFCCDFD)
References: <1442917490-26574-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442917490-26574-1-git-send-email-javier@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 22, 2015 at 12:24:50PM +0200, Javier Martinez Canillas wrote:
> The wilc_wlan_cleanup() function iterates over the list of transmission
> buffers freeing all of them and then iterates over the receive buffers
> list to free all of them as well.
> 
> But on the receive loop a pointer to struct txq_entry_t is dereferenced
> instead of the pointer to a struct rxq_entry_t. This not only causes a
> dereference to a pointer already freed but also leaks the memory in the
> struct rxq_entry_t buffer.
> 
> Fixes: c5c77ba18ea6 ("staging: wilc1000: Add SDIO/SPI 802.11 driver")
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
>  drivers/staging/wilc1000/wilc_wlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 4c25179c2fec..c40f143b00b7 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -1746,7 +1746,7 @@ static void wilc_wlan_cleanup(void)
>  		if (rqe == NULL)
>  			break;
>  #ifdef MEMORY_DYNAMIC
> -		kfree(tqe->buffer);
> +		kfree(rqe->buffer);
>  #endif
MEMORY_DYNAMIC is only used here and no where else. And buffer was
allocated in the else part of #ifdef MEMORY_STATIC.
So you should really be using #ifndef MEMORY_STATIC here instead of
#ifdef MEMORY_DYNAMIC otherwise memory leak will still remain.

regards
sudip
