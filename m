Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:47433 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYKRB5A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 20:57:00 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1226969241.4014.24.camel@johannes.berg>
References: <1226969241.4014.24.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 09:57:53 +0800
Message-Id: <1226973473.2548.97.camel@debian.sh.intel.com> (sfid-20081118_025715_600082_E039A7BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-18 at 08:47 +0800, Johannes Berg wrote:
> [patch below, sorry for the long list of CCs]
> 
> So I dug deeper into the DMA problems I had with iwlagn and a kind soul
> helped me in that he said something about pci-e alignment and mentioned
> the iwl_rx_allocate function to check for crossing 4KB boundaries. Since
> there's 8KB A-MPDU support, crossing 4k boundaries didn't seem like
> something the device would fail with, but when I looked into the
> function for a minute anyway I stumbled over this little gem:
> 
> 	BUG_ON(rxb->dma_addr & (~DMA_BIT_MASK(36) & 0xff));

OK, it should be (~DMA_BIT_MASK(36) | 0xff). My bad.

> Clearly, that is a totally bogus check, one would hope the compiler
> removes it entirely. (Think about it)

Sure.

> After fixing it, I obviously ran into it, nothing guarantees the
> alignment the way you want it,  because of the way skbs and their
> headroom are allocated. I won't explain that here nor double-check that
> I'm right, that goes beyond what most of the CC'ed people care about.

We do suspect the 256 alignment requirement will be an issue. Thus we do
let people can reproduce this problem check with it. See comment #21,
#22, #23 in bug
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1703. The
result is people still see this problem even the DMA address is 256
bytes aligned.

> So then I came up with the patch below, and so far my system has
> survived minutes with 64K pages, when it would previously fail in
> seconds. And I haven't seen a single instance of the TX bug either. But
> when you see the patch it'll be pretty obvious to you why.

Good. Your patch is generally correct. At least, it helps to enforce our
alignment requirement. But whether it can resolve the problem (I really
hope so) or not, let's wait and see.

> This should fix the following reported kernel bugs:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11596
> http://bugzilla.kernel.org/show_bug.cgi?id=11393
> http://bugzilla.kernel.org/show_bug.cgi?id=11983
> 
> I haven't checked if there are any elsewhere, but I suppose RHBZ will
> have a few instances too...
> 
> I'd like to ask anyone who is CC'ed (those are people I know ran into
> the bug) to try this patch.
> 
> I am convinced that this patch is correct in spirit, but I haven't
> understood why, for example, there are so many unmap calls. I'm not
> entirely convinced that this is the only bug leading to the TX reply
> errors.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

[...]

> @@ -302,7 +305,7 @@ void iwl_rx_queue_free(struct iwl_priv *
>  	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
>  		if (rxq->pool[i].skb != NULL) {
>  			pci_unmap_single(priv->pci_dev,
> -					 rxq->pool[i].dma_addr,
> +					 rxq->pool[i].real_dma_addr,
>  					 priv->hw_params.rx_buf_size,

priv->hw_params.rx_buf_size + 256.

>  					 PCI_DMA_FROMDEVICE);
>  			dev_kfree_skb(rxq->pool[i].skb);
> @@ -370,7 +373,7 @@ void iwl_rx_queue_reset(struct iwl_priv 
>  		 * to an SKB, so we need to unmap and free potential storage */
>  		if (rxq->pool[i].skb != NULL) {
>  			pci_unmap_single(priv->pci_dev,
> -					 rxq->pool[i].dma_addr,
> +					 rxq->pool[i].real_dma_addr,
>  					 priv->hw_params.rx_buf_size,
>  					 PCI_DMA_FROMDEVICE);
>  			priv->alloc_rxb_skb--;

ditto.

Thanks,
-yi

