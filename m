Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:36539 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbZKHMjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 07:39:32 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so2345707ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 04:39:37 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Move interface type assignments to generic code.
Date: Sun, 8 Nov 2009 13:38:18 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257679814-25233-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257679814-25233-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911081338.19315.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009, Gertjan van Wingerde wrote:
> Make sure all drivers can benefit of the assignment of the interface type of an adapter, instead of
> keeping it for rt2800 only.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 --
>  drivers/net/wireless/rt2x00/rt2800usb.c |    2 --
>  drivers/net/wireless/rt2x00/rt2x00pci.c |    2 ++
>  drivers/net/wireless/rt2x00/rt2x00soc.c |    5 +++++
>  drivers/net/wireless/rt2x00/rt2x00usb.c |    2 ++
>  5 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 3c5b875..bff8707 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1465,8 +1465,6 @@ static int rt2800pci_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
>  	int retval;
>  
> -	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
> -
>  	rt2x00dev->priv = (void *)&rt2800pci_rt2800_ops;
>  
>  	/*
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index ce2e893..3168ad4 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -1074,8 +1074,6 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
>  {
>  	int retval;
>  
> -	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
> -
>  	rt2x00dev->priv = (void *)&rt2800usb_rt2800_ops;
>  
>  	/*
> diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
> index cdd5154..ece70d7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
> @@ -310,6 +310,8 @@ int rt2x00pci_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
>  	rt2x00dev->irq = pci_dev->irq;
>  	rt2x00dev->name = pci_name(pci_dev);
>  
> +	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
> +
>  	/*
>  	 * Determine RT chipset by reading PCI header.
>  	 */
> diff --git a/drivers/net/wireless/rt2x00/rt2x00soc.c b/drivers/net/wireless/rt2x00/rt2x00soc.c
> index 539568c..4abcfa6 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00soc.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00soc.c
> @@ -93,6 +93,11 @@ int rt2x00soc_probe(struct platform_device *pdev,
>  	rt2x00dev->irq = platform_get_irq(pdev, 0);
>  	rt2x00dev->name = pdev->dev.driver->name;
>  
> +	/*
> +	 * SoC devices mimic PCI behavior.
> +	 */
> +	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_PCI);
> +
>  	rt2x00_set_chip_rt(rt2x00dev, chipset);
>  
>  	retval = rt2x00soc_alloc_reg(rt2x00dev);
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index c9cbdaa..aa6c31d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -653,6 +653,8 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
>  	rt2x00dev->ops = ops;
>  	rt2x00dev->hw = hw;
>  
> +	rt2x00_set_chip_intf(rt2x00dev, RT2X00_CHIP_INTF_USB);
> +
>  	retval = rt2x00usb_alloc_reg(rt2x00dev);
>  	if (retval)
>  		goto exit_free_device;


