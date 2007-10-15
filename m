Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:49489 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbXJOPJT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 11:09:19 -0400
Date: Mon, 15 Oct 2007 08:06:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] ssb: fix build failure
Message-Id: <20071015080646.d77f5dfb.randy.dunlap@oracle.com> (sfid-20071015_160922_371569_ECFD8477)
In-Reply-To: <200710151623.04881.mb@bu3sch.de>
References: <200710151623.04881.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 15 Oct 2007 16:23:04 +0200 Michael Buesch wrote:

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
> +	depends on SSB && (PCI = SSB)
>  	default y
>  
>  config SSB_PCIHOST
> @@ -37,7 +37,7 @@ config SSB_PCIHOST
>  
>  config SSB_PCMCIAHOST_POSSIBLE
>  	bool
> -	depends on SSB && PCMCIA && EXPERIMENTAL
> +	depends on SSB && (PCMCIA = SSB) && EXPERIMENTAL
>  	default y
>  
>  config SSB_PCMCIAHOST

That's usually done more like this:

	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL

This allows PCMCIA to be y or m, but if PCMCIA is m, then
SSB is restricted to m as well (or n).
I.e., PCMCIA = SSB is too strict and not required.

or am I not seeing straight?

---
~Randy
