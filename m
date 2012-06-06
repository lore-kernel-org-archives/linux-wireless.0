Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4089 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab2FFLKY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:10:24 -0400
Message-ID: <4FCF3A88.8080105@broadcom.com> (sfid-20120606_131028_301909_20E95DFA)
Date: Wed, 6 Jun 2012 13:10:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/18] brcmsmac: fix DMA on SoCs
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-16-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-16-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> --- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
> @@ -633,11 +634,14 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
>  	 */
>  	di->ddoffsetlow = 0;
>  	di->dataoffsetlow = 0;
> -	/* add offset for pcie with DMA64 bus */
> -	di->ddoffsetlow = 0;
> -	di->ddoffsethigh = SI_PCIE_DMA_H32;

> -	di->dataoffsetlow = di->ddoffsetlow;
> -	di->dataoffsethigh = di->ddoffsethigh;

The two statements above can move after the if statement below.

> +	/* for pci bus, add offset */
> +	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) {
> +		/* add offset for pcie with DMA64 bus */
> +		di->ddoffsetlow = 0;
> +		di->ddoffsethigh = SI_PCIE_DMA_H32;
> +	}
> +	di->dataoffsetlow = di->ddoffsetlow;
> +	di->dataoffsethigh = di->ddoffsethigh;
> +
>  	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
>  	if ((core->id.id == BCMA_CORE_SDIO_DEV)
>  	    && ((rev > 0) && (rev <= 2)))


