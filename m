Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36539 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbZKHMjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:39:16 -0500
Received: by ewy3 with SMTP id 3so2345707ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:39:20 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Mark rt2800pci as broken.
Date: Sun, 8 Nov 2009 13:37:54 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <1257679734-25160-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257679734-25160-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081337.54610.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Gertjan van Wingerde wrote:
> The rt2800pci driver is currently only marked as experimental, and only the help text explains that
> the driver is basically non-functional. Make the driver depend on CONFIG_BROKEN so that users cannot
> enable this driver without knowing that it is broken.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/Kconfig |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index bf60689..b0f4a2f 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -64,8 +64,8 @@ config RT2800PCI_SOC
>  	default y
>  
>  config RT2800PCI
> -	tristate "Ralink rt2800 (PCI/PCMCIA) support (VERY EXPERIMENTAL)"
> -	depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL
> +	tristate "Ralink rt2800 (PCI/PCMCIA) support (BROKEN)"
> +	depends on (RT2800PCI_PCI || RT2800PCI_SOC) && EXPERIMENTAL && BROKEN
>  	select RT2800_LIB
>  	select RT2X00_LIB_PCI if RT2800PCI_PCI
>  	select RT2X00_LIB_SOC if RT2800PCI_SOC
> @@ -78,9 +78,6 @@ config RT2800PCI
>  	  This adds support for rt2800 wireless chipset family.
>  	  Supported chips: RT2760, RT2790, RT2860, RT2880, RT2890 & RT3052
>  
> -	  This driver is non-functional at the moment and is intended for
> -	  developers.
> -
>  	  When compiled as a module, this driver will be called "rt2800pci.ko".
>  
>  config RT2500USB


