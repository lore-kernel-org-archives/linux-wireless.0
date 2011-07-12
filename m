Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([89.167.52.164]:37496 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab1GLUxS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 16:53:18 -0400
Date: Tue, 12 Jul 2011 22:53:16 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Felix Fietkau <nbd@openwrt.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@venema.h4ckr.net,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] [PATCH v2 07/46] net/wireless: ath9k: fix DMA
 API usage
Message-ID: <20110712205316.GA13503@rere.qmqm.pl> (sfid-20110712_225330_149198_1123686B)
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl>
 <280ad9176e6532f231e054b38b952b20580874c5.1310339688.git.mirq-linux@rere.qmqm.pl>
 <4E1BCF36.2010506@openwrt.org>
 <20110712193204.GB13413@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20110712193204.GB13413@linux-mips.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2011 at 08:32:04PM +0100, Ralf Baechle wrote:
> On Tue, Jul 12, 2011 at 12:36:06PM +0800, Felix Fietkau wrote:
> 
> > >diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> > >index 70dc8ec..c5f46d5 100644
> > >--- a/drivers/net/wireless/ath/ath9k/recv.c
> > >+++ b/drivers/net/wireless/ath/ath9k/recv.c
> > >@@ -684,15 +684,11 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
> > >  	BUG_ON(!bf);
> > >
> > >  	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
> > >-				common->rx_bufsize, DMA_FROM_DEVICE);
> > >+				common->rx_bufsize, DMA_BIDIRECTIONAL);
> > >
> > >  	ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
> > >-	if (ret == -EINPROGRESS) {
> > >-		/*let device gain the buffer again*/
> > >-		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
> > >-				common->rx_bufsize, DMA_FROM_DEVICE);
> > >+	if (ret == -EINPROGRESS)
> > >  		return false;
> > >-	}
> > >
> > >  	__skb_unlink(skb,&rx_edma->rx_fifo);
> > >  	if (ret == -EINVAL) {
> > I have strong doubts about this change. On most MIPS devices,
> > dma_sync_single_for_cpu is a no-op, whereas
> > dma_sync_single_for_device flushes the cache range. With this
> > change, the CPU could cache the DMA status part behind skb->data and
> > that cache entry would not be flushed inbetween calls to this
> > functions on the same buffer, likely leading to rx stalls.
> 
> The code was already broken before.  By the time dma_sync_single_for_cpu
> and ath9k_hw_process_rxdesc_edma are called, the DMA engine may still be
> active in the buffer,  yet the driver is looking at it.
> 
> dma_sync_single_for_cpu() is part of changing the buffer ownership from
> the device to the CPU.  When it is being called, DMA into the buffer should
> already have been completed ...  or else the shit may hit the jet engine.

Let's get rid of the "buffer ownership" misunderstanding from the picture.
Ownership is about who is expected to be writing (or is assured the data
is not being changed under his foot). This has nothing to do with DMA API.

DMA API is there for two purposes: to make part of memory visible to
both CPU and device (map/unmap) and to ensure memory consistency in
presence of caches (sync; implicitly done in map/unmap).

In the case we're analysing, the ownership is on the device's side
until it stops writing the buffer. sync_to_cpu doesn't change that.
It only allows the CPU to see more recent data (in case the CPU cached
something earlier).

> Imagine what would happen on a hypothetic cache architecture which does not
> have a dirty bit, that is which would have to write back every cache line -
> even clean lines - to memory in order to evict it.  Corruption.

dma_map_whatever() would mark the memory uncachable on such an architecture.
Otherwise this would violate assumptions on DMA_FROM_DEVICE mappings (or
"device owned buffers") that the CPU does not write to the mapped memory.

Best Regards,
Micha³ Miros³aw
