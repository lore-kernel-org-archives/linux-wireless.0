Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59505 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZG2JAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 05:00:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Work around mac80211 race condition that may transmit one packet after queue is stopped
Date: Wed, 29 Jul 2009 11:00:05 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <4a6fa3fe.kYeW+HADItDIXTLm%Larry.Finger@lwfinger.net>
In-Reply-To: <4a6fa3fe.kYeW+HADItDIXTLm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907291100.06108.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 July 2009 03:21:02 Larry Finger wrote:
> As shown in http://thread.gmane.org/gmane.linux.kernel.wireless.general/36497,
> mac80211 has a bug that allows a call to the TX routine after the queues have
> been stopped. This situation will only occur under extreme stress. Although
> b43 does not crash when this condition occurs, it does generate a WARN_ON and
> also logs a queue overrun message. This patch recognizes b43 is not at fault
> and logs a message only when the most verbose debugging mode is enabled. In
> the unlikely event that the queue is not stopped when the DMA queue becomes
> full, then a warning is issued.
> 
> During testing of this patch with one output stream running repeated tcpperf
> writes and a second running a flood ping, this routine was entered with
> the DMA ring stopped about once per hour. The condition where the DMA queue is
> full but the ring has not been stopped has never been seen by me.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This patch is 2.6.32 material.

ack

> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/dma.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/dma.c
> +++ wireless-testing/drivers/net/wireless/b43/dma.c
> @@ -1334,13 +1334,23 @@ int b43_dma_tx(struct b43_wldev *dev, st
>  	spin_lock_irqsave(&ring->lock, flags);
>  
>  	B43_WARN_ON(!ring->tx);
> -	/* Check if the queue was stopped in mac80211,
> -	 * but we got called nevertheless.
> -	 * That would be a mac80211 bug. */
> -	B43_WARN_ON(ring->stopped);
> +
> +	if (unlikely(ring->stopped)) {
> +		/* We get here only because of a bug in mac80211.
> +		 * Because of a race, one packet may be queued after
> +		 * the queue is stopped, thus we got called when we shouldn't.
> +		 * For now, just refuse the transmit. */
> +		if (b43_debug(dev, B43_DBG_DMAVERBOSE))
> +			b43err(dev->wl, "Packet after queue stopped\n");
> +		err = -ENOSPC;
> +		goto out_unlock;
> +	}
>  
>  	if (unlikely(free_slots(ring) < TX_SLOTS_PER_FRAME)) {
> -		b43warn(dev->wl, "DMA queue overflow\n");
> +		/* If we get here, we have a real error with the queue
> +		 * full, but queues not stopped. */
> +		b43err(dev->wl, "DMA queue overflow\n");
> +		WARN_ON(1);
>  		err = -ENOSPC;
>  		goto out_unlock;
>  	}
> 
> 



-- 
Greetings, Michael.
