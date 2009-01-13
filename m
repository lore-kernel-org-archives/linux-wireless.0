Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:54267 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZAMPgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 10:36:41 -0500
Received: from [172.20.25.81]([172.20.25.81]) (7542 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1LMlIa-0002VDC@megami.veritas.com>
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2009 07:35:24 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
Date: Tue, 13 Jan 2009 15:35:29 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
To: Bob Copeland <me@bobcopeland.com>
cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>, maximlevitsky@gmail.com
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
In-Reply-To: <20090110201547.GA11261@hash.localnet>
Message-ID: <Pine.LNX.4.64.0901131509080.9571@blonde.anvils> (sfid-20090113_163647_384991_61BED939)
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
 <1231426017.922.2.camel@maxim-laptop> <Pine.LNX.4.64.0901081603410.8411@blonde.anvils>
 <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com>
 <Pine.LNX.4.64.0901081740350.19523@blonde.anvils>
 <b6c5339f0901081041p3c9669f8ycd461b155da60f94@mail.gmail.com>
 <b6c5339f0901090541m1ac135bcta91bacb3f048a9ba@mail.gmail.com>
 <Pine.LNX.4.64.0901091400290.925@blonde.anvils> <20090110164705.GB10865@hash.localnet>
 <20090110201547.GA11261@hash.localnet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 10 Jan 2009, Bob Copeland wrote:
> On Sat, Jan 10, 2009 at 11:47:05AM -0500, Bob Copeland wrote:
> > Well I got a lockup doing that, I'll try again later but anyway I see
> > the bug already, read on if interested.  I should have a patch shortly.
> 
> Err, of course I would get a lockup, it's a BUG_ON.  This patch seems to
> fix it for me.  
> 
> From: Bob Copeland <me@bobcopeland.com>
> Date: Sat, 10 Jan 2009 14:42:54 -0500
> Subject: [PATCH] ath5k: fix bf->skb==NULL panic in ath5k_tasklet_rx
> 
> Under memory pressure, we may not be able to allocate a new skb for
> new packets.  If the allocation fails, ath5k_tasklet_rx will exit but
> will leave a buffer in the list with a NULL skb, eventually triggering
> a BUG_ON.
> 
> Extract the skb allocation from ath5k_rxbuf_setup() and change the
> tasklet to allocate the next skb before accepting a packet.

Thanks a lot, Bob, this looks like it should work.

But I haven't seen any allocation failure for several days.
I didn't get any while trying to simplify the reproduction,
and so once your patch arrived I switched back to trying my
original load with your patch applied.

That's so far had three runs (one on 2.6.28, two on 2.6.29-rc1) of
about 16 hours each, without even hitting the origin of the problem.
I did say originally that it would take a week or two to confirm,
so I'll just keep on trying.

I guess we can see from the nature of your patch that it has to
fix it; but it still would be nice to see such an allocation
failure logged, and the system and its wireless continuing okay.

> 
> Changes-licensed-under: 3-Clause-BSD

Hmm, I haven't noticed anyone doing that before: hope you're not
starting a trend!  I think you'll find (Documentation/SubmittingPatches)
that your Signed-off-by agrees to the Developer's Certificate of Origin
1.1, which would put your patch under the same open source licence(s) as
drivers/net/wireless/ath5k/base.c already contains - that's the usual
case.

But IANAL, and I may be missing an important nuance you'd hoped to convey:
that "(unless I am permitted to submit under a different licence)" clause?

Hugh

> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   85 +++++++++++++++++++++++--------------
>  1 files changed, 53 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 2b7b7f6..1c0061a 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1095,6 +1095,42 @@ ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
>  * Buffers setup *
>  \***************/
>  
> +static
> +struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
> +{
> +	struct sk_buff *skb;
> +	unsigned int off;
> +
> +	/*
> +	 * Allocate buffer with headroom_needed space for the
> +	 * fake physical layer header at the start.
> +	 */
> +	skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);
> +
> +	if (!skb) {
> +		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
> +				sc->rxbufsize + sc->cachelsz - 1);
> +		return NULL;
> +	}
> +	/*
> +	 * Cache-line-align.  This is important (for the
> +	 * 5210 at least) as not doing so causes bogus data
> +	 * in rx'd frames.
> +	 */
> +	off = ((unsigned long)skb->data) % sc->cachelsz;
> +	if (off != 0)
> +		skb_reserve(skb, sc->cachelsz - off);
> +
> +	*skb_addr = pci_map_single(sc->pdev,
> +		skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
> +	if (unlikely(pci_dma_mapping_error(sc->pdev, *skb_addr))) {
> +		ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
> +		dev_kfree_skb(skb);
> +		return NULL;
> +	}
> +	return skb;
> +}
> +
>  static int
>  ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>  {
> @@ -1102,37 +1138,11 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>  	struct sk_buff *skb = bf->skb;
>  	struct ath5k_desc *ds;
>  
> -	if (likely(skb == NULL)) {
> -		unsigned int off;
> -
> -		/*
> -		 * Allocate buffer with headroom_needed space for the
> -		 * fake physical layer header at the start.
> -		 */
> -		skb = dev_alloc_skb(sc->rxbufsize + sc->cachelsz - 1);
> -		if (unlikely(skb == NULL)) {
> -			ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
> -					sc->rxbufsize + sc->cachelsz - 1);
> +	if (!skb) {
> +		skb = ath5k_rx_skb_alloc(sc, &bf->skbaddr);
> +		if (!skb)
>  			return -ENOMEM;
> -		}
> -		/*
> -		 * Cache-line-align.  This is important (for the
> -		 * 5210 at least) as not doing so causes bogus data
> -		 * in rx'd frames.
> -		 */
> -		off = ((unsigned long)skb->data) % sc->cachelsz;
> -		if (off != 0)
> -			skb_reserve(skb, sc->cachelsz - off);
> -
>  		bf->skb = skb;
> -		bf->skbaddr = pci_map_single(sc->pdev,
> -			skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
> -		if (unlikely(pci_dma_mapping_error(sc->pdev, bf->skbaddr))) {
> -			ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
> -			dev_kfree_skb(skb);
> -			bf->skb = NULL;
> -			return -ENOMEM;
> -		}
>  	}
>  
>  	/*
> @@ -1661,7 +1671,8 @@ ath5k_tasklet_rx(unsigned long data)
>  {
>  	struct ieee80211_rx_status rxs = {};
>  	struct ath5k_rx_status rs = {};
> -	struct sk_buff *skb;
> +	struct sk_buff *skb, *next_skb;
> +	dma_addr_t next_skb_addr;
>  	struct ath5k_softc *sc = (void *)data;
>  	struct ath5k_buf *bf, *bf_last;
>  	struct ath5k_desc *ds;
> @@ -1746,10 +1757,17 @@ ath5k_tasklet_rx(unsigned long data)
>  				goto next;
>  		}
>  accept:
> +		next_skb = ath5k_rx_skb_alloc(sc, &next_skb_addr);
> +
> +		/*
> +		 * If we can't replace bf->skb with a new skb under memory
> +		 * pressure, just skip this packet
> +		 */
> +		if (!next_skb)
> +			goto next;
> +
>  		pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
>  				PCI_DMA_FROMDEVICE);
> -		bf->skb = NULL;
> -
>  		skb_put(skb, rs.rs_datalen);
>  
>  		/* The MAC header is padded to have 32-bit boundary if the
> @@ -1822,6 +1840,9 @@ accept:
>  			ath5k_check_ibss_tsf(sc, skb, &rxs);
>  
>  		__ieee80211_rx(sc->hw, skb, &rxs);
> +
> +		bf->skb = next_skb;
> +		bf->skbaddr = next_skb_addr;
>  next:
>  		list_move_tail(&bf->list, &sc->rxbuf);
>  	} while (ath5k_rxbuf_setup(sc, bf) == 0);
> -- 
> 1.6.0.6
> 
> 
> -- 
> Bob Copeland %% www.bobcopeland.com
