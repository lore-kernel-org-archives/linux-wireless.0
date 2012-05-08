Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815Ab2EHOFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 10:05:53 -0400
Date: Tue, 8 May 2012 16:05:56 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 3.4] iwlwifi: fix a potential race in receive buffer
 allocation
Message-ID: <20120508140555.GA4412@redhat.com> (sfid-20120508_160605_486916_A718CD29)
References: <1336079364-16222-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336079364-16222-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 02:09:24PM -0700, Wey-Yi Guy wrote:
> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> 
> The driver can potentially unmap pages that
> have not been mapped yet. Fix this race
> condition.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> this patch will be also available from wireless branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi.git
> 
>  drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
> index aa7aea1..173275f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
> @@ -310,7 +310,6 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
>  		spin_unlock_irqrestore(&rxq->lock, flags);
>  
>  		BUG_ON(rxb->page);
> -		rxb->page = page;
>  		/* Get physical address of the RB */
>  		rxb->page_dma = dma_map_page(trans->dev, page, 0,
>  				PAGE_SIZE << hw_params(trans).rx_page_order,
> @@ -320,6 +319,9 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
>  		/* and also 256 byte aligned! */
>  		BUG_ON(rxb->page_dma & DMA_BIT_MASK(8));
>  
> +		/* Page *must* be mapped before before updating the rxb. */
> +		rxb->page = page;
> +
>  		spin_lock_irqsave(&rxq->lock, flags);
>  
>  		list_add_tail(&rxb->list, &rxq->rx_free);

This patch make no sense. Nothing stops compiler or CPU to write
->page into memory before ->page_dma .

Stanislaw
