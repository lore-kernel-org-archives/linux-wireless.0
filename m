Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41692 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZJ1TQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 15:16:18 -0400
Date: Wed, 28 Oct 2009 15:11:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tiziano =?iso-8859-1?Q?M=FCller?= <tm@dev-zero.ch>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] rtl8180: change PCI DMA mask to DMA_BIT_MASK(32) to
	solve "No suitable DMA available" problems on sparc64.
Message-ID: <20091028191114.GB2856@tuxdriver.com>
References: <1252575463.30576.59.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1252575463.30576.59.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can I get a "Signed-off-by:" line from you for this?

Thanks,

John

On Thu, Sep 10, 2009 at 11:37:43AM +0200, Tiziano Müller wrote:
> Hi there
> 
> I had problems to get my rtl8185 PCI card running on Sparc64: I always
> got an error about "No suitable DMA available" followed by an error
> that no device could be detected. When comparing the rtl8180 driver to
> others I noticed that others are mostly using DMA_BIT_MASK so I changed
> the custom mask to DMA_BIT_MASK(32) which fixed my issue.
> 
> Cheers,
> Tiziano
> 
> ---
>  drivers/net/wireless/rtl818x/rtl8180_dev.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> index 16429c4..515f562 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> @@ -850,8 +850,8 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
>  		goto err_free_reg;
>  	}
>  
> -	if ((err = pci_set_dma_mask(pdev, 0xFFFFFF00ULL)) ||
> -	    (err = pci_set_consistent_dma_mask(pdev, 0xFFFFFF00ULL))) {
> +	if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) ||
> +	    (err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))) {
>  		printk(KERN_ERR "%s (rtl8180): No suitable DMA available\n",
>  		       pci_name(pdev));
>  		goto err_free_reg;
> -- 
> 1.6.4
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
