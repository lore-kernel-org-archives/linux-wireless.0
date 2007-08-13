Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58483
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758210AbXHMADV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2007 20:03:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH][SSB] Fix a warning in PCI core driver
Date: Mon, 13 Aug 2007 02:02:27 +0200
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070812235058.GA4966@hall.aurel32.net>
In-Reply-To: <20070812235058.GA4966@hall.aurel32.net>
MIME-Version: 1.0
Message-Id: <200708130202.28030.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 August 2007 01:50:58 Aurelien Jarno wrote:
> The patch below fixes a warning spotted a few days ago by Andrew Morton
> while releasing 2.6.23-rc2-mm1.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> 
> --- a/drivers/ssb/driver_pcicore.c
> +++ b/drivers/ssb/driver_pcicore.c
> @@ -278,7 +278,7 @@
>  static struct resource ssb_pcicore_mem_resource = {
>  	.name	= "SSB PCIcore external memory",
>  	.start	= SSB_PCI_DMA,
> -	.end	= SSB_PCI_DMA + SSB_PCI_DMA_SZ - 1,
> +	.end	= (u32)SSB_PCI_DMA + (u32)SSB_PCI_DMA_SZ - 1,
>  	.flags	= IORESOURCE_MEM,
>  };
>  
> 

These casts were intentionally removed by me.
I think they are bogus and I have no idea why this
generates this strange compiler warning (I think it
was some overflow warning?).

-- 
Greetings Michael.
