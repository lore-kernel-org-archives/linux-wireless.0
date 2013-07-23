Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37721 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab3GWH0Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 03:26:24 -0400
Message-ID: <51EE3018.4000507@hauke-m.de> (sfid-20130723_092627_336232_48B79847)
Date: Tue, 23 Jul 2013 09:26:16 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] Make BCMA_HOST_SOC depend on BCM47XX
References: <1374546675-384-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1374546675-384-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/23/2013 04:31 AM, John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> 
> Otherwise, 'make allyesconfig' generates this:
> 
>   CC [M]  drivers/net/ethernet/broadcom/bgmac.o
> drivers/net/ethernet/broadcom/bgmac.c:19:27: fatal error:
> bcm47xx_nvram.h: No such file or directory
> compilation terminated.
> make[4]: *** [drivers/net/ethernet/broadcom/bgmac.o] Error 1
> make[3]: *** [drivers/net/ethernet/broadcom] Error 2
> make[2]: *** [drivers/net/ethernet] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/bcma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 7c081b3..a2bdab1 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -36,7 +36,7 @@ config BCMA_DRIVER_PCI_HOSTMODE
>  
>  config BCMA_HOST_SOC
>  	bool "Support for BCMA in a SoC"
> -	depends on BCMA
> +	depends on BCMA && BCM47XX
>  	help
>  	  Host interface for a Broadcom AIX bus directly mapped into
>  	  the memory. This only works with the Broadcom SoCs from the
> 
I think bgmac should depend on BCM47XX.

Hauke
