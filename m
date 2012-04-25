Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57023 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab2DYItG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 04:49:06 -0400
Received: by bkuw12 with SMTP id w12so1162963bku.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 01:49:04 -0700 (PDT)
Message-ID: <4F97BA1A.6050600@openwrt.org> (sfid-20120425_104914_968556_F20139C4)
Date: Wed, 25 Apr 2012 10:47:22 +0200
From: Florian Fainelli <florian@openwrt.org>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	hauke@hauke-m.de
Subject: Re: [PATCH 3/6] bcma: Account for variable PCI memory base/size
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com> <BLU0-SMTP82FF4247B6804576EBAE9AAC270@phx.gbl>
In-Reply-To: <BLU0-SMTP82FF4247B6804576EBAE9AAC270@phx.gbl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nathan,

Le 04/25/12 08:15, Nathan Hintz a écrit :
> ---
>   drivers/bcma/driver_pci_host.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index d2097a1..3578e1a 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -491,8 +491,9 @@ void __devinit bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
>   	/* Ok, ready to run, register it to the system.
>   	 * The following needs change, if we want to port hostmode
>   	 * to non-MIPS platform. */
> -	io_map_base = (unsigned long)ioremap_nocache(BCMA_SOC_PCI_MEM,
> -						     0x04000000);
> +	io_map_base = (unsigned long)ioremap_nocache(pc_host->mem_resource.start,
> +						     pc_host->mem_resource.end -
> +						     pc_host->mem_resource.start + 1);

Please use resource_size(pc_host->mem_resource) instead of open-coding 
the size computation here.

>   	pc_host->pci_controller.io_map_base = io_map_base;
>   	set_io_port_base(pc_host->pci_controller.io_map_base);
>   	/* Give some time to the PCI controller to configure itself with the new
