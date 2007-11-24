Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44782
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbXKXUci (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 15:32:38 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH 4/5] b43: reinit on too many PHY TX errors
Date: Sat, 24 Nov 2007 21:31:27 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20071124201107.785472828@polimi.it> <20071124201107.785472828@polimi.it>> <20071124201301.178475691@polimi.it>>
In-Reply-To: <20071124201301.178475691@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711242131.27870.mb@bu3sch.de> (sfid-20071124_203244_010700_5B020118)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 24 November 2007 21:11:11 Stefano Brivio wrote:
> Restart the hardware on too many PHY TX errors. A thousand PHY TX errors
> per 15 seconds means we won't be able to recover for sure.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> To: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> Index: wireless-2.6/drivers/net/wireless/b43/b43.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/b43.h
> +++ wireless-2.6/drivers/net/wireless/b43/b43.h
> @@ -391,6 +391,8 @@ enum {
>  #define B43_DEFAULT_SHORT_RETRY_LIMIT	7
>  #define B43_DEFAULT_LONG_RETRY_LIMIT	4
>  
> +#define B43_PHY_TX_BADNESS_LIMIT	1000
> +
>  /* Max size of a security key */
>  #define B43_SEC_KEYSIZE			16
>  /* Security algorithms. */
> @@ -546,6 +548,9 @@ struct b43_phy {
>  	/* OFDM address read/write caching for hardware auto-increment. */
>  	u16 ofdm_addr;
>  	u8 ofdm_valid; /* 0: invalid, 1: read, 2: write */
> +
> +	/* PHY TX errors counter. */
> +	u16 txerr_cnt;
>  };
>  
>  /* Data structures for DMA transmission, per 80211 core. */
> Index: wireless-2.6/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/main.c
> +++ wireless-2.6/drivers/net/wireless/b43/main.c
> @@ -1394,8 +1394,17 @@ static void b43_interrupt_tasklet(struct
>  	if (unlikely(reason & B43_IRQ_MAC_TXERR))
>  		b43err(dev->wl, "MAC transmission error\n");
>  
> -	if (unlikely(reason & B43_IRQ_PHY_TXERR))
> +	if (unlikely(reason & B43_IRQ_PHY_TXERR)) {
>  		b43err(dev->wl, "PHY transmission error\n");
> +		if (dev->phy.txerr_cnt < B43_PHY_TX_BADNESS_LIMIT)
> +			dev->phy.txerr_cnt++;
> +		else {
> +			dev->phy.txerr_cnt = 0;
> +			b43err(dev->wl, "Too many PHY TX errors, "
> +					"restarting the controller\n");
> +			b43_controller_restart(dev, "PHY TX errors");
> +		}
> +	}
>  
>  	if (unlikely(merged_dma_reason & (B43_DMAIRQ_FATALMASK |
>  					  B43_DMAIRQ_NONFATALMASK))) {
> @@ -2259,6 +2268,9 @@ static int b43_chip_init(struct b43_wlde
>  	/* OFDM address caching. */
>  	phy->ofdm_valid = 0;
>  
> +	/* PHY TX errors counter. */
> +	phy->txerr_cnt = 0;
> +
>  	err = 0;
>  	b43dbg(dev->wl, "Chip initialized\n");
>  out:


> @@ -2344,6 +2356,8 @@ static void b43_periodic_every15sec(stru
>  	}
>  	b43_phy_xmitpower(dev);	//FIXME: unless scanning?
>  	//TODO for APHY (temperature?)
> +
> +	phy->txerr_cnt = 0;

Needs either atomic_t plus memory barriers or spin_lock(&wl->irq_lock).
I'd suggest atomic_t with mb()s as it's a bad idea to completely sync with
IRQs on every 15sec pwork for this error counter.

-- 
Greetings Michael.
