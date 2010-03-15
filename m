Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:65110 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965673Ab0COTI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 15:08:28 -0400
Message-ID: <4B9E85AA.1030803@gmail.com>
Date: Mon, 15 Mar 2010 20:08:26 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] rt2x00: fix warning when building rt2800pci with just
 soc support
References: <201003151722.26406.helmut.schaa@googlemail.com>
In-Reply-To: <201003151722.26406.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/10 17:22, Helmut Schaa wrote:
> Fix compile warning "rt2800pci.c:1248: warning: 'rt2800pci_device_table'
> defined but not used" when building rt2800pci with only soc support
> (without pci).
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> Nothing important, had the patch in my tree and just noticed that I didn't
> send it out yet.
> 
>  drivers/net/wireless/rt2x00/rt2800pci.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 10fafd0..0104906 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -1184,6 +1184,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
>  /*
>   * RT2800pci module information.
>   */
> +#ifdef CONFIG_RT2800PCI_PCI
>  static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>  	{ PCI_DEVICE(0x1814, 0x0601), PCI_DEVICE_DATA(&rt2800pci_ops) },
>  	{ PCI_DEVICE(0x1814, 0x0681), PCI_DEVICE_DATA(&rt2800pci_ops) },
> @@ -1211,6 +1212,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
>  #endif
>  	{ 0, }
>  };
> +#endif /* CONFIG_RT2800PCI_PCI */
>  
>  MODULE_AUTHOR(DRV_PROJECT);
>  MODULE_VERSION(DRV_VERSION);

