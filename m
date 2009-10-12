Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744AbZJLOUt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 10:20:49 -0400
Date: Mon, 12 Oct 2009 16:20:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] iwlwifi: use paged Rx
Message-ID: <20091012142002.GA2687@dhcp-lab-161.englab.brq.redhat.com>
References: <1255079985-17282-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255079985-17282-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 09, 2009 at 05:19:45PM +0800, Zhu Yi wrote:
> This switches the iwlwifi driver to use paged skb from linear skb for Rx
> buffer. So that it relieves some Rx buffer allocation pressure for the
> memory subsystem. Currently iwlwifi (4K for 3945) requests 8K bytes for
> Rx buffer. Due to the trailing skb_shared_info in the skb->data,
> alloc_skb() will do the next order allocation, which is 16K bytes. This
> is suboptimal and more likely to fail when the system is under memory
> usage pressure. Switching to paged Rx skb lets us allocate the RXB
> directly by alloc_pages(), so that only order 1 allocation is required.

[snip]

> Finally, mac80211 doesn't support paged Rx yet. So we linearize the skb
> for all the management frames and software decryption or defragmentation
> required data frames before handed to mac80211. For all the other frames,
> we __pskb_pull_tail 64 bytes in the linear area of the skb for mac80211
> to handle them properly.

This seems to be big overhead, but since there is no way to avoid it ...

> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
> V2: fix 3945 problem and linearize skb for fragemented frames
> V3: fix a 3945 pci_unmap_page bug
> 
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |   67 ++++++++++-----
>  drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 +-
>  drivers/net/wireless/iwlwifi/iwl-agn.c      |   42 ++++-----
>  drivers/net/wireless/iwlwifi/iwl-commands.h |   10 ++
>  drivers/net/wireless/iwlwifi/iwl-core.c     |   13 ++--
>  drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-dev.h      |   27 ++++--
>  drivers/net/wireless/iwlwifi/iwl-hcmd.c     |   21 ++----
>  drivers/net/wireless/iwlwifi/iwl-rx.c       |  122 +++++++++++++++++----------
>  drivers/net/wireless/iwlwifi/iwl-scan.c     |   20 ++--
>  drivers/net/wireless/iwlwifi/iwl-spectrum.c |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-sta.c      |   62 +++++--------
>  drivers/net/wireless/iwlwifi/iwl-tx.c       |   10 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |  120 +++++++++++++-------------
>  15 files changed, 284 insertions(+), 240 deletions(-)

[snip]

> @@ -543,14 +543,17 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
>  				   struct iwl_rx_mem_buffer *rxb,
>  				   struct ieee80211_rx_status *stats)
>  {
> -	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
> +	struct iwl_rx_packet *pkt = rxb_addr(rxb);
>  	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IWL_RX_DATA(pkt);
>  	struct iwl3945_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
>  	struct iwl3945_rx_frame_end *rx_end = IWL_RX_END(pkt);
> -	short len = le16_to_cpu(rx_hdr->len);
> +	u16 len = le16_to_cpu(rx_hdr->len);
> +	struct sk_buff *skb;
> +	int ret;
>  
>  	/* We received data from the HW, so stop the watchdog */
> -	if (unlikely((len + IWL39_RX_FRAME_SIZE) > skb_tailroom(rxb->skb))) {
> +	if (unlikely(len + IWL39_RX_FRAME_SIZE >
> +		     PAGE_SIZE << priv->hw_params.rx_page_order)) {
>  		IWL_DEBUG_DROP(priv, "Corruption detected!\n");
>  		return;
>  	}
> @@ -562,20 +565,45 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
>  		return;
>  	}
>  
> -	skb_reserve(rxb->skb, (void *)rx_hdr->payload - (void *)pkt);
> -	/* Set the size of the skb to the size of the frame */
> -	skb_put(rxb->skb, le16_to_cpu(rx_hdr->len));
> +	skb = alloc_skb(IWL_LINK_HDR_MAX, GFP_ATOMIC);
> +	if (!skb) {
> +		IWL_ERR(priv, "alloc_skb failed\n");
> +		return;
> +	}

If we know that we need to linearize we can alloc as big skb as needed,
otherwise skb_linearize() need to do reallocation.

Can we also remove IWL_LINK_HDR_MAX and do __pskb_pull_tail based on 
real header(s) size ? 

Or.

If we decide to do alloc_skb(IWL_LINK_HDR_MAX, gfp_flags) can this be 
done together with skb_add_rx_frag() in iwl_rx_allocate(), to offload
this interrupt context ?

>  	if (!iwl3945_mod_params.sw_crypto)
>  		iwl_set_decrypted_flag(priv,
> -				       (struct ieee80211_hdr *)rxb->skb->data,
> +				       (struct ieee80211_hdr *)rxb_addr(rxb),
>  				       le32_to_cpu(rx_end->status), stats);
>  
> +	skb_add_rx_frag(skb, 0, rxb->page,
> +			(void *)rx_hdr->payload - (void *)pkt, len);
> +
> +	/* mac80211 currently doesn't support paged SKB. Convert it to
> +	 * linear SKB for management frame and data frame requires
> +	 * software decryption or software defragementation. */
> +	if (ieee80211_is_mgmt(hdr->frame_control) ||
> +	    ieee80211_has_protected(hdr->frame_control) ||
> +	    ieee80211_has_morefrags(hdr->frame_control) ||
> +	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)

Minor optimization:
	    hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)

> +		ret = skb_linearize(skb);
> +	else
> +		ret = __pskb_pull_tail(skb, min_t(u16, IWL_LINK_HDR_MAX, len)) ?
> +			0 : -ENOMEM;
> +
> +	if (ret) {
> +		kfree_skb(skb);
> +		goto out;
> +	}
> +
>  	iwl_update_stats(priv, false, hdr->frame_control, len);
>  
> -	memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
> -	ieee80211_rx_irqsafe(priv->hw, rxb->skb);
> -	rxb->skb = NULL;
> +	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
> +	ieee80211_rx(priv->hw, skb);
> +
> + out:
> +	priv->alloc_rxb_page--;
> +	rxb->page = NULL;
>  }

[snip] 

>  struct iwl_rx_mem_buffer {
> -	dma_addr_t real_dma_addr;
> -	dma_addr_t aligned_dma_addr;
> -	struct sk_buff *skb;
> +	dma_addr_t page_dma;
> +	struct page *page;
>  	struct list_head list;
>  };
>  
> +#define rxb_addr(r) page_address(r->page)

Since we mostly use pointer, perhaps better would be save address of page
in iwl_rx_mem_buffer, and use virt_to_page where struct page is needed.

[snip]
 
> @@ -252,29 +252,34 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
>  
>  		if (rxq->free_count > RX_LOW_WATERMARK)
>  			priority |= __GFP_NOWARN;
> -		/* Alloc a new receive buffer */
> -		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
> -						priority);
>  
> -		if (!skb) {
> +		if (priv->hw_params.rx_page_order > 0)
> +			priority |= __GFP_COMP;
> +
> +		/* Alloc a new receive buffer */
> +		page = alloc_pages(priority, priv->hw_params.rx_page_order);
> +		if (!page) {
>  			if (net_ratelimit())
> -				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
> +				IWL_DEBUG_INFO(priv, "alloc_pages failed, "
> +					       "order: %d\n",
> +					       priv->hw_params.rx_page_order);
> +
>  			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
>  			    net_ratelimit())
> -				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
> +				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
>  					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",

priority can not be equal GFP_ATOMIC if was or'ed with __GFP_COMP or __GFP_NOWARN

Cheers
Stanislaw

