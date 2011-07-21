Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42870 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1GUTRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 15:17:13 -0400
Date: Thu, 21 Jul 2011 15:06:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH V2] b43: disable parity check on BCMA devices
Message-ID: <20110721190648.GC2468@tuxdriver.com> (sfid-20110721_211720_847125_46A01118)
References: <1311184027-3497-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1311184027-3497-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 20, 2011 at 07:47:07PM +0200, Rafał Miłecki wrote:
> Analyze of MMIO dumps from BCM43224, BCM43225, BCM4313 and BCM4331 has
> shown that wl disables parity check for all that cards. This is required
> for receiving any packets from the hardware.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: drop dependency on other patches, can be applied right away

> @@ -1069,6 +1078,11 @@ int b43_dma_init(struct b43_wldev *dev)
>  #endif
>  	}
>  
> +	dma->parity = true;
> +	/* TODO: find out which SSB devices need disabling parity */
> +	if (dev->dev->bus_type == B43_BUS_BCMA)
> +		dma->parity = false;
> +
>  	err = -ENOMEM;
>  	/* setup TX DMA channels. */
>  	dma->tx_ring_AC_BK = b43_setup_dmaring(dev, 0, 1, type);

drivers/net/wireless/b43/dma.c: In function ‘b43_dma_init’:
drivers/net/wireless/b43/dma.c:1083:28: error: ‘B43_BUS_BCMA’ undeclared (first use in this function)
drivers/net/wireless/b43/dma.c:1083:28: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [drivers/net/wireless/b43/dma.o] Error 1
make[1]: *** [drivers/net/wireless/b43] Error 2
make: *** [drivers/net/wireless/] Error 2

I fixed it up with a change like this:

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 2e072f6..0953ce1 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1079,9 +1079,11 @@ int b43_dma_init(struct b43_wldev *dev)
 	}
 
 	dma->parity = true;
+#ifdef CONFIG_B43_BCMA
 	/* TODO: find out which SSB devices need disabling parity */
 	if (dev->dev->bus_type == B43_BUS_BCMA)
 		dma->parity = false;
+#endif
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */

Please do be careful...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
