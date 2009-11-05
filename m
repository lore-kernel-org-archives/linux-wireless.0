Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:26762 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409AbZKESk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 13:40:59 -0500
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 02/41] rt2800pci: make Kconfig help entry more helpful
Date: Thu, 5 Nov 2009 19:41:00 +0100
Cc: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173210.28463.95558.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173210.28463.95558.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911051941.01166.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: make Kconfig help entry more helpful
> 
> Document known issues with the driver to aid distribution makers,
> users and developers in making informed decisions instead of wasting
> their time needlessly.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Making it depend on CONFIG_BROKEN makes more sense if the comment
is "non-functional".

Ivo

> ---
> This reflects the actual state of affairs for driver in net-next tree.
> 
>  drivers/net/wireless/rt2x00/Kconfig |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/net/wireless/rt2x00/Kconfig
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -64,7 +64,7 @@ config RT2800PCI_SOC
>  	default y
>  
>  config RT2800PCI
> -	tristate "Ralink rt2800 (PCI/PCMCIA) support"
> +	tristate "Ralink rt2800 (PCI/PCMCIA) support (VERY EXPERIMENTAL)"
>  	depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL
>  	select RT2X00_LIB_PCI if RT2800PCI_PCI
>  	select RT2X00_LIB_SOC if RT2800PCI_SOC
> @@ -77,6 +77,9 @@ config RT2800PCI
>  	  This adds support for rt2800 wireless chipset family.
>  	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890 & RT3052
>  
> +	  This driver is non-functional at the moment and is intended for
> +	  developers.
> +
>  	  When compiled as a module, this driver will be called "rt2800pci.ko".
>  
>  config RT2500USB
> 


