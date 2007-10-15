Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:16703 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbXJOP2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 11:28:51 -0400
Message-ID: <471386D6.9030301@oracle.com> (sfid-20071015_162854_697454_6B88D7E1)
Date: Mon, 15 Oct 2007 08:27:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch #2] ssb: fix build failure
References: <200710151723.21423.mb@bu3sch.de>
In-Reply-To: <200710151723.21423.mb@bu3sch.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix build failure if PCMCIA=m but SSB=y:
> 
> drivers/built-in.o: In function `ssb_pcmcia_switch_coreidx':
> : undefined reference to `pcmcia_access_configuration_register'
> 
> (fix symmetric bug for PCI too.)
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com> [choose a patch ;]

> ---
>  drivers/ssb/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/drivers/ssb/Kconfig
> ===================================================================
> --- linux.orig/drivers/ssb/Kconfig
> +++ linux/drivers/ssb/Kconfig
> @@ -22,7 +22,7 @@ config SSB
>  
>  config SSB_PCIHOST_POSSIBLE
>  	bool
> -	depends on SSB && PCI
> +	depends on SSB && (PCI = y || PCI = SSB)
>  	default y
>  
>  config SSB_PCIHOST
> @@ -37,7 +37,7 @@ config SSB_PCIHOST
>  
>  config SSB_PCMCIAHOST_POSSIBLE
>  	bool
> -	depends on SSB && PCMCIA && EXPERIMENTAL
> +	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
>  	default y
>  
>  config SSB_PCMCIAHOST
> 
> 
> 
> -------------------------------------------------------
> 


-- 
~Randy
