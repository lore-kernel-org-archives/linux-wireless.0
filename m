Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:51354 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531Ab1HKJRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 05:17:43 -0400
Received: by mail-bw0-f51.google.com with SMTP id r19so835187bka.38
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 02:17:42 -0700 (PDT)
Subject: Re: [PATCH 33/40] wl12xx: track freed packets in FW by AC
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-34-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-34-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 12:17:38 +0300
Message-ID: <1313054258.2407.820.camel@cumari> (sfid-20110811_111747_775224_8C940074)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> From: Arik Nemtsov <arik@wizery.com>
> 
> Track the number of freed packets in each AC when receiving an interrupt
> from the FW. This paves the way for tracking allocated packets per AC.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/main.c   |   16 +++++++++++++++-
>  drivers/net/wireless/wl12xx/tx.c     |    2 ++
>  drivers/net/wireless/wl12xx/wl12xx.h |    8 ++++++--
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index b223c27..3bfd772 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -810,22 +810,32 @@ static void wl1271_irq_update_links_status(struct wl1271 *wl,
>  static void wl1271_fw_status(struct wl1271 *wl,
>  			     struct wl1271_fw_status *status)
>  {
>  	struct timespec ts;
>  	u32 old_tx_blk_count = wl->tx_blocks_available;
>  	int avail, freed_blocks;
> +	int i;
>  
>  	wl1271_raw_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
>  
>  	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
>  		     "drv_rx_counter = %d, tx_results_counter = %d)",
>  		     status->intr,
>  		     status->fw_rx_counter,
>  		     status->drv_rx_counter,
>  		     status->tx_results_counter);
>  
> +	for (i = 0; i < NUM_TX_QUEUES; i++) {
> +		/* prevent wrap-around in freed-packets counter */
> +		wl->tx_allocated_pkts -=
> +				(status->tx_released_pkts[i] -
> +				wl->tx_pkts_freed[i] + 256) % 256;

Isn't the "+ 256" useless here, since you'll mod the result anyway? 


-- 
Cheers,
Luca.

