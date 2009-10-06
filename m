Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59942 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbZJFUw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 16:52:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Albert Herranz <albert_herranz@yahoo.es>
Subject: Re: [PATCH] b43: do not stack-allocate pio rx/tx header buffers
Date: Tue, 6 Oct 2009 22:52:15 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <1254846043-7121-1-git-send-email-albert_herranz@yahoo.es>
In-Reply-To: <1254846043-7121-1-git-send-email-albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910062252.17565.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 October 2009 18:20:43 Albert Herranz wrote:
> The DMA-API debugging facility complains about b43 mapping memory from
> stack for SDIO-based cards, as can be seen in the following two
> stack traces.
> 
>   Call Trace:
>   [d2ef7c60] [c01c55f0] check_for_stack+0xf4/0x10c (unreliable)
>   [d2ef7c80] [c01c6d10] debug_dma_map_sg+0xc4/0x134
>   [d2ef7cb0] [c0281e10] sdhci_prepare_data+0x200/0x590
>   [d2ef7ce0] [c0282288] sdhci_send_command+0xe8/0x320
>   [d2ef7d00] [c02825e0] sdhci_request+0x120/0x1b4
>   [d2ef7d20] [c0277ad4] mmc_wait_for_req+0x124/0x140
>   [d2ef7d50] [c027c2f0] mmc_io_rw_extended+0x188/0x214
>   [d2ef7e10] [c027d7c4] sdio_io_rw_ext_helper+0x104/0x224
>   [d2ef7e40] [c0296000] ssb_sdio_block_read+0xac/0x110
>   [d2ef7e60] [c0237f98] pio_rx_frame+0x1d0/0x43c
>   [d2ef7eb0] [c0238244] b43_pio_rx+0x40/0x90
>   [d2ef7ed0] [c0226124] b43_do_interrupt_thread+0x108/0x444
>   [d2ef7f30] [c0226504] b43_sdio_interrupt_handler+0x58/0x74
>   [d2ef7f40] [c0239110] b43_sdio_interrupt_dispatcher+0x4c/0x68
>   [d2ef7f60] [c027e1ac] sdio_irq_thread+0xf8/0x284
>   [d2ef7fb0] [c0054538] kthread+0x78/0x7c
>   [d2ef7ff0] [c00124ec] kernel_thread+0x4c/0x68
> 
>   Call Trace:
>   [d3335c20] [c01c55f0] check_for_stack+0xf4/0x10c (unreliable)
>   [d3335c40] [c01c6d10] debug_dma_map_sg+0xc4/0x134
>   [d3335c70] [c0281e14] sdhci_prepare_data+0x200/0x590
>   [d3335ca0] [c028228c] sdhci_send_command+0xe8/0x320
>   [d3335cc0] [c02825e4] sdhci_request+0x120/0x1b4
>   [d3335ce0] [c0277ad8] mmc_wait_for_req+0x124/0x140
>   [d3335d10] [c027c2f4] mmc_io_rw_extended+0x188/0x214
>   [d3335dd0] [c027d86c] sdio_io_rw_ext_helper+0x1a8/0x224
>   [d3335e00] [c0295ef4] ssb_sdio_block_write+0xac/0x110
>   [d3335e20] [c0237a18] tx_write_4byte_queue+0x6c/0x138
>   [d3335e40] [c0238610] pio_tx_frame+0x1c4/0x224
>   [d3335ee0] [c0238718] b43_pio_tx+0xa8/0x1f4
>   [d3335f00] [c0220380] b43_tx_work+0x4c/0xe0
>   [d3335f20] [c004fa74] run_workqueue+0x120/0x1a4
>   [d3335f70] [c004fb44] worker_thread+0x4c/0xb0
>   [d3335fb0] [c0054538] kthread+0x78/0x7c
>   [d3335ff0] [c00124ec] kernel_thread+0x4c/0x68
> 
> Indeed, b43 currently allocates the PIO RX and TX header buffers
> from stack. The solution here is to use heap-allocated buffers instead.
> 
> Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
> ---
>  drivers/net/wireless/b43/b43.h |    9 ++++++++
>  drivers/net/wireless/b43/pio.c |   42 +++++++++++++++++++++++++++------------
>  2 files changed, 38 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index fa1549a..b09dda1 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -550,6 +550,9 @@ struct b43_dma {
>  struct b43_pio_txqueue;
>  struct b43_pio_rxqueue;
>  
> +struct b43_rxhdr_fw4;
> +struct b43_txhdr;
> +
>  /* Data structures for PIO transmission, per 80211 core. */
>  struct b43_pio {
>  	struct b43_pio_txqueue *tx_queue_AC_BK; /* Background */
> @@ -559,6 +562,12 @@ struct b43_pio {
>  	struct b43_pio_txqueue *tx_queue_mcast; /* Multicast */
>  
>  	struct b43_pio_rxqueue *rx_queue;
> +
> +	/*
> +	 * RX/TX header buffers used by the frame transmit functions.
> +	 */
> +	struct b43_rxhdr_fw4 *rxhdr;
> +	struct b43_txhdr *txhdr;
>  };

Just embed it into struct b43_wl (surround it by #ifdef CONFIG_B43_PIO). No need
to kzalloc then and it saves some memory.
You also need to alloc 4 bytes for the tail buffer (that currently is on the stack, too).

-- 
Greetings, Michael.
