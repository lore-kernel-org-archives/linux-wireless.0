Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu004-omc1s14.hotmail.com ([65.55.116.25]:55412 "EHLO
	BLU004-OMC1S14.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933401AbbCDHeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 02:34:06 -0500
Message-ID: <BLU436-SMTP37961E670B2BEAB516F79CB91E0@phx.gbl> (sfid-20150304_083428_707352_62FF6EB9)
Date: Wed, 4 Mar 2015 15:41:55 +0800
From: Chen Gang <xili_gchen_5257@hotmail.com>
MIME-Version: 1.0
To: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcma: Kconfig: Let it depend on PCI
References: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
In-Reply-To: <BLU436-SMTP3656F4A0610686DAE30BA1B9110@phx.gbl>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Sorry for my carelessness, I deleted the original reply mail to me (may
also deleted another mails to me, too).

The hotmail is not stable, I am just struggling with it (it can not work
well with linux-kernel@vger.kernel.org).

Could you forward your original reply to me again?

Thanks.

On 3/4/15 05:16, Chen Gang wrote:
> bcma also needs PCI, just like IOMEM and DMA, so let it depend on PCI,
> or will cause building break for allmodconfig under c6x:
> 
>     CC [M]  drivers/bcma/driver_pcie2.o
>   drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
>   drivers/bcma/driver_pcie2.c:196:8: error: implicit declaration of function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>     err = pcie_set_readrq(dev, pcie2->reqsize);
>           ^
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/bcma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 0ee48be..8be284e 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -1,6 +1,6 @@
>  config BCMA_POSSIBLE
>  	bool
> -	depends on HAS_IOMEM && HAS_DMA
> +	depends on HAS_IOMEM && HAS_DMA && PCI
>  	default y
>  
>  menu "Broadcom specific AMBA"
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
