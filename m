Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33786 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705AbZJMITq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 04:19:46 -0400
Subject: Re: [PATCH V3] iwlwifi: use paged Rx
From: Zhu Yi <yi.zhu@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20091012142002.GA2687@dhcp-lab-161.englab.brq.redhat.com>
References: <1255079985-17282-1-git-send-email-yi.zhu@intel.com>
	 <20091012142002.GA2687@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 16:19:08 +0800
Message-Id: <1255421948.3719.363.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-12 at 22:20 +0800, Stanislaw Gruszka wrote:
> On Fri, Oct 09, 2009 at 05:19:45PM +0800, Zhu Yi wrote:
> > This switches the iwlwifi driver to use paged skb from linear skb for Rx
> > buffer. So that it relieves some Rx buffer allocation pressure for the
> > memory subsystem. Currently iwlwifi (4K for 3945) requests 8K bytes for
> > Rx buffer. Due to the trailing skb_shared_info in the skb->data,
> > alloc_skb() will do the next order allocation, which is 16K bytes. This
> > is suboptimal and more likely to fail when the system is under memory
> > usage pressure. Switching to paged Rx skb lets us allocate the RXB
> > directly by alloc_pages(), so that only order 1 allocation is required.
> 
> [snip]
> 
> > Finally, mac80211 doesn't support paged Rx yet. So we linearize the skb
> > for all the management frames and software decryption or defragmentation
> > required data frames before handed to mac80211. For all the other frames,
> > we __pskb_pull_tail 64 bytes in the linear area of the skb for mac80211
> > to handle them properly.
> 
> This seems to be big overhead, but since there is no way to avoid it ...

Which case? The linear one is the same as the current implementation.
For __pskb_pull_tail, it is guaranteed no new buffer will be allocated.

> If we know that we need to linearize we can alloc as big skb as needed,
> otherwise skb_linearize() need to do reallocation.

OK.

> Can we also remove IWL_LINK_HDR_MAX and do __pskb_pull_tail based on 
> real header(s) size ? 

The wireless header is a variant depending on type. And mac80211 also
needs to play with LLC and IP header (for qos). So I used the max
possible frame buffer (128 or probably 64 is enough?) mac80211 is going
to use for none software decryption and defragmentation data frames.

> Or.
> 
> If we decide to do alloc_skb(IWL_LINK_HDR_MAX, gfp_flags) can this be 
> done together with skb_add_rx_frag() in iwl_rx_allocate(), to offload
> this interrupt context ?

I'm not sure if it's a big gain. This is only a 128 bytes GFP_ATOMIC
allocation anyway. Other driver like niu also does this.

> > +	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)
> 
> Minor optimization:
> 	    hdr->seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)

The original code returns the fragment index. The change makes it
optimized on LE arches. But is less readable.

> >  struct iwl_rx_mem_buffer {
> > -	dma_addr_t real_dma_addr;
> > -	dma_addr_t aligned_dma_addr;
> > -	struct sk_buff *skb;
> > +	dma_addr_t page_dma;
> > +	struct page *page;
> >  	struct list_head list;
> >  };
> >  
> > +#define rxb_addr(r) page_address(r->page)
> 
> Since we mostly use pointer, perhaps better would be save address of page
> in iwl_rx_mem_buffer, and use virt_to_page where struct page is needed.

Both should be fine. But I'd like to access the virtual address of
rxb->page with a micro like rxb_addr than something like "pkt =
rxb->virt_page" directly.

> >  			    net_ratelimit())
> > -				IWL_CRIT(priv, "Failed to allocate SKB buffer with %s. Only %u free buffers remaining.\n",
> > +				IWL_CRIT(priv, "Failed to alloc_pages with %s. Only %u free buffers remaining.\n",
> >  					 priority == GFP_ATOMIC ?  "GFP_ATOMIC" : "GFP_KERNEL",
> 
> priority can not be equal GFP_ATOMIC if was or'ed with __GFP_COMP or __GFP_NOWARN

Good catch. The bug also exists in the original code. Will send out a
separated patch to fix.

Thanks,
-yi

