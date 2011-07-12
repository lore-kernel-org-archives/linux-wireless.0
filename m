Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h5.dl5rb.org.uk ([81.2.74.5]:56098 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754215Ab1GLTc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 15:32:26 -0400
Date: Tue, 12 Jul 2011 20:32:04 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@venema.h4ckr.net,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] [PATCH v2 07/46] net/wireless: ath9k: fix DMA API
 usage
Message-ID: <20110712193204.GB13413@linux-mips.org> (sfid-20110712_213231_227158_47C3CD21)
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl>
 <280ad9176e6532f231e054b38b952b20580874c5.1310339688.git.mirq-linux@rere.qmqm.pl>
 <4E1BCF36.2010506@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4E1BCF36.2010506@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 12, 2011 at 12:36:06PM +0800, Felix Fietkau wrote:

> >diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> >index 70dc8ec..c5f46d5 100644
> >--- a/drivers/net/wireless/ath/ath9k/recv.c
> >+++ b/drivers/net/wireless/ath/ath9k/recv.c
> >@@ -684,15 +684,11 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
> >  	BUG_ON(!bf);
> >
> >  	dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
> >-				common->rx_bufsize, DMA_FROM_DEVICE);
> >+				common->rx_bufsize, DMA_BIDIRECTIONAL);
> >
> >  	ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
> >-	if (ret == -EINPROGRESS) {
> >-		/*let device gain the buffer again*/
> >-		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
> >-				common->rx_bufsize, DMA_FROM_DEVICE);
> >+	if (ret == -EINPROGRESS)
> >  		return false;
> >-	}
> >
> >  	__skb_unlink(skb,&rx_edma->rx_fifo);
> >  	if (ret == -EINVAL) {
> I have strong doubts about this change. On most MIPS devices,
> dma_sync_single_for_cpu is a no-op, whereas
> dma_sync_single_for_device flushes the cache range. With this
> change, the CPU could cache the DMA status part behind skb->data and
> that cache entry would not be flushed inbetween calls to this
> functions on the same buffer, likely leading to rx stalls.

The code was already broken before.  By the time dma_sync_single_for_cpu
and ath9k_hw_process_rxdesc_edma are called, the DMA engine may still be
active in the buffer,  yet the driver is looking at it.

dma_sync_single_for_cpu() is part of changing the buffer ownership from
the device to the CPU.  When it is being called, DMA into the buffer should
already have been completed ...  or else the shit may hit the jet engine.

Imagine what would happen on a hypothetic cache architecture which does not
have a dirty bit, that is which would have to write back every cache line -
even clean lines - to memory in order to evict it.  Corruption.

And don't argue with what the actual MIPS implementation of dma_sync_single_-
for-{cpu,device} is doing.  It's meant to bee treated as a black box; that
abstraction is the whole point of the ABI.  And it seems the driver is also
being used on other architectures than MIPS …

  Ralf
