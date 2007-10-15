Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:62315 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbXJOPQ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 11:16:58 -0400
Message-ID: <471383BD.1030704@oracle.com> (sfid-20071015_161702_396866_420A400B)
Date: Mon, 15 Oct 2007 08:14:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [patch] ssb: fix build failure
References: <200710151623.04881.mb@bu3sch.de> <20071015080646.d77f5dfb.randy.dunlap@oracle.com> <20071015151054.GB8343@elte.hu>
In-Reply-To: <20071015151054.GB8343@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> That's usually done more like this:
>>
>> 	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
>>
>> This allows PCMCIA to be y or m, but if PCMCIA is m, then SSB is 
>> restricted to m as well (or n). I.e., PCMCIA = SSB is too strict and 
>> not required.
> 
> indeed - updated patch below.
> 
> 	Ingo

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ------------------>
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
> 
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


-- 
~Randy
