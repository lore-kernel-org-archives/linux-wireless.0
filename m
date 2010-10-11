Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:33641 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab0JMNBu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 09:01:50 -0400
Subject: Re: [PATCH 2/4] wl1271: Fix TX starvation
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286786936-20544-3-git-send-email-ido@wizery.com>
References: <1286786936-20544-1-git-send-email-ido@wizery.com>
	 <1286786936-20544-3-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 12:56:58 +0300
Message-ID: <1286791018.11177.484.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 10:48 +0200, ext Ido Yariv wrote:
> While wl1271_irq_work handles RX directly (by calling wl1271_rx), a different
> work is queued for transmitting packets. The IRQ work might handle more than
> one interrupt during a single call, including multiple TX completion
> interrupts. This might starve TX, since no packets are transmitted until all
> interrupts are handled.
> 
> Fix this by calling the TX work function directly, instead of deferring
> it.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/wl1271_main.c |   19 +++++++++++++------
>  drivers/net/wireless/wl12xx/wl1271_tx.c   |   12 ++++++++----
>  drivers/net/wireless/wl12xx/wl1271_tx.h   |    1 +
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 

*snip*


> @@ -537,6 +533,17 @@ static void wl1271_irq_work(struct work_struct *work)
>  			    (wl->tx_results_count & 0xff))
>  				wl1271_tx_complete(wl);
>  
> +			/* Check if any tx blocks were freed */
> +			if ((wl->tx_blocks_available > prev_tx_blocks) &&
> +					!skb_queue_empty(&wl->tx_queue)) {
> +				/*
> +				 * In order to avoid starvation of the TX path,
> +				 * call the work function directly.
> +				 */
> +				cancel_work_sync(&wl->tx_work);

Hmm, isn't this causing a theoretical potential for a dead-lock? The
tx_work could be waiting in mutex-lock already when cancel_work_sync is
called, in which case cancel_work_sync would lock forever.

IIRC the irq_work and tx_work currently run in the same queue, so this
may work with the current driver. Smells like a hazard anyway, and
changing the workqueues for each work could easily lead to dead locks
here. So at minimum I'd like to see it documented in the comment why
this cannot cause a deadlock.

> +				wl1271_tx_work_locked(wl);
> +			}
> +
>  			wl1271_rx(wl, wl->fw_status);
>  		}
>  
> diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
> index 63bc52c..90a8909 100644



