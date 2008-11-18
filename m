Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f11.google.com ([209.85.217.11]:33672 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYKRXWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 18:22:47 -0500
Received: by gxk4 with SMTP id 4so2186097gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 18 Nov 2008 15:22:45 -0800 (PST)
Message-ID: <43e72e890811181520r362fd0f9w33d568935d10f732@mail.gmail.com> (sfid-20081119_002251_694020_EE2729FA)
Date: Tue, 18 Nov 2008 15:20:04 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
Cc: "John Linville" <linville@tuxdriver.com>,
	"Tomas Winkler" <tomasw@gmail.com>,
	"reinette chatre" <reinette.chatre@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Matt Mackall" <mpm@selenic.com>,
	"Christophe Dumez" <dchris@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	"=?UTF-8?Q?Jan_V=C4=8Del=C3=A1k?=" <vcelak.jan@seznam.cz>,
	"Thomas Witt" <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andres Freund" <andres@anarazel.de>
In-Reply-To: <1227005557.4014.47.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227005557.4014.47.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 18, 2008 at 2:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:

> @@ -265,11 +265,14 @@ void iwl_rx_allocate(struct iwl_priv *pr
>                list_del(element);
>
>                /* Get physical address of RB/SKB */
> -               rxb->dma_addr = pci_map_single(priv->pci_dev, rxb->skb->data,
> -                          priv->hw_params.rx_buf_size, PCI_DMA_FROMDEVICE);
> +               rxb->real_dma_addr = pci_map_single(priv->pci_dev, rxb->skb->data,
> +                          priv->hw_params.rx_buf_size + 256, PCI_DMA_FROMDEVICE);
>
> -               /* RBD must be 256 bytes aligned and no more than 36 bits */
> -               BUG_ON(rxb->dma_addr & (~DMA_BIT_MASK(36) & 0xff));
> +               /* dma address must be no more than 36 bits */
> +               BUG_ON(rxb->real_dma_addr & ~DMA_BIT_MASK(36));
> +               /* and also 256 byte aligned! */
> +               rxb->aligned_dma_addr = ALIGN(rxb->real_dma_addr, 256);

aligned_dma_addr can obviously be > real_dma_addr at this point, what
gaurantees we can use it on our own whim?

  Luis
