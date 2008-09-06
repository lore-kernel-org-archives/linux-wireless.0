Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46396 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbYIFT75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 15:59:57 -0400
Message-ID: <48C2E13B.9020203@lwfinger.net> (sfid-20080906_220010_232966_4A0F92CA)
Date: Sat, 06 Sep 2008 14:59:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net>	 <200809062055.51797.mb@bu3sch.de> <1220727470.10102.9.camel@johannes.berg>	 <200809062104.15274.mb@bu3sch.de>  <48C2DBCB.1030706@lwfinger.net> <1220730115.10102.15.camel@johannes.berg>
In-Reply-To: <1220730115.10102.15.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> The mechanism depends on the card revision, but according to
> drivers/net/wireless/b43legacy/dma.c it's always via the dma/pio
> mechanism for legacy cards:
> 
>         if (dev->dev->id.revision < 5) {
>                 ring = b43legacy_setup_dmaring(dev, 3, 0, type);
>                 if (!ring)
>                         goto err_destroy_rx0;
>                 dma->rx_ring3 = ring;
>         }

In the V3 specs, I found

"Transmit Status

When this interrupt is set, the retrieve the TransmitStatus. Note that 
on cores with revision < 5, the last DMA controller or PIO queue can 
also also get the DMA recieve done interrupt, which also triggers the 
TransmitStatus retrieval process. The driver should be prepared to 
deal with both interrupts at any time, on any revision. In AP mode, 
this interrupt also initiates the sending of powersave responses."

The implication is that the interrupt will only be generated if we use 
the last (i.e. #5) DMA controller. As we are only using #3, no 
interrupts and handle_irq_status() is dead code.

Larry
