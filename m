Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41012 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3ICToQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 15:44:16 -0400
Message-ID: <52263BF0.9000906@infradead.org> (sfid-20130903_214419_674440_7A926B99)
Date: Tue, 03 Sep 2013 12:43:44 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] brcmfmac: fix bus interface selection in Kconfig
References: <1378212369-17166-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1378212369-17166-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/03/13 05:46, Arend van Spriel wrote:
> The kernel configuration for the driver could result in
> compilation issues as reported by Randy Dunlap. His results
> are show below:
> 
> "on x86_64:
> 
> when
> CONFIG_MMC=m
> CONFIG_BRCMUTIL=y
> CONFIG_BRCMFMAC=y
> CONFIG_BRCMFMAC_SDIO=y
> 
> This bool kconfig symbol:
> 
> config BRCMFMAC_SDIO
> 	bool "SDIO bus interface support for FullMAC driver"
> 	depends on MMC
> 
> allows BRCMFMAC_SDIO to be y even when MMC=m.
> 
> Is there a reasonable solution to this?
> 
> This causes many build errors:
> 
> drivers/built-in.o: In function `brcmf_sdio_assert_info':
> dhd_sdio.c:(.text+0x39609b): undefined reference to `sdio_claim_host'
> dhd_sdio.c:(.text+0x3960d9): undefined reference to `sdio_release_host'
> drivers/built-in.o: In function `brcmf_sdio_readframes':
> dhd_sdio.c:(.text+0x396a62): undefined reference to `sdio_claim_host'
> dhd_sdio.c:(.text+0x396a9b): undefined reference to `sdio_release_host'
> ..."
> 
> This patch adds the appropriate logic in Kconfig to resolve
> these issues. The solution was provided by Hauke Mehrtens.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
> Hi John,
> 
> Probably the merge window has already been started after the surpirse release
> of 3.11, but this one was reported by Randy Dunlap on linux-next tree and
> earlier today by Fenguang Wu. Maybe good to take it in the wireless-next tree.
> 
> Regards,
> Arend
> ---
>  drivers/net/wireless/brcm80211/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
> index fc8a0fa..b00a7e9 100644
> --- a/drivers/net/wireless/brcm80211/Kconfig
> +++ b/drivers/net/wireless/brcm80211/Kconfig
> @@ -28,7 +28,7 @@ config BRCMFMAC
>  
>  config BRCMFMAC_SDIO
>  	bool "SDIO bus interface support for FullMAC driver"
> -	depends on MMC
> +	depends on (MMC = y || MMC = BRCMFMAC)
>  	depends on BRCMFMAC
>  	select FW_LOADER
>  	default y
> @@ -39,7 +39,7 @@ config BRCMFMAC_SDIO
>  
>  config BRCMFMAC_USB
>  	bool "USB bus interface support for FullMAC driver"
> -	depends on USB
> +	depends on (USB = y || USB = BRCMFMAC)
>  	depends on BRCMFMAC
>  	select FW_LOADER
>  	---help---
> 


-- 
~Randy
