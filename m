Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:4960 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755208Ab2C0SNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 14:13:12 -0400
Message-ID: <4F720336.1030308@gmail.com> (sfid-20120327_201314_784801_F6C3C7A6)
Date: Tue, 27 Mar 2012 20:13:10 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Jakub Kicinski <kubakici@wp.pl>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 4/4] rt2x00: zero registers of unused TX rings
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl> <1332859867-27921-5-git-send-email-kubakici@wp.pl>
In-Reply-To: <1332859867-27921-5-git-send-email-kubakici@wp.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/27/12 16:51, Jakub Kicinski wrote:
> This is needed if we take over after drivers which use those.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800pci.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index f39587b..1d24124 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -394,6 +394,16 @@ static int rt2800pci_init_queues(struct rt2x00_dev *rt2x00dev)
>  	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX3, 0);
>  	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX3, 0);
>  
> +	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR4, 0);
> +	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT4, 0);
> +	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX4, 0);
> +	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX4, 0);
> +
> +	rt2x00pci_register_write(rt2x00dev, TX_BASE_PTR5, 0);
> +	rt2x00pci_register_write(rt2x00dev, TX_MAX_CNT5, 0);
> +	rt2x00pci_register_write(rt2x00dev, TX_CTX_IDX5, 0);
> +	rt2x00pci_register_write(rt2x00dev, TX_DTX_IDX5, 0);
> +
>  	entry_priv = rt2x00dev->rx->entries[0].priv_data;
>  	rt2x00pci_register_write(rt2x00dev, RX_BASE_PTR, entry_priv->desc_dma);
>  	rt2x00pci_register_write(rt2x00dev, RX_MAX_CNT,


-- 
---
Gertjan
