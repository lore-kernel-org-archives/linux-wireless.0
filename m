Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:61190 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955Ab0COQfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 12:35:52 -0400
Received: by ewy8 with SMTP id 8so1160136ewy.28
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 09:35:50 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH] rt2x00: fix warning when building rt2800pci with just soc support
Date: Mon, 15 Mar 2010 17:35:46 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201003151722.26406.helmut.schaa@googlemail.com>
In-Reply-To: <201003151722.26406.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003151735.46646.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 15 March 2010, Helmut Schaa wrote:
> Fix compile warning "rt2800pci.c:1248: warning: 'rt2800pci_device_table'
> defined but not used" when building rt2800pci with only soc support
> (without pci).
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

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


